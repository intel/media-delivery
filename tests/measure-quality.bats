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

@test "measure quality: transcode 50 frames, calculate metrics, measure bdrate and check measuring artifacts" {
  run docker_run /bin/bash -c "set -ex; $subs; \
    measure quality --nframes 50 --bitrates 0.1:0.2:0.3:0.4:0.5 WAR.mp4; \
    result=\$(cat ${ARTIFACTS}/measure/quality/*{.metrics,bdrate} | grep -v :: | wc -l); \
    [[ \$result = 24 ]]"
  print_output
  [ $status -eq 0 ]
}

# convert to 10bit HEVC mp4
getmp4hevc10b="ffmpeg -i WAR.mp4 \
  -pix_fmt p010le -c:v libx265 -preset medium -b:v 15M -fps_mode passthrough WAR_10bit.mp4"

@test "measure quality: transcode 50 frames of 10bit mp4 video, calculate metrics, measure bdrate and check measuring artifacts" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh HEVCMain10);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $getmp4hevc10b; \
    measure quality --pix-fmt p010le --codec HEVC --nframes 100 --bitrates 0.5:1:1.5:2:3 WAR_10bit.mp4; \
    result=\$(cat ${ARTIFACTS}/measure/quality/*{.metrics,bdrate} | grep -v :: | wc -l); \
    [[ \$result = 24 ]]"
  print_output
  [ $status -eq 0 ]
}

# convert to HEVC 4:2:2 mp4
getmp4hevc422="ffmpeg -i WAR.mp4 \
  -pix_fmt yuv422p -c:v libx265 -preset medium -b:v 15M -fps_mode passthrough WAR_422.mp4"

@test "measure quality: transcode 100 frames of 4:2:2 mp4 video via HEVC EncTools, calculate metrics, measure bdrate and check measuring artifacts" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh HEVCMain422_10);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $getmp4hevc422; \
    measure quality --pix-fmt yuv422p --codec HEVC --nframes 100 --use-enctools --enctools-lad 8 --bitrates 0.5:1:1.5:2:3 WAR_422.mp4; \
    result=\$(cat ${ARTIFACTS}/measure/quality/*{.metrics,bdrate} | grep -v :: | wc -l); \
    [[ \$result = 24 ]]"
  print_output
  [ $status -eq 0 ]
}

# convert to HEVC 10bit 4:2:2 mp4
getmp4hevc10b422="ffmpeg -i WAR.mp4 \
  -pix_fmt yuv422p10le -c:v libx265 -preset medium -b:v 15M -fps_mode passthrough WAR_10bit422.mp4"

@test "measure quality: transcode 100 frames of 10bit 4:2:2 mp4 video via HEVC EncTools, calculate metrics, measure bdrate and check measuring artifacts" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh HEVCMain422_10);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $getmp4hevc10b422; \
    measure quality --pix-fmt yuv422p10le --codec HEVC --nframes 100 --use-enctools --enctools-lad 8 --bitrates 0.5:1:1.5:2:3 WAR_10bit422.mp4; \
    result=\$(cat ${ARTIFACTS}/measure/quality/*{.metrics,bdrate} | grep -v :: | wc -l); \
    [[ \$result = 24 ]]"
  print_output
  [ $status -eq 0 ]
}

# convert to yuv420
cyuv="ffmpeg -i WAR.mp4 \
  -c:v rawvideo -pix_fmt yuv420p -fps_mode passthrough WAR.yuv"

@test "measure quality: encode 5 frames of a user-defined YUV video with AVC" {
  run docker_run /bin/bash -c "set -ex; $subs; $cyuv; \
    measure quality -w 480 -h 270 -f 24 \
    --nframes 5 --skip-metrics --skip-bdrate \
    WAR.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: encode 5 frames of a user-defined YUV video with HEVC" {
  run docker_run /bin/bash -c "set -ex; $subs; $cyuv; \
    measure quality -w 480 -h 270 -f 24 \
    --codec HEVC --nframes 5 --skip-metrics --skip-bdrate \
    WAR.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: encode 5 frames of a user-defined YUV video with AV1" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $cyuv; \
    measure quality -w 480 -h 270 -f 24 \
    --codec AV1 --nframes 5 --skip-metrics --skip-bdrate \
    WAR.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

# mock ParkScene: subsample to 720p
subs2="ffmpeg -i \
  /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4 \
  -s 1280x720 -sws_flags lanczos -vframes 240 ParkScene.mp4"

# mock ParkScene: convert to yuv
cyuv2="ffmpeg -i ParkScene.mp4 -c:v rawvideo -pix_fmt yuv420p \
  -fps_mode passthrough ParkScene_1280x720_24.yuv"

@test "measure quality: encode 5 frames of a predefined YUV video with AVC" {
  run docker_run /bin/bash -c "set -ex; $subs2; $cyuv2; \
    measure quality --nframes 5 --skip-metrics --skip-bdrate \
    ParkScene_1280x720_24.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: encode 5 frames of a predefined YUV video with HEVC" {
  run docker_run /bin/bash -c "set -ex; $subs2; $cyuv2; \
    measure quality --codec HEVC --nframes 5 --skip-metrics --skip-bdrate \
    ParkScene_1280x720_24.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

# mock BalloonFestival: subsample to 1080p
cyuv210b="ffmpeg -i /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4 -c:v rawvideo -pix_fmt p010le \
  -vframes 240 -fps_mode passthrough BalloonFestival_1920x1080p_25_10b_pq_709_ct2020_p010le.yuv"

@test "measure quality: encode 5 frames of a predefined YUV 10bit video with HEVC" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh HEVCMain10);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $cyuv210b; \
    measure quality --codec HEVC --pix-fmt p010le --nframes 5 --skip-metrics --skip-bdrate \
    BalloonFestival_1920x1080p_25_10b_pq_709_ct2020_p010le.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: encode 5 frames of a predefined YUV video with AV1" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs2; $cyuv2; \
    measure quality --codec AV1 --nframes 5 --skip-metrics --skip-bdrate \
    ParkScene_1280x720_24.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

# get raw H.264 stream from an mp4 container
get264="ffmpeg -i WAR.mp4 -vcodec copy -an WAR.h264"

@test "measure quality: transcode 5 frames of a user-defined raw H.264 video stream into AVC stream" {
  run docker_run /bin/bash -c "set -ex; $subs; $get264; \
    measure quality --nframes 5 --skip-metrics --skip-bdrate \
    WAR.h264; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw H.264 video stream into HEVC stream" {
  run docker_run /bin/bash -c "set -ex; $subs; $get264; \
    measure quality --codec HEVC --nframes 5 --skip-metrics --skip-bdrate \
    WAR.h264; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw H.264 video stream into AV1 stream" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $get264; \
    measure quality --codec AV1 --nframes 5 --skip-metrics --skip-bdrate \
    WAR.h264; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

# get raw HEVC stream from an mp4 container
get265="ffmpeg -i WAR.mp4 -y -vframes 5 -c:v libx265 -preset medium -b:v 15M -fps_mode passthrough WAR.h265"

@test "measure quality: transcode 5 frames of a user-defined raw HEVC video stream into AVC stream" {
  run docker_run /bin/bash -c "set -ex; $subs; $get265; \
    measure quality --nframes 5 --skip-metrics --skip-bdrate \
    WAR.h265; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw HEVC video stream into HEVC stream" {
  run docker_run /bin/bash -c "set -ex; $subs; $get265; \
    measure quality --codec HEVC --nframes 5 --skip-metrics --skip-bdrate \
    WAR.h265; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

# get raw HEVC 10bit stream from an mp4 container
get26510b="ffmpeg -i WAR_10bit.mp4 -y -vframes 5 -c:v libx265 -preset medium -b:v 15M -fps_mode passthrough WAR_10bit.h265"

@test "measure quality: transcode 5 frames of a user-defined raw HEVC 10bit video stream into HEVC 10bit stream" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh HEVCMain10);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $getmp4hevc10b; $get26510b; \
    measure quality --codec HEVC --nframes 5 --pix-fmt p010le --skip-metrics --skip-bdrate \
    WAR_10bit.h265; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

# get raw HEVC 4:2:2 stream from an mp4 container
get265422="ffmpeg -i WAR_422.mp4 -y -vframes 5 -c:v libx265 -preset medium -b:v 15M -fps_mode passthrough WAR_422.h265"

@test "measure quality: transcode 5 frames of a user-defined raw HEVC 4:2:2 video stream via HEVC EncTools into HEVC 4:2:2 stream" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh HEVCMain422_10);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $getmp4hevc422; $get265422; \
    measure quality --codec HEVC --nframes 5 --pix-fmt yuv422p --skip-metrics --skip-bdrate --use-enctools --enctools-lad 8 \
    WAR_422.h265; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

# get raw HEVC 10bit 4:2:2 stream from an mp4 container
get26510b422="ffmpeg -i WAR_10bit422.mp4 -y -vframes 5 -c:v libx265 -preset medium -b:v 15M -fps_mode passthrough WAR_10bit422.h265"

@test "measure quality: transcode 5 frames of a user-defined raw HEVC 10bit 4:2:2 video stream via EncTools into HEVC 10bit 4:2:2 stream" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh HEVCMain422_10);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $getmp4hevc10b422; $get26510b422; \
    measure quality --codec HEVC --nframes 5 --pix-fmt yuv422p10le --skip-metrics --skip-bdrate --use-enctools --enctools-lad 8 \
    WAR_10bit422.h265; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw HEVC video stream into AV1 stream" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $get265; \
    measure quality --codec AV1 --nframes 5 --skip-metrics --skip-bdrate \
    WAR.h265; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

# get raw AV1 stream from an mp4 container
getav1="ffmpeg -hwaccel qsv -qsv_device $DEVICE -i WAR.mp4 -y -vframes 5 -c:v av1_qsv -preset medium -b:v 15M -fps_mode passthrough WAR.ivf "

@test "measure quality: transcode 5 frames of a user-defined raw AV1 video stream into AV1 stream" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $getav1; \
    measure quality --codec AV1 --nframes 5 --skip-metrics --skip-bdrate \
    WAR.ivf; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 20 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: encode 5 frames of a YUV video with AVC in low power mode (VDENC)" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh H264High);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $cyuv; \
    measure quality -w 480 -h 270 -f 24 \
    --nframes 5 --skip-metrics --skip-bdrate --use-vdenc \
    WAR.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: encode 5 frames of a YUV video with HEVC in low power mode (VDENC)" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh HEVCMain);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $cyuv; \
    measure quality -w 480 -h 270 -f 24 \
    --codec HEVC --nframes 5 --skip-metrics --skip-bdrate --use-vdenc \
    WAR.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: encode 5 frames of a YUV video with AVC encTools" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $cyuv; \
    measure quality -w 480 -h 270 -f 24 \
    --nframes 5 --skip-metrics --skip-bdrate --use-enctools \
    WAR.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: encode 5 frames of a YUV video with HEVC encTools" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $cyuv; \
    measure quality -w 480 -h 270 -f 24 \
    --codec HEVC --nframes 5 --skip-metrics --skip-bdrate --use-enctools \
    WAR.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

# get 10bit yuv from mp4
cyuv10b="ffmpeg -i WAR.mp4 \
  -c:v rawvideo -pix_fmt p010le -fps_mode passthrough WAR_10bit.yuv"

@test "measure quality: encode 5 frames of a YUV 10bit video with HEVC encTools" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh HEVCMain10);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $cyuv10b; \
    measure quality -w 480 -h 270 --pix-fmt p010le -f 24 \
    --codec HEVC --nframes 5 --skip-metrics --skip-bdrate --use-enctools \
    WAR_10bit.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

# get yuv422 from mp4
cyuv422="ffmpeg -i WAR.mp4 \
  -c:v rawvideo -pix_fmt yuv422p -fps_mode passthrough WAR_422.yuv"

@test "measure quality: encode 5 frames of a YUV 4:2:2 video with HEVC encTools" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh HEVCMain422_10);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $cyuv422; \
    measure quality -w 480 -h 270 --pix-fmt yuv422p -f 24 \
    --codec HEVC --nframes 5 --skip-metrics --skip-bdrate --use-enctools --enctools-lad 8 \
    WAR_422.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 20 ]]"
  print_output
  [ $status -eq 0 ]
}

# get 10bit yuv422 from mp4
cyuv10b422="ffmpeg -i WAR.mp4 \
  -c:v rawvideo -pix_fmt yuv422p10le -fps_mode passthrough WAR_10bit422.yuv"

@test "measure quality: encode 5 frames of a YUV 4:2:2 10bit video with HEVC encTools" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh HEVCMain422_10);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $cyuv10b422; \
    measure quality -w 480 -h 270 --pix-fmt yuv422p10le -f 24 \
    --codec HEVC --nframes 5 --skip-metrics --skip-bdrate --use-enctools --enctools-lad 8 \
    WAR_10bit422.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 20 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: encode 5 frames of a YUV video with AV1 encTools" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $cyuv; \
    measure quality -w 480 -h 270 -f 24 \
    --codec AV1 --nframes 5 --skip-metrics --skip-bdrate --use-enctools \
    WAR.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw H.264 video stream into AVC stream using encTools" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $get264; \
    measure quality --nframes 5 --skip-metrics --skip-bdrate --use-enctools \
    WAR.h264; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw H.264 video stream into HEVC stream using encTools" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $get264; \
    measure quality --codec HEVC --nframes 5 --skip-metrics --skip-bdrate --use-enctools \
    WAR.h264; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw H.264 video stream into AV1 stream using encTools" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $get264; \
    measure quality --codec AV1 --nframes 5 --skip-metrics --skip-bdrate --use-enctools \
    WAR.h264; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw HEVC video stream into AVC stream using encTools" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $get265; \
    measure quality --nframes 5 --skip-metrics --skip-bdrate --use-enctools \
    WAR.h265; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw HEVC video stream into HEVC stream using encTools" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $get265; \
    measure quality --codec HEVC --nframes 5 --skip-metrics --skip-bdrate --use-enctools \
    WAR.h265; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw HEVC video stream into AV1 stream using encTools" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $get265; \
    measure quality --codec AV1 --nframes 5 --skip-metrics --skip-bdrate --use-enctools \
    WAR.h265; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 30 ]]"
  print_output
  [ $status -eq 0 ]
}

#low-delay
@test "measure quality: encode 5 frames of a user-defined YUV video with AVC in low-delay mode" {
  run docker_run /bin/bash -c "set -ex; $subs; $cyuv; \
    measure quality -w 480 -h 270 -f 24 --use-lowdelay \
    --nframes 5 --skip-metrics --skip-bdrate \
    WAR.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 15 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: encode 5 frames of a user-defined YUV video with HEVC in low-delay mode" {
  run docker_run /bin/bash -c "set -ex; $subs; $cyuv; \
    measure quality -w 480 -h 270 -f 24 --use-lowdelay \
    --codec HEVC --nframes 5 --skip-metrics --skip-bdrate \
    WAR.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 15 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: encode 5 frames of a user-defined YUV video with AV1 in low-delay mode" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $cyuv; \
    measure quality -w 480 -h 270 -f 24 --use-lowdelay \
    --codec AV1 --nframes 5 --skip-metrics --skip-bdrate \
    WAR.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 15 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: encode 5 frames of a predefined YUV video with AVC in low-delay mode" {
  run docker_run /bin/bash -c "set -ex; $subs2; $cyuv2; \
    measure quality --nframes 5 --use-lowdelay --skip-metrics --skip-bdrate \
    ParkScene_1280x720_24.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 15 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: encode 5 frames of a predefined YUV video with HEVC in low-delay mode" {
  run docker_run /bin/bash -c "set -ex; $subs2; $cyuv2; \
    measure quality --codec HEVC --use-lowdelay --nframes 5 --skip-metrics --skip-bdrate \
    ParkScene_1280x720_24.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 15 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: encode 5 frames of a predefined YUV video with AV1 in low-delay mode" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs2; $cyuv2; \
    measure quality --codec AV1 --nframes 5 --use-lowdelay --skip-metrics --skip-bdrate \
    ParkScene_1280x720_24.yuv; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 15 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw H.264 video stream into AVC stream in low-delay mode" {
  run docker_run /bin/bash -c "set -ex; $subs; $get264; \
    measure quality --nframes 5 --use-lowdelay --skip-metrics --skip-bdrate \
    WAR.h264; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 15 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw H.264 video stream into HEVC stream in low-delay mode" {
  run docker_run /bin/bash -c "set -ex; $subs; $get264; \
    measure quality --codec HEVC --nframes 5 --use-lowdelay --skip-metrics --skip-bdrate \
    WAR.h264; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 15 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw H.264 video stream into AV1 stream in low-delay mode" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $get264; \
    measure quality --codec AV1 --nframes 5 --use-lowdelay --skip-metrics --skip-bdrate \
    WAR.h264; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 15 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw HEVC video stream into AVC stream in low-delay mode" {
  run docker_run /bin/bash -c "set -ex; $subs; $get265; \
    measure quality --nframes 5 --use-lowdelay --skip-metrics --skip-bdrate \
    WAR.h265; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 15 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw HEVC video stream into HEVC stream in low-delay mode" {
  run docker_run /bin/bash -c "set -ex; $subs; $get265; \
    measure quality --codec HEVC --nframes 5 --use-lowdelay --skip-metrics --skip-bdrate \
    WAR.h265; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 15 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw HEVC video stream into AV1 stream in low-delay mode" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $get265; \
    measure quality --codec AV1 --nframes 5 --use-lowdelay --skip-metrics --skip-bdrate \
    WAR.h265; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 15 ]]"
  print_output
  [ $status -eq 0 ]
}

@test "measure quality: transcode 5 frames of a user-defined raw AV1 video stream into AV1 stream in low-delay mode" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $subs; $getav1; \
    measure quality --codec AV1 --nframes 5 --use-lowdelay --skip-metrics --skip-bdrate \
    WAR.ivf; \
    result=\$(find ${ARTIFACTS}/measure/quality/ -not -empty -type f -ls | wc -l); \
    [[ \$result = 10 ]]"
  print_output
  [ $status -eq 0 ]
}
