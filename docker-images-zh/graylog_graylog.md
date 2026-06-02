---
image: graylog/graylog
description: "这是官方Graylog Docker镜像（自动构建版），Graylog作为一款开源日志管理与分析平台，该镜像支持通过容器化方式快速部署，可集中收集、存储并分析各类系统与应用日志，提供实时搜索、可视化仪表盘及告警功能，其自动构建流程确保镜像版本更新及时且可靠，有效减少手动操作错误，为用户搭建高效、稳定的日志处理系统提供便捷支持。"
source: https://xuanyuan.cloud/zh/r/graylog/graylog
canonical: https://xuanyuan.cloud/zh/r/graylog/graylog
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [graylog/graylog — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/graylog/graylog)

含镜像标签、拉取命令、部署文档与相关推荐。

[graylog/graylog Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/graylog/graylog)

# Graylog Docker 镜像

Graylog 最新稳定版本为 **6.3.4**，对应标签包括 `6.3`、`6.3.4` 或 `6.3.4-1`。

[Docker Hub 地址]([])  

生产环境建议使用稳定版 `6.3`。完整的安装与配置说明，可查看 [最新稳定版文档]([])。


## 什么是 Graylog？

Graylog 是一款集中式日志解决方案，支持日志聚合与搜索，提供强大的查询语言、数据转换处理管道、告警功能等。其功能可通过 REST API 扩展，附加组件可从 [Graylog Marketplace]([]) 下载。


## 架构

可参考 [Graylog 最小化架构图]([]) 了解整体部署结构。核心依赖为：MongoDB（存储配置数据）和 OpenSearch（存储实际日志数据）。


## 如何使用此镜像

关于 Graylog Docker 镜像的全面概述及详细说明，建议参考 [Graylog Docker 文档]([])。


## 配置

配置项可通过以下两种方式设置：  
1. **环境变量**：参数名需添加 `GRAYLOG_` 前缀并转为大写（具体参数可参考 [配置概览]([])）。  
2. **外部配置文件**：将配置文件存储在容器外，直接编辑即可。


## 文档

Graylog 文档托管于 [docs.graylog.org]([])。使用前建议先查阅文档熟悉功能，再通过 [GitHub Issues]([]) 反馈问题。


## 许可

- 本 Docker 镜像基于 Apache 2.0 许可，详见 [LICENSE](LICENSE)。  
- Graylog 本身基于 Server Side Public License (SSPL) 许可，详见 [许可信息]([])。
