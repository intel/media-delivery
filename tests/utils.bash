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

if [ -z "${MDS_DEMO}" ]; then
  MDS_DEMO="cdn"
fi

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
function docker_run() {
  docker run --rm --privileged --network=host ${MDS_IMAGE} "$@"
}

function docker_run_opts() {
  opts=$1
  shift
  docker run --rm --privileged --network=host $opts ${MDS_IMAGE} "$@"
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
