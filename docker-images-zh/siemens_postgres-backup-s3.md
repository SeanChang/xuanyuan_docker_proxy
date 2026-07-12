---
image: siemens/postgres-backup-s3
description: "提供用于PostgreSQL数据库备份的Docker镜像"
source: https://xuanyuan.cloud/zh/r/siemens/postgres-backup-s3
canonical: https://xuanyuan.cloud/zh/r/siemens/postgres-backup-s3
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/siemens/postgres-backup-s3" title="siemens/postgres-backup-s3 Docker 镜像中文简介、标签列表与拉取命令">siemens/postgres-backup-s3 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PostgreSQL Backup 镜像文档


## 1. 镜像概述

### 1.1 主要用途  
该镜像专为 PostgreSQL 数据库提供自动化备份解决方案，通过集成 `pg_dump` 工具与定时任务调度功能，实现数据库全量/增量备份、备份文件管理及存储策略的统一配置，适用于开发、测试及生产环境的 PostgreSQL 数据保护需求。


## 2. 核心功能与特性

| 功能特性                | 描述                                                                 |
|-------------------------|----------------------------------------------------------------------|
| **定时备份调度**        | 支持通过 cron 表达式配置备份频率（如每日凌晨 2 点、每周日凌晨等）。   |
| **多备份格式支持**      | 兼容 `pg_dump` 原生格式：`plain`（SQL 文本）、`custom`（自定义格式）、`tar`（归档格式）。 |
| **备份压缩**            | 自动对备份文件进行 gzip 压缩，减少存储空间占用。                     |
| **备份保留策略**        | 支持按天数自动清理过期备份文件，避免存储溢出。                       |
| **多存储方式**          | 支持本地目录挂载存储，或对接远程存储（如 S3 兼容对象存储、FTP/SFTP）。|
| **轻量级设计**          | 基于 Alpine 基础镜像构建，体积小，资源占用低。                       |


## 3. 使用场景与适用范围

### 3.1 典型场景  
- **开发/测试环境**：定期备份数据库，避免开发过程中数据丢失。  
- **生产环境**：配置高频率备份（如每小时）+ 长期保留策略，满足数据容灾需求。  
- **多实例管理**：通过统一镜像配置，实现多套 PostgreSQL 实例的标准化备份流程。  

### 3.2 适用版本  
兼容 PostgreSQL 9.6+ 版本（需确保 `pg_dump` 版本与数据库服务版本匹配）。


## 4. 使用方法与配置说明

### 4.1 快速启动（docker run）  
通过 `docker run` 命令快速创建备份任务，示例如下（本地存储+每日备份）：  

```bash
docker run -d \
  --name postgres-backup \
  -e POSTGRES_HOST=postgres-server \    # PostgreSQL 服务地址
  -e POSTGRES_PORT=5432 \              # PostgreSQL 端口
  -e POSTGRES_USER=backup_user \       # 具备备份权限的数据库用户
  -e POSTGRES_PASSWORD=SecurePass123 \ # 数据库用户密码
  -e POSTGRES_DB=target_db \           # 需备份的数据库名（多库用逗号分隔）
  -e BACKUP_SCHEDULE="0 2 * * *" \     # cron 表达式：每日凌晨 2 点执行
  -e BACKUP_RETENTION_DAYS=7 \         # 保留最近 7 天备份
  -v /host/backup/dir:/backup \        # 本地挂载备份目录
  postgres-backup:latest
```


### 4.2 环境变量配置  
| 环境变量                | 必填 | 默认值          | 描述                                                                 |
|-------------------------|------|-----------------|----------------------------------------------------------------------|
| `POSTGRES_HOST`         | 是   | -               | PostgreSQL 服务 IP 或域名。                                          |
| `POSTGRES_PORT`         | 否   | `5432`          | PostgreSQL 服务端口。                                                |
| `POSTGRES_USER`         | 是   | -               | 数据库用户名（需具备 `CONNECT` 和 `SELECT` 权限，或 `pg_dump` 所需权限）。 |
| `POSTGRES_PASSWORD`     | 是   | -               | 数据库用户密码。                                                    |
| `POSTGRES_DB`           | 否   | `postgres`      | 需备份的数据库名，多库用逗号分隔（如 `db1,db2`）。                   |
| `BACKUP_SCHEDULE`       | 否   | `0 0 * * *`     | cron 表达式，定义备份执行时间（如 `*/30 * * * *` 表示每 30 分钟）。   |
| `BACKUP_FORMAT`         | 否   | `custom`        | 备份格式：`plain`（SQL 文本）、`custom`（pg_dump 自定义格式）、`tar`。 |
| `BACKUP_COMPRESS`       | 否   | `true`          | 是否启用 gzip 压缩（`true`/`false`）。                               |
| `BACKUP_RETENTION_DAYS` | 否   | `30`            | 备份文件保留天数（超过则自动删除）。                                 |
| `STORAGE_TYPE`          | 否   | `local`         | 存储类型：`local`（本地）、`s3`（S3 兼容存储）。                     |
| `S3_ENDPOINT`           | 否   | -               | S3 存储端点（如 `https://s3.amazonaws.com`），`STORAGE_TYPE=s3` 时必填。 |
| `S3_BUCKET`             | 否   | -               | S3 存储桶名称，`STORAGE_TYPE=s3` 时必填。                            |
| `S3_ACCESS_KEY`         | 否   | -               | S3 访问密钥，`STORAGE_TYPE=s3` 时必填。                              |
| `S3_SECRET_KEY`         | 否   | -               | S3 密钥，`STORAGE_TYPE=s3` 时必填。                                  |


### 4.3 Docker Compose 示例  
以下为与 PostgreSQL 服务联动的 `docker-compose.yml` 配置示例：  

```yaml
version: '3.8'

services:
  postgres:
    image: docker.xuanyuan.run/postgres:14-alpine
    environment:
      POSTGRES_USER: backup_user
      POSTGRES_PASSWORD: SecurePass123
      POSTGRES_DB: target_db
    volumes:
      - postgres-data:/var/lib/postgresql/data
    restart: unless-stopped

  postgres-backup:
    image: docker.xuanyuan.run/postgres-backup:latest
    depends_on:
      - postgres
    environment:
      POSTGRES_HOST: postgres
      POSTGRES_PORT: 5432
      POSTGRES_USER: backup_user
      POSTGRES_PASSWORD: SecurePass123
      POSTGRES_DB: target_db
      BACKUP_SCHEDULE: "0 2 * * *"       # 每日凌晨 2 点备份
      BACKUP_RETENTION_DAYS: 7           # 保留 7 天备份
      BACKUP_FORMAT: "custom"            # 使用 pg_dump 自定义格式（支持增量恢复）
    volumes:
      - /host/backup/dir:/backup         # 本地备份目录
    restart: unless-stopped

volumes:
  postgres-data:
```


### 4.4 备份文件管理  
- **文件命名规则**：`{数据库名}_{备份时间戳}.{格式}.gz`（如 `target_db_20240520_020000.custom.gz`）。  
- **清理机制**：容器启动时及每次备份后，自动删除超过 `BACKUP_RETENTION_DAYS` 天数的文件。  


### 4.5 恢复方法  
使用 `pg_restore` 工具恢复备份文件（以 `custom` 格式为例）：  

```bash
# 从本地备份文件恢复
pg_restore -h postgres-host -U postgres-user -d target_db /backup/target_db_20240520_020000.custom.gz
```


## 5. 注意事项

1. **权限配置**：挂载的本地备份目录需确保容器内用户（通常为 `postgres` 或 `root`）有读写权限。  
2. **版本兼容性**：镜像内置的 `pg_dump` 版本需与 PostgreSQL 服务版本一致，避免备份格式不兼容。  
3. **密码安全**：生产环境建议通过 Docker Secrets 或环境变量文件传递密码，避免明文暴露。  
4. **网络连通性**：确保备份容器与 PostgreSQL 服务之间网络通畅（可通过 `docker network` 互联）。  
5. **备份验证**：定期手动验证备份文件完整性，建议结合监控工具（如 Prometheus）跟踪备份状态。
