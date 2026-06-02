---
image: library/wordpress
description: "WordPress作为全球广泛使用的开源平台，是一款功能丰富的内容管理系统，它能够通过灵活运用各类插件、实用小工具及多样化主题，帮助用户轻松构建个性化网站、高效管理图文影音等各类内容，并根据需求自定义界面风格与功能模块，满足从个人博客到企业站点的不同场景应用需求。"
source: https://xuanyuan.cloud/zh/r/library/wordpress
canonical: https://xuanyuan.cloud/zh/r/library/wordpress
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/wordpress" title="library/wordpress Docker 镜像中文简介、标签列表与拉取命令">library/wordpress — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/wordpress" title="library/wordpress Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/wordpress</a>

# WordPress Docker 镜像使用指南


## 快速参考

### 维护者  
Docker 社区（[GitHub 仓库]([])）

### 获取帮助  
- Docker Community Slack（[加入链接]([])）  
- Server Fault（[相关主题]([])）  
- Unix & Linux（[相关主题]([])）  
- Stack Overflow（[相关主题]([])）  


## 支持的标签及对应 Dockerfile 链接  

### PHP 8.1 系列  
- **Apache 服务器**：`6.8.3-php8.1-apache`、`6.8-php8.1-apache`、`6-php8.1-apache`、`php8.1-apache`、`6.8.3-php8.1`、`6.8-php8.1`、`6-php8.1`、`php8.1`（[Dockerfile]([])）  
- **FPM 模式**：`6.8.3-php8.1-fpm`、`6.8-php8.1-fpm`、`6-php8.1-fpm`、`php8.1-fpm`（[Dockerfile]([])）  
- **Alpine FPM 模式**：`6.8.3-php8.1-fpm-alpine`、`6.8-php8.1-fpm-alpine`、`6-php8.1-fpm-alpine`、`php8.1-fpm-alpine`（[Dockerfile]([])）  


### PHP 8.2 系列  
- **Apache 服务器**：`6.8.3-php8.2-apache`、`6.8-php8.2-apache`、`6-php8.2-apache`、`php8.2-apache`、`6.8.3-php8.2`、`6.8-php8.2`、`6-php8.2`、`php8.2`（[Dockerfile]([])）  
- **FPM 模式**：`6.8.3-php8.2-fpm`、`6.8-php8.2-fpm`、`6-php8.2-fpm`、`php8.2-fpm`（[Dockerfile]([])）  
- **Alpine FPM 模式**：`6.8.3-php8.2-fpm-alpine`、`6.8-php8.2-fpm-alpine`、`6-php8.2-fpm-alpine`、`php8.2-fpm-alpine`（[Dockerfile]([])）  


### PHP 8.3 系列（含默认标签）  
- **Apache 服务器**：`6.8.3-apache`、`6.8-apache`、`6-apache`、`apache`、`6.8.3`、`6.8`、`6`、`latest`、`6.8.3-php8.3-apache`、`6.8-php8.3-apache`、`6-php8.3-apache`、`php8.3-apache`、`6.8.3-php8.3`、`6.8-php8.3`、`6-php8.3`、`php8.3`（[Dockerfile]([])）  
- **FPM 模式**：`6.8.3-fpm`、`6.8-fpm`、`6-fpm`、`fpm`、`6.8.3-php8.3-fpm`、`6.8-php8.3-fpm`、`6-php8.3-fpm`、`php8.3-fpm`（[Dockerfile]([])）  
- **Alpine FPM 模式**：`6.8.3-fpm-alpine`、`6.8-fpm-alpine`、`6-fpm-alpine`、`fpm-alpine`、`6.8.3-php8.3-fpm-alpine`、`6.8-php8.3-fpm-alpine`、`6-php8.3-fpm-alpine`、`php8.3-fpm-alpine`（[Dockerfile]([])）  


### PHP 8.4 系列  
- **Apache 服务器**：`6.8.3-php8.4-apache`、`6.8-php8.4-apache`、`6-php8.4-apache`、`php8.4-apache`、`6.8.3-php8.4`、`6.8-php8.4`、`6-php8.4`、`php8.4`（[Dockerfile]([])）  
- **FPM 模式**：`6.8.3-php8.4-fpm`、`6.8-php8.4-fpm`、`6-php8.4-fpm`、`php8.4-fpm`（[Dockerfile]([])）  
- **Alpine FPM 模式**：`6.8.3-php8.4-fpm-alpine`、`6.8-php8.4-fpm-alpine`、`6-php8.4-fpm-alpine`、`php8.4-fpm-alpine`（[Dockerfile]([])）  


### CLI 版本（WP-CLI）  
- `cli-2.12.0-php8.1`、`cli-2.12-php8.1`、`cli-2-php8.1`、`cli-php8.1`（[Dockerfile]([])）  
- `cli-2.12.0-php8.2`、`cli-2.12-php8.2`、`cli-2-php8.2`、`cli-php8.2`（[Dockerfile]([])）  
- `cli-2.12.0`、`cli-2.12`、`cli-2`、`cli`、`cli-2.12.0-php8.3`、`cli-2.12-php8.3`、`cli-2-php8.3`、`cli-php8.3`（[Dockerfile]([])）  
- `cli-2.12.0-php8.4`、`cli-2.12-php8.4`、`cli-2-php8.4`、`cli-php8.4`（[Dockerfile]([])）  


## 快速参考（续）  

### 提交 issue  
[GitHub 仓库 issues 页面]([])  


### 支持的架构  
（[更多信息]([])）  
- `amd64`（[Docker Hub]([])）  
- `arm32v5`（[Docker Hub]([])）  
- `arm32v6`（[Docker Hub]([])）  
- `arm32v7`（[Docker Hub]([])）  
- `arm64v8`（[Docker Hub]([])）  
- `i386`（[Docker Hub]([])）  
- `ppc64le`（[Docker Hub]([])）  
- `riscv64`（[Docker Hub]([])）  
- `s390x`（[Docker Hub]([])）  


### 镜像 artifact 详情  
[repo-info 仓库的 `repos/wordpress/` 目录]([])（[历史记录]([])）  
（包含镜像元数据、传输大小等信息）  


### 镜像更新  
- [official-images 仓库的 `library/wordpress` 标签]([])  
- [official-images 仓库的 `library/wordpress` 文件]([])（[历史记录]([])）  


### 描述来源  
[docs 仓库的 `wordpress/` 目录]([])（[历史记录]([])）  


## 什么是 WordPress？  

WordPress 是一款免费开源的博客工具和内容管理系统（CMS），基于 PHP 和 MySQL 构建，需运行在 Web  hosting 服务上。它支持插件架构和模板系统，截至 2013 年 8 月，全球前 1000 万个网站中超过 22.0% 使用 WordPress，是目前 Web 上最流行的博客系统，已被用于超过 6000 万个网站，主要使用语言包括英语、西班牙语和印尼语。  

> [.org/wiki/WordPress]()  

![WordPress 标志]([])  


## 如何使用本镜像  


### 基本运行命令  
```console
$ docker run --name some-wordpress --network some-network -d wordpress
```  


### 环境变量配置  
通过环境变量可配置 WordPress 实例（基于 [自定义 `wp-config.php` 实现]([])）：  
- `WORDPRESS_DB_HOST`：数据库主机地址  
- `WORDPRESS_DB_USER`：数据库用户名  
- `WORDPRESS_DB_PASSWORD`：数据库密码  
- `WORDPRESS_DB_NAME`：数据库名称（需预先存在，容器不会自动创建）  
- `WORDPRESS_TABLE_PREFIX`：数据库表前缀  
- 安全密钥（如 `WORDPRESS_AUTH_KEY`、`WORDPRESS_SECURE_AUTH_KEY` 等）：默认随机生成，若提供其他环境变量则需显式设置  
- `WORDPRESS_DEBUG=1`：启用调试模式（默认禁用）  
- `WORDPRESS_CONFIG_EXTRA`：额外配置代码（通过 `eval()` 执行，可用于设置 `WP_ALLOW_MULTISITE` 等）  


### 端口映射  
若需从主机直接访问容器，可映射端口：  
```console
$ docker run --name some-wordpress -p 8080:80 -d wordpress
```  
访问 `[] 或 `[] 即可打开 WordPress。  


### 反向代理配置  
若 WordPress 部署在 TLS 反向代理（如 NGINX）后，需设置 `X-Forwarded-Proto`（参考 [WordPress 文档]([])）。本镜像会自动在 `wp-config.php` 中添加相关代码（当上述环境变量被设置时）。  


### Docker Secrets  
敏感信息可通过 `_FILE` 后缀的环境变量从文件加载（如 Docker Secrets），例如：  
```console
$ docker run --name some-wordpress -e WORDPRESS_DB_PASSWORD_FILE=/run/secrets/mysql-root ... -d wordpress:tag
```  
支持的变量包括 `WORDPRESS_DB_HOST`、`WORDPRESS_DB_USER`、`WORDPRESS_DB_PASSWORD` 等（完整列表见原始文档）。  


### 使用 docker compose  
创建 `compose.yaml` 文件：  
```yaml
services:
  wordpress:
    image: wordpress
    restart: always
    ports:
      - 8080:80
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: exampleuser
      WORDPRESS_DB_PASSWORD: examplepass
      WORDPRESS_DB_NAME: exampledb
    volumes:
      - wordpress:/var/www/html

  db:
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_DATABASE: exampledb
      MYSQL_USER: exampleuser
      MYSQL_PASSWORD: examplepass
      MYSQL_RANDOM_ROOT_PASSWORD: '1'
    volumes:
      - db:/var/lib/mysql

volumes:
  wordpress:
  db:
```  
运行 `docker compose up`，完成后访问 `[]  


### 添加额外库/扩展  
本镜像不含额外 PHP 扩展（如邮件发送功能）。如需添加，需基于本镜像构建新镜像，参考 [php 镜像文档]([])。  


### 预装主题/插件  
- **运行时挂载**：将主题/插件目录挂载到 `/var/www/html/wp-content/themes/` 或 `/var/www/html/wp-content/plugins/`。  
- **构建时集成**：构建镜像时，将主题/插件放在 `/usr/src/wordpress/wp-content/`（容器首次启动时会复制
