#!/bin/bash

docker rmi wroshyr-builder:sniper 2>/dev/null
docker pull registry.gitlab.steamos.cloud/steamrt/sniper/sdk

cd dockerfile_sniper
docker build -t wroshyr-builder:sniper .
cd ..

