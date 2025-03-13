#!/bin/bash
mkdir -p armbian
#https://mirrors.tuna.tsinghua.edu.cn/armbian-releases/uefi-x86/archive/

REPO="wukongdaily/armbian-installer"
TAG="2025-03-12"
FILE_NAME="Armbian_25.2.1_Uefi-x86_noble_current_6.12.13.img.xz"
OUTPUT_PATH="armbian/armbian.img.xz"

DOWNLOAD_URL=$(curl -s https://api.github.com/repos/$REPO/releases/tags/$TAG | jq -r '.assets[] | select(.name == "'"$FILE_NAME"'") | .browser_download_url')

if [[ -z "$DOWNLOAD_URL" ]]; then
  echo "错误：未找到文件 $FILE_NAME"
  exit 1
fi

echo "下载地址: $DOWNLOAD_URL"

echo "下载文件: $FILE_NAME -> $OUTPUT_PATH"
curl -L -o "$OUTPUT_PATH" "$DOWNLOAD_URL"

if [[ $? -eq 0 ]]; then
  echo "下载armbian成功！"
  file armbian/armbian.img.xz
  echo "showfile end"
  xz -d armbian/armbian.img.xz
  ls -lh armbian/
else
  echo "下载失败！"
  exit 1
fi
exit 1

mkdir -p output
#docker run --privileged --rm -v $(pwd)/output:/output -v $(pwd)/supportFiles:/supportFiles:ro debian:buster /supportFiles/build.sh 

docker run --privileged --rm \
        -v $(pwd)/output:/output \
        -v $(pwd)/supportFiles:/supportFiles:ro \
        -v $(pwd)/armbian/armbian.img:/mnt/armbian.img \
        debian:buster \
        /supportFiles/build.sh