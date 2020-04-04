#!/bin/bash
#
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

# Usage: setup.sh <prefix>
#
# This scripts setups the solution by creating required directories,
# adjusting access rights, copying configuration files and executables.
#
# Mind 2 key scripts created by this setup:
#  /usr/bin/demo-bash - shell script which is an entrypoint to the solution
#  /etc/demo.env - script containing solution environment variables to
#    source in shell scripts

(( EUID != 0 )) && exec sudo -- "$0" "$@"

set -ex

prefix=$1

# nginx user should have permission to read/write in
# the HLS streams location
mkdir -p /var/www/hls/vod
chown -R www-data /var/www/hls

# Installing nginx configuration
cp nginx.conf /etc/nginx/nginx.conf

# Installing solution scripts
scripts=" \
  ../../assets/demo \
  ../../assets/ffmpeg-capture-hls.sh \
  ../../assets/monitor-nginx-server.sh \
  ../../benchmark/* \
  ../../scripts/setup-apt-proxy.sh \
  nginx-trigger-streaming.sh"

for s in $scripts; do
  cp -rd $s $prefix/bin
done

# Generating entrypoints
{
  echo "export DEMO_NAME=Edge"
  echo "export DEMO_PREFIX=$prefix"
  # these are streaming types supported by the demo, i.e. <type> in the following address:
  #   http://localhost:8080/vod/<type>/<stream>.index.m3u8
  echo "export DEMO_STREAM_TYPES=vod/avc"
  echo "export PATH=\$DEMO_PREFIX/bin:/usr/share/mfx/samples/:\$PATH"
  echo "export PYTHONUSERBASE=\$DEMO_PREFIX"
  echo "export MANPATH=\$DEMO_PREFIX/share/man:\$MANPATH"
  echo "export LIBVA_DRIVER_NAME=iHD"
} > /etc/demo.env

cp demo-setup /usr/bin/
