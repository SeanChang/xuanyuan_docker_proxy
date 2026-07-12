---
image: redpandadata/console
description: "Redpanda Console是一款开发者友好的UI，用于管理Kafka/Redpanda工作负载。"
source: https://xuanyuan.cloud/zh/r/redpandadata/console
canonical: https://xuanyuan.cloud/zh/r/redpandadata/console
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/redpandadata/console" title="redpandadata/console Docker 镜像中文简介、标签列表与拉取命令">redpandadata/console 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Redpanda Console 镜像文档


## 镜像概述

Redpanda Console 是一个开发者友好的 Web 应用程序，提供直观的用户界面（UI），旨在帮助用户轻松管理和调试 Kafka 或 Redpanda 工作负载。作为轻量级容器化应用，它可快速部署并集成到现有数据流架构中，简化 Kafka/Redpanda 集群的日常运维、监控与问题排查流程。


## 核心功能与特性

### 核心功能
- **主题管理**：查看、创建、编辑和删除 Kafka/Redpanda 主题，配置分区数、副本因子等参数。
- **消息可视化**：实时查看和搜索主题中的消息，支持按偏移量、时间戳筛选，支持 JSON、Avro 等格式解析。
- **消费者组监控**：监控消费者组的消费进度、滞后量（lag）、成员状态，识别消费瓶颈。
- **集群概览**：展示 brokers、主题、分区、消费者组等核心集群资源的统计信息与健康状态。

### 特性
- **开发者友好**：界面简洁直观，操作流程符合开发者习惯，降低学习成本。
- **实时性**：数据更新延迟低，支持实时监控消息流和集群状态变化。
- **轻量级部署**：基于容器化设计，支持通过 Docker 快速启动，无需复杂依赖。
- **兼容性**：兼容 Apache Kafka 和 Redpanda 集群，支持标准 Kafka 协议。


## 使用场景与适用范围

### 适用场景
- **开发调试**：在开发环境中，快速查看消息内容、验证生产者/消费者逻辑，排查数据格式或传输问题。
- **集群监控**：在生产/测试环境中，监控主题流量、消费者组滞后量，及时发现集群异常。
- **数据验证**：数据工程师验证数据流完整性，确认消息是否按预期写入目标主题。
- **运维管理**：简化主题创建、分区调整等日常运维操作，减少命令行工具的依赖。

### 适用范围
- 使用 Apache Kafka 或 Redpanda 作为消息系统的团队。
- 需要可视化管理 Kafka/Redpanda 集群的开发者、数据工程师和运维人员。
- 支持单机开发环境、分布式测试环境及生产环境部署。


## 使用方法

### Docker 快速启动（docker run）

通过 `docker run` 命令快速启动 Redpanda Console，需指定 Kafka/Redpanda brokers 地址：

```bash
docker run -d \
  --name redpanda-console \
  -p 8080:8080 \
  -e KAFKA_BROKERS="broker1:9092,broker2:9092" \  # 替换为实际的 Kafka/Redpanda brokers 地址
  redpanda/console:latest
```

启动后，通过 `http://localhost:8080` 访问 Web 界面。


### Docker Compose 部署

适用于与 Redpanda/Kafka 集群联动部署，示例 `docker-compose.yml`：

```yaml
version: '3.8'

services:
  redpanda-console:
    image: docker.xuanyuan.run/redpanda/console:latest
    container_name: redpanda-console
    ports:
      - "8080:8080"  # Web 界面端口
    environment:
      - KAFKA_BROKERS="redpanda-1:9092,redpanda-2:9092"  # 指向 Redpanda/Kafka brokers
      - CONSOLE_PORT=8080  # Web 服务监听端口（默认 8080）
      - LOG_LEVEL=info  # 日志级别：debug/info/warn/error
    depends_on:
      - redpanda-1  # 若依赖 Redpanda 集群，需声明依赖关系
    restart: unless-stopped

  # （可选）Redpanda 集群示例（用于测试环境）
  redpanda-1:
    image: docker.xuanyuan.run/redpanda/redpanda:latest
    command: redpanda start --overprovisioned --smp 1 --memory 1G --reserve-memory 0M --node-id 0 --check=false
    ports:
      - "9092:9092"  # Kafka API 端口
    volumes:
      - redpanda-data-1:/var/lib/redpanda/data

volumes:
  redpanda-data-1:
```


## 配置参数

### 环境变量

| 环境变量名          | 描述                                                                 | 默认值   | 示例值                     |
|---------------------|----------------------------------------------------------------------|----------|----------------------------|
| `KAFKA_BROKERS`     | Kafka/Redpanda brokers 地址列表，逗号分隔                             | 无       | `broker1:9092,broker2:9092` |
| `CONSOLE_PORT`      | Web 界面监听端口                                                     | `8080`   | `3000`                     |
| `LOG_LEVEL`         | 日志输出级别（`debug`/`info`/`warn`/`error`）                        | `info`   | `debug`                    |
| `KAFKA_SASL_ENABLED`| 是否启用 SASL 认证（`true`/`false`）                                 | `false`  | `true`                     |
| `KAFKA_SASL_USER`   | SASL 认证用户名（仅当 `KAFKA_SASL_ENABLED=true` 时生效）             | 无       | `admin`                    |
| `KAFKA_SASL_PASSWORD`| SASL 认证密码（仅当 `KAFKA_SASL_ENABLED=true` 时生效）               | 无       | `secret`                   |
| `KAFKA_TLS_ENABLED` | 是否启用 TLS 加密连接（`true`/`false`）                              | `false`  | `true`                     |

### 端口映射

- **Web 界面端口**：容器内默认 `8080`，需通过 `-p <宿主机端口>:8080` 映射到宿主机，如 `-p 8080:8080`。


### 持久化配置（可选）

若需自定义高级配置（如自定义主题配置策略、认证证书等），可通过挂载配置文件实现。创建本地配置文件 `console.yaml`，并通过 `-v ./console.yaml:/etc/console/config.yaml` 挂载到容器内 `/etc/console/config.yaml` 路径。配置文件格式参考 [Redpanda Console 官方文档](https://docs.redpanda.com/docs/reference/console/)。
