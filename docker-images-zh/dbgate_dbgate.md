---
image: dbgate/dbgate
description: "基于Web的界面，用于管理与探索SQL数据库数据"
source: https://xuanyuan.cloud/zh/r/dbgate/dbgate
canonical: https://xuanyuan.cloud/zh/r/dbgate/dbgate
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dbgate/dbgate" title="dbgate/dbgate Docker 镜像中文简介、标签列表与拉取命令">dbgate/dbgate 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# DbGate - 社区版


## 镜像概述与主要用途
DbGate 是一款基于 Web 的现代数据管理工具，社区版提供基础数据管理功能，适用于非企业级场景。其核心用途是通过 Web 界面实现对各类数据库的管理与数据探索。如需企业级功能，建议使用 [Premium 版](https://hub.docker.com/r/dbgate/dbgate-premium)。


## 核心功能与特性
- **多数据库支持**：兼容多种主流数据库系统（详见「支持的数据库」章节）。
- **Web 化管理**：通过浏览器访问的图形界面，无需本地安装客户端。
- **连接持久化**：支持保存数据库连接配置，通过卷映射实现数据持久化。
- **数据与脚本管理**：可存储查询脚本、数据归档及应用配置等。
- **预配置连接**：支持通过环境变量预定义数据库连接，简化部署流程。


## 支持的数据库
DbGate 社区版支持以下数据库系统：
- Microsoft SQL Server
- MySQL
- MariaDB
- PostgreSQL
- Oracle
- CockroachDB
- Amazon Redshift
- MongoDB
- Redis
- SQLite（**注意**：如需使用 SQLite，请勿选择 alpine 版本镜像）
- ClickHouse


## 使用场景与适用范围
- **开发环境**：本地或测试环境中多数据库的统一管理。
- **数据探索**：快速查询、浏览不同数据库中的数据。
- **小型团队**：轻量级数据库管理工具，降低运维成本。
- **脚本与配置存储**：需持久化保存查询脚本、连接配置的场景。
- **企业用户**：建议使用 Premium 版以获得更全面的企业级功能。


## 使用方法与配置说明

### 拉取镜像
从 Docker Hub 拉取最新版社区版镜像：
```bash
docker pull docker.xuanyuan.run/dbgate/dbgate
```

### 基本启动命令
使用以下命令启动 DbGate 容器，映射主机端口（替换 `<主机端口>` 为实际端口，如 `8080`）：
```bash
docker run -it --name dbgate-instance --restart always -p <主机端口>:3000 docker.xuanyuan.run/dbgate/dbgate
```

### 预配置数据库连接
如需启动时自动配置数据库连接，可通过环境变量定义。示例（配置 MS SQL 连接）：
```bash
docker run -it --name dbgate-instance --restart always -p <主机端口>:3000 \
  -e CONNECTIONS='mssql' \
  -e LABEL_mssql='MS SQL 数据库' \
  -e SERVER_mssql='服务器IP' \
  -e USER_mssql='用户名' \
  -e PASSWORD_mssql='密码' \
  -e ENGINE_mssql='mssql@dbgate-plugin-mssql' \
  docker.xuanyuan.run/dbgate/dbgate
```

### 卷映射（数据持久化）
若需在应用内手动配置连接并持久化数据（如保存的连接、脚本、归档文件等），需映射数据卷，而非定义 `CONNECTIONS` 环境变量。示例：
```bash
docker run -it --name dbgate-instance --restart always -p <主机端口>:3000 \
  -v dbgate-data:/root/.dbgate \  # 持久化存储路径
  dbgate/dbgate
```

### Docker Compose 配置示例
以下是多连接配置的 docker-compose 示例，包含卷映射与环境变量定义：
```yaml
version: '3'
services:
  dbgate:
    image: docker.xuanyuan.run/dbgate/dbgate
    restart: always
    ports:
      - 80:3000  # 主机端口:容器端口（容器内固定使用 3000 端口）
    volumes:
      - dbgate-data:/root/.dbgate  # 持久化数据卷
    environment:
      CONNECTIONS: con1,con2,con3,con4  # 定义连接名称列表（逗号分隔）

      # MySQL 连接配置（con1）
      LABEL_con1: MySQL数据库
      SERVER_con1: mysql  # 服务器地址（可为主机名或IP）
      USER_con1: root     # 用户名
      PASSWORD_con1: TEST # 密码
      PORT_con1: 3306     # 端口
      ENGINE_con1: mysql@dbgate-plugin-mysql  # 引擎插件

      # PostgreSQL 连接配置（con2）
      LABEL_con2: PostgreSQL数据库
      SERVER_con2: postgres
      USER_con2: postgres
      PASSWORD_con2: TEST
      PORT_con2: 5432
      ENGINE_con2: postgres@dbgate-plugin-postgres

      # MongoDB 连接配置（con3）
      LABEL_con3: MongoDB数据库
      URL_con3: mongodb://mongo:27017  # 连接URL
      ENGINE_con3: mongo@dbgate-plugin-mongo

      # SQLite 连接配置（con4）
      LABEL_con4: SQLite数据库
      FILE_con4: /home/jan/feeds.sqlite  # SQLite文件路径
      ENGINE_con4: sqlite@dbgate-plugin-sqlite

volumes:
  dbgate-data:
    driver: local  # 本地卷驱动
```


## 环境变量说明
DbGate 通过环境变量实现配置，核心变量如下：

### 基础配置变量
- `CONNECTIONS`: 预配置连接名称列表（如 `con1,con2`），多个连接用逗号分隔。若不定义此变量，需通过应用内手动配置连接。

### 连接专用变量
对 `CONNECTIONS` 中定义的每个连接（如 `con1`），可通过以下变量配置：
- `LABEL_<连接名>`: 连接显示名称（如 `LABEL_con1: MySQL数据库`）。
- `SERVER_<连接名>`: 数据库服务器地址（适用于需服务器地址的数据库，如 MySQL、PostgreSQL）。
- `USER_<连接名>`/`PASSWORD_<连接名>`: 登录用户名与密码。
- `PORT_<连接名>`: 数据库端口（如 `PORT_con1: 3306`）。
- `URL_<连接名>`: 数据库连接 URL（适用于 MongoDB 等，如 `URL_con3: mongodb://mongo:27017`）。
- `FILE_<连接名>`: SQLite 数据库文件路径（如 `FILE_con4: /path/to/db.sqlite`）。
- `ENGINE_<连接名>`: 数据库引擎插件（格式为 `<引擎名>@dbgate-plugin-<引擎名>`，如 `mysql@dbgate-plugin-mysql`）。

完整环境变量列表请参考 [官方文档](https://dbgate.org/docs/env-variables.html)。
