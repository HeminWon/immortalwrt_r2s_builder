#!/bin/bash
# ==========================================
# ImmortalWrt R2S 自定义软件包配置
# ==========================================
# 使用说明：
# 1. 默认所有第三方包都已注释，需要时取消注释即可
# 2. 添加包格式：CUSTOM_PACKAGES="$CUSTOM_PACKAGES 包名"
# 3. 移除包格式：CUSTOM_PACKAGES="$CUSTOM_PACKAGES -包名"
# 4. 支持在 workflow 中动态追加包
# ==========================================

# ============ 解决包冲突 ============
# dnsmasq-full 提供更完整的 DNS 功能
CUSTOM_PACKAGES="$CUSTOM_PACKAGES -dnsmasq"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES dnsmasq-full"

# ============ VPN 和代理（默认启用）============
# Tailscale 虚拟局域网
# CUSTOM_PACKAGES="$CUSTOM_PACKAGES tailscale"

# OpenClash 代理工具
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-openclash"

# ============ 基础工具（默认启用）============
CUSTOM_PACKAGES="$CUSTOM_PACKAGES htop"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES wget-ssl"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES curl"

# ============ 网络工具（默认启用）============
CUSTOM_PACKAGES="$CUSTOM_PACKAGES iperf3"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES tcpdump"

# ============ 常用插件（可选）============
# 以下插件默认关闭，需要时取消注释

# 终端工具
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-ttyd"

# ==========================================
# 注意事项：
# 1. Tailscale 组件已默认启用
# 2. R2S 闪存空间有限，过多软件包可能导致构建失败
# 3. 若需移除已有包，使用 -包名 格式
# 4. 修改后需推送到 main 分支或手动触发构建
# ==========================================
