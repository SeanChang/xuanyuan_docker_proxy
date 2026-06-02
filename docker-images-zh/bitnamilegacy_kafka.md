---
image: bitnamilegacy/kafka
description: "Bitnami旧版镜像（不再更新），包含所有现有容器镜像的备份，仅用于临时迁移目的"
source: https://xuanyuan.cloud/zh/r/bitnamilegacy/kafka
canonical: https://xuanyuan.cloud/zh/r/bitnamilegacy/kafka
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamilegacy/kafka" title="bitnamilegacy/kafka Docker 镜像中文简介、标签列表与拉取命令">bitnamilegacy/kafka 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述

本仓库为Bitnami Legacy（旧版）仓库，包含所有现有容器镜像的备份。该仓库中的镜像已停止更新和技术支持，仅可用于临时迁移场景。请注意，该仓库未来可能被移除，依赖其中镜像的用户需及时采取迁移措施。

## 核心功能与特性

- **镜像备份**：包含Bitnami所有历史容器镜像的完整备份，可作为临时迁移的过渡资源
- **状态说明**：所有镜像均已终止更新维护，不提供安全补丁、功能优化或技术支持服务
- **迁移支持**：仅用于协助用户完成从旧版镜像到替代方案的临时过渡

## 使用场景与适用范围

### 适用场景
- 依赖Bitnami旧版镜像的系统/应用临时迁移过程
- 需要获取历史版本镜像进行兼容性验证或数据迁移的场景

### 不适用场景
- 生产环境工作负载（存在安全风险且无支持）
- 长期运行的应用或服务（仓库未来可能被移除导致镜像不可用）

## 使用方法

### 镜像拉取
如需使用仓库中的镜像，可通过以下命令拉取：
```bash
docker pull bitnami/[legacy-image-name]:[tag]
```
> 说明：`[legacy-image-name]` 需替换为具体镜像名称，`[tag]` 需替换为对应版本标签。

### 镜像迁移建议
为避免仓库移除导致镜像不可用，建议将依赖的镜像迁移至私有容器 registry：
1. 拉取目标镜像至本地：
   ```bash
   docker pull bitnami/[legacy-image-name]:[tag]
   ```

2. 标记镜像为私有仓库地址：
   ```bash
   docker tag bitnami/[legacy-image-name]:[tag] [your-registry-domain]/[legacy-image-name]:[tag]
   ```

3. 推送至私有仓库永久保存：
   ```bash
   docker push [your-registry-domain]/[legacy-image-name]:[tag]
   ```

## 替代方案推荐

对于生产环境及长期需求，强烈建议迁移至 [Bitnami Secure Images](https://bitnami.com/)，其核心优势包括：
- 经过安全加固的容器环境
- 更小的攻击面设计
- CVE透明度支持（通过VEX/KEV标准）
- 完整的软件物料清单（SBOMs）
- 企业级技术支持服务
