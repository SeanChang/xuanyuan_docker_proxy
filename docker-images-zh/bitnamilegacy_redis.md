---
image: bitnamilegacy/redis
description: "Bitnami Legacy镜像（不再更新），包含所有现有容器镜像的备份，仅用于临时迁移目的，不提供进一步更新或支持。"
source: https://xuanyuan.cloud/zh/r/bitnamilegacy/redis
canonical: https://xuanyuan.cloud/zh/r/bitnamilegacy/redis
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamilegacy/redis" title="bitnamilegacy/redis Docker 镜像中文简介、标签列表与拉取命令">bitnamilegacy/redis 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Legacy镜像文档

## 镜像概述和主要用途
Bitnami Legacy镜像是Bitnami Legacy仓库中所有现有容器镜像的备份集合，该仓库已不再更新，也不提供任何支持。这些镜像仅用于临时迁移场景，供依赖旧版Bitnami镜像的用户进行过渡使用。由于该仓库未来可能被移除，不建议将其用于长期依赖或生产环境。

## 核心功能和特性
- **镜像备份**：包含Bitnami历史版本容器镜像的完整备份。
- **临时迁移支持**：仅用于临时迁移场景，帮助用户从旧版Bitnami镜像过渡到其他解决方案。
- **无更新与支持**：该仓库及其中的镜像已停止维护，不提供任何进一步的更新、安全补丁或技术支持。

## 使用场景和适用范围
### 适用场景
- **临时迁移**：当需要从依赖的旧版Bitnami镜像迁移至其他镜像（如Bitnami Secure Images）时，可临时使用这些备份镜像进行过渡。

### 不适用场景
- **生产环境**：由于缺乏更新和安全支持，严禁用于生产工作负载。
- **长期依赖**：该仓库未来可能被移除，不应作为长期依赖的镜像源。

## 使用方法和配置说明
### 镜像拉取与存储
若需使用这些Legacy镜像，建议立即拉取并存储到您自己的容器仓库，以确保后续可用性：

1. **拉取Legacy镜像**  
   使用`docker pull`命令从Bitnami Legacy仓库拉取所需镜像，示例：
   ```bash
   docker pull docker.xuanyuan.run/bitnami/[镜像名称]:[标签]
   ```
   （请将`[镜像名称]`和`[标签]`替换为实际需要的镜像信息）

2. **存储到私有仓库**  
   将拉取的镜像推送到您的私有容器仓库，示例：
   ```bash
   # 标记镜像为私有仓库地址
   docker tag bitnami/[镜像名称]:[标签] [私有仓库地址]/[镜像名称]:[标签]
   # 推送到私有仓库
   docker push [私有仓库地址]/[镜像名称]:[标签]
   ```

### 生产环境替代方案
对于生产工作负载和长期支持，强烈建议采用[Bitnami Secure Images](https://bitnami.com/)，其特性包括：
- 加固容器（减少安全漏洞）
- 更小的攻击面
- CVE透明度（通过VEX/KEV提供）
- 软件物料清单（SBOMs）
- 企业级技术支持

## 注意事项
- 该Legacy仓库未来可能被移除，依赖其镜像的用户需尽快完成迁移。
- 所有Legacy镜像均未修复已知或潜在安全漏洞，使用时需自行承担风险。
