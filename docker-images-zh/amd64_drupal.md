---
image: amd64/drupal
description: "Drupal是一款开源内容管理平台，支持数百万网站和应用的运行。"
source: https://xuanyuan.cloud/zh/r/amd64/drupal
canonical: https://xuanyuan.cloud/zh/r/amd64/drupal
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amd64/drupal" title="amd64/drupal Docker 镜像中文简介、标签列表与拉取命令">amd64/drupal — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/amd64/drupal" title="amd64/drupal Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/amd64/drupal</a>

# Drupal Docker 镜像文档

## 镜像概述与主要用途

Drupal 是一个免费开源的内容管理框架，使用 PHP 编写并基于 GNU 通用公共许可证发布。它被用作后端框架，支持全球至少 2.1% 的网站，涵盖个人博客、企业网站、政治和政府站点（如 WhiteHouse.gov 和 data.gov.uk），也广泛用于知识管理和业务协作。

本 Docker 镜像是 Drupal 官方镜像的 `amd64` 架构专用版本，提供了便捷的 Drupal 应用部署方式，适用于快速搭建开发、测试和生产环境。

## 核心功能与特性

- **多数据库支持**：兼容 SQLite（默认，无需额外容器）、MySQL、PostgreSQL 等主流数据库
- **跨架构兼容**：支持 `amd64`、`arm32v6`、`arm32v7`、`arm64v8`、`i386`、`ppc64le`、`riscv64`、`s390x` 等架构
- **灵活部署**：支持独立容器运行、Docker 网络集成、数据卷挂载等多种部署模式
- **镜像变体**：提供基础版本和 FPM 版本，满足不同 Web 服务器架构需求
- **可扩展性**：支持通过自定义 Dockerfile 添加 PHP 扩展和额外依赖库
- **安全可控**：支持以非 root 用户运行，遵循 Docker 安全最佳实践

## 支持的标签

> 注意：由于镜像描述长度超过 Hub 25000 字符限制，"支持的标签"列表已被精简。完整标签列表请参见：  
> [https://github.com/docker-library/docs/tree/master/drupal/README.md#supported-tags-and-respective-dockerfile-links](https://github.com/docker-library/docs/tree/master/drupal/README.md#supported-tags-and-respective-dockerfile-links)

## 使用场景与适用范围

- **个人博客**：快速搭建个人内容发布平台
- **企业网站**：构建企业官网、产品展示平台
- **政府与机构站点**：满足高安全性和可扩展性需求的官方网站
- **开发环境**：为 Drupal 主题、模块开发提供隔离的开发环境
- **生产环境**：通过配合数据库容器和反向代理，构建稳定的生产系统
- **知识管理系统**：搭建企业内部文档协作平台

## 详细使用方法与配置说明

### 基本使用

启动一个基础的 Drupal 实例：

```console
$ docker run --name some-drupal -d amd64/drupal
```

如需从主机访问容器服务，可映射端口：

```console
$ docker run --name some-drupal -p 8080:80 -d amd64/drupal
```

通过浏览器访问 `http://localhost:8080` 或 `http://主机IP:8080` 即可进入 Drupal 初始设置界面。首次访问时需完成安装向导，其中"数据库设置"步骤需根据实际数据库配置填写。

### 数据库配置

#### MySQL

1. 启动 MySQL 容器并配置环境变量：

```console
$ docker run -d --name some-mysql --network some-network \
    -e MYSQL_DATABASE=drupal \
    -e MYSQL_USER=user \
    -e MYSQL_PASSWORD=password \
    -e MYSQL_ROOT_PASSWORD=password \
mysql:5.7
```

2. 在 Drupal 安装向导的"数据库设置"步骤中填写：
   - 数据库类型：MySQL
   - 数据库名称：`drupal`（对应 `MYSQL_DATABASE`）
   - 数据库用户名：`user`（对应 `MYSQL_USER`）
   - 数据库密码：`password`（对应 `MYSQL_PASSWORD`）
   - 高级选项 > 数据库主机：`some-mysql`（同一 Docker 网络内的容器可通过容器名访问）

#### PostgreSQL

1. 启动 PostgreSQL 容器并配置环境变量：

```console
$ docker run -d --name some-postgres --network some-network \
    -e POSTGRES_DB=drupal \
    -e POSTGRES_USER=user \
    -e POSTGRES_PASSWORD=pass \
postgres:11
```

2. 在 Drupal 安装向导的"数据库设置"步骤中填写：
   - 数据库类型：PostgreSQL
   - 数据库名称：`drupal`（对应 `POSTGRES_DB`）
   - 数据库用户名：`user`（对应 `POSTGRES_USER`）
   - 数据库密码：`pass`（对应 `POSTGRES_PASSWORD`）
   - 高级选项 > 数据库主机：`some-postgres`（同一 Docker 网络内的容器可通过容器名访问）

### 数据卷管理

Drupal 的模块、主题、配置等数据建议通过数据卷持久化存储。以下是两种常用方案：

#### 方案一：使用绑定挂载（Bind Mounts）

1. 首先导出容器内的初始 `sites` 目录到主机：

```console
$ docker run --rm amd64/drupal tar -cC /var/www/html/sites . | tar -xC /path/on/host/sites
```

2. 启动容器并挂载目录：

```console
$ docker run --name some-drupal --network some-network -d \
    -v /path/on/host/modules:/var/www/html/modules \
    -v /path/on/host/profiles:/var/www/html/profiles \
    -v /path/on/host/sites:/var/www/html/sites \
    -v /path/on/host/themes:/var/www/html/themes \
    amd64/drupal
```

#### 方案二：使用 Docker 数据卷（Volumes）

1. 创建数据卷并初始化 `sites` 目录：

```console
$ docker volume create drupal-sites
$ docker run --rm -v drupal-sites:/temporary/sites amd64/drupal cp -aRT /var/www/html/sites /temporary/sites
```

2. 启动容器并挂载数据卷：

```console
$ docker run --name some-drupal --network some-network -d \
    -v drupal-modules:/var/www/html/modules \
    -v drupal-profiles:/var/www/html/profiles \
    -v drupal-sites:/var/www/html/sites \
    -v drupal-themes:/var/www/html/themes \
    amd64/drupal
```

### 使用 docker compose 部署

创建 `compose.yaml` 文件：

```yaml
# Drupal with PostgreSQL
# 访问地址: "http://localhost:8080"
# 初始设置时数据库配置：
# - 数据库类型: PostgreSQL
# - 数据库名称: postgres
# - 数据库用户名: postgres
# - 数据库密码: example
# - 高级选项 > 数据库主机: postgres

services:
  drupal:
    image: amd64/drupal:10-apache
    ports:
      - 8080:80
    volumes:
      - /var/www/html/modules
      - /var/www/html/profiles
      - /var/www/html/themes
      - /var/www/html/sites  # 匿名卷会自动用镜像内内容初始化
    restart: always

  postgres:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: example
    restart: always
```

启动服务：

```console
$ docker compose up -d
```

### 添加额外库/扩展

本镜像默认不包含额外的 PHP 扩展。如需添加，可基于本镜像创建自定义 Dockerfile，参考 [php 镜像文档](https://github.com/docker-library/docs/blob/master/php/README.md#how-to-install-more-php-extensions) 中的方法编译安装扩展。示例 Dockerfile：

```dockerfile
FROM amd64/drupal:10-apache

# 安装 gd 扩展示例
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd
```

### 以非 root 用户运行

参考 [php 镜像文档中的"以非 root 用户运行"部分](https://hub.docker.com/_/php/)，可通过设置 `--user` 参数或在 Dockerfile 中配置用户来实现。

## 镜像变体

### amd64/drupal:\<version>

默认镜像，基于 Apache 和 PHP 构建，适用于大多数场景。标签中的 `bookworm`、`trixie` 等为 Debian 发行版代号，指定了镜像的基础系统版本。如需安装额外系统包，建议显式指定发行版代号以避免兼容性问题。

### amd64/drupal:\<version>-fpm

包含 PHP FastCGI 进程管理器（FPM）的变体，需配合反向代理（如 NGINX、Apache）使用。**警告**：FastCGI 协议本身不提供安全保护，除非明确了解风险，否则不要使用 `-p` 参数将 FPM 端口暴露到外部网络。

使用示例（配合 NGINX）：

1. 创建网络：`docker network create drupal-network`
2. 启动 FPM 容器：`docker run --name drupal-fpm --network drupal-network -d amd64/drupal:10-fpm`
3. 配置 NGINX 反向代理到 `drupal-fpm:9000`

## 许可证信息

本镜像包含的 Drupal 软件遵循 [GNU 通用公共许可证](https://www.drupal.org/licensing/faq)。

与所有 Docker 镜像一样，本镜像可能包含其他软件（如 Bash、基础系统组件等），这些软件可能具有不同的许可证。更多许可证信息可在 [repo-info 仓库的 drupal 目录](https://github.com/docker-library/repo-info/tree/master/repos/drupal) 中找到。

使用本镜像即表示您同意遵守其中包含的所有软件的相关许可证条款。

---

**维护者**：[Docker 社区](https://github.com/docker-library/drupal)（非 Drupal 社区或 Drupal 安全团队）  
**获取帮助**：[Docker 社区 Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)  
**提交问题**：[https://github.com/docker-library/drupal/issues](https://github.com/docker-library/drupal/issues?q=)
