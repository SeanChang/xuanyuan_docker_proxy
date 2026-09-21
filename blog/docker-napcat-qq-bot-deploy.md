# Docker 部署 NapCat：轻松搭建 QQ Bot 协议端平台

![Docker 部署 NapCat：轻松搭建 QQ Bot 协议端平台](https://imgs.xuanyuan.cloud/docker/blog/napcat.webp)

*分类: Docker部署教程 | 标签: NapCat,NapCatQQ,mlikiowa/napcat-docker,Docker,轩辕镜像,OneBot,QQ Bot,协议端,私有化部署,部署教程 | 发布时间: 2026-09-20 15:59:27*

> NapCat 是基于 NTQQ 的现代化 Bot 协议端，兼容 OneBot 接口，可对接 AstrBot、Koishi 等应用框架。本文将介绍如何通过 Docker Compose 部署社区镜像 mlikiowa/napcat-docker，用轩辕镜像加速拉取，适合自托管 QQ 机器人协议层、内网联调与常驻网关等场景。

*本文基于 [mlikiowa/napcat-docker:v4.18.28](https://xuanyuan.cloud/zh/r/mlikiowa/napcat-docker)，跟做引擎 **NapCat v4.18.28**，测试平台 **Ubuntu 24.04** Linux。*

群里要挂一个能收发消息的机器人：有人在 Windows 上解压 Shell 包、对齐 QQ 版本，升级一次就重来；有人把协议端和应用层糊在同一台开发机，调试日志、登录态、插件目录搅在一起。换 Linux 服务器后，无头环境、依赖和权限又要重踩一遍。

放到第三方托管 Bot，账号与群聊内容都出域；内网脚本、运维告警、知识库问答本来就不该默认经过公网中转。很多机房或 NAS 上已经有一台跑 Docker 的 Ubuntu，缺的是：**协议端镜像能拉、登录态落本机、浏览器打开 WebUI 就能扫码，再把 OneBot 口交给应用框架或自己的脚本**。

**NapCat**（[GitHub · NapNeko/NapCatQQ](https://github.com/NapNeko/NapCatQQ)、[文档站](https://napneko.github.io/)）是基于 **NTQQ** 的 Bot **协议端**：提供 WebUI 与 OneBot 标准接口，可对接 [AstrBot](https://github.com/AstrBotDevs/AstrBot)、Koishi、NoneBot 等。本文跟做 **`mlikiowa/napcat-docker`**（[镜像页](https://xuanyuan.cloud/r/mlikiowa/napcat-docker)、[Docker 说明](https://github.com/NapNeko/NapCat-Docker)）：容器内 WebUI **6099**，OneBot HTTP / WS 常见为 **3000 / 3001**；配置与 QQ 数据分别在 **`/app/napcat/config`**、**`/app/.config/QQ`**。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 登录账号 | 日志二维码扫码，或 WebUI 快速登录 / 扫码 |
| 主动发消息 | 启用 HTTP **服务端**后，对宿主机 **13300** 调 `send_private_msg` / `send_group_msg` |
| 实时收事件 | 启用 HTTP **客户端**，把群消息 POST 到你的 webhook |
| 对接框架 | AstrBot / Koishi 等连 **13300** 或 **3001** |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`mlikiowa/napcat-docker:v4.18.28`**，**Docker Compose** 启动。把下文 IP、Token、QQ 号换成你的。无 Compose 见第七节。

> **上手要点**
> - **主路径**：第四节 Compose；备选 `docker run` 见第七节
> - **标签**：跟做 **`v4.18.28`**；勿写 `latest`
> - **挂载**：`./config`→`/app/napcat/config`；`./QQ`→`/app/.config/QQ`；可选 `./plugins`
> - **端口**：宿主机 **13300**→容器 **3000**；**3001**→**3001**；**6099**→**6099**（勿占宿主机 3000）
> - **权限**：`NAPCAT_UID` / `NAPCAT_GID` 用 `$(id -u)` / `$(id -g)`（root 时为 **0/0**）
> - **两套口令**：`WEBUI_TOKEN` 进管理面板；HTTP 服务端另设鉴权 Token（可与前者不同）
> - **发消息**：先在「网络配置」启用 HTTP 服务端，再对 **13300** 调接口（WebUI 不是聊天窗）
> - **启动标志**：`NapCat.Core Version: 4.18.28`、`网络已连接`、出现二维码或 WebUI 地址
> - **体积**：DISK **2.12GB** / CONTENT **597MB**
> - **目录**：Linux `/www/wwwroot/napcat`；macOS `~/docker/napcat`
> - **合规**：合法授权场景；建议小号；遵守当地法规与平台条款

官方：[NapCatQQ](https://github.com/NapNeko/NapCatQQ) · [NapCat-Docker](https://github.com/NapNeko/NapCat-Docker) · [文档](https://napneko.github.io/) · [镜像页](https://xuanyuan.cloud/r/mlikiowa/napcat-docker) · [标签列表](https://xuanyuan.cloud/r/mlikiowa/napcat-docker/tags) · [Docker Hub](https://hub.docker.com/r/mlikiowa/napcat-docker)

---

## 一、mlikiowa/napcat-docker 是什么？

把 NapCat 打成可拉取镜像：协议端与 WebUI 跑在容器里，配置与 QQ 登录态挂到宿主机，对外提供 OneBot 端口。和本机 Shell / AppImage 比，更适合服务器、NAS 上「协议层单独常驻」。

| | 本文镜像 | 本机 Shell / AppImage | 云端托管 Bot |
|--|----------|----------------------|--------------|
| 形态 | Docker 镜像 | 本机进程 + QQ 环境 | SaaS |
| 状态 | 挂载 `config` / `QQ` | 落本机工作目录 | 云端会话 |
| 适合 | 服务器 / NAS 常驻 | 桌面调试 | 不愿自运维 |

```text
脚本 / AstrBot / Koishi
        │  HTTP :13300 或 WS :3001
        ▼
NapCat v4.18.28 ── WebUI :6099/webui
        ├── /app/napcat/config  ← ./config
        └── /app/.config/QQ     ← ./QQ
```

Hub 上还有 `napcat-framework-docker` 等关联镜像；**本文只跟做 `mlikiowa/napcat-docker:v4.18.28`**。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux（建议 Ubuntu 24.04）；也可 Docker Desktop |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64** / **arm64** |
| 内存 | 可用 ≥ **512 MB**（另留应用层余量） |
| 磁盘 | 镜像约 DISK **2.12GB** / CONTENT **597MB**，另加 QQ 缓存 |
| 端口 | **13300**、**3001**、**6099**（可按需收缩） |
| 工作目录 | `/www/wwwroot/napcat` |
| 账号 | 可登录的 QQ；建议专用小号 |

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
| **`v4.18.28`** | 当前较新的具体版本 | **推荐** |
| `v4.18.27` 等 | 同线较早标签 | 可回退 |
| `v4.17.x` | 旧次要版本线 | 仅兼容旧配置 |
| `latest` | 浮动标签 | **勿写入跟做命令** |

完整列表见 [标签页](https://xuanyuan.cloud/r/mlikiowa/napcat-docker/tags)。升级时改 Compose 标签，并对照 [Releases](https://github.com/NapNeko/NapCatQQ/releases)。

### 3.2 用轩辕镜像加速拉取

```bash
docker pull docker.xuanyuan.run/mlikiowa/napcat-docker:v4.18.28
```

Ubuntu 24.04 实测：

```text
v4.18.28: Pulling from mlikiowa/napcat-docker
44136fa355b3: Download complete
8c7fb09262c1: Pull complete
9b3a18efc3dd: Pull complete
7c1df3ed6d32: Pull complete
4748ab99dc9a: Pull complete
6414378b6477: Pull complete
018488390058: Pull complete
490f82e472ca: Pull complete
933fab068b12: Download complete
Digest: sha256:2cc70b45244ae3fabc657ffc3aaa4de8fb893518171e519659ab83d80e6d36b5
Status: Downloaded newer image for docker.xuanyuan.run/mlikiowa/napcat-docker:v4.18.28
docker.xuanyuan.run/mlikiowa/napcat-docker:v4.18.28
```

```text
IMAGE                                                 ID             DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/mlikiowa/napcat-docker:v4.18.28   2cc70b45244a       2.12GB          597MB
```

---

## 四、Docker Compose 部署（推荐）

### 4.1 准备目录

```bash
sudo mkdir -p /www/wwwroot/napcat/{config,QQ,plugins}
cd /www/wwwroot/napcat
```

macOS 跟做把路径换成 `~/docker/napcat`。

```bash
export NAPCAT_UID=$(id -u)
export NAPCAT_GID=$(id -g)
echo "UID=$NAPCAT_UID GID=$NAPCAT_GID"
```

root 下常见 `UID=0 GID=0`，可继续；普通用户须保证对 `config` / `QQ` 可写。

### 4.2 写入 compose.yaml

把 `WEBUI_TOKEN` 换成你自己的强随机口令：

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
| `13300:3000` | OneBot HTTP（宿主机避开 3000） |
| `3001:3001` | OneBot WebSocket |
| `6099:6099` | WebUI |
| `./config` | NapCat 配置 |
| `./QQ` | QQ 登录态与缓存 |
| `./plugins` | 插件（可先空挂） |

官方另有 [AstrBot](https://github.com/NapNeko/NapCat-Docker/blob/main/compose/astrbot.yml)、[Koishi](https://github.com/NapNeko/NapCat-Docker/blob/main/compose/koishi-compose.yml) 等联合模板；本文先单独跑通协议端。

### 4.3 启动与扫码登录

```bash
cd /www/wwwroot/napcat
NAPCAT_UID=$(id -u) NAPCAT_GID=$(id -g) docker compose up -d
docker compose ps
docker compose logs -f --tail=80 napcat
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network napcat_default Created
 ✔ Container napcat       Started
```

```text
NAME      IMAGE                                                 COMMAND                SERVICE   CREATED         STATUS         PORTS
napcat    docker.xuanyuan.run/mlikiowa/napcat-docker:v4.18.28   "bash entrypoint.sh"   napcat    8 seconds ago   Up 6 seconds   0.0.0.0:3001->3001/tcp, 0.0.0.0:6099->6099/tcp, 0.0.0.0:13300->3000/tcp
```

日志关键行（Token 已脱敏；无头环境常见 dbus / EGL 报错可忽略）：

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

控制台二维码不好扫时：

```bash
docker cp napcat:/app/napcat/cache/qrcode.png /tmp/napcat-qrcode.png
```

也可按日志里的解码 URL 在其它站点生成二维码（含登录凭证，勿外传）。`Ctrl+C` 只退出跟随日志，容器继续跑。

### 4.4 打开 WebUI

```text
http://服务器IP:6099/webui
```

或：

```text
http://服务器IP:6099/webui?token=ChangeMeStrongToken
```

用 **`WEBUI_TOKEN`** 进入面板。若 4.3 已扫码成功，打开后多半已在线；也可在 **快速登录** 里选已有 QQ，或改用扫码 / 密码登录：

![NapCat WebUI 快速登录选择 QQ 账号](https://imgs.xuanyuan.cloud/docker/blog/napcat-1.webp)

**基础信息** 可核对 NapCat **4.18.28**、QQ 版本、系统与当前网络配置数量：

![NapCat WebUI 基础信息 版本与系统状态](https://imgs.xuanyuan.cloud/docker/blog/napcat-12.webp)

侧栏 **关于我们**、**插件商店**、**系统配置 → OneBot** 可按需浏览（安装插件、调超时 / 代理等）；发消息与事件上报以第五节 **网络配置** 为准：

![NapCat WebUI 关于我们 Core 4.18.28](https://imgs.xuanyuan.cloud/docker/blog/napcat-5.webp)

![NapCat WebUI 插件商店列表](https://imgs.xuanyuan.cloud/docker/blog/napcat-3.webp)

![NapCat WebUI 系统配置 OneBot 选项](https://imgs.xuanyuan.cloud/docker/blog/napcat-4.webp)

公网请限制 **6099** 来源或加反代 HTTPS；OneBot 口同样不要裸暴露。

---

## 五、发消息与事件上报

WebUI 管登录和网络，**不是** QQ 聊天窗。主动发消息走 HTTP **服务端**；要把群消息实时推给你自己的服务，再加 HTTP **客户端**。

| 类型 | 方向 | 用途 |
|------|------|------|
| HTTP **服务端**（宿主机 **13300**） | 你 → NapCat | `curl` / 框架发消息、查列表 |
| HTTP **客户端** | NapCat → 你的 URL | 群 / 私聊事件 POST 到 webhook |
| WS **3001** | 双向 | 正向 WebSocket，适合部分框架 |

文档：[WebUI 配置](https://napneko.github.io/config/basic) · [API 一览](https://napneko.github.io/onebot/api) · [Apifox 用例](https://napcat.apifox.cn)

### 5.1 启用 HTTP 服务端

Compose 已映射 **13300→3000**，仍须在 WebUI **新建并启用** HTTP 服务器，接口才会监听。

1. **网络配置** → **新建** → **HTTP 服务器**

![NapCat 网络配置新建菜单选择 HTTP 服务器](https://imgs.xuanyuan.cloud/docker/blog/napcat-6.webp)

2. `Host=0.0.0.0`，`Port=3000`，消息格式可选 **Array**；打开 **启用**；公网务必填鉴权 **Token**

![NapCat HTTP 服务器配置 启用 Port 3000](https://imgs.xuanyuan.cloud/docker/blog/napcat-7.webp)

3. **保存** 后列表出现已启用卡片；探测用 `http://服务器IP:13300`（不是 6099）

![NapCat 网络配置已启用 HTTP 服务器卡片](https://imgs.xuanyuan.cloud/docker/blog/napcat-8.webp)

### 5.2 用 curl 发私聊 / 群聊

在本机或能访问 **13300** 的机器上执行。未设 HTTP Token 时可先去掉 `Authorization`（仅限内网试通）。

```bash
# 私聊
curl -sS -X POST 'http://127.0.0.1:13300/send_private_msg' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer 你的HTTP鉴权token' \
  -d '{"user_id":好友QQ号,"message":"你好，来自 NapCat"}'

# 群聊
curl -sS -X POST 'http://127.0.0.1:13300/send_group_msg' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer 你的HTTP鉴权token' \
  -d '{"group_id":群号,"message":"大家好，来自 NapCat"}'
```

成功时一般返回 `status: ok` 与 `message_id`。也可先 `get_friend_list` / `get_group_list` 再发。连不上时查：服务端是否启用、端口是否为容器内 **3000**、Token 是否一致。

### 5.3 启用 HTTP 客户端（实时上报）

| | HTTP 服务端 | HTTP 客户端 |
|--|-------------|-------------|
| 方向 | 你调 NapCat | NapCat 调你 |
| URL | 不用填（它监听 3000） | 填**接收方**完整 webhook |

上报地址填接收方给的 URL（含密钥），**不要**填 `6099` / `13300`，也**不要**填容器访问不到的 `http://localhost:...`。

1. **网络配置** → **新建** → **HTTP 客户端**

![NapCat 网络配置新建菜单选择 HTTP 客户端](https://imgs.xuanyuan.cloud/docker/blog/napcat-9.webp)

2. 启用；名称自定；**URL** 粘贴 webhook；消息格式 `string` 或 `array`；**上报自身消息** 关闭（防循环）

![NapCat HTTP 客户端配置 URL 与关闭上报自身消息](https://imgs.xuanyuan.cloud/docker/blog/napcat-10.webp)

3. 保存后应同时看到服务端与客户端且均为启用；群里 `@` 测一条，接收方再回调 **13300** 发回复即可

![NapCat 网络配置 HTTP 服务器与 HTTP 客户端均已启用](https://imgs.xuanyuan.cloud/docker/blog/napcat-11.webp)

上报失败看 NapCat 日志（超时 / 4xx / 5xx）与容器出网；能收事件但不回复，查接收方是否调通了 5.1 的服务端。

### 5.4 对接应用框架（可选）

| 框架 | 说明 |
|------|------|
| AstrBot / Koishi 等 | 官方或社区有 Compose 模板 |
| 自研 | 主动调用 `http://宿主机:13300`；事件用 HTTP 客户端或 WS |

同 Compose 网络内用**服务名**互访，不要写宿主机映射口。模板见 [NapCat-Docker/compose](https://github.com/NapNeko/NapCat-Docker/tree/main/compose)，接入说明见 [接入框架](https://napneko.github.io/use/integration)。

---

## 六、升级与备份

| 项 | 做法 |
|----|------|
| 备份 | 停服务后打包 `config` 与 `QQ`（及需要时的 `plugins`） |
| 升级 | 改标签 → `docker compose pull` → 带上 UID/GID `up -d` |
| 回归 | 看日志；进 WebUI；`curl` 抽测一条消息 |

跨大版本先读 changelog。WebUI 端口被占用时可能自动 +1，以日志为准。

---

## 七、备选：docker run

```bash
mkdir -p /www/wwwroot/napcat/{config,QQ,plugins}

docker run -d \
  --name napcat \
  --restart unless-stopped \
  -e NAPCAT_UID=$(id -u) \
  -e NAPCAT_GID=$(id -g) \
  -e WEBUI_TOKEN=ChangeMeStrongToken \
  -e TZ=Asia/Shanghai \
  -p 13300:3000 \
  -p 3001:3001 \
  -p 6099:6099 \
  -v /www/wwwroot/napcat/config:/app/napcat/config \
  -v /www/wwwroot/napcat/QQ:/app/.config/QQ \
  -v /www/wwwroot/napcat/plugins:/app/napcat/plugins \
  docker.xuanyuan.run/mlikiowa/napcat-docker:v4.18.28
```

```bash
docker logs -f --tail=80 napcat
```

长期运行仍用第四节 Compose。

---

## 八、常见问题

**Q：该用哪个版本？**  
A：跟做 **`v4.18.28`**，不要写 `latest`。

**Q：为什么宿主机不用 3000？**  
A：本系列避开宿主机 **3000**。容器内仍是 3000，对外 **`13300:3000`**。

**Q：WebUI Token 和 HTTP Token 一样吗？**  
A：不必相同。前者是 `WEBUI_TOKEN`（进面板）；后者在 HTTP 服务器配置里填，给 `Authorization: Bearer …` 用。

**Q：登录后怎么在 WebUI 里点开发消息？**  
A：没有聊天窗。启用 HTTP 服务端后用 5.2 的 `curl`，或接 AstrBot 等框架。

**Q：HTTP 客户端 URL 填什么？**  
A：接收方 webhook 完整地址，不是 `6099` / `13300`。详见 5.3。

**Q：curl 13300 失败？**  
A：HTTP 服务器是否启用、容器端口是否 **3000**、Token 是否一致；别拿 6099 当 API 口。

**Q：日志里 dbus / EGL / GPU 报错？**  
A：无头容器常见，不影响 Core 启动与扫码，可忽略。

**Q：控制台二维码扫不上？**  
A：`docker cp napcat:/app/napcat/cache/qrcode.png /tmp/napcat-qrcode.png`，或用日志解码 URL（勿外传）。

**Q：permission denied？**  
A：核对 `NAPCAT_UID` / `NAPCAT_GID`。群晖等 NAS 还可能要在文件管理器里给挂载目录授读写。

**Q：6099 / 13300 能对公网裸开吗？**  
A：不建议。强 Token + 来源限制或 HTTPS 反代。

**Q：合规吗？**  
A：仅用于合法、授权场景；建议小号；遵守当地法规与平台条款。

---

## 九、命令速查

```bash
docker pull docker.xuanyuan.run/mlikiowa/napcat-docker:v4.18.28

sudo mkdir -p /www/wwwroot/napcat/{config,QQ,plugins}
cd /www/wwwroot/napcat
# 先写入第四节 compose.yaml
export NAPCAT_UID=$(id -u) NAPCAT_GID=$(id -g)
docker compose up -d
docker compose ps
docker compose logs -f napcat

curl -sS -X POST 'http://127.0.0.1:13300/send_private_msg' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer 你的HTTP鉴权token' \
  -d '{"user_id":好友QQ号,"message":"你好"}'
curl -sS -X POST 'http://127.0.0.1:13300/send_group_msg' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer 你的HTTP鉴权token' \
  -d '{"group_id":群号,"message":"大家好"}'

docker compose down
```

验证：WebUI `:6099/webui` · API `:13300` · 标签 `v4.18.28`

---

## 十、延伸阅读

| 资源 | 链接 |
|------|------|
| [mlikiowa/napcat-docker 镜像页](https://xuanyuan.cloud/zh/r/mlikiowa/napcat-docker) | [https://xuanyuan.cloud/zh/r/mlikiowa/napcat-docker](https://xuanyuan.cloud/zh/r/mlikiowa/napcat-docker) |
| [镜像标签列表](https://xuanyuan.cloud/r/mlikiowa/napcat-docker/tags) | [https://xuanyuan.cloud/r/mlikiowa/napcat-docker/tags](https://xuanyuan.cloud/r/mlikiowa/napcat-docker/tags) |
| [Docker Hub · mlikiowa/napcat-docker](https://hub.docker.com/r/mlikiowa/napcat-docker) | [https://hub.docker.com/r/mlikiowa/napcat-docker](https://hub.docker.com/r/mlikiowa/napcat-docker) |
| [GitHub · NapCatQQ](https://github.com/NapNeko/NapCatQQ) | [https://github.com/NapNeko/NapCatQQ](https://github.com/NapNeko/NapCatQQ) |
| [GitHub · NapCat-Docker](https://github.com/NapNeko/NapCat-Docker) | [https://github.com/NapNeko/NapCat-Docker](https://github.com/NapNeko/NapCat-Docker) |
| [NapCat 文档站](https://napneko.github.io/) | [https://napneko.github.io/](https://napneko.github.io/) |
| [WebUI 配置指南](https://napneko.github.io/config/basic) | [https://napneko.github.io/config/basic](https://napneko.github.io/config/basic) |
| [OneBot API 一览](https://napneko.github.io/onebot/api) | [https://napneko.github.io/onebot/api](https://napneko.github.io/onebot/api) |
| [API 完整用例 · Apifox](https://napcat.apifox.cn) | [https://napcat.apifox.cn](https://napcat.apifox.cn) |
| [接入框架](https://napneko.github.io/use/integration) | [https://napneko.github.io/use/integration](https://napneko.github.io/use/integration) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- 跟做 **`v4.18.28`**，挂载 `config` / `QQ`，映射 **13300 / 3001 / 6099**。
- Compose 启动 → 日志扫码 → WebUI 用 `WEBUI_TOKEN` 管理。
- 发消息：启用 HTTP 服务端 → **13300** 调 OneBot；实时事件再加 HTTP 客户端 webhook。
- 6099 与 OneBot 口勿裸暴露公网；合法合规使用。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/docker-napcat-qq-bot-deploy

