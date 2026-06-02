---
image: ubuntu/redis
description: "Redis是开源键值存储，提供由Canonical维护的长期版本。"
source: https://xuanyuan.cloud/zh/r/ubuntu/redis
canonical: https://xuanyuan.cloud/zh/r/ubuntu/redis
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/redis" title="ubuntu/redis Docker 镜像中文简介、标签列表与拉取命令">ubuntu/redis — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ubuntu/redis" title="ubuntu/redis Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ubuntu/redis</a>

# Redis™ 软件 | Ubuntu Docker 镜像文档


## 镜像概述和主要用途

本镜像为 Canonical 提供的 Redis™ 软件 Docker 镜像，基于 Ubuntu 系统构建。该镜像会接收安全更新，并跟踪 Redis™ 软件与 Ubuntu 系统的最新组合版本。**本仓库可免费使用，且不受每用户速率限制。**

Redis 是一款开源（BSD 许可）的内存数据结构存储系统，主要用作数据库、缓存和消息代理，适用于需要高性能数据访问和实时数据处理的场景。


## 核心功能和特性

### Redis 核心功能
- **多数据结构支持**：字符串、哈希表、列表、集合、有序集合（支持范围查询）、位图、HyperLogLog、地理空间索引（支持半径查询）和流
- **高可用性**：内置复制、Redis Sentinel 高可用方案、Redis Cluster 自动分片
- **数据持久化**：多种磁盘持久化级别（RDB、AOF）
- **高级特性**：Lua 脚本、LRU 淘汰策略、事务支持
- **性能优化**：基于内存操作，低延迟高吞吐量

### 镜像特性
- **安全维护**：基于 Ubuntu 系统，提供长期安全更新支持
- **多架构支持**：适配 `amd64`、`arm64`、`ppc64el`、`s390x` 等架构
- **灵活配置**：支持通过环境变量和自定义配置文件调整 Redis 行为


## 使用场景和适用范围

- **高性能缓存系统**：利用 Redis 内存存储特性，加速应用数据访问
- **实时数据处理**：支持流数据结构，适用于日志收集、实时分析场景
- **分布式系统组件**：作为分布式锁、会话存储、消息队列使用
- **开发测试环境**：快速部署独立 Redis 实例，无需复杂环境配置
- **生产环境部署**：LTS 版本提供长达 5 年免费安全维护，满足企业级稳定性需求


## 标签和架构

![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)  
LTS 通道提供最长 5 年免费安全维护  

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)  
通过 `canonical/redis` 可获取最长 10 年客户安全维护，[申请访问](https://ubuntu.com/security/docker-images#get-in-touch)  

*斜体标签在 ubuntu/redis 中不可用，仅为完整性展示*  

| 通道标签                | 当前版本                          | 架构支持                          |
|-------------------------|-----------------------------------|-----------------------------------|
| **`6.2-22.04_beta`**    | Redis™ 软件 6.2 基于 Ubuntu 22.04 LTS | `amd64`, `arm64`, `ppc64el`, `s390x` |
| _`track_risk`_          | -                                 | -                                 |

### 标签说明
- **通道标签**：表示对应轨道（track）的最稳定通道。轨道是应用版本与 Ubuntu 系列的组合，例如 `1.0-22.04`。
- **通道稳定性排序**：从最稳定到最不稳定依次为 `stable`、`candidate`、`beta`、`edge`。风险较高的通道默认隐含可用（如列出 `beta` 则可拉取 `edge`，列出 `stable` 则所有四个通道均可用）。
- **版本发布顺序**：镜像会按 `edge` → `beta` → `candidate` → `stable` 顺序发布。

### 商业用途与扩展安全维护通道
若需商业再分发或访问未列出的通道/版本，请[联系 Canonical 团队](https://ubuntu.com/security/docker-images#get-in-touch)（或发送邮件至 rocks@canonical.com）。


## 使用方法和配置说明

### Docker 快速启动
本地启动镜像：

```sh
docker run -d --name redis-container -e TZ=UTC -p 30073:6379 -e REDIS_PASSWORD=mypassword ubuntu/redis:6.2-22.04_beta
```

通过 `localhost:30073` 访问 Redis 服务。

### 参数说明

| 参数                          | 描述                                                                 |
|-------------------------------|----------------------------------------------------------------------|
| `-e TZ=UTC`                   | 设置时区。                                                            |
| `-e ALLOW_EMPTY_PASSWORD`     | 设置为 `yes` 允许无密码连接 Redis 服务。**生产环境不推荐此配置**。   |
| `-e REDIS_PASSWORD`           | 设置 Redis 访问密码。                                                |
| `-e REDIS_RANDOM_PASSWORD`    | 设置为 `1` 时，入口脚本会生成随机密码，可通过 `docker logs` 查看。    |
| `-e REDIS_ALLOW_REMOTE_CONNECTIONS=yes` | 设置为 `no` 时仅允许本地连接（Redis 绑定 `127.0.0.1`）。         |
| `-e REDIS_EXTRA_FLAGS`        | 指定启动 `redis-server` 时的额外参数。                               |
| `-p 30073:6379`               | 端口映射，将容器内 6379 端口映射到主机 30073 端口。                  |
| `-v /path/to/redis.conf:/etc/redis/redis.conf` | 挂载本地配置文件（示例配置见 [此处](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/redis/plain/examples/config/redis.conf?h=6.2-22.04)）。**启用 TLS**：注释 `port 6379`，取消注释 `# port 0` 和 `# tls-port 6379`。 |

### 测试与调试

#### 查看容器日志
```sh
docker logs -f redis-container
```

#### 进入容器交互终端
```sh
docker exec -it redis-container /bin/bash
```

#### 使用 redis-cli 连接
```sh
# 创建网络并连接容器
docker network create redis-network
docker network connect redis-network redis-container

# 启动 redis-cli 客户端
docker run -it --rm --network redis-network ubuntu/redis:6.2-22.04_beta redis-cli -h redis-container
```

连接后操作示例：
```
redis:6379> AUTH mypassword
OK
redis:6379> PING
PONG
redis:6379>
```


### Kubernetes 部署
适用于任何 Kubernetes 环境，推荐使用 MicroK8s（安装方法：[MicroK8s 文档](https://microk8s.io/)，启用组件：`microk8s.enable dns storage`，设置别名：`snap alias microk8s.kubectl kubectl`）。

1. 下载配置文件：
   - [redis.conf](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/redis/plain/examples/config/redis.conf?h=6.2-22.04)
   - [redis-deployment.yml](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/redis/plain/examples/redis-deployment.yml?h=6.2-22.04)

2. 修改 `redis-deployment.yml` 中 `containers.redis.image` 为目标通道标签（例如 `ubuntu/redis:6.2-22.04_beta`）。

3. 部署命令：
```sh
kubectl create configmap redis-config --from-file=redis=redis.conf
kubectl apply -f redis-deployment.yml
```

通过 `localhost:30073` 访问 Redis 服务。


## 废弃通道与标签
以下通道（标签）不再更新，请升级至新版本；若无法升级，可[联系支持](https://ubuntu.com/security/docker-images#get-in-touch)。

| 轨道                | 版本                              | EOL 日期   | 升级路径          |
|---------------------|-----------------------------------|------------|-------------------|
| ~~6.0-21.10~~       | Redis™ 软件 6.0.15 基于 Ubuntu 21.10 | 2022-07    | 6.2-22.04_beta    |
| ~~6.0-21.04~~       | Redis™ 软件 6.0.11 基于 Ubuntu 21.04 | 2022-01    | ~~6.0-21.10~~     |
| ~~5.0-20.04~~       | Redis™ 软件 5.0.7 基于 Ubuntu 20.04 LTS | 2021-01    | ~~6.0-21.04~~     |
| _`track`_           | -                                 | -          | -                 |


## Bugs 和功能请求
如发现镜像 bug 或需请求功能，请通过以下链接提交：  
[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)  

请将 bug 标题格式化为：`redis: <问题摘要>`，并包含所用镜像的 digest（通过以下命令获取）：  
```sh
docker images --no-trunc --quiet ubuntu/redis:<tag>
