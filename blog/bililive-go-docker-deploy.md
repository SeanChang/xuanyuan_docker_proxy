# Docker 部署 Bililive-go：轻松搭建多平台直播录制

![Docker 部署 Bililive-go：轻松搭建多平台直播录制](https://imgs.xuanyuan.cloud/docker/blog/bililive-go/bililive-go.webp)

*分类: Docker部署教程 | 标签: Bililive-go,chigusa/bililive-go,Docker,轩辕镜像,直播录制,私有化部署,部署教程 | 发布时间: 2026-10-19 22:51:14*

> Bililive-go 是一款面向直播观众的开源直播录制工具，旨在把多个平台的直播间放在同一份列表里，并通过网页管理监控、录像和开播通知。本文将介绍如何通过 Docker 快速部署 Bililive-go，搭建直播录制平台，帮助你在自己的服务器上保存直播录像，适合个人录播及长期挂机录制等场景。

*本文基于 [chigusa/bililive-go:v0.8.3](https://xuanyuan.cloud/zh/r/chigusa/bililive-go)，以 **v0.8.3** 版本实测，测试平台 **Ubuntu 24.04** Linux。*

## Bililive-go 是什么

Bililive-go 是开源的直播录制工具。它按配置查看直播间有没有开播，开播后把录像写到指定目录，并用网页管理房间、录像和通知。项目文档里的 Docker 镜像是 `chigusa/bililive-go`。

与临时打开直播页、再用录屏或单次下载工具不同，Bililive-go 会一直看着房间列表。主播开播后开始录，下播后停。房间、输出目录和通知都写在同一份配置里，网页上可以改。

## Bililive-go 能做什么

- **监控多个平台的直播间**：把房间地址放进同一份列表，开播后录制。
- **在网页里管理房间**：添加房间，开始或停止监控，并查看当前是在监控还是在录制。
- **浏览录像**：从直播间一行进入该房间的录像目录，网页里可以播放。
- **接收开播通知**：通知可以接到 Telegram、邮件或 ntfy。
- **按网站保存 cookie**：哔哩哔哩、抖音和 SOOP 可以在配置里按域名写入 cookie。

## 为什么要使用 Bililive-go

直播结束后，页面上的内容就留不下来。每个平台单独开着录，人一离开就容易漏场。

Bililive-go 把要看的房间放在自己的服务器上，开播再录，文件留在挂载的目录里。适合想长期留下某几位主播录像、又不想一直守在直播页前面的人。

## 使用 Docker 部署 Bililive-go

Bililive-go 可以用 Docker 把录制程序和网页一起跑起来。开始之前准备好 Docker，并想好录像要放在哪块磁盘上。直播时间一长，录像目录会持续变大。

接下来用 Docker Compose 写好目录和配置，完成启动，再在浏览器里添加直播间。

## 环境要求

本文命令使用 **v0.8.3** 版本。这一版发布于 2026-09-25。容器内网页监听 8080。镜像构建时把时区文件设成了 Asia/Shanghai。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）。macOS 把 `/www/wwwroot/bililive-go` 换成 `~/docker/bililive-go`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64** 或 **linux/arm/v7** |
| 磁盘 | Docker Hub 上该标签的压缩体积约为 linux/amd64 **390.5 MB**、linux/arm64 **366.4 MB**、linux/arm/v7 **279.2 MB**。录像另占空间，给 `Videos/` 留出能放下整场直播的磁盘 |
| 端口 | 宿主机 **8080** → 容器 **8080** |
| 工作目录 | `/www/wwwroot/bililive-go` |
| 录像 | 宿主机 `Videos/` 对应容器内 `/srv/bililive`。程序数据在这个目录下的 `.appdata` |
| 配置 | 宿主机 `config.yml` 对应容器内 `/etc/bililive-go/config.yml` |
| 账号 | 这份配置没有网页登录项。不要把 8080 直接暴露到公网 |

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

Windows 和 Mac 从 [Docker Desktop](https://www.docker.com/products/docker-desktop/) 安装，安装后启动 Docker Desktop。下文的 `cat > … <<'EOF'` 是 bash 写法。PowerShell 不能直接粘贴这一段，请改用 Git Bash、WSL，或在 Linux 上执行。

## 标签怎么选

[Bililive-go v0.8.3](https://github.com/bililive-go/bililive-go/releases/tag/v0.8.3) 发布于 2026-09-25。发布说明写的是斗鱼 cookie 自动续期，以及部分问题修复。Docker Hub 镜像 `chigusa/bililive-go` 上对应的具体标签是 **`v0.8.3`**。

2026-09-25 推送后，Docker Hub 上 `latest` 与 `v0.8.3` 的清单 digest 同为 `sha256:95e304f6250fa4ea833e14114393b8021d363d4ef868c0ab5f15dfae26ab2d4f`。到 2026-10-19，这两个标签仍指向这份清单。`latest` 会在下一次发版时改指向，不要写进命令。`v0.8.0-rc.*` 是候选版本。`v0.7.39` 属于上一条版本线。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`v0.8.3`** | 2026-09-25 发布的具体版本 | **是** |
| `latest` | 浮动标签，会继续变化 | 否 |
| `v0.8.2` | 上一版具体版本 | 否 |
| `v0.8.0-rc.*` | 0.8.0 的候选版本 | 否 |
| `v0.7.39` | 0.7 线的具体版本 | 否 |

`v0.8.3` 提供 linux/amd64、linux/arm64、linux/arm/v7。这一版没有 linux/386 和 linux/arm/v6。

完整标签见 [chigusa/bililive-go 标签列表](https://xuanyuan.cloud/r/chigusa/bililive-go/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/chigusa/bililive-go:v0.8.3
```

Ubuntu 24.04 实测：

```text
Digest: sha256:95e304f6250fa4ea833e14114393b8021d363d4ef868c0ab5f15dfae26ab2d4f
Status: Downloaded newer image for docker.xuanyuan.run/chigusa/bililive-go:v0.8.3
docker.xuanyuan.run/chigusa/bililive-go:v0.8.3
```

完成后确认本地有这个标签，再写下面的 Compose：

```bash
docker images docker.xuanyuan.run/chigusa/bililive-go:v0.8.3
```

```text
IMAGE                                            ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/chigusa/bililive-go:v0.8.3   95e304f6250f       1.53GB          410MB
```

## Docker Compose 部署

工作目录是 `/www/wwwroot/bililive-go`。`Videos/` 挂到容器内 `/srv/bililive`，录像和 `.appdata` 都在这里。删掉 `Videos/` 会丢掉录像和程序数据。`config.yml` 挂到容器内 `/etc/bililive-go/config.yml`。删掉这个文件会丢掉房间列表、cookie 和已经改过的设置。`docker compose down` 不加额外参数时，不会删除这两个路径。

宿主机 **8080** 对应容器内 **8080**，与仓库 `docker-compose.yml` 和 `config.docker.yml` 里的网页端口一致。8080 已被占用时，只改冒号左边的宿主机端口。

配置文件必须先写成文件，再启动。如果宿主机上还没有 `config.yml`，Docker 会按目录去创建这个路径，容器就起不来。

镜像默认 `PUID=0`、`PGID=0`。入口脚本启动时会把 `/srv/bililive`、`/etc/bililive-go` 和 `/opt/bililive` 的属主改成这两个值，所以 `Videos/` 和 `config.yml` 会变成 root 所有。要改成当前用户，先看下面两个数。这次实测的用户是 root，两个数都是 0，Compose 里不写 `PUID`、`PGID`。

```bash
id -u
id -g
```

以前用 `docker run` 创建过名为 `bililive-go` 的容器时，先删掉容器再启动 Compose。这一步不删除宿主机上的 `config.yml` 和 `Videos/`。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/bililive-go/Videos
sudo chown -R "$USER":"$USER" /www/wwwroot/bililive-go
```

2. 写入 `config.yml`。内容与 v0.8.3 仓库里的 `config.docker.yml` 一致。`live_rooms` 先空着，房间到网页里再加。`interval` 是 20，设置页上的名称是「检测间隔 (秒)」。通知三项的 `enable` 都是 `false`。示例里的地址和 token 不能直接拿去发通知。

```bash
cd /www/wwwroot/bililive-go
cat > config.yml <<'EOF'
rpc:
  enable: true
  bind: :8080
debug: false
interval: 20
out_put_path: /srv/bililive
app_data_path: /srv/bililive/.appdata
read_only_tool_folder: /opt/bililive/tools
feature:
  use_native_flv_parser: false
live_rooms:

# 通知服务配置
notify:
  telegram:
    # 是否开启Telegram通知
    enable: false
    # 是否启用声音通知
    withNotification: true
    # Telegram机器人Token
    botToken: ""
    # Telegram聊天ID
    chatID: ""
  email:
    # 是否开启Email通知
    enable: false
    # SMTP服务器地址 (例如: smtp.gmail.com, smtp.qq.com等)
    smtpHost: "smtp.qq.com"
    # SMTP服务器端口 (常用端口: 25, 465, 587)
    smtpPort: 465
    # 发送者邮箱地址
    senderEmail: ""
    # 发送者邮箱授权码或应用专用密码
    senderPassword: ""
    # 接收者邮箱地址
    recipientEmail: ""
  ntfy:
    enable: false
    URL: https://ntfy.sh/xxxx
    token: tk_xxxxxxxxx
    tag: new
EOF
```

3. 写入 `compose.yaml`：

```bash
cd /www/wwwroot/bililive-go
cat > compose.yaml <<'EOF'
name: bililive-go

services:
  bililive-go:
    image: docker.xuanyuan.run/chigusa/bililive-go:v0.8.3
    container_name: bililive-go
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - ./Videos:/srv/bililive
      - ./config.yml:/etc/bililive-go/config.yml
EOF
```

uid、gid 不是 0，又希望录像不要属于 root 时，把下面三行插在 `restart` 和 `ports` 之间。`1000` 只是示例，换成前面 `id -u` 和 `id -g` 的输出：

```yaml
    environment:
      PUID: "1000"
      PGID: "1000"
```

4. 启动：

```bash
cd /www/wwwroot/bililive-go
docker compose up -d
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network bililive-go_default Created
 ✔ Container bililive-go       Started
```

5. 确认容器在运行：

```bash
cd /www/wwwroot/bililive-go
docker compose ps
```

这次执行时，容器已经是 Up，8080 已经映射出来，程序还没有打印启动日志。入口脚本会先改 `/opt/bililive`、`Videos/` 和 `config.yml` 的属主。这段时间 `docker compose logs` 是空的，浏览器访问 8080 会显示连接被拒绝。属主改完之后才会执行 `bililive-go`。

```text
NAME          IMAGE                                            COMMAND               SERVICE       CREATED         STATUS         PORTS
bililive-go   docker.xuanyuan.run/chigusa/bililive-go:v0.8.3   "sh /entrypoint.sh"   bililive-go   8 seconds ago   Up 5 seconds   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp
```

6. 看启动日志。程序把日志同时写到标准错误，以及 `Videos/` 里 `bililive-go-` 开头的文件。`Ctrl+C` 只结束日志跟踪，不会停掉容器。

```bash
cd /www/wwwroot/bililive-go
docker compose logs -f --tail 100 bililive-go
```

下面是 Ubuntu 24.04 这次启动里用来判断网页已经起来的几行。

```text
bililive-go  | [Launcher] 诊断信息: exePath=/usr/bin/bililive-go, appDataPath=/srv/bililive/.appdata, appVersion="v0.8.3", flag.Conf="/etc/bililive-go/config.yml"
bililive-go  | [Launcher.Check] 状态文件不存在，正常启动
bililive-go  | [Launcher] Check 结果: ShouldBeLauncher=false (state=<nil>)
bililive-go  | time="2026-10-19 22:10:56" level=info msg="BiliLive-go Version: v0.8.3 Link Start"
bililive-go  | time="2026-10-19 22:10:58" level=info msg="Server start at :8080"
bililive-go  | time="2026-10-19 22:10:58" level=info msg="HTTP server started, initializing live rooms..."
bililive-go  | time="2026-10-19 22:10:58" level=info msg="FFmpeg found from remotetools: /opt/bililive/tools/linux/amd64/ffmpeg/n8.1-latest/bin/ffmpeg"
bililive-go  | time="2026-10-19 22:11:00" level=info msg="Created 0 live rooms (0 listening, 0 not listening)"
```

日志里出现 `Server start at :8080` 后，再打开浏览器。也可以在这台机器上先确认网页已经在听：

```bash
curl -I http://127.0.0.1:8080/
```

返回 `HTTP/1.1 200 OK` 即可。浏览器访问 `http://服务器IP:8080`。把地址里的服务器 IP 换成这台机器的地址。系统代理若把局域网地址也转走，这个地址要绕过代理。

## 浏览器首次使用

这份配置里一开始没有房间，也没有网页登录。下面这次添加的地址是 `https://live.bilibili.com/98`。录制从 22:27:19 到 22:39:03，文件留在 `Videos/哔哩哔哩/吃鸡赛事/`。

1. 打开 `http://服务器IP:8080`。左侧当前是「监控列表」。页内标题是「直播间列表」，旁边还有「Cookie管理」。表头为主播名称、直播间名称、直播平台、运行状态、操作。列表中间是「No data」。右上角是一个开关、「保存设置」和「添加房间」。

![Bililive-go 直播间列表：列表为 No data，右上角有保存设置和添加房间](https://imgs.xuanyuan.cloud/docker/blog/bililive-go/bililive-go-1.webp)

2. 点击「添加房间」。窗口标题是「添加直播间」，默认停在「单个添加」。地址填 `https://live.bilibili.com/98`。「添加后立即监听」开着，「仅开播提醒（不自动录制）」关着。点击「添加」。

![Bililive-go 添加直播间：单个添加，地址为 https://live.bilibili.com/98，添加后立即监听已打开](https://imgs.xuanyuan.cloud/docker/blog/bililive-go/bililive-go-2.webp)

3. 添加成功时，页面上方提示「添加成功」，窗口里是一条绿色进度和「关闭」。

![Bililive-go 添加直播间：提示添加成功，进度条为绿色，按钮为关闭](https://imgs.xuanyuan.cloud/docker/blog/bililive-go/bililive-go-3.webp)

4. 关掉窗口后回到列表。这一行主播名称是吃鸡赛事，直播间名称是 PGS赛事，直播平台是哔哩哔哩，运行状态是「录制准备中」。操作有「停止监控」「删除」「文件」「配置」。

![Bililive-go 直播间列表：吃鸡赛事、PGS赛事，运行状态为录制准备中](https://imgs.xuanyuan.cloud/docker/blog/bililive-go/bililive-go-4.webp)

5. 点这一行的「配置」，进入「设置」里的「直播间设置」。这一张上名称是「未知主播」，绿色标签是「监控中」，右侧地址是 `https://live.bilibili.com/98`。它和上一张列表不是同一时刻：列表里已经是吃鸡赛事和「录制准备中」。「启用监控」开着，「仅开播提醒」关着。页面下面的按钮是「保存直播间配置」。

![Bililive-go 直播间设置：未知主播处于监控中，地址为 https://live.bilibili.com/98，按钮为保存直播间配置](https://imgs.xuanyuan.cloud/docker/blog/bililive-go/bililive-go-5.webp)

6. 仍是这一页，能看到「配置覆盖」。检测间隔写着继承全局 20 秒，输出路径的实际生效值是 `/srv/bililive`。FFmpeg 路径是「自动查找」，蓝色字是 `/opt/bililive/tools/linux/amd64/ffmpeg/n8.1-latest/bin/ffmpeg`。输出路径要留在 `/srv/bililive`，否则录像不会进宿主机的 `Videos/`。这一页没有点「保存直播间配置」。

![Bililive-go 直播间设置：配置覆盖中输出路径为 /srv/bililive，FFmpeg 为自动查找](https://imgs.xuanyuan.cloud/docker/blog/bililive-go/bililive-go-6.webp)

7. 回到列表，点这一行的「文件」。路径是「输出文件路径 / 哔哩哔哩 / 吃鸡赛事」。文件名是 `[2026-10-19 22-27-19][吃鸡赛事][PGS赛事].flv`，大小 84.25 MB，旁边标着「无字幕」。这一行右侧有「重命名」「上传」「删除」。

![Bililive-go 录像目录：哔哩哔哩/吃鸡赛事下有一场 84.25 MB 的 flv](https://imgs.xuanyuan.cloud/docker/blog/bililive-go/bililive-go-7.webp)

8. 点这个文件名。播放器标题是「正在播放：[2026-10-19 22-27-19][吃鸡赛事][PGS赛事].flv」，画面是 PGS 积分榜。日志里 `Record Start` 在 22:27:19，`Record End` 在 22:39:03。录制中途的 `response code 412` 见「常见问题」。

![Bililive-go 网页播放器：正在播放吃鸡赛事的 PGS 录像，画面为积分榜](https://imgs.xuanyuan.cloud/docker/blog/bililive-go/bililive-go-8.webp)

9. 打开左侧「设置」。页签是「GUI 模式」和「YAML 模式」，这一张停在配置表单。输出路径是 `/srv/bililive`，「日志按天切分」开着，「检查间隔（小时）」是 6。页面最下面是「保存设置」。输出路径保持 `/srv/bililive`。

![Bililive-go 全局设置：输出路径为 /srv/bililive，日志按天切分开着，下方按钮为保存设置](https://imgs.xuanyuan.cloud/docker/blog/bililive-go/bililive-go-9.webp)

10. 打开左侧「弹幕」。标题是「弹幕录制配置」。「录制弹幕」关着。字体大小是 36，字体是微软雅黑（Microsoft YaHei），滚动区域是全屏，滚动时间是 10 秒，分辨率是 1920x1080。下面有 `https://live.bilibili.com/98` 这一条。要录弹幕时再打开「录制弹幕」，然后点「保存」。

![Bililive-go 弹幕录制配置：录制弹幕关闭，字体 36，分辨率 1920x1080](https://imgs.xuanyuan.cloud/docker/blog/bililive-go/bililive-go-10.webp)

11. 打开左侧「文件」。标题是「输出文件路径」，这是录像目录的根，不是某一个房间。三行分别是 `.appdata`、`哔哩哔哩` 和 `bililive-go-2026-10-19.log`。日志文件大小是 4.75 kB。房间录像在 `哔哩哔哩` 里面。

![Bililive-go 输出目录根：有 .appdata、哔哩哔哩和 bililive-go-2026-10-19.log](https://imgs.xuanyuan.cloud/docker/blog/bililive-go/bililive-go-11.webp)

12. 打开左侧「工具」，进入「外部工具管理器」。右上角运行平台是 linux/amd64。ffmpeg 为 n8.1-latest 已安装，node 为 v20.10.0 已安装，bililive-recorder 为 v2.17.3 已安装，bililive-scheduler 为 v0.1.0 已安装，dotnet 为 8.0.20 已安装，openlist 为 v4.2.4 已安装。biliLive-tools 一栏是已启用，默认版本写着未安装。启动日志 22:11:00 另有一行 `bililive-tools 服务已就绪`。klive 一栏写着「该工具组暂无工具」。

![Bililive-go 外部工具管理器：运行平台为 linux/amd64，ffmpeg 与 node 显示已安装，biliLive-tools 默认版本未安装](https://imgs.xuanyuan.cloud/docker/blog/bililive-go/bililive-go-12.webp)

13. 打开左侧「调度器」，进入「调度器仪表盘」。状态是「运行中」，已运行 13 分 45 秒。总任务数、正在录制、错误任务都是 0。bililive-go API 为「可达」。检查间隔是 15 秒。这次 22:10:56 开始下载调度器，22:24:42 才打印 `listening on port 43173`。43173 在容器内，没有映射到宿主机。直播间页面在 8080 起来之后就能用。

![Bililive-go 调度器仪表盘：运行中 13 分 45 秒，bililive-go API 可达，检查间隔 15 秒](https://imgs.xuanyuan.cloud/docker/blog/bililive-go/bililive-go-13.webp)

## 支持的直播平台

下面是 v0.8.3 仓库 README 里的支持表。cookie 一列有标记的，是哔哩哔哩、抖音和 SOOP。

| 站点 | 地址 | cookie |
|------|------|--------|
| Acfun 直播 | live.acfun.cn | |
| 哔哩哔哩直播 | live.bilibili.com | 支持 |
| 战旗直播 | www.zhanqi.tv | |
| 斗鱼直播 | www.douyu.com | |
| 虎牙直播 | www.huya.com | |
| CC 直播 | cc.163.com | |
| 一直播 | www.yizhibo.com | |
| OPENREC | www.openrec.tv | |
| 企鹅电竞 | egame.qq.com | |
| 浪 live | play.lang.live 与 www.lang.live | |
| 花椒 | www.huajiao.com | |
| 抖音直播 | live.douyin.com | 支持 |
| 猫耳 | fm.missevan.com | |
| 克拉克拉 | www.hongdoufm.com | |
| YY 直播 | www.yy.com | |
| 微博直播 | weibo.com | |
| SOOP | play.sooplive.com | 支持 |

cookie 按域名写。抖音的例子如下。`name` 和 `value` 只说明多条之间用分号隔开，要换成你自己从该网站拿到的键。

```yaml
cookies:
  live.douyin.com: __ac_nonce=123456789012345678903;name=value
```

写好后在「设置」里保存，或直接改宿主机上的 `config.yml` 再重启容器。网页「直播间列表」还有「Cookie管理」这一页，可以在页面里维护。

v0.8.3 的发布说明包含斗鱼 cookie 自动续期。上面这张表来自该版 README，斗鱼那一格是空的。

## 升级

升级前先备份 `/www/wwwroot/bililive-go/config.yml` 和 `/www/wwwroot/bililive-go/Videos`。新容器必须继续挂载这两个路径。换了一份空配置或空目录，启动后就是一套没有房间、没有录像的新环境。

1. 把 `compose.yaml` 里的镜像标签改成要升级的版本号。

2. 拉取并重建容器：

```bash
cd /www/wwwroot/bililive-go
docker compose pull
docker compose up -d
```

3. 再次确认 `docker compose ps` 里容器为 Up，然后用原来的地址打开网页，看房间列表还在。

## 备选：docker run

没有 Compose 时，可以用 `docker run` 做一次临时启动。配置文件、录像目录、端口和镜像标签与上面的 Compose 相同。这条命令的重启策略与项目文档里的 `docker run` 示例一致，是 `always`。

还没有 `config.yml` 和 `Videos/` 时，先按「Docker Compose 部署」写好这两个路径。配置文件必须是文件，不能是目录。

已经有名为 `bililive-go` 的容器时，先删除容器。这一步不删除 `/www/wwwroot/bililive-go` 里的文件。

```bash
docker rm -f bililive-go
docker run -d 
  --name bililive-go 
  --restart=always 
  -v /www/wwwroot/bililive-go/config.yml:/etc/bililive-go/config.yml 
  -v /www/wwwroot/bililive-go/Videos:/srv/bililive 
  -p 8080:8080 
  docker.xuanyuan.run/chigusa/bililive-go:v0.8.3
```

查看状态和日志：

```bash
docker ps --filter name=bililive-go
docker logs -f --tail 100 bililive-go
```

浏览器地址与「浏览器首次使用」相同。

## 常见问题

**Q1：`latest` 能不能写进 Compose？**

不要写。`latest` 会在下一次发版时改指向。说明见「标签怎么选」。

**Q2：容器是 Up，`docker logs` 是空的，浏览器却拒绝连接？**

入口脚本还在改属主时，`bililive-go` 还没听 8080，`docker compose logs` 也是空的。等到日志里出现 `Server start at :8080`，或本机 `curl -I http://127.0.0.1:8080/` 返回 200，再刷新浏览器。日志文件在 `/www/wwwroot/bililive-go/Videos/`，文件名以 `bililive-go-` 开头。系统代理把局域网地址转走时，浏览器也会显示连接被拒绝。

**Q3：启动报配置路径是目录？**

`-v` 或 Compose 的 `volumes` 指向一个还不存在的 `config.yml` 时，Docker 会创建目录，而不是空文件。先停掉容器，删掉这个错误的目录，再用「Docker Compose 部署」里的 `cat` 写出 `config.yml`，然后重新启动。

**Q4：要不要给网页设密码？**

本文这份 `config.yml` 没有网页登录项。`rpc.bind` 是 `:8080`，映射出去之后，能访问这个端口的人就能改房间和设置。安全组或防火墙里只放行你自己的地址。不要把 8080 对公网开放。

**Q5：8080 已经被占用？**

只改映射的宿主机端口，例如 `8088:8080`。容器内仍然是 8080，`config.yml` 里的 `bind: :8080` 不用改。访问地址改成新的宿主机端口。

**Q6：保存设置成功了，行为却没变？**

项目说明写的是：保存成功表示配置已经写入磁盘；有的配置要停止监控后再重新开始监控，有的要重启程序。列表里这一行可以点「停止监控」，再点「开启监控」。仍然没变时，执行 `docker compose restart bililive-go`。

**Q7：录像频繁分段，或中途花屏？**

官方常见问题把频繁分段归到网络波动。中途花屏，官方说明通常出现在主播开始 PK、分辨率发生细小变化、而默认 ffmpeg 处理不了这种变化的时候。把 `config.yml` 里的 `feature.use_native_flv_parser` 改成 `true` 后，会改用内置 FLV 解析，并在分辨率变化时自动分段。改完按 Q6 重新开始监控，或重启容器。

**Q8：录像文件属于 root，普通用户删不掉？**

镜像默认 `PUID=0`、`PGID=0`。入口脚本会按这两个值修改 `Videos/` 和 `config.yml` 的属主。在 `compose.yaml` 里加上 `PUID` 和 `PGID`，数值用 `id -u`、`id -g`，然后 `docker compose up -d`。已经变成 root 的旧文件，需要再改一次属主。

**Q9：重建之后，房间和录像都没了？**

核对挂载是否仍是 `/www/wwwroot/bililive-go/config.yml` 和 `/www/wwwroot/bililive-go/Videos`。房间列表在配置文件里，录像在 `Videos/`。`docker compose down` 本身不会删除这两个路径。

**Q10：拉取报 `no matching manifest`？**

`v0.8.3` 提供 linux/amd64、linux/arm64、linux/arm/v7。32 位 x86 和 armv6 拉不到这个标签。

**Q11：抖音、哔哩哔哩录下来的是未登录状态？**

这两个站点以及 SOOP，在 v0.8.3 的支持表里标记了 cookie。按「支持的直播平台」里的写法，把该域名的 cookie 写入 `config.yml`。键的内容要从你自己的浏览器里取，文中的 `__ac_nonce` 和 `name=value` 只是格式例子。

**Q12：日志里是 `room not exists`，而且 `room=/`？**

这次 22:26:13 出现过：

```text
level=warning msg="初始化直播间信息失败，将继续重试" error="room not exists" host=live.bilibili.com room=/
```

`room=/` 不是一个具体房间号。后来添加的 `https://live.bilibili.com/98` 进入了列表，并在 22:27:19 打印 `Record Start`。地址要写成带房间号的直播间链接。

**Q13：录制过程中反复出现 `response code 412 from user api`？**

这次录 `https://live.bilibili.com/98` 时，从 22:27:39 起多次出现这条错误。22:39:03 仍打印 `Record End`，接着 FLV 修复完成。文件在 `Videos/哔哩哔哩/吃鸡赛事/`，页面上大小是 84.25 MB。412 是哔哩哔哩接口返回的状态。这次它没有让录像停在 `Record Start` 之前。若列表里没有文件，再看同一段日志里有没有 `Record Start` 和 `Record End`。

**Q14：要不要一起启动 Prometheus 和 Grafana？**

本文不启用。仓库 `docker-compose.yml` 里这两段是注释。其中 Grafana 的示例把宿主机 3000 映到容器 3000。需要统计面板时按 [Grafana 说明](https://github.com/bililive-go/bililive-go/blob/v0.8.3/docs/grafana.md) 单独配置，并把宿主机端口改成 3000 以外。

## 命令速查

```bash
docker pull docker.xuanyuan.run/chigusa/bililive-go:v0.8.3

cd /www/wwwroot/bililive-go
docker compose up -d
docker compose ps
docker compose logs -f --tail 100 bililive-go

docker compose pull
docker compose up -d
docker compose restart bililive-go
docker compose stop
docker compose start
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://服务器IP:8080`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [chigusa/bililive-go 镜像页](https://xuanyuan.cloud/zh/r/chigusa/bililive-go) | [https://xuanyuan.cloud/zh/r/chigusa/bililive-go](https://xuanyuan.cloud/zh/r/chigusa/bililive-go) |
| [chigusa/bililive-go 概览](https://xuanyuan.cloud/r/chigusa/bililive-go) | [https://xuanyuan.cloud/r/chigusa/bililive-go](https://xuanyuan.cloud/r/chigusa/bililive-go) |
| [chigusa/bililive-go 标签列表](https://xuanyuan.cloud/r/chigusa/bililive-go/tags) | [https://xuanyuan.cloud/r/chigusa/bililive-go/tags](https://xuanyuan.cloud/r/chigusa/bililive-go/tags) |
| [Docker Hub · chigusa/bililive-go](https://hub.docker.com/r/chigusa/bililive-go) | [https://hub.docker.com/r/chigusa/bililive-go](https://hub.docker.com/r/chigusa/bililive-go) |
| [GitHub · bililive-go/bililive-go](https://github.com/bililive-go/bililive-go) | [https://github.com/bililive-go/bililive-go](https://github.com/bililive-go/bililive-go) |
| [Release · v0.8.3](https://github.com/bililive-go/bililive-go/releases/tag/v0.8.3) | [https://github.com/bililive-go/bililive-go/releases/tag/v0.8.3](https://github.com/bililive-go/bililive-go/releases/tag/v0.8.3) |
| [常见问题](https://github.com/bililive-go/bililive-go/blob/v0.8.3/docs/FAQ.md) | [https://github.com/bililive-go/bililive-go/blob/v0.8.3/docs/FAQ.md](https://github.com/bililive-go/bililive-go/blob/v0.8.3/docs/FAQ.md) |
| [通知服务](https://github.com/bililive-go/bililive-go/blob/v0.8.3/docs/notify.md) | [https://github.com/bililive-go/bililive-go/blob/v0.8.3/docs/notify.md](https://github.com/bililive-go/bililive-go/blob/v0.8.3/docs/notify.md) |
| [Wiki](https://github.com/bililive-go/bililive-go/wiki) | [https://github.com/bililive-go/bililive-go/wiki](https://github.com/bililive-go/bililive-go/wiki) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/bililive-go-docker-deploy


