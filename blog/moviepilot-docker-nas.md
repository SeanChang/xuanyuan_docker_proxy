# MoviePilot Docker 一键部署：轻松搭建 NAS 影视自动化管理平台

![MoviePilot Docker 一键部署：轻松搭建 NAS 影视自动化管理平台](https://imgs.xuanyuan.cloud/docker/blog/moviepilot/moviepilot.webp)

*分类: Docker部署教程 | 标签: MoviePilot,jxxghp/moviepilot-v3,Docker,轩辕镜像,NAS,媒体库,群晖,威联通,订阅追更,私有化部署,部署教程 | 发布时间: 2026-11-10 22:02:32*

> MoviePilot 是面向 NAS 与自托管影音库的自动化管理工具，用来订阅电影与剧集、对接下载器并整理入库。本文将介绍如何通过 Docker Compose 部署 jxxghp/moviepilot-v3，把配置与媒体根目录留在本机，适合家庭 NAS、内网影音库与订阅追更场景。

## MoviePilot 是什么

MoviePilot 是面向 NAS 与自托管影音场景的媒体库自动化管理工具。它按媒体信息搜索与匹配资源，建立订阅后交给下载器拉取，再按命名规则整理进媒体库目录，并可通知 Jellyfin、Emby、Plex 等媒体服务器刷新。

和只在下载器里手工搜种、下完再改名不同，它以元数据识别为中心做订阅与整理，减少漏更和错命中。和媒体服务器不同，它不负责播放；播放仍由 Jellyfin / Emby / Plex 等完成。本文使用的官方 V3 镜像是 **`jxxghp/moviepilot-v3`**。

## MoviePilot 能做什么

- **搜索与订阅**：按电影、电视剧搜索元数据与站点资源；V3 另支持音乐。可建立订阅自动追更。
- **下载器对接**：把任务交给 qBittorrent、Transmission 等客户端，按目录与规则落盘。
- **识别与整理**：下载完成后识别媒体信息，按自定义命名格式整理进媒体库目录。
- **媒体服务器联动**：对接 Jellyfin、Emby、Plex 等，整理后触发库刷新。
- **插件与通知**：通过插件扩展能力，并用微信、Telegram、Slack 等接收进度与远程指令。

## 为什么要使用 MoviePilot

片源一多，手工搜种、挑清晰度、改文件名、再让媒体服务器扫描，步骤碎且容易漏更。下载器和媒体服务器各自为政时，目录约定不一致，硬链接、洗版和追更也难稳定。

家里若已有 NAS 或常开的 Linux 主机，再配上下载器与影音库，可以用 MoviePilot 把订阅、下载、整理和刷库串起来。适合家庭 NAS 影音库、内网追剧，以及希望少动手维护片库结构的人。

## 使用 Docker 部署 MoviePilot

MoviePilot 可以用 Docker 启动，不必在宿主机单独装运行时。部署前准备好 Docker，并规划配置目录、浏览器内核缓存目录与媒体根目录。

接下来用 Docker Compose 写好镜像、端口与卷，启动服务，再在浏览器完成「首次设置」，并按需对接下载器与媒体服务器。

## 环境要求

本文使用 **`jxxghp/moviepilot-v3:3.2.5`** 版本实测。测试平台是 Ubuntu 24.04（主机名 `ikuai-ubuntu2404`）。`3.2.5` 为当前稳定发行版（2026-11-06 发布）；同日的 `latest` 与之指向同一索引，下次发版后 `latest` 会改指向，本文命令固定 **`3.2.5`**。镜像提供 **linux/amd64**、**linux/arm64**。

容器内 Web（Nginx）听 **3000**，后端 API 听 **3001**。本文把宿主机 **13300** 映到 **3000**、**13301** 映到 **3001**，避免占用宿主机常见的 **3000**。V3 全新安装不预置管理员；首次打开 Web 进入「首次设置」。停止容器时建议预留 **120** 秒优雅退出时间。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文按 Ubuntu 目录书写）；macOS 把 `/www/wwwroot/moviepilot-v3` 换成 `~/docker/moviepilot-v3` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64** 或 **linux/arm64** |
| 内存 | 建议可用 ≥ **1 GB**（站点多、插件多时宜更宽裕） |
| 磁盘 | 镜像约 **700+ MB** 量级，另加 `config`、`core` 与媒体库空间 |
| 端口 | 宿主机 **13300** → 容器 **3000**（Web）；**13301** → **3001**（API） |
| 工作目录 | `/www/wwwroot/moviepilot-v3` |
| 账号 | 无默认密码；「首次设置」自建管理员与 API 访问密钥 |
| 优雅停止 | `stop_grace_period: 120s`（或 `docker run --stop-timeout 120`） |

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

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=moviepilot-v3-docker-deploy)。

## 标签怎么选

新安装使用 **`3.2.5`**。不要把 `latest`、`dev` 写进 Compose。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`3.2.5`** | 当前稳定发行版，本文采用 | **是** |
| `3.2.4`、`3.2.3` 等 | 更早稳定版，便于回滚 | 否 |
| `latest` | 浮动稳定线，发版后会变 | 否 |
| `dev` | 开发构建 | 否 |

完整列表见 [标签列表](https://xuanyuan.cloud/r/jxxghp/moviepilot-v3/tags?xy_from=moviepilot-v3-docker-deploy)。发布说明见 [v3.2.5](https://github.com/jxxghp/MoviePilot/releases/tag/v3.2.5)。升级时改 Compose 中的标签，并先备份 `config`。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud/?xy_from=moviepilot-v3-docker-deploy) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/jxxghp/moviepilot-v3:3.2.5
```

Ubuntu 24.04 上拉取完成：

```text
3.2.5: Pulling from jxxghp/moviepilot-v3
6a4b2eff0815: Pull complete
a5d0b301c96c: Pull complete
6b37362b3da7: Pull complete
5c21337b2448: Pull complete
8def98961a31: Pull complete
d8a71b887e0b: Pull complete
ad232412d02e: Pull complete
ac548121c4e7: Pull complete
d06d856e8eaf: Pull complete
25f405902f09: Pull complete
6569bc8cad9a: Pull complete
b42df2d00c50: Pull complete
15948e5b9275: Pull complete
6286cf1a71b7: Pull complete
9b63fca58f1c: Pull complete
d47087aaa50a: Pull complete
2e89d1cb0d63: Pull complete
c3be4edd66c1: Pull complete
7d155058984a: Pull complete
08dc38b9e593: Pull complete
e3bfd7c8b78d: Pull complete
44136fa355b3: Download complete
c8be528d5cd0: Download complete
Digest: sha256:c9ab74b94427a18134b9c5e8d6fa0c186f6740c033029b69eceda0a07f4021af
Status: Downloaded newer image for docker.xuanyuan.run/jxxghp/moviepilot-v3:3.2.5
docker.xuanyuan.run/jxxghp/moviepilot-v3:3.2.5
```

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq?xy_from=moviepilot-v3-docker-deploy)。

## Docker Compose 部署

主路径为单容器安装：内置 SQLite 与本地缓存，不另起 PostgreSQL、Redis，也不映射 Docker Socket。工作目录：Linux **`/www/wwwroot/moviepilot-v3`**。macOS 用 **`~/docker/moviepilot-v3`**。

| 宿主机目录 | 容器内路径 | 用途 |
|------------|------------|------|
| `config/` | `/config` | **必挂**：配置、数据库、日志（务必备份） |
| `core/` | `/moviepilot/.cloakbrowser` | **必挂**：浏览器内核缓存，避免重建容器后重复下载 |
| `media/` 或真实盘符 | `/media` | 媒体库与下载目录的共同根目录；计划硬链接时，两者都应在此根下 |

需要对接已有 qBittorrent / Transmission 种子目录时，可按官方文档追加卷映射；首次跑通可先只用上面三项目录。

### 1. 创建目录

```bash
sudo mkdir -p /www/wwwroot/moviepilot-v3/{config,core,media/downloads,media/library}
sudo chown -R "$(id -u):$(id -g)" /www/wwwroot/moviepilot-v3
cd /www/wwwroot/moviepilot-v3
```

macOS：

```bash
mkdir -p ~/docker/moviepilot-v3/{config,core,media/downloads,media/library}
cd ~/docker/moviepilot-v3
```

生产环境可把 `./media` 换成 NAS 共享盘路径，例如 `/mnt/nas/media`，并保证下载器容器也能看到同一路径约定。

### 2. 写入 compose.yaml

容器内 Web 仍听 **3000**、API 仍听 **3001**；`NGINX_PORT` / `PORT` 与之一致。宿主机改用 **13300**、**13301**，避免和本机前端常用的 **3000** 冲突。

```bash
cd /www/wwwroot/moviepilot-v3

cat > compose.yaml <<'EOF'
services:
  moviepilot:
    image: docker.xuanyuan.run/jxxghp/moviepilot-v3:3.2.5
    container_name: moviepilot-v3
    hostname: moviepilot-v3
    stdin_open: true
    tty: true
    ports:
      - "13300:3000"
      - "13301:3001"
    volumes:
      - ./config:/config
      - ./core:/moviepilot/.cloakbrowser
      # 生产示例：- /mnt/nas/media:/media
      - ./media:/media
    environment:
      - NGINX_PORT=3000
      - PORT=3001
      - PUID=0
      - PGID=0
      - UMASK=000
      - TZ=Asia/Shanghai
    restart: always
    stop_grace_period: 120s
EOF
```

| 项 | 说明 |
|----|------|
| `image` | `docker.xuanyuan.run/jxxghp/moviepilot-v3:3.2.5` |
| `ports` | 宿主机 **13300→3000**（Web）、**13301→3001**（API） |
| `volumes` | `/config`、`/moviepilot/.cloakbrowser` 必挂；媒体根目录按实际路径改左边 |
| `stop_grace_period` | V3 停止时会收尾后台任务与插件，建议 **120s** |
| `PUID` / `PGID` | 官方示例为 `0`；若媒体文件属主不是 root，可改成宿主机用户 UID/GID |
| Docker Socket | V3 **不需要**映射 `/var/run/docker.sock`（内建重启由容器内 supervisor 完成） |

### 3. 启动并验证

```bash
docker compose up -d
docker compose ps
docker compose logs -f moviepilot
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network moviepilot-v3_default Created
 ✔ Container moviepilot-v3       Started

NAME            IMAGE                                            COMMAND                  SERVICE      CREATED         STATUS                            PORTS
moviepilot-v3   docker.xuanyuan.run/jxxghp/moviepilot-v3:3.2.5   "/usr/bin/tini -g --…"   moviepilot   5 seconds ago   Up 3 seconds (health: starting)   0.0.0.0:13300->3000/tcp, [::]:13300->3000/tcp, 0.0.0.0:13301->3001/tcp, [::]:13301->3001/tcp
```

首次启动会校正权限、准备数据库，并拉起 Nginx 与后端。日志中可先看到：

```text
[INFO] → 启动容器进程 supervisor...
success: moviepilot-nginx entered RUNNING state
success: moviepilot-backend entered RUNNING state
Application startup complete.
Uvicorn running on http://0.0.0.0:3001
SQLite database journal mode set to: wal
GET /health/ready HTTP/1.1" 200 OK
```

若外网不畅，日志可能出现 CloakBrowser 内核下载超时、插件索引超时或「无法连接 TheMovieDb」。Web 已就绪时，仍可先完成「首次设置」；代理、站点认证等登录后再配。

本机探测 Web：

```bash
curl -I http://127.0.0.1:13300
```

就绪后常见响应：

```text
HTTP/1.1 200 OK
Server: nginx/1.26.3
Content-Type: text/html
Cache-Control: no-cache, no-store, must-revalidate
```

浏览器打开：

```text
http://服务器IP:13300
```

把 `服务器IP` 换成你的主机地址。实测局域网地址为 `http://192.168.1.35:13300`。

## 浏览器初始化

### 1. 首次设置

首次打开会进入「首次设置」页（地址形如 `/#/initialize`）。按页面填写：

1. **超级管理员用户名**（1～50 个字符）。
2. **设置密码**、**再次输入密码**：长度 **6～50**，须包含字母、数字、特殊字符中的**至少两类**；两次必须一致。页面也会提示使用强密码。密码过简时，点「保存并前往登录 →」会失败，日志里常见 `POST /api/v1/login/initialization` 返回 **422**，页面提示「初始化失败，请检查服务状态后重试」。
3. **API 访问密钥**：点「生成」（可「重新生成」或复制），长度须 **≥ 16**，并自行备份。
4. **GITHUB API 访问**可选，首次可跳过。

点「保存并前往登录 →」，成功后进入登录页。

![MoviePilot 首次设置：管理员账号、已生成 API 访问密钥与保存并前往登录](https://imgs.xuanyuan.cloud/docker/blog/moviepilot/moviepilot-1.webp)

### 2. 登录

用刚创建的管理员账号登录。实测示例用户名为 `xuanyuan`。可勾选「保持登录」。页脚可见版本 **v3.2.5**。若出现「用户名或密码错误」，核对用户名与密码后重试。

![MoviePilot 登录页：用户名 xuanyuan、保持登录与登录按钮](https://imgs.xuanyuan.cloud/docker/blog/moviepilot/moviepilot-2.webp)

### 3. 仪表盘

登录后进入「仪表盘」。尚未配置下载器与目录时，存储与媒体统计多为 0，后台任务处于等待。右下角可能提示设置 GitHub Token，可稍后在「设定」里处理。

![MoviePilot 仪表盘：存储空间、媒体统计与后台任务](https://imgs.xuanyuan.cloud/docker/blog/moviepilot/moviepilot-3.webp)

### 4. 基础设置

打开「设定」→「系统」→「基础设置」，可查看访问域名、登录壁纸与 **API 令牌**（与首次设置生成的密钥对应，勿泄露）。GitHub Token、智能助手可按需再配。改完点「保存」。

![MoviePilot 基础设置：访问域名、登录壁纸与 API 令牌](https://imgs.xuanyuan.cloud/docker/blog/moviepilot/moviepilot-4.webp)

### 5. 存储与目录

打开「设定」→「存储 & 目录」。首次进入时，本地与各网盘存储多为「未配置」；用「+」添加存储，再在「目录」中按优先级添加下载目录与媒体库目录，并在「整理 & 刮削」里确认命名与刮削来源。

计划使用硬链接时，下载目录与媒体库都应落在同一容器内根路径下（本文为 `/media`），例如 `/media/downloads` 与 `/media/library`，并保证下载器容器映射到相同的宿主机根目录。

![MoviePilot 存储与目录：本地与网盘未配置、目录与整理刮削](https://imgs.xuanyuan.cloud/docker/blog/moviepilot/moviepilot-9.webp)

### 6. 推荐、探索与订阅入口

侧栏「发现」→「推荐」可浏览正在热映、热门音乐等；「探索」可按豆瓣等来源筛选类型、地区与年代。侧栏「订阅」→「电影」或「电视剧」的「热门订阅」可浏览热门片单。

这些页面用于确认 Web 与元数据源可用。真正自动追更前，还需完成站点用户认证，并在设定里接好下载器与目录；细节见官方 Wiki「基础」与「安装指引」。

![MoviePilot 推荐页：正在热映与本周热门音乐](https://imgs.xuanyuan.cloud/docker/blog/moviepilot/moviepilot-5.webp)

![MoviePilot 探索页：豆瓣电影筛选与海报列表](https://imgs.xuanyuan.cloud/docker/blog/moviepilot/moviepilot-6.webp)

![MoviePilot 电影热门订阅：海报与热度](https://imgs.xuanyuan.cloud/docker/blog/moviepilot/moviepilot-7.webp)

![MoviePilot 电视剧热门订阅：海报与评分](https://imgs.xuanyuan.cloud/docker/blog/moviepilot/moviepilot-8.webp)

不要把管理端口直接暴露到公网。需要远程访问时，优先使用可信组网或 HTTPS 反向代理。

## 备选：docker run

没有 Compose 时，可用下面的命令临时试玩。长期运行请改回 Compose。

```bash
sudo mkdir -p /www/wwwroot/moviepilot-v3/{config,core,media/downloads,media/library}
sudo chown -R "$(id -u):$(id -g)" /www/wwwroot/moviepilot-v3

docker run -d 
  --name moviepilot-v3 
  --hostname moviepilot-v3 
  -p 13300:3000 
  -p 13301:3001 
  -e NGINX_PORT=3000 
  -e PORT=3001 
  -e PUID=0 
  -e PGID=0 
  -e UMASK=000 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/moviepilot-v3/config:/config 
  -v /www/wwwroot/moviepilot-v3/core:/moviepilot/.cloakbrowser 
  -v /www/wwwroot/moviepilot-v3/media:/media 
  --stop-timeout 120 
  --restart always 
  docker.xuanyuan.run/jxxghp/moviepilot-v3:3.2.5
```

查看状态：

```bash
docker ps --filter name=moviepilot-v3
docker logs -f moviepilot-v3
```

## 备份与升级

备份前先停容器，再打包配置目录：

```bash
cd /www/wwwroot/moviepilot-v3
docker compose stop
tar -czf moviepilot-v3-config-backup.tar.gz config
docker compose start
```

| 目录 | 备份策略 |
|------|----------|
| `./config` | **必备份**（配置、数据库、日志） |
| `./core` | 建议保留；丢失后会重新拉取浏览器内核 |
| `./media` 或 NAS 媒体路径 | 按磁盘 / NAS 策略备份，与容器无关 |

升级时只改 `compose.yaml` 里的镜像标签，保留上述目录后执行：

```bash
docker compose pull
docker compose up --force-recreate -d
```

从 V2 切到 V3 时，保留原有 `/config` 映射，把镜像换成 `jxxghp/moviepilot-v3` 后拉取并重建；不要只靠重启旧容器跨主版本。V3 完成数据库升级后不能直接换回 V2 镜像，回退须按官方「从 V3 降级回 V2」说明操作。大版本升级前先阅读 [V3 版本说明](https://wiki.movie-pilot.org/zh/v3) 与 [升级](https://wiki.movie-pilot.org/upgrade)。

## 常见问题

### 默认用户名和密码是什么

没有默认账号。首次打开 Web 进入「首次设置」，自行创建管理员并生成 API 访问密钥。

### 保存并前往登录提示「初始化失败」怎么办

先确认 `curl -I http://127.0.0.1:13300` 为 **200**，且日志有 `Application startup complete`。若同时出现 `POST /api/v1/login/initialization` → **422**，是表单未通过校验，不是服务宕机。实测最常见原因是**密码过简**（未同时满足字母 / 数字 / 特殊字符中的至少两类）。再检查两次密码是否一致、是否已生成长度不少于 16 的 API 访问密钥。改完后刷新页面再点「保存并前往登录 →」。

### 可以用 latest 吗

`latest` 是浮动标签，发版后会改指向。本文命令使用 **`3.2.5`**。说明见「标签怎么选」。

### 为什么访问端口是 13300 而不是 3000

容器内 Web 仍听 **3000**。宿主机 **3000** 常被本机前端占用，本文改映为 **13300**。浏览器打开 `http://IP:13300`；`NGINX_PORT` 仍保持 **3000**，不要改成 13300。

### 需要映射 Docker Socket 吗

V3 不需要。镜像内 supervisor 负责 Nginx 与后端的内建重启；`--restart always` 只负责容器异常退出或主机重启后的恢复。

### 为什么要设 stop_grace_period 120s

V3 停止时会依次关闭后台任务、插件等模块。时间太短可能被强制杀掉。Compose 用 `stop_grace_period: 120s`，`docker run` 用 `--stop-timeout 120`。

### 页面打不开怎么办

先看 `docker compose ps` 是否为 Up，再看 `docker compose logs --tail 100 moviepilot`。确认宿主机 **13300** / **13301** 未被占用，并检查防火墙是否放行。

### 日志里 CloakBrowser / GitHub / TheMovieDb 报错要紧吗

外网不畅时可能出现。Web 与健康检查正常时，不影响先完成「首次设置」。登录后可在「设定」配置代理；需要站点搜索、订阅、下载时，再到头像菜单完成「用户认证」。

### 和下载器路径对不上

MoviePilot 与下载器应看到一致的文件路径。例如双方都把宿主机 `/mnt/nas/media` 映射为容器内 `/media`，则下载与整理都按 `/media/...` 配置。不在同一 Docker 网络时，下载器地址可先用局域网 IP 测试。

### 可以从 V2 原地升级吗

可以复用 `/config` 等数据，但必须换成 V3 镜像并重建容器，不能只重启 V2 容器。细节见官方升级文档。

### 删容器会丢片吗

配置与库状态在 `./config`；媒体文件在宿主机 `media`（或你挂载的 NAS 路径）。`docker compose down` 不删这些目录则都在。

## 命令速查

```bash
docker pull docker.xuanyuan.run/jxxghp/moviepilot-v3:3.2.5

cd /www/wwwroot/moviepilot-v3
docker compose up -d
docker compose ps
docker compose logs -f moviepilot

# 本机打开 http://127.0.0.1:13300 完成首次设置

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [jxxghp/moviepilot-v3 镜像页](https://xuanyuan.cloud/r/jxxghp/moviepilot-v3?xy_from=moviepilot-v3-docker-deploy) | [https://xuanyuan.cloud/r/jxxghp/moviepilot-v3](https://xuanyuan.cloud/r/jxxghp/moviepilot-v3?xy_from=moviepilot-v3-docker-deploy) |
| [jxxghp/moviepilot-v3 标签列表](https://xuanyuan.cloud/r/jxxghp/moviepilot-v3/tags?xy_from=moviepilot-v3-docker-deploy) | [https://xuanyuan.cloud/r/jxxghp/moviepilot-v3/tags](https://xuanyuan.cloud/r/jxxghp/moviepilot-v3/tags?xy_from=moviepilot-v3-docker-deploy) |
| [Docker Hub · jxxghp/moviepilot-v3](https://hub.docker.com/r/jxxghp/moviepilot-v3) | [https://hub.docker.com/r/jxxghp/moviepilot-v3](https://hub.docker.com/r/jxxghp/moviepilot-v3) |
| [MoviePilot 官网](https://movie-pilot.org) | [https://movie-pilot.org](https://movie-pilot.org) |
| [安装指引（Wiki）](https://wiki.movie-pilot.org/install) | [https://wiki.movie-pilot.org/install](https://wiki.movie-pilot.org/install) |
| [V3 版本说明](https://wiki.movie-pilot.org/zh/v3) | [https://wiki.movie-pilot.org/zh/v3](https://wiki.movie-pilot.org/zh/v3) |
| [GitHub · jxxghp/MoviePilot](https://github.com/jxxghp/MoviePilot) | [https://github.com/jxxghp/MoviePilot](https://github.com/jxxghp/MoviePilot) |
| [Release v3.2.5](https://github.com/jxxghp/MoviePilot/releases/tag/v3.2.5) | [https://github.com/jxxghp/MoviePilot/releases/tag/v3.2.5](https://github.com/jxxghp/MoviePilot/releases/tag/v3.2.5) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=moviepilot-v3-docker-deploy) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage?xy_from=moviepilot-v3-docker-deploy) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/moviepilot-v3-docker-deploy?xy_from=moviepilot-v3-docker-deploy)

*本文基于 [jxxghp/moviepilot-v3:3.2.5](https://xuanyuan.cloud/r/jxxghp/moviepilot-v3?xy_from=moviepilot-v3-docker-deploy)，以 **3.2.5** 版本实测，测试平台 **Ubuntu 24.04** Linux（`ikuai-ubuntu2404`）。*


