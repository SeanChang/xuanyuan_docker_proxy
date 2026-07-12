---
image: containerbase/sidecar
description: "containerbase sidecar是Docker Hub上的辅助容器镜像，其源码仓库主分支提交会自动构建并发布该镜像。"
source: https://xuanyuan.cloud/zh/r/containerbase/sidecar
canonical: https://xuanyuan.cloud/zh/r/containerbase/sidecar
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/containerbase/sidecar" title="containerbase/sidecar Docker 镜像中文简介、标签列表与拉取命令">containerbase/sidecar 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# docker-sidecar

[![Build status](https://github.com/containerbase/sidecar/workflows/build/badge.svg)](https://github.com/containerbase/sidecar/actions?query=workflow%3Abuild)
[![Docker Image Size](https://img.shields.io/docker/image-size/renovate/sidecar/latest)](https://hub.docker.com/r/renovate/sidecar)
[![Version](https://img.shields.io/docker/v/renovate/sidecar/latest)](https://hub.docker.com/r/renovate/sidecar)

## 镜像概述和主要用途

本仓库是Docker Hub镜像 `containerbase/sidecar` 的源码仓库。该镜像作为辅助容器（sidecar），用于支持containerbase相关功能的运行，主分支提交会自动触发构建并发布至Docker Hub。

## 核心功能和特性

- **自动构建发布**：主分支代码提交后自动执行构建流程，并将最新镜像发布至Docker Hub。
- **辅助容器支持**：作为sidecar容器，可为主容器提供额外的运行时支持（具体功能需结合containerbase生态使用）。

## 使用场景和适用范围

适用于需要集成containerbase生态的开发、测试或CI/CD环境，可作为辅助组件与主服务协同工作。

## 使用方法和配置说明

### 拉取镜像

通过Docker命令拉取最新版本镜像：

```bash
docker pull docker.xuanyuan.run/containerbase/sidecar:latest
```

### 源码构建与发布

克隆仓库并修改代码后，提交至主分支即可触发自动构建：

```bash
git clone https://github.com/containerbase/sidecar.git
cd sidecar
# 修改代码后提交至main分支
git add .
git commit -m "Update sidecar configuration"
git push origin main
```

> 详细配置及高级功能请参考[官方仓库](https://github.com/containerbase/sidecar)获取最新文档。
