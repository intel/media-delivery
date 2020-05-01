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

# prepare raw 2160p h264 file, high resolution is needed to reduce
# test time
rawh264="ffmpeg -an -hwaccel qsv \
  -c:v h264_qsv -i /opt/data/embedded/WAR_2Mbps_perceptual_1080p.mp4 \
  -vf scale_qsv=w=-1:h=2160 \
  -c:v h264_qsv -preset medium -profile:v high -b:v 1000000 -vframes 20 \
  -y WAR.h264"

# prepare raw 2160p h265 file, high resolution is needed to reduce
# test time
rawh265="ffmpeg -an -hwaccel qsv \
  -c:v h264_qsv -i /opt/data/embedded/WAR_2Mbps_perceptual_1080p.mp4 \
  -vf scale_qsv=w=-1:h=2160 \
  -c:v hevc_qsv -preset medium -profile:v main -b:v 1000000 -vframes 20 \
  -y WAR.hevc"

@test "bench perf --skip-perf raw h264" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  chmod 777 $tmp
  run docker_run_opts "-v $tmp:/opt/data/artifacts" /bin/bash -c " \
    set -ex; \
    $rawh264; \
    bench perf --skip-perf WAR.h264; \
    chmod -R a+w /opt/data/artifacts/*;"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/benchmark/perf
  [ -d $ptmp/output ]
  nout=$(find $ptmp/output -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nlines=$(cat $ptmp/benchperf_FFMPEG_avc2avc_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ] # we expect header and result lines
  nlines=$(cat $ptmp/benchperf_FFMPEG_avc2hevc_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nlines=$(cat $ptmp/benchperf_SMT_avc2avc_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nlines=$(cat $ptmp/benchperf_SMT_avc2hevc_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ]
  npng=$(find $ptmp -name *.png | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}

@test "bench perf --skip-perf raw h265" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  chmod 777 $tmp
  run docker_run_opts "-v $tmp:/opt/data/artifacts" /bin/bash -c " \
    set -ex; \
    $rawh265; \
    bench perf --skip-perf WAR.hevc; \
    chmod -R a+w /opt/data/artifacts/*;"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/benchmark/perf
  [ -d $ptmp/output ]
  nout=$(find $ptmp/output -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nlines=$(cat $ptmp/benchperf_FFMPEG_hevc2avc_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ] # we expect header and result lines
  nlines=$(cat $ptmp/benchperf_FFMPEG_hevc2hevc_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nlines=$(cat $ptmp/benchperf_SMT_hevc2avc_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nlines=$(cat $ptmp/benchperf_SMT_hevc2hevc_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ]
  npng=$(find $ptmp -name *.png | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}


@test "bench perf --skip-perf --skip-msdk raw h264" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  chmod 777 $tmp
  run docker_run_opts "-v $tmp:/opt/data/artifacts" /bin/bash -c " \
    set -ex; \
    $rawh264; \
    bench perf --skip-perf --skip-msdk WAR.h264; \
    chmod -R a+w /opt/data/artifacts/*;"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/benchmark/perf
  [ -d $ptmp/output ]
  nout=$(find $ptmp/output -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nlines=$(cat $ptmp/benchperf_FFMPEG_avc2avc_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ] # we expect header and result lines
  nlines=$(cat $ptmp/benchperf_FFMPEG_avc2hevc_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ]
  nout=$(find $ptmp -name "benchperf_SMT*" | wc -l)
  [ "$nout" -eq 0 ]
  npng=$(find $ptmp -name *.png | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}

@test "bench perf --skip-perf --skip-ffmpeg raw h264" {
  tmp=`mktemp -p $_TMP -d -t demo-XXXX`
  chmod 777 $tmp
  run docker_run_opts "-v $tmp:/opt/data/artifacts" /bin/bash -c " \
    set -ex; \
    $rawh264; \
    bench perf --skip-perf --skip-ffmpeg WAR.h264; \
    chmod -R a+w /opt/data/artifacts/*;"
  print_output
  [ $status -eq 0 ]

  ptmp=$tmp/benchmark/perf
  [ -d $ptmp/output ]
  nout=$(find $ptmp/output -name "*.h264" | wc -l)
  [ "$nout" -gt 0 ] # we expect at least 1 output file for each encoder
  nout=$(find $ptmp/output -name "*.h265" | wc -l)
  [ "$nout" -gt 0 ]
  nout=$(find $ptmp -name "benchperf_FFMPEG*" | wc -l)
  [ "$nout" -eq 0 ]
  nlines=$(cat $ptmp/benchperf_SMT_avc2avc_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ] # we expect header and result lines # only header lines
  nlines=$(cat $ptmp/benchperf_SMT_avc2hevc_benchmark.csv | wc -l)
  [ "$nlines" -eq 2 ]
  npng=$(find $ptmp -name *.png | wc -l)
  [ "$npng" -eq 0 ] # no detailed charts because of --skip-perf
}
