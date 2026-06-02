---
image: library/nextcloud
description: "Nextcloud手动构建Docker镜像是一款针对开源文件同步与共享平台Nextcloud的容器化部署包，支持用户通过手动配置方式构建，可灵活适配自建服务器环境，提供安全的文件存储、同步、共享及协作功能，适用于个人或企业搭建私有云存储系统，兼具部署便捷性与自定义扩展性，助力实现数据自主管理与高效协作。"
source: https://xuanyuan.cloud/zh/r/library/nextcloud
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[library/nextcloud](https://xuanyuan.cloud/zh/r/library/nextcloud)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Nextcloud Docker 镜像使用介绍


## 重要说明

⚠️⚠️⚠️ 本镜像由社区志愿者维护，适用于有经验的用户。若需快速部署并支持 Nextcloud Hub 全部功能，建议使用由 Nextcloud GmbH 官方维护的 [Nextcloud All-in-One Docker 容器]([])。


## 基本参考信息

### 维护方
[Nextcloud 社区]([])

### 帮助支持
可通过 [Docker Community Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([]) 获取帮助。


## 支持的标签及对应 Dockerfile 链接

以下是常用镜像标签及其 Dockerfile 地址（仅列举部分主要版本）：

- **Apache 版本**  
  [`30.0.16-apache`, `30.0-apache`, `30-apache`, `30.0.16`, `30.0`, `30`]([])  
  [`31.0.9-apache`, `31.0-apache`, `31-apache`, `stable-apache`, `production-apache`, `31.0.9`, `31.0`, `31`, `stable`, `production`]([])  
  [`32.0.0-apache`, `32.0-apache`, `32-apache`, `apache`, `32.0.0`, `32.0`, `32`, `latest`]([])

- **FPM 版本**  
  [`30.0.16-fpm`, `30.0-fpm`, `30-fpm`]([])  
  [`31.0.9-fpm`, `31.0-fpm`, `31-fpm`, `stable-fpm`, `production-fpm`]([])  
  [`32.0.0-fpm`, `32.0-fpm`, `32-fpm`, `fpm`]([])

- **FPM-Alpine 版本**  
  [`30.0.16-fpm-alpine`, `30.0-fpm-alpine`, `30-fpm-alpine`]([])  
  [`31.0.9-fpm-alpine`, `31.0-fpm-alpine`, `31-fpm-alpine`, `stable-fpm-alpine`, `production-fpm-alpine`]([])  
  [`32.0.0-fpm-alpine`, `32.0-fpm-alpine`, `32-fpm-alpine`, `fpm-alpine`]([])


## 扩展参考信息

- **问题反馈地址**：[[]]([])  
- **支持的架构**：`amd64`、`arm32v5`、`arm32v6`、`arm32v7`、`arm64v8`、`i386`、`ppc64le`、`riscv64`、`s390x`（[架构详情]([])）  
- **镜像详情**：[repo-info 仓库的 `repos/nextcloud/` 目录]([])（包含元数据、传输大小等）  
- **镜像更新**：[official-images 仓库的 `library/nextcloud` 标签]([])  
- **完整说明文档**：由于 Hub 长度限制，完整描述请参见 [GitHub 文档]([])


## 关于 Nextcloud

Nextcloud 是一款开源的个人/企业数据管理平台，可安全存储文件、日历、联系人等数据，并支持多设备访问与共享。详情可访问 [Nextcloud 官网]([])。

> **注意**：本 Docker 镜像是社区维护版本，Nextcloud GmbH 不提供技术支持。如需专业支持，可选择 [企业版]([]) 或 [All-in-One 容器]([])。


## 如何使用本镜像

本镜像适用于微服务环境，提供两种类型：`apache` 与 `fpm`。`apache` 标签包含完整的 Nextcloud 环境及 Apache 服务器，开箱即用；`fpm` 标签基于 `php-fpm`，需配合外部 Web 服务器（如 Nginx）使用。


### 1. Apache 镜像使用

Apache 镜像内置 Web 服务器，暴露 80 端口，直接运行即可启动服务：

```bash
docker run -d -p 8080:80 nextcloud
```

启动后，通过 `[] 访问 Nextcloud 初始化页面。


### 2. FPM 镜像使用

FPM 镜像需配合外部 Web 服务器（如 Nginx），仅提供 FastCGI 进程，不处理静态文件（样式表、图片等）。启动时无需映射端口（由 Web 服务器转发请求）：

```bash
docker run -d nextcloud:fpm
```

**注意**：Web 服务器需通过 `volumes-from` 挂载 Nextcloud 的静态文件目录（如 `/var/www/html`），具体配置可参考下文 Docker Compose 示例。


### 3. 使用外部数据库

默认情况下，容器使用 SQLite 数据库，生产环境建议使用 MySQL/MariaDB 或 PostgreSQL。可通过环境变量预配置数据库连接，或在初始化页面手动填写。

#### 示例：链接 MariaDB 容器
```bash
# 启动数据库容器
docker run -d -v db_data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=your_root_pw -e MYSQL_DATABASE=nextcloud -e MYSQL_USER=nextcloud -e MYSQL_PASSWORD=your_pw --name nextcloud_db mariadb:10.6

# 启动 Nextcloud 并链接数据库
docker run -d -p 8080:80 --link nextcloud_db:mysql -e MYSQL_HOST=mysql -e MYSQL_DATABASE=nextcloud -e MYSQL_USER=nextcloud -e MYSQL_PASSWORD=your_pw nextcloud
```


### 4. 持久化数据

Nextcloud 数据（文件上传、配置等）存储在容器内 `/var/www/html` 目录，建议通过**命名卷**或**主机目录挂载**实现持久化，避免容器删除后数据丢失。

#### 核心挂载目录
- Nextcloud 数据：`/var/www/html`（必选，包含所有应用及用户数据）  
- 数据库数据：MySQL/MariaDB 为 `/var/lib/mysql`，PostgreSQL 为 `/var/lib/postgresql/data`（按需挂载）

#### 示例：使用命名卷持久化
```bash
# 持久化 Nextcloud 数据
docker run -d -v nextcloud_data:/var/www/html nextcloud

# 持久化 MariaDB 数据
docker run -d -v mariadb_data:/var/lib/mysql mariadb:10.6
```

#### 细分挂载（可选）
如需精细化管理，可单独挂载子目录：
- `config`：配置文件（`/var/www/html/config`）  
- `data`：用户上传文件（`/var/www/html/data`）  
- `custom_apps`：自定义应用（`/var/www/html/custom_apps`）  
- `themes`：主题文件（`/var/www/html/themes/<自定义主题>`）

```bash
docker run -d \
  -v nextcloud:/var/www/html \
  -v nextcloud_config:/var/www/html/config \
  -v nextcloud_data:/var/www/html/data \
  nextcloud
```


### 5. 使用 Nextcloud 命令行工具（occ）

通过 `occ` 命令管理 Nextcloud（如用户创建、维护模式切换），需以 `www-data` 用户执行：

```bash
# 容器内执行
docker exec --user www-data <容器ID> php occ <命令>

# 示例：列出用户
docker exec --user www-data <容器ID> php occ user:list
```


### 6. 环境变量自动配置

通过环境变量可跳过初始化页面，直接完成配置。常用变量如下：

| 变量名                  | 说明                                                                 |
|-------------------------|----------------------------------------------------------------------|
| `NEXTCLOUD_ADMIN_USER`  | 管理员用户名（需与 `NEXTCLOUD_ADMIN_PASSWORD` 同时设置）             |
| `NEXTCLOUD_ADMIN_PASSWORD` | 管理员密码                                                           |
| `NEXTCLOUD_TRUSTED_DOMAINS` | 可信域名列表（空格分隔，如 `domain1.com domain2.com`）               |
| `MYSQL_HOST`/`POSTGRES_HOST` | 数据库主机地址                                                       |
| `REDIS_HOST`            | Redis 主机地址（用于缓存，可选）                                    |
| `PHP_MEMORY_LIMIT`      | PHP 内存限制（默认 512M）                                           |
| `PHP_UPLOAD_LIMIT`      | 文件上传限制（默认 512M）                                           |

#### 示例：通过环境变量初始化
```bash
docker run -d -p 8080:80 \
  -e NEXTCLOUD_ADMIN_USER=admin \
  -e NEXTCLOUD_ADMIN_PASSWORD=strong_password \
  -e NEXTCLOUD_TRUSTED_DOMAINS=localhost 192.168.1.100 \
  -e MYSQL_HOST=mysql -e MYSQL_DATABASE=nextcloud -e MYSQL_USER=nextcloud -e MYSQL_PASSWORD=db_pw \
  nextcloud
```


### 7. 反向代理配置

若 Nextcloud 部署在反向代理后，需配置信任代理 IP 及协议，避免访问异常。通过以下环境变量设置：

- `APACHE_DISABLE_REWRITE_IP=1`：禁用 IP 重写  
- `TRUSTED_PROXIES=192.168.1.0/24 10.0.0.1`：信任的代理 IP（支持 CIDR 格式）  
- `OVERWRITEPROTOCOL=https`：强制使用 HTTPS 协议  

示例：
```bash
docker run -d -p 8080:80 \
  -e TRUSTED_PROXIES=192.168.1.10 \
  -e OVERWRITEPROTOCOL=https \
  nextcloud
```


## Docker Compose 示例

使用 `compose.yaml` 可快速搭建完整环境（含数据库、持久化存储）。以下为 Apache + MariaDB 基础配置：

```yaml
volumes:
  nextcloud_data:  # Nextcloud 数据卷
  db_data:         # 数据库数据卷

services:
  db:
    image: mariadb:10.6
    restart: always
    volumes:
      - db_data:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=your_root_pw  # 替换为实际密码
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_PASSWORD=your_db_pw        # 替换为实际密码
    command: --transaction-isolation=READ-COMMITTED --log-bin=binlog --binlog-format=ROW

  app:
    image: nextcloud
    restart: always
    ports:
      - 8080:80
    volumes:
      - nextcloud_data:/var/www/html
    environment:
      - MYSQL_HOST=db
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_PASSWORD=your_db_pw        # 与数据库密码一致
    depends_on:
      - db
```

保存为 `compose.yaml` 后，执行 `docker compose up -d` 启动服务，通过 `[] 访问。


## 注意事项

- **升级与备份**：通过命名卷或主机目录挂载数据，便于升级容器时保留数据。  
- **HTTPS 配置**：公网访问需配置 SSL（如通过 Nginx 或 Traefik 反向代理），避免数据传输风险。  
- **性能优化**：大文件上传需调整 `PHP_UPLOAD_LIMIT` 及 Web 服务器请求体限制（如 `APACHE_BODY_LIMIT`）。  

更多高级配置（如 Redis 缓存、S3 存储、钩子脚本等），请参考 [完整文档]([])。
