---
image: roundcube/roundcubemail
description: "Roundcube Webmail套件是基于Web的邮件客户端，提供邮件收发与管理功能，支持通过浏览器访问使用邮件服务。"
source: https://xuanyuan.cloud/zh/r/roundcube/roundcubemail
canonical: https://xuanyuan.cloud/zh/r/roundcube/roundcubemail
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/roundcube/roundcubemail" title="roundcube/roundcubemail Docker 镜像中文简介、标签列表与拉取命令">roundcube/roundcubemail 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Roundcube Docker镜像技术文档


## 1. 镜像概述和主要用途

Roundcube Docker镜像是Roundcube Webmail套件的容器化部署方案，提供基于Web的电子邮件客户端功能。该镜像封装了Roundcube Webmail的核心组件，支持通过环境变量快速配置，兼容多种数据库后端，并提供灵活的持久化和扩展能力，适用于个人或企业邮件系统的Web访问层部署。


## 2. 核心功能和特性

- **多变体支持**：基于官方PHP镜像提供`apache`（含Apache Web服务器）、`fpm`（FPM模式）和`fpm-alpine`（Alpine轻量版FPM）三种变体
- **环境变量配置**：通过环境变量实现核心参数快速配置，无需手动修改配置文件
- **数据库兼容性**：支持SQLite（默认）、MySQL和PostgreSQL存储用户元数据
- **数据持久化**：关键目录支持卷挂载，确保配置、数据库和临时文件持久化
- **插件管理**：支持内置插件激活和自动安装扩展插件
- **Docker Swarm集成**：支持Docker Secrets管理敏感信息（如数据库密码、加密密钥）
- **灵活定制**：支持通过挂载配置文件实现高级自定义设置和PHP参数调整


## 3. 使用场景和适用范围

- **个人邮件客户端**：快速部署轻量级Web邮件访问界面
- **企业邮件系统**：作为企业邮件服务器（如Postfix/Dovecot）的Web前端
- **开发测试环境**：快速搭建邮件客户端测试环境，支持多种配置组合
- **容器化部署**：适配Docker Swarm、Kubernetes等容器编排平台，支持水平扩展
- **反向代理集成**：可配合Nginx等反向代理实现HTTPS和路径自定义


## 4. 镜像标签和变体

### 4.1 标签说明
| 标签类型       | 描述                                                                 |
|----------------|----------------------------------------------------------------------|
| `latest-*`     | 包含最新稳定版Roundcube及最新PHP基础镜像（如`latest-apache`）         |
| `1.3.x`        | 特定主版本系列（如1.3系列），持续接收该系列更新和基础镜像升级         |
| `1.3.10`       | 完整版本标签，仅表示发布时的版本和基础镜像，不接收后续更新             |

### 4.2 变体说明
- **`apache`**：基于`php:*{-apache}`镜像，内置Apache Web服务器，开箱即用
- **`fpm`**：基于`php:*{-fpm}`镜像，仅包含PHP-FPM，需配合外部Web服务器（如Nginx）
- **`fpm-alpine`**：基于Alpine Linux的FPM变体，镜像体积更小，资源占用更低


## 5. 详细配置说明

### 5.1 环境变量配置

#### 5.1.1 基础连接配置
| 环境变量                          | 默认值              | 说明                                                                 |
|-----------------------------------|---------------------|----------------------------------------------------------------------|
| `ROUNDCUBEMAIL_DEFAULT_HOST`      | -                   | IMAP服务器主机名，加密连接前缀：`tls://`（STARTTLS）或`ssl://`（SSL/TLS） |
| `ROUNDCUBEMAIL_DEFAULT_PORT`      | `143`               | IMAP服务器端口                                                       |
| `ROUNDCUBEMAIL_SMTP_SERVER`       | -                   | SMTP服务器主机名，加密连接前缀同上                                   |
| `ROUNDCUBEMAIL_SMTP_PORT`         | `587`               | SMTP服务器端口                                                       |
| `ROUNDCUBEMAIL_USERNAME_DOMAIN`   | -                   | 自动添加到登录用户名的域名（如`example.com`，用户仅需输入`user`）     |
| `ROUNDCUBEMAIL_REQUEST_PATH`      | `/`                 | 反向代理场景下的请求路径，详情见[defaults.inc.php](https://github.com/roundcube/roundcubemail/blob/master/config/defaults.inc.php) |

#### 5.1.2 功能与外观配置
| 环境变量                          | 默认值              | 说明                                                                 |
|-----------------------------------|---------------------|----------------------------------------------------------------------|
| `ROUNDCUBEMAIL_PLUGINS`           | `archive,zipdownload` | 启用的内置插件列表（逗号分隔）                                        |
| `ROUNDCUBEMAIL_INSTALL_PLUGINS`   | -                   | 设置为`1`或`true`启用启动时插件安装                                  |
| `ROUNDCUBEMAIL_SKIN`              | `elastic`           | 默认主题皮肤                                                         |
| `ROUNDCUBEMAIL_UPLOAD_MAX_FILESIZE` | `5M`               | 文件上传大小限制                                                     |
| `ROUNDCUBEMAIL_SPELLCHECK_URI`    | -                   | Google XML拼写检查API的完整URL（如`google-spell-pspell`服务）        |
| `ROUNDCUBEMAIL_ASPELL_DICTS`      | -                   | 要安装的aspell词典列表（逗号分隔，如`de,fr,pl`）                     |

#### 5.1.3 数据库配置
| 环境变量                          | 默认值              | 说明                                                                 |
|-----------------------------------|---------------------|----------------------------------------------------------------------|
| `ROUNDCUBEMAIL_DB_TYPE`           | `sqlite`            | 数据库类型：`mysql`、`pgsql`或`sqlite`                               |
| `ROUNDCUBEMAIL_DB_HOST`           | `mysql`/`postgres`  | 数据库主机名（默认值取决于数据库类型）                               |
| `ROUNDCUBEMAIL_DB_PORT`           | `3306`/`5432`       | 数据库端口（默认值取决于数据库类型）                                 |
| `ROUNDCUBEMAIL_DB_USER`           | `root`（MySQL）     | 数据库用户名                                                         |
| `ROUNDCUBEMAIL_DB_PASSWORD`       | -                   | 数据库密码                                                           |
| `ROUNDCUBEMAIL_DB_NAME`           | `roundcubemail`     | 数据库名称                                                           |


### 5.2 数据库连接配置

#### 5.2.1 SQLite（默认）
默认使用容器内SQLite数据库（路径`/var/roundcube/db`），适用于测试环境。生产环境需通过卷挂载持久化数据：
```sh
docker run -v roundcube-db:/var/roundcube/db -d docker.xuanyuan.run/roundcube/roundcubemail
```

#### 5.2.2 MySQL/PostgreSQL（推荐生产环境）
配置示例（MySQL）：
```sh
docker run \
  -e ROUNDCUBEMAIL_DB_TYPE=mysql \
  -e ROUNDCUBEMAIL_DB_HOST=mysql-host \
  -e ROUNDCUBEMAIL_DB_USER=roundcube \
  -e ROUNDCUBEMAIL_DB_PASSWORD=secret \
  -e ROUNDCUBEMAIL_DB_NAME=roundcube_db \
  -d docker.xuanyuan.run/roundcube/roundcubemail
```

> **注意**：启动前需确保数据库已存在，且用户具有表创建权限。


### 5.3 Docker Secrets支持（Swarm环境）

在Docker Swarm中，可通过Docker Secrets管理敏感信息，支持以下secrets：

| Secret名称                  | 对应环境变量                  | 用途                     |
|-----------------------------|-------------------------------|--------------------------|
| `roundcube_des_key`         | -                             | 用于加密的唯一随机密钥   |
| `roundcube_db_user`         | `ROUNDCUBEMAIL_DB_USER`       | 数据库用户名             |
| `roundcube_db_password`     | `ROUNDCUBEMAIL_DB_PASSWORD`   | 数据库密码               |
| `roundcube_oauth_client_secret` | `ROUNDCUBEMAIL_OAUTH_CLIENT_SECRET` | OAuth客户端密钥 |

使用示例：
```yaml
version: '3.8'
secrets:
  db_password:
    file: ./db_password.txt
services:
  roundcube:
    image: docker.xuanyuan.run/roundcube/roundcubemail
    secrets:
      - source: db_password
        target: roundcube_db_password
```


### 5.4 高级配置

#### 5.4.1 自定义配置文件
通过挂载目录到`/var/roundcube/config`，添加`*.php`文件实现配置覆盖（支持PHP语法）：
```sh
docker run -v ./custom-config:/var/roundcube/config -d docker.xuanyuan.run/roundcube/roundcubemail
```
> 配置参考：[Roundcube配置选项](https://github.com/roundcube/roundcubemail/wiki/Configuration)

#### 5.4.2 PHP参数调整
挂载PHP配置文件到`/usr/local/etc/php/conf.d/zzz_roundcube-custom.ini`自定义PHP设置：
```ini
# custom-php.ini
memory_limit = 128M
upload_max_filesize = 10M
```
启动命令：
```sh
docker run -v ./custom-php.ini:/usr/local/etc/php/conf.d/zzz_roundcube-custom.ini -d docker.xuanyuan.run/roundcube/roundcubemail
```


## 6. 持久数据管理

以下目录需通过卷挂载实现数据持久化或多实例共享：

| 路径                          | 用途描述                                                                 |
|-------------------------------|--------------------------------------------------------------------------|
| `/var/roundcube/db`           | SQLite数据库存储目录（仅SQLite模式需要）                                 |
| `/var/www/html`               | Roundcube安装根目录（含插件、皮肤等），FPM变体需与Web服务器共享此目录    |
| `/var/roundcube/config`       | 自定义配置文件目录（挂载后持久化配置）                                   |
| `/tmp/roundcube-temp`         | 临时文件目录（上传附件、缩略图等），多实例部署时需共享此目录             |

挂载示例（多目录持久化）：
```sh
docker run \
  -v roundcube-config:/var/roundcube/config \
  -v roundcube-temp:/tmp/roundcube-temp \
  -v roundcube-html:/var/www/html \
  -d docker.xuanyuan.run/roundcube/roundcubemail
```


## 7. 插件安装

通过环境变量启用插件安装：
```sh
docker run -e ROUNDCUBEMAIL_INSTALL_PLUGINS=1 -d docker.xuanyuan.run/roundcube/roundcubemail
```
> 插件安装逻辑在容器启动时执行，需确保网络通畅。


## 8. 使用方法

### 8.1 基本启动命令
```sh
docker run \
  -e ROUNDCUBEMAIL_DEFAULT_HOST=imap.example.com \
  -e ROUNDCUBEMAIL_SMTP_SERVER=smtp.example.com \
  -p 8000:80 \
  -d docker.xuanyuan.run/roundcube/roundcubemail
```
- 将`imap.example.com`和`smtp.example.com`替换为实际IMAP/SMTP服务器地址
- 访问`http://localhost:8000`打开Roundcube界面


### 8.2 Docker Compose示例（MySQL+Apache）
```yaml
version: '3.8'
services:
  roundcube:
    image: docker.xuanyuan.run/roundcube/roundcubemail:latest-apache
    ports:
      - "80:80"
    environment:
      - ROUNDCUBEMAIL_DEFAULT_HOST=imap.example.com
      - ROUNDCUBEMAIL_SMTP_SERVER=smtp.example.com
      - ROUNDCUBEMAIL_DB_TYPE=mysql
      - ROUNDCUBEMAIL_DB_HOST=mysql
      - ROUNDCUBEMAIL_DB_USER=roundcube
      - ROUNDCUBEMAIL_DB_PASSWORD=roundcube-pass
      - ROUNDCUBEMAIL_DB_NAME=roundcube
    volumes:
      - roundcube-temp:/tmp/roundcube-temp
      - roundcube-config:/var/roundcube/config
    depends_on:
      - mysql

  mysql:
    image: docker.xuanyuan.run/mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=root-pass
      - MYSQL_DATABASE=roundcube
      - MYSQL_USER=roundcube
      - MYSQL_PASSWORD=roundcube-pass
    volumes:
      - mysql-data:/var/lib/mysql

volumes:
  mysql-data:
  roundcube-temp:
  roundcube-config:
```


## 9. 构建自定义镜像

基于官方镜像扩展（例如添加Git和Composer）：
```dockerfile
FROM docker.xuanyuan.run/roundcube/roundcubemail:latest

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        git \
        composer \
    ; \
    rm -rf /var/lib/apt/lists/*
```
构建命令：
```sh
docker build -t custom-roundcube .
```


## 10. 示例配置

更多完整部署示例（如Nginx+FPM、PostgreSQL集成等）可参考官方仓库：  
[Roundcube Docker示例](https://github.com/roundcube/roundcubemail-docker/tree/master/examples)
