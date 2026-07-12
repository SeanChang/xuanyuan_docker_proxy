---
image: openiamdocker/postgres
description: "OpenIAM专用的PostgreSQL数据库镜像，为OpenIAM身份管理平台提供稳定可靠的数据存储服务，包含预配置的数据库结构和优化设置，支持企业级身份管理场景的数据持久化需求。"
source: https://xuanyuan.cloud/zh/r/openiamdocker/postgres
canonical: https://xuanyuan.cloud/zh/r/openiamdocker/postgres
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openiamdocker/postgres" title="openiamdocker/postgres Docker 镜像中文简介、标签列表与拉取命令">openiamdocker/postgres 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenIAM Postgres Database 镜像文档

## 镜像概述
OpenIAM Postgres Database 是为 OpenIAM 身份管理平台定制的 PostgreSQL 数据库镜像，专门用于支持 OpenIAM 平台的身份管理、访问控制、权限分配、单点登录等核心功能的数据存储需求。该镜像包含预配置的数据库结构、表关系及性能优化设置，可直接与 OpenIAM 应用组件集成，简化 OpenIAM 平台的部署流程。

## 核心功能与特性
### 1. 预配置的数据库结构
- 包含 OpenIAM 平台运行所需的完整数据库表结构、索引及约束条件，无需手动初始化数据库 schema。
- 表结构设计符合 OpenIAM 身份管理模型，支持用户、角色、权限、组织、策略等核心实体的数据存储。

### 2. 优化的 PostgreSQL 配置
- 针对 OpenIAM 平台的读写负载特点，优化了 PostgreSQL 核心参数（如连接池大小、缓存设置、事务日志配置等），提升数据处理性能。
- 内置数据库维护脚本，支持定期备份、索引优化等自动化运维操作。

### 3. 数据持久化支持
- 支持通过 Docker 卷（Volume）实现数据库数据持久化，避免容器重启导致数据丢失。
- 兼容 PostgreSQL 标准的数据备份与恢复机制，支持逻辑备份（pg_dump）和物理备份。

### 4. 版本兼容性
- 严格匹配 OpenIAM 平台的版本依赖，确保数据库结构与 OpenIAM 应用版本同步更新，避免兼容性问题。

## 使用场景
- **OpenIAM 平台部署**：作为 OpenIAM 身份管理平台的核心数据库组件，用于存储用户身份信息、权限策略、访问日志等业务数据。
- **企业级身份管理场景**：适用于企业内部员工身份管理、第三方应用访问控制、多租户权限隔离等场景的数据支撑。
- **开发与测试环境**：可快速搭建 OpenIAM 开发或测试环境，无需手动配置数据库结构。

## 使用方法

### 1. 基本运行命令（docker run）
```bash
docker run -d \
  --name openiam-postgres \
  -p 5432:5432 \
  -e POSTGRES_USER=openiam_admin \
  -e POSTGRES_PASSWORD=your_secure_password \
  -e POSTGRES_DB=openiam_db \
  -v openiam-postgres-data:/var/lib/postgresql/data \
  docker.xuanyuan.run/openiam/postgres:latest
```

**参数说明**：
- `-p 5432:5432`：将容器内 PostgreSQL 服务端口映射到主机 5432 端口。
- `-e POSTGRES_USER`：数据库管理员用户名（默认建议使用 `openiam_admin`）。
- `-e POSTGRES_PASSWORD`：数据库管理员密码（需设置强密码）。
- `-e POSTGRES_DB`：OpenIAM 专用数据库名（默认建议使用 `openiam_db`）。
- `-v openiam-postgres-data:/var/lib/postgresql/data`：挂载卷用于数据持久化，`openiam-postgres-data` 为卷名称。

### 2. Docker Compose 配置示例
在 OpenIAM 平台部署时，推荐与其他组件（如 OpenIAM 应用服务器、Redis 等）通过 `docker-compose.yml` 统一编排：

```yaml
version: '3.8'

services:
  openiam-postgres:
    image: docker.xuanyuan.run/openiam/postgres:latest
    container_name: openiam-postgres
    restart: always
    environment:
      POSTGRES_USER: openiam_admin
      POSTGRES_PASSWORD: your_secure_password
      POSTGRES_DB: openiam_db
      POSTGRES_INITDB_ARGS: "--encoding=UTF8 --lc-collate=C --lc-ctype=en_US.UTF-8"  # 字符集配置
    ports:
      - "5432:5432"
    volumes:
      - openiam-postgres-data:/var/lib/postgresql/data
    networks:
      - openiam-network

  # 其他 OpenIAM 组件（如应用服务器）可通过此网络连接数据库
  openiam-app:
    image: docker.xuanyuan.run/openiam/application:latest
    depends_on:
      - openiam-postgres
    # ... 其他 OpenIAM 应用配置

volumes:
  openiam-postgres-data:  # 定义持久化卷

networks:
  openiam-network:  # 自定义网络，确保组件间通信
```

### 3. 环境变量配置
除基础环境变量外，可通过以下变量进一步自定义数据库行为：

| 环境变量                | 描述                                  | 默认值                  |
|-------------------------|---------------------------------------|-------------------------|
| `POSTGRES_USER`         | 数据库管理员用户名                    | `openiam_admin`         |
| `POSTGRES_PASSWORD`     | 数据库管理员密码                      | 无（必须手动设置）      |
| `POSTGRES_DB`           | OpenIAM 数据库名称                    | `openiam_db`            |
| `PGDATA`                | 数据库数据存储路径                    | `/var/lib/postgresql/data` |
| `POSTGRES_INITDB_ARGS`  | 初始化数据库时的额外参数（如字符集）  | `--encoding=UTF8`       |
| `MAX_CONNECTIONS`       | 最大数据库连接数                      | `100`（OpenIAM 优化值） |

### 4. 连接到 OpenIAM 应用
OpenIAM 应用需通过以下数据库连接信息接入该镜像：
- **数据库类型**：PostgreSQL
- **主机**：容器名称（如 `openiam-postgres`，需在同一 Docker 网络内）或主机 IP
- **端口**：5432（默认，若映射到其他端口需对应修改）
- **数据库名**：`POSTGRES_DB` 环境变量值（默认 `openiam_db`）
- **用户名/密码**：`POSTGRES_USER` 和 `POSTGRES_PASSWORD` 环境变量值

## 数据备份与恢复
### 备份数据库
通过 `docker exec` 执行 `pg_dump` 命令备份数据：
```bash
docker exec openiam-postgres pg_dump -U $POSTGRES_USER -d $POSTGRES_DB > openiam_db_backup.sql
```

### 恢复数据库
将备份文件导入数据库：
```bash
cat openiam_db_backup.sql | docker exec -i openiam-postgres psql -U $POSTGRES_USER -d $POSTGRES_DB
```

## 注意事项
- 生产环境中必须设置强密码，并通过 Docker Secrets 或环境变量加密工具管理敏感信息。
- 建议定期备份数据库数据，避免数据丢失。
- 升级镜像前需确认与 OpenIAM 应用版本的兼容性，避免因数据库结构变更导致应用异常。
