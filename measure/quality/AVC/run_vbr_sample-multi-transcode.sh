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

dry_run=$1
shift
file=$1
shift
prefix=$1
shift
nframes=$1
shift
bitrate_Mbps=$1
shift
preset=$1
shift
raw=$1
shift
options=$@
shift

bitrate=$(python3 -c 'print(int('$bitrate_Mbps' * 1000))')
bufsize=$(python3 -c 'print(int('$bitrate' / 2))')

vframes="-n $nframes"
[[ "$nframes" = "0" ]] && vframes=""

DEVICE=${DEVICE:-/dev/dri/renderD128}

cmd=(sample_multi_transcode -i::$raw $file \
  -hw -async 1 -device $DEVICE \
  -u $preset -b $bitrate -vbr $vframes  \
  $options \
  -hrd $bufsize \
  -o::h264 ${prefix}_${bitrate_Mbps}Mbps_VBR_SMT.h264)

if [ "$dry_run" = "no" ]; then
  "${cmd[@]}"
else
  echo "${cmd[@]}"
  touch ${prefix}_${bitrate_Mbps}Mbps_VBR_SMT.h264
fi
