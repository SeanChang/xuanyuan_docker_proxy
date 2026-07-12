---
image: openeuler/alluxio
description: "官方alluxio Docker镜像，基于openEuler构建，是大型数据的分布式缓存平台，桥接计算框架与存储系统，提供统一接口以连接多种存储系统。"
source: https://xuanyuan.cloud/zh/r/openeuler/alluxio
canonical: https://xuanyuan.cloud/zh/r/openeuler/alluxio
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/alluxio" title="openeuler/alluxio Docker 镜像中文简介、标签列表与拉取命令">openeuler/alluxio 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# alluxio 镜像文档

## 快速参考

- 官方alluxio Docker镜像。
- 维护者：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)。
- 获取帮助：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)、[openEuler](https://gitee.com/openeuler/community)。

## 镜像概述

当前alluxio（alluxio存储栈）Docker镜像基于[openEuler](https://repo.openeuler.org/)构建。此仓库可免费使用，且无每用户速率限制。

Alluxio开源版（前身为Tachyon）是一个面向大规模数据的分布式缓存平台。它弥合了计算框架与存储系统之间的差距，使计算应用能够通过统一接口连接到多种存储系统。

了解更多关于alluxio的信息，请访问[https://www.alluxio.io/](https://www.alluxio.io/)。

## 核心功能与特性

- **分布式缓存平台**：专为大规模数据设计，提供高效缓存能力
- **存储系统桥接**：连接计算框架与多种存储系统，简化数据访问流程
- **统一接口**：为计算应用提供一致的数据访问方式，降低多存储系统集成复杂度
- **openEuler基础**：基于openEuler构建，确保稳定性与兼容性
- **免费无限制**：可自由使用，无每用户速率限制

## 支持的标签及对应Dockerfile链接

每个`alluxio` Docker镜像的标签由alluxio版本和基础镜像版本组成，详情如下：

| 标签 | 当前信息 | 架构 |
|------|----------|------|
|[2.9.4-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/alluxio/2.9.4/24.03-lts-sp1/Dockerfile)| 基于openEuler 24.03-LTS-SP1的Alluxio 2.9.4 | amd64, arm64 |

## 使用方法

### 环境准备

#### 创建连接Alluxio容器的网络
```bash
docker network create alluxio_nw
```

#### 创建存储ufs数据的卷
```bash
docker volume create ufs
```

### 启动Alluxio主节点
```bash
docker run -d --net=alluxio_nw \
    -p 19999:19999 \
    --name=alluxio-master \
    -v ufs:/opt/alluxio/underFSStorage \
    docker.xuanyuan.run/openeuler/alluxio:latest master
```

启动后，可通过 `http://localhost:19999` 访问Alluxio主节点Web界面。

## 常见问题

如有任何问题或需要使用特定功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或拉取请求。
