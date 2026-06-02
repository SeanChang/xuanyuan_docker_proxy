---
image: library/couchdb
description: "CouchDB是采用JSON文档格式、提供HTTP API并支持JavaScript/声明式索引的数据库。"
source: https://xuanyuan.cloud/zh/r/library/couchdb
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[library/couchdb](https://xuanyuan.cloud/zh/r/library/couchdb)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Apache CouchDB Docker 镜像文档

## 镜像概述和主要用途

Apache CouchDB 是一个使用 JSON 作为文档格式、HTTP API 作为交互接口、JavaScript/声明式索引的数据库。它通过定义 Couch 复制协议，支持数据在全球分布式服务器集群、移动设备和 Web 浏览器等各种计算环境中无缝流动。CouchDB 原生支持 JSON 文档存储，兼容二进制数据，提供离线优先的用户体验，同时保持高性能和高可靠性。


## 核心功能和特性

- **JSON 文档存储**：原生支持 JSON 格式文档，满足现代应用的数据存储需求。
- **HTTP API 接口**：通过标准 HTTP 协议进行数据交互，简化应用集成。
- **Couch 复制协议**：实现数据在不同环境（服务器集群、移动设备、浏览器）间的无缝同步，支持离线优先应用场景。
- **灵活的查询能力**：内置开发者友好的查询语言，可选 MapReduce 支持高效、全面的数据检索。
- **多架构支持**：兼容 `amd64`、`arm64v8`、`s390x` 等多种硬件架构。
- **集群部署**：支持构建分布式集群，实现高可用和横向扩展。


## 使用场景和适用范围

- **分布式系统**：适用于需要跨地域、多节点数据同步的全球分布式服务器集群。
- **移动应用**：配合 PouchDB 等兼容客户端，实现移动设备与服务器的数据同步，支持离线操作。
- **离线优先应用**：满足用户在无网络环境下的数据访问和修改需求，网络恢复后自动同步。
- **Web 应用**：作为后端数据库，提供 JSON 数据存储和 HTTP 接口，简化前后端交互。
- **数据复制与备份**：通过复制协议实现数据的多副本存储，提高数据可靠性。


## 支持的标签和架构

### 镜像标签

| 标签                          | Dockerfile 链接                                                                 |
|-------------------------------|--------------------------------------------------------------------------------|
| `latest`, `3.5.0`, `3.5`, `3` | [3.5.0/Dockerfile](https://github.com/apache/couchdb-docker/blob/2660034027fec97097f88afcc6f8a4416c364b24/3.5.0/Dockerfile) |
| `3.5.0-nouveau`, `3.5-nouveau`, `3-nouveau` | [3.5.0-nouveau/Dockerfile](https://github.com/apache/couchdb-docker/blob/2660034027fec97097f88afcc6f8a4416c364b24/3.5.0-nouveau/Dockerfile) |
| `3.4.3`, `3.4`                | [3.4.3/Dockerfile](https://github.com/apache/couchdb-docker/blob/2660034027fec97097f88afcc6f8a4416c364b24/3.4.3/Dockerfile) |
| `3.4.3-nouveau`, `3.4-nouveau` | [3.4.3-nouveau/Dockerfile](https://github.com/apache/couchdb-docker/blob/2660034027fec97097f88afcc6f8a4416c364b24/3.4.3-nouveau/Dockerfile) |

### 支持的架构

- `amd64`：[amd64/couchdb](https://hub.docker.com/r/amd64/couchdb/)
- `arm64v8`：[arm64v8/couchdb](https://hub.docker.com/r/arm64v8/couchdb/)
- `s390x`：[s390x/couchdb](https://hub.docker.com/r/s390x/couchdb/)


## 快速使用指南

### 启动基本实例

```console
$ docker run -d --name my-couchdb couchdb:tag
```

其中 `my-couchdb` 为容器名称，`tag` 为指定的镜像标签（如 `latest`、`3.5.0`）。


### 连接其他容器应用

通过容器链接使其他应用访问 CouchDB：

```console
$ docker run --name my-app --link my-couchdb:couchdb -d app-that-uses-couchdb
```

应用可通过 `couchdb:5984` 访问数据库服务。


### 暴露端口到外部

将容器内 CouchDB 端口（默认 5984）映射到主机：

```console
$ docker run -p 5984:5984 -d couchdb:tag
```

> **警告**：暴露端口前需确保已创建管理员用户并正确配置数据库权限，避免未授权访问。


### Docker Compose 示例

创建 `docker-compose.yml` 文件：

```yaml
version: '3'
services:
  couchdb:
    image: couchdb:3.5.0
    container_name: couchdb
    ports:
      - "5984:5984"
    environment:
      - COUCHDB_USER=admin
      - COUCHDB_PASSWORD=securepassword
    volumes:
      - couchdb_data:/opt/couchdb/data
      - couchdb_config:/opt/couchdb/etc/local.d
    restart: always

volumes:
  couchdb_data:
  couchdb_config:
```

启动服务：

```console
$ docker-compose up -d
```


## 详细配置说明

### 环境变量

| 环境变量          | 描述                                                                 |
|-------------------|----------------------------------------------------------------------|
| `COUCHDB_USER`    | 创建管理员用户名，与 `COUCHDB_PASSWORD` 配合使用，自动写入配置文件。  |
| `COUCHDB_PASSWORD`| 管理员密码，与 `COUCHDB_USER` 配合使用。                              |
| `COUCHDB_SECRET`  | 设置集群共享密钥，用于节点间身份验证。                                |
| `NODENAME`        | 设置节点名称（格式为 `couchdb@${NODENAME}`），用于集群部署。          |
| `ERL_FLAGS`       | Erlang 运行时参数，如 `-setcookie "cookie_value"` 设置节点间通信 cookie。 |


### 配置文件

CouchDB 配置通过 `.ini` 文件管理，推荐将自定义配置文件挂载到容器内 `/opt/couchdb/etc/local.d/` 目录（动态配置优先加载）。

#### 方法 1：绑定挂载主机目录

```console
$ docker run -v /host/path/to/config:/opt/couchdb/etc/local.d -d couchdb:tag
```

#### 方法 2：自定义 Dockerfile

```dockerfile
FROM couchdb:3.5.0
COPY custom.ini /opt/couchdb/etc/local.d/
```

构建并运行：

```console
$ docker build -t my-couchdb .
$ docker run -d my-couchdb
```


### 集群部署

#### 单节点集群初始化

通过环境变量创建管理员并启动：

```console
$ docker run -e COUCHDB_USER=admin -e COUCHDB_PASSWORD=password -d couchdb:tag
```

#### 多节点集群配置

1. 启动多个节点，指定 `NODENAME` 和 Erlang cookie：

```console
# 节点 1
$ docker run -d --name couchdb1 -e NODENAME=couchdb1 -e ERL_FLAGS="-setcookie mycookie" couchdb:tag

# 节点 2
$ docker run -d --name couchdb2 -e NODENAME=couchdb2 -e ERL_FLAGS="-setcookie mycookie" couchdb:tag
```

2. 参考 [官方集群文档](http://docs.couchdb.org/en/stable/setup/cluster.html) 完成集群配置（通过 Web 向导或 API）。

#### Kubernetes 部署

可使用 [Helm Chart](https://github.com/helm/charts/tree/master/incubator/couchdb) 快速部署到 Kubernetes 集群。


## 容器管理

### 访问容器 Shell

```console
$ docker exec -it my-couchdb bash
```

### 访问 Erlang 运行时

```console
$ docker exec -it my-couchdb /opt/couchdb/bin/remsh
```

### 查看日志

```console
$ docker logs my-couchdb
```


## 注意事项

### 数据持久化

CouchDB 数据默认存储在容器内 `/opt/couchdb/data`，需通过卷挂载实现持久化：

```console
$ docker run -v /host/data/path:/opt/couchdb/data -d couchdb:tag
```


### 系统数据库创建

CouchDB 不会自动创建系统数据库（`_global_changes`、`_replicator`、`_users`），需手动创建或通过集群配置工具自动生成：

- 使用 [集群设置向导](http://docs.couchdb.org/en/stable/setup/cluster.html#the-cluster-setup-wizard) 或 [集群 API](http://docs.couchdb.org/en/stable/setup/cluster.html#the-cluster-setup-api) 完成集群配置后自动创建。
- 单节点环境可手动创建：

```bash
# 通过 HTTP API 创建 _users 数据库
$ curl -X PUT http://admin:password@localhost:5984/_users
```


### 管理员开放模式

默认启动时，CouchDB 处于**管理员开放模式**（所有用户拥有管理员权限），需立即创建管理员用户：

```console
$ docker run -e COUCHDB_USER=admin -e COUCHDB_PASSWORD=securepassword -d couchdb:tag
```

> **集群环境注意**：多节点集群需确保所有节点使用相同的管理员密码哈希值，可通过挂载配置目录让 CouchDB 自动哈希密码后，复制哈希值到其他节点配置文件中。


### 日志配置

默认日志输出到 `stdout`，可通过配置文件启用文件日志：

1. 创建配置文件 `log.ini`：

```ini
[log]
writer = file
file = /opt/couchdb/log/couch.log
level = info
```

2. 挂载配置并日志目录：

```console
$ docker run -v /host/config:/opt/couchdb/etc/local.d -v /host/log:/opt/couchdb/log -d couchdb:tag
```


## 许可证

Apache CouchDB 基于 [Apache 许可证](https://github.com/apache/couchdb/blob/master/LICENSE) 开源。

镜像中包含的其他软件（如基础系统组件、依赖库等）可能遵循不同许可证，用户需自行确保使用符合相关许可要求。镜像元数据及许可证详情可参考 [repo-info 仓库](https://github.com/docker-library/repo-info/tree/master/repos/couchdb)。


## 参考链接

- [官方 CouchDB 文档](http://docs.couchdb.org/)
- [CouchDB Docker 仓库](https://github.com/apache/couchdb-docker)
- [问题反馈](https://github.com/apache/couchdb-docker/issues)
