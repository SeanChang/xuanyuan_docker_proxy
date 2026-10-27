# Docker 部署 Liquibase：轻松搭建数据库变更管理

![Docker 部署 Liquibase：轻松搭建数据库变更管理](https://imgs.xuanyuan.cloud/docker/blog/liquibase/liquibase.webp)

*分类: Docker部署教程 | 标签: Liquibase,liquibase/liquibase,Docker,轩辕镜像,数据库变更,部署教程 | 发布时间: 2026-10-27 16:28:55*

> Liquibase 是一款面向应用和数据团队的数据库变更工具，旨在用 changelog 管理表结构、索引和初始数据，并通过执行记录避免同一变更被重复应用。本文将介绍如何通过 Docker Compose 部署 Liquibase 社区版，对一套 PostgreSQL 执行 changelog，帮助开发人员用同一份变更更新数据库结构，适合应用发版、测试库初始化和多套环境同步等场景。

## Liquibase 是什么

Liquibase 是 Liquibase 公司维护的数据库变更工具。它把建表、改字段、索引和初始数据写成 changelog，按 changeSet 的顺序执行，并在目标库里记下哪些变更已经跑过。社区版 Docker 镜像里有 Liquibase 命令行、Java 和包管理器 lpm，没有管理网页。

和把一段 SQL 直接交给数据库执行不同，Liquibase 会记住每个 changeSet 的执行结果。同一份 changelog 再跑一次时，已经完成的变更会跳过，只继续还没执行的部分。

## Liquibase 能做什么

- **按 changelog 更新数据库**：用 XML、YAML、JSON 或 SQL 描述变更，把表结构和初始数据应用到目标库。
- **改库前先看 SQL**：先生成将要执行的语句，确认后再应用到数据库。
- **查看还没执行的变更**：对照 changelog 和库里的执行记录，看还剩哪些 changeSet。
- **从已有数据库生成 changelog**：把当前库结构写成文件。
- **按记录回退**：changeSet 里写了回退步骤时，可以撤回去。

## 为什么要使用 Liquibase

多人往同一套库里交 SQL 时，测试库和生产库容易各改各的，也不好确认某段脚本有没有执行过。

Liquibase 把变更放进仓库，开发库和测试库用同一份 changelog，执行结果留在库里。适合管理应用表结构、又不想在每台机器上单独安装 Java 的人。

## 使用 Docker 部署 Liquibase

Liquibase 的 Docker 镜像是命令行工具。它执行完指定的变更命令就会退出，不是一直开着的网页服务。部署前准备 Docker，并准备一个它能连上的数据库。本文用 PostgreSQL 作为这次变更的目标库。

接下来用 Docker Compose 写好 changelog 和连接参数，装上 PostgreSQL 驱动，启动数据库并执行变更，再查询表里的数据。

## 环境要求

社区版 **5.0.4** 于 2026-08-20 发布。这次在 Ubuntu 24.04 上实测，主机名 `ikuai-ubuntu2404`。日志里的版本是 **Liquibase 5.0.4**，Java 是 **21.0.11**。镜像构建文件以 Eclipse Temurin 21（Ubuntu Noble）为底，容器用户是 liquibase，UID 和 GID 都是 **1001**。本机不用再装 Java。标签页列出 **linux/amd64** 和 **linux/arm64**。

Liquibase 本身不监听端口。PostgreSQL 发布在宿主机 **5432**，容器内也是 **5432**。changelog 放在工作目录里，挂进容器的 `/liquibase/changelog`。

| 项目 | 建议 |
|------|------|
| 系统 | Linux。macOS 把工作目录换成 `~/docker/liquibase` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **amd64**、**arm64**。命令使用多架构标签 `5.0.4` |
| 磁盘 | Liquibase 镜像、带驱动的本地镜像，以及 PostgreSQL 数据卷 |
| 端口 | 宿主机 **5432** → PostgreSQL 容器 **5432**。Liquibase 无监听端口 |
| 工作目录 | `/www/wwwroot/liquibase` |

5432 已被占用时，只改 Compose 里冒号左边的宿主机端口。容器之间仍用服务名 `postgres` 和容器端口 5432 通信，JDBC 地址不用跟着改。

```bash
docker --version
docker compose version
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```

备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

## 标签怎么选

新安装使用 **`5.0.4`**。这是 2026-08-20 的 Liquibase 社区版。发布说明里写了数据库口令不再出现在报错和日志中，并包含 PostgreSQL、MySQL、MariaDB、Oracle 上的一批修复。

5.0 及以后的社区版在 `liquibase/liquibase`，许可证是 Functional Source License（FSL），可以用它管理自己的数据库变更。Docker 官方库里的 `liquibase` 镜像对应 4.x，4.x 仍是 Apache 2.0。有商业许可、要用策略检查等企业功能时，换 `liquibase/liquibase-secure`。

从 5.0 起，社区版镜像默认不带数据库驱动。连 PostgreSQL 之前，要在构建时用 lpm 把驱动装进镜像。

`latest` 和 `5.0` 目前与 `5.0.4` 是同一镜像，下次发布后会改指向。`5.0.4-alpine` 是同一版本的 Alpine 变体，底包和标准镜像不同。本文命令使用 **`5.0.4`**。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`5.0.4`** | 2026-08-20 的社区版，amd64 与 arm64 | **是** |
| `5.0.4-alpine` | 同一版本的 Alpine 变体 | 否 |
| `5.0`、`latest` | 浮动标签，目前指向 `5.0.4` | 否 |
| `5.0-alpine`、`latest-alpine`、`alpine` | Alpine 浮动标签 | 否 |
| `4.x` 数字标签 | 上一主版本，Apache 2.0 | 否 |

本文的 PostgreSQL 使用 **`17.10`**。上游 Compose 示例写的是 `postgres:15-alpine`，该标签会跟着 15 系列的新版本走。

完整标签见[标签列表](https://xuanyuan.cloud/r/liquibase/liquibase/tags)。5.0.4 的变更写在 [v5.0.4 发布说明](https://github.com/liquibase/liquibase/releases/tag/v5.0.4)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**。

Liquibase：

```bash
docker pull docker.xuanyuan.run/liquibase/liquibase:5.0.4
```

Ubuntu 24.04 上拉取完成：

```text
Digest: sha256:060f96efff4811ccf03957ff3160f21ea04139b89940640f8ad54a065cdc6906
Status: Downloaded newer image for docker.xuanyuan.run/liquibase/liquibase:5.0.4
docker.xuanyuan.run/liquibase/liquibase:5.0.4
```

PostgreSQL：

```bash
docker pull docker.xuanyuan.run/library/postgres:17.10
```

```text
Digest: sha256:7958605b474b3d264a969cb3a123d6aa00ad1e1fe9da8a69984dabb704d93317
Status: Downloaded newer image for docker.xuanyuan.run/library/postgres:17.10
docker.xuanyuan.run/library/postgres:17.10
```

## Docker Compose 部署

下面这份 Compose 让 PostgreSQL 保持运行，并让 Liquibase 执行一次 update。changelog 挂到容器内 `/liquibase/changelog`。连接参数写在 `liquibase.properties`。示例库名 `liquibase_demo`，用户 `liquibase`，口令 `liquibase_password`。

这是示例口令。5432 能被别人访问时，先把口令换成你自己的。`liquibase.properties` 里的 `password`、Compose 里的 `POSTGRES_PASSWORD` 和 `LIQUIBASE_COMMAND_PASSWORD` 要改成同一个值。

5.0 社区版镜像不含 PostgreSQL 驱动。构建阶段会执行 `lpm add postgresql --global`，这一步需要能访问外网。构建出来的本地镜像名是 `liquibase-postgresql:5.0.4`。

Liquibase 在 Compose 网络里通过服务名 `postgres` 连接数据库，JDBC 地址是 `jdbc:postgresql://postgres:5432/liquibase_demo`。这里要写服务名，不写 `127.0.0.1`。

| 宿主机 | 容器内 | 用途 |
|--------|--------|------|
| **5432** | **5432** | PostgreSQL。本机客户端连 `服务器IP:5432` |
| `changelog/` | `/liquibase/changelog` | changelog 文件 |
| `liquibase.properties` | `/liquibase/liquibase.properties` | 连接参数和 changelog 文件名 |
| 数据卷 `postgres_data` | `/var/lib/postgresql/data` | 数据库文件。删除容器不会删除这个卷 |

1. 先看 5432 是否已有进程监听。有输出时，下一步把 `compose.yaml` 里 `5432:5432` 冒号左边改成空闲端口。没有输出再继续：

```bash
sudo ss -lntp | grep -E ':5432' || true
```

这次没有输出，5432 没有进程监听。

2. 创建工作目录。changelog 要让容器里的用户能读，不要把目录权限收成只有所有者可读：

```bash
sudo mkdir -p /www/wwwroot/liquibase/changelog
sudo chown -R "$USER":"$USER" /www/wwwroot/liquibase
cd /www/wwwroot/liquibase
```

3. 写入 changelog。主文件用 `include` 带上建表和插入数据两份变更，路径相对主文件本身：

```bash
cat > changelog/db.changelog-master.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog
    xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
        http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-latest.xsd">

    <include file="001-create-users-table.xml" relativeToChangelogFile="true"/>
    <include file="002-insert-sample-data.xml" relativeToChangelogFile="true"/>

</databaseChangeLog>
EOF

cat > changelog/001-create-users-table.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog
    xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
        http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-latest.xsd">

    <changeSet id="1" author="docker-compose-example">
        <createTable tableName="users">
            <column name="id" type="SERIAL" autoIncrement="true">
                <constraints primaryKey="true" nullable="false"/>
            </column>
            <column name="username" type="VARCHAR(50)">
                <constraints nullable="false" unique="true"/>
            </column>
            <column name="email" type="VARCHAR(100)">
                <constraints nullable="false" unique="true"/>
            </column>
            <column name="created_at" type="TIMESTAMP" defaultValueComputed="CURRENT_TIMESTAMP">
                <constraints nullable="false"/>
            </column>
        </createTable>
    </changeSet>

</databaseChangeLog>
EOF

cat > changelog/002-insert-sample-data.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog
    xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
        http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-latest.xsd">

    <changeSet id="2" author="docker-compose-example">
        <insert tableName="users">
            <column name="username" value="john_doe"/>
            <column name="email" value="john.doe@example.com"/>
        </insert>
        <insert tableName="users">
            <column name="username" value="jane_smith"/>
            <column name="email" value="jane.smith@example.com"/>
        </insert>
    </changeSet>

</databaseChangeLog>
EOF
```

4. 写入连接配置。镜像自带的配置打开了 headless，换了 defaults 文件后仍要保留，避免命令停下来等输入：

```bash
cat > liquibase.properties <<'EOF'
liquibase.headless=true
changeLogFile=db.changelog-master.xml
url=jdbc:postgresql://postgres:5432/liquibase_demo
username=liquibase
password=liquibase_password
driver=org.postgresql.Driver
searchPath=/liquibase/changelog
EOF
```

5. 写入 Dockerfile。这一层在已经拉下的 `5.0.4` 上安装 PostgreSQL 驱动：

```bash
cat > Dockerfile <<'EOF'
FROM docker.xuanyuan.run/liquibase/liquibase:5.0.4
RUN lpm add postgresql --global
EOF
```

6. 写入 `compose.yaml`：

```bash
cat > compose.yaml <<'EOF'
services:
  postgres:
    image: docker.xuanyuan.run/library/postgres:17.10
    container_name: liquibase-postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB: liquibase_demo
      POSTGRES_USER: liquibase
      POSTGRES_PASSWORD: liquibase_password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U liquibase -d liquibase_demo"]
      interval: 10s
      timeout: 5s
      retries: 5

  liquibase:
    build:
      context: .
      dockerfile: Dockerfile
    image: liquibase-postgresql:5.0.4
    container_name: liquibase
    restart: "no"
    depends_on:
      postgres:
        condition: service_healthy
    volumes:
      - ./changelog:/liquibase/changelog
      - ./liquibase.properties:/liquibase/liquibase.properties
    environment:
      LIQUIBASE_COMMAND_URL: jdbc:postgresql://postgres:5432/liquibase_demo
      LIQUIBASE_COMMAND_USERNAME: liquibase
      LIQUIBASE_COMMAND_PASSWORD: liquibase_password
    command: ["--defaults-file=/liquibase/liquibase.properties", "update"]

volumes:
  postgres_data:
EOF
```

| 配置 | 说明 |
|------|------|
| `image: docker.xuanyuan.run/library/postgres:17.10` | PostgreSQL 具体版本 |
| `image: liquibase-postgresql:5.0.4` | 本地构建结果。基础镜像是 `docker.xuanyuan.run/liquibase/liquibase:5.0.4` |
| `restart: "no"` | Liquibase 跑完 update 就退出。不要设成一直重启 |
| `depends_on` + `service_healthy` | 数据库接受连接之后再执行变更 |

7. 构建并启动。构建时 lpm 会下载 PostgreSQL 驱动：

```bash
docker compose up -d --build
```

这次 `[2/2] RUN lpm add postgresql --global` 完成。构建日志把本地镜像写成 `docker.io/library/liquibase-postgresql:5.0.4`，这是本机的构建结果，不是再到 Docker Hub 拉取。随后 PostgreSQL 变为 Healthy，Liquibase 容器启动：

```text
✔ Image liquibase-postgresql:5.0.4      Built
✔ Network liquibase_default             Created
✔ Volume liquibase_postgres_data        Created
✔ Container liquibase-postgres          Healthy
✔ Container liquibase                   Started
```

8. 查看容器状态：

```bash
docker compose ps -a
```

这次查看时，Liquibase 仍在运行，PostgreSQL 已经是 healthy。Liquibase 没有端口映射：

```text
NAME                 IMAGE                                        COMMAND                  SERVICE     CREATED          STATUS                    PORTS
liquibase            liquibase-postgresql:5.0.4                   "/liquibase/docker-e…"   liquibase   29 seconds ago   Up 14 seconds
liquibase-postgres   docker.xuanyuan.run/library/postgres:17.10   "docker-entrypoint.s…"   postgres    30 seconds ago   Up 26 seconds (healthy)   0.0.0.0:5432->5432/tcp, [::]:5432->5432/tcp
```

Liquibase 是命令行，命令结束后容器会退出。刚启动就看状态，经常还是 Up。等下一步日志出现成功字样后，再看退出码。退出码为 0 时，表示这次命令结束时没有报错。

9. 查看 Liquibase 的输出：

```bash
docker compose logs liquibase
```

这次日志里的版本和执行结果是：

```text
Starting Liquibase at 08:16:28 using Java 21.0.11 (version 5.0.4 #11282 built at 2026-08-18 12:10:05 UTC)
Liquibase Version: 5.0.4

Running Changeset: 001-create-users-table.xml::1::docker-compose-example
Running Changeset: 002-insert-sample-data.xml::2::docker-compose-example

UPDATE SUMMARY
Run:                          2
Previously run:               0
Filtered out:                 0
-------------------------------
Total change sets:            2

Liquibase: Update has been successful. Rows affected: 2
Liquibase command 'update' was executed successfully.
```

`Run` 是这次新执行的 changeSet 数，`Previously run` 是库里已经记录过的数量。执行记录写在 `DATABASECHANGELOG` 里。

10. 查询 `users`。第二条 changeSet 插入了 `john_doe` 和 `jane_smith`：

```bash
docker compose exec postgres psql -U liquibase -d liquibase_demo -c "SELECT id, username, email FROM users ORDER BY id;"
```

```text
 id |  username  |         email
----+------------+------------------------
  1 | john_doe   | john.doe@example.com
  2 | jane_smith | jane.smith@example.com
(2 rows)
```

11. 要再跑同一份 changelog，等这次命令结束后执行：

```bash
docker compose up liquibase
```

再看新日志里的 `Previously run`。已经成功的 changeSet 会计入这一列，而不是再记一笔 `Run`。

不再需要这套服务时，在工作目录停止并删除容器。数据卷还在：

```bash
docker compose down
```

数据库文件也不再需要时，再连数据卷一起删除：

```bash
docker compose down -v
```

## 备选：docker run

没有 Compose 时，用下面的命令完成同一次变更。工作目录、changelog、`liquibase.properties` 和 Dockerfile 与上一节相同。

这一节和还在运行的 Compose 不要同时占用 5432。已经用 Compose 启动过时，先在工作目录执行 `docker compose down`。

properties 里的主机名是 `postgres`。数据库容器要加上这个网络别名，JDBC 地址才不用改。

1. 创建网络：

```bash
docker network create liquibase_net
```

2. 启动 PostgreSQL：

```bash
docker run -d 
  --name liquibase-postgres 
  --network liquibase_net 
  --network-alias postgres 
  --restart unless-stopped 
  -e POSTGRES_DB=liquibase_demo 
  -e POSTGRES_USER=liquibase 
  -e POSTGRES_PASSWORD=liquibase_password 
  -p 5432:5432 
  -v liquibase_postgres_data:/var/lib/postgresql/data 
  --health-cmd "pg_isready -U liquibase -d liquibase_demo" 
  --health-interval 10s 
  --health-timeout 5s 
  --health-retries 5 
  docker.xuanyuan.run/library/postgres:17.10
```

3. 等到健康检查变成 healthy，再继续：

```bash
until [ "$(docker inspect --format '{{.State.Health.Status}}' liquibase-postgres)" = "healthy" ]; do
  sleep 2
done
```

4. 构建带 PostgreSQL 驱动的镜像。这一步需要能访问外网：

```bash
cd /www/wwwroot/liquibase
docker build -t liquibase-postgresql:5.0.4 .
```

5. 执行 update。容器结束后会删除，变更留在数据库里：

```bash
docker run --rm 
  --name liquibase 
  --network liquibase_net 
  -v /www/wwwroot/liquibase/changelog:/liquibase/changelog 
  -v /www/wwwroot/liquibase/liquibase.properties:/liquibase/liquibase.properties 
  -e LIQUIBASE_COMMAND_URL="jdbc:postgresql://postgres:5432/liquibase_demo" 
  -e LIQUIBASE_COMMAND_USERNAME="liquibase" 
  -e LIQUIBASE_COMMAND_PASSWORD="liquibase_password" 
  liquibase-postgresql:5.0.4 
  --defaults-file=/liquibase/liquibase.properties 
  update
```

6. 查询 `users`：

```bash
docker exec liquibase-postgres psql -U liquibase -d liquibase_demo -c "SELECT id, username, email FROM users ORDER BY id;"
```

不再需要时，删除数据库容器和网络。数据卷单独再删：

```bash
docker rm -f liquibase-postgres
docker network rm liquibase_net
```

```bash
docker volume rm liquibase_postgres_data
```

## 常见问题

### 浏览器打不开 Liquibase

社区版镜像没有网页，也不映射 HTTP 端口。`docker compose ps` 里只有 PostgreSQL 有 `5432`。变更是否成功，看 Liquibase 日志和数据库里的表。

### 容器还显示 Up，或马上变成退出

刚执行 `docker compose ps` 时，update 可能还在跑，状态是 Up。日志里出现 `Liquibase command 'update' was executed successfully.` 之后，容器会退出。退出码为 0 表示这次命令没有报错。PostgreSQL 应仍在运行。

退出码不是 0 时，用 `docker compose logs liquibase` 看报错。不要把 Liquibase 设成 `restart: always`，失败后会反复执行。

### 日志里找不到 PostgreSQL 驱动

5.0 社区版默认不带 JDBC 驱动。确认 Dockerfile 里有 `RUN lpm add postgresql --global`，并且 liquibase 服务用的是构建出来的 `liquibase-postgresql:5.0.4`。构建日志里如果是下载驱动失败，先确认这台机器能访问外网，再执行 `docker compose up -d --build`。

`INSTALL_MYSQL=true` 只安装 MySQL 驱动，不会装上 PostgreSQL 驱动。

### 想连 MySQL 或已有的数据库

本文的 PostgreSQL 只作演示库。连已有数据库时，改 `liquibase.properties` 里的 `url`、`username`、`password` 和 `driver`，并装上对应驱动。MySQL 驱动因许可未随镜像提供，可以在启动时设置 `INSTALL_MYSQL=true`。在 Compose 网络里，主机名写服务名，不写 `127.0.0.1`。

### changelog 报找不到文件

changelog 目录要挂到 `/liquibase/changelog`。`changeLogFile` 写相对这个目录的文件名，例如 `db.changelog-master.xml`。`include` 使用 `relativeToChangelogFile="true"` 时，被包含的文件和主文件放在同一目录。5.0.4 在默认的安全解析下会拒绝带 DOCTYPE 声明的 XML changelog，标准 changelog 不要加 DOCTYPE。

### 第二次执行又插入了数据，或报唯一约束冲突

Liquibase 只跳过已经记入 `DATABASECHANGELOG` 的 changeSet。如果第一次 update 没成功，表可能建了一半，记录里没有这次 changeSet，再跑会按 changelog 重新执行。先看 `docker compose logs liquibase`。确认库可以清空时，再执行 `docker compose down -v`，然后重新 `docker compose up -d`。不要在还要保留数据的库上删数据卷。

### 口令改了一处，还是登不进去

示例口令 `liquibase_password` 要在三个地方保持一致：`liquibase.properties` 的 `password`、`POSTGRES_PASSWORD`、`LIQUIBASE_COMMAND_PASSWORD`。数据卷已经用旧口令初始化之后，只改环境变量不会改掉库里的口令。

### 用 latest 或 5.0 可以吗

这两个标签目前指向 5.0.4，下次发布后会指向新版本。本文命令使用 `5.0.4`。

## 命令速查

```bash
docker pull docker.xuanyuan.run/liquibase/liquibase:5.0.4
docker pull docker.xuanyuan.run/library/postgres:17.10

cd /www/wwwroot/liquibase
docker compose up -d --build
docker compose ps -a
docker compose logs liquibase
docker compose exec postgres psql -U liquibase -d liquibase_demo -c "SELECT id, username, email FROM users ORDER BY id;"

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。Liquibase 没有网页，也没有预置的登录账号。数据库示例用户是 `liquibase`，示例口令是 `liquibase_password`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [liquibase/liquibase 镜像页](https://xuanyuan.cloud/r/liquibase/liquibase) | [https://xuanyuan.cloud/r/liquibase/liquibase](https://xuanyuan.cloud/r/liquibase/liquibase) |
| [liquibase/liquibase 标签列表](https://xuanyuan.cloud/r/liquibase/liquibase/tags) | [https://xuanyuan.cloud/r/liquibase/liquibase/tags](https://xuanyuan.cloud/r/liquibase/liquibase/tags) |
| [Docker Hub · liquibase/liquibase](https://hub.docker.com/r/liquibase/liquibase) | [https://hub.docker.com/r/liquibase/liquibase](https://hub.docker.com/r/liquibase/liquibase) |
| [GitHub · liquibase/liquibase](https://github.com/liquibase/liquibase) | [https://github.com/liquibase/liquibase](https://github.com/liquibase/liquibase) |
| [Docker 镜像说明](https://github.com/liquibase/liquibase/blob/main/docker/README.md) | [https://github.com/liquibase/liquibase/blob/main/docker/README.md](https://github.com/liquibase/liquibase/blob/main/docker/README.md) |
| [v5.0.4 发布说明](https://github.com/liquibase/liquibase/releases/tag/v5.0.4) | [https://github.com/liquibase/liquibase/releases/tag/v5.0.4](https://github.com/liquibase/liquibase/releases/tag/v5.0.4) |
| [Issues](https://github.com/liquibase/liquibase/issues) | [https://github.com/liquibase/liquibase/issues](https://github.com/liquibase/liquibase/issues) |
| [已归档的 liquibase/docker 仓库](https://github.com/liquibase/docker) | [https://github.com/liquibase/docker](https://github.com/liquibase/docker) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

镜像的 Dockerfile 现放在 `liquibase/liquibase` 仓库的 `docker/` 目录。`liquibase/docker` 仓库已归档，问题提到上面的 Issues。

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/liquibase-docker-deploy)

*本文基于 [liquibase/liquibase:5.0.4](https://xuanyuan.cloud/r/liquibase/liquibase)，实测引擎 **Liquibase 5.0.4**，Java **21.0.11**，测试平台 **Ubuntu 24.04** Linux。*


