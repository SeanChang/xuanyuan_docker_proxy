---
image: apache/skywalking-banyandb
description: "Apache Skywalking BanyanDB是Skywalking可观测性平台的时序数据库存储组件，用于高效存储和管理分布式系统的监控指标、追踪数据及日志，支持高吞吐、低延迟的数据读写与查询。"
source: https://xuanyuan.cloud/zh/r/apache/skywalking-banyandb
canonical: https://xuanyuan.cloud/zh/r/apache/skywalking-banyandb
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/skywalking-banyandb" title="apache/skywalking-banyandb Docker 镜像中文简介、标签列表与拉取命令">apache/skywalking-banyandb 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache SkyWalking BanyanDB 镜像文档


## 1. 镜像概述

### 1.1 简介
本镜像为 Apache SkyWalking BanyanDB 提供容器化部署支持，**非 ASF 官方发布版本**，仅为便捷使用而提供。官方推荐生产环境中优先通过源码构建部署（[Dockerfile 源码地址](https://github.com/apache/skywalking-banyandb/blob/main/banyand/Dockerfile)）。


### 1.2 主要用途
BanyanDB 是一款专为可观测性场景设计的数据库，核心用途包括：  
- 摄入、存储、分析可观测性数据（指标、分布式追踪、日志）  
- 作为 Apache SkyWalking 等 APM（应用性能监控）系统的底层数据存储引擎  
- 支撑微服务、云原生架构下的可观测性平台数据管理需求  


## 2. 核心功能与特性

### 2.1 多类型数据支持  
原生支持三类可观测性数据统一存储与查询：  
- **指标（Metrics）**：如服务响应时间、错误率、资源使用率等  
- **追踪（Tracing）**：分布式调用链、服务依赖关系等  
- **日志（Logging）**：应用运行日志、系统日志等  


### 2.2 场景化设计  
针对可观测性平台数据特点优化：  
- 高写入吞吐量：适配监控场景下高频数据采集需求  
- 灵活的数据模型：支持动态 Schema，适配不同来源的可观测性数据  
- 与 Apache SkyWalking 深度集成：无缝对接 SkyWalking 的数据采集与分析流程  


## 3. 使用场景与适用范围

### 3.1 典型场景  
- **微服务架构监控**：存储服务间调用链、性能指标，支撑服务健康度分析  
- **云原生环境可观测性**：容器、K8s 集群的资源监控与日志聚合  
- **APM 系统数据存储**：作为 SkyWalking 等工具的后端数据库，替代传统时序数据库  


### 3.2 适用范围  
- 开发/测试环境：快速搭建可观测性数据存储原型  
- 中小规模生产环境：轻量化部署场景（大规模场景建议源码构建并优化配置）  


## 4. 使用方法与配置说明

### 4.1 镜像获取  
通过 Docker Hub 拉取最新镜像：  
```bash
docker pull docker.xuanyuan.run/apache/skywalking-banyandb:latest
```


### 4.2 基本运行命令  
#### 4.2.1 独立模式启动  
以单节点独立模式运行 BanyanDB 服务（适用于测试或单机场景）：  
```bash
docker run docker.xuanyuan.run/apache/skywalking-banyandb:latest standalone
```  
- `standalone`：指定独立运行模式，自动初始化默认配置  


### 4.3 Docker Compose 示例  
以下为简单的 Compose 配置（适用于快速集成到本地可观测性平台）：  
```yaml
version: '3.8'
services:
  banyandb:
    image: docker.xuanyuan.run/apache/skywalking-banyandb:latest
    command: standalone
    ports:
      - "17912:17912"  # 默认 gRPC 端口（数据交互）
      - "17913:17913"  # HTTP 端口（指标/监控）
    volumes:
      - ./data:/data  # 持久化数据目录（需提前创建 ./data 目录）
    restart: unless-stopped
```  


### 4.4 配置说明  
#### 4.4.1 运行模式  
当前镜像支持 `standalone`（独立模式），更多模式（如集群模式）需通过配置文件自定义，详情参考 [官方文档](https://skywalking.apache.org/docs/skywalking-banyandb/latest/readme/)。  

#### 4.4.2 高级配置  
如需自定义端口、存储路径、数据保留策略等，可通过挂载配置文件实现：  
```bash
docker run -v /本地配置目录:/etc/banyandb \
  docker.xuanyuan.run/apache/skywalking-banyandb:latest \
  standalone --config /etc/banyandb/config.yaml
```  
配置文件规范参考 [BanyanDB 配置文档](https://skywalking.apache.org/docs/skywalking-banyandb/latest/setup/configuration/)。  


## 5. 注意事项  
1. **非官方发布提示**：本镜像仅为便捷使用，生产环境请优先通过源码构建（[构建指南](https://github.com/apache/skywalking-banyandb#building-from-source)）。  
2. **数据持久化**：容器默认无持久化存储，生产环境需通过 `-v` 挂载主机目录（如示例 4.3）。  
3. **性能调优**：大规模部署需调整 JVM 参数、存储引擎配置，详情参考 [官方性能调优文档](https://skywalking.apache.org/docs/skywalking-banyandb/latest/operation/performance-tuning/)。  


## 参考资料  
- [BanyanDB 官方文档](https://skywalking.apache.org/docs/skywalking-banyandb/latest/readme/)  
- [GitHub 源码仓库](https://github.com/apache/skywalking-banyandb)
