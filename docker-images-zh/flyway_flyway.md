---
image: flyway/flyway
description: "Flyway命令行开源Docker镜像，用于简化数据库迁移管理，支持SQL和Java-based迁移，通过配置文件、JDBC驱动和迁移脚本实现数据库版本控制，适用于开发和部署环境中的数据库版本同步。"
source: https://xuanyuan.cloud/zh/r/flyway/flyway
canonical: https://xuanyuan.cloud/zh/r/flyway/flyway
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/flyway/flyway" title="flyway/flyway Docker 镜像中文简介、标签列表与拉取命令">flyway/flyway 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Flyway 开源Docker镜像

本文档介绍[Flyway命令行](https://documentation.red-gate.com/fd/welcome-to-flyway-184127914.html)开源Docker镜像的使用。

如需官方认证的Redgate Flyway Docker镜像，请使用Dockerhub上的[Redgate/Flyway](https://hub.docker.com/r/redgate/flyway/)，该镜像支持所有Flyway版本（包括Community、Teams和Enterprise版），并与[Flyway Pipelines](https://flyway.red-gate.com/pipelines)兼容。Flyway Pipelines可提供数据库部署状态的集中可视化，帮助追踪部署内容、时间和位置。

## 建议的项目结构

为便于灵活运行Flyway，建议项目中包含以下文件夹：

| 卷 | 用途 |
|------|------|
| `/flyway/conf` | 包含`flyway.conf/toml`[配置文件](https://documentation.red-gate.com/fd/configuration-files-224003079.html)的目录 |
| `/flyway/drivers` | 包含[数据库JDBC驱动](https://documentation.red-gate.com/fd/command-line-184127404.html#jdbc-drivers)的目录 |
| `/flyway/sql` | Flyway使用的SQL文件（用于[基于SQL的迁移](https://documentation.red-gate.com/fd/migrations-184127470.html#sql-based-migrations)） |
| `/flyway/jars` | Flyway使用的JAR文件（用于[基于Java的迁移](https://documentation.red-gate.com/fd/migrations-184127470.html#java-based-migrations)） |

## 快速开始

### 基本使用

最简单的开始方式是运行默认镜像，查看Flyway命令行使用说明：

```bash
docker run --rm docker.xuanyuan.run/flyway/flyway
```

### 执行具体操作

需向镜像传递必要参数，例如查看数据库信息：

```bash
docker run --rm docker.xuanyuan.run/flyway/flyway -url=jdbc:sqlite:dev.db info
```

### Azure版本特殊说明

`flyway/flyway:*azure`镜像为适配Azure Pipelines代理作业要求，语法略有不同：需显式添加`flyway`命令，例如：

```bash
docker run --rm docker.xuanyuan.run/flyway/flyway:latest-azure flyway
```

## 添加SQL迁移文件

1. 在项目文件夹中创建`/sql`目录，添加迁移脚本（如`V1__Initial.sql`）：

```sql
CREATE TABLE MyTable (
    MyColumn VARCHAR(100) NOT NULL
);
```

2. 挂载项目目录并运行迁移：

```bash
docker run --rm -v /absolute/path/to/my/project_folder:/flyway/project docker.xuanyuan.run/flyway/flyway -url=jdbc:sqlite:dev.db -workingDirectory="project" migrate
```

## 添加配置文件

可通过配置文件存储参数，避免命令行重复输入。

### 示例配置文件

创建`flyway.toml`：

```toml
[environments.development]
url = "jdbc:sqlite:/flyway/project/dev.db"
user= "admin"
password = "password1"

[flyway]
environment = "development"
```

### 运行命令

```bash
docker run --rm -v /absolute/path/to/my/project_folder:/flyway/project docker.xuanyuan.run/flyway/flyway migrate -workingDirectory="project"
```

## 添加JDBC驱动

若数据库驱动未默认包含（可查看[官方文档](https://documentation.red-gate.com/fd/supported-databases-184127454.html)确认），或需使用不同/更新版本的驱动，可在项目文件夹中创建`drivers/`目录并放入驱动文件。

## 添加基于Java的迁移和回调

将基于Java的迁移文件和回调JAR包放入项目目录的`jars/`文件夹中。

## Docker Compose配置

通过`docker-compose.yml`可同时启动Flyway和目标数据库容器，实现联动部署。

### 示例配置

```yaml
version: '3'
services:
  flyway:
    image: docker.xuanyuan.run/flyway/flyway
    command: -url=jdbc:mysql://db -schemas=myschema -user=root -password=P@ssw0rd -connectRetries=60 migrate
    volumes:
      - .:/flyway/sql
    depends_on:
      - db
  db:
    image: docker.xuanyuan.run/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=P@ssw0rd
    command: --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    ports:
      - 3306:3306
```

### 运行方式

执行以下命令启动服务，Flyway将自动等待最多一分钟，直至MySQL初始化完成后开始数据库迁移：

```bash
docker-compose up
