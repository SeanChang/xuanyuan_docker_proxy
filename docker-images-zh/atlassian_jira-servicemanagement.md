---
image: atlassian/jira-servicemanagement
description: "Jira Service Management是现代IT团队使用的功能齐全的服务台工具。"
source: https://xuanyuan.cloud/zh/r/atlassian/jira-servicemanagement
canonical: https://xuanyuan.cloud/zh/r/atlassian/jira-servicemanagement
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/atlassian/jira-servicemanagement" title="atlassian/jira-servicemanagement Docker 镜像中文简介、标签列表与拉取命令">atlassian/jira-servicemanagement 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Atlassian Jira 系列 Docker 镜像技术文档


## 镜像概述和主要用途

Atlassian Jira 系列 Docker 镜像提供了便捷的方式部署和运行 Jira 产品，包括 Jira Software Data Center、Jira Service Management Data Center 和 Jira Core。这些镜像旨在简化企业级 Jira 实例的搭建过程，满足不同团队的项目管理、敏捷开发和 IT 服务管理需求。

### 产品镜像说明
| 产品名称                | Docker 镜像地址                          | 主要用途                                                                 | 官方网站                                  |
|-------------------------|-----------------------------------------|--------------------------------------------------------------------------|-------------------------------------------|
| Jira Software Data Center | [atlassian/jira-software](https://hub.docker.com/r/atlassian/jira-software/) | 帮助大型敏捷团队规划、跟踪和发布软件，支持规模化协作与交付。               | [https://www.atlassian.com/software/jira](https://www.atlassian.com/software/jira) |
| Jira Service Management Data Center | [atlassian/jira-servicemanagement](https://hub.docker.com/r/atlassian/jira-servicemanagement/) | 企业级 IT 服务管理（ITSM）解决方案，提供高可用性，满足安全合规需求，确保服务请求零遗漏。 | [https://www.atlassian.com/software/jira/service-management](https://www.atlassian.com/software/jira/service-management) |
| Jira Core               | [atlassian/jira-core](https://hub.docker.com/r/atlassian/jira-core/) | 面向业务团队的项目与任务管理工具，简化日常工作流程与协作。               | [https://www.atlassian.com/software/jira/core](https://www.atlassian.com/software/jira/core) |


## 核心功能和特性

### Jira Software Data Center
- **敏捷开发支持**：提供 Scrum、Kanban 等敏捷框架，支持用户故事、迭代规划、燃尽图等功能。
- **规模化协作**：支持多团队并行开发，提供跨项目依赖管理和资源分配。
- **发布管理**：跟踪版本进度，关联代码提交与需求，实现从规划到发布的全流程可视化。
- **高可用性**：Data Center 模式下支持集群部署，确保服务稳定运行。

### Jira Service Management Data Center
- **ITSM 合规性**：符合 ITIL 标准，支持事件管理、问题管理、变更管理等核心 ITSM 流程。
- **高可用性与扩展性**：集群部署架构，满足企业级并发访问和业务增长需求。
- **安全与审计**：提供细粒度权限控制、操作审计日志，满足企业安全合规要求。
- **多渠道支持**：集成邮件、聊天工具等渠道，统一处理服务请求。

### Jira Core
- **项目管理**：自定义工作流、任务看板、甘特图等工具，适配各类业务流程。
- **团队协作**：支持任务分配、进度跟踪、评论互动，提升团队沟通效率。
- **报告与分析**：内置报表功能，可视化项目进度与团队绩效。


## 使用场景和适用范围

### Jira Software Data Center
- **大型软件开发团队**：需要协同管理多版本、多模块开发的企业级团队。
- **敏捷转型组织**：采用敏捷方法论，需标准化迭代流程、跟踪交付进度的团队。
- **规模化项目管理**：跨部门、跨地域协作，需要统一工具链的复杂项目。

### Jira Service Management Data Center
- **企业 IT 部门**：需要规范化处理员工 IT 请求（如故障报修、权限申请）的团队。
- **服务运营团队**：需保障服务可用性，满足 SLA 要求的运维或客户支持团队。
- **合规性要求高的组织**：金融、医疗等对安全审计、流程合规有严格要求的行业。

### Jira Core
- **业务部门**：市场、HR、财务等非技术团队，用于管理日常任务、活动策划等项目。
- **小型团队协作**：无需复杂开发流程，仅需基础任务跟踪和进度管理的团队。
- **跨部门项目**：需要简单工具协调不同角色（如活动筹备、预算管理）的场景。


## 使用方法和配置说明

### 环境要求
- **Docker 版本**：≥ 20.10.10
- **内存建议**：至少 2GiB 内存分配（详见 [Jira 系统要求](https://confluence.atlassian.com/adminjiraserver071/jira-applications-installation-requirements-802592164.html)）


### 数据持久化配置
Jira 运行时数据（如配置、附件、索引等）存储在 `JIRA_HOME` 目录，推荐通过 Docker 数据卷（Data Volume）或命名卷（Named Volume）挂载主机目录，确保数据持久化。  
- 默认 `JIRA_HOME` 路径（容器内）：`/var/atlassian/application-data/jira`  
- Data Center 模式下需额外挂载共享文件系统，通过 `JIRA_SHARED_HOME` 环境变量配置容器内挂载点。


### 快速启动（以 Jira Software 为例）
以下示例使用命名卷（Named Volume）持久化数据：

#### 1. 创建数据卷
```bash
docker volume create --name jiraVolume
```

#### 2. 启动 Jira 容器
```bash
docker run \
  -v jiraVolume:/var/atlassian/application-data/jira \  # 挂载数据卷到 JIRA_HOME
  --name="jira" \                                      # 容器名称
  -d \                                                 # 后台运行
  -p 8080:8080 \                                       # 端口映射（主机:容器）
  atlassian/jira-software                              # 镜像名称（Jira Software）
```

#### 3. 访问 Jira
容器启动后，通过 `http://localhost:8080` 访问 Jira 实例。  
> **注意**：若使用 Docker Machine（如 macOS），需通过 `http://$(docker-machine ip default):8080` 访问。


### 高级配置
对于 Data Center 模式部署、自定义数据库配置、SSL 加密等高级场景，可参考 [完整文档](https://atlassian.github.io/data-center-helm-charts/containers/JIRA/)。关键配置参数说明：

| 参数名               | 说明                                                                 | 默认值                                      |
|----------------------|----------------------------------------------------------------------|---------------------------------------------|
| `JIRA_HOME`          | Jira 应用数据存储目录（容器内路径）                                 | `/var/atlassian/application-data/jira`      |
| `JIRA_SHARED_HOME`   | Data Center 模式下共享文件系统挂载点（容器内路径）                   | 无（需手动配置）                            |
| `-p <host-port>:8080` | 端口映射，指定主机端口映射到容器内 Jira 服务端口（默认 8080）         | 无（需手动指定，如 `-p 80:8080`）           |
| `-v <volume>:<path>` | 数据卷挂载，用于持久化 `JIRA_HOME` 或 `JIRA_SHARED_HOME` 数据        | 无（推荐配置）                              |


### 注意事项
- **资源分配**：确保容器分配至少 2GiB 内存，避免因资源不足导致服务异常（可通过 `--memory=2g` 限制内存）。
- **数据备份**：定期备份挂载的数据卷，防止数据丢失。
- **镜像更新**：升级镜像前需参考官方升级指南，确保数据兼容性。
- **网络配置**：生产环境建议配置反向代理（如 Nginx），处理 SSL 终结、负载均衡等需求。
