---
image: obsidiandynamics/kafka
description: "将ZooKeeper和Kafka整合到单个镜像中的便捷解决方案，支持Kafka 2.3.0，便于快速部署和配置。"
source: https://xuanyuan.cloud/zh/r/obsidiandynamics/kafka
canonical: https://xuanyuan.cloud/zh/r/obsidiandynamics/kafka
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/obsidiandynamics/kafka" title="obsidiandynamics/kafka Docker 镜像中文简介、标签列表与拉取命令">obsidiandynamics/kafka 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 镜像概述
该镜像将ZooKeeper和Kafka整合到单个容器中，提供便捷的一站式部署方案，支持Kafka 2.3.0版本，适用于快速搭建Kafka开发或测试环境，无需单独配置ZooKeeper。

# 核心功能与特性
- 整合ZooKeeper与Kafka，简化部署流程
- 支持通过环境变量灵活配置Kafka参数
- 提供多种监听器配置方案，适应不同网络环境
- 内置自动重启机制，增强服务稳定性

# 使用场景
适用于开发、测试环境中快速搭建Kafka服务，或需要简化分布式消息系统部署流程的场景。

# 使用方法

## 运行示例

### 基础broker设置
```sh
docker run --name kafka --rm -it -p 2181:2181 -p 9092:9092 docker.xuanyuan.run/obsidiandynamics/kafka
```

### 指定备用主机名的监听器
将监听器广告为`kafka:9092`而非默认的`localhost:9092`：
```sh
docker run --name kafka --rm -it -p 2181:2181 -p 9092:9092 \
    -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092 \
    docker.xuanyuan.run/obsidiandynamics/kafka
```

### 多个广告监听器
同时广告`kafka:29092`和`localhost:9092`：
```sh
docker run --name kafka --rm -it -p 2181:2181 -p 9092:9092 -p 29092:29092 \
    -e KAFKA_LISTENERS=INTERNAL://:29092,EXTERNAL://:9092 \
    -e KAFKA_ADVERTISED_LISTENERS=INTERNAL://kafka:29092,EXTERNAL://localhost:9092 \
    -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT \
    -e KAFKA_INTER_BROKER_LISTENER_NAME=INTERNAL \
    docker.xuanyuan.run/obsidiandynamics/kafka
```

# 配置说明
配置通过环境变量进行管理，主要参数如下：

| 变量名                              | 默认值                  | 描述                                                                 |
| :---------------------------------- | :---------------------- | :------------------------------------------------------------------- |
| `KAFKA_BROKER_ID`                   | `0`                     | broker ID（设为-1可生成唯一ID）                                         |
| `KAFKA_LISTENERS`                   | `PLAINTEXT://:9092`     | 套接字服务器监听的地址（逗号分隔）                                       |
| `KAFKA_ADVERTISED_LISTENERS`        | `KAFKA_LISTENERS`的值   | broker向客户端广告的主机名/端口组合（逗号分隔）                          |
| `KAFKA_LISTENER_SECURITY_PROTOCOL_MAP` | `PLAINTEXT:PLAINTEXT`, `SSL:SSL`, `SASL_PLAINTEXT:SASL_PLAINTEXT`, `SASL_SSL:SASL_SSL` | 将监听器名称映射到安全协议                                           |
| `KAFKA_INTER_BROKER_LISTENER_NAME`  | `PLAINTEXT`             | 用于broker间通信的监听器                                               |
| `KAFKA_ADVERTISED_HOST_NAME`        | 机器的规范主机名        | 广告的主机名（已弃用，建议使用KAFKA_ADVERTISED_LISTENERS）              |
| `KAFKA_ADVERTISED_PORT`             | 绑定端口的值            | 广告的端口（已弃用，建议使用KAFKA_ADVERTISED_LISTENERS）                |
| `KAFKA_ZOOKEEPER_CONNECT`           | `127.0.0.1:2181 `       | ZooKeeper连接地址                                                     |
| `KAFKA_ZOOKEEPER_CONNECTION_TIMEOUT` | `10000`                 | ZooKeeper连接超时时间（毫秒）                                          |
| `KAFKA_ZOOKEEPER_SESSION_TIMEOUT`   | `6000`                  | ZooKeeper会话超时时间（毫秒）                                          |
| `KAFKA_RESTART_ATTEMPTS`            | `3`                     | 当broker以非零退出码终止时的重启次数                                    |
| `KAFKA_RESTART_DELAY`               | `5`                     | 重启尝试之间的秒数                                                    |
| `ZOOKEEPER_AUTOPURGE_PURGE_INTERVAL` | `0`                     | ZooKeeper自动清理间隔（小时，设为0表示禁用）                             |
