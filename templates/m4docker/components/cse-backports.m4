dnl BSD 3-Clause License
dnl
dnl Copyright (c) 2022, Intel Corporation
dnl All rights reserved.
dnl
dnl Redistribution and use in source and binary forms, with or without
dnl modification, are permitted provided that the following conditions are met:
dnl
dnl * Redistributions of source code must retain the above copyright notice, this
dnl   list of conditions and the following disclaimer.
dnl
dnl * Redistributions in binary form must reproduce the above copyright notice,
dnl   this list of conditions and the following disclaimer in the documentation
dnl   and/or other materials provided with the distribution.
dnl
dnl * Neither the name of the copyright holder nor the names of its
dnl   contributors may be used to endorse or promote products derived from
dnl   this software without specific prior written permission.
dnl
dnl THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
dnl AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
dnl IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
dnl DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
dnl FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
dnl DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
dnl SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
dnl CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
dnl OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
dnl OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
dnl
include(begin.m4)

DECLARE(`CSE_BACKPORTS_VER',c334b88)
DECLARE(`CSE_BACKPORTS_SRC',https://github.com/intel-gpu/intel-gpu-cse-backports.git)

ifelse(OS_NAME,ubuntu,`
define(`CSE_BACKPORTS_BUILD_DEPS',`ca-certificates dkms git make linux-headers-KERNEL_VER')
')

define(`BUILD_CSE_BACKPORTS',`
# build cse backports
ARG CSE_BACKPORTS_REPO=CSE_BACKPORTS_SRC
RUN cd BUILD_HOME && \
  git clone ${CSE_BACKPORTS_REPO} && \
  cd intel-gpu-cse-backports && \
  git checkout CSE_BACKPORTS_VER && \
  BUILD_VERSION=1 make -f Makefile.dkms dkmsdeb-pkg && \
  mv BUILD_HOME/intel-gpu-cse-backports/*.deb BUILD_DESTDIR
')

REG(CSE_BACKPORTS)

include(end.m4)dnl
