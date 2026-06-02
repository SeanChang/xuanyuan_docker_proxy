---
image: apache/hive
description: "Apache Hive是基于Hadoop的分布式数据仓库工具，支持类SQL查询语言（HQL）以高效分析和处理大规模结构化数据；其Docker镜像是预先集成Hive核心组件、依赖环境及配置的可执行文件包，可快速部署至各类环境，确保开发、测试与生产环境一致性，大幅简化Hive服务的安装配置流程，为数据仓库构建、数据查询及分析任务提供便捷、稳定且高效的运行载体。"
source: https://xuanyuan.cloud/zh/r/apache/hive
canonical: https://xuanyuan.cloud/zh/r/apache/hive
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/hive" title="apache/hive Docker 镜像中文简介、标签列表与拉取命令">apache/hive — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/apache/hive" title="apache/hive Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/apache/hive</a>

## Apache Hive 介绍


### 概述  
Apache Hive™ 是一款主流开源数据仓库框架，支持查询存储在分布式系统（如 Hadoop HDFS、Apache Ozone、Amazon S3、Azure Data Lake Storage 等）中的大规模数据集。它提供类 SQL 接口（HiveQL），可用于查询、分析和管理结构化及半结构化数据。  

通过 Hive，用户能定义表和数据模式，用熟悉的类 SQL 语法编写查询，执行过滤、聚合、关联等数据分析任务。Hive 兼容多种常见数据格式，包括 CSV、JSON、Avro、ORC、Parquet。


### 快速开始  

#### 1. 设置环境变量  
先定义 Hive 版本（根据实际使用的镜像标签调整）：  
```bash
export HIVE_VERSION=<Hive 版本号>
```  
**示例**：  
```bash
export HIVE_VERSION=4.1.0
```  


#### 2. 启动带嵌入式元存储的 HiveServer2  
适合轻量快速部署，使用 Derby 作为元数据库（无需额外配置数据库）：  
```bash
docker run -d -p 10000:10000 -p 10002:10002 \
  --env SERVICE_NAME=hiveserver2 \
  --name hive4 \
  apache/hive:${HIVE_VERSION}
```  


#### 3. 启动独立元存储  
如需单独部署元存储（仍用 Derby 轻量模式）：  
```bash
docker run -d -p 9083:9083 \
  --env SERVICE_NAME=metastore \
  --name metastore-standalone \
  apache/hive:${HIVE_VERSION}
```  

> **注意**：此模式下，容器停止后数据会丢失。若需持久化表结构和数据，需搭配外部 Postgres 数据库及卷（volume）存储。  


### 高级配置  

#### 1. 搭配独立元存储使用 HiveServer2  
若已有独立元存储，启动 HiveServer2 时指定元存储地址：  
```bash
docker run -d -p 10000:10000 -p 10002:10002 \
  --env SERVICE_NAME=hiveserver2 \
  --env SERVICE_OPTS="-Dhive.metastore.uris=thrift://metastore:9083" \  # 指定外部元存储地址
  --env IS_RESUME="true" \
  --name hiveserver2-standalone \
  apache/hive:${HIVE_VERSION}
```  


#### 2. 用外部数据库（Postgres/Oracle/MySQL/MsSQL）启动独立元存储  
生产环境建议用外部数据库存储元数据，以确保持久化。以下为 Postgres 示例：  
```bash
docker run -d -p 9083:9083 \
  --env SERVICE_NAME=metastore \
  --env DB_DRIVER=postgres \
  --env SERVICE_OPTS="\
    -Djavax.jdo.option.ConnectionDriverName=org.postgresql.Driver \
    -Djavax.jdo.option.ConnectionURL=jdbc:postgresql://postgres:5432/metastore_db \  # 数据库连接地址
    -Djavax.jdo.option.ConnectionUserName=hive \  # 数据库用户名
    -Djavax.jdo.option.ConnectionPassword=password" \  # 数据库密码
  --mount source=warehouse,target=/opt/hive/data/warehouse \  # 挂载卷持久化数据
  --name metastore-standalone \
  apache/hive:${HIVE_VERSION}
```  

> **数据持久化**：启动 HiveServer2 时，也需挂载卷保存数据，命令示例：  
> ```bash
> docker run -d -p 10000:10000 -p 10002:10002 \
>   --env SERVICE_NAME=hiveserver2 \
>   --env SERVICE_OPTS="-Dhive.metastore.uris=thrift://metastore:9083" \
>   --mount source=warehouse,target=/opt/hive/data/warehouse \
>   --env IS_RESUME="true" \
>   --name hiveserver2 \
>   apache/hive:${HIVE_VERSION}
> ```  


#### 3. 自定义配置  
如需使用自定义配置文件（如 `core-site.xml`、`hive-site.xml` 等），可通过 `HIVE_CUSTOM_CONF_DIR` 环境变量指定配置目录。例如，将配置文件放在宿主机 `/opt/hive/conf` 目录，启动命令：  
```bash
docker run -d -p 9083:9083 \
  --env SERVICE_NAME=metastore \
  --env DB_DRIVER=postgres \
  -v /opt/hive/conf:/hive_custom_conf \  # 挂载宿主机配置目录到容器内
  --env HIVE_CUSTOM_CONF_DIR=/hive_custom_conf \  # 指定自定义配置目录
  --name metastore \
  apache/hive:${HIVE_VERSION}
```  


### 使用方法  

#### 1. 访问 Beeline  
Beeline 是 Hive 的命令行客户端，可通过容器内执行或本地安装后连接：  
- **容器内执行**（需先启动 HiveServer2，如上文命名为 `hive4`）：  
  ```bash
  docker exec -it hive4 beeline -u 'jdbc:hive2://localhost:10000/'
  ```  
- **本地直接连接**（需本地安装 Beeline）：  
  ```bash
  beeline -u 'jdbc:hive2://localhost:10000/'
  ```  


#### 2. 访问 HiveServer2 Web UI  
启动后，通过浏览器访问：`[]  


#### 3. 示例查询（Beeline 中执行）  
```sql
-- 查看表
show tables;

-- 创建分区表
create table hive_example(a string, b int) partitioned by(c int);

-- 添加分区
alter table hive_example add partition(c=1);

-- 插入数据
insert into hive_example partition(c=1) values('a', 1), ('a', 2), ('b', 3);

-- 数据分析
select count(distinct a) from hive_example;  -- 去重计数
select sum(b) from hive_example;  -- 求和
```  


### 支持与资源  
- **官方网站**：[]  
- **代码仓库**：[]  
- **问题反馈/贡献**：[]  
- **入门文档**：[]  
- **邮件列表**（技术咨询）：[]  


### 进一步阅读  
详细操作可参考官方文档：[]
