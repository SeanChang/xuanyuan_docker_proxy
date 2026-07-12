---
image: debezium/zookeeper
description: "运行Debezium平台时所需的Zookeeper镜像，为Kafka提供分布式协调和共识服务，支持Kafka broker的可用性与职责协调，通过集群（通常3或5个节点）确保可靠性。"
source: https://xuanyuan.cloud/zh/r/debezium/zookeeper
canonical: https://xuanyuan.cloud/zh/r/debezium/zookeeper
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/debezium/zookeeper" title="debezium/zookeeper Docker 镜像中文简介、标签列表与拉取命令">debezium/zookeeper 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Debezium Zookeeper 镜像文档

## 镜像概述

本镜像已迁移至 [quay.io/debezium/zookeeper](https://quay.io/repository/debezium/zookeeper)。  
[Zookeeper](http://zookeeper.apache.org/) 是分布式协调与共识服务，在Debezium中被[Kafka](http://kafka.apache.org/)用于协调各Kafka broker的可用性和职责。其可靠性通过多Zookeeper进程集群实现，因采用仲裁机制，生产环境通常需奇数个节点（3或5个）。

## Debezium简介

Debezium是分布式平台，可将现有数据库转换为事件流，使应用能快速响应数据库行级变更。它构建于Kafka之上，提供Kafka Connect兼容连接器以监控特定数据库管理系统。Debezium将数据变更历史记录到Kafka日志，确保应用停止重启后可消费所有遗漏事件，保障事件处理的准确性和完整性。

运行Debezium需Zookeeper、Kafka及Debezium连接器服务。简单评估和实验可在单主机运行所有服务；生产环境需多实例部署以确保性能、可靠性、复制和容错，可通过[OpenShift](https://www.openshift.com)等平台管理多主机Docker容器。但Kafka在Docker容器中运行有局限性，高吞吐量场景建议按[Kafka文档](http://kafka.apache.org/documentation.html)在专用硬件上部署。

## 使用方法

本镜像用于运行Kafka broker所需的一个或多个Zookeeper实例。单实例场景默认配置通常足够（适合评估和演示），多实例需通过环境变量配置。

### 启动Zookeeper

使用以下命令启动Zookeeper实例：

```bash
$ docker run -it --name zookeeper -p 2181:2181 -p 2888:2888 -p 3888:3888 debezium/zookeeper
```

- 该命令创建名为`zookeeper`的容器，前台运行并附加控制台以显示输出和错误信息。
- 映射端口2181（供外部服务如Kafka通信）、2888和3888（Zookeeper内部通信）到主机。
- 如需后台运行，将`-it`替换为`-d`，日志可通过`docker logs`查看：
  ```bash
  $ docker logs --follow --name zookeeper
  ```

### 显示Zookeeper状态

连接运行中的Zookeeper实例并显示状态：

```bash
$ docker run -it --rm debezium/zookeeper status
```

- 状态显示后容器自动退出，`--rm`确保容器立即删除，可多次执行。

### 使用Zookeeper CLI

启动Zookeeper命令行界面（CLI）连接运行中的实例：

```bash
$ docker run -it --rm debezium/zookeeper cli
```

- 退出CLI后容器自动退出，`--rm`确保容器立即删除，可多次执行。

## 环境变量

### `SERVER_ID`
- 定义Zookeeper服务器的数字标识符。
- 默认值：`1`（仅适用于非复制、非容错的单节点独立服务器）。
- 集群环境需设置为集群内唯一值。

### `SERVER_COUNT`
- 定义集群中Zookeeper服务器总数。
- 默认值：`1`（仅适用于单节点独立服务器）。
- 集群环境必须设置为实际服务器数量。

### `LOG_LEVEL`
- 可选，设置Zookeeper应用日志（输出到STDOUT和STDERR）的详细程度。
- 有效值：`INFO`（默认）、`WARN`、`ERROR`、`DEBUG`、`TRACE`。

## 端口

容器暴露以下标准Zookeeper端口，可通过Docker选项映射到主机不同端口：
- 2181：客户端通信端口
- 2888：集群内跟随者与领导者通信端口
- 3888：领导者选举端口

## 数据存储

Zookeeper数据、日志和配置需通过卷挂载持久化，避免容器停止后数据丢失。

### Zookeeper数据
- 镜像定义数据卷：`/zookeeper/data`（数据存储）和`/zookeeper/txns`（事务日志）。
- 必须挂载这些目录以持久化数据，否则容器停止后数据丢失。

### 日志文件
- 镜像将详细日志写入卷`/zookeeper/logs`（同时输出到标准输出供Docker日志查看）。
- 必须挂载此目录以持久化日志，否则容器停止后日志丢失。

### 配置
- 镜像定义配置卷`/zookeeper/conf`，存储Zookeeper配置文件。
- 配置文件会根据环境变量和链接容器动态修改，挂载此卷可查看实际配置，也可提供自定义配置文件（需注意容器启动时的适配逻辑）。
