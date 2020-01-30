#!/bin/bash

# Usage: setup.sh <prefix>
#
# This scripts setups the solution by creating required directories,
# adjusting access rights, copying configuration files and executables.
#
# Mind 2 key scripts created by this setup:
#  /usr/bin/demo - shell script which is an entrypoint to the solution
#  /etc/demo.env - script containing solution environment variables to
#    source in shell scripts

(( EUID != 0 )) && exec sudo -- "$0" "$@"

set -ex

prefix=$1

# Create location for HLS stream fragments
mkdir /var/www/hls
# nginx user should have permission to read/write in
# the HLS streams location
chown www-data /var/www/hls

# Installing nginx configuration
cp nginx.conf /etc/nginx/nginx.conf

# Installing solution scripts
scripts=" \
  ../../assets/demo.sh \
  ../../assets/ffmpeg-capture-hls.sh \
  ../../scripts/setup-apt-proxy.sh \
  nginx-rtmp-trigger-streaming.sh"

for s in $scripts; do
  cp $s $prefix/bin
done

if_grps_changed=" \
  \"\$(groups \$(whoami) | awk -F: '{print \$2}' | awk '{\$1=\$1;print}')\" != \
  \"\$(groups)\""

# Generating entrypoints
{
  echo "export PATH=$PREFIX/bin:\$PATH"
  echo "video_grps=\$(ls -g /dev/dri/renderD* | awk '{print \$3}' | uniq | \
    awk -vORS=, '{ print }' | sed 's/,$/\n/')"
  echo "sudo usermod -aG \$video_grps user"
  echo "sudo usermod -aG \$video_grps www-data"
  # checking whether groups actually changed to avoid abusing user with the messages
  echo "if [ $if_grps_changed ]; then"
  echo "  echo \"We just added 'user' and 'www-data' accounts to some groups. If you\""
  echo "  echo \"run the shell under one of these accounts - you need to restart it.\""
  echo "  echo \"This can be done by these commands without leaving your current shell:\""
  echo "  echo \"  exec sudo su - user\""
  echo "  echo \"  exec sudo su - www-data\""
  echo "fi"
} > /etc/demo.env

{
  echo "#!/bin/bash"
  echo "source /etc/demo.env > /dev/null"
  echo "if [ $if_grps_changed ]; then exec sudo -u user -- "\$0" "\$@"; fi"
  echo "$prefix/bin/demo.sh \$@"
} > /usr/bin/demo

chmod a+x /usr/bin/demo
