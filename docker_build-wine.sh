#!/bin/bash

docker rmi wroshyr-builder:wine 2>/dev/null
docker pull archlinux:latest

cd dockerfile_wine
docker build -t wroshyr-builder:wine .
cd ..

