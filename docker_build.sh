#!/bin/bash

docker rmi wroshyr-builder:latest 2>/dev/null
docker pull archlinux:latest

cd dockerfile
docker build --progress=plain -t wroshyr-builder:latest .
cd ..

