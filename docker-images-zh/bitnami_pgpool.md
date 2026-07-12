---
image: bitnami/pgpool
description: "Bitnami提供的安全pgpool镜像，用于PostgreSQL数据库的连接池管理、负载均衡及高可用中间件。"
source: https://xuanyuan.cloud/zh/r/bitnami/pgpool
canonical: https://xuanyuan.cloud/zh/r/bitnami/pgpool
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/pgpool" title="bitnami/pgpool Docker 镜像中文简介、标签列表与拉取命令">bitnami/pgpool 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Pgpool-II 镜像文档


## 1. 镜像概述和主要用途

### 1.1 关于Pgpool-II
Pgpool-II 是 PostgreSQL 的代理服务，位于 PostgreSQL 服务器与客户端之间，提供连接池、负载均衡、自动故障转移和复制管理功能。

### 1.2 Bitnami 镜像特点
Bitnami Pgpool-II 镜像是经过安全加固的容器化版本，基于 Bitnami Secure Images  initiative，适用于开发和生产环境，提供最小化攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 清单和企业级支持选项。


## 2. 核心功能与特性

### 2.1 Pgpool-II 核心功能
- **连接池**：缓存客户端连接，减少 PostgreSQL 服务器的连接开销
- **负载均衡**：将读请求分发到多个 PostgreSQL 节点，提高查询性能
- **自动故障转移**：检测主节点故障并自动提升备节点
- **复制管理**：支持 PostgreSQL 流复制配置与监控
- **读写分离**：默认将写操作路由至主节点，读操作分发至备节点

### 2.2 Bitnami 镜像增强特性
- **安全加固**：基于 Photon Linux 最小化操作系统，减少攻击面
- **非 root 运行**：容器以非特权用户启动，符合生产环境安全最佳实践
- **供应链安全**：提供 SLSA-3 合规的构建流程、SBOM 清单和漏洞扫描报告
- **配置灵活性**：支持通过环境变量、自定义配置文件和初始化脚本定制部署
- **TLS 加密**：内置 TLS 支持，保护客户端与代理间的通信安全


## 3. 使用场景和适用范围

### 3.1 典型应用场景
- **PostgreSQL 高可用集群**：通过自动故障转移确保服务连续性
- **读写分离架构**：将读请求分发到备节点，提升查询吞吐量
- **多节点管理**：统一管理多个 PostgreSQL 实例，简化客户端连接配置
- **开发/测试环境**：快速部署包含代理层的 PostgreSQL 集群原型

### 3.2 适用用户
- 需要构建高可用 PostgreSQL 服务的企业用户
- 追求性能优化（如读写分离）的应用开发者
- 关注容器安全与供应链完整性的 DevOps 团队


## 4. 重要通知：Bitnami 镜像目录变更

自 2025 年 8 月 28 日起，Bitnami 将调整公共镜像目录策略：
- **镜像迁移**：现有所有容器镜像（包括历史版本标签，如 2.50.0、10.6）将从 `docker.io/bitnami` 迁移至 `docker.io/bitnamilegacy` 仓库，且不再接收更新
- **版本支持**：免费 tier 将仅提供安全加固的 "latest" 标签镜像（用于开发目的），非加固 Debian 基础镜像将逐步弃用
- **生产环境建议**：生产工作负载推荐使用 Bitnami Secure Images，包含硬化容器、CVE 透明度和长期支持

详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


## 5. 获取镜像

### 5.1 拉取最新镜像
```bash
docker pull docker.xuanyuan.run/bitnami/pgpool:latest
```

### 5.2 指定版本拉取
查看 [Docker Hub 标签列表](https://hub.docker.com/r/bitnami/pgpool/tags/) 获取可用版本，格式为：
```bash
docker pull docker.xuanyuan.run/bitnami/pgpool:[TAG]
```

### 5.3 本地构建（可选）
```bash
git clone https://github.com/bitnami/containers.git
cd containers/bitnami/pgpool/[VERSION]/[DISTRO]
docker build -t bitnami/pgpool:latest .
```


## 6. 快速启动

### 6.1 单节点快速运行
```bash
docker run --name pgpool docker.xuanyuan.run/bitnami/pgpool:latest
```
> 默认凭据和配置选项见 [环境变量](#9-环境变量) 部分。


## 7. 部署示例

### 7.1 使用 Docker 命令行部署 HA 集群

#### 步骤 1：创建网络
```bash
docker network create my-network --driver bridge
```

#### 步骤 2：启动 PostgreSQL 后端节点（使用 repmgr 实现复制）
```bash
# 主节点 pg-0
docker run --detach --name pg-0 \
  --network my-network \
  --env REPMGR_PARTNER_NODES=pg-0,pg-1 \
  --env REPMGR_NODE_NAME=pg-0 \
  --env REPMGR_NODE_NETWORK_NAME=pg-0 \
  --env REPMGR_PRIMARY_HOST=pg-0 \
  --env REPMGR_PASSWORD=repmgrpass \
  --env POSTGRESQL_POSTGRES_PASSWORD=adminpassword \
  --env POSTGRESQL_USERNAME=customuser \
  --env POSTGRESQL_PASSWORD=custompassword \
  --env POSTGRESQL_DATABASE=customdatabase \
  docker.xuanyuan.run/bitnami/postgresql-repmgr:latest

# 备节点 pg-1
docker run --detach --name pg-1 \
  --network my-network \
  --env REPMGR_PARTNER_NODES=pg-0,pg-1 \
  --env REPMGR_NODE_NAME=pg-1 \
  --env REPMGR_NODE_NETWORK_NAME=pg-1 \
  --env REPMGR_PRIMARY_HOST=pg-0 \
  --env REPMGR_PASSWORD=repmgrpass \
  --env POSTGRESQL_POSTGRES_PASSWORD=adminpassword \
  --env POSTGRESQL_USERNAME=customuser \
  --env POSTGRESQL_PASSWORD=custompassword \
  --env POSTGRESQL_DATABASE=customdatabase \
  docker.xuanyuan.run/bitnami/postgresql-repmgr:latest
```

#### 步骤 3：启动 Pgpool-II 代理
```bash
docker run --detach --name pgpool \
  --network my-network \
  -p 5432:5432 \
  --env PGPOOL_BACKEND_NODES=0:pg-0:5432,1:pg-1:5432 \
  --env PGPOOL_SR_CHECK_USER=customuser \
  --env PGPOOL_SR_CHECK_PASSWORD=custompassword \
  --env PGPOOL_ENABLE_LDAP=no \
  --env PGPOOL_POSTGRES_USERNAME=postgres \
  --env PGPOOL_POSTGRES_PASSWORD=adminpassword \
  --env PGPOOL_ADMIN_USERNAME=admin \
  --env PGPOOL_ADMIN_PASSWORD=adminpassword \
  docker.xuanyuan.run/bitnami/pgpool:latest
```

#### 步骤 4：验证连接
```bash
docker run -it --rm \
  --network my-network \
  docker.xuanyuan.run/bitnami/postgresql:latest \
  psql -h pgpool -U customuser -d customdatabase
```

### 7.2 使用 Docker Compose 部署 HA 集群

创建 `docker-compose.yml` 文件：
```yaml
version: '2'

networks:
  my-network:
    driver: bridge

services:
  pg-0:
    image: docker.xuanyuan.run/bitnami/postgresql-repmgr:latest
    volumes:
      - pg_0_data:/bitnami/postgresql
    environment:
      - POSTGRESQL_POSTGRES_PASSWORD=adminpassword
      - POSTGRESQL_USERNAME=customuser
      - POSTGRESQL_PASSWORD=custompassword
      - POSTGRESQL_DATABASE=customdatabase
      - REPMGR_PASSWORD=repmgrpassword
      - REPMGR_PRIMARY_HOST=pg-0
      - REPMGR_PARTNER_NODES=pg-0,pg-1
      - REPMGR_NODE_NAME=pg-0
      - REPMGR_NODE_NETWORK_NAME=pg-0

  pg-1:
    image: docker.xuanyuan.run/bitnami/postgresql-repmgr:latest
    volumes:
      - pg_1_data:/bitnami/postgresql
    environment:
      - POSTGRESQL_POSTGRES_PASSWORD=adminpassword
      - POSTGRESQL_USERNAME=customuser
      - POSTGRESQL_PASSWORD=custompassword
      - POSTGRESQL_DATABASE=customdatabase
      - REPMGR_PASSWORD=repmgrpassword
      - REPMGR_PRIMARY_HOST=pg-0
      - REPMGR_PARTNER_NODES=pg-0,pg-1
      - REPMGR_NODE_NAME=pg-1
      - REPMGR_NODE_NETWORK_NAME=pg-1

  pgpool:
    image: docker.xuanyuan.run/bitnami/pgpool:latest
    ports:
      - 5432:5432
    environment:
      - PGPOOL_BACKEND_NODES=0:pg-0:5432,1:pg-1:5432
      - PGPOOL_SR_CHECK_USER=customuser
      - PGPOOL_SR_CHECK_PASSWORD=custompassword
      - PGPOOL_ENABLE_LDAP=no
      - PGPOOL_POSTGRES_USERNAME=postgres
      - PGPOOL_POSTGRES_PASSWORD=adminpassword
      - PGPOOL_ADMIN_USERNAME=admin
      - PGPOOL_ADMIN_PASSWORD=adminpassword
    healthcheck:
      test: ["CMD", "/opt/bitnami/scripts/pgpool/healthcheck.sh"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  pg_0_data:
    driver: local
  pg_1_data:
    driver: local
```

启动集群：
```bash
docker-compose up -d
```


## 8. 配置说明

### 8.1 初始化自定义脚本
容器启动时会自动执行 `/docker-entrypoint-initdb.d` 目录下所有 `.sh` 脚本。通过挂载卷添加自定义脚本：
```yaml
# docker-compose.yml 示例片段
services:
  pgpool:
    image: docker.xuanyuan.run/bitnami/pgpool:latest
    volumes:
      - /path/to/init-scripts:/docker-entrypoint-initdb.d  # 本地脚本目录挂载
```

### 8.2 启用 TLS 加密
通过环境变量配置 TLS：
- `PGPOOL_ENABLE_TLS=yes`：启用 TLS
- `PGPOOL_TLS_CERT_FILE`：证书文件路径
- `PGPOOL_TLS_KEY_FILE`：私钥文件路径
- `PGPOOL_TLS_CA_FILE`（可选）：CA 证书路径（用于客户端认证）

示例 `docker run` 命令：
```bash
docker run \
  -v /path/to/certs:/opt/bitnami/pgpool/certs \
  -e PGPOOL_ENABLE_TLS=yes \
  -e PGPOOL_TLS_CERT_FILE=/opt/bitnami/pgpool/certs/postgres.crt \
  -e PGPOOL_TLS_KEY_FILE=/opt/bitnami/pgpool/certs/postgres.key \
  docker.xuanyuan.run/bitnami/pgpool:latest
```

### 8.3 自定义配置文件
通过环境变量指定自定义配置文件覆盖默认配置：
- `PGPOOL_USER_CONF_FILE`：自定义主配置文件路径（追加到默认配置）
- `PGPOOL_USER_HBA_FILE`：自定义 host-based 认证配置文件路径（覆盖默认 HBA 配置）

示例：
```yaml
# docker-compose.yml 示例片段
services:
  pgpool:
    environment:
      - PGPOOL_USER_CONF_FILE=/config/myconf.conf
      - PGPOOL_USER_HBA_FILE=/config/myhbaconf.conf
    volumes:
      - /path/to/myconf.conf:/config/myconf.conf
      - /path/to/myhbaconf.conf:/config/myhbaconf.conf
```

### 8.4 重新附加节点
当后端节点恢复后，需手动重新附加到 Pgpool：
1. 进入 Pgpool 容器：`docker exec -it pgpool bash`
2. 连接 Pgpool 管理接口：`PGPASSWORD=$PGPOOL_ADMIN_PASSWORD pcp_connect -h localhost -U $PGPOOL_ADMIN_USERNAME`
3. 查看节点状态：`show pool_nodes;`（获取节点 ID）
4. 附加节点：`pcp_attach_node -h localhost -U $PGPOOL_ADMIN_USERNAME <node_id>`


## 9. 环境变量

### 9.1 核心配置变量
| 环境变量名称                     | 描述                                                                 | 默认值         |
|----------------------------------|----------------------------------------------------------------------|----------------|
| `PGPOOL_PORT_NUMBER`             | Pgpool 服务端口                                                      | `5432`         |
| `PGPOOL_BACKEND_NODES`           | 后端 PostgreSQL 节点列表，格式：`id:hostname:port[,id:hostname:port]` | -              |
| `PGPOOL_SR_CHECK_USER`           | 流复制检查用户                                                      | -              |
| `PGPOOL_SR_CHECK_PASSWORD`       | 流复制检查用户密码                                                  | -              |
| `PGPOOL_ADMIN_USERNAME`          | PCP 管理接口用户名                                                  | `admin`        |
| `PGPOOL_ADMIN_PASSWORD`          | PCP 管理接口密码                                                    | -              |
| `PGPOOL_ENABLE_LOAD_BALANCING`   | 是否启用负载均衡                                                    | `yes`          |
| `PGPOOL_MAX_POOL`                | 最大连接池数量                                                      | `15`           |

### 9.2 高级配置变量
| 环境变量名称                     | 描述                                                                 | 默认值         |
|----------------------------------|----------------------------------------------------------------------|----------------|
| `PGPOOL_ENABLE_TLS`              | 是否启用 TLS 加密                                                    | `no`           |
| `PGPOOL_HEALTH_CHECK_PERIOD`     | 健康检查周期（秒）                                                  | `30`           |
| `PGPOOL_HEALTH_CHECK_TIMEOUT`    | 健康检查超时（秒）                                                  | `10`           |
| `PGPOOL_CONNECT_TIMEOUT`         | 连接超时（毫秒）                                                    | `10000`        |
| `PGPOOL_DISABLE_LOAD_BALANCE_ON_WRITE` | 写操作时是否禁用负载均衡                                      | `transaction`  |

> **注意**：完整环境变量列表请参见 [官方文档](https://github.com/bitnami/containers/blob/main/bitnami/pgpool/README.md)。


## 10. Kubernetes 部署
推荐使用 Bitnami Helm Chart 部署到 Kubernetes，详情参见 [PostgreSQL HA Chart](https://github.com/bitnami/charts/tree/master/bitnami/postgresql-ha)。


## 11. 注意事项
- **生产环境建议**：使用 Bitnami Secure Images 并启用 TLS 加密
- **数据持久化**：通过卷挂载持久化 PostgreSQL 数据（如示例中 `pg_0_data` 卷）
- **版本迁移**：2025 年 8 月 28 日后，历史版本镜像将迁移至 `docker.io/bitnamilegacy` 仓库，建议定期更新 `latest` 标签或迁移至 Secure Images
- **非 root 容器**：镜像默认以非 root 用户运行，提升安全性，避免挂载特权路径
