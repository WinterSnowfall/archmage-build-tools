#!/bin/bash

docker rmi archmage-builder:xp 2>/dev/null
docker pull debian:bullseye

cd dockerfile_xp
docker build -t archmage-builder:xp .
cd ..

