---
image: apache/artemis
description: "Apache Artemis是一款高性能多协议消息中间件，支持JMS、AMQP、MQTT等多种消息协议，提供可靠的消息传递、队列管理和发布/订阅功能，适用于构建分布式系统和企业级消息通信架构。"
source: https://xuanyuan.cloud/zh/r/apache/artemis
canonical: https://xuanyuan.cloud/zh/r/apache/artemis
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/artemis" title="apache/artemis Docker 镜像中文简介、标签列表与拉取命令">apache/artemis 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache Artemis Docker镜像文档

## 镜像概述

Apache Artemis是一款开源的多协议消息中间件，基于Java构建，提供高性能、可靠的消息传递服务。该Docker镜像封装了Apache Artemis服务器，便于快速部署和集成到各类应用架构中，支持多种消息协议，满足不同场景下的消息通信需求。

## 核心功能与特性

- **多协议支持**：兼容JMS 1.1/2.0、AMQP 1.0、MQTT 3.1.1、STOMP等多种消息协议，灵活适配不同客户端
- **高可靠性**：支持持久化消息存储、消息重发、事务管理，确保消息不丢失、不重复
- **高性能**：采用异步IO和高效的内存管理，支持高吞吐量和低延迟消息处理
- **灵活部署**：支持单机模式、主从集群、对称集群等多种部署架构，满足不同规模需求
- **安全特性**：提供用户认证、授权控制、SSL/TLS加密通信，保障消息传输安全
- **管理功能**：内置Web控制台和命令行工具，方便监控和管理消息队列、连接和资源

## 使用场景与适用范围

- **企业系统集成**：连接不同业务系统，实现跨系统消息通信和数据同步
- **微服务架构**：作为微服务间的通信枢纽，支持服务解耦和异步通信
- **异步任务处理**：处理非实时任务（如日志处理、报表生成），提高系统响应速度
- **事件驱动架构**：基于发布/订阅模式，构建事件驱动的应用系统
- **高可用系统**：通过集群部署，保障消息服务的持续可用和故障恢复

## 使用方法与配置说明

### 快速启动

使用以下命令快速启动Apache Artemis容器（默认配置）：

```bash
docker run -d --name artemis -p 8161:8161 -p 61616:61616 docker.xuanyuan.run/apache/artemis
```

- `-p 8161:8161`：映射Web控制台端口
- `-p 61616:61616`：映射JMS协议端口（默认）

启动后，可通过`http://localhost:8161`访问Web控制台（默认用户名/密码：admin/admin）。

### 自定义配置

#### 环境变量配置

通过环境变量自定义Artemis配置，常用变量如下：

| 环境变量 | 描述 | 默认值 |
|----------|------|--------|
| `ARTEMIS_USER` | 管理员用户名 | `admin` |
| `ARTEMIS_PASSWORD` | 管理员密码 | `admin` |
| `ARTEMIS_MIN_MEMORY` | JVM最小内存 | `512M` |
| `ARTEMIS_MAX_MEMORY` | JVM最大内存 | `1024M` |
| `ARTEMIS_JOURNAL_TYPE` | 消息日志存储类型（`NIO`/`AIO`） | `NIO` |
| `ARTEMIS_ACCEPTOR_*` | 自定义协议 acceptor（如`ARTEMIS_ACCEPTOR_AMQP=amqp://0.0.0.0:5672`） | 无 |

示例：自定义管理员账户和AMQP协议端口

```bash
docker run -d --name artemis \
  -p 8161:8161 \
  -p 5672:5672 \
  -e ARTEMIS_USER=myuser \
  -e ARTEMIS_PASSWORD=mypassword \
  -e ARTEMIS_ACCEPTOR_AMQP=amqp://0.0.0.0:5672 \
  docker.xuanyuan.run/apache/artemis
```

#### Docker Compose配置

创建`docker-compose.yml`文件，配置多实例或集成其他服务：

```yaml
version: '3'
services:
  artemis:
    image: docker.xuanyuan.run/apache/artemis
    container_name: artemis
    ports:
      - "8161:8161"   # Web控制台
      - "61616:61616" # JMS端口
      - "5672:5672"   # AMQP端口
    environment:
      - ARTEMIS_USER=admin
      - ARTEMIS_PASSWORD=securepassword
      - ARTEMIS_MAX_MEMORY=2048M
    volumes:
      - artemis-data:/var/lib/artemis/data  # 持久化消息数据
    restart: unless-stopped

volumes:
  artemis-data:
```

启动服务：

```bash
docker-compose up -d
```

### 持久化配置

为避免容器重启后数据丢失，建议挂载数据卷：

```bash
docker run -d --name artemis \
  -p 8161:8161 -p 61616:61616 \
  -v /host/path/to/artemis/data:/var/lib/artemis/data \
  docker.xuanyuan.run/apache/artemis
```

### 集群部署

Artemis支持主从集群和对称集群，通过配置文件或环境变量实现。以下是主从集群示例（使用共享存储）：

```bash
# 主节点
docker run -d --name artemis-master \
  -p 8161:8161 -p 61616:61616 \
  -e ARTEMIS_MODE=master \
  -e ARTEMIS_CLUSTER_PASSWORD=clusterpass \
  -v /shared/storage:/var/lib/artemis/data \
  docker.xuanyuan.run/apache/artemis

# 从节点
docker run -d --name artemis-slave \
  -p 8162:8161 -p 61617:61616 \
  -e ARTEMIS_MODE=slave \
  -e ARTEMIS_CLUSTER_PASSWORD=clusterpass \
  -v /shared/storage:/var/lib/artemis/data \
  docker.xuanyuan.run/apache/artemis
```

## 注意事项

- 生产环境中应修改默认用户名/密码，增强安全性
- 根据业务负载调整JVM内存配置（`ARTEMIS_MIN_MEMORY`和`ARTEMIS_MAX_MEMORY`）
- 持久化数据卷需确保宿主目录权限正确（容器内运行用户ID通常为1000）
- 集群部署时需确保节点间网络互通，并配置一致的集群密码
