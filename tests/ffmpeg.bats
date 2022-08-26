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

load utils

###############################
# AVC-AVC long transcoding test
###############################
xcode_avc_avc="ffmpeg -y -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v h264_qsv \
    -i /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4 -c:a copy \
    -c:v h264_qsv -profile:v high -preset medium -async_depth 1 \
    -b:v 3000000 -maxrate 6000000 -bufsize 12000000 -rc_init_occupancy 6000000 \
    -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -g 256 -strict -1 -bitrate_limit 0 WAR_audio_avc.mp4"

@test "ffmpeg-qsv avc-avc transcoding: transcode long sequence avc-avc using ffmpeg-qsv" {
  run docker_run /bin/bash -c "set -ex; $xcode_avc_avc; \
  result=\$(ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=nb_read_packets -of csv=p=0 WAR_audio_avc.mp4); \
  [[ \$result = 3443 ]]"
  print_output
  [ $status -eq 0 ]
}

################################
# AVC-HEVC long transcoding test
################################
xcode_avc_hevc="ffmpeg -y -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v h264_qsv \
    -i /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4 -c:a copy \
    -c:v hevc_qsv -profile:v main -preset medium -async_depth 1 \
    -b:v 3000000 -maxrate 6000000 -bufsize 12000000 -rc_init_occupancy 6000000 \
    -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -g 256 -strict -1 WAR_audio_hevc.mp4"

@test "ffmpeg-qsv avc-hevc transcoding: transcode long sequence avc-hevc using ffmpeg-qsv" {
  run docker_run /bin/bash -c "set -ex; $xcode_avc_hevc; \
  result=\$(ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=nb_read_packets -of csv=p=0 WAR_audio_hevc.mp4); \
  [[ \$result = 3443 ]]"
  print_output
  [ $status -eq 0 ]
}

########################################
# AVC-AVC long encTools transcoding test
########################################
xcode_avc_avc_et="ffmpeg -y -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v h264_qsv -extra_hw_frames 64 \
    -i /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4 -c:a copy \
    -c:v h264_qsv -profile:v high -preset medium -async_depth 1 \
    -b:v 3000000 -maxrate 6000000 -bufsize 12000000 -rc_init_occupancy 6000000 \
    -look_ahead_depth 8 -extbrc 1 -b_strategy 1 -adaptive_i 1 -adaptive_b 1 \
    -bf 7 -refs 5 -g 256 -strict -1 -bitrate_limit 0 WAR_audio_avc_et.mp4"

@test "ffmpeg-qsv avc-avc transcoding: transcode long sequence avc-avc using ffmpeg-qsv with encTools" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $xcode_avc_avc_et; \
  result=\$(ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=nb_read_packets -of csv=p=0 WAR_audio_avc_et.mp4); \
  [[ \$result = 3443 ]]"
  print_output
  [ $status -eq 0 ]
}

#########################################
# AVC-HEVC long encTools transcoding test
#########################################
xcode_avc_hevc_et="ffmpeg -y -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v h264_qsv -extra_hw_frames 64 \
    -i /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4 -c:a copy \
    -c:v hevc_qsv -profile:v main -preset medium -async_depth 1 \
    -b:v 3000000 -maxrate 6000000 -bufsize 12000000 -rc_init_occupancy 6000000 \
    -look_ahead_depth 8 -extbrc 1 -b_strategy 1 \
    -bf 7 -refs 5 -g 256 -strict -1 WAR_audio_hevc_et.mp4"

@test "ffmpeg-qsv avc-hevc transcoding: transcode long sequence avc-hevc using ffmpeg-qsv with encTools" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $xcode_avc_hevc_et; \
  result=\$(ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=nb_read_packets -of csv=p=0 WAR_audio_hevc_et.mp4); \
  [[ \$result = 3443 ]]"
  print_output
  [ $status -eq 0 ]
}

###############################
# AVC-AV1 long transcoding test
###############################
xcode_avc_av1="ffmpeg -y -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v h264_qsv \
    -i /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4 -c:a copy \
    -c:v av1_qsv -profile:v main -preset medium -async_depth 1 \
    -b:v 3000000 -maxrate 6000000 -bufsize 12000000 -rc_init_occupancy 6000000 \
    -b_strategy 1 -bf 7 -g 256 WAR_audio_av1.mp4"

@test "ffmpeg-qsv avc-av1 transcoding: transcode long sequence avc-av1 using ffmpeg-qsv" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run /bin/bash -c "set -ex; $xcode_avc_av1; \
  result=\$(ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=nb_read_packets -of csv=p=0 WAR_audio_av1.mp4); \
  [[ \$result = 3443 ]]"
  print_output
  [ $status -eq 0 ]
}
