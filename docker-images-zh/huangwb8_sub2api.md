---
image: huangwb8/sub2api
description: "Sub2API是一个AI API网关平台，用于分发和管理AI产品订阅的API配额。"
source: https://xuanyuan.cloud/zh/r/huangwb8/sub2api
canonical: https://xuanyuan.cloud/zh/r/huangwb8/sub2api
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/huangwb8/sub2api" title="huangwb8/sub2api Docker 镜像中文简介、标签列表与拉取命令">huangwb8/sub2api 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Sub2API Docker镜像

## 镜像概述

Sub2API是一个AI API网关平台，主要用于分发和管理AI产品订阅的API配额。它提供了便捷的API资源分配与控制功能，帮助服务提供商有效管理用户的API使用权限。

## 核心功能

- 分发AI产品订阅的API配额
- 管理用户API使用权限与访问控制
- 提供统一的API网关接入点

## 使用场景

适用于AI服务提供商需要对用户的API订阅进行配额管理和分发的场景，可帮助企业控制API资源使用，确保服务稳定性与资源分配公平性。

## 快速启动

使用以下命令快速部署Sub2API容器：

```bash
docker run -d \
  --name sub2api \
  -p 8080:8080 \
  -e DATABASE_URL="postgres://user:pass@host:5432/sub2api" \
  -e REDIS_URL="redis://host:6379" \
  docker.xuanyuan.run/weishaw/sub2api:latest
```

## Docker Compose配置

以下是包含依赖服务（PostgreSQL和Redis）的完整部署配置：

```yaml
version: '3.8'

services:
  sub2api:
    image: docker.xuanyuan.run/weishaw/sub2api:latest
    ports:
      - "8080:8080"
    environment:
      - DATABASE_URL=postgres://postgres:postgres@db:5432/sub2api?sslmode=disable
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis

  db:
    image: docker.xuanyuan.run/postgres:15-alpine
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=sub2api
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: docker.xuanyuan.run/redis:7-alpine
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

## 环境变量

| 变量名 | 描述 | 是否必需 | 默认值 |
|--------|------|----------|--------|
| `DATABASE_URL` | PostgreSQL连接字符串 | 是 | - |
| `REDIS_URL` | Redis连接字符串 | 是 | - |
| `PORT` | 服务器端口 | 否 | `8080` |
| `GIN_MODE` | Gin框架模式（`debug`/`release`） | 否 | `release` |

## 支持的架构

- `linux/amd64`
- `linux/arm64`

## 标签

- `latest` - 最新稳定版本
- `x.y.z` - 特定版本
- `x.y` - 次版本的最新补丁
- `x` - 主版本的最新次版本

## 链接

- [GitHub仓库](https://github.com/weishaw/sub2api)
- [文档](https://github.com/weishaw/sub2api#readme)
