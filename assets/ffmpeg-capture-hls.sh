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
export no_proxy=localhost
export ARTIFACTS=/opt/data/artifacts/ffmpeg-hls-client

if tty -s; then
  export _tty=1
else
  export _tty=0
fi
export _exit=0
export _scheduled=$ARTIFACTS/scheduled
export _done=$ARTIFACTS/done

if [ "$1" = "--exit" ]; then
  shift
  export _exit=1
fi

rm -rf $ARTIFACTS
mkdir -p -m=777 $ARTIFACTS

function run() {
  name=$1
  shift

  "$@" >$ARTIFACTS/$name.log 2>&1 &
  pid=$!
  echo "$pid:$name:$ARTIFACTS/$name.log" >> $ARTIFACTS/scheduled
  wait
  echo "$pid:$name:$ARTIFACTS/$name.log:$?" >> $ARTIFACTS/done
}

for s in $@; do
  if echo $s | grep http; then
    stream=$s
    name=stream=$(echo "$stream" | awk -F/ '{print $3}')
  else
    stream=http://localhost:8080/live/$s/index.m3u8
    name=$s
  fi

  cmd=(ffmpeg -hide_banner -i $stream -c copy -y $ARTIFACTS/$name.mkv)
  run $name "${cmd[@]}" </dev/null >/dev/null 2>&1 &
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
  running_reports=""
  completed_reports=""
  if [ -f $_scheduled ]; then
    while read p; do
      pid=$(echo "$p" | awk -F: '{print $1}')
      name=$(echo "$p" | awk -F: '{print $2}')
      log=$(echo "$p" | awk -F: '{print $3}')

      if [ -f $_done ]; then
        done_line=$(fgrep $p $_done)
        if [ $? -eq 0 ]; then
          status=${done_line##*:}
        fi
      fi

      size=$(du -sh $ARTIFACTS/$name.mkv 2>/dev/null | awk '{print $1}')

      line=$(cat $log | sed 's/\r/\n/' | grep frame= | tail -1)
      # frame= x fps= xx ...
      frames=$(echo $line | awk -F'[ |=]+' '{print $2}')
      fps=$(echo $line | awk -F'[ |=]+' '{print $4}')

      report_line="  ${name}: size=${size}, frames=${frames}, fps=${fps}"

      if [ -z "$status" ]; then
        running=$((++running))
        running_reports+="${report_line}\n"
      else
        report_line+=", status=${status}"
        completed=$((++completed))
        completed_reports+="${report_line}\n"
      fi
    done <$_scheduled
  fi

  echo "ffmpeg streaming clients monitor"
  echo "================================"
  if [ $_tty -ne 1 ]; then
    echo "Date: $(date)"
  fi
  echo "Output and logs path: $ARTIFACTS"
  echo "Total clients: $((running+completed))"
  echo "Running clients: $running"
  echo -ne "$running_reports"
  echo "Completed clients: $completed"
  echo -ne "$completed_reports"
  echo

  if [ $_tty -eq 1 ]; then
    echo "CTRL^C to exit monitor and enter shell"
  fi
  if [ $_exit -eq 1 -a $running -eq 0 ]; then
    return 1
  fi
  return 0
}

if [ $_tty -eq 1 ]; then
  export -f watch_pids

  # we echo something to be able to exit from watch: this emulates key press
  watch -n 1 --errexit -x bash -c "watch_pids" <<< "1"
else
  while watch_pids; do sleep 1; done
fi

if [[ $_tty == 1 && ( $_exit == 0 || $? == 0 ) ]]; then
  # You can press CTRL^C to abort watch command and enter shell to wander about
  /bin/bash
else
  echo "All clients completed."
  for i in `seq 5 -1 1`; do
    echo "Exiting demo in $i...";
    sleep 1;
  done
fi
