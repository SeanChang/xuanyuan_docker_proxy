---
image: linuxserver/lsio-api
description: "该容器为LinuxServer暴露API，硬编码用于LinuxServer仓库，不面向公众使用。"
source: https://xuanyuan.cloud/zh/r/linuxserver/lsio-api
canonical: https://xuanyuan.cloud/zh/r/linuxserver/lsio-api
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/lsio-api" title="linuxserver/lsio-api Docker 镜像中文简介、标签列表与拉取命令">linuxserver/lsio-api 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/lsio-api

## 概述

该容器专门用于为LinuxServer暴露API服务，硬编码适配LinuxServer仓库，不面向公众开放使用。其核心目的是满足LinuxServer内部的API接口需求。

## 核心功能与特性

- 为LinuxServer提供专用API接口服务
- 支持通过环境变量配置用户及组ID（PUID/PGID）、时区（TZ）等基础运行参数
- 提供数据库文件路径（DB_FILE）、缓存失效时间（INVALIDATE_HOURS）等可配置选项
- 通过令牌参数（PAT、SCARF_TOKEN）支持身份验证
- 支持数据持久化，通过挂载卷实现配置与数据库文件的持久存储

## 使用场景

仅限LinuxServer内部环境使用，用于处理与LinuxServer仓库相关的API交互需求。

## 使用方法

### Docker Run 部署示例

```bash
docker run -d \
--name=lsioapi \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=Etc/UTC \
-e CI=0 `#可选` \
-e DB_FILE=/config/api.db `#可选` \
-e INVALIDATE_HOURS=24 `#可选` \
-e PAT=token `#可选` \
-e SCARF_TOKEN=token `#可选` \
-e URL=http://localhost:8000 `#可选` \
-p 8000:8000 \
-v /path/to/lsio-api/config:/config \
--restart unless-stopped \
lscr.io/linuxserver/lsio-api:latest
```

### 环境变量配置说明

| 环境变量 | 描述 | 默认值 |
| :------- | :--- | :----- |
| PUID | 运行容器的用户ID | 1000 |
| PGID | 运行容器的组ID | 1000 |
| TZ | 容器运行时区 | Etc/UTC |
| CI | 持续集成标志（可选，默认0） | 0 |
| DB_FILE | 数据库文件存储路径（可选） | /config/api.db |
| INVALIDATE_HOURS | 缓存失效时间（小时，可选） | 24 |
| PAT | 个人访问令牌（可选，用于身份验证） | - |
| SCARF_TOKEN | Scarf令牌（可选，用于相关服务集成） | - |
| URL | API服务基础URL（可选） | http://localhost:8000 |

### 端口映射

- **8000**：API服务端口，需映射至主机端口以提供外部访问。

### 数据卷挂载

- **/config**：用于存储配置文件及数据库数据，建议挂载本地目录至容器`/config`目录以实现数据持久化。
