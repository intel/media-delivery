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
include(dav1d.m4)

DECLARE(`FFMPEG_VER',`bea841a')
DECLARE(`FFMPEG_ENABLE_MFX',`1.x')

define(`FFMPEG_BUILD_DEPS',`ca-certificates gcc g++ git dnl
  ifdef(`BUILD_MSDK',,ifelse(FFMPEG_ENABLE_MFX,1.x,libmfx-dev)) dnl
  ifdef(`BUILD_ONEVPLGPU',,ifelse(FFMPEG_ENABLE_MFX,2.x,libvpl-dev)) dnl
  ifdef(`BUILD_LIBVA2',,libva-dev) dnl
  libx264-dev libx265-dev make patch pkg-config yasm')

define(`FFMPEG_INSTALL_DEPS',`dnl
  ifdef(`BUILD_MEDIA_DRIVER',,intel-media-va-driver-non-free libigfxcmrt7) dnl
  ifdef(`BUILD_MSDK',,libmfx1) dnl
  ifdef(`BUILD_ONEVPLGPU',,ifelse(FFMPEG_ENABLE_MFX,2.x,libmfxgen1)) dnl
  ifdef(`BUILD_ONEVPL',,ifelse(FFMPEG_ENABLE_MFX,2.x,libvpl2)) dnl
  ifdef(`BUILD_LIBVA2',,libva-drm2) dnl
  libx264-155 libx265-179 libxcb-shm0')

define(`BUILD_FFMPEG',
RUN git clone https://github.com/ffmpeg/ffmpeg BUILD_HOME/ffmpeg && \
  cd BUILD_HOME/ffmpeg && \
  git checkout FFMPEG_VER
ifdef(`FFMPEG_PATCH_PATH',`PATCH(BUILD_HOME/ffmpeg,FFMPEG_PATCH_PATH)')dnl

RUN cd BUILD_HOME/ffmpeg && \
  ./configure \
  --prefix=BUILD_PREFIX \
  --libdir=BUILD_LIBDIR \
  --disable-static \
  --disable-doc \
  --enable-shared \
  --enable-vaapi \
ifelse(FFMPEG_ENABLE_MFX,1.x,`dnl
  --enable-libmfx \
',ifelse(FFMPEG_ENABLE_MFX,2.x,`dnl
  --enable-libvpl \
'))dnl
  --enable-gpl \
  --enable-libx264 \
  --enable-libx265 \
  --enable-version3 \
  --enable-libvmaf \
  --enable-libdav1d \
  && make -j $(nproc --all) \
  && make install DESTDIR=BUILD_DESTDIR \
  && make install

# Cleaning up...
RUN rm -rf BUILD_HOME/ffmpeg
) # define(BUILD_FFMPEG)

REG(FFMPEG)

include(end.m4)
