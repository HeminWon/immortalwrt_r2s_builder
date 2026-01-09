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
CUSTOM_PACKAGES=""
if [ -f "custom/packages.txt" ]; then
    echo "正在加载自定义软件包..."
    # 读取软件包列表，过滤注释和空行
    CUSTOM_PACKAGES=$(grep -v '^#' custom/packages.txt | grep -v '^$' | tr '\n' ' ' | xargs)
    echo "自定义软件包: ${CUSTOM_PACKAGES}"
fi

# 默认软件包列表（最小化）
PACKAGES="luci luci-ssl-openssl ${CUSTOM_PACKAGES}"

echo "最终软件包列表: ${PACKAGES}"
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
