dnl BSD 3-Clause License
dnl
dnl Copyright (c) 2020, Intel Corporation
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

include(ubuntu.m4)

define(`INTEL_GFX_URL',https://repositories.gfxs.intel.com/internal)

pushdef(`_install_ubuntu',`dnl
pushdef(`_tmp',`UBUNTU_CODENAME(OS_VERSION)-embargo-untested')dnl
INSTALL_PKGS(PKGS(curl ca-certificates gpg software-properties-common libnss3-tools unzip wget))

COPY assets/embargo/setup-certs.sh /tmp/
RUN /tmp/setup-certs.sh && rm -rf /tmp/setup-certs.sh

ARG INTEL_GFX_KEY_URL="INTEL_GFX_URL/intel-graphics.key"
ARG INTEL_GFX_APT_REPO="deb INTEL_GFX_URL/ubuntu _tmp main"

RUN \
  if [ -n "$INTEL_GFX_KEY_URL" ]; then \
    local_key=/usr/share/keyrings/intel-gfx.gpg && \
    curl -s $INTEL_GFX_KEY_URL | gpg --dearmor | tee $local_key >/dev/null && \
    repo=$(echo $INTEL_GFX_APT_REPO | sed "s@deb @deb [signed-by=$local_key] @") && \
    echo "$repo" >> /etc/apt/sources.list; \
  else \
    echo "$INTEL_GFX_APT_REPO" >> /etc/apt/sources.list; \
  fi && \
  apt-get update
popdef(`_tmp')')

ifelse(OS_NAME:OS_VERSION,ubuntu:20.04,`define(`ENABLE_INTEL_GFX_REPO',defn(`_install_ubuntu'))')
ifelse(OS_NAME:OS_VERSION,ubuntu:22.04,`define(`ENABLE_INTEL_GFX_REPO',defn(`_install_ubuntu'))')

popdef(`_install_ubuntu')

ifdef(`ENABLE_INTEL_GFX_REPO',,dnl
  `ERROR(`Intel Graphics Repository .m4 template does not support OS_NAME:OS_VERSION')')

include(end.m4)dnl
