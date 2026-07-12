---
image: nhost/postgres
description: "Nhost使用的PostgreSQL镜像，预安装多种扩展插件（如PostGIS、TimescaleDB、pgvector等），支持空间数据、时间序列、全文搜索等功能，适用于开发和生产环境的数据库部署。"
source: https://xuanyuan.cloud/zh/r/nhost/postgres
canonical: https://xuanyuan.cloud/zh/r/nhost/postgres
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/nhost/postgres" title="nhost/postgres Docker 镜像中文简介、标签列表与拉取命令">nhost/postgres 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PostgreSQL 镜像文档

## 镜像概述

本镜像为Nhost平台（http://www.nhost.io）使用的PostgreSQL数据库镜像，基于官方PostgreSQL构建，预安装了丰富的扩展插件，支持空间数据处理、时间序列分析、全文搜索、向量计算等多种高级功能，适用于开发环境和生产环境的数据库部署需求。

## 核心功能与特性

### 预安装扩展插件

| 扩展名称 | 版本 | 描述 |
|----------------|---------|-------------|
| address_standardizer | 3.5.3 | 用于将地址解析为组成元素，通常用于支持地理编码地址标准化步骤。 |
| address_standardizer_data_us | 3.5.3 | 地址标准化器美国数据集示例 |
| amcheck | 1.4 | 用于验证关系完整性的函数 |
| autoinc | 1.0 | 用于自动递增字段的函数 |
| bloom | 1.0 | bloom访问方法 - 基于签名文件的索引 |
| btree_gin | 1.3 | 支持在GIN中索引常见数据类型 |
| btree_gist | 1.7 | 支持在GiST中索引常见数据类型 |
| citext | 1.6 | 不区分大小写字符串的数据类型 |
| cube | 1.5 | 多维立方体的数据类型 |
| dblink | 1.2 | 从数据库内部连接到其他PostgreSQL数据库 |
| dict_int | 1.0 | 整数的文本搜索字典模板 |
| dict_xsyn | 1.0 | 扩展同义词处理的文本搜索字典模板 |
| earthdistance | 1.2 | 计算地球表面大圆距离 |
| file_fdw | 1.0 | 用于平面文件访问的外部数据包装器 |
| fuzzystrmatch | 1.2 | 确定字符串之间的相似度和距离 |
| hstore | 1.8 | 用于存储（键、值）对集合的数据类型 |
| http | 1.7 | PostgreSQL的HTTP客户端，允许在数据库内检索网页。 |
| hypopg | 1.4.2 | PostgreSQL的假设索引 |
| insert_username | 1.0 | 用于跟踪谁修改了表的函数 |
| intagg | 1.1 | 整数聚合器和枚举器（已过时） |
| intarray | 1.5 | 一维整数数组的函数、运算符和索引支持 |
| ip4r | 2.4 | - |
| isn | 1.2 | 国际产品编号标准的数据类型 |
| lo | 1.1 | 大对象维护 |
| ltree | 1.3 | 用于层次树状结构的数据类型 |
| moddatetime | 1.0 | 用于跟踪最后修改时间的函数 |
| pageinspect | 1.12 | 在底层检查数据库页面内容 |
| pg_buffercache | 1.5 | 检查共享缓冲区缓存 |
| pg_cron | 1.6 | PostgreSQL的作业调度器 |
| pg_freespacemap | 1.2 | 检查空闲空间映射（FSM） |
| pg_hashids | 1.3 | pg_hashids |
| pg_ivm | 1.11 | PostgreSQL的增量视图维护 |
| pg_jsonschema | 0.3.3 | pg_jsonschema |
| pg_prewarm | 1.2 | 预加载关系数据 |
| pg_repack | 1.5.2 | 以最小锁重组PostgreSQL数据库中的表 |
| pg_search | 0.17.2 | pg_search：使用BM25的PostgreSQL全文搜索 |
| pg_squeeze | 1.8 | 用于从关系中删除未使用空间的工具。 |
| pg_stat_statements | 1.11 | 跟踪所有执行的SQL语句的规划和执行统计信息 |
| pg_surgery | 1.0 | 用于对损坏关系执行修复的扩展 |
| pg_trgm | 1.6 | 基于三元组的文本相似度测量和索引搜索 |
| pg_visibility | 1.2 | 检查可见性映射（VM）和页面级可见性信息 |
| pg_walinspect | 1.1 | 检查PostgreSQL预写日志内容的函数 |
| pgcrypto | 1.3 | 加密函数 |
| pgmq | 1.6.1 | 轻量级消息队列。类似于AWS SQS和RSMQ，但基于Postgres。 |
| pgrowlocks | 1.2 | 显示行级锁定信息 |
| pgstattuple | 1.5 | 显示元组级统计信息 |
| plpgsql | 1.0 | PL/pgSQL过程语言 |
| postgis | 3.5.3 | PostGIS几何和地理空间类型及函数 |
| postgis_raster | 3.5.3 | PostGIS栅格类型和函数 |
| postgis_tiger_geocoder | 3.5.3 | PostGIS tiger地理编码器和反向地理编码器 |
| postgis_topology | 3.5.3 | PostGIS拓扑空间类型和函数 |
| postgres_fdw | 1.1 | 用于远程PostgreSQL服务器的外部数据包装器 |
| refint | 1.0 | 用于实现引用完整性的函数（已过时） |
| seg | 1.4 | 表示线段或浮点区间的数据类型 |
| sslinfo | 1.2 | 有关SSL证书的信息 |
| tablefunc | 1.0 | 操作整个表的函数，包括交叉表 |
| tcn | 1.0 | 触发式更改通知 |
| timescaledb | 2.21.1 | 支持时间序列数据的可扩展插入和复杂查询 |
| tsm_system_rows | 1.0 | 接受行数限制的TABLESAMPLE方法 |
| tsm_system_time | 1.0 | 接受毫秒时间限制的TABLESAMPLE方法 |
| unaccent | 1.1 | 移除重音符号的文本搜索字典 |
| uuid-ossp | 1.1 | 生成通用唯一标识符（UUID） |
| vector | 0.8.0 | 向量数据类型及ivfflat和hnsw访问方法 |

> 注意：PostgreSQL 14支持的TimescaleDB最新版本为2.19.3。

## 配置选项

### 可配置环境变量

以下环境变量可在Nhost云项目中通过设置配置：

```
ARCHIVE_TIMEOUT=300          # 归档超时时间（秒）
MAX_CONNECTIONS=100          # 最大连接数
SHARED_BUFFERS=128MB         # 共享缓冲区大小
EFFECTIVE_CACHE_SIZE=4GB     # 有效缓存大小
MAINTENANCE_WORK_MEM=64MB    # 维护工作内存大小
CHECKPOINT_COMPLETION_TARGET=0.9  # 检查点完成目标比例
WAL_BUFFERS=-1               # WAL缓冲区大小（-1表示自动计算）
DEFAULT_STATISTICS_TARGET=100  # 默认统计信息目标
RANDOM_PAGE_COST=4.0         # 随机页面成本
EFFECTIVE_IO_CONCURRENCY=1   # 有效IO并发数
WORK_MEM=4MB                 # 工作内存大小
HUGE_PAGES=try               # 大页内存设置
MIN_WAL_SIZE=80MB            # 最小WAL大小
MAX_WAL_SIZE=1GB             # 最大WAL大小
MAX_WORKER_PROCESSES=8       # 最大工作进程数
MAX_PARALLEL_WORKERS_PER_GATHER=2  # 每个Gather节点的最大并行工作数
MAX_PARALLEL_WORKERS=8       # 最大并行工作数
MAX_PARALLEL_MAINTENANCE_WORKERS=2  # 最大并行维护工作数
JIT=on                       # 是否启用JIT编译
WAL_LEVEL=replica            # WAL级别
MAX_WAL_SENDERS=10           # 最大WAL发送者数量
MAX_REPLICATION_SLOTS=10     # 最大复制槽数量
TRACK_IO_TIMING=off          # 是否跟踪IO计时
```

### 不可直接配置的设置

以下设置在镜像中可用，但不可直接配置：

```
ARCHIVE_MODE=off             # 归档模式（关闭）
ARCHIVE_COMMAND=wal-g wal-push %p  # 归档命令（使用wal-g推送WAL）
RESTORE_COMMAND=wal-g wal-fetch %f %p  # 恢复命令（使用wal-g拉取WAL）
CHECKPOINT_TIMEOUT=5min      # 检查点超时时间
SYNCHRONOUS_COMMIT=on        # 同步提交模式
HOT_STANDBY=on               # 热备模式
PITR_TARGET_ACTION=shutdown  # PITR目标操作（关闭）
PITR_TARGET_TIMELINE=latest  # PITR目标时间线（最新）
```

## 使用场景与适用范围

- **开发环境**：快速部署包含多种扩展的PostgreSQL实例，无需手动安装插件。
- **生产环境**：支持高可用性配置，通过WAL归档和PITR实现数据备份与恢复。
- **空间数据处理**：借助PostGIS扩展处理地理信息数据，支持地图应用开发。
- **时间序列数据**：使用TimescaleDB扩展高效存储和查询时间序列数据（如监控指标、日志）。
- **全文搜索**：通过pg_search和pg_trgm实现基于BM25算法的全文搜索功能。
- **向量计算**：利用vector扩展支持AI应用中的向量存储和相似度搜索。
- **消息队列**：通过pgmq扩展实现轻量级消息队列功能，替代外部MQ服务。

## 使用方法示例

### 基本运行命令

```bash
docker run -d \
  --name nhost-postgres \
  -e MAX_CONNECTIONS=200 \
  -e SHARED_BUFFERS=256MB \
  -p 5432:5432 \
  -v postgres-data:/var/lib/postgresql/data \
  docker.xuanyuan.run/nhost/postgres:latest
```

### Docker Compose配置示例

```yaml
version: '3'
services:
  postgres:
    image: docker.xuanyuan.run/nhost/postgres:latest
    container_name: nhost-postgres
    environment:
      - MAX_CONNECTIONS=200
      - SHARED_BUFFERS=256MB
      - EFFECTIVE_CACHE_SIZE=1GB
      - POSTGRES_PASSWORD=mysecretpassword
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  postgres-data:
```

## 更新日志

### {14.18,15.13,16.9,17.5}-20250728-1
- 将PostgreSQL更新至14.18、15.13、16.9和17.5版本
- 更新扩展：
  - hypopg: 1.4.1 → 1.4.2
  - pg_ivm: 1.10 → 1.11
  - pgmq: 1.5.1 → 1.6.1
  - pgsql-http: 1.6.3 → 1.7.0
  - postgis: 3.5.2 → 3.5.3
  - timescaledb: 2.19.3 → 2.21.1
- 新增扩展：
  - pg_search: 0.17.2
- 新增配置选项：
  - TRACK_IO_TIMING

### {14.17,15.12,16.8,17.4}-20250530-1
- 修复http扩展在特定条件下首次安装时可能出现的问题

### {14.17,15.12,16.8,17.4}-20250506-1
- 将PostgreSQL更新至14.17、15.12、16.8和17.4版本
- 更新扩展：
  - earth_distance: 1.1 → 1.2
  - pg_ivm: 1.9 → 1.10
  - pgmq: 1.5.0 → 1.5.1
  - timescaledb: 2.18.9 → 2.19.3
- 将wal-g更新至3.0.7版本

### {14.15,15.10,16.6,17.2}-20250311-1
- 内部小幅改进

### {14.15,15.10,16.6,17.2}-20250226-1
- 新增PiTR支持：
  - 镜像中添加WAL-G
  - 新增可配置环境变量：ARCHIVE_TIMEOUT
  - 新增系统环境变量：ARCHIVE_MODE、ARCHIVE_COMMAND、RESTORE_COMMAND、CHECKPOINT_TIMEOUT、SYNCHRONOUS_COMMIT、HOT_STANDBY、PITR_TARGET_ACTION、PITR_TARGET_TIMELINE

### {14.15,15.10,16.6,17.2}-20250131-1
- 新增对PostgreSQL 17.2的支持
- 将PostgreSQL更新至14.15、15.10、16.6版本
- 更新扩展：
  - address_standardizer: 3.5.0 → 3.5.2
  - address_standardizer_data_us: 3.5.0 → 3.5.2
  - amcheck: 1.3 → 1.4
  - btree_gist: 1.6 → 1.7
  - fuzzystrmatch: 1.1 → 1.2
  - ltree: 1.2 → 1.3
  - pageinspect: 1.9 → 1.12
  - pg_buffercache: 1.3 → 1.5
  - pg_repack: 1.5.1 → 1.5.2
  - pg_squeeze: 1.7 → 1.8
  - pg_stat_statements: 1.9 → 1.11
  - pgmq: 1.4.5 → 1.5.0
  - postgis: 3.5.0 → 3.5.2
  - postgis_raster: 3.5.0 → 3.5.2
  - postgis_tiger_geocoder: 3.5.0 → 3.5.2
  - postgis_topology: 3.5.0 → 3.5.2
  - timescaledb: 2.17.2 → 2.18.0

### {14.13,15.8,16.4}-20250120-1
- 修复：将pg_squeeze添加到shared_preload_libraries

### {14.13,15.8,16.4}-20250117-1
- 启动时刷新排序规则版本
- 新增pgmq扩展

### {14.13,15.8,16.4}-20250108-1
- 新增pg_jsonschema扩展

### {14.13,15.8,16.4}-20241126-1
- 新增pg_repack扩展
- 将pgvector更新至0.8.0版本
- 将timescaledb更新至2.17.2版本
- 将postgis更新至3.5.0版本
- 将pg_squeeze更新至1.7版本

### {14.13,15.8,16.4}-20240930-1
- 新增ip4r扩展

### {14.13,15.8,16.4}-20240918-1
- 新增pg_ivm插件

### {14.13,15.8,16.4}-20240909-1
- 版本更新至14.13、15.8、16.4
- 修复：必要时在启动时更新timescaledb

### {14.11,15.6,16.2}-20240901-1
- 新增pg_hashids插件
- 新增pg_squeeze插件
- 将pgvector更新至0.7.4版本
- 将timescaledb更新至2.14.2版本
- 将hypopg更新至1.4.1版本

### {14.11,15.6,16.2}-20240717-1
- 将默认区域设置更改为UTF-8

### {14.11,15.6,16.2}-20240515-1
- 首个多版本镜像

### 14.11-20240515-1
-
