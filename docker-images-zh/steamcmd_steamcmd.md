---
image: steamcmd/steamcmd
description: "包含SteamCMD二进制文件的Docker镜像，所有镜像通过GitHub Actions每日重建。"
source: https://xuanyuan.cloud/zh/r/steamcmd/steamcmd
canonical: https://xuanyuan.cloud/zh/r/steamcmd/steamcmd
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/steamcmd/steamcmd" title="steamcmd/steamcmd Docker 镜像中文简介、标签列表与拉取命令">steamcmd/steamcmd 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# SteamCMD Docker镜像

[![Build Status](https://github.com/steamcmd/docker/actions/workflows/build.yml/badge.svg)](https://github.com/steamcmd/docker/actions)
[![CodeFactor](https://www.codefactor.io/repository/github/steamcmd/docker/badge)](https://www.codefactor.io/repository/github/steamcmd/docker)
[![Discord Online](https://img.shields.io/discord/928592378711912488.svg)](https://discord.steamcmd.net)
[![Mastodon Follow](https://img.shields.io/mastodon/follow/109302774947550572?domain=https%3A%2F%2Ffosstodon.org&style=flat)](https://fosstodon.org/@steamcmd)
[![Docker Pulls](https://img.shields.io/docker/pulls/steamcmd/steamcmd.svg)](https://hub.docker.com/r/steamcmd/steamcmd)
[![Image Size](https://img.shields.io/docker/image-size/steamcmd/steamcmd/latest.svg)](https://hub.docker.com/r/steamcmd/steamcmd)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/steamcmd)](https://github.com/sponsors/steamcmd)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## 镜像概述和主要用途

SteamCMD Docker镜像是基于多种Docker基础镜像构建的SteamCMD工具容器，用于下载和运行Steam平台的游戏及游戏服务器软件。该镜像通过GitHub Actions每日自动重建，确保包含最新版本的SteamCMD及基础镜像更新。支持多种操作系统基础镜像，满足不同环境需求。

有关SteamCMD的详细信息，请参阅官方[维基文档](https://developer.valvesoftware.com/wiki/SteamCMD)。如需通过编程方式获取SteamCMD相关信息，可访问[steamcmd.net](https://www.steamcmd.net)。

## 核心功能和特性

- **多基础镜像支持**：提供基于Ubuntu、Debian、Alpine、Rocky Linux、CentOS等多种基础镜像的标签，适应不同环境需求。
- **每日自动更新**：通过GitHub Actions每日重建镜像，确保基础系统和SteamCMD始终为最新版本。
- **灵活的下载模式**：支持匿名登录和账号登录两种方式下载Steam资源。
- **数据持久化**：可通过Docker卷挂载本地目录，实现游戏数据的持久化存储。
- **跨平台兼容性**：覆盖主流Linux发行版基础镜像，同时提供Windows基础镜像的Dockerfile（当前暂不可用）。
- **轻量级选项**：Debian系列标签基于`slim`基础镜像，减少镜像体积。

## 使用场景和适用范围

- **游戏服务器部署**：快速搭建Steam平台游戏服务器（如CS:GO、ARK: Survival Evolved等），通过命令行参数指定游戏ID和安装目录。
- **游戏软件自动化下载**：集成到CI/CD流程中，自动下载指定版本的游戏或服务器软件。
- **开发测试环境**：为游戏开发或服务器插件开发提供一致的SteamCMD运行环境。
- **批量资源获取**：通过脚本调用实现多游戏/多版本资源的批量下载和管理。

适用对象包括游戏服务器管理员、自动化运维工程师、游戏开发人员及需要使用SteamCMD的个人用户。

## 标签说明

以下标签均已推送到Docker Hub和GitHub Container Registry（镜像地址格式：`docker.io/steamcmd/steamcmd:<tag>` 或 `ghcr.io/steamcmd/steamcmd:<tag>`）：

- **Ubuntu系列**：
  - [`ubuntu-24`, `ubuntu-noble`, `ubuntu`, `latest`](dockerfiles/ubuntu-24/Dockerfile)
  - [`ubuntu-22`, `ubuntu-jammy`](dockerfiles/ubuntu-22/Dockerfile)
  - [`ubuntu-20`, `ubuntu-focal`](dockerfiles/ubuntu-20/Dockerfile)
  - [`ubuntu-18`, `ubuntu-bionic`](dockerfiles/ubuntu-18/Dockerfile)
  - [`ubuntu-16`, `ubuntu-xenial`](dockerfiles/ubuntu-16/Dockerfile)

- **Debian系列**：
  - [`debian-12`, `debian-bookworm`, `debian`](dockerfiles/debian-12/Dockerfile)
  - [`debian-11`, `debian-bullseye`](dockerfiles/debian-11/Dockerfile)
  - [`debian-10`, `debian-buster`](dockerfiles/debian-10/Dockerfile)

- **Alpine系列**：
  - [`alpine-3`, `alpine`](dockerfiles/alpine-3/Dockerfile)

- **Rocky Linux系列**：
  - [`rocky-9`, `rocky`](dockerfiles/rocky-9/Dockerfile)
  - [`rocky-8`](dockerfiles/rocky-8/Dockerfile)

- **CentOS系列**：
  - [`centos-9`, `centos`](dockerfiles/centos-9/Dockerfile)

- **CachyOS系列**：
  - [`cachyos-3`](dockerfiles/cachyos-3/Dockerfile)
  - [`cachyos`](dockerfiles/cachyos/Dockerfile)

- **Windows系列**（当前不可用）：
  - [`windows-1809`](dockerfiles/windows-1809/Dockerfile)
  - [`windows-core-2025`](dockerfiles/windows-core-2025/Dockerfile)
  - [`windows-core-2022`](dockerfiles/windows-core-2022/Dockerfile)
  - [`windows-core-2019`](dockerfiles/windows-core-2019/Dockerfile)
  - [`windows-core-1809`](dockerfiles/windows-core-1809/Dockerfile)

> **注意**：
> - Windows标签暂不可用，原因是当前GitHub Actions Windows平台无法构建或存在兼容性问题。相关Dockerfile已包含在仓库中，供手动构建或未来平台支持时使用。详见Microsoft文档[Windows容器版本兼容性](https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/version-compatibility)。
> - Debian系列标签基于`slim`基础镜像构建，体积更小。
> - CentOS系列标签基于CentOS Stream镜像（旧版CentOS镜像已废弃）。如需"传统"CentOS环境，推荐使用Rocky Linux标签作为替代。

## 详细的使用方法和配置说明

### 基础操作

#### 拉取最新镜像

```shell
docker pull docker.xuanyuan.run/steamcmd/steamcmd:latest
```

#### 交互式测试

进入容器内部进行命令行交互，验证镜像功能：

```shell
docker run --entrypoint /bin/sh -it docker.xuanyuan.run/steamcmd/steamcmd:latest
```

### 游戏下载示例

#### 匿名下载CS:GO服务器软件

通过匿名登录下载CS:GO服务器（应用ID：740）：

```shell
docker run -it docker.xuanyuan.run/steamcmd/steamcmd:latest +login anonymous +app_update 740 +quit
```

#### 挂载本地目录下载并持久化数据

将游戏文件下载到本地`./data`目录（通过卷挂载实现数据持久化）：

```shell
docker run -it -v $PWD/data:/data docker.xuanyuan.run/steamcmd/steamcmd:latest +login anonymous +force_install_dir /data +app_update 740 +quit
```

**参数说明**：
- `+login anonymous`：使用匿名账号登录SteamCMD（部分资源需账号登录，此时替换为`+login <username> <password>`）。
- `+force_install_dir /data`：指定安装目录（需与挂载目录一致，此处为`/data`）。
- `+app_update 740`：更新指定应用ID的软件（740对应CS:GO服务器），首次运行时为下载安装。
- `+quit`：操作完成后退出SteamCMD。

### 高级配置：自定义命令和脚本

可通过编写Shell脚本实现复杂下载逻辑，例如批量下载多个游戏或定期更新：

1. 创建脚本文件`download.sh`：

```bash
#!/bin/sh
# 登录并更新多个应用
steamcmd +login anonymous \
  +force_install_dir /data/csgo +app_update 740 \
  +force_install_dir /data/ark +app_update 376030 \
  +quit
```

2. 挂载脚本并执行：

```shell
docker run -it -v $PWD/data:/data -v $PWD/download.sh:/download.sh docker.xuanyuan.run/steamcmd/steamcmd:latest sh /download.sh
```

## 许可证

本项目采用[MIT许可证](LICENSE)。
