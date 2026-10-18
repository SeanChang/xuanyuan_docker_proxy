# Docker 部署 MT Photos：轻松搭建 NAS 私有相册平台

![Docker 部署 MT Photos：轻松搭建 NAS 私有相册平台](https://imgs.xuanyuan.cloud/docker/blog/MT Photos/mtphotos1.webp)

*分类: Docker部署教程 | 标签: MT Photos,Docker,轩辕镜像,群晖,NAS,照片管理,私有化部署,部署教程 | 发布时间: 2026-10-16 11:20:12*

> MT Photos 是一款面向 NAS 用户的私有相册，旨在把已有照片目录和手机备份放进同一套图库，并通过浏览器按日期、人物和地点浏览。本文将介绍如何通过 Docker Compose 在群晖上部署 MT Photos，搭建私有相册，帮助把个人 Photos 目录留在自己的 NAS 上，适合家庭相册集中存放及补充 Synology Photos 等场景。

*本文基于 [mtphotos/mt-photos:latest](https://xuanyuan.cloud/zh/r/mtphotos/mt-photos)，以 **latest** 标签实测，测试平台 **群晖 DS920plus**。*

## MT Photos 是什么

MT Photos 是杭州相册家科技有限公司做的 NAS 照片管理系统。它跑在 Docker 里，用来在自己的 NAS 或服务器上管理照片和视频。手机端覆盖 iOS、Android、鸿蒙、Apple TV 和 Android TV。

和只在套件里看一条时间线不同，MT Photos 把已经放在 NAS 上的文件夹收成图库，也可以接收手机备份。浏览、扫描和整理都在浏览器里完成。

## MT Photos 能做什么

- **导入已有目录**：把 NAS 上的照片、视频文件夹收成图库。
- **接收手机备份**：用官方 App 把新拍的照片和视频备份到 NAS。
- **按日期浏览**：在时间线里打开缩略图和大图。
- **按人物和地点浏览**：在探索页按人物、地点、场景查看。
- **扫描和整理**：触发图库扫描，并检查重复文件、整理文件夹。

## 为什么要使用 MT Photos

手机相册、群晖 Photos 和移动硬盘里往往各有一份。找一组旧照片时，要在手机、File Station 和备份盘之间来回翻。早年拷进 `homes` 的目录还在套件相册外面。

把原片再同步到另一家云相册，目录还在，人物和地点索引却带不走。MT Photos 适合要把家庭照片留在自己 NAS 上的人，也适合想在 Synology Photos 之外，用浏览器管理已有文件夹的人。

## 使用 Docker 部署 MT Photos

MT Photos 用 Docker 跑起来，宿主机不必单独安装数据库。开始之前准备好群晖的 Container Manager，以及一个可以登录 DSM 的用户。

下面用 Docker Compose 准备目录、启动服务，并在浏览器里完成安装向导。

## 环境要求

本文命令使用 **`mtphotos/mt-photos:latest`**。这次在群晖 **DS920plus**（x86）上完成拉取、启动和安装向导。启动日志时间是 **2026-07-08**，日志里没有打印应用版本号。

[官方安装说明](https://mtmt.tech/docs/start/install/)建议内存 **4 GB** 以上，CPU 双核 **2.0 GHz** 以上。

| 项目 | 建议 |
|------|------|
| 设备 | 群晖 NAS。本文是 **DS920plus**，x86 |
| 系统 | DSM 7.x，已安装 **Container Manager** |
| 内存 | 建议 **4 GB** 以上 |
| CPU | 双核 **2.0 GHz** 以上 |
| 磁盘 | 视照片库大小而定。`/config` 会存数据库和缩略图缓存 |
| 端口 | 宿主机 **8063** → 容器 **8063** |
| SSH | 建议开启，便于命令行部署和排错 |
| 工作目录 | `/volume1/docker/mt_photos`。这是本次群晖实测目录 |

```bash
docker --version
docker compose version
```

群晖在套件中心安装 Container Manager。镜像加速配置见[群晖 NAS Docker 镜像源配置教程](https://xuanyuan.cloud/usage/synology)。

本文没有在 ARM 设备上实测。ARM 标签见「标签怎么选」。

## 标签怎么选

[官方安装说明](https://mtmt.tech/docs/start/install/)的拉取命令写的是 `latest`。这次在 DS920plus 上拉到并启动的也是 `latest`。日志没有版本号，命令就继续使用这次实测的 **`latest`**。

Docker Hub 上，**2026-10-10** 的 `latest` 与 **`1.57.2`** 指向同一份 linux/amd64 镜像。`latest` 以后还会变。要固定成某个数字版本时，先看[标签列表](https://xuanyuan.cloud/r/mtphotos/mt-photos/tags)，再替换命令里的标签。换成别的版本后，页面可能和本文截图不同。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`latest`** | 本次 DS920plus 实测拉取的标签。2026-10-10 与 `1.57.2` 的 linux/amd64 镜像相同，以后会变 | **是** |
| `1.57.2` | 2026-10-10 与 `latest` 相同的数字标签 | 否 |
| `arm-latest` | 官方给 ARM v8 的标签 | 否。本文没有在 ARM 上实测 |
| `nodb-latest` | 不含内置数据库 | 否 |
| `arm-1.x` / `nodb-1.x` | 对应架构或不含数据库的数字标签 | 否 |

官方写明 ARM v7（32 位）目前无法运行服务端。不要把本文的 x86 步骤直接套到 ARM 机器上。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/mtphotos/mt-photos:latest
```

群晖 DS920plus 实测（节选）：

```text
latest: Pulling from mtphotos/mt-photos
...
Status: Downloaded newer image for docker.xuanyuan.run/mtphotos/mt-photos:latest
```

## 准备目录和权限

`/config` 和 `/upload` 必须挂载。删掉容器后，数据库、缩略图和 App 备份还在。已有照片目录可以另挂。内置 PostgreSQL 会在 `/config/pgsql` 里初始化。这个目录属主不对时，日志会出现 `Permission denied`。先建目录、核对 uid，再改属主，然后启动。

`PUID` 和 `PGID` 不能是 **0**。下文的 `1026` 和 `100` 只是示例，换成 `id` 的实际输出。`你的用户名` 换成 DSM 里的用户名。

### 创建目录

```bash
mkdir -p /volume1/docker/mt_photos/config
mkdir -p /volume1/docker/mt_photos/upload
```

| 宿主机目录 | 容器内路径 | 用途 |
|------------|------------|------|
| `/volume1/docker/mt_photos/config` | `/config` | 必挂。数据库、缩略图、预览视频缓存 |
| `/volume1/docker/mt_photos/upload` | `/upload` | 必挂。App 备份的照片和视频 |
| `/volume1/homes/你的用户名/Photos` | `/photos` | 可选。已有照片目录 |

### 确认已有照片路径

部署前先看个人 Photos 目录是否存在：

```bash
ls /volume1/homes/你的用户名/Photos/
```

两条路径不要混用：

- `/volume1/photo` 是名为 `photo` 的共享文件夹，只有建过这个共享目录才有
- `/volume1/homes/你的用户名/Photos/` 是 DSM 给该用户建的个人照片目录，Synology Photos 和手机备份常用这里

安装向导里添加图库时，填容器内路径 `/photos`。

### 查看 uid 和 gid

```bash
id 你的用户名
```

示例输出（数值因用户而异）：

```text
uid=1026(你的用户名) gid=100(users) groups=100(users),101(administrators)
```

记下 `uid` 和 `gid`。后面的 `PUID`、`PGID` 和 `chown` 都用这一对。

### 修正目录属主

```bash
chown -R 你的用户名:users /volume1/docker/mt_photos/config
chown -R 你的用户名:users /volume1/docker/mt_photos/upload
```

## Docker Compose 部署

把 Compose 里的 `1026`、`100` 换成「准备目录和权限」里的 uid、gid，把 `你的用户名` 换成 DSM 用户名。已经有同名容器时，先执行 `docker stop mt-photos && docker rm mt-photos`，避免容器名和 **8063** 端口冲突。

官方端口是 **8063**。宿主机和容器都用这个端口。8063 已被占用时，见常见问题。

```bash
cd /volume1/docker/mt_photos

cat > docker-compose.yml <<'EOF'
version: "3"
services:
  mtphotos:
    image: docker.xuanyuan.run/mtphotos/mt-photos:latest
    container_name: mt-photos
    restart: unless-stopped
    ports:
      - "8063:8063"
    volumes:
      - /volume1/docker/mt_photos/config:/config
      - /volume1/docker/mt_photos/upload:/upload
      - /volume1/homes/你的用户名/Photos:/photos
    environment:
      - TZ=Asia/Shanghai
      - PUID=1026
      - PGID=100
EOF

docker compose up -d
docker logs mt-photos --tail 30
```

SSH 里如果没有 `docker compose`，打开 Container Manager → 「项目」，目录选 `/volume1/docker/mt_photos`，使用这份 `docker-compose.yml`。也可以改用「备选：docker run」，挂载和环境变量与这里相同。

| 配置 | 说明 |
|------|------|
| `8063:8063` | 宿主机 **8063** → 容器 **8063** |
| `/config` | 数据库与缓存 |
| `/upload` | App 备份目录 |
| `/photos` | 已有照片库。容器内路径可以按需要改 |
| `TZ=Asia/Shanghai` | 时区 |
| `PUID` / `PGID` | 与宿主机用户 uid、gid 一致。群晖上建议填写，且不能为 **0** |
| `restart: unless-stopped` | 群晖重启后自动拉起 |

```text
浏览器 ──HTTP:8063──▶ MT Photos 容器
宿主机 /volume1/docker/mt_photos/config ──▶ /config（数据库、缩略图缓存）
宿主机 /volume1/docker/mt_photos/upload  ──▶ /upload（App 备份）
宿主机 /volume1/homes/你的用户名/Photos  ──▶ /photos（已有照片，可选）
```

就绪时日志里有 `Server started, http port:8063`，并且不再出现 `Permission denied` 或「服务端启动异常」。DS920plus 实测日志：

```text
===== initDb =====
waiting for server to start.... done
server started
2026-07-08T12:55:13: PM2 log: Launching in no daemon mode
2026-07-08T12:55:13: PM2 log: App [launcher:0] starting in -fork mode-
2026-07-08T12:55:13: PM2 log: App [launcher:0] online
[MT Photos] : Server started, http port:8063
 ___  ________  ______ _           _
 |  /  |_   _| | ___  |         | |
 | .  . | | |   | |_/ / |__   ___ | |_ ___  ___
 | |/| | | |   |  __/| '_  / _ | __/ _ / __|
 | |  | | | |   | |   | | | | (_) | || (_) \__ 
 \_|  |_/ \_/   \_|   |_| |_|\___/ \__\___/|___/
CREATE INDEX idx_file_clip_vec start
CREATE INDEX idx_file_clip_vec success
CREATE INDEX IDX_people_descriptor_v2_vec start
CREATE INDEX idx_people_descriptor_v2_vec success
```

在 Container Manager → 「容器」里，`mt-photos` 为运行中：

![Container Manager 容器列表：mt-photos 状态为运行中，映像 docker.xuanyuan.run/mtphotos/mt-photos](https://img.xuanyuan.dev/docker/blog/mt-photos-1.png)

浏览器打开 `http://<群晖 IP>:8063`。

## Web 安装向导

### 选择语言

安装向导首页选择「简体中文」，点击「下一步」。

![MT Photos 安装向导：选择显示语言为简体中文](https://img.xuanyuan.dev/docker/blog/mt-photos-2.png)

### 创建管理员账户

填写管理员用户名和密码。这个账号用来管理图库和用户。

![创建管理员账户：填写用户名与密码，点击下一步](https://img.xuanyuan.dev/docker/blog/mt-photos-3.png)

### 设置图库

点击「添加图库」，在文件夹选择器里选容器内路径 `/photos`。它对应宿主机 `/volume1/homes/你的用户名/Photos`。

![添加图库：选择文件夹弹窗，选中容器内 /photos 目录](https://img.xuanyuan.dev/docker/blog/mt-photos-4.png)

为图库命名。实测创建了「太湖」。列表里能看到图库卡片后，点击「完成」。

![设置图库：已添加太湖图库，路径 /photos/2023年7月1日，点击完成](https://img.xuanyuan.dev/docker/blog/mt-photos-5.png)

## 登录与主界面

向导结束后进入登录页，用刚创建的管理员账号登录。

![MT Photos 登录页：输入用户名与密码，点击登录](https://img.xuanyuan.dev/docker/blog/mt-photos-6.png)

登录后进入「照片」。系统按日期分组。首次加载时缩略图可能还在索引，等后台跑完再看。

![MT Photos 照片主界面：按日期 2023-07-01 分组，缩略图索引中](https://img.xuanyuan.dev/docker/blog/mt-photos-7.png)

点开一张照片可以看大图。工具栏里有旋转、分享、收藏和元数据。

![MT Photos 照片预览：大图浏览与顶部工具栏](https://img.xuanyuan.dev/docker/blog/mt-photos-8.png)

## 图库扫描与管理

| 能力 | 说明 |
|------|------|
| 图库管理 | 把不同文件夹里的照片、视频合在一起看，并按用户授权 |
| 已有目录导入 | 宿主机照片目录映射进容器后即可扫描 |
| App 备份 | `/upload` 接收手机 App 备份的照片和视频 |
| 探索 | 按人物、地点、场景浏览 |
| 管理工具 | 重复文件检查、文件夹整理、人脸识别整理 |

进入左侧「管理」→「图库管理」，可以查看图库并触发扫描。实测「太湖」显示「更新上传文件信息中」，表示正在索引 `/photos` 下的照片。

![图库管理：太湖图库扫描中，可点击扫描所有图库](https://img.xuanyuan.dev/docker/blog/mt-photos-9.png)

「管理工具」里有重复文件检查、文件夹整理、人脸识别整理和系统维护任务。

![管理工具：图库相关、人脸识别相关与系统维护工具卡片](https://img.xuanyuan.dev/docker/blog/mt-photos-10.png)

索引完成后，「探索」会按人物、地点、场景聚合。照片需要带 GPS 或人脸等元数据。人脸和 OCR 也可以再加配套容器，见常见问题。

![探索页面：人物、地点、场景分类浏览](https://img.xuanyuan.dev/docker/blog/mt-photos-11.png)

## 备选：docker run

没有 Compose 时，用下面这条命令。先完成「准备目录和权限」里的目录、`id` 和 `chown`。`1026`、`100` 和 `你的用户名` 换成你的值。长期运行仍用「Docker Compose 部署」。

```bash
docker run -d 
  --name mt-photos 
  --restart unless-stopped 
  -p 8063:8063 
  -v /volume1/docker/mt_photos/config:/config 
  -v /volume1/docker/mt_photos/upload:/upload 
  -v /volume1/homes/你的用户名/Photos:/photos 
  -e TZ=Asia/Shanghai 
  -e PUID=1026 
  -e PGID=100 
  docker.xuanyuan.run/mtphotos/mt-photos:latest
```

```bash
docker logs mt-photos --tail 30
```

日志里出现 `Server started, http port:8063` 后，按「Web 安装向导」打开页面。

## 常见问题

**Q1：首次启动报 `Permission denied`，路径是 `/config/pgsql/data`？**

日志里可能出现：

```text
===== initDb =====
execFile stderr: sh /usr/src/app/initDb.sh initdb: error: could not access directory "/config/pgsql/data": Permission denied

pg_ctl: could not access directory "/config/pgsql/data": Permission denied
...
Debug: id postgres uid=103(postgres) gid=105(postgres) groups=105(postgres),103(ssl-cert)
...
 =========== 服务端启动异常 =============
修复方法： https://mtmt.tech/docs/advanced/ifix
```

内置 PostgreSQL 要求 `/config/pgsql` 的属主是容器内 `postgres`（uid **103**，gid **105**），权限为 `700`。群晖上 `/volume1/docker/mt_photos/config` 默认常常属于 `root`，容器就无法在映射目录里初始化数据库。`/config` 不要放在 SMB 或 NFS 远程挂载上。exFAT 也不能作为这个目录。

按顺序处理：

1. 停止并删除失败的容器。
2. 用 `id` 核对 NAS 用户的 uid 和 gid。
3. 删掉不完整的 `pgsql` 目录。
4. 把 `config` 目录属主改成这个 NAS 用户。
5. 带上 `PUID` 和 `PGID` 重新创建容器。
6. 看日志里是否出现 `Server started, http port:8063`。

```bash
docker stop mt-photos && docker rm mt-photos

id 你的用户名

rm -rf /volume1/docker/mt_photos/config/pgsql

chown -R 你的用户名:users /volume1/docker/mt_photos/config

docker run -d 
  --name mt-photos 
  --restart unless-stopped 
  -p 8063:8063 
  -v /volume1/docker/mt_photos/config:/config 
  -v /volume1/docker/mt_photos/upload:/upload 
  -v /volume1/homes/你的用户名/Photos:/photos 
  -e TZ=Asia/Shanghai 
  -e PUID=1026 
  -e PGID=100 
  docker.xuanyuan.run/mtphotos/mt-photos:latest

docker logs mt-photos --tail 30
```

若仍然失败，在 File Station 里右键 `/volume1/docker/mt_photos/config` → 「属性」→ 「权限」，确认该 NAS 用户有完全控制，且 Everyone 有读取。官方说明见[常见错误及解决方法](https://mtmt.tech/docs/advanced/ifix)。

**Q2：`8063` 端口被占用？**

把映射改成 `18063:8063`。容器内仍监听 **8063**，浏览器访问 `http://<群晖 IP>:18063`。

**Q3：图库里看不到已有照片？**

1. 确认启动时挂了照片目录，例如 `/volume1/homes/你的用户名/Photos:/photos`。
2. 添加图库时选容器内路径 `/photos`，不要填宿主机路径。
3. 进入「图库管理」，点击「扫描所有图库」。

**Q4：`PUID` 和 `PGID` 填什么？**

SSH 执行 `id 你的用户名`。`uid` 填 `PUID`，`gid` 填 `PGID`。示例里是 `1026` 和 `100`，以你的输出为准。不能填 **0**。

**Q5：人脸识别或 OCR 怎么开？**

这一份单容器不含 AI 服务。按[群晖 7.2+ 官方 Compose 示例](https://mtmt.tech/docs/example/dsm2/)再加 `mt-photos-ai`（端口 **8060**）和人脸识别 API 容器（端口 **8066**）。先让单容器的安装向导跑通，再加这些容器。

**Q6：CloudSync 看不到容器里的文件变化？**

群晖不会监听容器内部对文件的改动。若要触发 CloudSync，官方建议用 CIFS 挂载 SMB 共享路径。见[群晖安装方法](https://mtmt.tech/docs/example/dsm/)。

**Q7：如何停止与卸载？**

只删除容器、保留 `config`、`upload` 和照片时：

```bash
docker stop mt-photos && docker rm mt-photos
```

下面这条会删掉 `/volume1/docker/mt_photos` 里的数据库和备份。照片目录若不在这个路径下，则还在。确认不再需要这些数据再执行：

```bash
rm -rf /volume1/docker/mt_photos
```

## 命令速查

```bash
docker pull docker.xuanyuan.run/mtphotos/mt-photos:latest

mkdir -p /volume1/docker/mt_photos/config /volume1/docker/mt_photos/upload
ls /volume1/homes/你的用户名/Photos/
id 你的用户名
chown -R 你的用户名:users /volume1/docker/mt_photos/config
chown -R 你的用户名:users /volume1/docker/mt_photos/upload

cd /volume1/docker/mt_photos
docker compose up -d
docker logs mt-photos --tail 30
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://<群晖 IP>:8063`。添加图库时选容器内 `/photos`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [mtphotos/mt-photos 镜像页](https://xuanyuan.cloud/zh/r/mtphotos/mt-photos) | [https://xuanyuan.cloud/zh/r/mtphotos/mt-photos](https://xuanyuan.cloud/zh/r/mtphotos/mt-photos) |
| [mtphotos/mt-photos 概览](https://xuanyuan.cloud/r/mtphotos/mt-photos) | [https://xuanyuan.cloud/r/mtphotos/mt-photos](https://xuanyuan.cloud/r/mtphotos/mt-photos) |
| [mtphotos/mt-photos 标签列表](https://xuanyuan.cloud/r/mtphotos/mt-photos/tags) | [https://xuanyuan.cloud/r/mtphotos/mt-photos/tags](https://xuanyuan.cloud/r/mtphotos/mt-photos/tags) |
| [Docker Hub · mtphotos/mt-photos](https://hub.docker.com/r/mtphotos/mt-photos) | [https://hub.docker.com/r/mtphotos/mt-photos](https://hub.docker.com/r/mtphotos/mt-photos) |
| [官网 mtmt.tech](https://mtmt.tech) | [https://mtmt.tech](https://mtmt.tech) |
| [MT Photos 安装文档](https://mtmt.tech/docs/start/install/) | [https://mtmt.tech/docs/start/install/](https://mtmt.tech/docs/start/install/) |
| [群晖 DSM 7.2+ 安装](https://mtmt.tech/docs/example/dsm2/) | [https://mtmt.tech/docs/example/dsm2/](https://mtmt.tech/docs/example/dsm2/) |
| [群晖安装方法](https://mtmt.tech/docs/example/dsm/) | [https://mtmt.tech/docs/example/dsm/](https://mtmt.tech/docs/example/dsm/) |
| [常见错误与修复](https://mtmt.tech/docs/advanced/ifix) | [https://mtmt.tech/docs/advanced/ifix](https://mtmt.tech/docs/advanced/ifix) |
| [群晖 NAS Docker 镜像源配置教程](https://xuanyuan.cloud/usage/synology) | [https://xuanyuan.cloud/usage/synology](https://xuanyuan.cloud/usage/synology) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

[https://xuanyuan.cloud/blog/nas-mt-photos-docker](https://xuanyuan.cloud/blog/nas-mt-photos-docker-deploy)


