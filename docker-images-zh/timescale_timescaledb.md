---
image: timescale/timescaledb
description: "这是一款专为高性能实时分析场景设计的时序数据库，以PostgreSQL扩展的形式提供，能够无缝集成至PostgreSQL生态系统，高效支持时序数据的实时采集、存储与快速分析，为工业监控、物联网数据追踪、金融市场实时指标等场景提供便捷且高性能的数据管理解决方案，满足用户对大规模时序数据实时处理与深度分析的核心需求。"
source: https://xuanyuan.cloud/zh/r/timescale/timescaledb
canonical: https://xuanyuan.cloud/zh/r/timescale/timescaledb
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/timescale/timescaledb" title="timescale/timescaledb Docker 镜像中文简介、标签列表与拉取命令">timescale/timescaledb — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/timescale/timescaledb" title="timescale/timescaledb Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/timescale/timescaledb</a>

# TimescaleDB 介绍


## 基本信息  
TimescaleDB 是一款开源时序数据库，专为快速写入和复杂查询优化。它基于 PostgreSQL 构建，以扩展包形式提供，可直接集成到 PostgreSQL 生态中。


## 注意事项  
**请注意：此镜像没有 `latest` 标签**，具体原因见下文说明。


## 主要标签  
以下是常用的镜像标签（基于不同 PostgreSQL 版本）：  
- `latest-pg17`：基于 PostgreSQL 17 的最新版本  
- `latest-pg16`：基于 PostgreSQL 16 的最新版本  
- `latest-pg15`：基于 PostgreSQL 15 的最新版本  
- `latest-pg14`：基于 PostgreSQL 14 的最新版本  

此外，每个发布版本也有对应标签，例如 `2.18.0-pg17`、`2.18.0-pg16`、`2.18.0-pg15`、`2.18.0-pg14`。


## 主要链接  
- 镜像使用详细说明：[[]]([])  
- TimescaleDB 项目主页（GitHub）：[[]]([])  
- Docker 镜像仓库：[[]]([])  
- 官方网站：[[]]([])  


## 为什么没有 `latest` 标签？  
通常不建议使用 Docker 镜像的 `latest` 标签，因为可能导致意外升级。对于 TimescaleDB，这一问题更突出：升级不仅可能改变 TimescaleDB 版本，还可能涉及 PostgreSQL 主版本变化。若 `latest` 标签自动升级 PostgreSQL 主版本，用户需执行 `pg_upgrade` 操作，这会给运维带来预期外的麻烦。  

因此，我们不提供统一的 `latest` 标签，而是为每个支持的 PostgreSQL 版本单独发布 `latest` 等效标签（如 `latest-pg17`）。但仍建议生产环境明确指定具体版本，避免使用这些 `latest` 标签，以防止意外升级风险。
