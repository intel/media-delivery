#!/bin/bash

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
chown www-data /var/www/hls

# Installing nginx configuration
cp nginx.conf /etc/nginx/nginx.conf

# Installing solution scripts
scripts=" \
  ../../assets/demo \
  ../../assets/ffmpeg-capture-hls.sh \
  ../../scripts/setup-apt-proxy.sh \
  nginx-rtmp-trigger-streaming.sh"

for s in $scripts; do
  cp $s $prefix/bin
done

# Generating entrypoints
{
  echo "export DEMO_NAME=Edge"
  echo "export DEMO_PREFIX=$prefix"
  echo "export PATH=\$DEMO_PREFIX/bin:/usr/share/mfx/samples/:\$PATH"
  echo "export LIBVA_DRIVER_NAME=iHD"
} > /etc/demo.env

cp demo-setup /usr/bin/
