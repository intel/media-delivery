#!/bin/bash

export http_proxy=http://proxy-chain.intel.com:911
export https_proxy=http://proxy-chain.intel.com:911
#export no_proxy=localhost
#unset no_proxy

docker run \
  -it --privileged --network=host \
  $(env | grep -E '_proxy=' | sed 's/^/-e /') \
  intel-media-delivery $@
