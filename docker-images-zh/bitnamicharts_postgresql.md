---
image: bitnamicharts/postgresql
description: "Bitnami的PostgreSQL Helm chart，用于在Kubernetes环境中便捷部署和管理PostgreSQL数据库，支持灵活配置与可靠运行。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/postgresql
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[bitnamicharts/postgresql](https://xuanyuan.cloud/zh/r/bitnamicharts/postgresql)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami PostgreSQL 镜像文档

## 镜像概述和主要用途

PostgreSQL（简称Postgres）是一款开源对象关系型数据库，以可靠性和数据完整性著称。它符合ACID标准，支持外键、连接、视图、触发器和存储过程。Bitnami PostgreSQL镜像为PostgreSQL提供了预配置、随时可用的容器化部署方案，优化了安全性和易用性，适用于开发、测试和生产环境。

[PostgreSQL 官方概述](http://www.postgresql.org)

**商标说明**：本软件列表由Bitnami打包。所提及的商标分属各自公司所有，使用这些商标不意味着任何关联或背书。


## 核心功能和特性

- **ACID合规**：确保事务的原子性、一致性、隔离性和持久性
- **高可用性**：支持主从复制架构，可部署为高可用集群（参见[postgresql-ha 仓库](https://github.com/bitnami/charts/tree/main/bitnami/postgresql-ha)）
- **安全加固**：默认以非root用户运行，遵循容器安全最佳实践
- **灵活认证**：支持内置认证及LDAP集成
- **数据加密**：支持TLS加密连接
- **监控集成**：内置Prometheus指标导出器（postgres_exporter）
- **自定义配置**：支持通过配置文件或环境变量自定义postgresql.conf和pg_hba.conf
- **持久化存储**：支持数据持久化，兼容Docker卷和Kubernetes PV
- **密码管理**：提供自动密码更新机制，支持通过作业或手动更新密码
- **网络策略**：支持Kubernetes网络策略，限制Pod间通信
- **多版本支持**：可通过镜像标签指定不同PostgreSQL版本


## 使用场景和适用范围

### 适用场景
- **开发环境**：快速搭建独立PostgreSQL实例，用于应用开发和测试
- **测试环境**：部署主从复制架构，验证应用在读写分离场景下的表现
- **生产环境**：搭配Bitnami Secure Images（需商业许可），用于生产级数据库部署，提供安全加固和长期支持

### 适用范围
- 需要可靠关系型数据库的应用系统
- 对数据完整性和事务支持有要求的业务场景
- 需在Kubernetes或Docker环境中快速部署PostgreSQL的用户
- 要求符合安全标准（如非root运行、最小权限）的部署环境


## 快速开始

### Docker 快速启动

```bash
# 简单启动（非持久化，仅用于测试）
docker run --name postgresql -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 bitnami/postgresql:latest

# 持久化启动（数据保存在宿主机目录）
docker run --name postgresql \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_DB=mydb \
  -v /path/on/host:/bitnami/postgresql \
  -p 5432:5432 \
  bitnami/postgresql:latest
```

### Docker Compose 部署

```yaml
version: '3'

services:
  postgresql:
    image: bitnami/postgresql:latest
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_PASSWORD=mysecretpassword
      - POSTGRES_USER=myuser
      - POSTGRES_DB=mydb
      - POSTGRES_INITDB_ARGS=--encoding=UTF8
    volumes:
      - postgresql_data:/bitnami/postgresql
    networks:
      - postgres_network

networks:
  postgres_network:
    driver: bridge

volumes:
  postgresql_data:
    driver: local
```


## ⚠️ 重要通知：Bitnami 镜像仓库即将变更

自2025年8月28日起，Bitnami将升级其公共镜像仓库，通过新的[Bitnami Secure Images计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)提供精选的加固、安全聚焦镜像。此次变更包括：

- 首次向社区用户开放热门容器镜像的安全优化版本
- Bitnami将逐步弃用免费 tier 中的非加固Debian基础镜像，并从公共仓库中移除非最新标签。社区用户将只能访问数量减少的加固镜像，且仅发布为“latest”标签，适用于开发用途
- 自8月28日起，两周内所有现有容器镜像（包括旧版本标签，如2.50.0、10.6）将从公共仓库（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新
- 对于生产工作负载和长期支持，建议采用Bitnami Secure Images，包括加固容器、更小攻击面、CVE透明度（通过VEX/KEV）、SBOM和企业支持

这些变更旨在通过推广软件供应链完整性最佳实践和最新部署，提升所有Bitnami用户的安全态势。更多详情参见[Bitnami Secure Images公告](https://github.com/bitnami/containers/issues/83267)。


## 详细使用方法和配置说明

### 前提条件

- Docker 20.10+ 或 Kubernetes 1.23+（如使用Helm部署）
- Helm 3.8.0+（如使用Helm部署）
- 持久化存储支持（开发环境可忽略，生产环境必需）


### 基础部署（Docker）

#### 基本配置

```bash
docker run --name postgresql \
  -e POSTGRES_PASSWORD=StrongPassword123 \  # 数据库管理员密码
  -e POSTGRES_USER=appuser \                # 应用数据库用户
  -e POSTGRES_DB=appdb \                    # 应用数据库名称
  -e POSTGRES_INITDB_ARGS="--auth-host=scram-sha-256" \  # 初始化参数
  -p 5432:5432 \                            # 端口映射
  -v postgres_data:/bitnami/postgresql \    # 持久化卷
  bitnami/postgresql:latest
```

#### 环境变量说明

| 环境变量                | 描述                                  | 默认值          |
|-------------------------|---------------------------------------|-----------------|
| `POSTGRES_PASSWORD`     | postgres管理员密码                    | 随机生成        |
| `POSTGRES_USER`         | 应用数据库用户名                      | `postgres`      |
| `POSTGRES_DB`           | 初始数据库名称                        | 与`POSTGRES_USER`相同 |
| `POSTGRES_INITDB_ARGS`  | `initdb`命令额外参数                  | `""`            |
| `ALLOW_EMPTY_PASSWORD`  | 是否允许空密码（仅开发环境）          | `no`            |
| `REPLICATION_MODE`      | 复制模式（`master`/`slave`）          | `""`            |
| `REPLICATION_USER`      | 复制用户名称                          | `repl_user`     |
| `REPLICATION_PASSWORD`  | 复制用户密码                          | 随机生成        |


### 持久化存储配置

PostgreSQL数据默认存储在容器内`/bitnami/postgresql`路径。为确保数据持久化，需挂载宿主机目录或Docker卷：

```bash
# 使用宿主机目录
docker run --name postgresql \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -v /host/path/to/postgres/data:/bitnami/postgresql \
  bitnami/postgresql:latest

# 使用Docker命名卷（推荐）
docker volume create postgres_data
docker run --name postgresql \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -v postgres_data:/bitnami/postgresql \
  bitnami/postgresql:latest
```


### 主从复制配置

#### 启动主节点

```bash
docker run --name postgresql-master \
  -e POSTGRES_PASSWORD=masterpassword \
  -e REPLICATION_MODE=master \
  -e REPLICATION_USER=repluser \
  -e REPLICATION_PASSWORD=replpassword \
  -v master_data:/bitnami/postgresql \
  --network postgres-net \
  bitnami/postgresql:latest
```

#### 启动从节点

```bash
docker run --name postgresql-slave \
  -e POSTGRES_PASSWORD=masterpassword \  # 需与主节点相同
  -e REPLICATION_MODE=slave \
  -e REPLICATION_USER=repluser \
  -e REPLICATION_PASSWORD=replpassword \
  -e REPLICATION_HOST=postgresql-master \  # 主节点容器名称或IP
  -e REPLICATION_PORT=5432 \
  -v slave_data:/bitnami/postgresql \
  --network postgres-net \
  bitnami/postgresql:latest
```


### 自定义配置

#### 通过环境变量扩展配置

使用`POSTGRESQL_EXTRA_FLAGS`添加运行时参数：

```bash
docker run --name postgresql \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -e POSTGRESQL_EXTRA_FLAGS="-c max_connections=200 -c shared_buffers=256MB" \
  bitnami/postgresql:latest
```

#### 通过配置文件自定义

挂载自定义`postgresql.conf`或`pg_hba.conf`：

```bash
docker run --name postgresql \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -v /host/path/to/postgresql.conf:/opt/bitnami/postgresql/conf/postgresql.conf \
  -v /host/path/to/pg_hba.conf:/opt/bitnami/postgresql/conf/pg_hba.conf \
  bitnami/postgresql:latest
```


### LDAP集成

启用LDAP认证需配置以下环境变量：

```bash
docker run --name postgresql \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -e LDAP_ENABLED=true \
  -e LDAP_URI=ldap://ldap-server:389 \          # LDAP服务器URI
  -e LDAP_BASE=dc=example,dc=org \             # LDAP基础DN
  -e LDAP_BINDDN=cn=admin,dc=example,dc=org \  # 绑定DN
  -e LDAP_BINDPW=ldapadminpassword \           # 绑定密码
  -e LDAP_SCOPE=sub \                          # 搜索范围
  bitnami/postgresql:latest
```


### TLS加密配置

1. 创建TLS证书（自签名示例）：

```bash
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
  -keyout server.key -out server.crt \
  -subj "/CN=postgresql.example.com"
```

2. 启动带TLS的PostgreSQL：

```bash
docker run --name postgresql \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -e TLS_ENABLED=true \
  -v $(pwd)/server.crt:/opt/bitnami/postgresql/certs/server.crt \
  -v $(pwd)/server.key:/opt/bitnami/postgresql/certs/server.key \
  -e TLS_CERT_FILE=/opt/bitnami/postgresql/certs/server.crt \
  -e TLS_KEY_FILE=/opt/bitnami/postgresql/certs/server.key \
  bitnami/postgresql:latest
```


### 监控集成（Prometheus）

启用Prometheus指标导出器：

```bash
docker run --name postgresql \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -e METRICS_ENABLED=true \                  # 启用指标
  -e METRICS_EXPORTER_USER=exporter \        # 指标用户
  -e METRICS_EXPORTER_PASSWORD=exporterpass \# 指标用户密码
  -p 5432:5432 -p 9187:9187 \                # 暴露指标端口（9187）
  bitnami/postgresql:latest
```

指标可通过`http://localhost:9187/metrics`访问。


### Kubernetes部署（Helm）

#### 前提条件

- Kubernetes 1.23+
- Helm 3.8.0+
- PV供应器支持

#### 安装命令

```bash
helm install my-postgres oci://registry-1.docker.io/bitnamicharts/postgresql \
  --set auth.postgresPassword=StrongPassword123 \
  --set primary.persistence.size=10Gi \
  --set metrics.enabled=true
```

#### 主要Helm参数

| 参数                          | 描述                                  | 默认值          |
|-------------------------------|---------------------------------------|-----------------|
| `auth.postgresPassword`       | postgres管理员密码                    | 随机生成        |
| `auth.username`               | 应用用户名                            | `postgres`      |
| `primary.persistence.size`    | 主节点PVC大小                         | `8Gi`           |
| `readReplicas.replicaCount`   | 从节点数量                            | `1`             |
| `metrics.enabled`             | 是否启用Prometheus指标                | `false`         |
| `tls.enabled`                 | 是否启用TLS                           | `false`         |


## 备份与恢复

### Docker环境备份

```bash
# 备份数据库
docker exec postgresql pg_dump -U postgres appdb > backup.sql

# 恢复数据库
cat backup.sql | docker exec -i postgresql psql -U postgres -d appdb
```

### Kubernetes环境备份

使用Velero工具备份PV数据：

```bash
# 备份PostgreSQL命名空间
velero backup create postgres-backup --include-namespaces postgres

# 恢复到目标集群
velero restore create --from-backup postgres-backup
```


## 与官方PostgreSQL镜像的区别

| 特性                  | Bitnami镜像                          | Docker官方镜像                      |
|-----------------------|--------------------------------------|-------------------------------------|
| 用户权限              | 默认非root用户运行                   | root用户运行                        |
| 复制支持              | 内置主从复制配置                     | 需手动配置                          |
| 安全加固              | 符合容器安全最佳实践（非root、最小权限） | 基础配置，需手动加固                |
| OpenShift兼容性       | 支持（自动调整权限）                 | 需额外配置                          |
| 配置灵活性            | 丰富的环境变量和配置选项             | 基础环境变量支持                    |


## 升级与迁移

### 镜像升级

```bash
# 停止旧容器
docker stop postgresql

# 备份数据（关键步骤）
docker run --rm -v postgres_data:/source -v $(pwd):/backup alpine tar -czf /backup/postgres_backup.tar.gz -C /source .

# 启动新版本容器
docker run --name postgresql-new \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -v postgres_data:/bitnami/postgresql \
  bitnami/postgresql:16  # 指定新版本标签

# 验证后重命名
docker rm postgresql && docker rename postgresql-new postgresql
```

### 版本迁移注意事项

- 跨大版本升级（如13→14）需使用`pg_upgrade`工具
- 迁移前务必备份数据
- 从Legacy仓库（docker.io/bitnamilegacy）迁移时，需更新镜像仓库地址为`bitnami/postgresql`


## 常见问题

### 1. 容器启动失败，日志显示权限错误？

Bitnami镜像默认使用非root用户（UID 1001），挂载宿主机目录时需确保权限正确：

```bash
chown -R 1001:1001 /host/path/to/postgres/data
```

### 2. 如何禁用非必要功能以减小攻击面？

生产环境建议：
- 禁用空密码：`ALLOW_EMPTY_PASSWORD=no`
- 启用TLS加密：配置`TLS_ENABLED=true`
- 限制网络访问：通过Docker网络或Kubernetes NetworkPolicy控制流量

### 3. OpenShift环境部署注意事项？

OpenShift 4.11+：
```bash
helm install my-postgres oci://registry-1.docker.io/bitnamicharts/postgresql \
  --set primary.podSecurityContext.fsGroup=null \
  --set primary.containerSecurityContext.runAsUser=null \
  --set volumePermissions.enabled=false
```


## 生产环境建议

- 使用Bitnami Secure Images（需商业许可），获取加固容器和长期支持
- 启用持久化存储并定期备份
- 配置主从复制实现高可用
- 启用TLS加密所有数据库连接
- 定期更新镜像以修复安全漏洞
- 使用监控工具（如Prometheus+Grafana）监控数据库性能和健康状态
