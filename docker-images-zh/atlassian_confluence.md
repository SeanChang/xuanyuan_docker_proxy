---
image: atlassian/confluence
description: "Atlassian Confluence的Docker镜像，原以`atlassian/confluence`和`atlassian/confluence-server`双名称发布，2024年2月15日后仅前者持续更新，建议切换至`atlassian/confluence`以获取最新更新及标签。"
source: https://xuanyuan.cloud/zh/r/atlassian/confluence
canonical: https://xuanyuan.cloud/zh/r/atlassian/confluence
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/atlassian/confluence" title="atlassian/confluence Docker 镜像中文简介、标签列表与拉取命令">atlassian/confluence — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/atlassian/confluence" title="atlassian/confluence Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/atlassian/confluence</a>

# Atlassian Confluence Server Docker 镜像文档


## 重要说明
**注意**：截至2024年2月15日，此Docker镜像同时以 `atlassian/confluence` 和 `atlassian/confluence-server` 名称发布，两者指向同一镜像。但2024年2月15日之后，`atlassian/confluence-server` 版本停止接收更新（包括现有和新标签）。如果您正在使用 `atlassian/confluence-server`，请切换至 `atlassian/confluence` 镜像以获取最新更新和新标签。


## 镜像概述和主要用途

![Atlassian Confluence Server](https://wac-cdn.atlassian.com/dam/jcr:5d1374c2-276f-4bca-9ce4-813aba614b7a/confluence-icon-gradient-blue.svg?cdnVersion=696)

Confluence Server 是用于创建、组织和讨论团队工作的平台。它能够捕获通常散落在电子邮件和共享网络驱动器中的知识，使其易于查找、使用和更新。通过为每个团队、项目或部门提供专属空间，用户可以创建会议记录、产品需求、文件列表或项目计划等内容，提升协作效率。

Docker镜像旨在简化Confluence Server实例的部署和运行流程，快速搭建可用的Confluence环境。

了解更多关于Confluence Server：<https://www.atlassian.com/software/confluence>  
Dockerfile仓库地址：<https://bitbucket.org/atlassian-docker/docker-atlassian-confluence-server>


## 核心功能和特性

- **团队协作与知识管理**：集中存储和管理团队知识，避免信息分散。
- **空间创建**：为团队、项目或部门提供专属空间，隔离不同场景的内容。
- **多类型内容支持**：支持创建会议记录、产品需求、文件列表、项目计划等多种文档。
- **易访问与更新**：内容易于查找、编辑和维护，支持实时协作。
- **数据持久化**：通过数据卷挂载确保用户数据、配置等信息持久化存储。
- **数据中心模式支持**：支持配置共享文件系统，满足Data Center模式部署需求。


## 使用场景和适用范围

- **团队协作**：适用于需要共同编辑文档、跟踪项目进度的团队。
- **项目管理**：用于存储项目计划、需求文档、会议记录等项目相关内容。
- **知识沉淀**：作为企业或团队的知识库，集中管理技术文档、流程规范等。
- **部门文档管理**：支持不同部门（如研发、产品、运营）创建独立空间，管理专属内容。
- **小型到中型团队部署**：适合快速搭建Confluence环境，满足中小规模团队的协作需求。


## 使用方法和配置说明

### 环境要求

- Docker版本：≥20.10.10


### 数据卷挂载

推荐将主机目录挂载为数据卷，用于存储Confluence数据（如用户数据、配置文件等），对应环境变量 `CONFLUENCE_HOME`。  
若以Data Center模式运行，需挂载共享文件系统，可通过 `CONFLUENCE_SHARED_HOME` 配置容器内的挂载点。


### 快速启动

通过以下命令启动Atlassian Confluence Server：

```bash
docker run -v /data/your-confluence-home:/var/atlassian/application-data/confluence \
  --name="confluence" \
  -d \
  -p 8090:8090 \
  -p 8091:8091 \
  atlassian/confluence
```

#### 参数说明
- `-v /data/your-confluence-home:/var/atlassian/application-data/confluence`：将主机目录 `/data/your-confluence-home` 挂载到容器内的 `CONFLUENCE_HOME` 目录，实现数据持久化。
- `--name="confluence"`：指定容器名称为 `confluence`。
- `-d`：后台运行容器。
- `-p 8090:8090 -p 8091:8091`：映射容器端口到主机，8090为Web访问端口，8091为同步端口。


### 访问验证

成功启动后，Confluence可通过 <http://localhost:8090> 访问。  

**注意**：若在Mac OS X上使用 `docker-machine`，需通过以下命令访问：  
`open http://$(docker-machine ip default):8090`


### 系统资源建议

为确保Confluence正常运行，推荐为容器分配至少2GiB内存。更多信息参见 [支持的平台](https://confluence.atlassian.com/display/DOC/Supported+platforms)。


## 高级用法

如需高级配置（如自定义参数、故障排查、可支持性等），请参考 [完整文档](https://atlassian.github.io/data-center-helm-charts/containers/CONFLUENCE/)。
