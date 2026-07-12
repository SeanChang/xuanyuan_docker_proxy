---
image: openproject/community
description: "此为旧镜像名称，推荐使用openproject/openproject作为替代"
source: https://xuanyuan.cloud/zh/r/openproject/community
canonical: https://xuanyuan.cloud/zh/r/openproject/community
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openproject/community" title="openproject/community Docker 镜像中文简介、标签列表与拉取命令">openproject/community 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenProject (旧镜像名称)

## 镜像概述和主要用途

本镜像是 OpenProject 项目管理软件的旧镜像名称，已正式重命名为 `openproject/openproject`。建议用户立即迁移至新镜像名称以获取最新功能更新和安全补丁。OpenProject 是一款开源企业级项目管理工具，提供项目规划、任务跟踪、资源管理、团队协作等核心能力，适用于各类团队的项目全生命周期管理。


## 核心功能和特性

OpenProject 作为项目管理平台，主要功能包括：

- **项目规划与跟踪**：支持任务分解、优先级管理、状态跟踪，提供列表、看板、日历等多视图展示
- **资源与工时管理**：资源分配、工时记录与统计，支持成本核算
- **甘特图与进度可视化**：直观展示项目进度、任务依赖关系，支持拖拽调整计划
- **团队协作**：集成讨论区、文档管理、文件共享，支持评论与通知机制
- **报告与分析**：自定义报表、项目状态仪表盘，导出数据（CSV、PDF等格式）
- **多语言支持**：内置20+种语言，适配全球化团队
- **API与集成**：提供REST API，支持与版本控制工具（Git、SVN）、CI/CD系统集成


## 使用场景和适用范围

- **中小型团队协作**：敏捷开发、瀑布式项目管理等多种方法论支持
- **企业级项目管理**：多项目并行管理、跨部门协作、资源统筹分配
- **研发流程跟踪**：需求管理、缺陷跟踪、迭代规划全流程覆盖
- **非技术团队任务管理**：市场活动策划、运营流程优化、行政事务跟踪


## 详细的使用方法和配置说明

### 注意事项

旧镜像名称已停止维护，所有功能更新和问题修复将仅在新镜像 `openproject/openproject` 中提供。以下使用说明基于新镜像编写，建议直接迁移至新镜像。


### 基础使用方法（Docker Run）

```bash
# 启动单节点实例（含内置SQLite，适合测试环境）
docker run -d -p 8080:80 --name openproject docker.xuanyuan.run/openproject/openproject:latest

# 启动持久化存储实例（数据保存在宿主机目录）
docker run -d -p 8080:80 \
  -v /path/to/openproject/data:/var/openproject/assets \
  --name openproject docker.xuanyuan.run/openproject/openproject:latest
```


### 生产环境配置（Docker Compose）

推荐使用 Docker Compose 管理多容器部署（含 PostgreSQL 数据库、持久化存储），示例配置如下：

```yaml
# docker-compose.yml
version: '3'

services:
  openproject:
    image: docker.xuanyuan.run/openproject/openproject:latest
    container_name: openproject
    restart: always
    ports:
      - "8080:80"
    environment:
      - DATABASE_URL=postgresql://openproject:openproject@db:5432/openproject
      - SECRET_KEY_BASE=your-secret-key-here  # 建议使用随机字符串
      - OPENPROJECT_HOST__NAME=your-domain.com  # 访问域名
      - OPENPROJECT_EMAIL__DELIVERY_METHOD=smtp
      - OPENPROJECT_SMTP__ADDRESS=smtp.example.com
      - OPENPROJECT_SMTP__PORT=587
      - OPENPROJECT_SMTP__DOMAIN=example.com
      - OPENPROJECT_SMTP__AUTHENTICATION=login
      - OPENPROJECT_SMTP__USER_NAME=user@example.com
      - OPENPROJECT_SMTP__PASSWORD=smtp-password
      - OPENPROJECT_SMTP__ENABLE_STARTTLS_AUTO=true
    volumes:
      - openproject_data:/var/openproject/assets
    depends_on:
      - db

  db:
    image: docker.xuanyuan.run/postgres:14
    container_name: openproject_db
    restart: always
    environment:
      - POSTGRES_USER=openproject
      - POSTGRES_PASSWORD=openproject
      - POSTGRES_DB=openproject
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  openproject_data:
  postgres_data:
```

启动命令：
```bash
docker-compose up -d
```


### 核心配置参数（环境变量）

| 环境变量键                          | 说明                                                                 | 默认值                                  |
|-----------------------------------|----------------------------------------------------------------------|---------------------------------------|
| `DATABASE_URL`                    | 数据库连接地址（支持PostgreSQL/MySQL）                                 | `sqlite3:///var/openproject/db/production.sqlite3` |
| `SECRET_KEY_BASE`                 | 应用加密密钥（生产环境必须自定义，建议32位以上随机字符串）                   | 自动生成（非持久化，重启后可能导致会话失效）      |
| `OPENPROJECT_HOST__NAME`          | 访问域名/IP（用于生成链接、通知等）                                      | `localhost`                           |
| `OPENPROJECT_PORT`                | 应用监听端口                                                           | `80`                                  |
| `OPENPROJECT_EMAIL__DELIVERY_METHOD` | 邮件发送方式（`smtp`/`sendmail`/`test`）                               | `test`（仅日志输出，不实际发送）         |
| `OPENPROJECT_ATTACHMENTS__STORAGE` | 附件存储方式（`file`/`fog`，`fog`支持S3等云存储）                        | `file`                                |


### 数据持久化与迁移

旧镜像数据迁移至新镜像步骤：
1. 从旧容器导出数据卷：
   ```bash
   docker cp <旧容器ID>:/var/openproject/assets /path/to/backup
   ```
2. 使用新镜像启动容器时挂载备份目录：
   ```bash
   docker run -d -p 8080:80 -v /path/to/backup:/var/openproject/assets --name openproject docker.xuanyuan.run/openproject/openproject:latest
   ```


## 官方资源

- 新镜像地址：[Docker Hub - openproject/openproject](https://hub.docker.com/r/openproject/openproject)
- 官方文档：[OpenProject 官方安装指南](https://www.openproject.org/docs/installation-and-operations/installation/docker/)
- 问题反馈：[GitHub Issues](https://github.com/opf/openproject/issues)
