---
image: dyrnq/etcd
description: "Kubernetes官方分布式键值存储镜像，为K8s集群提供高可用、一致性的数据存储服务，用于保存集群状态和配置信息，是Kubernetes核心组件之一。"
source: https://xuanyuan.cloud/zh/r/dyrnq/etcd
canonical: https://xuanyuan.cloud/zh/r/dyrnq/etcd
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dyrnq/etcd" title="dyrnq/etcd Docker 镜像中文简介、标签列表与拉取命令">dyrnq/etcd — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/dyrnq/etcd" title="dyrnq/etcd Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/dyrnq/etcd</a>

# registry.k8s.io/etcd 镜像文档


## 1. 镜像概述和主要用途

`registry.k8s.io/etcd` 是 Kubernetes 官方维护的 etcd 容器镜像。etcd 是一个分布式、高可用的键值存储系统，基于 Raft 一致性算法实现，主要用于存储分布式系统的关键数据（如配置信息、集群状态等）。该镜像专为 Kubernetes 集群设计，作为其核心组件之一，负责存储集群的状态数据（如 Pod 配置、服务信息、节点状态等），同时也可独立部署用于其他分布式系统的配置管理或服务发现场景。


## 2. 核心功能和特性

### 2.1 核心功能
- **分布式键值存储**：支持键值对数据的存储与检索，键可按目录结构组织（如 `/kube-system/config`）。
- **强一致性**：基于 Raft 协议实现分布式节点间的数据一致性，确保数据可靠同步。
- **高可用性**：支持多节点集群部署，自动选举 Leader 节点，故障时自动切换，保障服务持续可用。
- **数据版本化**：每个键值对关联版本号，支持基于版本的条件更新和历史数据查询。
- **监听机制**：支持对键或目录的变更事件监听，实时响应数据更新。
- **API 支持**：提供 HTTP/gRPC API，支持数据的增删改查及集群管理操作。


### 2.2 关键特性
- **轻量级**：容器化部署，资源占用低，适合 Kubernetes 环境集成。
- **持久化存储**：支持数据持久化到磁盘，确保重启后数据不丢失。
- **安全性**：支持 TLS 加密通信、客户端认证及权限控制。
- **可扩展性**：支持集群节点动态添加/移除，适应业务规模增长。


## 3. 使用场景和适用范围

### 3.1 主要场景
- **Kubernetes 集群后端存储**：作为 Kubernetes 的核心组件，存储集群状态数据（如 etcd 中存储 `pods`、`services`、`namespaces` 等资源的元数据）。
- **分布式系统配置管理**：存储分布式应用的动态配置，支持多节点实时同步。
- **服务发现**：存储服务地址、端口等信息，供服务间相互发现。
- **分布式锁**：利用 Raft 一致性实现分布式环境下的锁机制，保证操作原子性。


### 3.2 适用范围
- **Kubernetes 环境**：推荐作为 Kubernetes 集群的默认 etcd 部署方式。
- **独立分布式系统**：可脱离 Kubernetes 独立部署，用于非 Kubernetes 环境的分布式存储需求。
- **开发/测试环境**：单节点模式适合本地开发或测试，集群模式适合模拟生产环境。


## 4. 使用方法和配置说明

### 4.1 镜像拉取
通过以下命令拉取最新版本镜像：
```bash
docker pull registry.k8s.io/etcd:latest
```
如需指定版本（如 `3.5.10`），可替换标签：
```bash
docker pull registry.k8s.io/etcd:3.5.10
```


### 4.2 基本运行方式
#### 4.2.1 单节点模式（开发/测试用）
单节点模式适合本地开发或测试，无需集群配置：
```bash
docker run -d \
  --name etcd-single \
  --publish 2379:2379 \  # 客户端通信端口
  --publish 2380:2380 \  # 集群间通信端口
  --volume etcd-data:/var/lib/etcd \  # 数据持久化目录
  registry.k8s.io/etcd:latest \
  etcd \
    --name=etcd-node-1 \  # 节点名称
    --data-dir=/var/lib/etcd \  # 数据存储目录
    --listen-client-urls=http://0.0.0.0:2379 \  # 监听客户端请求的地址
    --advertise-client-urls=http://localhost:2379 \  # 对外暴露的客户端地址（供其他节点访问）
    --listen-peer-urls=http://0.0.0.0:2380 \  # 监听集群节点间通信的地址
    --initial-advertise-peer-urls=http://localhost:2380 \  # 对外暴露的集群通信地址
    --initial-cluster=etcd-node-1=http://localhost:2380 \  # 初始集群配置（单节点仅包含自身）
    --initial-cluster-token=etcd-cluster-token \  # 集群标识 token（集群内所有节点需一致）
    --initial-cluster-state=new  # 集群初始化状态（new 表示新建集群）
```

验证运行状态：
```bash
# 进入容器
docker exec -it etcd-single sh

# 查看集群健康状态
etcdctl endpoint health --endpoints=http://localhost:2379

# 写入测试数据
etcdctl put /test/key "hello etcd"

# 读取测试数据
etcdctl get /test/key
```


#### 4.2.2 集群模式（生产用）
生产环境需部署多节点集群（至少 3 节点，确保高可用）。以下为 3 节点集群示例（假设节点 IP 分别为 `192.168.1.101`、`192.168.1.102`、`192.168.1.103`）：

**节点 1（192.168.1.101）启动命令**：
```bash
docker run -d \
  --name etcd-node-1 \
  --publish 2379:2379 \
  --publish 2380:2380 \
  --volume etcd-data-1:/var/lib/etcd \
  registry.k8s.io/etcd:latest \
  etcd \
    --name=etcd-node-1 \
    --data-dir=/var/lib/etcd \
    --listen-client-urls=http://0.0.0.0:2379 \
    --advertise-client-urls=http://192.168.1.101:2379 \
    --listen-peer-urls=http://0.0.0.0:2380 \
    --initial-advertise-peer-urls=http://192.168.1.101:2380 \
    --initial-cluster=etcd-node-1=http://192.168.1.101:2380,etcd-node-2=http://192.168.1.102:2380,etcd-node-3=http://192.168.1.103:2380 \
    --initial-cluster-token=etcd-cluster-token \
    --initial-cluster-state=new
```

**节点 2（192.168.1.102）启动命令**：
```bash
docker run -d \
  --name etcd-node-2 \
  --publish 2379:2379 \
  --publish 2380:2380 \
  --volume etcd-data-2:/var/lib/etcd \
  registry.k8s.io/etcd:latest \
  etcd \
    --name=etcd-node-2 \
    --data-dir=/var/lib/etcd \
    --listen-client-urls=http://0.0.0.0:2379 \
    --advertise-client-urls=http://192.168.1.102:2379 \
    --listen-peer-urls=http://0.0.0.0:2380 \
    --initial-advertise-peer-urls=http://192.168.1.102:2380 \
    --initial-cluster=etcd-node-1=http://192.168.1.101:2380,etcd-node-2=http://192.168.1.102:2380,etcd-node-3=http://192.168.1.103:2380 \
    --initial-cluster-token=etcd-cluster-token \
    --initial-cluster-state=new
```

**节点 3（192.168.1.103）启动命令**：
```bash
docker run -d \
  --name etcd-node-3 \
  --publish 2379:2379 \
  --publish 2380:2380 \
  --volume etcd-data-3:/var/lib/etcd \
  registry.k8s.io/etcd:latest \
  etcd \
    --name=etcd-node-3 \
    --data-dir=/var/lib/etcd \
    --listen-client-urls=http://0.0.0.0:2379 \
    --advertise-client-urls=http://192.168.1.103:2379 \
    --listen-peer-urls=http://0.0.0.0:2380 \
    --initial-advertise-peer-urls=http://192.168.1.103:2380 \
    --initial-cluster=etcd-node-1=http://192.168.1.101:2380,etcd-node-2=http://192.168.1.102:2380,etcd-node-3=http://192.168.1.103:2380 \
    --initial-cluster-token=etcd-cluster-token \
    --initial-cluster-state=new
```

验证集群状态：
```bash
# 任意节点执行，检查集群成员
etcdctl member list --endpoints=http://192.168.1.101:2379,http://192.168.1.102:2379,http://192.168.1.103:2379

# 检查集群健康状态
etcdctl endpoint health --endpoints=http://192.168.1.101:2379,http://192.168.1.102:2379,http://192.168.1.103:2379
```


### 4.3 环境变量说明
etcd 支持通过环境变量配置核心参数，常用变量如下：

| 环境变量                  | 描述                                                                 | 默认值                  |
|---------------------------|----------------------------------------------------------------------|-------------------------|
| `ETCD_NAME`               | 节点名称（集群内唯一）                                               | `default`               |
| `ETCD_DATA_DIR`           | 数据存储目录                                                         | `./default.etcd`        |
| `ETCD_LISTEN_CLIENT_URLS` | 监听客户端请求的地址（支持 HTTP/HTTPS）                              | `http://127.0.0.1:2379` |
| `ETCD_ADVERTISE_CLIENT_URLS` | 对外暴露的客户端地址（供其他节点/客户端访问）                       | `http://127.0.0.1:2379` |
| `ETCD_LISTEN_PEER_URLS`   | 监听集群节点间通信的地址                                             | `http://127.0.0.1:2380` |
| `ETCD_INITIAL_ADVERTISE_PEER_URLS` | 对外暴露的集群通信地址（供其他节点访问）                          | `http://127.0.0.1:2380` |
| `ETCD_INITIAL_CLUSTER`    | 初始集群配置，格式为 `<节点名1>=<节点1通信地址>,<节点名2>=<节点2通信地址>` | `default=http://127.0.0.1:2380` |
| `ETCD_INITIAL_CLUSTER_TOKEN` | 集群标识 token（所有节点必须一致，用于区分不同集群）                | `etcd-cluster`          |
| `ETCD_INITIAL_CLUSTER_STATE` | 集群初始化状态（`new` 表示新建集群，`existing` 表示加入现有集群）   | `new`                   |


### 4.4 命令行参数说明
除环境变量外，etcd 支持通过命令行参数配置，常用参数与环境变量对应关系如下：

| 命令行参数                  | 对应环境变量                  | 描述                                                                 |
|-----------------------------|-------------------------------|----------------------------------------------------------------------|
| `--name`                    | `ETCD_NAME`                   | 节点名称                                                             |
| `--data-dir`                | `ETCD_DATA_DIR`               | 数据存储目录                                                         |
| `--listen-client-urls`      | `ETCD_LISTEN_CLIENT_URLS`     | 监听客户端请求的地址                                                 |
| `--advertise-client-urls`   | `ETCD_ADVERTISE_CLIENT_URLS`  | 对外暴露的客户端地址                                                 |
| `--listen-peer-urls`        | `ETCD_LISTEN_PEER_URLS`       | 监听集群节点间通信的地址                                             |
| `--initial-advertise-peer-urls` | `ETCD_INITIAL_ADVERTISE_PEER_URLS` | 对外暴露的集群通信地址                                           |
| `--initial-cluster`         | `ETCD_INITIAL_CLUSTER`        | 初始集群配置                                                         |
| `--initial-cluster-token`   | `ETCD_INITIAL_CLUSTER_TOKEN`  | 集群标识 token                                                       |
| `--initial-cluster-state`   | `ETCD_INITIAL_CLUSTER_STATE`  | 集群初始化状态                                                       |


## 5. Docker Compose 部署示例

### 5.1 单节点部署（`docker-compose.yml`）
```yaml
version: '3'
services:
  etcd:
    image: registry.k8s.io/etcd:latest
    container_name: etcd-single
    ports:
      - "2379:2379"  # 客户端端口
      - "2380:2380"  # 集群通信端口
    volumes:
      - etcd-data:/var/lib/etcd  # 数据持久化
    environment:
      - ETCD_NAME=etcd-node-1
      - ETCD_DATA_DIR=/var/lib/etcd
      - ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379
      - ETCD_ADVERTISE_CLIENT_URLS=http://localhost:2379
      - ETCD_LISTEN_PEER_URLS=http://0.0.0.0:2380
      - ETCD_INITIAL_ADVERTISE_PEER_URLS=http://localhost:2380
      - ETCD_INITIAL_CLUSTER=etcd-node-1=http://localhost:2380
      - ETCD_INITIAL_CLUSTER_TOKEN=etcd-cluster-token
      - ETCD_INITIAL_CLUSTER_STATE=new
volumes:
  etcd-data:  # 声明持久化卷
```

启动命令：`docker-compose up -d`


### 5.2 3 节点集群部署（`docker-compose.yml`）
```yaml
version: '3'
services:
  etcd-node-1:
    image: registry.k8s.io/etcd:latest
    container_name: etcd-node-1
    ports:
      - "2379:2379"
      - "2380:2380"
    volumes:
      - etcd-data-1:/var/lib/etcd
    environment:
      - ETCD_NAME=etcd-node-1
      - ETCD_DATA_DIR=/var/lib/etcd
      - ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379
      - ETCD_ADVERTISE_CLIENT_URLS=http://etcd-node-1:2379
      - ETCD_LISTEN_PEER_URLS=http://0.0.0.0:2380
      - ETCD_INITIAL_ADVERTISE_PEER_URLS=http://etcd-node-1:2380
      - ETCD_INITIAL_CLUSTER=etcd-node-1=http://etcd-node-1:2380,etcd-node-2=http://etcd-node-2:2380,etcd-node-3=http://etcd-node-3:2380
      - ETCD_INITIAL_CLUSTER_TOKEN=etcd-cluster-token
      - ETCD_INITIAL_CLUSTER_STATE=new
    networks:
      - etcd-cluster-net

  etcd-node-2:
    image: registry.k8s.io/etcd:latest
    container_name: etcd-node-2
    ports:
      - "2381:2379"  # 避免端口冲突，映射到主机 2381 端口
      - "2382:2380"
    volumes:
      - etcd-data-2:/var/lib/etcd
    environment:
      - ETCD_NAME=etcd-node-2
      - ETCD_DATA_DIR=/var/lib/etcd
      - ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:237
