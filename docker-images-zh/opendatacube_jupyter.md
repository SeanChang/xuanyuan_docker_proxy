---
image: opendatacube/jupyter
description: "包含OpenDataCube和Jupyter的Docker镜像，用于数据处理与分析，支持环境变量配置及Docker Compose集成Postgres的部署方式。"
source: https://xuanyuan.cloud/zh/r/opendatacube/jupyter
canonical: https://xuanyuan.cloud/zh/r/opendatacube/jupyter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/opendatacube/jupyter" title="opendatacube/jupyter Docker 镜像中文简介、标签列表与拉取命令">opendatacube/jupyter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Jupyter镜像文档

## 镜像概述和主要用途
该镜像集成OpenDataCube（ODC）和Jupyter Notebook，提供便捷的数据处理与分析环境。适用于数据科学、地理空间数据分析等场景，支持通过简单配置快速启动交互式编程环境。

## 核心功能和特性
- 预装标准OpenDataCube，支持地理空间数据处理
- 集成Jupyter Notebook，提供交互式编程环境
- 包含环境变量驱动的配置入口点，便于自定义设置
- 支持Docker Compose部署，可与Postgres等服务集成

## 使用场景和适用范围
- 数据科学研究与开发
- 地理空间数据处理与分析
- 教育和培训中的交互式编程教学
- 需要快速部署Jupyter与ODC环境的场景

## 使用方法和配置说明

### 基本运行方式
通过以下命令启动Jupyter Notebook服务：

```bash
docker run \
    --rm \
    -p 8888:8888 \
    docker.xuanyuan.run/opendatacube/jupyter \
    jupyter notebook --ip="*" --NotebookApp.token='secretpassword'
```

参数说明：
- `--rm`：容器退出后自动删除
- `-p 8888:8888`：将容器的8888端口映射到主机的8888端口
- `opendatacube/jupyter`：镜像名称
- `jupyter notebook --ip="*" --NotebookApp.token='secretpassword'`：启动Jupyter Notebook并设置访问令牌

### Docker Compose部署
该镜像提供简单的Docker Compose配置，可与Postgres一起运行：

```bash
docker-compose up
```

### 环境变量配置
- `NB_USER`：设置Jupyter运行的非特权用户名称，默认值可根据镜像配置调整。

使用示例（自定义用户）：

```bash
docker run \
    --rm \
    -p 8888:8888 \
    -e NB_USER=myuser \
    opendatacube/jupyter \
    jupyter notebook --ip="*" --NotebookApp.token='secretpassword'
