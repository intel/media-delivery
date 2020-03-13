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

function setup() {
  echo "setting up" >&3
  rm -rf /tmp/mds_bats
  mkdir /tmp/mds_bats
}

function teardown() {
  echo "teardown" >&3
  rm -rf /tmp/mds_bats
}

##################
# helper functions
##################
function docker_run() {
  docker run --rm --privileged --network=host ${MDS_IMAGE} $@
}

function docker_run_opts() {
  opts=$1
  shift
  docker run --rm --privileged --network=host $opts ${MDS_IMAGE} $@
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

#################
# demo-bash tests
#################
@test "demo-bash whoami" {
  run docker_run whoami
  print_output
  [ "$status" -eq 0 ]
  [ "$output" = "user" ]

  run docker_run pwd
  print_output
  [ "$status" -eq 0 ]
  [ "$output" = "/home/user" ]

}

@test "demo-bash no gpu" {
  run docker run ${MDS_IMAGE} whoami
  print_output
  [ "$status" -eq 255 ]
}

@test "demo-bash map all" {
  tmp_content=`mktemp -p /tmp/mds_bats -d -t content-XXXX`
  tmp_artifacts=`mktemp -p /tmp/mds_bats -d -t artifacts-XXXX`
  tmp_hls=`mktemp -p /tmp/mds_bats -d -t hls-XXXX`
  chmod 755 $tmp_content $tmp
  chmod 777 $tmp_artifacts $tmp_hls
  run docker_run_opts \
    "-v $tmp_content:/opt/data/content -v $tmp_artifacts:/opt/data/artifacts -v $tmp_hls:/var/www/hls" \
    whoami
  print_output
  [ "$status" -eq 0 ]
  [ "$output" = "user" ]
  rm -rf $tmp_content $tmp_artifacts $tmp_hls
}

@test "demo-bash bad content map" {
  tmp=`mktemp -p /tmp/mds_bats -d -t content-XXXX`
  chmod a-r $tmp
  run docker_run_opts "-v $tmp:/opt/data/content" whoami
  print_output
  [ "$status" -eq 255 ]
  rm -rf $tmp
}

@test "demo-bash bad artifacts map" {
  tmp=`mktemp -p /tmp/mds_bats -d -t artifacts-XXXX`
  chmod a-r $tmp
  run docker_run_opts "-v $tmp:/opt/data/artifacts" whoami
  print_output
  [ "$status" -eq 255 ]
  rm -rf $tmp
}

@test "demo-bash bad hls map" {
  tmp=`mktemp -p /tmp/mds_bats -d -t hls-XXXX`
  chmod a-r $tmp
  run docker_run_opts "-v $tmp:/var/www/hls" whoami
  print_output
  [ "$status" -eq 255 ]
  rm -rf $tmp
}

####################
# generic demo tests
####################
@test "demo unknown command" {
  run docker_run demo unknown
  print_output
  [ $status -eq 255 ]
}

#################
# demo help tests
#################
@test "demo --help" {
  run docker_run demo --help
  print_output
  [ $status -eq 0 ]
}

@test "demo help" {
  run docker_run demo help
  print_output
  [ $status -eq 0 ]
}

@test "demo help ffmpeg" {
  run docker_run demo help ffmpeg
  print_output
  [ $status -eq 0 ]
}

@test "demo help streams" {
  run docker_run demo help streams
  print_output
  [ $status -eq 0 ]
}

@test "demo help unknown topic" {
  run docker_run demo help unknown
  print_output
  [ $status -eq 255 ]
}

####################
# demo streams tests
####################
@test "demo streams" {
  run docker_run demo streams
  print_output
  [ $status -eq 0 ]
  run grep_for "WAR_2Mbps_perceptual_1080p" ${lines[@]}
  [ $status -eq 0 ]
}

@test "demo streams -n" {
  N=5
  run docker_run demo -$N streams
  print_output
  [ $status -eq 0 ]
  streams_output=("${lines[@]}")

  run grep_for "WAR_2Mbps_perceptual_1080p" ${streams_output[@]}
  [ $status -eq 0 ]
  for i in `seq 1 $N`; do
    run grep_for "WAR_2Mbps_perceptual_1080p-$i" ${streams_output[@]}
    [ $status -eq 0 ]
  done
}

@test "demo streams w/ added content" {
  tmp=`mktemp -p /tmp/mds_bats -d -t demo-XXXX`
  chmod a+x $tmp
  chmod a+r $tmp
  touch $tmp/fake.mp4
  run docker_run_opts "-v $tmp:/opt/data/content" demo streams
  print_output
  [ $status -eq 0 ]
  streams_output=("${lines[@]}")

  run grep_for "fake" ${streams_output[@]}
  [ $status -eq 0 ]
  run grep_for "WAR_2Mbps_perceptual_1080p" ${streams_output[@]}
  [ $status -eq 0 ]
  rm -rf $tmp
}

@test "demo streams w/ added content -n" {
  N=5
  tmp=`mktemp -p /tmp/mds_bats -d -t demo-XXXX`
  chmod a+x $tmp
  chmod a+r $tmp
  touch $tmp/fake.mp4
  run docker_run_opts "-v $tmp:/opt/data/content" demo -$N streams
  print_output
  [ $status -eq 0 ]
  streams_output=("${lines[@]}")

  run grep_for "fake" ${streams_output[@]}
  [ $status -eq 0 ]
  for i in `seq 1 $N`; do
    run grep_for "fake-$i" ${streams_output[@]}
    [ $status -eq 0 ]
  done
  run grep_for "WAR_2Mbps_perceptual_1080p" ${streams_output[@]}
  [ $status -eq 0 ]
  for i in `seq 1 $N`; do
    run grep_for "WAR_2Mbps_perceptual_1080p-$i" ${streams_output[@]}
    [ $status -eq 0 ]
  done
  rm -rf $tmp
}

@test "demo streams too many arguments" {
  run docker_run demo streams param
  print_output
  [ $status -eq 255 ]
}

###################
# demo ffmpeg tests
###################
@test "demo ffmpeg no streams" {
  run docker_run demo ffmpeg
  print_output
  [ $status -eq 255 ]
}

@test "demo ffmpeg unknown stream" {
  run docker_run demo ffmpeg unknown
  print_output
  [ $status -eq 255 ]
}


function get_report_line_from_ffmpeg_log() {
  cat $1 | sed 's/\r/\n/' | grep frame= | tail -1
}

function get_frames_from_ffmpeg_log() {
  # frame= x fps= xx ...
  echo $(get_report_line_from_ffmpeg_log $1) | awk -F'[ |=]+' '{print $2}'
}

function check_done_status() {
  _done=$1
  while read line; do
    status=${line##*:}
    [ "$status" -eq 0 ]
  done <$_done
}

@test "demo ffmpeg capture" {
  tmp=`mktemp -p /tmp/mds_bats -d -t demo-XXXX`
  chmod 777 $tmp
  run docker_run_opts "-v $tmp:/opt/data/artifacts" demo ffmpeg --exit WAR_2Mbps_perceptual_1080p
  [ $status -eq 0 ]

  # checking artifacts in an order of appearence
  [ -f $tmp/ffmpeg-hls-client/scheduled ]
  [ -f $tmp/ffmpeg-hls-client/WAR_2Mbps_perceptual_1080p.log ]
  [ -f $tmp/ffmpeg-hls-server/lua-client-requests.log ]
  [ -f $tmp/ffmpeg-hls-server/scheduled ]
  [ -f $tmp/ffmpeg-hls-server/WAR_2Mbps_perceptual_1080p.log ]
  [ -f $tmp/ffmpeg-hls-client/WAR_2Mbps_perceptual_1080p.mkv ]
  [ -f $tmp/ffmpeg-hls-server/done ]
  [ -f $tmp/ffmpeg-hls-client/done ]

  check_done_status $tmp/ffmpeg-hls-server/done
  check_done_status $tmp/ffmpeg-hls-client/done

  frames=$(get_frames_from_ffmpeg_log $tmp/ffmpeg-hls-server/WAR_2Mbps_perceptual_1080p.log)
  echo "# server: frames=$frames" >&3
  [ "$frames" -eq 3443 ]

  frames=$(get_frames_from_ffmpeg_log $tmp/ffmpeg-hls-client/WAR_2Mbps_perceptual_1080p.log)
  echo "# client: frames=$frames" >&3
  [ "$frames" -eq 3443 ]

  sudo rm -rf $tmp
}
