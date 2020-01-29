#!/bin/bash

export http_proxy=http://proxy-chain.intel.com:911
export https_proxy=http://proxy-chain.intel.com:911
unset no_proxy

docker build \
  --network=host \
  $(env | grep -E '_proxy=' | sed 's/^/--build-arg /') \
  --file Dockerfile.ubuntu \
  -t intel-media-delivery \
  .
