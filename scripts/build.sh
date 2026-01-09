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

# 切换到 ImageBuilder 工作目录
cd /home/build/immortalwrt

# 加载自定义软件包配置
CUSTOM_PACKAGES=""

if [ -f "shell/custom-packages.sh" ]; then
    echo "正在加载自定义软件包配置..."
    source shell/custom-packages.sh
    echo "自定义软件包: ${CUSTOM_PACKAGES:-无}"
else
    echo "⚠️  未找到 shell/custom-packages.sh，将使用默认配置"
fi

# 构建最终软件包列表
# CUSTOM_PACKAGES 中已包含移除包（-前缀）和所有自定义包
PACKAGES=$(echo "${CUSTOM_PACKAGES} luci luci-ssl-openssl" | xargs)

echo "=========================================="
echo "最终软件包列表: ${PACKAGES}"
echo "=========================================="
echo "软件包处理说明："
echo "  - 移除包（-前缀）会在 ImageBuilder 中自动处理"
echo "  - 自定义包通过 shell/custom-packages.sh 配置"
echo "  - 基础包（luci, luci-ssl-openssl）默认包含"
echo "=========================================="
echo "开始构建固件..."
echo "=========================================="

# 执行构建
make image \
    PROFILE="${PROFILE}" \
    PACKAGES="${PACKAGES}" \
    ROOTFS_PARTSIZE="${ROOTFS_PARTSIZE}" || {
        echo "构建失败！"
        exit 1
    }

echo "=========================================="
echo "构建完成！"
echo "=========================================="

ls -lh bin/targets/*/*/
