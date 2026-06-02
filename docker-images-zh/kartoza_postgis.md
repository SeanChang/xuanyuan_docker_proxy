---
image: kartoza/postgis
description: "即开即用的PostGIS地理空间数据库是基于PostgreSQL的高效空间扩展解决方案，可快速存储、查询和分析各类地理空间数据，涵盖矢量数据（如点、线、面要素）与栅格数据处理，支持空间索引优化、地理编码转换、拓扑关系验证及空间分析函数等核心功能，适用于GIS应用开发、城市规划、环境监测、位置服务等多场景，无需复杂配置即可直接部署使用。"
source: https://xuanyuan.cloud/zh/r/kartoza/postgis
canonical: https://xuanyuan.cloud/zh/r/kartoza/postgis
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [kartoza/postgis — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/kartoza/postgis)

含镜像标签、拉取命令、部署文档与相关推荐。

[kartoza/postgis Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/kartoza/postgis)

# docker-postgis：运行 PostGIS 的 Docker 容器

[![Build Status]([])]([])


## 简介

`docker-postgis` 是一个运行 PostGIS 的轻量 Docker 容器。你可以在 Docker Hub 上访问其页面：[[]]([])。

与其他 PostGIS Docker 容器相比，本容器的特点包括：

- 开箱即支持 SSL，并强制客户端使用 SSL 连接
- 仅允许 Docker 子网内的连接
- 默认创建名为 `gis` 的数据库，可直接与 QGIS 等工具配合使用
- 包含流式复制和逻辑复制支持（默认关闭）
- 启动时可创建多个数据库
- 启动时可创建多个模式（schema）
- 支持在数据库初始化时启用多个扩展
- 自动注册 GDAL 驱动以支持 pg raster
- 支持数据库外（out-of-db） raster 数据


## 镜像标签规则

镜像标签遵循以下格式：  
`kartoza/postgis:[postgres_major_version]-[postgis-point-releases]`  

例如：  
`kartoza/postgis:13.0` 包含 PostgreSQL 13.0 和 PostGIS 3.0。

> **注意**：强烈建议使用带标签的版本。PostgreSQL 的不同小版本会将数据库集群文件存储在不同目录中，若使用持久化卷存储数据，使用非标签版本可能导致数据库“为空”的问题。


## 获取镜像

### 推荐方式：拉取 Docker 可信构建镜像
通过以下命令拉取指定版本的镜像（首次拉取流量较大）：  
```shell
docker pull kartoza/postgis:image_version
```


## 构建镜像

### 直接从 Git 构建
```shell
docker build -t kartoza/postgis git://github.com/kartoza/docker-postgis
```

### 克隆仓库后构建
1. 克隆仓库并切换到目标分支：  
   ```shell
   git clone git://github.com/kartoza/docker-postgis
   git checkout branch_name  # 可选，如不指定则使用默认分支
   ```
2. 构建镜像：  
   ```shell
   docker build -t kartoza/postgis .
   ```

### 指定 PostgreSQL 版本构建
通过构建参数指定 PostgreSQL 和 PostGIS 版本：  
```shell
docker build \
  --build-arg POSTGRES_MAJOR_VERSION=13 \
  --build-arg POSTGIS_MAJOR=3 \
  -t kartoza/postgis:13-3 .
```

### 基于其他 Debian 发行版构建
可通过构建参数指定基础镜像（需基于 Debian 并包含 PostgreSQL 官方 apt 源）：  
- `DISTRO`：发行版（默认 `debian`）  
- `IMAGE_VERSION`：版本（默认 `buster`）  
- `IMAGE_VARIANT`：变体（默认 `slim`）  

例如构建基于 Ubuntu 20.04 的镜像：  
1. 编辑 `.env` 文件：  
   ```dotenv
   DISTRO=ubuntu 
   IMAGE_VERSION=focal 
   IMAGE_VARIANT="" 
   ```
2. 运行构建脚本：  
   ```shell
   ./build.sh
   ```

###  locales 优化
默认构建会包含所有 locales，可通过 `GENERATE_ALL_LOCALE=0` 仅保留默认 locale 以加快构建：  
```shell
docker build --build-arg GENERATE_ALL_LOCALE=0 -t kartoza/postgis .
```


## 环境变量配置

### 集群初始化
- **`DATADIR`**：数据库集群存储路径（默认 `/var/lib/postgresql/{major-version}`）。如需持久化，建议挂载父目录（如 `-v data-volume:/var/lib/postgresql`）。  
- **初始化参数**（仅首次创建集群时生效，已有数据则忽略）：  
  - `DEFAULT_ENCODING`：集群编码（如 `UTF8`）  
  - `DEFAULT_COLLATION`：排序规则（如 `en_US.UTF-8`）  
  - `DEFAULT_CTYPE`：字符分类（如 `en_US.UTF-8`）  
  - `WAL_SEGSIZE`：WAL 段大小  
  - `PASSWORD_AUTHENTICATION`：认证方式（如 `md5`）  
  - `INITDB_EXTRA_ARGS`：`initdb` 命令的额外参数  
- **强制重建集群**：设置 `RECREATE_DATADIR=TRUE` 会删除现有 `DATADIR` 并重建（重建后需移除该参数，否则每次重启都会重建）。


### 数据库编码
默认集群编码为 `UTF8`，排序规则和字符分类为 `C.UTF-8`。如需自定义，初始化时传入以下环境变量：  
```shell
-e DEFAULT_ENCODING="UTF8" \
-e DEFAULT_COLLATION="en_US.UTF-8" \
-e DEFAULT_CTYPE="en_US.UTF-8"
```


### 基础配置
- `POSTGRES_USER`：数据库用户名（默认 `docker`）  
- `POSTGRES_PASS`：用户密码（默认 `docker`，建议使用强密码）  
- `POSTGRES_DBNAME`：默认数据库名（可指定多个，用逗号分隔，如 `gis,data`）  
- `POSTGRES_MULTIPLE_EXTENSIONS`：启用的扩展（如 `postgis,hstore,postgis_raster`）  
- `SHARED_PRELOAD_LIBRARIES`：预加载扩展（如 `pg_cron`）  
- `SSL_CERT_FILE`/`SSL_KEY_FILE`/`SSL_CA_FILE`：SSL 证书路径（自定义证书时使用）  


### 模式初始化
- `SCHEMA_NAME`：创建的模式名（可指定多个，逗号分隔），默认仅在第一个数据库中创建  
- `ALL_DATABASES=TRUE`：在所有数据库中创建指定模式  


### WAL 与归档配置
- `ARCHIVE_MODE`：是否启用 WAL 归档（默认 `off`，设为 `on` 则启用）  
- `ARCHIVE_COMMAND`：归档命令（默认 `test ! -f /opt/archivedir/%f && cp %p /opt/archivedir/%f`）  
- `WAL_LEVEL`：WAL 级别（默认 `replica`，逻辑复制需设为 `logical`）  
- `WAL_SIZE`：WAL 最大大小（默认 `4GB`）  


### 网络配置
- `ALLOW_IP_RANGE`：允许连接的 IP 范围（默认 `0.0.0.0/0`，即所有 IP）  
- `IP_LIST`：PostgreSQL 监听的 IP（默认 `*`，即所有接口）  


### 额外配置
通过 `EXTRA_CONF` 添加自定义 `postgresql.conf` 配置（用 `\n` 分隔多行）：  
```shell
-e EXTRA_CONF="log_destination = 'stderr'\nlogging_collector = on"
```


## Docker Secrets
为避免敏感信息通过环境变量传递，可在变量名后添加 `_FILE` 从文件读取值（如 Docker Secrets）。支持的变量包括：  
`POSTGRES_PASS_FILE`、`POSTGRES_USER_FILE`、`POSTGRES_DB_FILE`、`SSL_CERT_FILE_FILE` 等。  


## 运行容器

### 基础命令
```shell
docker run --name "postgis" -p 25432:5432 -d -t kartoza/postgis
```
> **注意**：若未指定 `POSTGRES_PASS`，会生成随机密码，可通过容器日志或 `/tmp/PGPASSWORD.txt` 文件查看。


### 使用 docker-compose
项目提供 `docker-compose.yml`，包含数据库和备份服务（基于 [docker-pg-backup]([])），默认暴露端口 `25432`：  
```shell
docker-compose up -d  # 启动服务（数据存储在 Docker 卷中，非本地磁盘）
```


## 连接数据库

### 使用 psql 客户端
1. 安装 PostgreSQL 客户端（以 Ubuntu 为例）：  
   ```shell
   sudo apt-get install postgresql-client-12
   ```
2. 连接数据库：  
   ```shell
   psql -h localhost -U docker -p 25432 -l
   ```


## 启动时执行 SQL 脚本
将 `.sql`、`.sql.gz` 或 `.sh` 文件挂载到 `/docker-entrypoint-initdb.d` 目录，容器启动时会自动执行。默认仅在首次启动时执行，若需每次启动执行，设置 `IGNORE_INIT_HOOK_LOCKFILE=TRUE`。  
示例：  
```shell
docker run -d -v `pwd`/setup.sql:/docker-entrypoint-initdb.d/setup.sql kartoza/postgis
```


## SSL 配置

### 强制 SSL 连接
设置 `FORCE_SSL=TRUE` 强制客户端使用 SSL 连接：  
```shell
docker run -e FORCE_SSL=TRUE -p 25432:5432 -d kartoza/postgis
```

### 使用自定义证书
挂载证书文件并指定路径：  
```shell
docker run -p 25432:5432 \
  -e FORCE_SSL=TRUE \
  -e SSL_CERT_FILE=/ssl/fullchain.pem \
  -e SSL_KEY_FILE=/ssl/privkey.pem \
  -e SSL_CA_FILE=/ssl/root.crt \
  -v /path/to/certs:/ssl \
  -d kartoza/postgis
```


## 复制配置

### 流式复制
支持主从复制，主库和从库通过环境变量配置：  

#### 主库配置
- `REPLICATION=TRUE`：启用复制  
- `REPLICATION_USER`：复制用户名（默认 `replicator`）  
- `REPLICATION_PASS`：复制用户密码（默认 `replicator`，建议自定义）  
- `ALLOW_IP_RANGE`：允许从库 IP 连接  

#### 从库配置
- `REPLICATE_FROM`：主库地址（IP 或域名）  
- `REPLICATE_PORT`：主库端口（默认 `5432`）  
- `DESTROY_DATABASE_ON_RESTART`：重启时是否重建数据（默认 `TRUE`）  
- `PROMOTE_MASTER=TRUE`：将从库提升为主库（提升后需重新配置复制）  


### 逻辑复制
设置 `WAL_LEVEL=logical` 启用逻辑复制，具体配置可参考示例 `sample/logical_replication/docker-compose.yml`。


## 注意事项
- 持久化数据时务必使用标签版本镜像，避免因 PostgreSQL 版本变更导致数据目录不兼容。
- 复制环境中，主库新增表或模式后，需手动授予复制用户权限（如 `ALTER DEFAULT PRIVILEGES IN SCHEMA data GRANT SELECT ON TABLES TO replicator;`）。
- SSL 连接时，客户端需根据证书类型选择合适的 `sslmode`（如自签名证书使用 `sslmode=require`，CA 签名证书可使用 `verify-full`）。
