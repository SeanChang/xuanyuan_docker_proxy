---
image: apache/amoro-spark-optimizer
description: "Apache Amoro是一个开源数据湖管理系统，专注于实时数据集成与管理，支持Iceberg、Hudi等多种数据湖格式，提供统一元数据管理、数据同步及优化能力，简化数据湖构建与运维。"
source: https://xuanyuan.cloud/zh/r/apache/amoro-spark-optimizer
canonical: https://xuanyuan.cloud/zh/r/apache/amoro-spark-optimizer
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/amoro-spark-optimizer" title="apache/amoro-spark-optimizer Docker 镜像中文简介、标签列表与拉取命令">apache/amoro-spark-optimizer 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache Amoro Docker镜像文档

## 镜像概述

Apache Amoro是一个开源数据湖管理系统，旨在简化数据湖的构建、管理与运维。它专注于实时数据集成场景，通过支持多种主流数据湖格式（如Apache Iceberg、Apache Hudi），提供统一的元数据管理、数据同步及优化能力，解决传统数据湖管理中格式碎片化、运维复杂等问题。

## 核心功能与特性

### 1. 多数据湖格式支持
- 原生支持Apache Iceberg、Apache Hudi等主流数据湖格式，无需额外适配即可管理多格式数据湖
- 提供统一的API与操作界面，屏蔽不同数据湖格式的底层差异

### 2. 实时数据同步
- 支持批处理与流处理数据接入，实现数据实时写入数据湖
- 内置数据一致性校验机制，确保同步过程中数据准确性

### 3. 元数据统一管理
- 集中管理多数据湖格式的元数据（表结构、分区信息、版本历史等）
- 支持元数据版本控制与回溯，保障数据湖元数据一致性

### 4. 数据优化能力
- 自动识别并合并小文件，提升数据查询性能
- 支持数据重分区、过期数据清理等运维操作，降低存储成本

### 5. 高兼容性与扩展性
- 兼容Hadoop生态系统（HDFS、YARN等）及云存储（S3、OSS等）
- 模块化架构设计，支持插件扩展，可集成自定义数据处理逻辑

## 使用场景与适用范围

### 1. 实时数据仓库构建
适用于需要实时接入业务数据并构建数据仓库的场景，通过Amoro的实时同步能力，实现数据从产生到分析的低延迟链路。

### 2. 多数据湖格式统一管理
当企业数据湖同时存在Iceberg、Hudi等多种格式时，可通过Amoro统一管理元数据与数据生命周期，避免格式碎片化导致的管理复杂度。

### 3. 数据湖迁移与整合
支持跨存储系统（如本地HDFS迁移至云存储）或跨数据湖格式（如从Hudi迁移至Iceberg）的数据迁移，降低迁移成本与风险。

### 4. 大规模数据处理优化
针对数据湖中小文件过多、查询性能下降等问题，通过Amoro的自动优化功能，提升大规模数据查询与分析效率。

## 使用方法与配置说明

### 环境要求
- Docker Engine 20.10+
- 至少2GB内存与2核CPU（生产环境建议4GB+内存、4核CPU）
- 网络可访问数据湖存储（如HDFS、S3）及元数据存储（如MySQL）

### 基本部署（docker run）

#### 1. 简单启动（默认配置）
```bash
docker run -d -p 8080:8080 --name amoro docker.xuanyuan.run/apache/amoro:latest
```
- 说明：默认使用内置Derby数据库存储元数据，适用于测试环境；Web UI端口映射为8080，访问`http://localhost:8080`进入控制台。

#### 2. 自定义元数据存储（MySQL）
```bash
docker run -d -p 8080:8080 --name amoro \
  -e AMORO_METASTORE_TYPE=mysql \
  -e AMORO_MYSQL_HOST=mysql-host \
  -e AMORO_MYSQL_PORT=3306 \
  -e AMORO_MYSQL_DB=amoro_metastore \
  -e AMORO_MYSQL_USER=root \
  -e AMORO_MYSQL_PASSWORD=password \
  docker.xuanyuan.run/apache/amoro:latest
```
- 环境变量说明：
  - `AMORO_METASTORE_TYPE`：元数据存储类型，支持`derby`（默认）、`mysql`、`postgresql`
  - `AMORO_MYSQL_*`：MySQL连接参数（当`METASTORE_TYPE=mysql`时必填）

### Docker Compose部署（生产环境建议）

创建`docker-compose.yml`文件：
```yaml
version: '3'
services:
  amoro:
    image: docker.xuanyuan.run/apache/amoro:latest
    ports:
      - "8080:8080"
    environment:
      - AMORO_METASTORE_TYPE=mysql
      - AMORO_MYSQL_HOST=mysql
      - AMORO_MYSQL_PORT=3306
      - AMORO_MYSQL_DB=amoro
      - AMORO_MYSQL_USER=amoro_user
      - AMORO_MYSQL_PASSWORD=amoro_pass
    depends_on:
      - mysql
    volumes:
      - amoro_data:/opt/amoro/data

  mysql:
    image: docker.xuanyuan.run/mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=root_pass
      - MYSQL_DATABASE=amoro
      - MYSQL_USER=amoro_user
      - MYSQL_PASSWORD=amoro_pass
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  amoro_data:
  mysql_data:
```

启动命令：
```bash
docker-compose up -d
```

### 基本操作

1. **访问Web UI**：部署完成后，通过`http://<host>:8080`访问Amoro控制台（默认用户名/密码：admin/admin）。

2. **配置数据源**：在控制台"数据源管理"页面，添加数据湖存储（如HDFS路径、S3桶）及元数据连接信息。

3. **创建数据湖表**：通过"表管理"功能，选择数据湖格式（Iceberg/Hudi），配置表结构与分区策略，完成表创建。

4. **启动数据同步**：在"同步任务"页面创建同步规则，指定源数据（如Kafka主题、数据库表）与目标数据湖表，启动实时同步。

5. **数据优化配置**：在"优化策略"页面设置自动优化规则（如小文件合并阈值、数据保留周期），系统将按规则自动执行优化操作。

## 注意事项

- 生产环境中建议使用外部元数据库（如MySQL）替代内置Derby，避免数据丢失风险。
- 大规模数据同步场景下，建议调整JVM内存参数（通过`JAVA_OPTS`环境变量，如`-e JAVA_OPTS="-Xms4g -Xmx8g"`）。
- 首次使用前请参考[Apache Amoro官方文档](https://amoro.apache.org/)完成初始化配置（如权限设置、存储连接测试）。
