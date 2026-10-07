# Docker 部署 Emby：轻松搭建家庭影音媒体服务器

![Docker 部署 Emby：轻松搭建家庭影音媒体服务器](https://imgs.xuanyuan.cloud/docker/blog/emby.webp)

*分类: Docker部署教程 | 标签: Emby, amilys/embyserver, Docker, 轩辕镜像, 媒体服务器, 影音库, 私有化部署, 部署教程 | 发布时间: 2026-10-06 16:14:53*

> Emby 是面向家庭的媒体服务器，把电影、剧集、音乐和照片收成媒体库，在浏览器、手机和电视上串流，并记住各端的播放进度。本文用 Docker Compose 部署 amilys/embyserver 之后，可以在网页里建库、扫库并点播本机目录里的视频。适合家庭影音库、NAS 自托管与内网多人一起看。

*本文基于 [amilys/embyserver:4.10.1.0-amd64](https://xuanyuan.cloud/zh/r/amilys/embyserver)，实测引擎 **Emby Server 4.10.1.0**（.NET **8.0.28**），测试平台 **Ubuntu 24.04** Linux。*

硬盘里的电影和剧集按季、按文件夹越堆越乱。客厅电视用文件管理器翻 SMB 共享，点开「未整理」才发现季和集对不上，外挂字幕还躺在另一个目录。手机想接着看昨晚放到一半的那一集，进度停在电脑上的播放器里，两边对不上。4K 原盘直接拖进网页播放器，CPU 风扇先响起来，进度条还在转圈。家里两个人各看各的，账号和观看记录也拆不开。

把这些片子再丢进网盘，家人要另装一个客户端，画质和流量都不在自己手里；小孩活动、家庭录像也不适合再传出去。公共流媒体账号又覆盖不了自己硬盘里的片。直接在系统里装一套媒体服务，转码组件、依赖和升级缠在一起。家里或机房已经有一台跑 Docker 的 Linux，缺的是：服务能拉起来、电影目录挂进去、浏览器打开就能建库，电视和手机再连同一台服务器。

**Emby**（[官网](https://emby.media/)、[镜像页](https://xuanyuan.cloud/zh/r/amilys/embyserver)）是面向家庭的媒体服务器：电影、剧集、音乐和照片收成媒体库，浏览器、手机和电视客户端串流，并同步播放进度。本文用的 **`amilys/embyserver`** 是维护者 amilys 的社区镜像。配置落在容器内 `/config`，片库由你把宿主机目录挂进去。容器启动时会执行 `/config/config/ext.sh`，用来开关界面美化（[emby-crx](https://github.com/Nolovenodie/emby-crx)）、弹幕（[dd-danmaku](https://github.com/RyoLee/dd-danmaku)）和外部播放器（[embyExternalUrl](https://github.com/bpking1/embyExternalUrl)）。本文使用 **`amilys/embyserver:4.10.1.0-amd64`** 版本实测。

跑通之后，可以在浏览器里创建管理员，把挂进容器的目录收成电影库或剧集库，再用电视、手机上的 Emby 客户端连同一台服务器接着看。

---

## 一、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux；macOS 上把工作目录换成 `~/docker/embyserver` |
| Docker | Engine + **Compose V2**（`docker compose version` 能输出版本） |
| 架构 | x86_64 用 **`4.10.1.0-amd64`**；aarch64 用 **`4.10.1.0-arm64`** |
| 内存 | 扫描片库和软解转码时会再升高 |
| 磁盘 | Docker Hub 对 amd64 标签标注约 **365 MB**。片库、海报和转码缓存另计 |
| 端口 | 宿主机 **8096** → 容器 **8096**（HTTP）。可选宿主机 **8920** → 容器 **8920**（HTTPS，要在 Emby 里配置证书后才走加密） |
| 权限 | `privileged: true`。启动脚本要写 `/config/config/ext.sh`，并修改镜像内的 `/system` |
| 工作目录 | `/www/wwwroot/embyserver` |

先看本机架构，再决定标签：

```bash
uname -m
docker --version
docker compose version
```

`x86_64` 用后文的 **`4.10.1.0-amd64`**。`aarch64` 把命令和 Compose 里的标签改成 **`4.10.1.0-arm64`**。

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```

备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见[轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 二、拉取镜像

### 2.1 标签怎么选

维护者 2026-10-03 的说明里，稳定版是 **v4.10.1.0**，beta 是 **v4.10.0.11**。Docker Hub 上没有不带架构后缀的 `4.10.1.0` 标签，稳定版拆成两个架构标签。

| 标签 | 说明 | 本文是否采用 |
|------|------|--------------|
| **`4.10.1.0-amd64`** | 稳定版 v4.10.1.0 的 amd64，2026-10-03 推送 | **x86_64 采用** |
| **`4.10.1.0-arm64`** | 同一稳定版的 arm64 | **aarch64 改用这个** |
| `4.10.0.11` | 维护者表中的 beta，2026-08-08，早于当前稳定版 | 不作为默认 |
| `4.9.5.0` 及更早 | 上一稳定线或更旧版本 | 仅回退时用 |
| `beta` | 浮动标签，当前指向 `4.10.0.11` | 不要用于 pull 或 Compose |
| `latest` | 浮动多架构标签，2026-10-03 指向 v4.10.1.0 | 不要用于 pull 或 Compose |

`latest` 会随维护者下一次推送改指向。升级时改 Compose 里的具体版本标签，并对照[标签列表](https://xuanyuan.cloud/r/amilys/embyserver/tags)。

### 2.2 用轩辕镜像加速拉取

x86_64：

```bash
docker pull docker.xuanyuan.run/amilys/embyserver:4.10.1.0-amd64
```

Ubuntu 24.04 实测：

```text
4.10.1.0-amd64: Pulling from amilys/embyserver
Digest: sha256:9c457402dcf38b1fb116bfaa1b5a2e9c2eb8001adc2e7743e86cbe63d178c433
Status: Downloaded newer image for docker.xuanyuan.run/amilys/embyserver:4.10.1.0-amd64
docker.xuanyuan.run/amilys/embyserver:4.10.1.0-amd64
```

aarch64 改为：

```bash
docker pull docker.xuanyuan.run/amilys/embyserver:4.10.1.0-arm64
```

---

## 三、Docker Compose 部署（主路径）

按这个顺序做：建立 `config/config` 目录，写入 `compose.yaml`，执行 `docker compose up -d`，再打开向导。

开始之前确认：

- 工作目录是 `/www/wwwroot/embyserver`。macOS 换成 `~/docker/embyserver`。
- 宿主机 **8096** 映射到容器 **8096**。本机若已经占用 8096，把冒号左边改成别的端口，例如 `18096:8096`，后文网址同步改端口。
- 镜像标签与上一节一致。ARM 机器把 `image` 改成 `4.10.1.0-arm64`。
- 启动脚本会把 `ext.sh` 复制到容器内 `/config/config/ext.sh`，并改镜像里的 `/system`。父目录不存在，或设置了 `UID` / `GID` 时，进程会退出并被重启，浏览器看到连接被拒绝。Ubuntu 24.04 上的失败日志见 FAQ。
- 片库若已经在别的磁盘，只改 Compose 里卷的宿主机路径，容器内路径保持 `/media`。向导里选的是容器内路径。

### 3.1 准备目录

`config/config` 是给 `ext.sh` 用的，不要只建到 `config` 这一层。

```bash
sudo mkdir -p /www/wwwroot/embyserver/config/config /www/wwwroot/embyserver/media
cd /www/wwwroot/embyserver
```

| 宿主机目录 | 容器路径 | 用途 |
|------------|----------|------|
| `/www/wwwroot/embyserver/config` | `/config` | 用户、媒体库、插件 |
| `/www/wwwroot/embyserver/config/config` | `/config/config` | `ext.sh`。目录必须在启动前存在 |
| `/www/wwwroot/embyserver/media` | `/media` | 电影、剧集等媒体文件。向导里选这个路径 |

### 3.2 写入 compose.yaml

片库不在 `/www/wwwroot/embyserver/media` 时，把卷的左侧路径换成真实目录，右侧仍写 `/media`。

```bash
cd /www/wwwroot/embyserver
cat > compose.yaml <<'EOF'
services:
  emby:
    image: docker.xuanyuan.run/amilys/embyserver:4.10.1.0-amd64
    container_name: embyserver
    restart: unless-stopped
    privileged: true
    ports:
      - "8096:8096"
      - "8920:8920"
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - /www/wwwroot/embyserver/config:/config
      - /www/wwwroot/embyserver/media:/media
EOF
```

要点：

- 宿主机 **8096** → 容器 **8096**，浏览器走 HTTP。
- 宿主机 **8920** → 容器 **8920**。要在 Emby 里配好证书，HTTPS 才会可用。
- `privileged: true` 与上面的目录配套。Compose 里不要再加 `UID`、`GID`。
- 不使用 `network_mode: host`。主机网络和 `ports` 不能写在一起。DLNA 见常见问题。
- 这一节不挂 GPU。需要核显时用第七节的 Compose 覆盖本文件。

### 3.3 启动

```bash
cd /www/wwwroot/embyserver
docker compose up -d
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network embyserver_default Created
 ✔ Container embyserver       Started
```

容器起来之后再看状态：

```bash
docker compose ps
```

状态应为 `Up`，端口映射里能看到 `8096` 和 `8920`。

然后再看日志：

```bash
docker compose logs --tail 40
```

Ubuntu 24.04 实测：

```text
Emby扩展启动脚本
Info Main: Emby Server 4.10.1.0
  Command line: /system/EmbyServer.dll -programdata /config -ffdetect /bin/ffdetect -ffmpeg /bin/ffmpeg -ffprobe /bin/ffprobe -restartexitcode 3
  Framework: .NET 8.0.28
  Data path: /config
Info Main: Logs path: /config/logs
Info Main: Cache path: /config/cache
Info Main: Internal metadata path: /config/metadata
Info Main: Local time: 10/06/2026 14:25:22 +08:00
Info App: Emby Server Version: 4.10.1.0
Info App: Copying plugin from /system/plugins/MovieDb.dll to /config/plugins/MovieDb.dll
```

日志里应有 `Emby扩展启动脚本` 和 `Emby Server 4.10.1.0`。插件会继续从 `/system/plugins` 复制到 `/config/plugins`。若隔一两秒就重复 `Shutdown complete`，先按常见问题里的「8096 拒绝连接」处理，先不要打开浏览器。

打开浏览器之前，把地址里的 IP 换成你的服务器地址。

```text
http://<服务器IP>:8096
```

---

## 四、浏览器首次设置

用上一节的地址打开。镜像没有预置管理员密码。向导里创建的第一个用户就是管理员。

向导第一页可以选择 **Chinese Simplified**，但后面几页和登录后的主页仍可能是英文。侧栏变成「首页」「我的媒体」，要等登录后在 **General** 里把 Display language 改成 **Chinese (China)**。

### 4.1 选择语言

1. 打开 `http://<服务器IP>:8096`。
2. 在 Preferred display language 里选择 **Chinese Simplified**。
3. 点击 **Next**。

![Emby 首次打开：Welcome to Emby，首选显示语言下拉框，绿色 Next](https://imgs.xuanyuan.cloud/docker/blog/emby-1.webp)

![Emby 向导语言列表：选中 Chinese Simplified，其下还有 Chinese Traditional](https://imgs.xuanyuan.cloud/docker/blog/emby-2.webp)

### 4.2 创建管理员

1. 在 Create Your First User 里填写用户名。
2. 填写 New password，并在 New password confirm 里再输入一次。
3. 点击 **Next**。

用户名自定。本次填写的是 `root`。这是 Emby 里的用户名，和宿主机登录无关。密码只在这一步设置。

![Emby 创建第一个用户：用户名 root，新密码与确认密码，Previous 与 Next](https://imgs.xuanyuan.cloud/docker/blog/emby-3.webp)

### 4.3 添加媒体库

视频放在宿主机的 `/www/wwwroot/embyserver/media`，或你在 Compose 里改过的那个目录。向导里填的是容器路径 `/media`。目录里暂时没有文件也可以建库，影片页会显示「共 0 项」；文件放进去之后再扫描。

1. 在 Setup Media Libraries 点击 **New Library**。
2. Content type 选 **Movies**，Display name 保持 **Movies**。
3. 在 Folders 里添加 `/media`。
4. Preferred metadata download language 选 **Chinese Simplified**，Certification country 选 **China**。
5. 点击 **OK**。
6. 确认卡片上的路径是 `/media`，再点击 **Next**。

文件夹不要填宿主机路径 `/www/wwwroot/embyserver/media`，容器里没有这个目录。也不要选容器根目录 `/`。

![Emby 设置媒体库：Setup Media Libraries，右侧 New Library，中间 Next](https://imgs.xuanyuan.cloud/docker/blog/emby-4.webp)

![Emby 新建媒体库：类型 Movies，文件夹 /media，元数据语言 Chinese Simplified，国家 China](https://imgs.xuanyuan.cloud/docker/blog/emby-5.webp)

![Emby 媒体库卡片：Movies，路径 /media，下方 Next](https://imgs.xuanyuan.cloud/docker/blog/emby-6.webp)

刮削需要服务器能访问对应的元数据网站。访问不到时，库仍然可以按文件名浏览和播放。

### 4.4 远程访问

只在家里局域网使用时，关掉 **Enable automatic port mapping**，再点击 **Next**。这个开关会尝试用 UPnP 把公网端口映射到本机，部分路由器不支持，也不适合只给内网看片的机器。

本次截图里开关是打开的。后面的控制台会多出一条远程地址，内网播放可以忽略它。

![Emby 配置远程访问：Enable automatic port mapping 开关打开，Previous 与 Next](https://imgs.xuanyuan.cloud/docker/blog/emby-7.webp)

### 4.5 接受条款

向导进入 Terms of Use 之后：

1. 打开 **I accept the terms of use**。
2. 点击 **Next**。

Privacy policy 和 Terms of Use 是条款链接，要阅读时再点。同意与否看的是这个开关。

![Emby 使用条款：Privacy policy 与 Terms of Use 链接，同意开关已打开](https://imgs.xuanyuan.cloud/docker/blog/emby-8.webp)

### 4.6 完成向导

向导最后一页是 You're Done!。Emby 会开始扫描媒体库。点击 **Finish**。

![Emby 向导结束：You're Done，各平台客户端图标，绿色 Finish](https://imgs.xuanyuan.cloud/docker/blog/emby-9.webp)

### 4.7 登录

登录页标题是 Sign in to 加上服务器友好名称。本次名称是容器主机名 `6563982f8d43`。

1. 点用户名，或点 **Manual Login**。
2. 输入向导里设置的密码。
3. 点击 **Sign In**。

![Emby 登录页：Sign in to 6563982f8d43，用户 root、Manual Login、Forgot Password](https://imgs.xuanyuan.cloud/docker/blog/emby-10.webp)

![Emby 手动登录：用户名 root，密码已填写，Sign In 与 Cancel](https://imgs.xuanyuan.cloud/docker/blog/emby-11.webp)

---

## 五、主界面与服务器设置

### 5.1 主页

登录后左侧是 My Media，其中有刚才建的 **Movies**。目录里还没有视频时，这里只有场记板图标，没有海报。

![Emby 主页：左侧 Home 与 Movies，My Media 下是空的 Movies 图标，右上角 Get Emby Premiere](https://imgs.xuanyuan.cloud/docker/blog/emby-12.webp)

### 5.2 控制台

右上角齿轮进入设置，再打开 **Dashboard**。本次页面显示版本 **4.10.1.0**，Running on http port **8096**。活动日志里有用户验证、用户策略和密码更改。

「家庭（局域网）访问」给出的是容器网桥地址。本次是 `http://172.21.0.2:8096`，同一局域网里的电脑打不开。浏览器和电视客户端用宿主机地址 `http://<服务器IP>:8096`。

「远程（广域网）访问」是 Emby 探测到的公网地址。只在内网播放时，不要按这一行去映射路由器端口。

顶部的 Please restart the server to finish applying updates，来自插件更新。本次警告是 TheAudioDb 与 Emby Guide Data 更新到 1.0.22.0。要重启时，点服务器名称右侧的电源图标。

![Emby 控制台英文界面：版本 4.10.1.0，HTTP 端口 8096，活动日志含用户验证与密码更改](https://imgs.xuanyuan.cloud/docker/blog/emby-13.webp)

### 5.3 把界面改成中文

1. 打开 **Emby Web Settings** 里的 **General**。
2. Display language 选择 **Chinese (China)**。

保存后刷新页面。左侧会变成「首页」「我的媒体」。

![Emby 通用设置：Display language 展开，选中 Chinese (China)](https://imgs.xuanyuan.cloud/docker/blog/emby-14.webp)

中文界面下打开 Movies。本次目录是空的，页面写着「共 0 项」「未找到项目」。视频放进宿主机媒体目录后，在这个库的菜单里扫描一次。

![Emby 中文影片库：Movies，共 0 项，未找到项目，标签有影片、预告片、收藏、文件夹](https://imgs.xuanyuan.cloud/docker/blog/emby-15.webp)

显示选项在左侧以用户名命名的「偏好设置」里。本次用户是 `root`，所以菜单是「root 偏好设置」。里面的「显示」本次为：主题 **Dark**，网页主题 **Light**，强调色 **Emby**。

![Emby 显示设置：主题 Dark，网页主题 Light，强调色 Emby，首选电视节目显示](https://imgs.xuanyuan.cloud/docker/blog/emby-16.webp)

改成中文后，控制台仍是版本 **4.10.1.0**，运行于 HTTP 端口 **8096**。家庭局域网那一行仍是刚才的容器网桥地址。顶部中文提示是「请重新启动服务器以便更新生效」。

![Emby 中文控制台：版本 4.10.1.0，运行于 HTTP 端口 8096，顶部提示请重新启动服务器](https://imgs.xuanyuan.cloud/docker/blog/emby-17.webp)

### 5.4 插件与设置菜单

「高级」里的「插件」列出已经复制到 `/config/plugins` 的项目，包括刮削、字幕、DLNA 和备份。版本号以页面上的为准。

![Emby 插件页：我的插件，含 DLNA、Emby Guide Data、MusicBrainz、Nfo Metadata、Open Subtitles、TheAudioDb](https://imgs.xuanyuan.cloud/docker/blog/emby-18.webp)

设置首页分成 Emby Web 设置、用户偏好设置、Emby Server 三块，右侧都标着 **4.10.1.0**。直播源加在 Emby Server 的「电视直播」里。添加之后，在界面里手动刷新一次节目指南。

电视和手机安装 [Emby 客户端](https://emby.media/download.html) 后，服务器地址填 `http://<服务器IP>:8096`，用向导里创建的用户登录。播放进度按这个用户保存。

![Emby 设置首页：Emby Web 设置、用户偏好设置、Emby Server 三组菜单，版本 4.10.1.0](https://imgs.xuanyuan.cloud/docker/blog/emby-19.webp)

---

## 六、扩展脚本（可选）

不改这个文件也可以建库和播放。容器第一次成功启动后，启动脚本会在下面的路径放一份默认脚本。要改美化、弹幕或外部播放器时再编辑；删掉该文件再重启，容器会重新生成一份。

```text
/www/wwwroot/embyserver/config/config/ext.sh
```

对应容器内 `/config/config/ext.sh`。

美化要填写媒体库 ID 才启用。打开已经扫过的媒体库，从浏览器地址栏复制 `parentId`。多个 ID 用英文逗号分隔。`MediaId` 留空则不启用美化。库还是空的时候，地址栏里没有 `parentId`。

`extmod` 里这三项可以按需删掉：

| 值 | 作用 |
|----|------|
| `embyLaunchPotplayer` | 调用外部播放器 |
| `ede.user` | 弹幕 |
| `actorPlus` | 隐藏未知演员 |

1. 从媒体库页面的地址栏抄下 `parentId`。
2. 编辑 `ext.sh`，把 `MediaId` 换成库 ID，并按需要调整 `extmod`。文件里和插件相关的部分如下。

```sh
#!/bin/sh

echo "Emby扩展启动脚本"

# MediaId 留空则不启用美化。多个 ID 用英文逗号分隔。
MediaId=""

# embyLaunchPotplayer 外部播放；ede.user 弹幕；actorPlus 隐藏未知演员
extmod='["embyLaunchPotplayer","ede.user","actorPlus"]'

sed -i '/ extmod/s/[.*]/'$extmod'/g' /system/dashboard-ui/ext.js

exit 0
```

3. 重启容器。

```bash
cd /www/wwwroot/embyserver
docker compose restart
```

4. 在浏览器按 `Ctrl+F5` 强制刷新网页。

---

## 七、硬件转码（可选）

先能在浏览器里直接播放，再考虑转码。软解只占用 CPU，不必挂设备。

Emby 的硬件转码属于 Premiere 功能，需要你自己的有效授权。在服务器设置的 Premiere 页面填入你的授权后再配转码。

核显或支持 VAAPI 的显卡，把渲染节点送进容器。第三节已经打开 `privileged: true`，进程以 root 运行，不必再写 `UID`、`GID`。

先确认设备节点存在：

```bash
ls -l /dev/dri
```

`/dev/dri` 不存在时，不要加设备行。在第三节的 Compose 上保留 `privileged: true`，只增加 `devices`。

```bash
cd /www/wwwroot/embyserver
cat > compose.yaml <<'EOF'
services:
  emby:
    image: docker.xuanyuan.run/amilys/embyserver:4.10.1.0-amd64
    container_name: embyserver
    restart: unless-stopped
    privileged: true
    ports:
      - "8096:8096"
      - "8920:8920"
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - /www/wwwroot/embyserver/config:/config
      - /www/wwwroot/embyserver/media:/media
    devices:
      - /dev/dri:/dev/dri
EOF
```

然后重新创建容器：

```bash
cd /www/wwwroot/embyserver
docker compose up -d
```

1. 打开 Emby 设置里的转码。
2. 在硬件加速里选择与这块显卡匹配的方式。
3. 保存。

首选解码器列表里出现这块显卡，说明设备已经进容器。列表仍是空的，先确认 `/dev/dri` 已写进 Compose，并且容器是用 `privileged: true` 重新创建的。NVIDIA 显卡还要在宿主机安装 NVIDIA Container Toolkit，做法见官方 [emby/embyserver](https://hub.docker.com/r/emby/embyserver) 说明里的 NVDEC / NVENC 一节，不要只挂 `/dev/dri`。

---

## 八、备选：docker run

没有 Compose 时用这一节。参数与第三节相同。已有同名容器时先停掉再删，避免端口占用。`config/config` 目录仍要先建好。

```bash
sudo mkdir -p /www/wwwroot/embyserver/config/config /www/wwwroot/embyserver/media
docker rm -f embyserver

docker run -d 
  --name embyserver 
  --restart unless-stopped 
  --privileged 
  -p 8096:8096 
  -p 8920:8920 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/embyserver/config:/config 
  -v /www/wwwroot/embyserver/media:/media 
  docker.xuanyuan.run/amilys/embyserver:4.10.1.0-amd64
```

需要核显时再追加 `--device /dev/dri:/dev/dri`。

查看状态：

```bash
docker ps --filter name=embyserver
docker logs --tail 80 embyserver
```

浏览器同样打开 `http://<服务器IP>:8096`。

---

## 九、升级

升级只改镜像标签，保留配置目录和片库目录。

1. 在[标签列表](https://xuanyuan.cloud/r/amilys/embyserver/tags)选定新的具体版本标签。
2. 修改 `compose.yaml` 里的 `image`。
3. 拉取并重新创建容器。

```bash
cd /www/wwwroot/embyserver
docker compose pull
docker compose up -d
```

不要删除 `/www/wwwroot/embyserver/config`。用户、媒体库和播放进度都在这里。片库目录也不要随升级挪走，除非你同时改 Compose 里的卷。

`docker run` 部署的，先用新标签 `docker pull`，再 `docker rm -f embyserver`，然后用第八节的命令换上新标签重新运行。两个 `-v` 路径保持不变。

网页仍是旧样式时，按 `Ctrl+F5` 强制刷新。改过 `ext.sh` 的，升级后看脚本是否被新版本覆盖，需要的话把 `MediaId` 和 `extmod` 再写回去。

---

## 十、常见问题

### 10.1 库是空的，或向导里看不到视频

页面写「未找到项目」「共 0 项」，且文件夹是 `/media` 时，多半是宿主机目录里还没有视频。把文件放进卷的左侧目录，再在这个库的菜单里扫描。

文件夹若填了 `/www/wwwroot/embyserver/media` 这类宿主机路径，容器里没有这个目录，扫描结果也是空的。改成 `/media`，确认 Compose 是「宿主机真实目录 → `/media`」，执行 `docker compose up -d` 后再扫描。

### 10.2 浏览器提示 8096 拒绝连接

`docker compose ps` 显示 `Up`，只说明容器进程还在。Emby 自己退出时，Docker 会按 `restart: unless-stopped` 立刻再拉起，端口上没有服务，浏览器就是 `ERR_CONNECTION_REFUSED`。

Ubuntu 24.04 上用 `UID=1000`、且没有 `/config/config` 目录时，日志是：

```text
cp: can't create '/config/config/ext.sh': No such file or directory
./run: line 9: /config/config/ext.sh: not found
Info Main: Application path: /system/EmbyServer.dll
Info Main: Shutdown complete
```

随后每隔一两秒重复 `Emby扩展启动脚本` 和 `Shutdown complete`。端口上没有服务在听，所以浏览器是 `ERR_CONNECTION_REFUSED`。

1. 执行 `docker compose down`。
2. 建好 `/www/wwwroot/embyserver/config/config`。
3. 按第三节重写 `compose.yaml`：加上 `privileged: true`，去掉 `UID`、`GID`。
4. 执行 `docker compose up -d`，再看日志。

日志里出现 `Emby Server 4.10.1.0`，并且不再循环 `Shutdown complete` 之后，再打开 `http://<服务器IP>:8096`。

### 10.3 和官方镜像、Jellyfin 怎么区分

| | amilys/embyserver（本文） | emby/embyserver | Jellyfin |
|--|---------------------------|-----------------|----------|
| 维护者 | amilys | Emby 官方 | Jellyfin 项目 |
| 配置目录 | `/config` | `/config` | `/config` |
| HTTP 端口 | **8096** | **8096** | **8096** |
| 运行用户 | 特权模式，不设置 `UID` / `GID` | `UID` / `GID` / `GIDLIST` | 各构建不同 |
| 额外脚本 | 启动时执行 `ext.sh`，可开关美化、弹幕、外部播放器 | 官方镜像不含这份脚本 | 另一套服务器，插件体系不同 |

已经在用官方 `emby/embyserver` 时，不要把两套容器指向同一个配置目录。本文的 `ext.sh` 只属于这个社区镜像。Jellyfin 的库和用户也不能直接当成 Emby 的 `/config` 来挂。

### 10.4 群晖说明里的高权限

维护者在镜像说明里写的是群晖路径：勾选 Privileged，把 `/docker/emby` 映射到 `/config`，并且不改环境变量。Linux 主路径同样使用 `privileged: true`，不设置 `UID`、`GID`。配置目录换成 `/www/wwwroot/embyserver/config`，并多建一层 `config/config`。

### 10.5 电视发现不了服务器

局域网发现使用 UDP **7359**，DLNA 使用 UDP **1900**。桥接网络下只映射了 TCP **8096** 时，客户端仍可以用手动地址 `http://<服务器IP>:8096` 连接。

要做 DLNA 或局域网自动发现时，官方 Emby 容器使用主机网络。先停掉容器。在 `compose.yaml` 的 `emby` 服务里删掉整段 `ports`，加上 `network_mode: host`，再执行 `docker compose up -d`。主机网络和 `ports` 不能同时写。

使用主机网络后，服务直接占用宿主机的 **8096** 和 **8920**。这两个端口已被占用时，先停掉占用进程，或继续用桥接，在客户端里手动填写 `http://<服务器IP>:8096`。

### 10.6 硬件转码没有解码器

先确认两件事：`/dev/dri` 已挂进容器，并且这个 Emby 用户具有有效的 Premiere 授权。设置页的硬件解码器列表是空的时，先看 `docker compose ps` 里的容器是不是用带 `devices` 的 Compose 重新创建的。

NVIDIA 不要只挂 `/dev/dri`。宿主机需要 NVIDIA Container Toolkit，并按官方镜像说明配置 runtime。

### 10.7 8096 已经被占用

改 Compose 里冒号左边的端口，例如 `"18096:8096"`。容器内仍然是 **8096**。浏览器和客户端地址改成 `http://<服务器IP>:18096`。改完执行 `docker compose up -d`。

---

## 十一、命令速查

```bash
# 拉取（ARM 改为 4.10.1.0-arm64）
docker pull docker.xuanyuan.run/amilys/embyserver:4.10.1.0-amd64

# 目录（ext.sh 的父目录必须先在）
sudo mkdir -p /www/wwwroot/embyserver/config/config /www/wwwroot/embyserver/media

# Compose
cd /www/wwwroot/embyserver
docker compose up -d
docker compose ps
docker compose logs --tail 80
docker compose restart
docker compose down

# 备选 docker run
docker run -d 
  --name embyserver 
  --restart unless-stopped 
  --privileged 
  -p 8096:8096 
  -p 8920:8920 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/embyserver/config:/config 
  -v /www/wwwroot/embyserver/media:/media 
  docker.xuanyuan.run/amilys/embyserver:4.10.1.0-amd64
```

浏览器访问 `http://<服务器IP>:8096`。媒体库文件夹填 `/media`。

---

## 十二、延伸阅读

| 资源 | 链接 |
|------|------|
| [amilys/embyserver 镜像页](https://xuanyuan.cloud/zh/r/amilys/embyserver) | [https://xuanyuan.cloud/zh/r/amilys/embyserver](https://xuanyuan.cloud/zh/r/amilys/embyserver) |
| [amilys/embyserver 概览](https://xuanyuan.cloud/r/amilys/embyserver) | [https://xuanyuan.cloud/r/amilys/embyserver](https://xuanyuan.cloud/r/amilys/embyserver) |
| [amilys/embyserver 标签列表](https://xuanyuan.cloud/r/amilys/embyserver/tags) | [https://xuanyuan.cloud/r/amilys/embyserver/tags](https://xuanyuan.cloud/r/amilys/embyserver/tags) |
| [Docker Hub · amilys/embyserver](https://hub.docker.com/r/amilys/embyserver) | [https://hub.docker.com/r/amilys/embyserver](https://hub.docker.com/r/amilys/embyserver) |
| [Docker Hub · emby/embyserver](https://hub.docker.com/r/emby/embyserver) | [https://hub.docker.com/r/emby/embyserver](https://hub.docker.com/r/emby/embyserver) |
| [Emby 官网](https://emby.media/) | [https://emby.media/](https://emby.media/) |
| [Emby 客户端下载](https://emby.media/download.html) | [https://emby.media/download.html](https://emby.media/download.html) |
| [GitHub · Nolovenodie/emby-crx](https://github.com/Nolovenodie/emby-crx) | [https://github.com/Nolovenodie/emby-crx](https://github.com/Nolovenodie/emby-crx) |
| [GitHub · RyoLee/dd-danmaku](https://github.com/RyoLee/dd-danmaku) | [https://github.com/RyoLee/dd-danmaku](https://github.com/RyoLee/dd-danmaku) |
| [GitHub · bpking1/embyExternalUrl](https://github.com/bpking1/embyExternalUrl) | [https://github.com/bpking1/embyExternalUrl](https://github.com/bpking1/embyExternalUrl) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/embyserver-docker-deploy

