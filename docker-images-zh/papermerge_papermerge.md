---
image: papermerge/papermerge
description: "Papermerge是一个开源文档管理系统(DMS)，用于数字档案的归档和检索，适用于管理扫描文档（如PDF、TIFF格式）等不可编辑信息。"
source: https://xuanyuan.cloud/zh/r/papermerge/papermerge
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[papermerge/papermerge](https://xuanyuan.cloud/zh/r/papermerge/papermerge)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Papermerge REST API Server

## 镜像概述

Papermerge是一个开源文档管理系统(DMS)，专为归档和检索数字文档设计。在Papermerge中，"文档"指适合归档的信息——不需要编辑但需存储以备将来参考的内容（如收据、税务文件等）。扫描文档（通常为PDF或TIFF格式）是其理想管理对象，术语"文档"、"扫描文档"、"PDF文档"和"数字档案"在Papermerge语境中可互换使用。

## 核心功能

- 数字文档归档与检索
- 支持PDF、TIFF等主流扫描文档格式
- 提供REST API接口
- 基于角色的用户认证与授权

## 使用场景

适用于需要长期存储和检索不可编辑信息的场景，如：
- 个人或企业收据、发票管理
- 税务文件归档
- 合同、协议等扫描文档存储
- 各类纸质文档数字化后的管理

## 使用方法

### 快速启动

仅需两个必填环境变量：`PAPERMERGE__MAIN__SECRET_KEY`（系统密钥）和`DJANGO_SUPERUSER_PASSWORD`（超级用户密码）：

```bash
docker run -p 8000:8000 \
    -e PAPERMERGE__MAIN__SECRET_KEY=abc \
    -e DJANGO_SUPERUSER_PASSWORD=123 \
    papermerge/papermerge:latest
```

#### 认证方式
通过`POST http://localhost:8000/api/auth/login/`端点进行认证，默认凭据：
- 用户名：admin
- 密码：123（即`DJANGO_SUPERUSER_PASSWORD`的值）

### 自定义超级用户名

如需指定超级用户名（如john），可使用`DJANGO_SUPERUSER_USERNAME`环境变量：

```bash
docker run -p 8000:8000 \
    -e PAPERMERGE__MAIN__SECRET_KEY=abc \
    -e DJANGO_SUPERUSER_PASSWORD=123 \
    -e DJANGO_SUPERUSER_USERNAME=john \
    papermerge/papermerge:latest
```

### 使用PostgreSQL数据库

默认使用sqlite3数据库，如需使用PostgreSQL，可通过以下docker-compose配置：

```yaml
version: '3.7'
services:
  app:
    image: papermerge/papermerge
    environment:
      - PAPERMERGE__MAIN__SECRET_KEY=abc
      - DJANGO_SUPERUSER_PASSWORD=12345
      - PAPERMERGE__DATABASE__TYPE=postgres
      - PAPERMERGE__DATABASE__USER=postgres
      - PAPERMERGE__DATABASE__PASSWORD=123
      - PAPERMERGE__DATABASE__NAME=postgres
      - PAPERMERGE__DATABASE__HOST=db
    ports:
      - 8000:8000
    depends_on:
      - db
  db:
    image: bitnami/postgresql:14.4.0
    volumes:
      - postgres_data:/var/lib/postgresql/data/
    environment:
      - POSTGRES_PASSWORD=123
volumes:
  postgres_data:
```

上述配置将启动使用PostgreSQL数据库的Papermerge REST API后端服务，数据将持久化存储在`postgres_data`卷中。

> 完整环境变量列表请参考[官方文档](https://docs.papermerge.io/Settings/index.html)
