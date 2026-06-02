---
image: openeuler/hadoop
description: "官方Hadoop Docker镜像，基于openEuler构建，支持分布式处理大型数据集，提供Web UI访问，适用于大数据处理场景。"
source: https://xuanyuan.cloud/zh/r/openeuler/hadoop
canonical: https://xuanyuan.cloud/zh/r/openeuler/hadoop
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/hadoop" title="openeuler/hadoop Docker 镜像中文简介、标签列表与拉取命令">openeuler/hadoop — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/openeuler/hadoop" title="openeuler/hadoop Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/openeuler/hadoop</a>

# Hadoop Docker镜像（openEuler）

## 镜像概述和主要用途
这是官方Hadoop Docker镜像，基于openEuler构建。Apache Hadoop是一个允许使用简单编程模型在计算机集群上分布式处理大型数据集的框架。该镜像免费使用，无每用户速率限制。

## 核心功能和特性
- 基于openEuler操作系统构建，稳定可靠
- 支持Apache Hadoop分布式数据处理框架
- 提供Web UI界面，便于监控和管理
- 支持amd64和arm64架构

## 支持的标签及Dockerfile链接
每个Hadoop Docker镜像的标签由Hadoop版本和基础镜像版本组成，详情如下：

| 标签 | 当前版本 | 架构 |
|------|----------|------|
|[3.4.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/hadoop/3.4.1/24.03-lts-sp1/Dockerfile)|基于openEuler 24.03-LTS-SP1的Apache Hadoop 3.4.1|amd64、arm64|

## 使用方法和配置说明

### 部署Hadoop实例
通过以下命令部署Hadoop实例：

```bash
docker run -d \
    --name hadoop \
    --hostname localhost \
    -p 9870:9870 \
    -p 8088:8088 \
    -p 19888:19888 \
    openeuler/hadoop:latest
```

### 查看容器日志
使用以下命令查看Hadoop启动日志：

```bash
docker logs --follow hadoop
```

当日志中出现以下信息时，表示Hadoop已准备就绪：

```
Starting resourcemanager
Starting nodemanagers
```

此时按Ctrl + C退出日志查看，即可访问Hadoop Web UI。

### Web UI访问
| 服务名称 | URL |
|----------|-----|
| NameNode | http://localhost:9870 |
| ResourceManager | http://localhost:8088 |
| JobHistory | http://localhost:19888 |

### 停止和删除容器
使用以下命令停止并删除Hadoop容器：

```bash
docker stop hadoop
docker rm hadoop
```

## 问题与反馈
如有任何问题或需要使用特殊功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。
