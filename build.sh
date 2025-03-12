#!/bin/bash
mkdir -p armbian
wget -O armbian/armbian.img.xz https://mirrors.tuna.tsinghua.edu.cn/armbian-releases/uefi-x86/archive/Armbian_25.2.1_Uefi-x86_noble_current_6.12.13.img.xz
xz -d armbian/armbian.img.xz

mkdir -p output
#docker run --privileged --rm -v $(pwd)/output:/output -v $(pwd)/supportFiles:/supportFiles:ro debian:buster /supportFiles/build.sh 

docker run --privileged --rm \
        -v $(pwd)/output:/output \
        -v $(pwd)/supportFiles:/supportFiles:ro \
        -v $(pwd)/armbian:/mnt/armbian \
        debian:buster \
        /supportFiles/build.sh