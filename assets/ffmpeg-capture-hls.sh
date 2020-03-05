#!/bin/bash

# Usage:
#    ffmpeg-capture-hls.sh <stream> [<stream>...]
#
# Helper script to trigger HLS streaming and capture it to the file.
# Script recognizes the following stream specifications:
#  - http://localhost:8080/live/<stream>/index.m3u8
#  - <stream> aka http://localhost:8080/live/<stream>/index.m3u8
# 

source /etc/demo.env

export no_proxy=localhost

export ARTIFACTS=/opt/data/artifacts/ffmpeg-hls-client

rm -rf $ARTIFACTS
mkdir -p $ARTIFACTS

for s in $@; do
  if echo $s | grep http; then
    stream=$s
    name=stream=$(echo "$stream" | awk -F/ '{print $3}')
  else
    stream=http://localhost:8080/live/$s/index.m3u8
    name=$s
  fi

  ffmpeg -hide_banner -i $stream -c copy -y $ARTIFACTS/$name.mkv >$ARTIFACTS/$name.log 2>&1 &
  pids+=( $!:$name:"$ARTIFACTS/$name.log" )
done

echo "Attempting to capture incoming HLS stream(s)..."
echo "Mind that you will see few seconds delay in the very beginning"
echo "becuase:"
echo "  1. HLS gives us first playlist in the very end of first fragment generation"
echo "  2. ffmpeg accumulates statistics before giving it back to us"
for i in `seq 5 -1 1`; do
  echo "Entering running streams monitoring loop in $i...";
  sleep 1;
done

function watch_pids() {
  echo "ffmpeg streaming clients monitor"
  echo "================================"
  echo "Output and logs are here: $ARTIFACTS"
  echo "Total clients: $#"
  n=0
  for arg in $@; do
    pid=$(echo "$arg" | awk -F: '{print $1}')
    if ps -p $pid > /dev/null; then
      n=$((++n))
    fi
  done
  if [ $n -eq $# ]; then
    status="ALL ALIVE"
  else
    status="SOME ARE DEAD"
  fi
  echo "Currently running clients: $n ($status)"
  for arg in $@; do
    name=$(echo "$arg" | awk -F: '{print $2}')
    log=$(echo "$arg" | awk -F: '{print $3}')

    size=$(du -sh $ARTIFACTS/$name.mkv 2>/dev/null | awk '{print $1}')

    line=$(cat $log | sed 's/\r/\n/' | grep frame= | tail -1)
    # frame= x fps= xx ...
    frames=$(echo $line | awk -F'[ |=]+' '{print $2}')
    fps=$(echo $line | awk -F'[ |=]+' '{print $4}')

    echo | awk \
      -v name=$name \
      -v size=$size \
      -v frames=$frames \
      -v fps=$fps \
      '{print name ": size=" size ", frames=" frames ", fps=" fps}';
  done

  echo
  echo "CTRL^C to exit monitor and enter shell"
}

export -f watch_pids

watch -n 1 -x bash -c "watch_pids ${pids[*]}"
# You can press CTRL^C to abort watch command and enter shell to wander about
/bin/bash
