<!-- xuanyuan-docker-images-zh
image: louislam/dockge
source: https://xuanyuan.cloud/zh/r/louislam/dockge
canonical: https://xuanyuan.cloud/zh/r/louislam/dockge
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/louislam/dockge" title="louislam/dockge Docker 镜像中文简介、标签列表与拉取命令">louislam/dockge — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/louislam/dockge" title="louislam/dockge Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/louislam/dockge</a></p>

# Dockge

## 镜像概述和主要用途

Dockge 是一款简洁易用、响应式的自托管 Docker Compose 栈管理工具，专注于以 `compose.yaml` 为核心的栈式管理。它提供直观的用户界面和实时交互体验，帮助用户轻松创建、编辑、启动、停止、重启和删除 Docker Compose 栈，同时支持镜像更新、交互式终端等功能。Dockge 采用文件式结构，不托管用户的 Compose 文件，确保用户可通过常规 `docker compose` 命令与文件交互。


## 核心功能和特性

- **Compose 栈全生命周期管理**  
  支持 `compose.yaml` 的创建、编辑、启动、停止、重启、删除，以及 Docker 镜像更新。

- **交互式 Compose 编辑器**  
  提供可视化编辑界面，简化 `compose.yaml` 配置过程。

- **交互式 Web 终端**  
  直接在浏览器中与容器进行终端交互。

- **实时响应式体验**  
  所有操作（拉取镜像、启动/停止栈等）的进度和终端输出均实时展示，无需刷新页面。

- **简洁美观的 UI**  
  延续 Uptime Kuma 的 UI/UX 设计风格，操作直观且视觉友好。

- **Docker Run 命令转换**  
  可将 `docker run ...` 命令自动转换为 `compose.yaml` 文件。

- **文件式存储结构**  
  Compose 文件存储在用户本地磁盘，未被托管，可通过常规 `docker compose` 命令直接操作。


## 使用场景和适用范围

### 适用用户  
- 需要集中管理多个 Docker Compose 栈的自托管服务管理员。  
- 追求简洁直观 UI/UX、实时交互体验的 Docker 用户。  
- 希望替代 Portainer 中栈管理功能，解决其在栈部署进度显示不清晰、错误提示模糊等问题的用户。  

### 适用场景  
- 日常 Docker Compose 栈的创建、配置与运维。  
- 通过 Web 界面实时监控栈部署进度和容器运行状态。  
- 将现有 `docker run` 命令标准化为 `compose.yaml` 进行管理。  
- 对现有 Compose 栈进行统一纳管和可视化操作。  


## 安装与部署

### 环境要求  
- Docker 20+ 或 Podman  
- （仅 Podman）需安装 `podman-docker`（Debian 系统：`apt install podman-docker`）  
- 操作系统：支持 Docker/Podman 的主流 Linux 发行版（如 Ubuntu、Debian 11+、Raspbian 11+、CentOS、Fedora、ArchLinux），不支持 Windows 和 Debian/Raspbian Buster 及以下版本。


### 基本安装  
默认栈目录：`/opt/stacks`，默认端口：5001。

```bash
# 创建栈目录和 Dockge 存储目录
mkdir -p /opt/stacks /opt/dockge
cd /opt/dockge

# 下载官方 compose.yaml
curl https://raw.githubusercontent.com/louislam/dockge/master/compose.yaml --output compose.yaml

# 启动 Dockge
docker compose up -d

# 若使用 docker-compose V1 或 Podman，执行：
# docker-compose up -d
```

服务启动后，访问 `http://localhost:5001` 即可打开 Dockge 界面。


### 高级安装（自定义配置）  
如需修改默认端口或栈目录，可通过以下 URL 生成自定义 `compose.yaml`：  

```bash
# 示例：自定义端口为 8080，栈目录为 /path/to/stacks
curl "https://dockge.kuma.pet/compose.yaml?port=8080&stacksPath=/path/to/stacks" --output compose.yaml
```

#### 配置参数说明  
- `port`：Dockge 服务端口（默认 5001）。  
- `stacksPath`：存放 Compose 栈文件的目录（默认 `/opt/stacks`）。  

也可通过 [交互式配置生成器](https://dockge.kuma.pet) 可视化生成 `compose.yaml`。


### 更新方法  
```bash
cd /opt/dockge
docker compose pull && docker compose up -d
```


## 使用方法

### 管理现有 Compose 栈  
若需将已有的 Compose 栈纳入 Dockge 管理：  

1. 停止现有栈：`docker compose down`  
2. 将 Compose 文件移动到栈目录：`mv /path/to/your/compose.yaml /opt/stacks/<栈名称>/compose.yaml`（需创建 `<栈名称>` 子目录）  
3. 在 Dockge 界面右上角下拉菜单中点击 **“扫描栈目录”**  
4. 刷新后即可在栈列表中看到该栈。


### 基本操作流程  
1. **创建栈**：点击界面中的 “+” 按钮，输入栈名称，通过交互式编辑器编写或粘贴 `compose.yaml`，保存后启动。  
2. **编辑栈**：在栈列表中点击目标栈的 “编辑” 按钮，修改 `compose.yaml` 后保存并应用。  
3. **启动/停止/重启栈**：在栈列表中点击对应操作按钮，实时查看进度。  
4. **更新镜像**：在栈详情页点击 “更新镜像”，自动拉取最新镜像并重启栈。  
5. **转换 Docker Run 命令**：在界面导航栏中选择 “Docker Run 转 Compose”，粘贴 `docker run` 命令，自动生成 `compose.yaml`。  


## 常见问题（FAQ）

### “Dockge” 名称由来？  
“Dockge” 是原创词汇，发音类似 “Dodge”，命名灵感来自 Twitch 表情（如 `sadge`、`bedge`）的后缀 “-ge”。


### 是否支持管理单个容器（无 Compose 文件）？  
Dockge 的核心目标是通过 `compose.yaml` 管理所有栈，单个容器建议使用 Portainer 或 Docker CLI 管理。


### 是否可与 Portainer 共存？  
可以。Dockge 专注于 Compose 栈管理，Portainer 提供更多 Docker 功能（如网络、单容器管理），二者可互补使用。


### Dockge 是否为 Portainer 替代品？  
视场景而定：若仅需通过 Compose 栈管理容器，Dockge 可作为替代品；若需管理网络、单容器等其他 Docker 资源，则需配合 Portainer 使用。


## 社区与贡献

### 问题反馈  
提交 Bug 报告：[GitHub Issues](https://github.com/louislam/dockge/issues)


### 讨论与帮助  
寻求帮助或参与讨论：[GitHub Discussions](https://github.com/louislam/dockge/discussions)


### 翻译贡献  
如需将 Dockge 翻译为其他语言，参考 [翻译指南](https://github.com/louislam/dockge/blob/master/frontend/src/lang/README.md)。


### 代码贡献  
提交 PR 前请阅读 [贡献指南](https://github.com/louislam/dockge/blob/master/CONTRIBUTING.md)，项目不接受所有类型的 PR，避免浪费贡献者时间。


## 其他说明  
Dockge 基于 [Compose V2](https://docs.docker.com/compose/migrate/) 构建，`compose.yaml` 即传统的 `docker-compose.yml` 文件。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/louislam/dockge" title="louislam/dockge Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/louislam/dockge</a></p>
