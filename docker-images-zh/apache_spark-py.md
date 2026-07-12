---
image: apache/spark-py
description: "Apache Spark是一个多语言引擎，用于在单节点或集群上执行数据工程、数据科学和机器学习任务，提供Scala、Java、Python、R的高级API及Spark SQL、MLlib等丰富工具。"
source: https://xuanyuan.cloud/zh/r/apache/spark-py
canonical: https://xuanyuan.cloud/zh/r/apache/spark-py
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/spark-py" title="apache/spark-py Docker 镜像中文简介、标签列表与拉取命令">apache/spark-py 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache Spark

Apache Spark™ 是一个多语言引擎，用于在单节点机器或集群上执行数据工程、数据科学和机器学习任务。它提供Scala、Java、Python和R的高级API，以及支持数据分析通用计算图的优化引擎。还支持丰富的高级工具，包括用于SQL和DataFrames的Spark SQL、用于pandas工作负载的pandas API on Spark、用于机器学习的MLlib、用于图处理的GraphX，以及用于流处理的Structured Streaming。

<https://spark.apache.org/>

## 在线文档

您可以在[项目网页](https://spark.apache.org/documentation.html)上找到最新的Spark文档，包括编程指南。本README文件仅包含基本设置说明。

## 交互式Python Shell

使用PySpark最简单的方法是通过Python shell：

```bash
docker run -it docker.xuanyuan.run/apache/spark-py /opt/spark/bin/pyspark
```

运行以下命令，应返回1,000,000,000：

```python
>>> spark.range(1000 * 1000 * 1000).count()
```

## 在Kubernetes上运行Spark
<https://spark.apache.org/docs/latest/running-on-kubernetes.html>

## 仅运行Scala/Java的Spark
使用<https://hub.docker.com/r/apache/spark>上的镜像

## 运行R Spark
使用<https://hub.docker.com/r/apache/spark-r>上的镜像
