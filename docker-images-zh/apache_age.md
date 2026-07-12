---
image: apache/age
description: "Apache AGE是PostgreSQL的图数据库扩展，支持在关系数据库上使用图数据模型，允许同时使用SQL和openCypher查询语言，适用于欺诈检测、推荐系统等场景。"
source: https://xuanyuan.cloud/zh/r/apache/age
canonical: https://xuanyuan.cloud/zh/r/apache/age
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/age" title="apache/age Docker 镜像中文简介、标签列表与拉取命令">apache/age 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache AGE

## 什么是Apache AGE
Apache AGE是PostgreSQL的扩展，使用户能够在现有关系数据库之上利用图数据库功能。AGE是A Graph Extension的缩写，灵感来源于Bitnine的AgensGraph，这是一个基于PostgreSQL的多模型数据库分支。该项目的基本原理是创建一个单一存储，同时处理关系和图数据模型，使用户能够使用标准ANSI SQL以及openCypher（当今最流行的图查询语言之一）。

![Apache AGE架构](https://age.apache.org/age-manual/master/_static/logo.png)

## 概述
Apache AGE具有以下特点：
- **强大**：为流行的PostgreSQL数据库添加图数据库支持，PostgreSQL被Apple、Spotify和NASA等组织使用
- **灵活**：允许执行openCypher查询，使复杂查询更易于编写，同时支持同时查询多个图
- **智能**：支持图查询，是许多高级Web服务（如欺诈检测、主数据管理、产品推荐等）的基础

## 特性
- **Cypher查询**：支持图查询语言
- **混合查询**：支持SQL和/或Cypher
- **多图查询**：支持查询多个图
- **层级结构**：图标签组织
- **属性索引**：支持顶点（节点）和边的索引
- **完整PostgreSQL支持**：支持所有PostgreSQL功能

## 文档
请参考最新的[Apache AGE文档](https://age.apache.org/age-manual/master/index.html)了解安装、特性、内置函数和Cypher查询。

## 预安装要求
根据不同操作系统安装以下必要库。从源代码构建AGE依赖于以下Linux库：

### CentOS
```bash
yum install gcc glibc glib-common readline readline-devel zlib zlib-devel flex bison
```

### Fedora
```bash
dnf install gcc glibc bison flex readline readline-devel zlib zlib-devel
```

### Ubuntu
```bash
sudo apt-get install build-essential libreadline-dev zlib1g-dev flex bison
```

## 安装
Apache AGE旨在易于安装和运行。可通过Docker和其他传统方式安装。

### 安装PostgreSQL
需要安装与AGE兼容的Postgres版本，目前AGE支持Postgres 11、12、13、14、15、16和17。

#### 通过包管理器安装
```bash
sudo apt install postgresql
```

#### 使用Docker安装

#### 获取Docker镜像
```bash
docker pull docker.xuanyuan.run/apache/age
```

#### 创建AGE Docker容器
```bash
docker run \
    --name age  \
    -p 5455:5432 \
    -e POSTGRES_USER=postgresUser \
    -e POSTGRES_PASSWORD=postgresPW \
    -e POSTGRES_DB=postgresDB \
    -d \
    docker.xuanyuan.run/apache/age
```

#### 进入PostgreSQL的psql
```bash
docker exec -it age psql -d postgresDB -U postgresUser
```

## 安装后配置
对于每个AGE连接，需要加载AGE扩展：
```bash
CREATE EXTENSION age;
LOAD 'age';
SET search_path = ag_catalog, "$user", public;
```

## 快速入门

### 创建图
```bash
SELECT create_graph('graph_name');
```

### 创建顶点（节点）
```bash
SELECT * 
FROM docker.xuanyuan.run/cypher('graph_name', $
    CREATE (:label {property:"Node A"})
$) as (v agtype);

SELECT * 
FROM docker.xuanyuan.run/cypher('graph_name', $
    CREATE (:label {property:"Node B"})
$) as (v agtype);
```

### 创建边
```bash
SELECT * 
FROM docker.xuanyuan.run/cypher('graph_name', $
    MATCH (a:label), (b:label)
    WHERE a.property = 'Node A' AND b.property = 'Node B'
    CREATE (a)-[e:RELTYPE {property:a.property + '<->' + b.property}]->(b)
    RETURN e
$) as (e agtype);
```

### 查询连接的节点
```bash
SELECT * from cypher('graph_name', $$
        MATCH (V)-[R]-(V2)
        RETURN V,R,V2
$$) as (V agtype, R agtype, V2 agtype);
```

## 语言特定驱动
Apache AGE支持多种编程语言驱动：

### 内置驱动
- Go驱动
- Java驱动
- NodeJs驱动
- Python驱动

### 社区驱动
- Apache AGE Rust驱动
- Apache AGE .NET驱动

## 图形可视化工具
Apache AGE Viewer是Apache AGE的用户界面，提供数据可视化和探索功能。这个Web可视化工具允许用户输入复杂的图查询，并以图形和表格形式探索结果。

## 社区贡献
您可以通过向[此仓库](https://github.com/apache/age)发送拉取请求来改进正在进行的工作或启动新工作。有关代码审查流程、如何合并拉取请求以及代码风格合规性到文档的更多信息，请访问[Apache AGE官方网站 - 开发者指南](https://age.apache.org/contribution/guide)。
