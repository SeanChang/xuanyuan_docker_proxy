---
image: diouxx/glpi
description: "该Docker镜像用于通过容器化方式部署开源IT资产管理与服务台软件GLPI，简化部署流程，便于快速搭建和使用GLPI系统。"
source: https://xuanyuan.cloud/zh/r/diouxx/glpi
canonical: https://xuanyuan.cloud/zh/r/diouxx/glpi
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/diouxx/glpi" title="diouxx/glpi Docker 镜像中文简介、标签列表与拉取命令">diouxx/glpi 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 使用Docker部署GLPI的项目

![Docker Pulls](https://img.shields.io/docker/pulls/diouxx/glpi) ![Docker Stars](https://img.shields.io/docker/stars/diouxx/glpi) [![](https://images.microbadger.com/badges/image/diouxx/glpi.svg)](http://microbadger.com/images/diouxx/glpi "Get your own image badge on microbadger.com") ![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/diouxx/glpi)

# 目录
- [使用Docker部署GLPI的项目](#使用docker部署glpi的项目)
- [目录](#目录)
- [概述](#概述)
  - [默认账户](#默认账户)
- [使用命令行部署](#使用命令行部署)
  - [基本部署GLPI](#基本部署glpi)
  - [使用现有数据库部署GLPI](#使用现有数据库部署glpi)
  - [带数据库和持久化数据的部署](#带数据库和持久化数据的部署)
  - [部署特定版本的GLPI](#部署特定版本的glpi)
- [使用docker-compose部署](#使用docker-compose部署)
  - [无持久化数据部署（快速测试用）](#无持久化数据部署快速测试用)
  - [部署特定版本](#部署特定版本)
  - [带持久化数据部署](#带持久化数据部署)
    - [mariadb.env](#mariadbenv)
    - [docker-compose.yml](#docker-composeyml)
- [环境变量](#环境变量)
  - [TIMEZONE](#timezone)

# 概述

通过Docker安装并运行GLPI实例

## 默认账户

更多信息参见📄[官方文档](https://glpi-install.readthedocs.io/en/latest/install/wizard.html#end-of-installation)

| 登录名/密码          | 角色                |
|---------------------|---------------------|
| glpi/glpi           | 管理员账户          |
| tech/tech           | 技术人员账户        |
| normal/normal       | "普通"用户账户      |
| post-only/postonly  | 仅发布权限账户      |

# 使用命令行部署

## 基本部署GLPI
```sh
docker run --name mariadb -e MARIADB_ROOT_PASSWORD=diouxx -e MARIADB_DATABASE=glpidb -e MARIADB_USER=glpi_user -e MARIADB_PASSWORD=glpi -d docker.xuanyuan.run/mariadb:10.7
docker run --name glpi --link mariadb:mariadb -p 80:80 -d docker.xuanyuan.run/diouxx/glpi
```

## 使用现有数据库部署GLPI
```sh
docker run --name glpi --link yourdatabase:mariadb -p 80:80 -d docker.xuanyuan.run/diouxx/glpi
```

## 带数据库和持久化数据的部署

对于生产环境或日常使用，建议使用卷(volumes)来持久化数据。

* 首先，创建带卷的MariaDB容器

```sh
docker run --name mariadb -e MARIADB_ROOT_PASSWORD=diouxx -e MARIADB_DATABASE=glpidb -e MARIADB_USER=glpi_user -e MARIADB_PASSWORD=glpi --volume /var/lib/mysql:/var/lib/mysql -d docker.xuanyuan.run/mariadb:10.7
```

* 然后，创建带卷并链接MariaDB容器的GLPI容器

```sh
docker run --name glpi --link mariadb:mariadb --volume /var/www/html/glpi:/var/www/html/glpi -p 80:80 -d docker.xuanyuan.run/diouxx/glpi
```

使用愉快 :)

## 部署特定版本的GLPI
默认情况下，`docker run`会使用GLPI的最新版本。对于生产环境，建议指定特定版本。以下是部署9.1.6版本的示例：
```sh
docker run --name glpi --hostname glpi --link mariadb:mariadb --volume /var/www/html/glpi:/var/www/html/glpi -p 80:80 --env "VERSION_GLPI=9.1.6" -d docker.xuanyuan.run/diouxx/glpi
```

# 使用docker-compose部署

## 无持久化数据部署（快速测试用）
```yaml
version: "3.8"

services:
  # MariaDB容器
  mariadb:
    image: docker.xuanyuan.run/mariadb:10.7
    container_name: mariadb
    hostname: mariadb
    environment:
      - MARIADB_ROOT_PASSWORD=password
      - MARIADB_DATABASE=glpidb
      - MARIADB_USER=glpi_user
      - MARIADB_PASSWORD=glpi

  # GLPI容器
  glpi:
    image: docker.xuanyuan.run/diouxx/glpi
    container_name: glpi
    hostname: glpi
    ports:
      - "80:80"
```

## 部署特定版本

```yaml
version: "3.8"

services:
  # MariaDB容器
  mariadb:
    image: docker.xuanyuan.run/mariadb:10.7
    container_name: mariadb
    hostname: mariadb
    environment:
      - MARIADB_ROOT_PASSWORD=password
      - MARIADB_DATABASE=glpidb
      - MARIADB_USER=glpi_user
      - MARIADB_PASSWORD=glpi

  # GLPI容器
  glpi:
    image: docker.xuanyuan.run/diouxx/glpi
    container_name: glpi
    hostname: glpi
    environment:
      - VERSION_GLPI=9.5.6
    ports:
      - "80:80"
```

## 带持久化数据部署

使用docker-compose部署时，需使用`docker-compose.yml`和`mariadb.env`文件。可修改**`mariadb.env`**来个性化设置，例如：

* MariaDB root密码
* GLPI数据库名
* GLPI数据库用户
* GLPI数据库用户密码

### mariadb.env
```
MARIADB_ROOT_PASSWORD=diouxx
MARIADB_DATABASE=glpidb
MARIADB_USER=glpi_user
MARIADB_PASSWORD=glpi
```

### docker-compose.yml
```yaml
version: "3.2"

services:
  # MariaDB容器
  mariadb:
    image: docker.xuanyuan.run/mariadb:10.7
    container_name: mariadb
    hostname: mariadb
    volumes:
      - /var/lib/mysql:/var/lib/mysql
    env_file:
      - ./mariadb.env
    restart: always

  # GLPI容器
  glpi:
    image: docker.xuanyuan.run/diouxx/glpi
    container_name: glpi
    hostname: glpi
    ports:
      - "80:80"
    volumes:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      - /var/www/html/glpi/:/var/www/html/glpi
    environment:
      - TIMEZONE=Europe/Brussels
    restart: always
```

在包含上述文件的目录中，运行以下命令进行部署：

```sh
docker-compose up -d
```

# 环境变量

## TIMEZONE
用于设置Apache和PHP的时区

通过命令行设置：
```sh
docker run --name glpi --hostname glpi --link mariadb:mariadb --volumes-from glpi-data -p 80:80 --env "TIMEZONE=Europe/Brussels" -d docker.xuanyuan.run/diouxx/glpi
```

通过docker-compose设置：

修改配置：
```yaml
environment:
  - TIMEZONE=Europe/Brussels
