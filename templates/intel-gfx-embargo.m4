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
include(ubuntu.m4)

define(`INTEL_GFX_URL',https://repositories.gfxs.intel.com/internal)

pushdef(`_install_ubuntu',`dnl
pushdef(`_tmp',`ifelse($1,`',UBUNTU_CODENAME(OS_VERSION),UBUNTU_CODENAME(OS_VERSION)-$1)')dnl
INSTALL_PKGS(PKGS(curl ca-certificates gpg-agent libnss3-tools software-properties-common unzip wget))

COPY assets/embargo/setup-certs.sh /tmp/
RUN /tmp/setup-certs.sh && rm -rf /tmp/setup-certs.sh

ARG INTEL_GFX_KEY_URL="INTEL_GFX_URL/intel-graphics.key"
RUN if [ -n "$INTEL_GFX_KEY_URL" ]; then curl -fsSL "$INTEL_GFX_KEY_URL" | apt-key add -; fi

ARG INTEL_GFX_APT_REPO="deb INTEL_GFX_URL/ubuntu _tmp main"
RUN if [ -n "$INTEL_GFX_APT_REPO" ]; then echo "$INTEL_GFX_APT_REPO" >> /etc/apt/sources.list && apt-get update; fi
popdef(`_tmp')')

ifelse(OS_NAME,ubuntu,ifelse(OS_VERSION,20.04,
`define(`ENABLE_INTEL_GFX_REPO',defn(`_install_ubuntu'))'))

popdef(`_install_ubuntu')

ifdef(`ENABLE_INTEL_GFX_REPO',,dnl
  `ERROR(`Intel Graphics Repositories don't support OS_NAME:OS_VERSION')')

include(end.m4)
