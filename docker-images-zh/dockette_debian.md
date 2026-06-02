---
image: dockette/debian
description: "基于Debian的基础Docker镜像，提供Sid、Jessie、Wheezy等特殊变体，包含预定义用户和优化配置，适用于构建轻量级应用环境。"
source: https://xuanyuan.cloud/zh/r/dockette/debian
canonical: https://xuanyuan.cloud/zh/r/dockette/debian
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [dockette/debian — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/dockette/debian)

含镜像标签、拉取命令、部署文档与相关推荐。

[dockette/debian Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/dockette/debian)

# Debian

基于Debian的基础Docker镜像，提供Sid、Jessie、Wheezy等特殊版本变体。

------

[![Docker Stars](https://img.shields.io/docker/stars/dockette/debian.svg?style=flat)](https://hub.docker.com/r/dockette/debian/)
[![Docker Pulls](https://img.shields.io/docker/pulls/dockette/debian.svg?style=flat)](https://hub.docker.com/r/dockette/debian/)

## 讨论/帮助

[![Join the chat](https://img.shields.io/gitter/room/dockette/dockette.svg?style=flat-square)](https://gitter.im/dockette/dockette?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## 镜像概述

该镜像为基于Debian的基础Docker镜像，提供多种Debian版本变体（包括Sid、Jessie、Wheezy等），适用于作为各类应用构建的基础环境，具备轻量级和优化特性。

## 核心功能与特性

- 预定义用户`dfx`，UID为`1000`
- 预定义常量：
  - `USER_UID`: `1000`
  - `USER_NAME`: `dfx`
  - `USER_HOME`: `/home/dfx`
- 镜像体积优化，提升部署效率

## 使用场景

作为基础镜像，适用于构建基于Debian的各类应用环境，支持多种Debian版本（如Sid、Buster、Stretch、Jessie、Wheezy等），提供标准和精简（slim）两种变体，满足不同资源需求。

## 使用方法

### 命令行运行

可通过以下命令直接运行不同版本的镜像：

```bash
# Sid版本
docker run -it --rm dockette/debian:sid /bin/bash
docker run -it --rm dockette/debian:sid-slim /bin/bash

# Buster版本
docker run -it --rm dockette/debian:buster /bin/bash
docker run -it --rm dockette/debian:buster-slim /bin/bash

# Stretch版本
docker run -it --rm dockette/debian:stretch /bin/bash
docker run -it --rm dockette/debian:stretch-slim /bin/bash

# Jessie版本
docker run -it --rm dockette/debian:jessie /bin/bash
docker run -it --rm dockette/debian:jessie-slim /bin/bash

# Wheezy版本
docker run -it --rm dockette/debian:wheezy /bin/bash
docker run -it --rm dockette/debian:wheezy-slim /bin/bash
```

### 作为基础镜像

在Dockerfile中使用该镜像作为基础进行应用构建：

```dockerfile
FROM dockette/debian:buster-slim

RUN apt update && apt install -y curl
