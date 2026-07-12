---
image: kasmweb/postgres
description: "Kasm Technologies维护的Postgres镜像，包含pg_audit及其他修改。"
source: https://xuanyuan.cloud/zh/r/kasmweb/postgres
canonical: https://xuanyuan.cloud/zh/r/kasmweb/postgres
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/postgres" title="kasmweb/postgres Docker 镜像中文简介、标签列表与拉取命令">kasmweb/postgres 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kasm Technologies 维护的 Postgres 镜像文档


## 1. 镜像概述

本镜像是由 Kasm Technologies 维护的 PostgreSQL 数据库镜像，基于官方 PostgreSQL 镜像构建，包含 `pg_audit` 审计扩展及其他定制化修改，旨在提供增强的数据库审计能力和灵活的配置选项。


## 2. 核心功能与特性

### 2.1 核心功能
- **原生 PostgreSQL 兼容性**：完整继承官方 PostgreSQL 镜像的所有功能，支持标准 SQL 语法、事务、存储过程等核心特性。
- **内置 pg_audit 扩展**：集成 PostgreSQL 官方审计扩展 `pg_audit`，可细粒度记录数据库活动（如 DDL、DML 操作、用户登录/退出等）。
- **定制化配置支持**：提供额外的配置接口，支持通过环境变量或配置文件调整数据库参数，满足特定场景需求。

### 2.2 关键特性
- **审计日志增强**：通过 `pg_audit` 实现合规性审计，支持按操作类型（如 `ddl`、`write`、`read`）、用户角色、数据库对象等维度配置审计规则。
- **开箱即用**：无需手动编译或安装 `pg_audit`，镜像启动时可自动启用扩展（需配置）。
- **灵活部署**：支持单机运行、容器编排（如 Docker Compose、Kubernetes），兼容主流容器化部署环境。


## 3. 使用场景与适用范围

### 3.1 适用场景
- **企业级应用数据库**：需满足内部审计或外部合规要求（如 GDPR、HIPAA、SOX）的业务系统。
- **金融/政务系统**：对数据操作可追溯性要求高的场景，需记录敏感数据访问及修改行为。
- **开发/测试环境**：需要模拟生产环境审计规则的开发或测试场景，验证应用数据操作合规性。
- **定制化数据库需求**：需调整 PostgreSQL 默认配置（如连接池、内存分配、日志策略）的场景。

### 3.2 不适用场景
- 对审计功能无需求且追求最小镜像体积的场景（建议直接使用官方 PostgreSQL 镜像）。


## 4. 使用方法与配置说明

### 4.1 基本运行

#### 4.1.1 最简启动命令
```bash
docker run -d \
  --name kasm-postgres \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -p 5432:5432 \
  docker.xuanyuan.run/kasmtech/postgres:latest
```

#### 4.1.2 数据持久化
通过挂载卷（Volume）持久化数据库数据，避免容器删除后数据丢失：
```bash
docker run -d \
  --name kasm-postgres \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -v /path/on/host/postgres-data:/var/lib/postgresql/data \  # 持久化数据目录
  -p 5432:5432 \
  kasmtech/postgres:latest
```


### 4.2 环境变量

#### 4.2.1 标准 PostgreSQL 环境变量
支持官方 PostgreSQL 镜像的所有标准环境变量，核心变量如下：

| 环境变量名              | 说明                                  | 默认值          |
|-------------------------|---------------------------------------|-----------------|
| `POSTGRES_DB`           | 初始化数据库名称                      | `postgres`      |
| `POSTGRES_USER`         | 数据库管理员用户名                    | `postgres`      |
| `POSTGRES_PASSWORD`     | 管理员用户密码（必填）                | 无              |
| `POSTGRES_INITDB_ARGS`  | `initdb` 命令额外参数（如字符集配置） | 无              |


#### 4.2.2 Kasm 定制环境变量
针对 `pg_audit` 及定制化配置的扩展变量：

| 环境变量名                          | 说明                                  | 默认值          |
|-------------------------------------|---------------------------------------|-----------------|
| `KASM_PGAUDIT_ENABLE`               | 是否启用 `pg_audit` 扩展（`true`/`false`） | `true`          |
| `KASM_PGAUDIT_LOG`                  | `pg_audit` 审计日志级别（如 `ddl,write`） | `ddl`           |
| `KASM_POSTGRES_CONFIG_EXTRA`        | 额外的 PostgreSQL 配置参数（键值对，逗号分隔，如 `max_connections=100,shared_buffers=256MB`） | 无 |


### 4.3 Docker Compose 配置示例

```yaml
version: '3.8'

services:
  postgres:
    image: docker.xuanyuan.run/kasmtech/postgres:latest
    container_name: kasm-postgres
    restart: always
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: ${DB_PASSWORD}  # 建议通过环境变量文件传入，避免明文
      POSTGRES_DB: appdb
      KASM_PGAUDIT_ENABLE: "true"
      KASM_PGAUDIT_LOG: "ddl, write, function"  # 审计 DDL、写操作及函数调用
      KASM_POSTGRES_CONFIG_EXTRA: "max_connections=200,log_min_messages=notice"
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data  # 命名卷持久化数据
    networks:
      - app-network

networks:
  app-network:
    driver: bridge

volumes:
  postgres-data:  # 自动创建命名卷
```


### 4.4 pg_audit 扩展配置

#### 4.4.1 基础配置（通过环境变量）
若已设置 `KASM_PGAUDIT_ENABLE=true`，镜像启动时会自动加载 `pg_audit` 扩展并应用 `KASM_PGAUDIT_LOG` 配置。例如：
```bash
docker run -d \
  --name kasm-postgres \
  -e POSTGRES_PASSWORD=secret \
  -e KASM_PGAUDIT_ENABLE=true \
  -e KASM_PGAUDIT_LOG="ddl, write, read" \  # 审计 DDL、写操作、读操作
  kasmtech/postgres:latest
```


#### 4.4.2 高级配置（手动修改配置文件）
如需更细粒度控制 `pg_audit` 规则，可通过以下步骤修改配置：

1. **进入容器**：
   ```bash
   docker exec -it kasm-postgres bash
   ```

2. **编辑 PostgreSQL 配置文件**：
   ```bash
   vi /var/lib/postgresql/data/postgresql.conf
   ```

3. **调整 `pg_audit` 配置**（示例）：
   ```ini
   # 启用 pg_audit（镜像默认已配置，无需重复设置）
   shared_preload_libraries = 'pg_audit'  # 确保包含 pg_audit
   
   # 审计规则配置
   pg_audit.log = 'ddl, write, function'  # 审计 DDL、写操作、函数调用
   pg_audit.log_catalog = on  # 审计系统目录操作
   pg_audit.log_parameter = on  # 记录 SQL 参数值
   pg_audit.log_relation = on  # 记录关联表名
   ```

4. **重启 PostgreSQL 服务**：
   ```bash
   su - postgres -c "pg_ctl reload"
   ```


## 5. 注意事项

- **版本兼容性**：镜像版本需与业务依赖的 PostgreSQL 版本匹配（如 `kasmtech/postgres:16` 对应 PostgreSQL 16.x）。
- **数据备份**：建议定期备份持久化卷数据，可通过 `pg_dump` 工具或第三方备份方案（如 WAL-G）实现。
- **安全最佳实践**：生产环境中避免使用明文密码，建议通过 Docker Secrets 或外部密钥管理系统（如 Vault）注入密码。
- **审计日志管理**：`pg_audit` 日志默认写入 PostgreSQL 日志文件，需配置日志轮转（如 `logrotate`）避免磁盘占满。
