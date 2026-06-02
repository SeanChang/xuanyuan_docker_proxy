---
image: bitnami/redis-sentinel
description: "Bitnami提供的Redis哨兵安全镜像，用于实现Redis集群的高可用，支持监控和自动故障转移。"
source: https://xuanyuan.cloud/zh/r/bitnami/redis-sentinel
canonical: https://xuanyuan.cloud/zh/r/bitnami/redis-sentinel
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/redis-sentinel" title="bitnami/redis-sentinel Docker 镜像中文简介、标签列表与拉取命令">bitnami/redis-sentinel 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Redis® Sentinel 镜像文档

## 镜像概述和主要用途

Redis® Sentinel 是 Redis 的高可用性解决方案，提供监控、通知、自动故障转移以及客户端配置提供等功能。它通过监控 Redis 主从节点状态，在主节点故障时自动将从节点提升为新主节点，确保 Redis 服务持续可用。

[Redis® Sentinel 官方概述](https://redis.io/)  
免责声明：Redis 是 Redis Ltd. 的注册商标。Bitnami 对其的使用仅为参考目的，不表示 Redis Ltd. 的任何赞助、认可或关联。


## 核心功能和特性

### Redis® Sentinel 核心功能
- **高可用性保障**：自动检测主节点故障并执行故障转移
- **监控能力**：持续监控 Redis 主从节点和其他 Sentinel 实例状态
- **通知机制**：当节点状态变化时发送通知（如主节点故障）
- **配置提供**：为客户端提供当前 Redis 主节点地址

### Bitnami 镜像特性
- **安全加固**：基于 Bitnami Secure Images 计划，采用最小化基础镜像（Photon Linux），减少攻击面
- **非 root 用户运行**：默认以 `redis` 用户运行容器，增强安全性
- **供应链安全**：提供 SBOM（软件物料清单）、VEX/KEV 漏洞透明度报告
- **持续更新**：上游安全补丁发布后数小时内更新镜像
- **跨平台一致性**：与 Bitnami 虚拟机、云镜像使用相同组件和配置逻辑


## 使用场景和适用范围

- **生产环境 Redis 高可用部署**：需保障 Redis 服务无单点故障的业务系统
- **自动故障转移需求**：无人值守场景下的 Redis 集群维护
- **分布式系统依赖**：作为分布式应用的缓存或数据存储高可用层
- **开发与测试环境**：快速搭建 Redis 高可用架构进行功能验证


## 快速启动（TL;DR）

```console
docker run --name redis-sentinel -e REDIS_MASTER_HOST=redis bitnami/redis-sentinel:latest
```

**警告**：此快速配置仅适用于开发环境。生产环境中应修改默认凭据，并参考[环境变量](#环境变量)部分进行安全配置。


## ⚠️ 重要通知：Bitnami 镜像目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共镜像目录，通过新的[Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)提供精选的安全加固镜像。过渡期变更如下：

- 首次向社区用户开放热门容器镜像的安全优化版本
- 逐步弃用免费 tier 中的非加固 Debian 基础镜像，仅保留"latest"标签的加固镜像（用于开发目的）
- 8 月 28 日起两周内，所有现有容器镜像（含历史版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至"Bitnami Legacy"仓库（docker.io/bitnamilegacy），且不再更新
- 生产环境建议采用 Bitnami Secure Images，包含加固容器、最小攻击面、CVE 透明度报告、SBOM 和企业支持

更多详情请参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


## 获取镜像

### 推荐方式：拉取预构建镜像
从 Docker Hub 拉取最新版：
```console
docker pull bitnami/redis-sentinel:latest
```

拉取特定版本（需替换 `[TAG]` 为具体版本号）：
```console
docker pull bitnami/redis-sentinel:[TAG]
```
[可用版本列表](https://hub.docker.com/r/bitnami/redis-sentinel/tags/)

### 手动构建镜像
```console
git clone https://github.com/bitnami/containers.git
cd bitnami/redis-sentinel/[VERSION]/[OS]  # 替换为具体版本和操作系统
docker build -t bitnami/redis-sentinel:latest .
```


## 使用方法

### 与其他容器连接

#### 步骤 1：创建 Docker 网络
```console
docker network create app-tier --driver bridge
```

#### 步骤 2：启动 Redis 主节点
```console
docker run -d --name redis-server \
  -e ALLOW_EMPTY_PASSWORD=yes \  # 开发环境允许空密码（生产环境禁用）
  --network app-tier \
  bitnami/redis:latest
```

#### 步骤 3：启动 Redis Sentinel
```console
docker run -it --rm \
  -e REDIS_MASTER_HOST=redis-server \  # 指向 Redis 主节点容器名
  -e REDIS_MASTER_SET=mymaster \      # 主节点集名称（默认 mymaster）
  -e REDIS_SENTINEL_QUORUM=2 \        # 故障转移法定人数（默认 2）
  --network app-tier \
  bitnami/redis-sentinel:latest
```

### Docker Compose 部署示例

创建 `docker-compose.yml`：
```yaml
version: '3.8'

networks:
  app-tier:
    driver: bridge

services:
  redis-master:
    image: bitnami/redis:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=yes  # 生产环境需设置 REDIS_PASSWORD
    networks:
      - app-tier
    volumes:
      - redis-master-data:/bitnami/redis/data

  redis-sentinel:
    image: bitnami/redis-sentinel:latest
    depends_on:
      - redis-master
    environment:
      - REDIS_MASTER_HOST=redis-master
      - REDIS_MASTER_SET=mymaster
      - REDIS_SENTINEL_QUORUM=2
      - REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS=5000  # 5秒无响应判定为下线
    networks:
      - app-tier
    volumes:
      - redis-sentinel-data:/bitnami/redis-sentinel/data

volumes:
  redis-master-data:
  redis-sentinel-data:
```

启动服务：
```console
docker-compose up -d
```


## 配置说明

### 环境变量

#### 可定制环境变量

| 名称 | 描述 | 默认值 |
|------|------|--------|
| `REDIS_SENTINEL_DATA_DIR` | Redis 数据目录 | `${REDIS_SENTINEL_VOLUME_DIR}/data` |
| `REDIS_SENTINEL_DISABLE_COMMANDS` | 禁用的 Redis 命令 | `nil` |
| `REDIS_SENTINEL_DATABASE` | 默认数据库名 | `redis` |
| `REDIS_SENTINEL_AOF_ENABLED` | 是否启用 AOF 持久化 | `yes` |
| `REDIS_SENTINEL_HOST` | Sentinel 监听主机 | `nil` |
| `REDIS_SENTINEL_MASTER_NAME` | 主节点名称 | `nil` |
| `REDIS_SENTINEL_PORT_NUMBER` | Sentinel 监听端口 | `$REDIS_SENTINEL_DEFAULT_PORT_NUMBER` |
| `REDIS_SENTINEL_QUORUM` | 故障转移法定人数（最小 Sentinel 节点数） | `2` |
| `REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS` | 节点判定为下线的超时时间（毫秒） | `60000` |
| `REDIS_SENTINEL_FAILOVER_TIMEOUT` | 故障转移超时时间（毫秒） | `180000` |
| `REDIS_SENTINEL_MASTER_REBOOT_DOWN_AFTER_PERIOD` | 主节点重启超时时间（毫秒） | `0` |
| `REDIS_SENTINEL_RESOLVE_HOSTNAMES` | 是否启用主机名解析 | `yes` |
| `REDIS_SENTINEL_ANNOUNCE_HOSTNAMES` | 是否广播主机名 | `no` |
| `ALLOW_EMPTY_PASSWORD` | 是否允许空密码访问 | `no` |
| `REDIS_SENTINEL_PASSWORD` | Sentinel 认证密码 | `nil` |
| `REDIS_MASTER_USER` | Redis 主节点用户名 | `nil` |
| `REDIS_MASTER_PASSWORD` | Redis 主节点密码 | `nil` |
| `REDIS_SENTINEL_ANNOUNCE_IP` | 广播的 IP 地址（用于集群发现） | `nil` |
| `REDIS_SENTINEL_ANNOUNCE_PORT` | 广播的端口（用于集群发现） | `nil` |
| `REDIS_SENTINEL_TLS_ENABLED` | 是否启用 TLS 认证 | `no` |
| `REDIS_SENTINEL_TLS_PORT_NUMBER` | TLS 监听端口（需启用 TLS） | `26379` |
| `REDIS_SENTINEL_TLS_CERT_FILE` | TLS 证书文件路径 | `nil` |
| `REDIS_SENTINEL_TLS_KEY_FILE` | TLS 密钥文件路径 | `nil` |
| `REDIS_SENTINEL_TLS_CA_FILE` | TLS CA 证书文件路径 | `nil` |
| `REDIS_SENTINEL_TLS_CA_DIR` | TLS CA 证书目录 | `nil` |
| `REDIS_SENTINEL_TLS_DH_PARAMS_FILE` | TLS DH 参数文件路径 | `nil` |
| `REDIS_SENTINEL_TLS_AUTH_CLIENTS` | 是否启用 TLS 客户端认证 | `yes` |
| `REDIS_MASTER_HOST` | Redis 主节点主机地址 | `redis` |
| `REDIS_MASTER_PORT_NUMBER` | Redis 主节点端口 | `6379` |
| `REDIS_MASTER_SET` | Sentinel 主节点集名称 | `mymaster` |

#### 只读环境变量

| 名称 | 描述 | 值 |
|------|------|-----|
| `REDIS_SENTINEL_VOLUME_DIR` | 持久化基础目录 | `/bitnami/redis-sentinel` |
| `REDIS_SENTINEL_BASE_DIR` | Redis 安装目录 | `${BITNAMI_ROOT_DIR}/redis-sentinel` |
| `REDIS_SENTINEL_CONF_DIR` | 配置文件目录 | `${REDIS_SENTINEL_BASE_DIR}/etc` |
| `REDIS_SENTINEL_CONF_FILE` | 主配置文件路径 | `${REDIS_SENTINEL_CONF_DIR}/sentinel.conf` |
| `REDIS_SENTINEL_LOG_DIR` | 日志目录 | `${REDIS_SENTINEL_BASE_DIR}/logs` |
| `REDIS_SENTINEL_PID_FILE` | PID 文件路径 | `${REDIS_SENTINEL_TMP_DIR}/redis-sentinel.pid` |
| `REDIS_SENTINEL_DAEMON_USER` | 运行用户 | `redis` |
| `REDIS_SENTINEL_DAEMON_GROUP` | 运行用户组 | `redis` |
| `REDIS_SENTINEL_DEFAULT_PORT_NUMBER` | 默认监听端口 | `26379` |

### 安全配置

#### 启用 TLS 加密

```console
docker run --name redis-sentinel \
  -v /host/path/to/certs:/opt/bitnami/redis/certs \  # 挂载证书目录
  -v /host/path/to/data:/bitnami/redis-sentinel/data \  # 持久化数据
  -e REDIS_MASTER_HOST=redis-server \
  -e REDIS_SENTINEL_TLS_ENABLED=yes \
  -e REDIS_SENTINEL_TLS_CERT_FILE=/opt/bitnami/redis/certs/server.crt \
  -e REDIS_SENTINEL_TLS_KEY_FILE=/opt/bitnami/redis/certs/server.key \
  -e REDIS_SENTINEL_TLS_CA_FILE=/opt/bitnami/redis/certs/ca.crt \
  bitnami/redis-sentinel:latest
```

> **注意**：启用 TLS 后默认禁用非 TLS 端口，如需同时监听，需设置 `REDIS_SENTINEL_PORT_NUMBER` 为非 0 值。

#### FIPS 模式配置（Bitnami Secure Images）

```console
docker run --name redis-sentinel \
  -e OPENSSL_FIPS=yes \  # 启用 FIPS 模式（默认 yes）
  bitnami/redis-sentinel:latest
```

### 自定义配置文件

#### 步骤 1：启动容器并挂载目录
```console
docker run --name redis-sentinel \
  -e REDIS_MASTER_HOST=redis-server \
  -v /host/path/to/data:/bitnami/redis-sentinel \  # 挂载持久化目录
  bitnami/redis-sentinel:latest
```

#### 步骤 2：修改配置文件
容器首次启动后，配置文件会生成在 `/host/path/to/data/conf/sentinel.conf`，可直接编辑：
```console
vi /host/path/to/data/conf/sentinel.conf
```

#### 步骤 3：重启容器使配置生效
```console
docker restart redis-sentinel
```


## 日志管理

容器日志输出至 `stdout`，可通过以下命令查看：
```console
docker logs redis-sentinel
```

如需自定义日志驱动，启动时添加 `--log-driver` 参数：
```console
docker run --name redis-sentinel \
  --log-driver=json-file \  # 默认驱动，可选 syslog、journald 等
  --log-opt max-size=10m \  # 日志文件最大 size
  --log-opt max-file=3 \    # 保留日志文件数
  bitnami/redis-sentinel:latest
```


## 维护与升级

### 升级镜像

#### 步骤 1：拉取最新镜像
```console
docker pull bitnami/redis-sentinel:latest
```

#### 步骤 2：停止并备份当前容器
```console
docker stop redis-sentinel
rsync -a /host/path/to/data /host/path/to/data.bkp.$(date +%Y%m%d-%H%M%S)  # 备份数据
```

#### 步骤 3：删除旧容器
```console
docker rm -v redis-sentinel
```

#### 步骤 4：启动新容器
```console
docker run --name redis-sentinel \
  -v /host/path/to/data:/bitnami/redis-sentinel \  # 使用原数据目录
  [其他环境变量] \
  bitnami/redis-sentinel:latest
```


## 重要变更记录

### 2024 年 1 月 16 日起
- 移除 `docker-compose.yaml` 文件，该文件仅用于内部测试。

### 版本 4.0.14-debian-9-r201 及后续
- 减小容器体积，配置逻辑基于 `rootfs/` 目录下的 Bash 脚本实现。

### 版本 4.0.10-r25 及后续
- 迁移为非 root 容器：容器和 Redis 进程均以 `redis` 用户（UID 1001）运行，配置文件支持非 root 用户写入。


## 常见问题与支持

### 提交问题
如遇到容器运行问题，请在 [Bitnami Containers GitHub 仓库](https://github.com/bitnami/containers/issues/new/choose) 提交 issue，并提供以下信息：
- 容器版本（`docker images | grep redis-sentinel`）
- 完整启动命令及日志（`docker logs [容器名]`）
- 宿主机环境（操作系统、Docker 版本）


## 许可证

Copyright © 2025 Broadcom. "Broadcom" 指 Broadcom Inc. 及其子公司。

本镜像基于 Apache License 2.0 许可协议分发。详见 [Apache 许可证](http://www.apache.org/licenses/LICENSE-2.0)。
