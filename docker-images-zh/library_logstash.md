---
image: library/logstash
description: "Logstash是一款开源的事件和日志管理工具，它支持从文件、数据库、消息队列、网络服务等多种数据源高效收集事件与日志数据，通过内置的过滤、转换和解析功能对数据进行处理，并能将结构化或半结构化数据输出至Elasticsearch、Kibana等目标系统，广泛应用于日志分析、系统监控、故障排查及安全审计等场景，为用户提供全面的日志数据处理解决方案。"
source: https://xuanyuan.cloud/zh/r/library/logstash
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[library/logstash](https://xuanyuan.cloud/zh/r/library/logstash)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Logstash Docker镜像介绍


## 快速参考

### 维护方  
[Elastic团队]([])  


### 获取帮助渠道  
[Logstash Discuss论坛]([]) 和 [Elastic社区]([])  


## 支持的标签及对应Dockerfile链接  
- [`8.17.10`]([])  
- [`8.18.8`]([])  
- [`8.19.5`]([])  
- [`9.0.8`]([])  
- [`9.1.5`]([])  


## 快速参考（续）

### 问题反馈地址  
Logstash Docker镜像或Logstash相关问题：[[]]([])  


### 支持的架构  
（[更多信息]([])）  
- [`amd64`]([])  
- [`arm64v8`]([])  


### 镜像 artifact 详情  
[repo-info 仓库的 `repos/logstash/` 目录]([])（[历史记录]([])）  
（包含镜像元数据、传输大小等）  


### 镜像更新  
- [official-images 仓库的 `library/logstash` 标签]([])  
- [official-images 仓库的 `library/logstash` 文件]([])（[历史记录]([])）  


### 本描述的来源  
[docs 仓库的 `logstash/` 目录]([])（[历史记录]([])）  


## 什么是 Logstash？  
Logstash 是一款开源数据收集引擎，具备实时管道处理能力。它能动态整合来自不同来源的数据，并将数据标准化后发送到指定目标。  

数据收集通过多种可配置的输入插件实现，包括原始 socket/数据包通信、文件尾随和多种消息总线客户端。输入插件收集数据后，可由多个过滤器插件处理，对事件数据进行修改和注释。最后，事件通过输出插件路由到外部程序，如 Elasticsearch、本地文件和多种消息总线。  

> 如需了解更多 Logstash 信息，请访问 [www.elastic.co/products/logstash]([])  

![logo]([])  


## 关于本镜像  
默认分发版本受 Elastic License 管辖，包含[完整的免费功能]([])。  

查看详细发布说明请访问[此处]([])。  

未找到所需版本？查看所有支持的[历史版本]([])。  


## 如何使用本镜像  
**注意**：拉取镜像时需使用特定版本号标签，不支持 `latest` 标签。  

对于 6.4.0 之前的 Logstash 版本，完整的镜像、标签和文档列表可在 [docker.elastic.co]([]) 查看。  

完整 Logstash 文档请见[此处]([])。  

有关运行 Docker 镜像的具体说明，请参见 Logstash 文档的[此章节]([])。  


## 许可  
查看本镜像包含软件的许可信息，请访问[此处]([])。  

与所有 Docker 镜像一样，本镜像可能包含其他软件，这些软件可能采用其他许可（如基础发行版中的 Bash 等，以及主要软件的直接或间接依赖）。  

部分自动检测到的额外许可信息可在 [repo-info 仓库的 `logstash/` 目录]([]) 中找到。  

使用预构建镜像时，用户有责任确保对本镜像的任何使用均符合其中包含的所有软件的相关许可。
