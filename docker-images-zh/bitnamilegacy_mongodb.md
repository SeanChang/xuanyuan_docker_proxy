---
image: bitnamilegacy/mongodb
description: "Bitnami Legacy镜像（已停止更新），包含所有现有容器镜像的备份，仅用于临时迁移目的，无进一步更新或支持。"
source: https://xuanyuan.cloud/zh/r/bitnamilegacy/mongodb
canonical: https://xuanyuan.cloud/zh/r/bitnamilegacy/mongodb
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamilegacy/mongodb" title="bitnamilegacy/mongodb Docker 镜像中文简介、标签列表与拉取命令">bitnamilegacy/mongodb 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Legacy镜像文档

## 镜像概述和主要用途
Bitnami Legacy镜像是Bitnami Legacy仓库中的容器镜像集合，已停止更新和维护。该仓库包含所有现有Bitnami容器镜像的备份，不提供进一步的功能更新、安全补丁或技术支持，仅适用于临时迁移场景。

## 核心功能和特性
- **镜像备份**：包含所有历史Bitnami容器镜像的完整备份
- **停止更新**：已终止开发，无新功能迭代或安全漏洞修复
- **无技术支持**：Bitnami官方不提供任何形式的技术支持
- **临时用途**：仅限用于现有工作负载的临时迁移过渡
- **生命周期限制**：仓库未来可能被移除，长期可用性无法保障

## 使用场景和适用范围
### 适用场景
- 基于旧版Bitnami镜像的工作负载临时迁移至其他环境
- 短期过渡需求，需临时访问历史Bitnami镜像版本

### 不适用场景
- 生产环境工作负载（无安全更新，存在风险）
- 长期运行的应用或服务（缺乏稳定性保障）

## 详细使用方法和配置说明
### 拉取Legacy镜像
如需使用Legacy镜像，可通过`docker pull`命令拉取：
```bash
docker pull docker.xuanyuan.run/bitnami/[镜像名称]:[标签]
```
> 注：需将`[镜像名称]`和`[标签]`替换为实际镜像标识，具体可参考历史镜像清单。

### 镜像持久化存储
为避免未来仓库移除导致镜像不可用，建议将拉取的镜像存储至私有容器 registry：
```bash
# 标记镜像为私有registry地址
docker tag bitnami/[镜像名称]:[标签] [私有registry地址]/[镜像名称]:[标签]

# 推送至私有registry
docker push [私有registry地址]/[镜像名称]:[标签]
```

## 生产环境建议
对于生产工作负载和长期支持需求，强烈建议迁移至[Bitnami Secure Images](https://bitnami.com/)。该系列镜像提供：
- 安全强化的容器环境
- 最小化攻击面设计
- CVE漏洞透明度（通过VEX/KEV披露）
- 完整的软件物料清单（SBOMs）
- 企业级技术支持服务
