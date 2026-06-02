---
image: library/redis
description: "Redis 官方 Docker 镜像，提供开箱即用的高性能键值数据库服务，适合作为缓存、会话存储、消息队列和排行榜等场景的基础组件，支持持久化与多架构部署，适合本地开发与生产环境按需扩展使用。"
source: https://xuanyuan.cloud/zh/r/library/redis
canonical: https://xuanyuan.cloud/zh/r/library/redis
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/redis" title="library/redis Docker 镜像中文简介、标签列表与拉取命令">library/redis — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/redis" title="library/redis Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/redis</a>

# Redis 官方 Docker 镜像中文说明

## 一、概述

Redis 是一款高性能键值数据库，常用于缓存、排行榜、会话存储、消息队列、实时统计以及简单的 NoSQL 存储等场景。本镜像基于官方 Redis 发行版构建，开箱即用，适合在本地开发环境、测试环境以及生产环境中以容器方式快速部署 Redis 服务。

- 默认监听端口：`6379`
- 默认数据目录：`/data`
- 支持多架构：常见的 `amd64` / `arm64` 等
- 提供 Debian 与 Alpine 等多种基础系统变体，方便在“功能完整”和“极致轻量”之间做权衡

## 二、典型使用场景

- **应用缓存**：给 Web / 后端服务提供低延迟缓存层，减轻数据库压力，提高整体响应速度。
- **分布式会话与令牌存储**：在多实例部署场景下存放登录态、Session、JWT 黑白名单等。
- **队列与消息中转**：利用 List / Stream 等数据结构实现简易队列、任务派发、日志收集等能力。
- **实时统计与排行榜**：基于 Sorted Set / Hash 实现 PV/UV 统计、积分榜、热度榜等功能。
- **简单 KV/文档存储**：在对关系特性要求不高的场景中，作为轻量数据存储使用。

## 三、快速开始

### 1. 启动一个最简 Redis 实例

```bash
docker run -d \
  --name redis \
  -p 6379:6379 \
  redis:latest
```

此命令会：

- 以后台方式启动一个名为 `redis` 的容器；
- 将容器内 `6379` 端口映射到宿主机 `6379` 端口；
- 使用镜像内默认配置（无密码、数据存放在容器的 `/data` 目录）。

> 仅建议在本地开发或受信任内网中这样使用，生产环境务必增加密码与访问控制。

### 2. 配置持久化数据目录

为了避免容器删除后数据丢失，可以将 `/data` 挂载到宿主机目录或 Docker 卷：

```bash
docker run -d \
  --name redis \
  -p 6379:6379 \
  -v /opt/redis/data:/data \
  redis:latest
```

- 所有 RDB / AOF 文件及运行中产生的数据都会写入宿主机 `/opt/redis/data` 目录；
- 升级或重建容器时，只要继续挂载同一目录即可保留数据。

## 四、基础安全与配置建议

### 1. 设置访问密码

默认配置下，Redis 对外开放端口且**无密码认证**，非常危险。常见做法是：

- 自定义 `redis.conf` 并开启 `requirepass`；
- 仅在内网或 Docker 网络内部暴露端口，对公网使用反向代理或隧道访问。

示例：使用自定义配置文件（假设已在宿主机 `/opt/redis/redis.conf` 中配置好密码等参数）：

```bash
docker run -d \
  --name redis \
  -p 6379:6379 \
  -v /opt/redis/redis.conf:/usr/local/etc/redis/redis.conf:ro \
  -v /opt/redis/data:/data \
  redis:latest redis-server /usr/local/etc/redis/redis.conf
```

### 2. 网络与访问控制

- 优先使用 Docker 自定义网络，仅在需要时映射宿主机端口；
- 对生产环境，建议只开放给反向代理 / 应用服务所在子网，不直接暴露公网；
- 如必须公网访问，务必设置强密码，并考虑加一层安全网关（如 VPN、SSH 隧道等）。

## 五、常用运维操作

### 1. 使用 redis-cli 连接容器内 Redis

```bash
# 从宿主机连接（端口已映射时）
redis-cli -h 127.0.0.1 -p 6379

# 从另一个容器连接（同一 Docker 网络时）
docker run -it --rm --network some-network redis redis-cli -h redis
```

若配置了密码，可以在进入 `redis-cli` 后使用：

```bash
AUTH your-strong-password
```

### 2. 查看日志与状态

```bash
# 查看容器日志
docker logs -f redis

# 进入容器执行 INFO / MONITOR 等命令
docker exec -it redis redis-cli INFO
```

## 六、选择合适的镜像变体

- **`redis:<version>`（Debian 默认版）**：可用性好、生态成熟，适合大多数环境，是推荐的通用选择。
- **`redis:<version>-alpine`（Alpine 轻量版）**：镜像体积极小，适合作为基础镜像或对磁盘占用极其敏感的场景，但某些依赖 glibc 的工具可能不兼容。

## 七、适用人群

- 希望快速在本地或测试环境中起一个 Redis 实例的开发者；
- 需要为业务增加高性能缓存层、会话存储或排行榜能力的后端工程师；
- 希望以容器方式统一管理中间件组件（Redis、MySQL、Nginx 等）的运维人员。
