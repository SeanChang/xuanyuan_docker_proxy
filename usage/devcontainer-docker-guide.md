# DevContainer Docker 镜像源配置教程

轩辕镜像平台已支持 Dev Containers，可以让你在国内环境快速构建开发容器，同时支持 Dev Container Features 安装（如 Poetry、Node.js、Python 工具等）。

## 1. 适用场景

本教程适用于以下开发场景：

| 开发环境 | 是否支持 | 说明 |
|----------|----------|------|
| VS Code Dev Containers | 完全支持 | 通过 Dev Container CLI 管理 |
| 命令行环境 | 完全支持 | 直接使用 CLI 工具 |
| Dev Container Features | 完全支持 | Poetry、Node.js、Python 等 |

## 2. 1. 安装 Dev Containers CLI

Dev Containers CLI 是官方推荐的命令行工具，用于管理 Dev Container。

```bash
npm install -g @devcontainers/cli@latest
```

验证安装是否成功：

```bash
devcontainer --version
```

> **注意**：输出示例：`0.80.1`

如果你在国内环境，请确保 NPM 可以访问，必要时配置国内源：

```bash
npm config set registry https://registry.npmmirror.com
```

## 3. 2. 准备工作空间

在你的项目根目录下创建 .devcontainer 文件夹，并新建 devcontainer.json 文件：

```bash
mkdir -p ~/myproject/.devcontainer
cd ~/myproject/.devcontainer
touch devcontainer.json
```

## 4. 3. 配置 devcontainer.json

下面是一个示例配置，通过轩辕镜像加速拉取 MCR 上的官方基础镜像与 GHCR 上的 Feature，并安装 Poetry：

```json
{
  "name": "my-devcontainer",
  // 基础镜像来源于 MCR（Microsoft Container Registry）
  "image": "xxx-mcr.xuanyuan.run/devcontainers/base:ubuntu-22.04",
  "features": {
    // Feature 来源于 GHCR（GitHub Container Registry）
    // 安装 Poetry 2.x
    "xxx-ghcr.xuanyuan.run/devcontainers-extra/features/poetry:2": {}
  },
  // 可选：指定工作目录挂载一致性
  "workspaceFolder": "/workspace",
  "workspaceMount": "source=${localWorkspaceFolder},target=/workspace,type=bind,consistency=cached"
}
```

**image：**指定基础镜像。官方 Dev Container 基础镜像发布在 MCR（Microsoft Container Registry），通过轩辕镜像加速拉取，注意使用 `xxx-mcr.xuanyuan.run` 前缀。

**features：**可以列出你需要的 Feature，例如 Poetry、Node.js、Python 等。Feature 发布在 GHCR，使用 `xxx-ghcr.xuanyuan.run` 前缀。

> **注意**：**注意区分 Registry 来源：**官方 Dev Container 基础镜像（如 `devcontainers/base`）发布在 MCR（Microsoft Container Registry），需使用 `xxx-mcr.xuanyuan.run`；而 Feature（如 Poetry、Node.js）发布在 GHCR（GitHub Container Registry），需使用 `xxx-ghcr.xuanyuan.run`。VS Code / Dev Container CLI 文档中常省略 Registry 前缀，容易让人误以为基础镜像也在 GHCR 上，实际并非如此。

**workspaceFolder：**容器内的挂载工作目录。

## 5. 4. 启动 Dev Container

在项目根目录运行：

```bash
devcontainer up --workspace-folder ~/myproject
```

CLI 会自动执行以下步骤：

- 从 MCR 拉取基础镜像（通过轩辕镜像加速）
- 拉取并安装指定的 Feature（如 Poetry）
- 挂载工作目录到容器
- 创建可交互开发环境

**常用参数：**

- `--remove-existing-container`：如果容器已存在，先删除再重建
- `--skip-post-create`：跳过初始化命令
- `--log-level trace`：打印详细日志，方便排查下载或安装问题

## 6. 5. 测试 Feature 是否安装成功

进入容器后，可以检查 Poetry 是否已安装：

```bash
poetry --version
```

> **注意**：输出示例：`Poetry (version 2.0.18)`

## 7. 6. 高级用法：添加多个 Feature

在 devcontainer.json 中，可以同时添加多个 Feature：

```json
"features": {
  "xxx-ghcr.xuanyuan.run/devcontainers-extra/features/poetry:2": {},
  "xxx-ghcr.xuanyuan.run/devcontainers-extra/features/node:20": {}
}
```

CLI 会自动拉取并安装所有 Feature，无需手动执行 devcontainer features install。

## 8. 7. 小贴士

调试命令：

```bash
devcontainer up --log-level trace --workspace-folder ~/myproject
```

> **注意**：这样，你就可以直接使用轩辕镜像，快速启动带有 Feature 的 Dev Container 开发环境。

## 9. 常见问题

| 问题描述 | 可能原因 | 解决方法 |
|----------|----------|----------|
| CLI 安装失败 | 网络连接问题；NPM 源访问受限；权限不足 | 配置国内 NPM 源；使用 sudo 权限安装；检查网络连接 |
| 镜像拉取失败 | 轩辕镜像地址配置错误或流量不足 | 检查镜像地址正确性，前往[充值页面](https://xuanyuan.cloud/recharge)充值流量包 |
| Feature 安装失败 | Feature 版本不兼容或网络问题 | 检查 Feature 版本兼容性，使用 --log-level trace 查看详细错误 |
