---
image: library/flink
description: "Apache Flink® 是一款功能强大的开源分布式流处理与批处理框架，具备低延迟、高吞吐的实时数据处理能力，支持事件时间语义与状态管理，可实现 Exactly-Once 数据一致性保障，广泛应用于实时数据分析、企业级 ETL、机器学习数据流处理及复杂事件检测等领域，通过统一的计算模型高效融合流批处理需求，为分布式数据处理提供稳定可靠的解决方案。"
source: https://xuanyuan.cloud/zh/r/library/flink
canonical: https://xuanyuan.cloud/zh/r/library/flink
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/flink" title="library/flink Docker 镜像中文简介、标签列表与拉取命令">library/flink 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache Flink Docker 镜像使用说明


## 快速参考

### 维护方  
[Apache Flink] 


### 获取帮助渠道  
- 官方 Apache Flink 邮件列表：[Apache Flink Mailing lists]   
- StackOverflow（标签 `apache-flink`）：[StackOverflow (tag `apache-flink`)]   


## 支持的标签及对应 Dockerfile 链接  

以下是各版本 Flink 镜像支持的标签，点击标签组可查看对应的 Dockerfile 源码：  

- [`2.1.0-scala_2.12-java21`, `2.1-scala_2.12-java21`, `scala_2.12-java21`, `2.1.0-java21`, `2.1-java21`, `java21`]   

- [`2.1.0-scala_2.12-java17`, `2.1-scala_2.12-java17`, `scala_2.12-java17`, `2.1.0-scala_2.12`, `2.1-scala_2.12`, `scala_2.12`, `2.1.0-java17`, `2.1-java17`, `java17`, `2.1.0`, `2.1`, `latest`]   

- [`2.1.0-scala_2.12-java11`, `2.1-scala_2.12-java11`, `scala_2.12-java11`, `2.1.0-java11`, `2.1-java11`, `java11`]   

- [`2.0.0-scala_2.12-java21`, `2.0-scala_2.12-java21`, `2.0.0-java21`, `2.0-java21`]   

- [`2.0.0-scala_2.12-java17`, `2.0-scala_2.12-java17`, `2.0.0-scala_2.12`, `2.0-scala_2.12`, `2.0.0-java17`, `2.0-java17`, `2.0.0`, `2.0`]   

- [`2.0.0-scala_2.12-java11`, `2.0-scala_2.12-java11`, `2.0.0-java11`, `2.0-java11`]   

- [`1.20.3-scala_2.12-java8`, `1.20-scala_2.12-java8`, `1.20.3-java8`, `1.20-java8`]   

- [`1.20.3-scala_2.12-java17`, `1.20-scala_2.12-java17`, `1.20.3-java17`, `1.20-java17`]   

- [`1.20.3-scala_2.12-java11`, `1.20-scala_2.12-java11`, `1.20.3-scala_2.12`, `1.20-scala_2.12`, `1.20.3-java11`, `1.20-java11`, `1.20.3`, `1.20`]   


## 快速参考（续）

### 问题反馈地址  
[]  


### 支持的架构  
（更多信息：[Docker 官方镜像架构说明] ）  
- `amd64`：[amd64/flink]   
- `arm64v8`：[arm64v8/flink]   


### 已发布镜像制品详情  
可查看 repo-info 仓库的 `repos/flink/` 目录：[repo-info repo's `repos/flink/` directory] （[历史记录] ）  
（包含镜像元数据、传输大小等信息）  


### 镜像更新  
- 关注 official-images 仓库的 `library/flink` 标签：[official-images repo's `library/flink` label]   
- 查看 official-images 仓库的 `library/flink` 文件：[official-images repo's `library/flink` file] （[历史记录] ）  


### 本文档来源  
[docs repo's `flink/` directory]   


## 什么是 Apache Flink？  
[Apache Flink]  是一款开源流处理框架，具备强大的流处理和批处理能力。  


## 如何使用 Docker 运行 Apache Flink？  
具体使用方法可参考官方文档：[Apache Flink Docker 部署指南]   


## 许可证  
本软件基于 Apache License 2.0 许可证发布（详见：[]  

Apache Flink、Flink®、Apache®、松鼠logo及Apache feather logo均为[Apache软件基金会] 的注册商标或商标。  

与所有 Docker 镜像一样，本镜像可能包含其他软件，这些软件可能采用其他许可证（如基础系统中的 Bash 等，以及主软件的直接或间接依赖）。  

部分自动检测到的附加许可证信息可在 [repo-info 仓库的 `flink/` 目录]  中查看。  

使用预构建镜像时，用户需自行确保其使用行为符合镜像中所有软件的相关许可证要求。
