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

# These are image consistency tests, i.e. tests which assure that
# self-built apps included into the image can actually be run (dependencies
# are satisfied).

@test "ffmpeg is ready" {
  run docker_run ffmpeg --help
  print_output
  [ $status -eq 0 ]
}

@test "ffprobe is ready" {
  run docker_run ffprobe --help
  print_output
  [ $status -eq 0 ]
}

# this test is indirect check that ffmpeg patches were actually applied
# and user did not forget to rebuild image with --no-cache
@test "ffmpeg patches were applied" {
  run docker_run diff \
    /opt/intel/solutions/patches \
    /opt/intel/solutions/src/intel-media-delivery/patches
  print_output
  [ $status -eq 0 ]
}
