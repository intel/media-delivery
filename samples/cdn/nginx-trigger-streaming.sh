#!/bin/bash
#
# Copyright (c) 2020-2022 Intel Corporation
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

# This script is called from the sample HTTP socat server when client requests
# HLS stream. Script parses incoming HTTP request and treats it as a transcoding
# request.
#
# /dev/stdin is used to read incoming HTTP request
# /dev/stdout is used to write HTTP response

source /etc/demo.env

while IFS= read -r line; do
  if [[ "$line" =~ GET.* ]]; then
    stream=$(echo "$line" | cut -f2 -d\ )
    (do-transcode.sh "$stream" </dev/null >/dev/null 2>&1) &

    n=0
    while [[ ! -s "/var/www/hls/$stream" && "$n" -lt 10 ]]; do sleep 1; $((++n)); done

    if [ -f "/var/www/hls/$stream" ]; then
      echo "HTTP/1.1 200 OK"
      echo "Content-Type: application/vnd.apple.mpegurl"
      echo ""
      cat /var/www/hls/$stream
    else
      echo "HTTP/1.1 404 Not Found"
    fi
    exit
  fi
done

