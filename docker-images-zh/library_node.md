<!-- xuanyuan-docker-images-zh
image: library/node
source: https://xuanyuan.cloud/zh/r/library/node
canonical: https://xuanyuan.cloud/zh/r/library/node
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [library/node — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/library/node "library/node Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/library/node

# Node.js Docker 镜像介绍


## 快速参考

### 维护方  
[Node.js Docker 团队]([])

### 获取帮助的途径  
[Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux 论坛]([]) 或 [Stack Overflow]([])


## 支持的标签及对应 Dockerfile 链接  

以下是各版本 Node.js 镜像的常用标签，以及构建这些镜像的 Dockerfile 源码链接（按 Node.js 版本分组）：


### Node.js 24.x（当前版本）  
#### Alpine 基础镜像（轻量级，基于 Alpine Linux）  
- `24-alpine3.21`, `24.10-alpine3.21`, `24.10.0-alpine3.21`, `alpine3.21`, `current-alpine3.21`  
  [对应 Dockerfile]([])  

- `24-alpine`, `24-alpine3.22`, `24.10-alpine`, `24.10-alpine3.22`, `24.10.0-alpine`, `24.10.0-alpine3.22`, `alpine`, `alpine3.22`, `current-alpine`, `current-alpine3.22`  
  [对应 Dockerfile]([])  

#### Debian Bookworm 基础镜像（默认，功能完整）  
- `24`, `24-bookworm`, `24.10`, `24.10-bookworm`, `24.10.0`, `24.10.0-bookworm`, `bookworm`, `current`, `current-bookworm`, `latest`  
  [对应 Dockerfile]([])  

#### Debian Bookworm Slim 精简版（仅含核心依赖）  
- `24-bookworm-slim`, `24-slim`, `24.10-bookworm-slim`, `24.10-slim`, `24.10.0-bookworm-slim`, `24.10.0-slim`, `bookworm-slim`, `current-bookworm-slim`, `current-slim`, `slim`  
  [对应 Dockerfile]([])  

#### 其他 Debian 版本基础镜像  
- Debian Bullseye：`24-bullseye`, `24.10-bullseye`, `24.10.0-bullseye`, `bullseye`, `current-bullseye` 等  
  [对应 Dockerfile]([])  
- Debian Trixie：`24-trixie`, `24.10-trixie`, `24.10.0-trixie`, `current-trixie`, `trixie` 等  
  [对应 Dockerfile]([])  


### Node.js 22.x（LTS 版本，代号 Jod）  
#### Alpine 基础镜像  
- `22-alpine3.21`, `22.20-alpine3.21`, `22.20.0-alpine3.21`, `jod-alpine3.21`, `lts-alpine3.21`  
  [对应 Dockerfile]([])  
- `22-alpine`, `22-alpine3.22`, `22.20-alpine`, `22.20-alpine3.22`, `22.20.0-alpine`, `22.20.0-alpine3.22`, `jod-alpine`, `jod-alpine3.22`, `lts-alpine`, `lts-alpine3.22`  
  [对应 Dockerfile]([])  

#### Debian Bookworm 基础镜像  
- `22`, `22-bookworm`, `22.20`, `22.20-bookworm`, `22.20.0`, `22.20.0-bookworm`, `jod`, `jod-bookworm`, `lts`, `lts-bookworm`, `lts-jod`  
  [对应 Dockerfile]([])  

（其他变体如 Slim、Bullseye、Trixie 等标签及链接可参考官方 Dockerfile 列表）  


### Node.js 20.x（LTS 版本，代号 Iron）  
#### Alpine 基础镜像  
- `20-alpine3.21`, `20.19-alpine3.21`, `20.19.5-alpine3.21`, `iron-alpine3.21`  
  [对应 Dockerfile]([])  
- `20-alpine`, `20-alpine3.22`, `20.19-alpine`, `20.19-alpine3.22`, `20.19.5-alpine`, `20.19.5-alpine3.22`, `iron-alpine`, `iron-alpine3.22`  
  [对应 Dockerfile]([])  

#### Debian Bookworm 基础镜像  
- `20`, `20-bookworm`, `20.19`, `20.19-bookworm`, `20.19.5`, `20.19.5-bookworm`, `iron`, `iron-bookworm`  
  [对应 Dockerfile]([])  

（其他变体标签及链接可参考官方 Dockerfile 列表）  


## 快速参考（续）  

### 问题反馈地址  
[[]]([])  

### 支持的架构  
（更多信息见 [官方说明]([])）  
`amd64`、`arm32v6`、`arm32v7`、`arm64v8`、`ppc64le`、`s390x`  

### 镜像详情  
[repo-info 仓库的 `repos/node/` 目录]([])（含镜像元数据、传输大小等）  

### 镜像更新  
- [official-images 仓库的 `library/node` 标签]([])  
- [official-images 仓库的 `library/node` 文件]([])（更新历史）  

### 本描述的来源  
[docs 仓库的 `node/` 目录]([])（更新历史）  


## 什么是 Node.js？  

Node.js 是用于构建可扩展服务器端和网络应用的软件平台。基于 JavaScript 编写的 Node.js 应用，可在 macOS、Windows 和 Linux 系统的 Node.js 运行时中直接运行，无需修改。  

Node.js 应用通过非阻塞 I/O 和异步事件模型设计，旨在最大化吞吐量和效率。尽管应用本身单线程运行，但 Node.js 会为文件和网络事件启用多线程处理，因此特别适合开发实时应用（如聊天、直播等）。  

Node.js 内部使用 Google V8 JavaScript 引擎执行代码，核心模块多为 JavaScript 编写，并内置异步 I/O 库，支持文件、套接字和 HTTP 通信。借助 HTTP 和套接字支持，Node.js 可直接作为 Web 服务器运行，无需依赖 Apache 等额外软件。  

> 来源：[维基百科 Node.js 条目]()  

![Node.js 标志]([])  


## 如何使用此镜像  

最新使用文档请参考 GitHub 上的 [《如何使用此镜像》]([])。  


## 镜像变体  

`node` 镜像提供多种版本，适用于不同场景：  

### `node:<version>`（默认版本）  
这是最常用的镜像版本。如果不确定需求，优先选择此版本。既可作为临时容器（挂载源码后启动应用），也可作为基础镜像构建其他镜像。  

标签中含 `bookworm`、`bullseye`、`trixie` 等名称的版本，基于对应代号的 Debian 发行版构建。若需在镜像中安装额外依赖，建议显式指定 Debian 版本，减少因系统更新导致的兼容性问题。  

此版本基于 `buildpack-deps` 构建，包含大量常用 Debian 包，可减少衍生镜像的依赖安装量，降低整体镜像体积。  


### `node:<version>-alpine`（Alpine 轻量版）  
基于 [Alpine Linux]([])（镜像体积仅 ~5MB）构建，是追求最小镜像体积的首选。  

**注意**：Alpine 使用 `musl libc` 而非 `glibc`，部分依赖 libc 的软件可能存在兼容性问题（如需要深度系统调用的场景）。若需安装额外工具（如 `git`、`bash`），需在 Dockerfile 中手动添加（参考 [Alpine 镜像使用文档]([])）。  


### `node:<version>-slim`（精简版）  
仅含运行 Node.js 所需的最小依赖，不含默认版本中的常用包。**仅推荐**在资源受限且仅部署 Node.js 镜像的场景使用；其他情况优先选择默认版本。  


## 许可证  

- Node.js 本身的许可证：[查看详情]([])  
- Node.js Docker 项目的许可证：[查看详情]([])  

与所有 Docker 镜像一样，本镜像可能包含其他软件（如 Debian 基础系统的 Bash 等），其许可证需另行确认。部分自动检测的许可证信息可在 [repo-info 仓库的 `node/` 目录]([]) 中查看。  

使用前请确保遵守所有包含软件的许可证要求。
