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

define(`INTEL_GFX_URL',https://gfx-assets-build.fm.intel.com/artifactory/api/archive/download/agama-builds/ci)

pushdef(`_install_ubuntu',`dnl
INSTALL_PKGS(PKGS(curl ca-certificates dpkg-dev gpg-agent libnss3-tools software-properties-common unzip wget))

COPY assets/embargo/setup-certs.sh /tmp/
RUN /tmp/setup-certs.sh && rm -rf /tmp/setup-certs.sh

ARG FLAVOR
ARG USER
ARG PASSWD
RUN mkdir -p /opt/apt-pkgs && cd /opt/apt-pkgs && \
  curl -s --noproxy '*' -L \
    -u "$USER:$PASSWD" \
    INTEL_GFX_URL/$(echo ${FLAVOR} | sed -E "s/agama-ci-(.*)-[0-9]+$/\1/")/$FLAVOR/artifacts/linux/ubuntu/20.04?archiveType=tgz | \
    tar -xvz --warning=no-timestamp

RUN cd /opt/apt-pkgs && \
  dpkg-scanpackages .  > Packages && \
  echo "deb [trusted=yes arch=amd64] file:///opt/apt-pkgs ./" > /etc/apt/sources.list.d/intel-gfx-$FLAVOR.list')

ifelse(OS_NAME,ubuntu,ifelse(OS_VERSION,20.04,
`define(`ENABLE_INTEL_GFX_REPO',defn(`_install_ubuntu'))'))

popdef(`_install_ubuntu')

ifdef(`ENABLE_INTEL_GFX_REPO',,dnl
  `ERROR(`Intel Graphics Repositories don't support OS_NAME:OS_VERSION')')

include(end.m4)
