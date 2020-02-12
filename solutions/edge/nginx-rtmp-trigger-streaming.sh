#!/bin/bash

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
# ignored ny the script. They can happen in this cases:
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

to_play=""
if [ -f /opt/data/content/$stream.mp4 ]; then
  to_play="/opt/data/content/$stream.mp4"
fi
if [ "$to_play" = "" -a -f /opt/data/embedded/$stream.mp4 ]; then
  to_play="/opt/data/embedded/$stream.mp4"
fi

if [ "$to_play" = "" ]; then
  addlog "no such stream to play: $stream"
  cp $LOGFILE $ARTIFACTS/
  addlog "$0 $@: end"
  exit 0
fi

cmd=(ffmpeg
  -hwaccel qsv -hwaccel_device /dev/dri/renderD128
  -c:v h264_qsv -re -stream_loop 100 -i $to_play
  -c:v h264_qsv -profile:v baseline
  -preset medium -g 50 -bf 1 -async_depth 1
  -b:v 1000K -maxrate 6000K -minrate 6000K
  -c:a copy -f flv rtmp://localhost:1935/live/$stream)

addlog "scheduling: ${cmd[@]}"
"${cmd[@]}" >$ARTIFACTS/$stream.log 2>&1 &
pid=$!

addlog "$0 $@: just scheduled PID=$pid"
addlog "$0 $@: waiting for some time for index file to appear"

# Timeout should be selected longer than HLS fragment length since index
# file is published by RTMP HLS server when first fragment becomes available.
end=$(( $(date +%s) + 20 ))
addlog "end=$end"
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
