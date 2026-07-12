---
image: openzipkin/zipkin
description: "Zipkin分布式追踪系统的官方镜像，用于实现分布式系统的追踪功能。"
source: https://xuanyuan.cloud/zh/r/openzipkin/zipkin
canonical: https://xuanyuan.cloud/zh/r/openzipkin/zipkin
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openzipkin/zipkin" title="openzipkin/zipkin Docker 镜像中文简介、标签列表与拉取命令">openzipkin/zipkin 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Zipkin Docker镜像文档


## 1. 镜像概述和主要用途

Zipkin 是一个分布式追踪系统，用于收集和查询服务架构中排查延迟问题所需的时序数据。本镜像为 Zipkin 官方权威镜像，提供开箱即用的分布式追踪能力，支持通过跟踪 ID 或属性（如服务名、操作名、标签、持续时间）查询追踪数据，并通过 Web UI 直观展示追踪详情与服务依赖关系。


## 2. 核心功能和特性

### 2.1 追踪数据收集与查询
- 支持通过跟踪 ID 直接定位追踪记录，或通过服务名、操作名、标签等属性筛选查询
- 自动汇总关键指标，如服务耗时占比、操作失败率等

### 2.2 直观的 UI 展示
- 提供追踪详情视图，展示请求链路中的各服务耗时、状态等信息（如图1）
- 生成依赖关系图，显示追踪请求流经的服务路径，帮助识别错误路径或过时服务调用（如图2）

### 2.3 多数据上报方式
- 支持 HTTP、Kafka、Apache ActiveMQ、gRPC、RabbitMQ 等多种数据上报协议
- 需通过 [追踪器或 instrumentation 库](https://zipkin.io/pages/tracers_instrumentation.html) 对应用进行埋点

### 2.4 灵活的存储后端
- 内置内存存储（默认，非持久化）
- 支持持久化存储：Apache Cassandra、Elasticsearch 等
- 存储组件设计轻量，多数需 Java 8+ 环境

### 2.5 轻量级核心库
- 核心库（`zipkin2`）最小支持 Java 6，避免与应用依赖冲突
- 内置 Zipkin v1/v2 JSON 格式编解码器，jar 体积仅 155k


## 3. 使用场景和适用范围

### 3.1 典型使用场景
- **微服务架构监控**：跟踪分布式系统中服务间的调用链路
- **延迟问题排查**：通过追踪数据定位服务调用中的瓶颈环节
- **依赖关系分析**：识别服务间的调用模式，发现不合理依赖或错误路径
- **分布式系统调试**：结合日志快速定位跨服务请求的异常原因

### 3.2 适用范围
- 需监控服务间通信的分布式系统（如微服务、SOA 架构）
- 应用需集成 Zipkin instrumentation 库以上报追踪数据
- 支持单机测试（内存存储）或生产环境（持久化存储如 Cassandra/Elasticsearch）


## 4. 使用方法和配置说明

### 4.1 快速启动

#### 4.1.1 Docker 启动（推荐）
```bash
docker run -d -p 9411:9411 --name zipkin docker.xuanyuan.run/openzipkin/zipkin
```
- 端口说明：`9411` 为 Zipkin 服务端口（Web UI 与 API 共用）
- 访问 UI：启动后通过 `http://<主机IP>:9411/zipkin/` 访问 Web 界面


#### 4.1.2 从 JAR 包启动（参考）
```bash
# 下载最新版可执行 JAR（需 JRE 8+）
curl -sSL https://zipkin.io/quickstart.sh | bash -s
# 启动服务
java -jar zipkin.jar
```


### 4.2 Zipkin Slim 版本

Slim 版本体积更小、启动更快，仅支持内存和 Elasticsearch 存储，不支持 Kafka/RabbitMQ 等消息传输。

#### 4.2.1 Docker 启动 Slim 版本
```bash
docker run -d -p 9411:9411 --name zipkin-slim docker.xuanyuan.run/openzipkin/zipkin-slim
```

#### 4.2.2 从 JAR 包启动 Slim 版本
```bash
curl -sSL https://zipkin.io/quickstart.sh | bash -s io.zipkin:zipkin-server:LATEST:slim zipkin.jar
java -jar zipkin.jar
```


### 4.3 存储配置

#### 4.3.1 内存存储（默认）
- 特点：无需额外依赖，服务重启后数据丢失
- 适用场景：本地测试、临时验证

#### 4.3.2 Apache Cassandra
- **要求**：Cassandra 3.11.3+（推荐最新 3.11.x 补丁版）
- **配置方式**：通过环境变量指定存储类型及连接信息
  ```bash
  docker run -d -p 9411:9411 \
    -e STORAGE_TYPE=cassandra \
    -e CASSANDRA_CONTACT_POINTS=cassandra-host1,cassandra-host2 \
    docker.xuanyuan.run/openzipkin/zipkin
  ```
- **注意**：需通过 [zipkin-dependencies](https://github.com/openzipkin/zipkin-dependencies) 任务聚合依赖关系


#### 4.3.3 Elasticsearch
- **要求**：Elasticsearch 5+（测试支持 6-7.x）
- **配置方式**：
  ```bash
  docker run -d -p 9411:9411 \
    -e STORAGE_TYPE=elasticsearch \
    -e ES_HOSTS=http://elasticsearch:9200 \
    docker.xuanyuan.run/openzipkin/zipkin
  ```
- **注意**：需通过 [zipkin-dependencies](https://github.com/openzipkin/zipkin-dependencies) Spark 任务聚合依赖关系


## 4.4 禁用搜索功能

默认启用搜索功能（支持 UI 追踪列表页操作），禁用后仅允许通过追踪 ID 查询（`GET /trace/{traceId}`），可降低存储成本或提升写入性能。

### 配置方式
通过环境变量 `SEARCH_ENABLED=false` 禁用：
```bash
docker run -d -p 9411:9411 -e SEARCH_ENABLED=false docker.xuanyuan.run/openzipkin/zipkin
```

### 禁用后影响
- 不可访问以下搜索相关 API：`/services`、`/remoteServices`、`/spans`、`/autocompleteKeys`、`/autocompleteValues`、`/traces`
- 仅支持通过追踪 ID 访问 `/trace/{traceId}` 获取详情


## 4.5 环境变量配置

| 环境变量         | 说明                                                                 | 默认值       |
|------------------|----------------------------------------------------------------------|--------------|
| `STORAGE_TYPE`   | 存储类型：`mem`（内存）、`cassandra`、`elasticsearch`                | `mem`        |
| `SEARCH_ENABLED` | 是否启用搜索功能：`true`/`false`                                     | `true`       |
| `CASSANDRA_CONTACT_POINTS` | Cassandra 节点地址，逗号分隔                               | `localhost`  |
| `ES_HOSTS`       | Elasticsearch 地址，逗号分隔（如 `http://es1:9200,http://es2:9200`） | `http://localhost:9200` |


## 5. 部署示例

### 5.1 Docker Compose 基础示例（Elasticsearch 存储）
```yaml
version: '3'
services:
  zipkin:
    image: docker.xuanyuan.run/openzipkin/zipkin
    ports:
      - "9411:9411"
    environment:
      - STORAGE_TYPE=elasticsearch
      - ES_HOSTS=http://elasticsearch:9200
    depends_on:
      - elasticsearch

  elasticsearch:
    image: docker.xuanyuan.run/elasticsearch:7.17.0
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    ports:
      - "9200:9200"
```


## 6. 存储组件详情

### 6.1 内存存储（`mem`）
- **特点**：无需外部依赖，启动快，数据非持久化
- **限制**：不适合生产环境，重启后数据丢失
- **适用场景**：本地开发、功能验证


### 6.2 Apache Cassandra
- **版本要求**：3.11.3+（推荐最新 3.11.x 补丁版）
- **数据模型**：使用 UDT 存储 Span，兼容 Zipkin v2 JSON 格式
- **索引优化**：结合 SASI 索引和手动索引，提升大规模数据查询性能
- **依赖聚合**：需独立部署 [zipkin-dependencies](https://github.com/openzipkin/zipkin-dependencies) 任务生成依赖关系


### 6.3 Elasticsearch
- **版本要求**：5+（测试支持 6-7.x）
- **数据模型**：直接存储 Zipkin v2 JSON 格式 Span，便于与其他工具集成
- **索引策略**：结合自定义索引和手动索引优化，支持大规模数据查询
- **依赖聚合**：需通过 [zipkin-dependencies](https://github.com/openzipkin/zipkin-dependencies) Spark 任务聚合依赖关系


## 7. 制品信息

### 7.1 Maven 坐标
- 服务端：`io.zipkin:zipkin-server`
- 核心库：`io.zipkin.zipkin2:zipkin`


### 7.2 Docker 镜像
- 标准版：`openzipkin/zipkin`（[Docker Hub](https://hub.docker.com/r/openzipkin/zipkin)）
- Slim 版：`openzipkin/zipkin-slim`


### 7.3 文档资源
- [官方文档](https://zipkin.io/)
- [Javadocs](https://zipkin.io/zipkin)（包含各版本 API 文档）
- [GitHub 仓库](https://github.com/openzipkin/zipkin)


**图1：Zipkin 追踪详情视图**  
![Trace view screenshot](https://zipkin.io/public/img/web-screenshot.png)

**图2：Zipkin 依赖关系图**  
![Dependency graph screenshot](https://zipkin.io/public/img/dependency-graph.png)
