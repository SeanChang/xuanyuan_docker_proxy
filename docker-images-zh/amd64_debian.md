---
image: amd64/debian
description: "Debian是一款完全由自由开源软件组成的Linux发行版。"
source: https://xuanyuan.cloud/zh/r/amd64/debian
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[amd64/debian](https://xuanyuan.cloud/zh/r/amd64/debian)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Debian Docker 镜像文档


## 快速参考

- **维护者**：  
  Debian 开发者 [tianon](https://qa.debian.org/developer.php?login=tianon) 和 [paultag](https://qa.debian.org/developer.php?login=paultag)

- **获取帮助**：  
  [Docker 社区 Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)

- **提交 issue**：  
  [https://github.com/debuerreotype/docker-debian-artifacts/issues](https://github.com/debuerreotype/docker-debian-artifacts/issues?q=)

- **支持的架构**：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
  [`amd64`](https://hub.docker.com/r/amd64/debian/)、[`arm32v5`](https://hub.docker.com/r/arm32v5/debian/)、[`arm32v7`](https://hub.docker.com/r/arm32v7/debian/)、[`arm64v8`](https://hub.docker.com/r/arm64v8/debian/)、[`i386`](https://hub.docker.com/r/i386/debian/)、[`mips64le`](https://hub.docker.com/r/mips64le/debian/)、[`ppc64le`](https://hub.docker.com/r/ppc64le/debian/)、[`riscv64`](https://hub.docker.com/r/riscv64/debian/)、[`s390x`](https://hub.docker.com/r/s390x/debian/)

- **镜像元数据**：  
  [repo-info 仓库的 `repos/debian/` 目录](https://github.com/docker-library/repo-info/blob/master/repos/debian)（[历史记录](https://github.com/docker-library/repo-info/commits/master/repos/debian)）  
  （包含镜像元数据、传输大小等）

- **镜像更新**：  
  [official-images 仓库的 `library/debian` 标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fdebian)  
  [official-images 仓库的 `library/debian` 文件](https://github.com/docker-library/official-images/blob/master/library/debian)（[历史记录](https://github.com/docker-library/official-images/commits/master/library/debian)）

- **文档来源**：  
  [docs 仓库的 `debian/` 目录](https://github.com/docker-library/docs/tree/master/debian)（[历史记录](https://github.com/docker-library/docs/commits/master/debian)）


## 支持的标签及对应 Dockerfile 链接

| 标签 | Dockerfile 链接 |
|------|----------------|
| `bookworm`, `bookworm-20250929`, `12.12`, `12` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/bookworm/oci/index.json) |
| `bookworm-backports` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/bookworm/backports/Dockerfile) |
| `bookworm-slim`, `bookworm-20250929-slim`, `12.12-slim`, `12-slim` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/bookworm/slim/oci/index.json) |
| `bullseye`, `bullseye-20250929`, `11.11`, `11` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/bullseye/oci/index.json) |
| `bullseye-slim`, `bullseye-20250929-slim`, `11.11-slim`, `11-slim` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/bullseye/slim/oci/index.json) |
| `experimental`, `experimental-20250929` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/experimental/Dockerfile) |
| `forky`, `forky-20250929` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/forky/oci/index.json) |
| `forky-backports` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/forky/backports/Dockerfile) |
| `forky-slim`, `forky-20250929-slim` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/forky/slim/oci/index.json) |
| `oldoldstable`, `oldoldstable-20250929` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/oldoldstable/oci/index.json) |
| `oldoldstable-slim`, `oldoldstable-20250929-slim` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/oldoldstable/slim/oci/index.json) |
| `oldstable`, `oldstable-20250929` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/oldstable/oci/index.json) |
| `oldstable-backports` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/oldstable/backports/Dockerfile) |
| `oldstable-slim`, `oldstable-20250929-slim` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/oldstable/slim/oci/index.json) |
| `rc-buggy`, `rc-buggy-20250929` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/rc-buggy/Dockerfile) |
| `sid`, `sid-20250929` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/sid/oci/index.json) |
| `sid-slim`, `sid-20250929-slim` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/sid/slim/oci/index.json) |
| `stable`, `stable-20250929` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/stable/oci/index.json) |
| `stable-backports` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/stable/backports/Dockerfile) |
| `stable-slim`, `stable-20250929-slim` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/stable/slim/oci/index.json) |
| `testing`, `testing-20250929` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/testing/oci/index.json) |
| `testing-backports` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/testing/backports/Dockerfile) |
| `testing-slim`, `testing-20250929-slim` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/testing/slim/oci/index.json) |
| `trixie`, `trixie-20250929`, `13.1`, `13`, `latest` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/trixie/oci/index.json) |
| `trixie-backports` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/trixie/backports/Dockerfile) |
| `trixie-slim`, `trixie-20250929-slim`, `13.1-slim`, `13-slim` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/trixie/slim/oci/index.json) |
| `unstable`, `unstable-20250929` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/unstable/oci/index.json) |
| `unstable-slim`, `unstable-20250929-slim` | [链接](https://github.com/debuerreotype/docker-debian-artifacts/blob/f79b97e304b3069b812f310bbf03562eac1a132e/unstable/slim/oci/index.json) |


## 镜像概述和主要用途

Debian 是一款主要由自由开源软件组成的操作系统，遵循 GNU 通用公共许可证，由 Debian 项目社区开发维护。作为最流行的 Linux 发行版之一，Debian 广泛用于个人计算机和网络服务器，并作为众多其他 Linux 发行版的基础。

本镜像为 `amd64` 架构的 Debian 官方镜像，旨在提供最小化、可靠的基础环境，适用于构建容器化应用、开发环境或作为其他应用镜像的基础层。


## 核心功能和特性

### 1. 最小化基础构建
基于 Debian 的 `minbase` 变体构建（仅包含“必需”软件包），确保最小化镜像体积，同时保留 Debian 系统的核心功能。

### 2. 多版本与变体支持
- **稳定版**：如 `bookworm`（12.x）、`bullseye`（11.x），提供长期支持和稳定性。
- **滚动更新版**：如 `stable`、`testing`、`unstable`，使用滚动套件名称（如 `deb http://deb.debian.org/debian testing main`）。
- **精简版（-slim）**：移除手册页、文档等非必要文件，进一步减小镜像体积，适合资源受限场景。

### 3. 可靠的软件源
默认使用 [deb.debian.org](https://deb.debian.org) CDN 镜像源，确保全球用户的访问可靠性（自 2016-10-20 起成为 `debootstrap` 的默认镜像源）。

### 4. 可重现构建
通过工具 [`debuerreotype`](https://github.com/debuerreotype/debuerreotype) 构建，确保镜像透明可重现，支持基于相同工具链重新生成一致的 rootfs  tarball。

### 5. 多架构支持
除 `amd64` 外，还支持 `arm32v5`、`arm64v8`、`i386`、`ppc64le` 等多种架构（详见“快速参考”部分）。


## 使用场景和适用范围

### 1. 应用基础镜像
作为容器化应用的基础层，提供稳定的 Debian 运行环境，适用于 Python、Node.js、Java 等各类应用。

### 2. 开发与测试环境
快速搭建隔离的 Debian 开发环境，支持安装特定版本的依赖包，便于开发和测试。

### 3. 服务器环境
用于部署轻量级服务（如 Nginx、MySQL、Redis 等），利用-slim 变体可减少资源占用。

### 4. CI/CD 流水线
在持续集成/部署流程中作为构建或测试阶段的基础环境，确保环境一致性。

### 5. 学习与实验
用于学习 Linux 命令、Debian 系统管理或测试跨版本兼容性。


## 详细的使用方法和配置说明

### 基本使用

#### 1. 运行交互式终端
```bash
docker run --rm -it amd64/debian:latest bash
```
- `--rm`：容器退出后自动删除
- `-it`：交互式终端模式
- `amd64/debian:latest`：使用最新稳定版镜像
- `bash`：启动 bash 终端

#### 2. 运行自定义命令
```bash
docker run --rm amd64/debian:bookworm-slim cat /etc/os-release
```
输出 Debian 版本信息。

#### 3. 挂载本地目录
```bash
docker run --rm -it -v $(pwd):/app amd64/debian:trixie-slim bash
```
将当前目录挂载到容器内 `/app` 目录，便于文件交互。


### Docker Compose 配置示例
```yaml
version: '3'
services:
  debian-app:
    image: amd64/debian:bookworm
    container_name: debian-demo
    tty: true  # 保持终端运行
    environment:
      - LANG=C.UTF-8  # 设置默认编码
    volumes:
      - ./data:/data  # 挂载数据卷
    command: bash  # 启动命令
```
启动命令：`docker-compose up -d`


###
