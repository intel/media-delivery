#!/bin/bash

mode=$1
if [ "$#" -gt 0 ]; then
  shift;
  streams=($@)
fi

if [ "$mode" = "help" ]; then
  echo "Usage: demo"
  echo "   or: demo streams"
  echo "   or: demo ffmpeg <stream> [<stream>...]"
  echo "   or: demo help"
  echo ""
  echo "This is a helper script to try different demo modes."
  echo ""
  echo "With no arguments it starts nginx server and awaits external incoming client"
  echo "requests. Issue the one requesting playback via vlc from the host or some other"
  echo "system on the network:"
  echo "   $ vlc http://localhost:8080/live/<stream>"
  echo "or capturing via ffmpeg:"
  echo "   $ ffmpeg -i http://localhost:8080/live/<stream> -c copy /tmp/output.mkv"
  echo ""
  echo "With 'streams' as an argument script returns list of streams available"
  echo "for playback and exits."
  echo ""
  echo "With 'ffmpeg' as an argument script triggers streaming via ffmpeg and captures"
  echo "incoming HLS video stream"
  exit 0
fi

if [ "$mode" = "streams" ]; then
  echo "Your content (has preference over embedded content):"
  for stream in `ls -1 /opt/data/content/*.mp4`; do
    name=$(basename -- "$stream")
    name="${name%.*}"
    echo "  $name | http://localhost:8080/live/$name/index.m3u8"
  done
  echo
  echo "Container embedded content:"
  for stream in `ls -1 /opt/data/embedded/*.mp4`; do
    name=$(basename -- "$stream")
    name="${name%.*}"
    echo "  $name | http://localhost:8080/live/$name/index.m3u8"
  done
  exit 0
fi

streams_required=no
if [ "$mode" = "ffmpeg" ]; then
  command="ffmpeg-capture-hls.sh $streams"
  streams_required=yes
fi

if [ "$streams_required" = "yes" -a ${#streams[@]} -eq 0 ]; then
  echo "error: '$mode' mode requires streams"
  exit -1
fi

{
  echo "new-session /usr/bin/bash -c \"$command\""
  echo "split-window -v sudo intel_gpu_top"
  echo "split-window -v top"
  echo "split-window -v" # TODO dump server and transcoding statistics
  echo "select-layout tiled"
} >> /home/user/.tmux.conf

sudo nginx

tmux attach
