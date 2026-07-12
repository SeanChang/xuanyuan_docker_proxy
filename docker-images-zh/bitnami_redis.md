---
image: bitnami/redis
description: "Bitnami Redis安全镜像是基于开源Redis内存数据存储的预配置安全解决方案，集成了自动漏洞修复、合规性检查及加固配置，支持快速部署且易于维护，适用于作为数据库、缓存或消息代理的场景，为用户提供安全可靠的Redis运行环境。"
source: https://xuanyuan.cloud/zh/r/bitnami/redis
canonical: https://xuanyuan.cloud/zh/r/bitnami/redis
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/redis" title="bitnami/redis Docker 镜像中文简介、标签列表与拉取命令">bitnami/redis 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Redis® 软件包介绍


## 什么是 Redis®？

> Redis® 是一款开源的高级键值存储系统，常被称为“数据结构服务器”，因其键可存储字符串、哈希表、列表、集合及有序集合等多种数据类型。

[Redis® 官方概述]   
**免责声明**：Redis 是 Redis Ltd. 的注册商标，其相关权利归 Redis Ltd. 所有。Bitnami 对该名称的使用仅为参考，不代表任何赞助、认可或关联关系。


## 快速启动（仅供开发环境）

```console
docker run --name redis -e ALLOW_EMPTY_PASSWORD=yes docker.xuanyuan.run/bitnami/redis:latest
```

**警告**：上述快速启动命令仅适用于开发环境。生产环境中需修改默认不安全凭据，并参考 [配置](#配置) 部分进行安全部署。


### 关于 Bitnami 安全镜像（BSI）

本镜像是由 Bitnami 构建和维护的安全加固型低漏洞镜像，基于云优化的企业级安全操作系统 [Photon Linux] 。选择 BSI 镜像的优势包括：  
- 热门开源软件的安全加固版本，漏洞数量接近零  
- 漏洞分级与优先级处理，提供 VEX 声明、KEV 和 EPSS 评分  
- 合规支持（FIPS、STIG、离线环境）及安全物料清单（SBOM）  
- 通过 in-toto 实现软件供应链来源验证  
- 原生支持社区常用 Helm 图表  

每个镜像均附带安全元数据，可在 [公开目录]  查看（部分数据需 [BSI 商业订阅] ）。如需基于 Debian Linux 的旧版镜像，请参考 Bitnami Legacy 仓库。


## 如何在 Kubernetes 中部署 Redis®？

通过 Helm 图表部署 Bitnami 应用是在 Kubernetes 中快速上手的推荐方式。部署详情参见 [Bitnami Redis® Chart GitHub 仓库] 。


## 为什么使用非 root 容器？

非 root 容器可增强安全性，适合生产环境，但因运行非 root 用户，无法执行特权操作。更多信息参见 [非 root 容器文档] 。


## 支持的标签及对应 Dockerfile 链接

Bitnami 标签策略（滚动标签与不可变标签的区别）详见 [文档] 。不同标签的对应关系可查看代码库分支目录下的 `tags-info.yaml` 文件（如 `bitnami/APP/VERSION/OPERATING-SYSTEM/tags-info.yaml`）。可通过 [bitnami/containers GitHub 仓库]  订阅项目更新。


## 获取镜像

### 从 Docker Hub 拉取（推荐）

直接拉取最新版：  
```console
docker pull docker.xuanyuan.run/bitnami/redis:latest
```

拉取特定版本（版本列表见 [Docker Hub] ）：  
```console
docker pull docker.xuanyuan.run/bitnami/redis:[标签]
```

### 从源码构建

克隆仓库后构建（替换 `APP`、`VERSION`、`OPERATING-SYSTEM` 占位符）：  
```console
git clone [] bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```


## 数据持久化

Redis® 提供多种 [持久化方案] ，本容器默认启用 AOF 持久化。如需修改，可在 `docker-compose.yaml` 中通过 `command: /opt/bitnami/scripts/redis/run.sh --appendonly no` 覆盖配置，或使用 `REDIS_AOF_ENABLED` 环境变量（详见 [禁用 AOF 持久化] ）。

若删除容器，数据会丢失。需通过挂载卷至 `/bitnami` 目录实现持久化（首次运行时会初始化空目录）：

### Docker 命令方式  
```console
docker run \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /本地路径/redis-persistence:/bitnami/redis/data \
    docker.xuanyuan.run/bitnami/redis:latest
```

### Docker Compose 方式  
修改仓库中的 [`docker-compose.yml`] ：  
```yaml
services:
  redis:
  ...
    volumes:
      - /本地路径/redis-persistence:/bitnami/redis/data
  ...
```

> **注意**：由于容器以非 root 用户运行，挂载的文件/目录需具备 UID `1001` 的读写权限。


## 与其他容器通信

借助 [Docker 容器网络] ，Redis 服务可被其他应用容器访问，同一网络内的容器可通过容器名作为主机名通信。


### 命令行方式

#### 步骤 1：创建网络  
```console
docker network create app-tier --driver bridge
```

#### 步骤 2：启动 Redis 服务端  
```console
docker run -d --name redis-server \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --network app-tier \
    docker.xuanyuan.run/bitnami/redis:latest
```

#### 步骤 3：启动 Redis 客户端  
```console
docker run -it --rm \
    --network app-tier \
    docker.xuanyuan.run/bitnami/redis:latest redis-cli -h redis-server
```


### Docker Compose 方式

Docker Compose 会自动创建网络并关联服务，以下示例中 `myapp` 为自定义应用服务：  

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  redis:
    image: docker.xuanyuan.run/bitnami/redis:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    networks:
      - app-tier
  myapp:
    image: docker.xuanyuan.run/你的应用镜像
    networks:
      - app-tier
```

> **重要**：  
> 1. 将 `你的应用镜像` 替换为实际应用镜像  
> 2. 应用容器中通过主机名 `redis` 访问 Redis 服务  

启动容器：  
```console
docker-compose up -d
```


## 配置

### 环境变量

#### 可自定义环境变量  

| 变量名                          | 描述                                  | 默认值                                  |
|---------------------------------|---------------------------------------|-----------------------------------------|
| `REDIS_DATA_DIR`                | Redis 数据目录                        | `${REDIS_VOLUME_DIR}/data`              |
| `REDIS_OVERRIDES_FILE`          | 配置覆盖文件                          | `${REDIS_MOUNTED_CONF_DIR}/overrides.conf` |
| `REDIS_DISABLE_COMMANDS`        | 禁用的 Redis 命令（逗号分隔）         | `nil`（无）                             |
| `REDIS_DATABASE`                | 默认数据库名                          | `redis`                                 |
| `REDIS_AOF_ENABLED`             | 是否启用 AOF 持久化                   | `yes`                                   |
| `REDIS_RDB_POLICY`              | RDB 持久化策略                        | `nil`（无）                             |
| `REDIS_RDB_POLICY_DISABLED`     | 是否禁用 RDB 策略                     | `no`                                    |
| `REDIS_MASTER_HOST`             | 主节点主机名（从节点使用）            | `nil`（无）                             |
| `REDIS_MASTER_PORT_NUMBER`      | 主节点端口（从节点使用）              | `6379`                                  |
| `REDIS_PORT_NUMBER`             | Redis 服务端口                        | `$REDIS_DEFAULT_PORT_NUMBER`            |
| `REDIS_ALLOW_REMOTE_CONNECTIONS`| 是否允许远程连接                      | `yes`                                   |
| `REDIS_REPLICATION_MODE`        | 复制模式（master/slave）              | `nil`（无）                             |
| `REDIS_REPLICA_IP`              | 从节点公告 IP                         | `nil`（无）                             |
| `REDIS_REPLICA_PORT`            | 从节点公告端口                        | `nil`（无）                             |
| `REDIS_EXTRA_FLAGS`             | 传递给 redis-server 的额外参数        | `nil`（无）                             |
| `ALLOW_EMPTY_PASSWORD`          | 是否允许空密码访问                    | `no`                                    |
| `REDIS_PASSWORD`                | Redis 服务密码                        | `nil`（无）                             |
| `REDIS_MASTER_PASSWORD`         | 主节点密码（从节点使用）              | `nil`（无）                             |
| `REDIS_ACLFILE`                 | ACL 配置文件路径                      | `nil`（无）                             |
| `REDIS_IO_THREADS_DO_READS`     | 是否启用读多线程                      | `nil`（无）                             |
| `REDIS_IO_THREADS`              | 线程数                                | `nil`（无）                             |
| `REDIS_TLS_ENABLED`             | 是否启用 TLS                          | `no`                                    |
| `REDIS_TLS_PORT_NUMBER`         | TLS 端口（需启用 TLS）                | `6379`                                  |
| `REDIS_TLS_CERT_FILE`           | TLS 证书文件                          | `nil`（无）                             |
| `REDIS_TLS_CA_DIR`              | TLS CA 证书目录                       | `nil`（无）                             |
| `REDIS_TLS_KEY_FILE`            | TLS 密钥文件                          | `nil`（无）                             |
| `REDIS_TLS_KEY_FILE_PASS`       | TLS 密钥文件密码                      | `nil`（无）                             |
| `REDIS_TLS_CA_FILE`             | TLS CA 文件                           | `nil`（无）                             |
| `REDIS_TLS_DH_PARAMS_FILE`      | TLS DH 参数文件                       | `nil`（无）                             |
| `REDIS_TLS_AUTH_CLIENTS`        | 是否验证客户端 TLS 证书               | `yes`                                   |
| `REDIS_SENTINEL_MASTER_NAME`    | Sentinel 主节点名称                   | `nil`（无）                             |
| `REDIS_SENTINEL_HOST`           | Sentinel 主机名                       | `nil`（无）                             |
| `REDIS_SENTINEL_PORT_NUMBER`    | Sentinel 端口                         | `26379`                                 |


#### 只读环境变量  

| 变量名                          | 描述                                  | 值                                      |
|---------------------------------|---------------------------------------|-----------------------------------------|
| `REDIS_VOLUME_DIR`              | 持久化基础目录                        | `/bitnami/redis`                        |
| `REDIS_BASE_DIR`                | Redis 安装目录                        | `${BITNAMI_ROOT_DIR}/redis`             |
| `REDIS_CONF_DIR`                | 配置目录                              | `${REDIS_BASE_DIR}/etc`                 |
| `REDIS_DEFAULT_CONF_DIR`        | 默认配置目录                          | `${REDIS_BASE_DIR}/etc.default`         |
| `REDIS_MOUNTED_CONF_DIR`        | 挂载配置目录                          | `${REDIS_BASE_DIR}/mounted-etc`         |
| `REDIS_CONF_FILE`               | 配置文件路径                          | `${REDIS_CONF_DIR}/redis.conf`          |
| `REDIS_LOG_DIR`                 | 日志目录                              | `${REDIS_BASE_DIR}/logs`                |
| `REDIS_LOG_FILE`                | 日志文件路径                          | `${REDIS_LOG_DIR}/redis.log`            |
| `REDIS_TMP_DIR`                 | 临时目录                              | `${REDIS_BASE_DIR}/tmp`                 |
| `REDIS_PID_FILE`                | PID 文件路径                          | `${REDIS_TMP_DIR}/redis.pid`            |
| `REDIS_BIN_DIR`                 | 可执行文件目录                        | `${REDIS_BASE_DIR}/bin`                 |
| `REDIS_DAEMON_USER`             | 运行用户                              | `redis`                                 |
| `REDIS_DAEMON_GROUP`            | 运行用户组                            | `redis`                                 |
| `REDIS_DEFAULT_PORT_NUMBER`     | 默认端口（编译时定义）                | `6379`                                  |


### 禁用 Redis 命令

出于安全考虑，可通过 `REDIS_DISABLE_COMMANDS` 禁用指定命令（首次运行时设置）：  
```console
docker run --name redis -e REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG docker.xuanyuan.run/bitnami/redis:latest
```

或修改 `docker-compose.yml`：  
```yaml
services:
  redis:
  ...
    environment:
      - REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG
  ...
```

如需启用所有命令，注释或删除该环境变量即可。


### 传递额外启动参数

通过 `run.sh` 脚本传递参数至 `redis-server`：  
```console
docker run --name redis -e ALLOW_EMPTY_PASSWORD=yes docker.xuanyuan.run/bitnami/redis:latest /opt/bitnami/scripts/redis/run.sh --maxmemory 100mb
```

或修改 `docker-compose.yml`：  
```yaml
services:
  redis:
  ...
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    command: /opt/bitnami/scripts/redis/run.sh --maxmemory 100mb
  ...
```

参数详情参见 [Redis 文档] 。


### 设置服务密码

首次运行时通过 `REDIS_PASSWORD` 设置密码（或通过 `REDIS_PASSWORD_FILE` 指定密码文件）：  
```console
docker run --name redis -e REDIS_PASSWORD=password123 docker.xuanyuan.run/bitnami/redis:latest
```

或修改 `docker-compose.yml`：  
```yaml
services:
  redis:
  ...
    environment:
      - REDIS_PASSWORD=password123
  ...
```

**注意**：密码不支持包含 `@` 符号。  
**警告**：Redis 默认允许远程访问，生产环境必须设置密码。仅开发环境可通过 `ALLOW_EMPTY_PASSWORD=yes` 允许空密码。


### 允许空密码

默认需设置密码，开发/测试场景可通过 `ALLOW_EMPTY_PASSWORD=yes` 允许空密码：  
```console
docker run --name redis -e ALLOW_EMPTY_PASSWORD=yes docker.xuanyuan.run/bitnami/redis:latest
```


### 启用多线程

Redis 6.0+ 支持 [多线程模型] ，通过 `REDIS_IO_THREADS` 和 `REDIS_IO_THREADS_DO_READS` 配置：  
```console
docker run --name redis -e REDIS_IO_THREADS=4 -e REDIS_IO_THREADS_DO_READS=yes docker.xuanyuan.run/bitnami/redis:latest
```


### 禁用 AOF 持久化

通过 `REDIS_AOF_ENABLED=no` 禁用 AOF：  
```console
docker run --name redis -e REDIS_AOF_ENABLED=no docker.xuanyuan.run/bitnami/redis:latest
```


### 启用访问控制列表（ACL）

Redis 6.0+ 支持 [ACL] ，生产环境建议通过 `REDIS_ACLFILE` 指定 ACL 文件：  
```console
docker run --name redis -e REDIS_ACLFILE=/opt/bitnami/redis/mounted-etc/users.acl -v /本地路径/users.acl:/opt/bitnami/redis/mounted-etc/users.acl docker.xuanyuan.run/bitnami/redis:latest
```

或修改 `docker-compose.yml`：  
```yaml
services:
  redis:
  ...
    environment:
      - REDIS_ACLFILE=/opt/bitnami/redis/mounted-etc/users.acl
    volumes:
      - /本地路径/users.acl:/opt/bitnami/redis/mounted-etc/users.acl
  ...
```


### 独立实例端口配置

默认独立模式端口为 6379，通过 `REDIS_PORT_NUMBER` 修改：  
```console
docker run --name redis -e REDIS_PORT_NUMBER=7000 -p 7000:7000 docker.xuanyuan.run/bitnami/redis:latest
```

或修改 `docker-compose.yml` 中的端口映射。
