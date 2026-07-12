---
image: jupyter/all-spark-notebook
description: "包含Python、Scala、R和Spark的Jupyter Notebook栈，来自https://github.com/jupyter/docker-stacks项目"
source: https://xuanyuan.cloud/zh/r/jupyter/all-spark-notebook
canonical: https://xuanyuan.cloud/zh/r/jupyter/all-spark-notebook
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jupyter/all-spark-notebook" title="jupyter/all-spark-notebook Docker 镜像中文简介、标签列表与拉取命令">jupyter/all-spark-notebook 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Jupyter Notebook Python, R, Spark 栈

## 镜像概述

该镜像提供了一个集成Python、Scala、R编程语言和Apache Spark的Jupyter Notebook环境，属于[jupyter/docker-stacks](https://github.com/jupyter/docker-stacks)项目的一部分。

> **重要提示**：Docker Hub上托管的镜像（`jupyter/all-spark-notebook`）已不再更新。请使用[quay.io镜像](https://quay.io/repository/jupyter/all-spark-notebook)获取最新版本。

## 核心功能与特性

- **多语言支持**：集成Python、Scala和R三种编程语言，满足多样化数据分析需求
- **Apache Spark集成**：内置Spark框架，支持分布式大数据处理
- **Jupyter Notebook环境**：提供交互式笔记本界面，支持代码编写、运行及结果可视化
- **自动化构建**：通过GitHub Actions在[jupyter/docker-stacks](https://github.com/jupyter/docker-stacks)项目中自动构建并推送至镜像仓库

## 使用场景与适用范围

适用于需要结合多语言编程与大数据处理的场景：
- 数据分析与探索性研究
- 机器学习模型开发与验证
- 分布式大数据处理任务
- 教学与培训中的交互式编程实践

## 使用方法与配置说明

### 拉取镜像

推荐从quay.io拉取最新镜像：

```bash
docker pull ***-quay.xuanyuan.run/jupyter/all-spark-notebook:latest
```

### 启动容器示例

启动Jupyter Notebook服务并映射本地端口（默认8888）：

```bash
docker run -p 8888:8888 ***-quay.xuanyuan.run/jupyter/all-spark-notebook:latest
```

运行后，根据终端输出的URL（包含安全token）访问Jupyter Notebook界面。

### 高级配置

更多配置选项（如挂载数据卷、设置密码、自定义Spark参数等）请参考项目官方文档。

## 项目文档与资源

- **官方文档**：[Jupyter Docker Stacks on ReadTheDocs](https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html)
- **镜像选择指南**：[Selecting an Image :: Core Stacks :: jupyter/all-spark-notebook](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-all-spark-notebook)
- **Spark配置细节**：[Image Specifics :: Apache Spark](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/specifics.html#apache-spark)

## 镜像指标

- Docker拉取量：[![docker pulls](https://img.shields.io/docker/pulls/jupyter/all-spark-notebook.svg)](https://hub.docker.com/r/jupyter/all-spark-notebook/)
- Docker星级：[![docker stars](https://img.shields.io/docker/stars/jupyter/all-spark-notebook.svg)](https://hub.docker.com/r/jupyter/all-spark-notebook/)
- 镜像大小：[![image size](https://img.shields.io/docker/image-size/jupyter/all-spark-notebook/latest)](https://hub.docker.com/r/jupyter/all-spark-notebook/ "jupyter/all-spark-notebook image size")
