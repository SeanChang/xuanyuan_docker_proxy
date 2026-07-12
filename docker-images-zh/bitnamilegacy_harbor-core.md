---
image: bitnamilegacy/harbor-core
description: "Bitnami旧版镜像（不再更新）"
source: https://xuanyuan.cloud/zh/r/bitnamilegacy/harbor-core
canonical: https://xuanyuan.cloud/zh/r/bitnamilegacy/harbor-core
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamilegacy/harbor-core" title="bitnamilegacy/harbor-core Docker 镜像中文简介、标签列表与拉取命令">bitnamilegacy/harbor-core 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述

本仓库为Bitnami旧版仓库，包含所有现有容器镜像的备份。请注意，该仓库**不再更新**，也不再提供支持，仅应作为临时迁移用途使用。

## 核心功能与特性

- **备份性质**：包含Bitnami历史容器镜像的备份副本
- **状态说明**：无后续更新、安全补丁或技术支持
- **临时可用性**：仓库未来可能被移除，镜像长期可用性无法保证

## 使用场景与适用范围

仅适用于**临时迁移场景**，当需要过渡到新版镜像或其他解决方案时，可临时使用此处的旧版镜像。**不建议用于生产环境**。

## 使用方法与注意事项

### 镜像获取与存储
若依赖本仓库中的旧版镜像，建议立即拉取并存储到您自己的容器 registry，以确保后续可用性：
```bash
# 拉取旧版镜像示例（请替换<image-name>为具体镜像名）
docker pull docker.xuanyuan.run/bitnami/<image-name>:<tag>

# 推送到私有registry示例
docker tag bitnami/<image-name>:<tag> your-registry.example.com/bitnami/<image-name>:<tag>
docker push your-registry.example.com/bitnami/<image-name>:<tag>
```

### 重要提示
- 本仓库未来可能被移除，请勿长期依赖其可用性
- 生产环境及需要长期支持的工作负载，建议迁移至[Bitnami Secure Images](https://bitnami.com/)，其特性包括：
  - 强化容器安全性
  - 更小的攻击面
  - CVE透明度（通过VEX/KEV）
  - 软件物料清单（SBOMs）
  - 企业级技术支持
