dnl # Copyright (c) 2020 Intel Corporation
dnl #
dnl # Permission is hereby granted, free of charge, to any person obtaining a copy
dnl # of this software and associated documentation files (the "Software"), to deal
dnl # in the Software without restriction, including without limitation the rights
dnl # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
dnl # copies of the Software, and to permit persons to whom the Software is
dnl # furnished to do so, subject to the following conditions:
dnl #
dnl # The above copyright notice and this permission notice shall be included in all
dnl # copies or substantial portions of the Software.
dnl #
dnl # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
dnl # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
dnl # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
dnl # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
dnl # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
dnl # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
dnl # SOFTWARE.
dnl #
include(envs.m4)
HIDE

# We need igt older than the following commit to have be able to select desired device
# for intel_gpu_top on multi-gpu systems:
#
# commit a627439eb5e39d927306055b1e540ef5940d7396
# Author: Ayaz A Siddiqui <ayaz.siddiqui@intel.com>
# Date:   Fri Oct 23 23:21:58 2020 +0530
#
#    lib/igt_device_scan: Select intel as default vendor for intel_gpu_top
#
#    intel_gpu_top is selecting first discrete device as default drm subsystem.
#    In case of multi-gpu system if the first device is not intel gpu
#    then it will lead to an error while running intel_gpu_top.
#
#    Signed-off-by: Ayaz A Siddiqui <ayaz.siddiqui@intel.com>
#    Cc: Petri Latvala <petri.latvala@intel.com>
#    Cc: Zbigniew Kempczynski <zbigniew.kempczynski@intel.com>
#    Cc: Dixit Ashutosh <ashutosh.dixit@intel.com>
#    Reviewed-by: Zbigniew Kempczyński <zbigniew.kempczynski@intel.com>
DECLARE(`IGT_VER',`db972bdaab8ada43b742bc9621bb0fc9d56a6fc6')

define(`IGT_BUILD_DEPS',`ca-certificates gcc bison flex git libcairo-dev libdrm-dev dnl
  libdw-dev libkmod-dev libpciaccess-dev libpixman-1-dev libprocps-dev libudev-dev dnl
  meson pkg-config')
define(`IGT_INSTALL_DEPS',`')

define(`BUILD_IGT',dnl
ARG IGT_REPO=https://gitlab.freedesktop.org/drm/igt-gpu-tools.git
RUN git clone $IGT_REPO BUILD_HOME/igt
RUN cd BUILD_HOME/igt \
  && git checkout IGT_VER \
  && meson build \
  --buildtype=release \
  --prefix=BUILD_PREFIX \
  --libdir=BUILD_LIBDIR \
  -Ddocs=disabled -Dman=disabled -Dlibdrm_drivers=intel \
  -Doverlay=disabled -Drunner=disabled -Dtests=disabled \
  && ninja -j $(nproc --all) -C build \
  && DESTDIR=BUILD_DESTDIR ninja -C build install \
  && ninja -C build install
)

define(`INSTALL_IGT',dnl
RUN setcap cap_sys_admin+ep $(find /opt -name intel_gpu_top)
)

REG(IGT)

UNHIDE
