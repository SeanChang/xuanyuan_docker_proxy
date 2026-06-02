---
image: hyperf/hyperf
description: "Hyperf官方提供的Docker镜像，用于运行基于Hyperf框架的高性能PHP协程应用，支持API及微服务开发部署。"
source: https://xuanyuan.cloud/zh/r/hyperf/hyperf
canonical: https://xuanyuan.cloud/zh/r/hyperf/hyperf
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hyperf/hyperf" title="hyperf/hyperf Docker 镜像中文简介、标签列表与拉取命令">hyperf/hyperf — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/hyperf/hyperf" title="hyperf/hyperf Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/hyperf/hyperf</a>

# Hyperf Docker 镜像文档


## 1. 镜像概述与主要用途

Hyperf Docker 镜像是 Hyperf 框架官方提供的容器化解决方案，旨在简化 Hyperf 应用的部署与运行流程。Hyperf 是基于 Swoole 的高性能 PHP 协程框架，该镜像预集成了 Hyperf 运行所需的环境依赖、PHP 扩展及运行时（Swoole/Swow），支持多版本 PHP、多基础镜像及轻量级部署，适用于快速搭建 Hyperf 开发环境与生产环境。


## 2. 核心功能与特性

### 2.1 多版本与运行时支持
- **PHP 版本**：支持 7.3、7.4、8.0（推荐 7.4）
- **基础镜像**：支持 Alpine、Ubuntu（推荐 Alpine，轻量级）
- **Alpine 版本**：支持 3.10、3.11、3.12（推荐 3.12）
- **运行时**：支持 `base`（基础环境）、`dev`（开发环境）、`swoole`（Swoole 运行时）、`swow`（Swow 运行时）
- **Swoole/Swow 版本**：支持指定版本（如 `v4.5.5`）


### 2.2 预装 PHP 扩展
基础镜像已集成以下常用 PHP 扩展，满足 Hyperf 核心功能需求：

```
[PHP Modules]
bcmath、Core、ctype、curl、date、dom、fileinfo、filter、gd、hash、iconv、json、libxml、mbstring、mysqlnd、openssl、pcntl、pcre、PDO、pdo_mysql、pdo_sqlite、Phar、posix、readline、redis、Reflection、session、SimpleXML、sockets、sodium、SPL、standard、sysvmsg、sysvsem、sysvshm、tokenizer、xml、xmlreader、xmlwriter、Zend OPcache、zip、zlib

[Zend Modules]
Zend OPcache
```


### 2.3 轻量级与高性能
基于 Alpine 基础镜像构建，体积小、资源占用低，结合 Swoole/Swow 协程运行时，可充分发挥 Hyperf 的高性能特性。


## 3. 使用场景与适用范围
- **开发环境**：快速搭建统一的 Hyperf 开发环境，避免依赖冲突
- **生产环境**：部署基于 Swoole/Swow 的 Hyperf 应用，支持高并发场景
- **多场景适配**：适用于 API 服务、微服务、后台任务、WebSocket 服务等 Hyperf 应用场景
- **扩展灵活**：支持通过 Dockerfile 扩展安装额外 PHP 扩展（如 Kafka、MongoDB 等）


## 4. 标签说明

### 4.1 标签格式
镜像标签由以下部分组成，各部分含义如下：
```
{PHP版本}-{基础镜像}-v{Alpine版本}-{运行时}-{Swoole/Swow版本}
```
- `PHP版本`：如 `7.3`、`7.4`、`8.0`（必填）
- `基础镜像`：`alpine` 或 `ubuntu`（必填）
- `Alpine版本`：如 `v3.11`、`v3.12`（基础镜像为 Alpine 时必填）
- `运行时`：`base`、`dev`、`swoole`、`swow`（必填）
- `Swoole/Swow版本`：如 `v4.5.5`（可选，默认使用最新稳定版）


### 4.2 支持的标签及 Dockerfile 链接
| 标签格式                          | 说明                     | Dockerfile 链接                                                                 |
|-----------------------------------|--------------------------|--------------------------------------------------------------------------------|
| `7.3-alpine-v3.11-swoole-*`       | PHP 7.3 + Swoole         | [链接](https://github.com/hyperf-cloud/hyperf-docker/blob/master/7.3/alpine/swoole/Dockerfile) |
| `7.3-alpine-v3.11-swow-*`         | PHP 7.3 + Swow           | [链接](https://github.com/hyperf-cloud/hyperf-docker/blob/master/7.3/alpine/swow/Dockerfile)   |
| `7.3-alpine-v3.11-base`           | PHP 7.3 基础环境         | [链接](https://github.com/hyperf-cloud/hyperf-docker/blob/master/7.3/alpine/base/Dockerfile)   |
| `7.4-alpine-v3.12-swoole-*`       | PHP 7.4 + Swoole         | [链接](https://github.com/hyperf-cloud/hyperf-docker/blob/master/7.4/alpine/swoole/Dockerfile) |
| `7.4-alpine-v3.12-swow-*`         | PHP 7.4 + Swow           | [链接](https://github.com/hyperf-cloud/hyperf-docker/blob/master/7.4/alpine/swoole/Dockerfile) |
| `7.4-alpine-v3.12-base`           | PHP 7.4 基础环境         | [链接](https://github.com/hyperf-cloud/hyperf-docker/blob/master/7.4/alpine/base/Dockerfile)   |
| `8.0-alpine-v3.12-swoole-*`       | PHP 8.0 + Swoole         | [链接](https://github.com/hyperf-cloud/hyperf-docker/blob/master/8.0/alpine/swoole/Dockerfile) |
| `8.0-alpine-v3.12-swow-*`         | PHP 8.0 + Swow           | [链接](https://github.com/hyperf-cloud/hyperf-docker/blob/master/8.0/alpine/swoole/Dockerfile) |
| `8.0-alpine-v3.12-base`           | PHP 8.0 基础环境         | [链接](https://github.com/hyperf-cloud/hyperf-docker/blob/master/8.0/alpine/base/Dockerfile)   |


## 5. 使用方法与配置说明

### 5.1 基础使用

#### 步骤 1：创建项目 Dockerfile
在 Hyperf 项目根目录创建 `Dockerfile`，示例如下（以 `7.4-alpine-v3.12-swoole` 为例）：
```dockerfile
FROM hyperf/hyperf:7.4-alpine-v3.12-swoole

# 设置工作目录
WORKDIR /opt/www

# 复制项目代码
COPY . .

# 安装依赖
RUN composer install --no-dev -o

# 启动命令（根据 Hyperf 应用类型调整）
CMD ["php", "bin/hyperf.php", "start"]
```


#### 步骤 2：构建镜像
```bash
docker build -t hyperf-app .
```


#### 步骤 3：运行容器
```bash
docker run -d -p 9501:9501 --name hyperf-container hyperf-app
```
- `-p 9501:9501`：映射 Hyperf 默认端口
- `--name hyperf-container`：指定容器名称


### 5.2 Docker Compose 配置示例
创建 `docker-compose.yml`，适合多服务部署（如配合 MySQL、Redis）：
```yaml
version: '3.8'

services:
  hyperf:
    build: .
    image: hyperf-app
    container_name: hyperf-app
    ports:
      - "9501:9501"
    volumes:
      - ./:/opt/www  # 开发环境挂载代码目录，实时更新
    depends_on:
      - mysql
      - redis
    environment:
      - APP_ENV=prod
      - DB_HOST=mysql
      - REDIS_HOST=redis

  mysql:
    image: mysql:5.7
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=hyperf
    ports:
      - "3306:3306"

  redis:
    image: redis:alpine
    ports:
      - "6379:6379"
```

启动服务：
```bash
docker-compose up -d
```


### 5.3 扩展安装示例
通过 Dockerfile 安装额外 PHP 扩展，满足特定业务需求。


#### 5.3.1 Kafka 扩展
```dockerfile
RUN apk add --no-cache librdkafka-dev \
    && pecl install rdkafka \
    && echo "extension=rdkafka.so" > /etc/php7/conf.d/rdkafka.ini
```


#### 5.3.2 MongoDB 扩展
```dockerfile
RUN apk add --no-cache openssl-dev \
    && pecl install mongodb \
    && echo "extension=mongodb.so" > /etc/php7/conf.d/mongodb.ini
```


#### 5.3.3 Protobuf 扩展
```dockerfile
RUN apk add --no-cache protobuf \
    && pecl install protobuf \
    && echo "extension=protobuf.so" > /etc/php7/conf.d/protobuf.ini
```


#### 5.3.4 Swoole Tracker（性能监控）
```dockerfile
# 下载并安装 Swoole Tracker
ADD ./swoole-tracker-install.sh /tmp
RUN chmod +x /tmp/swoole-tracker-install.sh \
    && cd /tmp \
    && ./swoole-tracker-install.sh \
    && rm /tmp/swoole-tracker-install.sh \
    # 配置扩展
    && cp /tmp/swoole-tracker/swoole_tracker72.so /usr/lib/php7/modules/swoole_tracker72.so \
    && echo "extension=swoole_tracker72.so" > /etc/php7/conf.d/swoole-tracker.ini \
    && echo "apm.enable=1" >> /etc/php7/conf.d/swoole-tracker.ini \
    && echo "apm.sampling_rate=100" >> /etc/php7/conf.d/swoole-tracker.ini \
    && echo "apm.enable_memcheck=1" >> /etc/php7/conf.d/swoole-tracker.ini \
    # 启动 Agent
    && printf '#!/bin/sh\n/opt/swoole/script/php/swoole_php /opt/swoole/node-agent/src/node.php' > /opt/swoole/entrypoint.sh \
    && chmod 755 /opt/swoole/entrypoint.sh
```


#### 5.3.5 修复阿里云 OSS 字符集问题
```dockerfile
# 安装 gnu-libiconv 解决字符集问题
RUN apk --no-cache --allow-untrusted --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ add gnu-libiconv=1.15-r2
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so
```


## 6. 参考链接
- [Hyperf 官方 GitHub](https://github.com/hyperf)
- [Hyperf 官方文档](https://doc.hyperf.io)
- [Hyperf Docker 镜像源码](https://github.com/hyperf-cloud/hyperf-docker)
