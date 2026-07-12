# Apple Container 镜像源配置教程

在 Apple Silicon Mac 上使用 Apple 官方 container CLI，通过轩辕镜像专属域名拉取 Docker Hub 等仓库镜像。v1.0.0 不支持全局 registry-mirrors，需在命令中写完整镜像路径并指定 --platform。

## 1. 适用场景

Apple Container 是 Apple 在 macOS 上推出的原生容器运行时（CLI 命令为 `container`），与 Docker Desktop、OrbStack 不同，它不使用 Docker 引擎，也**不支持** `registry-mirrors` 全局镜像源配置。

本教程适用于以下场景：

- Apple Silicon Mac（M 系列芯片，arm64）
- 已安装或准备安装 Apple Container v1.0.0+
- 希望在国内网络下通过轩辕镜像加速拉取容器镜像

> **注意**：若你仍在使用 Docker 引擎，请参考 OrbStack 教程或 Docker Desktop 教程。

## 2. 下载安装

从 Apple 官方 GitHub Releases 页面下载适用于 macOS 的安装包并安装：

https://github.com/apple/container/releases

安装完成后，验证 CLI 是否可用：

```bash
container --version
```

> **注意**：输出示例：`container CLI version 1.0.0`

## 3. 启动服务

首次使用前需启动 container 系统服务。首次运行时会提示安装 Kata 内核，输入 `Y` 确认即可。

```bash
container system start
```

首次启动输出示例（安装内核）：

```
Launching container-apiserver...
No default kernel configured.
Install the recommended default kernel from [...]? [Y/n]: y
Installing kernel...
```

内核安装完成后再次执行 `container system start`，无报错即表示服务已就绪。

## 4. 获取专属域名

登录网站后，在左侧菜单栏的「专属域名」中获取您的专属域名，格式为：`xxx.xuanyuan.run`

> **注意**：请将 **xxx.xuanyuan.run** 替换为您的专属域名。[登录](https://xuanyuan.cloud/)网站后，点击左侧菜单栏的「专属域名」即可获取。

Docker Hub 镜像的完整拉取路径格式为：`xxx.xuanyuan.run/library/镜像名:标签`。更多仓库前缀规则请参考专属域名拉取教程。

## 5. 拉取镜像

> **重要**：必须指定 `--platform linux/arm64`，否则可能拉取全部架构，浪费流量与磁盘空间。

以下对比数据来自 Apple Silicon Mac 实测（nginx:latest）：

| 命令 | blobs | 体积 | 结论 |
|------|-------|------|------|
| --platform linux/arm64 | 10 | ~58.6 MB | 正常，仅本机架构 |
| 不加 --platform | 105 | ~480 MB | 拉全架构，不推荐 |

推荐写法：

```bash
container image pull --platform linux/arm64 xxx.xuanyuan.run/library/nginx:latest
```

以下写法会拉取全部架构，请勿使用：

```bash
container image pull xxx.xuanyuan.run/library/nginx:latest
```

建议写入 shell 配置，避免每次手动加 `--platform`（Apple Container 支持 `CONTAINER_DEFAULT_PLATFORM` 环境变量）：

```bash
echo 'export CONTAINER_DEFAULT_PLATFORM=linux/arm64' >> ~/.zshrc && source ~/.zshrc
```

若已误拉全架构，先删除再重新拉取：

```bash
container image rm xxx.xuanyuan.run/library/nginx:latest
```

## 6. 运行容器

镜像拉取成功后，使用完整镜像路径运行容器，同样需要指定 platform：

```bash
container run --platform linux/arm64 -d -p 8080:80 xxx.xuanyuan.run/library/nginx:latest
```

启动后在浏览器访问 `http://localhost:8080` 验证 nginx 是否正常运行。

## 7. 构建镜像

在 Dockerfile 中将基础镜像改为轩辕专属域名完整路径，然后执行 build：

```dockerfile
FROM xxx.xuanyuan.run/library/node:20

WORKDIR /app
COPY . .
RUN npm install
CMD ["node", "index.js"]
```

```bash
container build --platform linux/arm64 -t my-app:latest -f Dockerfile .
```

## 8. 镜像源配置说明

Apple Container v1.0.0 与 Docker 在镜像源配置上有本质差异，请注意以下限制：

- **不支持 registry-mirrors**：无法像 Docker Desktop / OrbStack 一样配置全局镜像加速，官方明确表示不计划支持 Docker 式 mirrors（[Issue #164](https://github.com/apple/container/issues/164)）
- **`container registry default set` 已移除**：v1.0.0 改用 TOML 配置文件，该 CLI 子命令不再存在
- **配置文件路径**：用户配置位于 `~/.config/container/config.toml`，不是 `~/.container/config.toml`
- **[registry] domain 不推荐用于轩辕镜像**：可将 `nginx` 解析为 `domain/nginx`，但不会自动补 `library/` 前缀，与 Docker Hub 路径不兼容

> **注意**：正确做法：在 pull / run / build 命令中始终使用轩辕专属域名**完整镜像路径**，例如 `xxx.xuanyuan.run/library/nginx:latest`。

## 9. 常见问题

| 问题 | 可能原因 | 解决方法 |
|------|----------|----------|
| 拉取体积过大 / blob 数量异常（如 105 blobs） | 未指定 --platform，拉取了多架构 layer | 加 --platform linux/arm64，或设置 CONTAINER_DEFAULT_PLATFORM |
| HTTP2 Internal Error | 网络波动或首次连接不稳定 | 重试拉取命令，并确保加上 --platform linux/arm64 |
| registry default set 报错 | v1.0.0 已移除此命令 | 改用专属域名完整路径，见本教程「拉取镜像」章节 |
| 首次启动提示安装 kernel | 首次运行需下载 Kata 内核 | 输入 Y 确认安装，完成后再次 container system start |
| GHCR / GCR 等其他仓库怎么拉 | 不同仓库前缀规则不同 | 参考专属域名拉取教程中的多仓库前缀对照 |
