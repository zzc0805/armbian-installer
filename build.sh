#!/bin/bash
mkdir -p armbian
wget --show-progress=bar:force:noscroll -O armbian/armbian.img.xz \
  https://mirrors.tuna.tsinghua.edu.cn/armbian-releases/uefi-x86/archive/Armbian_25.2.1_Uefi-x86_noble_current_6.12.13.img.xz \
  2>&1 | grep --line-buffered -oP '\d+(?=%)' | xargs -I{} printf "Download Progress: %d%%\r" {}
echo
echo -n "Decompressing... "
xz -d -v armbian/armbian.img.xz >/dev/null && echo "Done" || echo "Failed"
echo -e "\nFile Info:"
file armbian/armbian.img
ls -lh armbian/

mkdir -p output
#docker run --privileged --rm -v $(pwd)/output:/output -v $(pwd)/supportFiles:/supportFiles:ro debian:buster /supportFiles/build.sh 

docker run --privileged --rm \
        -v $(pwd)/output:/output \
        -v $(pwd)/supportFiles:/supportFiles:ro \
        -v $(pwd)/armbian:/mnt/ \
        debian:buster \
        /supportFiles/build.sh