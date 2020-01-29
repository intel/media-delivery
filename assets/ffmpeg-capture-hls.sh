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

for s in $@; do
  if echo $s | grep http; then
    stream=$s
    name=stream=$(echo "$stream" | awk -F/ '{print $3}')
  else
    stream=http://localhost:8080/live/$s/index.m3u8
    name=$s
  fi

  ffmpeg -hide_banner -i $stream -c copy /tmp/$name.mkv >/tmp/ffmpeg-client-$name.log 2>&1 &
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

watch -n 1 " \
  echo \"total requested streams: $#\"; \
  echo \"total running streams: $(ls /tmp/ffmpeg-client-*.log | wc -l)\"; \
  for log in \`ls /tmp/ffmpeg-client-*.log\`; do \
    line=\`tail -1 \$log | grep frame=\`; \
    echo | awk -v myline=\"\$line\" -v mylog=\$log '{print mylog \": \" myline}'; \
  done"

# enter the shell for the user to be able to wander about
/bin/bash
