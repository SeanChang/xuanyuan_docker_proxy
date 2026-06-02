---
image: ubuntu/kafka
description: "Apache Kafka 是一个分布式事件流平台，它支持高吞吐量、低延迟的实时数据流处理与传输，可广泛应用于消息传递、日志聚合、实时分析、数据集成等场景，其长期维护轨道由 Canonical 负责，以确保平台在稳定性、安全性及功能迭代方面获得持续支持，为企业级用户提供可靠的事件流处理解决方案。"
source: https://xuanyuan.cloud/zh/r/ubuntu/kafka
canonical: https://xuanyuan.cloud/zh/r/ubuntu/kafka
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/kafka" title="ubuntu/kafka Docker 镜像中文简介、标签列表与拉取命令">ubuntu/kafka — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ubuntu/kafka" title="ubuntu/kafka Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ubuntu/kafka</a>

# Kafka Docker 镜像（基于 Ubuntu）


## 概述  
本文档介绍的 Kafka Docker 镜像由 Canonical 提供，基于 Ubuntu 系统构建。该镜像会持续接收安全更新，并同步升级至较新版本的 Kafka 或 Ubuntu。**此仓库可免费使用，且不受每用户速率限制。**


## 关于 Apache Kafka  
Apache Kafka 是一款开源的分布式事件流平台，适用于高性能数据管道、流处理分析及系统集成场景。详情可访问 [Apache Kafka 官网]([])。  
使用此镜像时，需配合 [Apache Zookeeper 镜像]([]) 运行。  

> **注意**：版本号 ≤3.1 的镜像基于 Dockerfile 构建；从 3.6.1 版本开始，镜像改为基于 Rocks 构建，入口点变更为 Pebble。更多信息可参考 [Rockcraft 文档]([])。


## 快速启动  
部署单节点 Kafka 容器前，需先部署 ZooKeeper 服务并确保 Kafka 可与其通信。步骤如下：  

### 1. 创建网络  
```bash  
docker network create -d bridge kafka-network  
```  

### 2. 部署 ZooKeeper  
```bash  
docker run --detach --name zookeeper --network kafka-network ubuntu/zookeeper:3.8-22.04_edge  
```  

### 3. 部署 Kafka  
```bash  
docker run --detach --name kafka --network kafka-network -p 9092:9092 ubuntu/kafka:3.9.1-22.04_edge  
```  


## 镜像标签与架构  

![LTS]([])  
LTS 通道提供长达 5 年的免费安全维护。  

![ESM]([])  
通过 Canonical 受限仓库，ESM 可提供长达 10 年的客户安全维护（[详情]([])）。  


| 通道标签                  | 支持截止日期 | 当前版本                  | 支持架构                          |  
|---------------------------|--------------|---------------------------|-----------------------------------|  
| `3.1-22.04_beta`          | -            | Kafka 3.1 on Ubuntu 22.04 LTS | `amd64`, `ppc64le`, `s390x`, `arm64` |  
| `3.1-22.04_edge`, `edge`, `latest` | -            | 同上                      | 同上                              |  
| `3.6-22.04_edge`          | -            | Kafka 3.6 on Ubuntu 22.04 LTS | `amd64`                           |  
| `3.9.1-22.04_edge`        | 2027-02      | Kafka 3.9.1 on Ubuntu 22.04 LTS | `amd64`                           |  


### 通道说明  
通道标签按稳定性排序：`stable`（最稳定）、`candidate`、`beta`、`edge`（风险较高）。若列出 `beta`，则 `edge` 也可用；若列出 `candidate`，则 `beta` 和 `edge` 可用；`stable` 则包含所有通道。镜像会按 `edge` → `beta` → `candidate` → `stable` 顺序更新。  


### 商业使用与 ESM 通道  
若涉及商业分发，或需使用 ESM 通道/未列出的版本，请联系 Canonical 团队（[官网]([]) 或邮箱 [邮箱已删除]）。  


## 使用方法  

### 本地启动  
```bash  
docker run -d --name kafka-container -e TZ=UTC -p 9092:9092 ubuntu/kafka:3.1-22.04_beta  
```  
启动后，可通过 `[] 访问 Kafka 服务。  


### 参数说明  

| 参数                                  | 描述                                                                 |  
|---------------------------------------|----------------------------------------------------------------------|  
| `-e TZ=UTC`                           | 设置时区（示例为 UTC）。                                             |  
| `-e ZOOKEEPER_HOST=<zookeeper>`       | 指定关联的 ZooKeeper 实例主机名（如 `zookeeper`）。                  |  
| `-e ZOOKEEPER_PORT=2181`              | 指定关联的 ZooKeeper 实例端口（默认 2181）。                         |  
| `-p 9092:9092`                        | 将 Kafka 服务暴露在本地 `9092` 端口。                                |  
| `-v /path/to/config/file:/etc/kafka/server.properties` | 挂载本地 Kafka 配置文件（替换默认配置）。                            |  
| `-v kafkaData:/var/lib/kafka`         | 将数据持久化到 Docker 卷 `kafkaData`，需确保与配置 `logs.dirs` 一致。 |  


### 测试与调试  

#### 查看容器日志  
```bash  
docker logs -f kafka-container  
```  

#### 进入容器终端  
```bash  
docker exec -it kafka-container /bin/bash  
```  


## 问题反馈  
若发现镜像 bug 或需请求功能，请在 Launchpad 提交工单：  
[[]]([])  

**工单标题格式**：`kafka: <问题摘要>`，并附上镜像完整 digest（通过以下命令获取）：  
```bash  
docker images --no-trunc --quiet ubuntu/kafka:<tag>  
```  


## 已弃用通道与标签  
以下通道（标签）不再更新，请升级至新版本；若无法升级，可 [联系 Canonical]([])。  

| 通道   | 版本   | 停止维护日期 | 升级路径 |  
|--------|--------|--------------|----------|  
| `track`|        |              |          |
