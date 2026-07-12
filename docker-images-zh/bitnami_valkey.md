---
image: bitnami/valkey
description: "Bitnami提供的valkey安全镜像，用于安全部署和运行高性能键值存储服务，具备可靠的安全性与便捷的部署维护特性。"
source: https://xuanyuan.cloud/zh/r/bitnami/valkey
canonical: https://xuanyuan.cloud/zh/r/bitnami/valkey
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/valkey" title="bitnami/valkey Docker 镜像中文简介、标签列表与拉取命令">bitnami/valkey 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Valkey 镜像文档


## ⚠️ 重要通知：Bitnami 镜像目录即将变更
自2025年8月28日起，Bitnami将升级其公共镜像目录，通过新的[Bitnami Secure Images计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)提供精选的强化安全镜像。过渡期安排如下：

- 首次向社区用户开放热门容器镜像的安全优化版本。
- Bitnami将逐步弃用免费 tier 中非强化的 Debian 基础镜像，并从公共目录中移除非最新标签。社区用户将只能访问数量减少的强化镜像，这些镜像仅以“latest”标签发布，适用于开发场景。
- 8月28日起两周内，所有现有容器镜像（包括旧版本标签，如2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议采用Bitnami Secure Images，包含强化容器、更小攻击面、CVE透明度（通过VEX/KEV）、SBOM及企业支持。

更多详情见[Bitnami Secure Images公告](https://github.com/bitnami/containers/issues/83267)。


## 为什么使用Bitnami Secure Images？
- 安全强化：专为开源软件的安全性和企业就绪性设计，通过VEX、KEV和EPSS评分提供CVE风险透明度。
- 最小化攻击面：基于Photon Linux构建，采用行业标准包格式，兼顾精简性和可扩展性。
- 持续更新：上游补丁发布后数小时内完成镜像更新，确保安全性和合规性。
- 跨格式一致性：容器、虚拟机和云镜像使用相同组件和配置方式，便于根据需求切换。
- 完整供应链保障：提供签名验证（Notation）、SBOM、病毒扫描报告等元数据，符合SLSA-3标准。


## 镜像概述和主要用途

### Valkey简介
Valkey是一款开源（BSD许可）的高性能键值数据库，支持缓存、消息队列、主数据库等多种工作负载，兼容Redis协议，提供亚毫秒级响应性能。

### Bitnami Valkey镜像特点
Bitnami Valkey镜像是Valkey的容器化分发版本，提供以下优势：
- 非root用户运行，增强安全性
- 预配置的持久化策略（默认AOF）
- 支持主从复制、ACL访问控制等高级特性
- 丰富的环境变量配置，简化部署流程
- 与Kubernetes、Docker Compose等工具无缝集成


## 核心功能和特性
- **多模式支持**：兼容缓存、消息队列（Pub/Sub）、主数据库等场景
- **持久化选项**：默认启用AOF（Append Only File），支持RDB快照策略
- **安全加固**：非root容器运行，可禁用危险命令（如FLUSHDB、CONFIG）
- **主从复制**：通过环境变量快速配置主从架构，支持读写分离
- **访问控制**：支持ACL（Access Control List），限制命令执行和键访问权限
- **灵活配置**：通过环境变量或配置文件覆盖默认参数，支持自定义端口、数据目录等


## 使用场景和适用范围
- **开发环境**：快速部署Valkey实例，用于应用调试和功能验证
- **缓存系统**：作为应用缓存层，提升读操作性能（如会话存储、热点数据缓存）
- **消息队列**：基于Pub/Sub实现简单的消息传递系统
- **主数据库**：轻量级键值存储需求，如计数器、排行榜、实时分析
- **生产环境**：采用Bitnami Secure Images，适用于对安全性和稳定性要求高的生产工作负载


## 详细使用方法和配置说明

### 获取镜像

#### 拉取预构建镜像
推荐从Docker Hub拉取最新版：
```console
docker pull docker.xuanyuan.run/bitnami/valkey:latest
```
指定版本（查看[可用标签](https://hub.docker.com/r/bitnami/valkey/tags/)）：
```console
docker pull docker.xuanyuan.run/bitnami/valkey:[TAG]  # 如bitnami/valkey:7.2.4
```

#### 本地构建镜像
克隆仓库并构建（替换`APP`、`VERSION`、`OPERATING-SYSTEM`占位符）：
```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```


### 基本部署

#### 快速启动（开发环境）
```console
docker run --name valkey -e ALLOW_EMPTY_PASSWORD=yes docker.xuanyuan.run/bitnami/valkey:latest
```
> **警告**：此配置仅适用于开发环境，生产环境需设置密码并调整安全参数。

#### Docker Compose部署
创建`docker-compose.yml`：
```yaml
version: '2'
services:
  valkey:
    image: docker.xuanyuan.run/bitnami/valkey:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=yes  # 开发环境允许空密码
      # - VALKEY_PASSWORD=your_secure_password  # 生产环境建议设置密码
    ports:
      - "6379:6379"
    volumes:
      - valkey-data:/bitnami/valkey/data  # 持久化数据卷

volumes:
  valkey-data:
```
启动服务：
```console
docker-compose up -d
```


### 数据持久化
Valkey数据默认存储在`/bitnami/valkey/data`，移除容器后数据会丢失。通过挂载卷实现持久化：

#### Docker命令方式
```console
docker run \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -v /path/to/local/data:/bitnami/valkey/data \  # 本地目录挂载
  bitnami/valkey:latest
```

#### Docker Compose方式
在`docker-compose.yml`中添加卷配置（见上文示例），确保挂载目录对UID `1001`有读写权限（非root容器要求）。


### 与其他容器通信
通过Docker网络实现容器间通信，使用容器名作为主机名。

#### 命令行方式
1. 创建网络：
```console
docker network create app-tier --driver bridge
```

2. 启动Valkey服务：
```console
docker run -d --name valkey-server \
  -e ALLOW_EMPTY_PASSWORD=yes \
  --network app-tier \
  docker.xuanyuan.run/bitnami/valkey:latest
```

3. 启动客户端容器（连接Valkey）：
```console
docker run -it --rm \
  --network app-tier \
  docker.xuanyuan.run/bitnami/valkey:latest valkey-cli -h valkey-server
```

#### Docker Compose方式
```yaml
version: '2'
networks:
  app-tier:
    driver: bridge
services:
  valkey:
    image: docker.xuanyuan.run/bitnami/valkey:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    networks:
      - app-tier
  myapp:  # 你的应用容器
    image: docker.xuanyuan.run/YOUR_APPLICATION_IMAGE  # 替换为实际应用镜像
    networks:
      - app-tier
    # 应用中使用主机名"valkey"连接Valkey服务
```


### 配置说明

#### 环境变量
通过环境变量自定义Valkey行为，分为可定制变量和只读变量。

##### 可定制环境变量
| 名称                          | 描述                                  | 默认值                                   |
|-------------------------------|---------------------------------------|------------------------------------------|
| `VALKEY_DATA_DIR`             | 数据存储目录                          | `${VALKEY_VOLUME_DIR}/data`              |
| `VALKEY_DISABLE_COMMANDS`     | 禁用的命令（逗号分隔）                | `nil`                                    |
| `VALKEY_AOF_ENABLED`          | 是否启用AOF持久化                     | `yes`                                    |
| `VALKEY_RDB_POLICY`           | RDB持久化策略（如"save 900 1"）       | `nil`                                    |
| `VALKEY_RDB_POLICY_DISABLED`  | 是否禁用RDB策略                       | `no`                                     |
| `VALKEY_PRIMARY_HOST`         | 主节点主机名（从节点用）              | `nil`                                    |
| `VALKEY_PRIMARY_PORT_NUMBER`  | 主节点端口（从节点用）                | `6379`                                   |
| `VALKEY_PORT_NUMBER`          | 服务端口                              | `$VALKEY_DEFAULT_PORT_NUMBER`            |
| `VALKEY_REPLICATION_MODE`     | 复制模式（primary/replica）           | `nil`                                    |
| `VALKEY_EXTRA_FLAGS`          | 传递给valkey-server的额外参数         | `nil`                                    |
| `ALLOW_EMPTY_PASSWORD`        | 允许空密码访问                        | `no`                                     |
| `VALKEY_PASSWORD`             | 服务密码                              | `nil`                                    |
| `VALKEY_ACLFILE`              | ACL配置文件路径                       | `nil`                                    |
| `VALKEY_TLS_ENABLED`          | 是否启用TLS                           | `no`                                     |

##### 只读环境变量（运行时自动设置）
| 名称                          | 描述                                  | 值                                       |
|-------------------------------|---------------------------------------|------------------------------------------|
| `VALKEY_VOLUME_DIR`           | 持久化基础目录                        | `/bitnami/valkey`                        |
| `VALKEY_CONF_FILE`            | 配置文件路径                          | `${VALKEY_CONF_DIR}/valkey.conf`         |
| `VALKEY_LOG_FILE`             | 日志文件路径                          | `${VALKEY_LOG_DIR}/valkey.log`           |
| `VALKEY_PID_FILE`             | PID文件路径                           | `${VALKEY_TMP_DIR}/valkey.pid`           |
| `VALKEY_DAEMON_USER`          | 运行用户                              | `valkey`                                 |
| `VALKEY_DEFAULT_PORT_NUMBER`  | 默认端口                              | `6379`                                   |


#### 常见配置场景

##### 禁用危险命令
通过`VALKEY_DISABLE_COMMANDS`禁用高风险命令（如FLUSHDB、CONFIG）：
```console
docker run --name valkey \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -e VALKEY_DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG \
  docker.xuanyuan.run/bitnami/valkey:latest
```

##### 传递额外启动参数
通过`VALKEY_EXTRA_FLAGS`或命令参数传递自定义配置（如内存限制）：
```console
docker run --name valkey \
  -e ALLOW_EMPTY_PASSWORD=yes \
  docker.xuanyuan.run/bitnami/valkey:latest /opt/bitnami/scripts/valkey/run.sh --maxmemory 100mb
```

##### 设置服务密码
生产环境必须设置密码，通过`VALKEY_PASSWORD`指定：
```console
docker run --name valkey \
  -e VALKEY_PASSWORD=your_secure_password \  # 不支持包含@符号
  bitnami/valkey:latest
```

##### 禁用AOF持久化
默认启用AOF，通过`VALKEY_AOF_ENABLED=no`禁用：
```console
docker run --name valkey \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -e VALKEY_AOF_ENABLED=no \
  docker.xuanyuan.run/bitnami/valkey:latest
```

##### 启用访问控制列表（ACL）
挂载ACL配置文件并通过`VALKEY_ACLFILE`指定路径：
```console
docker run --name valkey \
  -e VALKEY_ACLFILE=/opt/bitnami/valkey/mounted-etc/users.acl \
  -v /path/to/local/users.acl:/opt/bitnami/valkey/mounted-etc/users.acl \
  docker.xuanyuan.run/bitnami/valkey:latest
```
`users.acl`示例：
```
user alice on >password ~* +@all  # 允许访问所有键和命令
user bob on >password ~user:* +get  # 仅允许读取user:*键
```

##### 配置主从复制

1. **启动主节点**：
```console
docker run --name valkey-primary \
  -e VALKEY_REPLICATION_MODE=primary \
  -e VALKEY_PASSWORD=primarypass \
  docker.xuanyuan.run/bitnami/valkey:latest
```

2. **启动从节点**（连接主节点）：
```console
docker run --name valkey-replica \
  --link valkey-primary:primary \  # 链接主节点容器
  -e VALKEY_REPLICATION_MODE=replica \
  -e VALKEY_PRIMARY_HOST=primary \  # 主节点主机名（容器名）
  -e VALKEY_PRIMARY_PORT_NUMBER=6379 \
  -e VALKEY_PRIMARY_PASSWORD=primarypass \  # 主节点密码
  -e VALKEY_PASSWORD=replicapass \  # 从节点自身密码
  bitnami/valkey:latest
```


## Kubernetes部署
通过Helm Chart部署是在Kubernetes上使用Bitnami应用的推荐方式，详见[Bitnami Valkey Chart GitHub仓库](https://github.com/bitnami/charts/tree/master/bitnami/valkey)。


## 总结
Bitnami Valkey镜像提供了安全、灵活、易于部署的Valkey容器化方案，支持开发和生产环境。通过环境变量和卷挂载可快速配置持久化、主从复制、ACL等高级特性，结合Bitnami Secure Images可满足企业级安全需求。
