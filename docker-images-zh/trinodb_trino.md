---
image: trinodb/trino
description: "Trino（前身为PrestoSQL）的官方镜像，是一款用于大数据分析的快速分布式SQL引擎。"
source: https://xuanyuan.cloud/zh/r/trinodb/trino
canonical: https://xuanyuan.cloud/zh/r/trinodb/trino
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/trinodb/trino" title="trinodb/trino Docker 镜像中文简介、标签列表与拉取命令">trinodb/trino 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 用于大数据的快速分布式SQL查询引擎

该镜像提供开箱即用的单节点集群，包含JMX、内存、TPC-DS和TPC-H目录。通过挂载配置目录替换默认配置，可将其部署为完整集群。

有关镜像的更多详细信息，请参见[README](https://github.com/trinodb/trino/blob/master/core/docker/README.md)，或访问[Trino官网](https://trino.io/)了解更多关于Trino的信息。

## 快速开始

### 运行Trino服务器

你可以启动一个单节点Trino集群用于测试。Trino节点将同时作为协调器和工作节点。要启动它，请执行以下命令：

```bash
docker run -p 8080:8080 --name trino docker.xuanyuan.run/trinodb/trino
```

等待出现以下日志行：
```
INFO	main	io.trino.server.Server	======== SERVER STARTED ========
```

Trino服务器现已在`localhost:8080`（默认端口）上运行。

### 运行Trino CLI

运行[Trino CLI](https://trino.io/docs/current/client/cli.html)，默认连接到`localhost:8080`：

```bash
docker exec -it trino trino
```

你可以向Trino CLI传递额外参数：

```bash
docker exec -it trino trino --catalog tpch --schema sf1
