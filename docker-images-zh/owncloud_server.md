---
image: owncloud/server
description: "ownCloud是一个安全的协作平台，提供文件存储、共享及团队协作功能。"
source: https://xuanyuan.cloud/zh/r/owncloud/server
canonical: https://xuanyuan.cloud/zh/r/owncloud/server
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/owncloud/server" title="owncloud/server Docker 镜像中文简介、标签列表与拉取命令">owncloud/server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ownCloud 服务器 Docker 镜像

[![构建状态](https://drone.owncloud.com/api/badges/owncloud-docker/server/status.svg)](https://drone.owncloud.com/owncloud-docker/server)
[![Docker Hub](https://img.shields.io/docker/v/owncloud/server?logo=docker&label=dockerhub&sort=semver&logoColor=white)](https://hub.docker.com/r/owncloud/server)
[![GitHub 贡献者](https://img.shields.io/github/contributors/owncloud-docker/server)](https://github.com/owncloud-docker/server/graphs/contributors)
[![源代码：GitHub](https://img.shields.io/badge/source-github-blue.svg?logo=github&logoColor=white)](https://github.com/owncloud-docker/server)
[![许可：MIT](https://img.shields.io/github/license/owncloud-docker/server)](https://github.com/owncloud-docker/server/blob/master/LICENSE)

官方 [ownCloud](https://owncloud.com) Docker 镜像。设计用于配合主机文件系统中的数据卷，以及独立的 MariaDB 和 Redis 容器工作。有关快速入门指南，请参阅我们的 [文档](https://doc.owncloud.com/server/latest/admin_manual/installation/docker/)。

## 关于 ownCloud

ownCloud 是一款开源文件同步、共享和内容协作软件，让团队可从任何地点、任何设备轻松处理数据。它通过 Web 界面、同步客户端或 WebDAV 提供数据访问，同时提供跨设备轻松查看、同步和共享的平台 - 所有这些都在您的控制之下。ownCloud 的开放架构可通过简单但强大的应用程序和插件 API 进行扩展，并且可与任何存储系统兼容。

![ownCloud 的安全内容协作和文件共享](https://raw.githubusercontent.com/owncloud-docker/server/master/images/Home-UI.png)

## 使用场景和适用范围

ownCloud 服务器镜像适用于以下场景：

- **团队协作**：团队成员需要从任何地点、任何设备访问和协作处理数据，通过 Web 界面或客户端同步文件。
- **个人文件同步**：个人用户需要跨设备（如电脑、手机、平板）同步文件，确保数据随时随地可用且安全存储。
- **企业数据管理**：企业需要在自有基础设施控制下管理文件共享，满足数据隐私、合规性要求，避免第三方存储风险。
- **开源解决方案部署**：偏好开源技术栈的组织或个人，需构建私有、可定制的文件同步与内容协作平台。

## 快速参考

- **问题反馈地址**：\
  [owncloud/core](https://github.com/owncloud/core/issues)

- **支持的架构**：\
  `amd64`、`arm64v8`

- **继承的环境变量**：\
  [owncloud/ubuntu](https://github.com/owncloud-docker/ubuntu#environment-variables)、
  [owncloud/php](https://github.com/owncloud-docker/php#environment-variables)、
  [owncloud/base](https://github.com/owncloud-docker/base#environment-variables)

## Docker 标签及对应 Dockerfile 链接

- [`10.15.0`](https://github.com/owncloud-docker/server/blob/master/v20.04/Dockerfile.multiarch)，可用标签：`owncloud/server:10.15.0`、`owncloud/server:10.15`、`owncloud/server:10`、`owncloud/server:latest`
- [`10.14.0`](https://github.com/owncloud-docker/server/blob/master/v20.04/Dockerfile.multiarch)，可用标签：`owncloud/server:10.14.0`
- [`10.13.4`](https://github.com/owncloud-docker/server/blob/master/v20.04/Dockerfile.multiarch)，可用标签：`owncloud/server:10.13.4`、`owncloud/server:10.13`

## 默认卷

- `/mnt/data`：用于持久化存储 ownCloud 应用数据、用户文件等。

## 暴露端口

- 8080：Web 服务端口，用于访问 ownCloud Web 界面。

## 环境变量

该镜像未定义额外环境变量，但继承了以下基础镜像的环境变量：

- [owncloud/ubuntu](https://github.com/owncloud-docker/ubuntu#environment-variables)：包含基础系统环境配置。
- [owncloud/php](https://github.com/owncloud-docker/php#environment-variables)：包含 PHP 运行时配置，如内存限制、时区等。
- [owncloud/base](https://github.com/owncloud-docker/base#environment-variables)：包含 ownCloud 基础服务配置。

具体环境变量说明请参考上述链接。

## 使用方法与部署示例

### 前提条件

部署前需准备：
- 持久化数据卷（用于存储 ownCloud 数据、数据库数据、Redis 数据）。
- MariaDB 容器（提供数据库服务）。
- Redis 容器（用于缓存和会话管理）。

### 使用 docker run 部署

```bash
# 创建数据卷
docker volume create owncloud_data
docker volume create mariadb_data
docker volume create redis_data

# 启动 MariaDB 容器
docker run -d \
  --name owncloud-mariadb \
  -e MYSQL_ROOT_PASSWORD=owncloud \
  -e MYSQL_DATABASE=owncloud \
  -e MYSQL_USER=owncloud \
  -e MYSQL_PASSWORD=owncloud \
  -v mariadb_data:/var/lib/mysql \
  mariadb:10.5

# 启动 Redis 容器
docker run -d \
  --name owncloud-redis \
  -v redis_data:/data \
  redis:6-alpine

# 启动 ownCloud 服务器容器
docker run -d \
  --name owncloud-server \
  --link owncloud-mariadb:db \
  --link owncloud-redis:redis \
  -p 8080:8080 \
  -v owncloud_data:/mnt/data \
  -e OWNCLOUD_DB_TYPE=mysql \
  -e OWNCLOUD_DB_NAME=owncloud \
  -e OWNCLOUD_DB_USER=owncloud \
  -e OWNCLOUD_DB_PASSWORD=owncloud \
  -e OWNCLOUD_DB_HOST=db \
  -e OWNCLOUD_REDIS_ENABLED=true \
  -e OWNCLOUD_REDIS_HOST=redis \
  owncloud/server:latest
```

### 使用 docker-compose 部署

创建 `docker-compose.yml` 文件：

```yaml
version: '3'

services:
  owncloud:
    image: owncloud/server:latest
    container_name: owncloud-server
    ports:
      - "8080:8080"
    volumes:
      - owncloud_data:/mnt/data
    environment:
      - OWNCLOUD_DB_TYPE=mysql
      - OWNCLOUD_DB_NAME=owncloud
      - OWNCLOUD_DB_USER=owncloud
      - OWNCLOUD_DB_PASSWORD=owncloud
      - OWNCLOUD_DB_HOST=db
      - OWNCLOUD_REDIS_ENABLED=true
      - OWNCLOUD_REDIS_HOST=redis
    depends_on:
      - db
      - redis

  db:
    image: mariadb:10.5
    container_name: owncloud-mariadb
    volumes:
      - mariadb_data:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=owncloud
      - MYSQL_DATABASE=owncloud
      - MYSQL_USER=owncloud
      - MYSQL_PASSWORD=owncloud

  redis:
    image: redis:6-alpine
    container_name: owncloud-redis
    volumes:
      - redis_data:/data

volumes:
  owncloud_data:
  mariadb_data:
  redis_data:
```

启动服务：
```bash
docker-compose up -d
```

部署完成后，通过 `http://localhost:8080` 访问 ownCloud 界面，使用默认管理员账号（用户名：`admin`，密码：`admin`）登录，首次登录需修改密码。

## 许可

本项目采用 MIT 许可协议 - 详见 [LICENSE](https://github.com/owncloud-docker/server/blob/master/LICENSE) 文件。

## 版权

```text
Copyright (c) 2022 ownCloud GmbH
