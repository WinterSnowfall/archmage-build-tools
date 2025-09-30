#!/bin/bash

docker rmi archmage-builder:latest 2>/dev/null
docker pull archlinux:latest

cd dockerfile
docker build -t archmage-builder:latest .
cd ..

