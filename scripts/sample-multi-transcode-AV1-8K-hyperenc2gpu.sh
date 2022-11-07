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
stream=dweebs_7680x4320_yuv420p_60fps_100Mbps_7200frames_av1.ivf

download-streams.sh $stream

echo "Running 8K AV1-AV1 1x1 transcoding using Intel Deep Link Hyper Encode with SMT (2 GPU node solution) for $stream stream..."

# get devices
devices=( $(ls /dev/dri/renderD*) )
ndevs=${#devices[@]}
if [[ $ndevs -lt 2 ]]; then
  echo "error: at least 2 /dev/dri/renderDn render nodes are needed for this example" >&2
  exit -1
fi

# encode
par=8k.hyperenc.2gpu.av1.smt.par
log=$(basename $stream).hyperenc.2gpu.av1.smt.log
output=$(basename $stream).hyperenc.2gpu.av1.smt.av1
echo "-i::av1 $stream -device ${devices[0]} -async $async -u $preset -dist 8 -gop_size 60 -idr_interval 1 -vbr -b $bitrate -o::av1 $output -parallel_encoding -trace" > $par
echo "-i::av1 $stream -device ${devices[1]} -async $async -u $preset -dist 8 -gop_size 60 -idr_interval 1 -vbr -b $bitrate -o::av1 /dev/null" >> $par
sample_multi_transcode -par $par | tee $log

wait
echo "Finished 8K AV1-AV1 1x1 transcoding using Intel Deep Link Hyper Encode with SMT (2 GPU node solution) for $stream stream"
cat $log | grep "session 0" | grep fps
