---
image: library/postgres
description: "PostgreSQL作为一款功能强大的对象关系型数据库系统，凭借其先进的架构设计与完善的技术机制，不仅能高效融合关系型数据的结构化管理与对象型数据的灵活扩展，更通过严格的ACID事务支持、多版本并发控制及全面的数据校验机制，为各类应用场景提供卓越的系统可靠性与极致的数据完整性保障，是全球广泛应用的开源数据库优选方案。"
source: https://xuanyuan.cloud/zh/r/library/postgres
canonical: https://xuanyuan.cloud/zh/r/library/postgres
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/postgres" title="library/postgres Docker 镜像中文简介、标签列表与拉取命令">library/postgres — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/postgres" title="library/postgres Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/postgres</a>

# PostgreSQL Docker 镜像使用指南


## 说明
## 快速参考

### 维护方
[PostgreSQL Docker 社区]([])

### 帮助支持
可通过 [Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([]) 获取帮助。


## 支持的标签及对应 Dockerfile 链接

- **18.x 版本**  
  [`18.0`, `18`, `latest`, `18.0-trixie`, `18-trixie`, `trixie`]([])  
  [`18.0-bookworm`, `18-bookworm`, `bookworm`]([])  
  [`18.0-alpine3.22`, `18-alpine3.22`, `alpine3.22`, `18.0-alpine`, `18-alpine`, `alpine`]([])  
  [`18.0-alpine3.21`, `18-alpine3.21`, `alpine3.21`]([])  

- **17.x 版本**  
  [`17.6`, `17`, `17.6-trixie`, `17-trixie`]([])  
  [`17.6-bookworm`, `17-bookworm`]([])  
  [`17.6-alpine3.22`, `17-alpine3.22`, `17.6-alpine`, `17-alpine`]([])  
  [`17.6-alpine3.21`, `17-alpine3.21`]([])  

- **16.x 版本**  
  [`16.10`, `16`, `16.10-trixie`, `16-trixie`]([])  
  [`16.10-bookworm`, `16-bookworm`]([])  
  [`16.10-alpine3.22`, `16-alpine3.22`, `16.10-alpine`, `16-alpine`]([])  
  [`16.10-alpine3.21`, `16-alpine3.21`]([])  

- **15.x 及以下版本**  
  完整标签列表见 [GitHub 文档]([])。


## 快速参考（续）

- **问题反馈**：[GitHub Issues]([])  
- **支持架构**：`amd64`、`arm32v5`、`arm32v6`、`arm32v7`、`arm64v8`、`i386`、`mips64le`、`ppc64le`、`riscv64`、`s390x`（[详情]([])）  
- **镜像信息**：[repo-info 仓库]([])（含元数据、传输大小等）  
- **镜像更新**：[official-images 仓库标签]([]) 及 [配置文件]([])  
- **文档来源**：[docs 仓库]([])  


## 什么是 PostgreSQL？

PostgreSQL（常简称“Postgres”）是一款强调可扩展性和标准兼容性的对象关系型数据库管理系统（ORDBMS）。作为数据库服务器，其核心功能是安全存储数据并支持最佳实践，同时支持本地或网络（含互联网）中的应用程序按需检索数据。它可处理从小型单机应用到高并发互联网应用的各类负载，最新版本还支持数据库复制以提升安全性和可扩展性。

PostgreSQL 实现了 SQL:2011 标准的大部分功能，支持 ACID 事务（含多数 DDL 语句），通过多版本并发控制（MVCC）避免锁竞争，提供防脏读和完全可序列化能力。它支持复杂 SQL 查询、多种索引类型、可更新视图、物化视图、触发器、外键，以及函数和存储过程，并拥有丰富的第三方扩展。此外，PostgreSQL 支持从其他数据库迁移，通过标准 SQL 兼容和迁移工具，甚至可通过内置或第三方扩展模拟专有数据库的特性（如 Oracle）。

> 更多信息：[维基百科]()

![PostgreSQL 标志]([])


## 如何使用本镜像

### 启动 PostgreSQL 实例

```bash
$ docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
```

入口脚本会通过 `initdb` 创建默认用户（`postgres`）和数据库。  
> **说明**：`postgres` 数据库是默认数据库，供用户、工具和第三方应用使用（[PostgreSQL 文档]([])）。


### 通过 `psql` 连接

```bash
$ docker run -it --rm --network some-network postgres psql -h some-postgres -U postgres
psql (14.3)
Type "help" for help.

postgres=# SELECT 1;
 ?column? 
----------
        1
(1 row)
```


### 通过 `docker compose` 部署

`compose.yaml` 示例：

```yaml
# 使用 postgres/example 作为用户/密码凭证
services:
  db:
    image: postgres
    restart: always
    shm_size: 128mb  # 设置共享内存限制（docker compose 方式）
    # 若通过 swarm stack 部署，可改用 tmpfs 挂载：
    # volumes:
    #   - type: tmpfs
    #     target: /dev/shm
    #     tmpfs:
    #       size: 134217728  # 128MB
    environment:
      POSTGRES_PASSWORD: example

  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080
```

执行 `docker compose up`，待初始化完成后访问 `[] 或 `[] 如何扩展本镜像

### 环境变量

PostgreSQL 镜像依赖多个环境变量，其中 `POSTGRES_PASSWORD` 为必填项，其他为可选。  
**注意**：仅当容器数据目录为空时，以下变量才生效；若目录中已有数据库，启动时将忽略这些变量。


#### `POSTGRES_PASSWORD`  
必填，用于设置 PostgreSQL 超级用户密码。默认超级用户由 `POSTGRES_USER` 定义。  
- **注意1**：镜像默认对本地连接启用 `trust` 认证，因此容器内通过 `localhost` 连接无需密码，但跨容器/主机连接仍需密码。  
- **注意2**：此变量仅在初始化时设置超级用户密码，与运行时 `psql` 客户端使用的 `PGPASSWORD` 环境变量无关（[详情]([])）。


#### `POSTGRES_USER`  
可选，与 `POSTGRES_PASSWORD` 配合创建超级用户及同名数据库。若未指定，默认用户为 `postgres`。  
> 初始化时可能显示“数据库文件属主为 user 'postgres'”，此处指 Linux 系统用户（镜像内 `/etc/passwd` 定义），与 `POSTGRES_USER` 无关。


#### `POSTGRES_DB`  
可选，指定初始化时创建的默认数据库名称。若未指定，默认使用 `POSTGRES_USER` 的值。


#### `POSTGRES_INITDB_ARGS`  
可选，传递参数给 `initdb`。例如启用数据页校验和：  
```bash
-e POSTGRES_INITDB_ARGS="--data-checksums"
```


#### `POSTGRES_INITDB_WALDIR`  
可选，指定事务日志（WAL）存储路径（默认位于 `PGDATA` 子目录）。PostgreSQL 9.x 中变量名为 `POSTGRES_INITDB_XLOGDIR`（因 10+ 版本将 `--xlogdir` 重命名为 `--waldir`）。


#### `POSTGRES_HOST_AUTH_METHOD`  
可选，控制 `host` 类型连接的认证方式（适用于所有数据库、用户和地址）。默认值：14+ 版本为 `scram-sha-256`，旧版本为 `md5`。初始化时会向 `pg_hba.conf` 添加如下行：  
```bash
echo "host all all all $POSTGRES_HOST_AUTH_METHOD" >> pg_hba.conf
```  
- **注意1**：不建议使用 `trust`（无需密码即可连接）。  
- **注意2**：若设为 `trust`，则 `POSTGRES_PASSWORD` 非必填。  
- **注意3**：若使用其他值（如 `scram-sha-256`），可能需配合 `POSTGRES_INITDB_ARGS=--auth-host=scram-sha-256`。


#### `PGDATA`  
> **重要变更**：PostgreSQL 18+ 版本中，`PGDATA` 默认路径改为 `/var/lib/postgresql/18/docker`（后续版本将 `18` 替换为对应主版本号），且镜像定义的 `VOLUME` 为 `/var/lib/postgresql`。建议将数据卷挂载到 `/var/lib/postgresql`。  
> 旧版本用户可手动指定 `PGDATA` 以适配新路径（如 `--env PGDATA=/var/lib/postgresql/17/docker`），并迁移数据至 `PG_MAJOR/docker` 子目录。  
> **注意**：17 及以下版本需挂载 `/var/lib/postgresql/data`（而非 `/var/lib/postgresql`），否则数据不会持久化（因镜像默认在 `/var/lib/postgresql/data` 声明匿名卷）。


### Docker Secrets

通过环境变量后缀 `_FILE` 从文件加载敏感信息（如 Docker Secrets）。例如从 `/run/secrets/postgres-passwd` 读取密码：  
```bash
docker run --name some-postgres -e POSTGRES_PASSWORD_FILE=/run/secrets/postgres-passwd -d postgres
```  
目前支持 `POSTGRES_INITDB_ARGS`、`POSTGRES_PASSWORD`、`POSTGRES_USER`、`POSTGRES_DB`。


### 初始化脚本

在 `/docker-entrypoint-initdb.d` 目录下添加 `*.sql`、`*.sql.gz` 或 `*.sh` 脚本，可在数据库初始化后自动执行（仅当数据目录为空时）。  

**示例**：创建用户和数据库的 `init-user-db.sh` 脚本：  
```bash
#!/usr/bin/env bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER docker;
    CREATE DATABASE docker;
    GRANT ALL PRIVILEGES ON DATABASE docker TO docker;
EOSQL
```  
脚本按文件名排序执行（默认 locale 为 `en_US.utf8`），`*.sql` 文件由 `POSTGRES_USER` 执行，`*.sh` 脚本建议通过 `--username "$POSTGRES_USER"` 指定用户。


### 数据库配置

#### 方法1：自定义配置文件  
1. 获取默认配置：  
   ```bash
   docker run -i --rm postgres cat /usr/share/postgresql/postgresql.conf.sample > my-postgres.conf
   ```  
2. 修改配置（需设置 `listen_addresses = '*'` 允许跨容器连接）。  
3. 启动容器：  
   ```bash
   docker run -d --name some-postgres -v "$PWD/my-postgres.conf":/etc/postgresql/postgresql.conf -e POSTGRES_PASSWORD=mysecretpassword postgres -c 'config_file=/etc/postgresql/postgresql.conf'
   ```


#### 方法2：运行时指定参数  
通过 `docker run` 命令直接传递参数（支持所有 `.conf` 文件中的配置项，格式 `-c key=value`）：  
```bash
docker run -d --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword postgres -c shared_buffers=256MB -c max_connections=200
```


### 本地化配置

#### Debian 基础镜像  
通过 `Dockerfile` 扩展以设置 locale（如 `de_DE.utf8`）：  
```dockerfile
FROM postgres:14.3
RUN localedef -i de_DE -c -f UTF-8 -A /usr/share/locale/locale.alias de_DE.UTF-8
ENV LANG de_DE.utf8
```


#### Alpine 基础镜像  
PostgreSQL 15+ 的 Alpine 版本支持 ICU 本地化（旧版本不支持）。通过 `POSTGRES_INITDB_ARGS` 设置：  
```bash
docker run -d -e LANG=de_DE.utf8 -e POSTGRES_INITDB_ARGS="--locale-provider=icu --icu-locale=de-DE" -e POSTGRES_PASSWORD=mysecretpassword postgres:15-alpine 
```


### 扩展插件

- **Debian 镜像**：直接安装包（如 PostGIS），参考 [postgis/docker-postgis]([])。  
- **Alpine 镜像**：非 `postgres-contrib` 插件需手动编译，参考 [postgis/docker-postgis]([])。


### 任意 `--user` 说明

镜像支持通过 `docker run --user` 以非默认用户启动（[#253]([])、[#1018]([]
