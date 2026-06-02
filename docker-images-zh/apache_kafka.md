---
image: apache/kafka
description: "Apache Kafka是一个开源的分布式流处理平台，旨在提供高吞吐量、低延迟的实时数据流传递服务，支持发布/订阅消息模式，能够持久化存储海量数据流并确保数据可靠性，具备水平扩展能力和容错机制，广泛应用于日志收集、事件驱动架构、实时数据集成及流处理系统等场景，为企业级应用提供高效、稳定的数据流传输与处理解决方案。"
source: https://xuanyuan.cloud/zh/r/apache/kafka
canonical: https://xuanyuan.cloud/zh/r/apache/kafka
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [apache/kafka — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/apache/kafka)

含镜像标签、拉取命令、部署文档与相关推荐。

[apache/kafka Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/apache/kafka)

# Apache Kafka®


## 什么是 Apache Kafka？

Apache Kafka 是一款开源事件流平台，用于实时大规模收集、处理、存储和集成数据。它支持多种应用场景，包括流处理、数据集成和发布/订阅消息传递。

Kafka 最初由 LinkedIn 开发，2011 年开源，2012 年成为 Apache 软件基金会项目。目前全球数千家组织使用它来支撑关键实时应用，例如证券交易系统、电商平台、物联网监控与分析等。


## 快速入门

### 启动 Kafka broker
```console
docker run -d --name broker apache/kafka:latest
```

### 进入 broker 容器终端
```console
docker exec --workdir /opt/kafka/bin/ -it broker sh
```

### 创建主题
主题（topic）是 Kafka 中事件的逻辑分组。从容器内创建名为 `test-topic` 的主题：
```console
./kafka-topics.sh --bootstrap-server localhost:9092 --create --topic test-topic
```

### 生产消息
使用 Kafka 自带的控制台生产者向 `test-topic` 写入两条字符串事件：
```console
./kafka-console-producer.sh --bootstrap-server localhost:9092 --topic test-topic
```
命令执行后会显示 `>` 提示符，输入 `hello` 并按回车，再输入 `world` 按回车，最后按 `Ctrl+C` 退出生产者。

### 消费消息
从日志开头读取 `test-topic` 中的事件：
```console
./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test-topic --from-beginning
```
会看到之前生产的两条消息：
```
hello
world
```
消费者会持续运行，按 `Ctrl+C` 退出。

### 停止容器
完成后，在主机执行以下命令停止并删除容器：
```console
docker rm -f broker
```


## 覆盖默认 broker 配置

Kafka 支持通过环境变量覆盖大量 broker 配置。环境变量需以 `KAFKA_` 开头，配置项中的点（`.`）需替换为下划线（`_`）。例如，要设置主题默认分区数 `num.partitions`，需定义环境变量 `KAFKA_NUM_PARTITIONS`。更多配置说明见 [Kafka Docker 镜像使用指南]([])。

**注意**：覆盖任何配置后，默认配置将不再生效。例如，以 KRaft [combined 模式]([])（broker 和 controller 在同一容器中运行）启动 Kafka，并将默认分区数设为 3（默认是 1），需指定以下环境变量：

```console
docker run -d  \
  --name broker \
  -e KAFKA_NODE_ID=1 \
  -e KAFKA_PROCESS_ROLES=broker,controller \
  -e KAFKA_LISTENERS=PLAINTEXT://:9092,CONTROLLER://:9093 \
  -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092 \
  -e KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER \
  -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT \
  -e KAFKA_CONTROLLER_QUORUM_VOTERS=1@localhost:9093 \
  -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
  -e KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1 \
  -e KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1 \
  -e KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0 \
  -e KAFKA_NUM_PARTITIONS=3 \
  apache/kafka:latest
```

命令行指定大量环境变量较繁琐，建议使用 [Docker Compose]([]) 管理。先检查 Docker Compose 是否安装：
```console
docker compose version
```
未安装可参考 [安装文档]([])。

### 使用 Docker Compose 覆盖分区数

1. 创建 `docker-compose.yml` 文件，内容如下：
```yaml
services:
  broker:
    image: apache/kafka:latest
    container_name: broker
    environment:
      KAFKA_NODE_ID: 1
      KAFKA_PROCESS_ROLES: broker,controller
      KAFKA_LISTENERS: PLAINTEXT://localhost:9092,CONTROLLER://localhost:9093
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@localhost:9093
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
      KAFKA_NUM_PARTITIONS: 3
```

2. 在文件所在目录启动 Kafka（后台运行）：
```console
docker compose up -d
```

3. 可按 [快速入门](#快速入门) 步骤测试主题创建、消息生产与消费。

4. 停止服务：
```console
docker compose down
```


## 外部客户端连接

前面的示例在 Docker 容器内运行客户端命令。从外部连接需额外两步（单节点 combined 模式下）：

### 1. 端口映射
- **使用 `docker run`**：添加 `-p 9092:9092` 映射端口：
  ```console
  docker run -d -p 9092:9092 --name broker apache/kafka:latest
  ```
- **使用 Docker Compose**：在 `broker` 服务中添加端口映射：
  ```yaml
  ports:
    - 9092:9092
  ```

### 2. 下载 Kafka 发行版
从 [最新 Kafka 版本]([]) 下载并解压，控制台生产者/消费者工具位于 `bin` 目录。此时 [快速入门](#快速入门) 步骤可在主机执行，`localhost` 指向主机而非容器内地址。


## 多节点部署

本节部署更接近实际场景的多节点集群：3 个 broker 和 3 个 controller（KRaft [isolated 模式]([])），支持 Docker 内和主机连接。**注意**：此示例仅用于学习，不适合生产环境。

### 配置要点
1. `KAFKA_PROCESS_ROLES` 按角色设为 `broker` 或 `controller`（非 combined 模式的 `broker,controller`）。
2. `KAFKA_CONTROLLER_QUORUM_VOTERS` 列出 3 个 controller。
3. 默认副本数配置（如 `offsets.topic.replication.factor=3`）可满足多节点场景，无需额外指定。
4. Broker 需两个监听器：Docker 网络内（容器名解析）和主机（端口映射，如 broker-1 用 29092，broker-2 用 39092 等）。

### 部署步骤

1. 创建 `docker-compose.yml` 文件：
```yaml
services:
  controller-1:
    image: apache/kafka:latest
    container_name: controller-1
    environment:
      KAFKA_NODE_ID: 1
      KAFKA_PROCESS_ROLES: controller
      KAFKA_LISTENERS: CONTROLLER://:9093
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@controller-1:9093,2@controller-2:9093,3@controller-3:9093
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0

  controller-2:
    image: apache/kafka:latest
    container_name: controller-2
    environment:
      KAFKA_NODE_ID: 2
      KAFKA_PROCESS_ROLES: controller
      KAFKA_LISTENERS: CONTROLLER://:9093
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@controller-1:9093,2@controller-2:9093,3@controller-3:9093
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0

  controller-3:
    image: apache/kafka:latest
    container_name: controller-3
    environment:
      KAFKA_NODE_ID: 3
      KAFKA_PROCESS_ROLES: controller
      KAFKA_LISTENERS: CONTROLLER://:9093
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@controller-1:9093,2@controller-2:9093,3@controller-3:9093
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0

  broker-1:
    image: apache/kafka:latest
    container_name: broker-1
    ports:
      - 29092:9092
    environment:
      KAFKA_NODE_ID: 4
      KAFKA_PROCESS_ROLES: broker
      KAFKA_LISTENERS: 'PLAINTEXT://:19092,PLAINTEXT_HOST://:9092'
      KAFKA_ADVERTISED_LISTENERS: 'PLAINTEXT://broker-1:19092,PLAINTEXT_HOST://localhost:29092'
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@controller-1:9093,2@controller-2:9093,3@controller-3:9093
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
    depends_on:
      - controller-1
      - controller-2
      - controller-3

  broker-2:
    image: apache/kafka:latest
    container_name: broker-2
    ports:
      - 39092:9092
    environment:
      KAFKA_NODE_ID: 5
      KAFKA_PROCESS_ROLES: broker
      KAFKA_LISTENERS: 'PLAINTEXT://:19092,PLAINTEXT_HOST://:9092'
      KAFKA_ADVERTISED_LISTENERS: 'PLAINTEXT://broker-2:19092,PLAINTEXT_HOST://localhost:39092'
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@controller-1:9093,2@controller-2:9093,3@controller-3:9093
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
    depends_on:
      - controller-1
      - controller-2
      - controller-3

  broker-3:
    image: apache/kafka:latest
    container_name: broker-3
    ports:
      - 49092:9092
    environment:
      KAFKA_NODE_ID: 6
      KAFKA_PROCESS_ROLES: broker
      KAFKA_LISTENERS: 'PLAINTEXT://:19092,PLAINTEXT_HOST://:9092'
      KAFKA_ADVERTISED_LISTENERS: 'PLAINTEXT://broker-3:19092,PLAINTEXT_HOST://localhost:49092'
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@controller-1:9093,2@controller-2:9093,3@controller-3:9093
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
    depends_on:
      - controller-1
      - controller-2
      - controller-3
```

2. 在文件目录启动集群：
```console
docker compose up -d
```

### 测试集群

#### 从 Docker 内操作
进入任一 broker 容器：
```console
docker exec --workdir /opt/kafka/bin/ -it broker-1 sh
```
执行以下命令创建主题、生产/消费消息：
```console
./kafka-topics.sh --bootstrap-server broker-1:19092,broker-2:19092,broker-3:19092 --create --topic test-topic
```
```console
./kafka-console-consumer.sh --bootstrap-server broker-1:19092,broker-2:19092,broker-3:19092 --topic test-topic --from-beginning
```
```console
./kafka-console-producer.sh --bootstrap-server broker-1:19092,broker-2:19092,broker-3:19092 --topic test-topic
```

#### 从主机操作
进入 Kafka 发行版的 `bin` 目录，执行：
```console
./kafka-topics.sh --bootstrap-server localhost:29092,localhost:39092,localhost:49092 --create --topic test-topic2
```
```console
./kafka-console-producer.sh --bootstrap-server localhost:29092,localhost:39092,localhost:49092 --topic test-topic2
```
```console
./kafka-console-consumer.sh --bootstrap-server localhost:29092,localhost:39092,localhost:49092 --topic test-topic2 --from-beginning
```

### 停止集群
```console
docker compose down
```


## 扩展资源
- [Apache Kafka 官方文档]([])
- [Kafka Streams 介绍]([])：Kafka 的 JVM 流处理库
- [Kafka Connect 介绍]([])：配置式连接器框架，支持外部系统与 Kafka 间的数据传输
- [Kafka 相关书籍与论文]([])
- [流处理会议演讲幻灯片与录像]([])
