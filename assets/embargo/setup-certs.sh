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

set -ex

echo "Installing Intel CA certificates"
CERTPATH=/usr/local/share/ca-certificates
cd ${CERTPATH}
wget -O IntelSHA2RootChain-Base64.zip http://certificates.intel.com/repository/certificates/IntelSHA2RootChain-Base64.zip
unzip -o IntelSHA2RootChain-Base64.zip
rm IntelSHA2RootChain-Base64.zip

wget -O IntelRootChain-Base64.zip http://certificates.intel.com/repository/certificates/Intel%20Root%20Certificate%20Chain%20Base64.zip
unzip -o IntelRootChain-Base64.zip
rm IntelRootChain-Base64.zip

update-ca-certificates --fresh

# Install all the Intel* certs
[ -d ~/.pki/nssdb ] || mkdir -p ~/.pki/nssdb
  for CERTFILE in ${CERTPATH}/Intel*crt; do
    CERTNAME="${CERTFILE/.crt}"
    certutil -d sql:$HOME/.pki/nssdb -A -n "${CERTNAME}" -i "${CERTFILE}" -t TCP,TCP,TCP
done
