# 更新日志

本项目的所有重要变更都将记录在此文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
版本号遵循 [Semantic Versioning](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### 新增
- ✨ 添加 ShellCheck 静态检查工作流

### 变更
- ♻️ 修复 `sed -i` 可移植性问题，改用临时文件方式
- ♻️ 为 `prepare-packages.sh` 添加 `set -e` 错误处理
- ♻️ 为第三方包克隆添加错误处理

### 移除
- 🔥 删除已废弃的 `custom/packages.txt` 文件
- 🔥 删除未使用的 `router_ip.txt` 生成逻辑

## [v2026.01.09-18] - 2026-01-09

### 新增
- ✨ 启用 Tailscale VPN 支持
- ✨ 支持第三方 IPK 包集成
- ✨ 自定义软件包配置

### 变更
- ♻️ 迁移包配置从 txt 到 bash 脚本
- ♻️ 移除默认启用的部分软件包

## 版本号说明

版本号格式：`v{ImmortalWrt版本}-{构建序号}`

- ImmortalWrt版本：上游 ImmortalWrt 固件版本（如 24.10.4）
- 构建序号：本项目的构建次数

---

## 图例说明

- ✨ 新增功能
- 🐛 Bug 修复
- ♻️ 重构/改进
- 🔧 配置变更
- 📝 文档更新
- 🔥 移除功能
- ⚡️ 性能优化
- 🎨 代码格式
- 🔒 安全修复
