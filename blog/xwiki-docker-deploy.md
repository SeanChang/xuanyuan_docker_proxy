# Docker 部署 XWiki：轻松搭建企业知识库与协作 Wiki

![Docker 部署 XWiki：轻松搭建企业知识库与协作 Wiki](https://imgs.xuanyuan.cloud/docker/blog/xwiki/xwiki.webp)

*分类: Docker部署教程 | 标签: XWiki,Docker,轩辕镜像,知识库,Wiki,私有化部署,部署教程 | 发布时间: 2026-10-18 18:49:45*

> XWiki 是一款面向团队的开源企业 Wiki，旨在把页面、结构化数据和协作应用放在同一套系统里，并通过扩展与权限组织内部知识。本文将介绍如何通过 Docker 快速部署 XWiki，搭建可自托管的知识库，帮助团队在自己的服务器上维护文档和协作内容，适合企业内部知识库及项目文档等场景。

*本文基于 [library/xwiki:18.8.0-postgres-tomcat](https://xuanyuan.cloud/zh/r/library/xwiki) 与 [library/postgres:18.6](https://xuanyuan.cloud/zh/r/library/postgres)，实测 Tomcat **10.1.61**、Java **21.0.12.1**，数据库 PostgreSQL **18.6**，测试平台 **Ubuntu 24.04** Linux。*

## XWiki 是什么

XWiki 是一套用 Java 编写的开源 Wiki 平台，许可为 LGPL。页面、权限和扩展在同一个站点里，用来做团队知识库、内部网和可协作的文档站。

与只保存页面正文的 Wiki 不同，XWiki 的页面还可以带上字段和结构化数据。同一套页面能做成博客、任务或会议这类应用。官方把它称为第二代 Wiki。

## XWiki 能做什么

- **协作写页面**：用所见即所得编辑器写文档，保留修改历史，并支持评论和通知。
- **按身份授权**：用户和用户组分开，页面权限可以细到查看、编辑和管理。
- **做成结构化应用**：用 App Within Minutes 给页面加字段，再用可筛选的表格浏览这些数据。
- **安装扩展**：在扩展管理器里安装应用和宏。
- **处理附件与 Office 文件**：页面可以挂附件，并导入、转换 Office 文档。

## 为什么要使用 XWiki

文档放在网盘和聊天记录里时，权限和修改历史分散在各处。托管知识库的数据和后台在服务商那里，导出和停用都要按对方的规则来。

XWiki 把程序和数据库放在自己的服务器上。它适合要长期保管内部文档的团队，也适合要在 Wiki 里直接做博客、任务这类小应用的人。

## 使用 Docker 部署 XWiki

官方镜像里已经有 Tomcat 和对应数据库的 JDBC 驱动。数据库要另起一个容器，本机不必单独安装 Java 和数据库。开始之前，先准备好 Docker，并留出存放 Wiki 数据和数据库文件的目录。

接下来用 Docker Compose 写好这两部分的参数，启动两个容器，并在浏览器里完成安装向导。

## 环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux（本文 Ubuntu 24.04）；macOS 把 `/www/wwwroot/xwiki` 换成 `~/docker/xwiki` |
| Docker | Engine + **Compose V2**（`docker compose`） |
| 架构 | 两份镜像都提供 **linux/amd64** 和 **linux/arm64**。本文日志里的架构是 **amd64** |
| 磁盘 | Ubuntu 24.04 上 `docker images` 显示 XWiki DISK **2.53 GB**、CONTENT **816 MB**，PostgreSQL DISK **650 MB**、CONTENT **169 MB**；数据库和永久目录另计 |
| 内存 | 启动参数含 **`-Xmx1024m`**。宿主机还要留给 PostgreSQL 和 LibreOffice |
| 端口 | 宿主机 **8080/tcp** → XWiki 容器 **8080**。PostgreSQL 只在 Compose 网络内访问，不映射到宿主机 |
| 工作目录 | `/www/wwwroot/xwiki` |

启动日志里是 Apache Tomcat/10.1.61、JVM 21.0.12.1。镜像构建时安装了 LibreOffice 26.2.6，入口脚本会配置它。数据库不在 XWiki 镜像里。

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

标签写成 `<版本>-<数据库>-<Servlet 容器>`。省略数据库时，默认是 **MySQL**，Servlet 容器默认是 **Tomcat**。因此 `18.8.0`、`stable`、`latest` 都是 MySQL 变体，不能拿来配本文的 PostgreSQL。

本文 XWiki 使用 **`18.8.0-postgres-tomcat`**。它是当前稳定版 18.8.0 的 PostgreSQL + Tomcat 构建，与浮动标签 `stable-postgres-tomcat` 指向同一份镜像。数据库使用 **`18.6`**。官方 Compose 示例写的是 `postgres:latest`，当前与 `18`、`18.6` 指向同一版本。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`18.8.0-postgres-tomcat`** | XWiki 18.8.0、PostgreSQL 驱动、Tomcat | **是** |
| `18.8-postgres-tomcat`、`stable-postgres-tomcat`、`postgres-tomcat` | 随 18.8 或当前稳定版移动 | 否 |
| `18.8.0`、`stable`、`latest` | 省略数据库时默认 MySQL，不是 PostgreSQL | 否 |
| `17.10.14-postgres-tomcat` | 当前长期支持线，与 `lts-postgres-tomcat` 指向同一份镜像 | 要长期支持线时，只替换这一处标签，并改用尚未初始化的数据库目录 |
| `18.4.7-postgres-tomcat` | 18.4 线的具体版本 | 否 |
| `18.8.0-mysql-tomcat`、`18.8.0-mariadb-tomcat` | 别的数据库，连接参数和初始化方式不同 | 否 |

| 数据库标签 | 说明 | 是否写入本文命令 |
|------------|------|------------------|
| **`18.6`** | PostgreSQL 18 的具体版本 | **是** |
| `18`、`latest` | 随 18 的小版本移动 | 否 |
| `18.6-alpine`、`alpine` | Alpine 变体。官方示例使用 Debian 变体 | 否 |

PostgreSQL 18 的数据目录挂到容器内 `/var/lib/postgresql`。17 及更早才挂 `/var/lib/postgresql/data`。本文使用 `18.6` 和前一种路径。

镜像页简介里的旧标签列表可以忽略。本文命令是 `18.8.0-postgres-tomcat` 与 `18.6`。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/library/xwiki:18.8.0-postgres-tomcat
docker pull docker.xuanyuan.run/library/postgres:18.6
```

Ubuntu 24.04 实测：

```text
Digest: sha256:13ee48698a658362f32d061c4777b2686dc961eb6f82de52e9f724fa33b8efec
Status: Downloaded newer image for docker.xuanyuan.run/library/xwiki:18.8.0-postgres-tomcat
docker.xuanyuan.run/library/xwiki:18.8.0-postgres-tomcat
```

```text
Digest: sha256:74935e72241653ca55e0414067e6d8763aceb8a810eb51b452253ec3dcfc4336
Status: Downloaded newer image for docker.xuanyuan.run/library/postgres:18.6
docker.xuanyuan.run/library/postgres:18.6
```

拉取完成后确认本地有这两个标签：

```bash
docker images docker.xuanyuan.run/library/xwiki:18.8.0-postgres-tomcat
docker images docker.xuanyuan.run/library/postgres:18.6
```

```text
IMAGE                                                      ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/library/xwiki:18.8.0-postgres-tomcat   13ee48698a65       2.53GB          816MB

IMAGE                                       ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/library/postgres:18.6   74935e722416        650MB          169MB
```

## Docker Compose 部署

工作目录是 `/www/wwwroot/xwiki`。`xwiki` 对应容器内 `/usr/local/xwiki`，存放永久目录，包括配置状态和日志。`postgres` 对应 `/var/lib/postgresql`，存放 PostgreSQL 18 的数据。

第一次启动前，这两个目录保持为空。`postgres` 里已经有数据时，`POSTGRES_USER` 和 `POSTGRES_PASSWORD` 不会再生效。

Java 进程作为 1 号进程时，不会回收 LibreOffice 留下的子进程。Compose 里打开 `init: true`，由 init 进程负责回收。数据库还没接受连接时，XWiki 会启动失败，所以 PostgreSQL 通过健康检查之后再启动 XWiki。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/xwiki/xwiki /www/wwwroot/xwiki/postgres
sudo chown -R "$USER":"$USER" /www/wwwroot/xwiki
```

2. `postgres/` 仍为空时，再生成数据库口令并写入 `compose.yaml`。目录里已经有 PostgreSQL 数据时，不要重新执行这一步，否则新口令和已初始化的账号对不上。口令写在 `db_password.txt`，这是数据库账号 `xwiki` 的口令。Wiki 管理员在「浏览器首次使用」里另设。`umask 077` 让 `db_password.txt` 和 `compose.yaml` 只有当前用户可读；写完后把 umask 调回 `022`，避免后面新建的文件也变成仅本人可读。

```bash
cd /www/wwwroot/xwiki
DB_PASSWORD="$(openssl rand -hex 24)"
umask 077
printf '%s
' "$DB_PASSWORD" > db_password.txt
cat > compose.yaml <<EOF
name: xwiki

services:
  xwiki:
    image: docker.xuanyuan.run/library/xwiki:18.8.0-postgres-tomcat
    container_name: xwiki
    init: true
    restart: unless-stopped
    depends_on:
      db:
        condition: service_healthy
    ports:
      - "8080:8080"
    environment:
      DB_USER: xwiki
      DB_PASSWORD: ${DB_PASSWORD}
      DB_DATABASE: xwiki
      DB_HOST: db
      TZ: Asia/Shanghai
    volumes:
      - ./xwiki:/usr/local/xwiki

  db:
    image: docker.xuanyuan.run/library/postgres:18.6
    container_name: xwiki-db
    restart: unless-stopped
    environment:
      POSTGRES_USER: xwiki
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: xwiki
      POSTGRES_INITDB_ARGS: "--encoding=UTF8 --locale-provider=builtin --locale=C.UTF-8"
      TZ: Asia/Shanghai
    volumes:
      - ./postgres:/var/lib/postgresql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U xwiki -d xwiki"]
      interval: 5s
      timeout: 5s
      retries: 20

EOF
umask 022
unset DB_PASSWORD
```

`DB_HOST` 用服务名 `db`。官方示例里的数据库口令常写成 `xwiki`，这里不要改回去。`POSTGRES_INITDB_ARGS` 只在 `postgres/` 为空、第一次初始化时生效。

3. 启动：

```bash
cd /www/wwwroot/xwiki
docker compose up -d
```

Ubuntu 24.04 实测：数据库先到 healthy，XWiki 随后启动。

```text
[+] up 3/3
 ✔ Network xwiki_default Created   1.9s
 ✔ Container xwiki-db    Healthy  21.0s
 ✔ Container xwiki       Started  18.9s
```

4. 看两个容器是否在运行。`xwiki-db` 为 healthy，`xwiki` 为 Up，并发布 `8080`：

```bash
docker compose ps
```

```text
NAME       IMAGE                                                      COMMAND                  SERVICE   CREATED          STATUS                    PORTS
xwiki      docker.xuanyuan.run/library/xwiki:18.8.0-postgres-tomcat   "docker-entrypoint.s…"   xwiki     38 seconds ago   Up 19 seconds             0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp
xwiki-db   docker.xuanyuan.run/library/postgres:18.6                  "docker-entrypoint.s…"   db        41 seconds ago   Up 34 seconds (healthy)   5432/tcp
```

5. 看 XWiki 容器日志。容器显示 Up 之后，Tomcat 还在部署应用。浏览器可以打开，先看到的是初始化进度，不是安装表单。

```bash
docker compose logs -f --tail 100 xwiki
```

入口脚本先配置 XWiki 和 LibreOffice，再启动 Tomcat。堆参数是 `-Xmx1024m`，临时目录是 `/usr/local/xwiki/data/tmp`。跟踪可以停在正在部署 `ROOT` 这一行：

```text
xwiki  | Configuring XWiki...
xwiki  | Setting environment variables
xwiki  |   Deploying XWiki in the 'ROOT' context
xwiki  | Replacing environment variables in files
xwiki  |   Setting permanent directory...
xwiki  |   Configure libreoffice...
xwiki  | 18-Oct-2026 12:11:31.650 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version name:   Apache Tomcat/10.1.61
xwiki  | 18-Oct-2026 12:11:32.011 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version number: 10.1.61.0
xwiki  | 18-Oct-2026 12:11:32.011 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Architecture:          amd64
xwiki  | 18-Oct-2026 12:11:32.012 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Version:           21.0.12.1+1-LTS
xwiki  | 18-Oct-2026 12:11:32.100 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Xmx1024m
xwiki  | 18-Oct-2026 12:11:32.105 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.io.tmpdir=/usr/local/xwiki/data/tmp
xwiki  | 18-Oct-2026 12:11:33.828 INFO [main] org.apache.coyote.AbstractProtocol.init Initializing ProtocolHandler ["http-nio-8080"]
xwiki  | 18-Oct-2026 12:11:33.994 INFO [main] org.apache.catalina.startup.Catalina.load Server initialization in [3611] milliseconds
xwiki  | 18-Oct-2026 12:11:34.242 INFO [main] org.apache.catalina.core.StandardEngine.startInternal Starting Servlet engine: [Apache Tomcat/10.1.61]
xwiki  | 18-Oct-2026 12:11:34.261 INFO [main] org.apache.catalina.startup.HostConfig.deployDirectory Deploying web application directory [/usr/local/tomcat/webapps/ROOT]
```

镜像把滚动日志写到永久目录 `data/logs/xwiki.log`，对应宿主机 `/www/wwwroot/xwiki/xwiki/data/logs/xwiki.log`。按天滚动，保留 90 天。`docker compose logs` 看的是控制台。

6. 在服务器本机看响应头。上面这条日志之后执行，得到 **302**，`Location` 指向 `/bin/view/Main/`：

```bash
curl -sI http://127.0.0.1:8080/
```

```text
HTTP/1.1 302 
Content-Script-Type: text/javascript
Location: http://127.0.0.1:8080/bin/view/Main/
Date: Sun, 18 Oct 2026 04:13:27 GMT
```

浏览器访问 `http://服务器IP:8080`。本机调试用 `http://127.0.0.1:8080`。打开后先是初始化进度，进度结束后才是安装向导。

## 浏览器首次使用

数据库账号已经写进容器。向导不再询问数据库主机和口令。这套镜像没有预置 `Admin` / `admin`，Wiki 管理员在向导里创建，口令与 `db_password.txt` 不是同一个。

向导要从扩展仓库下载 Flavor。容器出网被拦住时，下载停住。这次安装的是 **XWiki Standard Flavor 18.8.0**。

1. 打开 `http://服务器IP:8080`。页面先显示 `XWiki is initializing (12%)...`。等这行进度消失。

![XWiki 正在初始化，页面显示 XWiki is initializing](https://imgs.xuanyuan.cloud/docker/blog/xwiki/xwiki-1.webp)

2. 进度消失后进入「Distribution Wizard」。页眉是 Admin user、Flavor、Orphaned dependencies、Extensions。「Later」会离开向导，下次重启后再出现。「Never」会放弃向导，之后需要自己导入 XAR。点「Continue」。

![Distribution Wizard 欢迎页，四个步骤和 Continue、Later、Never](https://imgs.xuanyuan.cloud/docker/blog/xwiki/xwiki-2.webp)

3. 在「Step 1 - Admin user」注册 Wiki 所有者。必填是 Username、Password、Confirm Password。这次填写 First Name `xuan`、Last Name `yuan`、Username `XuanYuan`，邮箱 `hi@sourcecodedance.com`。密码框不显示明文。点「Register and login」。

![Admin user 注册页，用户名 XuanYuan，按钮 Register and login](https://imgs.xuanyuan.cloud/docker/blog/xwiki/xwiki-3.webp)

4. 页面出现绿色提示「You are connected with user xuan yuan.」。后续扩展用这个已登录用户安装。点「Continue」。

![Admin user 完成，提示已连接用户 xuan yuan，按钮 Continue](https://imgs.xuanyuan.cloud/docker/blog/xwiki/xwiki-4.webp)

5. 「Step 2 - Flavor」列出 XWiki Standard Flavor 18.8.0，作者是 XWiki Development Team。「Let the wiki be empty」会留下空 Wiki。点「Install this flavor」。

![Flavor 步骤，XWiki Standard Flavor 18.8.0，按钮 Install this flavor](https://imgs.xuanyuan.cloud/docker/blog/xwiki/xwiki-5.webp)

6. 确认页再次显示这个 Flavor。要换别的 Flavor 时点「Select other flavor」。点「Install」。

![确认安装 XWiki Standard Flavor 18.8.0，按钮 Install](https://imgs.xuanyuan.cloud/docker/blog/xwiki/xwiki-6.webp)

7. Progress 开始解析依赖。页面上出现正在解析 `org.xwiki.platform:xwiki-platform-distribution-ui-base` 18.8.0。等这一屏自己结束。

![Flavor 安装进度，正在解析 18.8.0 的扩展依赖](https://imgs.xuanyuan.cloud/docker/blog/xwiki/xwiki-7.webp)

8. 解析结束后，页面列出将要安装的扩展，版本都是 18.8.0，其中包括 Attachment Application、Administration Application、Skin Application。点「Continue」。

![待安装扩展列表，按钮 Continue](https://imgs.xuanyuan.cloud/docker/blog/xwiki/xwiki-8.webp)

9. 报告页标题是「Step 5 - Report」。页眉上四步都已打勾。向导页眉里的「Orphaned dependencies」和「Extensions」这次没有单独打开。正文是 The installation is now finished。Pages 下列出 Home、Main、XWiki 等创建或修改过的页面。点「Continue」。

![安装报告 Step 5 Report，页面树含 Home、Main、XWiki](https://imgs.xuanyuan.cloud/docker/blog/xwiki/xwiki-9.webp)

10. 接着打开的是标题为 Main 的页面。Notice 写着 The requested page could not be found，链接文字是 edit this page。页脚已经是 **XWiki 18.8.0**，说明服务已在运行，只是 Main 还没有正文。点 edit this page 可以新建这一页。右上角还有「Edit」和「Create」。

![Main 页提示页面不存在，页脚 XWiki 18.8.0](https://imgs.xuanyuan.cloud/docker/blog/xwiki/xwiki-10.webp)

11. 管理首页标题是「Global Administration: Home」，面包屑为 XWiki / Global Administration。左侧是 Look & Feel、Content、Users & Rights、Editing。页脚同样是 XWiki 18.8.0。Main 没有正文时，管理页仍然可以打开。

![全局管理首页，Look and Feel、Content、Users and Rights、Editing](https://imgs.xuanyuan.cloud/docker/blog/xwiki/xwiki-11.webp)

## 数据、升级与访问

数据库口令在 `db_password.txt` 和 `compose.yaml` 里。Wiki 管理员口令在向导里设定。

备份前先停容器，再打包 `/www/wwwroot/xwiki`。压缩包里含数据库口令，不要放到公开位置。

压缩包放在 `/www/wwwroot/xwiki-backup.tar.gz`，与站点目录并列。

```bash
cd /www/wwwroot/xwiki
docker compose stop
tar -C /www/wwwroot -czf /www/wwwroot/xwiki-backup.tar.gz xwiki
docker compose start
```

升级前先看两个版本之间的发行说明，确认有没有要手工合并的配置。永久目录和数据库目录留在宿主机上。已经有数据的实例不要改到更低的版本。先改 `compose.yaml` 里 XWiki 的 `image` 标签，再停掉 XWiki 并启动。数据库容器保持运行。

```bash
cd /www/wwwroot/xwiki
docker compose stop xwiki
docker compose up -d
```

要对公网提供访问，在前面加 HTTPS 反向代理。`8080` 适合本机或内网。不要把未加访问控制的 `8080` 直接暴露到公网，也不要把 PostgreSQL 的 `5432` 映射出来。

堆内存默认是 `-Xmx1024m`。要加大时，在 `xwiki` 服务的 `environment` 里增加 `JAVA_OPTS: "-Xmx2048m"`，再执行 `docker compose up -d`。临时目录在永久目录下的 `data/tmp`，每次启动会被清空。

## 备选：docker run

没有 Compose 时，目录和 `db_password.txt` 仍按「Docker Compose 部署」的前两步准备，不要执行那里的 `docker compose up -d`。已经用 Compose 起过名为 `xwiki` 或 `xwiki-db` 的容器时，先在 `/www/wwwroot/xwiki` 执行 `docker compose down`，再跑下面的命令，避免容器名冲突。

`postgres/` 已经初始化过时，继续使用原来的口令。

1. 读出数据库口令。网络 `xwiki` 还不存在时再创建；若提示 `network with name xwiki already exists`，直接进行下一步：

```bash
cd /www/wwwroot/xwiki
DB_PASSWORD="$(cat db_password.txt)"
docker network create xwiki
```

2. 启动 PostgreSQL。数据目录挂到 `/var/lib/postgresql`：

```bash
docker run -d 
  --name xwiki-db 
  --network xwiki 
  --restart unless-stopped 
  -e POSTGRES_USER=xwiki 
  -e POSTGRES_PASSWORD="$DB_PASSWORD" 
  -e POSTGRES_DB=xwiki 
  -e POSTGRES_INITDB_ARGS="--encoding=UTF8 --locale-provider=builtin --locale=C.UTF-8" 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/xwiki/postgres:/var/lib/postgresql 
  docker.xuanyuan.run/library/postgres:18.6
```

3. 等数据库能应答后再启动 XWiki。刚启动时下面这条可能失败，隔几秒再执行。退出码为 0 再进行下一步：

```bash
docker exec xwiki-db pg_isready -U xwiki -d xwiki
```

4. 启动 XWiki。`--init` 的作用与 Compose 里的 `init: true` 相同。用户自定义网络上的容器名 `xwiki-db` 就是数据库主机名：

```bash
docker run -d 
  --init 
  --name xwiki 
  --network xwiki 
  --restart unless-stopped 
  -p 8080:8080 
  -e DB_USER=xwiki 
  -e DB_PASSWORD="$DB_PASSWORD" 
  -e DB_DATABASE=xwiki 
  -e DB_HOST=xwiki-db 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/xwiki/xwiki:/usr/local/xwiki 
  docker.xuanyuan.run/library/xwiki:18.8.0-postgres-tomcat
unset DB_PASSWORD
```

查看与停止：

```bash
docker ps --filter name=xwiki
docker logs -f --tail 100 xwiki
curl -sI http://127.0.0.1:8080/
docker stop xwiki xwiki-db
```

浏览器地址与「浏览器首次使用」相同。

## 常见问题

**Q1：`latest` 或 `18.8.0` 能不能写进 Compose？**

不能。不带 `-postgres-tomcat` 的 `18.8.0`、`stable` 和 `latest` 是 MySQL 变体。本文命令是 `18.8.0-postgres-tomcat` 和 `18.6`。对照见「标签怎么选」。

**Q2：`stable-postgres-tomcat` 和 `lts-postgres-tomcat` 呢？**

这两个会改指向。`stable-postgres-tomcat` 当前与 `18.8.0-postgres-tomcat` 是同一份镜像。长期支持线的具体标签是 `17.10.14-postgres-tomcat`。已经用 `18.8.0` 初始化过的数据目录，不要改去长期支持线。

**Q3：镜像页简介里的版本和本文不一致？**

简介里的标签列举可能还停在更早的版本。本文拉取的是 `docker.xuanyuan.run/library/xwiki:18.8.0-postgres-tomcat`。未登录时，标签页前几条也可能先看到 `18.4.7-postgres-tomcat`。那是 18.4 线，不是本文命令。

**Q4：向导停在 Flavor，进度不再往下走？**

安装 XWiki Standard Flavor 时，Progress 会从扩展仓库下载依赖。先看 XWiki 容器能否访问外网，再看 `docker compose logs --tail 80 xwiki`。出网恢复后刷新向导页面，看 Progress 是否继续。这次安装在解析依赖后列出了 18.8.0 的扩展，并走到了报告页。

**Q5：页面连不上数据库？**

先看 `xwiki-db` 是不是 healthy，再核对口令是否与 `db_password.txt` 一致：

```bash
cd /www/wwwroot/xwiki
docker compose ps
docker compose logs --tail 80 xwiki-db
```

`postgres/` 若是用另一组口令初始化的，只改 Compose 不会改掉已有账号。需要回到原来的口令，或在空目录上重新初始化。重新初始化会丢掉已有 Wiki 数据。

**Q6：把数据挂到 `/var/lib/postgresql/data` 后，重启就空了？**

PostgreSQL 18 的数据在 `/var/lib/postgresql` 下面的版本子目录里。挂到 `/var/lib/postgresql/data` 时，容器里的数据不会落在你准备的宿主机目录上。本文挂载是 `./postgres:/var/lib/postgresql`。

**Q7：页面很慢，或 Java 进程退出？**

启动参数里的堆上限是 `-Xmx1024m`。加大的写法在「数据、升级与访问」。宿主机还要留给 PostgreSQL 和 LibreOffice。这次启动没有出现内存不足。

**Q8：忘记 Wiki 管理员密码？**

向导里创建的用户在数据库中，和 `db_password.txt` 不是同一个口令。镜像没有预置超级管理员密码。只注册过这一个管理员时，用「数据、升级与访问」里的备份恢复。

**Q9：拉取报 `no matching manifest`？**

`18.8.0-postgres-tomcat` 与 `18.6` 提供 linux/amd64 和 linux/arm64。32 位 ARM 拉不到这两份标签。这次拉取的架构是 amd64。

## 命令速查

```bash
docker pull docker.xuanyuan.run/library/xwiki:18.8.0-postgres-tomcat
docker pull docker.xuanyuan.run/library/postgres:18.6

cd /www/wwwroot/xwiki
docker compose up -d
docker compose ps
docker compose logs -f --tail 100 xwiki
curl -sI http://127.0.0.1:8080/

docker compose restart xwiki
docker compose stop
docker compose start
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://服务器IP:8080`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [library/xwiki 镜像页](https://xuanyuan.cloud/zh/r/library/xwiki) | [https://xuanyuan.cloud/zh/r/library/xwiki](https://xuanyuan.cloud/zh/r/library/xwiki) |
| [library/xwiki 概览](https://xuanyuan.cloud/r/library/xwiki) | [https://xuanyuan.cloud/r/library/xwiki](https://xuanyuan.cloud/r/library/xwiki) |
| [library/xwiki 标签列表](https://xuanyuan.cloud/r/library/xwiki/tags) | [https://xuanyuan.cloud/r/library/xwiki/tags](https://xuanyuan.cloud/r/library/xwiki/tags) |
| [library/postgres 镜像页](https://xuanyuan.cloud/zh/r/library/postgres) | [https://xuanyuan.cloud/zh/r/library/postgres](https://xuanyuan.cloud/zh/r/library/postgres) |
| [library/postgres 标签列表](https://xuanyuan.cloud/r/library/postgres/tags) | [https://xuanyuan.cloud/r/library/postgres/tags](https://xuanyuan.cloud/r/library/postgres/tags) |
| [Docker Hub · xwiki](https://hub.docker.com/_/xwiki) | [https://hub.docker.com/_/xwiki](https://hub.docker.com/_/xwiki) |
| [Docker Hub · postgres](https://hub.docker.com/_/postgres) | [https://hub.docker.com/_/postgres](https://hub.docker.com/_/postgres) |
| [GitHub · xwiki/xwiki-docker](https://github.com/xwiki/xwiki-docker) | [https://github.com/xwiki/xwiki-docker](https://github.com/xwiki/xwiki-docker) |
| [XWiki 官网](https://www.xwiki.org/xwiki/bin/view/Main/) | [https://www.xwiki.org/xwiki/bin/view/Main/](https://www.xwiki.org/xwiki/bin/view/Main/) |
| [用 Docker 安装 XWiki](https://www.xwiki.org/xwiki/bin/view/documentation/xs/admin/installation/methods/install-xwiki-docker/) | [https://www.xwiki.org/xwiki/bin/view/documentation/xs/admin/installation/methods/install-xwiki-docker/](https://www.xwiki.org/xwiki/bin/view/documentation/xs/admin/installation/methods/install-xwiki-docker/) |
| [Distribution Wizard](https://www.xwiki.org/xwiki/bin/view/documentation/xs/admin/distribution-wizard/) | [https://www.xwiki.org/xwiki/bin/view/documentation/xs/admin/distribution-wizard/](https://www.xwiki.org/xwiki/bin/view/documentation/xs/admin/distribution-wizard/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/xwiki-docker-deploy


