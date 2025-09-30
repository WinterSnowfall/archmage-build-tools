#!/bin/bash

docker rmi archmage-builder:sniper 2>/dev/null
docker pull registry.gitlab.steamos.cloud/steamrt/sniper/sdk

cd dockerfile_sniper
docker build -t archmage-builder:sniper .
cd ..

