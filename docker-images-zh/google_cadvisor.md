---
image: google/cadvisor
description: "【已废弃】此镜像不再推送新内容，请使用gcr.io/cadvisor/cadvisor替代。cAdvisor是容器资源监控工具，用于收集、聚合和导出容器资源使用及性能数据。"
source: https://xuanyuan.cloud/zh/r/google/cadvisor
canonical: https://xuanyuan.cloud/zh/r/google/cadvisor
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/google/cadvisor" title="google/cadvisor Docker 镜像中文简介、标签列表与拉取命令">google/cadvisor — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/google/cadvisor" title="google/cadvisor Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/google/cadvisor</a>

# cAdvisor Docker镜像文档

## 镜像概述

cAdvisor（Container Advisor）是一款容器资源监控工具，帮助容器用户了解运行中容器的资源使用情况和性能特征。它作为后台进程运行，负责收集、聚合、处理和导出容器相关信息，包括资源隔离参数、历史资源使用数据及完整的历史资源使用直方图，并按容器和机器级别导出数据。

**【重要提示】** 此镜像已废弃（DEPRECATED），新镜像将不再推送。请使用 `gcr.io/cadvisor/cadvisor` 替代。

## 核心功能

- **资源数据收集**：实时收集容器的CPU、内存、磁盘I/O、网络等资源使用情况
- **数据聚合与处理**：对收集的数据进行聚合和处理，生成历史资源使用记录
- **多级别数据导出**：支持按容器和机器级别导出资源使用数据
- **历史数据存储**：维护容器的资源隔离参数和历史资源使用直方图

## 镜像构建信息

官方cAdvisor发布版本基于Linux构建，并通过scratch镜像导出，确保镜像体积小巧。

- Dockerfile地址：[https://github.com/google/cadvisor/blob/master/deploy/Dockerfile](https://github.com/google/cadvisor/blob/master/deploy/Dockerfile)

## 标签说明

cAdvisor镜像提供以下标签：

- **latest**：最新稳定版本，官方支持的最新发布版本
- **canary**：从代码库HEAD定期构建的镜像，可能存在不稳定性

此外，还有一个自动化构建的canary版本`google/cadvisor-canary`，持续从HEAD构建，由于其体积较大且稳定性不确定，不推荐用于生产环境。

## 注意事项

- 此镜像已废弃，不再推送新内容，建议迁移至`gcr.io/cadvisor/cadvisor`
- canary标签和`google/cadvisor-canary`镜像仅供测试使用，生产环境应使用稳定版本
