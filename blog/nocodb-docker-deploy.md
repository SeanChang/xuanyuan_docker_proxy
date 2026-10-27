# Docker 部署 NocoDB：轻松搭建在线数据表格

![Docker 部署 NocoDB：轻松搭建在线数据表格](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb.webp)

*分类: Docker部署教程 | 标签: NocoDB,Docker,轩辕镜像,在线数据库,PostgreSQL,私有化部署,部署教程 | 发布时间: 2026-10-24 21:04:47*

> NocoDB 是一款面向团队的开源在线数据库，旨在把结构化数据放进表格界面，并通过多种视图、分享和权限来组织这些数据。本文将介绍如何通过 Docker Compose 部署 NocoDB，搭建在线数据表格平台，帮助团队更高效地维护台账和收集表，适合内部数据管理及轻量业务表单等场景。

*本文基于 [nocodb/nocodb:2026.10.0](https://xuanyuan.cloud/zh/r/nocodb/nocodb)，以 **2026.10.0** 版本实测，数据库 PostgreSQL **17.10**，缓存 Redis **7.4.11**，测试平台 **Ubuntu 24.04** Linux。*

## NocoDB 是什么

NocoDB 是开源的在线数据库。浏览器里用表格新增、修改和删除记录，同一张表还可以换成表单、看板或日历。

和把台账放在在线表格里相比，这一套跑在你自己的服务器上。记录和附件留在服务器里，不必再把文件传来传去。

## NocoDB 能做什么

- **用表格维护数据**：在表格里新增、修改和删除记录，也可以排序、筛选和分组。
- **换不同视图**：同一张表可以按表格、画廊、表单、看板或日历来看。
- **分享页面**：表格和应用右上角有「分享」，可以把页面发给别人。
- **按角色区分权限**：不同的人能看到的表和能做的操作可以分开。
- **用接口读写**：除了在页面上改，还可以通过 REST API 和 SDK 访问数据。

## 为什么要使用 NocoDB

台账放在在线表格里，文件一多就对不上是哪一版。把同一份数据放进数据库，查询和页面又要另外做。

NocoDB 把表格和数据库放在同一套服务里，由你自己的机器保存。适合内部台账、收集表，以及要把数据留在自己服务器上的小团队。

## 使用 Docker 部署 NocoDB

用 Docker 跑 NocoDB，宿主机不用再安装 Node.js 和数据库软件包。开始之前准备好 Docker，并想好别人打开这个页面时使用的地址。

接下来用 Docker Compose 写好数据库、缓存和应用，启动服务，再在浏览器里注册第一个账号。

## 环境要求

本文命令使用 **`nocodb/nocodb:2026.10.0`**。数据库使用 **`library/postgres:17.10`**，缓存使用 **`library/redis:7.4.11`**。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）。macOS 把 `/www/wwwroot/nocodb` 换成 `~/docker/nocodb`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | NocoDB **2026.10.0** 提供 **linux/amd64**、**linux/arm64** 和 **linux/arm/v7** |
| 磁盘 | NocoDB amd64 约 241 MB，PostgreSQL 17.10 的 amd64 约 154 MB，Redis 7.4.11 的 amd64 约 42 MB。表数据和附件按实际再留余量 |
| 端口 | 宿主机 **8080** → 容器 **8080**。启动前确认本机没有别的程序占用 8080 |
| 工作目录 | `/www/wwwroot/nocodb` |
| 数据 | Compose 使用三个数据卷：应用文件、PostgreSQL、Redis。`docker compose down` 不加 `-v` 时保留这些卷 |
| 账号 | 没有预置管理员。第一个注册成功的人成为超级管理员 |

只在本机浏览器打开时，地址是 `http://127.0.0.1:8080`。给局域网里的人用时，放行 **8080**，并限制来源地址。不要把 8080 对公网全部打开。

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

Windows 和 Mac 从 [Docker Desktop](https://www.docker.com/products/docker-desktop/) 安装，安装后启动 Docker Desktop。下文的 `cat > compose.yaml <<'EOF'` 是 bash 写法。PowerShell 不能直接粘贴这一段，请改用 Git Bash、WSL，或在 Linux 上执行。

## 标签怎么选

2026-10-24 查看 Docker Hub 时，`latest` 与 `2026.10.0` 是同一份镜像。`latest` 会在以后的版本发布后改指向。下面的命令使用 **`2026.10.0`**。这一标签在 2026-10-23 推送，包含 linux/amd64、linux/arm64 和 linux/arm/v7。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`2026.10.0`** | 2026-10-23 这份具体版本 | **是** |
| `latest` | 当前与 `2026.10.0` 相同，以后会变 | 否 |
| `2026.09.1` 及更早版本号 | 更早的 NocoDB 版本 | 否 |

官方 quickstart 示例里的数据库标签是 `postgres:17.10`。Redis 示例写的是浮动标签 `redis:7`。本文把 Redis 写成具体版本 **`7.4.11`**。`7` 和 `7.4` 会随补丁更新改指向，不要写进命令。

完整标签见 [NocoDB 标签列表](https://xuanyuan.cloud/r/nocodb/nocodb/tags)、[PostgreSQL 标签列表](https://xuanyuan.cloud/r/library/postgres/tags) 和 [Redis 标签列表](https://xuanyuan.cloud/r/library/redis/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**。应用和 worker 使用同一份镜像，拉一次即可。

```bash
docker pull docker.xuanyuan.run/nocodb/nocodb:2026.10.0
docker pull docker.xuanyuan.run/library/postgres:17.10
docker pull docker.xuanyuan.run/library/redis:7.4.11
```

Ubuntu 24.04 实测：

```text
2026.10.0: Pulling from nocodb/nocodb
44136fa355b3: Download complete
7b229517ed22: Pull complete
72b4e0c2e63a: Pull complete
15577f11e05a: Pull complete
f0a5c9e3ce7d: Pull complete
109c2f814f46: Pull complete
b9f4b6046e0e: Pull complete
9e14b3894480: Pull complete
1a0fb29d2323: Pull complete
6190b487ea09: Pull complete
e45e0e360a1a: Download complete
Digest: sha256:e8fee91b205b7c51df6e35a9d890d8b68b216e987ed3feb387c5478dff6df951
Status: Downloaded newer image for docker.xuanyuan.run/nocodb/nocodb:2026.10.0
docker.xuanyuan.run/nocodb/nocodb:2026.10.0
```

```text
17.10: Pulling from library/postgres
26c307b5e35a: Pull complete
b33915915b51: Pull complete
99adb42d27ad: Pull complete
c7ce579d92bc: Pull complete
f5991d0b8b5b: Pull complete
315760abeb8e: Pull complete
57b3b7f0e8be: Pull complete
1e27b4f5b34f: Pull complete
3b520f7c783b: Pull complete
881078803fc8: Pull complete
4fa43b3f35bd: Pull complete
7feaef9a63ac: Pull complete
ccc368eb7cc7: Pull complete
639f0ce3e131: Pull complete
77f2ab6112f3: Download complete
b34e54be0ddb: Download complete
Digest: sha256:7958605b474b3d264a969cb3a123d6aa00ad1e1fe9da8a69984dabb704d93317
Status: Downloaded newer image for docker.xuanyuan.run/library/postgres:17.10
docker.xuanyuan.run/library/postgres:17.10
```

```text
7.4.11: Pulling from library/redis
4b603876a035: Pull complete
33eae4cc1a36: Pull complete
6b2f4b3ff830: Pull complete
9d5d7c9fabc5: Pull complete
aa7891908097: Pull complete
4f4fb700ef54: Pull complete
11422d7ca1a4: Pull complete
53d0115eec0b: Download complete
88197588d635: Download complete
Digest: sha256:44960b3100c48159a66d28c18b0588c193492e25f7551d60e51dd464fc3eca5b
Status: Downloaded newer image for docker.xuanyuan.run/library/redis:7.4.11
docker.xuanyuan.run/library/redis:7.4.11
```

完成后，再写下面的 Compose。

## Docker Compose 部署

这一套包含四个容器：

| 容器 | 作用 |
|------|------|
| `nocodb` | 网页和 API，发布到宿主机 8080 |
| `nocodb-worker` | 导入、导出和自动化一类后台任务 |
| `nocodb-db` | PostgreSQL，保存元数据和表数据 |
| `nocodb-redis` | 缓存和任务队列 |

应用和 worker 把同一份数据卷挂到 `/usr/app/data`，附件放在这里。PostgreSQL 与 Redis 各自使用数据卷，端口不发布到宿主机。

数据库密码会出现在三处：`POSTGRES_PASSWORD`，以及 `nocodb` 和 `worker` 的 `NC_DB`。三处必须相同。密码不要包含 `&`、`?`、`#`、`=`，这些字符会打断 `NC_DB` 这串连接信息。

`NC_AUTH_JWT_SECRET` 用来签发登录令牌。应用和 worker 必须写成同一串。原样启动时，数据库密码是 `change-me`，令牌密钥是 `change-me-jwt-secret`。给别人用之前先换成只有你知道的值。

`NC_SITE_URL` 决定邀请、重置密码和分享链接使用的地址。只在本机打开时保持 `http://127.0.0.1:8080`。从别的电脑打开时，先改成 `http://服务器IP:8080`，再启动。

单机这一套把 `NC_DISABLE_MUX` 写成 `true`。保留这一行。

以前用 `docker run` 创建过名为 `nocodb` 的容器时，先删掉容器再启动 Compose。这一步不删除下面新建的数据卷。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/nocodb
sudo chown -R "$USER":"$USER" /www/wwwroot/nocodb
```

同名容器还在时：

```bash
docker rm -f nocodb
```

2. 确认 8080 没有被占用：

```bash
ss -ltn 'sport = :8080'
```

只有表头、下面没有地址行时，端口是空的。

Ubuntu 24.04 实测：

```text
State                  Recv-Q                  Send-Q                                   Local Address:Port                                   Peer Address:Port                  Process
```

3. 写入 `compose.yaml`。密码三处保持一致，两处令牌密钥保持一致。只在本机打开时，`NC_SITE_URL` 保持 `http://127.0.0.1:8080`。原样粘贴时，数据库密码是 `change-me`，令牌密钥是 `change-me-jwt-secret`。

```bash
cd /www/wwwroot/nocodb
cat > compose.yaml <<'EOF'
name: nocodb

services:
  nocodb:
    image: docker.xuanyuan.run/nocodb/nocodb:2026.10.0
    container_name: nocodb
    restart: unless-stopped
    environment:
      NC_DB: "pg://db:5432?u=nocodb&p=change-me&d=nocodb"
      NC_REDIS_URL: "redis://redis:6379"
      NC_SITE_URL: "http://127.0.0.1:8080"
      NC_AUTH_JWT_SECRET: "change-me-jwt-secret"
      NC_DISABLE_MUX: "true"
    ports:
      - "8080:8080"
    volumes:
      - nocodb_data:/usr/app/data
    networks:
      - nocodb-network
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    healthcheck:
      test: ["CMD-SHELL", "wget -q --tries=1 --spider http://localhost:8080/api/v1/health || exit 1"]
      interval: 30s
      timeout: 5s
      retries: 5
      start_period: 30s

  worker:
    image: docker.xuanyuan.run/nocodb/nocodb:2026.10.0
    container_name: nocodb-worker
    restart: unless-stopped
    environment:
      NC_DB: "pg://db:5432?u=nocodb&p=change-me&d=nocodb"
      NC_REDIS_URL: "redis://redis:6379"
      NC_SITE_URL: "http://127.0.0.1:8080"
      NC_AUTH_JWT_SECRET: "change-me-jwt-secret"
      NC_WORKER_CONTAINER: "true"
    volumes:
      - nocodb_data:/usr/app/data
    networks:
      - nocodb-network
    depends_on:
      nocodb:
        condition: service_healthy

  db:
    image: docker.xuanyuan.run/library/postgres:17.10
    container_name: nocodb-db
    restart: unless-stopped
    environment:
      POSTGRES_USER: nocodb
      POSTGRES_PASSWORD: change-me
      POSTGRES_DB: nocodb
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - nocodb-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U nocodb -d nocodb"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: docker.xuanyuan.run/library/redis:7.4.11
    container_name: nocodb-redis
    restart: unless-stopped
    volumes:
      - redis_data:/data
    networks:
      - nocodb-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

networks:
  nocodb-network:
    driver: bridge

volumes:
  nocodb_data:
  postgres_data:
  redis_data:
EOF
```

宿主机 **8080** 对应容器 **8080**。8080 已被占用时，只改冒号左边，并让两处 `NC_SITE_URL` 使用同一个端口。不要把宿主机端口改成 3000。

容器异常退出后会自动再启动。手动 `docker compose stop` 之后，不会被拉起来。

4. 启动：

```bash
cd /www/wwwroot/nocodb
docker compose up -d
```

Ubuntu 24.04 实测：

```text
[+] up 8/8
 ✔ Volume nocodb_redis_data      Created                                                                                                                                                             0.4s
 ✔ Network nocodb_nocodb-network Created                                                                                                                                                             0.4s
 ✔ Volume nocodb_nocodb_data     Created                                                                                                                                                             0.3s
 ✔ Volume nocodb_postgres_data   Created                                                                                                                                                             0.2s
 ✔ Container nocodb-db           Healthy                                                                                                                                                            16.5s
 ✔ Container nocodb-redis        Healthy                                                                                                                                                            15.5s
 ✔ Container nocodb              Healthy                                                                                                                                                            75.4s
 ✔ Container nocodb-worker       Started                                                                                                                                                            78.0s
```

这次数据库约 16 秒通过健康检查，应用约 75 秒变成 Healthy，worker 在其后启动。

5. 看状态。四个容器都应为 Up。只有 `nocodb` 映射了 `0.0.0.0:8080->8080/tcp`。数据库的 5432 和 Redis 的 6379 不映射到宿主机。`nocodb-worker` 那一行的 `8080/tcp` 也只在容器内，没有映出来。worker 没有 `(healthy)`，这份 Compose 没有给它写健康检查。

```bash
docker compose ps
```

Ubuntu 24.04 实测：

```text
NAME            IMAGE                                         COMMAND                  SERVICE   CREATED         STATUS                   PORTS
nocodb          docker.xuanyuan.run/nocodb/nocodb:2026.10.0   "/usr/bin/dumb-init …"   nocodb    2 minutes ago   Up 2 minutes (healthy)   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp
nocodb-db       docker.xuanyuan.run/library/postgres:17.10    "docker-entrypoint.s…"   db        2 minutes ago   Up 2 minutes (healthy)   5432/tcp
nocodb-redis    docker.xuanyuan.run/library/redis:7.4.11      "docker-entrypoint.s…"   redis     2 minutes ago   Up 2 minutes (healthy)   6379/tcp
nocodb-worker   docker.xuanyuan.run/nocodb/nocodb:2026.10.0   "/usr/bin/dumb-init …"   worker    2 minutes ago   Up About a minute        8080/tcp
```

6. 在服务器上看健康检查地址。打印 `200` 就可以打开页面。

```bash
curl -fsS -o /dev/null -w "%{http_code}
" http://127.0.0.1:8080/api/v1/health
```

Ubuntu 24.04 实测：

```text
200
```

7. 看应用日志。前面是表结构迁移。出现 `App started successfully.` 和 `Visit -> http://127.0.0.1:8080/` 就可以打开页面。`No license key found — running in CE mode` 表示这次没有填写许可证，按社区版运行。

```bash
docker compose logs --tail 80 nocodb
```

Ubuntu 24.04 实测。命令输出里前面是迁移过程，下面只保留可以打开页面的那几行：

```text
nocodb  | {"level":30,"time":1792845575813,"pid":13,"hostname":"8feeb9874c0a","context":"NestApplication","msg":"Nest application successfully started"}
nocodb  | {"level":30,"time":1792845575840,"pid":13,"hostname":"8feeb9874c0a","context":"Noco","msg":"No license key found — running in CE mode"}
nocodb  | App started successfully.
nocodb  | Visit -> http://127.0.0.1:8080/
```

`docker compose down` 不加额外参数时，不会删除数据卷。卷名是 `nocodb_nocodb_data`、`nocodb_postgres_data` 和 `nocodb_redis_data`。

## 打开页面并注册

在跑 Docker 的这台机器上，浏览器打开：

```text
http://127.0.0.1:8080
```

也可以直接打开 `http://127.0.0.1:8080/dashboard`。从别的电脑访问时，把主机换成这台服务器的 IP，并且两处 `NC_SITE_URL` 已经写成同一个地址。

没有预置的用户名和密码。第一个注册成功的人成为超级管理员。

注册和向导这几页，左半边是产品介绍，不是已经建好的表。要填写和点击的是右半边。

1. 首次打开是英文注册页，标题是 Create your NocoDB account。右上角把语言从 English 改成「简体中文」。

![NocoDB 英文注册页，右侧为 Create your NocoDB account，语言为 English，蓝色按钮为 Sign up](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb-1.webp)

2. 页面变成「创建您的 NocoDB 账户」。填写邮箱和密码。这次邮箱是 `hi@sourcecodedance.com`。不需要新闻邮件时，取消「订阅我们的每周新闻邮件」，再点「注册」。截图里这一项是勾选的。

![简体中文注册页，语言菜单展开并选中简体中文，邮箱已填，蓝色按钮为注册](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb-2.webp)

注册页改成简体中文之后，使用场景和 AI 工具这两步仍是英文，按钮分别是「跳过」和「结束」。

3. 注册后先问使用场景，四个选项是 Work、School、Non-Profit、Personal。这次点「跳过」。

![注册后的使用场景页，选项为 Work、School、Non-Profit、Personal，右下角为跳过](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb-3.webp)

4. 下一页是 Choose AI Tools That You Are Familiar With。不需要勾选工具。点「结束」。

![选择熟悉的 AI 工具，右下角按钮为结束，左下角为返回](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb-4.webp)

5. 随后进入 Default Workspace。项目列表里已经有 Getting Started，左下角是刚才注册的邮箱。这是注册后就有的项目，不是刚才新建的。

![Default Workspace 项目页，卡片为 Getting Started，右上角为新建项目，左下角邮箱为 hi@sourcecodedance.com](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb-5.webp)

从别的电脑打开时，云服务器在安全组里放行 **8080**，来源填你的局域网或指定 IP。本机启用了 ufw 时，把网段换成你的局域网再执行：

```bash
sudo ufw allow from 192.168.0.0/16 to any port 8080 proto tcp
```

## 新建一张表

1. 点 Getting Started。首页标题是「你想做什么？」。下面有新建表格、新建文档、导入、从应用同步、连接到数据库。左下角版本是 Version 2026.10.0。侧栏里已有一张 Features，那是这个项目自带的表。

![Getting Started 首页，标题为你想做什么，列出新建表格、新建文档、导入、从应用同步和连接到数据库，左下角 Version 2026.10.0](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb-6.webp)

2. 点「新建表格」。名称保持「表格-1」，数据源保持「默认」。点「创建新的表格」。

![创建新的表格对话框，名称为表格-1，数据源为默认，蓝色按钮为创建新的表格](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb-7.webp)

3. 进入空表。点「字段」可以看到 Id、CreatedAt、UpdatedAt。底部是 0 记录。同一页上有「+ 新的字段」和「+ 新增记录」。

![表格-1 的空表，字段菜单展开，列出 Id、CreatedAt、UpdatedAt，底部为 0 记录](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb-8.webp)

4. 点「+ 新的字段」，增加一列 Title。

5. 点「+ 新增记录」，Title 填「测试字段」。这一行的 Id 为 1，CreatedAt 与 UpdatedAt 都是 2026-10-24 20:47。底部变成 1 记录。

![表格-1 已有一行，Title 为测试字段，Id 为 1，CreatedAt 与 UpdatedAt 为 2026-10-24 20:47，底部为 1 记录](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb-9.webp)

附件写在应用数据卷里。`nocodb` 和 `nocodb-worker` 挂的是同一份卷。表数据在 PostgreSQL 里。

## 新建工作流

首页「你想做什么？」里没有工作流。新建工作流后出现「创建工作流程」。名称填 Workflow，点「创建工作流程」。

![创建工作流程对话框，名称为 Workflow，蓝色按钮为创建工作流程](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb-10.webp)

进入 Editor 后打开触发器列表。可见记录被创建、记录被更新、记录被删除、记录进入视图、记录符合条件，以及提交表单、在记录上点击按钮、在记录上评论、按计划。这次停在这个列表，没有保存触发器。右上角是 Paused，右侧上次运行是 No runs yet。

![Workflow 编辑器打开选择触发器菜单，可见记录被创建、记录被更新和按计划，状态为 Paused](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb-11.webp)

## 新建应用

1. 新建应用的第一页标题是「为你的应用命名」。名称这次是「未命名应用」。点「下一个」。

![为应用命名，应用名称为未命名应用，右侧有布局预览，按钮为下一个](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb-12.webp)

2. 下一页标题是「选择一个 Layout」。列表里有表格、列表、画廊、看板、日历、时间线、记录审核和表单。这次选「看板」，说明是把记录整理到各列中。点「下一个」。

![选择 Layout，看板一项已选中，说明为把记录整理到各列中，按钮为下一个](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb-13.webp)

3. 下一页标题是「连接到一个表」。这次选的是项目自带的 Features，不是刚才的「表格-1」。Features 的字段是 Title，记录是 0 条。点「创建应用」。

![连接到一个表，表为 Features，字段为 Title，蓝色按钮为创建应用](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb-14.webp)

4. 进入看板后，中间写着「请选择堆叠字段以呈现看板」。右侧分组字段处显示「选择分组字段」，下面是同一句提示。这次没有选成分列，看板是空的。

![未命名应用的看板视图，中间和右侧都提示请选择堆叠字段以呈现看板，数据源为 Features](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb-15.webp)

## 查看集成

回到 Default Workspace，左侧点「集成」。已有的连接是 NocoDB。同一页还可以看到 MySQL、PostgreSQL、SQLite、SQL Server 和 Oracle。这次没有新增连接。

![工作区集成页，Your connections 为 NocoDB，下方列出 MySQL、PostgreSQL、SQLite、SQL Server 和 Oracle](https://imgs.xuanyuan.cloud/docker/blog/nocodb/nocodb-16.webp)

## 按需要调整

下面每一项都是在已经写好的 `compose.yaml` 上修改。改完后在同一目录执行：

```bash
cd /www/wwwroot/nocodb
docker compose up -d
```

不要加 `-v`。数据卷会保留。

### 改访问地址

从局域网另一台电脑打开时，把两处 `NC_SITE_URL` 里的 `127.0.0.1` 换成服务器 IP，端口仍是 8080。应用和 worker 一起改，然后执行 `docker compose up -d`。已经建好的表还在。

### 改数据库密码

数据卷第一次初始化之后，只改 `compose.yaml` 里的 `POSTGRES_PASSWORD`，不会改掉库里已经生效的密码。`NC_DB` 必须和库里的密码一致，否则应用连不上数据库。

库里还没有要留的数据时，可以删掉数据卷，用新密码重新初始化。这一步会清掉表、账号和附件：

```bash
cd /www/wwwroot/nocodb
docker compose down -v
```

然后把三处密码改成同一个新值，再执行 `docker compose up -d`，并重新注册。

库里已经有数据时，先在数据库里修改用户密码，再把 `compose.yaml` 里的三处改成同一个新值，最后执行 `docker compose up -d`。新密码同样不要包含 `&`、`?`、`#`、`=`。

```bash
cd /www/wwwroot/nocodb
docker compose exec db psql -U nocodb -d nocodb -c "ALTER USER nocodb PASSWORD 'new-password';"
```

把 `new-password` 换成你的新密码，并同步改掉 Compose 里的三处。

## 备选：docker run

没有 Compose，或只想短时间看一眼界面时，可以用单个容器。这条路径不设置 `NC_DB`，NocoDB 使用 SQLite，数据写在 `/usr/app/data`。它不包含 worker、PostgreSQL 和 Redis。多人长期使用时，回到上面的 Compose。

这条命令占用宿主机 8080，容器名也是 `nocodb`。Compose 那一套还在跑时，先停掉它。`docker compose stop` 不删除数据卷。

1. 停掉 Compose，并准备另一份目录。SQLite 的文件放在这里，不进入 Compose 的数据卷：

```bash
cd /www/wwwroot/nocodb
docker compose stop
sudo mkdir -p /www/wwwroot/nocodb-run/data
sudo chown -R "$USER":"$USER" /www/wwwroot/nocodb-run
```

2. 启动。原样执行时，令牌密钥是 `change-me-jwt-secret`。给别人用之前先换掉。

```bash
docker run -d 
  --name nocodb 
  --restart unless-stopped 
  -p 8080:8080 
  -e NC_AUTH_JWT_SECRET=change-me-jwt-secret 
  -e NC_SITE_URL=http://127.0.0.1:8080 
  -v /www/wwwroot/nocodb-run/data:/usr/app/data 
  docker.xuanyuan.run/nocodb/nocodb:2026.10.0
```

3. 看状态。`nocodb` 应为 Up，端口是 `0.0.0.0:8080->8080/tcp`。

```bash
docker ps --filter name=nocodb
```

浏览器打开 `http://127.0.0.1:8080` 注册。在这个容器里注册的账号写在 `/www/wwwroot/nocodb-run/data`，不会出现在 Compose 的 PostgreSQL 里。

试用结束、要回到 Compose 时，先删掉这个容器，再启动原来的 Compose。不要删除 Compose 的数据卷。

```bash
docker stop nocodb && docker rm nocodb
cd /www/wwwroot/nocodb
docker compose up -d
```

## 升级

先导出 PostgreSQL。附件在应用数据卷里，升级时不要执行 `docker compose down -v`。

```bash
cd /www/wwwroot/nocodb
docker compose exec -T db pg_dump -U nocodb -d nocodb > nocodb-backup.sql
```

提示输入密码时，填写当前库里的密码。按本文示例、且没有改过密码时，填写 `change-me`。导出的 `nocodb-backup.sql` 在当前目录。

然后把 `compose.yaml` 里两处 `nocodb/nocodb` 的标签改成同一个新的具体版本号。PostgreSQL 仍用 `17.10`，Redis 仍用 `7.4.11`。然后执行：

```bash
cd /www/wwwroot/nocodb
docker compose pull
docker compose up -d
```

不要把标签改成 `latest`。

## 常见问题

**Q1：8080 端口起不来？**

宿主机上已经有程序监听 8080 时，这条映射会失败。先停掉占用端口的程序，或只把 `8080:8080` 的左边改成空闲端口，并让两处 `NC_SITE_URL` 使用同一个端口。然后执行 `docker compose up -d`。

**Q2：能不能把页面放到宿主机 3000？**

容器内监听的是 8080。宿主机 3000 经常被本机前端开发占用，本文把宿主机 **8080** 映到容器 **8080**。需要换端口时，改冒号左边，不要改成 3000。

**Q3：页面能打开，邀请和分享链接仍指向 127.0.0.1？**

`NC_SITE_URL` 还是本机地址。按「改访问地址」把应用和 worker 的这一项改成别人能打开的 `http://服务器IP:8080`，再执行 `docker compose up -d`。

**Q4：改了 Compose 里的数据库密码之后，应用起不来？**

PostgreSQL 数据卷已经初始化过时，卷里的密码不会跟着 `POSTGRES_PASSWORD` 变。`NC_DB` 里的密码要和库里的实际密码一致。还没有要留的数据时，按「改数据库密码」执行 `docker compose down -v` 后重新初始化。已经有数据时，先 `ALTER USER`，再改 Compose 里的三处。

**Q5：没有默认管理员账号？**

没有。按「打开页面并注册」用邮箱注册。第一个注册成功的人成为超级管理员。

**Q6：改了 `NC_AUTH_JWT_SECRET` 之后要重新登录？**

登录令牌是用这个密钥签发的。密钥换成新值并重新启动后，原来的登录状态失效，用原来的邮箱和密码再登录即可。账号还在数据库里。应用和 worker 的密钥要保持同一串。

**Q7：`docker compose down` 会删掉表吗？**

不加 `-v` 时，三个数据卷都保留，表、账号和附件还在。加上 `-v` 会删掉这些卷。SQLite 试用目录 `/www/wwwroot/nocodb-run/data` 不是这套卷，两边的账号和表不共用。

**Q8：worker 一直不启动？**

`nocodb-worker` 会等 `nocodb` 的健康检查通过。先看 `docker compose ps`。`nocodb` 还没有变成 healthy 时，看 `docker compose logs --tail 80 nocodb`，并确认数据库密码三处一致、8080 映射成功。

**Q9：如何停止？**

还要保留数据时，不要加 `-v`。

```bash
cd /www/wwwroot/nocodb
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop nocodb && docker rm nocodb
```

这套服务不再需要时，再删除数据卷和 SQLite 试用目录：

```bash
cd /www/wwwroot/nocodb
docker compose down -v
rm -rf /www/wwwroot/nocodb-run
```

`compose.yaml` 里有数据库密码和令牌密钥。目录废弃时一并处理，不要留在还在使用的备份里。

## 命令速查

```bash
docker pull docker.xuanyuan.run/nocodb/nocodb:2026.10.0
docker pull docker.xuanyuan.run/library/postgres:17.10
docker pull docker.xuanyuan.run/library/redis:7.4.11

cd /www/wwwroot/nocodb
docker compose up -d
docker compose ps
docker compose logs --tail 80 nocodb
curl -fsS -o /dev/null -w "%{http_code}
" http://127.0.0.1:8080/api/v1/health
docker compose exec -T db pg_dump -U nocodb -d nocodb > nocodb-backup.sql
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://127.0.0.1:8080`，从别的电脑访问时把主机换成服务器 IP。第一个注册的人是超级管理员。Compose 的数据在数据卷里，SQLite 试用的数据在 `/www/wwwroot/nocodb-run/data`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [nocodb/nocodb 镜像页](https://xuanyuan.cloud/zh/r/nocodb/nocodb) | [https://xuanyuan.cloud/zh/r/nocodb/nocodb](https://xuanyuan.cloud/zh/r/nocodb/nocodb) |
| [nocodb/nocodb 概览](https://xuanyuan.cloud/r/nocodb/nocodb) | [https://xuanyuan.cloud/r/nocodb/nocodb](https://xuanyuan.cloud/r/nocodb/nocodb) |
| [nocodb/nocodb 标签列表](https://xuanyuan.cloud/r/nocodb/nocodb/tags) | [https://xuanyuan.cloud/r/nocodb/nocodb/tags](https://xuanyuan.cloud/r/nocodb/nocodb/tags) |
| [library/postgres 镜像页](https://xuanyuan.cloud/zh/r/library/postgres) | [https://xuanyuan.cloud/zh/r/library/postgres](https://xuanyuan.cloud/zh/r/library/postgres) |
| [library/redis 镜像页](https://xuanyuan.cloud/zh/r/library/redis) | [https://xuanyuan.cloud/zh/r/library/redis](https://xuanyuan.cloud/zh/r/library/redis) |
| [Docker Hub · nocodb/nocodb](https://hub.docker.com/r/nocodb/nocodb) | [https://hub.docker.com/r/nocodb/nocodb](https://hub.docker.com/r/nocodb/nocodb) |
| [GitHub · nocodb/nocodb](https://github.com/nocodb/nocodb) | [https://github.com/nocodb/nocodb](https://github.com/nocodb/nocodb) |
| [官方 Quickstart](https://nocodb.com/docs/self-hosting/installation/quickstart) | [https://nocodb.com/docs/self-hosting/installation/quickstart](https://nocodb.com/docs/self-hosting/installation/quickstart) |
| [官方 quickstart Compose 示例](https://github.com/nocodb/nocodb/blob/develop/docker-compose/examples/quickstart-demo/docker-compose.yml) | [https://github.com/nocodb/nocodb/blob/develop/docker-compose/examples/quickstart-demo/docker-compose.yml](https://github.com/nocodb/nocodb/blob/develop/docker-compose/examples/quickstart-demo/docker-compose.yml) |
| [环境变量](https://nocodb.com/docs/self-hosting/environment-variables) | [https://nocodb.com/docs/self-hosting/environment-variables](https://nocodb.com/docs/self-hosting/environment-variables) |
| [升级说明](https://nocodb.com/docs/self-hosting/maintenance/upgrading) | [https://nocodb.com/docs/self-hosting/maintenance/upgrading](https://nocodb.com/docs/self-hosting/maintenance/upgrading) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/nocodb-docker-deploy


