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

define(`FFMPEG_BUILD_DEPS',`ca-certificates gcc g++ git libmfx-dev libva-dev libx264-dev libx265-dev make patch pkg-config yasm')
define(`FFMPEG_INSTALL_DEPS',`intel-media-va-driver-non-free libigfxcmrt7 libmfx1 libva-drm2 libx264-155 libx265-179 libxcb-shm0')

DECLARE(`FFMPEG_VER',`n4.3.1')

define(`BUILD_FFMPEG',
RUN git clone --depth 1 --branch FFMPEG_VER https://github.com/ffmpeg/ffmpeg BUILD_HOME/ffmpeg
ifdef(`FFMPEG_PATCH_PATH',`PATCH(BUILD_HOME/ffmpeg,FFMPEG_PATCH_PATH)')dnl

RUN cd BUILD_HOME/ffmpeg && \
  ./configure \
  --prefix=BUILD_PREFIX \
  --libdir=BUILD_LIBDIR \
  --disable-static \
  --disable-doc \
  --enable-shared \
  --enable-vaapi \
  --enable-libmfx \
  --enable-gpl \
  --enable-libx264 \
  --enable-libx265 \
  --enable-version3 \
  --enable-libvmaf \
  && make -j $(nproc --all) \
  && make install DESTDIR=BUILD_DESTDIR \
  && make install

# Cleaning up...
RUN rm -rf BUILD_HOME/ffmpeg
) # define(BUILD_FFMPEG)

REG(FFMPEG)

include(end.m4)
