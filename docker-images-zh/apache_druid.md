---
image: apache/druid
description: "Apache Druid是一款开源实时分析数据库，专为大规模时序数据的快速查询与实时摄入设计，支持交互式分析，提供高性能数据处理能力。"
source: https://xuanyuan.cloud/zh/r/apache/druid
canonical: https://xuanyuan.cloud/zh/r/apache/druid
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [apache/druid — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/apache/druid)

含镜像标签、拉取命令、部署文档与相关推荐。

[apache/druid Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/apache/druid)

# Apache Druid Docker 镜像文档


## 1. 镜像概述和主要用途

Apache Druid 是一款高性能实时分析数据库，旨在缩短从数据到洞察与行动的时间。其核心优势在于快速的数据摄入和查询能力，适用于需要实时分析、高并发查询及交互式数据探索的场景。

Apache Druid Docker 镜像（`apache/druid`）提供了便捷的容器化部署方案，简化了 Druid 集群的搭建流程，确保环境一致性，并支持灵活的配置与扩展。该镜像适用于开发测试、演示环境及中小规模生产部署。


## 2. 核心功能和特性

### 2.1 Druid 核心功能
- **实时与批量数据摄入**：支持 Kafka、Kinesis 等流数据源及文件、HDFS 等批处理数据源。
- **低延迟查询**：针对时序数据和高基数维度优化，毫秒级响应复杂聚合查询。
- **高并发支持**：设计用于处理大量并发用户查询，适合构建分析型 UI。
- **灵活的数据模型**：支持多值维度、复杂指标计算及时间分区存储。
- **内置 Web 控制台**：提供数据加载、集群管理、查询调试的可视化界面。

### 2.2 Docker 镜像特性
- **预配置组件**：包含 Druid 所有核心服务（Coordinator、Overlord、Broker、Router、Historical、MiddleManager 等）。
- **多版本支持**：提供不同 Druid 版本的镜像标签，满足版本兼容性需求。
- **轻量级部署**：简化依赖管理，支持快速启动单节点或多节点集群。
- **可扩展配置**：支持通过环境变量或挂载配置文件自定义集群参数。


## 3. 使用场景和适用范围

- **开发与测试环境**：快速搭建隔离的 Druid 环境，验证数据摄入和查询逻辑。
- **演示与原型验证**：通过容器化部署快速展示 Druid 的实时分析能力。
- **中小规模生产环境**：在资源有限的场景下，部署轻量级 Druid 集群处理实时数据。
- **集成测试**：与 Kafka、PostgreSQL 等组件联动，验证端到端数据流水线。


## 4. 使用方法和配置说明

### 4.1 前提条件
- 安装 Docker Engine（20.10+）及 Docker Compose（v2+）。
- 单节点模式建议至少 4GB 内存，多节点模式根据规模调整资源。


### 4.2 快速启动（单节点模式）
单节点模式适合快速体验 Druid 功能，包含所有核心服务及内置依赖（ZooKeeper、元数据库）。

```bash
docker run -d \
  -p 8888:8888 \  # Web 控制台端口
  -p 8081:8081 \  # Coordinator 端口
  -p 8082:8082 \  # Overlord 端口
  -p 8083:8083 \  # Broker 端口
  -p 8084:8084 \  # Router 端口
  -p 2181:2181 \  # ZooKeeper 端口
  --name druid-quickstart \
  apache/druid:latest \
  bin/start-micro-quickstart
```

启动后，访问 `http://localhost:8888` 打开 Druid Web 控制台。


### 4.3 Docker Compose 部署（多组件模式）
多组件模式适用于模拟生产环境，分离 Druid 各服务并使用外部依赖（如独立 ZooKeeper、PostgreSQL）。

#### 4.3.1 docker-compose.yml 示例
```yaml
version: '3.8'

services:
  # ZooKeeper 依赖
  zookeeper:
    image: zookeeper:3.8
    ports:
      - "2181:2181"
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
    volumes:
      - zk-data:/data
      - zk-datalog:/datalog

  # 元数据库（PostgreSQL）
  postgres:
    image: postgres:14
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: druid
      POSTGRES_USER: druid
      POSTGRES_PASSWORD: druid
    volumes:
      - pg-data:/var/lib/postgresql/data

  # Druid Coordinator（集群协调）
  coordinator:
    image: apache/druid:latest
    depends_on:
      - zookeeper
      - postgres
    ports:
      - "8081:8081"
    environment:
      - DRUID_XMX: "1g"
      - DRUID_XMS: "1g"
      - DRUID_CONFIG_COMMON: "common.runtime.properties"
      - DRUID_CONFIG_COORDINATOR: "coordinator.runtime.properties"
      - ZOOKEEPER_HOST: zookeeper
      - METADATA_STORAGE_TYPE: postgresql
      - METADATA_STORAGE_URL: jdbc:postgresql://postgres:5432/druid
      - METADATA_STORAGE_USER: druid
      - METADATA_STORAGE_PASSWORD: druid
    volumes:
      - druid-coordinator:/opt/druid/var

  # Druid Overlord（任务管理）
  overlord:
    image: apache/druid:latest
    depends_on:
      - zookeeper
      - postgres
    ports:
      - "8082:8082"
    environment:
      - DRUID_XMX: "1g"
      - DRUID_XMS: "1g"
      - DRUID_CONFIG_COMMON: "common.runtime.properties"
      - DRUID_CONFIG_OVERLORD: "overlord.runtime.properties"
      - ZOOKEEPER_HOST: zookeeper
      - METADATA_STORAGE_TYPE: postgresql
      - METADATA_STORAGE_URL: jdbc:postgresql://postgres:5432/druid
      - METADATA_STORAGE_USER: druid
      - METADATA_STORAGE_PASSWORD: druid
    volumes:
      - druid-overlord:/opt/druid/var

  # 更多服务（Broker、Router、Historical、MiddleManager）配置类似，略...

volumes:
  zk-data:
  zk-datalog:
  pg-data:
  druid-coordinator:
  druid-overlord:
```

#### 4.3.2 启动集群
```bash
docker-compose up -d
```


### 4.4 环境变量配置
Docker 镜像支持通过环境变量调整核心配置，关键参数如下：

| 环境变量                  | 描述                                  | 默认值                          |
|---------------------------|---------------------------------------|---------------------------------|
| `DRUID_XMX`               | JVM 最大堆内存                        | `1g`                            |
| `DRUID_XMS`               | JVM 初始堆内存                        | `1g`                            |
| `ZOOKEEPER_HOST`          | ZooKeeper 连接地址                    | `localhost:2181`                |
| `METADATA_STORAGE_TYPE`   | 元数据库类型（`postgresql`/`mysql`）   | `derby`（内置，仅单节点用）     |
| `METADATA_STORAGE_URL`    | 元数据库 JDBC URL                     | `jdbc:derby://localhost:1527/var/druid/metadata.db` |
| `METADATA_STORAGE_USER`   | 元数据库用户名                        | `druid`                         |
| `METADATA_STORAGE_PASSWORD` | 元数据库密码                         | `druid`                         |
| `DRUID_CONFIG_COMMON`     | 通用配置文件名                        | `common.runtime.properties`     |
| `DRUID_CONFIG_<ROLE>`     | 服务角色配置文件（如 `COORDINATOR`）   | `<role>.runtime.properties`     |


### 4.5 持久化数据
通过挂载卷（Volumes）持久化 Druid 数据和配置：
- 数据存储：`/opt/druid/var`（包含 segments、任务日志等）
- 配置文件：`/opt/druid/conf`（可挂载自定义配置文件覆盖默认值）

示例（挂载自定义配置）：
```bash
docker run -d \
  -v ./custom-conf:/opt/druid/conf \  # 挂载自定义配置
  apache/druid:latest
```


## 5. 配置参数说明
Druid 配置主要通过 `runtime.properties` 文件定义，Docker 镜像默认配置位于 `/opt/druid/conf`。关键配置项如下：

| 配置项                          | 描述                                  | 示例值                          |
|---------------------------------|---------------------------------------|---------------------------------|
| `druid.zk.service.host`         | ZooKeeper 地址                        | `zookeeper:2181`                |
| `druid.metadata.storage.connector.connectURI` | 元数据库连接 URI               | `jdbc:postgresql://postgres:5432/druid` |
| `druid.coordinator.startAsLeader` | Coordinator 是否以 leader 模式启动    | `true`                          |
| `druid.server.http.numThreads`   | HTTP 服务线程数                       | `60`                            |
| `druid.processing.buffer.sizeBytes` | 处理缓冲区大小                     | `134217728`（128MB）            |


## 6. 注意事项
- **生产环境建议**：单节点模式仅用于测试，生产环境需部署多节点集群，并使用外部 ZooKeeper 和元数据库。
- **资源配置**：根据数据规模调整 JVM 内存（`DRUID_XMX`/`DRUID_XMS`）和处理线程数，避免 OOM。
- **版本兼容性**：镜像标签与 Druid 版本对应（如 `apache/druid:28.0.0`），升级前参考官方迁移文档。
- **安全配置**：生产环境需启用 TLS、认证（如 LDAP）及网络隔离，避免直接暴露服务端口。


## 参考链接
- [Apache Druid 官方文档](https://druid.apache.org/docs/latest/)
- [Docker Hub 镜像页面](https://hub.docker.com/r/apache/druid)
- [Docker 快速入门教程](https://druid.apache.org/docs/latest/tutorials/docker.html)
- [Druid 配置参考](https://druid.apache.org/docs/latest/configuration/index.html)
