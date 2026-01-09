# 贡献指南

感谢您考虑为 ImmortalWrt R2S Builder 项目做出贡献！

## 贡献方式

### 1. 报告 Bug

如果发现 Bug，请创建 Issue 并包含以下信息：

- **环境信息**：ImmortalWrt 版本、设备型号
- **重现步骤**：详细的操作步骤
- **预期行为**：您期望发生什么
- **实际行为**：实际发生了什么
- **构建日志**：相关的错误日志（如有）

### 2. 提出新功能

在提出新功能前，请先搜索现有 Issues 避免重复。创建 Feature Request 时请说明：

- **功能描述**：清晰描述您希望添加的功能
- **使用场景**：为什么需要这个功能
- **替代方案**：是否考虑过其他解决方案

### 3. 提交代码

#### 开发流程

1. **Fork 本仓库**到您的账号
2. **创建功能分支**：`git checkout -b feature/your-feature-name`
3. **编写代码**并遵循下面的代码规范
4. **测试您的更改**确保构建成功
5. **提交更改**使用规范的提交信息
6. **推送到您的 Fork**：`git push origin feature/your-feature-name`
7. **创建 Pull Request**到本仓库的 `main` 分支

#### 代码规范

**Shell 脚本规范**：

- 使用 `#!/bin/bash` 或 `#!/bin/sh` 明确指定解释器
- 在脚本开头添加 `set -e` 确保错误时退出
- 使用双引号包裹变量：`"${VARIABLE}"`
- 添加清晰的注释说明关键步骤
- 使用 shellcheck 进行静态检查

**配置文件规范**：

- YAML/JSON 使用 2 空格缩进
- UTF-8 编码
- 添加注释说明配置项用途

**提交信息规范**：

遵循 [Conventional Commits](https://www.conventionalcommits.org/zh-hans/) 和 [Gitmoji](https://gitmoji.dev/) 规范：

```
<gitmoji> <type>: <description>

[可选的正文]

[可选的脚注]
```

**Type 类型**：
- `feat`: 新功能
- `fix`: Bug 修复
- `refactor`: 重构（不改变功能）
- `perf`: 性能优化
- `docs`: 文档更新
- `style`: 代码格式（不影响功能）
- `test`: 测试相关
- `chore`: 构建/工具链相关

**Gitmoji 示例**：
- ✨ `:sparkles:` - 新功能
- 🐛 `:bug:` - Bug 修复
- ♻️ `:recycle:` - 重构
- 📝 `:memo:` - 文档
- 🔧 `:wrench:` - 配置
- 🔥 `:fire:` - 删除代码/文件

**提交示例**：

```bash
✨ feat: 添加 R4S 设备支持

- 新增 R4S 设备配置
- 更新构建脚本支持多设备
- 添加 Matrix build 策略
```

#### Pull Request 规范

创建 PR 时请：

- **标题清晰**：简洁描述您的更改
- **详细描述**：说明做了什么、为什么、如何测试
- **关联 Issue**：如果修复了某个 Issue，请在描述中注明 `Fixes #123`
- **保持小而专注**：一个 PR 只做一件事
- **确保 CI 通过**：ShellCheck 和构建测试都应通过

### 4. 更新文档

文档改进同样重要！如果您：

- 发现文档中的错误或不清晰的地方
- 添加了新功能需要说明
- 有更好的使用示例

欢迎提交 PR 更新 README.md 或其他文档。

## 开发环境设置

### 本地测试

1. **克隆仓库**：
   ```bash
   git clone https://github.com/HeminWon/immortalwrt_r2s_builder.git
   cd immortalwrt_r2s_builder
   ```

2. **安装 shellcheck**（可选，用于本地检查）：
   ```bash
   # macOS
   brew install shellcheck

   # Ubuntu/Debian
   apt-get install shellcheck
   ```

3. **运行静态检查**：
   ```bash
   shellcheck scripts/*.sh shell/*.sh
   ```

4. **测试构建**（需要 Docker）：
   ```bash
   # 手动触发 GitHub Actions 或在本地运行 Docker
   docker run --rm \
     -v $PWD/scripts/build.sh:/home/build/immortalwrt/build.sh \
     -v $PWD/shell:/home/build/immortalwrt/shell \
     immortalwrt/imagebuilder:rockchip-armv8-openwrt-24.10.4 \
     bash /home/build/immortalwrt/build.sh
   ```

## 项目结构

```
immortalwrt_r2s_builder/
├── .github/workflows/     # GitHub Actions 工作流
│   ├── build-r2s.yml     # 构建流程
│   └── shellcheck.yml    # Shell 静态检查
├── scripts/              # 核心构建脚本
│   └── build.sh         # 主构建脚本
├── shell/               # 辅助脚本
│   ├── custom-packages.sh    # 软件包配置
│   └── prepare-packages.sh   # 第三方包处理
├── CHANGELOG.md         # 更新日志
├── CONTRIBUTING.md      # 本文件
└── README.md           # 项目文档
```

## 常见问题

### Q: 如何添加新的软件包？

编辑 `shell/custom-packages.sh`，在相应分类下添加：

```bash
CUSTOM_PACKAGES="$CUSTOM_PACKAGES 包名"
```

### Q: 如何支持新的设备型号？

目前需要：
1. 修改 `.github/workflows/build-r2s.yml` 中的 `DEVICE_PROFILE`
2. 修改 Docker 镜像的架构标签
3. 未来计划支持 Matrix build 自动化

### Q: 构建失败怎么办？

1. 检查 GitHub Actions 的完整日志
2. 确认软件包名称正确
3. 检查是否有包冲突
4. 查看 ImmortalWrt 官方文档

## 行为准则

- **尊重他人**：友善、专业地沟通
- **保持耐心**：维护者可能需要时间审查您的贡献
- **接受反馈**：建设性的批评帮助我们改进
- **聚焦技术**：讨论围绕代码和技术问题

## 许可证

通过贡献代码，您同意您的贡献将基于 [MIT License](LICENSE) 授权。

## 联系方式

- **GitHub Issues**：https://github.com/HeminWon/immortalwrt_r2s_builder/issues
- **Pull Requests**：https://github.com/HeminWon/immortalwrt_r2s_builder/pulls

---

再次感谢您的贡献！🎉
