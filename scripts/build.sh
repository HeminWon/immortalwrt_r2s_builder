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

# 加载自定义软件包
REMOVE_PACKAGES=""
ADD_PACKAGES=""

if [ -f "custom/packages.txt" ]; then
    echo "正在加载自定义软件包..."

    # 分离移除包（-开头）和普通包
    # 关键：移除指令必须在依赖链之前，避免包冲突
    REMOVE_PACKAGES=$(grep -v '^#' custom/packages.txt | grep -v '^$' | grep '^-' | tr '\n' ' ')
    ADD_PACKAGES=$(grep -v '^#' custom/packages.txt | grep -v '^$' | grep -v '^-' | tr '\n' ' ')

    echo "移除的软件包: ${REMOVE_PACKAGES:-无}"
    echo "添加的软件包: ${ADD_PACKAGES:-无}"
fi

# 构建最终软件包列表
# 移除包在最前面 → 自定义包 → 基础包
PACKAGES=$(echo "${REMOVE_PACKAGES} ${ADD_PACKAGES} luci luci-ssl-openssl" | xargs)

echo "最终软件包列表: ${PACKAGES}"
echo "=========================================="
echo "软件包处理说明："
echo "  - 移除包（-前缀）优先处理，避免依赖冲突"
echo "  - 自定义包按 packages.txt 顺序添加"
echo "  - 基础包（luci, luci-ssl-openssl）放在最后"
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
