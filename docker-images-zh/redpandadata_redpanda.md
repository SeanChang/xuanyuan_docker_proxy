---
image: redpandadata/redpanda
description: "Redpanda 是现代应用的实时引擎，专注于为各类现代应用提供高效、低延迟的实时数据处理支持，能够满足高并发场景下的数据传输与处理需求，为开发者构建响应迅速、性能卓越的现代应用系统提供可靠的实时引擎解决方案，助力现代应用在数据驱动的业务环境中实现高效的数据流转与即时响应。"
source: https://xuanyuan.cloud/zh/r/redpandadata/redpanda
canonical: https://xuanyuan.cloud/zh/r/redpandadata/redpanda
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/redpandadata/redpanda" title="redpandadata/redpanda Docker 镜像中文简介、标签列表与拉取命令">redpandadata/redpanda 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Redpanda


## 关于 Redpanda  
Redpanda 是一款面向关键业务负载的流处理平台。它兼容 Kafka® 协议，无需依赖 Zookeeper® 和 JVM，且无需修改现有代码即可直接使用。你可以沿用所有熟悉的开源工具，同时获得 10 倍性能提升。  

Redpanda 致力于为现代应用打造实时流处理引擎——无论是企业级系统，还是个人开发者在笔记本上原型开发的 React 应用，都能适配。除了兼容 Kafka 协议，它还前瞻性地支持内置 WASM 转换、地理复制分层存储等功能，形成一套能从最小项目扩展到全球分布式 PB 级数据处理的全新平台。  


## 社区互动  
- **Slack**：社区实时交流的主要渠道，点击 [加入] 。  
- **Github Discussions**：适合发起长周期、深度的异步讨论，访问 [这里] 。  
- **GitHub Issues**：仅用于提交实际问题，讨论请通过邮件列表进行，提交地址 [Issues] 。  
- **行为准则**：社区共同遵守的规范，查看 [详情] 。  


## 快速开始  
> **注意**：若需本地部署集群，推荐使用 `rpk container` 方式，详见 [文档] 。  


### 部署方式  
- **Docker Compose**：参考 [Docker Compose 部署文档] 。  
- **单节点部署**：参考 [快速入门指南] 。  


### 客户端连接  
部署完成后，将 Kafka 兼容客户端指向 `127.0.0.1:9092`，即可直接使用。
