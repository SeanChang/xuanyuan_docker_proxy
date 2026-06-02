---
image: bitnamilegacy/mysql
description: "Bitnami旧版镜像（不再更新）"
source: https://xuanyuan.cloud/zh/r/bitnamilegacy/mysql
canonical: https://xuanyuan.cloud/zh/r/bitnamilegacy/mysql
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamilegacy/mysql" title="bitnamilegacy/mysql Docker 镜像中文简介、标签列表与拉取命令">bitnamilegacy/mysql — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnamilegacy/mysql" title="bitnamilegacy/mysql Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnamilegacy/mysql</a>

# Bitnami旧版镜像文档

## 概述
本镜像为Bitnami Legacy仓库中的旧版容器镜像，该仓库已停止更新且不再提供支持。镜像包含历史容器镜像的备份，仅适用于临时迁移场景，不可用于生产环境。

## 核心特性
- **不再维护**：镜像无后续更新、安全补丁或技术支持
- **历史备份**：包含Bitnami过往发布的容器镜像备份
- **临时可用**：当前可访问，但未来仓库可能被移除

## 使用场景
仅推荐用于依赖旧版Bitnami镜像系统的**临时迁移**，例如：
- 从旧版Bitnami镜像迁移至新版本的过渡期
- 临时恢复依赖特定旧版镜像的系统环境
- 历史项目的短期维护与数据迁移

## 注意事项
1. **存储建议**：若需继续使用，需将镜像拉取并存储至私有容器 registry（如Docker Hub私有仓库、Harbor等），避免原仓库移除后无法访问
2. **安全风险**：旧版镜像可能存在未修复的安全漏洞，不应用于处理敏感数据或生产环境
3. **生命周期**：Bitnami官方未承诺该Legacy仓库的保留期限，长期依赖存在仓库移除风险

## 推荐方案
对于生产工作负载及长期支持需求，建议迁移至[Bitnami Secure Images](https://bitnami.com/)，其核心优势包括：
- 强化容器安全（减少攻击面）
- 完整的CVE透明度（通过VEX/KEV报告）
- 软件物料清单（SBOMs）支持
- 企业级技术支持服务
- 持续更新与安全补丁
