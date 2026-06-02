---
image: bitnamilegacy/kube-state-metrics
description: "Bitnami遗留镜像（不再更新）"
source: https://xuanyuan.cloud/zh/r/bitnamilegacy/kube-state-metrics
canonical: https://xuanyuan.cloud/zh/r/bitnamilegacy/kube-state-metrics
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamilegacy/kube-state-metrics" title="bitnamilegacy/kube-state-metrics Docker 镜像中文简介、标签列表与拉取命令">bitnamilegacy/kube-state-metrics 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami遗留镜像文档

## 镜像概述和主要用途
本仓库为Bitnami遗留仓库，包含所有现有容器镜像的备份。该仓库已不再更新，也不会提供任何支持，仅用于临时迁移场景。请注意，此仓库未来可能被移除。

## 核心特性
- **不再更新**：不会接收任何新的更新或安全补丁
- **无官方支持**：Bitnami不再提供技术支持服务
- **镜像备份**：包含历史所有Bitnami容器镜像的备份版本

## 使用场景和适用范围
仅适用于**临时迁移目的**，例如：
- 从旧版Bitnami镜像迁移至新版本的过渡阶段
- 临时需要访问历史特定版本镜像的场景

> **警告**：严禁用于生产环境或长期依赖，存在安全风险。

## 使用方法和注意事项

### 拉取和保存镜像
为确保镜像持续可用，建议将所需遗留镜像拉取并存储到自有容器 registry：

```bash
# 1. 拉取遗留镜像
docker pull bitnami/[镜像名称]:[标签]

# 2. 标记镜像为自有registry地址
docker tag bitnami/[镜像名称]:[标签] [你的私有registry地址]/[镜像名称]:[标签]

# 3. 推送至自有registry
docker push [你的私有registry地址]/[镜像名称]:[标签]
```

### 生产环境建议
对于生产工作负载和长期支持，强烈建议迁移至 [Bitnami Secure Images](https://bitnami.com/)，其优势包括：
- 强化容器（安全加固配置）
- 更小的攻击面（精简镜像体积）
- CVE透明度（通过VEX/KEV提供漏洞披露）
- 软件物料清单（SBOMs）
- 企业级技术支持
