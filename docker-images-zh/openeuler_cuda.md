---
image: openeuler/cuda
description: "官方CUDA Docker镜像，基于openEuler构建，提供异构计算平台，通过分层API和高级库助力快速构建基于NVIDIA GPU的高性能计算应用和AI服务，免费使用且无用户速率限制。"
source: https://xuanyuan.cloud/zh/r/openeuler/cuda
canonical: https://xuanyuan.cloud/zh/r/openeuler/cuda
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/cuda" title="openeuler/cuda Docker 镜像中文简介、标签列表与拉取命令">openeuler/cuda 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# CUDA | openEuler 镜像文档

## 快速参考

- 官方CUDA Docker镜像。
- 维护者：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)
- 帮助获取：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)、[openEuler社区](https://gitee.com/openeuler/community)

## 镜像概述

当前CUDA Docker镜像基于[openEuler](https://repo.openeuler.org/)构建，该仓库可免费使用且无用户速率限制。

CUDA是一个异构计算平台，用于通用并行计算，提供分层API和高级库，帮助快速构建基于NVIDIA GPU的高性能计算应用和AI服务。更多信息请参考[CUDA文档](https://docs.nvidia.com/cuda/)。

## 支持的标签及对应Dockerfile链接

每个`cuda`镜像的标签由完整软件栈版本组成，详情如下：

| 标签 | 内容描述 | 架构 |
|------|----------|------|
|[11.8.0-cudnn8.9.0-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/cuda/11.8.0-cudnn8.9.0/22.03-lts/Dockerfile)| 基于openEuler 22.03-LTS的CUDA 11.8.0（含cudnn 8.9.0） | arm64, amd64 |
|[13.0.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/cuda/13.0.0/24.03-lts/Dockerfile)| 基于openEuler 24.03-LTS的CUDA 13.0.0 | arm64, amd64 |
|[13.0.0-python3.10-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/cuda/13.0.0-python3.10/24.03-lts/Dockerfile)| 基于openEuler 24.03-LTS的CUDA 13.0.0（含Python 3.10） | arm64, amd64 |

## 使用方法

用户可根据需求选择对应的`{Tag}`和容器启动选项。

### 拉取镜像

```bash
docker pull docker.xuanyuan.run/openeuler/cuda:{Tag}
```

### 启动容器实例

```bash
docker run \
    --name my-cuda \
    --gpus all \
    -it docker.xuanyuan.run/openeuler/cuda:{Tag} bash
```

### 容器启动选项说明

| 选项 | 描述 |
|------|------|
| `--name my-cuda` | 为容器命名为`my-cuda` |
| `--gpus all` | 指定容器可访问所有GPU设备，也可指定特定GPU，如`--gpus '"device=0,1"'` |
| `-it` | 以交互模式启动容器并分配终端（bash） |
| `openeuler/cuda:{Tag}` | 指定要运行的Docker镜像，将`{Tag}`替换为所需的`openeuler/cuda`镜像版本或标签 |

### 查看容器运行日志

```bash
docker logs -f my-cuda
```

### 获取交互shell

```bash
docker exec -it my-cuda /bin/bash
```

## 问答

如有任何问题或需使用特定功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。
