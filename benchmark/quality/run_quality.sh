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

if [[ "$1" =~ ^(help|-help|--help|-h)$ ]]; then
  echo "Usage:"
  echo "  run_quality.sh help|-help|--help|-h"
  echo "  run_quality.sh <stream.yuv> <prefix> <width> <height> <nframes> <framerate> AVC|HEVC -4K|-HD|-SD default|best [--skip-metrics|--skip-encoding]"
  echo "  run_quality.sh <stream.container> <prefix> <nframes> AVC|HEVC -4K|-HD|-SD default|best [--skip-metrics]"
  echo ""
  echo "Options:"
  echo "  help|-help|--help|-h - print this help"
  echo "  <stream.yuv>         - fully qualified path to the input stream in I420 color format"
  echo "  <stream.container>   - fully qualified path to the input stream in I420 color format"
  echo "  <prefix>             - prefix appended to the output file name(s) (TODO: delete me)"
  echo "  <widht>, <height>    - width and height of the input stream"
  echo "  <nframes>            - number of frames to process"
  echo "  <framerate>          - input stream framerate"
  echo "  AVC|HEVC             - encoder to use"
  echo "  -4K|-HD|-SD          - a set of bitrates to use"
  echo "  default|best         - a set of encoding options to use"
  echo "  --skip-metrics       - do not calculate metrics"
  echo ""
  echo "Description:"
  echo "Encodes input YUV I420 stream with specified codec and with different bitrates."
  exit 0
fi

file=$1
shift
prefix=$1
shift

if [[ "${file##*.}" =~ (yuv|YUV) ]]; then
  is_container=0
  width=$1
  shift
  height=$1
  shift
  nframes=$1
  shift
  framerate=$1
  shift
else
  is_container=1
  nframes=$1
  shift
  framerate=$(($(ffprobe -v error -select_streams v -of default=noprint_wrappers=1:nokey=1 \
    -show_entries stream=r_frame_rate $file)))
fi

codec=$1
shift
bitrates=$1
shift
options=$1
shift
skip_arg=$1
shift

if [ "$codec" = "AVC" ]; then
  if [ "$bitrates" = "-4K" ]; then
    bitrates_list=(6 9 15 24 40)
    vmaf_model_path=vmaf_4k_v0.6.1.pkl
  elif [ "$bitrates" = "-HD" ]; then
    bitrates_list=(2 3 6 12 24)
    vmaf_model_path=vmaf_v0.6.1.pkl
  elif [ "$bitrates" = "-SD" ]; then
    bitrates_list=(1 1.5 3 6 12)
    vmaf_model_path=vmaf_v0.6.1.pkl
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
    options_qsv="-extbrc 1 -qmin 1 -qmax 51 -refs 5"
    options_senc="-extbrc:on -x 5"
  else
    echo "error: invalid encoding options preset (default, best): $options"
    exit -1
  fi
else
  echo "error: invalid codec (AVC, HEVC): $codec"
  exit -1
fi

if [ "$skip_arg" != "--skip-encoding" ]; then
  path=$(dirname $(readlink -f $0))

  for b in "${bitrates_list[@]}"; do
    if [ $is_container -eq 1 ]; then
      $path/$codec/run_cbr_ffmpeg-qsv.sh $file $prefix $nframes $framerate $b $options_qsv
      $path/$codec/run_vbr_ffmpeg-qsv.sh $file $prefix $nframes $framerate $b $options_qsv
    else
      $path/$codec/run_cbr_ffmpeg-qsv.sh $file $prefix $width $height $nframes $framerate $b $options_qsv
      $path/$codec/run_vbr_ffmpeg-qsv.sh $file $prefix $width $height $nframes $framerate $b $options_qsv
      $path/$codec/run_cbr_sample-encode.sh $file $prefix $width $height $nframes $framerate $b $options_senc
      $path/$codec/run_vbr_sample-encode.sh $file $prefix $width $height $nframes $framerate $b $options_senc
    fi
  done
fi

if [ "$skip_arg" != "--skip-metrics" ]; then
  if [ -f $DEMO_PREFIX/share/vmaf/$vmaf_model_path ]; then
    # that's the location where media delivery demo installs vmaf models
    vmaf_model_path=$DEMO_PREFIX/share/vmaf/$vmaf_model_path
  elif [ -f /usr/local/share/model/$vmaf_model_path ]; then
    # that's default installation path for vmaf models
    vmaf_model_path=/usr/local/share/model/$vmaf_model_path
  else
    echo "error: can't find vmaf model: $vmaf_model_path"
    exit -1
  fi

  for out in `ls -1 $prefix* | grep -v \.metrics`; do
    if [ $is_container -eq 0 ]; then
      rawvideo="-f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate"
    fi

    cmd=(ffmpeg -an
      $rawvideo -i $file
      -r $framerate -i $out
      -lavfi " \
        [0:v]trim=end_frame=$nframes[ref]; \
        [1:v]trim=end_frame=$nframes[v]; \
        [v][ref]libvmaf=model_path=$vmaf_model_path:psnr=1:ssim=1:ms_ssim=1:log_fmt=json:log_path=/tmp/out.json"
      -f null -)

    "${cmd[@]}"

    # calculate bitrate in kbps
    b=$(stat -c %s $out)   # filesize
    b=$(($b * 8))          # filesize in bits
    b=$(($b / $nframes))   # bits per frame
    b=$(($b * $framerate)) # bps
    b=$(($b / 1000))       # kbps

    vmaf=$(cat /tmp/out.json | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["VMAF score"])')
    psnr=$(cat /tmp/out.json | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["PSNR score"])')
    ssim=$(cat /tmp/out.json | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["SSIM score"])')
    ms_ssim=$(cat /tmp/out.json | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["MS-SSIM score"])')
    metrics="$out:$b:$vmaf:$psnr:$ssim:$ms_ssim"
    
    echo "$metrics" | grep CBR_QSV >> $prefix.cbr.ffmpeg-qsv.metrics
    echo "$metrics" | grep VBR_QSV >> $prefix.vbr.ffmpeg-qsv.metrics
    if [ $is_container -eq 0 ]; then
      echo "$metrics" | grep CBR_SENC >> $prefix.cbr.sample-encode.metrics
      echo "$metrics" | grep VBR_SENC >> $prefix.vbr.sample-encode.metrics
    fi
  done
fi
