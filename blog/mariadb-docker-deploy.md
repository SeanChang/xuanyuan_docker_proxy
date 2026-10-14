# Docker 部署 MariaDB：轻松搭建开源关系型数据库

![Docker 部署 MariaDB：轻松搭建开源关系型数据库](https://imgs.xuanyuan.cloud/docker/blog/mariadb/mariadb.webp)

*分类: Docker部署教程 | 标签: MariaDB,Docker,轩辕镜像,关系型数据库,MySQL,私有化部署,部署教程 | 发布时间: 2026-10-11 13:08:50*

> MariaDB 是从 MySQL 分叉而来的开源关系型数据库，用来存放表中的业务数据，应用通过 SQL 和 MySQL 协议访问。本文将通过 Docker Compose 部署 MariaDB，把数据文件放在本机目录，供网站和业务系统连接，适合要自己保管数据库的服务器。

*本文基于 [library/mariadb:12.3.3](https://xuanyuan.cloud/zh/r/library/mariadb)，以 **12.3.3** 版本实测，测试平台 **Ubuntu 24.04** Linux。*

## MariaDB 是什么

MariaDB 是一套开源的关系型数据库，由 MySQL 的原开发者发起，MariaDB 基金会与 MariaDB 公司维护。业务数据放在表里，应用程序用 SQL 读写，连接方式沿用 MySQL 协议。

与 MySQL 官方发行版相比，MariaDB 保持常用 SQL、客户端和协议兼容，并继续增加自己的功能。本文使用的是 Docker 官方镜像 `library/mariadb`。

## MariaDB 能做什么

- **存业务记录**：表、索引和事务放在一个库里，应用用 SQL 读写。
- **分开授权**：不同应用使用不同用户，权限落在各自的库上。
- **多程序共用**：同一台服务器上的网站和内部工具各自连接。
- **导入和导出**：用 SQL 把库备份出去，或把已有数据导进来。
- **跟着版本升级**：换新版本后，可以更新数据目录里的系统表。

## 为什么要使用 MariaDB

网站和业务系统把库放在托管服务上时，导出、停机和账号都按对方的规则来。MariaDB 跑在自己的机器上，数据文件在自己的磁盘里。

它适合已经按 MySQL 协议写好连接串，又要把库留在自己服务器上的网站、业务系统和内部工具。

## 使用 Docker 部署 MariaDB

官方镜像里带有服务器和客户端。本机不用再装数据库软件包。开始之前，先准备好 Docker，并留出存放数据文件的目录。root 口令和业务账号口令在第一次初始化时写入。

下面用 Docker Compose 写好这些参数，启动容器，并在命令行里确认版本和连接。

## 环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux（本文 **Ubuntu 24.04**）；macOS 把 `/www/wwwroot/mariadb` 换成 `~/docker/mariadb` |
| Docker | Engine + **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64**、**ppc64le**、**s390x** |
| 磁盘 | Ubuntu 24.04 上 `docker images` 显示 DISK **473MB**、CONTENT **112MB**；数据目录和备份另计 |
| 端口 | 宿主机 **127.0.0.1:3306** → 容器 **3306**。容器内监听 3306 |
| 工作目录 | `/www/wwwroot/mariadb` |

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

[Docker 官方镜像清单](https://github.com/docker-library/official-images/blob/master/library/mariadb) 里，`12.3.3` 与浮动标签 `lts`、`12`、`12.3` 指向同一条 Ubuntu 24.04（Noble）构建。该版本 Dockerfile 标明 `release-status` 为 Stable、`release-support-type` 为 Long Term Support。`latest` 当前指向 `13.0.2`，基础系统是 Ubuntu 26.04（Resolute）。

命令使用 **`12.3.3`**。详情页中文简介仍按 `12.0.2`、`11.8.3` 分组。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`12.3.3`** | 12.3 长期支持线的具体版本，Ubuntu 24.04 | **是** |
| `12.3.3-noble`、`lts-noble` | 与 `12.3.3` 同一条 Ubuntu 构建 | 否 |
| `12.3`、`12`、`lts` | 浮动标签，之后会改指向 | 否 |
| `13.0.2`、`13`、`latest` | 当前最新稳定线，基础系统 Ubuntu 26.04 | 否 |
| `13.1.1-rc`、`13.1-rc` | 候选版本 | 否 |
| `11.8.9` | 11.8 线的当前具体版本 | 应用必须留在 11.8 时，只替换这一处标签 |
| `11.8`、`11` | 随 11.8 小版本移动 | 否 |
| `11.4.13`、`10.11.19`、`10.6.28` | 更早的维护线，带具体版本号 | 否。旧应用需要时再改标签 |
| `*-ubi`、`*-ubi9`、`*-ubi10` | Red Hat UBI 基础系统 | 否 |

升级时只改镜像标签，并先做「备份、恢复与升级」里的备份。已经用更高版本初始化的 `data/` 不要挂回更低版本。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/library/mariadb:12.3.3
```

Ubuntu 24.04 实测：

```text
Digest: sha256:2bdff1534a7e569fecaf4b10b66ad0d410806e382d9db29ba305448addda97c4
Status: Downloaded newer image for docker.xuanyuan.run/library/mariadb:12.3.3
docker.xuanyuan.run/library/mariadb:12.3.3
```

拉取完成后确认本地有这个标签：

```bash
docker images docker.xuanyuan.run/library/mariadb:12.3.3
```

```text
IMAGE                                        ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/library/mariadb:12.3.3   2bdff1534a7e        473MB          112MB
```

## Docker Compose 部署

工作目录是 `/www/wwwroot/mariadb`。`data` 对应容器内 `/var/lib/mysql`，存放数据库文件。`conf.d` 对应 `/etc/mysql/conf.d`，放额外的 `.cnf`。`initdb.d` 对应 `/docker-entrypoint-initdb.d`，只在数据目录为空的第一次启动时执行。

`data` 里已经有 `mysql` 子目录时，除 `MARIADB_AUTO_UPGRADE` 以外的初始化变量都不会再生效，也不会改已有账号。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/mariadb/data /www/wwwroot/mariadb/conf.d /www/wwwroot/mariadb/initdb.d
sudo chown -R "$USER":"$USER" /www/wwwroot/mariadb
```

2. `data/mysql` 还不存在时，再生成两份口令并写入 `compose.yaml`。`root_password.txt` 是 root 口令，`app_password.txt` 是业务账号 `app` 的口令。`umask 077` 让这两个文件和 `compose.yaml` 只有当前用户可读；写完后把 umask 调回 `022`。

```bash
cd /www/wwwroot/mariadb
ROOT_PASSWORD="$(openssl rand -hex 24)"
APP_PASSWORD="$(openssl rand -hex 24)"
umask 077
printf '%s
' "$ROOT_PASSWORD" > root_password.txt
printf '%s
' "$APP_PASSWORD" > app_password.txt
cat > compose.yaml <<EOF
name: mariadb

services:
  mariadb:
    image: docker.xuanyuan.run/library/mariadb:12.3.3
    container_name: mariadb
    restart: unless-stopped
    stop_grace_period: 60s
    environment:
      TZ: Asia/Shanghai
      MARIADB_ROOT_PASSWORD: ${ROOT_PASSWORD}
      MARIADB_DATABASE: app
      MARIADB_USER: app
      MARIADB_PASSWORD: ${APP_PASSWORD}
      MARIADB_AUTO_UPGRADE: "1"
    ports:
      - "127.0.0.1:3306:3306"
    volumes:
      - ./data:/var/lib/mysql
      - ./conf.d:/etc/mysql/conf.d:ro
      - ./initdb.d:/docker-entrypoint-initdb.d:ro
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      start_period: 60s
      interval: 10s
      timeout: 5s
      retries: 5
EOF
umask 022
unset ROOT_PASSWORD APP_PASSWORD
```

| 配置项 | 说明 |
|--------|------|
| `127.0.0.1:3306:3306` | 只在本机发布 3306。同一台机器上的程序连 `127.0.0.1` |
| `MARIADB_ROOT_PASSWORD` | root 口令。官方镜像要求它、空口令、随机口令、口令哈希四者之一 |
| `MARIADB_DATABASE` / `MARIADB_USER` / `MARIADB_PASSWORD` | 第一次初始化时创建库 `app` 和用户 `app`。该用户对这个库拥有全部权限 |
| `MARIADB_AUTO_UPGRADE` | 版本需要时运行系统表升级。数据目录已有库时，仍然只有这项会生效 |
| `TZ` | 容器系统时区。镜像默认是 UTC |
| `./data` | 数据文件。删除容器不会删除这个目录 |
| `./conf.d` | 额外配置。目录可以先空着 |
| `./initdb.d` | 初始化脚本。目录可以先空着 |
| `stop_grace_period: 60s` | 留给 InnoDB 写完关闭日志。停得太快时，下次启动会做崩溃恢复 |
| `healthcheck` | 官方脚本 `healthcheck.sh`：先确认 TCP 可连，再确认 InnoDB 初始化完成 |

官方镜像默认把 root 和 `MARIADB_USER` 的主机部分设为 `%`。端口只发布在 `127.0.0.1`，局域网其他机器连不上。入口脚本会先以 root 调整数据目录属主，再降到镜像里的 `mysql` 用户。`compose.yaml` 里不要写 `user:`。

`root_password.txt`、`app_password.txt` 和 `compose.yaml` 里有口令。不要把这三个文件提交到公开仓库，也不要发到聊天记录里。

3. 要改服务器参数时，在第一次启动前把以 `.cnf` 结尾的文件放进 `conf.d`。不改参数就让这个目录空着。容器已经在跑时，写入文件后再执行 `docker compose restart mariadb`。

```bash
cd /www/wwwroot/mariadb
cat > conf.d/99-custom.cnf <<'EOF'
[mariadb]
max_connections = 200
EOF
```

镜像自身已经写了 `host-cache-size=0` 和 `skip-name-resolve`。账号按主机部分匹配，不按客户端域名反查。

4. 要预置表时，在第一次启动前把 `.sql`、`.sql.gz`、`.sql.xz`、`.sql.zst` 或 `.sh` 放进 `initdb.d`。按文件名顺序执行，SQL 导入 `MARIADB_DATABASE` 指定的库 `app`。`data/mysql` 已经存在时，这些文件不会再执行。

```bash
cd /www/wwwroot/mariadb
cat > initdb.d/01-note.sql <<'EOF'
CREATE TABLE IF NOT EXISTS note (
  id INT PRIMARY KEY AUTO_INCREMENT,
  body VARCHAR(255) NOT NULL
);
EOF
```

5. 启动。数据目录为空时，初始化完成前没有套接字，健康检查会先停在 `starting`。`start_period` 的 60 秒不计入失败次数。

```bash
cd /www/wwwroot/mariadb
docker compose up -d
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network mariadb_default Created      0.2s
 ✔ Container mariadb       Started      2.1s
```

启动大约 6 秒时，状态仍是 `health: starting`，端口已经绑在 `127.0.0.1:3306`：

```text
NAME      IMAGE                                        COMMAND                  SERVICE   CREATED         STATUS                            PORTS
mariadb   docker.xuanyuan.run/library/mariadb:12.3.3   "docker-entrypoint.s…"   mariadb   6 seconds ago   Up 4 seconds (health: starting)   127.0.0.1:3306->3306/tcp
```

这时日志还停在初始化。入口脚本写明服务器是 `1:12.3.3+maria~ubu2404`，并已切换到用户 `mysql`：

```text
2026-10-11 12:51:06+08:00 [Note] [Entrypoint]: Entrypoint script for MariaDB Server 1:12.3.3+maria~ubu2404 started.
2026-10-11 12:51:06+08:00 [Warn] [Entrypoint]: /sys/fs/cgroup///memory.pressure not writable, functionality unavailable to MariaDB
2026-10-11 12:51:06+08:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
2026-10-11 12:51:06+08:00 [Note] [Entrypoint]: Entrypoint script for MariaDB Server 1:12.3.3+maria~ubu2404 started.
2026-10-11 12:51:07+08:00 [Note] [Entrypoint]: Initializing database files
2026-10-11 12:51:07 0 [Warning] mariadbd: io_uring_queue_init() failed with EPERM: sysctl kernel.io_uring_disabled has the value 2, or 1 and the user of the process is not a member of sysctl kernel.io_uring_group. (see man 2 io_uring_setup).
create_uring failed: falling back to libaio
```

`memory.pressure` 那一行表示容器里写不了这项 cgroup 文件。`io_uring` 那一行的下一句是 `falling back to libaio`，服务器改用 libaio，初始化继续。

这个时间点执行客户端，会得到：

```text
ERROR 2002 (HY000): Can't connect to local server through socket '/run/mysqld/mysqld.sock' (2)
```

套接字要等初始化结束才出现。看到这句时不要 `docker compose down`，也不要删除 `data/` 或重新生成口令。

6. 等到健康状态变成 `healthy`，再做下一节的查询。循环每 3 秒看一次。若一直停在 `starting`，按 Ctrl+C 停下，再看 `docker compose logs --tail 80 mariadb`。

```bash
cd /www/wwwroot/mariadb
until [ "$(docker inspect -f '{{.State.Health.Status}}' mariadb)" = "healthy" ]; do
  sleep 3
done
docker compose ps
docker compose logs --tail 30 mariadb
```

## 连接数据库

先完成上一节的等待。root 在容器里走套接字。业务账号从同一 Docker 网络里的其他容器走 TCP。口令来自上面两个文件，命令替换会去掉末尾换行。`-p` 紧贴口令时，口令会出现在进程参数里。

1. 在数据库容器里用 root 查看版本：

```bash
cd /www/wwwroot/mariadb
docker compose exec mariadb mariadb -uroot -p"$(cat root_password.txt)" -e "SELECT VERSION();"
```

Ubuntu 24.04 实测：

```text
+------------------------+
| VERSION()              |
+------------------------+
| 12.3.3-MariaDB-ubu2404 |
+------------------------+
```

2. 用另一个容器，走 Compose 网络，以用户 `app` 连库 `app`。项目名是 `compose.yaml` 里的 `name: mariadb`，默认网络名是 `mariadb_default`，主机名是服务名 `mariadb`。

```bash
cd /www/wwwroot/mariadb
docker run --rm --network mariadb_default 
  docker.xuanyuan.run/library/mariadb:12.3.3 
  mariadb -hmariadb -uapp -p"$(cat app_password.txt)" app -e "SELECT DATABASE(), CURRENT_USER();"
```

Ubuntu 24.04 实测：

```text
DATABASE()      CURRENT_USER()
app     app@%
```

同一 Compose 项目里的其他服务，主机名写 `mariadb`，端口写 `3306`，库名 `app`，用户 `app`，口令与 `app_password.txt` 相同。应用配置里写用户 `app` 的口令，不写 root 口令。

宿主机上没有 `mariadb` 命令。连接用镜像里的 12.3.3 客户端。手输口令时出现的 `ERROR 1045` 见「常见问题」。

## 备份、恢复与升级

备份使用同一标签里的 `mariadb-dump`，客户端和服务器版本一致。导出文件放在工作目录，文件名带当天日期。

```bash
cd /www/wwwroot/mariadb
docker compose exec mariadb 
  mariadb-dump -uroot -p"$(cat root_password.txt)" --all-databases --single-transaction 
  > "backup-$(date +%F).sql"
```

Ubuntu 24.04 上这条命令回到提示符，没有报错。当天 `date +%F` 是 `2026-10-11`，文件名是 `backup-2026-10-11.sql`。

恢复会在当前数据目录上重放这份 SQL。先确认文件名，再确认要灌回这份备份：

```bash
cd /www/wwwroot/mariadb
ls -l backup-*.sql
docker compose exec -T mariadb 
  mariadb -uroot -p"$(cat root_password.txt)" < backup-2026-10-11.sql
```

`backup-2026-10-11.sql` 是这次备份的文件名。换一天备份，把重定向改成 `ls` 列出的那一个。

以后要升级时，先做上面的备份，再改 `compose.yaml` 里的镜像标签，然后重新启动。`MARIADB_AUTO_UPGRADE` 已经打开。入口脚本会在需要时更新系统表，并在数据目录顶层留下 `system_mysql_backup_*.sql.zst`。

```bash
cd /www/wwwroot/mariadb
docker compose up -d
docker compose exec mariadb mariadb -uroot -p"$(cat root_password.txt)" -e "SELECT VERSION();"
```

日志若出现 `Upgrade after a crash is not supported`，上一版没有正常关闭。先把标签改回日志里写出的那个大版本，正常停止并看到 `Shutdown complete` 之后，再换成新标签。停止宽限不够时，把 `stop_grace_period` 加大。

## 备选：docker run

没有 Compose 时再用这一节。工作目录、口令文件和三个子目录与「Docker Compose 部署」相同。已经有名为 `mariadb` 的容器时，不要再执行 `docker run`，也不要重新生成口令文件。

`data/mysql` 还不存在、口令文件也还没有时，先生成口令：

```bash
cd /www/wwwroot/mariadb
ROOT_PASSWORD="$(openssl rand -hex 24)"
APP_PASSWORD="$(openssl rand -hex 24)"
umask 077
printf '%s
' "$ROOT_PASSWORD" > root_password.txt
printf '%s
' "$APP_PASSWORD" > app_password.txt
umask 022
unset ROOT_PASSWORD APP_PASSWORD
```

启动：

```bash
docker run -d 
  --name mariadb 
  --restart unless-stopped 
  --stop-timeout 60 
  -p 127.0.0.1:3306:3306 
  -v /www/wwwroot/mariadb/data:/var/lib/mysql 
  -v /www/wwwroot/mariadb/conf.d:/etc/mysql/conf.d:ro 
  -v /www/wwwroot/mariadb/initdb.d:/docker-entrypoint-initdb.d:ro 
  -e TZ=Asia/Shanghai 
  -e MARIADB_ROOT_PASSWORD="$(cat /www/wwwroot/mariadb/root_password.txt)" 
  -e MARIADB_DATABASE=app 
  -e MARIADB_USER=app 
  -e MARIADB_PASSWORD="$(cat /www/wwwroot/mariadb/app_password.txt)" 
  -e MARIADB_AUTO_UPGRADE=1 
  --health-cmd 'healthcheck.sh --connect --innodb_initialized' 
  --health-interval 10s 
  --health-timeout 5s 
  --health-retries 5 
  --health-start-period 60s 
  docker.xuanyuan.run/library/mariadb:12.3.3
```

日志里出现 `ready for connections` 之后再查询。启动后立刻查询会报 `ERROR 2002`。

```bash
docker ps --filter name=mariadb
docker logs --tail 80 mariadb
docker exec mariadb mariadb -uroot -p"$(cat /www/wwwroot/mariadb/root_password.txt)" -e "SELECT VERSION();"
```

要停掉容器时再执行：

```bash
docker stop mariadb
```

这一节没有 Compose 网络。其他容器要连接时，创建一个网络，把数据库容器和业务容器都加入该网络，主机名用 `mariadb`。

## 常见问题

**Q1：`latest` 或 `lts` 能不能写进 Compose？**

命令里写 `12.3.3`。`lts`、`12`、`12.3` 当前也指向这一版本，以后会改指向。`latest` 当前指向 `13.0.2`。对照见「标签怎么选」。

**Q2：详情页中文简介仍是 12.0.2 和 11.8.3？**

中文简介仍按这两个版本分组。拉取的标签是 `docker.xuanyuan.run/library/mariadb:12.3.3`。

**Q3：容器退出，日志要求设置 root 口令？**

数据目录为空时，必须提供 `MARIADB_ROOT_PASSWORD`、`MARIADB_RANDOM_ROOT_PASSWORD`、`MARIADB_ROOT_PASSWORD_HASH`、`MARIADB_ALLOW_EMPTY_ROOT_PASSWORD` 之一，或者对应的 `_FILE` 变量。这里使用 `MARIADB_ROOT_PASSWORD`。空口令会让 root 没有保护。

**Q4：改了 compose.yaml 里的口令或库名，库里却没变？**

`data/mysql` 已经存在时，初始化变量不再执行。口令以第一次初始化的结果为准。查询时读 `root_password.txt` 和 `app_password.txt` 里的原口令。

**Q5：root 从容器外连不上？**

官方镜像默认把 root 的主机部分设为 `%`。只有把 `MARIADB_ROOT_HOST` 设成 `localhost` 时，root 才只能走容器内套接字。这项只在数据目录为空的第一次启动时生效。应用连接用用户 `app`。

**Q6：宿主机执行 `mariadb` 提示找不到命令，装上之后 `ERROR 1045`？**

Ubuntu 24.04 上执行 `mariadb -h 127.0.0.1 -P 3306 -uapp -p app`，提示 `Command 'mariadb' not found, but can be installed with: apt install mariadb-client-core`。按提示安装后，包版本是 `1:10.11.14-0ubuntu0.24.04.1`。在 `Enter password:` 里手输口令，返回：

```text
ERROR 1045 (28000): Access denied for user 'app'@'172.26.0.1' (using password: YES)
```

`172.26.0.1` 是访问发布端口时服务器看到的来源地址。同一份 `app_password.txt` 交给镜像里的 12.3.3 客户端时，`CURRENT_USER()` 是 `app@%`。连接步骤使用镜像里的客户端，并用 `$(cat app_password.txt)` 读口令。

**Q7：`ERROR 2002`，找不到 `/run/mysqld/mysqld.sock`？**

状态仍是 `health: starting`、日志还停在 `Initializing database files` 时，套接字还不存在。按「Docker Compose 部署」等到 `healthy` 再查询。不要删除 `data/`，也不要重新生成口令。

磁盘较慢时，入口脚本启动临时服务器若超过约 30 秒，日志里会有 `Unable to start server`。把数据目录放在本机磁盘上，再启动一次。

**Q8：日志里有 `io_uring` EPERM 和 `memory.pressure`？**

这次启动就有这两行。`falling back to libaio` 表示服务器改用 libaio。`memory.pressure not writable` 表示容器里写不了这项 cgroup 文件。初始化会继续。

**Q9：局域网里的其他机器要连这台库？**

把端口从 `127.0.0.1:3306:3306` 改成 `3306:3306`，然后执行 `docker compose up -d`。在防火墙里限制来源地址。应用仍使用用户 `app`。不要对公网开放 3306。

**Q10：和 MySQL 镜像、其他 MariaDB 镜像怎么区分？**

`library/mysql` 是 MySQL 官方镜像。`library/mariadb` 是 MariaDB 的 Docker 官方镜像，协议与常用客户端兼容。10.6 及以后，账号变量使用 `MARIADB_*`，并优先于同名的 `MYSQL_*`。`linuxserver/mariadb` 和 `bitnami/mariadb` 的环境变量、数据目录约定不同。这里部署的是 `library/mariadb`。

**Q11：拉取报 `no matching manifest`？**

`12.3.3` 提供 linux/amd64、linux/arm64、ppc64le、s390x。机器架构不在这四项里时，这个标签没有对应清单。UBI 标签的 CPU 基线与这份 Ubuntu 标签不同，命令里不使用 UBI。

**Q12：日志里是 Permission denied？**

`Errcode: 13` 表示容器里的 `mysql` 用户写不了 `/var/lib/mysql`。入口脚本要先以 root 运行，才能改这个目录的属主。`compose.yaml` 里不要写 `user:`。已经写过的，删掉该项后再执行 `docker compose up -d`。

**Q13：忘记 root 口令，文件也丢了？**

口令文件还在时，用文件里的口令。文件丢失时，官方做法是准备一段 `CREATE USER` / `SET PASSWORD` 的 SQL，用一次 `--init-file` 挂到现有数据目录上执行，然后再按原来的方式启动。步骤见 [Docker 官方镜像常见问题](https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/docker-official-image-frequently-asked-questions)。

## 命令速查

```bash
docker pull docker.xuanyuan.run/library/mariadb:12.3.3

cd /www/wwwroot/mariadb
docker compose up -d
docker compose ps
docker compose logs --tail 30 mariadb
docker compose exec mariadb mariadb -uroot -p"$(cat root_password.txt)" -e "SELECT VERSION();"

docker compose restart mariadb
docker compose stop
docker compose start
docker compose down
```

`docker compose down` 不会删除 `data/`。没有 Compose 时用「备选：docker run」里的命令。业务账号的连接命令见「连接数据库」。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [library/mariadb 镜像页](https://xuanyuan.cloud/zh/r/library/mariadb) | [https://xuanyuan.cloud/zh/r/library/mariadb](https://xuanyuan.cloud/zh/r/library/mariadb) |
| [library/mariadb 概览](https://xuanyuan.cloud/r/library/mariadb) | [https://xuanyuan.cloud/r/library/mariadb](https://xuanyuan.cloud/r/library/mariadb) |
| [library/mariadb 标签列表](https://xuanyuan.cloud/r/library/mariadb/tags) | [https://xuanyuan.cloud/r/library/mariadb/tags](https://xuanyuan.cloud/r/library/mariadb/tags) |
| [Docker Hub · mariadb](https://hub.docker.com/_/mariadb) | [https://hub.docker.com/_/mariadb](https://hub.docker.com/_/mariadb) |
| [GitHub · MariaDB/mariadb-docker](https://github.com/MariaDB/mariadb-docker) | [https://github.com/MariaDB/mariadb-docker](https://github.com/MariaDB/mariadb-docker) |
| [官方镜像标签清单](https://github.com/docker-library/official-images/blob/master/library/mariadb) | [https://github.com/docker-library/official-images/blob/master/library/mariadb](https://github.com/docker-library/official-images/blob/master/library/mariadb) |
| [MariaDB 官网](https://mariadb.org/) | [https://mariadb.org/](https://mariadb.org/) |
| [官方镜像环境变量](https://mariadb.com/kb/en/mariadb-server-docker-official-image-environment-variables/) | [https://mariadb.com/kb/en/mariadb-server-docker-official-image-environment-variables/](https://mariadb.com/kb/en/mariadb-server-docker-official-image-environment-variables/) |
| [healthcheck.sh 说明](https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/using-healthcheck-sh) | [https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/using-healthcheck-sh](https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/using-healthcheck-sh) |
| [Docker 官方镜像常见问题](https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/docker-official-image-frequently-asked-questions) | [https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/docker-official-image-frequently-asked-questions](https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/docker-official-image-frequently-asked-questions) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/mariadb-docker-deploy


