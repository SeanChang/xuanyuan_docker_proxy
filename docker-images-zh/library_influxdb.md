<!-- xuanyuan-docker-images-zh
image: library/influxdb
source: https://xuanyuan.cloud/zh/r/library/influxdb
canonical: https://xuanyuan.cloud/zh/r/library/influxdb
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [library/influxdb — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/library/influxdb "library/influxdb Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/library/influxdb

# InfluxDB Docker 镜像使用指南


## 什么是 InfluxDB？

![logo]([])

InfluxDB 是一款时序数据库平台，专为收集、存储和处理大量事件及时序数据设计。适用于监控（传感器、服务器、应用、网络）、金融分析、行为追踪等场景。


## 快速参考

### 维护者  
[InfluxData]([])

### 获取帮助  
- **InfluxDB 3 Core/Enterprise**：优先通过 [InfluxDB  服务器]()  
- **InfluxDB v2/v1**：优先通过 [InfluxDB 社区 Slack]([])  

### 问题反馈  
[GitHub Issues]([])

### 支持架构  
`amd64`（[查看]([])）、`arm64v8`（[查看]([])）

### 镜像详情  
包含元数据、传输大小等信息，见 [repo-info 仓库的 influxdb 目录]([])（[历史记录]([])）

### 镜像更新  
- [official-images 仓库的 library/influxdb 标签]([])  
- [official-images 仓库的 library/influxdb 文件]([])（[历史记录]([])）

### 说明文档来源  
[docs 仓库的 influxdb 目录]([])（[历史记录]([])）


## 支持的标签及对应 Dockerfile 链接  

### 1.12 版本  
- `1.12`、`1.12.2`：[Dockerfile]([])  
- `1.12-alpine`、`1.12.2-alpine`：[Dockerfile]([])  
- `1.12-data`、`1.12.2-data`：[Dockerfile]([])  
- `1.12-data-alpine`、`1.12.2-data-alpine`：[Dockerfile]([])  
- `1.12-meta`、`1.12.2-meta`：[Dockerfile]([])  
- `1.12-meta-alpine`、`1.12.2-meta-alpine`：[Dockerfile]([])  

### 1.11 版本  
- `1.11`、`1.11.8`：[Dockerfile]([])  
- `1.11-alpine`、`1.11.8-alpine`：[Dockerfile]([])  
- `1.11-data`、`1.11.9-data`：[Dockerfile]([])  
- `1.11-data-alpine`、`1.11.9-data-alpine`：[Dockerfile]([])  
- `1.11-meta`、`1.11.9-meta`：[Dockerfile]([])  
- `1.11-meta-alpine`、`1.11.9-meta-alpine`：[Dockerfile]([])  

### 2 版本  
- `2`、`2.7`、`2.7.12`、`latest`：[Dockerfile]([])  
- `2-alpine`、`2.7-alpine`、`2.7.12-alpine`、`alpine`：[Dockerfile]([])  

### 3 版本  
- `3-core`、`3.5-core`、`3.5.0-core`、`core`：[Dockerfile]([])  
- `3-enterprise`、`3.5-enterprise`、`3.5.0-enterprise`、`enterprise`：[Dockerfile]([])  


## 各版本使用指南  

### InfluxDB 3 Core（最新开源版）  
#### 核心特性  
- 基于对象存储，集成 InfluxDB 3 存储引擎、Apache Arrow 和 DataFusion SQL  
- 查询延迟低于 10ms，支持无限基数  
- 兼容 SQL 和 InfluxQL 查询语言  
- 内置 Python 处理引擎  
- 支持 InfluxDB v1/v2 兼容 API  

#### 启动方式  
##### 1. 使用 docker compose  
创建 `compose.yaml` 文件：  
```yaml
# compose.yaml
name: influxdb3
services:
  influxdb3-core:
    container_name: influxdb3-core
    image: influxdb:3-core
    ports:
      - 8181:8181  # HTTP API 端口
    command:
      - influxdb3
      - serve
      - --node-id=node0  # 节点 ID
      - --object-store=file  # 使用文件存储
      - --data-dir=/var/lib/influxdb3/data  # 数据存储路径
      - --plugin-dir=/var/lib/influxdb3/plugins  # 插件目录
    volumes:
      - type: bind
        source: ~/.influxdb3/core/data  # 本地数据目录
        target: /var/lib/influxdb3/data
      - type: bind
        source: ~/.influxdb3/core/plugins  # 本地插件目录
        target: /var/lib/influxdb3/plugins
```  
执行 `docker compose up -d` 启动。

##### 2. 使用 docker run  
```bash
docker run --rm -p 8181:8181 \
  -v $PWD/data:/var/lib/influxdb3/data \  # 挂载数据目录
  -v $PWD/plugins:/var/lib/influxdb3/plugins \  # 挂载插件目录
  influxdb:3-core influxdb3 serve \
    --node-id=my-node-0 \  # 自定义节点 ID
    --object-store=file \
    --data-dir=/var/lib/influxdb3/data \
    --plugin-dir=/var/lib/influxdb3/plugins
```  

#### 基本使用  
启动后，参考 [快速入门指南]([]) 创建授权令牌，通过内置 `influxdb3` CLI 或 HTTP API 写入、查询数据。

#### 推荐工具  
- **InfluxDB 3 Explorer UI**：可视化数据管理界面，[Docker Hub 地址]([])  
- **Telegraf**：从数百个数据源收集指标，[Docker Hub 地址]([])  
- **官方客户端库**：Python、Go、JavaScript 等语言支持，[查看文档]([])  

#### 自定义配置  
查看所有服务器参数：  
```bash
docker run --rm influxdb:3-core influxdb3 serve --help
```  


### InfluxDB v2（上一代开源版）  
#### 启动方式  
```bash
docker run -d -p 8086:8086 \  # HTTP API 端口
  -v $PWD/data:/var/lib/influxdb2 \  # 数据持久化目录
  -v $PWD/config:/etc/influxdb2 \  # 配置目录
  -e DOCKER_INFLUXDB_INIT_MODE=setup \  # 初始化模式
  -e DOCKER_INFLUXDB_INIT_USERNAME=my-user \  # 用户名
  -e DOCKER_INFLUXDB_INIT_PASSWORD=my-password \  # 密码
  -e DOCKER_INFLUXDB_INIT_ORG=my-org \  # 组织名
  -e DOCKER_INFLUXDB_INIT_BUCKET=my-bucket \  # 桶名
  influxdb:2
```  
启动后访问 [[]]([]) 打开 UI。  
详细说明见 [v2 Docker Compose 文档]([])。


### InfluxDB v1（初代版本）  
#### 启动方式  
```bash
docker run -d -p 8086:8086 \  # HTTP API 端口
  -v $PWD:/var/lib/influxdb \  # 数据持久化到当前目录
  influxdb:1.11
```  
详细说明见 [v1 Docker 文档]([])。


### 企业版说明  
- **InfluxDB 3 Enterprise**：需许可证，支持无限数据保留、集群和高可用，安装文档见 [官方指南]([])。  
- **InfluxDB v1 Enterprise**：需许可证，包含数据节点（`influxdb:1.11-data`）和元数据节点（`influxdb:1.11-meta`，端口 8091），安装文档见 [官方指南]([])。


## 版本兼容性  

### 迁移路径（从 v1/v2 到 3 Core）  
1. 双写新数据到旧版本和 3 Core；  
2. 查询历史数据并写入 3 Core（推荐使用 3 Enterprise 实现历史数据查询）。


## 镜像变体  

### `influxdb:<version>`  
默认镜像，适用于大多数场景，可作为临时容器或基础镜像。

### `influxdb:<version>-alpine`  
基于 Alpine Linux，镜像体积更小（约 5MB 基础镜像），适合对镜像大小敏感的场景。注意：使用 musl libc 而非 glibc，部分依赖 glibc 的软件可能存在兼容性问题。


## 许可证  

- 软件许可信息：[查看源码仓库 LICENSE]([])  
- 镜像包含的其他软件许可：[repo-info 仓库 influxdb 目录]([])  
- 用户需自行确保使用此镜像符合所有包含软件的许可要求。
