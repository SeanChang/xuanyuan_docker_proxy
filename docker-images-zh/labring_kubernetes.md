---
image: labring/kubernetes
description: "Sealos 是基于 Kubernetes 内核的云操作系统发行版，旨在让用户像使用个人电脑一样便捷地使用云服务，支持高效管理云原生应用，将云成本降低至原来的 1/10。"
source: https://xuanyuan.cloud/zh/r/labring/kubernetes
canonical: https://xuanyuan.cloud/zh/r/labring/kubernetes
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/labring/kubernetes" title="labring/kubernetes Docker 镜像中文简介、标签列表与拉取命令">labring/kubernetes 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## Sealos 云操作系统

### 概述

Sealos（发音：['siːləs]）是一款基于 Kubernetes 内核的云操作系统发行版，致力于让用户"像使用个人电脑一样使用云"，大幅降低云服务使用成本（可达原来的 1/10）。它整合了 Kubernetes 生态的核心能力，提供简单易用的界面和工具，支持快速部署、管理分布式应用及数据库等服务，适用于公有云、私有云等多种环境。

### 核心功能与特性

#### 核心功能
- **应用管理**：通过模板市场轻松管理和快速发布可公开访问的分布式应用，支持一键部署各类应用。
- **数据库管理**：秒级创建高可用数据库，支持 MySQL、PostgreSQL、MongoDB、Redis 等主流数据库类型。
- **云环境通用性**：在公有云和私有云环境中均能高效运行，支持传统应用无缝迁移至云端。

#### 核心优势
- **高效经济**：仅为所使用的容器付费，自动扩缩容避免资源浪费，显著降低云服务成本。
- **高通用性与易用性**：用户可专注于核心业务，无需关注底层系统复杂性，学习成本极低。
- **敏捷与安全**：独特的多租户共享模型，在安全框架下实现资源有效隔离与协作。

### 使用场景

Sealos 适用于多种云原生应用场景，包括但不限于：
- **快速部署基础服务**：30秒内部署 Nginx、MySQL、PostgreSQL、MongoDB 等服务。
- **搭建业务应用**：如 WordPress 博客平台、Uptime Kuma 拨测系统等。
- **低代码平台运行**：支持各类低代码平台的部署与管理。
- **Kubernetes 集群管理**：提供 Kubernetes 集群的生命周期管理，支持一键部署高可用集群。

### 安装与部署

#### 自托管 Sealos 云平台
参考官方自托管文档：[Self hosting](https://sealos.io/self-hosting)

#### 一键部署 Kubernetes 集群
通过 Sealos 可快速部署 Kubernetes 高可用集群，单节点部署命令示例：
```bash
# 安装单节点 Kubernetes 集群
sealos run labring/kubernetes:v1.28.0
```

#### 部署应用示例
1. **部署 Nginx**：通过 Sealos 应用启动台，30秒内完成部署，详见 [Easily Deploy Nginx in 30 Seconds](https://sealos.io/docs/quick-start/use-app-launchpad)。
2. **部署数据库**：支持一键创建高可用 MySQL/PostgreSQL/MongoDB，详见 [Start a highly available database](https://sealos.io/docs/quick-start/use-database)。
3. **部署 WordPress**：完整部署流程参考 [Running WordPress on Sealos](https://sealos.io/docs/examples/blog-platform/install-wordpress)。

### 社区与支持

- **官方网站**：访问 [Sealos 官网](https://sealos.io/) 获取完整文档和资源链接。
- **Discord 社区**：加入 [Discord 服务器](https://discord.gg/qzBmGGZGk7) 与开发者和用户交流，提问或分享经验。
- **GitHub 仓库**：通过 [GitHub Issues](https://github.com/labring/sealos/issues/new/choose) 提交 bug 报告或功能请求。
- **路线图**：查看 [公开路线图](https://github.com/orgs/labring/projects/4/views/9) 了解项目优先级和发展方向。

### 截图展示

Sealos 提供直观的用户界面，主要功能模块截图如下：

| 模板市场 | 应用启动台 |
| :---: | :---: |
| ![模板市场](https://raw.githubusercontent.com/labring/sealos/main/docs/4.0/img/templates.jpg) | ![应用启动台](https://raw.githubusercontent.com/labring/sealos/main/docs/4.0/img/app-launchpad-1.jpg) |
| 数据库管理 | Serverless 应用 |
| ![数据库管理](https://raw.githubusercontent.com/labring/sealos/main/docs/4.0/img/database.jpg) | ![Serverless](https://raw.githubusercontent.com/labring/sealos/main/docs/4.0/img/laf.jpg) |
