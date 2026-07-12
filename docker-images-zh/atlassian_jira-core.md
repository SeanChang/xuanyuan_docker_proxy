---
image: atlassian/jira-core
description: "Jira Core是专为业务团队打造的项目与任务管理解决方案。"
source: https://xuanyuan.cloud/zh/r/atlassian/jira-core
canonical: https://xuanyuan.cloud/zh/r/atlassian/jira-core
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/atlassian/jira-core" title="atlassian/jira-core Docker 镜像中文简介、标签列表与拉取命令">atlassian/jira-core 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Jira 系列 Docker 镜像技术文档

![Atlassian Jira Software](https://wac-cdn.atlassian.com/dam/jcr:826c97dc-1f5c-4955-bfcc-ea17d6b0c095/jira%20software-icon-gradient-blue.svg?cdnVersion=492)![Atlassian Jira Service Management](https://wac-cdn.atlassian.com/dam/jcr:8e0905be-0ee7-4652-ba3a-4e3db1143969/jira%20service%20desk-icon-gradient-blue.svg?cdnVersion=492)![Atlassian Jira Core](https://wac-cdn.atlassian.com/dam/jcr:f89f1ce5-60f1-47c2-b9f5-657de4940d31/jira%20core-icon-gradient-blue.svg?cdnVersion=492)

## 镜像概述和主要用途

### Jira Software Data Center
Jira Software Data Center 帮助全球顶尖敏捷团队大规模规划、跟踪和发布优秀软件。  
- Docker Hub: [atlassian/jira-software](http://hub.docker.com/r/atlassian/jira-software/)  
- 官方网站: [https://www.atlassian.com/software/jira](https://www.atlassian.com/software/jira)

### Jira Service Management Data Center
Jira Service Management Data Center 是企业级 ITSM 解决方案，提供高可用性，满足安全合规需求，确保所有请求得到妥善处理。  
- Docker Hub: [atlassian/jira-servicemanagement](http://hub.docker.com/r/atlassian/jira-servicemanagement/)  
- 官方网站: [https://www.atlassian.com/software/jira/service-management](https://www.atlassian.com/software/jira/service-management)

### Jira Core
Jira Core 是为业务团队打造的项目和任务管理解决方案。  
- Docker Hub: [atlassian/jira-core](http://hub.docker.com/r/atlassian/jira-core/)  
- 官方网站: [https://www.atlassian.com/software/jira/core](https://www.atlassian.com/software/jira/core)

**镜像用途**：此 Docker 容器简化了 Jira Software、Service Management 或 Core 实例的部署和运行过程。  
**注意**：以下示例以 Jira Software 为例进行说明。


## 核心功能和特性

### Jira Software Data Center
- **敏捷规划**：支持 Scrum、Kanban 等敏捷方法论，提供用户故事、任务、史诗等工作项管理
- **跟踪与报告**：实时跟踪项目进度，生成自定义报表和可视化仪表盘
- **发布管理**：规划软件发布周期，与 CI/CD 工具集成实现自动化部署
- **大规模协作**：支持大型团队和多项目并行管理，提供高可用性和横向扩展能力

### Jira Service Management Data Center
- **企业级 ITSM**：符合 ITIL 标准的服务管理流程，覆盖事件、问题、变更管理
- **高可用性**：数据中心模式确保服务持续可用，最小化业务中断
- **安全与合规**：内置审计日志、细粒度权限控制和合规报告功能
- **多渠道支持**：整合邮件、聊天、服务门户等渠道，集中处理用户请求

### Jira Core
- **项目与任务管理**：灵活的工作流配置，支持任务分配、进度跟踪和截止日期管理
- **业务团队协作**：为非技术团队（市场、HR、财务等）设计的直观操作界面
- **自定义配置**：可定制表单、字段和报表，适配不同业务流程需求
- **生态集成**：与 Confluence、Slack 等工具无缝集成，扩展协作能力


## 使用场景和适用范围

### Jira Software Data Center
- **适用团队**：大型软件开发团队、跨部门敏捷团队、企业级研发组织
- **典型场景**：复杂软件项目的敏捷规划、多版本并行开发管理、分布式团队协作

### Jira Service Management Data Center
- **适用团队**：IT 服务台、客户支持团队、企业运维部门
- **典型场景**：内部 IT 服务请求处理、客户支持工单管理、IT 基础设施变更控制

### Jira Core
- **适用团队**：业务运营团队（市场、人力资源、财务、行政）
- **典型场景**：日常工作任务跟踪、项目进度管理、业务流程自动化


## 详细使用方法和配置说明

### 系统要求
- **Docker 版本**：推荐使用 Docker 20.10.10 及以上版本
- **资源配置**：建议为容器分配至少 2GiB 内存（详见 [Jira 系统要求](https://confluence.atlassian.com/adminjiraserver071/jira-applications-installation-requirements-802592164.html)）


### 数据卷配置
- **JIRA_HOME**：用于存储应用数据（配置、插件、数据库等），需通过数据卷挂载以实现持久化，默认路径为 `/var/atlassian/application-data/jira`
- **JIRA_SHARED_HOME**：Data Center 模式下的共享文件系统挂载点，需配置为所有节点可访问的共享目录，通过环境变量指定


### 快速启动步骤
以下示例使用命名卷部署 Jira Software，其他产品可替换镜像名称（如 `atlassian/jira-servicemanagement` 或 `atlassian/jira-core`）。

1. 创建命名卷（用于持久化 JIRA_HOME 数据）：
   ```bash
   docker volume create --name jiraVolume
   ```

2. 启动 Jira 容器：
   ```bash
   docker run -v jiraVolume:/var/atlassian/application-data/jira --name="jira" -d -p 8080:8080 docker.xuanyuan.run/atlassian/jira-software
   ```

3. 访问应用：
   - 本地环境：[http://localhost:8080](http://localhost:8080)
   - Mac OS X (docker-machine)：使用 `open http://$(docker-machine ip default):8080` 访问


### 关键配置参数说明
| 参数                | 描述                                                                 | 默认值                                  |
|---------------------|----------------------------------------------------------------------|-----------------------------------------|
| `JIRA_HOME`         | 应用数据存储目录                                                     | `/var/atlassian/application-data/jira`  |
| `JIRA_SHARED_HOME`  | Data Center 模式下的共享文件系统路径（需所有节点可访问）             | 未设置（Data Center 模式必填）          |
| `-p 8080:8080`      | 端口映射，将容器内 8080 端口映射到主机 8080 端口                     | -                                        |
| `-v jiraVolume:...` | 数据卷挂载，将命名卷或主机目录挂载到 `JIRA_HOME`                     | -                                        |


### Docker Compose 部署示例
创建 `docker-compose.yml` 文件：
```yaml
version: '3'
services:
  jira:
    image: docker.xuanyuan.run/atlassian/jira-software
    container_name: jira
    ports:
      - "8080:8080"  # 端口映射
    volumes:
      - jiraVolume:/var/atlassian/application-data/jira  # 挂载 JIRA_HOME
    environment:
      - TZ=Asia/Shanghai  # 设置时区
    restart: unless-stopped  # 自动重启策略
    mem_limit: 2g  # 限制最大内存使用

volumes:
  jiraVolume:
    driver: local  # 使用本地驱动的命名卷
```

启动命令：
```bash
docker-compose up -d
```


## 高级用法
有关高级配置（数据库集成、SSL 加密、集群部署等）、故障排除和可支持性详情，请参阅 [完整文档](https://atlassian.github.io/data-center-helm-charts/containers/JIRA/)。
