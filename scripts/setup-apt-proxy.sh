#!/bin/bash

set -ex

rm -f /etc/apt/apt.conf

if [ -n "$http_proxy" ]; then
  echo "Acquire::http::proxy \"$http_proxy\";" >> /etc/apt/apt.conf
fi

if [ -n "$https_proxy" ]; then
  echo "Acquire::https::proxy \"$https_proxy\";" >> /etc/apt/apt.conf
fi

echo "http_proxy=$http_proxy"
echo "https_proxy=$https_proxy"
cat /etc/apt/apt.conf
