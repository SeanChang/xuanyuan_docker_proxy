---
image: ongres/patroni
description: "PostgreSQL数据库与Patroni结合的高可用性OCI镜像，提供自动化故障转移、集群管理及持续可用性保障，适用于容器化环境中的关键数据库部署。"
source: https://xuanyuan.cloud/zh/r/ongres/patroni
canonical: https://xuanyuan.cloud/zh/r/ongres/patroni
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ongres/patroni" title="ongres/patroni Docker 镜像中文简介、标签列表与拉取命令">ongres/patroni — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ongres/patroni" title="ongres/patroni Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ongres/patroni</a>

# PostgreSQL + Patroni 高可用OCI镜像文档

## 1. 镜像概述

本镜像整合了PostgreSQL数据库与Patroni高可用解决方案，提供开箱即用的高可用PostgreSQL集群能力。Patroni作为PostgreSQL的高可用编排工具，可实现自动故障检测、主从切换、集群配置管理等核心功能，而OCI镜像格式确保其可在各类容器运行时环境（如Docker、Kubernetes）中无缝部署。

## 2. 核心功能与特性

### 2.1 基础数据库功能
- 完整集成PostgreSQL数据库引擎，支持标准SQL语法及PostgreSQL扩展功能
- 兼容主流PostgreSQL版本特性（具体版本取决于镜像标签）

### 2.2 高可用能力
- **自动故障检测**：实时监控集群节点健康状态
- **自动故障转移**：主节点故障时自动将从节点提升为新主节点
- **集群配置管理**：统一管理集群参数，支持动态配置更新
- **主从复制**：基于PostgreSQL原生流复制实现数据同步

### 2.3 部署与配置特性
- 符合OCI镜像标准，支持Docker、containerd等容器运行时
- 环境变量驱动配置，简化集群部署流程
- 支持持久化存储挂载，确保数据持久性
- 兼容主流监控系统（如Prometheus），提供集群指标暴露

## 3. 使用场景

- **关键业务数据库**：需保障持续可用的企业核心业务系统
- **容器化部署环境**：Kubernetes、Docker Swarm等容器编排平台中的PostgreSQL部署
- **云原生应用**：作为云原生架构中的有状态服务后端
- **灾备需求场景**：需快速恢复能力的多可用区部署

## 4. 使用方法

### 4.1 基础运行命令（单节点示例）

```bash
docker run -d \
  --name patroni-postgres \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=securepassword \
  -e POSTGRES_DB=mydb \
  -e PATRONI_SCOPE=mycluster \
  -e PATRONI_RESTAPI_USER=patroni \
  -e PATRONI_RESTAPI_PASSWORD=patronipassword \
  -e PATRONI_POSTGRESQL_USER=postgres \
  -e PATRONI_POSTGRESQL_PASSWORD=pgpassword \
  -p 5432:5432 \
  -p 8008:8008 \
  -v /path/to/data:/var/lib/postgresql/data \
  [镜像名称]:[标签]
```

### 4.2 核心环境变量说明

| 环境变量 | 描述 | 示例值 |
|----------|------|--------|
| `POSTGRES_USER` | 数据库超级用户 | `admin` |
| `POSTGRES_PASSWORD` | 超级用户密码 | `securepassword` |
| `POSTGRES_DB` | 初始数据库名称 | `mydb` |
| `PATRONI_SCOPE` | 集群标识（所有节点需一致） | `mycluster` |
| `PATRONI_RESTAPI_USER` | Patroni API认证用户 | `patroni` |
| `PATRONI_RESTAPI_PASSWORD` | Patroni API认证密码 | `patronipassword` |
| `PATRONI_POSTGRESQL_USER` | Patroni管理数据库用户 | `postgres` |
| `PATRONI_POSTGRESQL_PASSWORD` | Patroni管理用户密码 | `pgpassword` |
| `PATRONI_KUBERNETES_NAMESPACE` | Kubernetes命名空间（K8s环境） | `default` |

### 4.3 Docker Compose集群示例（3节点）

```yaml
version: '3.8'

services:
  postgres-1:
    image: [镜像名称]:[标签]
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: securepassword
      PATRONI_SCOPE: mycluster
      PATRONI_NAME: postgres-1
      PATRONI_RESTAPI_USER: patroni
      PATRONI_RESTAPI_PASSWORD: patronipassword
      PATRONI_POSTGRESQL_USER: postgres
      PATRONI_POSTGRESQL_PASSWORD: pgpassword
      PATRONI_RESTAPI_LISTEN: 0.0.0.0:8008
      PATRONI_POSTGRESQL_LISTEN: 0.0.0.0:5432
    volumes:
      - data1:/var/lib/postgresql/data

  postgres-2:
    image: [镜像名称]:[标签]
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: securepassword
      PATRONI_SCOPE: mycluster
      PATRONI_NAME: postgres-2
      PATRONI_RESTAPI_USER: patroni
      PATRONI_RESTAPI_PASSWORD: patronipassword
      PATRONI_POSTGRESQL_USER: postgres
      PATRONI_POSTGRESQL_PASSWORD: pgpassword
      PATRONI_RESTAPI_LISTEN: 0.0.0.0:8008
      PATRONI_POSTGRESQL_LISTEN: 0.0.0.0:5432
    volumes:
      - data2:/var/lib/postgresql/data

  postgres-3:
    image: [镜像名称]:[标签]
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: securepassword
      PATRONI_SCOPE: mycluster
      PATRONI_NAME: postgres-3
      PATRONI_RESTAPI_USER: patroni
      PATRONI_RESTAPI_PASSWORD: patronipassword
      PATRONI_POSTGRESQL_USER: postgres
      PATRONI_POSTGRESQL_PASSWORD: pgpassword
      PATRONI_RESTAPI_LISTEN: 0.0.0.0:8008
      PATRONI_POSTGRESQL_LISTEN: 0.0.0.0:5432
    volumes:
      - data3:/var/lib/postgresql/data

volumes:
  data1:
  data2:
  data3:
```

### 4.4 集群状态检查

通过Patroni REST API检查集群状态：

```bash
curl -u patroni:patronipassword http://<容器IP>:8008/cluster
```

### 4.5 持久化配置

如需自定义PostgreSQL或Patroni配置，可通过挂载配置文件实现：

```bash
docker run -d \
  ... \
  -v /host/path/to/postgresql.conf:/etc/postgresql/postgresql.conf \
  -v /host/path/to/patroni.yml:/etc/patroni/patroni.yml \
  [镜像名称]:[标签]
```

## 5. 注意事项

- 生产环境中需配置适当的资源限制（CPU/内存）
- 多节点集群需确保网络互通及时间同步
- 持久化存储建议使用高性能块存储（如Kubernetes PV、AWS EBS）
- 定期备份数据，Patroni不替代数据备份策略
- 高可用集群至少需3个节点以避免脑裂问题
