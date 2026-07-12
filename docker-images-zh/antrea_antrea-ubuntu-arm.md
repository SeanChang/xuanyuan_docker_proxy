---
image: antrea/antrea-ubuntu-arm
description: "Antrea的旧版统一arm/v7架构Docker镜像，已弃用，建议使用antrea-ubuntu镜像。"
source: https://xuanyuan.cloud/zh/r/antrea/antrea-ubuntu-arm
canonical: https://xuanyuan.cloud/zh/r/antrea/antrea-ubuntu-arm
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/antrea/antrea-ubuntu-arm" title="antrea/antrea-ubuntu-arm Docker 镜像中文简介、标签列表与拉取命令">antrea/antrea-ubuntu-arm 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Antrea 旧版统一arm/v7镜像

## 镜像概述

本镜像为Antrea的旧版"unified" Docker镜像，专门针对arm/v7架构。**请注意：此镜像已弃用**，建议使用[antrea-ubuntu](https://hub.docker.com/r/antrea/antrea-ubuntu)镜像作为替代方案。

## 核心功能与特性

- 针对arm/v7架构优化的Antrea旧版统一镜像
- 包含Antrea网络功能的传统实现方式
- 仅适用于需要旧版兼容性的特定场景

## 使用场景与适用范围

由于本镜像已弃用，不建议在新部署环境中使用。仅推荐在需要维护依赖此旧版镜像的遗留系统时临时使用，且应尽快迁移至[antrea-ubuntu](https://hub.docker.com/r/antrea/antrea-ubuntu)镜像以获取持续支持。

## 使用方法与配置说明

### 基本信息

鉴于此镜像已弃用，官方不再提供技术支持和更新维护。如需临时使用，可参考以下基本操作：

#### 基本运行命令（不推荐）

```bash
docker run --rm docker.xuanyuan.run/antrea/antrea:legacy-armv7
```

### 迁移建议

强烈建议迁移至[antrea-ubuntu](https://hub.docker.com/r/antrea/antrea-ubuntu)镜像，以获取最新功能、安全更新和官方技术支持。
