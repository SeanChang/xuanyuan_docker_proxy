<!-- xuanyuan-docker-images-zh
image: provectuslabs/kafka-ui
source: https://xuanyuan.cloud/zh/r/provectuslabs/kafka-ui
canonical: https://xuanyuan.cloud/zh/r/provectuslabs/kafka-ui
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [provectuslabs/kafka-ui — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/provectuslabs/kafka-ui "provectuslabs/kafka-ui Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/provectuslabs/kafka-ui

# UI for Apache Kafka

## 镜像概述
UI for Apache Kafka 是一个多功能、快速且轻量级的Web UI，专为管理Apache Kafka®集群设计。该工具由开发者构建，面向开发者，提供直观的界面用于监控和管理Kafka集群，是免费开源的解决方案。

## 核心功能和特性
- **集群监控**：实时查看brokers状态、主题信息、分区分布及消费者组活动
- **主题管理**：支持创建、编辑、删除主题，配置分区数量、副本因子及保留策略
- **消息操作**：浏览、搜索、过滤消息内容，支持消息发送和消费测试
- **消费者组监控**：跟踪消费进度、滞后情况及消费者 offsets
- **轻量级设计**：资源占用低，启动快速，适合各种环境部署
- **多集群支持**：可同时连接和管理多个Kafka集群

## 使用场景和适用范围
- **开发环境**：调试Kafka应用程序，验证消息生产和消费流程
- **生产环境**：实时监控集群健康状态，及时发现和解决问题
- **集群管理**：集中管理多个Kafka集群，统一配置和维护
- **数据验证**：查看消息内容，确保数据格式和传输正确性

## 使用方法和配置说明

### 快速启动（Docker Run）
```docker
docker run -d -p 8080:8080 \
  -e KAFKA_CLUSTERS_0_NAME=local-cluster \
  -e KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=kafka:9092 \
  --name kafka-ui provectuslabs/kafka-ui
```

### Docker Compose 配置示例
```yaml
version: '3.8'
services:
  kafka-ui:
    image: provectuslabs/kafka-ui
    container_name: kafka-ui
    ports:
      - "8080:8080"
    environment:
      - KAFKA_CLUSTERS_0_NAME=prod-cluster
      - KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=broker1:9092,broker2:9092
      - KAFKA_CLUSTERS_0_ZOOKEEPER=zookeeper:2181
      - KAFKA_CLUSTERS_1_NAME=test-cluster
      - KAFKA_CLUSTERS_1_BOOTSTRAPSERVERS=test-broker:9092
    restart: unless-stopped
```

### 主要配置参数（环境变量）
| 环境变量 | 描述 | 默认值 |
|----------|------|--------|
| `PORT` | 服务监听端口 | 8080 |
| `KAFKA_CLUSTERS_0_NAME` | 第一个集群名称 | - |
| `KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS` | 第一个集群的broker地址列表 | - |
| `KAFKA_CLUSTERS_0_ZOOKEEPER` | 第一个集群的Zookeeper地址 | - |
| `KAFKA_CLUSTERS_0_PROPERTIES_SECURITY_PROTOCOL` | 安全协议（PLAINTEXT/SASL_SSL等） | PLAINTEXT |

### 访问界面
启动容器后，通过浏览器访问 `http://localhost:8080` 即可打开Kafka UI界面，无需额外身份验证（生产环境建议配置安全访问）。

## 相关资源
- [官方文档](https://docs.kafka-ui.provectus.io/)
- [快速入门指南](https://docs.kafka-ui.provectus.io/configuration/quick-start)
- [社区支持](https://discord.gg/4DWzD7pGE5)
