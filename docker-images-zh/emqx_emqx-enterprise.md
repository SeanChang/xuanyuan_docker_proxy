---
image: emqx/emqx-enterprise
description: "EMQX Enterprise的官方Docker镜像，这是一个高性能、可扩展的企业级MQTT平台，支持连接数百万IoT设备并实时处理消息，适用于AI、IoT和工业物联网等场景。"
source: https://xuanyuan.cloud/zh/r/emqx/emqx-enterprise
canonical: https://xuanyuan.cloud/zh/r/emqx/emqx-enterprise
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/emqx/emqx-enterprise" title="emqx/emqx-enterprise Docker 镜像中文简介、标签列表与拉取命令">emqx/emqx-enterprise — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/emqx/emqx-enterprise" title="emqx/emqx-enterprise Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/emqx/emqx-enterprise</a>

# EMQX Enterprise 概述

## 官方Docker镜像 [网站](https://www.emqx.com/zh/products/emqx) | [文档](https://docs.emqx.com/zh/emqx/latest/) | [GitHub](https://github.com/emqx/emqx) | [Slack](https://slack-invite.emqx.io/) | [Discord](https://discord.gg/xYGf3fQnES)

支持的架构：`amd64`、`arm64v8`

## 概述

EMQX 是世界上最具可扩展性和可靠性的 MQTT 平台，专为高性能、可靠和安全的 IoT 数据基础设施设计。它支持 MQTT 5.0、3.1.1 和 3.1，以及 MQTT-SN、CoAP、LwM2M、MQTT over QUIC 等其他协议。EMQX 能够连接数百万 IoT 设备，实时处理和路由消息，并与各类后端数据系统集成。它适用于 AI、IoT、工业物联网（IIoT）、联网车辆、智慧城市等领域的应用。

### 统一功能与新许可证（v5.9.0+）

从 5.9.0 版本开始，EMQX 统一了功能并采用商业源代码许可证（BSL）1.1。这意味着所有功能（包括强大的数据集成、流设计器、高级可观测性和企业级安全性）现在都在单个 Docker 镜像中可用。

了解更多许可证变更：
* 新闻：[EMQX 采用 BSL](https://www.emqx.com/zh/news/emqx-adopts-business-source-license)
* 博客：[我们为何采用 BSL](https://www.emqx.com/zh/blog/adopting-business-source-license-to-accelerate-mqtt-and-ai-innovation)
* [许可证常见问题](https://www.emqx.com/zh/content/license-faq)

**重要提示：集群需要许可证密钥（v5.9.0+）！**

在 BSL 1.1 许可下，部署 EMQX 集群（超过 1 个节点）需加载许可证密钥，即使是 BSL 允许的免费/开发用例也不例外。有关获取和应用许可证的详细信息，请参阅许可证常见问题和许可证文档。

## 核心功能

EMQX 为现代连接系统提供以下关键能力：

### 全面的协议支持

- 完整支持 MQTT v5.0、v3.1.1 和 v3.1。
- [MQTT over QUIC](https://docs.emqx.com/zh/emqx/latest/mqtt-over-quic/introduction.html)：利用 QUIC 协议优势，实现更快的连接建立、减少队头阻塞和无缝连接迁移。
- 通过 [网关](https://docs.emqx.com/zh/emqx/latest/gateway/gateway.html) 支持 [LwM2M](https://docs.emqx.com/zh/emqx/latest/gateway/lwm2m.html)、[CoAP](https://docs.emqx.com/zh/emqx/latest/gateway/coap.html)、[MQTT-SN](https://docs.emqx.com/zh/emqx/latest/gateway/mqttsn.html) 等其他 IoT 协议。

### 大规模可扩展性与高可用性

- [连接](https://www.emqx.com/zh/solutions/iot-device-connectivity) 1 亿+并发 MQTT 客户端（单集群）。
- [处理](https://www.emqx.com/zh/solutions/reliable-mqtt-messaging) 每秒数百万条消息，延迟亚毫秒级。
- [无主集群](https://docs.emqx.com/zh/emqx/latest/deploy/cluster/introduction.html) 架构，确保高可用性和容错能力。
- 通过 [EMQX 集群链接](https://www.emqx.com/zh/solutions/cluster-linking) 实现无缝全局通信。

### 强大的规则引擎与数据集成

- 基于 SQL 的 [规则引擎](https://www.emqx.com/zh/solutions/mqtt-data-processing)，用于实时处理、转换、丰富和过滤流转数据。
- 与 50+ 云服务和企业系统无缝数据桥接及 [集成](https://www.emqx.com/zh/solutions/mqtt-data-integration)，包括：
  - **消息队列**：[Kafka](https://docs.emqx.com/zh/emqx/latest/data-integration/data-bridge-kafka.html)、[RabbitMQ](https://docs.emqx.com/zh/emqx/latest/data-integration/data-bridge-rabbitmq.html)、[Pulsar](https://docs.emqx.com/zh/emqx/latest/data-integration/data-bridge-pulsar.html)、[RocketMQ](https://docs.emqx.com/zh/emqx/latest/data-integration/data-bridge-rocketmq.html) 等。
  - **数据库**：[PostgreSQL](https://docs.emqx.com/zh/emqx/latest/data-integration/data-bridge-pgsql.html)、[MySQL](https://docs.emqx.com/zh/emqx/latest/data-integration/data-bridge-mysql.html)、[MongoDB](https://docs.emqx.com/zh/emqx/latest/data-integration/data-bridge-mongodb.html)、[Redis](https://docs.emqx.com/zh/emqx/latest/data-integration/data-bridge-redis.html)、[ClickHouse](https://docs.emqx.com/zh/emqx/latest/data-integration/data-bridge-clickhouse.html)、[InfluxDB](https://docs.emqx.com/zh/emqx/latest/data-integration/data-bridge-influxdb.html) 等。
  - **云服务**：[AWS Kinesis](https://docs.emqx.com/zh/emqx/latest/data-integration/data-bridge-kinesis.html)、[GCP Pub/Sub](https://docs.emqx.com/zh/emqx/latest/data-integration/data-bridge-gcp-pubsub.html)、[Azure Event Hub](https://docs.emqx.com/zh/emqx/latest/data-integration/data-bridge-azure-event-hub.html)、[Confluent Cloud](https://docs.emqx.com/zh/emqx/latest/data-integration/confluent-sink.html) 等。
- [Webhook](https://docs.emqx.com/zh/emqx/latest/data-integration/webhook.html) 支持，便于与自定义服务集成。

### [流设计器](https://docs.emqx.com/zh/emqx/latest/flow-designer/introduction.html)

- 拖放式画布，无需代码即可编排实时数据管道，支持规则、集成和 AI 任务节点。

### [智能数据中心](https://docs.emqx.com/zh/cloud/latest/data_hub/smart_data_hub.html)

- [模式注册表](https://docs.emqx.com/zh/cloud/latest/data_hub/schema_registry.html)：定义、存储和管理数据模式，确保一致性。
- [模式验证](https://docs.emqx.com/zh/cloud/latest/data_hub/schema_validation.html)：根据注册模式验证传入数据，维护数据完整性。
- [消息转换](https://docs.emqx.com/zh/cloud/latest/data_hub/message_transformation.html)：在不同格式和结构间转换数据，促进无缝集成。

### [AI 处理与集成](https://www.emqx.com/zh/solutions/artificial-intelligence)

- 原生 IoT 数据流 AI 处理能力。
- 与主流 AI 服务集成。
- 支持边缘或云端的 AI 驱动决策。

### 强健的[安全性](https://www.emqx.com/zh/solutions/mqtt-security)

- 通过 TLS/SSL 和 WSS 实现 [安全连接](https://docs.emqx.com/zh/emqx/latest/network/overview.html)。
- 灵活的 [认证](https://docs.emqx.com/zh/emqx/latest/access-control/authn/authn.html) 机制：用户名/密码、JWT、PSK、X.509 证书等。
- 基于 [ACL](https://docs.emqx.com/zh/emqx/latest/access-control/authz/authz.html) 的细粒度访问控制。
- 与外部认证数据库集成（[LDAP](https://docs.emqx.com/zh/emqx/latest/access-control/authn/ldap.html)、[SQL](https://docs.emqx.com/zh/emqx/latest/access-control/authn/postgresql.html)、[Redis](https://docs.emqx.com/zh/emqx/latest/access-control/authn/redis.html)）。

### 高级可观测性与管理

- 与 [Prometheus](https://docs.emqx.com/zh/emqx/latest/observability/prometheus.html)、[Grafana](https://grafana.com/grafana/dashboards/17446-emqx/)、[Datadog](https://docs.emqx.com/zh/emqx/latest/observability/datadog.html) 和 [OpenTelemetry](https://docs.emqx.com/zh/emqx/latest/observability/opentelemetry/opentelemetry.html) 集成的全面监控。
- 详细的日志和 [追踪](https://docs.emqx.com/zh/emqx/latest/observability/tracer.html) 功能。
- 用户友好的 [仪表板](https://docs.emqx.com/zh/emqx/latest/dashboard/introduction.html)，用于集群概览和管理。
- 丰富的 [HTTP API](https://docs.emqx.com/zh/emqx/latest/admin/api.html)，支持自动化和第三方集成。

### 可扩展性

- [插件](https://docs.emqx.com/zh/emqx/latest/extensions/plugins.html) 架构，用于扩展功能。
- [钩子](https://docs.emqx.com/zh/emqx/latest/extensions/hooks.html)，用于在消息生命周期各节点自定义行为。

### 统一体验

- 基于 BSL 1.1 许可证（v5.9.0+），所有功能（含原企业版专属功能）对开发者开放。

## 快速启动

运行单个 EMQX 节点：

```bash
docker run -d --name emqx \
  -p 1883:1883 -p 8083:8083 -p 8084:8084 \
  -p 8883:8883 -p 18083:18083 \
  emqx/emqx-enterprise:latest
```

EMQX 代理在 Docker 容器中以 Linux 用户 `emqx` 运行。

## 配置

`etc/emqx.conf` 中的所有 EMQX 配置可通过环境变量设置。默认情况下，前缀为 `EMQX_` 的环境变量会映射到配置文件中的键值对。

示例：

```bash
# EMQX_LISTENERS__TCP__DEFAULT__BIND <-> listeners.tcp.default.bind
# EMQX_LISTENERS__SSL__DEFAULT__ACCEPTORS <-> listeners.ssl.default.acceptors
# EMQX_ZONES__DEFAULT__MQTT__MAX_PACKET_SIZE <--> zones.default.mqtt.max_packet_size

# 规则：移除前缀 EMQX_，大写字母转小写，下划线替换为点

# 示例：将 MQTT TCP 端口设置为 1884
docker run -d --name emqx \
    -e EMQX_LISTENERS__TCP__DEFAULT__BIND=1884 \
    -p 18083:18083 \
    -p 1884:1884 \
    emqx/emqx-enterprise:latest
```

更多配置详情见 [官方文档](https://docs.emqx.com/zh/emqx/latest/configuration/configuration.html)。

## 集群

**注意：** 部署 EMQX 集群（超过 1 个节点）需加载许可证密钥。

EMQX 支持多种集群方式，详情见 [文档](https://docs.emqx.com/zh/emqx/latest/deploy/cluster/create-cluster.html)。

通过 `docker compose` 创建静态节点列表集群：

* 创建 `docker-compose.yaml`：

```yaml
services:
  emqx1:
    image: emqx/emqx-enterprise:latest
    ports:
      - "18083:18083"
    environment:
      - "EMQX_NODE__NAME=emqx@node1.emqx.com"
      - "EMQX_CLUSTER__DISCOVERY_STRATEGY=static"
      - "EMQX_CLUSTER__STATIC__SEEDS=[emqx@node1.emqx.com, emqx@node2.emqx.com]"
      - "EMQX_LICENSE__KEY=<您的许可证密钥>"
    networks:
      emqx-bridge:
        aliases:
          - node1.emqx.com

  emqx2:
    image: emqx/emqx-enterprise:latest
    environment:
      - "EMQX_NODE__NAME=emqx@node2.emqx.com"
      - "EMQX_CLUSTER__DISCOVERY_STRATEGY=static"
      - "EMQX_CLUSTER__STATIC__SEEDS=[emqx@node1.emqx.com, emqx@node2.emqx.com]"
      - "EMQX_LICENSE__KEY=<您的许可证密钥>"
    networks:
      emqx-bridge:
        aliases:
          - node2.emqx.com

networks:
  emqx-bridge:
    driver: bridge
```

* 启动集群：

```bash
docker compose -p my_emqx up -d
```

* 查看集群状态：

```bash
$ docker exec -it my_emqx_emqx1_1 sh -c "emqx ctl cluster status"
Cluster status: #[running_nodes => ['emqx@node1.emqx.com','emqx@node2.emqx.com'],
                  stopped_nodes => []}
```

## 持久化

需持久化的目录：
* `/opt/emqx/data`
* `/opt/emqx/log`

EMQX 使用 `data/mnesia/<node_name>` 存储数据，建议使用稳定标识符（如主机名或 FQDN）作为节点名称，避免因名称变更导致数据丢失。

`docker compose` 配置示例：

```yaml
volumes:
  vol-emqx-data:
    name: foo-emqx-data
  vol-emqx-log:
    name: foo-emqx-log

services:
  emqx:
    image: emqx/emqx-enterprise:latest
    hostname: node.emqx.com
    restart: always
    environment:
      EMQX_NODE__NAME: "emqx@node.emqx.com"
    volumes:
      - vol-emqx-data:/opt/emqx/data
      - vol-emqx-log:/opt/emqx/log
```

## 内核调优

Linux 主机调优建议参考 [调优指南](https://docs.emqx.com/zh/emqx/latest/performance/tune.html)。若通过 Docker 调优，需确保 Docker 版本 ≥1.12：

```bash
docker run -d --name emqx -p 18083:18083 -p 1883:1883 \
  --sysctl fs.file-max=2097152 \
  --sysctl fs.nr_open=2097152 \
  --sysctl net.core.somaxconn=32768 \
  --sysctl net.ipv4.tcp_max_syn_backlog=16384 \
  --sysctl net.core.netdev_max_backlog=16384 \
  --sysctl net.ipv4.ip_local_port_range="1000 65535" \
  --sysctl net.core.rmem_default=262144 \
  --sysctl net.core.wmem_default=262144 \
  --sysctl net.core.rmem_max=16777216 \
  --sysctl net.core.wmem_max=16777216 \
  --sysctl net.core.optmem_max=16777216 \
  --sysctl net.ipv4.tcp_rmem="1024 4096 16777216" \
  --sysctl net.ipv4.tcp_wmem="1024 4096 16777216" \
  --sysctl net.ipv4.tcp_max_tw_buckets=1048576 \
  --sysctl net.ipv4.tcp_fin_timeout=15 \
  emqx/emqx-enterprise:latest
```

**注意：不要以特权模式运行 EMQX Docker 容器，也不要挂载系统 proc 到容器中进行内核调优，这存在安全风险。**

## 致谢

- [@je-al](https://github.com/emqx/emqx-docker/issues/2)
- [@RaymondMouthaan](https://github.com/emqx/emqx-docker/pull/91)
- [@zhongjiewu](https://github.com/emqx/emqx/issues/3427)
