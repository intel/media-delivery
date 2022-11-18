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

@test "measure perf nosuchfile.h264" {
  run docker_run measure perf nosuchfile.h264
  print_output
  [ $status -ne 0 ]
}

# prepare raw 2160p h264 file, high resolution and fps=60 is needed to
# reduce test time
rawh264="ffmpeg -an -hwaccel qsv -qsv_device $DEVICE \
  -c:v h264_qsv -i /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4 \
  -vf scale_qsv=w=-1:h=2160,vpp_qsv=framerate=60 \
  -c:v h264_qsv -preset medium -profile:v high -b:v 1000000 -vframes 20 \
  -y /tmp/WAR.h264"

# prepare raw 2160p hevc file, high resolution and fps=60 is needed to
# reduce test time
rawh265="ffmpeg -an -hwaccel qsv -qsv_device $DEVICE \
  -c:v h264_qsv -i /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4 \
  -vf scale_qsv=w=-1:h=2160,vpp_qsv=framerate=60 \
  -c:v hevc_qsv -preset medium -profile:v main -b:v 1000000 -vframes 20 \
  -y /tmp/WAR.hevc"

# prepare raw AV1 stream from an mp4 container
rawav1="ffmpeg -hwaccel qsv -qsv_device $DEVICE \
  -i /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4 -y -vframes 20 \
  -c:v av1_qsv -preset medium -b:v 15M -vsync 0 /tmp/WAR.ivf "

# add mp4 file for mp4 check out
submp4="ffmpeg -i \
  /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4 \
  -vframes 20 /tmp/WAR_20fr.mp4"

# Container creates artifacts under container user and host user (if not
# 'root'), can't delete them. We change permissions to the artifacts to
# allow full access to anyone.
function get_test_body() {
    local ffcmd=$1
    local bcmd=$2
    echo "set -ex; $ffcmd; $bcmd;"
}

function get_perf_opts() {
  local tmp=$1
  local opts="-u $(id -u):$(id -g)"
  if [[ "$(cat /proc/sys/kernel/perf_event_paranoid)" -ge 1 ]]; then
    opts+=" --read-only"
  else
    opts+=" $(get_security_opts)"
  fi
  opts+=" -v $tmp:${ARTIFACTS}"
  echo "$opts $(get_mounts $opts)"
}

@test "measure perf raw h264" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawh264" "measure perf /tmp/WAR.h264")"
  print_output
  if ! kernel_ge_4_16; then
    [ $status -ne 0 ]
  else
    [ $status -eq 0 ]

    ptmp=$tmp/measure/perf
    nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nlines=$(cat $ptmp/msperf_FFMPEG_AVC-AVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ] # we expect header and result lines
    nlines=$(cat $ptmp/msperf_FFMPEG_AVC-HEVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/msperf_SMT_AVC-AVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/msperf_SMT_AVC-HEVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    npng=$(find $ptmp -name "*.png" | wc -l)
    [ "$npng" -ge 4 ] # we should have at least one picture for each performance
  fi
}

@test "measure perf raw h265" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawh265" "measure perf /tmp/WAR.hevc")"
  print_output
  if ! kernel_ge_4_16; then
    [ $status -ne 0 ]
  else
    [ $status -eq 0 ]

    ptmp=$tmp/measure/perf
    nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nlines=$(cat $ptmp/msperf_FFMPEG_HEVC-AVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ] # we expect header and result lines
    nlines=$(cat $ptmp/msperf_FFMPEG_HEVC-HEVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/msperf_SMT_HEVC-AVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/msperf_SMT_HEVC-HEVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    npng=$(find $ptmp -name "*.png" | wc -l)
    [ "$npng" -ge 4 ] # we should have at least one picture for each performance
  fi
}

@test "measure perf raw av1" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawav1" "measure perf /tmp/WAR.ivf")"
  print_output
  if ! kernel_ge_4_16; then
    [ $status -ne 0 ]
  else
    [ $status -eq 0 ]

    ptmp=$tmp/measure/perf
    nout=$(find $ptmp/output_SMT -name "*.ivf" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_FFMPEG -name "*.ivf" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nlines=$(cat $ptmp/msperf_FFMPEG_AV1-AV1_performance.csv | wc -l)
    [ "$nlines" -eq 2 ] # we expect header and result lines
    npng=$(find $ptmp -name "*.png" | wc -l)
    [ "$npng" -ge 4 ] # we should have at least one picture for each performance
  fi
}

@test "measure perf raw h264 with AVC Enc Tools" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawh264" "measure perf --use-enctools /tmp/WAR.h264")"
  print_output
  if ! kernel_ge_4_16; then
    [ $status -ne 0 ]
  else
    [ $status -eq 0 ]

    ptmp=$tmp/measure/perf
    nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nlines=$(cat $ptmp/msperf_FFMPEG_AVC-AVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ] # we expect header and result lines
    nlines=$(cat $ptmp/msperf_FFMPEG_AVC-HEVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/msperf_SMT_AVC-AVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/msperf_SMT_AVC-HEVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    npng=$(find $ptmp -name "*.png" | wc -l)
    [ "$npng" -ge 4 ] # we should have at least one picture for each performance
  fi
}

@test "measure perf raw h265 with HEVC Enc Tools" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawh265" "measure perf --use-enctools /tmp/WAR.hevc")"
  print_output
  if ! kernel_ge_4_16; then
    [ $status -ne 0 ]
  else
    [ $status -eq 0 ]

    ptmp=$tmp/measure/perf
    nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nlines=$(cat $ptmp/msperf_FFMPEG_HEVC-AVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ] # we expect header and result lines
    nlines=$(cat $ptmp/msperf_FFMPEG_HEVC-HEVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/msperf_SMT_HEVC-AVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/msperf_SMT_HEVC-HEVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    npng=$(find $ptmp -name "*.png" | wc -l)
    [ "$npng" -ge 4 ] # we should have at least one picture for each performance
  fi
}

@test "measure perf raw av1 with AV1 Enc Tools" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0); \
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawav1" "measure perf --use-enctools /tmp/WAR.ivf")"
  print_output
  if ! kernel_ge_4_16; then
    [ $status -ne 0 ]
  else
    [ $status -eq 0 ]

    ptmp=$tmp/measure/perf
    nout=$(find $ptmp/output_SMT -name "*.ivf" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_FFMPEG -name "*.ivf" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nlines=$(cat $ptmp/msperf_SMT_AV1-AV1_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    npng=$(find $ptmp -name "*.png" | wc -l)
    [ "$npng" -ge 4 ] # we should have at least one picture for each performance
  fi
}

@test "measure perf raw h264 with AVC Enc Tools with customized Look Ahead" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawh264" "measure perf --use-enctools --enctools-lad 40 /tmp/WAR.h264")"
  print_output
  if ! kernel_ge_4_16; then
    [ $status -ne 0 ]
  else
    [ $status -eq 0 ]

    ptmp=$tmp/measure/perf
    nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nlines=$(cat $ptmp/msperf_FFMPEG_AVC-AVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ] # we expect header and result lines
    nlines=$(cat $ptmp/msperf_FFMPEG_AVC-HEVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/msperf_SMT_AVC-AVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/msperf_SMT_AVC-HEVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    npng=$(find $ptmp -name "*.png" | wc -l)
    [ "$npng" -ge 4 ] # we should have at least one picture for each performance
  fi
}

@test "measure perf raw h265 with HEVC Enc Tools with customized Look Ahead" {
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawh265" "measure perf --use-enctools --enctools-lad 40 /tmp/WAR.hevc")"
  print_output
  if ! kernel_ge_4_16; then
    [ $status -ne 0 ]
  else
    [ $status -eq 0 ]

    ptmp=$tmp/measure/perf
    nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nlines=$(cat $ptmp/msperf_FFMPEG_HEVC-AVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ] # we expect header and result lines
    nlines=$(cat $ptmp/msperf_FFMPEG_HEVC-HEVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/msperf_SMT_HEVC-AVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/msperf_SMT_HEVC-HEVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    npng=$(find $ptmp -name "*.png" | wc -l)
    [ "$npng" -ge 4 ] # we should have at least one picture for each performance
  fi
}

@test "measure perf raw av1 with AV1 Enc Tools with customized Look Ahead" {
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh AV1Profile0); \
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  if ! [[ "$TEST_ENCTOOLS" =~ ^(on|ON) ]]; then skip; fi
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawav1" "measure perf --use-enctools --enctools-lad 40 /tmp/WAR.ivf")"
  print_output
  if ! kernel_ge_4_16; then
    [ $status -ne 0 ]
  else
    [ $status -eq 0 ]

    ptmp=$tmp/measure/perf
    nout=$(find $ptmp/output_SMT -name "*.ivf" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder

    nout=$(find $ptmp/output_FFMPEG -name "*.ivf" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder

    nlines=$(cat $ptmp/msperf_FFMPEG_AV1-AV1_performance.csv | wc -l)
    [ "$nlines" -eq 2 ] # we expect header and result lines
    nlines=$(cat $ptmp/msperf_SMT_AV1-AV1_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    npng=$(find $ptmp -name "*.png" | wc -l)
    [ "$npng" -ge 4 ] # we should have at least one picture for each performance
  fi
}

@test "measure perf --skip-perf raw h264" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawh264" "measure perf --skip-perf /tmp/WAR.h264")"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/measure/perf
  nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nlines=$(cat $ptmp/msperf_FFMPEG_AVC-AVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ] # we expect header and result lines
  nlines=$(cat $ptmp/msperf_FFMPEG_AVC-HEVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nlines=$(cat $ptmp/msperf_SMT_AVC-AVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nlines=$(cat $ptmp/msperf_SMT_AVC-HEVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  npng=$(find $ptmp -name "*.png" | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}

@test "measure perf --skip-perf --use-vdenc --codec AVC raw h264" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh H264High);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawh264" "measure perf --skip-perf --use-vdenc --codec AVC /tmp/WAR.h264")"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/measure/perf
  nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nlines=$(cat $ptmp/msperf_SMT_AVC-AVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nlines=$(cat $ptmp/msperf_FFMPEG_AVC-AVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  npng=$(find $ptmp -name "*.png" | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}

@test "measure perf --skip-perf --use-vdenc --codec HEVC raw h264" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh HEVCMain);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawh264" "measure perf --skip-perf --use-vdenc --codec HEVC /tmp/WAR.h264")"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/measure/perf
  nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nlines=$(cat $ptmp/msperf_SMT_AVC-HEVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nlines=$(cat $ptmp/msperf_FFMPEG_AVC-HEVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  npng=$(find $ptmp -name "*.png" | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}

@test "measure perf --skip-perf raw h265" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawh265" "measure perf --skip-perf /tmp/WAR.hevc")"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/measure/perf
  nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nlines=$(cat $ptmp/msperf_FFMPEG_HEVC-AVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ] # we expect header and result lines
  nlines=$(cat $ptmp/msperf_FFMPEG_HEVC-HEVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nlines=$(cat $ptmp/msperf_SMT_HEVC-AVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nlines=$(cat $ptmp/msperf_SMT_HEVC-HEVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  npng=$(find $ptmp -name "*.png" | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}

@test "measure perf --skip-perf --use-vdenc --codec AVC raw h265" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh H264High);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawh265" "measure perf --skip-perf --use-vdenc --codec AVC /tmp/WAR.hevc")"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/measure/perf
  nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ]
  nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ]
  nlines=$(cat $ptmp/msperf_SMT_HEVC-AVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nlines=$(cat $ptmp/msperf_FFMPEG_HEVC-AVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  npng=$(find $ptmp -name "*.png" | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}

@test "measure perf --skip-perf --use-vdenc --codec HEVC raw h265" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "--security-opt=no-new-privileges:true -v $(pwd)/tests:/opt/tests" \
    /bin/bash -c "set -ex; \
    supported=\$(/opt/tests/profile-supported.sh HEVCMain);
    [[ "\$supported" = "yes" ]]"
  print_output
  if [ $status -eq 1 ]; then skip; fi
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawh265" "measure perf --skip-perf --use-vdenc --codec HEVC /tmp/WAR.hevc")"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/measure/perf
  nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nlines=$(cat $ptmp/msperf_SMT_HEVC-HEVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nlines=$(cat $ptmp/msperf_FFMPEG_HEVC-HEVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  npng=$(find $ptmp -name "*.png" | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}

@test "measure perf --skip-perf --skip-msdk raw h264" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawh264" "measure perf --skip-perf --skip-msdk /tmp/WAR.h264")"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/measure/perf
  [ ! -e $ptmp/output_SMT ]
  nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nlines=$(cat $ptmp/msperf_FFMPEG_AVC-AVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ] # we expect header and result lines
  nlines=$(cat $ptmp/msperf_FFMPEG_AVC-HEVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nout=$(find $ptmp -name "msperf_SMT*" | wc -l)
  [ "$nout" -eq 0 ]
  npng=$(find $ptmp -name *.png | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}

@test "measure perf --skip-perf --skip-ffmpeg raw h264" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawh264" "measure perf --skip-perf --skip-ffmpeg /tmp/WAR.h264")"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/measure/perf
  [ ! -e $ptmp/output_FFMPEG ]
  nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nout=$(find $ptmp -name "msperf_FFMPEG*" | wc -l)
  [ "$nout" -eq 0 ]
  nlines=$(cat $ptmp/msperf_SMT_AVC-AVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ] # we expect header and result lines # only header lines
  nlines=$(cat $ptmp/msperf_SMT_AVC-HEVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  npng=$(find $ptmp -name *.png | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}

@test "measure perf -decode --skip-ffmpeg raw h265" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$rawh265" "measure perf --density-decode --skip-ffmpeg /tmp/WAR.hevc")"
  print_output
  if ! kernel_ge_4_16; then
    [ $status -ne 0 ]
  else
    [ $status -eq 0 ]

    ptmp=$tmp/measure/perf
    nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nlines=$(cat $ptmp/msperf_SMT_HEVC-AVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/msperf_SMT_HEVC-HEVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
	nlines=$(cat $ptmp/msperf_SMT_DECODE-HEVC_performance.csv | wc -l)
    [ "$nlines" -eq 2 ]
    npng=$(find $ptmp -name "*.png" | wc -l)
    [ "$npng" -ge 4 ] # we should have at least one picture for each performance
  fi
}

@test "measure perf --skip-perf raw mp4" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  run docker_run_opts "$(get_perf_opts $tmp)" /bin/bash -c " \
    $(get_test_body "$submp4" "measure perf -v -e 3 --skip-perf /tmp/WAR_20fr.mp4")"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/measure/perf
  nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nlines=$(cat $ptmp/msperf_FFMPEG_AVC-AVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ] # we expect header and result lines
  nlines=$(cat $ptmp/msperf_FFMPEG_AVC-HEVC_performance.csv | wc -l)
  [ "$nlines" -eq 2 ]
  npng=$(find $ptmp -name *.png | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}
