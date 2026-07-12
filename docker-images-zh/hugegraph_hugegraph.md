---
image: hugegraph/hugegraph
description: "Apache HugeGraph-Server官方版本提供分布式图数据库服务，支持大规模图数据的存储、查询与分析，由官方维护确保稳定性与兼容性。"
source: https://xuanyuan.cloud/zh/r/hugegraph/hugegraph
canonical: https://xuanyuan.cloud/zh/r/hugegraph/hugegraph
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hugegraph/hugegraph" title="hugegraph/hugegraph Docker 镜像中文简介、标签列表与拉取命令">hugegraph/hugegraph 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache HugeGraph Docker 镜像文档

## 镜像概述和主要用途

Apache HugeGraph 是一个高性能、高可扩展性的图数据库，支持存储和查询超过百亿级别的顶点和边数据。本 Docker 镜像提供了 HugeGraph 服务器的便捷部署方式，适用于快速搭建测试或开发环境。

该镜像默认使用 RocksDB 作为后端存储，提供了网络端口暴露、认证配置、示例图数据加载等功能，并可与 Hubble 可视化工具配合使用，实现图数据的直观管理和探索。

## 核心功能和特性

- 兼容 Apache TinkerPop 3 框架，支持 Gremlin 和 Cypher 图查询语言
- 提供完善的模式元数据管理，包括 VertexLabel、EdgeLabel、PropertyKey 和 IndexLabel
- 多类型索引支持，包括精确查询、范围查询和复杂条件组合查询
- 插件式后端存储驱动框架，支持 RocksDB、Cassandra、HBase、ScyllaDB 及 MySQL/PostgreSQL 等多种存储引擎
- 与 Flink/Spark/HDFS 等大数据平台集成，易于连接其他数据处理系统

## 使用场景和适用范围

- 快速搭建图数据库测试环境
- 开发阶段的图应用程序调试
- 小规模图数据存储和查询需求验证
- 图数据库功能评估和技术选型参考
- 作为 Hubble 可视化工具的后端服务

> **注意**：该 Docker 镜像为便捷发布版本，并非官方正式分发工件。生产环境部署请参考官方文档的推荐配置。

## 详细使用方法和配置说明

### 基本启动命令

使用以下命令快速启动 HugeGraph 服务器容器：

```bash
docker run -itd --name=server -e PASSWORD=xxx -p 8080:8080 docker.xuanyuan.run/hugegraph/hugegraph
```

此命令将：
- 以后台模式运行容器
- 设置管理员密码（通过 PASSWORD 环境变量）
- 映射容器的 8080 端口到主机的 8080 端口
- 使用默认的 RocksDB 作为后端存储

### 容器状态检查

```bash
# 检查容器运行状态
docker ps -a

# 查看容器日志
docker exec -it server bash
tail -f logs/hugegraph-server.log
```

### 服务可用性验证

在本地机器上执行以下命令验证服务是否正常运行：

```bash
curl 0.0.0.0:8080
```

### 环境变量配置

| 环境变量 | 说明 | 示例 |
|---------|------|------|
| PASSWORD | 设置管理员密码，启用认证功能 | `-e PASSWORD=mysecret` |
| PRELOAD | 是否预加载示例图数据，值为 "true" 时启用 | `-e PRELOAD="true"` |

### 高级配置

#### 启用认证

通过设置 PASSWORD 环境变量启用认证：

```bash
docker run -itd --name=server -e PASSWORD=mysecretpassword -p 8080:8080 docker.xuanyuan.run/hugegraph/hugegraph
```

或者参考官方文档进行更详细的认证配置：[认证配置](https://hugegraph.apache.org/docs/config/config-authentication/)

#### 加载示例图数据

启动容器时添加 PRELOAD 环境变量：

```bash
docker run -itd --name=server -e PRELOAD="true" -p 8080:8080 docker.xuanyuan.run/hugegraph/hugegraph
```

#### 修改配置或创建多图

如需自定义图配置或创建多图，需进入容器进行操作：

```bash
# 进入容器
docker exec -it server bash

# 编辑配置文件（参考官方文档进行配置修改）
vi conf/hugegraph.properties

# 重启服务使配置生效
bin/hugegraph-server restart
```

详细配置指南请参考：[多图配置](https://hugegraph.apache.org/docs/config/config-guide/#5-multi-graph-configuration)

## Docker Compose 部署方案

### HugeGraph 与 Hubble 一起部署

创建 `docker-compose.yml` 文件：

```yaml
version: '3'
services:
  hugegraph:
    image: docker.xuanyuan.run/hugegraph/hugegraph
    container_name: hugegraph-server
    environment:
      - PASSWORD=mysecret
      - PRELOAD=true
    ports:
      - "8080:8080"
    restart: unless-stopped
    
  hubble:
    image: docker.xuanyuan.run/hugegraph/hubble
    container_name: hugegraph-hubble
    ports:
      - "8088:8088"
    depends_on:
      - hugegraph
    restart: unless-stopped
```

启动服务：

```bash
docker-compose up -d
```

访问 Hubble Web UI：http://localhost:8088

## 版本选择

推荐使用带版本标签的镜像以确保稳定性，如：

```bash
docker run -itd --name=server -e PASSWORD=xxx -p 8080:8080 docker.xuanyuan.run/hugegraph/hugegraph:1.2.0
```

- 使用特定版本标签（如 `1.2.0`）获取稳定版本
- 使用 `latest` 标签获取开发中的最新功能

## 相关组件

- **Hubble**：HugeGraph 的 Web 可视化工具，Docker 镜像：`hugegraph/hubble`
- **hugegraph-toolchain**：包含图数据加载工具、命令行工具和客户端库
- **hugegraph-computer**：图计算系统集成组件

更多信息请访问官方网站：[https://hugegraph.apache.org/](https://hugegraph.apache.org/)

## 参考文档

- [HugeGraph 官方文档](https://hugegraph.apache.org/docs/)
- [配置指南](https://hugegraph.apache.org/docs/config/config-guide/)
- [多图配置](https://hugegraph.apache.org/docs/config/config-guide/#5-multi-graph-configuration)
- [认证配置](https://hugegraph.apache.org/docs/config/config-authentication/)
- [Docker Compose 部署指南](https://hugegraph.apache.org/docs/quickstart/hugegraph-hubble/#21-use-docker-recommended)
