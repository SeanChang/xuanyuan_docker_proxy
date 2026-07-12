---
image: webera/nfs
description: "包含nfs服务器的Docker镜像"
source: https://xuanyuan.cloud/zh/r/webera/nfs
canonical: https://xuanyuan.cloud/zh/r/webera/nfs
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/webera/nfs" title="webera/nfs Docker 镜像中文简介、标签列表与拉取命令">webera/nfs 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Webera nfs 镜像

## 镜像概述

Webera nfs镜像是一个包含nfs服务器的Docker镜像，用于在容器环境中提供网络文件系统（NFS）服务。镜像源代码托管于[GitHub仓库](https://github.com/wearewebera/image-nfs)。

## 核心功能与特性

- 内置nfs服务器，支持标准NFS协议
- 提供网络文件共享服务能力
- 可通过容器化方式快速部署nfs服务

## 使用场景

- 本地开发环境中的文件共享需求
- 测试环境下的NFS服务模拟与验证
- 轻量级容器化文件服务部署

## 使用方法

### 基本运行命令

```bash
docker run -d --name nfs-server --privileged -v /host/path/to/share:/shared docker.xuanyuan.run/webera/nfs
```

> 注意：NFS服务运行可能需要特权模式（--privileged），并需挂载宿主机目录作为共享存储卷（示例中`/host/path/to/share`为宿主机目录，`/shared`为容器内共享目录）。

### 镜像源信息

镜像源代码及更多详情可访问：[https://github.com/wearewebera/image-nfs](https://github.com/wearewebera/image-nfs)
