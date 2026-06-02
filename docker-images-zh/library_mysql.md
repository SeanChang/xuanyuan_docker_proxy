---
image: library/mysql
description: "MySQL 官方 Docker 镜像，提供开箱即用的关系型数据库服务，支持通过环境变量完成库和账号初始化，并结合数据卷实现持久化存储，适合本地开发、集成测试及小到中型生产环境的数据库部署。"
source: https://xuanyuan.cloud/zh/r/library/mysql
canonical: https://xuanyuan.cloud/zh/r/library/mysql
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/mysql" title="library/mysql Docker 镜像中文简介、标签列表与拉取命令">library/mysql — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/mysql" title="library/mysql Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/mysql</a>

# MySQL 官方 Docker 镜像中文说明

## 一、概述

MySQL 是使用最广泛的开源关系型数据库之一，适用于博客、企业官网、电商平台、SaaS 系统等各种场景。本镜像由官方团队维护，预装 MySQL Server，并对初始化流程做了容器化封装，可通过少量环境变量完成数据库创建与账号初始化，极大简化部署流程。

- 默认监听端口：`3306`
- 默认数据目录：`/var/lib/mysql`
- 支持多架构：`amd64` / `arm64` 等
- 同时提供长期支持（LTS）与创新版本（Innovation）镜像标签

## 二、典型使用场景

- **Web / API 服务数据库**：为 PHP、Java、Node.js、Python 等应用提供主数据库服务。
- **本地开发与集成测试**：在本地或 CI 中快速拉起一套“临时 MySQL 环境”，测试通过后直接销毁容器即可。
- **教学与实验环境**：在课程或培训中一键启动 MySQL，聚焦于 SQL 与数据建模本身，而非环境安装。

## 三、快速开始

### 1. 启动一个最简 MySQL 实例

```bash
docker run -d \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=your-root-password \
  -p 3306:3306 \
  mysql:latest
```

此命令会：

- 初始化一个 MySQL 数据目录（在容器内 `/var/lib/mysql`）；
- 创建 `root` 用户并设置密码为 `your-root-password`；
- 监听容器内 3306 端口，并映射到宿主机 3306。

> 初始化期间 MySQL 还在创建系统表、用户等，短时间内可能无法立即连接，稍等片刻或在应用中增加重试逻辑即可。

### 2. 配置数据持久化

为了避免容器删除导致数据丢失，推荐将 `/var/lib/mysql` 挂载到宿主机目录或 Docker 卷：

```bash
# 使用命名卷（推荐）
docker run -d \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=your-root-password \
  -p 3306:3306 \
  -v mysql-data:/var/lib/mysql \
  mysql:latest

# 或挂载宿主机目录
docker run -d \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=your-root-password \
  -p 3306:3306 \
  -v /opt/mysql/data:/var/lib/mysql \
  mysql:latest
```

## 四、常用初始化环境变量

这些变量**仅在数据目录为空、首次初始化时生效**；目录中已存在数据库时会被忽略。

- **`MYSQL_ROOT_PASSWORD`**（必选）：`root` 用户密码（除非使用空密码或随机密码模式）。
- **`MYSQL_DATABASE`**：初始化时自动创建的数据库名称。
- **`MYSQL_USER`** / **`MYSQL_PASSWORD`**：创建一个业务账号，并授予上面 `MYSQL_DATABASE` 的全部权限。
- **`MYSQL_ALLOW_EMPTY_PASSWORD`**：允许 `root` 使用空密码（设为 `yes`，不推荐生产环境）。
- **`MYSQL_RANDOM_ROOT_PASSWORD`**：启动时为 `root` 生成随机密码（设为 `yes`，密码会写入容器日志）。

示例：一次性创建库和业务账号：

```bash
docker run -d \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=your-root-password \
  -e MYSQL_DATABASE=app_db \
  -e MYSQL_USER=app_user \
  -e MYSQL_PASSWORD=app_password \
  -v mysql-data:/var/lib/mysql \
  mysql:latest
```

## 五、自定义配置与字符集

### 1. 使用命令行参数调整配置

很多常见配置可以直接通过 `mysqld` 参数设置，而无需准备独立的配置文件，例如统一设置 `utf8mb4` 字符集：

```bash
docker run -d \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=your-root-password \
  -v mysql-data:/var/lib/mysql \
  mysql:latest \
  --character-set-server=utf8mb4 \
  --collation-server=utf8mb4_unicode_ci
```

### 2. 挂载自定义配置文件

如果已准备好 `my.cnf` 或额外配置片段，可以通过挂载目录的方式加载：

```bash
# 假设 /opt/mysql/conf.d 中放置了自定义 .cnf 文件
docker run -d \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=your-root-password \
  -v mysql-data:/var/lib/mysql \
  -v /opt/mysql/conf.d:/etc/mysql/conf.d \
  mysql:latest
```

多个配置文件会按 MySQL 约定顺序加载，后加载的值会覆盖默认值。

## 六、备份与恢复示例

### 1. 全库备份

```bash
# 备份所有数据库到宿主机文件
Docker exec mysql sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > /backup/all.sql
```

### 2. 从备份恢复

```bash
# 从备份文件恢复
docker exec -i mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"' < /backup/all.sql
```

## 七、适用人群

- 希望快速搭建 LAMP / LNMP / Spring Boot / Node.js 等常见技术栈的开发者与运维；
- 需要在 CI/CD 流水线中自动拉起/销毁 MySQL 实例的团队；
- 需要在单机或小规模集群中部署稳定可靠关系型数据库的用户。
