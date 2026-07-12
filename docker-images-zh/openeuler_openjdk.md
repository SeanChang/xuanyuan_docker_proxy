---
image: openeuler/openjdk
description: "基于openEuler构建的官方OpenJDK Docker镜像，由openEuler CloudNative SIG维护，提供Java运行环境，支持amd64/arm64架构，免费使用且无用户速率限制。"
source: https://xuanyuan.cloud/zh/r/openeuler/openjdk
canonical: https://xuanyuan.cloud/zh/r/openeuler/openjdk
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/openjdk" title="openeuler/openjdk Docker 镜像中文简介、标签列表与拉取命令">openeuler/openjdk 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenJDK | openEuler 镜像文档

## 镜像概述和主要用途
本镜像为基于[openEuler](https://repo.openeuler.org/)构建的官方OpenJDK Docker镜像，由[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)维护。该仓库可免费使用，且无用户速率限制。OpenJDK是Java平台标准版(Java SE)及相关项目的开源实现，适用于Java应用的开发、测试和生产环境部署。

## 核心功能和特性
- 基于openEuler操作系统构建，提供稳定可靠的运行环境
- 包含OpenJDK运行时环境，支持Java应用运行
- 支持多种硬件架构（amd64、arm64）
- 标签由OpenJDK版本和基础镜像版本组成，便于版本管理

## 支持的标签及对应Dockerfile链接
每个`openjdk`镜像的标签由OpenJDK版本和基础镜像版本组成，详情如下：

| 标签 | 当前版本 | 支持架构 |
|------|----------|----------|
|[23_13-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/openjdk/23+13/22.03-lts-sp3/Dockerfile)| OpenJDK 23+13 on openEuler 22.03-LTS-SP3 | amd64, arm64 |

## 使用方法和配置说明

### 拉取镜像
根据需求选择对应的`{Tag}`，从Docker拉取`openeuler/openjdk`镜像：

```bash
docker pull docker.xuanyuan.run/openeuler/openjdk:{Tag}
```

### 启动OpenJDK实例
```bash
docker run -it --name my-openjdk docker.xuanyuan.run/openeuler/openjdk:{Tag}
```

### 查看容器运行日志
```bash
docker logs -f my-openjdk
```

### 获取交互式shell
```bash
docker exec -it my-openjdk /bin/bash
```

## 问题反馈
如有任何问题或需要使用特定功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。
