---
image: wojiushixiaobai/dataease
description: "DataEase 是开源数据可视化分析工具（BI工具），支持丰富数据源连接，通过拖拉拽快速制作图表并分享，帮助用户快速分析数据、洞察业务趋势，实现业务优化。"
source: https://xuanyuan.cloud/zh/r/wojiushixiaobai/dataease
canonical: https://xuanyuan.cloud/zh/r/wojiushixiaobai/dataease
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/wojiushixiaobai/dataease" title="wojiushixiaobai/dataease Docker 镜像中文简介、标签列表与拉取命令">wojiushixiaobai/dataease — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/wojiushixiaobai/dataease" title="wojiushixiaobai/dataease Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/wojiushixiaobai/dataease</a>

## 镜像概述和主要用途

DataEase 是开源的数据可视化分析工具（BI工具），旨在帮助用户快速分析数据并洞察业务趋势，从而实现业务的改进与优化。该工具支持丰富的数据源连接，用户可通过拖拉拽方式快速制作图表，并能方便地与他人分享分析结果。

## 核心功能和特性

### 主要优势
- **开源开放**：零门槛获取与安装，线上快速部署，按月迭代更新
- **简单易用**：极易上手，通过鼠标点击和拖拽即可完成数据分析与图表制作
- **全场景支持**：支持多平台安装和多样化嵌入方式，适应不同使用环境
- **安全分享**：提供多种数据分享方式，确保数据在分享过程中的安全性

### 支持的数据源
- **OLTP数据库**：MySQL、Oracle、SQL Server、PostgreSQL、MariaDB、Db2、TiDB、MongoDB-BI等
- **OLAP数据库**：ClickHouse、Apache Doris、Apache Impala、StarRocks等
- **数据仓库/数据湖**：Amazon RedShift等
- **数据文件**：Excel、CSV等
- **API数据源**

## 使用场景和适用范围

DataEase 适用于各类需要数据分析与可视化的场景，包括但不限于：
- **企业数据分析**：快速整合企业内外部数据，分析业务运营状况
- **业务监控**：实时监控关键业务指标，及时发现异常与趋势
- **数据报告制作**：替代传统Excel报表，通过可视化图表呈现数据洞察
- **团队协作**：制作分析图表后便捷分享给团队成员，支持协同决策

## 详细使用方法和配置说明

### 前提条件
- 2核4G及以上配置的Linux服务器
- 已安装Docker和Docker Compose

### 快速部署步骤
1. 克隆项目仓库：
   ```bash
   cd ~
   git clone --depth=1 https://github.com/wojiushixiaobai/dataease
   ```

2. 进入项目目录并启动服务：
   ```bash
   cd ~/dataease
   docker compose up -d
   ```

3. 登录系统：
   - 服务启动后，通过服务器IP地址访问
   - 默认用户名：admin
   - 默认密码：DataEase@123456

### 其他部署方式
- **1Panel应用商店**：通过[1Panel应用商店](https://dataease.io/docs/v2/installation/1panel_installation/)可实现更便捷的部署
- **离线安装包（生产环境推荐）**：生产环境建议使用[离线安装包方式](https://dataease.io/docs/v2/installation/offline_INSTL_and_UPG/)部署，确保稳定性

## UI展示

| 工作台 | 仪表板 |
|--------|--------|
| DataEase工作台界面，展示数据分析概览与功能入口 | DataEase仪表板界面，展示多类型图表组合的数据分析结果 |
| 数据源管理界面，显示已配置的各类数据源列表 | 模板中心界面，提供丰富的图表模板供快速选用 |

## 技术栈

- **前端**：Vue.js、Element
- **图库**：AntV
- **后端**：Spring Boot
- **数据库**：MySQL
- **数据处理**：Apache Calcite、Apache SeaTunnel
- **基础设施**：Docker

## 许可证

Copyright (c) 2014-2024 FIT2CLOUD 飞致云, All rights reserved.  
基于GNU General Public License version 3 (GPLv3)许可。详情见[https://www.gnu.org/licenses/gpl-3.0.html](https://www.gnu.org/licenses/gpl-3.0.html)
