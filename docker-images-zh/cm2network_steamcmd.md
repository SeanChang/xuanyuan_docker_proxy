---
image: cm2network/steamcmd
description: "包含Valve的SteamCMD二进制文件的最小化镜像，用于管理和安装Steam游戏服务器。"
source: https://xuanyuan.cloud/zh/r/cm2network/steamcmd
canonical: https://xuanyuan.cloud/zh/r/cm2network/steamcmd
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cm2network/steamcmd" title="cm2network/steamcmd Docker 镜像中文简介、标签列表与拉取命令">cm2network/steamcmd 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# cm2network/steamcmd 镜像文档

[![](https://img.shields.io/codacy/grade/6a8e207cf98246169e633d6f22da9d9c)](https://hub.docker.com/r/cm2network/steamcmd/) [![Docker Build Status](https://img.shields.io/docker/cloud/build/cm2network/steamcmd.svg)](https://hub.docker.com/r/cm2network/steamcmd/) [![Docker Stars](https://img.shields.io/docker/stars/cm2network/steamcmd.svg)](https://hub.docker.com/r/cm2network/steamcmd/) [![Docker Pulls](https://img.shields.io/docker/pulls/cm2network/steamcmd.svg)](https://hub.docker.com/r/cm2network/steamcmd/) [![](https://img.shields.io/docker/image-size/cm2network/steamcmd)](https://img.shields.io/docker/image-size/cm2network/steamcmd) [![Discord](https://img.shields.io/discord/747067734029893653)](https://discord.gg/7ntmAwM)

## 支持的标签及对应 Dockerfile 链接

- [`steam`, `steam-bookworm`, `latest` (*bookworm/Dockerfile*)](https://github.com/CM2Walki/steamcmd/blob/master/bookworm/Dockerfile)
- [`root`, `root-bookworm` (*bookworm/Dockerfile*)](https://github.com/CM2Walki/steamcmd/blob/master/bookworm/Dockerfile)
- [`steam-bullseye`, `bullseye` (*bullseye/Dockerfile*)](https://github.com/CM2Walki/steamcmd/blob/master/bullseye/Dockerfile)
- [`root-bullseye` (*bullseye/Dockerfile*)](https://github.com/CM2Walki/steamcmd/blob/master/bullseye/Dockerfile)

## 镜像概述和主要用途

SteamCMD（Steam 控制台客户端）是 Steam 客户端的命令行版本，主要用于通过命令行界面安装和更新 Steam 上可用的各种专用服务器。它适用于使用 SteamPipe 内容系统的游戏，所有游戏均已从已弃用的 HLDSUpdateTool 迁移到 SteamCMD。

该镜像包含 Valve 的 SteamCMD 二进制文件，设计为最小化镜像，可作为基于 Steam 的专用服务器的基础镜像使用。

## 核心功能和特性

- 提供命令行界面的 Steam 客户端
- 支持安装和更新 Steam 平台上的专用服务器
- 兼容使用 SteamPipe 内容系统的游戏
- 提供非 root 用户安全运行环境
- 支持多种 Debian 版本变体（bookworm、bullseye）
- 可通过数据卷持久化 SteamCMD 安装和登录会话

## 使用场景和适用范围

- 作为游戏服务器 Docker 镜像的基础镜像
- 测试 Steam 平台专用服务器的安装
- 自动化部署和更新 Steam 游戏服务器
- 构建自定义游戏服务器镜像
- 开发和测试与 Steam 服务器相关的应用程序

## 使用方法和配置说明

### 基本交互式使用

可以通过以下命令以交互方式运行镜像：

```console
$ docker run -it --name=steamcmd cm2network/steamcmd bash
$ ./steamcmd.sh +force_install_dir /home/steam/squad-dedicated +login anonymous +app_update 403240 +quit
```

此方法适用于测试特定游戏服务器安装。上述示例命令会安装 SQUAD 专用服务器。

### 使用命名卷持久化数据

```console
# 可选：创建用于存储登录会话的卷
$ docker volume create steamcmd_login_volume
# 可选：创建用于存储 SteamCMD 安装的卷
$ docker volume create steamcmd_volume

$ docker run -it \
    -v "steamcmd_login_volume:/home/steam/Steam" \
    -v "steamcmd_volume:/home/steam/steamcmd" \
    cm2network/steamcmd bash
```

当需要下载非匿名 AppID 或上传 steampipe 构建时，此设置是必要的。

### 配置说明

- SteamCMD 可执行文件路径：`/home/steam/steamcmd.sh`
- 镜像包含 `nano` 文本编辑器，便于配置文件编辑
- 默认工作目录：`/home/steam`
- 默认用户：`steam`（UID 1000）

## 镜像变体

`steamcmd` 镜像提供两种主要变体，适用于不同使用场景：

### `steamcmd:latest`（默认镜像）

这是默认推荐的镜像。如果不确定需求，建议使用此版本。设计用作构建其他镜像的基础，默认用户为 `steam`，在高层 Dockerfile 中执行的任何命令都将以此用户身份执行。

### `steamcmd:root`

这是一个特殊用途镜像，默认用户为 `root`。如果需要为游戏服务器安装额外软件包且不想创建过多层，此版本是合适的选择。

> **注意**：以 `root` 用户运行 `steamcmd.sh` 会失败，因为目录所有者是 `steam` 用户。可以使用 `su steam` 切换用户，或使用 `chown` 更改目录所有权。

## 使用示例

以下是基于此镜像的游戏服务器镜像示例：

| 镜像 | 拉取量 | 构建状态 |
|------|--------|----------|
| [cm2network/cs2](https://hub.docker.com/r/cm2network/cs2/) | [![Docker Pulls](https://img.shields.io/docker/pulls/cm2network/cs2.svg)](https://hub.docker.com/r/cm2network/cs2/) | [![Docker Build Status](https://img.shields.io/docker/cloud/build/cm2network/cs2)](https://hub.docker.com/r/cm2network/cs2/) |
| [cm2network/tf2](https://hub.docker.com/r/cm2network/tf2/) | [![Docker Pulls](https://img.shields.io/docker/pulls/cm2network/tf2.svg)](https://hub.docker.com/r/cm2network/tf2/) | [![Docker Build Status](https://img.shields.io/docker/cloud/build/cm2network/tf2.svg)](https://hub.docker.com/r/cm2network/tf2/) |
| [cm2network/squad](https://hub.docker.com/r/cm2network/squad/) | [![Docker Pulls](https://img.shields.io/docker/pulls/cm2network/squad.svg)](https://hub.docker.com/r/cm2network/squad/) | [![Docker Build Status](https://img.shields.io/docker/cloud/build/cm2network/squad.svg)](https://hub.docker.com/r/cm2network/squad/) |
| [cm2network/mordhau](https://hub.docker.com/r/cm2network/mordhau/) | [![Docker Pulls](https://img.shields.io/docker/pulls/cm2network/mordhau.svg)](https://hub.docker.com/r/cm2network/mordhau/) | [![Docker Build Status](https://img.shields.io/docker/cloud/build/cm2network/mordhau.svg)](https://hub.docker.com/r/cm2network/mordhau/) |
| [cm2network/holdfastnaw](https://hub.docker.com/r/cm2network/holdfastnaw/) | [![Docker Pulls](https://img.shields.io/docker/pulls/cm2network/holdfastnaw.svg)](https://hub.docker.com/r/cm2network/holdfastnaw/) | [![Docker Build Status](https://img.shields.io/docker/cloud/build/cm2network/holdfastnaw.svg)](https://hub.docker.com/r/cm2network/holdfastnaw/) |
| [cm2network/valheim](https://hub.docker.com/r/cm2network/valheim/) | [![Docker Pulls](https://img.shields.io/docker/pulls/cm2network/valheim.svg)](https://hub.docker.com/r/cm2network/valheim/) | [![Docker Build Status](https://img.shields.io/docker/cloud/build/cm2network/valheim.svg)](https://hub.docker.com/r/cm2network/valheim/) |
| [cm2network/steampipe](https://hub.docker.com/r/cm2network/steampipe/) | [![Docker Pulls](https://img.shields.io/docker/pulls/cm2network/steampipe.svg)](https://hub.docker.com/r/cm2network/steampipe/) | [![Docker Build Status](https://img.shields.io/docker/cloud/build/cm2network/steampipe.svg)](https://hub.docker.com/r/cm2network/steampipe/) |
| [cm2network/csgo](https://hub.docker.com/r/cm2network/csgo/) | [![Docker Pulls](https://img.shields.io/docker/pulls/cm2network/csgo.svg)](https://hub.docker.com/r/cm2network/csgo/) | 仓库已归档 |

## 贡献者

[![Contributors Display](https://badges.pufler.dev/contributors/CM2Walki/steamcmd?size=50&padding=5&bots=false)](https://github.com/CM2Walki/steamcmd/graphs/contributors)
