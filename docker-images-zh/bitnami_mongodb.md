---
image: bitnami/mongodb
description: "Bitnami MongoDB安全镜像是一款针对MongoDB数据库精心打造的预配置解决方案，集成全面安全加固措施、性能优化组件及跨平台兼容性，旨在帮助用户快速部署稳定可靠的MongoDB环境，其遵循企业级安全标准，包含自动更新机制、访问控制策略及数据加密功能，有效保障数据完整性与系统安全性，同时简化安装配置流程，支持一键部署至各类云平台或本地服务器，适用于从小型项目到大型企业级应用的多样化场景，为开发者和运维人员提供高效、安全、便捷的数据库运行环境。"
source: https://xuanyuan.cloud/zh/r/bitnami/mongodb
canonical: https://xuanyuan.cloud/zh/r/bitnami/mongodb
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/mongodb" title="bitnami/mongodb Docker 镜像中文简介、标签列表与拉取命令">bitnami/mongodb — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/mongodb" title="bitnami/mongodb Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/mongodb</a>

# Bitnami 封装的 MongoDB®


## 什么是 MongoDB®？

MongoDB® 是一款开源的非关系型（NoSQL）数据库，采用类 JSON 文档格式存储数据，使用简便。它具备自动化扩展能力和高性能，非常适合开发云原生应用。

[MongoDB® 概览]([])  
**免责声明**：本产品中提及的商标分属各自公司所有。我们不提供任何商业许可，本列表基于开源许可。MongoDB(R) 由 MongoDB 公司独立运营和维护，与 Bitnami 是完全独立的项目。


## 快速启动

```console
docker run --name mongodb bitnami/mongodb:latest
```

这是由 Bitnami 构建和维护的强化版最小漏洞（CVE）镜像。Bitnami 安全镜像（BSI）基于云优化、安全强化的企业级操作系统 [Photon Linux]([])。选择 BSI 镜像的理由包括：  
- 热门开源软件的强化安全镜像，漏洞数量接近零  
- 通过 VEX 声明、KEV 和 EPSS 评分进行漏洞分类与优先级排序  
- 聚焦合规性，支持 FIPS、STIG 和离线部署选项，包含安全物料清单（SBOM）  
- 通过 in-toto 提供软件供应链来源证明  
- 原生支持主流 Helm 图表  

每个镜像均附带安全元数据，可在 [公开目录]([]) 中查看（部分数据需 [BSI 商业订阅]([])）。如需基于 Debian Linux 的旧版镜像，请查看 Bitnami Legacy 仓库。


## 如何在 Kubernetes 中部署 MongoDB®？

通过 Helm Charts 部署 Bitnami 应用是在 Kubernetes 上快速上手的最佳方式。部署详情可参考 [Bitnami MongoDB® Chart GitHub 仓库]([])。


## 为什么使用非 root 容器？

非 root 容器能增加一层安全防护，建议在生产环境中使用。但由于运行时使用非 root 用户，可能无法执行特权操作。更多信息见 [相关文档]([])。


## 支持的标签及对应 Dockerfile 链接

Bitnami 标签策略（滚动标签与固定标签的区别）详见 [文档]([])。各标签对应关系可查看分支文件夹中的 `tags-info.yaml` 文件（如 `bitnami/APP/VERSION/OPERATING-SYSTEM/tags-info.yaml`）。可通过 [bitnami/containers GitHub 仓库]([]) 订阅项目更新。


## 获取镜像

推荐通过 Docker Hub 拉取预构建镜像：

```console
docker pull bitnami/mongodb:latest
```

如需指定版本，可拉取带版本标签的镜像，版本列表见 [Docker Hub]([])：

```console
docker pull bitnami/mongodb:[TAG]
```

也可手动构建镜像：

```console
git clone [] bitnami/APP/VERSION/OPERATING-SYSTEM  # 替换 APP、VERSION、操作系统为实际值
docker build -t bitnami/APP:latest .
```


## 数据持久化

若删除容器，数据会丢失。需挂载卷以持久化数据，挂载目录为 `/bitnami/mongodb`（首次运行时会初始化空目录）：

```console
docker run \
    -v /本地路径/mongodb-persistence:/bitnami/mongodb \
    bitnami/mongodb:latest
```

或修改仓库中的 [`docker-compose.yml`]([])：

```diff
 ...
 services:
   mongodb:
     ...
     volumes:
-      - mongodb_data:/bitnami/mongodb
+      - /本地路径/mongodb-persistence:/bitnami/mongodb
   ...
```

> **注意**：由于是非 root 容器，挂载的文件和目录需对 UID `1001` 有正确权限。


## 容器间通信

利用 [Docker 容器网络]([])，同一网络中的容器可通过容器名互访。


### 命令行方式

#### 步骤 1：创建网络

```console
docker network create app-tier --driver bridge
```

#### 步骤 2：启动 MongoDB 服务端

```console
docker run -d --name mongodb-server \
    --network app-tier \
    bitnami/mongodb:latest
```

#### 步骤 3：启动客户端并连接

```console
docker run -it --rm \
    --network app-tier \
    bitnami/mongodb:latest mongo --host mongodb-server
```


### Docker Compose 方式

Compose 会自动创建网络，以下示例假设应用容器（`myapp`）需连接 MongoDB：

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  mongodb:
    image: bitnami/mongodb:latest
    networks:
      - app-tier
  myapp:
    image: 你的应用镜像  # 替换为实际应用镜像
    networks:
      - app-tier
```

> **重要**：  
> 1. 替换 `你的应用镜像` 为实际镜像名；  
> 2. 应用容器中通过 hostname `mongodb` 连接服务端。

启动容器：

```console
docker-compose up -d
```


## 配置


### 环境变量

#### 可自定义环境变量

| 名称                                  | 描述                                                                 | 默认值                               |
|---------------------------------------|----------------------------------------------------------------------|-------------------------------------|
| `MONGODB_MOUNTED_CONF_DIR`            | 自定义配置文件目录（覆盖默认配置）                                   | `${MONGODB_VOLUME_DIR}/conf`        |
| `MONGODB_INIT_RETRY_ATTEMPTS`         | 服务初始化状态检查最大重试次数                                       | `7`                                 |
| `MONGODB_INIT_RETRY_DELAY`            | 重试间隔（秒）                                                       | `5`                                 |
| `MONGODB_PORT_NUMBER`                 | MongoDB 端口                                                         | `$MONGODB_DEFAULT_PORT_NUMBER`      |
| `MONGODB_EXTRA_FLAGS`                 | mongod 启动额外参数                                                  | `nil`                               |
| `MONGODB_ROOT_USER`                   | root 用户名                                                          | `root`                              |
| `MONGODB_ROOT_PASSWORD`               | root 密码                                                           | `nil`                               |
| `MONGODB_USERNAME`                    | 初始化时创建的普通用户名                                             | `nil`                               |
| `MONGODB_PASSWORD`                    | 普通用户密码                                                         | `nil`                               |
| `MONGODB_DATABASE`                    | 初始化时创建的数据库名                                               | `nil`                               |
| `ALLOW_EMPTY_PASSWORD`                | 是否允许空密码访问                                                   | `no`                                |
| `MONGODB_REPLICA_SET_MODE`            | 副本集模式（primary/secondary/arbiter）                              | `nil`                               |


#### 只读环境变量（运行时不可修改）

| 名称                                  | 描述                                                                 | 值                                    |
|---------------------------------------|----------------------------------------------------------------------|--------------------------------------|
| `MONGODB_VOLUME_DIR`                  | 持久化基础目录                                                       | `$BITNAMI_VOLUME_DIR/mongodb`        |
| `MONGODB_DATA_DIR`                    | 数据存储目录                                                         | `${MONGODB_VOLUME_DIR}/data`         |
| `MONGODB_CONF_FILE`                   | 配置文件路径                                                         | `$MONGODB_CONF_DIR/mongodb.conf`     |
| `MONGODB_DEFAULT_PORT_NUMBER`         | 默认端口                                                             | `27017`                              |


### 初始化实例

首次运行时，容器会执行 `/docker-entrypoint-initdb.d` 目录下扩展名为 `.sh` 和 `.js` 的文件。可通过挂载卷添加自定义脚本。


### 传递额外启动参数

通过环境变量传递 `mongod` 启动参数：

```console
docker run --name mongodb -e ALLOW_EMPTY_PASSWORD=yes -e MONGODB_EXTRA_FLAGS='--wiredTigerCacheSizeGB=2' bitnami/mongodb:latest
```

或在 `docker-compose.yml` 中添加：

```yaml
services:
  mongodb:
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - MONGODB_EXTRA_FLAGS=--wiredTigerCacheSizeGB=2
```


### 配置日志 verbosity 级别

- `MONGODB_DISABLE_SYSTEM_LOG`：是否禁用系统日志（默认 `false`）  
- `MONGODB_SYSTEM_LOG_VERBOSITY`：日志级别（0-5，默认 `0`，详见 [MongoDB 文档]([])）

示例：

```console
docker run --name mongodb -e ALLOW_EMPTY_PASSWORD=yes -e MONGODB_SYSTEM_LOG_VERBOSITY=3 bitnami/mongodb:latest
```


### 使用 numactl

设置 `MONGODB_ENABLE_NUMACTL=true` 可通过 numactl 启动命令，详见 [MongoDB 文档]([])。


### 启用 IPv6

设置 `MONGODB_ENABLE_IPV6=yes` 启用 IPv6（默认 `false`）：

```console
docker run --name mongodb -e ALLOW_EMPTY_PASSWORD=yes -e MONGODB_ENABLE_IPV6=yes bitnami/mongodb:latest
```


### 启用 directoryPerDB

设置 `MONGODB_ENABLE_DIRECTORY_PER_DB=yes` 为每个数据库使用独立目录（默认 `true`，详见 [文档]([])）：

```console
docker run --name mongodb -e ALLOW_EMPTY_PASSWORD=yes -e MONGODB_ENABLE_DIRECTORY_PER_DB=yes bitnami/mongodb:latest
```
