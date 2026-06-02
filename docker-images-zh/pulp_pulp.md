---
image: pulp/pulp
description: "包含所有兼容插件的Pulp 3内容管理系统镜像，用于管理软件包、容器镜像等各类内容。"
source: https://xuanyuan.cloud/zh/r/pulp/pulp
canonical: https://xuanyuan.cloud/zh/r/pulp/pulp
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/pulp/pulp" title="pulp/pulp Docker 镜像中文简介、标签列表与拉取命令">pulp/pulp — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/pulp/pulp" title="pulp/pulp Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/pulp/pulp</a>

# Pulp 3 全插件镜像

## 镜像概述和主要用途

Pulp 3 是开源内容管理系统，本镜像集成 Pulp 3 核心及所有兼容插件，支持 RPM、Python 包、容器镜像、Ansible 角色等多种内容类型。无需额外安装插件即可直接部署使用，简化内容管理基础设施的搭建流程，适用于企业级内容同步、分发与版本控制场景。

## 核心功能和特性

- **多类型内容支持**：通过集成插件支持 RPM、Python (PyPI)、容器镜像 (OCI)、Ansible 角色、Debian 包等多种内容格式。
- **内容同步与分发**：支持从远程仓库同步内容，通过 HTTP/HTTPS 向客户端分发，支持增量同步节省带宽。
- **版本控制**：追踪内容变更历史，支持回滚到历史版本，确保内容可追溯。
- **访问控制**：基于角色的权限管理 (RBAC)，配置细粒度用户权限，保障内容安全。
- **REST API**：提供完整 RESTful API，支持自动化操作与 CI/CD 流程集成。
- **可扩展性**：支持水平扩展，通过增加节点提升处理能力，适应大规模内容管理需求。

## 使用场景和适用范围

- **企业私有仓库**：构建内部软件仓库，集中管理 RPM、Python 等包，供服务器和开发环境使用。
- **开发依赖管理**：为团队提供稳定依赖源，避免外部仓库不稳定影响开发进度。
- **CI/CD 内容供应**：作为流水线资源源，提供构建部署所需的依赖包、容器镜像。
- **混合云分发**：在多区域环境中作为内容枢纽，优化跨区域内容分发延迟。
- **内容备份镜像**：镜像外部公共仓库内容，防止外部服务中断导致业务受影响。

## 使用方法和配置说明

### 前置要求

- Docker 19.03+ 环境
- 至少 2GB 内存（生产环境推荐 4GB+）
- 持久化存储（推荐 SSD 提升性能）

### Docker Run 示例

#### 测试环境启动
```bash
docker run -d -p 8080:80 --name pulp3-full pulp/pulp3-with-all-plugins
```

#### 生产环境启动
```bash
docker run -d \
  -p 8080:80 \
  -v /path/to/pulp/data:/var/lib/pulp \
  -v /path/to/pulp/config:/etc/pulp \
  -e PULP_ADMIN_USER=admin \
  -e PULP_ADMIN_PASSWORD=your_secure_password \
  --name pulp3-full \
  pulp/pulp3-with-all-plugins
```

### Docker Compose 示例

创建 `docker-compose.yml`：
```yaml
version: '3.8'

services:
  pulp:
    image: pulp/pulp3-with-all-plugins
    ports:
      - "8080:80"
    volumes:
      - pulp_data:/var/lib/pulp
      - pulp_config:/etc/pulp
    environment:
      - PULP_ADMIN_USER=admin
      - PULP_ADMIN_PASSWORD=secure_password_here
      - PULP_LOG_LEVEL=INFO
    restart: unless-stopped

volumes:
  pulp_data:
  pulp_config:
```

启动命令：
```bash
docker-compose up -d
```

## 配置参数

### 环境变量

| 环境变量名               | 描述                                  | 默认值                     |
|--------------------------|---------------------------------------|----------------------------|
| `PULP_ADMIN_USER`        | 管理员用户名                          | `admin`                    |
| `PULP_ADMIN_PASSWORD`    | 管理员密码                            | 随机生成（日志中查看）     |
| `PULP_LOG_LEVEL`         | 日志级别（DEBUG/INFO/WARNING/ERROR）  | `INFO`                     |
| `PULP_STORAGE_PATH`      | 内容存储路径                          | `/var/lib/pulp`            |
| `PULP_DATABASE_URL`      | 外部数据库连接 URL（默认内置 SQLite）  | `sqlite:////var/lib/pulp/pulp.db` |

### 持久化配置

推荐挂载以下目录到外部存储：
- `/var/lib/pulp`：存储内容数据
- `/etc/pulp`：存储配置文件

## 访问与使用

- **Web 界面**：访问 `http://<主机IP>:8080`，使用管理员账户登录
- **REST API**：API 根地址 `http://<主机IP>:8080/pulp/api/v3/`，文档参见 [Pulp 3 API 文档](https://docs.pulpproject.org/pulp3/restapi.html)

## 注意事项

- 生产环境建议使用 PostgreSQL 替代内置 SQLite，通过 `PULP_DATABASE_URL` 配置外部数据库
- 首次启动需初始化数据库，耗时约几分钟，可通过 `docker logs pulp3-full` 查看进度
- 高负载场景需调整 CPU/内存资源限制，并考虑水平扩展节点
