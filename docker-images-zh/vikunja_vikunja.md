---
image: vikunja/vikunja
description: "Vikunja官方Docker镜像，用于部署开源任务管理与项目协作应用。"
source: https://xuanyuan.cloud/zh/r/vikunja/vikunja
canonical: https://xuanyuan.cloud/zh/r/vikunja/vikunja
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/vikunja/vikunja" title="vikunja/vikunja Docker 镜像中文简介、标签列表与拉取命令">vikunja/vikunja 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Vikunja Docker 镜像


## 镜像概述和主要用途

Vikunja 是一款开源的项目管理工具，提供任务跟踪、列表管理、看板视图等功能，支持个人和团队协作。本 Docker 镜像是由 Vikunja 官方提供的部署包，旨在简化 Vikunja 的安装与运维流程，适用于自托管场景下的快速部署。通过 Docker 镜像，用户可无需手动配置依赖环境，直接启动 Vikunja 服务，实现项目管理功能。


## 核心功能和特性

### 核心功能
- **任务管理**：支持创建、编辑、分配任务，设置优先级、截止日期、标签和描述
- **多视图模式**：提供列表视图、看板视图、日历视图，适配不同项目管理习惯
- **协作功能**：用户/团队管理、权限控制（细粒度资源访问权限）、任务评论与历史记录
- **数据集成**：支持导入/导出任务数据，提供 REST API 和 WebDAV 接口
- **提醒功能**：截止日期提醒、任务状态变更通知


### 特性
- **轻量高效**：基于 Go 语言开发，资源占用低，响应速度快
- **数据持久化**：支持 SQLite、PostgreSQL、MySQL/MariaDB 等数据库后端
- **安全可靠**：内置用户认证（支持 OAuth2）、数据加密存储、HTTPS 支持
- **可扩展性**：支持插件扩展，可通过环境变量自定义配置
- **跨平台**：Docker 镜像支持 Linux/Windows/macOS 等主流操作系统


## 使用场景和适用范围

### 适用场景
- **个人任务管理**：用于个人日常待办事项、学习计划、目标跟踪
- **团队协作**：小型/中型团队的项目进度跟踪、任务分配、需求管理
- **自托管服务**：企业/组织内部部署，满足数据本地化存储需求
- **开源项目管理**：用于开源社区的 issue 跟踪、版本规划、贡献者协作


### 适用范围
- 用户规模：个人用户、5-50 人小型团队
- 部署环境：物理服务器、云服务器（AWS/Azure/GCP）、NAS 设备
- 技术背景：无需深入了解 Vikunja 底层依赖，适合 Docker 基础用户


## 详细使用方法和配置说明

### 前置要求
- Docker 19.03+ 或 Docker Compose 2.0+
- 至少 128MB 可用内存（推荐 512MB+）
- 持久化存储（用于保存配置和数据）


### Docker Run 部署
#### 基础部署（SQLite 数据库，适合个人/测试场景）
```bash
docker run -d \
  --name vikunja \
  -p 3456:3456 \
  -v /path/to/vikunja/data:/app/vikunja/files \
  -e VIKUNJA_SERVICE_JWT_SECRET="your-secure-jwt-secret" \
  docker.xuanyuan.run/vikunja/vikunja:latest
```
- 说明：通过 `-v` 挂载本地目录 `/path/to/vikunja/data` 持久化任务数据（SQLite 数据库文件和附件存储于该目录）；`-p 3456:3456` 映射服务端口；`VIKUNJA_SERVICE_JWT_SECRET` 为必填环境变量，用于 JWT 令牌加密（需替换为随机字符串）。


### Docker Compose 部署（推荐生产环境）
#### 架构说明
生产环境需搭配外部数据库（如 PostgreSQL/MySQL）以提升性能和可靠性。以下为包含 Vikunja 服务和 PostgreSQL 数据库的 `docker-compose.yml` 示例：

```yaml
version: '3'

services:
  vikunja:
    image: docker.xuanyuan.run/vikunja/vikunja:latest
    container_name: vikunja
    ports:
      - "3456:3456"
    environment:
      - VIKUNJA_DATABASE_TYPE=postgres
      - VIKUNJA_DATABASE_HOST=db
      - VIKUNJA_DATABASE_PORT=5432
      - VIKUNJA_DATABASE_USER=vikunja
      - VIKUNJA_DATABASE_PASSWORD=vikunja-db-passwd  # 替换为安全密码
      - VIKUNJA_DATABASE_NAME=vikunja
      - VIKUNJA_SERVICE_JWT_SECRET=your-secure-jwt-secret  # 替换为随机字符串
      - VIKUNJA_SERVICE_FRONTEND_URL=http://localhost:3456  # 前端访问 URL
    volumes:
      - ./vikunja-data:/app/vikunja/files  # 持久化附件和配置
    depends_on:
      - db
    restart: unless-stopped

  db:
    image: docker.xuanyuan.run/postgres:14-alpine
    container_name: vikunja-db
    environment:
      - POSTGRES_USER=vikunja
      - POSTGRES_PASSWORD=vikunja-db-passwd  # 与上方数据库密码一致
      - POSTGRES_DB=vikunja
    volumes:
      - ./postgres-data:/var/lib/postgresql/data  # 持久化数据库数据
    restart: unless-stopped
```

#### 启动步骤
1. 创建目录并保存上述 `docker-compose.yml` 文件：
   ```bash
   mkdir -p vikunja && cd vikunja
   # 将上述 docker-compose.yml 内容保存到当前目录
   ```
2. 启动服务：
   ```bash
   docker-compose up -d
   ```
3. 访问服务：浏览器打开 `http://<服务器IP>:3456`，首次访问需注册管理员账号。


### 数据持久化
Vikunja 核心数据需通过 Docker 卷挂载持久化，避免容器重启后数据丢失：
- **应用数据**：`/app/vikunja/files`（含配置文件、SQLite 数据库、用户上传附件）
- **数据库数据**：若使用外部数据库（如 PostgreSQL），需单独挂载数据库数据目录（如示例中 `./postgres-data`）


## 配置参数说明

### 核心环境变量
| 环境变量名                  | 说明                                  | 默认值                  | 必要性       |
|---------------------------|---------------------------------------|-------------------------|--------------|
| `VIKUNJA_SERVICE_JWT_SECRET` | JWT 令牌加密密钥（需自定义随机字符串） | 无                      | **必填**     |
| `VIKUNJA_DATABASE_TYPE`     | 数据库类型（sqlite/postgres/mysql）   | sqlite                  | 可选（默认sqlite） |
| `VIKUNJA_DATABASE_HOST`     | 数据库地址（仅外部数据库需配置）      | 无                      | 外部数据库必填 |
| `VIKUNJA_DATABASE_PORT`     | 数据库端口                            | 5432（postgres）/3306（mysql） | 外部数据库必填 |
| `VIKUNJA_DATABASE_USER`     | 数据库用户名                          | 无                      | 外部数据库必填 |
| `VIKUNJA_DATABASE_PASSWORD` | 数据库密码                            | 无                      | 外部数据库必填 |
| `VIKUNJA_DATABASE_NAME`     | 数据库名称                            | vikunja                 | 外部数据库必填 |
| `VIKUNJA_SERVICE_FRONTEND_URL` | 前端访问 URL（用于通知链接生成）      | http://localhost:3456   | 可选         |


### 高级配置
如需自定义服务端口、日志级别、邮件通知等，可通过修改配置文件 `config.yml`（位于挂载的 `files` 目录）实现，详细配置项参考 [官方文档](https://vikunja.io/docs/config-options/)。


## 注意事项
1. **安全加固**：生产环境中需将 `VIKUNJA_SERVICE_JWT_SECRET` 和数据库密码替换为强随机字符串，避免使用默认值。
2. **备份策略**：定期备份持久化目录（如 `./vikunja-data` 和数据库目录），防止数据丢失。
3. **HTTPS 配置**：建议通过反向代理（如 Nginx/Traefik）配置 HTTPS，避免明文传输数据。
4. **版本升级**：升级镜像前需备份数据，参考 [官方升级指南](https://vikunja.io/docs/upgrading/)。


## 参考链接
- 官方文档：[Vikunja 安装指南](https://vikunja.io/docs/installing/#docker)
- 源码仓库：[code.vikunja.io/vikunja](https://code.vikunja.io/vikunja)
- 配置说明：[Vikunja 配置选项](https://vikunja.io/docs/config-options/)
