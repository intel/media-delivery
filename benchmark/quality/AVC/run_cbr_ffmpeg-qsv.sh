#!/bin/bash

file=$1
shift
prefix=$1
shift
width=$1
shift
height=$1
shift
nframes=$1
shift
framerate=$1
shift
bitrate_mbps=$1
shift
options=$@
shift

if [ $bitrate_mbps = 1.5 ]; then
  bitrate=1500000
else
  bitrate=$(($bitrate_mbps * 1000000))
fi

ffmpeg \
  -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $file -vframes $nframes \
  -c:v h264_qsv -preset medium -profile:v high -b:v $bitrate -maxrate $bitrate -minrate $bitrate \
  $options \
  -vsync 0 -y ${prefix}_${bitrate_mbps}Mbps_CBR_QSV.h264
