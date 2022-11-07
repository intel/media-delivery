#!/bin/bash
#
# Copyright (c) 2022 Intel Corporation
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

bitrate=${BITRATE:-100000}
preset=${PRESET:-veryfast}
async=${ASYNC:-20}
stream=dweebs_7680x4320_yuv420p_60fps_100Mbps_7200frames.h265

download-streams.sh $stream

echo "Running 8K HEVC-HEVC 1x1 transcoding using Intel Deep Link Hyper Encode with SMT (1 GPU node solution) for $stream stream..."

# get devices
devices=( $(ls /dev/dri/renderD*) )
ndevs=${#devices[@]}
if [[ $ndevs -lt 1 ]]; then
  echo "error: at least 1 /dev/dri/renderDn render node is needed for this example" >&2
  exit -1
fi

# encode
par=8k.hyperenc.1gpu.hevc.smt.par
log=$(basename $stream).hyperenc.1gpu.hevc.smt.log
output=$(basename $stream).hyperenc.1gpu.hevc.smt.h265
echo "-i::h265 $stream -device ${devices[0]} -async $async -o::sink -join -parallel_encoding -trace" > $par
echo "-i::source -join -async $async -u $preset -dist 8 -gop_size 30 -idr_interval 1 -vbr -b $bitrate -o::h265 $output" >> $par
echo "-i::source -join -async $async -u $preset -dist 8 -gop_size 30 -idr_interval 1 -vbr -b $bitrate -o::h265 /dev/null" >> $par
sample_multi_transcode -par $par | tee $log

wait
echo "Finished 8K HEVC-HEVC 1x1 transcoding using Intel Deep Link Hyper Encode with SMT (1 GPU node solution) for $stream stream"
cat $log | grep "session 0" | grep fps
