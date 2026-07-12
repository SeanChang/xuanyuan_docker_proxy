---
image: starrocks/allin1-ubuntu
description: "starrocks/allin1-ubuntu 是基于 Ubuntu 系统构建的 StarRocks 集成版 Docker 镜像，整合了 StarRocks 所有核心组件（FE、BE、Broker 等），支持一键启动完整集群环境。该镜像专为开发测试、快速体验及学习研究设计，无需复杂配置即可运行高性能分析型数据库，帮助用户便捷探索 StarRocks 的实时分析、高并发查询等核心能力，是轻量化部署和功能验证的理想选择。"
source: https://xuanyuan.cloud/zh/r/starrocks/allin1-ubuntu
canonical: https://xuanyuan.cloud/zh/r/starrocks/allin1-ubuntu
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/starrocks/allin1-ubuntu" title="starrocks/allin1-ubuntu Docker 镜像中文简介、标签列表与拉取命令">starrocks/allin1-ubuntu 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# StarRocks Docker 镜像使用说明


## 什么是 StarRocks？

StarRocks 是一款下一代高性能分析型数据仓库，支持实时、多维、高并发的数据分析。它采用 MPP 架构，配备全向量化执行引擎、支持实时更新的列式存储引擎，并提供丰富功能，包括全自定义基于成本的优化器（CBO）、智能物化视图等。StarRocks 支持从多种数据源进行实时和批量数据摄入，还可零数据迁移直接分析数据湖中的数据。

更多信息参见 [StarRocks 官方文档] 。


### 架构说明

StarRocks 由前端（FE）、后端（BE）节点组成，若使用对象存储计算模式，还需包含计算节点（CN）。


#### FE 节点
FE 节点负责元数据管理、客户端连接管理、查询规划与调度。每个 FE 节点在内存中存储完整的元数据副本，确保服务无差别。FE 节点分为 leader、follower 和 observer 三种角色，follower 节点通过类 Paxos 的 BDB JE 协议（BDB JE 即 Berkeley DB Java Edition）选举 leader。


#### BE 节点
BE 节点负责数据存储与 SQL 执行。

##### 数据存储
BE 节点具备数据存储能力。FE 节点按预设规则将数据分发至 BE 节点，BE 节点对摄入的数据进行转换、按指定格式写入并生成索引。

##### SQL 执行
当 SQL 查询请求到达时，FE 节点根据查询语义解析为逻辑执行计划，再转换为可在 BE 节点执行的物理执行计划。最终由存储目标数据的 BE 节点直接执行查询，避免数据传输与复制，实现高效查询性能。


#### CN 节点
CN 节点是无状态 BE 节点，数据存储于对象存储而非本地存储。其主要负责数据加载、查询计算、缓存管理等任务。

[架构详情文档] 


## 如何使用本镜像

以下场景均提供快速入门教程（分步指南），可按需参考。


### 一体化部署（Allin1）

通过 [StarRocks 基础教程]  部署单个容器（含 FE 和 BE 节点），完成数据加载与分析。


### 分离存储与计算

按共享数据模式 [快速入门教程]  部署 StarRocks 与 MinIO。可修改提供的 Docker Compose 文件，切换至 S3、GCS、Azure 或其他对象存储。

[Compose 文件下载] 


### Helm/Operator 部署

通过 StarRocks Helm 图表和 Kubernetes Operator 部署：

[快速入门教程] 

[Operator 仓库] （含更多示例）


## 通过 MySQL 客户端连接 StarRocks

使用 MySQL 协议连接 StarRocks 的默认端口为 `9030`。


### 暴露端口配置
Docker Compose 文件中通常通过以下配置暴露端口：
```yaml
    ports:
      - "8030:8030"
      - "9020:9020"
      - "9030:9030"
```

若通过命令行运行容器，可通过类似以下命令暴露端口：
```bash
docker run -p 9030:9030 ...
```


### 连接命令示例
若已暴露 9030 端口，可通过以下命令连接：
```bash
mysql -P9030 -h 127.0.0.1 -u root --prompt="StarRocks > " -p
```
若未配置 root 密码，直接按回车即可。

也可使用容器内自带的 MySQL 客户端：
```bash
docker compose exec starrocks-fe \
mysql -P9030 -h127.0.0.1 -uroot --prompt="StarRocks > "
```
或
```bash
docker exec -ti starrocks-fe mysql -P9030 -h127.0.0.1 -uroot --prompt="StarRocks > " -p
```

> 提示：上述 exec 命令中，需将 `starrocks-fe` 替换为实际的服务名或容器名。


### 其他客户端连接
支持 MySQL 协议的客户端（如 DBeaver）均可连接，只需将默认 MySQL 端口替换为 9030 即可。
