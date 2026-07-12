---
image: hugegraph/loader
description: "hugegraph-loader是一个命令行工具，用于将图数据集加载到HugeGraph数据库中，支持多种数据源和输入格式，可定制数据加载过程。"
source: https://xuanyuan.cloud/zh/r/hugegraph/loader
canonical: https://xuanyuan.cloud/zh/r/hugegraph/loader
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hugegraph/loader" title="hugegraph/loader Docker 镜像中文简介、标签列表与拉取命令">hugegraph/loader 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# hugegraph-loader

[![License](https://img.shields.io/badge/license-Apache%202-0E78BA.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)
[![Build Status](https://github.com/apache/hugegraph-toolchain/actions/workflows/loader-ci.yml/badge.svg)](https://github.com/apache/hugegraph-toolchain/actions/workflows/loader-ci.yml)
[![codecov](https://codecov.io/gh/hugegraph/hugegraph-loader/branch/master/graph/badge.svg)](https://codecov.io/gh/hugegraph/hugegraph-loader)
[![Maven Central](https://maven-badges.herokuapp.com/maven-central/org.apache.hugegraph/hugegraph-loader/badge.svg)](https://mvnrepository.com/artifact/org.apache.hugegraph/hugegraph-loader)

hugegraph-loader是一个可定制的命令行工具，用于将中小型图数据集从多种数据源加载到HugeGraph数据库中，支持多种输入格式，提供灵活的数据加载管理能力。

## 核心功能和特性

- **多数据源支持**：包括本地文件、HDFS文件、MySQL等
- **多种输入格式**：支持JSON、CSV及带任意分隔符的文本格式
- **多样化加载选项**：提供直观的参数配置，方便用户管理数据加载过程
- **自动模式检测**：可从数据中自动检测模式，减少复杂的模式管理工作
- **Groovy脚本自定义**：支持通过Groovy脚本自定义顶点和边的构建逻辑

## 使用场景和适用范围

适用于测试/开发环境中快速加载图数据，以及需要将中小型图数据集导入HugeGraph数据库的场景。特别适合需要处理多种数据格式和来源，或需要自定义数据转换逻辑的用户。

## 使用方法和配置说明

### 获取镜像

- 使用最新/测试版本：`docker pull docker.xuanyuan.run/hugegraph/loader`
- 使用稳定/发布版本：`docker pull docker.xuanyuan.run/hugegraph/loader:1.2.0`（或未来其他发布标签）

### Docker运行

#### docker run

基础启动命令：
```bash
docker run -itd --name loader docker.xuanyuan.run/hugegraph/loader
```

挂载数据目录（加载本地数据时）：
```bash
docker run -itd --name loader -v /path/to/local/data:/loader/data docker.xuanyuan.run/hugegraph/loader
```

#### docker-compose

示例`docker-compose.yml`可参考[官方示例](https://github.com/apache/incubator-hugegraph-toolchain/blob/master/hugegraph-loader/docker/example/docker-compose.yml)，通过以下命令部署loader、server和hubble：
```bash
docker-compose up -d
```

> 注意：
> 1. hugegraph-loader的Docker镜像是便捷发布版本，非**官方发布**工件。更多详情请参见[ASF发布分发政策](https://infra.apache.org/release-distribution.html#dockerhub)。
> 2. 推荐使用`release tag`（如`1.2.0`）获取稳定版本，`latest`标签用于体验开发中的最新功能。

### 数据加载操作

#### 使用Docker加载数据

若loader与HugeGraph服务器在同一Docker网络（如通过docker-compose部署），可使用服务器容器名作为主机名（示例中服务器容器名为`graph`）；若单独部署，需指定服务器所在主机的IP。

基本加载命令：
```bash
docker exec -it loader bin/hugegraph-loader.sh -g hugegraph -f example/file/struct.json -s example/file/schema.groovy -h graph -p 8080
```

核心参数说明：
- `-g`：目标图名称
- `-f`：数据结构配置文件路径
- `-s`：模式（schema）定义文件路径
- `-h`：HugeGraph服务器地址
- `-p`：HugeGraph服务器端口

更多参数详情请参见[官方文档](https://hugegraph.apache.org/docs/quickstart/hugegraph-loader/#341-parameter-description)。

## 文档和资源

完整使用指南请访问[hugegraph-loader官方文档](https://hugegraph.apache.org/docs/quickstart/hugegraph-loader/)。

## 许可证

hugegraph-loader采用Apache 2.0许可证。
