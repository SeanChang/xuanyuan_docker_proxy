---
image: freshrss/freshrss
description: "FreshRSS是一款自托管的RSS订阅聚合器，支持x86-64和ARM架构的自动构建版本。"
source: https://xuanyuan.cloud/zh/r/freshrss/freshrss
canonical: https://xuanyuan.cloud/zh/r/freshrss/freshrss
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/freshrss/freshrss" title="freshrss/freshrss Docker 镜像中文简介、标签列表与拉取命令">freshrss/freshrss 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# FreshRSS Docker 镜像文档

![Docker Pulls](https://img.shields.io/docker/pulls/freshrss/freshrss.svg)
[![Liberapay donations](https://img.shields.io/liberapay/receives/FreshRSS.svg?logo=liberapay)](https://liberapay.com/FreshRSS/donate)

![FreshRSS logo](https://github.com/FreshRSS/FreshRSS/raw/edge/docs/img/FreshRSS-logo.png)

## 镜像概述和主要用途

FreshRSS 是一款自托管的 RSS 订阅源聚合器，允许用户集中管理和阅读各类 RSS 订阅内容。本 Docker 镜像提供了 FreshRSS 的便捷部署方案，支持多架构运行环境，适用于个人或团队的 RSS 内容管理需求。

- **官方网站**：[freshrss.org](https://freshrss.org/)
- **官方 Docker 镜像**：[hub.docker.com/r/freshrss/freshrss](https://hub.docker.com/r/freshrss/freshrss/)
- **代码仓库**：[github.com/FreshRSS/FreshRSS](https://github.com/FreshRSS/FreshRSS/)
- **文档**：[freshrss.github.io/FreshRSS](https://freshrss.github.io/FreshRSS/)
- **许可证**：[GNU AGPL 3](https://www.gnu.org/licenses/agpl-3.0.html)

## 核心功能和特性

- **自托管部署**：完全掌控数据隐私，无需依赖第三方服务
- **多数据库支持**：内置 SQLite（默认），同时支持 PostgreSQL 和 MySQL/MariaDB
- **自动刷新机制**：通过 cron 任务定期更新订阅源
- **扩展支持**：可安装第三方扩展增强功能
- **多架构兼容**：支持 `linux/amd64`、`linux/arm/v7`、`linux/arm64` 等平台
- **灵活部署选项**：支持独立容器运行或通过 Docker Compose 集成数据库和反向代理
- **开发模式**：支持挂载本地代码进行开发调试

## 使用场景和适用范围

- **个人 RSS 阅读**：集中管理个人订阅的博客、新闻等内容
- **团队信息聚合**：团队共享的行业资讯、技术文档等订阅源管理
- **开发环境**：快速搭建 FreshRSS 开发调试环境
- **自托管服务栈**：作为个人服务器生态的一部分，与其他自托管服务协同工作

## 安装 Docker

参考 Docker 官方文档：<https://docs.docker.com/get-docker/>

Debian/Ubuntu 系统示例：

```sh
# 安装 Docker Compose（会自动安装对应版本的 Docker）
apt install docker-compose-v2
```

## 快速开始

### 独立容器运行

```sh
docker run -d --restart unless-stopped --log-opt max-size=10m \
  -p 8080:80 \
  -e TZ=Asia/Shanghai \
  -e 'CRON_MIN=1,31' \
  -v freshrss_data:/var/www/FreshRSS/data \
  -v freshrss_extensions:/var/www/FreshRSS/extensions \
  --name freshrss \
  freshrss/freshrss
```

参数说明：
- `-p 8080:80`：将容器 80 端口映射到主机 8080 端口
- `-e TZ=Asia/Shanghai`：设置时区（默认 UTC）
- `-e 'CRON_MIN=1,31'`：设置定时刷新订阅的分钟数（每小时的第 1 和 31 分钟）
- `-v freshrss_data:/var/www/FreshRSS/data`：持久化存储数据
- `-v freshrss_extensions:/var/www/FreshRSS/extensions`：持久化存储扩展

### 完成安装

通过浏览器访问 `http://服务器IP:8080`，通过 FreshRSS 网页界面完成安装，或使用命令行方式（见下文）。

## 命令行操作

可通过容器内的 CLI 命令管理 FreshRSS，命令格式：

```sh
docker exec --user www-data freshrss 命令
```

> **注意**：使用 Alpine 版本镜像时，需将 `--user www-data` 替换为 `--user apache`

### 命令行安装示例

```sh
# 执行基础安装
docker exec --user www-data freshrss cli/do-install.php --default-user freshrss

# 创建管理员用户
docker exec --user www-data freshrss cli/create-user.php --user freshrss --password freshrss
```

### 常用 CLI 命令

```sh
# 列出所有用户
docker exec --user www-data freshrss cli/list-users.php

# 更新所有订阅源
docker exec --user www-data freshrss cli/actualize-user.php --user freshrss
```

## 镜像变体

Docker 镜像标签对应不同的 FreshRSS 版本和分支：

| 标签格式 | 说明 |
|----------|------|
| `:latest` | 默认标签，指向最新稳定版 |
| `:edge` | 滚动更新版本，对应 git 的 `edge` 分支 |
| `:x.y.z` | 特定版本，如 `:1.21.0` |
| `:x` | 主版本系列，如 `:1` 会自动更新到最新的 1.x 版本 |
| `*-alpine` | 基于 Alpine Linux 的轻量版本，如 `:latest-alpine` |

### Debian 与 Alpine 版本对比

- **Debian 版本**（默认）：兼容性更好，性能略低，包更新较慢
- **Alpine 版本**：体积更小，构建速度更快，包版本更新，但在部分系统可能存在兼容性问题

## 环境变量

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| `TZ` | `UTC` | 服务器时区，参考 [PHP 时区列表](http://php.net/timezones) |
| `CRON_MIN` | 未设置 | cron 任务分钟数，如 `1,31` 表示每小时的第 1 和 31 分钟执行 |
| `DATA_PATH` | 空 | 可写数据路径，由 `constants.php` 或 `constants.local.php` 定义 |
| `FRESHRSS_ENV` | `production` | 运行环境，设为 `development` 启用开发模式（更多日志输出） |
| `COPY_LOG_TO_SYSLOG` | `On` | 是否将日志复制到 syslog |
| `COPY_SYSLOG_TO_STDERR` | `On` | 是否将 syslog 复制到标准错误输出（docker logs 可见） |
| `LISTEN` | `80` | 内部 Apache 监听地址和端口，如 `0.0.0.0:8080` |
| `FRESHRSS_INSTALL` | 未设置 | 自动安装参数，仅在首次运行时生效 |
| `FRESHRSS_USER` | 未设置 | 自动创建用户参数，仅在首次运行时生效 |
| `TRUSTED_PROXY` | 未设置 | 受信任代理 IP 范围，影响日志记录和外部认证 |
| `OIDC_ENABLED` | `0` | 是否启用 OpenID Connect 认证（仅 Debian 版本支持） |

## 更新方法

```sh
# 拉取最新镜像
docker pull docker.xuanyuan.run/freshrss/freshrss

# 停止并备份当前容器
docker stop freshrss
docker rename freshrss freshrss_old

# 启动新容器（使用之前的运行命令）
docker run ... --name freshrss freshrss/freshrss

# 确认正常运行后删除旧容器
docker rm freshrss_old
```

## 自定义构建镜像

对于 Docker Hub 未提供的架构（如非 x64/arm 平台），可自行构建镜像：

```sh
# 构建 Alpine 版本（latest 分支）
docker build --pull --tag freshrss/freshrss:latest -f Docker/Dockerfile-Alpine https://github.com/FreshRSS/FreshRSS.git#latest

# 构建 Debian 版本（edge 分支）
docker build --pull --tag freshrss/freshrss:edge -f Docker/Dockerfile https://github.com/FreshRSS/FreshRSS.git#edge
```

## 开发模式

挂载本地代码目录进行开发：

```sh
cd ./FreshRSS/
docker run --rm \
  -p 8080:80 \
  -e FRESHRSS_ENV=development \
  -e TZ=Asia/Shanghai \
  -e 'CRON_MIN=1,31' \
  -v $(pwd):/var/www/FreshRSS \
  -v freshrss_data:/var/www/FreshRSS/data \
  --name freshrss \
  docker.xuanyuan.run/freshrss/freshrss:edge
```

此命令会将当前目录的代码挂载到容器中，在 8080 端口启动服务，并输出详细日志。按 `Ctrl+C` 停止服务。

## 数据库配置

FreshRSS 默认使用 SQLite 数据库，也可配置 PostgreSQL 或 MySQL/MariaDB。

### 创建专用网络

```sh
docker network create freshrss-network
```

### PostgreSQL 配置

```sh
# 启动 PostgreSQL 容器
docker run -d --restart unless-stopped --log-opt max-size=10m \
  -v pgsql_data:/var/lib/postgresql/data \
  -e POSTGRES_DB=freshrss \
  -e POSTGRES_USER=freshrss \
  -e POSTGRES_PASSWORD=freshrss \
  --net freshrss-network \
  --name freshrss-db postgres
```

在 FreshRSS 安装界面中，数据库主机填写容器名 `freshrss-db`。

### MySQL/MariaDB 配置

```sh
# 启动 MariaDB 容器
docker run -d --restart unless-stopped --log-opt max-size=10m \
  -v mysql_data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=freshrss \
  -e MYSQL_USER=freshrss \
  -e MYSQL_PASSWORD=freshrss \
  --net freshrss-network \
  --name freshrss-db mariadb
```

## Docker Compose 部署

### 环境变量配置

创建 `.env` 文件：

```ini
BASE_URL=https://freshrss.example.com
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=your_secure_password
ADMIN_API_PASSWORD=your_api_password
PUBLISHED_PORT=8080
DB_HOST=freshrss-db
DB_BASE=freshrss
DB_PASSWORD=freshrss
DB_USER=freshrss
```

### docker-compose.yml 配置

```yaml
volumes:
  data:
  extensions:
  db_data:

services:
  freshrss:
    image: docker.xuanyuan.run/freshrss/freshrss:latest
    restart: unless-stopped
    logging:
      options:
        max-size: 10m
    ports:
      - "${PUBLISHED_PORT}:80"
    volumes:
      - data:/var/www/FreshRSS/data
      - extensions:/var/www/FreshRSS/extensions
    environment:
      TZ: Asia/Shanghai
      CRON_MIN: '2,32'
      FRESHRSS_ENV: production
      LISTEN: 0.0.0.0:80
      TRUSTED_PROXY: 172.16.0.1/12 192.168.0.1/16
      FRESHRSS_INSTALL: |-
        --api-enabled
        --base-url ${BASE_URL}
        --db-base ${DB_BASE}
        --db-host ${DB_HOST}
        --db-password ${DB_PASSWORD}
        --db-type pgsql
        --db-user ${DB_USER}
        --default-user admin
        --language zh-CN
      FRESHRSS_USER: |-
        --api-password ${ADMIN_API_PASSWORD}
        --email ${ADMIN_EMAIL}
        --language zh-CN
        --password ${ADMIN_PASSWORD}
        --user admin
    depends_on:
      - freshrss-db
    networks:
      - freshrss-network

  freshrss-db:
    image: docker.xuanyuan.run/postgres:14-alpine
    restart: unless-stopped
    logging:
      options:
        max-size: 10m
    volumes:
      - db_data:/var/lib/postgresql/data
    environment:
      POSTGRES_DB: ${DB_BASE}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    networks:
      - freshrss-network

networks:
  freshrss-network:
```

### 启动服务

```sh
# 启动服务
docker compose up -d

# 查看日志
docker compose logs -f --timestamps

# 停止服务
docker compose down --remove-orphans
```

## 生产环境部署

### 使用 Traefik 反向代理

#### 子域名部署

在 docker-compose.yml 中添加 Traefik 标签：

```yaml
labels:
  - traefik.enable=true
  - traefik.http.routers.freshrss.rule=Host(`freshrss.example.com`)
  - traefik.http.routers.freshrss.entrypoints=websecure
  - traefik.http.routers.freshrss.tls.certresolver=myresolver
```

#### 子路径部署

```yaml
labels:
  - traefik.enable=true
  - traefik.http.middlewares.freshrss-stripprefix.stripprefix.prefixes=/freshrss
  - traefik.http.routers.freshrss.middlewares=freshrss-stripprefix
  - traefik.http.routers.freshrss.rule=PathPrefix(`/freshrss`)
  - traefik.http.routers.freshrss.entrypoints=websecure
  - traefik.http.routers.freshrss.tls.certresolver=myresolver
```

### Apache 反向代理配置

作为子目录部署的 Apache 配置示例：

```apache
ProxyPreserveHost On

<Location /freshrss/>
    ProxyPass http://127.0.0.1:8080/
    ProxyPassReverse http://127.0.0.1:8080/
    RequestHeader set X-Forwarded-Prefix "/freshrss"
    RequestHeader set X-Forwarded-Proto "https"
    Require all granted
    Options none
</Location>
```

### Nginx 反向代理配置

#### 子目录部署

```nginx
upstream freshrss {
    server 127.0.0.1:8080;
    keepalive 64;
}

server {
    listen 80;
    server_name example.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name example.com;

    # SSL 配置省略

    location /freshrss/ {
        proxy_pass http://freshrss/;
        add_header X-Frame-Options SAMEORIGIN;
        add_header X-XSS-Protection "1; mode=block";
        proxy_redirect off;
        proxy_buffering off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Prefix /freshrss/;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port $server_port;
        proxy_read_timeout 90;
        proxy_set_header Authorization $http_authorization;
        proxy_pass_header Authorization;
    }
}
```

## 订阅源自动刷新

### 方法 1：容器内置 cron（推荐）

通过 `CRON_MIN` 环境变量启用，如：

```sh
docker run ... -e 'CRON_MIN=13,43' ... freshrss/freshrss
```

### 方法 2：主机 cron 任务

在主机创建 cron 任务：

```text
7,37 * * * * root docker exec --user www-data freshrss php ./app/actualize_script.php > /tmp/FreshRSS.log 2>&1
```

### 方法 3：独立 cron 容器

Debian 版本示例：

```sh
docker run -d --restart unless-stopped --log-opt max-size=10m \
  -v freshrss_data:/var/www/FreshRSS/data \
  -v freshrss_extensions:/var/www/FreshRSS/extensions \
  -e 'CRON_MIN=17,47' \
  --net freshrss-network \
  --name freshrss_cron freshrss/freshrss \
  cron -f
```

## 修改运行中的配置

FreshRSS 配置存储在 `data/config.php` 中，可通过以下步骤修改：

```sh
# 查看数据卷路径
docker volume inspect freshrss_data

# 编辑配置文件（路径可能不同，请根据实际输出调整）
sudo nano /var/lib/docker/volumes/freshrss_data/_data/config.php

# 重启容器使配置生效
docker restart freshrss
