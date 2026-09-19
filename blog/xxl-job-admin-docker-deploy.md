# Docker 部署 XXL-JOB：轻松搭建分布式任务调度平台

![Docker 部署 XXL-JOB：轻松搭建分布式任务调度平台](https://imgs.xuanyuan.cloud/docker/blog/xxl-job.webp)

*分类: Docker部署教程 | 标签: XXL-JOB,xxl-job-admin,Docker,轩辕镜像,任务调度,分布式,私有化部署,部署教程 | 发布时间: 2026-09-16 04:07:33*

> XXL-JOB 是一款轻量级分布式任务调度框架，提供 Web 控制台、Cron 调度、执行器集群与失败告警。本文将介绍如何通过 Docker Compose 部署 xuxueli/xxl-job-admin 并配套 MySQL，轻松搭建可自托管的调度中心，适合微服务定时任务、批处理与运维巡检等场景。

*本文基于 [xuxueli/xxl-job-admin:3.4.2](https://xuanyuan.cloud/zh/r/xuxueli/xxl-job-admin)，实测引擎 **XXL-JOB 3.4.2**，测试平台 **Ubuntu 24.04** Linux。*

订单凌晨对账、报表半夜出数、库存定时同步——这些活往往还散在各服务的 `@Scheduled`、服务器 `crontab`，甚至某台运维笔记本上的脚本里。改执行时间要改代码发版；机器挂了任务就静默漏跑；失败了只能翻散落的应用日志，很难在一处看清「谁触发、跑到哪台、重试了几次」。

放到公有云定时器，又会碰到更硬的约束：**任务配置、执行日志和告警收件人最好留在自己的库里**。机房内网、等保或「数据不出域」时，外链调度不合适；自建又怕装 JDK、配 Maven、手搓建表 SQL。很多团队其实已经有一台跑 Docker 的 Ubuntu，缺的是：**调度中心镜像能拉、库表能初始化、浏览器打开就能管 Cron 与执行器**。

**XXL-JOB**（[官网文档](https://www.xuxueli.com/xxl-job/)、[GitHub · xuxueli/xxl-job](https://github.com/xuxueli/xxl-job/)）是开源轻量级**分布式任务调度平台**：Web 控制台做任务 CRUD，支持 Cron / 任务依赖 / API 触发，执行器可集群并提供多种路由与故障转移。本文部署的官方镜像 **`xuxueli/xxl-job-admin`**（[镜像页](https://xuanyuan.cloud/zh/r/xuxueli/xxl-job-admin)）是**调度中心（Admin）**：容器内监听 **8080**，依赖外置 **MySQL**，日志落在 **`/data/applogs`**。真正执行业务代码的是独立**执行器**进程——本文先把 Admin + MySQL 跑通，执行器对接见第七节。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 打开调度台 | `http://服务器IP:18080/`，默认 **`admin` / `123456`** |
| 管定时任务 | 新建 / 启停 Cron，看运行报表与调度日志 |
| 接执行器 | 业务服务引入 `xxl-job-core`，填 Admin 地址与 AccessToken |
| 备份搬家 | 停栈后打包 `./mysql-data`、`./applogs`、`./init-db` |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`xuxueli/xxl-job-admin:3.4.2`**，**Docker Compose** 拉起 MySQL + Admin。把下文 IP 与数据库密码换成你的。无 Compose 见第八节。文内附 **8** 张实测截图。

> **上手要点**
> - **主路径**：第四节 Compose；备选 `docker run` 见第八节
> - **SQL**：挂载与镜像同版本的 `tables_xxl_job.sql`（本文用 **3.4.2**）
> - **端口**：宿主机 **18080** → 容器 **8080**
> - **标签**：跟做 **`3.4.2`**；勿写 `latest`
> - **体积**：Admin DISK **513MB** / CONTENT **150MB**；MySQL 8.4 DISK **1.12GB** / CONTENT **255MB**
> - **冷启动**：MySQL 首次约 **1 分钟** 才 healthy；Admin 容器 Up 后 JVM 还要再加载数十秒——日志为空或页面打不开时，先 `docker compose logs -f`
> - **账号**：**`admin` / `123456`**（生产立刻改密）
> - **AccessToken**：默认 **`default_token`**（执行器须一致）
> - **目录**：Linux `/www/wwwroot/xxl-job-admin`；macOS 跟做用 `~/docker/xxl-job-admin`
> - **访问路径**：3.4.x 默认根路径 `/`（不是旧版 `/xxl-job-admin`）

官方：[中文文档](https://www.xuxueli.com/xxl-job/) · [GitHub](https://github.com/xuxueli/xxl-job/) · [镜像页](https://xuanyuan.cloud/zh/r/xuxueli/xxl-job-admin) · [标签列表](https://xuanyuan.cloud/r/xuxueli/xxl-job-admin/tags)

---

## 一、xxl-job-admin 镜像是什么？

`xuxueli/xxl-job-admin` 只提供**调度中心**：配置任务、按策略触发、汇总结果与告警。它**不内置 MySQL**，也不在容器里跑你的业务 Handler——业务在独立**执行器**里实现（常见为 Java + `xxl-job-core`，也可用其它语言对接）。

| | XXL-JOB Admin（本文） | 各服务 `@Scheduled` / crontab | 云厂商定时器 |
|--|----------------------|-------------------------------|--------------|
| 入口 | 浏览器控制台 | 散落在代码与机器 | 厂商控制台 |
| 数据 | 本机 MySQL + 日志卷 | 本地日志 | 通常出域 |
| 适合 | 微服务统一调度、内网合规 | 单机极简任务 | 少运维、可接受出域 |

```text
浏览器 ──HTTP:18080──▶  xxl-job-admin（:8080）
                           ├── JDBC ──▶ MySQL（库 xxl_job）
                           └── ./applogs ──▶ /data/applogs
执行器 ──注册 / 回调──▶  Admin（AccessToken）
```

若你更需要 DAG / 数据工作流编排，应另看 Airflow、DolphinScheduler 一类方案；XXL-JOB 更适合**业务侧定时任务集中管理、Web 配置、轻量接入**。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux（建议 Ubuntu 24.04）；也可 Docker Desktop |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64**（当前官方镜像以 linux/amd64 为主） |
| 内存 | 可用 ≥ **2 GB**（MySQL + Java 同机） |
| 磁盘 | Admin ≈ **513MB** + MySQL ≈ **1.12GB** + 数据增长 |
| 端口 | 宿主机 **18080**；MySQL 默认仅栈内网 |
| 工作目录 | `/www/wwwroot/xxl-job-admin` |

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

---

## 三、拉取镜像

### 3.1 标签怎么选

| 标签 | 说明 | 是否跟做 |
|------|------|----------|
| **`3.4.2`** | 当前较新稳定版 | **推荐** |
| `3.4.1` / `3.4.0` | 同大版本线 | 可，升级前看 changelog |
| `3.3.x` / `2.x` | 较旧 | 仅存量；**SQL / 密码哈希可能不兼容** |
| `latest` | 浮动标签 | **勿写入跟做命令** |

完整列表见 [标签页](https://xuanyuan.cloud/r/xuxueli/xxl-job-admin/tags)。**镜像标签与 `tables_xxl_job.sql` 必须同版本**——用 `3.4.2` 镜像就下 [3.4.2 的 SQL](https://raw.githubusercontent.com/xuxueli/xxl-job/3.4.2/doc/db/tables_xxl_job.sql)，不要拿 `master` 盲替。

### 3.2 用轩辕镜像加速拉取

```bash
docker pull docker.xuanyuan.run/xuxueli/xxl-job-admin:3.4.2
docker pull docker.xuanyuan.run/library/mysql:8.4
```

Ubuntu 24.04 实测：

```text
3.4.2: Pulling from xuxueli/xxl-job-admin
d1f56e4c7f2f: Pull complete
dd847706531f: Pull complete
d1138b4ddaeb: Pull complete
5bf746862a74: Pull complete
6bad0740bbb7: Pull complete
e98099d09b5a: Pull complete
198ee0ba58a2: Pull complete
Digest: sha256:fa6ad9343f41be414446685f00c28456444577c8209948760c8089b493c39e35
Status: Downloaded newer image for docker.xuanyuan.run/xuxueli/xxl-job-admin:3.4.2
docker.xuanyuan.run/xuxueli/xxl-job-admin:3.4.2
```

```text
8.4: Pulling from library/mysql
13c85306055e: Pull complete
f5703b642196: Pull complete
052c01bf8f0e: Pull complete
e1ff04460a23: Pull complete
62f909f48b33: Pull complete
35c18fec455d: Pull complete
2a2df1f368eb: Pull complete
70d659eb9b53: Pull complete
7c507b2b0af4: Pull complete
ec3187676fa6: Pull complete
af464d8ae8d2: Download complete
1e46095c5b6f: Download complete
Digest: sha256:85b9bf2e29cf836ecb8c2a15a935d4ba0c606631dff1dd79531a11983c638f2a
Status: Downloaded newer image for docker.xuanyuan.run/library/mysql:8.4
docker.xuanyuan.run/library/mysql:8.4
```

```bash
docker images docker.xuanyuan.run/xuxueli/xxl-job-admin:3.4.2
docker images docker.xuanyuan.run/library/mysql:8.4
```

```text
IMAGE                                             ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/xuxueli/xxl-job-admin:3.4.2   fa6ad9343f41        513MB          150MB

IMAGE                                   ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/library/mysql:8.4   85b9bf2e29cf       1.12GB          255MB
```

---

## 四、Docker Compose 部署（推荐）

工作目录：`/www/wwwroot/xxl-job-admin`（macOS 跟做用 `~/docker/xxl-job-admin`）。

### 4.1 创建目录并下载初始化 SQL

```bash
sudo mkdir -p /www/wwwroot/xxl-job-admin/{init-db,mysql-data,applogs}
sudo chown -R "$USER:$USER" /www/wwwroot/xxl-job-admin
cd /www/wwwroot/xxl-job-admin

# 与镜像 3.4.2 对齐（勿用 master 盲替）
curl -fsSL -o init-db/tables_xxl_job.sql \
  https://raw.githubusercontent.com/xuxueli/xxl-job/3.4.2/doc/db/tables_xxl_job.sql

ls -la init-db/tables_xxl_job.sql
```

MySQL **仅在数据目录为空时**执行 `init-db/` 脚本。换 SQL 重装需先清空 `./mysql-data`（会丢库，慎用）。

### 4.2 编写 docker-compose.yml

把下文 `ChangeMe_XxlJob_Root` 换成强密码；MySQL 的 `MYSQL_ROOT_PASSWORD` 与 Admin `PARAMS` 里密码必须一致。

```bash
cat > docker-compose.yml <<'EOF'
services:
  mysql:
    image: docker.xuanyuan.run/library/mysql:8.4
    container_name: xxl-job-mysql
    restart: unless-stopped
    environment:
      TZ: Asia/Shanghai
      MYSQL_ROOT_PASSWORD: ChangeMe_XxlJob_Root
      MYSQL_DATABASE: xxl_job
    volumes:
      - ./init-db/tables_xxl_job.sql:/docker-entrypoint-initdb.d/tables_xxl_job.sql:ro
      - ./mysql-data:/var/lib/mysql
    command: >
      --character-set-server=utf8mb4
      --collation-server=utf8mb4_unicode_ci
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-pChangeMe_XxlJob_Root"]
      interval: 10s
      timeout: 5s
      retries: 12
      start_period: 30s
    networks:
      - xxl-job-net

  xxl-job-admin:
    image: docker.xuanyuan.run/xuxueli/xxl-job-admin:3.4.2
    container_name: xxl-job-admin
    restart: unless-stopped
    depends_on:
      mysql:
        condition: service_healthy
    ports:
      - "18080:8080"
    environment:
      TZ: Asia/Shanghai
      JAVA_OPTS: "-Xms256m -Xmx512m"
      PARAMS: >-
        --spring.datasource.url=jdbc:mysql://mysql:3306/xxl_job?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true&useSSL=false
        --spring.datasource.username=root
        --spring.datasource.password=ChangeMe_XxlJob_Root
        --xxl.job.accessToken=default_token
    volumes:
      - ./applogs:/data/applogs
    networks:
      - xxl-job-net

networks:
  xxl-job-net:
    driver: bridge
EOF
```

| 项 | 作用 |
|----|------|
| `"18080:8080"` | 浏览器访问 **18080**，容器内仍是 **8080** |
| `PARAMS` | Spring 参数覆盖（`--key=value`，空格分隔） |
| `./applogs → /data/applogs` | Admin 日志持久化 |
| `./mysql-data` | MySQL 数据持久化 |
| JDBC 主机 `mysql` | Compose **服务名**；写成 `127.0.0.1` 会连到 Admin 容器自己 |

### 4.3 启动与验证

```bash
docker compose up -d
docker compose ps
docker compose logs -f xxl-job-admin
```

Ubuntu 24.04 实测：MySQL 约 **63 秒** 变为 healthy，随后 Admin Started。

```text
[+] up 3/3
 ✔ Network xxl-job-admin_xxl-job-net Created
 ✔ Container xxl-job-mysql           Healthy
 ✔ Container xxl-job-admin           Started
```

```text
NAME            IMAGE                                             COMMAND                  SERVICE         CREATED              STATUS                        PORTS
xxl-job-admin   docker.xuanyuan.run/xuxueli/xxl-job-admin:3.4.2   "sh -c 'java ${LOG_H…"   xxl-job-admin   About a minute ago   Up 12 seconds                 0.0.0.0:18080->8080/tcp, [::]:18080->8080/tcp
xxl-job-mysql   docker.xuanyuan.run/library/mysql:8.4             "docker-entrypoint.s…"   mysql           About a minute ago   Up About a minute (healthy)   3306/tcp, 33060/tcp
```

容器刚 Up 的前几十秒，`--tail` 日志可能仍为空，浏览器或 `curl` 也会打不开。保持 `logs -f`，等到有 Spring Boot 输出后再访问。可选探测：

```bash
curl -sI --max-time 5 "http://127.0.0.1:18080/" | head -n 5
```

就绪后打开 `http://服务器IP:18080/`，应出现登录页。

---

## 五、浏览器首次登录

1. 打开 `http://服务器IP:18080/`（本机可用 `http://127.0.0.1:18080/`）。
2. 登录：**`admin` / `123456`**。
3. 进入「运行报表」：页脚为 **Powered by XXL-JOB 3.4.2**。实测初始状态约 **任务数量 4**、**调度次数 0**、**执行器数量 0**（初始化 SQL 预置了示例任务，尚未接执行器）。
4. 点右上角「欢迎: admin」→ **修改密码**，生产环境务必立刻改掉默认口令。

![XXL-JOB 登录页：任务调度中心，账号 admin](https://imgs.xuanyuan.cloud/docker/blog/xxl-job-1.webp)

![XXL-JOB 运行报表：任务数量 4、执行器 0，页脚 3.4.2](https://imgs.xuanyuan.cloud/docker/blog/xxl-job-2.webp)

![XXL-JOB 修改密码弹窗：旧密码与新密码](https://imgs.xuanyuan.cloud/docker/blog/xxl-job-8.webp)

不要把 **18080** 裸暴露公网；内网使用或前面加反代 + HTTPS。

---

## 六、控制台怎么用

Admin 侧你主要会用这些菜单：任务管理、调度日志、执行器管理、用户管理。完整跑通任务还依赖执行器在线。

### 6.1 任务管理

打开「任务管理」，执行器筛「通用执行器Sample」，可见 **示例任务01**（CRON `0 0 0 * * ?`，BEAN `demoJobHandler`，默认 STOP）。报表上的「任务数量 4」是跨执行器合计（含 AI Sample 下的示例）；换筛选器才能看到其余条目。

点「+新增」可配调度类型、JobHandler、路由策略、超时与失败重试等。

![XXL-JOB 任务管理：示例任务01，状态 STOP](https://imgs.xuanyuan.cloud/docker/blog/xxl-job-3.webp)

![XXL-JOB 新增任务弹窗：基础 / 调度 / 任务 / 高级配置](https://imgs.xuanyuan.cloud/docker/blog/xxl-job-4.webp)

### 6.2 调度日志

「调度日志」可按执行器、任务、状态与时间筛选。刚部署、尚未触发时为空（「没有找到匹配的记录」）属正常。有执行器并触发后，可在此看调度 / 执行结果与 Rolling 日志。

![XXL-JOB 调度日志：空列表与筛选栏](https://imgs.xuanyuan.cloud/docker/blog/xxl-job-5.webp)

### 6.3 执行器与用户

「执行器管理」有两个预置 Sample：`xxl-job-executor-sample`、`xxl-job-executor-sample-ai`，注册方式为自动注册；未接执行器时 OnLine 机器地址为「无」。「用户管理」默认仅有管理员 **admin**。

![XXL-JOB 执行器管理：两个 Sample，OnLine 地址为空](https://imgs.xuanyuan.cloud/docker/blog/xxl-job-6.webp)

![XXL-JOB 用户管理：默认管理员 admin](https://imgs.xuanyuan.cloud/docker/blog/xxl-job-7.webp)

本文 Compose **不含**执行器容器。没有在线机器时，「执行一次」示例任务会失败——属预期，见下一节。

---

## 七、对接执行器与生产加固

### 7.1 执行器最小配置

在业务应用或官方 sample 中，至少对齐这三项：

| 配置项 | 示例 |
|--------|------|
| Admin 地址 | `http://服务器IP:18080/`（集群多地址逗号分隔） |
| AccessToken | 与 Admin `PARAMS` 中 `xxl.job.accessToken` 一致（本文默认 `default_token`） |
| AppName | 与控制台「执行器」里的 AppName 一致（如 `xxl-job-executor-sample`） |

示例代码与可选镜像构建见仓库 [xxl-job-executor-samples](https://github.com/xuxueli/xxl-job/tree/master/xxl-job-executor-samples)。生产请把 Token 改成强随机串，并同步改 Admin `PARAMS` 与全部执行器。

### 7.2 生产建议

- 同时改掉：MySQL root 密码、Admin 登录密码、AccessToken；勿把真实口令提交到公开仓库
- Admin / MySQL 不对公网裸暴露；保证执行器能访问到 Admin
- 按负载调整 `JAVA_OPTS`；定期备份 `./mysql-data` 与 `./applogs`
- 升级：先备份 → 换同系列标签 → 对照 [Releases](https://github.com/xuxueli/xxl-job/releases) 是否需要增量 SQL（**勿**对已有库重复执行整份初始化脚本）

---

## 八、备选：docker run（临时 / 无 Compose）

适合已有可连通的 MySQL，且已导入 **3.4.2** 的 `tables_xxl_job.sql`。JDBC 主机必须是 Admin 容器能解析的地址（宿主机 MySQL 常用局域网 IP；**不要**写容器内的 `127.0.0.1`）。

```bash
docker run -d \
  --name xxl-job-admin \
  --restart unless-stopped \
  -p 18080:8080 \
  -e TZ=Asia/Shanghai \
  -e JAVA_OPTS="-Xms256m -Xmx512m" \
  -e PARAMS="--spring.datasource.url=jdbc:mysql://你的MySQL主机:3306/xxl_job?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true&useSSL=false --spring.datasource.username=root --spring.datasource.password=你的密码 --xxl.job.accessToken=default_token" \
  -v /www/wwwroot/xxl-job-admin/applogs:/data/applogs \
  docker.xuanyuan.run/xuxueli/xxl-job-admin:3.4.2
```

仍推荐第四节 Compose：健康检查、网络与初始化 SQL 一次齐。

---

## 九、升级与迁移

1. 改标签后 `docker compose pull` → `docker compose up -d`
2. 大版本升级前阅读 [Releases](https://github.com/xuxueli/xxl-job/releases) 与官方文档中的表结构变更
3. 搬家：停栈 → 打包 `mysql-data`、`applogs`、`init-db`、`docker-compose.yml` → 新机同目录启动
4. 已有生产库**不要**指望再次挂载整份 `tables_xxl_job.sql` 做升级——init 只在空数据目录首次执行

---

## 十、常见问题 FAQ

**Q1：Admin 连不上 MySQL？**  
`PARAMS` 主机名应为服务名 `mysql`；密码与 `MYSQL_ROOT_PASSWORD` 一致；等 MySQL healthy 后再看 Admin 日志。写成 `127.0.0.1` 是最常见踩坑。

**Q2：登录提示账号或密码错误？**  
确认 SQL 与镜像同版本。3.x 默认 **`admin` / `123456`**；混用 2.x 初始化数据会导致密码哈希算法不一致。

**Q3：打开 `/xxl-job-admin` 404？**  
3.4.x 默认 `context-path=/`，访问 **`http://IP:18080/`**。若你在 `PARAMS` 里改过 context-path，则按自定义路径访问。

**Q4：任务触发失败、执行器为 0？**  
Admin 只负责调度；需有执行器注册，且 AccessToken、AppName 一致。本文 Compose 未包含执行器。

**Q5：为什么映射 18080 而不是 8080？**  
8080 常被其它 Java 服务占用；左边端口可按需改，右边保持容器内 `8080`。宿主机也不建议占用开发常用的 3000。

**Q6：可以跟做 `latest` 吗？**  
不推荐。固定 **`3.4.2`**，升级时显式改标签并核对 SQL / changelog。

**Q7：要不要把 MySQL 端口映射到宿主机？**  
跟做默认不映射更安全。临时排错可加 `"13306:3306"`，用完删掉。

**Q8：刚 `up` 完 logs 为空、页面打不开？**  
冷启动正常现象：MySQL 先初始化（实测约 1 分钟），Admin Up 后 JVM 还要再加载。用 `docker compose logs -f xxl-job-admin` 等到有输出；`curl` 建议加 `--max-time 5`。

---

## 十一、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/xuxueli/xxl-job-admin:3.4.2
docker pull docker.xuanyuan.run/library/mysql:8.4

# Compose（主路径）
cd /www/wwwroot/xxl-job-admin
docker compose up -d
docker compose ps
docker compose logs -f xxl-job-admin
docker compose down

# 备选 run（需自备 MySQL）
docker run -d --name xxl-job-admin -p 18080:8080 \
  -e PARAMS="--spring.datasource.url=jdbc:mysql://... --spring.datasource.username=root --spring.datasource.password=... --xxl.job.accessToken=default_token" \
  -v /www/wwwroot/xxl-job-admin/applogs:/data/applogs \
  docker.xuanyuan.run/xuxueli/xxl-job-admin:3.4.2
```

访问：`http://服务器IP:18080/` · 默认账号：`admin` / `123456`

---

## 十二、延伸阅读

| 资源 | 链接 |
|------|------|
| [xuxueli/xxl-job-admin 镜像页](https://xuanyuan.cloud/zh/r/xuxueli/xxl-job-admin) | [https://xuanyuan.cloud/zh/r/xuxueli/xxl-job-admin](https://xuanyuan.cloud/zh/r/xuxueli/xxl-job-admin) |
| [镜像标签列表](https://xuanyuan.cloud/r/xuxueli/xxl-job-admin/tags) | [https://xuanyuan.cloud/r/xuxueli/xxl-job-admin/tags](https://xuanyuan.cloud/r/xuxueli/xxl-job-admin/tags) |
| [XXL-JOB 官方文档](https://www.xuxueli.com/xxl-job/) | [https://www.xuxueli.com/xxl-job/](https://www.xuxueli.com/xxl-job/) |
| [GitHub · xuxueli/xxl-job](https://github.com/xuxueli/xxl-job/) | [https://github.com/xuxueli/xxl-job/](https://github.com/xuxueli/xxl-job/) |
| [3.4.2 初始化 SQL](https://github.com/xuxueli/xxl-job/blob/3.4.2/doc/db/tables_xxl_job.sql) | [https://github.com/xuxueli/xxl-job/blob/3.4.2/doc/db/tables_xxl_job.sql](https://github.com/xuxueli/xxl-job/blob/3.4.2/doc/db/tables_xxl_job.sql) |
| [Docker Hub · xuxueli/xxl-job-admin](https://hub.docker.com/r/xuxueli/xxl-job-admin) | [https://hub.docker.com/r/xuxueli/xxl-job-admin](https://hub.docker.com/r/xuxueli/xxl-job-admin) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- 跟做固定 **`xuxueli/xxl-job-admin:3.4.2`**，Compose 拉起 MySQL + Admin，访问 **`http://IP:18080/`**。
- 初始化 SQL 必须与镜像同版本；默认 **`admin` / `123456`**，生产改密并更换 `default_token`。
- Admin 只是调度中心；接上执行器后才能真正跑任务。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/xxl-job-admin-docker-deploy


