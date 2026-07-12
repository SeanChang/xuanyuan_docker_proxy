---
image: openeuler/flannel
description: "官方flannel Docker镜像，基于openEuler构建，为Kubernetes提供简单易用的三层网络结构配置，由openEuler CloudNative SIG维护。"
source: https://xuanyuan.cloud/zh/r/openeuler/flannel
canonical: https://xuanyuan.cloud/zh/r/openeuler/flannel
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/flannel" title="openeuler/flannel Docker 镜像中文简介、标签列表与拉取命令">openeuler/flannel 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# flannel | openEuler 镜像文档

## 镜像概述

本镜像为官方flannel Docker镜像，基于[openEuler](https://repo.openeuler.org/)构建，由[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)维护。Flannel是一种简单易用的三层网络结构配置工具，专为Kubernetes设计，可实现容器间的网络通信。本仓库可免费使用，且不受用户速率限制。

## 核心功能与特性

- 为Kubernetes集群提供三层网络结构配置
- 基于openEuler操作系统构建，确保兼容性和稳定性
- 支持多架构（amd64、arm64）部署
- 与上游flannel版本保持同步，验证与openEuler的集成效果

## 支持的标签及对应Dockerfile链接

每个`flannel`镜像标签由flannel版本和基础镜像版本组成，具体如下：

| 标签                                                                                                                               | 当前版本                                 | 架构         |
|-----------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|--------------|
|[0.27.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/flannel/0.27.3/24.03-lts-sp1/Dockerfile) | flannel 0.27.3 基于 openEuler 24.03-LTS-SP1 | amd64, arm64 |
| [0.26.7-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/flannel/0.26.7/24.03-lts-sp1/Dockerfile) | flannel 0.26.7 基于 openEuler 24.03-LTS-SP1 | amd64, arm64  |

## 使用方法

根据需求选择对应的`{Tag}`标签进行操作：

### 拉取镜像

```bash
docker pull docker.xuanyuan.run/openeuler/flannel:{Tag}
```

### 启动flannel实例

```bash
docker run -it --rm docker.xuanyuan.run/openeuler/flannel:{Tag}
```

> 说明：`openeuler/flannel`镜像用于验证上游flannel版本与openEuler的集成效果。

## 问题反馈

如遇任何问题或需使用特殊功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。

## 获取帮助

- [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)
- [openEuler 社区](https://gitee.com/openeuler/community)
