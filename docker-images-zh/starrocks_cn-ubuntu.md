---
image: starrocks/cn-ubuntu
description: "StarRocks是下一代高性能分析型数据仓库，采用MPP架构与全向量化执行引擎，支持实时更新的列式存储，提供实时、多维、高并发数据分析能力，并具备全定制化成本优化器和智能物化视图等功能。"
source: https://xuanyuan.cloud/zh/r/starrocks/cn-ubuntu
canonical: https://xuanyuan.cloud/zh/r/starrocks/cn-ubuntu
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/starrocks/cn-ubuntu" title="starrocks/cn-ubuntu Docker 镜像中文简介、标签列表与拉取命令">starrocks/cn-ubuntu 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# StarRocks Docker镜像文档

## 1. 镜像概述与主要用途

### 1.1 关于StarRocks
StarRocks是一款下一代高性能分析型数据仓库，支持实时、多维度、高并发的数据查询分析。其采用MPP（大规模并行处理）架构，配备全向量执行引擎、支持实时更新的列式存储引擎，并提供丰富功能特性，包括全自定义成本优化器（CBO）、智能物化视图等。StarRocks支持从多类数据源实时或批量接入数据，同时允许直接分析数据湖存储的数据，实现零数据迁移。

更多信息参见[官方文档](https://docs.starrocks.io/)。

### 1.2 架构组成
StarRocks集群由前端节点（FE）、后端节点（BE）及对象存储计算节点（CN，可选）组成。

#### 1.2.1 前端节点（FE）
FE负责元数据管理、客户端连接管理、查询规划及查询调度。每个FE节点在内存中存储并维护完整的元数据副本，确保各FE节点提供无差别的服务。FE节点支持三种角色：Leader、Follower和Observer。Follower节点通过类Paxos的BDB JE（Berkeley DB Java Edition）协议选举产生Leader。

#### 1.2.2 后端节点（BE）
BE负责数据存储与SQL执行。
- **数据存储**：BE具备数据存储能力，FE根据预设规则将数据分发至BE节点。BE对摄入的数据进行转换，按指定格式写入并生成索引。
- **SQL执行**：SQL查询到达后，FE将其解析为逻辑执行计划，再转换为可在BE上执行的物理计划。存储目标数据的BE直接执行查询，避免数据传输与复制，实现高性能查询。

#### 1.2.3 计算节点（CN）
CN是无状态的BE节点，数据存储于对象存储而非本地存储。CN节点负责数据加载、查询计算、缓存管理等任务。

## 2. 核心功能与特性

- **MPP架构**：采用大规模并行处理架构，支持集群横向扩展，提升数据处理能力。
- **全向量执行引擎**：通过向量化执行技术，大幅提升查询效率，降低CPU开销。
- **实时更新的列式存储引擎**：基于列式存储优化分析查询性能，同时支持数据实时更新。
- **全自定义成本优化器（CBO）**：智能选择最优查询执行计划，适配复杂数据分布与查询场景。
- **智能物化视图**：自动维护预计算结果，加速重复查询，降低计算资源消耗。
- **多源数据接入**：支持实时和批量数据从多种数据源（如Kafka、MySQL、HDFS等）接入。
- **数据湖零迁移分析**：直接查询数据湖（如S3、HDFS）中的数据，无需数据迁移。

## 3. 使用场景与适用范围

### 3.1 实时数据分析场景
适用于需要实时处理并分析流数据的业务，如实时监控、实时报表、实时决策支持等，支持毫秒级数据摄入与秒级查询响应。

### 3.2 多维度业务分析场景
支持复杂的多维度聚合查询，适用于企业BI分析、用户行为分析、销售数据分析等场景，满足业务人员灵活的即席查询需求。

### 3.3 高并发查询场景
通过优化的执行引擎与资源隔离机制，支持数千并发查询，适用于SaaS平台、内部数据分析平台等多用户同时访问的场景。

### 3.4 数据湖统一分析平台
支持直接查询存储在对象存储（如S3、GCS、MinIO）或HDFS中的数据，构建统一的数据分析平台，避免数据孤岛与冗余存储。

## 4. 使用方法与配置说明

### 4.1 Allin1单容器部署
Allin1模式将FE和BE节点整合至单个容器，适合快速体验和测试环境部署。

#### 4.1.1 部署步骤
参考[StarRocks基础快速入门](https://docs.starrocks.io/docs/quick_start/shared-nothing/)，通过单容器完成部署、数据加载与分析。

### 4.2 分离存储与计算部署（Docker Compose）
分离存储与计算模式将数据存储于对象存储（如MinIO、S3、GCS等），计算节点（CN）负责查询执行，适合生产环境或需要弹性扩展的场景。

#### 4.2.1 部署步骤
参考[共享数据快速入门](https://docs.starrocks.io/docs/quick_start/shared-data/)，使用Docker Compose部署StarRocks与MinIO。可修改Compose配置切换至S3、GCS、Azure等对象存储。

#### 4.2.2 Docker Compose配置示例
```yaml
version: '3'
services:
  starrocks-fe:
    image: docker.xuanyuan.run/starrocks/fe:latest
    ports:
      - "8030:8030"  # FE HTTP端口
      - "9020:9020"  # FE RPC端口
      - "9030:9030"  # FE MySQL协议端口
    environment:
      - FE_SERVERS=starrocks-fe:9010
      - FE_ID=1
    volumes:
      - fe_data:/opt/starrocks/fe/meta

  starrocks-be:
    image: docker.xuanyuan.run/starrocks/be:latest
    ports:
      - "8040:8040"  # BE HTTP端口
    environment:
      - BE_ADDR=starrocks-be:9050
      - FE_SERVERS=starrocks-fe:9010
    volumes:
      - be_data:/opt/starrocks/be/storage

  minio:
    image: docker.xuanyuan.run/minio/minio:latest
    ports:
      - "9000:9000"
      - "9001:9001"
    environment:
      - MINIO_ROOT_USER=minioadmin
      - MINIO_ROOT_PASSWORD=minioadmin
    command: server /data --console-address ":9001"
    volumes:
      - minio_data:/data

volumes:
  fe_data:
  be_data:
  minio_data:
```

### 4.3 Kubernetes部署（Helm/Operator）
通过StarRocks Helm Chart与Kubernetes Operator实现容器编排部署，适合大规模生产环境，支持自动扩缩容、滚动更新等特性。

#### 4.3.1 部署步骤
- 参考[Helm快速入门](https://docs.starrocks.io/docs/quick_start/helm/)部署Helm Chart。
- 参考[Operator仓库](https://github.com/StarRocks/starrocks-kubernetes-operator/blob/main/examples/starrocks/README.md)获取更多部署示例与配置说明。

## 5. 连接StarRocks数据库

### 5.1 端口映射配置
StarRocks默认通过MySQL协议端口（9030）提供客户端连接，需在部署时映射该端口。

#### 5.1.1 Docker Run端口映射
```bash
docker run -p 9030:9030 docker.xuanyuan.run/starrocks/allin1:latest
```

#### 5.1.2 Docker Compose端口映射
在Compose配置文件中添加端口映射：
```yaml
services:
  starrocks-fe:
    ports:
      - "9030:9030"  # MySQL协议端口
      - "8030:8030"  # FE HTTP端口（可选）
      - "9020:9020"  # FE RPC端口（可选）
```

### 5.2 使用MySQL客户端连接
#### 5.2.1 本地MySQL客户端
若已映射9030端口，通过本地MySQL客户端连接：
```bash
mysql -P9030 -h 127.0.0.1 -u root --prompt="StarRocks > " -p
```
> 初始状态下`root`用户无密码，输入密码时直接回车即可。

#### 5.2.2 容器内MySQL客户端
通过`docker compose exec`或`docker exec`命令使用容器内置MySQL客户端：
```bash
# Docker Compose环境
docker compose exec starrocks-fe mysql -P9030 -h127.0.0.1 -uroot --prompt="StarRocks > "

# 独立容器环境
docker exec -ti <container_name> mysql -P9030 -h127.0.0.1 -uroot --prompt="StarRocks > " -p
```
> 替换`<container_name>`为实际容器名称（如`starrocks-fe`）。

### 5.3 其他MySQL协议客户端
支持所有兼容MySQL协议的客户端（如DBeaver、Navicat等），连接时指定端口9030即可。
