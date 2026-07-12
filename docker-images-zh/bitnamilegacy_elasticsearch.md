---
image: bitnamilegacy/elasticsearch
description: "Bitnami旧版镜像（不再更新，仅用于临时迁移）"
source: https://xuanyuan.cloud/zh/r/bitnamilegacy/elasticsearch
canonical: https://xuanyuan.cloud/zh/r/bitnamilegacy/elasticsearch
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamilegacy/elasticsearch" title="bitnamilegacy/elasticsearch Docker 镜像中文简介、标签列表与拉取命令">bitnamilegacy/elasticsearch 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Legacy 镜像文档

## 镜像概述

本镜像来自Bitnami Legacy仓库，包含所有现有Bitnami容器镜像的备份。该仓库已停止维护，不再提供更新或技术支持，仅建议用于临时迁移场景。请注意，该仓库未来可能被移除，依赖这些旧镜像的用户需及时采取措施确保可用性。

## 核心功能与特性

- **旧版镜像备份**：包含历史Bitnami容器镜像的完整备份，保留原有镜像内容
- **临时可用性**：作为迁移过渡期的临时资源，支持从旧版镜像向新方案迁移
- **无更新支持**：不再提供安全更新、功能优化或技术支持服务

## 使用场景与适用范围

- **临时迁移**：仅适用于依赖旧版Bitnami镜像的系统进行临时迁移操作
- **过渡期使用**：作为从旧版镜像迁移至新解决方案期间的临时替代资源
- **非生产环境**：严禁用于生产工作负载，不具备安全保障能力

## 使用方法与配置说明

### 镜像拉取与存储建议

由于该仓库未来可能被移除，建议依赖旧版镜像的用户执行以下操作：

1. **拉取镜像**：使用`docker pull`命令获取所需旧版镜像
   ```bash
   docker pull docker.xuanyuan.run/bitnami/[镜像名称]:[标签]
   ```
   *注：将`[镜像名称]`和`[标签]`替换为实际需要的镜像信息*

2. **存储至私有仓库**：将拉取的镜像推送至用户自有容器 registry，确保长期可用性
   ```bash
   # 标记镜像为私有仓库地址
   docker tag bitnami/[镜像名称]:[标签] [私有仓库地址]/[镜像名称]:[标签]
   # 推送至私有仓库
   docker push [私有仓库地址]/[镜像名称]:[标签]
   ```

### 生产环境替代方案

对于生产工作负载及长期支持需求，强烈建议迁移至[Bitnami Secure Images](https://bitnami.com/)，其具备以下优势：
- 经过安全加固的容器环境
- 更小的攻击面
- CVE透明度（通过VEX/KEV）
- 软件物料清单（SBOMs）
- 企业级技术支持

## 注意事项

- 本镜像不提供任何更新或安全补丁，存在潜在安全风险
- 请勿在生产环境中使用这些旧版镜像
- 该Legacy仓库未来可能被永久移除，建议尽快完成迁移或备份操作
