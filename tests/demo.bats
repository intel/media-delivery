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

load utils

####################
# generic demo tests
####################
@test "demo --help" {
  run docker_run demo --help
  print_output
  [ $status -eq 0 ]
}

####################
# demo streams tests
####################
@test "demo streams" {
  run docker_run demo streams
  print_output
  [ $status -eq 0 ]
  run grep_for "WAR_TRAILER_HiQ_10_withAudio" ${lines[@]}
  [ $status -eq 0 ]
}

@test "demo streams -n" {
  for N in 5 10 20 30 40 50; do
    run docker_run demo -$N streams
    print_output
    [ $status -eq 0 ]
    streams_output=("${lines[@]}")

    run grep_for "WAR_TRAILER_HiQ_10_withAudio" ${streams_output[@]}
    [ $status -eq 0 ]
    for i in `seq 1 $N`; do
      run grep_for "WAR_TRAILER_HiQ_10_withAudio-$i" ${streams_output[@]}
      [ $status -eq 0 ]
    done
  done
}

@test "demo streams wrong -n" {
  for N in 51 60 100; do
    run docker_run demo -$N streams
    print_output
    [ $status -eq 255 ]
    streams_output=("${lines[@]}")

    run grep_for "error:" ${streams_output[@]}
    [ $status -eq 0 ]
  done
}

@test "demo streams w/ added content" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  chmod a+x $tmp
  chmod a+r $tmp
  touch $tmp/fake.mp4
  run docker_run_opts "-v $tmp:/opt/data/content" demo streams
  print_output
  [ $status -eq 0 ]
  streams_output=("${lines[@]}")

  run grep_for "fake" ${streams_output[@]}
  [ $status -eq 0 ]
  run grep_for "WAR_TRAILER_HiQ_10_withAudio" ${streams_output[@]}
  [ $status -eq 0 ]
  rm -rf $tmp
}

@test "demo streams w/ added content -n" {
  N=5
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
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
  run grep_for "WAR_TRAILER_HiQ_10_withAudio" ${streams_output[@]}
  [ $status -eq 0 ]
  for i in `seq 1 $N`; do
    run grep_for "WAR_TRAILER_HiQ_10_withAudio-$i" ${streams_output[@]}
    [ $status -eq 0 ]
  done
  rm -rf $tmp
}

@test "demo streams too many arguments" {
  run docker_run demo streams param
  print_output
  [ $status -eq 255 ]
}

#########################
# default demo mode tests
#########################
@test "demo unknown stream" {
  run docker_run demo unknown-stream
  print_output
  [ $status -eq 255 ]
}

function get_report_line_from_ffmpeg_log() {
  cat $1 | sed 's/\r/\n/g' | grep frame= | tail -1
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

function test_expect() {
  local type=$1
  local stream=$2
  local stream_frames=$3

  # checking artifacts in an order of appearence
  [ -f $tmp/ffmpeg-hls-client/scheduled ]
  [ -f $tmp/ffmpeg-hls-client/$type/$stream.log ]
  [ -f $tmp/ffmpeg-hls-server/lua-client-requests.log ]
  [ -f $tmp/ffmpeg-hls-server/scheduled ]
  [ -f $tmp/ffmpeg-hls-server/$type/$stream.log ]
  [ -f $tmp/ffmpeg-hls-client/$type/$stream.mkv ]
  [ -f $tmp/ffmpeg-hls-server/done ]
  [ -f $tmp/ffmpeg-hls-client/done ]

  check_done_status $tmp/ffmpeg-hls-server/done
  check_done_status $tmp/ffmpeg-hls-client/done

  frames=$(get_frames_from_ffmpeg_log $tmp/ffmpeg-hls-server/$type/$stream.log)
  echo "# server: frames=$frames" >&3

  [ "$frames" -eq "$stream_frames" ]
  frames=$(get_frames_from_ffmpeg_log $tmp/ffmpeg-hls-client/$type/$stream.log)
  echo "# client: frames=$frames" >&3
  [ "$frames" -eq "$stream_frames" ]
}

function test_ffmpeg_capture() {
  local type=$1
  echo "# type=$type" >&3

  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  opts="-u $(id -u):$(id -g) -v $tmp:/opt/data/artifacts"
  opts+=" $(get_mounts $opts)"
  opts+=" $(get_security_opts)"
  opts+=" --pids-limit 100 --memory $((400*1024*1024)) --cpu-shares 100"

  run docker_run_opts "$opts" \
    demo --exit $type/WAR_TRAILER_HiQ_10_withAudio
  [ $status -eq 0 ]

  test_expect $type WAR_TRAILER_HiQ_10_withAudio 3443
}

@test "demo vod/avc capture" {
  test_ffmpeg_capture "vod/avc"
}

@test "demo vod/hevc capture" {
  if [ $MDS_DEMO != "cdn" ]; then
    skip "note: mode not supported for '$MDS_DEMO' demo"
  fi
  test_ffmpeg_capture "vod/hevc"
}

@test "demo vod/abr capture" {
  if [ $MDS_DEMO != "cdn" ]; then
    skip "note: mode not supported for '$MDS_DEMO' demo"
  fi
  test_ffmpeg_capture "vod/abr"
}

h265="ffmpeg -hwaccel qsv \
  -c:v h264_qsv -i /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4 \
  -c:v hevc_qsv -preset medium -profile:v main -b:v 1000000 -vframes 20 \
  -y /tmp/WAR.mp4"

@test "demo vod/avc from mp4/h265" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  opts="-u $(id -u):$(id -g) -v $tmp:/opt/data/artifacts"
  opts+=" $(get_mounts $opts)"

  run docker_run_opts "$opts" /bin/bash -c " \
    set -ex; $h265; ln -s /tmp/WAR.mp4 /opt/data/content/; \
    demo --exit vod/avc/WAR;"
  [ $status -eq 0 ]

  test_expect vod/avc WAR 20
}
