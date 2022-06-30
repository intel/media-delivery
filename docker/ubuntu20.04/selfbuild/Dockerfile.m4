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

include(defs.m4)dnl
divert(-1)
define(`USE_VPL_TOOLS',yes)
define(`ONEVPL_PATCH_PATH',patches/libvpl2)
define(`MEDIA_DRIVER_PATCH_PATH',patches/media-driver)
define(`MFX_ENABLE_AENC',ON)
define(`ENABLE_PRODUCTION_KMD',ON)
divert(0)dnl
include(begin.m4)
include(content.m4)
include(media-driver.m4)
include(libva2-utils.m4)
include(onevpl-gpu.m4)
include(msdk.m4)
include(vmaf.m4)
include(ffmpeg.m4)
include(manuals.m4)
include(samples.m4)
include(end.m4)
PREAMBLE

ARG IMAGE=OS_NAME:OS_VERSION
FROM $IMAGE AS base

FROM base as content

GET_CONTENT

FROM base as build

BUILD_ALL

# Ok, here goes the final image end-user will actually see
FROM base

LABEL vendor="Intel Corporation"

INSTALL_CONTENT(content)

INSTALL_ALL(runtime,build)

USER user
WORKDIR /home/user
