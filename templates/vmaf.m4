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
include(begin.m4)

DECLARE(`VMAF_VER',`v1.5.2')
DECLARE(`ENABLE_VMAF_PYTHON',`yes')

define(`VMAF_PYTHON_DEPS',`ifelse(ENABLE_VMAF_PYTHON,yes,
`cython3 python3 python3-dev python3-numpy python3-setuptools python3-wheel')')
define(`VMAF_PYTHON_INSTALL_DEPS',`ifelse(ENABLE_VMAF_PYTHON,yes,`python3 python3-pip')')

define(`VMAF_BUILD_DEPS',`ca-certificates gcc g++ git make meson patch pkg-config VMAF_PYTHON_DEPS')
define(`VMAF_INSTALL_DEPS',`VMAF_PYTHON_INSTALL_DEPS')

define(`BUILD_VMAF',dnl
# As of now we need 2 things from VMAF: libvmaf library against which we will link
# ffmpeg and model *.pkl files to be able to calculate VMAF.
RUN git clone --depth 1 --branch VMAF_VER https://github.com/Netflix/vmaf.git BUILD_HOME/vmaf
ifdef(`VMAF_PATCH_PATH',`PATCH(BUILD_HOME/vmaf,VMAF_PATCH_PATH)')dnl

RUN cd BUILD_HOME/vmaf/libvmaf \
  && meson build \
  --buildtype=release \
  --prefix=BUILD_PREFIX \
  --libdir=BUILD_LIBDIR \
  && ninja -j $(nproc --all) -C build \
  && DESTDIR=BUILD_DESTDIR ninja -C build install \
  && ninja -C build install
ifelse(ENABLE_VMAF_PYTHON,yes,`
RUN cd BUILD_HOME/vmaf/python \
    && python3 setup.py build \
    && python3 setup.py bdist_wheel --dist-dir=BUILD_WHEEL')
) # define(BUILD_VMAF)

define(`INSTALL_VMAF',dnl
COPY --from=$2 BUILD_WHEEL BUILD_WHEEL
RUN python3 -m pip install --no-deps --prefix=BUILD_PREFIX BUILD_WHEEL/* && rm -rf /opt/wheel
)

REG(VMAF)

include(end.m4)
