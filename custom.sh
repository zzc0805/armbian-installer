#!/bin/bash
set -euo pipefail  
# 校验参数是否存在
if [ -z "$1" ]; then
  echo "❌ 错误：未提供下载地址！"
  exit 1
fi
mkdir -p imm
OUTPUT_PATH="imm/custom.img.gz"
DOWNLOAD_URL="$1"
echo "下载地址: $DOWNLOAD_URL"

# 下载文件
if ! curl -k -L -o "$OUTPUT_PATH" "$DOWNLOAD_URL"; then
  echo "❌ 下载失败！"
  exit 1
fi

echo "✅ 下载自定义OpenWrt成功!"
file imm/custom.img.gz

# 解压并校验
echo "正在解压为: custom.img"
gunzip -f imm/custom.img.gz || true 

# 检查解压后的文件
if [ -f "imm/custom.img" ]; then
  echo "✅ 解压成功"
  ls -lh imm/
  echo "✅ 准备合成 自定义OpenWrt 安装器"
else
  echo "❌ 错误：解压后文件 imm/custom.img 不存在"
  exit 1
fi

mkdir -p output
docker run --privileged --rm \
        -v $(pwd)/output:/output \
        -v $(pwd)/supportFiles:/supportFiles:ro \
        -v $(pwd)/imm/custom.img:/mnt/custom.img \
        debian:buster \
        /supportFiles/custom/build.sh
