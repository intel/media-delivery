#
# Copyright (c) 2020 Intel Corporation
#
# Permission is hereby granted, free of charge, to any person obtaining 
# a copy of this software and associated documentation files (the 
# "Software"), to deal in the Software without restriction, including 
# without limitation the rights to use, copy, modify, merge, publish, 
# distribute, sublicense, and/or sell copies of the Software, and to 
# permit persons to whom the Software is furnished to do so, subject to 
# the following conditions:
#
# The above copyright notice and this permission notice shall be 
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

load utils

# subsample by 4
subs="ffmpeg -i \
  /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4 \
  -s 480x270 -sws_flags lanczos -vframes 100 WAR.mp4"

@test "bench quality transcode 65 frames and check artifacts" {
  run docker_run /bin/bash -c "set -ex; $subs; \
    bench quality --nframes 65 WAR.mp4; \
    cat /opt/data/artifacts/benchmark/quality/*{.metrics,bdrate} | wc -l"
  print_output
  [ $status -eq 0 ]
  [ "${lines[$((${#lines[@]}-1))]}" = "24" ]
}

# convert to yuv420
cyuv="ffmpeg -i WAR.mp4 \
  -c:v rawvideo -pix_fmt yuv420p -vsync passthrough WAR.yuv"

@test "bench quality encode 5 frames" {
  run docker_run /bin/bash -c "set -ex; $subs; $cyuv; \
    bench quality -w 480 -h 270 -f 24 \
    --nframes 5 --skip-metrics --skip-bdrate \
    WAR.yuv; \
    ls /opt/data/artifacts/benchmark/quality/ | wc -l"
  print_output
  [ $status -eq 0 ]
  [ "${lines[$((${#lines[@]}-1))]}" = "30" ]
}

# mock ParkScene: subsample to 720p
subs2="ffmpeg -i \
  /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4 \
  -s 1280x720 -sws_flags lanczos -vframes 240 ParkScene.mp4"

# mock ParkScene: convert to yuv
cyuv2="ffmpeg -i ParkScene.mp4 -c:v rawvideo -pix_fmt yuv420p \
  -vsync passthrough ParkScene_1280x720_24.yuv"

@test "bench quality --codec AVC encode 5 frames of a predefined stream" {
  run docker_run /bin/bash -c "set -ex; $subs2; $cyuv2; \
    bench quality --nframes 5 --skip-metrics --skip-bdrate \
    ParkScene_1280x720_24.yuv; \
    ls /opt/data/artifacts/benchmark/quality/ | wc -l"
  print_output
  [ $status -eq 0 ]
  [ "${lines[$((${#lines[@]}-1))]}" = "30" ]
}

@test "bench quality --codec HEVC encode 5 frames of a predefined stream" {
  run docker_run /bin/bash -c "set -ex; $subs2; $cyuv2; \
    bench quality --codec HEVC --nframes 5 --skip-metrics --skip-bdrate \
    ParkScene_1280x720_24.yuv; \
    ls /opt/data/artifacts/benchmark/quality/ | wc -l"
  print_output
  [ $status -eq 0 ]
  [ "${lines[$((${#lines[@]}-1))]}" = "30" ]
}

