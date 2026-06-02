---
image: library/spark
description: "Apache Spark 是一款专为大规模数据处理打造的统一分析引擎，它集成了批处理、流处理、机器学习、图计算等多种数据处理能力，通过基于内存的计算模型显著提升数据处理速度，具备高效、易用且可扩展的特性，能为企业和开发者提供一站式的大数据分析解决方案，支持从数据提取、清洗、转换到深度分析与应用部署的全流程，满足各类复杂数据场景下的处理需求，助力实现数据驱动的高效决策与业务创新。"
source: https://xuanyuan.cloud/zh/r/library/spark
canonical: https://xuanyuan.cloud/zh/r/library/spark
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/spark" title="library/spark Docker 镜像中文简介、标签列表与拉取命令">library/spark 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache Spark Docker 镜像介绍


## 快速参考

### 维护者  
[Apache Spark 团队]([])  

### 获取帮助  
[Apache Spark™ 社区]([])  


## 支持的标签及对应 Dockerfile 链接  

以下是可用的镜像标签及其对应的 Dockerfile 源码链接，标签按功能和版本分类：  

- **4.0.0 版本（Java 21 基础）**  
  - `4.0.0-scala2.13-java21-python3-ubuntu`、`4.0.0-java21-python3`、`4.0.0-java21`、`python3`、`latest`  
    [Dockerfile]([])  
  - `4.0.0-scala2.13-java21-r-ubuntu`、`4.0.0-java21-r`  
    [Dockerfile]([])  
  - `4.0.0-scala2.13-java21-ubuntu`、`4.0.0-java21-scala`  
    [Dockerfile]([])  
  - `4.0.0-scala2.13-java21-python3-r-ubuntu`  
    [Dockerfile]([])  

- **4.0.0 版本（Java 17 基础）**  
  - `4.0.0-scala2.13-java17-python3-ubuntu`、`4.0.0-python3`、`4.0.0`、`python3-java17`  
    [Dockerfile]([])  
  - `4.0.0-scala2.13-java17-r-ubuntu`、`4.0.0-r`、`r`  
    [Dockerfile]([])  
  - `4.0.0-scala2.13-java17-ubuntu`、`4.0.0-scala`、`scala`  
    [Dockerfile]([])  
  - `4.0.0-scala2.13-java17-python3-r-ubuntu`  
    [Dockerfile]([])  

- **3.5.7 版本（Java 17/11 基础）**  
  - Java 17 系列：`3.5.7-scala2.12-java17-python3-ubuntu`、`3.5.7-java17-python3`、`3.5.7-java17` 等  
    [Dockerfile 链接]([])（其他子标签类似，可通过原链接查看）  
  - Java 11 系列：`3.5.7-scala2.12-java11-python3-ubuntu`、`3.5.7-python3`、`3.5.7` 等  
    [Dockerfile 链接]([])  


## 快速参考（续）  

### 提交 issue  
[Apache JIRA SPARK 项目]([])  

### 支持的架构  
- `amd64`：[amd64/spark]([])  
- `arm64v8`：[arm64v8/spark]([])  

### 镜像详情  
- 包含元数据、传输大小等信息：[repo-info 仓库的 spark 目录]([])（含历史记录）  

### 镜像更新  
- 跟踪更新：[official-images 仓库的 library/spark 标签]([])  
- 更新记录：[official-images 仓库的 library/spark 文件]([])（含历史提交）  

### 描述来源  
[docs 仓库的 spark 目录]([])（含历史记录）  


## 什么是 Apache Spark™？  

Apache Spark™ 是一个多语言引擎，用于在单机或集群上执行数据工程、数据科学和机器学习任务。它提供 Scala、Java、Python 和 R 的高级 API，以及支持数据分析通用计算图的优化引擎。同时，它还包含丰富的高级工具：用于 SQL 和 DataFrames 的 Spark SQL、用于 pandas 工作负载的 pandas API on Spark、机器学习库 MLlib、图处理工具 GraphX，以及流处理工具 Structured Streaming。  


## 在线文档  

最新 Spark 文档（含编程指南）可在 [项目官网]([]) 查看。本文档仅包含基础使用说明。  


## 交互式 Shell 使用  

### Scala 交互式 Shell  
启动 Scala 交互式 shell 的最简单方式：  
```console
docker run -it spark /opt/spark/bin/spark-shell
```  
示例代码（应返回 1000000000）：  
```scala
scala> spark.range(1000 * 1000 * 1000).count()
```  

### Python 交互式 Shell  
启动 PySpark 交互式 shell：  
```console
docker run -it spark:python3 /opt/spark/bin/pyspark
```  
示例代码（应返回 1000000000）：  
```python
>>> spark.range(1000 * 1000 * 1000).count()
```  

### R 交互式 Shell  
启动 SparkR 交互式 shell：  
```console
docker run -it spark:r /opt/spark/bin/sparkR
```  


## 在 Kubernetes 上运行 Spark  
详细指南：[官方文档]([])  


## 配置与环境变量  
环境变量说明：[spark-docker 仓库 OVERVIEW.md]([])  


## 许可证  

Apache Spark、Spark、Apache、Apache 羽标 logo 及 Apache Spark 项目 logo 均为 Apache 软件基金会的商标。  
本软件基于 [Apache 许可证 2.0 版]([]) 授权。  

与所有 Docker 镜像一样，本镜像可能包含其他软件（如基础系统的 Bash 等），这些软件可能采用其他许可证。部分自动检测到的许可证信息可在 [repo-info 仓库的 spark 目录]([]) 查看。  

使用预构建镜像时，用户需自行确保对镜像中所有软件的使用符合相关许可证要求。
