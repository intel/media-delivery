#
# Copyright (c) 2020 Intel Corporation
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

if [ -z "${MDS_IMAGE}" ]; then
  echo "error: no container specified (\${MDS_IMAGE})" >&2
  exit 1
fi

if ! which docker >/dev/null 2>&1; then
  echo "error: docker is not available in \${PATH}" >&2
  exit 1
fi

DEVICE=${DEVICE:-/dev/dri/renderD128}
if [ ! -e $DEVICE ]; then
  echo "error: no such device: $DEVICE" >&2
  exit 1
fi

if [ -z "${MDS_DEMO}" ]; then
  MDS_DEMO="cdn"
fi

if [ -z "${TIMEOUT}" ]; then
TIMEOUT=300
fi

CONTAINER_NAME=media-delivery-killme

ARTIFACTS="/opt/data/artifacts"

_TMP=`pwd`/mds_bats

function setup() {
  rm -rf $_TMP
  mkdir $_TMP
}

function teardown() {
  if [ -n "$BATS_ERROR_STATUS" -a "$BATS_ERROR_STATUS" -eq 1 -a -d "$MDS_LOGS" ]; then
    if find $_TMP -mindepth 1 | read; then
      logs=$MDS_LOGS/$BATS_TEST_NUMBER
      mkdir $logs
      cp -rd $_TMP/* $logs
    fi
  fi
  rm -rf $_TMP
}

##################
# helper functions
##################
function get_mounts() {
  local opts="$@"
  local mnts=""
  local dirs=" \
    /opt/data/artifacts \
    /opt/data/content \
    /opt/data/duplicates \
    /var/www/hls \
    /var/log/nginx \
    /var/lib/nginx"
  if echo $@ | grep -qE "(-u|--read-only)"; then
    for d in $dirs; do
      if ! echo "$@" | grep -q "$d"; then
        mnts+=" --tmpfs=$d:uid=$(id -u)"
      fi
    done

    if ! echo "$@" | grep -q "/tmp"; then
      mnts+=" --tmpfs=/tmp"
    fi
  fi
  echo $mnts
}

function get_security_opts() {
  echo "--security-opt=no-new-privileges:true --read-only"
}

function docker_run_opts() {
  local opts=$1
  shift

  local DEVICE_GRP=$(ls -g $DEVICE | awk '{print $3}' | \
    xargs getent group | awk -F: '{print $3}')

  local cmd=(docker run --rm -p 8080:8080 \
    -e DEVICE=$DEVICE --device $DEVICE --group-add $DEVICE_GRP \
    --cap-add SYS_ADMIN \
    --name $CONTAINER_NAME \
    $opts ${MDS_IMAGE} "$@")
  echo "# RUN: ${cmd[@]}" >>$_TMP/cmd.txt
  echo "# ${cmd[@]}" >&3

  "${cmd[@]}" &
  local pid=$!

  end=$(( $(date +%s) + $TIMEOUT ))
  while ps -p $pid > /dev/null &&
      [ $(date +%s) -lt $end ]; do
    sleep 1;
  done

  local res=0
  if ps -p $pid > /dev/null; then
    echo "# test timeout, killing..." >&3
    docker stop $CONTAINER_NAME
    echo "# $(dmesg | grep GPU | grep HANG)" >&3
    res=1
  else
    wait $pid || res=$?
  fi

  echo "# STS: $res" >>$_TMP/cmd.txt
  return $res
}

function docker_run() {
  docker_run_opts "--security-opt=no-new-privileges:true" "$@"
}

function print_output() {
  for i in $(seq 1 ${#lines[@]}); do
    echo "# ${lines[$i]}" >&3
  done
}

function grep_for() {
  what=$1
  shift
  text=($@)
  res=1
  for line in ${text[@]}; do
    if [[ "$line" =~ "$what"  ]]; then
      res=0
      break
    fi
  done
  return $res
}

function kernel_ge_4_16() {
  # i915 pmu is available from vanilla kernel 4.16
  if [[ $(uname -r)  =~ ^([0-9]+)\.([0-9]+) ]]; then
    if [[ ${BASH_REMATCH[1]} -le 3 || ${BASH_REMATCH[1]} -eq 4 && ${BASH_REMATCH[2]} -lt 16 ]]; then
      return 1
    fi
  else
    echo "# bug: something is very wrong" >&3
    return 1
  fi
  return 0
}

function vdenc_support() {
  local std=$1
  # we get seg in the form of: seg="200 300", where 200 and 300 are line numbers in vainfo output:
  #  200 VAProfileH264/VAEntrypointEncSliceLP
  #  ...
  #  300 VAProfile<next-item>/VAEntrypoint<next-item>
  local seg=$(vainfo -a --display drm --device $DEVICE 2> /dev/null | \
    grep -n VAProfile | grep -A1 VAProfile${std}/VAEntrypointEncSliceLP | awk -F: '{ print $1 }')
  seg=(${seg// / })
  [ -z "${seg}" ] && return 0 # profile does not exist
  # now we produce segment variable as an input to sed in a form: segment="200,300p", or segment="200,$p"
  # if there is no profile entry after the one we searched for ($ indicates EOF and p stands for "print" for sed)
  local segment=${seg[0]}
  [ ${#seg[@]} -eq 1 ] && segment+=',$p' || segment+=','${seg[1]}'p'
  [ -z "$(vainfo -a --display drm --device $DEVICE 2> /dev/null | sed -n $segment | grep VA_RC_CBR)" ] && return 0
  [ -z "$(vainfo -a --display drm --device $DEVICE 2> /dev/null | sed -n $segment | grep VA_RC_VBR)" ] && return 0
  return 1
}

