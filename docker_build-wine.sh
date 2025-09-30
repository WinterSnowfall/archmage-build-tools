#!/bin/bash

docker rmi archmage-builder:wine 2>/dev/null
docker pull archlinux:latest

cd dockerfile_wine
docker build -t archmage-builder:wine .
cd ..

