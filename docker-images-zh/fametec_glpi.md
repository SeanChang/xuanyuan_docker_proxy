---
image: fametec/glpi
description: "GLPI 9.5.6 Docker镜像是一款免费的IT资产管理与服务台软件，集成php7.3和apache，提供ITIL服务台功能、许可证跟踪及软件审计。"
source: https://xuanyuan.cloud/zh/r/fametec/glpi
canonical: https://xuanyuan.cloud/zh/r/fametec/glpi
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/fametec/glpi" title="fametec/glpi Docker 镜像中文简介、标签列表与拉取命令">fametec/glpi 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# GLPI Docker容器

![GLPI Logo](https://raw.githubusercontent.com/glpi-project/glpi/master/pics/logos/logo-GLPI-250-black.png)

## 镜像概述

GLPI（Gestionnaire Libre de Parc Informatique）是一款免费的IT资产管理与服务台软件，提供ITIL服务台功能、许可证跟踪和软件审计等核心能力。本Docker镜像基于GLPI 9.5.6版本构建，集成php7.3和apache环境，支持快速部署和配置。

## 核心功能与特性

- **IT资产管理**：全面跟踪硬件、软件资产信息及生命周期
- **ITIL服务台**：支持事件管理、问题管理、变更管理等ITIL流程
- **许可证跟踪**：监控软件许可证使用情况，确保合规性
- **软件审计**：自动检测网络中的软件安装情况
- **多语言支持**：通过环境变量配置界面语言（如pt_BR）
- **插件扩展**：支持一键安装所有插件（PLUGINS="all"）
- **自动化任务**：集成Cron服务处理计划任务

## 拓扑结构

![Topology](https://raw.githubusercontent.com/fametec/glpi/master/topologia-docker-compose-glpi.png)

## 使用场景

- 企业IT资产管理与 inventory 维护
- IT服务台运维支持
- 软件许可证合规性管理
- 中小型组织IT基础设施监控

## 部署与使用方法

### 快速演示

[在线演示环境](https://www.katacoda.com/eduardofraga/scenarios/glpi-playground)

### 独立容器部署

#### 1. 部署MariaDB数据库

```bash
docker run -d --name mariadb-glpi \
  -e MYSQL_DATABASE=glpi \
  -e MYSQL_USER=glpi \
  -e MYSQL_PASSWORD=glpi \
  -e MYSQL_RANDOM_ROOT_PASSWORD=1 \
  -p 3306:3306 \
  docker.xuanyuan.run/fametec/glpi:mariadb
```

#### 2. 部署GLPI应用

```bash
docker run -d --name glpi \
  --link mariadb-glpi:mariadb-glpi \
  -e GLPI_LANG=pt_BR \
  -e MARIADB_HOST=mariadb-glpi \
  -e MARIADB_PORT=3306 \
  -e MARIADB_DATABASE=glpi \
  -e MARIADB_USER=glpi \
  -e MARIADB_PASSWORD=glpi \
  -e VERSION="9.5.6" \
  -e PLUGINS="all" \
  -p 80:80 \
  -p 443:443 \
  docker.xuanyuan.run/fametec/glpi:latest
```

#### 3. 部署Cron服务（计划任务）

```bash
docker run -d --name crond-glpi \
  --link mariadb-glpi:mariadb \
  --volume glpi:/var/www/html/glpi \
  docker.xuanyuan.run/fametec/glpi:crond
```

### Docker Compose部署

#### docker-compose.yaml配置

```yaml
version: "3.5"
services:
  mariadb-glpi: 
    image: docker.xuanyuan.run/fametec/glpi:mariadb
    restart: unless-stopped
    volumes: 
      - mariadb-glpi-volume:/var/lib/mysql:rw
    environment: 
      MYSQL_DATABASE: glpi
      MYSQL_USER: glpi-user 
      MYSQL_PASSWORD: glpi-pass 
      MYSQL_RANDOM_ROOT_PASSWORD: 1 
    ports: 
      - 3306:3306
    networks: 
      - glpi-backend
  glpi: 
    image: docker.xuanyuan.run/fametec/glpi:latest
    restart: unless-stopped
    volumes: 
      - glpi-volume-files:/var/www/html/files:rw
      - glpi-volume-plugins:/var/www/html/plugins:rw
    environment: 
      GLPI_LANG: pt_BR
      MARIADB_HOST: mariadb-glpi
      MARIADB_PORT: 3306
      MARIADB_DATABASE: glpi
      MARIADB_USER: glpi-user
      MARIADB_PASSWORD: glpi-pass
      VERSION: "9.5.6"
      PLUGINS: "all"
    depends_on: 
      - mariadb-glpi
    ports: 
      - 30080:80
    networks: 
      - glpi-frontend
      - glpi-backend
  # CRON服务
  crond: 
    image: docker.xuanyuan.run/fametec/glpi:crond
    restart: unless-stopped
    volumes:
      - glpi-volume-files:/var/www/html/files:rw
      - glpi-volume-plugins:/var/www/html/plugins:rw
    depends_on:
      - mariadb-glpi
    environment: 
      MARIADB_HOST: mariadb-glpi
      MARIADB_PORT: 3306
      MARIADB_DATABASE: glpi
      MARIADB_USER: glpi-user
      MARIADB_PASSWORD: glpi-pass
    networks: 
      - glpi-backend

volumes: 
  glpi-volume-files:
  glpi-volume-plugins:
  mariadb-glpi-volume: 

networks: 
  glpi-frontend: 
  glpi-backend:
```

## 配置参数说明

| 环境变量 | 描述 | 默认值 |
|---------|------|-------|
| GLPI_LANG | 界面语言 | pt_BR |
| MARIADB_HOST | 数据库主机地址 | mariadb-glpi |
| MARIADB_PORT | 数据库端口 | 3306 |
| MARIADB_DATABASE | 数据库名称 | glpi |
| MARIADB_USER | 数据库用户名 | glpi |
| MARIADB_PASSWORD | 数据库密码 | glpi |
| VERSION | GLPI版本 | 9.5.6 |
| PLUGINS | 插件安装选项 | all（安装所有插件） |

## 支持与学习资源

- **培训课程**：[Fametreinamentos](https://www.fametreinamentos.com.br)
- **技术支持**：[Fametec](https://www.fametec.com.br)，邮箱：contato@fametec.com.br

## 许可证

![license](https://img.shields.io/github/license/glpi-project/glpi.svg)  
GLPI遵循开源许可证，详情参见[GLPI项目仓库](https://github.com/glpi-project/glpi)。
