# Docker 部署 Wiki.js：轻松搭建私有化维基知识库

![Docker 部署 Wiki.js：轻松搭建私有化维基知识库](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs.webp)

*分类: Docker部署教程 | 标签: Wiki.js,requarks/wiki,Docker,轩辕镜像,维基,知识库,私有化部署,部署教程 | 发布时间: 2026-10-12 23:07:48*

> Wiki.js 是一款面向团队与个人的开源维基，旨在把文档留在自己的服务器上，并通过页面、目录和权限组织知识库。本文将介绍如何通过 Docker Compose 快速部署 Wiki.js，搭建私有化维基，帮助你在浏览器里编写和查阅文档，适合团队知识库及项目文档等场景。

*本文基于 [requarks/wiki:2.5.316](https://xuanyuan.cloud/zh/r/requarks/wiki)，以 **2.5.316** 版本实测，数据库 PostgreSQL **15.19**，测试平台 **Ubuntu 24.04** Linux。*

## Wiki.js 是什么

Wiki.js 是 Requarks 做的开源维基，用 Node.js 写成。页面留在你自己的服务器上，在浏览器里编写和阅读。

和把文档放在托管平台相比，账号和页面在这台机器的数据库里。编辑器用 Markdown，也可以换成可视化编辑器。

## Wiki.js 能做什么

- **编写页面**：写下标题和正文，保存后可以打开。
- **按路径存放**：每一页有路径，也可以加标签。
- **站内搜索**：在已有页面里查找标题和正文。
- **控制权限**：用本地账号和分组决定谁能看、谁能改。
- **发表评论**：页面下方可以直接留言。

## 为什么要使用 Wiki.js

只留一份内部手册时，不必从零做登录和编辑器。Wiki.js 在浏览器里完成安装，页面放在 PostgreSQL 里。

适合团队手册和项目文档。

## 使用 Docker 部署 Wiki.js

Wiki.js 可以用 Docker 跑起来，宿主机不必安装 Node.js。开始之前准备好 Docker，并定好浏览器里要打开的地址。

下面用 Docker Compose 配好数据库，启动服务，然后在浏览器里完成安装、登录，并新建一页。

## 环境要求

本文使用 **2.5.316** 版本实测，测试平台 **Ubuntu 24.04**。官方建议跑 Wiki.js 的 Linux 至少 1 GB 内存，CPU 两核更合适。镜像里已经带 Node.js，宿主机不必再装。数据库是 PostgreSQL **15.19**，和 Wiki.js 跑在同一台机器上。这次日志里的架构是 `x86_64-pc-linux-musl`。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（本文 **Ubuntu 24.04**）；macOS 把 `/www/wwwroot/wikijs` 换成 `~/docker/wikijs` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64** 或 **linux/arm64**。ARMv7 自 2.5.304 起不再提供 |
| 内存 | Wiki.js 至少 1 GB。PostgreSQL 在同一台机器上时再留出余量 |
| 磁盘 | 官方建议至少 1 GB。图片和附件多时按实际容量另留 |
| 端口 | 宿主机 **13300** → 容器 **3000**。PostgreSQL 只在 Compose 网络内，不映射到宿主机 |
| 工作目录 | `/www/wwwroot/wikijs` |
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

[GitHub Release v2.5.316](https://github.com/requarks/wiki-v2/releases/tag/v2.5.316) 发布于 2026-10-02。官方发行说明把 **2.5.316** 标为稳定版，3.0 仍是测试版。Docker Hub 上 `requarks/wiki:2.5.316` 已发布，架构为 amd64 与 arm64。

官方 Docker 文档建议用大版本标签 `2`，或次版本标签 `2.5`。这两个标签都会跟着后续版本移动。下面的命令使用具体版本 **`2.5.316`**。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`2.5.316`** | 稳定版 2.5.316，对应 Release v2.5.316 | **是** |
| `2.5` | 2.5 线的滚动标签，会继续移动 | 否 |
| `2` | Wiki.js 2 的滚动标签，官方 Docker 示例使用它 | 否 |
| `latest` | 浮动标签 | 否 |
| `3.0.0-beta` | 3.0 测试版，官方写明还不建议用于生产 | 否 |
| `2.5.303` | 最后一个仍提供 ARMv7 的版本 | 否 |

数据库使用 PostgreSQL 15 的具体标签 **`15.19-alpine`**。官方 Compose 示例写的是 `postgres:15-alpine`，这个标签会跟着 15 线的后续补丁移动，不写入本文命令。

完整标签见[标签列表](https://xuanyuan.cloud/r/requarks/wiki/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/requarks/wiki:2.5.316
docker pull docker.xuanyuan.run/library/postgres:15.19-alpine
```

两条都完成后，再写下面的 Compose。

Ubuntu 24.04 实测：

```text
Digest: sha256:fffff288a52f76e5b8c19a4fbcd0f3e538e96edea642c4f2d813d54d59a876de
Status: Downloaded newer image for docker.xuanyuan.run/requarks/wiki:2.5.316
docker.xuanyuan.run/requarks/wiki:2.5.316
```

```text
Digest: sha256:f7d23353e1b15400d22ebe31189f4d314b87a4c129cc400c8c2d8d4ca127bf81
Status: Downloaded newer image for docker.xuanyuan.run/library/postgres:15.19-alpine
docker.xuanyuan.run/library/postgres:15.19-alpine
```

## Docker Compose 部署

页面和附件保存在 PostgreSQL 里。宿主机目录 `db/` 对应容器内 `/var/lib/postgresql/data`。`/wiki/data/content` 是镜像里的缓存目录，这次不挂到宿主机。

删除容器不会删除 `db/`。删掉 `db/` 会丢掉页面和附件。数据库口令写在 `db_password.txt` 和 `compose.yaml` 里。站点管理员没有预置邮箱和口令，在安装页另设。

`db/` 里已经有数据时，不要重新执行写入 `compose.yaml` 的那一步，否则新口令和已初始化的数据库对不上。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/wikijs/db
sudo chown -R "$USER":"$USER" /www/wwwroot/wikijs
```

2. 生成数据库口令并写入 `compose.yaml`。`umask 077` 让 `db_password.txt` 和 `compose.yaml` 只有当前用户可读；写完后把 umask 调回 `022`。容器内监听 3000。宿主机映到 13300，避开本机常见的前端端口。PostgreSQL 不映射到宿主机。`DB_HOST` 写数据库容器名 `wikijs-db`。

```bash
cd /www/wwwroot/wikijs
DB_PASSWORD="$(openssl rand -hex 24)"
umask 077
printf '%s
' "$DB_PASSWORD" > db_password.txt
cat > compose.yaml <<EOF
name: wikijs

services:
  wiki:
    image: docker.xuanyuan.run/requarks/wiki:2.5.316
    container_name: wikijs
    restart: unless-stopped
    init: true
    depends_on:
      db:
        condition: service_healthy
    environment:
      DB_TYPE: postgres
      DB_HOST: wikijs-db
      DB_PORT: 5432
      DB_USER: wikijs
      DB_PASS: ${DB_PASSWORD}
      DB_NAME: wiki
    ports:
      - "13300:3000"

  db:
    image: docker.xuanyuan.run/library/postgres:15.19-alpine
    container_name: wikijs-db
    restart: unless-stopped
    volumes:
      - ./db:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U wikijs -d wiki"]
      interval: 10s
      timeout: 5s
      retries: 5
    environment:
      POSTGRES_DB: wiki
      POSTGRES_USER: wikijs
      POSTGRES_PASSWORD: ${DB_PASSWORD}
EOF
unset DB_PASSWORD
umask 022
```

| 配置 | 说明 |
|------|------|
| `13300:3000` | 宿主机 **13300** → 容器 **3000** |
| `./db` | PostgreSQL 数据文件。不映射 `5432` |
| `wikijs-db` | 数据库容器名。`DB_HOST` 写的就是它 |
| `POSTGRES_USER` / 库名 | 用户 `wikijs`，库名 `wiki`。口令在 `db_password.txt`，两边用同一串 |
| `init: true` | 给 Wiki.js 加一个 init 进程 |
| `unless-stopped` | 除非手动停掉，否则退出后会再启动 |

3. 启动，并查看状态。`wikijs-db` 变为 healthy 之后，Wiki.js 才会启动。

```bash
cd /www/wwwroot/wikijs
docker compose up -d
docker compose ps
```

Ubuntu 24.04 上这次启动，数据库是 Healthy，Wiki.js 是 Started。进度里的秒数是各自动作的耗时：

```text
[+] up 3/3
 ✔ Network wikijs_default Created  0.4s
 ✔ Container wikijs-db    Healthy  15.0s
 ✔ Container wikijs       Started  14.8s
```

```text
NAME        IMAGE                                               COMMAND                  SERVICE   CREATED          STATUS                    PORTS
wikijs      docker.xuanyuan.run/requarks/wiki:2.5.316           "docker-entrypoint.s…"   wiki      27 seconds ago   Up 13 seconds             3443/tcp, 0.0.0.0:13300->3000/tcp, [::]:13300->3000/tcp
wikijs-db   docker.xuanyuan.run/library/postgres:15.19-alpine   "docker-entrypoint.s…"   db        29 seconds ago   Up 25 seconds (healthy)   5432/tcp
```

`ps` 里数据库已经是 healthy。Compose 没有给 `wikijs` 配健康检查，所以它的状态是 Up。`3443/tcp` 是镜像暴露的 HTTPS 端口，没有映射出来。浏览器走 `13300->3000`。

4. 看两边是否已经跑起来：

```bash
docker compose logs --tail 80 db
docker compose logs --tail 80 wiki
```

数据库初始化中途有两行：

```text
wikijs-db  | sh: locale: not found
wikijs-db  | 2026-10-12 14:25:47.584 UTC [36] WARNING:  no usable system locales were found
```

同一段日志里还有 `enabling "trust" authentication for local connections`。本地连接被设成 trust，后面在容器里执行 `pg_dump` 不用再输入口令。

入口脚本初始化时会先拉起一次再停下，接着才正式监听。看到下面这一行，再看 Wiki.js：

```text
wikijs-db  | 2026-10-12 14:25:51.830 UTC [1] LOG:  starting PostgreSQL 15.19 on x86_64-pc-linux-musl, compiled by gcc (Alpine 15.2.0) 15.2.0, 64-bit
wikijs-db  | 2026-10-12 14:25:52.087 UTC [1] LOG:  database system is ready to accept connections
```

这次 Wiki.js 连上了数据库。日志里有 `= Wiki.js 2.5.316`，其中有这几行：

```text
wikijs  | 2026-10-12T14:26:03.628Z [MASTER] info: Database Connection Successful [ OK ]
wikijs  | 2026-10-12T14:26:07.142Z [MASTER] warn: DB Configuration is empty or incomplete. Switching to Setup mode...
wikijs  | 2026-10-12T14:26:07.142Z [MASTER] info: Starting setup wizard...
wikijs  | 2026-10-12T14:26:07.404Z [MASTER] info: Starting HTTP server on port 3000...
wikijs  | 2026-10-12T14:26:07.404Z [MASTER] info: HTTP Server on port: [ 3000 ]
wikijs  | 2026-10-12T14:26:07.432Z [MASTER] info: HTTP Server: [ RUNNING ]
wikijs  | 2026-10-12T14:26:07.433Z [MASTER] info: Browse to http://YOUR-SERVER-IP:3000/ to complete setup!
```

`Database Connection Successful` 表示数据库口令已经对上。下一行 `Switching to Setup mode` 表示还没提交安装页，所以进入安装向导。日志里的 `3000` 是容器内端口。浏览器打开宿主机的 **13300**。

5. 在服务器上确认 13300 已经有响应：

```bash
curl -I http://127.0.0.1:13300
```

这次返回：

```text
HTTP/1.1 200 OK
X-Powered-By: Express
Content-Type: text/html; charset=utf-8
```

`200 OK` 之后再打开浏览器。连接被拒绝时，先看 `docker compose ps` 和上一步的日志，不要先改安装页。

## 初始化站点

镜像没有预置管理员邮箱和口令。谁先提交安装页，谁就是站点管理员。13300 若能从公网直接访问，先完成安装。

浏览器打开：

```text
http://你的服务器IP:13300
```

在服务器本机上打开时用 `http://127.0.0.1:13300`。这次从局域网另一台机器打开，地址是 `http://192.168.1.35:13300`。

1. 填写管理员邮箱和密码。密码至少 8 位。站点地址写浏览器实际打开的 URL，输入框下方写着末尾不要斜杠。这次邮箱是 `hi@sourcecodedance.com`，Site URL 是 `http://192.168.1.35:13300`。页顶写着「You are about to install Wiki.js 2.5.316.」。「Allow Telemetry」这次是开着的，要关就在点「INSTALL」之前关掉。密码另行保存，不要填 `db_password.txt` 里的数据库口令。

![Wiki.js 安装页：版本 2.5.316，管理员邮箱 hi@sourcecodedance.com，Site URL 为 192.168.1.35:13300，按钮为 INSTALL](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-1.webp)

2. 点「INSTALL」。页面先显示「Finalizing your installation...」，随后是「Installation complete!」和「Redirecting...」。

![Wiki.js 安装进行中：蓝色对话框为 Finalizing your installation](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-2.webp)

![Wiki.js 安装完成：对话框为 Installation complete，正在 Redirecting](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-3.webp)

3. 跳到登录页后，用刚才的邮箱和密码点「Log In」。

![Wiki.js 登录页：邮箱为 hi@sourcecodedance.com，按钮为 Log In](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-4.webp)

## 把界面换成简体中文

登录后是英文欢迎页，文案是「Welcome to your wiki!」，按钮是「CREATE HOME PAGE」和「ADMINISTRATION」。

![Wiki.js 欢迎页：Welcome to your wiki，按钮为 CREATE HOME PAGE 和 ADMINISTRATION](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-5.webp)

「CREATE HOME PAGE」会先问用哪个编辑器。先改语言，再写页面。

![Wiki.js 编辑器选择：标题为 Which editor do you want to use for this page，选项含 Markdown 和 Visual Editor](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-6.webp)

1. 点「ADMINISTRATION」。仪表盘绿条是「Wiki.js 2.5.316」和「You are running the latest version.」。这是站点里的版本检查，镜像标签仍用 `2.5.316`。这时页面数是 0，用户数和用户组都是 2，最近登录是 Administrator。

![Wiki.js 管理区仪表盘：Wiki.js 2.5.316，页面 0、用户 2、用户组 2，最近登录为 Administrator](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-7.webp)

2. 左侧打开「Locale」。右上「Download Locale」里找到 `zh` / Chinese Simplified，点下载。

![Wiki.js 语言包：Site Locale 为 English，列表中有 Chinese Simplified](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-8.webp)

3. 「Multilingual Namespaces」保持关闭。打开后，路径会带上语言代码，页面上的例子是 `/en/page-name`。下载完成后，`zh` 这一行是绿色对勾，Availability 是 100%。再把「Site Locale」改成「Chinese Simplified」。

![Wiki.js 语言包：Site Locale 下拉选中 Chinese Simplified，zh 一行已是绿色对勾](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-9.webp)

4. 界面变成中文后，打开「常规」，核对「网站网址」。这次是 `http://192.168.1.35:13300`，下方写着「无需键入尾部斜杠」。

![Wiki.js 常规设置：网站网址为 http://192.168.1.35:13300，提示无需键入尾部斜杠](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-10.webp)

## 新建首页

回到站点首页。文案已经是「欢迎访问您的 wiki 站点！」，按钮是「创建首页」和「管理员页面」。

![Wiki.js 中文欢迎页：欢迎访问您的 wiki 站点，按钮为创建首页和管理员页面](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-11.webp)

1. 点「创建首页」。对话框标题是「您想使用哪个编辑器？」。这次选「Markdown」。

![Wiki.js 选择编辑器：标题为您想使用哪个编辑器，第一项为 Markdown](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-12.webp)

2. 打开「页面属性」。标题和简短说明都写成「轩辕镜像技术文档」。路径填 `home`，语言列是 `zh`。提示写着「不要包含任何前导或尾随斜杠」。标签加上「轩辕镜像」和「技术文档」，再点「OK」。

![Wiki.js 页面属性：标题为轩辕镜像技术文档，路径为 home，语言为 zh，标签为轩辕镜像和技术文档](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-13.webp)

3. 正文按下面写。右侧能看到预览。

```markdown
# 轩辕镜像的技术文档

这是轩辕镜像的第一篇技术文档
```

![Wiki.js Markdown 编辑器：左侧为标题和正文，右侧预览标题为轩辕镜像的技术文档](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-14.webp)

4. 右上角点「创建」。中间会显示「渲染中」。

![Wiki.js 创建页面：蓝色对话框为渲染中，请稍候](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-15.webp)

5. 创建完成后进入这一页。页眉是「轩辕镜像技术文档」，正文是刚才写的标题和段落，标签是「轩辕镜像」和「技术文档」。最后编辑显示 Administrator。

![Wiki.js 页面：标题轩辕镜像技术文档，正文为轩辕镜像的技术文档，标签为轩辕镜像和技术文档](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-16.webp)

6. 在「评论」里写「谢谢分享」，点「发表评论」。顶部绿条是「新评论已成功发布。」

![Wiki.js 评论已发布：绿条为新评论已成功发布，评论内容为谢谢分享，作者为 Administrator](https://imgs.xuanyuan.cloud/docker/blog/wikijs/wikijs-17.webp)

## 备份

升级或重装之前，先保留 `db/`，再导出数据库。容器里走本地连接，不用再输入口令：

```bash
docker exec wikijs-db pg_dump -U wikijs -d wiki > /www/wwwroot/wikijs/wiki.sql
```

导出文件在 `/www/wwwroot/wikijs/wiki.sql`。里面有页面内容，不要提交到公开仓库。

## 使用域名访问

需要域名时，先做好解析和反向代理，再打开安装页。安装页上的站点地址写成 `https://你的域名`，末尾不要斜杠。域名或子域名都要指到站点根路径。不能挂到 `https://example.com/wiki` 这种子目录。已经用 IP 装完的，到「常规」里改「网站网址」。

下面把请求转到本机 13300。把 `wiki.example.com` 换成你的域名。程序默认单文件上限是 5 MB（5242880 字节）。`client_max_body_size` 小于这个值时，上传会先被代理拒绝。

```nginx
server {
  listen 80;
  server_name wiki.example.com;
  client_max_body_size 10m;

  location / {
    proxy_pass http://127.0.0.1:13300;
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
  }
}
```

证书放在反向代理上。官方说明：前面已经有 Nginx 或 Apache 时，SSL 由代理终止，不要再让 Wiki.js 自己申请证书。

排障见 [Troubleshooting](https://docs.requarks.io/troubleshooting)。

## 备选：docker run

上面的 Compose 已经在跑维基时，停在那里即可，不必再做这一节。

没有 Compose、只想短期打开看看时，用两条 `docker run`。Wiki.js 镜像里没有数据库，需要单独起一个 PostgreSQL，并放在同一个网络里。13300 上已经有 Compose 里的 `wikijs` 容器时，先停掉它，否则这条命令起不来。数据目录用 `/www/wwwroot/wikijs-run`，不要挂上面的 `db/`。`docker compose down` 只停容器，不删除 `db/`。

```bash
cd /www/wwwroot/wikijs
docker compose down
```

```bash
docker network create wikijs-net
sudo mkdir -p /www/wwwroot/wikijs-run/db
sudo chown -R "$USER":"$USER" /www/wwwroot/wikijs-run
cd /www/wwwroot/wikijs-run
DB_PASSWORD="$(openssl rand -hex 24)"
umask 077
printf '%s
' "$DB_PASSWORD" > db_password.txt
umask 022
docker run -d 
  --name wikijs-db 
  --network wikijs-net 
  --restart unless-stopped 
  -v /www/wwwroot/wikijs-run/db:/var/lib/postgresql/data 
  -e POSTGRES_DB=wiki 
  -e POSTGRES_USER=wikijs 
  -e POSTGRES_PASSWORD="$DB_PASSWORD" 
  docker.xuanyuan.run/library/postgres:15.19-alpine
docker run -d 
  --name wikijs 
  --network wikijs-net 
  --restart unless-stopped 
  --init 
  -p 13300:3000 
  -e DB_TYPE=postgres 
  -e DB_HOST=wikijs-db 
  -e DB_PORT=5432 
  -e DB_USER=wikijs 
  -e DB_PASS="$DB_PASSWORD" 
  -e DB_NAME=wiki 
  docker.xuanyuan.run/requarks/wiki:2.5.316
unset DB_PASSWORD
```

网络已经存在时，`docker network create` 会提示已存在，继续执行后面的命令即可。

然后看日志，并探测页面：

```bash
docker logs --tail 80 wikijs-db
docker logs --tail 80 wikijs
curl -I http://127.0.0.1:13300
```

数据库日志出现 `database system is ready to accept connections`，并且 `curl` 返回 HTTP 响应后，浏览器打开 `http://你的服务器IP:13300`，按「初始化站点」填写。

试用结束、要回到 Compose 里的维基时，停掉这两个容器再启动原来的 Compose。不要重新生成数据库口令。

```bash
docker stop wikijs wikijs-db && docker rm wikijs wikijs-db
cd /www/wwwroot/wikijs
docker compose up -d
```

## 常见问题

**Q1：13300 端口被占用怎么办？**

把宿主机端口改成别的，容器内仍是 3000。例如改成 18080 时，Compose 里写成 `"18080:3000"`，安装页上的站点地址也改成这个端口，再执行 `docker compose up -d`。浏览器访问 `http://服务器IP:18080`。

用 `docker run` 启动时，把 `-p 13300:3000` 和安装页上的地址一起改。

**Q2：数据存在哪里？**

Compose 部署时，页面和附件在 `/www/wwwroot/wikijs/db`，对应 PostgreSQL 的数据文件。官方维护者说明附件以数据库中的 blob 保存。

`/wiki/data/content` 是镜像声明的卷，用来放缓存和临时文件。Compose 里没有挂这个目录，Docker 会给它一个匿名卷。`docker compose down` 不加 `-v` 时，这个匿名卷还在。升级时不要删除 `db/`。

**Q3：管理员和数据库口令在哪里？**

管理员邮箱和密码在安装那一页，没有预置值。登录用这个邮箱。数据库口令在 `/www/wwwroot/wikijs/db_password.txt`，库用户是 `wikijs`，库名是 `wiki`。PostgreSQL 不映射到宿主机。

**Q4：站点地址填错了会怎样？**

页面里的绝对地址会指向安装时填的 URL。安装之前，让安装页上的地址和浏览器实际打开的地址一致，末尾不要斜杠。这次填的是 `http://192.168.1.35:13300`，换语言之后在「常规」的「网站网址」里仍是这一串。已经安装后要改，先做备份，再改这个输入框。英文界面里这一页叫「General」。

**Q5：如何升级？**

先导出数据库，并保留 `db/`。本文命令使用 `2.5.316`。要升到更新的具体版本时，把 `compose.yaml` 里的 Wiki.js 标签改成那个版本号，然后执行：

```bash
cd /www/wwwroot/wikijs
docker compose pull
docker compose up -d
```

不要把标签改成 `2.5`、`2` 或 `latest`。数据库目录保持不动。3.0 仍是测试版，不要把生产站直接改成 `3.0.0-beta`。

**Q6：容器起来了，浏览器打不开？**

按这个顺序看：

1. `docker compose ps` 里 `wikijs-db` 是否为 healthy，`wikijs` 是否为 Up。
2. `docker compose logs --tail 80 db` 里是否已有 `database system is ready to accept connections`。
3. `docker compose logs --tail 80 wiki` 里是否还在报连不上数据库。`DB_HOST` 应是 `wikijs-db`。
4. 在服务器上执行 `curl -I http://127.0.0.1:13300`。这次是 `HTTP/1.1 200 OK`。若仍是连接被拒绝，先等容器起来。日志里的 3000 是容器端口，浏览器打开 13300。
5. 本机通、外网不通时，再检查云服务器安全组和本机防火墙是否放行了你映射的端口。

**Q7：如何停止与卸载？**

确认不再需要这个站点之前，不要删除数据目录。

Compose 停止并保留 `db/`：

```bash
cd /www/wwwroot/wikijs
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop wikijs wikijs-db && docker rm wikijs wikijs-db
```

站点不再需要时，再删除数据目录：

```bash
rm -rf /www/wwwroot/wikijs/db /www/wwwroot/wikijs-run
```

`wiki.sql` 里也有页面内容。确认不需要备份后再删。

**Q8：可以改用 MySQL 或 SQLite 吗？**

本文使用 PostgreSQL。MySQL、MariaDB、MS SQL Server 和 SQLite 在 2.x 可用。官方写明这些引擎不会进入 3.x，SQLite 不建议用于生产。换引擎的环境变量见[官方 Docker 文档](https://docs.requarks.io/install/docker)。

**Q9：能挂到网站的子目录吗？**

不能。站点要放在域名根路径上，写法见「使用域名访问」。

**Q10：和 3.0 是什么关系？**

3.0 仍是测试版，见「标签怎么选」。生产环境用 `2.5.316`。

**Q11：ARMv7 能跑这个标签吗？**

`2.5.316` 提供 amd64 和 arm64。官方说明自 2.5.304 起不再提供 ARMv7，最后一个仍带 ARMv7 的版本是 `2.5.303`。树莓派 4 及更新的 64 位系统用 arm64。

**Q12：数据库日志出现 `no usable system locales were found` 怎么办？**

这次初始化时有 `sh: locale: not found` 和 `WARNING: no usable system locales were found`。后面已经有 `database system is ready to accept connections`，Wiki.js 日志里是 `Database Connection Successful [ OK ]`，安装页也能打开。先看有没有这行就绪日志。

**Q13：和 Docker Hub 上的镜像是什么关系？**

本文使用的 `requarks/wiki:2.5.316` 与 Docker Hub 上的同名标签是同一份镜像，通过轩辕镜像加速拉取。数据库参数见[官方 Docker 文档](https://docs.requarks.io/install/docker)。

## 命令速查

```bash
docker pull docker.xuanyuan.run/requarks/wiki:2.5.316
docker pull docker.xuanyuan.run/library/postgres:15.19-alpine

cd /www/wwwroot/wikijs
docker compose up -d
docker compose ps
docker compose logs --tail 80 wiki
curl -I http://127.0.0.1:13300

docker exec wikijs-db pg_dump -U wikijs -d wiki > /www/wwwroot/wikijs/wiki.sql
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开安装时填的地址，用邮箱 `hi@sourcecodedance.com` 登录。数据库口令在 `db_password.txt`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [requarks/wiki 镜像页](https://xuanyuan.cloud/zh/r/requarks/wiki) | [https://xuanyuan.cloud/zh/r/requarks/wiki](https://xuanyuan.cloud/zh/r/requarks/wiki) |
| [requarks/wiki 概览](https://xuanyuan.cloud/r/requarks/wiki) | [https://xuanyuan.cloud/r/requarks/wiki](https://xuanyuan.cloud/r/requarks/wiki) |
| [requarks/wiki 标签列表](https://xuanyuan.cloud/r/requarks/wiki/tags) | [https://xuanyuan.cloud/r/requarks/wiki/tags](https://xuanyuan.cloud/r/requarks/wiki/tags) |
| [library/postgres 镜像页](https://xuanyuan.cloud/r/library/postgres) | [https://xuanyuan.cloud/r/library/postgres](https://xuanyuan.cloud/r/library/postgres) |
| [Docker Hub · requarks/wiki](https://hub.docker.com/r/requarks/wiki) | [https://hub.docker.com/r/requarks/wiki](https://hub.docker.com/r/requarks/wiki) |
| [Docker Hub · postgres](https://hub.docker.com/_/postgres) | [https://hub.docker.com/_/postgres](https://hub.docker.com/_/postgres) |
| [GitHub · requarks/wiki](https://github.com/requarks/wiki) | [https://github.com/requarks/wiki](https://github.com/requarks/wiki) |
| [Release v2.5.316](https://github.com/requarks/wiki-v2/releases/tag/v2.5.316) | [https://github.com/requarks/wiki-v2/releases/tag/v2.5.316](https://github.com/requarks/wiki-v2/releases/tag/v2.5.316) |
| [Wiki.js 官网](https://js.wiki/) | [https://js.wiki/](https://js.wiki/) |
| [Docker 安装](https://docs.requarks.io/install/docker) | [https://docs.requarks.io/install/docker](https://docs.requarks.io/install/docker) |
| [系统要求](https://docs.requarks.io/install/requirements) | [https://docs.requarks.io/install/requirements](https://docs.requarks.io/install/requirements) |
| [发行说明](https://docs.requarks.io/releases) | [https://docs.requarks.io/releases](https://docs.requarks.io/releases) |
| [Troubleshooting](https://docs.requarks.io/troubleshooting) | [https://docs.requarks.io/troubleshooting](https://docs.requarks.io/troubleshooting) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/wikijs-docker-deploy


