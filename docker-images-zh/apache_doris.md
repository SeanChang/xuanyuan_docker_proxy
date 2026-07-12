---
image: apache/doris
description: "此镜像为Apache Doris的构建环境镜像，Apache Doris是一款开源的高性能MPP分析型数据库，主要用于支持大规模数据的实时分析与查询，该构建环境镜像集成了编译、构建Apache Doris源码所需的各类依赖工具、环境配置及相关组件，能够帮助开发者或用户快速搭建稳定、一致的构建环境，以便高效地进行源码编译、版本构建及后续的开发测试工作。"
source: https://xuanyuan.cloud/zh/r/apache/doris
canonical: https://xuanyuan.cloud/zh/r/apache/doris
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/doris" title="apache/doris Docker 镜像中文简介、标签列表与拉取命令">apache/doris 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache Doris Docker Hub 镜像说明


## 镜像类型

本仓库包含两类镜像：


### 构建环境镜像  
名称格式为 `build-env-xxx` 的镜像，主要用于从源码编译 Apache Doris。


### 运行时镜像  
以下为 Doris 运行时镜像，适用于容器环境部署 Doris 服务：  

1. **fe-xxx**：Doris 的 FE（Frontend）镜像。  
2. **be-xxx**：Doris 的 BE（Backend）镜像。  
3. **broker-xxx**：Doris 的 Broker 镜像。  
4. **ms-xxx**：Doris 的 Metaservice 镜像，仅用于存算分离架构。  
5. **operator-xxx**：[doris-operator]  镜像，用于在 Kubernetes 上创建、配置和管理 Doris 集群。  
6. **base-latest**：构建 Doris 运行时镜像的基础镜像，包含调试工具。  
7. **debug-latest**：用于 Doris 组件崩溃时的调试工具镜像。  


### 运行时镜像说明  
- 基于 Ubuntu 22.04 系统构建，支持 amd64 和 arm64 两种 CPU 架构。  
- amd64 架构仅支持具备 AVX2 指令集的版本。若主机不支持 AVX2 指令集，需参考 Doris GitHub 上的 Docker 镜像创建章节（[]  


## 快速部署指南  

1. [通过 Docker Compose 快速开始]   
2. [在 Kubernetes 上部署]   


## 关于 Apache Doris  

Apache Doris 是一款基于 MPP 架构的易用、高性能实时分析数据库，以极致速度和易用性为核心特点。在海量数据场景下，可提供亚秒级查询响应，并同时支持高并发点查询和高吞吐复杂分析场景。  


### 相关链接  
- **GitHub 仓库**：[]  
- **官方网站**：[]
