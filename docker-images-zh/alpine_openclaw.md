---
image: alpine/openclaw
description: "OpenClaw - 您的个人AI助手，支持任何操作系统和平台，以独特的“龙虾方式”提供服务。🦞"
source: https://xuanyuan.cloud/zh/r/alpine/openclaw
canonical: https://xuanyuan.cloud/zh/r/alpine/openclaw
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/alpine/openclaw" title="alpine/openclaw Docker 镜像中文简介、标签列表与拉取命令">alpine/openclaw — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/alpine/openclaw" title="alpine/openclaw Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/alpine/openclaw</a>

# OpenClaw Docker镜像文档

## 镜像概述
OpenClaw Docker镜像是个人AI助手OpenClaw的容器化版本，旨在提供跨平台的AI助手服务。当前镜像基于Debian GNU/Linux构建（因musl相关兼容性问题暂未使用Alpine），并自动从官方源`ghcr.io/openclaw/openclaw`进行镜像同步。开发团队正积极解决兼容性问题，计划未来迁移至Alpine构建。

## 核心功能与特性
- **跨平台支持**：可在任何操作系统和平台上运行
- **自动镜像同步**：与官方源保持同步更新
- **安全运行**：提供安全的容器化部署方式
- **本地LLM支持**：支持本地部署大语言模型，无需API成本

## 使用场景
- 个人AI助手日常使用
- 本地部署大语言模型（无API成本）
- 跨操作系统环境下的AI服务部署
- 初学者友好的AI助手容器化实践

## Docker镜像标签
镜像标签信息可在Docker Hub查看：[https://hub.docker.com/repository/docker/alpine/openclaw/tags](https://hub.docker.com/repository/docker/alpine/openclaw/tags)

## 使用方法

### 前提条件
- 已安装Docker
- 已安装bash v4及以上版本

### 快速启动步骤
```bash
# 克隆仓库
git clone https://github.com/ozbillwang/openclaw-in-docker.git
cd openclaw-in-docker

# 设置环境变量
export OPENCLAW_IMAGE="alpine/openclaw:latest"

# 运行部署脚本
./docker-setup.sh
```

### 相关文档
- OpenClaw Docker官方指南：[https://docs.openclaw.ai/install/docker](https://docs.openclaw.ai/install/docker)
- 初学者安全运行指南：[https://medium.com/p/94112a9b57be](https://medium.com/p/94112a9b57be)
- Mac mini本地LLM部署指南：[https://medium.com/p/fb3857f73e0b](https://medium.com/p/fb3857f73e0b)
