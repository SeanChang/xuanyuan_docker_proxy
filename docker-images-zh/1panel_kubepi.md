---
image: 1panel/kubepi
description: "KubePi 是一个现代化的 Kubernetes 面板，支持导入多个 K8s 集群，通过权限控制分配不同集群和命名空间权限给用户，帮助管理员和开发人员管理集群应用、进行故障排查，简化 K8s 集群复杂性。"
source: https://xuanyuan.cloud/zh/r/1panel/kubepi
canonical: https://xuanyuan.cloud/zh/r/1panel/kubepi
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/1panel/kubepi" title="1panel/kubepi Docker 镜像中文简介、标签列表与拉取命令">1panel/kubepi 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述

KubePi 是一个现代化的 Kubernetes 面板，旨在简化 Kubernetes 集群的管理复杂性。它允许管理员导入多个 K8s 集群，并通过细粒度的权限控制将不同集群、命名空间的操作权限分配给指定用户；同时为开发人员提供便捷的应用管理和故障排查工具，帮助团队更高效地处理 K8s 集群中的各项任务。

## 核心功能与特性

- **多集群管理**：支持导入和管理多个 Kubernetes 集群，实现统一的集群视图
- **权限控制**：基于用户角色的权限分配，可针对不同集群、命名空间设置精细化权限
- **应用管理**：提供直观界面，方便开发人员管理集群中运行的应用程序
- **故障排查**：集成故障排查工具，帮助开发人员快速定位和解决集群中的问题

## 使用场景

- **多集群管理场景**：企业内部存在多个 K8s 集群（如开发、测试、生产环境）时，通过 KubePi 实现统一管理
- **团队协作场景**：需要为不同团队或用户分配不同集群/命名空间权限，确保操作安全性和隔离性
- **开发与运维协同场景**：开发人员可自主管理应用，运维人员集中管控集群权限，提升协作效率

## 使用方法

### Docker 快速部署

通过以下命令快速启动 KubePi 容器：

```bash
docker run --privileged -d --restart=unless-stopped -p 80:80 docker.xuanyuan.run/1panel/kubepi
```

**初始登录信息**：
- 用户名：admin
- 密码：kubepi

### 通过 1Panel 应用商店部署

也可通过 [1Panel 应用商店](https://apps.fit2cloud.com/1panel) 快速部署 KubePi，简化部署流程。

### 使用手册

详细使用说明请参考官方文档：[KubePi 维基](https://github.com/1Panel-dev/KubePi/wiki)

## UI 展示

![KubePi 仪表盘](https://kubeoperator.oss-cn-beijing.aliyuncs.com/kubepi/img/02-dashboard.png)
