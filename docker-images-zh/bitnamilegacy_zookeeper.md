<!-- xuanyuan-docker-images-zh
image: bitnamilegacy/zookeeper
source: https://xuanyuan.cloud/zh/r/bitnamilegacy/zookeeper
canonical: https://xuanyuan.cloud/zh/r/bitnamilegacy/zookeeper
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [bitnamilegacy/zookeeper — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/bitnamilegacy/zookeeper "bitnamilegacy/zookeeper Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/bitnamilegacy/zookeeper

# Bitnami旧版镜像文档

## 镜像概述和主要用途
本仓库为Bitnami旧版镜像仓库，包含所有现有容器镜像的备份，不再提供更新或支持，仅用于临时迁移场景。

## 核心特性
- **不再更新或支持**：仓库中的镜像已停止维护，不会接收任何更新、安全补丁或技术支持
- **临时迁移专用**：仅限用于依赖旧版镜像的临时迁移工作，不适合生产环境使用
- **未来可能移除**：此仓库未来可能会被移除，需提前做好镜像备份以确保持续可用

## 使用场景和适用范围
### 适用场景
仅用于依赖旧版Bitnami镜像的临时迁移工作，帮助用户在过渡到新版镜像前临时维持服务运行。

### 不适用场景
- 生产环境或关键业务系统
- 需要长期运行或获得技术支持的应用
- 对安全性有严格要求的场景

## 使用方法和配置说明
### 拉取镜像
如需使用旧版镜像，可通过以下命令拉取（请替换`[镜像名]`和`[标签]`为实际值）：
```bash
docker pull bitnami/[镜像名]:[标签]
```

### 镜像备份建议
由于仓库未来可能被移除，建议将所需镜像拉取后存储到私有容器 registry，确保持续可用：
```bash
# 1. 拉取旧版镜像
docker pull bitnami/[镜像名]:[标签]

# 2. 标记为私有registry地址（替换[私有registry地址]为实际地址）
docker tag bitnami/[镜像名]:[标签] [私有registry地址]/[镜像名]:[标签]

# 3. 推送到私有registry
docker push [私有registry地址]/[镜像名]:[标签]
```

### 注意事项
- **无技术支持**：使用过程中遇到的问题将无法获得官方技术支持
- **安全风险**：镜像已停止更新，可能存在未修复的安全漏洞，使用前需评估风险
- **时效性限制**：仓库未来可能被移除，需尽快完成迁移或备份

## 生产环境建议
对于生产工作负载和长期支持需求，推荐采用[Bitnami Secure Images](https://bitnami.com/)，其核心优势包括：
- 强化容器：经过安全加固的容器配置
- 更小攻击面：优化镜像体积，减少潜在攻击向量
- CVE透明度：通过VEX/KEV提供CVE漏洞透明度报告
- SBOM支持：包含软件物料清单，便于供应链安全管理
- 企业级支持：提供专业的技术支持服务
