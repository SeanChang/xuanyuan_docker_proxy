---
image: chrislusf/seaweedfs
description: "SeaweedFS的官方Docker构建镜像"
source: https://xuanyuan.cloud/zh/r/chrislusf/seaweedfs
canonical: https://xuanyuan.cloud/zh/r/chrislusf/seaweedfs
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/chrislusf/seaweedfs" title="chrislusf/seaweedfs Docker 镜像中文简介、标签列表与拉取命令">chrislusf/seaweedfs 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# SeaweedFS Docker镜像

## 概述
这是SeaweedFS的官方Docker构建镜像，用于便捷部署和运行SeaweedFS分布式文件系统。SeaweedFS是一个高性能、可扩展的分布式文件存储系统，适用于大规模文件存储场景。

## 试用

```bash
wget https://raw.githubusercontent.com/chrislusf/seaweedfs/master/docker/seaweedfs-compose.yml
docker-compose -f seaweedfs-compose.yml -p seaweedfs up
```

## 试用最新版本

```bash
wget https://raw.githubusercontent.com/chrislusf/seaweedfs/master/docker/seaweedfs-dev-compose.yml
docker-compose -f seaweedfs-dev-compose.yml -p seaweedfs up
```

## 本地开发

```bash
cd $GOPATH/src/github.com/chrislusf/seaweedfs/docker
make
```

## 构建并推送多架构镜像

确保支持`docker buildx`（可能需要Docker的实验性功能）

```bash
BUILDER=$(docker buildx create --driver docker-container --use)
docker buildx build --pull --push --platform linux/386,linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6 . -t chrislusf/seaweedfs
docker buildx stop $BUILDER
