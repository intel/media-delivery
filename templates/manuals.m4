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

define(`MANUALS_BUILD_DEPS',`asciidoc-base docbook-xsl make xsltproc')
define(`MANUALS_INSTALL_DEPS',`less man-db')

define(`BUILD_MANUALS',
# Building some manual pages for the sample
COPY doc/man BUILD_HOME/manuals
RUN cd BUILD_HOME/manuals && make -j $(nproc --all) && \
  DESTDIR=BUILD_DESTDIR make prefix=BUILD_PREFIX install
RUN rm -rf BUILD_HOME/manuals
)

define(`INSTALL_MANUALS',
# Restoring man which is excluded from the minimal ubuntu image
``RUN rm -f /usr/bin/man && dpkg-divert --quiet --remove --rename /usr/bin/man'')

REG(MANUALS)

UNHIDE
