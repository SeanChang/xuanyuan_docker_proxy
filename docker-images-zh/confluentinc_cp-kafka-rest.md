---
image: confluentinc/cp-kafka-rest
description: "Confluent官方REST Proxy Docker镜像，用于部署和运行REST Proxy，支持在事件流平台中通过REST API与Kafka交互。"
source: https://xuanyuan.cloud/zh/r/confluentinc/cp-kafka-rest
canonical: https://xuanyuan.cloud/zh/r/confluentinc/cp-kafka-rest
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/confluentinc/cp-kafka-rest" title="confluentinc/cp-kafka-rest Docker 镜像中文简介、标签列表与拉取命令">confluentinc/cp-kafka-rest 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Confluent REST Proxy Docker镜像

## 镜像概述和主要用途
用于部署和运行Confluent REST Proxy的Docker镜像。该镜像允许通过REST API与Apache Kafka集群交互，实现消息的生产、消费及管理操作。源代码托管于[Github](https://github.com/confluentinc/cp-docker-images/)。

## 核心功能和特性
- 提供RESTful API接口，简化Kafka集群的访问与管理
- 支持与Confluent Platform其他组件（如Schema Registry、Kafka Connect）集成
- 可无缝融入安全的端到端事件流平台架构

## 使用场景和适用范围
适用于需要通过HTTP/HTTPS协议与Kafka集群交互的应用场景，包括跨语言服务集成、前端应用消息通信、第三方系统数据接入等。尤其适合构建基于事件驱动架构的分布式系统。

## 资源与文档

### 官方文档
- [Confluent REST Proxy文档](https://docs.confluent.io/current/kafka-rest/index.html)：包含快速入门指南、详细教程及API参考
- [Confluent Platform镜像文档](http://docs.confluent.io/current/cp-docker-images/docs/intro.html)：提供镜像使用指南、Docker Compose配置示例、参考文档及高级教程

### 示例项目
- [confluentinc/cp-demo](https://github.com/confluentinc/cp-demo)：本地可运行的GitHub示例，展示REST Proxy在安全端到端事件流平台中的应用，包含使用Confluent Control Center管理监控Kafka Connect、Schema Registry等组件的操作指南
- [confluentinc/examples](https://github.com/confluentinc/examples)：额外精选的本地可运行示例

## 贡献指南
贡献前请阅读项目贡献准则：
- 源代码：https://github.com/confluentinc/cp-docker-images
- 问题跟踪：https://github.com/confluentinc/cp-docker-images/issues

## 许可信息
使用此镜像需遵守其中包含软件的许可条款。详细信息请参考Confluent Docker镜像文档[参考](https://docs.confluent.io/platform/current/installation/docker/image-reference.html)。用于扩展和构建自定义Docker镜像的软件基于Apache 2.0许可协议提供。
