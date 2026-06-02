<!-- xuanyuan-docker-images-zh
image: emqx/emqx
source: https://xuanyuan.cloud/zh/r/emqx/emqx
canonical: https://xuanyuan.cloud/zh/r/emqx/emqx
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/emqx/emqx" title="emqx/emqx Docker 镜像中文简介、标签列表与拉取命令">emqx/emqx — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/emqx/emqx" title="emqx/emqx Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/emqx/emqx</a></p>

# EMQX 概述


## EMQX 官方 Docker 镜像  
[官网]() | [文档]() | [GitHub]([]) | [Slack]([]) | []()  

支持架构：`amd64`、`arm64v8`  


## 概述  
EMQX 是全球扩展性最强、可靠性最高的 MQTT 平台，专为高性能、高可靠、高安全的 IoT 数据基础设施设计。它支持 MQTT 5.0、3.1.1、3.1 协议，以及 MQTT-SN、CoAP、LwM2M、MQTT over QUIC 等其他协议，可连接数百万 IoT 设备，实时处理和路由消息，并与各类后端数据系统集成。适用于 AI、物联网、工业物联网（IIoT）、车联网、智慧城市等场景。  


### 统一特性与新许可证（v5.9.0+）  
从 v5.9.0 版本开始，EMQX 统一了所有特性，并采用 Business Source License (BSL) 1.1 许可证。这意味着所有功能——包括强大的数据集成、流设计器（Flow Designer）、高级可观测性和企业级安全特性——均通过此单一 Docker 镜像提供。  

了解许可证变更详情：  
- 新闻：[EMQX 采用 BSL 许可证]()  
- 博客：[为何我们选择 BSL 许可证]()  
- [许可证常见问题]()  

**重要提示：v5.9.0+ 版本集群需许可证！**  
根据 BSL 1.1 条款，部署 EMQX 集群（超过 1 个节点）需加载许可证密钥，即使是 BSL 允许的免费/开发场景也不例外。获取和应用许可证的详细步骤请参见许可证 FAQ 及官方文档。  


## 核心特性  
EMQX 为现代连接系统提供以下关键能力：  


### 全面的协议支持  
- 完整支持 MQTT v5.0、v3.1.1 和 v3.1 协议。  
- [MQTT over QUIC]()：利用 QUIC 协议优势，实现更快的连接建立、减少队头阻塞、支持无缝连接迁移。  
- 通过 [网关]() 支持其他 IoT 协议，如 [LwM2M]()、[CoAP]()、[MQTT-SN]() 等。  


### 海量扩展与高可用  
- [支持]() 单集群连接 1 亿+ 并发 MQTT 客户端。  
- [处理]() 每秒数百万条消息，延迟低至亚毫秒级。  
- [无主集群]() 架构，确保高可用和容错能力。  
- 通过 [EMQX 集群桥接]() 实现全球无缝通信。  


### 强大的规则引擎与数据集成  
- 基于 SQL 的 [规则引擎]()，可实时处理、转换、富集和过滤流转数据。  
- 无缝对接 50+ 云服务和企业系统，包括：  
  - **消息队列**：[Kafka]()、[RabbitMQ]()、[Pulsar]()、[RocketMQ]() 等。  
  - **数据库**：[PostgreSQL]()、[MySQL]()、[MongoDB]()、[Redis]()、[ClickHouse]()、[InfluxDB]() 等。  
  - **云服务**：[AWS Kinesis]()、[GCP Pub/Sub]()、[Azure Event Hub]()、[Confluent Cloud]() 等。  
- 支持 [Webhook]()，轻松集成自定义服务。  


### [Flow Designer]()  
- 拖拽式画布，零代码编排实时数据流水线，支持规则、集成和 AI 任务节点。  


### [Smart Data Hub]()  
- [Schema Registry]()：定义、存储和管理数据 schema，确保一致性。  
- [Schema Validation]()：校验入站数据与已注册 schema 的一致性，保障数据完整性。  
- [Message Transformation]()：在不同格式和结构间转换数据，简化集成流程。  


### [AI 处理与集成]()  
- 原生支持 IoT 数据流的 AI 处理能力。  
- 集成主流 AI 服务。  
- 支持边缘或云端的 AI 驱动决策。  


### 可靠的 [安全机制]()  
- 通过 TLS/SSL 和 WSS 实现 [安全连接]()。  
- 灵活的 [认证]() 机制：用户名/密码、JWT、PSK、X.509 证书等。  
- 基于 [ACL]() 的细粒度访问控制。  
- 集成外部认证数据库（[LDAP]()、[SQL]()、[Redis]()）。  


### 高级可观测性与管理  
- 全面监控支持：[Prometheus]()、[Grafana]([])、[Datadog]()、[OpenTelemetry]()。  
- 详细日志与 [追踪]() 功能。  
- 易用的 [Dashboard]()，提供集群概览与管理界面。  
- 丰富的 [HTTP API]()，支持自动化和第三方集成。  


### 可扩展性  
- [插件]() 架构，扩展功能。  
- [钩子]() 机制，在消息生命周期各节点自定义行为。  


### 统一体验  
- 自 BSL 1.1 许可证（v5.9.0+）起，所有功能（含原企业版专属特性）对所有开发者开放。  


## 快速启动  
运行单个 EMQX 节点：  

```bash
docker run -d --name emqx \
  -p 1883:1883 -p 8083:8083 -p 8084:8084 \
  -p 8883:8883 -p 18083:18083 \
  emqx/emqx:latest
```  

容器内 EMQX 以 Linux 用户 `emqx` 身份运行。  


## 配置  
`etc/emqx.conf` 中的所有配置均可通过环境变量设置。默认情况下，前缀为 `EMQX_` 的环境变量会映射为配置文件中的键值对。  

**映射规则**：  
- 移除前缀 `EMQX_`  
- 大写字母转为小写  
- 下划线 `_` 替换为点 `.`  

**示例**：  
`EMQX_LISTENERS_TCP_DEFAULT_BIND` 对应 `listeners.tcp.default.bind`，以下命令将 MQTT TCP 端口设为 1884：  

```bash
docker run -d --name emqx \
  -e EMQX_LISTENERS_TCP_DEFAULT_BIND=1884 \
  -p 18083:18083 \
  -p 1884:1884 \
  emqx/emqx:latest
```  

更多配置细节见 [官方文档]()。  


### EMQX 节点名称配置  

| 选项         | 默认值         | 映射关系 | 说明                          |  
|--------------|----------------|----------|-------------------------------|  
| EMQX_NAME    | 容器名称       | 无       | EMQX 节点短名称               |  
| EMQX_HOST    | 容器 IP        | 无       | EMQX 节点主机（IP 或域名）    |  

仅在容器启动阶段（`docker-entrypoint.sh` 中）使用这些变量：若设置了 `EMQX_NAME` 和 `EMQX_HOST` 但未设置 `EMQX_NODE_NAME`，则 `EMQX_NODE_NAME=$EMQX_NAME@$EMQX_HOST`；否则直接使用 `EMQX_NODE_NAME` 的值。  


## 集群  
**注意**：部署 EMQX 集群（超过 1 个节点）需加载许可证密钥。  

EMQX 支持多种集群部署方式，详见 [文档]()。以下为基于 `docker compose` 的静态节点列表集群示例：  


### 步骤 1：创建 `docker-compose.yaml`  

```yaml
services:
  emqx1:
    image: emqx/emqx:latest
    environment:
      - "EMQX_NAME=emqx"
      - "EMQX_HOST=node1.emqx.io"
      - "EMQX_CLUSTER_DISCOVERY_STRATEGY=static"
      - "EMQX_CLUSTER_STATIC_SEEDS=[[邮箱已删除], [邮箱已删除]]"
      - "EMQX_LICENSE_KEY=<your license key>"  # 替换为实际许可证密钥
    networks:
      emqx-bridge:
        aliases:
          - node1.emqx.io

  emqx2:
    image: emqx/emqx:latest
    environment:
      - "EMQX_NAME=emqx"
      - "EMQX_HOST=node2.emqx.io"
      - "EMQX_CLUSTER_DISCOVERY_STRATEGY=static"
      - "EMQX_CLUSTER_STATIC_SEEDS=[[邮箱已删除], [邮箱已删除]]"
      - "EMQX_LICENSE_KEY=<your license key>"  # 替换为实际许可证密钥
    networks:
      emqx-bridge:
        aliases:
          - node2.emqx.io

networks:
  emqx-bridge:
    driver: bridge
```  


### 步骤 2：启动集群  

```bash
docker compose -p my_emqx up -d
```  


### 步骤 3：查看集群状态  

```bash
docker exec -it my_emqx_emqx1_1 sh -c "emqx ctl cluster status"
```  

输出示例：  
```
Cluster status: #[running_nodes => ['[邮箱已删除]','[邮箱已删除]'], stopped_nodes => []}
```  


## 持久化  
需持久化容器数据时，挂载以下目录：  
- `/opt/emqx/data`（数据目录）  
- `/opt/emqx/log`（日志目录）  

**注意**：数据目录中部分文件路径含节点名称（`/opt/emqx/data/mnesia/${node_name}`），需复用相同节点名称才能恢复之前的状态。建议通过环境变量 `EMQX_NAME` 和 `EMQX_HOST` 固定节点名称（如 `EMQX_HOST=127.0.0.1` 或网络别名）。  

**docker-compose 示例**：  

```yaml
volumes:
  vol-emqx-data:
    name: foo-emqx-data
  vol-emqx-log:
    name: foo-emqx-log

services:
  emqx:
    image: emqx/emqx:latest
    restart: always
    environment:
      EMQX_NAME: foo_emqx
      EMQX_HOST: 127.0.0.1
    volumes:
      - vol-emqx-data:/opt/emqx/data
      - vol-emqx-log:/opt/emqx/log
```  


## 内核调优  
Linux 主机可参考 [调优指南]()。若通过 Docker 调优，需确保 Docker 版本 ≥1.12，命令如下：  

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
  emqx/emqx:latest
```  

**警告**：不要以特权模式运行 EMQX 容器，或挂载系统 `proc` 目录到容器内调优内核，存在安全风险。  


## 致谢  
- [@je-al]([])  
- [@RaymondMouthaan]([])  
- [@zhongjiewu]([])

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/emqx/emqx" title="emqx/emqx Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/emqx/emqx</a></p>
