---
image: bitnamicharts/postgresql-ha
description: "Bitnami提供的Helm chart，用于在Kubernetes环境中部署和管理高可用PostgreSQL数据库实例。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/postgresql-ha
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/postgresql-ha
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/postgresql-ha" title="bitnamicharts/postgresql-ha Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/postgresql-ha 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami PostgreSQL HA Helm Chart 文档


## 镜像概述和主要用途

Bitnami PostgreSQL HA Helm Chart 用于在 Kubernetes 集群中部署具有高可用（HA）架构的 PostgreSQL 集群。该解决方案包含 PostgreSQL 复制管理器（repmgr）和 Pgpool-II 组件，前者用于管理 PostgreSQL 集群的复制和故障转移，后者作为代理实现负载均衡和连接管理，确保数据库服务的高可用性和可靠性。


## 核心功能和特性

- **高可用架构**：基于主从复制拓扑，包含主节点（可写）和从节点（只读），结合 Repmgr 实现自动故障转移，当主节点故障时自动将从节点提升为主节点，避免数据丢失。
- **Pgpool-II 集成**：作为 PostgreSQL 后端代理，提供连接池、负载均衡、读写分离功能，减少连接开销并优化集群性能。
- **自动化复制管理**：通过 Repmgr 实现 PostgreSQL 集群的成员管理、复制监控和自动故障转移。
- **灵活的配置定制**：支持通过 ConfigMap 或参数自定义 PostgreSQL（`postgresql.conf`、`pg_hba.conf`）、Pgpool-II（`pgpool.conf`、`pool_hba.conf`）和 Repmgr（`repmgr.conf`）配置文件。
- **安全增强**：支持 TLS 加密（前端客户端与 Pgpool-II 之间、Pgpool-II 与 PostgreSQL 节点之间）、LDAP 认证、客户端证书认证。
- **可观测性**：集成 Prometheus 监控，通过 `postgres_exporter` 暴露指标，支持 ServiceMonitor 集成。
- **数据持久化**：使用持久卷（PVC）存储数据库数据，支持自定义存储类和现有卷声明。
- **初始化脚本支持**：允许通过 ConfigMap、Secret 或参数指定自定义初始化脚本，用于数据库初始化（如创建用户、表等）。


## 使用场景和适用范围

- **生产环境数据库部署**：需要高可用性、自动故障转移和数据可靠性的关键业务系统。
- **Kubernetes 集群内数据库服务**：适用于在 Kubernetes 环境中部署 PostgreSQL，利用容器编排和服务发现能力。
- **读写分离需求**：通过 Pgpool-II 实现读写请求分离，优化查询性能。
- **需要监控和可观测性的场景**：集成 Prometheus 便于监控集群状态和性能指标。
- **安全合规场景**：支持 TLS 加密和 LDAP 认证，满足数据传输和访问控制的安全要求。


## 先决条件

- Kubernetes 集群版本 1.23+
- Helm 版本 3.8.0+
- 集群中存在默认 StorageClass（用于动态创建持久卷）或已准备好静态持久卷


## 详细使用方法和配置说明

### 安装 Helm Chart

#### 快速安装（TL;DR）

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/postgresql-ha
```

#### 自定义安装

指定自定义参数安装（需替换 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 为实际 Helm 仓库地址，如 Bitnami 官方仓库为 `registry-1.docker.io/bitnamicharts`）：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/postgresql-ha \
  --set postgresql.postgresqlPassword=mysecretpassword \
  --set postgresql.repmgrPassword=repmgrsecret \
  --set pgpool.service.type=LoadBalancer
```


### 配置参数说明

#### 核心参数

| 参数路径                     | 描述                                                                 | 默认值                  |
|------------------------------|----------------------------------------------------------------------|-------------------------|
| `postgresql.postgresqlPassword` | PostgreSQL 管理员密码                                                | 自动生成随机值          |
| `postgresql.repmgrPassword`   | Repmgr 管理员密码                                                    | 自动生成随机值          |
| `pgpool.service.type`         | Pgpool-II 服务类型（ClusterIP/NodePort/LoadBalancer）                | ClusterIP               |
| `persistence.enabled`         | 是否启用持久化存储                                                  | true                    |
| `persistence.storageClass`    | 持久卷存储类                                                        | 默认 StorageClass       |
| `metrics.enabled`             | 是否启用 Prometheus 监控                                            | false                   |


#### 资源配置

可通过 `resources` 参数设置容器资源请求和限制，或使用 `resourcesPreset` 预设（仅建议开发环境使用）：

```yaml
postgresql:
  resources:
    requests:
      cpu: 500m
      memory: 512Mi
    limits:
      cpu: 1000m
      memory: 1Gi
pgpool:
  resources:
    requests:
      cpu: 200m
      memory: 256Mi
    limits:
      cpu: 500m
      memory: 512Mi
```


#### TLS 加密配置

##### 前端加密（客户端与 Pgpool-II 之间）

1. 创建包含 TLS 证书的 Secret（需提前生成证书文件 `cert.crt`、`cert.key`、`ca.crt`）：

```console
kubectl create secret generic pgpool-tls-secret \
  --from-file=./cert.crt \
  --from-file=./cert.key \
  --from-file=./ca.crt
```

2. 安装时启用 TLS：

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/postgresql-ha \
  --set pgpool.tls.enabled=true \
  --set pgpool.tls.certificatesSecret=pgpool-tls-secret \
  --set pgpool.tls.certFilename=cert.crt \
  --set pgpool.tls.certKeyFilename=cert.key \
  --set pgpool.tls.certCAFilename=ca.crt
```

##### 后端加密（Pgpool-II 与 PostgreSQL 节点之间）

类似前端配置，通过 `postgresql.tls.*` 参数启用：

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/postgresql-ha \
  --set postgresql.tls.enabled=true \
  --set postgresql.tls.certificatesSecret=postgresql-tls-secret \
  --set postgresql.tls.certFilename=cert.crt \
  --set postgresql.tls.certKeyFilename=cert.key
```


#### LDAP 认证配置

启用 LDAP 认证需配置以下参数（示例）：

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/postgresql-ha \
  --set ldap.enabled=true \
  --set ldap.uri=ldap://my-ldap-server \
  --set ldap.basedn=dc=example\,dc=org \
  --set ldap.binddn=cn=admin\,dc=example\,dc=org \
  --set ldap.bindpw=admin \
  --set ldap.scope=sub \
  --set ldap.searchfilter=posixaccount
```


#### 自定义配置文件

通过参数直接指定配置内容（如 `postgresql.configuration` 自定义 `postgresql.conf`）：

```yaml
postgresql:
  configuration: |
    max_connections = 100
    shared_buffers = 256MB
pgpool:
  configuration: |
    num_init_children = 32
    max_pool = 4
```

或通过外部 ConfigMap 挂载配置（需提前创建 ConfigMap）：

```yaml
postgresql:
  configurationCM: my-postgresql-config  # 外部 ConfigMap 名称
pgpool:
  configurationCM: my-pgpool-config      # 外部 ConfigMap 名称
```


#### 初始化数据库

通过 `initdbScripts` 参数指定初始化脚本（键为脚本名，值为脚本内容）：

```yaml
postgresql:
  initdbScripts:
    init-user.sql: |
      CREATE USER appuser WITH PASSWORD 'apppass';
      CREATE DATABASE appdb OWNER appuser;
```

或使用外部 Secret（含敏感信息）：

```yaml
postgresql:
  initdbScriptsSecret: my-init-scripts-secret  # 外部 Secret 名称
```


### 升级与维护

#### 更新凭据

1. 通过 SQL 更新数据库用户密码：

```sql
ALTER USER postgres WITH PASSWORD 'newpassword';
```

2. 更新 Kubernetes Secret（替换 `SECRET_NAME`、`POSTGRES_PASSWORD` 等占位符）：

```console
kubectl create secret generic SECRET_NAME \
  --from-literal=postgres-password=POSTGRES_PASSWORD \
  --from-literal=repmgr-password=REPMGR_PASSWORD \
  --dry-run -o yaml | kubectl apply -f -
```


#### 备份与恢复

建议使用 Velero 工具备份持久卷数据和 Kubernetes 资源，具体步骤参考 [Velero 官方文档](https://velero.io/docs/)。


### 注意事项

- **镜像标签策略**：生产环境建议使用固定标签（如 `16.1.0-debian-11-r0`）而非 `latest`，避免自动更新导致兼容性问题。
- **存储配置**：确保持久卷有足够容量，生产环境建议使用高性能存储（如 SSD）。
- **安全更新**：自 2025 年 8 月 28 日起，Bitnami 非强化版 Debian 镜像将逐步迁移至 `docker.io/bitnamilegacy` 仓库并停止更新，生产环境建议使用 Bitnami Secure Images（需订阅）。
- **资源规划**：根据数据库负载调整资源请求和限制，避免资源不足导致性能问题。


## 与普通 PostgreSQL Helm Chart 的区别

| 特性                | PostgreSQL HA Helm Chart                          | 普通 PostgreSQL Helm Chart              |
|---------------------|---------------------------------------------------|-----------------------------------------|
| 架构组件            | 包含 Pgpool-II（负载均衡/代理）和 Repmgr（复制管理） | 仅包含 PostgreSQL 主从复制              |
| 默认节点数          | 4 节点（1 Pgpool + 3 PostgreSQL 节点）            | 2 节点（1 主 + 1 从）                   |
| 故障转移            | 自动（Repmgr + Pgpool-II）                        | 手动或需额外工具                        |
| 负载均衡            | 支持（Pgpool-II 提供）                            | 无内置负载均衡                          |
| 连接池              | 支持（Pgpool-II）                                 | 需额外配置                              |


## 镜像变更通知（2025年8月起）

Bitnami 将于 2025 年 8 月 28 日起调整公共镜像策略：

- **非强化版镜像迁移**：所有现有镜像（含历史版本标签）将迁移至 `docker.io/bitnamilegacy` 仓库，不再更新。
- **免费层镜像缩减**：社区用户仅可访问少量强化版镜像（仅 `latest` 标签），用于开发环境。
- **生产环境建议**：推荐使用 Bitnami Secure Images，包含强化容器、CVE 透明性、SBOM 和企业支持。

详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。
