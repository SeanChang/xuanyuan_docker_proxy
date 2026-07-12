---
image: bitnamilegacy/rabbitmq
description: "Bitnami旧版镜像（不再更新）"
source: https://xuanyuan.cloud/zh/r/bitnamilegacy/rabbitmq
canonical: https://xuanyuan.cloud/zh/r/bitnamilegacy/rabbitmq
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamilegacy/rabbitmq" title="bitnamilegacy/rabbitmq Docker 镜像中文简介、标签列表与拉取命令">bitnamilegacy/rabbitmq 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami旧版镜像文档

## 镜像概述和主要用途
本仓库为Bitnami旧版（Legacy）镜像仓库，包含所有现有容器镜像的备份。该仓库已不再提供更新或支持，仅应用于临时迁移场景。所有镜像均为历史版本备份，不包含任何新增功能或安全更新。

## 核心特性
- **不再更新**：镜像将不会接收任何后续更新（包括功能迭代和安全补丁）
- **仅作备份**：仓库仅存储历史容器镜像的备份副本
- **无官方支持**：Bitnami官方不再提供技术支持或维护服务

## 使用场景和适用范围
- **适用场景**：仅用于临时迁移需求，帮助用户从旧版Bitnami镜像过渡至其他解决方案
- **不适用场景**：禁止用于生产环境或长期运行的工作负载；不适合对安全性、稳定性有要求的业务场景

## 使用方法和配置说明
### 拉取镜像
如需使用旧版镜像，可通过以下命令从Legacy仓库拉取：
```bash
docker pull docker.xuanyuan.run/bitnami/[镜像名称]:[标签]
```
> 示例：拉取旧版nginx镜像  
> `docker pull docker.xuanyuan.run/bitnami/nginx:1.21.6`

### 存储至私有仓库
由于该仓库未来可能被移除，建议将所需镜像拉取后存储至自有容器 registry：
```bash
# 1. 拉取镜像
docker pull docker.xuanyuan.run/bitnami/[镜像名称]:[标签]

# 2. 标记为私有仓库地址
docker tag bitnami/[镜像名称]:[标签] [私有仓库地址]/[镜像名称]:[标签]

# 3. 推送至私有仓库
docker push [私有仓库地址]/[镜像名称]:[标签]
```

## 注意事项
- **仓库生命周期**：Bitnami Legacy仓库未来可能被永久移除，建议尽快完成必要镜像的迁移存储
- **生产环境建议**：对于生产工作负载和长期支持需求，强烈建议采用[Bitnami Secure Images](https://bitnami.com/)，其包含强化容器、更小攻击面、CVE透明度（通过VEX/KEV）、SBOM以及企业级支持
