---
image: dr34m/openclaw
description: "每10分钟自动从官方仓库ghcr.io/openclaw/openclaw同步的Docker镜像，通过Github Action实现安全透明同步，无恶意软件风险。"
source: https://xuanyuan.cloud/zh/r/dr34m/openclaw
canonical: https://xuanyuan.cloud/zh/r/dr34m/openclaw
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dr34m/openclaw" title="dr34m/openclaw Docker 镜像中文简介、标签列表与拉取命令">dr34m/openclaw — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/dr34m/openclaw" title="dr34m/openclaw Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/dr34m/openclaw</a>

# OpenClaw 自动同步 Docker 镜像

## 镜像概述

本镜像每10分钟自动从官方仓库`ghcr.io/openclaw/openclaw`同步更新，确保用户能够获取到最新版本的OpenClaw应用。通过[Github Action](https://github.com/dr34m-cn/openclaw-docker)实现自动化同步流程，保证同步过程的安全性、透明度，杜绝恶意软件感染风险。

## 核心功能与特性

- **实时同步**：每10分钟与官方仓库保持同步，确保镜像版本最新
- **安全透明**：基于Github Action的公开同步机制，同步过程可追溯，无恶意软件注入风险
- **多标签支持**：提供`latest`、`main`和`main-slim`等多个标签，满足不同使用需求

## 使用场景

适用于需要快速获取OpenClaw官方最新镜像的用户或开发者，尤其适合对镜像安全性和实时性有较高要求的场景。

## 使用方法

### 拉取镜像

可通过以下命令拉取不同标签的镜像：

```sh
# 拉取最新版本
docker pull dr34m/openclaw:latest

# 拉取main分支版本
docker pull dr34m/openclaw:main

# 拉取main分支的精简版本
docker pull dr34m/openclaw:main-slim
```

### 镜像使用

拉取完成后，可通过常规Docker命令运行镜像，具体运行参数请参考OpenClaw官方文档。
