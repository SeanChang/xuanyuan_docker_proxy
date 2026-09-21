# Docker 一键部署 Jellyfin：快速搭建私有化媒体服务器

![Docker 一键部署 Jellyfin：快速搭建私有化媒体服务器](https://imgs.xuanyuan.cloud/docker/blog/jellyfin.webp)

*分类: Docker部署教程 | 标签: Jellyfin,nyanmisaka/jellyfin,Docker,轩辕镜像,媒体服务器,硬件加速,影音库,私有化部署,部署教程 | 发布时间: 2026-09-19 08:04:54*

> Jellyfin 是开源免费的媒体服务器，可集中管理电影、剧集、音乐与相册，并在手机、电视、浏览器上流式播放。本文将介绍如何通过 Docker Compose 部署社区硬件加速构建 nyanmisaka/jellyfin，用轩辕镜像加速拉取，适合家庭影音库、NAS 自托管与内网观影等场景。

*本文基于 [nyanmisaka/jellyfin:260326-amd64](https://xuanyuan.cloud/zh/r/nyanmisaka/jellyfin)，实测引擎 **Jellyfin 10.10.7**（FFmpeg **7.1.3**，构建 **260326**），测试平台 **Ubuntu 24.04** Linux。*

硬盘里电影、剧集、演唱会录像越堆越多：有人按文件夹用播放器硬翻；有人把库丢进网盘，流量与审核都不可控；客厅电视直连 SMB，4K HEVC / HDR 一开就卡成幻灯片——CPU 软解把整机拖死，风扇狂转，画面还在转圈缓冲。手机想接着看刚才的进度，各端进度条又对不上。

商业流媒体或第三方「私人影院」云，又会碰到账号共享、片源合规和数据出域：自家硬盘上的蓝光拆包、家庭录像、演唱会录屏，本来就该留在内网。很多家里已经有一台跑 Docker 的 Ubuntu 或 NAS，缺的是：**服务能拉起来、片库挂进去、浏览器打开就能建库扫库；需要转码时再把核显 / 独显塞进容器做硬解**。

**Jellyfin**（[官网](https://jellyfin.org/)、[容器文档](https://jellyfin.org/docs/general/installation/container/)）是开源、无订阅的媒体服务器：管理本地音视频与图片，向浏览器、手机 App、智能电视客户端串流，必要时服务端转码。本文用的 **`nyanmisaka/jellyfin`**（[镜像页](https://xuanyuan.cloud/r/nyanmisaka/jellyfin)）是维护者 **nyanmisaka** 的硬件加速向构建，集成较新的 Jellyfin-FFmpeg，强化 Intel / AMD / NVIDIA / Rockchip 硬解硬编与 HDR 色调映射。挂载约定与官方容器一致：`/config`、`/cache`、媒体目录；Web 默认 **8096**。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 打开向导 | `http://服务器IP:8096`，创建管理员并添加媒体库 |
| 扫片开播 | 片库挂进 `/media`，库内点播或用官方客户端 |
| 硬件转码（可选） | 挂 `/dev/dri` 或 NVIDIA 设备后，在控制台启用硬解 |
| 备份搬家 | 停容器后打包宿主机 `./config` |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`nyanmisaka/jellyfin:260326-amd64`**，**Docker Compose** 启动。把下文 IP、片库路径换成你的。无 Compose 见第八节。文内 **14** 张截图为界面跟做参考；片库请挂**真实视频目录**，向导文件夹选 **`/media`**（勿选 `/`）。

> **上手要点**
> - **主路径**：第四节 Compose；备选 `docker run` 见第八节
> - **端口**：宿主机 **8096** → 容器 **8096**；可选 UDP **7359**（局域网发现）
> - **标签**：跟做 **`260326-amd64`**；arm64 用 **`260326-arm64`**；勿写 `latest`
> - **体积**：DISK **2.01GB** / CONTENT **603MB**（amd64）
> - **挂载**：`./config`→`/config`、`./cache`→`/cache`；片库把宿主机真实目录挂到 **`/media`**（示例 `./media`，生产改成 NAS / 磁盘路径）
> - **账号**：无预置密码；向导里自建管理员
> - **启动标志**：`Jellyfin version: 10.10.7`、`Kestrel is listening`、`Startup complete`
> - **目录**：Linux `/www/wwwroot/jellyfin`；macOS `~/docker/jellyfin`
> - **硬解**：默认不挂 GPU；需要时见第六节

官方：[容器安装](https://jellyfin.org/docs/general/installation/container/) · [镜像页](https://xuanyuan.cloud/r/nyanmisaka/jellyfin) · [标签列表](https://xuanyuan.cloud/r/nyanmisaka/jellyfin/tags) · [Docker Hub](https://hub.docker.com/r/nyanmisaka/jellyfin) · [维护者](https://github.com/nyanmisaka)

---

## 一、nyanmisaka/jellyfin 是什么？

![Jellyfin 品牌标识：紫色三角图标与白色字标](https://imgs.xuanyuan.cloud/docker/blog/jellyfin-0.webp)

`nyanmisaka/jellyfin` 跑的是 Jellyfin 服务端：配置与用户数据在 `/config`，转码与缩略图缓存在 `/cache`，电影 / 剧集 / 音乐通过绑定挂载进入容器，浏览器或客户端连 **8096**。相对官方 `jellyfin/jellyfin`，本镜像更侧重硬解管线与较新 FFmpeg（VA-API / QSV / NVENC、HDR / DoVi、Rockchip 等），适合已有核显或独显、想减轻 CPU 软解压力的家庭与 NAS 场景。

| | nyanmisaka/jellyfin（本文） | jellyfin/jellyfin | linuxserver/jellyfin |
|--|------------------------------|-------------------|----------------------|
| 定位 | 社区硬件加速构建 | 官方稳定构建 | LinuxServer 维护版 |
| 标签 | **日期 + 架构**（如 `260326-amd64`） | 语义化版本号 | 语义化 / `latest` |
| 硬解 | 构建与文档偏硬解 / HDR | 官方通用支持 | 常用 `/dev/dri` + PUID |
| 适合 | 要新 FFmpeg / 硬解特性 | 跟官方发版节奏 | 习惯 LSIO 环境变量 |

```text
浏览器 / 客户端 ──HTTP:8096──▶  nyanmisaka/jellyfin
                                  ├── /config  ← ./config（库、用户、插件）
                                  ├── /cache   ← ./cache（转码与缩略图）
                                  └── /media   ← 宿主机片库（建议只读）
```

同站还有官方 `jellyfin/jellyfin`、`linuxserver/jellyfin` 等，**本文只跟做 `nyanmisaka/jellyfin:260326-amd64`**。详情页 [`/r/`](https://xuanyuan.cloud/r/nyanmisaka/jellyfin) 与 [`/zh/r/`](https://xuanyuan.cloud/zh/r/nyanmisaka/jellyfin) 为同一镜像的不同语言路径。

### 1.1 标签怎么理解

| 标签线 | 说明 |
|--------|------|
| **`YYMMDD-amd64` / `YYMMDD-arm64`** | 按构建日 + 架构；跟做主路径 |
| `latest` | 浮动主线（多为 amd64）；**勿写入跟做命令** |
| `latest-rockchip` | RK3588 完整硬解（RKMPP/RGA），**仅 arm64** |
| `*-testing` | 测试构建；生产勿跟 |

维护者说明：`latest` 线用 Jellyfin-FFmpeg 7.x 与较新 Intel Compute-Runtime；`latest-rockchip` 专为 RK3588。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux（建议 Ubuntu 24.04）；也可 Docker Desktop |
| Docker | Engine + **Compose V2**（建议 ≥ 20.10） |
| 架构 | 跟做 **amd64**；arm64 换对应标签 |
| 内存 | 可用 ≥ **2 GB**（转码时宜更宽裕） |
| 磁盘 | 镜像层约 **2 GB**，另加片库与 `/cache` 增长空间 |
| 端口 | 宿主机 **8096/tcp**；可选 **7359/udp** |
| 工作目录 | `/www/wwwroot/jellyfin` |
| 硬解（可选） | Intel/AMD：`/dev/dri`；NVIDIA：主机驱动 + 容器 GPU |

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

该镜像以 **`YYMMDD-架构`** 命名，**不是**官方镜像那种 `10.10.7` 语义化标签；选标签必须带架构后缀。

| 标签 | 说明 | 是否跟做 |
|------|------|----------|
| **`260326-amd64`** | 较新的非 testing 日期构建（amd64） | **推荐（本文）** |
| `260326-arm64` | 同上，arm64 | arm64 机器改用 |
| `251212-amd64` 等 | 更早日期线 | 可回滚 |
| `*-testing` | 测试线 | 仅尝鲜 |
| `latest` | 浮动 | **勿写入跟做命令** |
| `latest-rockchip` | RK3588 | 仅 Rockchip arm64 |

完整列表见 [轩辕标签列表](https://xuanyuan.cloud/r/nyanmisaka/jellyfin/tags) / [Docker Hub Tags](https://hub.docker.com/r/nyanmisaka/jellyfin/tags)。升级时改 Compose 中的标签并核对维护者说明。

### 3.2 用轩辕镜像加速拉取

```bash
docker pull docker.xuanyuan.run/nyanmisaka/jellyfin:260326-amd64
```

Ubuntu 24.04 实测（amd64）：

```text
260326-amd64: Pulling from nyanmisaka/jellyfin
6db0909c4473: Pull complete
810f0c947b06: Pull complete
8321119095ee: Pull complete
0d0a5e6f4b4c: Pull complete
4f4fb700ef54: Pull complete
7142f09dab97: Pull complete
40fd9dd30eba: Pull complete
921ddec2e740: Pull complete
Digest: sha256:31235bcd44f30bad797c2c9ee989cf4fe928919008bbc9b98938ea346372a282
Status: Downloaded newer image for docker.xuanyuan.run/nyanmisaka/jellyfin:260326-amd64
docker.xuanyuan.run/nyanmisaka/jellyfin:260326-amd64
```

```bash
docker images docker.xuanyuan.run/nyanmisaka/jellyfin:260326-amd64
```

```text
IMAGE                                                  ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/nyanmisaka/jellyfin:260326-amd64   31235bcd44f3       2.01GB          603MB
```

arm64 改拉（同环境实测 Digest：`sha256:91c01c7e74a8e803593ead9972bf72842325bef36d6f07dcdbc33da331d652b8`）：

```bash
docker pull docker.xuanyuan.run/nyanmisaka/jellyfin:260326-arm64
```

---

## 四、Docker Compose 部署（推荐）

### 4.1 准备目录

```bash
sudo mkdir -p /www/wwwroot/jellyfin/{config,cache,media}
sudo chown -R "$(id -u):$(id -g)" /www/wwwroot/jellyfin
cd /www/wwwroot/jellyfin
# macOS：mkdir -p ~/docker/jellyfin/{config,cache,media} && cd ~/docker/jellyfin
```

| 宿主机路径 | 容器内路径 | 用途 |
|------------|------------|------|
| `./config` | `/config` | **必挂**：数据库、用户、插件、库元数据（务必备份） |
| `./cache` | `/cache` | **必挂**：转码临时文件与图片缓存（可清空重建） |
| `./media` 或真实盘符 | `/media` | 片库；生产请改成你的 NAS / 磁盘路径，建议 `:ro` |

把电影 / 剧集放进宿主机片库目录，或把 Compose 里的 `./media` 改成例如 `/mnt/nas/movies`。向导里选的永远是**容器内**路径 `/media`，不是宿主机路径。

### 4.2 写入 compose.yaml

```bash
cd /www/wwwroot/jellyfin

cat > compose.yaml <<'EOF'
services:
  jellyfin:
    image: docker.xuanyuan.run/nyanmisaka/jellyfin:260326-amd64
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
    # 硬解见第六节；默认注释
    # group_add:
    #   - "44"   # getent group render
    # devices:
    #   - /dev/dri:/dev/dri
EOF
```

| 项 | 说明 |
|----|------|
| `image` | `docker.xuanyuan.run/nyanmisaka/jellyfin:260326-amd64` |
| `ports` | **8096** Web；**7359/udp** 局域网发现（不需要可删） |
| `volumes` | `/config`、`/cache` 必挂；片库按实际路径改左边 |
| `:ro` | 片库只读，降低误写；若需就地改文件名再去掉 |
| `user` | 非 root 运行时，先保证宿主机目录属主匹配 |

### 4.3 启动并验证

```bash
docker compose up -d
docker compose ps
docker compose logs -f jellyfin
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network jellyfin_default Created
 ✔ Container jellyfin       Started

NAME       IMAGE                                                  COMMAND                SERVICE    CREATED         STATUS                            PORTS
jellyfin   docker.xuanyuan.run/nyanmisaka/jellyfin:260326-amd64   "/jellyfin/jellyfin"   jellyfin   4 seconds ago   Up 2 seconds (health: starting)   0.0.0.0:7359->7359/udp, [::]:7359->7359/udp, 0.0.0.0:8096->8096/tcp, [::]:8096->8096/tcp
```

日志关键成功标志（首次安装会跑迁移，稍等）：

```text
[INF] Main: Jellyfin version: 10.10.7
[INF] Main: Operating system: Debian GNU/Linux 12 (bookworm)
[INF] Main: Architecture: X64
[INF] Emby.Server.Implementations.ApplicationHost: EFCore migrations applied successfully
[INF] Main: Kestrel is listening on 0.0.0.0
[INF] MediaBrowser.MediaEncoding.Encoder.MediaEncoder: Found ffmpeg version 7.1.3
[INF] MediaBrowser.MediaEncoding.Encoder.MediaEncoder: Available hwaccel types: ["cuda", "vaapi", "qsv", "drm", "opencl", "vulkan"]
[INF] Emby.Server.Implementations.ApplicationHost: Core startup complete
[INF] Main: Startup complete 0:00:28.4731725
```

本机探测（`302` → `web/` 即正常）：

```bash
curl -I http://127.0.0.1:8096
```

```text
HTTP/1.1 302 Found
Server: Kestrel
Location: web/
```

浏览器打开 `http://服务器IP:8096`（实测机为 `http://192.168.1.35:8096`）。

---

## 五、浏览器初始化

> 下列截图为实测界面跟做参考（示例库类型是「音乐视频」）。正式环境请挂载**真实视频目录**，内容类型选电影 / 剧集等；文件夹只选 **`/media`**，**不要**选容器根 `/`。

### 5.1 欢迎页与语言

打开地址进入首次向导。首选显示语言可改为中文，再点 **下一个**。

![Jellyfin 欢迎向导：欢迎来到 Jellyfin，首选显示语言下拉框](https://imgs.xuanyuan.cloud/docker/blog/jellyfin-1.webp)

### 5.2 创建管理员

填写管理员用户名与密码（无默认账号；生产用强密码。实测示例用户名为 `root`）。

![Jellyfin 创建管理员：用户名 root，密码与确认密码输入框](https://imgs.xuanyuan.cloud/docker/blog/jellyfin-2.webp)

### 5.3 添加媒体库

进入「设置你的媒体库」，点 **添加媒体库**。

![Jellyfin 设置媒体库：蓝色加号卡片「添加媒体库」](https://imgs.xuanyuan.cloud/docker/blog/jellyfin-3.webp)

弹窗里选内容类型（截图示例为「音乐视频」；你可改为电影 / 剧集），再点文件夹旁的 **+**。

![Jellyfin 添加媒体库弹窗：内容类型音乐视频，文件夹与元数据选项](https://imgs.xuanyuan.cloud/docker/blog/jellyfin-4.webp)

目录树里会出现容器内的 `bin`、`config`、`media` 等。请点进 **`media`**（即 `/media`）再确认——**不要**把库建在 `/` 上，否则会扫到 `/dev`、`/proc`，日志刷屏报错。

![Jellyfin 文件夹浏览：容器根目录含 bin boot cache config media 等](https://imgs.xuanyuan.cloud/docker/blog/jellyfin-12.webp)

若库卡片上已显示路径 `/`，说明选错了，删掉该库或改文件夹为 `/media`：

![Jellyfin 媒体库列表：已添加「音乐视频」卡片，旁为继续添加](https://imgs.xuanyuan.cloud/docker/blog/jellyfin-5.webp)

### 5.4 元数据语言与远程访问

元数据语言可选 **Chinese**；国家/地区按需。

![Jellyfin 首选元数据语言：语言 Chinese，国家地区 United States](https://imgs.xuanyuan.cloud/docker/blog/jellyfin-6.webp)

局域网试用可勾选「允许远程连接」；**自动端口映射（UPnP）** 公网慎开，建议反代或 VPN。

![Jellyfin 设置远程访问：允许远程连接已勾选，自动端口映射未勾选](https://imgs.xuanyuan.cloud/docker/blog/jellyfin-7.webp)

### 5.5 完成并向导后登录

点 **完成**，再用管理员账号登录。

![Jellyfin 向导完成页：完成按钮与开始收集媒体库信息提示](https://imgs.xuanyuan.cloud/docker/blog/jellyfin-8.webp)

![Jellyfin 登录页：用户 root、密码框、记住我与登录按钮](https://imgs.xuanyuan.cloud/docker/blog/jellyfin-9.webp)

### 5.6 首页与控制台

「我的媒体」会出现库卡片；有真实片源并完成扫描后才会有海报与条目。

![Jellyfin 首页：我的媒体下「音乐视频」库卡片](https://imgs.xuanyuan.cloud/docker/blog/jellyfin-10.webp)

右上角头像 → **设置** → **控制台**，可管库、看任务与版本。

![Jellyfin 设置菜单：个人信息与管理下的控制台、媒体资料管理器](https://imgs.xuanyuan.cloud/docker/blog/jellyfin-11.webp)

控制台应显示服务器 **10.10.7**、构建 **260326**（与跟做标签一致）。可点 **扫描所有媒体库** 看进度。

![Jellyfin 控制台：版本 10.10.7 构建 260326，扫描媒体库进度与活动日志](https://imgs.xuanyuan.cloud/docker/blog/jellyfin-13.webp)

客户端见 [Jellyfin 下载页](https://jellyfin.org/downloads/)；局域网也可用浏览器。

---

## 六、硬件加速（可选）

默认 Compose **不**挂 GPU。客户端能直通播放时，不必开硬解。出现这些情况再开：远端弱网要降码率、多设备同时转码、字幕烧录、不支持的封装要服务端转码等。

### 6.1 Intel / AMD（VA-API / QSV）

1. 确认设备：`ls -l /dev/dri`
2. 查 render 组 GID：`getent group render`
3. 在 Compose 中取消注释 `group_add` 与 `devices`（GID 换成你的）
4. `docker compose up -d` 后，打开 **控制台 → 播放 → 转码**，启用对应硬件加速并保存

### 6.2 NVIDIA

宿主机需专有驱动，并按 [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) 配置。Compose 可增加（按你的 Docker / Compose 版本调整）：

```yaml
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

在播放设置里选 NVIDIA NVENC 相关选项。驱动过旧可能导致硬编不可用。

### 6.3 Rockchip RK3588

改用 **`latest-rockchip`**（arm64），并按板卡文档挂载 MPP / RGA 设备；勿与本文 amd64 主路径混用标签。

实测日志里已能看到 FFmpeg **7.1.3** 与 `hwaccel` 类型列表（cuda / vaapi / qsv 等），但**未挂设备前**控制台里启用硬解不会真正生效。

---

## 七、日常运维

```bash
cd /www/wwwroot/jellyfin

docker compose ps
docker compose logs -f jellyfin

# 换新日期标签：先改 compose.yaml 的 image，再：
docker compose pull
docker compose up -d

docker compose down   # 不删 ./config
```

| 目录 | 备份策略 |
|------|----------|
| `./config` | **必备份**（用户、库元数据、插件） |
| `./cache` | 可不备份，可删后重建 |
| 片库宿主机路径 | 按你的磁盘 / NAS 策略备份，与容器无关 |

生产建议：反代 HTTPS、限制公网裸暴露、定期备份 `config`；需要公网访问时设置 `JELLYFIN_PublishedServerUrl` 与防火墙。

---

## 八、备选：docker run（临时 / 无 Compose）

```bash
mkdir -p /www/wwwroot/jellyfin/{config,cache,media}
cd /www/wwwroot/jellyfin

docker run -d \
  --name jellyfin \
  -p 8096:8096/tcp \
  -p 7359:7359/udp \
  -e TZ=Asia/Shanghai \
  -v /www/wwwroot/jellyfin/config:/config \
  -v /www/wwwroot/jellyfin/cache:/cache \
  -v /www/wwwroot/jellyfin/media:/media:ro \
  --restart unless-stopped \
  docker.xuanyuan.run/nyanmisaka/jellyfin:260326-amd64
```

硬解（Intel/AMD，按需追加到命令中）：

```bash
  --group-add 44 \
  --device /dev/dri:/dev/dri \
```

查看日志：`docker logs -f jellyfin`。长期运行请改回第四节 Compose。

---

## 九、常见问题 FAQ

**Q1：为什么不用 `latest`？**  
会静默漂移。跟做固定 **`260326-amd64`**，升级时显式改标签。

**Q2：为什么标签要写 `amd64` / `arm64`？**  
该镜像按架构分标签。架构选错会出现 `no matching manifest`。

**Q3：和官方 `jellyfin/jellyfin`、`linuxserver/jellyfin` 怎么选？**  
跟官方发版节奏 → 官方镜像；习惯 LSIO 的 `PUID`/`PGID` → linuxserver；要本构建的硬解 / FFmpeg → **nyanmisaka**（本文）。

**Q4：日志狂刷 `/dev` `/proc`，或库路径显示为 `/`？**  
向导里误选了容器根。删掉该媒体库，只加 **`/media`**，并把宿主机真实视频目录挂上去。选文件夹时点进目录树里的 `media`，不要停在 `/`。

**Q5：首页没有电影海报？**  
截图示例库是空的或类型为「音乐视频」。放入真实影片、内容类型选对，再到控制台扫描。

**Q6：`/config` 权限报错？**  
用 `user: "UID:GID"` 对齐属主，或先 `chown` 数据目录。

**Q7：直通流畅，一转码就卡？**  
直通几乎不吃 CPU；转码要软解或硬解。检查是否挂了设备、是否在控制台启用了对应加速、客户端是否强制转码。

**Q8：必须映射 7359 吗？**  
不必。只影响部分客户端的局域网自动发现；可手动填 `http://IP:8096`。

**Q9：宿主机端口能改吗？**  
可以，例如 `"18096:8096"`。客户端与 `JELLYFIN_PublishedServerUrl` 写新端口。

**Q10：Rockchip 能跟做 `260326-amd64` 吗？**  
不能。用 **`latest-rockchip`**（arm64）并按板卡挂设备。

**Q11：删容器会丢片吗？**  
用户与库在 `./config`；片文件在宿主机挂载目录。`compose down` 不删目录则都在。

**Q12：日志有 `WebRootPath was not found: /wwwroot`？**  
实测首次启动可能出现，不影响 Web。以 `Startup complete` 与 `curl -I :8096` 返回 `302` 为准。

**Q13：片库挂了 `:ro`，还能「把图像保存到媒体文件夹」吗？**  
只读挂载下不能往片库写 NFO / 封面。需要就地写回时去掉 `:ro`，或关掉该项、让元数据只进 `/config`。

---

## 十、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/nyanmisaka/jellyfin:260326-amd64

# Compose（主路径）
cd /www/wwwroot/jellyfin
docker compose up -d
docker compose ps
docker compose logs -f jellyfin
docker compose down

# 备选 run
docker run -d --name jellyfin \
  -p 8096:8096/tcp -p 7359:7359/udp \
  -v /www/wwwroot/jellyfin/config:/config \
  -v /www/wwwroot/jellyfin/cache:/cache \
  -v /www/wwwroot/jellyfin/media:/media:ro \
  --restart unless-stopped \
  docker.xuanyuan.run/nyanmisaka/jellyfin:260326-amd64
```

验证：`http://服务器IP:8096` · 跟做：`260326-amd64` · 实测 **10.10.7** / FFmpeg **7.1.3**

---

## 十一、延伸阅读

| 资源 | 链接 |
|------|------|
| [nyanmisaka/jellyfin 镜像页](https://xuanyuan.cloud/r/nyanmisaka/jellyfin) | [https://xuanyuan.cloud/r/nyanmisaka/jellyfin](https://xuanyuan.cloud/r/nyanmisaka/jellyfin) |
| [镜像标签列表](https://xuanyuan.cloud/r/nyanmisaka/jellyfin/tags) | [https://xuanyuan.cloud/r/nyanmisaka/jellyfin/tags](https://xuanyuan.cloud/r/nyanmisaka/jellyfin/tags) |
| [Docker Hub · nyanmisaka/jellyfin](https://hub.docker.com/r/nyanmisaka/jellyfin) | [https://hub.docker.com/r/nyanmisaka/jellyfin](https://hub.docker.com/r/nyanmisaka/jellyfin) |
| [Jellyfin 官网](https://jellyfin.org/) | [https://jellyfin.org/](https://jellyfin.org/) |
| [Jellyfin 容器安装文档](https://jellyfin.org/docs/general/installation/container/) | [https://jellyfin.org/docs/general/installation/container/](https://jellyfin.org/docs/general/installation/container/) |
| [维护者 GitHub · nyanmisaka](https://github.com/nyanmisaka) | [https://github.com/nyanmisaka](https://github.com/nyanmisaka) |
| [jellyfin/jellyfin 镜像页（官方构建）](https://xuanyuan.cloud/r/jellyfin/jellyfin) | [https://xuanyuan.cloud/r/jellyfin/jellyfin](https://xuanyuan.cloud/r/jellyfin/jellyfin) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- Compose 固定 **`260326-amd64`**，挂 `/config`、`/cache`、真实片库→`/media`，打开 **`:8096`** 完成向导。
- 实测 **Jellyfin 10.10.7**（构建 **260326**）、FFmpeg **7.1.3**；媒体库勿选容器根 `/`。
- 硬解按需挂设备；标签带架构后缀，勿写 `latest`。
- 备份优先 `./config`。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/jellyfin-docker-deploy


