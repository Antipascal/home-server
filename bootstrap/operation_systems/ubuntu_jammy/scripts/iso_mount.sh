#!/bin/bash
export $(grep -v '^#' ../.env | xargs)

echo "----- Downloading image -----"
wget -nc $IMAGE_LINK

echo "----- Cleaning up -----"
rm -rf $BUILD_DIR/
mkdir --parents $BUILD_DIR

7z x -y $IMAGE -o$BUILD_DIR