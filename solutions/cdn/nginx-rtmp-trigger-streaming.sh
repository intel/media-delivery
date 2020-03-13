#!/bin/bash
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

# Usage:
#    trigger-streaming.sh <stream>
#
# Script looks for incoming <stream> to match "/live/<stream>/index.m3u8".
# If match found, script either schedules ffmpeg transcode command line
# which will start HLS streaming or skips scheduling if it was already done
# for the specified stream. Right after scheduling scripts waits for some time
# to assure that index file (index.m3u8) was actually generated.
#
# It can happen that script will be invoked for the <stream> not matching
# the above specification. This is ok and such requests will be simply
# ignored by the script. They can happen in this cases:
#   - For malformed HTTP requests issued by the clients
#   - For valid requests for HLS fragments which are of /live/<stream>/<path>.ts
#

LOGFILE=/tmp/lua-client-requests.log

# Just simple logging to debug the script
addlog() {
  echo "[$(date)] $@" >>$LOGFILE
}

log() {
  addlog "$@" >>$LOGFILE
  $@
}

addlog "$0 $@: start"

source /etc/demo.env

ARTIFACTS=/opt/data/artifacts/ffmpeg-hls-server
mkdir -p $ARTIFACTS

# Let's parse incoming URL request expected to be: "/live/<stream>/index.m3u8"
live=$(echo "$1" | awk -F/ '{print $2}')
stream=$(echo "$1" | awk -F/ '{print $3}')
index=$(echo "$1" | awk -F/ '{print $4}')

addlog "live=$live, stream=$stream, index=$index"

if [ "$live" != "live" -o -z "$stream" -o "$index" != "index.m3u8" ]; then
  addlog "nothing to do for the stream: $1"
  addlog "$0 $@: end"
  cp $LOGFILE $ARTIFACTS/
  exit 0
fi

if [ -d /var/www/hls/live/$stream ]; then
  addlog "already publishing: $1"
  addlog "$0 $@: end"
  cp $LOGFILE $ARTIFACTS/
  exit 0
fi

mkdir -p /var/www/hls/live/$stream
cd /var/www/hls/live/$stream

to_play=""
if [ -f /opt/data/content/$stream.mp4 ]; then
  to_play="/opt/data/content/$stream.mp4"
fi
if [ "$to_play" = "" -a -f /opt/data/embedded/$stream.mp4 ]; then
  to_play="/opt/data/embedded/$stream.mp4"
fi
if [ "$to_play" = "" -a -f /opt/data/duplicates/$stream.mp4 ]; then
  to_play="/opt/data/duplicates/$stream.mp4"
fi

if [ "$to_play" = "" ]; then
  addlog "no such stream to play: $stream"
  cp $LOGFILE $ARTIFACTS/
  addlog "$0 $@: end"
  exit 0
fi

function run() {
  "$@" >$ARTIFACTS/$stream.log 2>&1 &
  pid=$!
  echo "$pid:$stream:$ARTIFACTS/$stream.log" >> $ARTIFACTS/scheduled
  wait
  echo "$pid:$stream:$ARTIFACTS/$stream.log:$?" >> $ARTIFACTS/done
}

cmd=(ffmpeg
  -hwaccel qsv -hwaccel_device /dev/dri/renderD128
  -c:v h264_qsv -re -i $to_play
  -filter_complex '[v:0]split=2[o1][s2];[s2]scale_qsv=w=640:h=-1[o2]'
  -map [o1] -c:v h264_qsv -b:v 5M
  -map [o2] -c:v h264_qsv -b:v 1M
  -map a:0 -map a:0 -c:a copy
  -f hls -hls_time 10 -hls_playlist_type event
  -master_pl_name index.m3u8
  -hls_segment_filename stream_%v/data%06d.ts
  -use_localtime_mkdir 1
  -var_stream_map 'v:0,a:0 v:1,a:1' stream_%v.m3u8)

addlog "scheduling: ${cmd[@]}"
run "${cmd[@]}" </dev/null >/dev/null 2>&1 &
pid=$!

TIMEOUT=20
addlog "$0 $@: waiting for $TIMEOUT seconds for index file to appear"

# Timeout should be selected longer than HLS fragment length since index
# file is published by ffmpeg when first fragment becomes available.
end=$(( $(date +%s) + 20 ))
while ps -p $pid > /dev/null &&
      [ $(date +%s) -lt $end ] &&
      [ ! -f /var/www/hls/live/$stream/index.m3u8 ]; do
  sleep 1;
done

if ! ps -p $pid > /dev/null; then
  addlog "$0 $@: failed to schedule: scheduled process died"
else
  if [ ! -f /var/www/hls/live/$stream/index.m3u8 ]; then
    addlog "$0 $@: failed to schedule: timeout waiting for index file: /var/www/hls/live/$stream/index.m3u8"
    kill -9 $pid
  else
    addlog "$0 $@: scheduled successfully"
  fi
fi

addlog "$0 $@: end"
cp $LOGFILE $ARTIFACTS/
