---
image: danielqsj/kafka-exporter
description: "用于Prometheus的Kafka指标导出工具，可收集Kafka集群运行指标并提供给Prometheus监控系统。"
source: https://xuanyuan.cloud/zh/r/danielqsj/kafka-exporter
canonical: https://xuanyuan.cloud/zh/r/danielqsj/kafka-exporter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/danielqsj/kafka-exporter" title="danielqsj/kafka-exporter Docker 镜像中文简介、标签列表与拉取命令">danielqsj/kafka-exporter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# kafka_exporter

## 镜像概述与主要用途

kafka_exporter是一个用于Prometheus的Kafka指标导出器，能够收集Kafka集群的关键指标（如Broker状态、Topic分区信息、消费者组滞后等），并通过HTTP端点暴露给Prometheus进行监控。对于Kafka的其他JMX指标，可结合[JMX Exporter](https://github.com/prometheus/jmx_exporter)使用。


## 核心功能与特性

- **多维度指标收集**：支持Broker、Topic、Consumer Group三个层级的指标采集
- **灵活的配置选项**：支持多Kafka服务器配置、SASL/TLS认证、元数据刷新间隔调整等
- **Docker化部署**：提供官方Docker镜像，支持快速部署与集成
- **Prometheus兼容**：暴露标准Prometheus指标格式，支持无缝接入监控系统
- **Grafana集成**：提供专用Grafana仪表板模板，支持可视化监控


## 兼容性

支持[Apache Kafka](https://kafka.apache.org) 0.10.1.0及更高版本。


## 依赖环境

- [Prometheus](https://prometheus.io)（指标收集与存储）
- [Sarama](https://shopify.github.io/sarama)（Kafka客户端库）
- [Golang](https://golang.org)（编译环境，如自行构建）


## 使用场景与适用范围

适用于需要对Kafka集群进行实时监控的场景，包括：
- 生产环境Kafka集群状态监控（Broker可用性、分区同步状态等）
- Topic健康度监控（分区数量、偏移量趋势、副本同步情况）
- 消费者组性能监控（消费滞后量、偏移量提交状态）
- 结合Prometheus告警规则实现异常状态告警
- 与Grafana配合构建可视化监控面板


## 使用方法与配置说明

### 镜像获取

```bash
# 拉取最新版本
docker pull docker.xuanyuan.run/danielqsj/kafka-exporter:latest

# 拉取指定版本（如1.4.1）
docker pull docker.xuanyuan.run/danielqsj/kafka-exporter:1.4.1
```


### 快速启动（Docker Run）

#### 基础配置（单Kafka节点）
```bash
docker run -d \
  --name kafka-exporter \
  -p 9308:9308 \
  docker.xuanyuan.run/danielqsj/kafka-exporter:latest \
  --kafka.server=kafka:9092 \  # Kafka服务器地址
  --web.listen-address=:9308    # 监听地址（默认:9308）
```

#### 高级配置（多Kafka节点+SASL认证）
```bash
docker run -d \
  --name kafka-exporter \
  -p 9308:9308 \
  docker.xuanyuan.run/danielqsj/kafka-exporter:latest \
  --kafka.server=kafka-1:9092 \
  --kafka.server=kafka-2:9092 \  # 配置多个Kafka节点
  --sasl.enabled=true \          # 启用SASL认证
  --sasl.username=admin \        # SASL用户名
  --sasl.password=secret \       # SASL密码
  --sasl.mechanism=scram-sha512  # SASL认证机制
```


### Docker Compose配置示例

```yaml
version: '3.8'
services:
  kafka-exporter:
    image: docker.xuanyuan.run/danielqsj/kafka-exporter:latest
    container_name: kafka-exporter
    ports:
      - "9308:9308"
    command:
      - --kafka.server=kafka-1:9092
      - --kafka.server=kafka-2:9092
      - --web.listen-address=:9308
      - --refresh.metadata=60s  # 元数据刷新间隔
      - --kafka.labels=prod-cluster  # 集群标识标签
      - --topic.filter=^prod-.*  # 仅监控prod前缀的topic
    restart: unless-stopped
    networks:
      - kafka-network

networks:
  kafka-network:
    external: true
```


## 配置参数详解

### 核心配置参数

| 参数名称                     | 默认值              | 描述                                                                 |
|------------------------------|---------------------|----------------------------------------------------------------------|
| `kafka.server`               | `kafka:9092`        | Kafka服务器地址（支持多次指定，配置多个节点）                         |
| `kafka.version`              | `1.0.0`             | Kafka broker版本（用于协议适配）                                     |
| `web.listen-address`         | `:9308`             | Web服务监听地址（用于暴露指标）                                      |
| `web.telemetry-path`         | `/metrics`          | 指标暴露路径                                                         |
| `refresh.metadata`           | `30s`               | Kafka元数据刷新间隔（如topic列表、分区信息）                         |
| `kafka.labels`               | 空                  | Kafka集群名称标签（用于多集群监控区分）                              |
| `topic.filter`               | `.*`                |  topic过滤正则表达式（仅匹配的topic会被监控）                        |
| `group.filter`               | `.*`                | 消费者组过滤正则表达式（仅匹配的组会被监控）                         |


### 安全认证参数

| 参数名称                     | 默认值              | 描述                                                                 |
|------------------------------|---------------------|----------------------------------------------------------------------|
| `sasl.enabled`               | `false`             | 是否启用SASL认证                                                     |
| `sasl.username`              | 空                  | SASL认证用户名（启用时必填）                                         |
| `sasl.password`              | 空                  | SASL认证密码（启用时必填）                                           |
| `sasl.mechanism`             | 空                  | SASL认证机制（支持`plain`、`scram-sha512`、`scram-sha256`）          |
| `sasl.handshake`             | `true`              | 是否启用SASL握手（非Kafka SASL代理时需禁用）                         |
| `tls.enabled`                | `false`             | 是否启用TLS加密连接                                                 |
| `tls.ca-file`                | 空                  | TLS根证书文件路径（可选）                                            |
| `tls.cert-file`              | 空                  | TLS客户端证书文件路径（可选）                                        |
| `tls.key-file`               | 空                  | TLS客户端密钥文件路径（可选）                                        |
| `tls.insecure-skip-tls-verify` | `false`           | 是否跳过TLS证书验证（测试环境使用，生产环境不建议）                  |


### 高级配置参数

| 参数名称                     | 默认值              | 描述                                                                 |
|------------------------------|---------------------|----------------------------------------------------------------------|
| `use.consumelag.zookeeper`   | `false`             | 是否从ZooKeeper获取消费者组偏移量（适用于旧版Kafka）                 |
| `zookeeper.server`           | `localhost:2181`    | ZooKeeper服务器地址（当`use.consumelag.zookeeper=true`时生效）       |
| `offset.show-all`            | `true`              | 是否显示所有消费者组的偏移量/滞后量（禁用时仅显示活跃组）            |
| `concurrent.enable`          | `false`             | 是否启用并发指标采集（大型集群建议禁用，避免性能影响）               |
| `topic.workers`              | `100`               | Topic处理工作线程数                                                  |
| `log.enable-sarama`          | `false`             | 是否启用Sarama客户端日志（调试用）                                   |
| `verbosity`                  | `0`                 | 日志详细程度（0=默认，数值越高日志越详细）                           |


### 参数使用说明

- **布尔值参数**：采用`--<name>`启用和`--no-<name>`禁用的形式。例如：
  - 启用SASL握手：`--sasl.handshake`
  - 禁用SASL握手：`--no-sasl.handshake`

- **多值参数**：`kafka.server`支持多次指定，用于监控多节点集群，如`--kafka.server=node1:9092 --kafka.server=node2:9092`


## 导出指标说明

### Broker指标

| 指标名称               | 描述                     | 类型    |
|------------------------|--------------------------|---------|
| `kafka_brokers`        | Kafka集群中的Broker数量  | Gauge   |

**示例输出**：
```txt
# HELP kafka_brokers Number of Brokers in the Kafka Cluster.
# TYPE kafka_brokers gauge
kafka_brokers 3
```


### Topic指标

| 指标名称                                       | 描述                                      | 类型    |
|----------------------------------------------|-------------------------------------------|---------|
| `kafka_topic_partitions`                      | Topic的分区数量                           | Gauge   |
| `kafka_topic_partition_current_offset`        | Topic分区当前偏移量                       | Gauge   |
| `kafka_topic_partition_oldest_offset`         | Topic分区最旧偏移量                       | Gauge   |
| `kafka_topic_partition_in_sync_replica`       | Topic分区的同步副本数量                   | Gauge   |
| `kafka_topic_partition_leader`                | Topic分区的Leader Broker ID               | Gauge   |
| `kafka_topic_partition_leader_is_preferred`   | 是否使用首选Leader（1=是，0=否）          | Gauge   |
| `kafka_topic_partition_replicas`              | Topic分区的副本总数                       | Gauge   |
| `kafka_topic_partition_under_replicated_partition` | 是否为欠复制分区（1=是，0=否）        | Gauge   |

**示例输出**：
```txt
# HELP kafka_topic_partitions Number of partitions for this Topic
# TYPE kafka_topic_partitions gauge
kafka_topic_partitions{topic="order-events"} 8

# HELP kafka_topic_partition_in_sync_replica Number of In-Sync Replicas for this Topic/Partition
# TYPE kafka_topic_partition_in_sync_replica gauge
kafka_topic_partition_in_sync_replica{partition="0",topic="order-events"} 3
```


### 消费者组指标

| 指标名称                                   | 描述                                      | 类型    |
|------------------------------------------|-------------------------------------------|---------|
| `kafka_consumergroup_current_offset`     | 消费者组在指定分区的当前偏移量            | Gauge   |
| `kafka_consumergroup_lag`                | 消费者组在指定分区的滞后量（当前偏移与最新偏移差） | Gauge |

**示例输出**：
```txt
# HELP kafka_consumergroup_lag Current Approximate Lag of a ConsumerGroup at Topic/Partition
# TYPE kafka_consumergroup_lag gauge
kafka_consumergroup_lag{consumergroup="order-service",partition="0",topic="order-events"} 42
```


## Grafana仪表板

官方提供Grafana仪表板模板，支持快速构建可视化监控面板：
- **仪表板ID**：7589
- **名称**：Kafka Exporter Overview
- **获取地址**：[Grafana Dashboard 7589](https://grafana.com/dashboards/7589)

**使用方法**：在Grafana中导入仪表板ID，配置Prometheus数据源即可查看预设监控视图。


## 许可证

本项目基于[Apache License 2.0](https://github.com/danielqsj/kafka_exporter/blob/master/LICENSE)开源。
