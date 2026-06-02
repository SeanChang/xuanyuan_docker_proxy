---
image: jaegertracing/jaeger-collector
description: "Jaeger Collector是Jaeger分布式追踪系统的核心组件，用于接收来自SDK的追踪数据并将其标准化、处理后发送到指定的存储系统，实现追踪数据的集中收集与持久化。"
source: https://xuanyuan.cloud/zh/r/jaegertracing/jaeger-collector
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[jaegertracing/jaeger-collector](https://xuanyuan.cloud/zh/r/jaegertracing/jaeger-collector)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Jaeger Collector 镜像文档

## 镜像概述
Jaeger Collector是Jaeger分布式追踪系统的关键组件，负责接收来自应用程序SDK（如Jaeger Client）发送的追踪数据（跨度Span），对数据进行验证、标准化和聚合处理后，将其持久化到后端存储系统（如Elasticsearch、Cassandra、Kafka等）。该镜像提供了开箱即用的Collector服务，支持云原生环境部署，是构建分布式系统可观测性的重要工具。

## 核心功能与特性
### 1. 多协议数据接收
- 支持通过gRPC协议（默认端口14250/tcp）接收来自SDK的追踪数据
- 支持通过HTTP协议（默认端口14268/tcp）接收Jaeger Thrift格式的追踪数据
- 兼容OpenTelemetry协议，可接收OpenTelemetry SDK发送的追踪数据

### 2. 数据处理能力
- 内置数据验证机制，过滤无效或格式错误的追踪数据
- 支持追踪数据采样（基于配置的采样策略）
- 可选的追踪数据聚合与批处理，优化存储写入性能

### 3. 多存储后端支持
- 支持主流存储系统：Elasticsearch、Cassandra、Kafka、PostgreSQL等
- 可配置为"转发模式"，将数据发送到其他Collector或第三方系统
- 支持存储后端的水平扩展配置

### 4. 高可用性设计
- 无状态服务设计，支持多实例水平扩展
- 内置健康检查接口，便于容器编排平台（如Kubernetes）进行实例管理
- 支持数据重试机制，确保存储写入可靠性

## 使用场景
- **微服务架构**：在微服务集群中集中收集各服务间的调用追踪数据
- **云原生应用**：配合Kubernetes等容器编排平台，实现容器化应用的追踪数据收集
- **分布式系统调试**：通过集中存储的追踪数据，分析系统性能瓶颈、故障定位及服务依赖关系
- **可观测性平台集成**：作为追踪数据管道，与监控（Prometheus）、日志（ELK）系统联动，构建完整可观测性体系

## 使用方法与配置说明

### 基本部署（Docker Run）
```bash
docker run -d \
  --name jaeger-collector \
  -p 14250:14250/tcp \  # gRPC接收端口
  -p 14268:14268/tcp \  # HTTP接收端口
  -e SPAN_STORAGE_TYPE=elasticsearch \  # 指定存储类型
  -e ES_SERVER_URLS=http://elasticsearch:9200 \  # Elasticsearch服务地址
  jaegertracing/jaeger-collector:latest
```

### 环境变量配置
| 环境变量 | 描述 | 示例值 | 必填 |
|----------|------|--------|------|
| `SPAN_STORAGE_TYPE` | 指定后端存储类型 | `elasticsearch`、`cassandra`、`kafka` | 是 |
| `ES_SERVER_URLS` | Elasticsearch服务地址（当SPAN_STORAGE_TYPE=elasticsearch时） | `http://es-node1:9200,http://es-node2:9200` | 否（依存储类型而定） |
| `CASSANDRA_SERVERS` | Cassandra服务地址（当SPAN_STORAGE_TYPE=cassandra时） | `cassandra-node1:9042,cassandra-node2:9042` | 否（依存储类型而定） |
| `KAFKA_BROKERS` | Kafka broker地址（当SPAN_STORAGE_TYPE=kafka时） | `kafka-node1:9092,kafka-node2:9092` | 否（依存储类型而定） |
| `COLLECTOR_HTTP_PORT` | HTTP接收端口 | `14268` | 否（默认14268） |
| `COLLECTOR_GRPC_PORT` | gRPC接收端口 | `14250` | 否（默认14250） |
| `LOG_LEVEL` | 日志级别 | `debug`、`info`、`warn`、`error` | 否（默认info） |

### 自定义配置文件
如需更复杂的配置（如采样策略、数据处理规则等），可通过挂载配置文件进行自定义：
```bash
docker run -d \
  --name jaeger-collector \
  -p 14250:14250 \
  -p 14268:14268 \
  -v /path/to/collector-config.yaml:/etc/jaeger/collector-config.yaml \
  jaegertracing/jaeger-collector:latest \
  --config-file=/etc/jaeger/collector-config.yaml
```

配置文件示例（collector-config.yaml）：
```yaml
receivers:
  jaeger:
    protocols:
      grpc:
        endpoint: 0.0.0.0:14250
      thrift_http:
        endpoint: 0.0.0.0:14268
processors:
  batch:
    timeout: 5s
    send_batch_size: 1000
exporters:
  elasticsearch:
    endpoints: ["http://elasticsearch:9200"]
    index: jaeger-span-%{date:yyyy-MM-dd}
service:
  pipelines:
    traces:
      receivers: [jaeger]
      processors: [batch]
      exporters: [elasticsearch]
```

## 部署示例（docker-compose）
以下示例展示如何使用docker-compose部署Jaeger Collector与Elasticsearch存储后端：

```yaml
version: '3.8'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.17.0
    environment:
      - discovery.type=single-node
      - ES_JAVA_OPTS=-Xms512m -Xmx512m
    ports:
      - "9200:9200"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9200/_cluster/health"]
      interval: 10s
      timeout: 10s
      retries: 5

  jaeger-collector:
    image: jaegertracing/jaeger-collector:latest
    depends_on:
      elasticsearch:
        condition: service_healthy
    environment:
      - SPAN_STORAGE_TYPE=elasticsearch
      - ES_SERVER_URLS=http://elasticsearch:9200
      - LOG_LEVEL=info
    ports:
      - "14250:14250"  # gRPC接收端口
      - "14268:14268"  # HTTP接收端口
      - "14269:14269"  # 健康检查端口
    restart: unless-stopped
```

启动命令：`docker-compose up -d`

## 注意事项
- 生产环境中建议为Collector配置多个实例以实现高可用
- 根据存储后端性能调整批处理参数（如send_batch_size、timeout）以优化写入性能
- 对于大规模部署，建议使用Kafka作为缓冲层，避免存储后端压力过大
- 定期清理过期追踪数据，避免存储容量耗尽（可通过存储后端的索引生命周期管理实现）
