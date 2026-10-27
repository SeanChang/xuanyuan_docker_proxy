# Docker 部署 CloudBeaver：轻松搭建网页数据库管理平台

![Docker 部署 CloudBeaver：轻松搭建网页数据库管理平台](https://imgs.xuanyuan.cloud/docker/blog/cloudbeaver/cloudbeaver.webp)

*分类: Docker部署教程 | 标签: CloudBeaver,dbeaver/cloudbeaver,Docker,轩辕镜像,数据库管理,私有化部署,部署教程 | 发布时间: 2026-10-27 11:24:06*

> CloudBeaver 是一款面向开发与数据团队的开源网页数据库管理工具，旨在把多种数据库的连接、SQL 编辑和数据查看放在同一套浏览器界面里，并通过管理员账号控制访问范围。本文将介绍如何通过 Docker Compose 部署 CloudBeaver 社区版，搭建私有化的网页数据库管理平台，帮助开发、运维和数据分析人员在浏览器里管理数据库，适合内网开发库、测试库及需要统一入口的小团队等场景。

## CloudBeaver 是什么

CloudBeaver 社区版是 DBeaver 的网页数据库管理服务。服务端是 Java 程序，页面用 TypeScript 和 React 写成。社区版可以免费使用，许可证是 Apache 2.0。

桌面版 DBeaver 安装在每台电脑上。CloudBeaver 把连接、SQL 和数据查看放在浏览器里，由管理员在服务器上配置，其他人登录后使用。同一套页面按驱动连接不同的数据库。

## CloudBeaver 能做什么

- **连接多种数据库**：在网页里按驱动新建连接，查看库、表和数据。
- **编写和执行 SQL**：在 SQL 编辑器里写语句，在数据编辑器里查看和修改表数据。
- **导入和导出数据**：在数据传输里导入、导出表数据。
- **管理用户和共享连接**：管理员创建用户和团队，并把连接分给有权限的人。
- **用 AI 辅助 SQL**：开始页有 AI Chat，入口写着先启用助手。服务器配置里可以关闭这项功能。

## 为什么要使用 CloudBeaver

每台电脑单独安装客户端时，数据库地址和账号留在各自的电脑上。把数据库服务器的系统账号交给同事，交出的是这台机器的登录权限。

CloudBeaver 提供一个网页入口。管理员配置连接，其他人用浏览器登录后使用分到的连接。适合放在自己管理的内网，查看开发库、测试库，或给做分析的人一个登录入口。

## 使用 Docker 部署 CloudBeaver

CloudBeaver 社区版提供现成镜像，本机不用再安装 Java。开始之前，先准备好 Docker。

接下来用 Docker Compose 写好运行参数，启动服务，并在浏览器里完成初始配置。

## 环境要求

**26.2.3** 于 2026-10-19 发布，标签包含 **amd64** 和 **arm64**。这次在 Ubuntu 24.04 上实测，主机名 `ikuai-ubuntu2404`，内核 **6.8.0-146-generic**。日志里的版本是 **CloudBeaver Community 26.2.3.202610190842**，Java 是 **25.0.4.1**（Eclipse Adoptium，64 位）。

社区版把用户和连接保存在挂载目录里的 H2 中。企业版从 24.2.0 起的 Compose 默认使用 PostgreSQL。社区版仍然使用 H2，不必再单独准备数据库。

| 项目 | 建议 |
|------|------|
| 系统 | Linux。macOS 把工作目录换成 `~/docker/cloudbeaver` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **amd64**、**arm64**。命令使用多架构标签 `26.2.3` |
| 磁盘 | 镜像，以及 `workspace/` 里的 H2、连接配置和之后下载的驱动文件。程序日志在 `logs/` |
| 端口 | 宿主机 **8978** → 容器 **8978** |
| 工作目录 | `/www/wwwroot/cloudbeaver` |

8978 已被占用时，只改宿主机端口，容器内仍然监听 8978。浏览器改用新的宿主机端口。

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

新安装使用 **`26.2.3`**。这是 2026-10-19 的稳定版，更新说明里包含 SQL 编辑器、数据编辑器和若干依赖库的修复。

`latest` 指向当前稳定版，下次发布后会改指向。`26` 和 `26.2` 会跟着该系列的新小版本走。`ea` 是每两周一次的早期访问版，2026-10-26 仍在更新。这四个标签都不写入本文命令。

| 标签 | 说明 | 是否写入本文主路径 |
|------|------|--------------------|
| **`26.2.3`** | 2026-10-19 的稳定版，amd64 与 arm64 | **是** |
| `26.2.2` 及更早的数字标签 | 更旧的稳定版 | 否 |
| `26.2`、`26` | 系列浮动标签，会指向该系列里更新的版本 | 否 |
| `latest` | 当前稳定版的浮动标签 | 否 |
| `ea` | 早期访问版 | 否 |

本文使用社区版 `dbeaver/cloudbeaver`。`dbeaver/cloudbeaver-ee` 是企业版，`dbeaver/cloudbeaver-te` 是团队版集群里的 Web 节点。

完整标签见[标签列表](https://xuanyuan.cloud/r/dbeaver/cloudbeaver/tags)。版本号的含义见 [CloudBeaver release cycles](https://github.com/dbeaver/cloudbeaver/wiki/CloudBeaver-release-cycles)。26.2.3 的变更写在[项目 README 的 Changelog](https://github.com/dbeaver/cloudbeaver/blob/devel/README.md)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/dbeaver/cloudbeaver:26.2.3
```

Ubuntu 24.04 上，第一次拉取在层 `14ee08b574c6` 超时，报错是 `timeout awaiting response headers`。同一条命令再执行一次后完成：

```text
Digest: sha256:0c875296f85ffd7c0ffaaaeff678cd2f383890050297585318d7cf8f49024d1f
Status: Downloaded newer image for docker.xuanyuan.run/dbeaver/cloudbeaver:26.2.3
docker.xuanyuan.run/dbeaver/cloudbeaver:26.2.3
```

## Docker Compose 部署

下面这份 Compose 把网页放在宿主机 **8978**。`workspace/` 对应容器内 `/opt/cloudbeaver/workspace`，社区版的用户、连接和 H2 库都在这里。`logs/` 对应容器内 `/opt/cloudbeaver/logs`。本文的 `compose.yaml` 放在 `/www/wwwroot/cloudbeaver/compose.yaml`。删除容器不会删除这两个目录。

镜像构建时创建了用户 `dbeaver`，UID 和 GID 都是 **8978**。`workspace/` 和 `logs/` 要交给这个用户写。

| 宿主机 | 容器内 | 用途 |
|--------|--------|------|
| **8978** | **8978** | 网页。浏览器打开 `http://服务器IP:8978` |
| `workspace/` | `/opt/cloudbeaver/workspace` | 用户、连接、内部 H2 和下载的驱动 |
| `logs/` | `/opt/cloudbeaver/logs` | 程序日志 |

1. 先看 8978 是否已有进程监听。有输出时，下一步把 `compose.yaml` 里冒号左边改成空闲端口。没有输出再继续：

```bash
sudo ss -lntp | grep -E ':8978' || true
```

这次没有输出，8978 没有进程监听。

2. 创建目录。工作目录留给当前用户写 `compose.yaml`，两个数据目录交给 8978：

```bash
sudo mkdir -p /www/wwwroot/cloudbeaver/workspace /www/wwwroot/cloudbeaver/logs
sudo chown "$USER":"$USER" /www/wwwroot/cloudbeaver
sudo chown -R 8978:8978 /www/wwwroot/cloudbeaver/workspace /www/wwwroot/cloudbeaver/logs
cd /www/wwwroot/cloudbeaver
```

3. 写入 `compose.yaml`：

```bash
cat > compose.yaml <<'EOF'
services:
  cloudbeaver:
    image: docker.xuanyuan.run/dbeaver/cloudbeaver:26.2.3
    container_name: cloudbeaver
    restart: unless-stopped
    ports:
      - "8978:8978"
    volumes:
      - ./workspace:/opt/cloudbeaver/workspace
      - ./logs:/opt/cloudbeaver/logs
EOF
```

| 配置 | 说明 |
|------|------|
| `8978:8978` | 冒号左边是宿主机端口，右边是容器内端口。只改左边 |
| `./workspace` | 容器内 `/opt/cloudbeaver/workspace` |
| `./logs` | 容器内 `/opt/cloudbeaver/logs` |
| `unless-stopped` | 机器重启后容器会起来。手动 `docker stop` 之后保持停止 |

4. 启动，并查看状态和日志：

```bash
docker compose up -d
docker compose ps
docker compose logs cloudbeaver
```

Ubuntu 24.04 上这次启动的输出：

```text
[+] up 2/2
 ✔ Network cloudbeaver_default Created  0.2s
 ✔ Container cloudbeaver       Started  2.6s
```

```text
NAME          IMAGE                                            COMMAND                 SERVICE       CREATED         STATUS         PORTS
cloudbeaver   docker.xuanyuan.run/dbeaver/cloudbeaver:26.2.3   "./launch-product.sh"   cloudbeaver   6 seconds ago   Up 3 seconds   0.0.0.0:8978->8978/tcp, [::]:8978->8978/tcp
```

8978 同时映射了 IPv4 和 IPv6。容器命令是 `./launch-product.sh`。网络名 `cloudbeaver_default`，日志里的容器地址是 `172.22.0.2`。

日志很长，下面只留和这次启动有关的几行：

```text
cloudbeaver  | Starting Cloudbeaver Server
cloudbeaver  | 2026-10-27 02:56:26.720 - Workspace path initialized: /opt/cloudbeaver/workspace
cloudbeaver  | 2026-10-27 02:56:26.857 - Platform not initialized: metadata folder may be not set
cloudbeaver  | 2026-10-27 02:56:26.893 -        Starting instance server at http://localhost:41461
cloudbeaver  | 2026-10-27 02:56:28.400 [main] DEBUG io.cloudbeaver.server.CBApplication - CloudBeaver Community 26.2.3.202610190842 is starting
cloudbeaver  | 2026-10-27 02:56:28.401 [main] DEBUG io.cloudbeaver.server.CBApplication -       OS: Linux 6.8.0-146-generic (amd64)
cloudbeaver  | 2026-10-27 02:56:28.401 [main] DEBUG io.cloudbeaver.server.CBApplication -       Java version: 25.0.4.1 by Eclipse Adoptium (64bit)
cloudbeaver  | 2026-10-27 02:56:28.402 [main] DEBUG io.cloudbeaver.server.CBApplication -       Memory available 117Mb/450Mb
cloudbeaver  | 2026-10-27 02:56:28.404 [main] DEBUG io.cloudbeaver.server.CBApplication -       Listen port: 8978 on all interfaces
cloudbeaver  | 2026-10-27 02:56:28.404 [main] DEBUG io.cloudbeaver.server.CBApplication -       Server is in configuration mode!
cloudbeaver  | 2026-10-27 02:56:28.613 [main] ERROR i.c.registry.WebDriverRegistry -    Driver 'yandex_clickhouse' is missing library 'ru.yandex.clickhouse:clickhouse-jdbc:RELEASE'
cloudbeaver  | 2026-10-27 02:56:28.620 [main] INFO  i.c.registry.WebDriverRegistry - Available drivers: ClickHouse,Databend,Db2 for LUW,Db2 for IBM i,DuckDB,Firebird,Hadoop / Apache Kyuubi,Trino,H2 Embedded (legacy),H2 Embedded V.2.1,H2 Embedded,MS SQL Server / SQL Server,MySQL,MariaDB,Oracle,PostgreSQL,SQLite,LibSQL
cloudbeaver  | 2026-10-27 02:56:28.727 [main] DEBUG i.c.service.security.db.CBDatabase -        Initiate connection pool with management database (H2 Embedded V.2.1; jdbc:h2:/opt/cloudbeaver/workspace/.data/cb.h2v2.dat)
```

`localhost:41461` 是启动过程中的内部地址，对外端口是 **8978**。`Platform not initialized` 出现在工作区元数据就绪之前，后面的行显示服务继续启动。`Server is in configuration mode` 表示还没做完初始配置。`Memory available 117Mb/450Mb` 是这次进程打印的 Java 内存。

`yandex_clickhouse` 缺少 `ru.yandex.clickhouse:clickhouse-jdbc:RELEASE`，是旧的 ClickHouse 驱动。紧接着的 `Available drivers` 里仍有 ClickHouse。向导里的 Disabled drivers 是默认不启用的几项，和这份清单不是同一份列表。内部库是 **H2 Embedded V.2.1**，文件是 `workspace/.data/cb.h2v2.dat`。随后日志开始创建 H2 的 schema。本机访问返回 200。

5. 在服务器本机确认网页有响应：

```bash
curl -sS -o /dev/null -w "%{http_code}
" http://127.0.0.1:8978/
```

这次返回：

```text
200
```

## 在浏览器里完成初始配置

日志里的 `Server is in configuration mode` 对应第一次打开时的向导。页面标题是 INITIAL SERVER CONFIGURATION。没有预置的管理员用户名和密码。

1. 在浏览器打开 `http://服务器IP:8978`，把「服务器IP」换成这台机器的地址。左侧当前是 Welcome，标题是 Welcome to CloudBeaver Community。说明里写着要设置服务器信息和管理员凭据，这些参数以后可以在管理面板里修改。

![CloudBeaver 初始配置欢迎页，标题 Welcome to CloudBeaver Community，左侧为 Welcome，按钮为 NEXT](https://imgs.xuanyuan.cloud/docker/blog/cloudbeaver/cloudbeaver-1.webp)

2. 点「NEXT」，进入 Main server configuration。页顶写明管理员可以配置服务器、建立数据库连接和管理其他用户，并要求记住密码，管理员密码不能自动找回。

![CloudBeaver 主服务器配置页，Server Name 为 CloudBeaver Community，Allowed Server URLs 为空，Login 为 cbadmin，Allow anonymous access 与 Local 为打开](https://imgs.xuanyuan.cloud/docker/blog/cloudbeaver/cloudbeaver-2.webp)

3. 确认 Server Name。这次页面上是 `CloudBeaver Community`，可以改成你认得的名字。Allowed Server URLs 留空。页面写明空值表示允许任意地址访问，多条地址时一行一条。框内的 `example.com` 和 `localhost:5000` 是占位文字。Session lifetime 保持 **30**，单位是分钟。Force HTTPS mode 保持关闭。开关下写着生产环境建议开启，并先配好 HTTPS 代理。这次用 `http://服务器IP:8978` 访问。

4. 在 Administrator credentials 里填写 Login、Password 和 Repeat Password。两次密码要一致。服务器配置的默认密码策略是至少 8 位，同时包含大写、小写和至少 1 个数字。这次 Login 填写 `cbadmin`。

5. Authentication settings 里的 Local 保持打开，这是用户名和密码登录。Allow anonymous access 在上图里是打开的，旁边写着可以不登录就使用。只给登录用户使用时，先关掉它。Enable private connections 这次是关闭的，旁边写着打开后允许用户创建私有连接。右下角 Disabled drivers 里能看到 DuckDB、SQLite，以及几项 H2 Embedded。这些禁用项先留着，然后点「NEXT」。

6. 进入 Confirmation。标题是 That is almost it。说明写着点 FINISH 后会应用全部设置，并回到主页面。

![CloudBeaver 初始配置确认页，标题 That is almost it，按钮为 FINISH](https://imgs.xuanyuan.cloud/docker/blog/cloudbeaver/cloudbeaver-3.webp)

点「FINISH」。

7. 完成后弹出 Authentication，方式是 Local。填写刚才的 User name 和 User password，点「LOGIN」。顶部有 Connections 和 Administration。

![CloudBeaver 登录框，标题 Authentication，方式为 Local，字段为 User name 和 User password，按钮为 LOGIN](https://imgs.xuanyuan.cloud/docker/blog/cloudbeaver/cloudbeaver-4.webp)

如果登录时报 `Unsupported authentication provider: local`，说明 Local 认证没有启用。在服务器配置里把 `enabledAuthProviders` 包含 `local`，保存后重启容器。向导里的 Local 需要保持打开。

## 登录后的开始页

登录后右上角用户是 `cbadmin`。主区域标题是 CloudBeaver Community，下面是 Start。四个入口是 New Connection、SQL Editor、Documentation 和 AI Chat。左侧是 No Connections，并写着用顶部菜单建立连接。

左下角出现 `You don't have permission for this action`。开始页仍停在 Start，四个入口都在。随后的偏好设置和「新建连接」可以打开。

![CloudBeaver 开始页，右上角用户 cbadmin，四个入口为 New Connection、SQL Editor、Documentation、AI Chat，左下角提示 You don't have permission for this action](https://imgs.xuanyuan.cloud/docker/blog/cloudbeaver/cloudbeaver-5.webp)

1. 点右上角用户名 `cbadmin`，打开带 User Info 的面板。进入 Preferences 的 Interface。在 Language 里选择「简体中文」，点「SAVE」。

![CloudBeaver 偏好设置的 Interface 页，Language 下拉框展开并停在简体中文，顶部按钮为 SAVE](https://imgs.xuanyuan.cloud/docker/blog/cloudbeaver/cloudbeaver-6.webp)

2. 保存后左下角提示「保存偏好选项成功」。面板页签变为「用户信息」「偏好选项」「认证」，「语言」显示为简体中文。

![CloudBeaver 偏好设置已切换为简体中文，语言为简体中文，左下角提示保存偏好选项成功](https://imgs.xuanyuan.cloud/docker/blog/cloudbeaver/cloudbeaver-7.webp)

## 新建数据库连接

语言保存后，主界面标题是 CloudBeaver 社区版。在「开始」页点「新建连接」。弹出「新连接」，搜索框是「输入驱动名称」。这次能看到的有 Db2 for LUW、MariaDB、MySQL、Oracle、PostgreSQL、SQL Server、Apache Kyuubi 和 ClickHouse。

![CloudBeaver 新连接对话框，标题为新连接，搜索框为输入驱动名称，列表含 MariaDB、MySQL、Oracle、PostgreSQL、SQL Server 和 ClickHouse](https://imgs.xuanyuan.cloud/docker/blog/cloudbeaver/cloudbeaver-8.webp)

选中一种驱动后，下一页填写主机、端口、数据库名和连接名。数据库在另一台机器上时，主机填那台机器的地址，并确认容器能访问对应端口。数据库在本机时，先看「常见问题」里的本机数据库。容器里的 `127.0.0.1` 指向容器自己。

官方说明里，一部分驱动要先下载二进制文件，缺少文件时页面会提示。容器需要能访问外网，下载结果写在 `workspace/` 里。填完后先测试连接，再创建。这次停在驱动列表，没有保存连接。

向导里的 Enable private connections 当时是关闭的。管理员仍然打开了「新建连接」。要让普通用户创建只属于自己的连接时，回到服务器配置里打开这项。

## 访问控制与数据保存

Allow anonymous access 打开时，可以不登录就使用。只给登录用户使用时，在向导里关掉它。8978 供自己的网络使用。放到公网前面时，用带登录校验的反向代理。WebSocket 和网页使用同一个主机和端口，代理要放行 WebSocket。

账号、权限和连接都在 `/opt/cloudbeaver/workspace`。升级前先复制整个 `workspace/`。官方说明不支持降级。删除容器会留下这个目录。删掉目录再启动，会重新进入初始配置，已有用户和连接一起消失。

## 备选：docker run

这一节只在没有 Compose 时使用。已经用 Compose 启动过同名容器时，不要再执行一遍，否则容器名和 8978 会冲突。

目录和属主与 Compose 相同。还没有创建时，先执行：

```bash
sudo mkdir -p /www/wwwroot/cloudbeaver/workspace /www/wwwroot/cloudbeaver/logs
sudo chown -R 8978:8978 /www/wwwroot/cloudbeaver/workspace /www/wwwroot/cloudbeaver/logs
```

后台启动：

```bash
docker run -d 
  --name cloudbeaver 
  --restart unless-stopped 
  -p 8978:8978 
  -v /www/wwwroot/cloudbeaver/workspace:/opt/cloudbeaver/workspace 
  -v /www/wwwroot/cloudbeaver/logs:/opt/cloudbeaver/logs 
  docker.xuanyuan.run/dbeaver/cloudbeaver:26.2.3
```

查看状态和日志：

```bash
docker ps --filter name=cloudbeaver
docker logs cloudbeaver
```

浏览器仍然打开 `http://服务器IP:8978`，初始配置与「在浏览器里完成初始配置」相同。

## 常见问题

**Q1：为什么命令里不写 `latest`？**

`latest`、`26`、`26.2` 和 `ea` 都会随新版本变化。本文命令使用 **`26.2.3`**。对照见「标签怎么选」。升级前先备份 `workspace/`。

**Q2：忘记管理员密码怎么办？**

官方说明管理员密码不能自动找回。还没有要保留的连接和用户时，可以停止容器，把 `/www/wwwroot/cloudbeaver/workspace` 清空后再启动，然后重新做初始配置。这个目录里已经有连接、用户或下载的驱动时，清空会把它们一起删掉。

**Q3：容器起来了，浏览器打不开？**

按这个顺序看：

1. `docker compose ps` 里 `cloudbeaver` 是否为 Up。
2. `docker compose logs cloudbeaver`。`Platform not initialized` 和 `yandex_clickhouse` 的含义见「Docker Compose 部署」。这次这两行之后，本机访问返回 200。目录不可写时，把 `workspace/` 和 `logs/` 的属主改成 **8978**，再执行 `docker compose up -d`。
3. 在服务器上执行 `curl -sS -o /dev/null -w "%{http_code}
" http://127.0.0.1:8978/`。
4. 本机返回 200、别的机器打不开时，检查安全组和防火墙是否放行 **8978**。
5. 前面有反向代理时，按「访问控制与数据保存」转发 WebSocket。

**Q4：连不上跑在宿主机上的数据库？**

容器里的 `127.0.0.1` 指向容器自己。官方给出两种做法。

数据库只监听宿主机的回环地址时，在 Linux 上改用主机网络，连接地址可以继续用 localhost。这样会直接占用宿主机的 8978，Compose 里不再写 `ports`。在 `cloudbeaver` 服务下增加：

```yaml
    network_mode: host
```

然后删掉该服务的 `ports`，执行 `docker compose up -d`。`network_mode: host` 用在 Linux 上。

数据库监听的是可供其他网卡访问的地址时，给容器增加主机名。官方示例是 `--add-host=host.docker.internal:<宿主机 IP>`。Compose 里可以写成：

```yaml
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

放在 `cloudbeaver` 服务下，执行 `docker compose up -d`。新建连接时，Host 填 `host.docker.internal`，Port 填数据库自己的端口。数据库只监听 `127.0.0.1` 时，这条主机名仍然连不上，改用上面的 `network_mode: host`。

数据库在另一台机器上时，Host 填那台机器的 IP 或域名。那台机器的防火墙要允许来自 CloudBeaver 容器所在网段的访问。

**Q5：新建连接时提示缺少驱动？**

官方说明：一部分驱动要先下载二进制文件。容器需要能访问外网。下载完成后文件在 `workspace/` 里，升级和重建容器时保留这个目录。

这次向导的 Disabled drivers 里能看到 DuckDB、SQLite 和几项 H2 Embedded。需要其中某一项时，在点「NEXT」之前点该项右侧的叉。旧驱动 `yandex_clickhouse` 缺库的那一行，不影响「新连接」列表里的 ClickHouse。

**Q6：未登录也能打开页面？**

初始配置里的 Allow anonymous access 处于打开状态时，可以不登录就使用。只允许登录用户使用时，重新进入 Administration 的 Server configuration，关掉这项并保存。

**Q7：还要再部署 PostgreSQL 吗？**

社区版不用。内部的用户和权限放在 H2 里。要查的业务库在「新建数据库连接」里单独添加。企业版 Compose 默认使用 PostgreSQL，那是另一个镜像。

**Q8：如何升级？**

先备份 `/www/wwwroot/cloudbeaver/workspace`。官方说明不支持降级。保留这个目录是升级；换一个空目录再启动，是重新初始化。

改 `compose.yaml` 的 `image` 标签后执行：

```bash
cd /www/wwwroot/cloudbeaver
docker compose pull
docker compose up -d
```

用 `docker run` 启动的，备份 `workspace/` 后执行 `docker stop cloudbeaver && docker rm cloudbeaver`，再按「备选：docker run」用新标签启动。`/www/wwwroot/cloudbeaver/workspace` 的路径保持不变。

**Q9：和企业版、团队版是什么关系？**

本文是社区版 `dbeaver/cloudbeaver`。企业版和团队版的镜像名见「标签怎么选」。换掉 `image` 之后，端口、向导和数据目录都可能不同。

**Q10：macOS 上目录放哪里？**

工作目录改成 `~/docker/cloudbeaver`，其下仍然是 `workspace/` 和 `logs/`。端口仍是宿主机 **8978**。容器报告目录不可写时，再把这两个子目录的属主改成 **8978**。

**Q11：如何停止与卸载？**

确认不再需要账号和连接之前，不要删除 `workspace/`。

Compose 停止并保留数据目录：

```bash
cd /www/wwwroot/cloudbeaver
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop cloudbeaver && docker rm cloudbeaver
```

账号、连接和驱动都不再需要时，再删除整个目录：

```bash
rm -rf /www/wwwroot/cloudbeaver
```

## 命令速查

```bash
docker pull docker.xuanyuan.run/dbeaver/cloudbeaver:26.2.3

cd /www/wwwroot/cloudbeaver
docker compose up -d
docker compose ps
docker compose logs cloudbeaver
curl -sS -o /dev/null -w "%{http_code}
" http://127.0.0.1:8978/

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://服务器IP:8978`。没有预置账号，首次进入时自己设置管理员用户名和密码。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [dbeaver/cloudbeaver 镜像页](https://xuanyuan.cloud/zh/r/dbeaver/cloudbeaver) | [https://xuanyuan.cloud/zh/r/dbeaver/cloudbeaver](https://xuanyuan.cloud/zh/r/dbeaver/cloudbeaver) |
| [dbeaver/cloudbeaver 概览](https://xuanyuan.cloud/r/dbeaver/cloudbeaver) | [https://xuanyuan.cloud/r/dbeaver/cloudbeaver](https://xuanyuan.cloud/r/dbeaver/cloudbeaver) |
| [dbeaver/cloudbeaver 标签列表](https://xuanyuan.cloud/r/dbeaver/cloudbeaver/tags) | [https://xuanyuan.cloud/r/dbeaver/cloudbeaver/tags](https://xuanyuan.cloud/r/dbeaver/cloudbeaver/tags) |
| [Docker Hub · dbeaver/cloudbeaver](https://hub.docker.com/r/dbeaver/cloudbeaver) | [https://hub.docker.com/r/dbeaver/cloudbeaver](https://hub.docker.com/r/dbeaver/cloudbeaver) |
| [GitHub · dbeaver/cloudbeaver](https://github.com/dbeaver/cloudbeaver) | [https://github.com/dbeaver/cloudbeaver](https://github.com/dbeaver/cloudbeaver) |
| [Changelog（含 26.2.3）](https://github.com/dbeaver/cloudbeaver/blob/devel/README.md) | [https://github.com/dbeaver/cloudbeaver/blob/devel/README.md](https://github.com/dbeaver/cloudbeaver/blob/devel/README.md) |
| [社区版 Docker 部署](https://github.com/dbeaver/cloudbeaver/wiki/CloudBeaver-Community-deployment-from-docker-image) | [https://github.com/dbeaver/cloudbeaver/wiki/CloudBeaver-Community-deployment-from-docker-image](https://github.com/dbeaver/cloudbeaver/wiki/CloudBeaver-Community-deployment-from-docker-image) |
| [发布周期与 Docker 标签](https://github.com/dbeaver/cloudbeaver/wiki/CloudBeaver-release-cycles) | [https://github.com/dbeaver/cloudbeaver/wiki/CloudBeaver-release-cycles](https://github.com/dbeaver/cloudbeaver/wiki/CloudBeaver-release-cycles) |
| [首次配置与 Administration](https://github.com/dbeaver/cloudbeaver/wiki/Administration) | [https://github.com/dbeaver/cloudbeaver/wiki/Administration](https://github.com/dbeaver/cloudbeaver/wiki/Administration) |
| [新建连接](https://github.com/dbeaver/cloudbeaver/wiki/Create-Connection) | [https://github.com/dbeaver/cloudbeaver/wiki/Create-Connection](https://github.com/dbeaver/cloudbeaver/wiki/Create-Connection) |
| [服务器配置](https://github.com/dbeaver/cloudbeaver/wiki/Server-configuration) | [https://github.com/dbeaver/cloudbeaver/wiki/Server-configuration](https://github.com/dbeaver/cloudbeaver/wiki/Server-configuration) |
| [内部数据库](https://github.com/dbeaver/cloudbeaver/wiki/Server-Database) | [https://github.com/dbeaver/cloudbeaver/wiki/Server-Database](https://github.com/dbeaver/cloudbeaver/wiki/Server-Database) |
| [Workspace 备份](https://github.com/dbeaver/cloudbeaver/wiki/CloudBeaver-Workspace-Backup) | [https://github.com/dbeaver/cloudbeaver/wiki/CloudBeaver-Workspace-Backup](https://github.com/dbeaver/cloudbeaver/wiki/CloudBeaver-Workspace-Backup) |
| [CloudBeaver 文档](https://dbeaver.com/docs/cloudbeaver/) | [https://dbeaver.com/docs/cloudbeaver/](https://dbeaver.com/docs/cloudbeaver/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/cloudbeaver-docker-deploy)

*本文基于 [dbeaver/cloudbeaver:26.2.3](https://xuanyuan.cloud/zh/r/dbeaver/cloudbeaver)，实测引擎 **CloudBeaver Community 26.2.3.202610190842**，Java **25.0.4.1**，测试平台 **Ubuntu 24.04** Linux。*


