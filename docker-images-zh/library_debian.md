---
image: library/debian
description: "Debian是一款完全由自由及开源软件构成的Linux发行版，由全球志愿者社区协作开发与维护，始终坚守软件自由与开源的核心原则，提供丰富且经过严格测试的软件包，支持多种硬件架构，以卓越的稳定性、安全性及长期支持特性著称，同时作为众多主流Linux发行版（如Ubuntu）的基础，在开源生态系统中占据重要地位，持续为全球用户及开发者提供可靠的开源计算平台。"
source: https://xuanyuan.cloud/zh/r/library/debian
canonical: https://xuanyuan.cloud/zh/r/library/debian
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/debian" title="library/debian Docker 镜像中文简介、标签列表与拉取命令">library/debian — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/debian" title="library/debian Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/debian</a>

## Debian Docker 镜像介绍


### 快速参考

#### 维护者  
由 Debian 开发者 [tianon]([]) 和 [paultag]([]) 维护。


#### 求助渠道  
可通过以下途径获取帮助：  
- [Docker 社区 Slack]([])  
- [Server Fault]([])  
- [Unix & Linux]([])  
- [Stack Overflow]([])  


### 支持的标签及对应 Dockerfile 链接  
以下是当前支持的镜像标签及其 Dockerfile 源码链接：  

- [`bookworm`, `bookworm-20250929`, `12.12`, `12`]([])  
- [`bookworm-backports`]([])  
- [`bookworm-slim`, `bookworm-20250929-slim`, `12.12-slim`, `12-slim`]([])  
- [`bullseye`, `bullseye-20250929`, `11.11`, `11`]([])  
- [`bullseye-slim`, `bullseye-20250929-slim`, `11.11-slim`, `11-slim`]([])  
- [`experimental`, `experimental-20250929`]([])  
- [`forky`, `forky-20250929`]([])  
- [`forky-backports`]([])  
- [`forky-slim`, `forky-20250929-slim`]([])  
- [`oldoldstable`, `oldoldstable-20250929`]([])  
- [`oldoldstable-slim`, `oldoldstable-20250929-slim`]([])  
- [`oldstable`, `oldstable-20250929`]([])  
- [`oldstable-backports`]([])  
- [`oldstable-slim`, `oldstable-20250929-slim`]([])  
- [`rc-buggy`, `rc-buggy-20250929`]([])  
- [`sid`, `sid-20250929`]([])  
- [`sid-slim`, `sid-20250929-slim`]([])  
- [`stable`, `stable-20250929`]([])  
- [`stable-backports`]([])  
- [`stable-slim`, `stable-20250929-slim`]([])  
- [`testing`, `testing-20250929`]([])  
- [`testing-backports`]([])  
- [`testing-slim`, `testing-20250929-slim`]([])  
- [`trixie`, `trixie-20250929`, `13.1`, `13`, `latest`]([])  
- [`trixie-backports`]([])  
- [`trixie-slim`, `trixie-20250929-slim`, `13.1-slim`, `13-slim`]([])  
- [`unstable`, `unstable-20250929`]([])  
- [`unstable-slim`, `unstable-20250929-slim`]([])  


### 快速参考（续）

#### 问题反馈  
可在 [debuerreotype/docker-debian-artifacts 仓库的 issues 页面]([]) 提交问题。


#### 支持的架构  
支持多种架构，包括：  
[`amd64`]([])、[`arm32v5`]([])、[`arm32v7`]([])、[`arm64v8`]([])、[`i386`]([])、[`mips64le`]([])、[`ppc64le`]([])、[`riscv64`]([])、[`s390x`]([])。


#### 镜像详情  
镜像元数据、传输大小等信息可在 [repo-info 仓库的 `repos/debian/` 目录]([]) 查看（含 [历史记录]([])）。


#### 镜像更新  
- 关注 [official-images 仓库的 `library/debian` 标签]([]) 获取更新动态。  
- 镜像定义文件位于 [official-images 仓库的 `library/debian` 文件]([])（含 [历史记录]([])）。


#### 本文档来源  
本文档内容源自 [docs 仓库的 `debian/` 目录]([])（含 [历史记录]([])）。


### 什么是 Debian？  
Debian 是一款主要由自由开源软件组成的操作系统，多数软件采用 GNU 通用公共许可证，由 Debian 项目团队开发。它是个人电脑和网络服务器中最受欢迎的 Linux 发行版之一，也是众多其他 Linux 发行版的基础。  

> 更多信息：[.org/wiki/Debian]()  

![Debian 标志]([])  


### 关于本镜像  

本仓库的镜像旨在保持最小化（容器的不可变/分层特性决定了“添加比删除更容易”）。具体而言，镜像基于 [“minbase” 变体]([]) 构建，仅包含“必要”软件包，以确保最小的 Debian 系统 footprint（由 Debian 项目的 [发布和 FTP 团队]([]) 定义和管理）。  


#### 标签说明  
- `debian:latest` 始终指向最新稳定版。稳定版也会通过版本号标签标识（如 `debian:11` 对应 `debian:bullseye`，`debian:10` 对应 `debian:buster` 等）。  
- 滚动标签（如 `debian:stable`、`debian:testing`）在 `/etc/apt/sources.list` 中使用滚动套件名称（例如 `deb [] testing main`）。  


#### 镜像源  
默认使用 [deb.debian.org CDN 重定向服务]([]) 作为软件源，以确保对大多数用户的可靠性（自 2016-10-20 起成为 `debootstrap` 的默认源）。详情可参考 [deb.debian.org 主页]([])。  


#### EOL 版本  
若需使用已终止支持（EOL）的 Debian 版本（仅可从 [archive.debian.org]([]) 获取），可参考 [debian/eol 镜像]([])，其中包含早至 Potato（Debian 2.2，首个全面支持 APT 的版本）的标签。  


####  locales 设置  
默认镜像仅包含 `C`、`C.UTF-8` 和 `POSIX` 三种 locale。多数需 UTF-8 环境的场景下，`C.UTF-8` 已足够（可通过 `-e LANG=C.UTF-8` 或 `ENV LANG C.UTF-8` 设置）。  

如需其他 locale，可通过 `locales` 包安装生成。以下是 PostgreSQL 项目的示例方法：  
```dockerfile
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
```  


#### 构建方式  
镜像的 rootfs 压缩包通过 [可重现 Debian 根文件系统工具 `debuerreotype`]([]) 构建，目标是透明且可重现——使用相同工具链可重新生成官方 Debian 镜像的压缩包。具体构建流程可参考该工具仓库中的 [examples/debian.sh 脚本]([])（及配套的 `debian-all.sh` 脚本）。  

此外，[debuerreotype/docker-debian-artifacts 仓库]([]) 中的脚本用于生成各标签的 `Dockerfile`，并将架构特定的压缩包收集到仓库的 [`dist-ARCH` 分支]([])，分支中还包含构建元数据（如基础镜像的软件包版本 `rootfs.manifest`、`debuerreotype` 调用时的 snapshot.debian.org 时间戳 `rootfs.debuerreotype-epoch` 等）。  

各 `rootfs.tar.xz`  artifact 的 SHA256 校验和及完整构建命令可在 [docker.debian.net]([]) 查询。  


### 镜像变体  

#### `debian:<suite>-slim`  
此类标签是精简版镜像的实验性尝试，移除了容器中通常非必需的文件（如 man 页、文档等），具体移除内容可参考 `
