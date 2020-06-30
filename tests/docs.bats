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

@test "manuals" {
  skip "note: for unknown reason test dosn't work under gitlab ci"

  MAN=" \
    demo \
    demo-bash \
    demo.env \
    demo-ffmpeg \
    demo-help \
    demo-setup \
    demo-streams \
    ffmpeg-capture-hls \
    hello-bash \
    monitor-nginx-server"

  for m in $MAN; do
    run docker_run man --pager=cat $m
    print_output
    [ "$status" -eq 0 ]
    manout=("${lines[@]}")
    run grep_for "NAME" ${manout[@]}
    [ $status -eq 0 ]
    run grep_for "SYNOPSIS" ${manout[@]}
    [ $status -eq 0 ]
    run grep_for "DESCRIPTION" ${manout[@]}
    [ $status -eq 0 ]
  done
}
