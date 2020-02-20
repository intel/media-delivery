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
elif [ $bitrate_mbps = 4.5 ]; then
  bitrate=4500000
elif [ $bitrate_mbps = 7.5 ]; then
  bitrate=7500000
else
  bitrate=$(($bitrate_mbps * 1000000))
fi

ffmpeg \
  -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $file -vframes $nframes \
  -c:v hevc_qsv -preset medium -profile:v main -b:v $bitrate \
  $options \
  -vsync 0 -y ${prefix}_${bitrate_mbps}Mbps_VBR_QSV.h265
