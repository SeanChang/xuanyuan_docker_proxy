---
image: deltaio/delta-docker
description: "集成Python、Jupyter、PySpark、Scala Spark、Rust及ROAPI示例的Delta Lake Docker镜像，支持数据湖开发与分析。"
source: https://xuanyuan.cloud/zh/r/deltaio/delta-docker
canonical: https://xuanyuan.cloud/zh/r/deltaio/delta-docker
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/deltaio/delta-docker" title="deltaio/delta-docker Docker 镜像中文简介、标签列表与拉取命令">deltaio/delta-docker 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Delta Lake Docker 镜像文档

![Delta Lake Logo](https://docs.delta.io/latest/_static/delta-lake-white.png)

[![Test](https://github.com/delta-io/delta/actions/workflows/test.yaml/badge.svg)](https://github.com/delta-io/delta/actions/workflows/test.yaml)
[![License](https://img.shields.io/badge/license-Apache%202-brightgreen.svg)](https://github.com/delta-io/delta/blob/master/LICENSE.txt)
[![PyPI](https://img.shields.io/pypi/v/delta-spark.svg)](https://pypi.org/project/delta-spark/)
[![PyPI - Downloads](https://img.shields.io/pypi/dm/delta-spark)](https://pypistats.org/packages/delta-spark)


## 镜像概述和主要用途

Delta Lake 是一款开源存储框架，支持构建 Lakehouse 架构，兼容多种计算引擎（包括 Spark、PrestoDB、Flink、Trino、Hive）及多语言 API（Scala、Java、Rust、Ruby、Python）。本 Docker 镜像集成了 Python、JupyterLab、PySpark、Scala Spark、Rust、ROAPI 等工具及示例，旨在提供开箱即用的 Delta Lake 开发与运行环境，简化本地化部署与测试流程。


## 核心功能与特性

### 多引擎与多语言支持
- 兼容主流计算引擎：Apache Spark、PrestoDB、Flink、Trino、Apache Hive
- 支持多语言开发：Python、Rust、Scala、Java 等（镜像内置 Python/Rust 环境及示例）

### 集成开发工具
- 预置 JupyterLab：提供交互式开发环境，支持 PySpark、Python 数据处理
- 内置数据处理库：Polars、Pandas（依版本而定）、ROAPI（用于 REST API 快速构建）
- Spark 环境：集成 PySpark 与 Scala Spark，支持 Delta Lake 表操作

### 多平台兼容
- 支持 amd64 与 arm64 架构（4.0.0 及以上版本为多平台构建）


## 使用场景与适用范围

- **数据湖应用开发**：本地快速构建基于 Delta Lake 的数据湖应用，验证读写逻辑
- **Spark 作业调试**：在本地环境调试 PySpark/Scala Spark 作业，无需集群部署
- **多语言数据处理验证**：测试 Python/Rust 等语言对 Delta 表的操作流程
- **教学与演示**：快速搭建 Delta Lake 演示环境，展示 Lakehouse 特性


## 使用方法与配置说明

### 镜像标签说明

| 标签               | 平台        | Python 版本 | Rust 版本 | Delta-Spark 版本 | Spark 版本 | JupyterLab 版本 | Pandas 版本 | Polars 版本 | ROAPI 版本 |
|--------------------|-------------|-------------|-----------|------------------|------------|-----------------|-------------|-------------|------------|
| 1.0.0_3.0.0       | amd64       | 0.12.0      | latest    | 3.0.0            | 3.5.0      | 3.6.3           | 1.5.3       | 不包含      | 0.9.0      |
| 1.0.0_3.0.0_arm64 | arm64       | 0.12.0      | latest    | 3.0.0            | 3.5.0      | 3.6.3           | 1.5.3       | 不包含      | 0.9.0      |
| 4.0.0             | arm64/amd64 | 1.1.14      | 1.1.14    | 4.0.0            | 4.0.0      | 4.4.6           | 不包含      | 1.33.1      | 0.12.6     |
| latest            | arm64/amd64 | 1.1.14      | 1.1.14    | 4.0.0            | 4.0.0      | 4.4.6           | 不包含      | 1.33.1      | 0.12.6     |

> **注意**：自 4.0.0 版本起，镜像提供多平台构建（支持 amd64/arm64 架构）。表格中“不包含”表示该版本镜像未集成对应组件。


### 镜像拉取与运行

#### 1. 拉取镜像
根据架构和版本需求选择标签，默认拉取 `latest` 标签（多平台最新版）：
```bash
docker pull docker.xuanyuan.run/deltaio/delta-docker:latest
```

#### 2. 运行容器（JupyterLab 示例）
启动容器并映射 JupyterLab 端口（默认 8888），挂载本地目录以持久化数据：
```bash
docker run -d \
  -p 8888:8888 \
  -v ./local-data:/data \
  --name delta-dev-env \
  docker.xuanyuan.run/deltaio/delta-docker:latest \
  jupyter lab --ip=0.0.0.0 --allow-root --no-browser
```
- `-p 8888:8888`：映射 JupyterLab 端口到本地
- `-v ./local-data:/data`：挂载本地目录 `./local-data` 到容器内 `/data`，用于数据持久化
- `--name delta-dev-env`：指定容器名称
- 启动命令 `jupyter lab ...`：启动 JupyterLab 并允许外部访问

#### 3. 访问 JupyterLab
容器启动后，查看日志获取访问 token：
```bash
docker logs delta-dev-env
```
在输出中找到类似 `http://127.0.0.1:8888/lab?token=xxx` 的链接，在浏览器中访问即可。


### 标签选择建议
- **开发测试**：优先使用 `latest` 标签，获取最新功能与组件
- **架构适配**：arm64 架构用户选择 `4.0.0` 或 `latest`；旧版 amd64 用户可选择 `1.0.0_3.0.0`
- **版本兼容**：根据项目依赖的 Spark/Delta-Spark 版本选择对应标签（如依赖 Spark 3.5.0 选择 `1.0.0_3.0.0`）


## 参考链接

- [Delta Lake 官方文档](https://docs.delta.io)
- [快速入门指南](https://docs.delta.io/latest/quick-start.html)（Scala、Java、Python）
- [Delta Lake Docker GitHub 仓库](https://github.com/delta-io/delta-docker)（含详细使用示例）
- [Delta Lake DockerHub 镜像仓库](https://hub.docker.com/repository/docker/deltaio/delta-docker/)
- [Delta Lake 集成列表](https://delta.io/integrations/)（完整支持的计算引擎与工具）</think># Delta Lake Docker 镜像文档

![Delta Lake Logo](https://docs.delta.io/latest/_static/delta-lake-white.png)

[![Test](https://github.com/delta-io/delta/actions/workflows/test.yaml/badge.svg)](https://github.com/delta-io/delta/actions/workflows/test.yaml)
[![License](https://img.shields.io/badge/license-Apache%202-brightgreen.svg)](https://github.com/delta-io/delta/blob/master/LICENSE.txt)
[![PyPI](https://img.shields.io/pypi/v/delta-spark.svg)](https://pypi.org/project/delta-spark/)
[![PyPI - Downloads](https://img.shields.io/pypi/dm/delta-spark)](https://pypistats.org/packages/delta-spark)


## 镜像概述和主要用途

Delta Lake 是一款开源存储框架，支持构建 Lakehouse 架构，兼容 Spark、PrestoDB、Flink、Trino、Hive 等计算引擎，以及 Scala、Java、Rust、Ruby、Python 等多语言 API。本 Docker 镜像集成了 Python、JupyterLab、PySpark、Scala Spark、Rust、ROAPI 等工具及示例，提供开箱即用的 Delta Lake 开发环境，简化本地化部署与测试流程。


## 核心功能与特性

### 多引擎与多语言支持
- 兼容主流计算引擎：Apache Spark、PrestoDB、Flink、Trino、Apache Hive
- 支持多语言开发：Python、Rust、Scala、Java 等（镜像内置对应环境及示例）

### 集成开发工具链
- 预置 JupyterLab：提供交互式开发环境，支持 PySpark、Python 数据处理
- 内置数据处理库：Polars、Pandas（依版本而定）、ROAPI（快速构建 REST API）
- 完整 Spark 环境：集成 PySpark 与 Scala Spark，支持 Delta Lake 表操作

### 多平台架构兼容
- 支持 amd64 与 arm64 架构（4.0.0 及以上版本为多平台构建）


## 使用场景与适用范围

- **数据湖应用开发**：本地快速构建基于 Delta Lake 的数据湖应用，验证读写逻辑
- **Spark 作业调试**：在本地环境调试 PySpark/Scala Spark 作业，无需集群部署
- **多语言数据处理验证**：测试 Python/Rust 等语言对 Delta 表的操作流程
- **教学与演示**：快速搭建 Delta Lake 演示环境，展示 Lakehouse 特性


## 使用方法与配置说明

### 镜像标签说明

| 标签               | 平台        | Python 版本 | Rust 版本 | Delta-Spark 版本 | Spark 版本 | JupyterLab 版本 | Pandas 版本 | Polars 版本 | ROAPI 版本 |
|--------------------|-------------|-------------|-----------|------------------|------------|-----------------|-------------|-------------|------------|
| 1.0.0_3.0.0       | amd64       | 0.12.0      | latest    | 3.0.0            | 3.5.0      | 3.6.3           | 1.5.3       | 不包含      | 0.9.0      |
| 1.0.0_3.0.0_arm64 | arm64       | 0.12.0      | latest    | 3.0.0            | 3.5.0      | 3.6.3           | 1.5.3       | 不包含      | 0.9.0      |
| 4.0.0             | arm64/amd64 | 1.1.14      | 1.1.14    | 4.0.0            | 4.0.0      | 4.4.6           | 不包含      | 1.33.1      | 0.12.6     |
| latest            | arm64/amd64 | 1.1.14      | 1.1.14    | 4.0.0            | 4.0.0      | 4.4.6           | 不包含      | 1.33.1      | 0.12.6     |

> **注意**：自 4.0.0 版本起，镜像提供多平台构建（支持 amd64/arm64 架构）。表格中“不包含”表示该版本未集成对应组件。


### 镜像拉取与运行示例

#### 1. 拉取镜像
根据架构和版本需求选择标签，默认拉取 `latest` 标签（多平台最新版）：
```bash
docker pull docker.xuanyuan.run/deltaio/delta-docker:latest
```

#### 2. 启动 JupyterLab 环境
启动容器并映射 JupyterLab 端口，挂载本地目录以持久化数据：
```bash
docker run -d \
  -p 8888:8888 \
  -v ./local-data:/data \
  --name delta-dev-env \
  docker.xuanyuan.run/deltaio/delta-docker:latest \
  jupyter lab --ip=0.0.0.0 --allow-root --no-browser
```
- `-p 8888:8888`：映射 JupyterLab 端口到本地
- `-v ./local-data:/data`：挂载本地目录至容器 `/data`，实现数据持久化
- `--name delta-dev-env`：指定容器名称，便于后续管理

#### 3. 访问 JupyterLab
查看容器日志获取访问 token：
```bash
docker logs delta-dev-env
```
在输出中找到类似 `http://127.0.0.1:8888/lab?token=xxx` 的链接，在浏览器中访问即可。


### 标签选择建议
- **开发测试**：优先使用 `latest` 标签，获取最新功能与组件
- **架构适配**：arm64 架构选择 `4.0.0` 或 `latest`；旧版 amd64 可选择 `1.0.0_3.0.0`
- **版本兼容**：根据项目依赖的 Spark/Delta-Spark 版本选择对应标签（如依赖 Spark 3.5.0 选择 `1.0.0_3.0.0`）


## 参考链接

- [Delta Lake 官方文档](https://docs.delta.io)
- [快速入门指南](https://docs.delta.io/latest/quick-start.html)（Scala、Java、Python）
- [Delta Lake Docker GitHub 仓库](https://github.com/delta-io/delta-docker)（含详细使用示例）
- [Delta Lake DockerHub 镜像仓库](https://hub.docker.com/repository/docker/deltaio/delta-docker/)
- [Delta Lake 集成列表](https://delta.io/integrations/)（完整支持的计算引擎与工具）
