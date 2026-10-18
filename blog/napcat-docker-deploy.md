# Docker 部署 NapCat：轻松搭建 QQ Bot 协议端平台

![Docker 部署 NapCat：轻松搭建 QQ Bot 协议端平台](https://imgs.xuanyuan.cloud/docker/blog/napcat1.webp)

*分类: Docker部署教程 | 标签: NapCat,NapCatQQ,mlikiowa/napcat-docker,Docker,轩辕镜像,OneBot,QQ Bot,协议端,私有化部署,部署教程 | 发布时间: 2026-10-16 11:09:41*

> NapCat 是一款面向要在自己机器上收发 QQ 消息的人的开源 Bot 协议端，旨在把登录态和 OneBot 接口留在本机，并通过 WebUI 管理网络配置。本文将介绍如何通过 Docker Compose 部署 NapCat，搭建自托管 QQ 协议端，帮助把机器人协议层留在自己的服务器上，适合内网联调及常驻网关等场景。

*本文基于 [mlikiowa/napcat-docker:v4.18.28](https://xuanyuan.cloud/zh/r/mlikiowa/napcat-docker)，以 **v4.18.28** 版本实测，测试平台 **Ubuntu 24.04** Linux。*

## NapCat 是什么

NapCat（NapCatQQ）是 NapNeko 维护的开源 Bot 协议端，基于 NTQQ 实现。它在本机提供 WebUI 和 OneBot 接口，用来登录一个 QQ 号，并把收发消息交给后面的应用或脚本。

和把协议栈、应用、日志放在同一台开发机上不同，NapCat 只负责登录和协议。聊天逻辑留在 AstrBot、Koishi、NoneBot，或你自己的程序里。

## NapCat 能做什么

- **扫码登录**：在日志或 WebUI 里完成 QQ 登录，登录态保存在本机。
- **主动发消息**：通过 OneBot HTTP 接口发送私聊和群聊。
- **接收事件**：把群消息和私聊上报到你指定的地址。
- **对接框架**：按 OneBot 接入 AstrBot、Koishi、NoneBot 等。
- **常驻运行**：面向低内存环境长时间运行协议端。

## 为什么要使用 NapCat

在 Windows 上解压 Shell，还要跟着 QQ 的版本走，升级一次就要重来。协议端和应用放在同一台开发机上时，登录态、日志和插件目录会混在一起。把账号交给第三方托管，群聊内容也会离开自己的机器。

NapCat 把协议端留在自己的服务器或 NAS 上。适合要自己收发 QQ 消息的人，也适合把机器人接口留在内网的团队。

## 使用 Docker 部署 NapCat

NapCat 可以用 Docker 跑起来，宿主机不必再装一套 NTQQ 和 Shell。开始之前准备好 Docker，以及一个可以登录的 QQ 号。

下面用 Docker Compose 启动服务，扫码登录，并在浏览器里打开 WebUI。

## 环境要求

本文命令使用 **`mlikiowa/napcat-docker:v4.18.28`**。这个标签在 Ubuntu 24.04 上完成拉取、启动和扫码。日志里的版本是 NapCat 4.18.28。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）；macOS 把 `/www/wwwroot/napcat` 换成 `~/docker/napcat`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | Docker Hub 上 `v4.18.28` 包含 linux/amd64、linux/arm64 |
| 内存 | 官方 Docker 说明没有最低内存。后面接的应用框架另占内存 |
| 磁盘 | Docker Hub 列出的 linux/amd64 大小约 597 MB。本次 `docker images` 显示 DISK 2.12GB / CONTENT 597MB。QQ 缓存另计 |
| 端口 | 宿主机 **13300** → 容器 **3000**；**3001** → **3001**；**6099** → **6099** |
| 工作目录 | `/www/wwwroot/napcat` |
| 挂载 | `config/` → `/app/napcat/config`；`QQ/` → `/app/.config/QQ`；`plugins/` → `/app/napcat/plugins` |
| 账号 | 可以登录的 QQ。建议用专用小号 |

只在本机打开 WebUI 时用 `http://127.0.0.1:6099/webui`。给别人用、或放到公网时，在前面加 HTTPS，并限制来源。OneBot 口同样不要直接暴露。

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

[NapCat-Docker 说明](https://github.com/NapNeko/NapCat-Docker)里的示例写的是 `latest`。Docker Hub 上，`latest` 与 **`v4.18.37`** 在 2026-10-10 指向同一份镜像。`latest` 以后会变，本文命令使用已经实测的 **`v4.18.28`**。

GitHub 上的 [v4.18.38](https://github.com/NapNeko/NapCatQQ/releases/tag/v4.18.38) 已经发布。Docker Hub 还没有同名标签，不要把它写进 `docker pull`。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`v4.18.28`** | 本文实测版本。日志为 NapCat.Core 4.18.28 | **是** |
| `v4.18.37` | 2026-10-10 与 `latest` 相同 | 否 |
| `latest` | 现在等于 `v4.18.37`，以后会变 | 否 |
| `v4.18.27` 等更早标签 | 可用来回退 | 否 |
| `v4.18.38` | 只有 GitHub Release，Docker Hub 没有这个标签 | 否 |
| `pr-*` | 构建预览 | 否 |

同作者还有 `napcat-framework-docker` 等镜像。本文只部署 `mlikiowa/napcat-docker`。

完整标签见[标签列表](https://xuanyuan.cloud/r/mlikiowa/napcat-docker/tags)。升级前对照 [Releases](https://github.com/NapNeko/NapCatQQ/releases)，并确认 Docker Hub 上有这个标签。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/mlikiowa/napcat-docker:v4.18.28
```

Ubuntu 24.04 上拉取结束时：

```text
Digest: sha256:2cc70b45244ae3fabc657ffc3aaa4de8fb893518171e519659ab83d80e6d36b5
Status: Downloaded newer image for docker.xuanyuan.run/mlikiowa/napcat-docker:v4.18.28
docker.xuanyuan.run/mlikiowa/napcat-docker:v4.18.28
```

```text
IMAGE                                                 ID             DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/mlikiowa/napcat-docker:v4.18.28   2cc70b45244a       2.12GB          597MB
```

## Docker Compose 部署

[上游 Compose 示例](https://github.com/NapNeko/NapCat-Docker)把 WebUI **6099** 和 WebSocket **3001** 绑在 `127.0.0.1`，默认不映射 HTTP。本文把三个口都映射出来，方便在局域网打开 WebUI，并用 curl 发消息。容器内 HTTP 仍是 **3000**，宿主机用 **13300**，避免占用本机 3000。

上游说明：`WEBUI_TOKEN` 和 `MODE` 只在对应配置还不存在时写入。`config/` 里已经有配置时，在 WebUI 里改。HTTP 服务端在启动后于「发消息与事件上报」里新建并启用。

以前用 `docker run` 创建过同名容器时，先删掉容器再启动 Compose。`docker rm` 不删除 `config/` 和 `QQ/`。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/napcat/{config,QQ,plugins}
sudo chown -R "$USER":"$USER" /www/wwwroot/napcat
cd /www/wwwroot/napcat
```

macOS 把路径换成 `~/docker/napcat`。

同名容器还在时：

```bash
docker rm -f napcat
```

2. 看一下当前用户的 UID 和 GID。root 下常见 `0` 和 `0`，可以继续。普通用户要能写 `config/` 和 `QQ/`。

```bash
export NAPCAT_UID=$(id -u)
export NAPCAT_GID=$(id -g)
echo "UID=$NAPCAT_UID GID=$NAPCAT_GID"
```

3. 写入 `compose.yaml`。把 `WEBUI_TOKEN` 换成你自己的口令。

```bash
cd /www/wwwroot/napcat
cat > compose.yaml <<'EOF'
services:
  napcat:
    image: docker.xuanyuan.run/mlikiowa/napcat-docker:v4.18.28
    container_name: napcat
    restart: unless-stopped
    environment:
      - NAPCAT_UID=${NAPCAT_UID:-1000}
      - NAPCAT_GID=${NAPCAT_GID:-1000}
      - WEBUI_TOKEN=ChangeMeStrongToken
      - TZ=Asia/Shanghai
    ports:
      - "13300:3000"
      - "3001:3001"
      - "6099:6099"
    volumes:
      - ./config:/app/napcat/config
      - ./QQ:/app/.config/QQ
      - ./plugins:/app/napcat/plugins
EOF
```

| 项 | 含义 |
|----|------|
| `13300:3000` | OneBot HTTP。宿主机避开 3000 |
| `3001:3001` | OneBot WebSocket |
| `6099:6099` | WebUI |
| `./config` | NapCat 配置，对应容器 `/app/napcat/config` |
| `./QQ` | QQ 登录态与缓存，对应容器 `/app/.config/QQ` |
| `./plugins` | 插件。目录可以先空着 |
| `WEBUI_TOKEN` | 第一次生成 WebUI 配置时的口令 |
| `NAPCAT_UID` / `NAPCAT_GID` | 容器内写挂载目录的用户。群晖还要在文件管理器里给目录读写权限 |

4. 启动容器：

```bash
cd /www/wwwroot/napcat
NAPCAT_UID=$(id -u) NAPCAT_GID=$(id -g) docker compose up -d
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network napcat_default Created
 ✔ Container napcat       Started
```

5. 查看状态，并跟随日志：

```bash
docker compose ps
docker compose logs -f --tail=80 napcat
```

`docker compose ps` 实测：

```text
NAME      IMAGE                                                 COMMAND                SERVICE   CREATED         STATUS         PORTS
napcat    docker.xuanyuan.run/mlikiowa/napcat-docker:v4.18.28   "bash entrypoint.sh"   napcat    8 seconds ago   Up 6 seconds   0.0.0.0:3001->3001/tcp, 0.0.0.0:6099->6099/tcp, 0.0.0.0:13300->3000/tcp
```

日志里应出现版本、WebUI 地址和二维码。下面的 Token 已换成占位。无头环境里常见的 dbus、EGL 报错可以先忽略，Core 仍会继续启动。

```text
正在配置 WebUI Token...
NapCat Shell App Loading...
[NapCat] [Core] NapCat.Core Version: 4.18.28
[NapCat] [WebUi] WebUi Token: <你的 WEBUI_TOKEN>
[NapCat] [WebUi] WebUi User Panel Url: http://0.0.0.0:6099/webui?token=<你的 WEBUI_TOKEN>
等待网络连接...
网络已连接
没有 -q 指令指定快速登录，将使用二维码登录方式
请扫描下面的二维码，然后在手Q上授权登录：
二维码已保存到 /app/napcat/cache/qrcode.png
[Core] [Login] 二维码已被扫描，等待确认...
[AdapterManager] OneBot11 适配器初始化完成
[AdapterManager] 协议适配器初始化完成，已加载 2 个适配器
```

控制台二维码不好扫时，把图片拷出来：

```bash
docker cp napcat:/app/napcat/cache/qrcode.png /tmp/napcat-qrcode.png
```

日志里的解码 URL 含登录凭证，不要外传。`Ctrl+C` 只退出跟随日志，容器继续跑。

## 打开 WebUI

浏览器打开：

```text
http://服务器IP:6099/webui
```

或带上口令：

```text
http://服务器IP:6099/webui?token=ChangeMeStrongToken
```

用 `WEBUI_TOKEN` 进入面板。前面已经扫码成功时，打开后多半已经在线。也可以在「快速登录」里选已有 QQ，或改用扫码、密码登录：

![NapCat WebUI 快速登录：选择 QQ 账号](https://imgs.xuanyuan.cloud/docker/blog/napcat-1.webp)

「基础信息」可以核对 NapCat **4.18.28**、QQ 版本和当前网络配置数量：

![NapCat WebUI 基础信息：版本与系统状态](https://imgs.xuanyuan.cloud/docker/blog/napcat-2.webp)

侧栏可以再看「关于我们」「插件商店」，以及「系统配置」里的 OneBot。发消息和事件上报以「发消息与事件上报」为准：

![NapCat WebUI 关于我们：Core 4.18.28](https://imgs.xuanyuan.cloud/docker/blog/napcat-5.webp)

![NapCat WebUI 插件商店：插件列表](https://imgs.xuanyuan.cloud/docker/blog/napcat-3.webp)

![NapCat WebUI 系统配置：OneBot 选项](https://imgs.xuanyuan.cloud/docker/blog/napcat-4.webp)

公网访问时限制 **6099** 的来源，或放到 HTTPS 反代后面。OneBot 口同样不要直接暴露。

## 发消息与事件上报

WebUI 用来登录和改网络配置。主动发消息走 HTTP 服务端。要把群消息推到你自己的服务，再加 HTTP 客户端。

| 类型 | 方向 | 用途 |
|------|------|------|
| HTTP 服务端（宿主机 **13300**） | 你 → NapCat | `curl` 或框架发消息、查列表 |
| HTTP 客户端 | NapCat → 你的 URL | 群消息、私聊 POST 到 webhook |
| WebSocket **3001** | 双向 | 正向 WebSocket，部分框架使用 |

文档：[WebUI 配置](https://napneko.github.io/config/basic) · [API 一览](https://napneko.github.io/onebot/api) · [Apifox 用例](https://napcat.apifox.cn)

### 启用 HTTP 服务端

Compose 已经映射 **13300→3000**。还要在 WebUI 里新建并启用 HTTP 服务器，接口才会监听。

1. 打开「网络配置」，点「新建」，选择「HTTP 服务器」。

![NapCat 网络配置：新建菜单里选择 HTTP 服务器](https://imgs.xuanyuan.cloud/docker/blog/napcat-6.webp)

2. 填写 `Host=0.0.0.0`、`Port=3000`。消息格式可以选 Array。打开「启用」。放到公网时填写鉴权 Token。这个 Token 和 `WEBUI_TOKEN` 可以不同。

![NapCat HTTP 服务器：启用，端口 3000](https://imgs.xuanyuan.cloud/docker/blog/napcat-7.webp)

3. 保存。列表里出现已启用的卡片。探测地址是 `http://服务器IP:13300`。

![NapCat 网络配置：HTTP 服务器卡片已启用](https://imgs.xuanyuan.cloud/docker/blog/napcat-8.webp)

### 用 curl 发私聊和群聊

在本机，或在能访问 **13300** 的机器上执行。还没填 HTTP Token 时，可以先去掉 `Authorization`，只在内网试通。

```bash
# 私聊
curl -sS -X POST 'http://127.0.0.1:13300/send_private_msg' 
  -H 'Content-Type: application/json' 
  -H 'Authorization: Bearer 你的HTTP鉴权token' 
  -d '{"user_id":好友QQ号,"message":"你好，来自 NapCat"}'

# 群聊
curl -sS -X POST 'http://127.0.0.1:13300/send_group_msg' 
  -H 'Content-Type: application/json' 
  -H 'Authorization: Bearer 你的HTTP鉴权token' 
  -d '{"group_id":群号,"message":"大家好，来自 NapCat"}'
```

成功时一般返回 `status: ok` 和 `message_id`。也可以先调用 `get_friend_list`、`get_group_list`，再发消息。连不上时检查：HTTP 服务器是否启用、容器端口是否为 **3000**、Token 是否一致。

### 启用 HTTP 客户端

| | HTTP 服务端 | HTTP 客户端 |
|--|-------------|-------------|
| 方向 | 你调 NapCat | NapCat 调你 |
| URL | 不用填。它监听容器内 3000 | 填接收方的完整 webhook |

上报地址填接收方给的 URL，包含密钥。不要填 `6099` 或 `13300`，也不要填容器访问不到的 `http://localhost:...`。

1. 打开「网络配置」，点「新建」，选择「HTTP 客户端」。

![NapCat 网络配置：新建菜单里选择 HTTP 客户端](https://imgs.xuanyuan.cloud/docker/blog/napcat-9.webp)

2. 打开「启用」。名称自定。把 webhook 粘贴到 URL。消息格式用 `string` 或 `array`。关闭「上报自身消息」，避免消息循环。

![NapCat HTTP 客户端：填写 URL，关闭上报自身消息](https://imgs.xuanyuan.cloud/docker/blog/napcat-10.webp)

3. 保存。列表里应同时看到 HTTP 服务器和 HTTP 客户端，并且都是启用。在群里发一条消息做测试。接收方要回复时，再回调 **13300**。

![NapCat 网络配置：HTTP 服务器与 HTTP 客户端都已启用](https://imgs.xuanyuan.cloud/docker/blog/napcat-11.webp)

上报失败时看 NapCat 日志里的超时、4xx、5xx，并确认容器能访问接收方。能收到事件但回不了消息时，检查接收方有没有成功调用 HTTP 服务端。

### 对接应用框架

接入步骤见 [接入框架](https://napneko.github.io/use/integration)。文档里的例子包括 NoneBot、Koishi 和 AstrBot。和 NapCat 在同一个 Compose 网络里时，用服务名互访，不要写宿主机映射端口。模板见 [NapCat-Docker/compose](https://github.com/NapNeko/NapCat-Docker/tree/main/compose)，其中有 [AstrBot](https://github.com/NapNeko/NapCat-Docker/blob/main/compose/astrbot.yml) 和 [Koishi](https://github.com/NapNeko/NapCat-Docker/blob/main/compose/koishi-compose.yml)。

## 升级与备份

登录态在 `QQ/`，网络配置在 `config/`。升级前先停容器，再备份这两个目录。需要保留插件时，把 `plugins/` 一起打包。

```bash
cd /www/wwwroot/napcat
docker compose stop
```

把 `compose.yaml` 里的标签改成新的具体版本，不要改成 `latest`。先确认 [标签列表](https://xuanyuan.cloud/r/mlikiowa/napcat-docker/tags) 里有这个标签，再执行：

```bash
docker compose pull
NAPCAT_UID=$(id -u) NAPCAT_GID=$(id -g) docker compose up -d
```

不要删除 `config/` 和 `QQ/`。升级后看日志里的版本号，打开 WebUI，再用 curl 发一条消息。跨版本先读 [Releases](https://github.com/NapNeko/NapCatQQ/releases)。WebUI 端口被占用时，可能会自动加 1，以日志里的地址为准。

## 备选：docker run

没有 Compose 时用下面的命令。长期运行仍用「Docker Compose 部署」。

```bash
mkdir -p /www/wwwroot/napcat/{config,QQ,plugins}

docker run -d 
  --name napcat 
  --restart unless-stopped 
  -e NAPCAT_UID=$(id -u) 
  -e NAPCAT_GID=$(id -g) 
  -e WEBUI_TOKEN=ChangeMeStrongToken 
  -e TZ=Asia/Shanghai 
  -p 13300:3000 
  -p 3001:3001 
  -p 6099:6099 
  -v /www/wwwroot/napcat/config:/app/napcat/config 
  -v /www/wwwroot/napcat/QQ:/app/.config/QQ 
  -v /www/wwwroot/napcat/plugins:/app/napcat/plugins 
  docker.xuanyuan.run/mlikiowa/napcat-docker:v4.18.28
```

```bash
docker logs -f --tail=80 napcat
```

## 常见问题

**Q1：该用哪个版本？**

本文命令使用 **`v4.18.28`**。不要写 `latest`。Docker Hub 上 `latest` 在 2026-10-10 等于 `v4.18.37`，以后会变。GitHub 的 v4.18.38 还没有同名 Docker 标签。

**Q2：为什么宿主机不用 3000？**

本系列避开宿主机 **3000**，减少和本机其它服务冲突。容器内仍是 3000，对外是 **`13300:3000`**。

**Q3：WebUI Token 和 HTTP Token 一样吗？**

不必相同。`WEBUI_TOKEN` 用来进面板。HTTP 服务器配置里的 Token 用来填 `Authorization: Bearer …`。

**Q4：登录后能在 WebUI 里直接发消息吗？**

WebUI 没有聊天窗。先按「启用 HTTP 服务端」打开接口，再用 curl，或接 AstrBot 等框架。

**Q5：HTTP 客户端的 URL 填什么？**

填接收方 webhook 的完整地址。不要填 `6099` 或 `13300`。容器访问不到的 `localhost` 也不要填。

**Q6：curl 13300 失败？**

检查 HTTP 服务器是否启用、容器端口是否为 **3000**、Token 是否一致。不要把 6099 当成 API 口。

**Q7：日志里有 dbus、EGL、GPU 报错？**

无头容器里常见。Core 已经打印版本号，并且能扫码时，可以忽略这些显示相关报错。

**Q8：控制台二维码扫不上？**

执行 `docker cp napcat:/app/napcat/cache/qrcode.png /tmp/napcat-qrcode.png`。日志里的解码 URL 含登录凭证，不要外传。

**Q9：permission denied？**

核对 `NAPCAT_UID` 和 `NAPCAT_GID`，并确认 `config/`、`QQ/` 允许这个用户读写。群晖等 NAS 还要在文件管理器里给挂载目录授权。

**Q10：要不要设置 MODE？**

上游示例用 `MODE=ws`，只在还没有网络配置时写入正向 WebSocket。`config/` 里已经有配置后，到 WebUI 的「网络配置」里改。本文的发消息步骤在 WebUI 里新建 HTTP 服务端。

**Q11：6099 和 13300 能对公网直接开放吗？**

不要长期裸开。使用强 Token，并限制来源，或放到 HTTPS 反代后面。

**Q12：使用上有什么限制？**

官方仓库说明：用于提高易用性、实现消息推送，使用须遵守当地法律法规。建议用专用小号，只在合法、已授权的场景使用。

## 命令速查

```bash
docker pull docker.xuanyuan.run/mlikiowa/napcat-docker:v4.18.28

cd /www/wwwroot/napcat
NAPCAT_UID=$(id -u) NAPCAT_GID=$(id -g) docker compose up -d
docker compose ps
docker compose logs -f --tail=80 napcat

curl -sS -X POST 'http://127.0.0.1:13300/send_private_msg' 
  -H 'Content-Type: application/json' 
  -H 'Authorization: Bearer 你的HTTP鉴权token' 
  -d '{"user_id":好友QQ号,"message":"你好"}'
curl -sS -X POST 'http://127.0.0.1:13300/send_group_msg' 
  -H 'Content-Type: application/json' 
  -H 'Authorization: Bearer 你的HTTP鉴权token' 
  -d '{"group_id":群号,"message":"大家好"}'

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://127.0.0.1:6099/webui`。发消息前先在 WebUI 启用 HTTP 服务端，再访问宿主机 **13300**。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [mlikiowa/napcat-docker 镜像页](https://xuanyuan.cloud/zh/r/mlikiowa/napcat-docker) | [https://xuanyuan.cloud/zh/r/mlikiowa/napcat-docker](https://xuanyuan.cloud/zh/r/mlikiowa/napcat-docker) |
| [mlikiowa/napcat-docker 概览](https://xuanyuan.cloud/r/mlikiowa/napcat-docker) | [https://xuanyuan.cloud/r/mlikiowa/napcat-docker](https://xuanyuan.cloud/r/mlikiowa/napcat-docker) |
| [mlikiowa/napcat-docker 标签列表](https://xuanyuan.cloud/r/mlikiowa/napcat-docker/tags) | [https://xuanyuan.cloud/r/mlikiowa/napcat-docker/tags](https://xuanyuan.cloud/r/mlikiowa/napcat-docker/tags) |
| [Docker Hub · mlikiowa/napcat-docker](https://hub.docker.com/r/mlikiowa/napcat-docker) | [https://hub.docker.com/r/mlikiowa/napcat-docker](https://hub.docker.com/r/mlikiowa/napcat-docker) |
| [GitHub · NapCatQQ](https://github.com/NapNeko/NapCatQQ) | [https://github.com/NapNeko/NapCatQQ](https://github.com/NapNeko/NapCatQQ) |
| [GitHub · NapCat-Docker](https://github.com/NapNeko/NapCat-Docker) | [https://github.com/NapNeko/NapCat-Docker](https://github.com/NapNeko/NapCat-Docker) |
| [NapCat 文档站](https://napneko.github.io/) | [https://napneko.github.io/](https://napneko.github.io/) |
| [WebUI 配置指南](https://napneko.github.io/config/basic) | [https://napneko.github.io/config/basic](https://napneko.github.io/config/basic) |
| [OneBot API 一览](https://napneko.github.io/onebot/api) | [https://napneko.github.io/onebot/api](https://napneko.github.io/onebot/api) |
| [接入框架](https://napneko.github.io/use/integration) | [https://napneko.github.io/use/integration](https://napneko.github.io/use/integration) |
| [API 完整用例 · Apifox](https://napcat.apifox.cn) | [https://napcat.apifox.cn](https://napcat.apifox.cn) |
| [Releases](https://github.com/NapNeko/NapCatQQ/releases) | [https://github.com/NapNeko/NapCatQQ/releases](https://github.com/NapNeko/NapCatQQ/releases) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

[https://xuanyuan.cloud/blog/napcat-docker-deploy](https://xuanyuan.cloud/blog/napcat-docker-deploy)


