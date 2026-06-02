---
image: influxdata/influxdb3-ui
description: "用于InfluxDB时序数据库的数据探索与可视化用户界面，支持数据查询、分析及管理操作，提供直观的时序数据交互体验。"
source: https://xuanyuan.cloud/zh/r/influxdata/influxdb3-ui
canonical: https://xuanyuan.cloud/zh/r/influxdata/influxdb3-ui
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/influxdata/influxdb3-ui" title="influxdata/influxdb3-ui Docker 镜像中文简介、标签列表与拉取命令">influxdata/influxdb3-ui — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/influxdata/influxdb3-ui" title="influxdata/influxdb3-ui Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/influxdata/influxdb3-ui</a>

# InfluxDB 3 Explorer 镜像文档


## 1. 镜像概述与主要用途

InfluxDB 3 Explorer 是一款独立 Web 应用程序，专为可视化、查询和管理存储在 InfluxDB 3 中的数据而设计。该工具提供直观的用户界面，便于用户与时序数据进行交互，支持对 InfluxDB 3 实例中的数据进行高效操作与分析。


## 2. 核心功能与特性

- **数据可视化**：提供直观界面展示时序数据趋势与模式  
- **数据查询**：支持对 InfluxDB 3 数据进行灵活查询与筛选  
- **实例管理**：在管理模式下可对 InfluxDB 3 实例进行配置与维护  
- **多模式运行**：支持查询模式（只读访问）和管理模式（完整功能）  
- **配置持久化**：支持本地目录挂载，确保应用数据持久化  
- **预配置连接**：可通过配置文件预设 InfluxDB 连接参数，简化初始设置  
- **HTTPS 支持**：支持挂载 SSL 证书与密钥，启用安全访问  


## 3. 使用场景与适用范围

- **时序数据可视化分析**：适用于需要实时查看、分析 InfluxDB 3 中时序数据的场景  
- **InfluxDB 3 实例管理**：在管理模式下，可对 InfluxDB 3 数据库进行配置、监控与维护  
- **团队协作**：通过预配置连接参数，方便团队成员快速接入统一的 InfluxDB 3 实例  
- **生产环境部署**：支持持久化存储与 HTTPS，满足生产环境对数据安全与稳定性的要求  


## 4. 使用方法与配置说明

### 4.1 前提条件

使用 InfluxDB 3 Explorer 需搭配兼容的 InfluxDB 3 实例，如 InfluxDB 3 Core 或 InfluxDB 3 Enterprise。可参考 [官方 InfluxDB Docker 镜像](https://hub.docker.com/_/influxdb) 获取实例。


### 4.2 拉取镜像

通过 Docker CLI 拉取指定版本镜像：

```bash
docker pull influxdata/influxdb3-ui:1.0.0
```


### 4.3 启动 InfluxDB 3 Explorer

#### 4.3.1 查询模式（默认）

以只读模式启动，仅支持数据查询与可视化：

```bash
docker run --detach \
  --name influxdb3-explorer \
  --publish 8888:80 \
  influxdata/influxdb3-ui:1.0.0
```

- 容器端口 `80` 映射至主机端口 `8888`（Web UI 访问）  
- 访问地址：`http://localhost:8888`  


#### 4.3.2 管理模式

以完整功能模式启动，支持数据管理与实例配置：

```bash
docker run --detach \
  --name influxdb3-explorer \
  --publish 8888:80 \
  --publish 8889:8888 \
  influxdata/influxdb3-ui:1.0.0 \
  --mode=admin
```

- 端口映射：`80`（Web UI）→ 主机 `8888`，`8888`（API）→ 主机 `8889`  
- 访问地址：`http://localhost:8888`  

**说明**：未指定 `--mode` 时默认启用查询模式。


### 4.4 持久化数据存储

为避免容器重启导致应用数据丢失，需挂载本地目录持久化存储：

1. 创建本地存储目录（设置权限确保容器可读写）：  
   ```bash
   mkdir -m 700 ./db
   ```

2. 启动容器时挂载目录：  
   ```bash
   docker run --detach \
     --name influxdb3-explorer \
     --publish 8888:80 \
     --volume $(pwd)/db:/db:rw \
     influxdata/influxdb3-ui:1.0.0 \
     --mode=admin
   ```

- `./db`：本地存储目录，`/db`：容器内数据存储路径，`rw`：读写权限  


### 4.5 预配置 InfluxDB 连接

通过挂载配置文件预设 InfluxDB 连接参数，无需手动输入：

1. 创建配置目录与文件：  
   ```bash
   mkdir -m 755 ./config
   ```

2. 编辑 `./config/config.json`，填入连接信息：  
   ```json
   {
     "DEFAULT_INFLUX_SERVER": "http://host.docker.internal:8181",  // InfluxDB 服务地址
     "DEFAULT_INFLUX_DATABASE": "my_database",  // 默认数据库名
     "DEFAULT_API_TOKEN": "your-admin-token",   // 访问令牌
     "DEFAULT_SERVER_NAME": "my_server"         // 服务器显示名称
   }
   ```

3. 启动容器时挂载配置目录：  
   ```bash
   docker run --detach \
     --name influxdb3-explorer \
     --publish 8888:80 \
     --volume $(pwd)/config:/app-root/config:ro \  // 配置文件只读挂载
     --volume $(pwd)/db:/db:rw \
     influxdata/influxdb3-ui:1.0.0 \
     --mode=admin
   ```


### 4.6 启用 HTTPS

挂载 SSL 证书与密钥文件，启用 TLS/SSL 加密访问：

1. 创建 SSL 目录并放入证书文件：  
   ```bash
   mkdir -m 755 ./ssl
   # 将证书文件（server.crt 或 fullchain.pem）与密钥文件（server.key）放入 ./ssl 目录
   ```

2. 启动容器并挂载 SSL 目录：  
   ```bash
   docker run --detach \
     --name influxdb3-explorer \
     --publish 8888:443 \  // HTTPS 默认端口 443
     --volume $(pwd)/ssl:/etc/nginx/ssl:ro \
     influxdata/influxdb3-ui:1.0.0 \
     --mode=admin
   ```

- 容器会自动识别 `/etc/nginx/ssl` 目录下的证书文件并启用 HTTPS  
- 访问地址：`https://localhost:8888`  


### 4.7 自定义 SSL 证书路径

若证书文件路径非默认，可通过环境变量指定：

```bash
docker run --detach \
  --name influxdb3-explorer \
  --publish 8888:443 \
  --volume $(pwd)/ssl:/custom/ssl:ro \
  --env SSL_CERT_PATH=/custom/ssl/server.crt \  # 自定义证书路径
  --env SSL_KEY_PATH=/custom/ssl/server.key \   # 自定义密钥路径
  influxdata/influxdb3-ui:1.0.0 \
  --mode=admin
```


### 4.8 环境变量

通过环境变量可自定义容器配置，支持以下参数：

| 环境变量            | 描述                                  | 默认值                          |
|---------------------|---------------------------------------|---------------------------------|
| `DATABASE_URL`      | 容器内 SQLite 数据库路径              | `/db/sqlite.db`                 |
| `SESSION_SECRET_KEY`| 会话管理密钥（生产环境必须设置）      | 未设置（容器重启时自动生成新密钥） |
| `SSL_CERT_PATH`     | SSL 证书文件路径                      | `/etc/nginx/ssl/cert.pem`       |
| `SSL_KEY_PATH`      | SSL 私钥文件路径                      | `/etc/nginx/ssl/key.pem`        |

**生产环境注意事项**：必须显式设置 `SESSION_SECRET_KEY`，否则容器重启后会话密钥会重置，导致现有会话失效。


## 5. 参考链接

- [InfluxDB 3 Explorer 官方文档](https://docs.influxdata.com/influxdb3/explorer/install/)  
- [InfluxDB Docker 镜像](https://hub.docker.com/_/influxdb)
