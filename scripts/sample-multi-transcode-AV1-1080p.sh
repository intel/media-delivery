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

bitrate=${BITRATE:-3000}
preset=${PRESET:-veryfast}
async=${ASYNC:-1}
stream=bbb_sunflower_1080p_60fps_4Mbps_38kframes_av1.ivf

# process cmdline options
nstreams=$1
if [[ -z "$1" ]]; then
  echo $(basename $0) "<num-of-streams> [<stream>]"
  exit 0
fi
! [[ -z "$2" ]] && stream=$2
! [[ -e $stream ]] && download-streams.sh $stream

echo "Running 1080p AV1-AV1 1x$nstreams transcoding with SMT for $stream stream..."

# get devices
devices=( $(ls /dev/dri/renderD*) )
ndevs=${#devices[@]}
echo "Number of detected devices: $ndevs"

# set output
output="/dev/null"
[[ $nstreams = 1 ]] && output="$(basename $stream).av1.smt.ivf"

# encode loop
for ((i=0; i<$nstreams; i++)); do

  device="${devices[((i % ndevs))]}"

  sample_multi_transcode -device $device -i::av1 $stream -hw -async $async -u $preset -n 6000 -gop_size 256 -vbr \
    -b $bitrate -NalHrdConformance:off -VuiNalHrdParameters:off -bref -hrd $((bitrate / 2)) -InitialDelayInKB $((bitrate / 4)) \
    -dist 8 -lowpower:on -o::av1 $output 2>&1 | tee $(basename $stream).${nstreams}.${i}.dev$((i % ndevs)).av1.smt.log &

done

wait
echo "Finished 1080p AV1-AV1 1x$nstreams transcoding with SMT for $stream stream"
cat $(basename $stream).${nstreams}.*.dev*.av1.smt.log | grep PASSED | grep fps
