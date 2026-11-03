# Docker 部署 FlatNas：轻松搭建个人导航与仪表盘平台

![Docker 部署 FlatNas：轻松搭建个人导航与仪表盘平台](https://imgs.xuanyuan.cloud/docker/blog/flatnas/flatnas.webp)

*分类: Docker部署教程 | 标签: FlatNas,qdnas/flatnas,Docker,轩辕镜像,个人导航,仪表盘,NAS,起始页,私有化部署,部署教程 | 发布时间: 2026-11-03 13:29:59*

> FlatNas 是面向 NAS 用户与极客的轻量级个人导航页与仪表盘，把常用网站、内网服务和小组件聚合到同一起始页。本文将介绍如何通过 Docker Compose 部署 qdnas/flatnas，搭建可自托管的浏览器起始页，适合家用 NAS、内网工具入口，以及需要统一管理书签与 Docker 容器的场景。

## FlatNas 是什么

FlatNas 是一款个人导航页与仪表盘。它基于 Vue 3 与 Go（Gin）构建，把常用网站、内网服务和小组件放在同一浏览器起始页，面向 NAS 用户、极客和开发者。

与只收藏网址的静态起始页不同，它还带文件传输助手、本地音乐播放、壁纸管理和 Docker 容器管理。布局与书签写在本机目录，迁移时按目录复制即可。

## FlatNas 能做什么

- **统一入口**：把常用网站和内网服务放在同一页访问，并可为同一卡片分别填写外网、内网地址。
- **文件与媒体**：用文件传输助手收发文本和文件，用本地 `music` 目录驱动播放器，并管理壁纸。
- **内外网切换**：按访问环境在内网地址与外网地址之间自动选用。
- **组件布局**：拖拽时钟、天气、日历、待办、热点等组件，也可在设置里开关或新增多开组件。
- **Docker 管理**：在网页里查看、启停容器，并按策略检测镜像更新（需挂载 `docker.sock` 并在设置中开启）。

## 为什么要使用 FlatNas

家用 NAS 和内网机器上，服务地址、书签和临时传文件入口常散在浏览器收藏夹、记事本和多个后台里。每次访问都要回忆端口，外出时还要区分内外网地址。

FlatNas 把这些入口收成一页，配置与数据留在本机卷上。适合想自建浏览器起始页的人，也适合需要顺手看一眼 Docker 容器状态的 NAS 用户。

## 使用 Docker 部署 FlatNas

FlatNas 可以用 Docker 启动，本机不必先安装前后端运行时。部署前准备好 Docker，并规划好数据、音乐、壁纸和文件传输要用的目录。

接下来用 Docker Compose 写好镜像、端口和卷，启动服务，再在浏览器里登录、改密码并确认主界面可用。

## 环境要求

本文使用 **`qdnas/flatnas:1.2.6`** 版本实测。测试平台是 Ubuntu 24.04（主机名 `ikuai-ubuntu2404`）。镜像提供 **linux/amd64**、**linux/arm64**、**linux/arm/v7**。Docker Hub 上 amd64 压缩体积约 **46 MB**；解压后更大，拉取前确认磁盘有富余。

容器内 Web 服务听 **3000**。官方示例把宿主机映到 **23000**，本文沿用，避免占用本机前端常用的 **3000**。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 Ubuntu 目录书写）；macOS 把 `/www/wwwroot/flatnas` 换成 `~/docker/flatnas` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64**、**linux/arm/v7** |
| 内存 | 建议 ≥ **256 MB** 可用（上游说明 NAS 端约 100 MB 量级） |
| 磁盘 | 镜像约数十 MB，另加 `data`、`music`、`doc` 等目录增长空间 |
| 端口 | 宿主机 **23000** → 容器 **3000** |
| 工作目录 | `/www/wwwroot/flatnas` |
| 账号 | 初始密码 **`admin`**，登录后立即修改 |

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

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=flatnas-docker-deploy)。

## 标签怎么选

新安装使用 **`1.2.6`**。Hub 上该标签的推送时间晚于当前 `latest`，Digest 也不同；不要把 `latest` 当成「永远指向最新稳定版」。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`1.2.6`** | 当前可用的具体版本标签，本文采用 | **是** |
| `1.2.5`、`1.2.3` 等 | 更早的固定版本，便于回滚 | 否 |
| `1.2.5dev*` / `v1.2.5dev*` | 开发预览标签 | 否 |
| `latest` | 浮动标签，当前并不指向 `1.2.6` | 否 |

完整列表见 [标签列表](https://xuanyuan.cloud/r/qdnas/flatnas/tags?xy_from=flatnas-docker-deploy)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud/?xy_from=flatnas-docker-deploy) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/qdnas/flatnas:1.2.6
```

Ubuntu 24.04 上拉取完成：

```text
1.2.6: Pulling from qdnas/flatnas
fb414609a072: Pull complete
e2bb062ac536: Pull complete
55ee73eb026c: Pull complete
ff4a5f6e4b5d: Pull complete
6a0ac1617861: Pull complete
a0e995e9c469: Pull complete
d5f9cdc14c90: Download complete
Digest: sha256:3398f0442cfc0e50b51d5d9027e27205e0b8d676a05a928f52070fafa8dd6ab2
Status: Downloaded newer image for docker.xuanyuan.run/qdnas/flatnas:1.2.6
docker.xuanyuan.run/qdnas/flatnas:1.2.6
```

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq?xy_from=flatnas-docker-deploy)。

## Docker Compose 部署

工作目录：Linux **`/www/wwwroot/flatnas`**。macOS 用 **`~/docker/flatnas`**。

| 宿主机目录 | 容器内路径 | 用途 |
|------------|------------|------|
| `data/` | `/app/server/data` | 布局、组件、书签等配置（含 `data.json`） |
| `doc/` | `/app/server/doc` | 文件传输助手目录 |
| `music/` | `/app/server/music` | 本地音乐（如 MP3） |
| `PC/` | `/app/server/PC` | 桌面端壁纸 |
| `APP/` | `/app/server/APP` | 移动端壁纸 |
| `/var/run/docker.sock` | `/var/run/docker.sock` | 供 Docker 管理使用（还需在网页设置里开启） |

### 1. 创建目录

```bash
sudo mkdir -p /www/wwwroot/flatnas/{data,doc,music,PC,APP}
sudo chown -R "$USER":"$USER" /www/wwwroot/flatnas
cd /www/wwwroot/flatnas
```

macOS：

```bash
mkdir -p ~/docker/flatnas/{data,doc,music,PC,APP}
cd ~/docker/flatnas
```

### 2. 写入 compose.yaml

`23000:3000` 表示宿主机 **23000** 对应容器内 **3000**。需要在网页里管理本机 Docker 时，保留 `docker.sock` 挂载；不需要该功能时可删掉对应一行，见「常见问题」。

```bash
cat > compose.yaml <<'EOF'
services:
  flatnas:
    image: docker.xuanyuan.run/qdnas/flatnas:1.2.6
    container_name: flatnas
    restart: unless-stopped
    ports:
      - "23000:3000"
    environment:
      HOST: "0.0.0.0"
      PORT: "3000"
      TZ: Asia/Shanghai
    volumes:
      - ./data:/app/server/data
      - ./doc:/app/server/doc
      - ./music:/app/server/music
      - ./PC:/app/server/PC
      - ./APP:/app/server/APP
      - /var/run/docker.sock:/var/run/docker.sock
EOF
```

| 配置 | 说明 |
|------|------|
| `image` | 具体版本标签 `1.2.6` |
| `23000:3000` | 宿主机 **23000** → 容器 **3000** |
| `HOST` / `PORT` | 容器内监听地址与端口 |
| `TZ` | 时区，本文写 `Asia/Shanghai` |
| `./data` | 配置与布局数据 |
| `./doc` | 文件传输助手 |
| `./music` | 播放器曲库；目录为空时，顶部音乐会显示「获取失败」 |
| `./PC` / `./APP` | 桌面 / 移动端壁纸 |
| `docker.sock` | 挂载后，还要在「设置 → Docker 管理」打开服务开关，容器才能访问宿主机 Docker |

### 3. 启动并确认状态

```bash
docker compose up -d
docker compose ps
```

这次启动完成：

```text
[+] up 2/2
 ✔ Network flatnas_default Created
 ✔ Container flatnas       Started

NAME      IMAGE                                     COMMAND               SERVICE   CREATED         STATUS         PORTS
flatnas   docker.xuanyuan.run/qdnas/flatnas:1.2.6   "./flatnas-backend"   flatnas   6 seconds ago   Up 4 seconds   0.0.0.0:23000->3000/tcp, [::]:23000->3000/tcp
```

再看日志：

```bash
docker compose logs --no-color --tail=80 flatnas
```

这次日志是：

```text
flatnas  | Backend process started
flatnas  | 2026/11/03 13:16:31 [WeatherPoller] Started (30min interval)
flatnas  | 2026/11/03 13:16:31 Server starting on 0.0.0.0:3000 (basePath=/)
flatnas  | 2026/11/03 13:16:31 [WeatherPoller] Running full poll...
flatnas  | 2026/11/03 13:16:31 [WeatherPoller] No cities to poll
flatnas  | 2026/11/03 13:16:31 [IPFetcher] Success via ip-api: 杭州
```

看到 `Server starting on 0.0.0.0:3000 (basePath=/)` 即可。天气与公网位置会由后台按周期更新；首次可能出现 `No cities to poll`，登录后天气组件仍可显示。

本机探测：

```bash
curl -I http://127.0.0.1:23000
```

这次返回：

```text
HTTP/1.1 200 OK
Accept-Ranges: bytes
Cache-Control: no-cache, no-store, must-revalidate
Content-Length: 1534
Content-Type: text/html; charset=utf-8
```

浏览器地址把 IP 换成你的：

```text
http://你的服务器IP:23000
```

## 登录并开始使用

### 1. 首次打开与同步

1. 打开上面的地址。
2. 等待页面提示「正在同步服务端数据，请稍后…」结束。

![FlatNas 首次打开：正在同步服务端数据，请稍后](https://imgs.xuanyuan.cloud/docker/blog/flatnas/flatnas-1.webp)

同步后进入标题为「我的导航」的页面。顶部有「自动」「内网」与「登录」；未登录时中间区域是空的。

![FlatNas 同步后：我的导航，顶部有自动、内网与登录](https://imgs.xuanyuan.cloud/docker/blog/flatnas/flatnas-2.webp)

### 2. 管理员登录

1. 点击顶部「登录」。
2. 在「管理员登录」对话框输入初始密码 **`admin`**，再点「登录」。

![FlatNas 管理员登录：输入密码 admin 后点击登录](https://imgs.xuanyuan.cloud/docker/blog/flatnas/flatnas-3.webp)

登录后立刻打开右上角齿轮，进入「设置 → 账户管理」修改密码，并另行保存。不要把未改密的页面直接暴露到公网。

### 3. 主界面

登录后，页面会出现时钟、天气、日历、文件传输助手、备忘录、待办、计算器、网络信息、热点等组件；顶部有搜索框，右上角有齿轮与「编辑」。

本次实测中，`music/` 仍为空，顶部音乐控件显示「获取失败」。把 MP3 放进宿主机 `music/` 后刷新即可。

![FlatNas 登录后主界面：时钟天气、文件传输助手、待办与热点；右上角有编辑](https://imgs.xuanyuan.cloud/docker/blog/flatnas/flatnas-4.webp)

### 4. 设置与组件

点击右上角齿轮打开「设置」。

「外观布局」可改网站标题、背景图与白昼模式：

![FlatNas 设置：外观布局，网站标题为「我的导航」](https://imgs.xuanyuan.cloud/docker/blog/flatnas/flatnas-5.webp)

「单开组件」可开关时钟、天气、文件传输助手等：

![FlatNas 设置：单开组件，可开关时钟、天气与文件传输助手](https://imgs.xuanyuan.cloud/docker/blog/flatnas/flatnas-6.webp)

「多开组件」可新增万能窗口、高德天气、倒计时、正计时：

![FlatNas 设置：多开组件，可新增万能窗口与高德天气等](https://imgs.xuanyuan.cloud/docker/blog/flatnas/flatnas-7.webp)

### 5. Docker 管理

侧边栏进入「Docker 管理」（界面标注「内测中」）。Compose 已挂载 `docker.sock` 时，「Docker 服务」仍可能显示「已关闭」。要在网页里管理容器，先打开该开关，再按需启用「容器管理组件」。

![FlatNas 设置：Docker 管理（内测中），Docker 服务默认已关闭](https://imgs.xuanyuan.cloud/docker/blog/flatnas/flatnas-8.webp)

长期自托管时，建议保持「自动升级」关闭，升级改由维护窗口手动改镜像标签完成。

### 6. 编辑布局与书签卡片

1. 在主界面点击「编辑」，进入编辑模式。
2. 拖拽或缩放组件；需要新增入口时点「新建卡片」。
3. 改完后点「保存」或「完成」。

![FlatNas 编辑模式：右上角有完成、保存与新建卡片](https://imgs.xuanyuan.cloud/docker/blog/flatnas/flatnas-9.webp)

在「修改项目」里填写标题，并分别设置外网链接与内网链接；可上传或智能匹配图标。

![FlatNas 修改项目：填写标题、外网链接、内网链接与图标](https://imgs.xuanyuan.cloud/docker/blog/flatnas/flatnas-10.webp)

布局、组件和书签写在 `data/data.json`。删除容器不会删除宿主机上的 `data`、`doc`、`music`、`PC`、`APP` 目录。

## 备选：docker run

没有 Compose 时，可以用下面的命令临时试玩：

```bash
sudo mkdir -p /www/wwwroot/flatnas/{data,doc,music,PC,APP}
sudo chown -R "$USER":"$USER" /www/wwwroot/flatnas

docker run -d 
  --name flatnas 
  --restart unless-stopped 
  -p 23000:3000 
  -e HOST=0.0.0.0 
  -e PORT=3000 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/flatnas/data:/app/server/data 
  -v /www/wwwroot/flatnas/doc:/app/server/doc 
  -v /www/wwwroot/flatnas/music:/app/server/music 
  -v /www/wwwroot/flatnas/PC:/app/server/PC 
  -v /www/wwwroot/flatnas/APP:/app/server/APP 
  -v /var/run/docker.sock:/var/run/docker.sock 
  docker.xuanyuan.run/qdnas/flatnas:1.2.6
```

查看状态：

```bash
docker ps --filter name=flatnas
docker logs --tail 80 flatnas
```

停止并删除容器时，宿主机上述五个目录仍会保留。

## 备份与升级

备份前先停容器，再打包数据目录：

```bash
cd /www/wwwroot/flatnas
docker compose stop
tar -czf flatnas-backup.tar.gz data doc music PC APP
docker compose start
```

升级时只改 `compose.yaml` 里的镜像标签，保留上述目录后执行：

```bash
docker compose pull
docker compose up -d
```

## 常见问题

### 初始密码是什么

**`admin`**。登录后到「设置 → 账户管理」修改。

### 必须挂载 docker.sock 吗

要用网页里的 Docker 管理就需要挂载。不需要时，从 Compose 删掉 `docker.sock` 那一行再启动。

挂载后还要在「设置 → Docker 管理」打开「Docker 服务」；否则界面显示「已关闭」，后端不会访问 Engine。开启后，容器内进程能调用宿主机 Docker，请只在可信环境使用，并先改掉默认密码。

### 顶部音乐显示「获取失败」

宿主机 `music/` 为空时会出现。把 MP3 放进该目录，对应容器内 `/app/server/music`，再刷新页面。

### 配置丢了或想迁移

确认已挂载 `./data`。布局与书签在 `data/data.json`。整机迁移时打包 `data`、`doc`、`music`、`PC`、`APP`。

### 子路径部署怎么配

反代到 `/flatnas` 一类路径时，可增加环境变量 `BASE_PATH=/flatnas`，并保证反代与前端资源路径一致。复杂网络（DDNS、Tunnel、FRP）见上游仓库说明。

### 可以用 latest 吗

`latest` 是浮动标签，当前与 `1.2.6` 的 Digest 不一致。本文命令使用 **`1.2.6`**。说明见「标签怎么选」。

### 为什么不用宿主机 3000

本机前端开发经常占用 3000。容器内听 **3000**，本文宿主机映射为 **23000**，与上游 Docker 示例一致。

### 需要走代理才能拉外网资源吗

可在 Compose 的 `environment` 中设置 `PROXY_URL`（`http` / `https` / `socks5` / `socks5h`）。生效后，在卡片或万能窗口里打开「代理」开关。开关不显示时，检查变量格式，并可访问 `/api/config/proxy-status`。

## 命令速查

```bash
docker pull docker.xuanyuan.run/qdnas/flatnas:1.2.6

cd /www/wwwroot/flatnas
docker compose up -d
docker compose ps
docker compose logs --no-color --tail=80 flatnas

# 浏览器打开 http://服务器IP:23000 ，密码 admin，登录后立刻修改

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [qdnas/flatnas 镜像页](https://xuanyuan.cloud/r/qdnas/flatnas?xy_from=flatnas-docker-deploy) | [https://xuanyuan.cloud/r/qdnas/flatnas](https://xuanyuan.cloud/r/qdnas/flatnas?xy_from=flatnas-docker-deploy) |
| [qdnas/flatnas 标签列表](https://xuanyuan.cloud/r/qdnas/flatnas/tags?xy_from=flatnas-docker-deploy) | [https://xuanyuan.cloud/r/qdnas/flatnas/tags](https://xuanyuan.cloud/r/qdnas/flatnas/tags?xy_from=flatnas-docker-deploy) |
| [Docker Hub · qdnas/flatnas](https://hub.docker.com/r/qdnas/flatnas) | [https://hub.docker.com/r/qdnas/flatnas](https://hub.docker.com/r/qdnas/flatnas) |
| [GitHub · Garry-QD/FlatNas](https://github.com/Garry-QD/FlatNas) | [https://github.com/Garry-QD/FlatNas](https://github.com/Garry-QD/FlatNas) |
| [FlatNas 官网](https://flatnas.top/) | [https://flatnas.top/](https://flatnas.top/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=flatnas-docker-deploy) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage?xy_from=flatnas-docker-deploy) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/flatnas-docker-deploy?xy_from=flatnas-docker-deploy)

*本文基于 [qdnas/flatnas:1.2.6](https://xuanyuan.cloud/r/qdnas/flatnas?xy_from=flatnas-docker-deploy)，以 **1.2.6** 版本实测，测试平台 **Ubuntu 24.04** Linux。*


