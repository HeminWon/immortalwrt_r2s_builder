#!/bin/bash
set -e

echo "=========================================="
echo "ImmortalWrt Builder for NanoPi R2S"
echo "=========================================="

# 环境变量
PROFILE="${PROFILE:-friendlyarm_nanopi-r2s}"
ROOTFS_PARTSIZE="${ROOTFS_PARTSIZE:-1024}"
ROUTER_IP="${ROUTER_IP:-192.168.2.1}"

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

# 处理第三方软件包
if [ -n "$CUSTOM_PACKAGES" ]; then
    echo "=========================================="
    echo "处理第三方软件包..."
    echo "=========================================="

    # 下载 run 文件仓库
    echo "🔄 正在克隆第三方软件包仓库..."
    if ! git clone --depth=1 https://github.com/wukongdaily/store.git /tmp/store-run-repo; then
        echo "❌ 错误：克隆第三方包仓库失败"
        exit 1
    fi

    # 拷贝 run/arm64 下所有文件到 extra-packages 目录
    mkdir -p extra-packages
    if ! cp -r /tmp/store-run-repo/run/arm64/* extra-packages/ 2>/dev/null; then
        echo "⚠️  警告：未找到 run/arm64 目录或目录为空"
    fi

    echo "✅ Run 文件已复制到 extra-packages"
    ls -lh extra-packages/*.run 2>/dev/null || echo "无 .run 文件"

    # 解压并拷贝 ipk 到 packages 目录
    sh shell/prepare-packages.sh

    echo "📦 整理后的 IPK 包："
    ls -lah packages/

    # 添加架构优先级信息（关键步骤）
    echo "⚙️  配置架构优先级..."
    cat > repositories_prefix.conf << 'EOF'
arch aarch64_generic 10
arch aarch64_cortex-a53 15
EOF
    cat repositories_prefix.conf repositories.conf > repositories.conf.tmp
    mv repositories.conf.tmp repositories.conf
    rm repositories_prefix.conf

    echo "✅ 已配置本地包优先级"
    echo "=========================================="
    echo "repositories.conf 配置："
    cat repositories.conf
    echo "=========================================="
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
