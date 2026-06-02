---
image: tdengine/tdengine
description: "Docker镜像tdengine/tdengine提供涛思数据自主研发的高性能时序数据库TDengine，专为物联网、工业互联网、车联网等时序数据密集型场景设计，具备千万级数据点写入能力、毫秒级查询响应、内置流计算与缓存机制，支持集群部署、数据自动压缩与生命周期管理，帮助用户高效存储、分析海量时序数据，简化时序数据库部署与运维流程。"
source: https://xuanyuan.cloud/zh/r/tdengine/tdengine
canonical: https://xuanyuan.cloud/zh/r/tdengine/tdengine
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/tdengine/tdengine" title="tdengine/tdengine Docker 镜像中文简介、标签列表与拉取命令">tdengine/tdengine — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/tdengine/tdengine" title="tdengine/tdengine Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/tdengine/tdengine</a>

# TDengine 简介及 Docker 部署指南


## 什么是 TDengine？

TDengine 是一款开源、高性能、云原生的时序数据库，专为物联网（IoT）、车联网、工业物联网等场景优化。它能高效处理每日 TB 甚至 PB 级别的数据，支持数十亿传感器和数据采集点的实时写入、处理与监控。相较于其他时序数据库，TDengine 具有以下核心优势：

- **高性能**：解决了高基数问题，可支持数十亿数据采集点，同时在数据写入、查询和压缩效率上显著优于同类产品。  
- **简化方案**：内置缓存、流处理和数据订阅功能，提供一站式时序数据处理方案，大幅降低系统设计复杂度和运维成本。  
- **云原生**：原生分布式架构，支持分片分区、存算分离、RAFT 协议，可部署于 Kubernetes，提供全可观测性，适配公有云、私有云及混合云环境。  
- **易用性**：管理员部署维护更轻松，开发者接口简洁、集成第三方工具便捷，数据用户可快速访问数据。  
- **高效数据分析**：通过超级表、存算分离、时间分区、预计算等机制，高效实现数据探索、格式化与访问。  
- **开源特性**：核心模块（含集群功能）均开源，GitHub 星标数达 19.9k，全球有 13.9 万+运行实例，社区活跃。

想体验 TDengine 最简单的方式是通过 [TDengine Cloud]([])。


## 如何通过 Docker 运行 TDengine

> **注意**：从 3.3.7.0 版本开始，TDengine 的 Docker 镜像名称变更为 `tdengine/tsdb`。


### 步骤 1：在 Docker 中启动 TDengine 服务端

执行以下命令启动 TDengine 容器，映射必要端口并配置数据持久化：

```bash
docker run -d \
  --name tdengine \
  --hostname tdengine-server \
  -p 6030-6060:6030-6060 \
  -p 6030-6060:6030-6060/udp \
  -v ~/work/taos/log:/var/log/taos \
  -v ~/work/taos/data:/var/lib/taos \
  tdengine/tdengine
```

**参数说明**：  
- `--name tdengine`：指定容器名称，便于后续操作。  
- `--hostname tdengine-server`：设置容器主机名，避免 IP 变化导致连接问题。  
- `-p 6030-6060:6030-6060`：映射 TCP 端口（6030-6060 为 TDengine 默认端口范围）。  
- `-p 6030-6060:6030-6060/udp`：映射 UDP 端口，支持客户端通信。  
- `-v`：挂载主机目录到容器，用于持久化日志和数据，防止容器删除后数据丢失。  


### 步骤 2：验证容器运行状态

使用 `docker ps` 命令检查容器是否正常启动：

```bash
docker ps
```

输出示例：  
```
CONTAINER ID   IMAGE               COMMAND   CREATED          STATUS          PORTS                                                                                    NAMES
c452519b0f9b   tdengine/tdengine   "taosd"   14 minutes ago   Up 14 minutes   0.0.0.0:6030-6060->6030-6060/tcp, 0.0.0.0:6030-6060->6030-6060/udp                       tdengine
```

**关键信息**：  
- `STATUS` 为 `Up` 表示容器运行中。  
- `PORTS` 显示端口映射成功。  


### 步骤 3：进入容器操作 TDengine

通过 `docker exec` 命令进入容器内部，使用 TDengine Shell（`taos`）进行交互：

```bash
docker exec -it tdengine /bin/bash
```

进入容器后，启动 `taos` 客户端：

```bash
root@tdengine-server:~# taos

Welcome to the TDengine shell from Linux, Client Version:2.0.20.13
Copyright (c) 2020 by TAOS Data, Inc. All rights reserved.

taos> 
```

成功连接后，可通过 SQL 命令创建数据库、表、超级表，执行插入和查询操作（详见 [TAOS SQL 文档]([])）。


### 步骤 4：从主机访问容器内的 TDengine 服务

配置端口映射后，可直接从主机通过 `taos` 命令或 RESTful 接口访问容器内的 TDengine。


#### 方式 1：使用 TDengine Shell 访问

在主机终端直接执行 `taos`：

```bash
taos

Welcome to the TDengine shell from Linux, Client Version:2.0.22.3
Copyright (c) 2020 by TAOS Data, Inc. All rights reserved.

taos>
```

#### 方式 2：通过 RESTful 接口访问

使用 `curl` 访问容器的 6041 端口（RESTful 默认端口）：

```bash
curl -u root:taosdata -d 'show databases' 127.0.0.1:6041/rest/sql
```

成功响应示例（部分）：  
```json
{"status":"succ","head":["name","created_time",...],"data":[["test","2021-08-18 06:01:11.021",...]],"rows":2}
```

更多 RESTful 接口细节见 [官方文档]([])。


### 步骤 5：运行包含 taosAdapter 的 TDengine 容器

TDengine 2.4.0.0 及以上版本的 Docker 镜像内置 `taosAdapter` 组件，支持通过 RESTful 接口写入/查询数据，并兼容 InfluxDB/OpenTSDB 的数据接入协议，便于应用平滑迁移。


#### 启动带 taosAdapter 的容器

```bash
docker run -d \
  --name tdengine-taosa \
  -p 6030-6060:6030-6060 \
  -p 6030-6060:6030-6060/udp \
  tdengine/tdengine:2.4.0.0
```

> **注意**：taosAdapter 可能需要额外端口映射，具体端口见 [taosAdapter 文档]([])。


#### 验证 taosAdapter 功能

1. **通过 RESTful 接口查询**：  
   ```bash
   curl -H 'Authorization: Basic cm9vdDp0YW9zZGF0YQ==' -d 'show databases;' 127.0.0.1:6041/rest/sql
   ```

2. **模拟 StatsD 数据写入**：  
   ```bash
   echo "foo:1|c" | nc -u -w0 127.0.0.1 6044  # 向 6044 端口发送 StatsD 格式数据
   ```

3. **在 TDengine Shell 中查询结果**：  
   ```sql
   taos> use statsd;
   taos> select * from foo;  # 可看到写入的模拟数据
   ```


### 应用示例：通过 taosdemo 向容器内 TDengine 写入数据

`taosdemo` 是 TDengine 提供的数据生成工具，可快速模拟海量时序数据写入。


#### 步骤 1：在主机运行 taosdemo

```bash
taosdemo
```

按提示输入后，工具会自动创建数据库 `test`、超级表 `meters`，并生成 10000 张子表（`d0` 至 `d9999`），每张表插入 10000 条记录（共 1 亿条数据）。


#### 步骤 2：在 TDengine Shell 中验证数据

1. **查看数据库**：  
   ```sql
   taos> show databases;
   ```

2. **查看超级表**：  
   ```sql
   taos> use test;
   taos> show stables;  # 应显示超级表 meters
   ```

3. **查询子表数据**：  
   ```sql
   taos> select * from d0 limit 10;  # 查看 d0 表前 10 条记录
   ```

4. **查看标签信息**：  
   ```sql
   taos> select groupid, location from d0;  # 查看 d0 表的标签（groupId 和 location）
   ```


## 停止 Docker 中的 TDengine 服务

```bash
docker stop tdengine  # tdengine 为容器名称
```


通过以上步骤，可快速部署 TDengine 并体验其数据写入、查询能力。更多功能可参考 [TDengine 官方文档]([])。
