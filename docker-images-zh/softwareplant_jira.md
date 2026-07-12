---
image: softwareplant/jira
description: "提供自动化部署和运行Atlassian JIRA的Docker镜像，简化项目管理与问题跟踪工具的部署流程，支持快速启动和配置JIRA实例，减少手动配置步骤。"
source: https://xuanyuan.cloud/zh/r/softwareplant/jira
canonical: https://xuanyuan.cloud/zh/r/softwareplant/jira
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/softwareplant/jira" title="softwareplant/jira Docker 镜像中文简介、标签列表与拉取命令">softwareplant/jira 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Automated Atlassian JIRA Docker镜像文档

## 镜像概述和主要用途
该Docker镜像专注于提供Atlassian JIRA的自动化部署与运行解决方案。Atlassian JIRA是一款广泛应用的项目管理与问题跟踪工具，本镜像通过容器化技术整合JIRA的安装、配置流程，消除手动部署的复杂性，帮助用户快速搭建可用的JIRA环境。适用于需要简化JIRA部署流程、快速获取项目管理工具的各类场景，覆盖开发测试到生产环境。

## 核心功能和特性
- **自动化部署流程**：集成JIRA初始化配置逻辑，容器启动后自动完成软件安装与基础配置，无需手动执行安装步骤。
- **简化参数配置**：支持通过环境变量或配置文件自定义JIRA参数，如数据库连接、端口设置等，降低配置门槛。
- **持久化存储支持**：默认数据目录设计支持挂载外部卷，确保JIRA数据（项目信息、用户数据、配置文件等）在容器重启或重建后不丢失。
- **版本兼容性**：支持通过镜像标签指定JIRA版本（如`9.12.0`），适配不同版本的功能需求，满足版本管理需求。
- **环境隔离**：容器化运行使JIRA与主机系统环境隔离，避免依赖冲突，提升部署稳定性。

## 使用场景和适用范围
- **开发团队内部工具**：快速搭建团队专属JIRA环境，用于任务分配、缺陷跟踪和项目进度管理。
- **测试环境快速部署**：在测试阶段一键启动JIRA实例，验证新功能或配置变更的效果。
- **生产环境稳定运行**：通过合理配置资源和持久化策略，支持生产环境JIRA服务的长期稳定运行。
- **演示与评估场景**：临时启动JIRA实例用于产品功能演示或工具选型评估，用完即销毁，节省资源。

## 使用方法与配置说明

### 基础部署（Docker Run）
通过以下命令快速启动JIRA实例：
```bash
docker run -d \
  --name jira-instance \
  -p 8080:8080 \
  -v jira-data:/var/atlassian/application-data/jira \
  -e JIRA_DB_HOST=postgres-host \
  -e JIRA_DB_NAME=jira_db \
  -e JIRA_DB_USER=jira_user \
  -e JIRA_DB_PASSWORD=secure-password \
  docker.xuanyuan.run/atlassian/jira-software:latest
```
**参数说明**：
- `-p 8080:8080`：将容器内JIRA默认端口（8080）映射到主机8080端口，可根据需求调整主机端口。
- `-v jira-data:/var/atlassian/application-data/jira`：挂载命名卷`jira-data`到JIRA数据目录，实现数据持久化。
- 环境变量（`-e`）：指定数据库连接信息，需提前部署兼容数据库（如PostgreSQL、MySQL）。

### Docker Compose配置示例
创建`docker-compose.yml`实现JIRA与数据库的联动部署：
```yaml
version: '3.8'
services:
  jira:
    image: docker.xuanyuan.run/atlassian/jira-software:latest
    container_name: jira
    ports:
      - "8080:8080"
    volumes:
      - jira-data:/var/atlassian/application-data/jira
    environment:
      - JIRA_DB_TYPE=postgresql
      - JIRA_DB_HOST=postgres
      - JIRA_DB_PORT=5432
      - JIRA_DB_NAME=jira_db
      - JIRA_DB_USER=jira_user
      - JIRA_DB_PASSWORD=secure-password
    depends_on:
      - postgres
    restart: unless-stopped
    resources:
      limits:
        cpus: '2'
        memory: 4G

  postgres:
    image: docker.xuanyuan.run/postgres:14
    container_name: jira-postgres
    environment:
      - POSTGRES_DB=jira_db
      - POSTGRES_USER=jira_user
      - POSTGRES_PASSWORD=secure-password
    volumes:
      - postgres-data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  jira-data:
  postgres-data:
```
启动服务：
```bash
docker-compose up -d
```

## 配置参数与环境变量

### 核心环境变量
| 环境变量名              | 描述                          | 默认值                                  |
|-------------------------|-------------------------------|-----------------------------------------|
| `JIRA_PORT`             | 容器内JIRA服务端口            | 8080                                    |
| `JIRA_DB_TYPE`          | 数据库类型（postgresql/mysql）| postgresql                              |
| `JIRA_DB_HOST`          | 数据库主机地址                | 无（必填）                              |
| `JIRA_DB_PORT`          | 数据库端口                    | 5432（postgresql默认）/3306（mysql默认）|
| `JIRA_DB_NAME`          | 数据库名称                    | jira_db                                 |
| `JIRA_DB_USER`          | 数据库用户名                  | jira_user                               |
| `JIRA_DB_PASSWORD`      | 数据库密码                    | 无（必填）                              |
| `JIRA_HOME`             | JIRA数据存储目录              | /var/atlassian/application-data/jira    |

### 持久化配置
JIRA数据（含配置、附件、日志等）存储于`JIRA_HOME`目录，必须通过`-v <卷名>:${JIRA_HOME}`挂载外部卷实现持久化，避免容器销毁导致数据丢失。

### 资源配置建议
- **开发/测试环境**：至少1核CPU、2GB内存。
- **生产环境（100人以内团队）**：2核CPU、4GB内存，根据用户规模和数据量适当增加资源。

## 注意事项
- **数据库依赖**：JIRA需连接外部数据库（不支持内置数据库用于生产环境），需提前部署PostgreSQL（推荐）或MySQL，并确保版本兼容（参考Atlassian官方文档）。
- **版本选择**：通过镜像标签指定JIRA版本（如`atlassian/jira-software:9.12.0`），生产环境建议使用固定版本而非`latest`。
- **安全配置**：生产环境需配置HTTPS（可通过反向代理如Nginx实现），并定期更新镜像和数据库以修复安全漏洞。
