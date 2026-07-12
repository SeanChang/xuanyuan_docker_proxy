---
image: leantime/leantime
description: "Leantime官方Docker镜像，一个面向小型团队和初创公司的开源项目管理系统，基于PHP、Javascript和MySQL构建。"
source: https://xuanyuan.cloud/zh/r/leantime/leantime
canonical: https://xuanyuan.cloud/zh/r/leantime/leantime
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/leantime/leantime" title="leantime/leantime Docker 镜像中文简介、标签列表与拉取命令">leantime/leantime 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Leantime Docker 镜像文档

## 镜像概述

Leantime 是一款面向小型团队和初创公司的开源项目管理系统，采用 PHP、Javascript 开发，基于 MySQL 数据库。本镜像为 Leantime 官方 Docker 镜像，基于 [Leantime 最新发布版本](https://github.com/Leantime/leantime/releases) 构建。

## 核心功能与特性

- **开源免费**：完全开源，可自由使用和定制
- **团队协作**：支持小型团队的项目管理流程
- **技术栈兼容**：基于 PHP、Javascript 和 MySQL，易于部署和维护
- **官方支持**：官方维护的 Docker 镜像，确保与最新版本同步

## 使用场景

适用于小型团队和初创公司进行项目规划、任务管理、团队协作等项目管理需求。

## 使用方法

### 前提条件

运行本镜像需先准备 MySQL 数据库（可使用现有数据库或新建容器）。

### 已有 MySQL 数据库时运行

若已存在 MySQL 数据库，可直接运行以下命令启动 Leantime 容器：

```bash
docker run -d -p 80:80 \
-e LEAN_DB_HOST=mysql_leantime \
-e LEAN_DB_USER=admin \
-e LEAN_DB_PASSWORD=321.qwerty \
-e LEAN_DB_DATABASE=leantime \
--name leantime docker.xuanyuan.run/leantime/leantime:latest
```

**参数说明**：
- `-p 80:80`：将容器的 80 端口映射到主机的 80 端口
- 环境变量（`-e`）：可设置 `config/configuration.php` 中的任何配置变量，常用变量包括：
  - `LEAN_DB_HOST`：MySQL 主机地址
  - `LEAN_DB_USER`：数据库用户名
  - `LEAN_DB_PASSWORD`：数据库密码
  - `LEAN_DB_DATABASE`：数据库名称

启动后，访问 `<yourdomain.com>/install` 运行安装脚本完成配置。

### 带 MySQL 和网络的完整设置

若需从零开始搭建（包括 MySQL 容器），请按以下步骤操作：

#### 1. 创建网络

创建专用网络使 Leantime 与 MySQL 容器通信：

```bash
docker network create leantime-net
```

#### 2. 创建 MySQL 容器

```bash
docker run -d -p 3306:3306 --network leantime-net \
-e MYSQL_ROOT_PASSWORD=321.qwerty \
-e MYSQL_DATABASE=leantime \
-e MYSQL_USER=admin \
-e MYSQL_PASSWORD=321.qwerty \
--name mysql_leantime docker.xuanyuan.run/mysql:5.7 --character-set-server=utf8 --collation-server=utf8_unicode_ci
```

**参数说明**：
- `--network leantime-net`：加入已创建的网络
- `MYSQL_ROOT_PASSWORD`：MySQL root 用户密码
- `MYSQL_DATABASE`：自动创建的数据库名（需与 Leantime 配置一致）
- `MYSQL_USER` 和 `MYSQL_PASSWORD`：Leantime 连接数据库的用户及密码

#### 3. 创建 Leantime 容器

```bash
docker run -d -p 80:80 --network leantime-net \
-e LEAN_DB_HOST=mysql_leantime \
-e LEAN_DB_USER=admin \
-e LEAN_DB_PASSWORD=321.qwerty \
-e LEAN_DB_DATABASE=leantime \
--name leantime docker.xuanyuan.run/leantime/leantime:latest
```

#### 4. 完成安装

访问 `<yourdomain.com>/install` 运行安装脚本，按提示完成配置。

### 使用 docker-compose 部署

通过 docker-compose 可一键部署完整环境：

```bash
git clone https://github.com/Leantime/docker-leantime.git
cd docker-leantime
docker-compose up -d
```

部署完成后，同样通过 `<yourdomain.com>/install` 访问安装脚本。
