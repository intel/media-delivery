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
  bitrate=1500
elif [ $bitrate_mbps = 4.5 ]; then
  bitrate=4500
elif [ $bitrate_mbps = 7.5 ]; then
  bitrate=7500
else
  bitrate=$(($bitrate_mbps * 1000))
fi

sample_encode -hw \
  h264 -w $width -h $height -f $framerate -i $file \
  -u medium -b $bitrate -vbr -n $nframes  \
  $options \
  -o ${prefix}_${bitrate_mbps}Mbps_VBR_SENC.h264
