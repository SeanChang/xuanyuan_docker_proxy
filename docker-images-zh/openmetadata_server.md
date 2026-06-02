---
image: openmetadata/server
description: "一站式数据发现、协作与治理平台，通过中央元数据仓库、深度数据血缘和团队协作功能，帮助用户有效管理数据资产并确保数据质量。"
source: https://xuanyuan.cloud/zh/r/openmetadata/server
canonical: https://xuanyuan.cloud/zh/r/openmetadata/server
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [openmetadata/server — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/openmetadata/server)

含镜像标签、拉取命令、部署文档与相关推荐。

[openmetadata/server Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/openmetadata/server)

## OpenMetadata 概述

OpenMetadata 是一个统一的元数据管理平台，专注于数据发现、可观测性和治理，由中央元数据仓库、深度数据血缘追踪和无缝团队协作功能提供支持。作为快速发展的开源项目，它拥有活跃社区并被各行业企业广泛采用。基于开放元数据标准和 API，支持 75 种以上数据服务连接器，实现端到端元数据管理，助力用户释放数据资产价值。

### 核心组件

OpenMetadata 包含四个主要组件：
- **元数据 Schema**：基于通用抽象和类型的元数据核心定义与词汇表，支持自定义扩展以适应不同用例。
- **元数据存储**：中央存储库，以统一方式存储和管理连接数据资产、用户及工具生成元数据的元数据图。
- **元数据 API**：构建于元数据 Schema 之上的元数据生产与消费接口，支持用户界面、工具及服务与元数据存储的无缝集成。
- **数据摄入框架**：可插拔框架，支持从各类数据源和工具摄入元数据，涵盖数据仓库、数据库、仪表板、消息系统、管道服务等 75 种以上连接器。

## 核心功能特性

### 数据发现
在单一平台中查找和探索所有数据资产，支持关键词搜索、数据关联和高级查询，覆盖表、主题、仪表板、管道及服务等多种数据对象。

### 数据协作
支持团队就数据资产进行沟通与协作，提供事件通知、警报发送、公告发布、任务创建及对话线程等功能，促进跨团队协作效率。

### 数据质量与分析器
通过无代码方式衡量和监控数据质量，支持定义数据质量测试、分组测试套件及交互式结果展示，使数据质量成为组织共同责任。

### 数据治理
实施组织级数据策略与标准，支持数据域和数据产品定义、所有者分配、标签与术语分类，以及自动化数据分类功能。

### 数据洞察与 KPI
通过报告和平台分析提供数据状态关键指标视图，支持 KPI 定义与目标设置，并可配置基于 KPI 的定时警报。

### 数据血缘
端到端跟踪数据资产的来源与转换过程，支持列级血缘可视化、查询筛选及无代码编辑器手动调整血缘关系。

### 数据文档
使用富文本、图像和链接记录数据资产，支持评论注释、数据字典生成及数据目录创建，提升数据可理解性。

### 数据可观测性
监控数据资产与管道的健康状态，跟踪数据新鲜度、数据量、质量及延迟等指标，支持异常与故障警报配置。

### 数据安全
集成多种身份验证与授权机制，支持单点登录及细粒度访问控制，保障数据与元数据安全。

### Webhooks 集成
通过 Webhooks 与外部应用集成，支持 Slack、Microsoft Teams、Google Chat 等工具接收元数据事件通知。

## 试用沙箱

访问 [http://sandbox.open-metadata.org](http://sandbox.open-metadata.org) 体验含示例数据的沙箱环境。

## 安装与运行

### 快速部署
参考 [官方安装文档](https://docs.open-metadata.org/quick-start/local-docker-deployment) 完成本地 Docker 部署，几分钟内即可启动服务。

## 文档与支持

- **官方文档**：[https://docs.open-metadata.org](https://docs.open-metadata.org)，提供完整功能说明与操作指南。
- **社区支持**：加入 [Slack 社区](https://slack.open-metadata.org) 获取实时帮助、讨论功能需求或参与社区交流。

## 许可证
OpenMetadata 基于 [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0) 许可发布。
