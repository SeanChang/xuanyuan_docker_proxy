---
image: docker/ecs-searchdomain-sidecar
description: "Docker Compose \"Cloud Integrations\"是Docker Compose的云集成工具，可使用现有Docker命令在AWS ECS、Azure ACI等云服务上运行Docker容器和Compose应用。ECS和ACI集成已于2023年11月退役，当前仓库主要处理关键安全修复，ECS用户可考虑使用compose-ecs。"
source: https://xuanyuan.cloud/zh/r/docker/ecs-searchdomain-sidecar
canonical: https://xuanyuan.cloud/zh/r/docker/ecs-searchdomain-sidecar
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/docker/ecs-searchdomain-sidecar" title="docker/ecs-searchdomain-sidecar Docker 镜像中文简介、标签列表与拉取命令">docker/ecs-searchdomain-sidecar 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 【警告】退役日期通知

Docker Compose对ECS和ACI的集成已于2023年11月退役。目前，本仓库的主要优先级是关键安全修复。

ECS用户可考虑使用[compose-ecs](https://github.com/docker/compose-ecs)。


# Docker Compose "Cloud Integrations"

[![Actions Status](https://github.com/docker/compose-cli/workflows/Continuous%20integration/badge.svg)](https://github.com/docker/compose-cli/actions)
[![Actions Status](https://github.com/docker/compose-cli/workflows/Windows%20CI/badge.svg)](https://github.com/docker/compose-cli/actions)


## 概述

此Compose CLI工具可帮助用户使用已熟悉的Docker命令，在云服务上轻松运行Docker容器和Docker Compose应用，支持以下云服务：
- Amazon弹性容器服务([ECS](https://aws.amazon.com/ecs))
- Microsoft Azure容器实例([ACI](https://azure.microsoft.com/services/container-instances))
- Kubernetes（开发中）


## 【警告】Compose v2（又称"本地Docker Compose"）已迁移

本仓库专注于"云集成"功能，Docker Compose v2代码已迁移至[github.com/docker/compose](https://github.com/docker/compose/tree/v2)。


## 核心功能与特性

- **云服务支持**：兼容AWS ECS、Azure ACI及开发中的Kubernetes
- **命令兼容性**：使用现有Docker命令，无需学习新语法
- **无缝集成**：直接通过Docker CLI工具链管理云部署


## 开始使用

### 系统要求
- **macOS、Windows或Windows WSL2**：需安装[Docker Desktop](https://www.docker.com/products/docker-desktop)的当前版本
- **Linux**：使用[安装脚本](INSTALL.md)

### 前提条件
- 需拥有[AWS](https://aws.amazon.com)或[Azure](https://azure.microsoft.com)账户以使用云集成功能

如有反馈，可创建[issues](https://github.com/docker/compose-cli/issues)。


## 使用示例

- **ECS**：[在云上部署Wordpress](https://www.docker.com/blog/deploying-wordpress-to-the-cloud/)
- **ACI**：[在云上部署Minecraft服务器](https://www.docker.com/blog/deploying-a-minecraft-docker-server-to-the-cloud/)
- **ACI**：[使用Docker、Azure和Github Actions设置云部署](https://www.docker.com/blog/setting-up-cloud-deployments-using-docker-azure-and-github-actions/)


## 开发指南

### 构建与测试
有关构建CLI、运行测试（包括本地容器、ACI和ECS的端到端测试）的说明，参见[BUILDING.md](BUILDING.md)，该文档还包含CLI发布流程。

### 贡献规范
贡献前请阅读[贡献指南](CONTRIBUTING.md)，其中包含项目使用的开发约定。
