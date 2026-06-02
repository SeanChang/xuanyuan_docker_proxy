---
image: elastic/filebeat
description: "由Elastic官方维护的Filebeat Docker镜像是轻量级日志采集工具Filebeat的容器化版本，作为Elastic Stack（ELK Stack）的核心组件之一，它专为在Docker等容器环境中高效收集、传输服务器、应用程序或容器生成的日志数据而设计，支持多种日志输入源（如文件、标准输出等）和输出目标（如Elasticsearch、Logstash等），能够简化日志采集流程，助力用户实现日志的集中管理、实时分析与可视化监控。"
source: https://xuanyuan.cloud/zh/r/elastic/filebeat
canonical: https://xuanyuan.cloud/zh/r/elastic/filebeat
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/elastic/filebeat" title="elastic/filebeat Docker 镜像中文简介、标签列表与拉取命令">elastic/filebeat — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/elastic/filebeat" title="elastic/filebeat Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/elastic/filebeat</a>

## Elastic Filebeat Docker镜像介绍  


### 简介  
本Docker镜像是由Elastic官方开发的Filebeat容器化部署方案，用于在Docker环境中快速运行Filebeat日志收集工具。  


### 基本信息  
Filebeat是Elastic Stack中的轻量级日志数据收集器，可实时监控指定日志文件或目录，将数据转发至Elasticsearch、Logstash等服务进行存储和分析。该官方镜像封装了Filebeat的核心功能，便于用户通过容器化方式简化部署、配置和管理流程。  


### 使用参考  
关于镜像的详细配置方法、运行参数及最佳实践，可参考以下官方文档：  
- [Filebeat Docker运行指南]([])  
- [Elastic Docker镜像仓库]([])  


通过上述资源，用户可根据实际需求调整容器配置（如日志路径挂载、输出目标设置等），实现Filebeat在Docker环境中的高效运行。
