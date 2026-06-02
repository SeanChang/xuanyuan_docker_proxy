---
image: starrocks/fe-ubuntu
description: "starrocks/fe-ubuntu 是 StarRocks 高性能分析型数据库的前端（FE）节点 Docker 镜像，基于 Ubuntu 系统构建。FE 作为 StarRocks 的核心组件，负责元数据管理、查询解析与优化、集群协调等关键任务，支撑数据库高效运行。依托 Ubuntu 稳定的系统环境，镜像具备良好兼容性和依赖管理能力，可快速部署于各类容器化平台。适用于企业级实时数据分析、大规模数据仓库构建等场景，助力用户简化部署流程，高效支持 OLAP 任务稳定运行。"
source: https://xuanyuan.cloud/zh/r/starrocks/fe-ubuntu
canonical: https://xuanyuan.cloud/zh/r/starrocks/fe-ubuntu
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/starrocks/fe-ubuntu" title="starrocks/fe-ubuntu Docker 镜像中文简介、标签列表与拉取命令">starrocks/fe-ubuntu — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/starrocks/fe-ubuntu" title="starrocks/fe-ubuntu Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/starrocks/fe-ubuntu</a>

# StarRocks Docker 镜像使用指南


## 关于 StarRocks

StarRocks 是一款下一代高性能分析型数据仓库，支持实时、多维、高并发的数据分析场景。它采用 MPP 架构，配备全向量化执行引擎、支持实时更新的列存引擎，并提供丰富特性，包括全自定义成本优化器（CBO）、智能物化视图等。StarRocks 支持从多种数据源实时或批量接入数据，也能直接分析数据湖中的数据，无需迁移。

更多信息参见 [StarRocks 官方文档]([])


### 架构组成

StarRocks 由前端（FE）、后端（BE）以及对象存储计算节点（CN）组成。


#### FE（前端节点）

FE 负责元数据管理、客户端连接管理、查询规划与调度。每个 FE 节点会在内存中存储并维护完整的元数据副本，因此所有 FE 节点功能对等，可提供一致服务。FE 节点支持三种角色：leader、follower 和 observer，follower 节点通过类 Paxos 协议的 BDB JE（Berkeley DB Java Edition）选举 leader。


#### BE（后端节点）

BE 负责数据存储与 SQL 执行。

##### 数据存储  
BE 具备数据存储能力。FE 会根据预设规则将数据分发至 BE 节点，BE 对接收的数据进行格式转换、写入并生成索引。

##### SQL 执行  
当 SQL 查询请求到达时，FE 先根据查询语义解析为逻辑执行计划，再转换为可在 BE 节点执行的物理计划。存储目标数据的 BE 节点直接执行查询，避免数据传输与复制，从而实现高效查询性能。


#### CN（计算节点）

CN 是无状态的 BE 节点，数据存储于对象存储而非本地存储。CN 节点主要负责数据加载、查询计算、缓存管理等任务。

[架构详情文档]([])


## 如何使用该镜像

针对以下场景，均提供快速启动教程（分步指南），帮助快速上手。


### Allin1 单容器部署

如需部署包含 FE 和 BE 的单容器实例，可参考 [StarRocks 基础快速启动]([])，完成容器部署、数据加载与分析操作。


### 存储计算分离部署

如需部署存储计算分离架构，可参考 [共享数据快速启动教程]([])，部署 StarRocks 与 MinIO。若需切换至 S3、GCS、Azure 等其他对象存储，可直接修改提供的 Docker Compose 文件。

[Compose 文件下载]([])


### Helm/Operator 部署

通过 StarRocks Helm 图表与 Kubernetes Operator 部署：

[Helm 快速启动教程]([])

[Operator 仓库]([])（含更多部署示例）


## 使用 MySQL 客户端连接 StarRocks

StarRocks 默认通过 MySQL 协议的 `9030` 端口提供连接服务。Docker Compose 文件中通常会通过以下配置暴露该端口：

```yaml
    ports:
      - "8030:8030"
      - "9020:9020"
      - "9030:9030"
```

若通过命令行运行容器，可使用类似以下命令暴露端口：

```bash
docker run -p 9030:9030 ...
```

暴露 9030 端口后，通过以下命令连接：

```bash
mysql -P9030 -h 127.0.0.1 -u root --prompt="StarRocks > " -p
```

若未为 `root` 用户配置密码，直接回车即可登录。

也可使用容器内自带的 MySQL 客户端：

```bash
docker compose exec starrocks-fe \
mysql -P9030 -h127.0.0.1 -uroot --prompt="StarRocks > "
```

或：

```bash
docker exec -ti starrocks-fe mysql -P9030 -h127.0.0.1 -uroot --prompt="StarRocks > " -p
```

> 提示  
> 上述命令中的 `starrocks-fe` 需替换为实际的服务名或容器名。


### DBeaver 等其他客户端

其他支持 MySQL 协议的客户端（如 DBeaver）也可连接，只需将默认 MySQL 端口替换为 9030 即可。
