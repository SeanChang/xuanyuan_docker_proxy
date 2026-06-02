---
image: knowstreaming/knowstreaming-manager
description: "KnowStreaming管理端镜像，用于Kafka集群的可视化监控、管理与运维，支持主题管理、消费者组监控、性能指标分析等核心功能，帮助用户简化Kafka运维工作。"
source: https://xuanyuan.cloud/zh/r/knowstreaming/knowstreaming-manager
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[knowstreaming/knowstreaming-manager](https://xuanyuan.cloud/zh/r/knowstreaming/knowstreaming-manager)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# KnowStreaming Manager 镜像文档

## 概述
KnowStreaming Manager 是开源Kafka监控运维平台KnowStreaming的管理端组件，提供基于Web界面的可视化操作，用于Kafka集群的全生命周期管理与监控。该镜像封装了KnowStreaming管理端服务，可快速部署并接入Kafka集群，帮助用户实时掌握集群状态、管理资源配置、分析性能瓶颈。

## 核心功能和特性
- **集群监控**：实时展示Kafka集群健康状态，包括Broker存活状态、分区分布、副本同步情况等
- **主题管理**：支持主题的创建、修改（分区数、副本数等）、删除及配置参数管理
- **消费者组监控**：可视化展示消费者组消费进度、延迟情况、消费速率等关键指标
- **性能分析**：采集并展示Broker、Topic、分区级别的性能指标（吞吐量、延迟、请求量等）
- **告警机制**：支持自定义告警规则，对异常指标（如Broker宕机、消费延迟超限）触发告警通知
- **配置管理**：集中管理Kafka集群配置参数，支持配置版本记录与回溯

## 使用场景
- 企业级Kafka集群日常运维与监控
- 开发/测试环境Kafka资源快速管理
- Kafka集群性能瓶颈分析与优化
- 多Kafka集群统一管理与监控

## 使用方法和配置说明

### 前置条件
- 已部署Kafka集群（支持Kafka 0.10.x及以上版本）
- 已部署MySQL数据库（用于存储KnowStreaming元数据）
- 网络环境需开放容器与Kafka集群、MySQL之间的通信端口

### 快速启动（docker run）
```bash
docker run -d \
  --name knowstreaming-manager \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://mysql-host:3306/knowstreaming?useUnicode=true&characterEncoding=utf8&useSSL=false" \
  -e SPRING_DATASOURCE_USERNAME="root" \
  -e SPRING_DATASOURCE_PASSWORD="password" \
  -e KAFKA_CLUSTER_NAME="default-cluster" \
  -e KAFKA_BOOTSTRAP_SERVERS="kafka-broker1:9092,kafka-broker2:9092" \
  knowstreaming/knowstreaming-manager:latest
```

### 关键环境变量配置
| 环境变量名                  | 说明                                  | 默认值                  |
|---------------------------|-------------------------------------|-----------------------|
| `SPRING_DATASOURCE_URL`    | MySQL数据库连接URL                     | -                     |
| `SPRING_DATASOURCE_USERNAME` | MySQL数据库用户名                       | -                     |
| `SPRING_DATASOURCE_PASSWORD` | MySQL数据库密码                         | -                     |
| `KAFKA_CLUSTER_NAME`       | 待管理的Kafka集群名称                    | `default`             |
| `KAFKA_BOOTSTRAP_SERVERS`  | Kafka集群bootstrap.servers地址         | `localhost:9092`      |
| `SERVER_PORT`              | 管理端服务端口                          | `8080`                |
| `LOG_LEVEL`                | 日志级别（DEBUG/INFO/WARN/ERROR）       | `INFO`                |
| `ALERT_ENABLED`            | 是否启用告警功能（true/false）           | `true`                |

### 访问管理界面
服务启动后，通过浏览器访问 `http://<容器IP或主机IP>:8080`，使用默认账号密码（admin/admin）登录，首次登录需修改密码。

### 持久化配置
为避免容器重启后配置丢失，建议挂载配置目录：
```bash
docker run -d \
  --name knowstreaming-manager \
  -p 8080:8080 \
  -v /path/to/local/config:/app/config \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://mysql-host:3306/knowstreaming" \
  ...（其他环境变量）
  knowstreaming/knowstreaming-manager:latest
```

### 注意事项
- MySQL数据库需提前创建`knowstreaming`数据库，并执行初始化SQL脚本（可从KnowStreaming官方仓库获取）
- Kafka集群需配置允许管理端访问的权限（如通过ACL配置）
- 生产环境建议使用docker-compose或Kubernetes进行部署，确保高可用性
