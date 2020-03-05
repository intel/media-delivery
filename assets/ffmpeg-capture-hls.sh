#!/bin/bash

# Usage:
#   ffmpeg-capture-hls.sh [<options>] <stream> [<stream>...]
#
# Options:
#   --exit Exit once all streams will be captured
#
# Helper script to trigger HLS streaming and capture it to the file.
# Script recognizes the following stream specifications:
#  - http://localhost:8080/live/<stream>/index.m3u8
#  - <stream> aka http://localhost:8080/live/<stream>/index.m3u8
#
# By default script triggers capture (in the background process)
# and enters monitoring loop. You can exit from it with CTRL^C. Upon
# exit script will enter bash shell for you to wander about. If
# --exit option will be specified, script will exit automatically
# upon capturing all the streams.

source /etc/demo.env

# to be able to pass variables to watch we need to export them
export _exit=0
export no_proxy=localhost
export ARTIFACTS=/opt/data/artifacts/ffmpeg-hls-client

if [ "$1" = "--exit" ]; then
  shift
  export _exit=1
fi

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
  running=0
  completed=0
  for arg in $@; do
    pid=$(echo "$arg" | awk -F: '{print $1}')
    name=$(echo "$arg" | awk -F: '{print $2}')
    log=$(echo "$arg" | awk -F: '{print $3}')

    size=$(du -sh $ARTIFACTS/$name.mkv 2>/dev/null | awk '{print $1}')

    line=$(cat $log | sed 's/\r/\n/' | grep frame= | tail -1)
    # frame= x fps= xx ...
    frames=$(echo $line | awk -F'[ |=]+' '{print $2}')
    fps=$(echo $line | awk -F'[ |=]+' '{print $4}')

    report_line=$(echo | awk \
      -v name=$name \
      -v size=$size \
      -v frames=$frames \
      -v fps=$fps \
      '{print "  " name ": size=" size ", frames=" frames ", fps=" fps}')

    if ps -p $pid > /dev/null; then
      running=$((++running))
      running_reports+="${report_line}\n"
    else
      completed=$((++completed))
      completed_reports+="${report_line}\n"
    fi
  done

  echo "ffmpeg streaming clients monitor"
  echo "================================"
  echo "Output and logs path: $ARTIFACTS"
  echo "Total clients: $((running+completed))"
  echo "Running clients: $running"
  echo -ne "$running_reports"
  echo "Completed clients: $completed"
  echo -ne "$completed_reports"

  echo
  echo "CTRL^C to exit monitor and enter shell"
  if [ $_exit -eq 1 -a $running -eq 0 ]; then
    return 1
  fi
  return 0
}

export -f watch_pids

# we echo something to be able to exit from watch: this emulates key press
watch -n 1 --errexit -x bash -c "watch_pids ${pids[*]}" <<< "1"

if [ $_exit -eq 0 -o $? -eq 0 ]; then
  # You can press CTRL^C to abort watch command and enter shell to wander about
  /bin/bash
else
  echo "All clients completed."
  for i in `seq 5 -1 1`; do
    echo "Exiting demo in $i...";
    sleep 1;
  done
fi
