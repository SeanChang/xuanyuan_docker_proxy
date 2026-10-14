# Docker 部署 Memos：轻松搭建私有化轻量笔记平台

![Docker 部署 Memos：轻松搭建私有化轻量笔记平台](https://imgs.xuanyuan.cloud/docker/blog/memos1.webp)

*分类: Docker部署教程 | 标签: Memos,neosmemo/memos,Docker,轩辕镜像,笔记,Markdown,私有化部署,部署教程 | 发布时间: 2026-06-28 05:31:45*

> Memos 是一款面向个人和小团队的开源笔记服务，旨在用时间线记下灵感和待办，并通过 Markdown、标签和附件把内容留在自己的服务器上。本文将介绍如何通过 Docker 快速部署 Memos，搭建私有化轻量笔记平台，帮助你更高效地记录碎片想法，适合替代云笔记随手记及内网知识备忘等场景。

*本文基于 [neosmemo/memos:0.29.1](https://xuanyuan.cloud/zh/r/neosmemo/memos)，以 **0.29.1** 版本实测，测试平台 **Ubuntu 24.04** Linux。*

## Memos 是什么

Memos 是开源的自托管笔记服务，用一条时间线记下想法。写一条 memo 只要几秒，可以打标签、加附件，也可以只把其中一条分享出去。笔记默认不公开，放在你自己指定的机器上。

和 Notion、飞书、语雀相比，它不做多人协作和模板市场，内容留在你部署的实例里。和一堆本地 Markdown 文件相比，它有浏览器里的时间线、搜索和账号。

## Memos 能做什么

- **打开就写**：用时间线记一条想法，不必先建文件夹。
- **用 Markdown 组织**：正文可以写标签、待办和常见 Markdown。
- **附上文件**：可以插入图片、音频、附件和位置。
- **按条件找回**：用搜索、标签和筛选条件找回旧笔记。
- **控制谁能看到**：每条笔记默认私有，需要时再改为公开或分享。

## 为什么要使用 Memos

把灵感和待办放在 Notion、飞书或语雀上，数据在对方的服务里。只想随手记几句时，也不一定需要一整套协作文档。

Memos 把时间线放在你自己的服务器上。个人记摘抄、碎片待办，或者小团队放一份轻量记录，都可以用它。它适合在意笔记放在哪里的人。复杂协作和知识图谱要另选工具。

## 使用 Docker 部署 Memos

Memos 可以用 Docker 启动，本机不必先安装它的二进制。开始之前，先准备好 Docker。

下面用 Docker Compose 写好数据目录，启动服务，并在浏览器里注册第一个用户、写下一条笔记。

## 环境要求

官方使用文档目前按 0.31.0 来写。本文命令和界面步骤停在已实测的 **0.29.1**，没有改测更新版本。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（本文命令按 Ubuntu 目录书写）；macOS 把 `/www/wwwroot/memos` 换成 `~/docker/memos` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 内存 | ≥ 512 MB（空闲约 50～80 MB） |
| CPU | 单核即可 |
| 磁盘 | ≥ 1 GB（镜像、SQLite 和附件） |
| 端口 | 宿主机 **5230** → 容器 **5230** |
| 工作目录 | `/www/wwwroot/memos` |

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

这次实测拉取的是 `stable`，启动日志写明 `Memos 0.29.1`。`stable` 会跟着当前稳定版移动，官方文档里的当前稳定版已经不是 0.29.1。下面的命令使用 `0.29.1`。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`0.29.1`** | 本文实测版本，日志与界面都是这个版本 | **是** |
| `stable` | 跟随当前稳定版，之后 pull 可能变成别的版本 | 否 |
| `0.29` | 这一条小版本上的滚动补丁 | 否 |
| `latest` | 浮动标签 | 否 |

完整标签见[标签列表](https://xuanyuan.cloud/r/neosmemo/memos/tags)。要离开 0.29.1，先看文末 FAQ 里的升级说明。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/neosmemo/memos:0.29.1
```

## Docker Compose 部署

笔记和附件在容器内 `/var/opt/memos`。删除容器不会删除宿主机上的 `data/`。删掉 `data/` 会丢掉全部笔记。

这次启动没有设置 `MEMOS_INSTANCE_URL`。只用服务器 IP 在内网访问时，保持不设置。已经有公网域名时，再在下面文件里写成那个 `https://` 地址，分享链接和登录 Cookie 才会对着这个域名。

1. 创建目录，并把所有权交给当前用户：

```bash
sudo mkdir -p /www/wwwroot/memos/data
sudo chown -R "$USER":"$USER" /www/wwwroot/memos
cd /www/wwwroot/memos
```

2. 写入 `compose.yaml`。`5230:5230` 表示宿主机 5230 对应容器内 5230。

```bash
cat > compose.yaml <<'EOF'
services:
  memos:
    image: docker.xuanyuan.run/neosmemo/memos:0.29.1
    container_name: memos
    restart: unless-stopped
    ports:
      - "5230:5230"
    volumes:
      - ./data:/var/opt/memos
    environment:
      MEMOS_PORT: 5230
      MEMOS_DRIVER: sqlite
EOF
```

| 配置 | 说明 |
|------|------|
| `5230:5230` | 宿主机 **5230** → 容器 **5230** |
| `./data` | SQLite 数据库和上传的附件 |
| `MEMOS_PORT` | 容器内 HTTP 端口，与上面的映射一致 |
| `MEMOS_DRIVER` | 本文使用 `sqlite` |
| `0.29.1` | 本文实测版本 |

3. 启动，并查看日志：

```bash
docker compose up -d
docker compose ps
docker compose logs memos
```

Ubuntu 24.04 上这次启动的日志类似：

```text
time=2026-06-28T05:11:44.804Z level=INFO msg="initializing new database with latest schema"
time=2026-06-28T05:11:44.826Z level=INFO msg="database initialized successfully" schemaVersion=0.28.1
Memos 0.29.1 started successfully!
Data directory: /var/opt/memos
Database driver: sqlite
Server running on port 5230
Access your memos at: http://localhost:5230
Happy note-taking!
```

看到 `Memos 0.29.1 started successfully!` 和 `Server running on port 5230`，服务已经起来。日志里的 `schemaVersion=0.28.1` 是这次初始化打出来的，旁边的程序版本仍是 0.29.1。

4. 在服务器本机探测页面：

```bash
curl -I http://127.0.0.1:5230
```

应返回 HTTP `200` 或 `302`。

首次打开浏览器、尚未登录时，日志里可能出现 `refresh token not found` 的 `client error`。这是未登录请求，不阻止后面的注册。

## 注册并切换中文

如果 5230 能从公网直接访问，先完成注册，再去做别的事。第一个注册成功的用户会成为站点管理员，Memos 没有预置的账号密码。

浏览器打开：

```text
http://你的服务器IP:5230
```

页面是创建账户。填写用户名和密码，点击「注册」。

![Memos 首次访问：创建账户页面，首个注册用户即为站点管理员](https://img.xuanyuan.dev/docker/blog/memos-1.png)

注册后进入主界面。左侧是日历、标签和导航，中间上方是输入框，下方是时间线。还没有笔记时，会显示「No data found.」。

![Memos 登录后主界面：空时间线与「Any thoughts...」输入框](https://img.xuanyuan.dev/docker/blog/memos-2.png)

默认界面是英文。点击左下角用户头像，打开「Language」，选择「简体中文」。

![Memos 切换语言：左下角用户菜单中的 Language 选项](https://img.xuanyuan.dev/docker/blog/memos-3.png)

切换后，搜索框是「搜索备忘录...」，输入框提示是「此刻的想法...」，标签区提示是「您可以通过输入 '#标签' 创建标签」。最后这句按界面原文保留。

## 写下第一条笔记

1. 在输入框写入内容，例如：

```markdown
记录我此时此刻的想法。
```

2. 点击「保存」。笔记按时间线出现在下方，可以在私有和公开之间切换。

![Memos 写第一条 memo：中文界面与时间线展示](https://img.xuanyuan.dev/docker/blog/memos-4.png)

正文里写 `#工作`、`#灵感` 会生成标签，点标签可以筛选。顶部搜索框按关键词查标题和正文。手机浏览器打开同一地址，也可以看这些笔记。

输入框左侧的「+」还可以插入别的内容：

| 菜单项 | 用途 |
|--------|------|
| Media | 插入图片、视频 |
| 录制音频 | 在浏览器里录音 |
| 文件 | 上传附件 |
| 链接备忘录 | 关联另一条笔记 |
| 添加位置 | 给这条笔记加上位置 |
| 更多 | 展开其余项 |

![Memos 输入框「+」菜单：Media、录制音频、文件、链接备忘录与添加位置](https://img.xuanyuan.dev/docker/blog/memos-6.png)

## 捷径过滤器

0.29.1 的界面里，左侧有「捷径」。点击「捷径」图标，再点「创建捷径」，可以用表达式筛选。下面三行是这次界面给出的示例：

| 示例 | 表达式 | 含义 |
|------|--------|------|
| 置顶 | `pinned` | 只显示置顶笔记 |
| 近 1 小时 | `created_ts >= now() - 60 * 60` | 最近一小时内创建的 |
| 工作标签 | `tag in ["work"]` | 含有这个标签 |

![Memos 捷径过滤器：创建自定义筛选表达式](https://img.xuanyuan.dev/docker/blog/memos-5.png)

更新版本把 Shortcut 迁到了 Views。本文没有在那些版本上重做这一屏。

## 备份与访问范围

定期备份 `/www/wwwroot/memos/data`。里面有 SQLite 数据库（例如 `memos_prod.db`）和上传的文件。升级前先备份这一份。

要对公网提供访问，把 Memos 放在 Nginx、Caddy 或 Traefik 后面，由代理终止 TLS，并转发 `Host`、`X-Forwarded-Proto`、`X-Forwarded-For`。同时把 `MEMOS_INSTANCE_URL` 设成对外的 `https://` 地址。步骤见[反向代理文档](https://usememos.com/docs/deploy/reverse-proxy)。本文这次启动没有加反向代理。

只有确定要让 5230 从外网直接访问时，才放行端口：

```bash
sudo ufw allow 5230/tcp
```

云服务器还要在安全组放行。更稳妥的做法是 5230 只留在内网，公网走反向代理。

## 常用环境变量

这次 Compose 只写了端口和 SQLite。其余变量保持镜像默认。

| 变量 | 本文情况 | 用途 |
|------|----------|------|
| `MEMOS_PORT` | 设为 `5230`，与日志一致 | 容器内 HTTP 端口 |
| `MEMOS_ADDR` | 未设置 | 绑定地址。空着表示所有网卡 |
| `MEMOS_DATA` | 未设置；日志为 `/var/opt/memos` | 数据目录 |
| `MEMOS_DRIVER` | 设为 `sqlite` | 也可改为 `postgres` 或 `mysql` |
| `MEMOS_DSN` | 使用 SQLite 时不用填 | 外部数据库连接串 |
| `MEMOS_INSTANCE_URL` | 未设置 | 对外使用的 https 地址 |
| `MEMOS_LOG_LEVEL` | 未设置 | `debug`、`info`、`warn`、`error` |

官方文档里，0.31 起实例地址和「是否允许匿名访问」要分开设置。本文实测的是 0.29.1，没有覆盖这项。

## 备选：docker run

机器上没有 Docker Compose，或只想临时起一个容器时，用下面的命令。目录、端口和镜像与「Docker Compose 部署」相同。容器名已经是 `memos` 时不要再执行，否则名称冲突。

目录还没建好时，先执行「Docker Compose 部署」里创建目录的命令。

```bash
docker run -d 
  --name memos 
  --restart unless-stopped 
  -p 5230:5230 
  -v /www/wwwroot/memos/data:/var/opt/memos 
  docker.xuanyuan.run/neosmemo/memos:0.29.1
```

然后用 `docker logs memos` 确认 `Memos 0.29.1 started successfully!`，再用 `curl -I http://127.0.0.1:5230` 探测。

## 常见问题

**Q1：5230 端口被占用怎么办？**

把宿主机端口改成别的，容器内仍是 5230。例如改成 8080 时，Compose 里写成 `"8080:5230"`，再执行 `docker compose up -d`。浏览器访问 `http://服务器IP:8080`。

用 `docker run` 启动时，把 `-p 5230:5230` 改成 `-p 8080:5230`。

**Q2：数据存在哪里？**

在宿主机 `/www/wwwroot/memos/data`，对应容器内 `/var/opt/memos`。这里有 SQLite 数据库和上传的附件。升级时不要删除这个目录。

**Q3：如何升级？**

先备份 `/www/wwwroot/memos/data`。本文命令固定为 `0.29.1`。官方说明，0.22 到 0.30 不能直接装到最新月度版本，需要先升到 `0.31.0` 并成功启动。新版本一旦跑过数据库迁移，旧版本不能再打开这个库，回退只能靠这份备份。

本文没有做这次升级，也没有重走注册和写笔记。要升的话，先读[升级文档](https://usememos.com/docs/operations/upgrade)，再改 `compose.yaml` 里的标签，然后执行：

```bash
cd /www/wwwroot/memos
docker compose pull
docker compose up -d
```

**Q4：日志里出现 `refresh token not found` 正常吗？**

本文在首次打开页面、尚未登录时见过这条 `client error`。它不阻止注册和登录。

**Q5：忘记密码怎么办？**

注册页没有「忘记密码」邮件。本文不另给数据库重置步骤。注册时用强密码，并另行保存。5230 若能从公网访问，注册完成前不要长时间敞开。

**Q6：和 Docker Hub 上的镜像是什么关系？**

本文使用的 `neosmemo/memos:0.29.1` 与 Docker Hub 上的同名标签是同一份镜像，通过轩辕镜像加速拉取。数据目录和端口见[官方 Docker 文档](https://usememos.com/docs/deploy/docker)。

**Q7：可以多人使用，或者换成 PostgreSQL 吗？**

可以有多个用户，管理员在设置里管理。本文用 SQLite 完成了注册和写笔记。用户变多、要单独备份数据库时，官方 Docker 文档支持把 `MEMOS_DRIVER` 改成 `postgres` 或 `mysql`，并填写 `MEMOS_DSN`。`./data` 仍要保留，里面有本地附件。本文没有部署这两类数据库。

**Q8：如何停止与卸载？**

确认不再需要这些笔记之前，不要删除数据目录。

Compose 停止并保留 `data/`：

```bash
cd /www/wwwroot/memos
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop memos && docker rm memos
```

笔记都不再需要时，再删除数据目录：

```bash
rm -rf /www/wwwroot/memos/data
```

**Q9：容器起来了，浏览器打不开？**

按这个顺序看：

1. `docker ps` 里容器是否为 Up。
2. `docker logs memos` 里是否有 `Server running on port 5230`，以及有没有报错。
3. 在服务器上执行 `curl -I http://127.0.0.1:5230`，看本机是否通。
4. 本机通、外网不通时，再检查云服务器安全组和本机防火墙是否放行了你映射的端口。

## 命令速查

```bash
docker pull docker.xuanyuan.run/neosmemo/memos:0.29.1

cd /www/wwwroot/memos
docker compose up -d
docker compose ps
docker compose logs memos
curl -I http://127.0.0.1:5230

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://服务器IP:5230`。第一个注册的用户是管理员。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [neosmemo/memos 镜像页](https://xuanyuan.cloud/zh/r/neosmemo/memos) | [https://xuanyuan.cloud/zh/r/neosmemo/memos](https://xuanyuan.cloud/zh/r/neosmemo/memos) |
| [neosmemo/memos 概览](https://xuanyuan.cloud/r/neosmemo/memos) | [https://xuanyuan.cloud/r/neosmemo/memos](https://xuanyuan.cloud/r/neosmemo/memos) |
| [neosmemo/memos 标签列表](https://xuanyuan.cloud/r/neosmemo/memos/tags) | [https://xuanyuan.cloud/r/neosmemo/memos/tags](https://xuanyuan.cloud/r/neosmemo/memos/tags) |
| [Docker Hub · neosmemo/memos](https://hub.docker.com/r/neosmemo/memos) | [https://hub.docker.com/r/neosmemo/memos](https://hub.docker.com/r/neosmemo/memos) |
| [GitHub · usememos/memos](https://github.com/usememos/memos) | [https://github.com/usememos/memos](https://github.com/usememos/memos) |
| [Release v0.29.1](https://github.com/usememos/memos/releases/tag/v0.29.1) | [https://github.com/usememos/memos/releases/tag/v0.29.1](https://github.com/usememos/memos/releases/tag/v0.29.1) |
| [v0.29.1 更新说明](https://usememos.com/changelog/0-29-1) | [https://usememos.com/changelog/0-29-1](https://usememos.com/changelog/0-29-1) |
| [Memos 文档](https://usememos.com/docs) | [https://usememos.com/docs](https://usememos.com/docs) |
| [Docker 部署](https://usememos.com/docs/deploy/docker) | [https://usememos.com/docs/deploy/docker](https://usememos.com/docs/deploy/docker) |
| [Docker Compose](https://usememos.com/docs/deploy/docker-compose) | [https://usememos.com/docs/deploy/docker-compose](https://usememos.com/docs/deploy/docker-compose) |
| [反向代理](https://usememos.com/docs/deploy/reverse-proxy) | [https://usememos.com/docs/deploy/reverse-proxy](https://usememos.com/docs/deploy/reverse-proxy) |
| [升级说明](https://usememos.com/docs/operations/upgrade) | [https://usememos.com/docs/operations/upgrade](https://usememos.com/docs/operations/upgrade) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/docker-memos


