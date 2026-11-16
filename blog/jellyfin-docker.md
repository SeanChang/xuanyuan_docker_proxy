# jellyfin Docker 容器化部署指南

![jellyfin Docker 容器化部署指南](https://imgs.xuanyuan.cloud/docker/blog/docker-jellyfin.png)

*分类: Docker部署教程 | 标签: jellyfin,docker,部署教程 | 发布时间: 2025-12-11 04:14:39*

> Jellyfin 是开源免费的媒体服务器，用来集中管理电影、剧集、音乐与相册，并在浏览器、手机与电视客户端上流式播放。本文将介绍如何通过 Docker Compose 部署官方镜像 jellyfin/jellyfin，把片库留在本机目录，适合家庭影音库、NAS 自托管与内网观影。

## Jellyfin 是什么

Jellyfin 是开源、无订阅费用的媒体服务器。它把本机或 NAS 上的电影、剧集、音乐与图片整理成媒体库，再通过浏览器、手机 App 与智能电视客户端串流播放；客户端无法直通时，可由服务端转码。

和按文件夹用播放器硬翻不同，它统一管理海报、简介与观看进度，多设备可接着看。和商业流媒体或带会员档位的私有影院方案不同，服务与片库都留在你自己的机器上。官方容器镜像是 **`jellyfin/jellyfin`**。

## Jellyfin 能做什么

- **媒体库管理**：按电影、剧集、音乐、相册等类型组织本地文件，并拉取海报与简介。
- **多端串流**：在浏览器、手机与电视客户端播放，并同步观看进度。
- **按需转码**：客户端不便直通时，由服务端转码或烧录字幕后再送出。
- **用户与权限**：自建管理员与普通用户，按库控制可见范围。
- **插件扩展**：安装元数据、字幕等插件，并配合官方与社区客户端使用。

## 为什么要使用 Jellyfin

硬盘和 NAS 里影片越堆越多，文件夹硬翻效率低，各设备进度也对不上。商业流媒体要订阅，片源不在自己手里；家庭录像、已购碟片也不适合再上传到第三方云。

如果家里已有一台常开的 Linux 主机或 NAS，用 Jellyfin 可以把片库留在本地，浏览器完成建库与播放。适合家庭影音中心、内网观影，以及希望数据不出域的自托管场景。

## 使用 Docker 部署 Jellyfin

Jellyfin 可以用 Docker 启动，不必在宿主机单独安装 .NET 运行时。部署前准备好 Docker，并规划配置目录、缓存目录与真实片库路径。

接下来用 Docker Compose 写好镜像、端口与卷，启动服务，再在浏览器完成首次向导、添加媒体库并确认能打开首页。

## 环境要求

本文使用 **`jellyfin/jellyfin:12.4`** 版本实测。测试平台是 Ubuntu 24.04（主机名 `ikuai-ubuntu2404`）。容器日志中的版本为 **12.4.0**，基础系统为 Debian GNU/Linux 13（trixie）。`12.4` 是当前稳定发行版；`latest`、`12` 会随发版改指向，本文命令固定 **`12.4`**。镜像提供 **linux/amd64**、**linux/arm64** 等架构。

容器内 Web 听 **8096/tcp**；可选 **7359/udp** 供部分客户端局域网发现。无预置账号，首次向导里自建管理员。官方容器文档以 **Linux** 为主路径；在 Windows / macOS 上用容器跑 Jellyfin 不被官方支持，硬解与扫库等能力可能异常。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文按 Ubuntu 目录书写）；macOS 把 `/www/wwwroot/jellyfin-official` 换成 `~/docker/jellyfin-official` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64** 或 **linux/arm64** |
| 内存 | 建议可用 ≥ **2 GB**（转码时宜更宽裕） |
| 磁盘 | 镜像数百 MB 量级，另加 `config`、`cache` 与片库空间 |
| 端口 | 宿主机 **8096** → 容器 **8096**；可选 **7359/udp** |
| 工作目录 | `/www/wwwroot/jellyfin-official` |
| 账号 | 无默认密码；首次向导创建管理员 |
| 硬解（可选） | Intel / AMD：`/dev/dri`；NVIDIA：主机驱动 + 容器 GPU |

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

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=jellyfin-official-docker-deploy)。

## 标签怎么选

新安装使用 **`12.4`**。不要把 `latest`、`unstable` 或纯日期戳预览标签写进 Compose。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`12.4`** | 当前稳定发行版，本文采用 | **是** |
| `12.3`、`12.2` 等 | 更早稳定版，便于回滚 | 否 |
| `12` | 主版本滚动线 | 否 |
| `latest` | 浮动稳定线，发版后会变 | 否 |
| `unstable` / `YYYYMMDDHH` | 预览 / 日构建 | 否 |
| `12.4.YYYYMMDD-HHMMSS` | 某一包构建快照 | 否 |

完整列表见 [标签列表](https://xuanyuan.cloud/r/jellyfin/jellyfin/tags?xy_from=jellyfin-official-docker-deploy)。发布说明见 [v12.4](https://github.com/jellyfin/jellyfin/releases/tag/v12.4)。升级时改 Compose 中的标签，并先备份 `config`。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud/?xy_from=jellyfin-official-docker-deploy) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/jellyfin/jellyfin:12.4
```

Ubuntu 24.04 上拉取完成：

```text
12.4: Pulling from jellyfin/jellyfin
2ad4c3afb22d: Pull complete
526fffcbc249: Pull complete
e4f64296b96e: Pull complete
4f4fb700ef54: Pull complete
5ec2bdefc613: Pull complete
00d1feae788f: Pull complete
f2be67225471: Pull complete
eb04fc9266f4: Pull complete
da8ad6b41798: Pull complete
0a41bce6ef14: Pull complete
Digest: sha256:fea863d0cd9ec445985d9c75fc6ed64e38a1d2766cf0c250a33d553f4fc1b771
Status: Downloaded newer image for docker.xuanyuan.run/jellyfin/jellyfin:12.4
docker.xuanyuan.run/jellyfin/jellyfin:12.4
```

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq?xy_from=jellyfin-official-docker-deploy)。

## Docker Compose 部署

工作目录：Linux **`/www/wwwroot/jellyfin-official`**。macOS 用 **`~/docker/jellyfin-official`**。

| 宿主机目录 | 容器内路径 | 用途 |
|------------|------------|------|
| `config/` | `/config` | **必挂**：数据库、用户、插件、库元数据（务必备份） |
| `cache/` | `/cache` | **必挂**：转码临时文件与图片缓存（可清空重建） |
| `media/` 或真实盘符 | `/media` | 片库；生产请改成 NAS / 磁盘路径，建议 `:ro` |

向导里选的是**容器内**路径 `/media`，不是宿主机路径。把影片放进宿主机片库目录，或把 Compose 里的 `./media` 改成例如 `/mnt/nas/movies`。

### 1. 创建目录

```bash
sudo mkdir -p /www/wwwroot/jellyfin-official/{config,cache,media}
sudo chown -R "$(id -u):$(id -g)" /www/wwwroot/jellyfin-official
cd /www/wwwroot/jellyfin-official
```

macOS：

```bash
mkdir -p ~/docker/jellyfin-official/{config,cache,media}
cd ~/docker/jellyfin-official
```

### 2. 写入 compose.yaml

```bash
cd /www/wwwroot/jellyfin-official

cat > compose.yaml <<'EOF'
services:
  jellyfin:
    image: docker.xuanyuan.run/jellyfin/jellyfin:12.4
    container_name: jellyfin
    # 可选：与宿主机用户一致，避免 /config 权限问题
    # user: "1000:1000"
    ports:
      - "8096:8096/tcp"
      - "7359:7359/udp"
    volumes:
      - ./config:/config
      - ./cache:/cache
      # 生产示例：- /mnt/nas/movies:/media:ro
      - ./media:/media:ro
    environment:
      - TZ=Asia/Shanghai
      # 可选：- JELLYFIN_PublishedServerUrl=http://192.168.1.10:8096
    restart: unless-stopped
    # 硬解见「硬件加速」；默认注释
    # group_add:
    #   - "44"   # getent group render
    # devices:
    #   - /dev/dri:/dev/dri
EOF
```

| 项 | 说明 |
|----|------|
| `image` | `docker.xuanyuan.run/jellyfin/jellyfin:12.4` |
| `ports` | **8096** Web；**7359/udp** 局域网发现（不需要可删） |
| `volumes` | `/config`、`/cache` 必挂；片库按实际路径改左边 |
| `:ro` | 片库只读，降低误写；需要就地改文件名，或写回封面 / 字幕时去掉 |
| `user` | 非 root 运行时，先保证宿主机目录属主匹配 |

### 3. 启动并验证

```bash
docker compose up -d
docker compose ps
docker compose logs -f jellyfin
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network jellyfin-official_default Created
 ✔ Container jellyfin                Started

NAME       IMAGE                                        COMMAND                SERVICE    CREATED         STATUS                            PORTS
jellyfin   docker.xuanyuan.run/jellyfin/jellyfin:12.4   "/jellyfin/jellyfin"   jellyfin   7 seconds ago   Up 4 seconds (health: starting)   0.0.0.0:7359->7359/udp, [::]:7359->7359/udp, 0.0.0.0:8096->8096/tcp, [::]:8096->8096/tcp
```

首次启动会初始化数据库，日志很长。可先看到：

```text
[INF] Jellyfin.Server.ServerSetupApp.SetupServer: Kestrel is listening on 0.0.0.0
[INF] Main: Jellyfin version: 12.4.0
[INF] Main: Operating system: Debian GNU/Linux 13 (trixie)
[INF] Main: Architecture: X64
```

迁移未结束时，本机探测可能失败（例如 `Connection reset by peer`）。稍等再试：

```bash
curl -I http://127.0.0.1:8096
```

就绪后常见响应：

```text
HTTP/1.1 302 Found
Date: Tue, 10 Nov 2026 02:49:28 GMT
Server: Kestrel
Location: web/
```

浏览器打开：

```text
http://服务器IP:8096
```

把 `服务器IP` 换成你的主机地址。

## 浏览器初始化

向导里添加文件夹时，只选容器内的 **`/media`**，不要选容器根 `/`。选错会扫到 `/dev`、`/proc` 一类路径。生产环境请把真实影片挂进宿主机片库目录；截图里的库是空的，用来演示路径是否选对。

### 1. 欢迎页与语言

打开地址进入首次向导。可修改「服务器名称」（默认常是容器主机名），「首选的显示语言」选「中文 (中国)」，再点「下一个」。

![Jellyfin 欢迎向导：服务器名称与首选显示语言「中文 (中国)」](https://imgs.xuanyuan.cloud/docker/blog/Jellyfin-official/Jellyfin-1.webp)

### 2. 创建管理员

填写管理员用户名与密码。没有默认账号。实测示例用户名为 `root`；生产环境请使用强密码。

![Jellyfin 创建管理员：用户名 root，密码与确认密码](https://imgs.xuanyuan.cloud/docker/blog/Jellyfin-official/Jellyfin-2.webp)

### 3. 添加媒体库

进入「设置你的媒体库」，点「添加媒体库」。

![Jellyfin 设置媒体库：蓝色加号卡片「添加媒体库」](https://imgs.xuanyuan.cloud/docker/blog/Jellyfin-official/Jellyfin-3.webp)

在弹窗中把「内容类型」选为「电影」（或剧集、音乐等），显示名称可保持默认。点「文件夹」旁的「+」，进入目录树中的 **`media`** 后确认，不要停在 `/`。

本文 Compose 把片库挂成 `:ro`。若勾选「将图像保存到媒体文件夹」或「将字幕保存到媒体文件夹」，写入会失败。截图里「将字幕保存到媒体文件夹」仍为勾选状态，按本文挂载时请取消，或去掉 `:ro`。

![Jellyfin 添加媒体库：内容类型「电影」，文件夹尚未添加](https://imgs.xuanyuan.cloud/docker/blog/Jellyfin-official/Jellyfin-4.webp)

保存后，库卡片应显示路径 **`/media`**。若显示为 `/`，删掉该库后重新添加。

![Jellyfin 媒体库列表：电影库路径为 /media](https://imgs.xuanyuan.cloud/docker/blog/Jellyfin-official/Jellyfin-5.webp)

### 4. 元数据语言与远程访问

「首选的元数据语言」里选择语言与国家/地区。截图示例为 English / United States；需要中文元数据时改成对应选项即可，之后仍可在单个媒体库里覆盖。

![Jellyfin 首选元数据语言：English，United States](https://imgs.xuanyuan.cloud/docker/blog/Jellyfin-official/Jellyfin-6.webp)

「允许远程连接」默认勾选。取消后，来自非本地网络的连接会被拒绝。局域网试用可保持勾选；需要从公网访问时，更稳妥的是反代或 VPN，而不是直接裸暴露。

![Jellyfin 设置远程访问：允许远程连接已勾选](https://imgs.xuanyuan.cloud/docker/blog/Jellyfin-official/Jellyfin-7.webp)

### 5. 完成并向导后登录

点「完成」。界面会提示 Jellyfin 已开始收集媒体库信息。

![Jellyfin 向导完成页：完成按钮](https://imgs.xuanyuan.cloud/docker/blog/Jellyfin-official/Jellyfin-8.webp)

用刚才创建的管理员账号登录。可勾选「记住我」。

![Jellyfin 登录页：用户 root、记住我与登录按钮](https://imgs.xuanyuan.cloud/docker/blog/Jellyfin-official/Jellyfin-9.webp)

### 6. 首页与空库

登录后进入首页。「我的媒体」下会出现库卡片。截图里服务器名显示为 `myjellyfin`，以你在向导或控制台里设置的名称为准。

![Jellyfin 首页：我的媒体下「电影」库卡片](https://imgs.xuanyuan.cloud/docker/blog/Jellyfin-official/Jellyfin-10.webp)

进入「电影」库时，若宿主机 `media/` 还没有影片，会显示「这里没有可显示的内容。」把真实影片放进挂载目录后，到控制台执行扫描即可。

![Jellyfin 电影库为空：没有可用的项](https://imgs.xuanyuan.cloud/docker/blog/Jellyfin-official/Jellyfin-11.webp)

### 7. 控制台

点右上角用户头像，打开「控制台」。应能看到服务器、Web、构建版本均为 **12.4**，以及 `/config`、`/cache` 等路径。可点「扫描所有媒体库」查看进度。

![Jellyfin 控制台：版本 12.4，路径映射与活动](https://imgs.xuanyuan.cloud/docker/blog/Jellyfin-official/Jellyfin-12.webp)

左侧「插件」可查看已安装的元数据插件。实测内置插件版本为 **12.4.0.0**。

![Jellyfin 插件页：已安装 TMDb、OMDb 等，版本 12.4.0.0](https://imgs.xuanyuan.cloud/docker/blog/Jellyfin-official/Jellyfin-13.webp)

客户端见 [Jellyfin 下载页](https://jellyfin.org/downloads/)。局域网内也可用浏览器播放。

## 硬件加速（可选）

默认 Compose **不**挂 GPU。客户端能直通播放时，不必开硬解。弱网降码率、多路同时转码、字幕烧录，或封装不被客户端支持时，再考虑硬件加速。

### Intel / AMD（VA-API / QSV）

1. 确认设备：`ls -l /dev/dri`
2. 查 render 组 GID：`getent group render`
3. 在 Compose 中取消注释 `group_add` 与 `devices`，把 GID 换成你的
4. 执行 `docker compose up -d`
5. 打开「控制台」→「播放」→「转码」，启用对应硬件加速并保存

### NVIDIA

宿主机需安装专有驱动，并按 [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) 配置。Compose 可按 Docker / Compose 版本增加类似配置：

```yaml
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

在播放设置里选 NVIDIA 相关选项。未挂设备前，即使在控制台勾选硬解，也不会真正走 GPU。

## 备选：docker run

没有 Compose 时，可用下面的命令临时试玩。长期运行请改回 Compose。

```bash
sudo mkdir -p /www/wwwroot/jellyfin-official/{config,cache,media}
sudo chown -R "$(id -u):$(id -g)" /www/wwwroot/jellyfin-official
cd /www/wwwroot/jellyfin-official

docker run -d 
  --name jellyfin 
  -p 8096:8096/tcp 
  -p 7359:7359/udp 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/jellyfin-official/config:/config 
  -v /www/wwwroot/jellyfin-official/cache:/cache 
  -v /www/wwwroot/jellyfin-official/media:/media:ro 
  --restart unless-stopped 
  docker.xuanyuan.run/jellyfin/jellyfin:12.4
```

Intel / AMD 硬解可按需追加：

```bash
  --group-add 44 
  --device /dev/dri:/dev/dri 
```

查看状态：

```bash
docker ps --filter name=jellyfin
docker logs -f jellyfin
```

## 备份与升级

备份前先停容器，再打包配置目录：

```bash
cd /www/wwwroot/jellyfin-official
docker compose stop
tar -czf jellyfin-config-backup.tar.gz config
docker compose start
```

| 目录 | 备份策略 |
|------|----------|
| `./config` | **必备份**（用户、库元数据、插件） |
| `./cache` | 可不备份，可删后重建 |
| 片库宿主机路径 | 按磁盘 / NAS 策略备份，与容器无关 |

升级时只改 `compose.yaml` 里的镜像标签，保留上述目录后执行：

```bash
docker compose pull
docker compose up -d
```

大版本升级前先阅读官方发布说明，并确认已备份 `config`。需要公网访问时，建议反代 HTTPS，并设置 `JELLYFIN_PublishedServerUrl` 与防火墙。

## 常见问题

### 默认用户名和密码是什么

没有默认账号。首次启动后进入向导，自行创建管理员。

### 可以用 latest 吗

`latest` 是浮动标签，发版后会改指向。本文命令使用 **`12.4`**。说明见「标签怎么选」。

### 和 nyanmisaka/jellyfin、linuxserver/jellyfin 怎么选

要官方发版节奏与官方构建 → **`jellyfin/jellyfin`**（本文）。习惯 LinuxServer 的 `PUID` / `PGID` → `linuxserver/jellyfin`。更侧重社区硬解与较新 FFmpeg 管线 → 可看同站 `nyanmisaka/jellyfin` 教程。同一台机器不要用相同容器名和相同宿主机端口同时开两套。

### 刚启动时 curl 报 Connection reset by peer

首次安装会跑较长时间的数据库初始化。`8096` 尚未就绪时会出现连接被重置。稍后再执行 `curl -I`；成功时常见为 `302`，且 `Location: web/`。

### 日志狂刷 `/dev` `/proc`，或库路径显示为 `/`

向导里误选了容器根。删掉该媒体库，只加 **`/media`**，并把宿主机真实视频目录挂上去。

### 首页没有电影海报

片库目录是空的，或内容类型选错。放入真实影片并选对类型后，到控制台扫描所有媒体库。空库时页面会显示「这里没有可显示的内容。」

### `/config` 权限报错怎么办

用 `user: "UID:GID"` 对齐属主，或先对数据目录执行 `chown`。

### 直通流畅，一转码就卡

直通几乎不吃 CPU；转码要软解或硬解。检查是否挂了设备、是否在控制台启用了对应加速、客户端是否强制转码。

### 必须映射 7359 吗

不必。只影响部分客户端的局域网自动发现；可手动填写 `http://IP:8096`。

### 宿主机 8096 被占用怎么办

把 Compose 里的 `"8096:8096"` 改成例如 `"18096:8096"`，访问 `http://IP:18096`，并视需要设置 `JELLYFIN_PublishedServerUrl`。然后执行 `docker compose up -d`。

### 片库挂了 `:ro`，还能把图像或字幕保存到媒体文件夹吗

不能。只读挂载下无法往片库写 NFO、封面或字幕。需要就地写回时去掉 `:ro`；否则关掉这两项，让元数据只进 `/config`。

### 删容器会丢片吗

用户与库元数据在 `./config`；片文件在宿主机挂载目录。`docker compose down` 不删这些目录则都在。

## 命令速查

```bash
docker pull docker.xuanyuan.run/jellyfin/jellyfin:12.4

cd /www/wwwroot/jellyfin-official
docker compose up -d
docker compose ps
docker compose logs -f jellyfin

# 本机打开 http://127.0.0.1:8096 完成向导；片库文件夹选 /media

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [jellyfin/jellyfin 镜像页](https://xuanyuan.cloud/r/jellyfin/jellyfin?xy_from=jellyfin-official-docker-deploy) | [https://xuanyuan.cloud/r/jellyfin/jellyfin](https://xuanyuan.cloud/r/jellyfin/jellyfin?xy_from=jellyfin-official-docker-deploy) |
| [jellyfin/jellyfin 标签列表](https://xuanyuan.cloud/r/jellyfin/jellyfin/tags?xy_from=jellyfin-official-docker-deploy) | [https://xuanyuan.cloud/r/jellyfin/jellyfin/tags](https://xuanyuan.cloud/r/jellyfin/jellyfin/tags?xy_from=jellyfin-official-docker-deploy) |
| [Docker Hub · jellyfin/jellyfin](https://hub.docker.com/r/jellyfin/jellyfin) | [https://hub.docker.com/r/jellyfin/jellyfin](https://hub.docker.com/r/jellyfin/jellyfin) |
| [Jellyfin 官网](https://jellyfin.org/) | [https://jellyfin.org/](https://jellyfin.org/) |
| [Jellyfin 容器安装文档](https://jellyfin.org/docs/general/installation/container/) | [https://jellyfin.org/docs/general/installation/container/](https://jellyfin.org/docs/general/installation/container/) |
| [GitHub Releases · v12.4](https://github.com/jellyfin/jellyfin/releases/tag/v12.4) | [https://github.com/jellyfin/jellyfin/releases/tag/v12.4](https://github.com/jellyfin/jellyfin/releases/tag/v12.4) |
| [Jellyfin 客户端下载](https://jellyfin.org/downloads/) | [https://jellyfin.org/downloads/](https://jellyfin.org/downloads/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=jellyfin-official-docker-deploy) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage?xy_from=jellyfin-official-docker-deploy) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/jellyfin-official-docker-deploy?xy_from=jellyfin-official-docker-deploy)

*本文基于 [jellyfin/jellyfin:12.4](https://xuanyuan.cloud/r/jellyfin/jellyfin?xy_from=jellyfin-official-docker-deploy)，以 **12.4** 版本实测（引擎 **12.4.0**），测试平台 **Ubuntu 24.04** Linux（`ikuai-ubuntu2404`）。*

