---
image: bolagnaise/tesla-amber-sync
description: "⚠️ 已弃用：请使用 bolagnaise/tesla-sync 替代此镜像。原镜像用于澳大利亚Tesla Powerwall能源管理，支持与Amber Electric或Flow Power动态定价同步、创建自定义TOU计划及利用AEMO批发价格峰值最大化电池收益，但目前已停止维护。"
source: https://xuanyuan.cloud/zh/r/bolagnaise/tesla-amber-sync
canonical: https://xuanyuan.cloud/zh/r/bolagnaise/tesla-amber-sync
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bolagnaise/tesla-amber-sync" title="bolagnaise/tesla-amber-sync Docker 镜像中文简介、标签列表与拉取命令">bolagnaise/tesla-amber-sync 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Tesla Sync Docker镜像（已弃用）

## 重要通知

⚠️ **此镜像已弃用**，请使用官方维护的 `bolagnaise/tesla-sync` 镜像替代。本镜像不再接收更新和支持。

## 原镜像概述

Tesla Sync 是一款针对澳大利亚市场的智能Tesla Powerwall能源管理工具，原设计用于：
- 与Amber Electric或Flow Power（AEMO批发）动态定价自动同步
- 创建适用于任何电力供应商的自定义TOU（分时电价）计划
- 利用AEMO批发价格峰值最大化电池收益潜力

## 核心功能（原设计）

### 核心功能
- **自动TOU tariff同步** - 每5分钟更新Tesla Powerwall的Amber Electric定价
- **实时定价仪表板** - 监控当前和历史电价，支持实时更新
- **近实时能源监控** - 能源使用图表每30秒更新一次
- **时区支持** - 从Amber数据自动检测时区，确保澳大利亚所有州的时间显示准确

### 高级功能
- **AEMO峰值检测** - 自动监控澳大利亚批发电价，在极端价格事件时切换到峰值电价（可配置阈值）
- **太阳能限制** - 在负电价期间（≤0c/kWh）自动阻止太阳能输出
- **峰值保护** - 防止Powerwall在Amber价格峰值期间从电网充电
- **出口价格提升** - 人为提高出口价格，以在较低价格点触发Powerwall输出
- **Flow Power + AEMO支持** - 全面支持Flow Power和其他使用AEMO NEM定价的批发电力零售商
- **自定义TOU计划** - 为任何电力供应商创建和管理自定义分时电价计划

## 替代方案

请使用官方维护的镜像：`bolagnaise/tesla-sync`

### 获取替代镜像
```bash
docker pull docker.xuanyuan.run/bolagnaise/tesla-sync
```

### 官方文档
有关最新安装和使用说明，请访问：
- [GitHub仓库](https://github.com/bolagnaise/tesla-sync)
- [Docker Hub](https://hub.docker.com/r/bolagnaise/tesla-sync)

## 免责声明

原镜像为非官方集成，与Tesla, Inc.或Amber Electric无关联或背书。使用风险自负。开发者不对因使用本软件可能引起的任何损害或问题负责。
