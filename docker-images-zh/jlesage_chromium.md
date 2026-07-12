---
image: jlesage/chromium
description: "一个Chromium的Docker容器，其图形用户界面可通过现代网页浏览器访问，无需在客户端安装或配置，便于快速部署和使用开源浏览器。"
source: https://xuanyuan.cloud/zh/r/jlesage/chromium
canonical: https://xuanyuan.cloud/zh/r/jlesage/chromium
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jlesage/chromium" title="jlesage/chromium Docker 镜像中文简介、标签列表与拉取命令">jlesage/chromium 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Chromium Docker容器

[![Release](https://img.shields.io/github/release/jlesage/docker-chromium.svg?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-chromium/releases/latest)
[![Docker Image Size](https://img.shields.io/docker/image-size/jlesage/chromium/latest?logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/chromium/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/jlesage/chromium?label=Pulls&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/chromium)
[![Docker Stars](https://img.shields.io/docker/stars/jlesage/chromium?label=Stars&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/chromium)
[![Build Status](https://img.shields.io/github/actions/workflow/status/jlesage/docker-chromium/build-image.yml?logo=github&branch=master&style=for-the-badge)](https://github.com/jlesage/docker-chromium/actions/workflows/build-image.yml)
[![Source](https://img.shields.io/badge/Source-GitHub-blue?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-chromium)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg?style=for-the-badge)](https://paypal.me/JocelynLeSage)

这是一个[Chromium](https://www.chromium.org/Home/)的Docker容器。

应用程序的图形用户界面（GUI）可通过现代网页浏览器访问，无需在客户端进行任何安装或配置。

> 此Docker容器完全是非官方的，并非由Chromium的创建者制作。

---

[![Chromium logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/chromium-icon.png&w=110)](https://www.chromium.org/Home/)[![Chromium](https://images.placeholders.dev/?width=256&height=110&fontFamily=monospace&fontWeight=400&fontSize=52&text=Chromium&bgColor=rgba(0,0,0,0.0)&textColor=rgba(121,121,121,1))](https://www.chromium.org/Home/)

Chromium是一个开源浏览器项目，旨在为所有用户构建更安全、更快、更稳定的网络体验方式。

---

## 镜像概述和主要用途

该Docker容器提供了Chromium浏览器的容器化部署方案，允许用户通过网页浏览器访问Chromium的图形界面，无需在本地安装浏览器。适用于需要在服务器环境、容器平台或远程访问场景中使用浏览器的需求。

## 核心功能和特性

- **网页访问GUI**：无需本地安装，通过现代网页浏览器即可访问Chromium界面
- **配置持久化**：支持通过卷挂载保存浏览器配置、状态和日志
- **易于部署**：提供简单的Docker命令即可快速启动容器
- **跨平台兼容**：可在任何支持Docker的系统上运行

## 使用场景和适用范围

- 服务器或无头环境中需要浏览器功能的场景
- 远程访问浏览器，避免本地安装和配置
- 开发或测试环境中需要隔离的浏览器实例
- 教学或演示场景中快速部署浏览器环境

## 使用方法和配置说明

### 快速启动

**注意**：
    以下提供的Docker命令仅为示例，参数应根据实际需求进行调整。

使用以下命令启动Chromium Docker容器：

```shell
docker run -d \
    --name=chromium \
    -p 5800:5800 \
    -v /docker/appdata/chromium:/config:rw \
    docker.xuanyuan.run/jlesage/chromium
```

参数说明：
- `-p 5800:5800`：将容器的5800端口映射到主机的5800端口，用于网页访问GUI
- `-v /docker/appdata/chromium:/config:rw`：挂载主机目录用于持久化存储应用配置、状态、日志及其他需要持久化的文件

通过浏览器访问`http://你的主机IP:5800`即可打开Chromium GUI。

## 文档与支持

### 完整文档
完整文档可访问 https://github.com/jlesage/docker-chromium。

### 支持与联系
如在使用容器时遇到问题或有疑问，请[创建新issue](https://github.com/jlesage/docker-chromium/issues)。

其他Docker化应用可访问 https://jlesage.github.io/docker-apps。
