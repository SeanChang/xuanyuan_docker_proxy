---
image: bitnami/redis-cluster
description: "Bitnami安全Redis集群镜像，提供预配置安全特性，用于部署和运行Redis集群环境。"
source: https://xuanyuan.cloud/zh/r/bitnami/redis-cluster
canonical: https://xuanyuan.cloud/zh/r/bitnami/redis-cluster
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/redis-cluster" title="bitnami/redis-cluster Docker 镜像中文简介、标签列表与拉取命令">bitnami/redis-cluster 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Redis® Cluster 镜像文档

## 镜像概述和主要用途

Redis® Cluster 是 Redis 的分布式实现，支持数据自动分片、高可用与水平扩展。Bitnami Redis® Cluster 镜像基于 Bitnami Secure Images 构建，提供预配置的集群环境，简化分布式 Redis 集群的部署与管理。该镜像适用于需要高性能、高可用分布式内存缓存或数据存储的应用场景，如高并发系统缓存、分布式会话存储等。

## 核心功能与特性

- **安全加固**：基于最小化 Photon Linux 操作系统，减少攻击面，符合 SLSA-3 合规性，提供 SBOMs、VEX/KEV 漏洞报告及签名验证。
- **集群自动化**：支持节点自动发现与配置，简化集群初始化流程，可通过环境变量调整副本数、节点列表等参数。
- **灵活配置**：支持通过配置文件、覆盖配置或环境变量自定义 Redis 参数，兼容 Redis 原生配置项。
- **数据持久化**：支持 AOF 和 RDB 两种持久化机制，可按需配置持久化策略。
- **TLS 加密**：内置 TLS 支持，可配置证书实现节点间及客户端通信加密。
- **透明 CVE 管理**：提供 CVE 漏洞透明度报告（含 VEX/KEV、EPSS 评分），加速漏洞修复响应。
- **FIPS 合规**：Bitnami Secure Images 版本支持 FIPS 模式配置，满足企业合规需求。

## 使用场景与适用范围

- **分布式缓存**：为高并发应用提供分布式内存缓存，减轻数据库负载。
- **高可用数据存储**：通过集群复制与自动故障转移，确保数据高可用性。
- **水平扩展**：支持动态添加节点实现存储与计算能力的水平扩展。
- **开发/测试环境**：快速部署本地或 CI/CD 环境的 Redis 集群，模拟生产配置。
- **企业级部署**：结合 Bitnami Secure Images 提供的企业支持，适用于生产级工作负载。

## 重要通知：Bitnami 镜像目录变更

自 2025 年 8 月 28 日起，Bitnami 将调整公共镜像目录，推进 Bitnami Secure Images 计划：
- **镜像迁移**：所有现有镜像（含历史版本标签，如 `2.50.0`、`10.6`）将从 `docker.io/bitnami` 迁移至 `docker.io/bitnamilegacy` 仓库，且不再接收更新。
- **版本支持**：免费 tier 将仅提供安全加固的 `latest` 标签镜像（适用于开发），非加固 Debian 基础镜像逐步弃用。
- **生产建议**：生产环境需采用 Bitnami Secure Images，包含加固容器、CVE 透明管理、企业支持等特性。

详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。

## 详细使用方法和配置说明

### 获取镜像

#### 拉取预构建镜像（推荐）

从 Docker Hub 拉取最新版：
```console
docker pull bitnami/redis-cluster:latest
```

拉取特定版本（替换 `[TAG]` 为版本号，如 `7.2.4`）：
```console
docker pull bitnami/redis-cluster:[TAG]
```

#### 构建自定义镜像

克隆仓库并构建：
```console
git clone https://github.com/bitnami/containers.git
cd bitnami/redis-cluster/[VERSION]/[OPERATING-SYSTEM]  # 替换为具体版本和操作系统
docker build -t bitnami/redis-cluster:latest .
```

### 基本启动

快速启动单节点集群（仅开发测试，允许空密码）：
```console
docker run --name redis-cluster -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis-cluster:latest
```

### 数据持久化

挂载本地目录至 `/bitnami` 实现数据持久化：
```console
docker run \
  --name redis-cluster \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -v /path/to/local/persistence:/bitnami  # 替换为本地实际路径
  bitnami/redis-cluster:latest
```

### 容器网络通信

通过 Docker 网络实现多容器通信：

1. 创建自定义网络：
```console
docker network create redis-cluster-network --driver bridge
```

2. 启动集群节点并加入网络：
```console
docker run \
  --name redis-node-1 \
  --network redis-cluster-network \
  -e ALLOW_EMPTY_PASSWORD=yes \
  bitnami/redis-cluster:latest
```

3. 其他容器通过节点名称（如 `redis-node-1`）和端口（默认 6379）访问集群。

### 配置文件管理

#### 自定义 `redis.conf`

挂载自定义配置文件覆盖默认配置：
```console
docker run \
  --name redis-cluster \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -v /path/to/your_redis.conf:/opt/bitnami/redis/mounted-etc/redis.conf \  # 本地配置文件路径
  -v /path/to/persistence:/bitnami \
  bitnami/redis-cluster:latest
```

#### 覆盖配置（`overrides.conf`）

仅覆盖部分配置，无需替换完整 `redis.conf`：
```console
docker run \
  --name redis-cluster \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -v /path/to/overrides.conf:/opt/bitnami/redis/mounted-etc/overrides.conf \  # 本地覆盖配置路径
  bitnami/redis-cluster:latest
```

### 环境变量配置

#### 可定制环境变量

| 名称                                  | 描述                                                     | 默认值                                  |
|---------------------------------------|----------------------------------------------------------|-----------------------------------------|
| `REDIS_DATA_DIR`                      | Redis 数据目录                                          | `${REDIS_VOLUME_DIR}/data`              |
| `REDIS_AOF_ENABLED`                   | 是否启用 AOF 持久化                                      | `yes`                                   |
| `REDIS_RDB_POLICY`                    | RDB 持久化策略（格式：`<秒>#<修改次数>`，多策略空格分隔） | `nil`                                   |
| `REDIS_RDB_POLICY_DISABLED`           | 是否禁用 RDB 策略                                        | `no`                                    |
| `REDIS_PORT_NUMBER`                   | 客户端端口号                                             | `$REDIS_DEFAULT_PORT_NUMBER`            |
| `ALLOW_EMPTY_PASSWORD`                | 是否允许空密码访问                                       | `no`                                    |
| `REDIS_PASSWORD`                      | Redis 访问密码                                          | `nil`                                   |
| `REDIS_TLS_ENABLED`                   | 是否启用 TLS                                            | `no`                                    |
| `REDIS_TLS_PORT_NUMBER`               | TLS 端口（需 `REDIS_TLS_ENABLED=yes`）                   | `6379`                                  |
| `REDIS_CLUSTER_REPLICAS`              | 集群副本数量                                             | `1`                                     |
| `REDIS_CLUSTER_DYNAMIC_IPS`           | 是否使用动态 IP 创建集群                                 | `yes`                                   |
| `REDIS_NODES`                         | 集群节点列表（逗号分隔）                                 | `nil`                                   |

#### 只读环境变量

| 名称                          | 描述                     | 值                                      |
|-------------------------------|--------------------------|-----------------------------------------|
| `REDIS_VOLUME_DIR`            | 持久化基础目录           | `/bitnami/redis`                        |
| `REDIS_CONF_DIR`              | 配置目录                 | `${REDIS_BASE_DIR}/etc`                 |
| `REDIS_LOG_FILE`              | 日志文件路径             | `${REDIS_LOG_DIR}/redis.log`            |
| `REDIS_DEFAULT_PORT_NUMBER`   | 默认端口号               | `6379`                                  |

## Docker 部署方案示例

### 多节点集群部署（docker run）

部署 3 主 3 从集群：

1. 启动 6 个节点：
```console
# 主节点
docker run -d --name redis-node-1 --network redis-cluster-network -e ALLOW_EMPTY_PASSWORD=yes -e REDIS_CLUSTER_CREATOR=yes bitnami/redis-cluster:latest
docker run -d --name redis-node-2 --network redis-cluster-network -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis-cluster:latest
docker run -d --name redis-node-3 --network redis-cluster-network -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis-cluster:latest

# 从节点
docker run -d --name redis-node-4 --network redis-cluster-network -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis-cluster:latest
docker run -d --name redis-node-5 --network redis-cluster-network -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis-cluster:latest
docker run -d --name redis-node-6 --network redis-cluster-network -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis-cluster:latest
```

2. 初始化集群：
```console
docker exec -it redis-node-1 redis-cli --cluster create \
  redis-node-1:6379 redis-node-2:6379 redis-node-3:6379 \
  redis-node-4:6379 redis-node-5:6379 redis-node-6:6379 \
  --cluster-replicas 1 --cluster-yes
```

### Docker Compose 配置示例

创建 `docker-compose.yml` 部署 3 主 3 从集群：

```yaml
version: '3'
services:
  redis-node-1:
    image: bitnami/redis-cluster:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - REDIS_CLUSTER_CREATOR=yes
      - REDIS_CLUSTER_REPLICAS=1
      - REDIS_NODES=redis-node-1,redis-node-2,redis-node-3,redis-node-4,redis-node-5,redis-node-6
    networks:
      - redis-cluster-network
    volumes:
      - redis-data-1:/bitnami

  redis-node-2:
    image: bitnami/redis-cluster:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - REDIS_NODES=redis-node-1,redis-node-2,redis-node-3,redis-node-4,redis-node-5,redis-node-6
    networks:
      - redis-cluster-network
    volumes:
      - redis-data-2:/bitnami

  redis-node-3:
    image: bitnami/redis-cluster:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - REDIS_NODES=redis-node-1,redis-node-2,redis-node-3,redis-node-4,redis-node-5,redis-node-6
    networks:
      - redis-cluster-network
    volumes:
      - redis-data-3:/bitnami

  redis-node-4:
    image: bitnami/redis-cluster:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - REDIS_NODES=redis-node-1,redis-node-2,redis-node-3,redis-node-4,redis-node-5,redis-node-6
    networks:
      - redis-cluster-network
    volumes:
      - redis-data-4:/bitnami

  redis-node-5:
    image: bitnami/redis-cluster:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - REDIS_NODES=redis-node-1,redis-node-2,redis-node-3,redis-node-4,redis-node-5,redis-node-6
    networks:
      - redis-cluster-network
    volumes:
      - redis-data-5:/bitnami

  redis-node-6:
    image: bitnami/redis-cluster:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - REDIS_NODES=redis-node-1,redis-node-2,redis-node-3,redis-node-4,redis-node-5,redis-node-6
    networks:
      - redis-cluster-network
    volumes:
      - redis-data-6:/bitnami

networks:
  redis-cluster-network:
    driver: bridge

volumes:
  redis-data-1:
  redis-data-2:
  redis-data-3:
  redis-data-4:
  redis-data-5:
  redis-data-6:
```

启动集群：
```console
docker-compose up -d
```

### TLS 加密通信配置

挂载证书并启用 TLS：
```console
docker run \
  --name redis-cluster \
  -v /path/to/certs:/opt/bitnami/redis/certs \  # 本地证书目录（含 redis.crt、redis.key、CA 证书）
  -v /path/to/persistence:/bitnami \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -e REDIS_TLS_ENABLED=yes \
  -e REDIS_TLS_CERT_FILE=/opt/bitnami/redis/certs/redis.crt \
  -e REDIS_TLS_KEY_FILE=/opt/bitnami/redis/certs/redis.key \
  -e REDIS_TLS_CA_FILE=/opt/bitnami/redis/certs/redisCA.crt \
  bitnami/redis-cluster:latest
```

## 维护与日志

### 查看日志

容器日志输出至 `stdout`，可通过以下命令查看：
```console
docker logs redis-cluster
```

### 升级镜像

1. 拉取最新镜像：
```console
docker pull bitnami/redis-cluster:latest
```

2. 停止并删除旧容器：
```console
docker stop redis-cluster && docker rm -v redis-cluster
```

3. 启动新容器（需挂载原持久化目录）：
```console
docker run --name redis-cluster -v /path/to/persistence:/bitnami bitnami/redis-cluster:latest
```

## FIPS 配置（Bitnami Secure Images）

通过环境变量启用 FIPS 模式：
```console
docker run \
  --name redis-cluster \
  -e OPENSSL_FIPS=yes  # 启用 FIPS 模式（默认值），设置 no 禁用
  bitnami/redis-cluster:latest
```

**注意**：生产环境建议使用 Bitnami Secure Images，获取长期支持与安全更新。
