# Docker 部署 Hue：轻松搭建数据库与数据仓库 SQL 查询平台

![Docker 部署 Hue：轻松搭建数据库与数据仓库 SQL 查询平台](https://imgs.xuanyuan.cloud/docker/blog/hue/hue.webp)

*分类: Docker部署教程 | 标签: Hue,Docker,轩辕镜像,SQL,数据仓库,私有化部署,部署教程 | 发布时间: 2026-10-18 20:27:49*

> Hue 是一款面向数据分析人员的开源 SQL 助手，旨在把多种数据库和数据仓库的查询放在同一个网页里，并通过编辑器、查询历史和账号权限组织团队的查询工作。本文将介绍如何通过 Docker Compose 快速部署 Hue，搭建可自托管的 SQL 查询平台，帮助团队在自己的服务器上编写和保存查询，适合内部数据查询及给已有数据库加一个网页入口等场景。

*本文基于 [gethue/hue:20260611-140101](https://xuanyuan.cloud/zh/r/gethue/hue) 与 [library/mysql:8.4.11](https://xuanyuan.cloud/zh/r/library/mysql)，实测 Hue **4.11.0**、Python **3.11.0rc1**，数据库 MySQL **8.4.11**，测试平台 **Ubuntu 24.04** Linux。*

## Hue 是什么

Hue 是一套开源 SQL 助手，代码在 Cloudera 的 Hue 仓库里，许可为 Apache 2.0。查询编辑器在网页里，用来查看数据库和数据仓库中的数据，并保存查询、结果和账号。分析人员用浏览器打开同一个入口，按解释器切换要查询的数据源。

## Hue 能做什么

- **在浏览器里写 SQL**：编辑器提供补全和语法检查，执行后直接看结果。
- **留下查询历史**：写过的语句留在服务器上，下次可以打开继续改。
- **按账号分工**：第一次登录的用户成为管理员，之后可以添加用户，并控制谁能看到查询。
- **连接多种数据源**：同一套界面里配置 MySQL、PostgreSQL、Hive、Impala、Spark SQL、Presto、ClickHouse 等解释器。
- **把查询分享给同事**：语句和结果放在同一套系统里，按账号授权查看。

## 为什么要使用 Hue

分析人员各用各的客户端时，连接串、查询历史和权限散在个人电脑上。换一台机器就要重新配。Hue 把这些放在自己的服务器上。

它适合要给团队一个统一查询入口的人，也适合先把网页编辑器接上已有的 MySQL，以后再加数据仓库解释器的人。本文这一套先接 Hue 自己的 MySQL，用来确认编辑器能打开库里的表。

## 使用 Docker 部署 Hue

官方镜像里已经带上 Hue 的运行环境。元数据库要另起一个容器，本机不必单独安装 Python 和 MySQL。开始之前，先准备好 Docker，并留出存放配置和数据库文件的目录。

接下来用 Docker Compose 写好这两部分的参数，启动两个容器，并在浏览器里完成第一次登录。

## 环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Ubuntu 24.04；macOS 把 `/www/wwwroot/hue` 换成 `~/docker/hue` |
| Docker | Engine + **Compose V2**（`docker compose`） |
| 架构 | `20260611-140101` 在 Docker Hub 上只有 **linux/amd64**。`library/mysql:8.4.11` 另有 arm64。两份一起跑时，宿主机用 amd64 |
| CPU | 镜像里的 Polars **1.8.2** 需要 **AVX2**。这台 Ubuntu 24.04 没有 `avx2`、`fma`、`bmi1`、`bmi2`、`lzcnt`、`movbe`。`start-hue.sh` 会在容器启动时换成同版本的 `polars-lts-cpu` |
| 磁盘 | Ubuntu 24.04 上 `docker images` 显示 Hue DISK **3.65 GB**、CONTENT **767 MB**，MySQL DISK **1.12 GB**、CONTENT **254 MB**；`mysql/` 数据目录另计 |
| 端口 | 宿主机 **8888/tcp** → Hue 容器 **8888**。MySQL 只在 Compose 网络内访问，不映射到宿主机 |
| 工作目录 | `/www/wwwroot/hue` |

镜像基于 Ubuntu 22.04，工作目录是 `/usr/share/hue`，进程用户是 `hue`（uid **1001**），对外端口是 **8888**，默认命令是 `./startup.sh`。数据库不在 Hue 镜像里。

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

Hue 现在发布到 Docker Hub 的标签主要是日期构建号，形如 `20260611-140101`。官方文档里的示例写的是 `latest`。截至 2026-10-18，`latest` 与 `20260611-140101` 指向同一份镜像，digest 见「拉取镜像」。`20260511-140101` 到 `20260610-140101` 这一段也是这份镜像。本文命令使用其中最新的日期标签。

仓库里最后一次带版本号的发布标签是 `4.11.0`（2023-01-19）。那是另一份镜像，digest 以 `sha256:11b649636e68` 开头。界面上的 Hue **4.11.0** 来自这次日期标签的启动日志，与 2023 年的 `4.11.0` 标签不是同一份镜像。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`20260611-140101`** | 与当前 `latest` 同一份镜像的日期标签 | **是** |
| `latest` | 浮动标签，以后会改指向 | 否 |
| `20260610-140101` 以及更早的日期标签 | 构建日期更早。上面这一段目前仍是同一份镜像 | 否 |
| `4.11.0` | 2023-01-19 的发布标签 | 否 |

| 数据库标签 | 说明 | 是否写入本文命令 |
|------------|------|------------------|
| **`8.4.11`** | MySQL 8.4 的具体版本 | **是** |
| `8.4`、`8`、`latest` | 随小版本移动 | 否 |
| `5.7` | 上游 Compose 示例里的镜像标签 | 否 |

上游 `tools/docker/hue/docker-compose.yml` 使用 `mysql:5.7`，并把 `MYSQL_USER` 写成 `root`、口令写成 `secret`。`root` 是 MySQL 镜像里已经存在的账号。本文另建账号 `hue`，口令随机生成。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/gethue/hue:20260611-140101
docker pull docker.xuanyuan.run/library/mysql:8.4.11
```

Ubuntu 24.04 实测：

```text
Digest: sha256:7d5c1b9f8a79ac987e3a04fba987890dd9cd6055c6c475e63fcb0355455fa4e1
Status: Downloaded newer image for docker.xuanyuan.run/gethue/hue:20260611-140101
docker.xuanyuan.run/gethue/hue:20260611-140101
```

```text
Digest: sha256:24989179f58856db763f418010c1169fecc944e3ec1ea7e921572d83eb070f70
Status: Downloaded newer image for docker.xuanyuan.run/library/mysql:8.4.11
docker.xuanyuan.run/library/mysql:8.4.11
```

拉取完成后确认本地有这两个标签：

```bash
docker images docker.xuanyuan.run/gethue/hue:20260611-140101
docker images docker.xuanyuan.run/library/mysql:8.4.11
```

```text
IMAGE                                            ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/gethue/hue:20260611-140101   7d5c1b9f8a79       3.65GB          767MB

IMAGE                                      ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/library/mysql:8.4.11   24989179f588       1.12GB          254MB
```

## Docker Compose 部署

工作目录是 `/www/wwwroot/hue`。`hue.ini` 挂到容器内 `/usr/share/hue/desktop/conf/z-hue.ini`，用来覆盖镜像里的数据库和解释器。`mysql/` 对应 `/var/lib/mysql`，存放 MySQL 数据。

先把 `hue.ini` 写成文件再启动。如果这个路径还不存在，Docker 会把它建成目录，容器就读不到配置。

第一次启动前，`mysql/` 保持为空。里面已经有数据时，`MYSQL_USER` 和 `MYSQL_PASSWORD` 不会再生效。

不配 MySQL、只挂配置时，Hue 使用容器里的 SQLite。官方说明这种情况会报 `database is locked`，用户和查询历史也会随容器删除而丢失。本文把 `[[database]]` 指到 MySQL。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/hue/mysql
sudo chown -R "$USER":"$USER" /www/wwwroot/hue
```

2. `mysql/` 仍为空时，再生成数据库口令并写入 `compose.yaml` 和 `hue.ini`。目录里已经有 MySQL 数据时，不要重新执行这一步，否则新口令和已初始化的账号对不上。口令写在 `db_password.txt`，这是数据库账号 `hue` 的口令。登录 Hue 的管理员口令在「浏览器首次使用」里另设，两者不要用成同一个。

`umask 077` 让 `db_password.txt` 和 `compose.yaml` 只有当前用户可读。`hue.ini` 在 umask 调回 `022` 之后再写，并设成 `644`。容器里的进程用户是 uid 1001，文件不对其他用户可读时，Hue 读不到这段配置。`hue.ini` 里有数据库口令，不要把这个目录放到公开位置。

```bash
cd /www/wwwroot/hue
DB_PASSWORD="$(openssl rand -hex 24)"
SECRET_KEY="$(openssl rand -hex 32)"
umask 077
printf '%s
' "$DB_PASSWORD" > db_password.txt
cat > compose.yaml <<EOF
name: hue

services:
  hue:
    image: docker.xuanyuan.run/gethue/hue:20260611-140101
    container_name: hue
    restart: unless-stopped
    depends_on:
      db:
        condition: service_healthy
    ports:
      - "8888:8888"
    command: ["./start-hue.sh"]
    environment:
      TZ: Asia/Shanghai
    volumes:
      - ./hue.ini:/usr/share/hue/desktop/conf/z-hue.ini
      - ./start-hue.sh:/usr/share/hue/start-hue.sh:ro

  db:
    image: docker.xuanyuan.run/library/mysql:8.4.11
    container_name: hue-db
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: hue
      MYSQL_USER: hue
      MYSQL_PASSWORD: ${DB_PASSWORD}
      MYSQL_RANDOM_ROOT_PASSWORD: "yes"
      TZ: Asia/Shanghai
    volumes:
      - ./mysql:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "127.0.0.1", "-uhue", "-p${DB_PASSWORD}", "--silent"]
      interval: 10s
      timeout: 5s
      retries: 30
      start_period: 40s

EOF
umask 022
cat > hue.ini <<EOF
[desktop]
secret_key=${SECRET_KEY}
http_host=0.0.0.0
http_port=8888
time_zone=Asia/Shanghai

[[database]]
engine=mysql
host=db
port=3306
user=hue
password=${DB_PASSWORD}
name=hue

[notebook]
[[interpreters]]
[[[mysql]]]
name=MySQL
interface=sqlalchemy
options='{"url": "mysql://hue:${DB_PASSWORD}@db:3306/hue"}'
EOF
chmod 644 hue.ini
cat > start-hue.sh <<'EOF'
#!/bin/sh
set -e
cd /usr/share/hue
if ! ./build/env/bin/python -c "import polars" >/dev/null 2>&1; then
  VER=$(./build/env/bin/python -c "import importlib.metadata as m; print(m.version('polars'))")
  ./build/env/bin/pip uninstall -y polars
  ./build/env/bin/pip install --no-cache-dir "polars-lts-cpu==${VER}"
fi
exec ./startup.sh
EOF
chmod 755 start-hue.sh
unset DB_PASSWORD SECRET_KEY
```

| 参数 | 说明 |
|------|------|
| `8888:8888` | 宿主机 **8888** → 容器 **8888** |
| `host: db` | 数据库主机名用 Compose 服务名 `db` |
| `MYSQL_DATABASE` 与 `hue.ini` 的 `name` | 库名都写成 `hue`。库由 MySQL 在 `mysql/` 为空时创建 |
| `MYSQL_PASSWORD` 与 `hue.ini` 里的 `password` | 同一串口令，来自 `db_password.txt` |
| `MYSQL_RANDOM_ROOT_PASSWORD` | `root` 使用随机口令，写在 `hue-db` 的日志里。日常连接用账号 `hue` |
| `secret_key` | `openssl rand -hex 32` 生成，写入 `hue.ini` |
| `./hue.ini` | 挂到 `/usr/share/hue/desktop/conf/z-hue.ini`。同目录里还有镜像自带的配置，这个文件排在后面，用来覆盖数据库和 MySQL 解释器 |
| `./start-hue.sh` | 挂到 `/usr/share/hue/start-hue.sh`，并作为容器命令 |
| `./mysql` | 数据库文件落在宿主机目录 |
| `depends_on` + `healthcheck` | MySQL 能应答 `mysqladmin ping` 之后，再启动 Hue。Hue 启动时会先做数据库迁移 |

镜像自带的 `./startup.sh` 会导入 Polars **1.8.2**。这台机器没有 AVX2 等指令时，进程报 `Illegal instruction`，退出码 **-4**，`curl` 没有输出。`start-hue.sh` 在导入失败时卸掉这份 Polars，安装同版本的 `polars-lts-cpu`，再执行 `./startup.sh`。这次装上的是 **polars-lts-cpu 1.8.2**。装好的包留在这只容器里。删掉容器再创建，会再装一次。`docker compose restart hue` 不会清掉已经装好的包。第一次安装要能访问 PyPI。完整报错见「常见问题」。

3. 启动：

```bash
cd /www/wwwroot/hue
docker compose up -d
```

Ubuntu 24.04 实测：空目录第一次初始化 MySQL，等到 healthy 用了 **94.2** 秒。MySQL 已经在跑、只拉起 Hue 时，这次用了 **14** 秒。下面是后一种输出。Hue 容器起来之后还要安装 Polars 并做迁移。

```text
[+] up 2/2
 ✔ Container hue-db Healthy  14.0s
 ✔ Container hue    Started  15.0s
```

4. 看两个容器是否在运行。`hue-db` 为 healthy，`hue` 发布 `8888`，命令列是 `./start-hue.sh`。刚执行完 `up` 时 Hue 可能只显示 Up 不到一秒，这时 Polars 还在安装，页面还打不开。下面这份 `ps` 是 MySQL 已经跑了一段时间之后看的：

```bash
docker compose ps
```

```text
NAME      IMAGE                                            COMMAND                  SERVICE   CREATED          STATUS                    PORTS
hue       docker.xuanyuan.run/gethue/hue:20260611-140101   "./start-hue.sh"         hue       15 seconds ago   Up Less than a second     0.0.0.0:8888->8888/tcp, [::]:8888->8888/tcp
hue-db    docker.xuanyuan.run/library/mysql:8.4.11         "docker-entrypoint.s…"   db        13 minutes ago   Up 13 minutes (healthy)   3306/tcp, 33060/tcp
```

5. 看 Hue 容器日志。这台机器上，第一次启动会先下载 `polars-lts-cpu`，再执行 `./startup.sh` 做数据库迁移。等到出现 `Listening at: http://0.0.0.0:8888` 再打开浏览器：

```bash
docker compose logs -f --tail 100 hue
```

pip 会提示 `/home/hue/.cache/pip` 不可写，缓存被关掉，安装仍然完成。日志从 19:59:55（+0800）打印 Hue **4.11.0**，迁移结束时权限记录增加 34 条。Gunicorn **23.0.0** 在 20:04:21（+0800）开始监听，同一时刻的日志行写成 `12:04:21 +0000`。worker 是 **gthread**。

```text
Found existing installation: polars 1.8.2
Uninstalling polars-1.8.2:
  Successfully uninstalled polars-1.8.2
Successfully installed polars-lts-cpu-1.8.2
[18/Oct/2026 19:59:55 +0800] settings     INFO     Welcome to Hue 4.11.0
[18/Oct/2026 19:59:55 +0800] settings     INFO     Python version: 3.11.0rc1
[18/Oct/2026 20:03:33 +0800] models       INFO     HuePermissions: 34 added, 0 updated, 0 up to date, 0 stale, 0 deleted
[18/Oct/2026 20:04:21 +0800] gunicorn_server_utils INFO     Welcome to Hue from Gunicorn server 4.11.0
[2026-10-18 12:04:21 +0000] [33] [INFO] Listening at: http://0.0.0.0:8888 (33)
[2026-10-18 12:04:21 +0000] [33] [INFO] Using worker: gthread
```

同一段日志里还有 `mozilla_django_oidc`、`py4j`、`simple_salesforce`、File Browser、`libmagic`、`django-csp` 未安装，以及 `Keytab renewer not starting, no keytab configured`。这套 Compose 没有 Kerberos 和这些可选模块。`kt_renewer` 随后正常退出。这些行不影响登录页。

6. Gunicorn 开始监听之后，在服务器本机看响应头。得到 **302**，`Location` 指向登录页：

```bash
curl -sI http://127.0.0.1:8888/
```

```text
HTTP/1.1 302 Found
Server: gunicorn
Date: Sun, 18 Oct 2026 12:09:30 GMT
Connection: keep-alive
Content-Type: text/html; charset=utf-8
Location: /hue/accounts/login?next=/
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
Cross-Origin-Opener-Policy: same-origin
Vary: Accept-Language, Cookie
Content-Language: en-us
Content-Length: 0
audited: False
```

浏览器访问 `http://服务器IP:8888`。本机调试用 `http://127.0.0.1:8888`。

## 浏览器首次使用

镜像没有预置管理员。第一次打开是创建账号页。谁先提交用户名和口令，谁就成为管理员。完成这次登录之前，不要把 `8888` 暴露到公网。这里的口令与 `db_password.txt` 不是同一个。

1. 打开 `http://服务器IP:8888`。根路径返回 302，浏览器进入 `/hue/accounts/login?next=/`。页眉是 Hue 标志和 `Query. Explore. Repeat.`。提示写着 Since this is your first time logging in, pick any username and password. Be sure to remember these, as they will become your Hue superuser credentials. 两个输入框的占位文字是「用户名」和「密码」，按钮是 **Create Account**。

![Hue 首次登录页，提示将成为超级用户，按钮 Create Account](https://imgs.xuanyuan.cloud/docker/blog/hue/hue-1.webp)

2. 填写用户名和口令，点 **Create Account**。这次用户名是 `admin`。进入后编辑器标题是 **Hive**。左侧 Databases 显示 `Error loading databases.`，上方是 `No databases found`，右侧 Tables 是 `No tables identified.`。Saved Queries 写着 `You don't have any saved queries.`。左侧 **Editor** 里还有 Impala。Hive 和 Impala 在这套 Compose 里没有对应服务。

![登录后默认打开 Hive 编辑器，左侧 Error loading databases](https://imgs.xuanyuan.cloud/docker/blog/hue/hue-2.webp)

3. 在左侧 **Editor** 里点 **MySQL**。库 `hue` 出现，Tables 显示 **(80)**，其中有 `auth_user`、`auth_group`、`django_content_type`、`desktop_document2`、`beeswax_savedquery`。这些是 Hue 自己的元数据。左下角用户名是 `admin`，版本是 **4.11.0**。还没点开某一张表时，右侧仍是 `No tables identified.`。

![MySQL 解释器列出库 hue 的 80 张表，页脚用户 admin、版本 4.11.0](https://imgs.xuanyuan.cloud/docker/blog/hue/hue-3.webp)

4. 左侧点 **Dashboard**，再点 **Table (MySQL)**，表选 `hue.auth_group`。Grid Results 显示 1 行，`id` 为 1，`name` 为 `default`。右侧 Indexes 列出 `id` integer 和 `name` varchar(190)。页脚仍是 **4.11.0**。能看到这一行，说明已经连上 MySQL。

![Dashboard 打开 hue.auth_group，结果一行 name 为 default](https://imgs.xuanyuan.cloud/docker/blog/hue/hue-4.webp)

之后再打开登录页，使用这个账号。其他用户由这位管理员在左侧 **Administer Users** 里创建。

## 数据、升级与访问

数据库口令在 `db_password.txt`、`compose.yaml` 和 `hue.ini` 里。Hue 管理员口令在第一次登录时设定。MySQL 的 `root` 口令是随机的，在 `hue-db` 的日志里。

备份前先停容器，再打包 `/www/wwwroot/hue`。压缩包里含数据库口令，不要放到公开位置。

压缩包放在 `/www/wwwroot/hue-backup.tar.gz`，与站点目录并列。

```bash
cd /www/wwwroot/hue
docker compose stop
tar -C /www/wwwroot -czf /www/wwwroot/hue-backup.tar.gz hue
docker compose start
```

升级前先看两个标签之间的发行说明。`mysql/` 和 `hue.ini` 留在宿主机上。已经有数据的实例不要改到更低的版本。先改 `compose.yaml` 里 Hue 的 `image` 标签，再执行：

```bash
cd /www/wwwroot/hue
docker compose up -d
```

改 `hue.ini` 之后也要让 Hue 重新读配置：

```bash
cd /www/wwwroot/hue
docker compose restart hue
```

要对公网提供访问，在前面加 HTTPS 反向代理。`8888` 适合本机或内网。不要把未完成第一次登录的 `8888` 直接暴露到公网，也不要把 MySQL 的 `3306` 映射出来。

要让编辑器查询另一台 MySQL，改 `hue.ini` 里解释器的地址，把主机、端口、账号、口令和库名换成那台库的信息。Hue 自己的元数据库仍用上面的 `[[database]]`，不要改成业务库。

```ini
[notebook]
[[interpreters]]
[[[mysql]]]
name=MySQL
interface=sqlalchemy
options='{"url": "mysql://用户:口令@数据库主机:3306/库名"}'
```

Hive、Impala、Spark SQL、Presto、ClickHouse 的解释器写法见延伸阅读里的连接器文档。改完后执行 `docker compose restart hue`。

## 备选：docker run

没有 Compose 时，目录、`db_password.txt` 和 `hue.ini` 仍按「Docker Compose 部署」的前两步准备，不要执行那里的 `docker compose up -d`。已经用 Compose 起过名为 `hue` 或 `hue-db` 的容器时，先在 `/www/wwwroot/hue` 执行 `docker compose down`，再跑下面的命令，避免容器名冲突。

`mysql/` 已经初始化过时，继续使用原来的口令。`hue.ini` 里的主机名是 `db`，所以 MySQL 容器要带上网络别名 `db`。

1. 读出数据库口令。网络 `hue` 还不存在时再创建；若提示 `network with name hue already exists`，直接进行下一步：

```bash
cd /www/wwwroot/hue
DB_PASSWORD="$(cat db_password.txt)"
docker network create hue
```

2. 启动 MySQL。数据目录挂到 `/var/lib/mysql`：

```bash
docker run -d 
  --name hue-db 
  --network hue 
  --network-alias db 
  --restart unless-stopped 
  -e MYSQL_DATABASE=hue 
  -e MYSQL_USER=hue 
  -e MYSQL_PASSWORD="$DB_PASSWORD" 
  -e MYSQL_RANDOM_ROOT_PASSWORD=yes 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/hue/mysql:/var/lib/mysql 
  --health-cmd "mysqladmin ping -h 127.0.0.1 -uhue -p$DB_PASSWORD --silent" 
  --health-interval 10s 
  --health-timeout 5s 
  --health-retries 30 
  --health-start-period 40s 
  docker.xuanyuan.run/library/mysql:8.4.11
```

3. 等数据库能应答后再启动 Hue。刚启动时下面这条可能失败，隔几秒再执行。退出码为 0 再进行下一步：

```bash
docker exec hue-db mysqladmin ping -h 127.0.0.1 -uhue -p"$DB_PASSWORD" --silent
```

4. 启动 Hue。末尾的 `./start-hue.sh` 替换镜像默认的 `./startup.sh`。用户自定义网络上的别名 `db` 就是 `hue.ini` 里的数据库主机名：

```bash
docker run -d 
  --name hue 
  --network hue 
  --restart unless-stopped 
  -p 8888:8888 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/hue/hue.ini:/usr/share/hue/desktop/conf/z-hue.ini 
  -v /www/wwwroot/hue/start-hue.sh:/usr/share/hue/start-hue.sh:ro 
  docker.xuanyuan.run/gethue/hue:20260611-140101 
  ./start-hue.sh
unset DB_PASSWORD
```

查看与停止：

```bash
docker ps --filter name=hue
docker logs -f --tail 100 hue
curl -sI http://127.0.0.1:8888/
docker stop hue hue-db
```

浏览器地址与「浏览器首次使用」相同。

## 常见问题

**Q1：`latest` 或 `4.11.0` 能不能写进 Compose？**

本文命令是 `20260611-140101` 和 `8.4.11`。`latest` 目前与 `20260611-140101` 是同一份镜像，但它会改指向。`4.11.0` 是 2023-01-19 的发布标签，digest 不同。对照见「标签怎么选」。

**Q2：只跑 Hue、不配 MySQL，可以吗？**

不配 MySQL 时，Hue 使用容器里的 SQLite。官方说明这种情况会遇到 `database is locked`，容器删除后用户和查询历史也不在了。本文把 `[[database]]` 指到 MySQL。

**Q3：页面连不上数据库？**

先看 `hue-db` 是不是 healthy，再核对 `hue.ini` 里的口令是否与 `db_password.txt` 一致：

```bash
cd /www/wwwroot/hue
docker compose ps
docker compose logs --tail 80 hue
docker compose logs --tail 80 hue-db
```

`mysql/` 若是用另一组口令初始化的，只改 `hue.ini` 不会改掉已有账号。需要回到原来的口令，或在空目录上重新初始化。重新初始化会丢掉已有的 Hue 用户和查询历史。

**Q4：日志里是 `Illegal instruction`，`curl` 没有输出？**

这是镜像里的 Polars **1.8.2** 用到了本机没有的指令。退出码 **-4**。当时的日志是：

```text
[18/Oct/2026 19:47:19 +0800] settings     INFO     Welcome to Hue 4.11.0
The following required CPU features were not detected:
    avx2, fma, bmi1, bmi2, lzcnt, movbe
Illegal instruction (core dumped)
[18/Oct/2026 19:47:54 +0800] supervisor   WARNING  Exit code for /usr/share/hue/build/env/bin/hue runcpserver: -4
```

`POLARS_SKIP_CPU_CHECK` 只跳过警告。确认 `compose.yaml` 的命令是 `./start-hue.sh`，并且该文件已挂进容器，然后重新创建 Hue 容器：

```bash
cd /www/wwwroot/hue
docker compose up -d
docker compose logs --tail 80 hue
```

第一次会从 PyPI 安装同版本的 `polars-lts-cpu`。容器出网被拦住时，安装会失败，页面仍然打不开。安装写在容器里，`docker compose up -d` 重建容器后会再装一次。`docker compose restart hue` 不会清掉已经装好的包。

**Q5：Hue 一启动就退出，日志里说读不到配置？**

看 `hue.ini` 是不是文件、是不是 `644`。它若是一个目录，说明启动前这个路径还不存在，Docker 已把它建成目录。删掉这个目录，按「Docker Compose 部署」重新写出 `hue.ini`，再 `docker compose up -d`。

**Q6：编辑器里没有 MySQL，或 MySQL 执行失败？**

确认 `hue.ini` 里的 `[[[mysql]]]` 还在，并且容器内路径是 `/usr/share/hue/desktop/conf/z-hue.ini`。改完文件后执行 `docker compose restart hue`。登录后编辑器默认停在 Hive，左侧 **Editor** 里点 **MySQL**。Hive 和 Impala 连不上，是因为这套 Compose 没有这两个服务。

**Q7：忘记 Hue 管理员口令？**

这个口令不在 `db_password.txt` 里。下面这条命令再创建一个管理员，原来的口令不会改掉。用户名不要用已经存在的 `admin`。按提示输入用户名和口令：

```bash
cd /www/wwwroot/hue
docker compose exec hue ./build/env/bin/hue createsuperuser
```

**Q8：`8888` 已经被占用？**

只改映射的宿主机端口，例如 `8889:8888`。容器内仍然是 `8888`，`hue.ini` 里的 `http_port` 不用改。访问地址改成新的宿主机端口。

**Q9：拉取报 `no matching manifest`？**

`20260611-140101` 只有 linux/amd64。arm64 或 32 位机器拉不到这个标签。

**Q10：想把 MySQL 从宿主机连进去？**

本文不把 `3306` 映射出来。查询走 Hue 编辑器。若必须从宿主机连接，在 `db` 服务的 `ports` 里增加一段宿主机端口到 `3306` 的映射，并限制来源地址。不要把这个端口直接暴露到公网。

## 命令速查

```bash
docker pull docker.xuanyuan.run/gethue/hue:20260611-140101
docker pull docker.xuanyuan.run/library/mysql:8.4.11

cd /www/wwwroot/hue
docker compose up -d
docker compose ps
docker compose logs -f --tail 100 hue
curl -sI http://127.0.0.1:8888/

docker compose restart hue
docker compose stop
docker compose start
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://服务器IP:8888`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [gethue/hue 镜像页](https://xuanyuan.cloud/zh/r/gethue/hue) | [https://xuanyuan.cloud/zh/r/gethue/hue](https://xuanyuan.cloud/zh/r/gethue/hue) |
| [gethue/hue 概览](https://xuanyuan.cloud/r/gethue/hue) | [https://xuanyuan.cloud/r/gethue/hue](https://xuanyuan.cloud/r/gethue/hue) |
| [gethue/hue 标签列表](https://xuanyuan.cloud/r/gethue/hue/tags) | [https://xuanyuan.cloud/r/gethue/hue/tags](https://xuanyuan.cloud/r/gethue/hue/tags) |
| [library/mysql 镜像页](https://xuanyuan.cloud/zh/r/library/mysql) | [https://xuanyuan.cloud/zh/r/library/mysql](https://xuanyuan.cloud/zh/r/library/mysql) |
| [library/mysql 标签列表](https://xuanyuan.cloud/r/library/mysql/tags) | [https://xuanyuan.cloud/r/library/mysql/tags](https://xuanyuan.cloud/r/library/mysql/tags) |
| [Docker Hub · gethue/hue](https://hub.docker.com/r/gethue/hue) | [https://hub.docker.com/r/gethue/hue](https://hub.docker.com/r/gethue/hue) |
| [Docker Hub · mysql](https://hub.docker.com/_/mysql) | [https://hub.docker.com/_/mysql](https://hub.docker.com/_/mysql) |
| [GitHub · cloudera/hue](https://github.com/cloudera/hue) | [https://github.com/cloudera/hue](https://github.com/cloudera/hue) |
| [Hue Docker 说明](https://github.com/cloudera/hue/tree/master/tools/docker/hue) | [https://github.com/cloudera/hue/tree/master/tools/docker/hue](https://github.com/cloudera/hue/tree/master/tools/docker/hue) |
| [Hue 官网](https://gethue.com/) | [https://gethue.com/](https://gethue.com/) |
| [在 Docker 中运行 Hue](https://docs.gethue.com/administrator/installation/cloud/) | [https://docs.gethue.com/administrator/installation/cloud/](https://docs.gethue.com/administrator/installation/cloud/) |
| [服务器与登录配置](https://docs.gethue.com/administrator/configuration/server/) | [https://docs.gethue.com/administrator/configuration/server/](https://docs.gethue.com/administrator/configuration/server/) |
| [连接器配置](https://docs.gethue.com/administrator/configuration/connectors/) | [https://docs.gethue.com/administrator/configuration/connectors/](https://docs.gethue.com/administrator/configuration/connectors/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/hue-docker-deploy


