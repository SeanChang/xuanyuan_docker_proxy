# Docker 部署 Halo：轻松搭建开源博客

![Docker 部署 Halo：轻松搭建开源博客](https://imgs.xuanyuan.cloud/docker/blog/halo/halo.webp)

*分类: Docker部署教程 | 标签: Halo,halohub/halo,Docker,轩辕镜像,开源博客,博客,私有化部署,部署教程 | 发布时间: 2026-10-11 14:19:10*

> Halo 是一款面向个人的开源博客建站工具，旨在把文章留在自己的服务器上，并通过主题与插件组织博客前台。本文将介绍如何通过 Docker Compose 快速部署 Halo，搭建自托管博客，帮助你发布文章并在前台打开，适合个人写博客。

*本文基于 [halohub/halo:2.26.1](https://xuanyuan.cloud/zh/r/halohub/halo)，以 **2.26.1** 版本实测，数据库 PostgreSQL **15.4**，Java **21.0.12**，测试平台 **Ubuntu 24.04** Linux。*

## Halo 是什么

Halo 是开源的博客建站工具。文章写在你自己的服务器上，前台版式由主题决定，评论和搜索来自插件。管理入口在浏览器里的 Console。

和把博客放在第三方平台相比，文章留在你这台机器上。和只生成静态页面相比，它有登录账号、可更换的主题和可安装的插件。本文部署社区版来写博客。在线商城在商城版里，用的是另一套镜像。

## Halo 能做什么

- **发布文章**：写完后发布，博客前台能打开标题和正文。
- **看运行情况**：仪表盘列出文章数、评论数和浏览量。
- **更换主题**：前台版式跟着当前主题变。
- **使用插件**：这次启动日志里已经拉起搜索、站点地图等插件，之后也可以再安装或停用。
- **备份站点**：在 Console 里创建整站备份，升级前先留一份。

## 为什么要使用 Halo

文章放在托管平台上，数据和主题都在对方那里。只写一个自己的博客时，也不必从零做后台。

Halo 把文章和上传的文件放在你指定的目录里。个人博客用社区版即可。

## 使用 Docker 部署 Halo

Halo 可以用 Docker 把博客跑起来，宿主机不必安装 JRE。开始之前准备好 Docker，并定好博客对外的访问地址。

下面用 Docker Compose 配好数据库和这个地址，启动服务，然后在浏览器里初始化、登录，并发布一篇文章。

## 环境要求

本文使用社区版 **2.26.1** 版本实测。官方建议服务器至少 1 GB 内存。宿主机不必安装 JRE，镜像里的 Java 是 **21.0.12**。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（本文 **Ubuntu 24.04**）；macOS 把 `/www/wwwroot/halo` 换成 `~/docker/halo` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | 常见服务器选 **linux/amd64** 或 **linux/arm64** |
| 内存 | ≥ 1 GB（官方建议）。Halo 与 PostgreSQL 跑在同一台机器上 |
| 磁盘 | 镜像和数据库之外，按附件数量另留空间 |
| 端口 | 宿主机 **8090** → 容器 **8090**。PostgreSQL 只在 Compose 网络内，不映射到宿主机 |
| 工作目录 | `/www/wwwroot/halo` |
| 其他 | 生成数据库口令需要 `openssl` |

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

[GitHub Release v2.26.1](https://github.com/halo-dev/halo/releases/tag/v2.26.1) 发布于 2026-09-01。社区版镜像是 `halohub/halo`，付费版是 `halohub/halo-pro`。本文只部署社区版。

官方 Compose 示例写的是 `2.26`。这个标签会跟着 2.26 线的后续补丁移动。下面的命令使用具体版本 **`2.26.1`**。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`2.26.1`** | 社区版 2.26.1，对应 Release v2.26.1 | **是** |
| `2.26` | 2.26 线的滚动标签，官方 Compose 示例使用它 | 否 |
| `2` | 整个 Halo 2 的最新版本，会继续移动 | 否 |
| `latest` | 浮动标签 | 否 |
| `2.27.0-beta.*` | 预览版本 | 否 |
| `halohub/halo-pro` | 付费版镜像，需要许可证才能用其中的付费功能 | 否 |

数据库使用官方 Compose 示例中的 PostgreSQL **`15.4`**。`15` 和 `latest` 会移动，不写入本文命令。

完整标签见[标签列表](https://xuanyuan.cloud/r/halohub/halo/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/halohub/halo:2.26.1
docker pull docker.xuanyuan.run/library/postgres:15.4
```

Ubuntu 24.04 实测：

```text
Digest: sha256:bfe89bf70c44ea94a7dd33f8ec98e8e59088adfb7a9fb7b6f013f82391c33bee
Status: Downloaded newer image for docker.xuanyuan.run/halohub/halo:2.26.1
docker.xuanyuan.run/halohub/halo:2.26.1
```

```text
Digest: sha256:d1168ad5397bf9c94cc417c530469805a8767ed585481d93f174461ac8557e3a
Status: Downloaded newer image for docker.xuanyuan.run/library/postgres:15.4
docker.xuanyuan.run/library/postgres:15.4
```

两条都完成后，再写下面的 Compose。

## Docker Compose 部署

Halo 的工作目录在容器内 `/root/.halo2`，对应宿主机 `halo2/`。这里有主题、插件、附件、日志和备份。PostgreSQL 的数据在宿主机 `db/`，对应容器内 `/var/lib/postgresql/data`。

删除容器不会删除这两个目录。删掉 `halo2/` 或 `db/` 会丢掉站点数据。数据库口令写在 `db_password.txt`。站点管理员没有预置口令，在初始化页面另设。

从别的电脑访问时，把下面命令里的 `EXTERNAL_URL` 改成 `http://你的服务器IP:8090/`，末尾保留斜杠。只用服务器本机浏览器时保持 `http://127.0.0.1:8090/`。已经有域名时写成 `https://你的域名/`。这一项要在第一次打开初始化页之前定下来。`halo2/` 或 `db/` 里已经有数据时，不要重新执行写入 `compose.yaml` 的那一步，否则新口令和已初始化的数据库对不上。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/halo/halo2 /www/wwwroot/halo/db
sudo chown -R "$USER":"$USER" /www/wwwroot/halo
```

2. 生成数据库口令并写入 `compose.yaml`。`umask 077` 让 `db_password.txt` 和 `compose.yaml` 只有当前用户可读；写完后把 umask 调回 `022`。`8090:8090` 表示宿主机 8090 对应容器内 8090。PostgreSQL 不映射到宿主机。

```bash
cd /www/wwwroot/halo
EXTERNAL_URL="http://127.0.0.1:8090/"
DB_PASSWORD="$(openssl rand -hex 24)"
umask 077
printf '%s
' "$DB_PASSWORD" > db_password.txt
cat > compose.yaml <<EOF
name: halo

services:
  halo:
    image: docker.xuanyuan.run/halohub/halo:2.26.1
    container_name: halo
    restart: on-failure:3
    depends_on:
      halodb:
        condition: service_healthy
    networks:
      - halo_network
    volumes:
      - ./halo2:/root/.halo2
    ports:
      - "8090:8090"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8090/actuator/health/readiness"]
      interval: 30s
      timeout: 5s
      retries: 5
      start_period: 30s
    environment:
      - JVM_OPTS=-Xmx256m -Xms256m
    command:
      - --spring.r2dbc.url=r2dbc:pool:postgresql://halodb/halo
      - --spring.r2dbc.username=halo
      - --spring.r2dbc.password=${DB_PASSWORD}
      - --spring.sql.init.platform=postgresql
      - --halo.external-url=${EXTERNAL_URL}

  halodb:
    image: docker.xuanyuan.run/library/postgres:15.4
    container_name: halo-db
    restart: on-failure:3
    networks:
      - halo_network
    volumes:
      - ./db:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD", "pg_isready"]
      interval: 10s
      timeout: 5s
      retries: 5
    environment:
      - POSTGRES_PASSWORD=${DB_PASSWORD}
      - POSTGRES_USER=halo
      - POSTGRES_DB=halo
      - PGUSER=halo

networks:
  halo_network:
EOF
unset DB_PASSWORD
umask 022
```

| 配置 | 说明 |
|------|------|
| `8090:8090` | 宿主机 **8090** → 容器 **8090** |
| `./db` | PostgreSQL 数据文件。不映射 `5432` |
| `halodb` | Compose 网络里的数据库主机名，连接地址写的就是它 |
| `POSTGRES_USER` / 库名 | 都是 `halo`。口令在 `db_password.txt`，Halo 和 PostgreSQL 用同一串 |
| `JVM_OPTS` | 堆内存 256 MB，与官方示例一致 |
| `on-failure:3` | 进程异常退出时最多重启 3 次 |

3. 启动，并查看状态。`halo-db` 变为 healthy 之后，Halo 才会启动。Halo 的健康检查通过前，状态可能仍是 starting。

```bash
cd /www/wwwroot/halo
docker compose up -d
docker compose ps
```

Ubuntu 24.04 上这次启动，数据库先变为 healthy，Halo 随后启动：

```text
[+] up 3/3
 ✔ Network halo_halo_network Created  0.2s
 ✔ Container halo-db         Healthy  13.4s
 ✔ Container halo            Started  13.2s
```

启动后十几秒再看，`halo-db` 已经是 healthy，`halo` 仍是 `health: starting`。这时 8090 还没有开始监听。

```text
NAME      IMAGE                                       COMMAND                  SERVICE   CREATED          STATUS                            PORTS
halo      docker.xuanyuan.run/halohub/halo:2.26.1     "sh -c 'exec java ${…"   halo      19 seconds ago   Up 6 seconds (health: starting)   0.0.0.0:8090->8090/tcp, [::]:8090->8090/tcp
halo-db   docker.xuanyuan.run/library/postgres:15.4   "docker-entrypoint.s…"   halodb    21 seconds ago   Up 18 seconds (healthy)           5432/tcp
```

4. 看 Halo 是否已经跑起来：

```bash
docker compose logs --tail 80 halo
```

进程起来后，日志里有版本号。这次是 `Version: 2.26.1`，Java `21.0.12`：

```text
halo  |     __  __      __
halo  |    / / / /___ _/ /___
halo  |   / /_/ / __ `/ / __ 
halo  |  / __  / /_/ / / /_/ /
halo  | /_/ /_/\__,_/_/\____/
halo  |
halo  | Version: 2.26.1
halo  | 2026-10-11T13:45:29.130+08:00  INFO 1 --- [           main] run.halo.app.Application                 : Starting Application v2.26.1 using Java 21.0.12 with PID 1 (/application/application.jar started by root in /application)
```

看到 `Version: 2.26.1` 只说明进程已启动。后面还会加载插件。这次约 2 分钟后，日志仍在启动 `PluginSearchWidget`、`PluginSitemap` 等插件。

5. `halo` 仍是 `health: starting` 时，先不要打开浏览器。要确认端口，探测官方健康检查用的地址：

```bash
docker exec halo curl -fsS http://127.0.0.1:8090/actuator/health/readiness
```

这次在 starting 时执行，8090 还没监听：

```text
curl: (7) Failed to connect to 127.0.0.1 port 8090 after 0 ms: Could not connect to server
```

这不是账号错误。等到 `docker compose ps` 里 `halo` 变为 healthy，再打开浏览器。后面登录页能打开，说明那时 8090 已经在听。

## 初始化站点

8090 若能从公网直接访问，先完成初始化。镜像没有预置管理员口令。谁先提交这一页，谁就是博客管理员。

浏览器打开：

```text
http://你的服务器IP:8090/console
```

在服务器本机上打开时用 `http://127.0.0.1:8090/console`。

1. 填写「系统初始化」。语言选「简体中文」。「外部访问地址」要和 `EXTERNAL_URL` 一致，这次是 `http://127.0.0.1:8090/`。站点标题、用户名、电子邮箱、密码和确认密码都在这一页。这次站点标题是「轩辕镜像技术博客」，用户名是 `xuanyuan`。以后登录填这个用户名。密码另行保存，不要拿 `db_password.txt` 里的数据库口令来填。

![Halo 系统初始化：语言为简体中文，外部访问地址为 127.0.0.1:8090，站点标题为轩辕镜像技术博客，用户名为 xuanyuan，按钮为初始化](https://imgs.xuanyuan.cloud/docker/blog/halo/halo-1.webp)

2. 点「初始化」。

从 2.25.0 起，初始化还会生成「用户协议」和「隐私政策」两个页面，里面是占位文字。要开放注册时，先把这两页换成你自己的文本。

## 登录并发布文章

再次打开 Console 时，登录页的输入框写着「账号」。填用户名 `xuanyuan` 和初始化时的密码。填电子邮箱时，页面红字是「无效的凭证。」邮箱还没在个人中心验证，不能当作登录名。

![Halo 登录页：账号框填的是电子邮箱 hi@sourcecodedance.com](https://imgs.xuanyuan.cloud/docker/blog/halo/halo-2.webp)

![Halo 登录失败：红字为无效的凭证，账号仍是电子邮箱](https://imgs.xuanyuan.cloud/docker/blog/halo/halo-3.webp)

改填 `xuanyuan` 后进入「仪表盘」。左下角显示名称是 `Administrator`，角色是超级管理员。这是显示名称，不是登录名，登录仍用 `xuanyuan`。这时文章数是 1，用户数是 1。那 1 篇文章是新站点自带的「Hello Halo」。用户数只计管理员；后面查库还能看到系统自带的 `ghost` 和 `anonymousUser`，仪表盘不把它们算进这个 1。

![Halo 仪表盘：文章 1、用户 1，左下角显示名称为 Administrator、角色为超级管理员](https://imgs.xuanyuan.cloud/docker/blog/halo/halo-4.webp)

1. 左侧打开「文章」，点右上角「新建」。标题写成「测试博客文章发布」，正文写「测试博客文章发布」和「这是我的第一篇博客」。回到列表时，它还是未发布，「Hello Halo」是已发布。

![Halo 文章列表：Hello Halo 已发布，测试博客文章发布为未发布，右上角为新建](https://imgs.xuanyuan.cloud/docker/blog/halo/halo-5.webp)

2. 打开「测试博客文章发布」，右上角点「发布」。

![Halo 文章编辑器：标题为测试博客文章发布，正文两段，右上角为发布](https://imgs.xuanyuan.cloud/docker/blog/halo/halo-6.webp)

3. 列表顶部出现「发布成功」，这篇文章变为已发布。

![Halo 文章列表：顶部提示发布成功，测试博客文章发布的状态为已发布](https://imgs.xuanyuan.cloud/docker/blog/halo/halo-7.webp)

4. 打开站点根路径 `http://你的服务器IP:8090/`。这次页眉和横幅都是「轩辕镜像技术博客」，下面有刚发布的文章，也有「Hello Halo」。

![Halo 博客前台：页眉与横幅为轩辕镜像技术博客，文章为测试博客文章发布和 Hello Halo](https://imgs.xuanyuan.cloud/docker/blog/halo/halo-8.webp)

## 备份

升级或修改访问地址之前，先在 Console 左侧打开「备份」，点右上角「创建备份」。创建之后备份在后台进行，隔一会儿再看结果。文件在宿主机 `/www/wwwroot/halo/halo2/backups`。

官方说明：恢复可以换部署方式和数据库类型；恢复过程中不要刷新页面；冲突的数据会被覆盖；结束后页面会提示重启 Halo。

步骤见[备份与恢复](https://docs.halo.run/guide/use/backup)。

## 使用域名访问

需要域名时，先做好解析和反向代理，再启动并做初始化。把 `EXTERNAL_URL` 写成 `https://你的域名/`。域名或子域名都要指到站点根路径。官方说明不能挂到 `https://example.com/blog` 这种子目录。

下面是官方文档中的 Nginx 示例。把 `www.yourdomain.com` 换成你的域名。`client_max_body_size` 影响上传大小。

```nginx
upstream halo {
  server 127.0.0.1:8090;
}
server {
  listen 80;
  listen [::]:80;
  server_name www.yourdomain.com;
  client_max_body_size 1024m;
  location / {
    proxy_pass http://halo;
    proxy_set_header HOST $host;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
}
```

更多反向代理见[使用 Docker Compose 部署](https://docs.halo.run/getting-started/install/docker-compose)。

## 备选：docker run

上面的 Compose 已经在跑博客时，停在那里即可，不必再做这一节。

没有 Compose、只想短期打开看看时，用一条 `docker run`。它使用镜像自带的 H2 数据库。官方说明这只适合体验和测试，长期写博客用上面的 PostgreSQL。操作不当可能损坏 H2 的数据文件。

8090 上已经有 Compose 里的 `halo` 容器时，先停掉它，否则这条命令起不来。H2 的数据目录用 `/www/wwwroot/halo-h2`，不要挂上面的 `halo2/`。`docker compose down` 只停容器，不删除 `halo2/` 和 `db/`。

```bash
cd /www/wwwroot/halo
docker compose down
```

```bash
sudo mkdir -p /www/wwwroot/halo-h2
sudo chown -R "$USER":"$USER" /www/wwwroot/halo-h2
docker run -d 
  --name halo 
  --restart on-failure:3 
  -p 8090:8090 
  -v /www/wwwroot/halo-h2:/root/.halo2 
  -e JVM_OPTS="-Xmx256m -Xms256m" 
  docker.xuanyuan.run/halohub/halo:2.26.1 
  --halo.external-url=http://127.0.0.1:8090/
```

从别的电脑访问时，把 `--halo.external-url` 改成 `http://你的服务器IP:8090/`，末尾保留斜杠。这一项同样要在初始化之前定下来。

然后看日志，并探测就绪地址：

```bash
docker logs --tail 80 halo
docker exec halo curl -fsS http://127.0.0.1:8090/actuator/health/readiness
```

不再出现 `Failed to connect` 后，浏览器打开 `http://你的服务器IP:8090/console`，按「初始化站点」填写。

试用结束、要回到 Compose 里的博客时，停掉这个 H2 容器再启动原来的 Compose。不要重新生成数据库口令。

```bash
docker stop halo && docker rm halo
cd /www/wwwroot/halo
docker compose up -d
```

## 常见问题

**Q1：8090 端口被占用怎么办？**

把宿主机端口改成别的，容器内仍是 8090。例如改成 18090 时，Compose 里写成 `"18090:8090"`，并把 `EXTERNAL_URL` 里的端口改成 18090，再执行 `docker compose up -d`。浏览器访问 `http://服务器IP:18090/console`。

用 `docker run` 启动时，把 `-p 8090:8090` 和 `--halo.external-url` 里的端口一起改。

**Q2：数据存在哪里？**

Compose 部署时有两处：

- `/www/wwwroot/halo/halo2` 对应容器内 `/root/.halo2`，里面有主题、插件、附件、日志和 `backups`
- `/www/wwwroot/halo/db` 对应 PostgreSQL 的数据文件

容器内路径是 `/root/.halo2`。挂到 `/root/.halo` 或 `/root/.halo/data` 时，2.x 不会把数据写进你打算保留的那个目录。升级时不要删除 `halo2/` 和 `db/`。

**Q3：登录显示「无效的凭证」怎么办？**

地址里带 `error=invalid-credential&method=local`，页面红字是「无效的凭证。」时，登录名或密码没有对上。本地登录先查已验证邮箱，再查用户名。初始化填写的邮箱默认未验证，填邮箱会得到这个红字。仪表盘左下角的 `Administrator` 是显示名称，也不能拿来登录。

改填初始化时的用户名，密码仍用那一页设置的密码。不要填 `db_password.txt`。

忘记用户名时再查库。这条命令列出用户名、邮箱和是否已验证，不输出密码：

```bash
docker exec halo-db psql -U halo -d halo -c "SELECT name, convert_from(data, 'UTF-8')::jsonb #>> '{spec,email}' AS email, convert_from(data, 'UTF-8')::jsonb #>> '{spec,emailVerified}' AS email_verified FROM extensions WHERE name LIKE '/registry/users/%';"
```

Ubuntu 24.04 上这次查询的结果是：

```text
             name              |         email          | email_verified 
-------------------------------+------------------------+----------------
 /registry/users/ghost         | ghost@example.com      | false
 /registry/users/anonymousUser | anonymous@example.com  | false
 /registry/users/xuanyuan      | hi@sourcecodedance.com | false
(3 rows)
```

`ghost` 和 `anonymousUser` 是系统自带用户。这次的管理员是 `xuanyuan`，邮箱未验证。登录名是路径最后一段 `xuanyuan`。

**Q4：管理员和数据库口令在哪里？**

管理员用户名和密码在初始化那一页，没有预置值。数据库口令在 `/www/wwwroot/halo/db_password.txt`，库用户和库名都是 `halo`。PostgreSQL 不映射到宿主机。

**Q5：外部访问地址填错了会怎样？**

文章和附件里的绝对地址会指向当时填的外部访问地址。这次填的是 `http://127.0.0.1:8090/`，从局域网另一台机器仍能打开登录页和前台。页面打不开时看端口和健康检查；已经出现「无效的凭证。」时，改用户名，不必先改这个地址。

初始化之前，让 `EXTERNAL_URL`、初始化页上的「外部访问地址」和浏览器实际打开的地址一致。已经初始化后要改，先做备份，再改 `compose.yaml` 里的 `--halo.external-url`，然后执行 `docker compose up -d`。

**Q6：如何升级？**

先在 Console 里创建备份，并保留 `halo2/` 与 `db/`。本文命令使用 `2.26.1`，没有在这里执行升级。要升到更新的具体版本时，把 `compose.yaml` 里的 Halo 标签改成那个版本号，然后执行：

```bash
cd /www/wwwroot/halo
docker compose pull
docker compose up -d
```

不要把标签改成 `2.26`、`2` 或 `latest`。数据库目录保持不动。

**Q7：容器起来了，浏览器打不开？**

按这个顺序看：

1. `docker compose ps` 里 `halo-db` 是否为 healthy，`halo` 是否为 healthy。`health: starting` 时 8090 可能还没监听。
2. `docker compose logs --tail 80 halo` 里是否已有 `Version: 2.26.1`，以及后面的插件是否还在启动。
3. 在服务器上执行 `docker exec halo curl -fsS http://127.0.0.1:8090/actuator/health/readiness`。若是 `Failed to connect to 127.0.0.1 port 8090`，先等 healthy 再测，这不是登录失败。
4. 本机通、外网不通时，再检查云服务器安全组和本机防火墙是否放行了你映射的端口。

**Q8：如何停止与卸载？**

确认不再需要这个站点之前，不要删除数据目录。

Compose 停止并保留 `halo2/` 和 `db/`：

```bash
cd /www/wwwroot/halo
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop halo && docker rm halo
```

站点不再需要时，再删除数据目录：

```bash
rm -rf /www/wwwroot/halo/halo2 /www/wwwroot/halo/db /www/wwwroot/halo-h2
```

**Q9：可以改用 H2 或 MySQL 吗？**

「备选：docker run」使用 H2，只适合体验。生产环境用本文的 PostgreSQL。官方 Compose 文档另有 MySQL 和外部数据库的写法，见[使用 Docker Compose 部署](https://docs.halo.run/getting-started/install/docker-compose)。本文没有部署 MySQL。

**Q10：能挂到网站的子目录吗？**

不能。站点要放在域名或子域名的根路径上，写法见「使用域名访问」。

**Q11：和专业版是什么关系？**

本文镜像是社区版 `halohub/halo`。专业版和商城版使用 `halohub/halo-pro`，其中部分功能要许可证。社区版没有这一步。自动备份插件官方写明属于付费版；社区版在 Console 里手动点「创建备份」。

**Q12：忘记管理员密码怎么办？**

登录页上的「忘记密码」要先配好邮件通知，并且邮箱已验证。这次邮箱未验证，用不上。用户名不确定时，用「登录显示『无效的凭证』怎么办？」里的查询。初始化时把用户名和密码另行保存。8090 若能从公网访问，初始化完成前不要长时间敞开。

**Q13：和 Docker Hub 上的镜像是什么关系？**

本文使用的 `halohub/halo:2.26.1` 与 Docker Hub 上的同名标签是同一份镜像，通过轩辕镜像加速拉取。工作目录和数据库参数见[官方 Docker Compose 文档](https://docs.halo.run/getting-started/install/docker-compose)。

## 命令速查

```bash
docker pull docker.xuanyuan.run/halohub/halo:2.26.1
docker pull docker.xuanyuan.run/library/postgres:15.4

cd /www/wwwroot/halo
docker compose up -d
docker compose ps
docker compose logs --tail 80 halo
docker exec halo curl -fsS http://127.0.0.1:8090/actuator/health/readiness

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://服务器IP:8090/console`，用初始化时的用户名登录。数据库口令在 `db_password.txt`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [halohub/halo 镜像页](https://xuanyuan.cloud/zh/r/halohub/halo) | [https://xuanyuan.cloud/zh/r/halohub/halo](https://xuanyuan.cloud/zh/r/halohub/halo) |
| [halohub/halo 概览](https://xuanyuan.cloud/r/halohub/halo) | [https://xuanyuan.cloud/r/halohub/halo](https://xuanyuan.cloud/r/halohub/halo) |
| [halohub/halo 标签列表](https://xuanyuan.cloud/r/halohub/halo/tags) | [https://xuanyuan.cloud/r/halohub/halo/tags](https://xuanyuan.cloud/r/halohub/halo/tags) |
| [library/postgres 镜像页](https://xuanyuan.cloud/r/library/postgres) | [https://xuanyuan.cloud/r/library/postgres](https://xuanyuan.cloud/r/library/postgres) |
| [Docker Hub · halohub/halo](https://hub.docker.com/r/halohub/halo) | [https://hub.docker.com/r/halohub/halo](https://hub.docker.com/r/halohub/halo) |
| [Docker Hub · postgres](https://hub.docker.com/_/postgres) | [https://hub.docker.com/_/postgres](https://hub.docker.com/_/postgres) |
| [GitHub · halo-dev/halo](https://github.com/halo-dev/halo) | [https://github.com/halo-dev/halo](https://github.com/halo-dev/halo) |
| [Release v2.26.1](https://github.com/halo-dev/halo/releases/tag/v2.26.1) | [https://github.com/halo-dev/halo/releases/tag/v2.26.1](https://github.com/halo-dev/halo/releases/tag/v2.26.1) |
| [Halo 官网](https://www.halo.run/) | [https://www.halo.run/](https://www.halo.run/) |
| [写在前面](https://docs.halo.run/getting-started/prepare) | [https://docs.halo.run/getting-started/prepare](https://docs.halo.run/getting-started/prepare) |
| [使用 Docker Compose 部署](https://docs.halo.run/getting-started/install/docker-compose) | [https://docs.halo.run/getting-started/install/docker-compose](https://docs.halo.run/getting-started/install/docker-compose) |
| [使用 Docker 部署](https://docs.halo.run/getting-started/install/docker) | [https://docs.halo.run/getting-started/install/docker](https://docs.halo.run/getting-started/install/docker) |
| [初始化](https://docs.halo.run/guide/setup) | [https://docs.halo.run/guide/setup](https://docs.halo.run/guide/setup) |
| [备份与恢复](https://docs.halo.run/guide/use/backup) | [https://docs.halo.run/guide/use/backup](https://docs.halo.run/guide/use/backup) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/halo-docker-deploy


