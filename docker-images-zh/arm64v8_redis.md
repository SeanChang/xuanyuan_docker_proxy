---
image: arm64v8/redis
description: "Redis是全球速度最快的数据平台，它整合了缓存、向量搜索与NoSQL数据库功能，可高效实现数据缓存以提升访问速度、支持向量搜索满足AI驱动的相似性查询需求，并作为NoSQL数据库提供灵活的数据存储与处理能力，广泛适用于各类高性能数据应用场景。"
source: https://xuanyuan.cloud/zh/r/arm64v8/redis
canonical: https://xuanyuan.cloud/zh/r/arm64v8/redis
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm64v8/redis" title="arm64v8/redis Docker 镜像中文简介、标签列表与拉取命令">arm64v8/redis 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Redis 官方镜像（arm64v8 架构）介绍


## 说明
本文档对应 [Redis 官方镜像]  的 `arm64v8` 架构专属仓库。更多信息可参考官方镜像文档的「[非 amd64 架构说明] 」及 FAQ 的「[镜像源码在 Git 中变更后如何处理] 」。


## 快速参考

### 维护方  
[Redis LTD] 

### 获取帮助  
可通过以下渠道寻求帮助：[Docker 社区 Slack] 、[Server Fault] 、[Unix & Linux]  或 [Stack Overflow] 。


## 支持的标签及对应 Dockerfile 链接  

- [`8.2.2`, `8.2`, `8`, `8.2.2-bookworm`, `8.2-bookworm`, `8-bookworm`, `latest`, `bookworm`]   
- [`8.2.2-alpine`, `8.2-alpine`, `8-alpine`, `8.2.2-alpine3.22`, `8.2-alpine3.22`, `8-alpine3.22`, `alpine`, `alpine3.22`]   
- [`8.0.4`, `8.0`, `8.0.4-bookworm`, `8.0-bookworm`]   
- [`8.0.4-alpine`, `8.0-alpine`, `8.0.4-alpine3.21`, `8.0-alpine3.21`]   
- [`7.4.6`, `7.4`, `7`, `7.4.6-bookworm`, `7.4-bookworm`, `7-bookworm`]   
- [`7.4.6-alpine`, `7.4-alpine`, `7-alpine`, `7.4.6-alpine3.21`, `7.4-alpine3.21`, `7-alpine3.21`]   
- [`7.2.11`, `7.2`, `7.2.11-bookworm`, `7.2-bookworm`]   
- [`7.2.11-alpine`, `7.2-alpine`, `7.2.11-alpine3.21`, `7.2-alpine3.21`]   
- [`6.2.20`, `6.2`, `6`, `6.2.20-bookworm`, `6.2-bookworm`, `6-bookworm`]   
- [`6.2.20-alpine`, `6.2-alpine`, `6-alpine`, `6.2.20-alpine3.21`, `6.2-alpine3.21`, `6-alpine3.21`]   


## 快速参考（续）  

### 提交 issue 的地址  
[[]]   

### 支持的架构（更多信息）  
[`amd64`] 、[`arm32v5`] 、[`arm32v6`] 、[`arm32v7`] 、[`arm64v8`] 、[`i386`] 、[`mips64le`] 、[`ppc64le`] 、[`riscv64`] 、[`s390x`]   

### 镜像 artifact 详情  
[repo-info 仓库的 `repos/redis/` 目录] （[历史记录] ）  
（包含镜像元数据、传输大小等信息）  

### 镜像更新  
[official-images 仓库的 `library/redis` 标签]   
[official-images 仓库的 `library/redis` 文件] （[历史记录] ）  

### 本文档来源  
[docs 仓库的 `redis/` 目录] （[历史记录] ）  


## 什么是 Redis？  
Redis 是全球最快的数据平台，提供云环境和本地部署的缓存、向量搜索及 NoSQL 数据库解决方案，可无缝集成到任何技术栈中，帮助用户轻松构建、扩展和部署支撑现代世界运行的高速应用。  

> 更多信息：[redis.io]   

![logo]   


## 安全性  

为便于通过 Docker 网络从其他容器访问 Redis，默认关闭「保护模式」。这意味着如果通过 `docker run -p` 将端口暴露到主机外部，Redis 将无密码对外公开。**强烈建议**：若计划将 Redis 实例暴露到公网，务必通过配置文件设置密码。相关安全说明可参考：  
- [Redis 安全文档]   
- [保护模式]   
- [antirez 关于 Redis 安全的几点说明]   

### 进程用户与权限  
默认情况下，Redis Docker 镜像会切换到 `redis` 用户并移除不必要的系统权限，以降低安全风险。若通过 `--user` 选项指定用户，或设置环境变量 `SKIP_DROP_PRIVS=1`（8.0.2 及以上版本支持），则会跳过权限降级步骤。**注意**：不推荐使用 `SKIP_DROP_PRIVS`，这会降低容器安全性。  


## 如何使用本镜像  

### 启动 Redis 实例  
```console
$ docker run --name some-redis -d arm64v8/redis
```

### 启动带持久化存储的实例  
```console
$ docker run --name some-redis -d arm64v8/redis redis-server --save 60 1 --loglevel warning
```  
上述命令配置 Redis 每 60 秒内若有至少 1 次写入操作，则保存数据库快照；`--loglevel warning` 可减少日志输出。持久化数据默认存储在 `VOLUME /data`，可通过 `--volumes-from some-volume-container` 或 `-v /docker/host/dir:/data` 挂载外部存储（详见 [Docker 卷文档] ）。关于 Redis 持久化的更多信息，参见 [官方文档] 。  

#### 文件与目录权限  
Redis（8.0.2 及以上版本）会尝试自动修正数据目录和配置文件的所有权及权限（仅在基础默认场景下），避免干扰自定义配置。若需跳过此步骤，可设置环境变量 `SKIP_FIX_PERMS=1`。  

#### 手动设置文件权限  
若需自行管理权限，可通过以下命令调整挂载卷的所有权：  
```console
$ docker run --rm -v /your/host/path:/data arm64v8/redis chown -R redis:redis /data
```

### 通过 `redis-cli` 连接  
```console
$ docker run -it --network some-network --rm arm64v8/redis redis-cli -h some-redis
```  
（`some-network` 为容器所在网络，`some-redis` 为 Redis 容器名称）  

### 使用自定义配置文件  

#### 方法 1：通过 Dockerfile 构建  
创建包含自定义 `redis.conf` 的 Dockerfile：  
```dockerfile
FROM docker.xuanyuan.run/arm64v8/redis
COPY redis.conf /usr/local/etc/redis/redis.conf
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
```  

#### 方法 2：直接通过 `docker run` 挂载  
无需编写 Dockerfile，直接挂载配置目录：  
```console
$ docker run -v /myredis/conf:/usr/local/etc/redis --name myredis arm64v8/redis redis-server /usr/local/etc/redis/redis.conf
```  
（`/myredis/conf/` 为本地目录，包含你的 `redis.conf` 文件。挂载目录需可写，因 Redis 可能需要创建或重写配置文件。）  


## 镜像变体  

`arm64v8/redis` 提供多种镜像变体，适用于不同场景：  

### `arm64v8/redis:<version>`  
默认镜像，基于 Debian 系统（标签中含 `bookworm` 等字样表示 Debian 发行版代号）。若不确定需求，建议使用此变体。它既可用作临时容器，也可作为基础镜像构建其他镜像。  

### `arm64v8/redis:<version>-alpine`  
基于 [Alpine Linux] （[`alpine` 官方镜像] ），体积极小（约 5MB），适合对镜像大小有严格要求的场景。注意：Alpine 使用 `musl libc` 而非 `glibc`，部分依赖 glibc 的软件可能存在兼容性问题（详见 [相关讨论] ）。如需额外工具（如 `git`、`bash`），需在 Dockerfile 中自行安装（参考 [Alpine 镜像文档] ）。  


## 许可协议  

- Redis 8.0 及以上版本采用三许可模式：[Redis 源码可用许可 v2（RSALv2）] 、[服务器端公共许可 v1（SSPLv1）]  或 [GNU Affero 通用公共许可 v3（AGPLv3）] 。  
- Redis 7.4.x-7.8.x 采用双许可：[RSALv2]  或 [SSPLv1] 。  
- Redis 7.2.4 及以下版本采用 [3-Clause BSD 许可] 。  

更多信息参见 [Redis 许可协议概述]  和 [Redis 商标政策] 。  

与所有 Docker 镜像一样，本镜像可能包含其他软件（如基础系统的 Bash 等），其许可协议需另行确认。自动检测到的许可信息可参考 [repo-info 仓库的 `redis/` 目录] 。  

使用前请确保遵守所有包含软件的许可协议。
