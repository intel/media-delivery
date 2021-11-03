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

profile=$1
# we get seg in the form of: seg="200 300", where 200 and 300 are line numbers in vainfo output:
#  200 VAProfileH264/VAEntrypointEncSliceLP
#  ...
#  300 VAProfile<next-item>/VAEntrypoint<next-item>
seg=$(vainfo -a --display drm --device $DEVICE 2> /dev/null | \
  grep -n VAProfile | grep -A1 VAProfile${profile}/VAEntrypointEncSliceLP | awk -F: '{ print $1 }')
[ -z "${seg}" ] && echo "no" && exit 0 # profile does not exist
seg=(${seg// / })
# now we produce segment variable as an input to sed in a form: segment="200,300p", or segment="200,$p"
# if there is no profile entry after the one we searched for ($ indicates EOF and p stands for "print" for sed)
segment=${seg[0]}
[ ${#seg[@]} -eq 1 ] && segment+=',$p' || segment+=','${seg[1]}'p'
res="yes"
[ -z "$(vainfo -a --display drm --device $DEVICE 2> /dev/null | sed -n $segment | grep VA_RC_CBR)" ] && res="no"
[ -z "$(vainfo -a --display drm --device $DEVICE 2> /dev/null | sed -n $segment | grep VA_RC_VBR)" ] && res="no"
echo $res
