# ImmortalWrt Builder for NanoPi R2S

基于 GitHub Actions 自动构建 ImmortalWrt 固件，专为 NanoPi R2S 设备优化。

## 特性

- ✅ 基于 ImmortalWrt 24.10.4 稳定版本
- ✅ 专注于 NanoPi R2S 设备
- ✅ 使用官方 Docker ImageBuilder，无需本地编译环境
- ✅ 最小化配置，易于理解和定制
- ✅ 自动生成 Release 和 Artifacts
- ✅ 支持自定义软件包列表

## 快速开始

### 方式一：手动触发构建

1. 进入仓库的 **Actions** 标签页
2. 选择 **Build ImmortalWrt for NanoPi R2S** workflow
3. 点击 **Run workflow** 按钮
4. 可选配置参数：
   - **路由器 IP 地址**: 默认 `192.168.1.1`
   - **Rootfs 分区大小**: 默认 `1024` MB
5. 等待构建完成（约 10-20 分钟）

### 方式二：自动触发构建

修改以下文件并推送到 `main` 分支将自动触发构建：
- `.github/workflows/build-r2s.yml`
- `scripts/build.sh`
- `custom/packages.txt`

## 目录结构

```
.
├── .github/
│   └── workflows/
│       └── build-r2s.yml          # GitHub Actions 工作流配置
├── scripts/
│   └── build.sh                   # 核心构建脚本
├── custom/
│   ├── packages.txt               # 自定义软件包列表
│   └── router_ip.txt              # 自动生成的路由器 IP（构建时）
└── output/                        # 构建输出目录（自动生成）
```

## 自定义配置

### 修改软件包

编辑 `custom/packages.txt` 文件：

```bash
# 添加软件包
htop
curl
iperf3

# 移除软件包（使用 - 前缀）
-dnsmasq
```

常用软件包参考：
- `luci-app-ttyd` - 终端工具
- `luci-app-upnp` - UPnP 支持
- `luci-app-uhttpd` - HTTP 服务器配置
- `iperf3` - 网络性能测试
- `tcpdump` - 网络抓包工具

### 修改构建参数

编辑 `.github/workflows/build-r2s.yml` 中的环境变量：

```yaml
env:
  IMMORTALWRT_VERSION: '24.10.4'       # ImmortalWrt 版本
  DEVICE_PROFILE: 'friendlyarm_nanopi-r2s'  # 设备型号
```

## 固件刷入

1. 从 **Releases** 页面下载最新固件（`.img.gz` 文件）
2. 解压得到 `.img` 文件
3. 使用工具刷入存储设备：
   - **Windows**: [balenaEtcher](https://www.balena.io/etcher/) 或 [Rufus](https://rufus.ie/)
   - **macOS**: balenaEtcher 或 `dd` 命令
   - **Linux**: `dd` 命令
4. 将存储设备插入 R2S，上电启动

### macOS/Linux 使用 dd 命令示例

```bash
# 查看设备
diskutil list  # macOS
lsblk          # Linux

# 卸载设备（macOS）
diskutil unmountDisk /dev/diskX

# 写入镜像
sudo dd if=immortalwrt-xxx.img of=/dev/diskX bs=4M status=progress

# 同步
sync
```

⚠️ **警告**: 请确保 `of=` 参数指向正确的设备，错误的设备会导致数据丢失！

## 默认配置

- **管理地址**: http://192.168.1.1（可在构建时自定义）
- **用户名**: root
- **密码**: password
- **SSH**: 端口 22，使用 root 登录

## 技术细节

### 构建流程

1. **环境初始化**: 设置时区和构建参数
2. **Docker 容器**: 拉取官方 ImmortalWrt ImageBuilder 镜像
3. **配置加载**: 读取自定义软件包和配置
4. **固件编译**: 使用 ImageBuilder 生成固件
5. **文件输出**: 压缩固件并上传到 Artifacts 和 Releases

### Docker 镜像

使用阿里云镜像加速：
```
registry.cn-shanghai.aliyuncs.com/sulinggg/immortalwrt:rockchip-24.10.4
```

### 依赖项

- Ubuntu latest runner
- Docker（GitHub Actions 预装）
- 无需本地构建环境

## 故障排查

### 构建失败

1. 检查 Actions 日志中的错误信息
2. 验证 `custom/packages.txt` 中的软件包名称是否正确
3. 确保 Docker 镜像版本与 ImmortalWrt 版本匹配

### 固件无法启动

1. 确认镜像完整性（检查 SHA256）
2. 重新刷入固件
3. 尝试使用不同的存储设备

### 无法访问管理界面

1. 检查网络连接
2. 确认 IP 地址配置（默认 192.168.1.1）
3. 尝试使用 SSH 连接调试

## 参考资源

- [ImmortalWrt 官方文档](https://immortalwrt.org/)
- [OpenWrt Wiki](https://openwrt.org/docs/start)
- [NanoPi R2S 硬件信息](https://wiki.friendlyelec.com/wiki/index.php/NanoPi_R2S)

## License

MIT License
