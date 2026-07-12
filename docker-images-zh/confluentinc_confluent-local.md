---
image: confluentinc/confluent-local
description: "Confluent Local Docker镜像用于快速启动KRaft模式的Apache Kafka，支持零配置设置，包含Confluent Community RestProxy，适用于本地开发工作流，为实验性镜像，不支持生产环境。"
source: https://xuanyuan.cloud/zh/r/confluentinc/confluent-local
canonical: https://xuanyuan.cloud/zh/r/confluentinc/confluent-local
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/confluentinc/confluent-local" title="confluentinc/confluent-local Docker 镜像中文简介、标签列表与拉取命令">confluentinc/confluent-local 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Confluent Local Docker镜像

## 镜像概述和主要用途

Confluent Local Docker镜像是用于快速启动KRaft模式Apache Kafka®的Docker镜像，支持零配置设置。该镜像同时部署Apache Kafka与Confluent Community RestProxy，为实验性镜像，专为本地开发工作流构建，不正式支持生产环境工作负载。

对于Confluent企业版Kafka，请参考官方支持的[CP-Server](https://hub.docker.com/r/confluentinc/cp-server)镜像；对于Apache Kafka，请参见[CP-Kafka](https://hub.docker.com/r/confluentinc/cp-kafka)镜像。

## 核心功能和特性

- 默认以KRaft模式启动，无需额外配置
- 集成Confluent Community RestProxy，提供RESTful接口访问Kafka
- 零配置快速部署，简化本地开发环境搭建流程
- 实验性镜像，持续优化本地开发体验

## 使用场景和适用范围

适用于本地开发工作流，帮助开发者快速搭建Kafka环境进行开发和测试。**不建议用于生产环境**，生产环境请使用Confluent官方支持的企业版或Apache Kafka镜像。

## 使用方法和配置说明

### 基本使用

该Docker镜像默认以KRaft模式启动。

### 配置修改

如需修改默认配置，请参考[Confluent企业版Kafka配置参考](https://docs.confluent.io/platform/current/installation/docker/config-reference.html#confluent-enterprise-ak-configuration)。

## 资源

- [什么是Apache Kafka？](https://developer.confluent.io/learn-kafka)
- [Kafka的作用是什么？](https://developer.confluent.io/)

## 贡献

- [如何为源代码贡献？](https://github.com/confluentinc/kafka-images)
- [如何提交/跟踪问题？](https://github.com/confluentinc/kafka-images/issues)

## 许可证

使用此镜像受包含软件的许可条款约束。有关更多信息，请参考Confluent Docker镜像文档[参考](https://docs.confluent.io/platform/current/installation/docker/image-reference.html)。用于扩展和构建自定义Docker镜像的软件在Apache 2.0许可下可用。
