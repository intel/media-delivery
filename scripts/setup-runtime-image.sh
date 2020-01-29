#!/bin/bash

apt-get update && apt-get install -y \
    curl joe less vim wget \
  && rm -rf /var/lib/apt/lists/*
