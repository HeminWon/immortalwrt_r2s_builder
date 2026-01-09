#!/bin/bash
set -e

echo "=========================================="
echo "ImmortalWrt Builder for NanoPi R2S"
echo "=========================================="

# 环境变量
PROFILE="${PROFILE:-friendlyarm_nanopi-r2s}"
ROOTFS_PARTSIZE="${ROOTFS_PARTSIZE:-1024}"
ROUTER_IP="${ROUTER_IP:-192.168.1.1}"

echo "设备 Profile: ${PROFILE}"
echo "Rootfs 分区大小: ${ROOTFS_PARTSIZE}MB"
echo "路由器 IP: ${ROUTER_IP}"

# 进入 ImageBuilder 目录
cd /builder

# 加载自定义配置
if [ -d "/custom" ]; then
    echo "正在加载自定义配置..."
    if [ -f "/custom/packages.txt" ]; then
        CUSTOM_PACKAGES=$(cat /custom/packages.txt | tr '\n' ' ')
        echo "自定义软件包: ${CUSTOM_PACKAGES}"
    fi
fi

# 默认软件包列表（最小化）
PACKAGES="luci luci-ssl-openssl"

# 添加自定义软件包
if [ -n "${CUSTOM_PACKAGES}" ]; then
    PACKAGES="${PACKAGES} ${CUSTOM_PACKAGES}"
fi

echo "=========================================="
echo "开始构建固件..."
echo "=========================================="

# 执行构建
make image \
    PROFILE="${PROFILE}" \
    PACKAGES="${PACKAGES}" \
    ROOTFS_PARTSIZE="${ROOTFS_PARTSIZE}" \
    FILES="/custom" || {
        echo "构建失败！"
        exit 1
    }

# 复制输出文件
echo "=========================================="
echo "组织输出文件..."
echo "=========================================="

mkdir -p /workdir/output
find bin/targets -name "*.img" -exec cp {} /workdir/output/ \;

echo "构建完成！"
ls -lh /workdir/output/
