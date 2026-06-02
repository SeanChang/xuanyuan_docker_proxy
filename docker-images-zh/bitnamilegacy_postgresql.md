---
image: bitnamilegacy/postgresql
description: "Bitnami Legacy镜像（不再更新），包含所有现有容器镜像的备份，仅用于临时迁移目的，不提供进一步更新或支持。"
source: https://xuanyuan.cloud/zh/r/bitnamilegacy/postgresql
canonical: https://xuanyuan.cloud/zh/r/bitnamilegacy/postgresql
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [bitnamilegacy/postgresql — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/bitnamilegacy/postgresql)

含镜像标签、拉取命令、部署文档与相关推荐。

[bitnamilegacy/postgresql Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/bitnamilegacy/postgresql)

# Bitnami Legacy镜像文档

## 镜像概述和主要用途

本仓库为Bitnami Legacy仓库，**不再更新**。仓库中包含所有现有容器镜像的备份，这些镜像将不再接收进一步的更新或技术支持，仅应用于临时迁移场景。请注意，该仓库未来可能会被移除。

## 核心功能和特性

- **镜像备份**：包含Bitnami所有现有容器镜像的完整备份。
- **状态说明**：不再提供任何形式的更新（包括安全更新）或技术支持。
- **临时属性**：仅用于临时迁移需求，不适合长期依赖或生产环境使用。

## 使用场景和适用范围

### 适用场景
- **临时迁移**：需将基于旧版Bitnami镜像的工作负载临时迁移至其他环境的场景。

### 不适用场景
- **生产环境**：不适合用于生产环境工作负载（缺乏更新和支持，存在安全风险）。
- **长期部署**：不建议作为长期依赖的镜像源（仓库未来可能被移除）。

## 使用方法和配置说明

### 镜像获取与存储
由于原仓库未来可能被移除，建议立即拉取所需镜像并存储至自有容器 registry：

```bash
# 1. 拉取Legacy镜像
docker pull bitnami/[镜像名称]:[标签]

# 2. 标记镜像为私有registry地址（示例）
docker tag bitnami/[镜像名称]:[标签] registry.example.com/bitnami/[镜像名称]:[标签]

# 3. 推送至私有registry
docker push registry.example.com/bitnami/[镜像名称]:[标签]
```

### 注意事项
- **及时迁移**：务必在仓库移除前完成必要镜像的拉取和存储，避免后续无法访问。
- **风险自负**：使用过程中不提供技术支持，需自行评估镜像的安全性和兼容性。

## 生产环境替代方案
对于生产环境或长期支持需求，推荐使用[Bitnami Secure Images](https://bitnami.com/)，其核心优势包括：
- 容器加固（减少安全漏洞）
- 更小的攻击面（优化镜像体积和组件）
- CVE透明度（通过VEX/KEV报告披露漏洞信息）
- 软件物料清单（SBOMs，提升供应链透明度）
- 企业级技术支持
