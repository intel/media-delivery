#!/bin/bash
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

std=$1
seg=$(vainfo -a --display drm --device $DEVICE 2> /dev/null | \
  grep -n VAProfile | grep -A1 VAProfile${std}/VAEntrypointEncSliceLP | awk -F: '{ print $1 }')
[ -z "${seg}" ] && echo "VDENC $1 Entrypoint is not supported" && exit 10
seg=(${seg// / })
segment=${seg[0]}
[ ${#seg[@]} -eq 1 ] && segment+=',$p' || segment+=','${seg[1]}'p'
[ -z "$(vainfo -a --display drm --device $DEVICE 2> /dev/null | sed -n $segment | grep VA_RC_CBR)" ] && echo "VDENC $1 CBR is not supported" && exit 11
[ -z "$(vainfo -a --display drm --device $DEVICE 2> /dev/null | sed -n $segment | grep VA_RC_VBR)" ] && echo "VDENC $1 VBR is not supported" && exit 12
echo "VDENC" $1 "CBR and VBR are supported"
exit 0
