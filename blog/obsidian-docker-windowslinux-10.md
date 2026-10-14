# Docker 部署 Obsidian：轻松搭建私有知识库与笔记平台

![Docker 部署 Obsidian：轻松搭建私有知识库与笔记平台](https://imgs.xuanyuan.cloud/docker/blog/obsidian-1-1.webp)

*分类: Docker部署教程 | 标签: Obsidian,Docker,轩辕镜像,笔记,知识库,私有化部署,部署教程 | 发布时间: 2026-04-21 07:33:20*

> Obsidian 是一款面向个人思考与知识整理的笔记应用，旨在把笔记留在你自己的设备上，并通过链接、关系图谱和本地开放格式把内容组织成可长期保存的知识库。本文将介绍如何通过 Docker 快速部署 Obsidian，搭建私有知识库与笔记平台，帮助你更高效地管理双链笔记和本地文稿，适合个人知识库及在服务器上集中存放笔记等场景。

*本文基于 [linuxserver/obsidian:1.13.4](https://xuanyuan.cloud/zh/r/linuxserver/obsidian)，以 **1.13.4** 版本实测，测试平台 **Ubuntu 24.04** Linux。*

## Obsidian 是什么

Obsidian 是一款面向个人思考的笔记应用，用来记录想法、整理知识。笔记存在你自己的设备上，离线也能打开，内容不会交给笔记服务商阅读。

与在线文档主要把正文放在服务商那边不同，Obsidian 使用开放文件格式，笔记由你长期保管。与散落的本地文件相比，它用链接、关系图谱和画布把同一库里的内容组织起来。

## Obsidian 能做什么

- **链接笔记**：在笔记之间建立连接，把想法、人物和资料串成自己的知识网络。
- **查看关系图谱**：用图谱看见笔记之间如何相连。
- **在画布上铺开思路**：用 Canvas 做研究、头脑风暴和示意。
- **从笔记写到日记和知识库**：个人记录、日记、知识库和项目整理可以用同一套工具完成。
- **把数据留在自己手里**：笔记存在你的设备上，格式开放，可以长期保存。

## 为什么要使用 Obsidian

把笔记放在在线文档里，正文在服务商那边，换服务时不容易把链接结构一起带走。只在一台电脑上写，换到另一台设备后又要重新对上同一份库。

Obsidian 把笔记存在你指定的设备上，链接和图谱都围绕这份库展开。它适合想自己保管笔记、并在笔记之间来回跳转的人。需要多人同时改同一篇云文档时，要另看协作工具。

## 使用 Docker 部署 Obsidian

官方客户端装在本机。服务器或 NAS 上如果没有桌面，可以用 Docker 把桌面版跑起来，再在浏览器里打开。开始之前，先准备好 Docker。

下面用 Docker Compose 写好运行参数，启动服务，并在浏览器里切换语言、新建仓库。

## 环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04**（Docker Desktop 亦可） |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64 / arm64**（以标签页为准） |
| 内存 | ≥ **2 GB**，推荐 **4 GB** |
| 磁盘 | ≥ **2 GB**。镜像较大，另外留出笔记空间 |
| 端口 | 宿主机 **13300**（HTTP）、**3001**（HTTPS） |
| 共享内存 | **`shm_size: 1gb`** |
| 工作目录 | `/www/wwwroot/obsidian`。macOS 上改为 `~/docker/obsidian` |

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

更多见[轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

```bash
ss -tlnp | grep -E ':13300|:3001'
```

**3001** 被占用时，只改左侧宿主机端口，例如 `"13001:3001"`，访问改为 `https://IP:13001`。

---

## 标签怎么选

| 标签 | 含义 | 建议 |
|------|------|------|
| **`1.13.4`** | 上游桌面 **1.13.4**，与欢迎页版本一致 | **本文使用** |
| **`v1.13.4-ls*`** | LinuxServer 的 CI 构建号 | 需要和某次上游构建一致时再选 |
| **`latest`** | 会随上游变化 | 不要写入本文命令 |

完整列表见[标签列表](https://xuanyuan.cloud/r/linuxserver/obsidian/tags)。升级时先改 Compose 里的标签，再 `pull` 和 `up -d`。

拉取 `1.13.4` 时，它和当时的 `latest` Digest 相同。`latest` 以后会指向别的构建，pull、Compose 和 `docker run` 都写 **`1.13.4`**。

---

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/linuxserver/obsidian:1.13.4
```

Ubuntu 24.04 实测：

```text
1.13.4: Pulling from linuxserver/obsidian
Digest: sha256:90fd8a7b03ec5cafb53e596296bbbe99f2dca2ef553bbd3d40d295ef90419921
Status: Downloaded newer image for docker.xuanyuan.run/linuxserver/obsidian:1.13.4
docker.xuanyuan.run/linuxserver/obsidian:1.13.4
```

---

## Docker Compose 部署

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/obsidian` |
| **macOS** | **`~/docker/obsidian`** |
| **Windows（Docker Desktop）** | 如 `C:dockerobsidian` |

宿主机不要占用 **3000**。这个端口常和本机前端开发冲突。容器内的 HTTP **3000** 改映到宿主机 **13300**，只留给反向代理。浏览器直接打开请用 HTTPS **3001**。

Electron 需要较大的共享内存。`shm_size` 过小，画面容易黑屏或进程崩溃。本文设为 **1gb**。

`PUID` 和 `PGID` 与运行用户一致，减少 `config` 目录的权限问题。先用 `id` 看本机 uid 和 gid。下文的 `1000` 与本次实测日志一致，不一样就换成你的值。

### 创建目录

当前用户不是 root 时，给 `mkdir` 和 `chown` 加上 `sudo`。

```bash
mkdir -p /www/wwwroot/obsidian/config
chown -R "$USER:$USER" /www/wwwroot/obsidian
cd /www/wwwroot/obsidian

# macOS：mkdir -p ~/docker/obsidian/config && cd ~/docker/obsidian
```

### 编写 docker-compose.yml

```bash
cd /www/wwwroot/obsidian

cat > docker-compose.yml <<'EOF'
services:
  obsidian:
    image: docker.xuanyuan.run/linuxserver/obsidian:1.13.4
    container_name: obsidian
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      # 可选：开启 HTTP Basic 认证（仅适合受信内网）
      # - CUSTOM_USER=admin
      # - PASSWORD=请改成强密码
      # 老 CPU 无 AVX2 / Wayland 异常时可取消下一行注释
      # - PIXELFLUX_WAYLAND=false
    volumes:
      - ./config:/config
    ports:
      - "13300:3000"   # HTTP，仅反代备用；浏览器直连请用 HTTPS
      - "3001:3001"    # HTTPS（推荐）
    shm_size: "1gb"
    restart: unless-stopped
EOF
```

| 项 | 说明 |
|----|------|
| `13300:3000` | 宿主机 **13300** → 容器 **3000**。HTTP 供反代，浏览器直连常被拒绝 |
| `3001:3001` | 宿主机 **3001** → 容器 **3001**。浏览器用 HTTPS 打开 |
| `shm_size` | Electron 使用。过小易黑屏或崩溃 |
| `./config` → `/config` | 配置与笔记 |
| `PUID` / `PGID` | 与宿主机用户一致 |

### 启动与验证

```bash
docker compose up -d
docker compose ps
docker compose logs -f --tail 100
```

本文实测：

```text
[+] Running 2/2
 ✔ Network obsidian_default  Created
 ✔ Container obsidian        Started
```

```text
NAME       IMAGE                                             COMMAND   SERVICE    CREATED         STATUS         PORTS
obsidian   docker.xuanyuan.run/linuxserver/obsidian:1.13.4   "/init"   obsidian   5 seconds ago   Up 5 seconds   0.0.0.0:3001->3001/tcp, [::]:3001->3001/tcp, 0.0.0.0:13300->3000/tcp, [::]:13300->3000/tcp
```

日志关键行（节选）：

```text
obsidian  | User UID:    1000
obsidian  | User GID:    1000
obsidian  | [ls.io-init] done.
obsidian  | INFO:selkies.__main__:Starting Selkies in 'websockets' mode.
obsidian  | INFO:main:Upload directory ensured: /config/Desktop
obsidian  | INFO:main:Initial Encoder: x264enc, Framerate: 60
obsidian  | INFO:main:SelkiesStreamingApp initialized: encoder=x264enc, display=1024x768
obsidian  | INFO:main:All main components initialized. Running server...
obsidian  | INFO:data_websocket:Data WebSocket Server listening on port 8082
obsidian  | [svc-de] /config/.XDG/wayland-1 found launching de
```

容器状态为 `Up`，端口 **3001** 和 **13300** 已映射，并且日志里出现 `All main components initialized` 与 `launching de` 之后，再打开浏览器。

---

## 浏览器访问

用 HTTPS 打开。本文实测地址是 `https://192.168.1.10:3001`，换成你的服务器地址。

| 方式 | 地址 | 说明 |
|------|------|------|
| **HTTPS** | `https://<服务器 IP>:3001` | 完整功能。需要信任自签名证书 |
| HTTP | `http://<服务器 IP>:13300` | 直连常报需要安全连接。只作反代上游 |

```text
浏览器  ──HTTPS:3001──▶  Selkies ──▶ 桌面版 Obsidian
              │
         HTTP:13300 仅作反代上游（直连常被拒绝）
```

首次打开会提示连接不安全。容器自带自签名证书，内网访问时会出现这个提示。Chrome 或 Edge 选择「高级」，再选择「继续访问」。之后可以点地址栏的锁或感叹号，打开剪贴板权限，方便和本机复制粘贴。

![浏览器提示 192.168.1.10:3001 连接不安全并显示剪贴板权限](https://img.xuanyuan.dev/docker/blog/obsidian-9.webp)

用 `http://` 打开时，常见报错：

```text
Error: This application requires a secure connection
```

改回 `https://<服务器 IP>:3001`。旧写法 `-p 3005:3000` 配合 `http://IP:3005` 也会出现同一条报错。

---

## 首次初始化

进入后先看到欢迎页，顶部为 **Version 1.13.4**，与镜像标签一致。

1. 把底部语言改成「简体中文」。
2. 点击「创建」，新建仓库。也可以点界面上的 Quick start。
3. 按向导选择路径，完成建库。

![Obsidian 欢迎页英文：Version 1.13.4 与 Quick start](https://img.xuanyuan.dev/docker/blog/obsidian-1.webp)

![Obsidian 欢迎页已切换简体中文](https://img.xuanyuan.dev/docker/blog/obsidian-2.webp)

建库完成后，左侧是文件列表，中间是「欢迎」笔记，右侧是「关系图谱」。

![Obsidian 欢迎笔记与关系图谱中文主界面](https://img.xuanyuan.dev/docker/blog/obsidian-3.webp)

---

## 主界面

下面几项用来确认远程桌面里的 Obsidian 可用，不必一次全做。

### 关系图谱

左侧点「关系图谱」图标，或把图谱拖到另一栏。有链接的笔记会连成节点。新建画布、日记之后，节点会增加。

![Obsidian 双栏关系图谱视图](https://img.xuanyuan.dev/docker/blog/obsidian-4.webp)

### Canvas 画布

左侧点 Canvas，或在命令面板里搜索「画布」，然后新建。按界面提示：从下方拖入卡片，空格加拖动用来平移，Ctrl 加滚轮用来缩放。

![Obsidian Canvas 画布与右侧关系图谱](https://img.xuanyuan.dev/docker/blog/obsidian-5.webp)

### 日记

左侧点日记入口，新建当日笔记。本文示例是 `2026-08-07`。图谱里对应节点会高亮。

![Obsidian 日记笔记 2026-08-07 与关系图谱](https://img.xuanyuan.dev/docker/blog/obsidian-6.webp)

### 命令面板

按 `Ctrl+P` 打开「选择命令…」，可以搜索拆分、书签、保存。

![Obsidian 命令面板选择命令](https://img.xuanyuan.dev/docker/blog/obsidian-7.webp)

### 表格视图

新建 Base 或表格视图后，可以列出库内文件，并做排序和筛选。

![Obsidian 表格列出仓库文件并与图谱对照](https://img.xuanyuan.dev/docker/blog/obsidian-8.webp)

### 搜索

左侧点搜索图标。支持 `path:`、`file:`、`tag:` 等语法。

![Obsidian 搜索选项语法说明](https://img.xuanyuan.dev/docker/blog/obsidian-10.webp)

---

## Selkies 侧边栏

页面最左侧可以展开 Selkies 面板。这是远程桌面的推流设置，和 Obsidian 自己的设置是两套菜单。卡顿、文字发糊、传文件时先看这里。

### 统计信息

这里有 CPU、内存、FPS、带宽和延迟。

![Selkies 侧边栏统计信息 CPU 内存 FPS](https://img.xuanyuan.dev/docker/blog/obsidian-11.webp)

### 屏幕设置

可以打开 HiDPI 和抗锯齿。界面缩放调到 **150%** 时，高分屏更容易读。

![Selkies 屏幕设置 HiDPI 与 150% 缩放](https://img.xuanyuan.dev/docker/blog/obsidian-12.webp)

### 视频设置

默认编码器是 **x264enc**，帧率 **60**，Video CRF **25**，与日志 `Initial Encoder: x264enc, Framerate: 60` 一致。文字发糊时可以试 **Full Color 4:4:4**，它更吃资源。

![Selkies 视频设置 x264enc 与帧率](https://img.xuanyuan.dev/docker/blog/obsidian-13.webp)

### 剪贴板、文件与共享

侧边栏有服务器剪贴板、上传和下载，以及只读共享链接。本文示例是 `https://192.168.1.10:3001/#shared`。

![Selkies 剪贴板文件传输与共享链接](https://img.xuanyuan.dev/docker/blog/obsidian-14.webp)

上传默认落到 `/config/Desktop`。日志里有 `Upload directory ensured: /config/Desktop`。

---

## 安全提醒

未设置 `CUSTOM_USER` 和 `PASSWORD` 时，能访问端口的人就可以操作界面。

Web 界面里有无密码的 sudo 终端。拿到这个页面，相当于可以在容器里以 root 执行命令。

不要把 **3001** 直接暴露到公网。内网也建议用防火墙限制来源 IP，并加上 Basic 认证或反代认证。Compose 里可以把 `CUSTOM_USER` 和 `PASSWORD` 两行注释去掉，密码换成强密码。

公网用 Nginx 或 SWAG 做反代时，上游可以指向 HTTP **13300**，由反代提供正式证书。

---

## 备选：docker run

没有 Compose 时，用下面的命令。先建好 `/www/wwwroot/obsidian/config`。`PUID` 和 `PGID` 换成 `id` 的输出。

```bash
docker run -d 
  --name=obsidian 
  -e PUID=1000 
  -e PGID=1000 
  -e TZ=Asia/Shanghai 
  -p 13300:3000 
  -p 3001:3001 
  -v /www/wwwroot/obsidian/config:/config 
  --shm-size="1gb" 
  --restart unless-stopped 
  docker.xuanyuan.run/linuxserver/obsidian:1.13.4
```

Windows（PowerShell，一行）：

```powershell
docker run -d --name obsidian -e PUID=1000 -e PGID=1000 -e TZ=Asia/Shanghai -p 13300:3000 -p 3001:3001 -v C:dockerobsidian:/config --shm-size="1gb" --restart unless-stopped docker.xuanyuan.run/linuxserver/obsidian:1.13.4
```

本机浏览器打开 `https://localhost:3001`。

---

## 升级、停止与数据

先把 Compose 里的镜像标签改成要升级的版本，再拉取并启动。`./config` 里的笔记会保留。

```bash
cd /www/wwwroot/obsidian
docker compose pull
docker compose up -d
```

只停止容器：

```bash
docker compose down
```

下面两条会删掉 `/www/wwwroot/obsidian`，笔记和配置一起消失。确认不再需要这些数据再执行：

```bash
docker compose down
rm -rf /www/wwwroot/obsidian
```

macOS 上把路径换成 `~/docker/obsidian`。

---

## 常见问题

**Q1：提示 `This application requires a secure connection`？**

页面要求安全连接。改用 `https://<服务器 IP>:3001`，并在浏览器里继续访问。`http://<服务器 IP>:13300` 不是主入口。

**Q2：按旧文映射了 `3005:3000`，容器在跑，网页仍报错？**

协议和端口不对。笔记一般还在挂载目录里。先停掉旧容器，再按「Docker Compose 部署」重建，映射里要有 `3001:3001`，并用 HTTPS 打开。

```bash
docker stop obsidian && docker rm obsidian
```

**Q3：3000 或 3001 被占用？**

只改左侧宿主机端口。容器内的 **3000** 和 **3001** 保持不变。宿主机 **3000** 常和本机前端开发冲突，本文默认用 **13300**。

```yaml
ports:
  - "13300:3000"
  - "13001:3001"
```

浏览器改为 `https://<服务器 IP>:13001`。

**Q4：黑屏，或 Obsidian 崩溃？**

先确认 `shm_size` 是 `"1gb"`。仍然黑屏时，可以再加：

```yaml
security_opt:
  - seccomp:unconfined
```

老 CPU 或没有 AVX2 时，可以再设置 `PIXELFLUX_WAYLAND=false`。

**Q5：文字模糊？**

打开 Selkies 的「视频设置」，试 **Full Color 4:4:4**，或把界面缩放调高。屏幕和视频两项都在「Selkies 侧边栏」。

**Q6：容器名报 `/obsidian` already in use？**

已经有同名容器。先删掉再启动：

```bash
docker stop obsidian && docker rm obsidian
docker compose up -d
```

**Q7：权限不足？**

先核对 `PUID` 和 `PGID` 是否与目录属主一致。也可以把配置目录交给 uid **1000**：

```bash
sudo chown -R 1000:1000 /www/wwwroot/obsidian/config
```

**Q8：Windows PowerShell 换行报错？**

PowerShell 不用 CMD 的 `^` 续行。把命令写成一行，或用反引号 `` ` `` 换行。

**Q9：和官方桌面客户端怎么选？**

| | linuxserver/obsidian（本文） | 官方桌面客户端 |
|--|------------------------------|----------------|
| 入口 | 浏览器，HTTPS **3001** | 本机安装包 |
| 数据 | 挂卷在服务器或 NAS | 多在本机目录 |
| 适合 | 远程访问，多设备共用同一库 | 单机长时间写作 |
| 注意 | 需要 HTTPS。默认没有强认证 | 没有推流开销 |

单机长时间写作用 [Obsidian 官方客户端](https://obsidian.md/)。NAS 或服务器上集中访问用本文这个容器。

---

## 命令速查

```bash
docker pull docker.xuanyuan.run/linuxserver/obsidian:1.13.4

cd /www/wwwroot/obsidian
# macOS：cd ~/docker/obsidian
docker compose up -d
docker compose ps
docker compose logs -f --tail 100

docker compose down
```

浏览器打开 `https://<服务器 IP>:3001`。

备选：

```bash
docker run -d --name=obsidian 
  -e PUID=1000 -e PGID=1000 -e TZ=Asia/Shanghai 
  -p 13300:3000 -p 3001:3001 
  -v /www/wwwroot/obsidian/config:/config 
  --shm-size="1gb" --restart unless-stopped 
  docker.xuanyuan.run/linuxserver/obsidian:1.13.4
```

---

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [linuxserver/obsidian 镜像页](https://xuanyuan.cloud/zh/r/linuxserver/obsidian) | [https://xuanyuan.cloud/zh/r/linuxserver/obsidian](https://xuanyuan.cloud/zh/r/linuxserver/obsidian) |
| [linuxserver/obsidian 概览](https://xuanyuan.cloud/r/linuxserver/obsidian) | [https://xuanyuan.cloud/r/linuxserver/obsidian](https://xuanyuan.cloud/r/linuxserver/obsidian) |
| [linuxserver/obsidian 标签列表](https://xuanyuan.cloud/r/linuxserver/obsidian/tags) | [https://xuanyuan.cloud/r/linuxserver/obsidian/tags](https://xuanyuan.cloud/r/linuxserver/obsidian/tags) |
| [Docker Hub · linuxserver/obsidian](https://hub.docker.com/r/linuxserver/obsidian) | [https://hub.docker.com/r/linuxserver/obsidian](https://hub.docker.com/r/linuxserver/obsidian) |
| [LinuxServer 文档 · obsidian](https://docs.linuxserver.io/images/docker-obsidian/) | [https://docs.linuxserver.io/images/docker-obsidian/](https://docs.linuxserver.io/images/docker-obsidian/) |
| [GitHub · linuxserver/docker-obsidian](https://github.com/linuxserver/docker-obsidian) | [https://github.com/linuxserver/docker-obsidian](https://github.com/linuxserver/docker-obsidian) |
| [Obsidian 官网](https://obsidian.md/) | [https://obsidian.md/](https://obsidian.md/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/obsidian-docker-windowslinux-10


