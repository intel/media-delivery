#!/bin/bash

if [[ "$1" =~ ^(help|-help|--help|-h)$ ]]; then
  echo "Usage:"
  echo "  run_quality.sh help|-help|--help|-h"
  echo "  run_quality.sh <stream> <prefix> <width> <height> <nframes> <framerate> AVC|HEVC -4K|-HD|-SD default|best"
  echo ""
  echo "Options:"
  echo "  help|-help|--help|-h - print this help"
  echo "  <stream>          - fully qualified path to the input stream in I420 color format"
  echo "  <prefix>          - prefix appended to the output file name(s) (TODO: delete me)"
  echo "  <widht>, <height> - width and height of the input stream"
  echo "  <nframes>         - number of frames to process"
  echo "  <framerate>       - input stream framerate"
  echo "  AVC|HEVC          - encoder to use"
  echo "  -4K|-HD|-SD       - a set of bitrates to use"
  echo "  default|best      - a set of encoding options to use"
  echo ""
  echo "Description:"
  echo "Encodes input YUV I420 stream with specified codec and with different bitrates."
  exit 0
fi

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
codec=$1
shift
bitrates=$1
shift
options=$1
shift

if [ "$codec" = "AVC" ]; then
  if [ "$bitrates" = "-4K" ]; then
    bitrates_list=(6 9 15 24 40)
  elif [ "$bitrates" = "-HD" ]; then
    bitrates_list=(2 3 6 12 24)
  elif [ "$bitrates" = "-SD" ]; then
    bitrates_list=(1 1.5 3 6 12)
  else
    echo "error: invalid bitrates list (-4K, -HD, -SD): $bitrates"
    exit -1
  fi

  if [ "$options" = "default" ]; then
    options_qsv=""
    options_senc=""
  elif [ "$options" = "best" ]; then
    options_qsv="-extbrc 1 -b_strategy 1 -bf 7 -refs 5"
    options_senc="-extbrc:implicit -ExtBrcAdaptiveLTR:on -r 8 -x 5"
  else
    echo "error: invalid encoding options preset (default, best): $options"
    exit -1
  fi
elif [ "$codec" = "HEVC" ]; then
  if [ "$bitrates" = "-4K" ]; then
    bitrates_list=(6 9 15 24 40)
  elif [ "$bitrates" = "-HD" ]; then
    bitrates_list=(2 3 6 9 15)
  elif [ "$bitrates" = "-SD" ]; then
    bitrates_list=(1 1.5 3 4.5 7.5)
  else
    echo "error: invalid bitrates list (-4K, -HD, -SD): $bitrates"
    exit -1
  fi

  if [ "$options" = "default" ]; then
    options_qsv=""
    options_senc=""
  elif [ "$options" = "best" ]; then
    options_qsv="-extbrc 1 -qmin 1 -qmax 51"
    options_senc="-extbrc:on"
  else
    echo "error: invalid encoding options preset (default, best): $options"
    exit -1
  fi
else
  echo "error: invalid codec (AVC, HEVC): $codec"
  exit -1
fi

path=$(dirname $(readlink -f $0))

for b in "${bitrates_list[@]}"; do
  $path/$codec/run_cbr_ffmpeg-qsv.sh $file $prefix $width $height $nframes $framerate $b $options_qsv
  $path/$codec/run_vbr_ffmpeg-qsv.sh $file $prefix $width $height $nframes $framerate $b $options_qsv
  $path/$codec/run_cbr_sample-encode.sh $file $prefix $width $height $nframes $framerate $b $options_senc
  $path/$codec/run_vbr_sample-encode.sh $file $prefix $width $height $nframes $framerate $b $options_senc
done
