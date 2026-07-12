---
image: atlassian/jira-software
description: "Jira Software是供敏捷团队使用的软件开发工具。"
source: https://xuanyuan.cloud/zh/r/atlassian/jira-software
canonical: https://xuanyuan.cloud/zh/r/atlassian/jira-software
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/atlassian/jira-software" title="atlassian/jira-software Docker 镜像中文简介、标签列表与拉取命令">atlassian/jira-software 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Jira Docker 镜像文档


## 镜像概述和主要用途

本Docker镜像用于简化Atlassian Jira系列产品（Jira Software、Jira Service Management和Jira Core）的部署和运行。Jira系列产品是企业级项目管理和协作工具，分别针对不同场景设计：

- **Jira Software Data Center**：面向敏捷开发团队的软件项目管理工具，支持大规模团队进行规划、跟踪和发布软件。
- **Jira Service Management Data Center**：企业级IT服务管理（ITSM）解决方案，提供高可用性，满足安全合规需求，确保服务请求无遗漏。
- **Jira Core**：为业务团队设计的项目和任务管理工具，专注于通用项目协作。

Docker镜像支持快速部署单实例或Data Center模式，推荐使用Docker版本≥20.10.10。


## 核心功能和特性

### Jira Software
- 敏捷开发支持：Scrum、Kanban等敏捷框架工具
- 项目规划与跟踪：史诗、故事、任务管理，燃尽图、甘特图等可视化工具
- 版本发布管理：迭代规划、发布跟踪、变更管理
- Data Center模式：支持高可用性和横向扩展，满足大规模团队需求

### Jira Service Management
- ITSM合规性：符合ITIL、SLM等行业标准
- 服务请求管理：工单系统、SLA监控、自动化响应流程
- 高可用性架构：Data Center模式确保服务不中断
- 安全与合规：细粒度权限控制、审计日志、数据加密

### Jira Core
- 通用项目管理：任务分配、进度跟踪、截止日期管理
- 自定义工作流：支持业务流程可视化配置
- 团队协作：评论、附件、通知集成
- 报表与仪表板：项目状态实时监控


## 使用场景和适用范围

### Jira Software
- 敏捷开发团队（Scrum/Kanban）的软件项目管理
- 大规模研发团队的多项目协同与版本发布管理
- 需要追踪需求、缺陷和迭代进度的开发流程

### Jira Service Management
- 企业IT部门的服务台（帮助台）运营
-.IT服务请求处理、事件管理、问题管理
- 需要满足高可用性和合规要求的关键业务系统支持

### Jira Core
- 非技术团队（如HR、财务、运营）的日常任务与项目管理
- 跨部门协作项目（如活动策划、流程优化）
- 需要自定义工作流的业务流程管理


## 使用方法和配置说明

### 前提条件
- Docker版本≥20.10.10
- 建议分配至少2GiB内存（详见[系统需求](https://confluence.atlassian.com/adminjiraserver071/jira-applications-installation-requirements-802592164.html)）
- 数据持久化：通过Docker数据卷或命名卷挂载`JIRA_HOME`目录（存储应用数据）；Data Center模式需额外挂载共享文件系统（通过`JIRA_SHARED_HOME`配置）


### 快速启动

#### 1. 创建数据卷
推荐使用命名卷存储应用数据：
```bash
docker volume create --name jiraVolume
```

#### 2. 启动容器
以Jira Software为例，映射数据卷并暴露端口：
```bash
docker run -v jiraVolume:/var/atlassian/application-data/jira \
  --name="jira" \
  -d \
  -p 8080:8080 \
  docker.xuanyuan.run/atlassian/jira-software
```

#### 3. 访问应用
容器启动后，通过`http://localhost:8080`访问Jira（若使用`docker-machine`，需替换为`http://$(docker-machine ip default):8080`）。


### 高级用法
如需配置、故障排除、可支持性等高级操作，请参考[完整文档](https://atlassian.github.io/data-center-helm-charts/containers/JIRA/)。


## Docker部署方案示例

### docker run 命令示例（Jira Service Management）
```bash
# 创建共享数据卷（Data Center模式需共享文件系统）
docker volume create --name jiraServiceManagementVolume
docker run -v jiraServiceManagementVolume:/var/atlassian/application-data/jira \
  -e JIRA_SHARED_HOME=/var/atlassian/shared \  # 配置共享目录（Data Center模式）
  --name="jira-servicemanagement" \
  -d \
  -p 8081:8080 \
  atlassian/jira-servicemanagement
```


### docker-compose 配置示例（Jira Core）
```yaml
version: '3'
services:
  jira-core:
    image: docker.xuanyuan.run/atlassian/jira-core
    container_name: jira-core
    ports:
      - "8082:8080"
    volumes:
      - jiraCoreVolume:/var/atlassian/application-data/jira
    environment:
      - JVM_MINIMUM_MEMORY=1g  # 最小内存
      - JVM_MAXIMUM_MEMORY=2g  # 最大内存
    restart: unless-stopped

volumes:
  jiraCoreVolume:
    driver: local
```


## 配置参数与环境变量

### 核心目录
- **`JIRA_HOME`**：应用数据存储目录，默认`/var/atlassian/application-data/jira`，需通过数据卷挂载以持久化数据。
- **`JIRA_SHARED_HOME`**：Data Center模式下的共享文件系统目录，用于多节点间共享数据（如附件、索引），需手动配置并挂载共享存储。


### 资源配置
- **JVM内存**：通过环境变量`JVM_MINIMUM_MEMORY`（默认`1g`）和`JVM_MAXIMUM_MEMORY`（默认`2g`）调整，建议根据团队规模增加（如大规模团队设置为`4g`/`8g`）。


### 镜像信息
- Jira Software：[Docker Hub](http://hub.docker.com/r/atlassian/jira-software/)
- Jira Service Management：[Docker Hub](http://hub.docker.com/r/atlassian/jira-servicemanagement/)
- Jira Core：[Docker Hub](http://hub.docker.com/r/atlassian/jira-core/)
