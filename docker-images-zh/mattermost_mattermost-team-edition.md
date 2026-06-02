---
image: mattermost/mattermost-team-edition
description: "Mattermost Team Edition的官方Docker镜像，用于便捷部署和运行团队协作平台。"
source: https://xuanyuan.cloud/zh/r/mattermost/mattermost-team-edition
canonical: https://xuanyuan.cloud/zh/r/mattermost/mattermost-team-edition
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mattermost/mattermost-team-edition" title="mattermost/mattermost-team-edition Docker 镜像中文简介、标签列表与拉取命令">mattermost/mattermost-team-edition — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/mattermost/mattermost-team-edition" title="mattermost/mattermost-team-edition Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mattermost/mattermost-team-edition</a>

# Mattermost Team Edition Docker镜像文档


## 1. 镜像概述

### 1.1 基本信息
本镜像为Mattermost Team Edition的官方Docker镜像，用于提供团队协作平台Mattermost Team Edition的容器化部署方案。该镜像已替代旧版镜像 `mattermost/mattermost-prod-app`，是当前推荐的Team Edition容器化部署方式。

### 1.2 主要用途
提供Mattermost Team Edition的标准化、可移植部署，支持快速搭建团队协作环境，适用于自托管场景下的团队沟通与协作需求。

### 1.3 镜像来源
Dockerfile源码地址：[https://github.com/mattermost/mattermost/blob/master/server/build/Dockerfile](https://github.com/mattermost/mattermost/blob/master/server/build/Dockerfile)


## 2. 核心功能与特性

### 2.1 核心功能
- **团队协作平台**：提供基于Web的团队协作环境，支持多团队与多频道管理。
- **实时消息传递**：支持文本、富媒体消息，提供一对一聊天与群组对话功能。
- **文件共享**：支持多格式文件上传与共享，集成文件预览能力。
- **第三方集成**：兼容Slack风格Webhook，支持与Jira、GitHub等工具集成。
- **搜索功能**：支持消息、文件、用户全局搜索，提升信息检索效率。

### 2.2 容器化特性
- **轻量级部署**：基于Alpine Linux构建，镜像体积优化，资源占用低。
- **环境变量配置**：支持通过环境变量动态配置应用参数，无需手动修改配置文件。
- **数据持久化**：支持挂载外部卷存储应用数据与日志，确保数据不丢失。
- **可扩展性**：支持与主流数据库（PostgreSQL/MySQL）集成，适应团队规模增长。


## 3. 使用场景与适用范围

### 3.1 典型使用场景
- **中小型团队协作**：10-100人规模团队的内部沟通与信息同步。
- **开发团队协作**：代码审查、任务跟踪、CI/CD流程通知集成。
- **远程团队管理**：跨地域团队的实时沟通、会议记录与文档协作。
- **企业内部沟通**：替代邮件的高效沟通工具，支持部门、项目组独立频道。

### 3.2 适用范围
- 需自托管协作平台的企业或组织。
- 对数据隐私与合规性有严格要求的团队。
- 希望低成本部署团队协作工具的中小型企业。
- 技术团队或DevOps场景下的协作需求。


## 4. 使用方法

### 4.1 前置要求
- Docker 19.03+ 或 Docker Desktop
- Docker Compose（推荐，用于多服务部署）
- 至少 2GB 内存与 10GB 磁盘空间
- 数据库服务（PostgreSQL 12+ 或 MySQL 8.0+，推荐PostgreSQL）


### 4.2 快速启动（单容器模式）
需提前准备外部数据库（以PostgreSQL为例），执行以下命令启动容器：

```bash
docker run -d \
  --name mattermost-team \
  -p 8065:8065 \
  -e MM_SQLSETTINGS_DRIVERNAME=postgres \
  -e MM_SQLSETTINGS_DATASOURCE="postgres://user:password@db-host:5432/mattermost?sslmode=disable&connect_timeout=10" \
  -e MM_SERVICESETTINGS_SITEURL="http://your-domain.com:8065" \
  -v mattermost-data:/app/mattermost/data \
  -v mattermost-logs:/app/mattermost/logs \
  mattermost/mattermost-team-edition:latest
```

> 说明：`db-host` 需替换为实际数据库地址，`user/password` 替换为数据库认证信息，首次启动需确保数据库已创建（可手动创建名为`mattermost`的数据库）。


### 4.3 Docker Compose部署（推荐）
创建 `docker-compose.yml` 文件，集成应用与PostgreSQL服务：

```yaml
version: '3.8'

services:
  mattermost:
    image: mattermost/mattermost-team-edition:latest
    container_name: mattermost-app
    restart: unless-stopped
    ports:
      - "8065:8065"
    environment:
      # 数据库配置
      MM_SQLSETTINGS_DRIVERNAME: postgres
      MM_SQLSETTINGS_DATASOURCE: "postgres://mmuser:mmuser_password@db:5432/mattermost?sslmode=disable&connect_timeout=10"
      # 站点配置
      MM_SERVICESETTINGS_SITEURL: "http://localhost:8065"
      MM_SERVICESETTINGS_LISTENADDRESS: ":8065"
      # 日志配置
      MM_LOGSETTINGS_CONSOLELEVEL: info
    volumes:
      - mattermost-data:/app/mattermost/data
      - mattermost-logs:/app/mattermost/logs
      - mattermost-config:/app/mattermost/config
    depends_on:
      - db

  db:
    image: postgres:14-alpine
    container_name: mattermost-db
    restart: unless-stopped
    environment:
      POSTGRES_USER: mmuser
      POSTGRES_PASSWORD: mmuser_password
      POSTGRES_DB: mattermost
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  mattermost-data:
  mattermost-logs:
  mattermost-config:
  postgres-data:
```

启动服务：
```bash
docker-compose up -d
```

访问应用：打开浏览器访问 `http://localhost:8065`，首次登录需创建管理员账户。


## 5. 配置说明

### 5.1 核心环境变量
通过环境变量配置应用参数，常用配置如下：

| 环境变量                          | 描述                                  | 默认值                                  |
|-----------------------------------|---------------------------------------|-----------------------------------------|
| `MM_SQLSETTINGS_DRIVERNAME`       | 数据库驱动类型                        | `postgres`（支持`mysql`）               |
| `MM_SQLSETTINGS_DATASOURCE`       | 数据库连接字符串                      | 无（必填）                              |
| `MM_SERVICESETTINGS_SITEURL`      | 站点访问URL                           | `http://localhost:8065`                 |
| `MM_SERVICESETTINGS_LISTENADDRESS`| 应用监听地址与端口                    | `:8065`                                 |
| `MM_LOGSETTINGS_CONSOLELEVEL`     | 日志级别                              | `info`（可选：`debug`/`warn`/`error`）  |
| `MM_FILESETTINGS_DIRECTORY`       | 文件存储路径                          | `/app/mattermost/data`                  |
| `MM_EMAILSETTINGS_SMTPSERVER`     | SMTP服务器地址                        | 无（如需邮件通知需配置）                |
| `MM_EMAILSETTINGS_SMTPPORT`       | SMTP服务器端口                        | `587`                                   |
| `MM_EMAILSETTINGS_USESSL`         | 是否启用SSL连接SMTP                   | `false`                                 |
| `MM_EMAILSETTINGS_USERNAME`       | SMTP认证用户名                        | 无                                      |
| `MM_EMAILSETTINGS_PASSWORD`       | SMTP认证密码                          | 无                                      |


### 5.2 数据持久化
通过挂载以下卷确保数据持久化：

| 卷路径                          | 用途                          | 建议操作                  |
|---------------------------------|-------------------------------|---------------------------|
| `/app/mattermost/data`          | 存储上传文件、用户头像等数据  | 必须挂载外部卷            |
| `/app/mattermost/logs`          | 应用日志文件                  | 建议挂载外部卷            |
| `/app/mattermost/config`        | 配置文件（自动生成）          | 可选挂载，用于自定义配置  |


### 5.3 高级配置
如需自定义更多参数，可通过修改 `/app/mattermost/config/config.json` 文件实现（需挂载`config`卷），或通过环境变量覆盖（格式：`MM_<配置项层级>_<配置项名称>`，如`MM_SERVICESETTINGS_ENABLELINKPREVIEWS=true`）。


## 6. 注意事项

- **首次启动**：首次启动需等待数据库初始化完成，约1-2分钟，可通过日志确认：`docker logs mattermost-app`。
- **数据库兼容性**：推荐使用PostgreSQL 12+，MySQL需启用`utf8mb4`字符集。
- **升级说明**：升级前需备份数据卷，建议通过`docker-compose pull`更新镜像后重启服务。
- **安全加固**：生产环境需配置HTTPS（通过反向代理如Nginx），并修改默认管理员密码。
- **资源调整**：根据团队规模调整容器CPU/内存限制（通过`docker run --cpus`或`docker-compose`的`deploy`配置）。
