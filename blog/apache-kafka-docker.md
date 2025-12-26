# Apache Kafka Docker 容器化部署指南

![Apache Kafka Docker 容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-kafka.png)

*分类: Docker,Kafka | 标签: kafka,docker,部署教程 | 发布时间: 2025-12-03 08:04:30*

> Apache Kafka是一个开源的分布式事件流平台，旨在高吞吐量、低延迟地处理实时数据流。它最初由LinkedIn开发，2011年开源，2012年成为Apache Software Foundation顶级项目。Kafka广泛应用于流处理、数据集成、发布/订阅消息传递等场景，全球数千家组织使用它来支持关键业务的实时应用。

## 概述

Apache Kafka是一个开源的分布式事件流平台，旨在高吞吐量、低延迟地处理实时数据流。它最初由LinkedIn开发，2011年开源，2012年成为Apache Software Foundation顶级项目。Kafka广泛应用于流处理、数据集成、发布/订阅消息传递等场景，全球数千家组织使用它来支持关键业务的实时应用。

本文档提供基于Docker容器化部署Kafka的完整方案，包括环境准备、镜像拉取、容器部署、功能测试、生产环境建议及故障排查等内容，旨在帮助用户快速实现Kafka的容器化部署与管理。


## 环境准备

### Docker安装

Kafka容器化部署依赖Docker环境，推荐使用以下一键安装脚本完成Docker及相关组件的安装：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

该脚本将自动安装Docker Engine、Docker Compose及相关依赖，并配置系统环境以优化Docker运行性能。


## 镜像准备

### 镜像信息

- **镜像名称**：apache/kafka
- **推荐标签**：latest
- **标签列表**：[Kafka镜像标签列表](https://xuanyuan.cloud/r/apache/kafka/tags)

### 拉取命令

```bash
# 拉取最新版本
docker pull xxx.xuanyuan.run/apache/kafka:latest

# 如需指定版本，将latest替换为具体标签，例如：
# docker pull xxx.xuanyuan.run/apache/kafka:3.6.1
```

### 验证镜像

拉取完成后，通过以下命令验证镜像是否成功获取：

```bash
docker images | grep apache/kafka
```

预期输出示例：
```
xxx.xuanyuan.run/apache/kafka   latest    1234abcd5678   2 weeks ago   650MB
```


## 容器部署

Kafka容器化部署支持多种模式，包括单节点快速启动、自定义配置部署及多节点集群部署，用户可根据实际需求选择合适方案。

### 1. 单节点快速启动

适用于开发测试场景，快速启动一个单节点Kafka实例（KRaft combined mode）：

```bash
docker run -d \
  --name kafka-broker \
  -p 9092:9092 \
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
  xxx.xuanyuan.run/apache/kafka:latest
```

参数说明：
- `--name kafka-broker`：指定容器名称
- `-p 9092:9092`：映射Kafka客户端通信端口
- 环境变量以`KAFKA_`为前缀，对应Kafka配置参数（原配置中的点替换为下划线）

### 2. 自定义配置部署

通过环境变量覆盖默认配置，满足特定需求。例如修改默认分区数为3：

```bash
docker run -d \
  --name kafka-custom \
  -p 9092:9092 \
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
  -e KAFKA_NUM_PARTITIONS=3 \  # 自定义默认分区数为3
  xxx.xuanyuan.run/apache/kafka:latest
```

### 3. Docker Compose部署

对于复杂配置，推荐使用Docker Compose管理容器。创建`docker-compose.yml`文件：

```yaml
version: '3.8'
services:
  broker:
    image: xxx.xuanyuan.run/apache/kafka:latest
    container_name: kafka-broker
    ports:
      - "9092:9092"
    environment:
      KAFKA_NODE_ID: 1
      KAFKA_PROCESS_ROLES: broker,controller
      KAFKA_LISTENERS: PLAINTEXT://:9092,CONTROLLER://:9093
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@localhost:9093
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
      KAFKA_NUM_PARTITIONS: 3  # 默认分区数
    volumes:
      - kafka-data:/tmp/kafka-logs  # 数据持久化
    restart: unless-stopped

volumes:
  kafka-data:  # 定义数据卷
```

启动容器：

```bash
docker compose up -d
```

### 4. 多节点集群部署

对于需要高可用性的场景，可部署多节点Kafka集群（KRaft isolated mode）。创建`docker-compose-cluster.yml`文件：

```yaml
version: '3.8'
services:
  # 控制器节点
  controller-1:
    image: xxx.xuanyuan.run/apache/kafka:latest
    container_name: kafka-controller-1
    environment:
      KAFKA_NODE_ID: 1
      KAFKA_PROCESS_ROLES: controller
      KAFKA_LISTENERS: CONTROLLER://:9093
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@kafka-controller-1:9093,2@kafka-controller-2:9093,3@kafka-controller-3:9093
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
    restart: unless-stopped

  controller-2:
    image: xxx.xuanyuan.run/apache/kafka:latest
    container_name: kafka-controller-2
    environment:
      KAFKA_NODE_ID: 2
      KAFKA_PROCESS_ROLES: controller
      KAFKA_LISTENERS: CONTROLLER://:9093
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@kafka-controller-1:9093,2@kafka-controller-2:9093,3@kafka-controller-3:9093
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
    restart: unless-stopped

  controller-3:
    image: xxx.xuanyuan.run/apache/kafka:latest
    container_name: kafka-controller-3
    environment:
      KAFKA_NODE_ID: 3
      KAFKA_PROCESS_ROLES: controller
      KAFKA_LISTENERS: CONTROLLER://:9093
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@kafka-controller-1:9093,2@kafka-controller-2:9093,3@kafka-controller-3:9093
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
    restart: unless-stopped

  #  broker节点
  broker-1:
    image: xxx.xuanyuan.run/apache/kafka:latest
    container_name: kafka-broker-1
    ports:
      - "29092:9092"
    environment:
      KAFKA_NODE_ID: 4
      KAFKA_PROCESS_ROLES: broker
      KAFKA_LISTENERS: 'PLAINTEXT://:19092,PLAINTEXT_HOST://:9092'
      KAFKA_ADVERTISED_LISTENERS: 'PLAINTEXT://kafka-broker-1:19092,PLAINTEXT_HOST://localhost:29092'
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@kafka-controller-1:9093,2@kafka-controller-2:9093,3@kafka-controller-3:9093
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
    depends_on:
      - controller-1
      - controller-2
      - controller-3
    volumes:
      - broker-1-data:/tmp/kafka-logs
    restart: unless-stopped

  broker-2:
    image: xxx.xuanyuan.run/apache/kafka:latest
    container_name: kafka-broker-2
    ports:
      - "39092:9092"
    environment:
      KAFKA_NODE_ID: 5
      KAFKA_PROCESS_ROLES: broker
      KAFKA_LISTENERS: 'PLAINTEXT://:19092,PLAINTEXT_HOST://:9092'
      KAFKA_ADVERTISED_LISTENERS: 'PLAINTEXT://kafka-broker-2:19092,PLAINTEXT_HOST://localhost:39092'
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@kafka-controller-1:9093,2@kafka-controller-2:9093,3@kafka-controller-3:9093
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
    depends_on:
      - controller-1
      - controller-2
      - controller-3
    volumes:
      - broker-2-data:/tmp/kafka-logs
    restart: unless-stopped

  broker-3:
    image: xxx.xuanyuan.run/apache/kafka:latest
    container_name: kafka-broker-3
    ports:
      - "49092:9092"
    environment:
      KAFKA_NODE_ID: 6
      KAFKA_PROCESS_ROLES: broker
      KAFKA_LISTENERS: 'PLAINTEXT://:19092,PLAINTEXT_HOST://:9092'
      KAFKA_ADVERTISED_LISTENERS: 'PLAINTEXT://kafka-broker-3:19092,PLAINTEXT_HOST://localhost:49092'
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@kafka-controller-1:9093,2@kafka-controller-2:9093,3@kafka-controller-3:9093
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
    depends_on:
      - controller-1
      - controller-2
      - controller-3
    volumes:
      - broker-3-data:/tmp/kafka-logs
    restart: unless-stopped

volumes:
  broker-1-data:
  broker-2-data:
  broker-3-data:
```

启动集群：

```bash
docker compose -f docker-compose-cluster.yml up -d
```

### 验证部署

无论采用哪种部署方式，均可通过以下命令验证容器状态：

```bash
# 单节点/Compose单节点
docker ps | grep kafka-broker

# 多节点集群
docker compose -f docker-compose-cluster.yml ps
```

健康容器的状态应为`Up`。


## 功能测试

### 1. 单节点测试

#### 进入容器

```bash
docker exec -it kafka-broker /bin/sh
```

#### 创建测试主题

```bash
# 切换到Kafka命令目录
cd /opt/kafka/bin

# 创建名为test-topic的主题，1个分区，1个副本
./kafka-topics.sh --bootstrap-server localhost:9092 --create --topic test-topic --partitions 1 --replication-factor 1
```

预期输出：
```
Created topic test-topic.
```

#### 查看主题列表

```bash
./kafka-topics.sh --bootstrap-server localhost:9092 --list
```

预期输出：
```
test-topic
```

#### 生产消息

打开新终端，启动生产者：

```bash
docker exec -it kafka-broker /opt/kafka/bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic test-topic
```

在生产者终端输入测试消息：
```
Hello Kafka!
This is a test message.
^C  # 按Ctrl+C退出
```

#### 消费消息

打开新终端，启动消费者（--from-beginning表示从开头消费）：

```bash
docker exec -it kafka-broker /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test-topic --from-beginning
```

预期输出：
```
Hello Kafka!
This is a test message.
^C  # 按Ctrl+C退出
```

### 2. 多节点集群测试

#### 从容器内访问

```bash
# 进入broker-1容器
docker exec -it kafka-broker-1 /bin/sh

# 创建跨节点主题（3个分区，2个副本）
cd /opt/kafka/bin
./kafka-topics.sh --bootstrap-server kafka-broker-1:19092,kafka-broker-2:19092,kafka-broker-3:19092 --create --topic cluster-topic --partitions 3 --replication-factor 2
```

#### 从主机访问

需先[下载Kafka发行版](https://kafka.apache.org/downloads)并解压，然后使用本地命令行工具：

```bash
# 创建主题
./kafka-topics.sh --bootstrap-server localhost:29092,localhost:39092,localhost:49092 --create --topic host-topic --partitions 3 --replication-factor 2

# 生产消息
./kafka-console-producer.sh --bootstrap-server localhost:29092,localhost:39092,localhost:49092 --topic host-topic

# 消费消息（新终端）
./kafka-console-consumer.sh --bootstrap-server localhost:29092,localhost:39092,localhost:49092 --topic host-topic --from-beginning
```


## 生产环境建议

Docker容器化部署Kafka在生产环境中需特别注意以下配置：

### 1. 数据持久化

Kafka数据必须持久化到宿主机，避免容器重启导致数据丢失：

```yaml
# docker-compose.yml中添加
volumes:
  - /data/kafka:/tmp/kafka-logs  # /data/kafka为宿主机目录
```

### 2. 资源限制

为Kafka容器分配合理的资源，避免资源竞争：

```yaml
# docker-compose.yml中添加
deploy:
  resources:
    limits:
      cpus: '4'        # 限制CPU核心数
      memory: 8G       # 限制内存
    reservations:
      cpus: '2'        # 保留CPU核心数
      memory: 4G       # 保留内存
```

### 3. 网络配置

- 使用自定义网络隔离Kafka服务
- 配置固定IP或主机名，确保集群通信稳定
- 避免使用主机网络模式，增强安全性

### 4. 安全设置

- 启用Kafka认证机制（SASL/SSL）
- 配置ACL控制主题访问权限
- 限制容器capabilities，遵循最小权限原则

```yaml
# 示例：限制容器权限
cap_add:
  - NET_BIND_SERVICE
cap_drop:
  - ALL
```

### 5. 监控集成

- 暴露JMX端口，集成Prometheus+Grafana监控
- 配置日志驱动，将日志输出到集中式日志系统

```yaml
# 日志配置示例
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

### 6. 高可用配置

- 部署至少3个broker节点
- 关键主题（如__consumer_offsets）副本数设置为3
- 启用控制器冗余，避免单点故障


## 故障排查

### 常见问题及解决方法

#### 1. 容器启动失败

**症状**：`docker ps`显示容器状态为`Exited`

**排查步骤**：
1. 查看容器日志：
   ```bash
   docker logs kafka-broker
   ```
2. 常见原因及解决：
   - **端口冲突**：检查9092/9093端口是否被占用，更换映射端口
   - **配置错误**：环境变量配置不当，特别是KAFKA_LISTENERS和KAFKA_ADVERTISED_LISTENERS
   - **数据目录权限**：宿主机挂载目录权限不足，执行`chmod 777 /data/kafka`临时测试（生产环境需配置更精细权限）

#### 2. 主题创建失败

**症状**：执行kafka-topics.sh提示连接错误

**排查步骤**：
```bash
# 检查网络连通性
docker exec -it kafka-broker ping localhost -c 3

# 检查Kafka进程状态
docker exec -it kafka-broker jps | grep Kafka
```

预期输出应包含`Kafka`进程。

#### 3. 外部客户端无法连接

**症状**：宿主机/其他机器无法连接Kafka

**解决方法**：
- 确保KAFKA_ADVERTISED_LISTENERS配置正确（外部可访问的地址）
- 检查宿主机防火墙是否开放映射端口
- 多节点集群需确保PLAINTEXT_HOST监听器配置正确

#### 4. 性能问题

**症状**：消息生产/消费延迟高

**优化方向**：
- 增加内存分配，调整JVM参数：
  ```bash
  -e KAFKA_HEAP_OPTS="-Xms4G -Xmx4G"
  ```
- 调整分区数，提高并行处理能力
- 优化磁盘IO，使用SSD存储


## 参考资源

- [Kafka镜像文档（轩辕）](https://xuanyuan.cloud/r/apache/kafka)
- [Kafka镜像标签列表](https://xuanyuan.cloud/r/apache/kafka/tags)
- [Apache Kafka官方文档](https://kafka.apache.org/documentation/)
- [Kafka Docker镜像使用指南](https://github.com/apache/kafka/blob/trunk/docker/examples/README.md)
- [Docker Compose官方文档](https://docs.docker.com/compose/)


## 总结

本文详细介绍了Apache Kafka的Docker容器化部署方案，涵盖环境准备、镜像拉取、多种部署模式、功能测试、生产环境配置及故障排查等内容。通过容器化部署，用户可快速搭建Kafka服务，降低环境配置复杂度，同时保持良好的可扩展性。

**关键要点**：
- 使用轩辕镜像访问支持可显著提升国内环境下的镜像下载访问表现
- 单节点部署适合开发测试，多节点集群适合生产环境
- 生产环境必须配置数据持久化、资源限制和安全措施
- 功能测试需验证主题管理、消息生产和消费全流程

**后续建议**：
- 深入学习Kafka架构原理，理解分区、副本、消费者组等核心概念
- 根据业务吞吐量需求，优化Kafka配置参数（如批处理大小、压缩策略等）
- 研究Kafka Streams和Kafka Connect，扩展流处理和数据集成能力
- 建立完善的监控告警体系，及时发现并解决集群问题
- 制定数据备份和灾难恢复策略，确保业务连续性

通过合理配置和持续优化，Docker容器化的Kafka可稳定支持大规模实时数据处理场景，为业务提供高效可靠的消息传递基础设施。

