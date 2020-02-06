#!/bin/bash

LDC_V="1.16.0"

sudo apt update
sudo apt install -y git libcurl4-openssl-dev libsqlite3-dev libxml2 pkg-config
wget https://github.com/ldc-developers/ldc/releases/download/v${LDC_V}/ldc2-${LDC_V}-linux-armhf.tar.xz
tar -xvf ldc2-${LDC_V}-linux-armhf.tar.xz
rm ldc2-${LDC_V}-linux-armhf.tar.xz

git clone https://github.com/abraunegg/onedrive.git onedrive-git
cd onedrive-git
./configure DC=../ldc2-${LDC_V}-linux-armhf/bin/ldmd2
make clean
make

cd ..
mv onedrive-git/onedrive .
rm -rf ldc2-${LDC_V}-linux-armhf/
rm -rf onedrive-git/
