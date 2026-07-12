---
image: dockette/jdk8
description: "提供基于Alpine Linux的Java JDK 8（Oracle和OpenJDK版本）及Maven 3的即用型Docker镜像，适用于Java应用的开发、构建与运行环境。"
source: https://xuanyuan.cloud/zh/r/dockette/jdk8
canonical: https://xuanyuan.cloud/zh/r/dockette/jdk8
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dockette/jdk8" title="dockette/jdk8 Docker 镜像中文简介、标签列表与拉取命令">dockette/jdk8 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Java Docker镜像文档

即用型Java镜像，包含Java JDK 8（Oracle和OpenJDK版本）及Maven 3，基于Alpine Linux构建，轻量高效，适用于Java应用开发与构建。

## 镜像概述和主要用途

本镜像提供预配置的Java开发环境，包含Oracle JDK 8、OpenJDK 8以及集成Oracle JDK 8的Maven 3，均基于Alpine Linux 3.8构建。旨在为Java应用提供轻量级、即用型的开发和构建环境，简化Java项目的部署流程。

## 核心功能和特性

- **轻量级基础**：基于Alpine Linux，镜像体积小，资源占用低
- **多版本支持**：提供Oracle JDK 8、OpenJDK 8两种Java运行环境
- **构建工具集成**：包含Maven 3.5.4，支持Java项目构建
- **即用型设计**：无需额外配置，可直接用于Java应用开发、编译和运行

## 讨论/帮助

[![加入聊天](https://img.shields.io/gitter/room/dockette/dockette.svg?style=flat-square)](https://gitter.im/dockette/dockette?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## 使用方法

### Oracle JDK 8

> Java版本：1.8.0_131-b13

基于Alpine Linux（`dockette/alpine:3.8`）构建的Oracle Java JDK 8镜像。

[![Docker Stars](https://img.shields.io/docker/stars/dockette/jdk8.svg?style=flat)](https://hub.docker.com/r/dockette/jdk8/)
[![Docker Pulls](https://img.shields.io/docker/pulls/dockette/jdk8.svg?style=flat)](https://hub.docker.com/r/dockette/jdk8/)

```bash
docker run -v /path/to/site:/srv docker.xuanyuan.run/dockette/jdk8
```

### OpenJDK 8

> OpenJDK版本：8.171.11-r0

基于Alpine Linux（`dockette/alpine:3.8`）构建的OpenJDK 8镜像。

[![Docker Stars](https://img.shields.io/docker/stars/dockette/openjdk8.svg?style=flat)](https://hub.docker.com/r/dockette/openjdk8/)
[![Docker Pulls](https://img.shields.io/docker/pulls/dockette/openjdk8.svg?style=flat)](https://hub.docker.com/r/dockette/openjdk8/)

```bash
docker run -v /path/to/site:/srv docker.xuanyuan.run/dockette/openjdk8
```

### Maven 3

> Maven版本：3.5.4

基于Alpine Linux（`dockette/alpine:3.8`）构建，集成Oracle Java JDK 8的Maven 3镜像。

[![Docker Stars](https://img.shields.io/docker/stars/dockette/mvn.svg?style=flat)](https://hub.docker.com/r/dockette/mvn/)
[![Docker Pulls](https://img.shields.io/docker/pulls/dockette/mvn.svg?style=flat)](https://hub.docker.com/r/dockette/mvn/)

```bash
docker run -v /path/to/site:/srv docker.xuanyuan.run/dockette/mvn
