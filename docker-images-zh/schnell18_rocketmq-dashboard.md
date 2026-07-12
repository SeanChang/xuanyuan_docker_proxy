---
image: schnell18/rocketmq-dashboard
description: "基于官方Dockerfile修改，使用Azul提供的更新版Open JRE（schnell18/alpine-jre8-0.2.0），并添加专用entrypoint.sh以简化Java应用启动的镜像。"
source: https://xuanyuan.cloud/zh/r/schnell18/rocketmq-dashboard
canonical: https://xuanyuan.cloud/zh/r/schnell18/rocketmq-dashboard
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/schnell18/rocketmq-dashboard" title="schnell18/rocketmq-dashboard Docker 镜像中文简介、标签列表与拉取命令">schnell18/rocketmq-dashboard 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 镜像概述

该镜像基于官方Dockerfile构建，主要进行了以下优化和修改：
- 使用Azul提供的更新版Open JRE（基础镜像：schnell18/alpine-jre8-0.2.0）
- 添加专用`entrypoint.sh`脚本，简化Java应用的启动流程

镜像的源码可在GitHub获取：[https://github.com/schnell18/rocketmq-dashboard](https://github.com/schnell18/rocketmq-dashboard)

## 核心功能与特性

### 1. 更新的运行环境
采用Azul提供的Open JRE，相比官方基础镜像具有更新的Java运行时环境，提升应用稳定性和安全性。

### 2. 简化的启动流程
通过专用`entrypoint.sh`脚本，无需手动配置复杂的Java启动参数，可直接启动Java应用，降低使用门槛。

## 使用场景

适用于需要运行Java应用的场景，尤其推荐用于部署RocketMQ Dashboard（基于源码仓库推断），可简化部署流程并确保运行环境的更新。

## 使用方法

### 基本运行命令

通过`docker run`命令即可启动镜像，`entrypoint.sh`会自动处理Java应用的启动：

```bash
docker run -d --name rocketmq-dashboard docker.xuanyuan.run/schnell18/rocketmq-dashboard
```

### 自定义配置（如有需要）

若需自定义Java启动参数，可通过环境变量或挂载配置文件实现，具体可参考源码仓库中的说明文档。
