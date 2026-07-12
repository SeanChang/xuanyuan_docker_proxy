---
image: epiclabs/kafka
description: "spotify/kafka的分支版本，升级了更新的Kafka版本，解决旧版本问题，集成ZooKeeper以简化部署。"
source: https://xuanyuan.cloud/zh/r/epiclabs/kafka
canonical: https://xuanyuan.cloud/zh/r/epiclabs/kafka
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/epiclabs/kafka" title="epiclabs/kafka Docker 镜像中文简介、标签列表与拉取命令">epiclabs/kafka 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述
该镜像为spotify/kafka的分支版本，主要特点是升级了更稳定的Kafka版本。最初开发目的是解决Kafka 0.8.x.x版本中存在的已知问题（KAFKA-1387）。与spotify/kafka类似，本镜像集成了ZooKeeper服务，提供开箱即用的Kafka+ZooKeeper部署方案，简化了使用流程，但也可能存在与原spotify/kafka类似的潜在问题。

## 核心功能与特性
- **升级Kafka版本**：相比spotify/kafka，使用了更新、更稳定的Kafka版本，提升了性能和可靠性
- **集成ZooKeeper**：内置ZooKeeper服务，无需单独部署，降低了分布式环境的搭建复杂度
- **问题修复**：针对Kafka 0.8.x.x版本的KAFKA-1387问题进行了优化，解决了旧版本的稳定性问题

## 使用场景与适用范围
适用于需要快速部署Kafka和ZooKeeper的开发、测试环境，尤其适合对Kafka版本有较高要求、希望避免旧版本已知问题，且需要简化部署流程的场景。不建议直接用于生产环境，生产环境需考虑更完善的集群配置和高可用方案。

## 使用方法与配置说明
### 基本部署
可参考spotify/kafka的使用方式启动容器，基本命令格式如下：
```bash
docker run -d --name kafka-container -p 2181:2181 -p 9092:9092 <镜像名称>
```
（注：需将`<镜像名称>`替换为该分支镜像的实际名称）

### 环境变量配置
继承自spotify/kafka的核心环境变量，主要包括：
- `ADVERTISED_HOST`：Kafka对外广告的主机地址，默认为容器IP
- `ADVERTISED_PORT`：Kafka对外广告的端口，默认为9092
- `KAFKA_PORT`：Kafka服务监听端口，默认为9092
- `ZOOKEEPER_PORT`：ZooKeeper服务监听端口，默认为2181

### 参考文档
更多配置细节可参考spotify/kafka官方文档：[https://hub.docker.com/r/spotify/kafka/](https://hub.docker.com/r/spotify/kafka/)
