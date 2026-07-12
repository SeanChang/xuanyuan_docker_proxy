---
image: manageiq/postgresql
description: "基于CentOS构建的PostgreSQL容器，专为ManageIQ平台设计，提供可靠的后端数据库服务支持。"
source: https://xuanyuan.cloud/zh/r/manageiq/postgresql
canonical: https://xuanyuan.cloud/zh/r/manageiq/postgresql
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/manageiq/postgresql" title="manageiq/postgresql Docker 镜像中文简介、标签列表与拉取命令">manageiq/postgresql 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 基于CentOS的ManageIQ PostgreSQL容器

## 概述
该容器基于CentOS操作系统构建，集成PostgreSQL数据库服务，专为ManageIQ平台设计，提供稳定、可靠的后端数据库支持，确保ManageIQ各项功能的正常运行。

## 特性
- **稳定基础**：基于CentOS系统，具备良好的兼容性和系统稳定性
- **数据库集成**：内置PostgreSQL数据库服务，提供高效的数据存储与检索能力
- **ManageIQ优化**：针对ManageIQ平台的数据库需求进行预配置，简化集成流程
- **数据持久化**：支持通过数据卷挂载实现数据库数据的持久化存储

## 使用场景
作为ManageIQ平台的后端数据库容器，用于支撑ManageIQ的云资源管理、虚拟化平台监控、自动化运维、合规审计等核心功能，存储平台配置、资源数据、审计日志等关键信息。

## 部署示例
```bash
docker run -d \
  --name manageiq-postgres \
  -p 5432:5432 \
  -v /path/to/local/data:/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=your_secure_password \
  -e POSTGRES_DB=manageiq \
  -e POSTGRES_USER=manageiq_user \
  [镜像名称]
```
*注：请将`/path/to/local/data`替换为本地数据目录，`your_secure_password`替换为实际密码，`[镜像名称]`替换为该容器镜像的具体名称。*
