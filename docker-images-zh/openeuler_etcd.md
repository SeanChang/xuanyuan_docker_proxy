---
image: openeuler/etcd
description: "官方etcd Docker镜像，基于openEuler构建，提供分布式键值存储功能，适用于在集群中安全存储数据，具有可靠性、容错性和易用性。"
source: https://xuanyuan.cloud/zh/r/openeuler/etcd
canonical: https://xuanyuan.cloud/zh/r/openeuler/etcd
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/etcd" title="openeuler/etcd Docker 镜像中文简介、标签列表与拉取命令">openeuler/etcd — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/openeuler/etcd" title="openeuler/etcd Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/openeuler/etcd</a>

# etcd | openEuler Docker镜像文档

## 镜像概述

本镜像为官方etcd Docker镜像，基于[openEuler](https://repo.openeuler.org/)构建，由[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)维护。该镜像可免费使用，且无每用户速率限制。

etcd是一个分布式键值存储系统，设计用于在集群中安全存储数据。因其可靠性、容错性和易用性，etcd在生产环境中被广泛应用。更多关于etcd的信息，请访问[https://etcd.io/](https://etcd.io/)。

## 核心功能与特性

- **分布式存储**：支持在集群环境中分布式存储键值数据
- **高可靠性**：具备容错机制，确保数据在节点故障时仍可访问
- **安全性**：设计用于安全存储关键数据
- **易用性**：简单的部署和配置流程，适合生产环境使用

## 支持的标签及对应Dockerfile链接

etcd Docker镜像的标签由etcd版本和基础镜像版本组成，具体信息如下：

| 标签 | 内容 | 支持架构 |
|------|------|----------|
|[3.6.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/etcd/3.6.0/24.03-lts-sp1/Dockerfile)| 基于openEuler 24.03-LTS-SP1的Etcd 3.6.0 | amd64, arm64 |

## 使用方法

### 创建网络

```bash
docker network create app-tier --driver bridge
```

### 启动etcd服务器实例

使用`--network app-tier`参数将etcd容器附加到`app-tier`网络：

```bash
docker run -d --name Etcd-server \
    --network app-tier \
    --publish 2379:2379 \
    --publish 2380:2380 \
    --env ALLOW_NONE_AUTHENTICATION=yes \
    --env ETCD_ADVERTISE_CLIENT_URLS=http://etcd-server:2379 \
    openeuler/etcd:latest
```

#### 环境变量说明

- `ALLOW_NONE_AUTHENTICATION=yes`：允许无认证访问（仅用于测试环境，生产环境建议启用认证）
- `ETCD_ADVERTISE_CLIENT_URLS`：指定etcd向集群中其他成员通告的客户端URL

## 问题与反馈

如遇任何问题或需要使用特定功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)仓库提交issue或pull request。

## 获取帮助

- [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)
- [openEuler社区](https://gitee.com/openeuler/community)
