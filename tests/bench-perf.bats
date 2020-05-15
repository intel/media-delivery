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

@test "bench perf nosuchfile.h264" {
  run docker_run bench perf nosuchfile.h264
  print_output
  [ $status -ne 0 ]
}

# prepare raw 2160p h264 file, high resolution and fps=60 is needed to
# reduce test time
rawh264="ffmpeg -an -hwaccel qsv \
  -c:v h264_qsv -i /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4 \
  -vf scale_qsv=w=-1:h=2160,vpp_qsv=framerate=60 \
  -c:v h264_qsv -preset medium -profile:v high -b:v 1000000 -vframes 20 \
  -y WAR.h264"

# prepare raw 2160p h264 file, high resolution and fps=60 is needed to
# reduce test time
rawh265="ffmpeg -an -hwaccel qsv \
  -c:v h264_qsv -i /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4 \
  -vf scale_qsv=w=-1:h=2160,vpp_qsv=framerate=60 \
  -c:v hevc_qsv -preset medium -profile:v main -b:v 1000000 -vframes 20 \
  -y WAR.hevc"

# Container creates artifacts under container user and host user (if not
# 'root'), can't delete them. We change permissions to the artifacts to
# allow full access to anyone.
function get_test_body() {
    ffcmd=$1
    bcmd=$2
    echo " \
      set -ex; \
      $ffcmd; \
      $bcmd; \
      set +e; \
      cp -rd /opt/data/artifacts/* /opt/tmp/; \
      sudo chmod -R 777 /opt/tmp/*"
}

@test "bench perf raw h264" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  chmod 777 $tmp
  run docker_run_opts "-v $tmp:/opt/tmp" /bin/bash -c " \
    $(get_test_body "$rawh264" "bench perf WAR.h264")"
  print_output
  if ! kernel_ge_4_16; then
    [ $status -ne 0 ]
  else
    [ $status -eq 0 ]

    ptmp=$tmp/benchmark/perf
    nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nlines=$(cat $ptmp/benchperf_FFMPEG_AVC-AVC_benchmark.csv | wc -l)
    [ "$nlines" -eq 2 ] # we expect header and result lines
    nlines=$(cat $ptmp/benchperf_FFMPEG_AVC-HEVC_benchmark.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/benchperf_SMT_AVC-AVC_benchmark.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/benchperf_SMT_AVC-HEVC_benchmark.csv | wc -l)
    [ "$nlines" -eq 2 ]
    npng=$(find $ptmp -name "*.png" | wc -l)
    [ "$npng" -ge 4 ] # we should have at least one picture for each benchmark
  fi
}

@test "bench perf raw h265" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  chmod 777 $tmp
  run docker_run_opts "-v $tmp:/opt/tmp" /bin/bash -c " \
    $(get_test_body "$rawh265" "bench perf WAR.hevc")"
  print_output
  if ! kernel_ge_4_16; then
    [ $status -ne 0 ]
  else
    [ $status -eq 0 ]

    ptmp=$tmp/benchmark/perf
    nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
    [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
    nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
    [ "$nout" -gt 0 ]
    nlines=$(cat $ptmp/benchperf_FFMPEG_HEVC-AVC_benchmark.csv | wc -l)
    [ "$nlines" -eq 2 ] # we expect header and result lines
    nlines=$(cat $ptmp/benchperf_FFMPEG_HEVC-HEVC_benchmark.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/benchperf_SMT_HEVC-AVC_benchmark.csv | wc -l)
    [ "$nlines" -eq 2 ]
    nlines=$(cat $ptmp/benchperf_SMT_HEVC-HEVC_benchmark.csv | wc -l)
    [ "$nlines" -eq 2 ]
    npng=$(find $ptmp -name "*.png" | wc -l)
    [ "$npng" -ge 4 ] # we should have at least one picture for each benchmark
  fi
}

@test "bench perf --skip-perf raw h264" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  chmod 777 $tmp
  run docker_run_opts "-v $tmp:/opt/tmp" /bin/bash -c " \
    $(get_test_body "$rawh264" "bench perf --skip-perf WAR.h264")"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/benchmark/perf
  nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nlines=$(cat $ptmp/benchperf_FFMPEG_AVC-AVC_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ] # we expect header and result lines
  nlines=$(cat $ptmp/benchperf_FFMPEG_AVC-HEVC_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nlines=$(cat $ptmp/benchperf_SMT_AVC-AVC_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nlines=$(cat $ptmp/benchperf_SMT_AVC-HEVC_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ]
  npng=$(find $ptmp -name "*.png" | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}

@test "bench perf --skip-perf raw h265" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  chmod 777 $tmp
  run docker_run_opts "-v $tmp:/opt/tmp" /bin/bash -c " \
    $(get_test_body "$rawh265" "bench perf --skip-perf WAR.hevc")"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/benchmark/perf
  nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nlines=$(cat $ptmp/benchperf_FFMPEG_HEVC-AVC_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ] # we expect header and result lines
  nlines=$(cat $ptmp/benchperf_FFMPEG_HEVC-HEVC_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nlines=$(cat $ptmp/benchperf_SMT_HEVC-AVC_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nlines=$(cat $ptmp/benchperf_SMT_HEVC-HEVC_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ]
  npng=$(find $ptmp -name "*.png" | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}

@test "bench perf --skip-perf --skip-msdk raw h264" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  chmod 777 $tmp
  run docker_run_opts "-v $tmp:/opt/tmp" /bin/bash -c " \
    $(get_test_body "$rawh264" "bench perf --skip-perf --skip-msdk WAR.h264")"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/benchmark/perf
  [ ! -e $ptmp/output_SMT ]
  nout=$(find $ptmp/output_FFMPEG -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output_FFMPEG -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nlines=$(cat $ptmp/benchperf_FFMPEG_AVC-AVC_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ] # we expect header and result lines
  nlines=$(cat $ptmp/benchperf_FFMPEG_AVC-HEVC_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nout=$(find $ptmp -name "benchperf_SMT*" | wc -l)
  [ "$nout" -eq 0 ]
  npng=$(find $ptmp -name *.png | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}

@test "bench perf --skip-perf --skip-ffmpeg raw h264" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  chmod 777 $tmp
  run docker_run_opts "-v $tmp:/opt/tmp" /bin/bash -c " \
    $(get_test_body "$rawh264" "bench perf --skip-perf --skip-ffmpeg WAR.h264")"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/benchmark/perf
  [ ! -e $ptmp/output_FFMPEG ]
  nout=$(find $ptmp/output_SMT -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output_SMT -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nout=$(find $ptmp -name "benchperf_FFMPEG*" | wc -l)
  [ "$nout" -eq 0 ]
  nlines=$(cat $ptmp/benchperf_SMT_AVC-AVC_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ] # we expect header and result lines # only header lines
  nlines=$(cat $ptmp/benchperf_SMT_AVC-HEVC_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ]
  npng=$(find $ptmp -name *.png | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}
