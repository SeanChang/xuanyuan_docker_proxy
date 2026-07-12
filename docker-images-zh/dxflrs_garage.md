---
image: dxflrs/garage
description: "S3兼容的对象存储，适用于小型自托管地理分布式部署。"
source: https://xuanyuan.cloud/zh/r/dxflrs/garage
canonical: https://xuanyuan.cloud/zh/r/dxflrs/garage
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dxflrs/garage" title="dxflrs/garage Docker 镜像中文简介、标签列表与拉取命令">dxflrs/garage 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Garage 镜像文档

## 镜像概述和主要用途

Garage 是一个 S3 兼容的分布式对象存储服务，专为中小型自托管环境设计，特别适用于地理分布式部署场景。其核心目标是提供轻量级、易操作且高可用的对象存储解决方案，支持跨不同物理位置的节点组成存储集群，实现数据冗余与故障 resilience。


## 核心功能和特性

### S3 API 兼容性
- 完全兼容 S3 协议，可无缝对接依赖 S3 接口的应用（如备份工具、静态网站托管、数据归档系统等）。

### 分布式与地理冗余
- 支持由多物理位置节点组成的集群，自动实现数据跨节点复制，确保地理分布式部署下的数据安全性。

### 轻量级架构
- 设计精简，资源占用低，适合中小型部署场景，无需复杂的基础设施支持。

### 高可用性
- 即使部分节点或物理位置不可达，集群仍能维持服务可用，保障数据访问连续性。

### 易操作性
- 简化的配置与管理流程，降低自托管存储的运维复杂度。

### 开源许可
- 采用 AGPLv3 开源协议，允许自由使用、修改和分发。


## 使用场景和适用范围

### 适用场景
- **中小型自托管存储**：满足企业或个人对私有对象存储的需求，无需依赖公有云服务。
- **地理分布式部署**：多分支机构、跨数据中心的存储需求，需确保数据本地冗余与全局访问。
- **S3 兼容应用对接**：作为私有 S3 存储后端，支持各类 S3 客户端工具（如 `s3cmd`、`rclone`）及应用集成。
- **轻量级高可用存储**：对资源有限但需高可用性的场景（如边缘计算节点、小型机房）。

### 不适用场景
- 超大规模存储集群（十万级以上节点）或极高吞吐量需求（需考虑性能优化或更专业的分布式存储方案）。


## 使用方法和配置说明

### 前置准备
- 确保 Docker 环境已安装（参考 [Docker 官方文档](https://docs.docker.com/engine/install/)）。
- 集群部署需提前规划节点网络（确保节点间通信端口可通）及数据目录（建议持久化存储）。


### Docker 快速启动（单节点示例）

#### 1. 准备配置文件
创建 `garage.toml` 配置文件（单节点最小配置示例）：
```toml
metadata_dir = "/data/meta"
data_dir = "/data/data"

rpc_bind_addr = "0.0.0.0:3901"
api_bind_addr = "0.0.0.0:3900"
s3_api_bind_addr = "0.0.0.0:9000"
s3_website_bind_addr = "0.0.0.0:9001"

[cluster]
id = "garage-test-cluster"
```

#### 2. 启动容器
```bash
docker run -d \
  --name garage-node \
  -p 9000:9000 \  # S3 API 端口
  -p 3900:3900 \  # 管理 API 端口
  -v /path/to/local/data:/data \  # 持久化数据目录（需替换为本地路径）
  -v /path/to/garage.toml:/etc/garage.toml \  # 挂载配置文件
  deuxfleurs/garage \
  server -c /etc/garage.toml
```


### Docker Compose 集群部署（多节点示例）

#### 1. 创建 `docker-compose.yml`
```yaml
version: "3.8"

services:
  garage-node-1:
    image: docker.xuanyuan.run/deuxfleurs/garage
    container_name: garage-node-1
    ports:
      - "9000:9000"  # S3 API
      - "3900:3900"  # 管理 API
      - "3901:3901"  # 节点间 RPC
    volumes:
      - ./node1/data:/data  # 节点 1 数据目录
      - ./garage.toml:/etc/garage.toml  # 共享配置文件（集群模式需调整节点 ID）
    command: server -c /etc/garage.toml
    restart: unless-stopped

  garage-node-2:
    image: docker.xuanyuan.run/deuxfleurs/garage
    container_name: garage-node-2
    ports:
      - "9001:9000"  # S3 API（避免端口冲突）
      - "3902:3900"  # 管理 API
      - "3903:3901"  # 节点间 RPC
    volumes:
      - ./node2/data:/data  # 节点 2 数据目录
      - ./garage.toml:/etc/garage.toml
    command: server -c /etc/garage.toml
    restart: unless-stopped
```

#### 2. 启动集群
```bash
docker-compose up -d
```


### 关键配置说明

#### 核心配置项（`garage.toml`）
- `metadata_dir`：元数据存储路径（建议持久化）。
- `data_dir`：对象数据存储路径（需持久化，建议使用高性能存储介质）。
- `rpc_bind_addr`：节点间 RPC 通信地址（格式 `IP:端口`，集群内节点需互通此端口）。
- `api_bind_addr`：管理 API 地址（用于集群配置与监控）。
- `s3_api_bind_addr`：S3 API 服务地址（客户端访问端口，默认 9000）。
- `[cluster]`：集群配置，包括 `id`（集群唯一标识）、`peers`（集群节点列表，格式 `节点 ID@IP:RPC端口`）。

#### 容器运行注意事项
- **数据持久化**：必须挂载本地目录至容器内 `/data`（或配置文件中指定的 `metadata_dir` 和 `data_dir`），避免容器重启导致数据丢失。
- **网络配置**：集群模式下，需确保所有节点的 RPC 端口（默认 3901）互通，可通过 Docker 网络或主机网络实现。
- **节点 ID**：每个节点需生成唯一 ID（通过 `garage node id` 命令生成），并在集群配置中注册。


## 参考文档
- 完整部署指南：[使用 Docker 部署 Garage 集群](https://garagehq.deuxfleurs.fr/documentation/cookbook/real-world/)
- 官方文档：[Garage 文档中心](https://garagehq.deuxfleurs.fr/documentation/)
- 配置手册：[Garage 配置参考](https://garagehq.deuxfleurs.fr/documentation/reference-manual/configuration/)
