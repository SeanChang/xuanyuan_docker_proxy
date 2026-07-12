---
image: percona/mongodb_exporter
description: "MongoDB的Prometheus导出器，支持分片、复制和存储引擎相关监控指标"
source: https://xuanyuan.cloud/zh/r/percona/mongodb_exporter
canonical: https://xuanyuan.cloud/zh/r/percona/mongodb_exporter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/percona/mongodb_exporter" title="percona/mongodb_exporter Docker 镜像中文简介、标签列表与拉取命令">percona/mongodb_exporter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MongoDB Exporter

## 镜像概述和主要用途

MongoDB Exporter是一个Prometheus导出器，用于收集MongoDB数据库的监控指标，包括分片、复制和存储引擎等方面的性能数据。该实现能够处理MongoDB监控命令公开的所有指标，通过循环遍历诊断命令中公开的所有字段并尝试从中获取数据。

## 核心功能和特性

- **全面的指标收集**：支持MongoDB多种诊断命令提供的所有指标
- **灵活的指标来源**：能够从多种MongoDB诊断命令获取数据
- **兼容性模式**：支持旧版指标格式，简化迁移过程
- **自动发现**：可自动发现指定数据库中的集合
- **自定义监控对象**：允许指定要监控的集合和索引
- **集群感知**：提供集群角色标签，便于区分不同节点类型

## 指标来源

目前实现了以下指标来源：
- $collStats
- $indexStats
- getDiagnosticData
- replSetGetStatus
- serverStatus

## 与旧版的兼容性

| 旧版Percona MongoDB Exporter |
|-----------------------------|
| 旧版0.1x.y版本（原`master`分支）已迁移至`release-0.1x`分支。 |
| 如果考虑从旧版导出器迁移，可以使用`--compatible-mode`标志以旧指标名称公开指标。 |
| 这将简化向新版本的迁移过程。 |

## 使用场景和适用范围

- MongoDB数据库性能监控
- 与Prometheus和Grafana集成构建监控系统
- 支持独立MongoDB实例、副本集和分片集群
- 需要详细了解数据库、集合和索引性能的场景

## 使用方法和配置说明

### 构建方法

构建过程使用dockerized版本的goreleaser，无需安装Go环境：

```bash
make release
```

生成的二进制文件将位于`build`目录下：

```
├── build
│ ├── config.yaml
│ ├── mongodb_exporter_7c73946_checksums.txt
│ ├── mongodb_exporter-7c73946.darwin-amd64.tar.gz
│ ├── mongodb_exporter-7c73946.linux-amd64.tar.gz
│ ├── mongodb_exporter_darwin_amd64
│ │ └── mongodb_exporter <--- MacOS二进制文件
│ └── mongodb_exporter_linux_amd64
│     └── mongodb_exporter <--- Linux二进制文件
```

### Docker部署

Docker镜像可从Docker Hub获取：[percona/mongodb_exporter](https://hub.docker.com/repository/docker/percona/mongodb_exporter)

#### Docker Run示例

```bash
docker run -d -p 9216:9216 docker.xuanyuan.run/percona/mongodb_exporter \
  --mongodb.uri=mongodb://user:pass@mongodb-host:27017/admin?ssl=true \
  --compatible-mode
```

#### Docker Compose示例

```yaml
version: '3'
services:
  mongodb_exporter:
    image: docker.xuanyuan.run/percona/mongodb_exporter
    ports:
      - "9216:9216"
    command:
      - --mongodb.uri=mongodb://user:pass@mongodb:27017/admin?ssl=true
      - --compatible-mode
      - --mongodb.collstats-colls=testdb.testcol
    depends_on:
      - mongodb
  mongodb:
    image: docker.xuanyuan.run/mongo
    ports:
      - "27017:27017"
    environment:
      - MONGO_INITDB_ROOT_USERNAME=user
      - MONGO_INITDB_ROOT_PASSWORD=pass
```

### 权限配置

连接用户需要有足够的权限来查询所需的统计信息：

```javascript
{
  "role": "clusterMonitor",
  "db": "admin"
},
{
  "role": "read",
  "db": "local"
}
```

有关MongoDB角色的更多信息，请参阅[官方文档](https://docs.mongodb.com/manual/reference/built-in-roles/#mongodb-authrole-clusterMonitor)。

### 配置参数详解

#### 环境变量

| 环境变量 | 描述 | 示例 |
|---------|------|------|
| MONGODB_URI | MongoDB连接URI | mongodb://user:pass@127.0.0.1:27017/admin?ssl=true |

#### 命令行参数

| 参数 | 描述 | 示例 |
|------|------|------|
| -h, --help | 显示上下文相关帮助 | |
| --compatible-mode | 同时以新旧格式公开新指标 | |
| --discovering-mode | 启用从collstats-colls和indexstats-colls中设置的数据库自动发现集合 | |
| --mongodb.collstats-colls | 逗号分隔的要获取统计信息的数据库.集合列表 | --mongodb.collstats-colls=testdb.testcol1,testdb.testcol2 |
| --mongodb.direct-connect | 是否建立直接连接。如果指定了多个主机或使用SRV URI，则直接连接无效 | --mongodb.direct-connect=false |
| --mongodb.indexstats-colls | 逗号分隔的要获取索引统计信息的数据库.集合列表 | --mongodb.indexstats-colls=db1.col1,db1.col2 |
| --mongodb.uri | MongoDB连接URI (可通过MONGODB_URI环境变量设置) | --mongodb.uri=mongodb://user:pass@127.0.0.1:27017/admin?ssl=true |
| --mongodb.global-conn-pool | 使用全局连接池而不是为每个HTTP请求创建新连接 | |
| --web.listen-address | Web界面和遥测的监听地址 | --web.listen-address=":9216" |
| --web.telemetry-path | 指标公开路径 | --web.telemetry-path="/metrics" |
| --log.level | 仅记录给定严重性或更高级别的消息。有效值: [debug, info, warn, error] | --log.level="error" |
| --disable.diagnosticdata | 禁用从getDiagnosticData收集指标 | |
| --disable.replicasetstatus | 禁用从replSetGetStatus收集指标 | |
| --disable.dbstats | 禁用从dbStats收集指标 | |
| --version | 显示版本并退出 | |

### 使用示例

#### 基本运行

```bash
mongodb_exporter --mongodb.uri=mongodb://127.0.0.1:17001
```

#### 启用集合统计指标收集

```bash
mongodb_exporter --mongodb.uri=mongodb://127.0.0.1:17001 --mongodb.collstats-colls=db1.c1,db2.c2
```

#### 启用兼容性模式

启用兼容性模式后，导出器将同时以新的命名和标签模式以及版本1兼容的方式公开所有新指标：

```bash
mongodb_exporter --mongodb.uri=mongodb://127.0.0.1:17001 --compatible-mode
```

例如，新格式指标：
```
# HELP mongodb_ss_wt_log_log_bytes_written serverStatus.wiredTiger.log.
# TYPE mongodb_ss_wt_log_log_bytes_written untyped
mongodb_ss_wt_log_log_bytes_written 2.6208e+06
```

将同时以旧格式公开：
```
HELP mongodb_mongod_wiredtiger_log_bytes_total mongodb_mongod_wiredtiger_log_bytes_total
# TYPE mongodb_mongod_wiredtiger_log_bytes_total untyped
mongodb_mongod_wiredtiger_log_bytes_total{type="unwritten"} 2.6208e+06
```

## 集群角色标签

导出器在所有指标中设置了一些拓扑标签：

- **cl_role**: 集群角色，根据下表确定：

| 服务器类型 | 标签 |
|------------|------|
| mongos | mongos |
| 常规实例（主节点或从节点） | shardsvr |
| 仲裁节点 | shardsvr |
| 独立节点 | (空字符串) |

- **cl_id**: 集群ID
- **rs_nm**: 副本集名称
- **rs_state**: 副本集状态，是`getDiagnosticData()` -> `replSetGetStatus.myState`返回的整数。有关副本集状态值的详细信息，请查看[官方文档](https://docs.mongodb.com/manual/reference/replica-states/)。
