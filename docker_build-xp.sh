#!/bin/bash

docker rmi wroshyr-builder:xp 2>/dev/null
docker pull debian:bullseye

cd dockerfile_xp
docker build --progress=plain -t wroshyr-builder:xp .
cd ..

