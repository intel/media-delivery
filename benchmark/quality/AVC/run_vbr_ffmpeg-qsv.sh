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

file=$1
shift
prefix=$1
shift
if [[ "${file##*.}" =~ (yuv|YUV) ]]; then
  width=$1
  shift
  height=$1
  shift
  nframes=$1
  shift
  framerate=$1
  shift

  rawvideo="-f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate"
else
  nframes=$1
  shift
  framerate=$1
  shift
fi
bitrate_mbps=$1
shift
options=$@
shift

if [ $bitrate_mbps = 1.5 ]; then
  bitrate=1500000
else
  bitrate=$(($bitrate_mbps * 1000000))
fi

ffmpeg -an \
  $rawvideo -i $file -vframes $nframes \
  -c:v h264_qsv -preset medium -profile:v high -b:v $bitrate \
  $options \
  -vsync 0 -y ${prefix}_${bitrate_mbps}Mbps_VBR_QSV.h264
