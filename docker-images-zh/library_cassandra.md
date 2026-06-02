<!-- xuanyuan-docker-images-zh
image: library/cassandra
source: https://xuanyuan.cloud/zh/r/library/cassandra
canonical: https://xuanyuan.cloud/zh/r/library/cassandra
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [library/cassandra — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/library/cassandra "library/cassandra Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/library/cassandra

# Cassandra Docker镜像技术文档


## 镜像概述与主要用途

Apache Cassandra 是一个开源分布式数据库管理系统，设计用于跨多台商用服务器处理大量数据，提供高可用性且无单点故障。该系统支持跨多个数据中心的集群部署，通过异步无主复制机制为所有客户端提供低延迟操作。作为分布式存储系统，Cassandra 适用于需要横向扩展、高吞吐量和容错能力的场景。


## 核心功能与特性

- **分布式架构**：跨多台服务器分布式存储数据，支持水平扩展，轻松应对数据量增长。
- **高可用性与容错**：无单点故障设计，节点故障不影响整体集群可用性，自动数据复制确保数据冗余。
- **多数据中心支持**：原生支持跨地域/数据中心部署，可配置数据中心和机架信息，优化数据分布与容错。
- **异步无主复制**：节点间通过 gossip 协议通信，异步复制数据，降低延迟并提升写入性能。
- **灵活配置选项**：支持自定义监听地址、广播地址、集群名称、令牌数量等关键参数，适配不同部署需求。
- **CQL 支持**：通过 Cassandra Query Language (CQL) 进行数据操作，语法类 SQL，易于使用。


## 使用场景与适用范围

- **大规模数据存储**：适用于 TB/PB 级别的结构化或半结构化数据存储需求。
- **高可用性需求**：金融、电商、物联网等对服务连续性要求极高的业务场景。
- **跨地域部署**：需要在多个数据中心/地域分布数据，实现低延迟访问和灾难恢复。
- **写入密集型应用**：社交媒体、日志收集、实时分析等写入吞吐量要求高的场景。
- **横向扩展需求**：业务增长快，需通过添加节点快速扩展存储和处理能力的系统。


## 支持的标签与 Dockerfile 链接

| 标签                                       | Dockerfile 链接                                                                 |
|--------------------------------------------|---------------------------------------------------------------------------------|
| `5.0.5`, `5.0`, `5`, `latest`, `5.0.5-jammy`, `5.0-jammy`, `5-jammy`, `jammy` | [5.0/Dockerfile](https://github.com/docker-library/cassandra/blob/793ea6b2a8097d629252fe77585775443b53e4c3/5.0/Dockerfile) |
| `4.1.10`, `4.1`, `4`, `4.1.10-jammy`, `4.1-jammy`, `4-jammy` | [4.1/Dockerfile](https://github.com/docker-library/cassandra/blob/793ea6b2a8097d629252fe77585775443b53e4c3/4.1/Dockerfile) |
| `4.0.18`, `4.0`, `4.0.18-jammy`, `4.0-jammy` | [4.0/Dockerfile](https://github.com/docker-library/cassandra/blob/793ea6b2a8097d629252fe77585775443b53e4c3/4.0/Dockerfile) |
| `3.11.19`, `3.11`, `3`, `3.11.19-jammy`, `3.11-jammy`, `3-jammy` | [3.11/Dockerfile](https://github.com/docker-library/cassandra/blob/793ea6b2a8097d629252fe77585775443b53e4c3/3.11/Dockerfile) |
| `3.0.32`, `3.0`, `3.0.32-jammy`, `3.0-jammy` | [3.0/Dockerfile](https://github.com/docker-library/cassandra/blob/793ea6b2a8097d629252fe77585775443b53e4c3/3.0/Dockerfile) |


## 快速参考

- **维护者**：[Docker 社区](https://github.com/docker-library/cassandra)  
- **获取帮助**：[Docker Community Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)  
- **提交 issue**：[https://github.com/docker-library/cassandra/issues](https://github.com/docker-library/cassandra/issues?q=)  
- **支持的架构**：`amd64`、`arm32v7`、`arm64v8`、`ppc64le`、`s390x`（[更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64)）  
- **镜像 artifact 详情**：[repo-info 仓库的 `repos/cassandra/` 目录](https://github.com/docker-library/repo-info/blob/master/repos/cassandra)（包含元数据、传输大小等）  
- **镜像更新**：[official-images 仓库的 `library/cassandra` 标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fcassandra) 及 [配置文件](https://github.com/docker-library/official-images/blob/master/library/cassandra)  
- **文档来源**：[docs 仓库的 `cassandra/` 目录](https://github.com/docker-library/docs/tree/master/cassandra)  


## 使用方法与配置说明

### 启动单个 Cassandra 服务实例

启动 Cassandra 实例的基本命令如下：

```bash
docker run --name some-cassandra --network some-network -d cassandra:tag
```

- `--name some-cassandra`：指定容器名称（可自定义）。  
- `--network some-network`：将容器加入自定义网络（建议使用，便于集群通信）。  
- `-d`：后台运行容器。  
- `cassandra:tag`：指定镜像标签（如 `latest`、`5.0` 等，见“支持的标签”）。  


### 创建 Cassandra 集群

通过环境变量可配置两种集群场景：**同机多节点**和**跨机多节点**。

#### 同机集群

1. 启动第一个节点（种子节点）：  
   ```bash
   docker run --name some-cassandra --network some-network -d cassandra:tag
   ```

2. 启动后续节点，指定种子节点为第一个节点的容器名：  
   ```bash
   docker run --name some-cassandra2 --network some-network -d -e CASSANDRA_SEEDS=some-cassandra cassandra:tag
   ```

#### 跨机集群（如两台云服务器）

假设服务器 A  IP 为 `10.42.42.42`，服务器 B IP 为 `10.43.43.43`。

1. 服务器 A 启动种子节点，暴露 gossip 端口（7000）并指定广播地址：  
   ```bash
   docker run --name some-cassandra -d -e CASSANDRA_BROADCAST_ADDRESS=10.42.42.42 -p 7000:7000 cassandra:tag
   ```

2. 服务器 B 启动节点，指定种子节点为服务器 A 的 IP，并暴露端口：  
   ```bash
   docker run --name some-cassandra -d -e CASSANDRA_BROADCAST_ADDRESS=10.43.43.43 -p 7000:7000 -e CASSANDRA_SEEDS=10.42.42.42 cassandra:tag
   ```


### 通过 cqlsh 连接 Cassandra

使用 `cqlsh`（Cassandra 查询语言 shell）连接运行中的 Cassandra 容器：

```bash
docker run -it --network some-network --rm cassandra cqlsh some-cassandra
```

- `-it`：交互模式，分配终端。  
- `--network some-network`：与目标 Cassandra 容器在同一网络。  
- `--rm`：命令执行后自动删除临时容器。  
- `some-cassandra`：目标 Cassandra 容器名称（或 IP）。  

更多 CQL 语法参考 [Cassandra 官方文档](https://cassandra.apache.org/doc/latest/cql/index.html)。


### 容器 shell 访问与日志查看

#### 进入容器 shell

通过 `docker exec` 进入运行中的容器：

```bash
docker exec -it some-cassandra bash
```

#### 查看 Cassandra 日志

通过 Docker 容器日志命令查看 Cassandra 服务日志：

```bash
docker logs some-cassandra
```


### 配置 Cassandra

#### 自定义配置文件（推荐）

最灵活的方式是通过挂载自定义 `cassandra.yaml` 文件覆盖默认配置：

```bash
docker run --name some-cassandra -v /path/on/host/cassandra.yaml:/etc/cassandra/cassandra.yaml -d cassandra:tag
```

如需使用非默认配置文件名，可通过启动参数指定：

```bash
docker run --name some-cassandra -d cassandra:tag -Dcassandra.config=/path/to/custom-config.yaml
```

#### 环境变量配置

镜像支持通过环境变量修改 `cassandra.yaml` 及 `cassandra-rackdc.properties` 中的关键配置，如下表：

| 环境变量                | 描述                                                                 | 默认值                  | 对应配置项                                                                 |
|-------------------------|----------------------------------------------------------------------|-------------------------|--------------------------------------------------------------------------|
| `CASSANDRA_LISTEN_ADDRESS` | 监听入站连接的 IP 地址。                                             | `auto`（容器启动时 IP） | `cassandra.yaml` 的 `listen_address`                                      |
| `CASSANDRA_BROADCAST_ADDRESS` | 向其他节点广播的 IP 地址（用于集群通信）。                           | `CASSANDRA_LISTEN_ADDRESS` 的值 | `cassandra.yaml` 的 `broadcast_address` 和 `broadcast_rpc_address`         |
| `CASSANDRA_RPC_ADDRESS`  | Thrift RPC 服务器绑定地址。                                          | `0.0.0.0`（通配地址）   | `cassandra.yaml` 的 `rpc_address`                                         |
| `CASSANDRA_START_RPC`    | 是否启动 Thrift RPC 服务器。                                         | `false`                 | `cassandra.yaml` 的 `start_rpc`                                           |
| `CASSANDRA_SEEDS`        | 集群启动时 gossip 协议的种子节点 IP 列表（逗号分隔）。               | 自动添加当前节点 IP     | `cassandra.yaml` 的 `seed_provider` 中的 `seeds`                          |
| `CASSANDRA_CLUSTER_NAME` | 集群名称（所有节点必须一致）。                                       | `Test Cluster`          | `cassandra.yaml` 的 `cluster_name`                                        |
| `CASSANDRA_NUM_TOKENS`   | 节点的令牌数量（影响数据分片）。                                     | `256`                   | `cassandra.yaml` 的 `num_tokens`                                          |
| `CASSANDRA_DC`           | 节点所属数据中心名称（需配合 `GossipingPropertyFileSnitch`）。       | -                       | `cassandra-rackdc.properties` 的 `dc`                                     |
| `CASSANDRA_RACK`         | 节点所属机架名称（需配合 `GossipingPropertyFileSnitch`）。           | -                       | `cassandra-rackdc.properties` 的 `rack`                                   |
| `CASSANDRA_ENDPOINT_SNITCH` | 节点使用的 endpoint snitch 实现（控制数据分布策略）。               | `SimpleSnitch`          | `cassandra.yaml` 的 `endpoint_snitch`                                     |


## 部署示例

### docker-compose 集群配置示例

以下是使用 `docker-compose.yml` 启动 3 节点集群的示例：

```yaml
version: '3'
services:
  cassandra-seed:
    image: cassandra:latest
    container_name: cassandra-seed
    environment:
      - CASSANDRA_CLUSTER_NAME=MyCluster
      - CASSANDRA_NUM_TOKENS=256
      - CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch
      - CASSANDRA_DC=DC1
      - CASSANDRA_RACK=Rack1
    volumes:
      - cassandra-seed-data:/var/lib/cassandra
    ports:
      - "7000:7000"  # Gossip 端口
      - "9042:9042"  # CQL 端口

  cassandra-node1:
    image: cassandra:latest
    container_name: cassandra-node1
    environment:
      - CASSANDRA_CLUSTER_NAME=MyCluster
      - CASSANDRA_SEEDS=cassandra-seed
      - CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch
      - CASSANDRA_DC=DC1
      - CASSANDRA_RACK=Rack1
    volumes:
      - cassandra-node1-data:/var/lib/cassandra
    depends_on:
      - cassandra-seed

  cassandra-node2:
    image: cassandra:latest
    container_name: cassandra-node2
    environment:
      - CASSANDRA_CLUSTER_NAME=MyCluster
      - CASSANDRA_SEEDS=cassandra-seed
      - CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch
      - CASSANDRA_DC=DC1
      - CASSANDRA_RACK=Rack2
    volumes:
      - cassandra-node2-data:/var/lib/cassandra
    depends_on:
      - cassandra-seed

volumes:
  cassandra-seed-data:
  cassandra-node1-data:
  cassandra-node2-data:
```

启动集群：  
```bash
docker-compose up -d
```


## 注意事项

### 数据存储位置

Cassandra 默认将数据存储在容器内的 `/var/lib/cassandra`。为避免数据丢失，建议通过**卷挂载**将数据持久化到主机：

```bash
docker run --name some-cassandra -v /host/datadir:/var/lib/cassandra -d cassandra:tag
```

- `/host/datadir`：主机上的目录（需提前创建并设置权限）。  
- `/var/lib/cassandra`：容器内数据目录。  


### 初始化完成前无法连接

容器启动时，若未初始化数据库，会自动创建默认数据库。此过程中 Cassandra 不接受连接，可能导致自动化工具（如 `docker-compose`）启动多容器时出现连接失败。建议通过脚本检测节点状态（如 `nodetool status`），确认初始化完成后再进行后续操作。


## 许可证信息

Cassandra 软件使用 [Apache 许可证](https://git-wip-us.apache.org/repos/asf?p=cassandra.git;a=blob;f=LICENSE.txt;hb=cassandra-3.11.1)。  
镜像可能包含其他软件（如 Bash、基础系统组件等），其许可证可能不同。更多信息可参考 [repo-info 仓库的 `cassandra/` 目录](https://github.com/docker-library/repo-info/tree/master/repos/cassandra)。  
使用本镜像需确保遵守所有包含软件的相关许可证。
