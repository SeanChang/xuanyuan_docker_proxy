---
image: apache/spark
description: "Apache Spark是由Apache软件基金会开发的开源分布式计算系统，专为大数据处理设计，支持批处理、流处理、机器学习和图计算等多种数据处理模式，通过基于内存的计算引擎显著提升处理速度，具备高效、易用且可扩展的特性，广泛应用于数据科学与大数据分析领域，为用户提供快速、灵活的大数据处理解决方案。"
source: https://xuanyuan.cloud/zh/r/apache/spark
canonical: https://xuanyuan.cloud/zh/r/apache/spark
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [apache/spark — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/apache/spark)

含镜像标签、拉取命令、部署文档与相关推荐。

[apache/spark Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/apache/spark)

# Apache Spark

Apache Spark™ 是一款多语言引擎，适用于在单节点机器或集群上执行数据工程、数据科学和机器学习任务。它提供 Scala、Java、Python 和 R 的高级 API，以及支持数据分析通用计算图的优化引擎。同时，Spark 还包含一系列丰富的高级工具，具体包括：用于 SQL 和 DataFrames 的 Spark SQL、适用于 pandas 工作负载的 pandas API on Spark、机器学习库 MLlib、图处理工具 GraphX，以及流处理组件 Structured Streaming。

<[]>


## 在线文档

最新的 Spark 文档（含编程指南）可在 [项目网页]([]) 查看。本 README 文件仅包含基本的环境设置说明。


## 交互式 Scala Shell

使用 Spark 最简单的方式是通过交互式 Scala Shell：

```bash
docker run -it apache/spark /opt/spark/bin/spark-shell
```

尝试以下命令，预期返回结果为 1,000,000,000：

```scala
scala> spark.range(1000 * 1000 * 1000).count()
```


## 在 Kubernetes 上运行 Spark

相关文档请参见：<[]>


## 在 Spark 上运行 Python

可使用 Docker 镜像：<[]>


## 在 Spark 上运行 R

可使用 Docker 镜像：<[]>
