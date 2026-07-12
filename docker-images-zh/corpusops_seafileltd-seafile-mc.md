---
image: corpusops/seafileltd-seafile-mc
description: "提供Seafile文件同步与共享平台的Docker化部署，支持便捷的容器化运行与管理。"
source: https://xuanyuan.cloud/zh/r/corpusops/seafileltd-seafile-mc
canonical: https://xuanyuan.cloud/zh/r/corpusops/seafileltd-seafile-mc
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/corpusops/seafileltd-seafile-mc" title="corpusops/seafileltd-seafile-mc Docker 镜像中文简介、标签列表与拉取命令">corpusops/seafileltd-seafile-mc 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# corpusops/seafile Docker镜像文档


## 一、镜像概述和主要用途

corpusops/seafile 是基于 Seafile 的 Docker 镜像，Seafile 是一款开源企业级云存储解决方案，提供文件同步、共享、版本控制等功能。该镜像旨在简化 Seafile 的部署流程，通过容器化方式快速搭建和管理 Seafile 服务，适用于企业、团队或个人搭建私有云存储系统。


## 二、核心功能和特性

### 2.1 核心功能
- **文件同步与共享**：支持多设备文件实时同步，提供细粒度的文件共享权限管理
- **版本控制**：自动保存文件历史版本，支持版本回溯和恢复
- **数据安全**：采用加密技术保护数据传输和存储，支持 HTTPS 协议
- **团队协作**：提供团队空间、权限管理、在线编辑协作等功能
- **高可用性**：支持集群部署，确保服务稳定运行

### 2.2 镜像特性
- **轻量级部署**：基于 Docker 容器，简化依赖管理和环境配置
- **可定制化**：支持通过环境变量、配置文件自定义服务参数
- **多平台支持**：兼容常见的 Docker 运行环境（Linux、Windows、macOS）
- **持久化存储**：支持数据卷挂载，确保数据持久化保存
- **快速更新**：镜像定期更新，集成 Seafile 最新稳定版本


## 三、使用场景和适用范围

### 3.1 适用场景
- **企业私有云存储**：搭建企业内部文件存储和共享平台，替代第三方云存储服务
- **团队协作平台**：用于团队内部文件协作、项目文档管理和版本控制
- **个人私有云**：个人用户搭建安全的私有云存储，保护数据隐私
- **教育机构/科研团队**：用于教学资料、科研数据的集中管理和共享

### 3.2 适用范围
- 中小企业、团队或个人用户
- 对数据隐私和安全性有较高要求的场景
- 需要快速部署和维护的云存储服务需求


## 四、使用方法和配置说明

### 4.1 环境要求
- Docker Engine 19.03+
- Docker Compose 1.25+（推荐）
- 至少 2GB 内存，4GB+ 推荐
- 至少 20GB 可用磁盘空间


### 4.2 快速启动（docker run）

#### 4.2.1 基本启动命令
```bash
docker run -d \
  --name seafile \
  -p 80:80 \
  -p 443:443 \
  -v /path/to/seafile/data:/opt/seafile/data \
  -v /path/to/seafile/config:/opt/seafile/conf \
  -e SEAFILE_SERVER_NAME="My Seafile Server" \
  -e SEAFILE_ADMIN_EMAIL="admin@example.com" \
  -e SEAFILE_ADMIN_PASSWORD="your_secure_password" \
  docker.xuanyuan.run/corpusops/seafile
```

#### 4.2.2 参数说明
- `-p 80:80`：映射 HTTP 端口
- `-p 443:443`：映射 HTTPS 端口（如需启用 HTTPS）
- `-v /path/to/seafile/data:/opt/seafile/data`：挂载数据目录，持久化存储文件数据
- `-v /path/to/seafile/config:/opt/seafile/conf`：挂载配置目录，持久化配置文件
- `-e SEAFILE_SERVER_NAME`：Seafile 服务器名称
- `-e SEAFILE_ADMIN_EMAIL`：管理员邮箱（用于登录）
- `-e SEAFILE_ADMIN_PASSWORD`：管理员密码


### 4.3 Docker Compose 部署

#### 4.3.1 创建 docker-compose.yml 文件
```yaml
version: '3'

services:
  seafile:
    image: docker.xuanyuan.run/corpusops/seafile
    container_name: seafile
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./seafile/data:/opt/seafile/data
      - ./seafile/config:/opt/seafile/conf
      - ./seafile/logs:/opt/seafile/logs
    environment:
      - SEAFILE_SERVER_NAME="My Seafile Server"
      - SEAFILE_ADMIN_EMAIL="admin@example.com"
      - SEAFILE_ADMIN_PASSWORD="your_secure_password"
      - SEAFILE_DB_TYPE="sqlite"  # 可选：sqlite/mysql/postgresql
      - SEAFILE_MAX_UPLOAD_SIZE="100M"  # 最大上传文件大小
    depends_on:
      - db  # 如需使用外部数据库，需添加 db 服务（如 MySQL）

  # 可选：MySQL 数据库服务（推荐生产环境使用）
  db:
    image: docker.xuanyuan.run/mysql:8.0
    container_name: seafile-mysql
    restart: always
    volumes:
      - ./mysql/data:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD="mysql_root_password"
      - MYSQL_DATABASE="seafile"
      - MYSQL_USER="seafile"
      - MYSQL_PASSWORD="seafile_db_password"
```

#### 4.3.2 启动服务
```bash
docker-compose up -d
```


### 4.4 配置参数说明

#### 4.4.1 环境变量
| 环境变量名                | 描述                                  | 默认值                  |
|---------------------------|---------------------------------------|-------------------------|
| `SEAFILE_SERVER_NAME`     | 服务器名称                            | "Seafile Server"        |
| `SEAFILE_ADMIN_EMAIL`     | 管理员邮箱（必填）                    | -                       |
| `SEAFILE_ADMIN_PASSWORD`  | 管理员密码（必填）                    | -                       |
| `SEAFILE_DB_TYPE`         | 数据库类型（sqlite/mysql/postgresql） | "sqlite"                |
| `SEAFILE_DB_HOST`         | 数据库主机地址（非 sqlite 时必填）    | "db"                    |
| `SEAFILE_DB_PORT`         | 数据库端口                            | 3306（MySQL）           |
| `SEAFILE_DB_USER`         | 数据库用户名                          | "seafile"               |
| `SEAFILE_DB_PASSWORD`     | 数据库密码                            | -                       |
| `SEAFILE_DB_NAME`         | 数据库名称                            | "seafile"               |
| `SEAFILE_MAX_UPLOAD_SIZE` | 最大上传文件大小                      | "200M"                  |
| `SEAFILE_HTTPS`           | 是否启用 HTTPS（true/false）          | "false"                 |
| `SEAFILE_SERVER_URL`      | 服务器访问 URL                        | "http://localhost"      |


#### 4.4.2 持久化目录
| 本地目录路径               | 容器内路径               | 描述                     |
|----------------------------|--------------------------|--------------------------|
| `/path/to/seafile/data`    | `/opt/seafile/data`      | 存储用户文件数据         |
| `/path/to/seafile/config`  | `/opt/seafile/conf`      | 存储配置文件             |
| `/path/to/seafile/logs`    | `/opt/seafile/logs`      | 存储服务日志             |
| `/path/to/mysql/data`      | `/var/lib/mysql`         | MySQL 数据库数据（如需） |


### 4.5 访问服务
服务启动后，通过浏览器访问 `http://<服务器IP>` 或 `https://<服务器IP>`（如启用 HTTPS），使用管理员邮箱和密码登录。


## 五、注意事项

1. **数据备份**：定期备份持久化目录（尤其是 `data` 和 `config` 目录），防止数据丢失。
2. **安全配置**：生产环境中建议启用 HTTPS，可通过反向代理（如 Nginx）配置 SSL 证书。
3. **性能优化**：对于大规模部署，建议使用 MySQL/PostgreSQL 数据库替代 SQLite，并配置适当的资源限制（CPU、内存）。
4. **更新镜像**：更新镜像前请备份数据，使用 `docker-compose pull` 拉取最新镜像后重启服务。
5. **日志查看**：通过 `docker logs seafile` 或查看 `logs` 目录下的日志文件排查问题。
