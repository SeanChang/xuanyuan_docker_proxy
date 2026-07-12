---
image: debezium/kafka
description: "运行Debezium平台时所需的Kafka镜像"
source: https://xuanyuan.cloud/zh/r/debezium/kafka
canonical: https://xuanyuan.cloud/zh/r/debezium/kafka
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/debezium/kafka" title="debezium/kafka Docker 镜像中文简介、标签列表与拉取命令">debezium/kafka 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Debezium Kafka 镜像文档


## 1. 镜像概述和主要用途

### 1.1 基本信息
该镜像为 Debezium 平台的核心组件，用于提供 Kafka 服务。仓库已迁移至 [quay.io/debezium/kafka](https://quay.io/repository/debezium/kafka)。

### 1.2 主要用途
Kafka 是一个分布式、分区、复制的提交日志服务，作为 Debezium 平台的基础组件，用于存储数据库变更事件流。Debezium 连接器监控数据库并将行级变更事件写入 Kafka 主题，客户端应用通过消费相关 Kafka 主题接收和处理变更事件。


## 2. 核心功能和特性

- **分布式日志服务**：支持分布式部署，提供分区和副本机制，确保高可用性和可靠性。  
- **变更事件存储**：作为 Debezium 连接器的目标端，持久化存储数据库变更历史，支持应用停止重启后重新处理错过的事件。  
- **Kafka Connect 兼容**：Debezium 基于 Kafka 构建，提供 Kafka Connect 兼容连接器，无缝集成数据库变更捕获能力。  
- **事件完整性保障**：通过 Kafka 的日志持久化机制，确保所有变更事件被完整记录和可靠传递。  


## 3. 使用场景和适用范围

### 3.1 开发与测试环境
适用于单主机部署，用于 Debezium 平台的简单评估和功能验证，快速搭建包含 Zookeeper、Kafka 和 Debezium 连接器的本地环境。

### 3.2 生产环境
需通过多实例部署提供性能、可靠性和容错能力，可结合 OpenShift 等容器编排平台管理多主机上的容器集群。**注意**：高吞吐量场景建议参考 [Kafka 官方文档](http://kafka.apache.org/documentation.html)，在专用硬件上部署 Kafka。


## 4. 使用方法和配置说明

### 4.1 前提条件
需提前部署 Zookeeper 服务，可通过容器（名称为 `zookeeper`）或 OpenShift 服务（名称为 `zookeeper`）提供。


### 4.2 启动 Kafka Broker

#### 4.2.1 前台运行
```bash
docker run -it --name kafka -p 9092:9092 --link zookeeper:zookeeper ***-quay.xuanyuan.run/debezium/kafka
```
- 参数说明：  
  `-it`：交互式运行并附加控制台，用于查看 broker 输出和错误日志；  
  `--name kafka`：指定容器名称为 `kafka`；  
  `-p 9092:9092`：映射容器 9092 端口到主机；  
  `--link zookeeper:zookeeper`：链接 Zookeeper 容器，使 Kafka 可访问 Zookeeper 服务。

#### 4.2.2 后台运行
使用 `-d` 替换 `-it` 以 detached 模式启动：
```bash
docker run -d --name kafka -p 9092:9092 --link zookeeper:zookeeper ***-quay.xuanyuan.run/debezium/kafka
```
查看日志：
```bash
docker logs --follow --name kafka  # 实时跟踪日志输出
```


### 4.3 创建主题
通过临时容器在运行的 Kafka 集群上创建主题：
```bash
docker run -it --rm --link zookeeper:zookeeper ***-quay.xuanyuan.run/debezium/kafka create-topic [-p numPartitions] [-r numReplicas] [-c cleanupPolicy] topic-name
```
- 参数说明：  
  `topic-name`：主题名称（必填）；  
  `-p numPartitions`：分区数（默认 1）；  
  `-r numReplicas`：副本数（默认 1）；  
  `-c cleanupPolicy`：清理策略（`delete` 或 `compact`，默认 `delete`）。  
- 示例：创建 3 分区、1 副本、清理策略为 `compact` 的主题 `db_changes`：
  ```bash
  docker run -it --rm --link zookeeper:zookeeper ***-quay.xuanyuan.run/debezium/kafka create-topic -p 3 -r 1 -c compact db_changes
  ```


### 4.4 监控主题
通过临时容器监控指定主题的消息：
```bash
docker run -it --rm --link zookeeper:zookeeper --link kafka:kafka ***-quay.xuanyuan.run/debezium/kafka watch-topic [-a] [-k] [-m minBytes] topic-name
```
- 参数说明：  
  `topic-name`：主题名称（必填）；  
  `-a`：从主题起始位置显示所有消息；  
  `-k`：显示消息键（默认不显示）；  
  `-m minBytes`：指定最小拉取字节数（默认 1）。  
- 示例：监控 `db_changes` 主题，显示所有消息及键：
  ```bash
  docker run -it --rm --link zookeeper:zookeeper --link kafka:kafka ***-quay.xuanyuan.run/debezium/kafka watch-topic -a -k db_changes
  ```


### 4.5 列出主题
通过临时容器列出所有主题：
```bash
docker run -it --rm --link zookeeper:zookeeper ***-quay.xuanyuan.run/debezium/kafka list-topics
```


### 4.6 Docker Compose 配置示例
以下为包含 Zookeeper 和 Kafka 的本地部署示例：
```yaml
version: '3'
services:
  zookeeper:
    image: docker.xuanyuan.run/debezium/zookeeper:latest
    ports:
      - "2181:2181"
    environment:
      - ZOOKEEPER_CLIENT_PORT=2181  # Zookeeper 客户端端口

  kafka:
    image: ***-quay.xuanyuan.run/debezium/kafka:latest
    ports:
      - "9092:9092"
    links:
      - zookeeper:zookeeper  # 链接 Zookeeper 服务
    environment:
      - BROKER_ID=1  # 唯一 broker ID
      - ZOOKEEPER_CONNECT=zookeeper:2181  # Zookeeper 连接地址
      - HOST_NAME=kafka  # 绑定主机名
      - ADVERTISED_HOST_NAME=localhost  # 客户端连接用主机名
      - HEAP_OPTS=-Xmx512M -Xms512M  # JVM 堆内存配置
      - CREATE_TOPICS=test_topic:3:1:delete  # 启动时创建主题（名称:分区数:副本数:清理策略）
```


## 5. 环境变量

### 5.1 核心配置变量

| 环境变量              | 作用说明                                                                 | 默认值                  |
|-----------------------|--------------------------------------------------------------------------|-------------------------|
| `BROKER_ID`           |  broker 唯一标识符，集群中需唯一                                        | 1                       |
| `ZOOKEEPER_CONNECT`   | Zookeeper 连接地址（格式参考 Kafka `zookeeper.connect` 属性）            | 链接 `zookeeper` 容器时自动配置 |
| `HOST_NAME`           | broker 绑定的主机名                                                     | 容器主机名              |
| `ADVERTISED_HOST_NAME`| 注册到 Zookeeper 的客户端连接主机名，默认使用 `HOST_NAME` 的值          | `HOST_NAME` 的值        |
| `HEAP_OPTS`           | JVM 堆内存配置                                                          | `-Xmx1G -Xms1G`         |
| `CREATE_TOPICS`       | 启动时自动创建的主题列表，格式：`topic:partitions:replicas[:cleanupPolicy]` | 无                      |
| `LOG_LEVEL`           | 日志级别（`INFO`/`WARN`/`ERROR`/`DEBUG`/`TRACE`）                      | `INFO`                  |


### 5.2 自定义 Kafka 配置
以 `KAFKA_` 为前缀的环境变量会自动转换为 Kafka 配置属性，转换规则：  
1. 移除 `KAFKA_` 前缀；  
2. 所有字符转为小写；  
3. 下划线 `_` 转为点 `.`。  

**示例**：  
`KAFKA_ADVERTISED_HOST_NAME` → `advertised.host.name`  
`KAFKA_AUTO_CREATE_TOPICS_ENABLE` → `auto.create.topics.enable`  

> 注意：环境变量值中不可包含 `@` 字符。


## 6. 端口说明
容器暴露 Kafka 标准端口 **9092**，可通过 `-p` 参数映射到主机端口（如 `-p 9093:9092` 将容器 9092 端口映射到主机 9093 端口）。


## 7. 数据存储

### 7.1 主题数据（`/kafka/data`）
- **用途**：存储 broker 持久化数据（分区日志、索引等），数据目录结构为 `/kafka/data/<BROKER_ID>/`。  
- **持久化要求**：必须通过 Docker 卷挂载该目录（如 `-v /host/kafka/data:/kafka/data`），否则容器停止后数据丢失。


### 7.2 日志文件（`/kafka/logs`）
- **用途**：存储 Kafka 详细日志，按日轮转，包含：  
  - `server.log`：控制台输出日志；  
  - `state-change.log`：控制器与 broker 状态变更记录；  
  - `kafka-request.log`：请求处理记录；  
  - `log-cleaner.log`：日志压缩详情；  
  - `controller.log`：控制器活动日志（如分区 leader 选举）。  
- **挂载建议**：通过卷挂载（如 `-v /host/kafka/logs:/kafka/logs`）持久化日志。


### 7.3 配置文件（`/kafka/config`）
- **用途**：存储 Kafka 配置文件（如 `server.properties`），启动时会根据环境变量和链接容器自动更新配置。  
- **使用建议**：可挂载该目录查看实际生效的配置，或通过自定义配置文件覆盖默认配置（需注意环境变量优先级）。
