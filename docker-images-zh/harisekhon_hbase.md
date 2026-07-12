---
image: harisekhon/hbase
description: "Apache HBase NoSQL列存储数据库，以伪分布式模式运行，包含HBase Master、RegionServer、Thrift Server和Stargate Rest Server，可打开HBase shell，适合开发和CI测试（标签0.90 - 2.1）"
source: https://xuanyuan.cloud/zh/r/harisekhon/hbase
canonical: https://xuanyuan.cloud/zh/r/harisekhon/hbase
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/harisekhon/hbase" title="harisekhon/hbase Docker 镜像中文简介、标签列表与拉取命令">harisekhon/hbase 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache HBase

https://hbase.apache.org/

## 镜像概述

Apache HBase是一个NoSQL列存储数据库。本镜像启动一个单节点伪分布式HBase集群，包含HBase Master、RegionServer、Thrift Server和Stargate Rest Server。以交互方式启动时，将直接进入HBase shell。

## 核心功能和特性

- 伪分布式模式运行，模拟完整HBase集群环境
- 包含关键组件：HBase Master、RegionServer、Thrift Server和Stargate Rest Server
- 支持交互式HBase shell访问
- 数据目录作为标准Docker卷管理，确保数据持久化

## 使用场景

- 开发环境：提供本地HBase集群用于应用开发和调试
- CI测试：适合持续集成流程中的自动化测试环境
- 学习和演示：快速搭建HBase环境进行功能验证和技术演示

## 使用方法

### 基本交互模式

直接启动容器并进入HBase shell：

```bash
docker run -ti docker.xuanyuan.run/harisekhon/hbase
```

### 完整端口映射

由于HBase使用多个端口，建议使用`docker-compose`映射所有端口：

```bash
docker-compose up
```

### 快捷启动（无docker-compose）

使用`make`命令快捷启动，自动包含所有端口映射：

```bash
make run
```

## 数据管理

HBase根目录位于`/hbase-data`，并作为标准Docker卷导出，方便进行数据持久化和管理。

## 相关镜像

更多开源、大数据和NoSQL技术的Docker镜像可在[DockerHub个人主页](https://hub.docker.com/r/harisekhon)查看。所有镜像的源代码位于[Dockerfiles GitHub主仓库](https://github.com/HariSekhon/Dockerfiles/)。
