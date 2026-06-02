---
image: library/clickhouse
description: "ClickHouse 是一款专注于实时数据应用与分析领域的开源数据库，它不仅是目前速度最快的数据库之一，在资源利用效率上也表现卓越，能够高效支持各类实时应用场景下的数据存储、查询与分析需求，凭借其快速响应能力和低资源消耗特性，为实时数据处理与分析提供稳定可靠的解决方案。"
source: https://xuanyuan.cloud/zh/r/library/clickhouse
canonical: https://xuanyuan.cloud/zh/r/library/clickhouse
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [library/clickhouse — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/library/clickhouse)

含镜像标签、拉取命令、部署文档与相关推荐。

[library/clickhouse Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/library/clickhouse)

# ClickHouse Docker 镜像使用指南


## 快速参考

### 维护者  
[ClickHouse Inc.]([])  

### 获取帮助  
[Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])  


## 支持的标签及对应 Dockerfile 链接  

- **最新稳定版**：`latest`、`jammy`、`25.9`、`25.9-jammy`、`25.9.3`、`25.9.3-jammy`、`25.9.3.48`、`25.9.3.48-jammy`  
  [Dockerfile 链接]([])  

- **LTS 版**：`lts`、`lts-jammy`、`25.8`、`25.8-jammy`、`25.8.10`、`25.8.10-jammy`、`25.8.10.7`、`25.8.10.7-jammy`  
  [Dockerfile 链接]([])  

- **其他版本**：  
  - `25.7` 系列：[Dockerfile 链接]([])  
  - `25.3` 系列：[Dockerfile 链接]([])  


## 快速参考（续）  

### 问题反馈地址  
[[]]([])  

### 支持的架构  
- `amd64`：[镜像链接]([])  
- `arm64v8`：[镜像链接]([])  
  （架构详情：[点击查看]([])）  

### 镜像详情  
[repo-info 仓库的 `repos/clickhouse/` 目录]([])（含镜像元数据、传输大小等，[历史记录]([])）  

### 镜像更新  
- [official-images 仓库的 `library/clickhouse` 标签]([])  
- [official-images 仓库的 `library/clickhouse` 文件]([])（[历史记录]([])）  

### 本文档来源  
[docs 仓库的 `clickhouse/` 目录]([])（[历史记录]([])）  


## ClickHouse 服务器 Docker 镜像  


### 什么是 ClickHouse？  

![logo]([])  

ClickHouse 是开源的列式数据库管理系统（DBMS），专为联机分析处理（OLAP）设计，支持通过 SQL 实时生成分析报告。其处理速度比传统数据库快 100-1000 倍，单服务器每秒可处理数亿至数十亿行数据、数十 GB 数据，具有高可靠性、易用性和容错能力，用户群体遍布全球。  

详细文档见：[[]]([])  


### 版本说明  

- `latest`：指向最新稳定分支的最新版本。  
- 分支标签（如 `22.2`）：指向对应分支的最新版本。  
- 完整版本标签（如 `22.2.3`、`22.2.3.5`）：指向具体版本。  


### 兼容性  

- **amd64 架构**：需支持 [SSE3 指令集]()（2005 年后的 x86 CPU 基本支持）。  
- **arm64v8 架构**：需支持 [ARMv8.2-A 架构]() 及 Load-Acquire RCpc 寄存器（该寄存器在 ARMv8.2-A 中为可选，ARMv8.3-A 中为必选）。支持 Graviton >=2、Azure/GCP 实例；不支持 Raspberry Pi 4（ARMv8.0-A）、Jetson AGX Xavier/Orin（ARMv8.2-A）。  
- **基础镜像要求**：24.11 及以上版本基于 `ubuntu:22.04`，需 Docker 版本 >=20.10.10（含 [补丁]([])）。若版本不足，可使用 `docker run --security-opt seccomp=unconfined` 作为临时方案（注意安全风险）。  


### 如何使用镜像  


#### 启动服务器实例  

```bash
docker run -d --name some-clickhouse-server --ulimit nofile=262144:262144 clickhouse
```  

- 默认仅 Docker 网络内可访问（见下文“网络配置”）。  
- 默认以 `default` 用户启动，无密码。  


#### 通过原生客户端连接  

```bash
# 方式一：通过容器网络连接
docker run -it --rm --network=container:some-clickhouse-server --entrypoint clickhouse-client clickhouse

# 方式二：直接在容器内执行客户端
docker exec -it some-clickhouse-server clickhouse-client
```  

客户端详情：[ClickHouse 客户端文档]([])  


#### 通过 curl 连接 HTTP 接口  

```bash
echo "SELECT 'Hello, ClickHouse!'" | docker run -i --rm --network=container:some-clickhouse-server buildpack-deps:curl curl '[]' -s --data-binary @-
```  

HTTP 接口详情：[ClickHouse HTTP 接口文档]([])  


#### 停止/删除容器  

```bash
docker stop some-clickhouse-server  # 停止
docker rm some-clickhouse-server    # 删除
```  


#### 网络配置  

> ⚠️ 注意：默认 `default` 用户无密码时，不允许网络访问（见下文“用户管理”）。  

如需外部访问，可通过以下方式暴露端口：  

**方式一：端口映射**  
```bash
docker run -d -p 18123:8123 -p 19000:9000 -e CLICKHOUSE_PASSWORD=changeme --name some-clickhouse-server --ulimit nofile=262144:262144 clickhouse
# 测试连接
echo 'SELECT version()' | curl '[]' --data-binary @-
```  

**方式二：使用主机网络（性能更佳）**  
```bash
docker run -d --network=host --name some-clickhouse-server --ulimit nofile=262144:262144 clickhouse
# 测试连接
echo 'SELECT version()' | curl '[]' --data-binary @-
```  


#### 数据持久化（挂载目录）  

建议挂载以下目录以确保数据/配置持久化：  
- `/var/lib/clickhouse/`：数据存储目录  
- `/var/log/clickhouse-server/`：日志目录  
- `/etc/clickhouse-server/config.d/`：配置文件目录（可选）  

```bash
docker run -d \
  -v "$PWD/ch_data:/var/lib/clickhouse/" \
  -v "$PWD/ch_logs:/var/log/clickhouse-server/" \
  --name some-clickhouse-server --ulimit nofile=262144:262144 clickhouse
```  


#### Linux 能力（Capabilities）  

部分高级功能需启用特定 Linux 能力（可选）：  

```bash
docker run -d \
  --cap-add=SYS_NICE --cap-add=NET_ADMIN --cap-add=IPC_LOCK \
  --name some-clickhouse-server --ulimit nofile=262144:262144 clickhouse
```  

详情：[配置 Docker 能力文档]([])  


### 配置  


#### 自定义配置启动  

```bash
docker run -d --name some-clickhouse-server --ulimit nofile=262144:262144 -v /本地配置路径/config.xml:/etc/clickhouse-server/config.xml clickhouse
```  

配置文件详情：[ClickHouse 配置文档]([])  


#### 以自定义用户启动  

```bash
# 确保本地目录存在且属当前用户
docker run --rm --user "${UID}:${GID}" --name some-clickhouse-server \
  -v "$PWD/logs/clickhouse:/var/log/clickhouse-server" \
  -v "$PWD/data/clickhouse:/var/lib/clickhouse" \
  --ulimit nofile=262144:262144 clickhouse
```  

挂载本地目录时，需通过 `--user` 指定用户，确保文件权限正确。  


#### 以 root 用户启动（适用于用户命名空间）  

```bash
docker run --rm -e CLICKHOUSE_RUN_AS_ROOT=1 --name clickhouse-server-userns \
  -v "$PWD/logs/clickhouse:/var/log/clickhouse-server" \
  -v "$PWD/data/clickhouse:/var/lib/clickhouse" \
  clickhouse
```  


#### 初始化数据库和用户  

可通过环境变量在启动时创建默认数据库和用户：  

```bash
docker run --rm -e CLICKHOUSE_DB=my_database -e CLICKHOUSE_USER=username -e CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT=1 -e CLICKHOUSE_PASSWORD=password -p 9000:9000/tcp clickhouse
```  

- `CLICKHOUSE_DB`：创建默认数据库  
- `CLICKHOUSE_USER`/`CLICKHOUSE_PASSWORD`：创建用户及密码  
- `CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT`：启用访问控制  


#### 默认用户（default）管理  

默认 `default` 用户无密码时，**禁止网络访问**。如需开放（仅测试用，不安全）：  

```bash
docker run --rm -e CLICKHOUSE_SKIP_USER_SETUP=1 -p 9000:9000/tcp clickhouse
```  


### 扩展镜像  

如需自定义初始化（如创建表、用户），可在 `/docker-entrypoint-initdb.d` 目录下添加 `*.sql`、`*.sql.gz` 或 `*.sh` 脚本。容器启动时会自动执行这些脚本。  

**示例**：创建数据库和表（保存为 `/docker-entrypoint-initdb.d/init-db.sh`）  

```bash
#!/bin/bash
set -e

clickhouse client -n <<-EOSQL
    CREATE DATABASE docker;
    CREATE TABLE docker.docker (x Int32) ENGINE = Log;
EOSQL
```  

可通过 `CLICKHOUSE_USER` 和 `CLICKHOUSE_PASSWORD` 环境变量指定脚本执行时的客户端凭证。  


## 许可协议  

- 软件许可信息：[LICENSE]([])  
- 镜像包含的其他软件（如 Bash 等）可能涉及其他许可协议，详情见 [repo-info 仓库的 `clickhouse/` 目录]([])。  

使用前请确保遵守所有软件的许可协议。
