---
image: library/celery
description: "该镜像已弃用，请改用“python”镜像。"
source: https://xuanyuan.cloud/zh/r/library/celery
canonical: https://xuanyuan.cloud/zh/r/library/celery
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/celery" title="library/celery Docker 镜像中文简介、标签列表与拉取命令">library/celery — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/celery" title="library/celery Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/celery</a>

# Celery Docker 镜像文档


## 镜像概述和主要用途

本镜像为 Celery 的官方 Docker 镜像，**已被正式弃用**。官方推荐使用 [标准 `python` 镜像](https://hub.docker.com/_/python/) 替代，且自 2017 年 6 月 1 日起不再提供任何更新。请用户据此调整使用方式。

> 有关弃用原因的详细讨论，参见 [docker-library/celery#1](https://github.com/docker-library/celery/issues/1#issuecomment-287655769) 和 [docker-library/celery#12](https://github.com/docker-library/celery/issues/12)。


## 核心功能和特性

Celery 是一个基于分布式消息传递的开源异步任务队列/作业队列，专注于实时操作，同时支持任务调度。本镜像曾用于快速部署 Celery 环境，但由于以下原因已不再维护：
- 多数场景下使用本镜像需重新安装应用依赖，增加复杂性
- 官方推荐在应用容器中直接集成 Celery，简化部署流程


## 使用场景和适用范围

### 原适用场景
- 快速启动 Celery Worker 节点
- 连接 RabbitMQ/Redis 等消息代理实现分布式任务处理

### 当前推荐方案
由于本镜像已弃用，**推荐在应用容器中直接安装并运行 Celery**。例如，通过 `python` 镜像构建应用镜像时，使用 `pip install celery` 集成 Celery，再通过命令行启动 Worker/Beat 等组件。


## 详细的使用方法和配置说明

### 过时用法（不推荐）
以下为镜像弃用前的典型使用方式，仅供参考：

#### 1. 连接 RabbitMQ 启动 Worker
```bash
# 假设已启动 RabbitMQ 容器（名称：some-rabbit）
docker run --link some-rabbit:rabbit --name some-celery -d celery
```

#### 2. 检查集群状态
```bash
docker run --link some-rabbit:rabbit --rm celery celery status
```

#### 3. 连接 Redis 启动 Worker
```bash
# 假设已启动 Redis 容器（名称：some-redis）
docker run --link some-redis:redis -e CELERY_BROKER_URL=redis://redis --name some-celery -d celery
```


### 当前推荐用法
大多数应用应在自身容器中集成 Celery，通过命令行启动相关组件。以 Sentry 为例（参考 [Sentry 镜像文档](https://github.com/docker-library/docs/blob/d328e02359c6fc9a7f1f3c59efa2893f63e667e4/sentry/README.md#how-to-setup-a-full-sentry-instance)）：

#### 1. 启动 Celery Beat（定时任务）
```bash
docker run -d --name sentry-cron ... sentry run cron
```

#### 2. 启动 Celery Worker
```bash
docker run -d --name sentry-worker-1 ... sentry run worker
```


## 支持的标签及对应 Dockerfile 链接

- [`4.0.2`, `4.0`, `4`（*4.0/Dockerfile*）](https://github.com/docker-library/celery/blob/96de4372507fc4eb147f43b8c4f207da3d95bcd1/4.0/Dockerfile)
- [`3.1.25`, `3.1`, `3`, `latest`（*3.1/Dockerfile*）](https://github.com/docker-library/celery/blob/e6b17d6339f3cf26a0bfd7083cd2ae926f6e5130/3.1/Dockerfile)


## 快速参考

### 帮助与支持
- **获取帮助**：[Docker 社区论坛](https://forums.docker.com/)、[Docker 社区 Slack](https://blog.docker.com/2016/11/introducing-docker-community-directory-docker-community-slack/)、[Stack Overflow](https://stackoverflow.com/search?tab=newest&q=docker)

### 问题反馈
- **提交 issue**：[https://github.com/docker-library/celery/issues](https://github.com/docker-library/celery/issues)

### 维护与更新
- **维护者**：[Docker 社区](https://github.com/docker-library/celery)
- **镜像 artifact 详情**：[repo-info 仓库的 `repos/celery/` 目录](https://github.com/docker-library/repo-info/blob/master/repos/celery)（[历史记录](https://github.com/docker-library/repo-info/commits/master/repos/celery)）
- **镜像更新记录**：[官方镜像 PR（标签 `library/celery`）](https://github.com/docker-library/official-images/pulls?q=label%3Alibrary%2Fcelery)
- **文档来源**：[docs 仓库的 `celery/` 目录](https://github.com/docker-library/docs/tree/master/celery)（[历史记录](https://github.com/docker-library/docs/commits/master/celery)）

### 环境要求
- **支持的 Docker 版本**：[最新稳定版](https://github.com/docker/docker/releases/latest)（最低支持 1.6，尽力兼容）
