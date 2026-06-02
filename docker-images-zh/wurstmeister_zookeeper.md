---
image: wurstmeister/zookeeper
description: "提供Apache ZooKeeper分布式协调服务的Docker镜像，用于分布式系统中的配置管理、命名服务、同步控制及集群协调，支持容器化快速部署与集成。"
source: https://xuanyuan.cloud/zh/r/wurstmeister/zookeeper
canonical: https://xuanyuan.cloud/zh/r/wurstmeister/zookeeper
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/wurstmeister/zookeeper" title="wurstmeister/zookeeper Docker 镜像中文简介、标签列表与拉取命令">wurstmeister/zookeeper — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/wurstmeister/zookeeper" title="wurstmeister/zookeeper Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/wurstmeister/zookeeper</a>

# Zookeeper Docker 镜像文档

## 1. 镜像概述和主要用途

Zookeeper Docker 镜像是基于 Apache ZooKeeper 的容器化部署方案。Apache ZooKeeper 是一个分布式的、开源的协调服务，专为分布式应用提供高性能的协调服务，如命名服务、配置管理、同步控制和组服务等。

该 Docker 镜像封装了 ZooKeeper 服务，提供了简单、一致且可移植的部署方式，简化了在开发、测试和生产环境中搭建和管理 ZooKeeper 集群的过程。

## 2. 核心功能和特性

- **分布式协调**：提供分布式锁、选举和屏障等协调机制
- **配置管理**：集中存储和管理分布式系统的配置信息
- **命名服务**：提供分布式环境下的命名服务
- **集群支持**：支持单节点和多节点集群部署
- **数据持久化**：支持数据持久化到磁盘，确保服务重启后数据不丢失
- **事务日志**：完整的事务日志记录，支持数据恢复
- **版本化数据**：每个节点的数据都有版本号，支持乐观锁机制
- **快速部署**：通过 Docker 快速部署和启动，无需复杂的环境配置

## 3. 使用场景和适用范围

### 适用场景
- 分布式系统中的服务协调和同步
- 微服务架构中的服务发现和注册
- 分布式锁和资源竞争控制
- 配置中心，集中管理应用配置
- 分布式队列和发布/订阅系统
- Hadoop、Kafka、Solr 等分布式系统的协调服务

### 适用范围
- 开发环境：快速搭建本地开发环境
- 测试环境：提供一致的测试环境配置
- 生产环境：可用于中小规模生产环境部署
- 学习研究：ZooKeeper 功能学习和验证

## 4. 使用方法和配置说明

### 4.1 基本使用方法

#### 单节点启动

```bash
docker run --name zookeeper -p 2181:2181 -d zookeeper
```

#### 自定义配置启动

```bash
docker run --name zookeeper \
  -p 2181:2181 \
  -v /path/to/zoo.cfg:/conf/zoo.cfg \
  -v /path/to/data:/data \
  -v /path/to/datalog:/datalog \
  -d zookeeper
```

#### 使用 docker-compose 启动

```yaml
version: '3'
services:
  zookeeper:
    image: zookeeper
    container_name: zookeeper
    ports:
      - "2181:2181"
    environment:
      ZOO_MY_ID: 1
      ZOO_SERVERS: server.1=0.0.0.0:2888:3888
    volumes:
      - zookeeper-data:/data
      - zookeeper-datalog:/datalog
    restart: always

volumes:
  zookeeper-data:
  zookeeper-datalog:
```

### 4.2 环境变量配置

| 环境变量 | 描述 | 默认值 |
|---------|------|-------|
| `ZOO_MY_ID` | 服务器ID，用于集群配置，取值范围1-255 | 1 |
| `ZOO_SERVERS` | 集群服务器列表，格式：`server.id=host:port:port` | `server.1=0.0.0.0:2888:3888` |
| `ZOO_PORT` | 客户端连接端口 | 2181 |
| `ZOO_TICK_TIME` | 基本时间单元（毫秒） | 2000 |
| `ZOO_INIT_LIMIT` |  follower 初始化连接到 leader 的最大时间（tick数） | 10 |
| `ZOO_SYNC_LIMIT` | follower 与 leader 同步的最大时间（tick数） | 5 |
| `ZOO_MAX_CLIENT_CNXNS` | 最大客户端连接数 | 60 |
| `ZOO_AUTOPURGE_PURGEINTERVAL` | 自动清理事务日志和快照的时间间隔（小时），0表示禁用 | 0 |
| `ZOO_AUTOPURGE_RETAINCOUNT` | 自动清理时保留的快照文件数 | 3 |

### 4.3 多节点集群配置

使用 docker-compose 配置3节点ZooKeeper集群：

```yaml
version: '3'
services:
  zk1:
    image: zookeeper
    container_name: zk1
    restart: always
    hostname: zk1
    ports:
      - "2181:2181"
    environment:
      ZOO_MY_ID: 1
      ZOO_SERVERS: server.1=zk1:2888:3888 server.2=zk2:2888:3888 server.3=zk3:2888:3888
    volumes:
      - zk1-data:/data
      - zk1-datalog:/datalog

  zk2:
    image: zookeeper
    container_name: zk2
    restart: always
    hostname: zk2
    ports:
      - "2182:2181"
    environment:
      ZOO_MY_ID: 2
      ZOO_SERVERS: server.1=zk1:2888:3888 server.2=zk2:2888:3888 server.3=zk3:2888:3888
    volumes:
      - zk2-data:/data
      - zk2-datalog:/datalog

  zk3:
    image: zookeeper
    container_name: zk3
    restart: always
    hostname: zk3
    ports:
      - "2183:2181"
    environment:
      ZOO_MY_ID: 3
      ZOO_SERVERS: server.1=zk1:2888:3888 server.2=zk2:2888:3888 server.3=zk3:2888:3888
    volumes:
      - zk3-data:/data
      - zk3-datalog:/datalog

volumes:
  zk1-data:
  zk1-datalog:
  zk2-data:
  zk2-datalog:
  zk3-data:
  zk3-datalog:
```

### 4.4 数据持久化

ZooKeeper 容器使用以下目录存储持久化数据：
- `/data`: 存储快照文件
- `/datalog`: 存储事务日志

建议通过 Docker 卷或绑定挂载来持久化这些目录，以防止容器重启或删除时数据丢失。

### 4.5 客户端连接

使用 ZooKeeper 客户端连接到服务：

```bash
# 进入容器内部使用zkCli
docker exec -it zookeeper zkCli.sh -server localhost:2181

# 从宿主机或其他容器连接
docker run -it --rm --link zookeeper:zookeeper zookeeper zkCli.sh -server zookeeper:2181
```

### 4.6 健康检查

ZooKeeper 提供了四字命令来检查服务状态：

```bash
# 检查服务状态
echo stat | nc localhost 2181

# 检查详细状态
echo mntr | nc localhost 2181

# 检查连接状态
echo ruok | nc localhost 2181
```

在 Docker 中配置健康检查：

```yaml
healthcheck:
  test: ["CMD", "echo", "ruok", "|", "nc", "localhost", "2181"]
  interval: 30s
  timeout: 10s
  retries: 3
```

## 5. 常见问题解决

### 5.1 集群无法启动
- 确保每个节点的 `ZOO_MY_ID` 唯一且与 `ZOO_SERVERS` 中配置一致
- 检查网络连接，确保节点之间可以相互通信
- 检查数据目录权限，确保容器有读写权限

### 5.2 连接数过多
- 调整 `ZOO_MAX_CLIENT_CNXNS` 增加最大连接数
- 检查客户端是否正确关闭连接，避免连接泄漏

### 5.3 性能问题
- 确保事务日志目录 (`datalog`) 位于高性能存储上
- 调整 JVM 参数，优化内存配置
- 考虑增加集群节点数量分担负载

## 6. 注意事项

- 生产环境中建议使用奇数个节点（3、5、7等）组成集群，以确保高可用性
- 确保数据目录和事务日志目录有足够的磁盘空间
- 定期备份数据目录，防止数据丢失
- 对于大规模部署，建议根据实际负载调整 JVM 参数和 ZooKeeper 配置
- 在云环境中部署时，注意配置适当的安全组和网络策略，限制访问来源
