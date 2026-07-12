---
image: labring/kubernetes-docker
description: "Sealos是基于Kubernetes内核的云操作系统发行版，旨在让云使用体验如个人电脑般简单，将云成本降低至原来的1/10，支持云原生应用的便捷管理与快速部署。"
source: https://xuanyuan.cloud/zh/r/labring/kubernetes-docker
canonical: https://xuanyuan.cloud/zh/r/labring/kubernetes-docker
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/labring/kubernetes-docker" title="labring/kubernetes-docker Docker 镜像中文简介、标签列表与拉取命令">labring/kubernetes-docker 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Sealos 云操作系统

## 概述

Sealos（发音：['siːləs]）是基于Kubernetes内核的云操作系统发行版。其核心目标是让使用云服务像使用个人电脑一样简单，并将云基础设施成本降低至传统方案的1/10。Sealos提供了完整的云原生应用管理能力，支持在公有云与私有云环境中无缝部署和运行分布式应用、数据库及各类服务。

![Sealos架构](https://github.com/labring/sealos/assets/8912557/9e8c1d76-718e-4910-a9ab-94f220a61a9c)


## 核心功能与特性

### 核心功能
- **应用管理**：通过模板市场实现分布式应用的便捷管理与快速发布，支持公开可访问的应用部署。
- **数据库管理**：秒级创建高可用数据库，支持MySQL、PostgreSQL、MongoDB、Redis等主流数据库类型。
- **云通用性**：在公有云与私有云环境中均能高效运行，支持传统应用向云环境无缝迁移。

### 主要优势
- **高效经济**：按实际使用的容器资源付费，自动扩缩容避免资源浪费，显著降低云成本。
- **易用通用**：用户可专注于核心业务，无需关注底层系统复杂性，学习成本极低。
- **敏捷安全**：独特的多租户共享模型，在安全框架下实现资源隔离与协作的平衡。


## 使用场景

Sealos适用于各类云原生应用部署与管理场景，典型包括：
- 快速部署Web服务（如Nginx），30秒内完成配置与启动
- 创建高可用数据库集群（MySQL/PostgreSQL/MongoDB），无需复杂的集群配置
- 运行博客平台（如WordPress）、监控系统（如Uptime Kuma）、低代码平台等各类应用
- 企业级私有云或公有云环境中的Kubernetes集群生命周期管理


## 使用方法

### 快速开始

通过Sealos云平台快速部署应用：
1. 访问 [Sealos云平台](https://cloud.sealos.io)
2. 在应用启动台选择所需应用模板（如Nginx、MySQL）
3. 填写基本配置并提交，30秒内完成部署

### 安装Sealos

#### 1. 自托管Sealos云平台
参考 [自托管文档](https://sealos.io/self-hosting) 部署完整的Sealos云环境。

#### 2. 部署Kubernetes集群
通过Sealos命令行工具一键部署Kubernetes高可用集群：
```bash
# 安装单节点Kubernetes
sealos run labring/kubernetes:v1.25.0 --single

# 安装多节点Kubernetes HA集群
sealos run labring/kubernetes:v1.25.0 \
  --masters 192.168.0.2,192.168.0.3,192.168.0.4 \
  --nodes 192.168.0.5,192.168.0.6 \
  --passwd your-server-password
```

### 应用部署示例

#### 部署WordPress
1. 在Sealos应用启动台搜索"WordPress"模板
2. 配置数据库参数（可选择内置MySQL或连接外部数据库）
3. 点击"部署"，系统自动完成容器编排与服务暴露
4. 通过生成的域名访问WordPress站点

#### 部署高可用MySQL
```bash
# 通过Sealos命令行部署MySQL集群
sealos run labring/mysql:8.0.32 \
  --env MYSQL_ROOT_PASSWORD=your-password \
  --replicas 3
```


## 社区与支持

- **官方网站**：[https://sealos.io](https://sealos.io)（完整文档与资源）
- **Discord社区**：[加入Discord](https://discord.gg/qzBmGGZGk7)，与开发者和用户交流
- **GitHub仓库**：[labring/sealos](https://github.com/labring/sealos)（提交issue与PR）
- **文档中心**：[Sealos文档](https://sealos.io/docs)（快速入门、示例教程）


## 路线图

Sealos维护 [公开路线图](https://github.com/orgs/labring/projects/4/views/9)，展示项目主要优先级、功能成熟度及发展方向，用户可通过该路线图了解未来规划并参与方向讨论。


## 截图展示

| 模板市场 | 应用启动台 |
| :---: | :---: |
| ![模板市场](https://raw.githubusercontent.com/labring/sealos/main/docs/4.0/img/templates.jpg) | ![应用启动台](https://raw.githubusercontent.com/labring/sealos/main/docs/4.0/img/app-launchpad-1.jpg) |
| 数据库管理 | 无服务器架构 |
| ![数据库管理](https://raw.githubusercontent.com/labring/sealos/main/docs/4.0/img/database.jpg) | ![无服务器架构](https://raw.githubusercontent.com/labring/sealos/main/docs/4.0/img/laf.jpg) |
