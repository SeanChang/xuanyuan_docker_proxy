---
image: serversideup/php
description: "适合生产环境的PHP Docker镜像，针对Laravel和WordPress进行了优化。"
source: https://xuanyuan.cloud/zh/r/serversideup/php
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[serversideup/php](https://xuanyuan.cloud/zh/r/serversideup/php)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# serversideup/php Docker 镜像文档

## 镜像概述和主要用途

`serversideup/php` 是一组优化的 Docker 镜像，专为在生产环境中运行 PHP 应用程序而设计。所有内容都围绕提升 PHP 和 Docker 的开发体验而构建，消除了不同环境配置差异导致的问题，确保代码在任何环境中都能一致运行。

这些镜像经过高度优化，可运行现代 PHP 应用程序，适用于 Laravel 和 WordPress 等框架，无论您希望在何处部署应用程序。

## 核心功能和特性

| 生产就绪 | 原生健康检查 | 高性能 |
|---------|------------|-------|
| 可定制和灵活 | 原生 CloudFlare 支持 | 基于官方 PHP |
| NGINX Unit | 统一日志记录 | FPM + S6 Overlay |

## 使用场景和适用范围

- 生产环境中运行现代 PHP 应用程序
- 需要一致开发、测试和生产环境的团队
- Laravel 和 WordPress 应用的部署
- 需要高性能和可靠性的 PHP 服务
- 希望简化 Docker 配置的开发和运维团队

## 镜像变体

该仓库提供多种 Docker 镜像变体，您可以根据需求选择：

| 变体类型        | 描述                                                                 |
|----------------|----------------------------------------------------------------------|
| cli            | PHP 命令行界面版本                                                    |
| fpm            | PHP-FPM (FastCGI 进程管理器) 版本                                      |
| fpm-apache     | PHP-FPM + Apache 服务器组合                                           |
| fpm-nginx      | PHP-FPM + NGINX 服务器组合                                            |
| unit           | NGINX Unit 版本 (轻量级应用服务器，支持动态配置)                       |

每种变体都提供 Debian 和 Alpine 两种基础镜像（部分变体），支持 PHP 7.4 到 8.4 版本。

## 使用方法和配置说明

### 基本用法

使用以下镜像名称模式：

```sh
serversideup/php:{{version}}-{{variation-name}}
```

例如，要使用 PHP 8.2 与 FPM + NGINX，可使用：

```sh
serversideup/php:8.2-fpm-nginx
```

所有镜像均在 [Docker Hub](https://hub.docker.com/r/serversideup/php/) 和 [GitHub Packages](https://github.com/serversideup/docker-php/pkgs/container/php) 上可用。

### 可用版本

#### CLI 变体
**Debian 基础**:
- serversideup/php:8.4-cli
- serversideup/php:8.3-cli
- serversideup/php:8.2-cli
- serversideup/php:8.1-cli
- serversideup/php:8.0-cli
- serversideup/php:7.4-cli

**Alpine 基础**:
- serversideup/php:8.4-cli-alpine
- serversideup/php:8.3-cli-alpine
- serversideup/php:8.2-cli-alpine
- serversideup/php:8.1-cli-alpine
- serversideup/php:8.0-cli-alpine
- serversideup/php:7.4-cli-alpine

#### FPM 变体
**Debian 基础**:
- serversideup/php:8.4-fpm
- serversideup/php:8.3-fpm
- serversideup/php:8.2-fpm
- serversideup/php:8.1-fpm
- serversideup/php:8.0-fpm
- serversideup/php:7.4-fpm

**Alpine 基础**:
- serversideup/php:8.4-fpm-alpine
- serversideup/php:8.3-fpm-alpine
- serversideup/php:8.2-fpm-alpine
- serversideup/php:8.1-fpm-alpine
- serversideup/php:8.0-fpm-alpine
- serversideup/php:7.4-fpm-alpine

#### FPM-Apache 变体
**Debian 基础**:
- serversideup/php:8.4-fpm-apache
- serversideup/php:8.3-fpm-apache
- serversideup/php:8.2-fpm-apache
- serversideup/php:8.1-fpm-apache
- serversideup/php:8.0-fpm-apache
- serversideup/php:7.4-fpm-apache

#### FPM-NGINX 变体
**Debian 基础**:
- serversideup/php:8.4-fpm-nginx
- serversideup/php:8.3-fpm-nginx
- serversideup/php:8.2-fpm-nginx
- serversideup/php:8.1-fpm-nginx
- serversideup/php:8.0-fpm-nginx
- serversideup/php:7.4-fpm-nginx

**Alpine 基础**:
- serversideup/php:8.4-fpm-nginx-alpine
- serversideup/php:8.3-fpm-nginx-alpine
- serversideup/php:8.2-fpm-nginx-alpine
- serversideup/php:8.1-fpm-nginx-alpine
- serversideup/php:8.0-fpm-nginx-alpine
- serversideup/php:7.4-fpm-nginx-alpine

#### Unit 变体
**Debian 基础**:
- serversideup/php:8.4-unit
- serversideup/php:8.3-unit
- serversideup/php:8.2-unit
- serversideup/php:8.1-unit
- serversideup/php:8.0-unit
- serversideup/php:7.4-unit

### Docker Run 示例

使用 PHP 8.2 FPM-NGINX 变体运行简单的 PHP 应用：

```bash
docker run -d \
  --name php-app \
  -p 80:80 \
  -v $(pwd):/var/www/html \
  serversideup/php:8.2-fpm-nginx
```

### Docker Compose 示例

以下是使用 Laravel 应用的 docker-compose.yml 示例：

```yaml
version: '3.8'

services:
  app:
    image: serversideup/php:8.2-fpm-nginx
    container_name: laravel-app
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    environment:
      - PHP_MEMORY_LIMIT=512M
      - PHP_MAX_EXECUTION_TIME=60
      - APP_ENV=production
      - APP_KEY=base64:your-app-key-here
      - DB_HOST=db
      - DB_DATABASE=laravel
      - DB_USERNAME=laraveluser
      - DB_PASSWORD=laravelpassword
    volumes:
      - ./:/var/www/html
      - ./docker/nginx/conf.d:/etc/nginx/conf.d
      - ./docker/php/custom.ini:/etc/php.d/custom.ini
    depends_on:
      - db

  db:
    image: mysql:8.0
    container_name: laravel-db
    restart: unless-stopped
    environment:
      - MYSQL_DATABASE=laravel
      - MYSQL_USER=laraveluser
      - MYSQL_PASSWORD=laravelpassword
      - MYSQL_ROOT_PASSWORD=rootpassword
    volumes:
      - mysql-data:/var/lib/mysql

volumes:
  mysql-data:
```

### 环境变量配置

虽然完整的环境变量列表未在文档中详细列出，但以下是一些常用的 PHP 配置环境变量：

| 环境变量               | 描述                     | 默认值      |
|------------------------|--------------------------|-------------|
| PHP_MEMORY_LIMIT       | PHP 内存限制             | 256M        |
| PHP_MAX_EXECUTION_TIME | PHP 最大执行时间（秒）   | 30          |
| PHP_POST_MAX_SIZE      | POST 数据最大大小        | 8M          |
| PHP_UPLOAD_MAX_FILESIZE| 上传文件最大大小         | 2M          |

您还可以通过挂载自定义 PHP 配置文件来覆盖默认设置：

```bash
-v ./custom.ini:/etc/php.d/custom.ini
```

## 专业支持

- **托管服务**：CI/CD 设计与工程、托管服务、保证正常运行时间
- **专业帮助**：通过视频和屏幕共享直接获得核心贡献者的帮助
- **全栈开发团队**：从基础构建您的应用，或帮助您现有的代码库

## 镜像特性详解

### 生产就绪
这些镜像包含生产环境所需的所有配置和安全强化，无需额外调整即可用于生产环境。

### 高性能
针对 PHP 应用进行了优化，包括适当的缓存配置、进程管理和资源分配。

### 统一日志记录
所有服务日志统一输出到标准输出，便于 Docker 日志收集和集中管理。

### 原生健康检查
内置健康检查功能，可与 Docker 的健康检查机制集成，确保服务正常运行。

### 灵活定制
支持通过环境变量、配置文件挂载或构建自定义镜像来定制 PHP 和 Web 服务器配置。

## 注意事项

- 所有镜像均定期更新以包含最新的安全补丁
- Alpine 变体通常体积更小，但可能缺少某些 Debian 软件包
- 生产环境中建议使用特定版本标签而非 `latest`，以确保一致性
- 对于高流量应用，建议适当调整 PHP-FPM 进程数和内存限制
