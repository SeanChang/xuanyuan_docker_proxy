---
image: openeuler/fastdfs
description: "官方FastDFS Docker镜像，基于openEuler构建，提供高性能分布式文件系统功能，支持文件存储、同步和访问，适用于高容量和负载均衡场景。"
source: https://xuanyuan.cloud/zh/r/openeuler/fastdfs
canonical: https://xuanyuan.cloud/zh/r/openeuler/fastdfs
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/fastdfs" title="openeuler/fastdfs Docker 镜像中文简介、标签列表与拉取命令">openeuler/fastdfs 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# FastDFS Docker镜像文档

## 镜像概述

本镜像为官方FastDFS Docker镜像，基于[openEuler](https://repo.openeuler.org/)构建，由[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)维护。FastDFS是一个开源高性能分布式文件系统（DFS），主要功能包括文件存储、文件同步和文件访问，专为高容量和负载均衡设计。本仓库可免费使用，无每用户速率限制。

## 核心功能与特性

- **分布式文件存储**：支持大规模文件存储，实现数据分散存储
- **文件同步机制**：确保不同节点间文件数据一致性
- **负载均衡**：优化文件访问请求分发，提升系统性能
- **高可用性**：支持集群部署，保障服务稳定运行
- **轻量级设计**：基于openEuler系统，资源占用低，部署便捷

## 支持的标签及对应Dockerfile链接

每个`fastdfs`镜像标签由FastDFS版本和基础镜像版本组成，具体如下：

| 标签 | 当前版本信息 | 支持架构 |
|------|--------------|----------|
| [6.13.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/fastdfs/6.13.0/24.03-lts-sp1/Dockerfile) | FastDFS 6.13.0 基于 openEuler 24.03-LTS-SP1 | amd64, arm64 |
| [6.12.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/fastdfs/6.12.3/24.03-lts-sp1/Dockerfile) | FastDFS 6.12.3 基于 openEuler 24.03-LTS-SP1 | amd64, arm64 |

## 使用方法

根据需求选择对应的`{Tag}`版本进行操作。

### 拉取镜像

```bash
docker pull docker.xuanyuan.run/openeuler/fastdfs:{Tag}
```

### 交互式shell运行

可通过交互式shell启动容器使用FastDFS：

```bash
docker run -it --rm docker.xuanyuan.run/openeuler/fastdfs:{Tag} bash
```

### 启动Tracker Server

```bash
fdfs_trackerd /etc/fdfs/tracker.conf start
```

验证Tracker是否运行：

```bash
ps aux | grep fdfs_trackerd
```

### 启动Storage Server

修改配置文件`/etc/fdfs/storage.conf`中的`tracker_server`为本地容器IP，然后启动：

```bash
fdfs_storaged /etc/fdfs/storage.conf start
```

验证Storage是否运行：

```bash
ps aux | grep fdfs_storaged
```

### 监控集群状态

修改配置文件`/etc/fdfs/client.conf`中的`tracker_server`为本地容器IP，然后执行：

```bash
fdfs_monitor /etc/fdfs/client.conf
```

预期输出应包含：

```
Storage 1:
    id = 172.17.0.2
    ip_addr = 172.17.0.2  ACTIVE
```

### 测试文件上传

使用实际IP和存储路径，`force`标志允许创建单节点卷：

```bash
# 创建测试文件
echo "Hello FastDFS" > test.txt

# 上传文件
fdfs_test /etc/fdfs/client.conf upload test.txt
```

## 问题反馈

如有任何问题或需要使用特定功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。
