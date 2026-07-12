---
image: taozex/doris
description: "基于Doris 1.1.1版本的Docker镜像，支持一键启动Doris服务，便于快速学习和使用Doris列式存储分析数据库。"
source: https://xuanyuan.cloud/zh/r/taozex/doris
canonical: https://xuanyuan.cloud/zh/r/taozex/doris
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/taozex/doris" title="taozex/doris Docker 镜像中文简介、标签列表与拉取命令">taozex/doris 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## Doris Docker镜像文档

### 镜像概述
本镜像基于Doris 1.1.1版本构建，提供便捷的Docker化部署方式，支持一键启动Doris服务，旨在简化Doris列式存储分析数据库的学习和使用流程。

### 核心功能与特性
- 基于Doris 1.1.1稳定版本构建
- 一键启动Doris服务，无需复杂配置
- 预设端口映射，支持客户端访问
- 兼容MySQL客户端连接

### 使用场景
- 快速搭建Doris学习环境
- 本地测试Doris功能与SQL语法
- 简单演示Doris的数据分析能力

### 使用方法

#### 1. 运行Doris容器
使用以下命令启动Doris容器，映射必要端口：
```bash
docker run -p 9030:9030 -p 8030:8030 -p 8040:8040 --privileged=true -d --name doris docker.xuanyuan.run/taozex/doris:tagname
```
> 说明：需将`tagname`替换为具体镜像标签

#### 2. 使用MySQL客户端访问Doris
通过MySQL客户端连接Doris服务：
```bash
mysql -uroot -h127.0.0.1 -P 9030
```

#### 3. 测试容器功能
连接成功后，执行以下SQL命令测试Doris功能：
```sql
-- 创建测试数据库
CREATE DATABASE TEST;

-- 使用测试数据库
USE TEST;

-- 创建测试表
CREATE TABLE `doris_test` (
 `c0` int(11) NULL COMMENT "",
 `c1` date NULL COMMENT "",
 `c2` datetime NULL COMMENT "",
 `c3` varchar(65533) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`c0`)
DISTRIBUTED BY HASH(`c0`) BUCKETS 1 
PROPERTIES (
"replication_num" = "1",
"in_memory" = "false",
"storage_format" = "DEFAULT"
);

-- 插入测试数据
insert into doris_test values (1, '2022-02-01', '2022-02-01 10:47:57', '111');
insert into doris_test values (2, '2022-02-02', '2022-02-02 10:47:57', '222');
insert into doris_test values (3, '2022-02-03', '2022-02-03 10:47:57', '333');

-- 查询测试数据
select * from doris_test where c1 >= '2022-02-02';
