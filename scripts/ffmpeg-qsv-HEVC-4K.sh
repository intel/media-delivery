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

bitrate=${BITRATE:-6000000}
preset=${PRESET:-veryfast}
async=${ASYNC:-2}
stream=bbb_sunflower_2160p_60fps_8Mbps_38kframes.h265

# process cmdline options
nstreams=$1
if [[ -z "$1" ]]; then
  echo $(basename $0) "<num-of-streams> [<stream>]"
  exit 0
fi
! [[ -z "$2" ]] && stream=$2
! [[ -e $stream ]] && download-streams.sh $stream

echo "Running 4K HEVC-HEVC 1x$nstreams transcoding with QSV for $stream stream..."

# get devices
devices=( $(ls /dev/dri/renderD*) )
ndevs=${#devices[@]}
echo "Number of detected devices: $ndevs"

# set output
output="-f null -"
[[ $nstreams = 1 ]] && output="$(basename $stream).hevc.qsv.h265"

# encode loop
for ((i=0; i<$nstreams; i++)); do

  device="${devices[((i % ndevs))]}"

  ffmpeg -y -hwaccel qsv -qsv_device $device -extra_hw_frames 8 -c:v hevc_qsv -i $stream \
    -c:v hevc_qsv -preset $preset -vframes 6000 -profile:v main -async_depth $async -b:v $bitrate \
    -maxrate $((bitrate * 2)) -bufsize $((bitrate * 4)) -rc_init_occupancy $((bitrate * 2)) \
    -low_power true -look_ahead_depth 8 -extbrc 1 -b_strategy 1 -bf 7 -refs 4 -g 256 -idr_interval begin_only \
    -strict -1 -vsync passthrough $output 2>&1 | tee $(basename $stream).${nstreams}.${i}.dev$((i % ndevs)).hevc.qsv.log &

done

wait
reset && clear
echo "Finished 4K HEVC-HEVC 1x$nstreams transcoding with QSV for $stream stream"
cat $(basename $stream).${nstreams}.*.dev*.hevc.qsv.log | grep fps=
