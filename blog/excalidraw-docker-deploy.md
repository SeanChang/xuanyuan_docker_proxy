# Docker 部署 Excalidraw：轻松搭建手绘风格白板

![Docker 部署 Excalidraw：轻松搭建手绘风格白板](https://imgs.xuanyuan.cloud/docker/blog/excalidraw/excalidraw.webp)

*分类: Docker部署教程 | 标签: Excalidraw,excalidraw/excalidraw,Docker,轩辕镜像,白板,私有化部署,部署教程 | 发布时间: 2026-10-20 14:43:14*

> Excalidraw 是一款开源的手绘风格虚拟白板，旨在把流程图、架构草图和线框放在同一块画布上，并通过浏览器本地保存与文件导出整理这些图。本文将介绍如何通过 Docker Compose 快速部署 Excalidraw，搭建手绘风格白板，帮助你在自己的服务器上绘制并保存草图，适合内网讨论、课堂演示及个人草稿等场景。

*本文基于 [excalidraw/excalidraw:latest](https://xuanyuan.cloud/zh/r/excalidraw/excalidraw)，镜像对应 2026-05-06 的发布，编辑器组件 **@excalidraw/excalidraw 0.18.0**，Nginx **1.27.5**，测试平台 **Ubuntu 24.04** Linux。*

## Excalidraw 是什么

Excalidraw 是开源的手绘风格虚拟白板。镜像 `excalidraw/excalidraw` 是它的网页客户端，由 Nginx 提供已经构建好的页面，用来在自己的地址上画流程图、架构草图和线框。

与打开 excalidraw.com 相比，这份镜像把编辑器页面放在你自己的服务器上。画布写在浏览器里，要留存就从菜单导出。页面上能看到「实时协作...」和「分享」。镜像说明写明，当前自托管还不提供你自己的协作后端。

## Excalidraw 能做什么

- **在无限画布上绘图**：用矩形、菱形、椭圆、箭头、线条、自由书写和文字画手绘风格的图。
- **把当前画布留在浏览器里**：页面把场景写在本机浏览器中。欢迎页同时提醒，这份存储可能被清掉。
- **导出图片和源文件**：可以导出 PNG、SVG，也可以保存成以后还能导入的 `.excalidraw` 文件。
- **切换语言和主题**：语言列表里有简体中文，也可以在浅色和深色之间切换。
- **使用素材和图片**：可以从素材库加入图形，也可以把图片放到画布上。

## 为什么要使用 Excalidraw

流程图和架构草图如果只画在别人的网站上，换一台电脑或清掉浏览器数据，就不容易找回。把密钥、内网地址写进公网页面，也不好控制谁能打开。

Excalidraw 的这个镜像把编辑器页面放到自己的服务器上。日常作画留在这台浏览器里，需要带走时从菜单导出。它适合内网讨论、课堂演示，以及想随手留下架构图草稿的人。

## 使用 Docker 部署 Excalidraw

Excalidraw 可以用 Docker 把网页客户端跑起来。开始之前准备好 Docker。这个客户端不需要单独的数据库。

接下来用 Docker Compose 写好端口，完成启动，再在浏览器里打开画布。

## 环境要求

本文命令使用 `excalidraw/excalidraw:latest`，对应 2026-05-06 的发布。版本怎么对应，见「标签怎么选」。2026-10-20 的启动日志里是 **nginx/1.27.5**，容器内监听 80。页面在镜像里已经构建好，宿主机不需要安装 Node.js。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）。macOS 把 `/www/wwwroot/excalidraw` 换成 `~/docker/excalidraw`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64** 或 **linux/arm/v7** |
| 磁盘 | Docker Hub 上该标签的压缩大小约为 linux/amd64 **43.2 MB**、linux/arm64 **44.1 MB**、linux/arm/v7 **40.6 MB**。这次 Ubuntu 24.04 拉取后，`docker images` 显示 DISK USAGE **143 MB**、CONTENT SIZE **43.3 MB** |
| 端口 | 宿主机 **5000** → 容器 **80** |
| 工作目录 | `/www/wwwroot/excalidraw`。这个目录只放 Compose 文件 |
| 数据 | 无数据卷。场景在浏览器本地，导出的文件在你下载它们的那台电脑上 |
| 账号 | 没有登录，也没有默认密码 |

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

[发布工作流](https://github.com/excalidraw/excalidraw/blob/b2b2815954f6/.github/workflows/publish-docker.yml) 在 `release` 分支推送时构建镜像，标签只写 `excalidraw/excalidraw:latest`，平台是 linux/amd64、linux/arm64、linux/arm/v7。仓库没有 `0.18.0` 这类版本号标签。

最近一次成功发布是 2026-05-06，提交为 [b2b2815954f6](https://github.com/excalidraw/excalidraw/commit/b2b2815954f6)，说明是 `fix(editor): prevent duplicate lasso toolbar item (#11286)`。该提交里的编辑器组件版本是 `@excalidraw/excalidraw` **0.18.0**。2026-10-19 核对 Docker Hub 标签接口时，`latest` 的更新时间仍是 `2026-05-06T21:20:09Z`，清单 digest 为 `sha256:f7ee194addd607bf831d2af0f0a34463dd4225e426cf35199ef0b12a803398e9`。此后 release 分支上的发布工作流没有成功推送新镜像。

仓库里另有大量 `sha-` 前缀标签，最新的一条停在 2021-11。那些标签只有 linux/amd64，压缩大小大约 13 MB。不要把它们写进命令。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`latest`** | 官方发布流程推出的标签，当前指向 2026-05-06 那次构建 | **是**。没有可替代的版本号标签 |
| `sha-*` | 2021 年的提交前缀，仅 linux/amd64 | 否 |

`latest` 会在下一次成功发布时改指向。那次发布完成前，本文命令里的 `latest` 就是 2026-05-06 这版。升级时先看标签的更新时间，再执行「升级」里的拉取。

完整标签见 [excalidraw/excalidraw 标签列表](https://xuanyuan.cloud/r/excalidraw/excalidraw/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/excalidraw/excalidraw:latest
```

Ubuntu 24.04 实测：

```text
latest: Pulling from excalidraw/excalidraw
8a4eeabc2c25: Pull complete
61ca4f733c80: Pull complete
f18232174bc9: Pull complete
81bd8ed7ec67: Pull complete
b464cfdf2a63: Pull complete
d7e507024086: Pull complete
34a64644b756: Pull complete
197eb75867ef: Pull complete
39c2ddfd6010: Pull complete
aaab95e0c6c1: Download complete
Digest: sha256:f7ee194addd607bf831d2af0f0a34463dd4225e426cf35199ef0b12a803398e9
Status: Downloaded newer image for docker.xuanyuan.run/excalidraw/excalidraw:latest
docker.xuanyuan.run/excalidraw/excalidraw:latest
```

完成后确认本地有这个标签，再写下面的 Compose：

```bash
docker images docker.xuanyuan.run/excalidraw/excalidraw:latest
```

```text
IMAGE                                              ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/excalidraw/excalidraw:latest   f7ee194addd6        143MB         43.3MB
```

## Docker Compose 部署

工作目录是 `/www/wwwroot/excalidraw`，里面只放 `compose.yaml`。没有数据卷，画布不在这个目录里。宿主机 **5000** 映射到容器 **80**，与镜像说明里的 `-p 5000:80` 一致。5000 已被占用时，只改冒号左边，见「常见问题」。

### 创建目录

```bash
mkdir -p /www/wwwroot/excalidraw
chown -R "$USER:$USER" /www/wwwroot/excalidraw
cd /www/wwwroot/excalidraw

# macOS：mkdir -p ~/docker/excalidraw && cd ~/docker/excalidraw
```

当前用户不是 root 时，给 `mkdir` 和 `chown` 加上 `sudo`。

### 编写 compose.yaml

```bash
cd /www/wwwroot/excalidraw
cat > compose.yaml <<'EOF'
services:
  excalidraw:
    image: docker.xuanyuan.run/excalidraw/excalidraw:latest
    container_name: excalidraw
    restart: unless-stopped
    ports:
      - "5000:80"
EOF
```

| 项 | 说明 |
|----|------|
| `"5000:80"` | 宿主机 **5000** → 容器 **80** |
| 无 `volumes` | 页面是静态文件。画布在浏览器本地 |
| `restart: unless-stopped` | 容器退出后由 Docker 拉起，直到你主动停止 |

### 启动并验证

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 50
curl -sS -o /dev/null -w "%{http_code}
" http://127.0.0.1:5000/
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network excalidraw_default  Created  0.3s
 ✔ Container excalidraw        Started  2.4s
```

```text
NAME         IMAGE                                              COMMAND                  SERVICE      CREATED         STATUS                            PORTS
excalidraw   docker.xuanyuan.run/excalidraw/excalidraw:latest   "/docker-entrypoint.…"   excalidraw   4 seconds ago   Up 2 seconds (health: starting)   0.0.0.0:5000->80/tcp, [::]:5000->80/tcp
```

日志关键行：

```text
excalidraw  | 10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
excalidraw  | /docker-entrypoint.sh: Configuration complete; ready for start up
excalidraw  | 2026/10/20 06:27:14 [notice] 1#1: nginx/1.27.5
excalidraw  | 2026/10/20 06:27:14 [notice] 1#1: start worker processes
```

```text
200
```

出现 `nginx/1.27.5` 和 `start worker processes` 后，curl 返回 `200`。`ps` 里的 `[::]:5000` 对应上面那行 IPv6 监听。这次执行 `docker compose ps` 时，健康检查还是 `starting`，页面已经可以打开。镜像自带的健康检查请求的是容器内 `http://localhost`。

浏览器访问 `http://服务器IP:5000`。把 IP 换成这台机器的地址。在服务器本机上可以用 `http://127.0.0.1:5000`。

## 浏览器里打开画布

浏览器语言是中文时，菜单会直接显示中文。若菜单是英文，先打开左上角菜单，把底部语言下拉框改成「简体中文」。这次打开时已经是「简体中文」。

1. 在浏览器打开 `http://服务器IP:5000`。欢迎页中央是 EXCALIDRAW。中间的英文是：Your drawings are saved in your browser's storage. Browser storage can be cleared unexpectedly. Save your work to a file regularly to avoid losing it. 左上角箭头写着「导出、首选项、语言……」，工具栏旁写着「选择工具并开始绘图！」。工具栏下方写着：滚动画面，按住 Ctrl（或 ⌘）并滚动来缩放，按住空格再拖动来平移。中间是「打开」「帮助」「实时协作...」和 Sign up。右上角是 Excalidraw+ 和「分享」。右下角写着「快捷键和帮助」。

![Excalidraw 首次打开：欢迎页中央为 EXCALIDRAW，英文提示画布保存在浏览器，左上角写着导出、首选项、语言](https://imgs.xuanyuan.cloud/docker/blog/excalidraw/excalidraw-1.webp)

2. 点击左上角菜单。上面有「打开」「保存到...」「导出图片...」和「实时协作...」。「导出图片...」旁是 Ctrl+Shift+E。底部「主题」选中浅色，语言下拉框是「简体中文」，下面是「画布背景」。「主题」上方仍显示 Preferences。同一列里还有 GitHub、Discord 群组和 Sign up。

![Excalidraw 主菜单：含保存到、导出图片和实时协作，语言下拉框为简体中文，主题为浅色](https://imgs.xuanyuan.cloud/docker/blog/excalidraw/excalidraw-2.webp)

3. 在工具栏依次选椭圆、菱形和矩形，在画布中央叠着画，再点中心的矩形。左侧出现「描边」「背景」「线条风格」，透明度是 100。选中后，工具栏下方写着按 Ctrl 添加文本，并用 Ctrl 加方向键移动。

![Excalidraw 画布：椭圆与菱形中间选中矩形，左侧为描边、背景、线条风格，透明度 100](https://imgs.xuanyuan.cloud/docker/blog/excalidraw/excalidraw-3.webp)

要带走这张图，用菜单里的「保存到...」或「导出图片...」。文件在你点保存的那台电脑上。「实时协作...」和右上角「分享」的说明见「常见问题」。

## 备选：docker run

没有 Compose 时，可以用 `docker run` 做一次持续运行。端口和镜像标签与上面的 Compose 相同。镜像说明里的示例带有 `--rm`，容器一停就会被删掉。下面这条命令不带 `--rm`，重启策略是 `unless-stopped`。

已经有名为 `excalidraw` 的容器时，先停掉 Compose 或删掉同名容器。这一步不删除浏览器里的画布。

```bash
docker rm -f excalidraw
docker run -d 
  --name excalidraw 
  --restart unless-stopped 
  -p 5000:80 
  docker.xuanyuan.run/excalidraw/excalidraw:latest
```

查看状态：

```bash
docker ps --filter name=excalidraw
curl -sS -o /dev/null -w "%{http_code}
" http://127.0.0.1:5000/
```

浏览器地址与「浏览器里打开画布」相同。

## 升级

`latest` 在下一次成功发布后会指向新构建。这个镜像没有服务器上的数据卷，升级前先把画布存下来。

1. 用菜单里的「保存到...」把当前画布存成文件。

2. 拉取并重建容器：

```bash
cd /www/wwwroot/excalidraw
docker compose pull
docker compose up -d
```

3. 再次确认 `docker compose ps` 里容器为 Up，curl 仍返回 `200`。浏览器强制刷新后再打开页面，并导入刚才保存的文件。

若 Hub 上的 `latest` 仍是 2026-05-06 那次构建，拉取会提示镜像已是最新。2026-05-06 之后的编辑器改动，要等官方再次成功发布这个标签。

## 常见问题

**Q1：为什么命令里写的是 `latest`？**

发布工作流只推送这一个标签。2026-10-20 拉到的 digest 仍是 2026-05-06 那次构建。对照见「标签怎么选」。下一次成功发布后它会改指向。

**Q2：`sha-` 开头的标签能不能用？**

不要用。那是 2021 年的提交前缀，只有 linux/amd64，压缩大小大约 13 MB。

**Q3：为什么宿主机端口是 5000，而不是 3000？**

容器内监听 80。镜像说明里的运行示例就是 `-p 5000:80`。仓库里的 `docker-compose.yml` 把宿主机 3000 映到容器 80，那份文件从源码构建，还挂了源码目录，并关闭了健康检查。本文按镜像说明使用宿主机 5000，避开本机前端常用的 3000。

**Q4：5000 已经被占用？**

只改映射的宿主机端口，例如 `15000:80`。容器内仍然是 80。访问地址改成新的宿主机端口。

**Q5：重建容器之后，画布没了？**

画布不在容器磁盘里。欢迎页写明它在浏览器存储中，存储可能被清掉。`docker compose down` 不会删除浏览器里的图，也不会删除你已经下载的文件。换浏览器、换设备，或清除这个地址的站点数据，页面上的图会消失。要留下的图，用菜单里的「保存到...」。

**Q6：能不能在自己的服务器上多人实时协作？**

镜像说明写明，当前自托管还不提供你自己的协作服务。页面上仍有「实时协作...」和「分享」。这次发布用的 `.env.production` 把协作地址写成 `https://oss-collab.excalidraw.com`，把分享接口写成 `https://json.excalidraw.com/api/v2/`。这些值在构建页面时写进去。这次测试没有点这两个按钮。Compose 里再加 `environment`，改不了已经写进静态文件的地址。画图和「保存到...」不依赖它们。

**Q7：素材库在这台服务器上吗？**

不在。构建配置把素材库地址写成 `https://libraries.excalidraw.com`。这次测试没有打开素材库。矩形、菱形和「保存到...」不依赖这个地址。

**Q8：这个页面要登录吗？**

不用登录。镜像没有默认账号，也没有默认密码。菜单和欢迎页上的 Sign up、Excalidraw+ 指向 excalidraw.com 的托管服务，不是这个容器里的账号。能访问宿主机 5000 的人都能打开画布。安全组或防火墙里只放行你自己的地址。别人打开同一地址，看不到留在你浏览器里的图。

**Q9：拉取报 `no matching manifest`？**

`latest` 提供 linux/amd64、linux/arm64、linux/arm/v7。32 位 x86 和 armv6 拉不到这个标签。

**Q10：升级后画面还是旧的？**

浏览器可能还留着上一次的页面脚本。强制刷新后再看。画布若和升级前不一致，用菜单里的「打开」载入升级前保存的文件。

## 命令速查

```bash
docker pull docker.xuanyuan.run/excalidraw/excalidraw:latest

cd /www/wwwroot/excalidraw
docker compose up -d
docker compose ps
docker compose logs --tail 50 excalidraw
curl -sS -o /dev/null -w "%{http_code}
" http://127.0.0.1:5000/

docker compose pull
docker compose up -d
docker compose restart excalidraw
docker compose stop
docker compose start
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://服务器IP:5000`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [excalidraw/excalidraw 镜像页](https://xuanyuan.cloud/zh/r/excalidraw/excalidraw) | [https://xuanyuan.cloud/zh/r/excalidraw/excalidraw](https://xuanyuan.cloud/zh/r/excalidraw/excalidraw) |
| [excalidraw/excalidraw 概览](https://xuanyuan.cloud/r/excalidraw/excalidraw) | [https://xuanyuan.cloud/r/excalidraw/excalidraw](https://xuanyuan.cloud/r/excalidraw/excalidraw) |
| [excalidraw/excalidraw 标签列表](https://xuanyuan.cloud/r/excalidraw/excalidraw/tags) | [https://xuanyuan.cloud/r/excalidraw/excalidraw/tags](https://xuanyuan.cloud/r/excalidraw/excalidraw/tags) |
| [Docker Hub · excalidraw/excalidraw](https://hub.docker.com/r/excalidraw/excalidraw) | [https://hub.docker.com/r/excalidraw/excalidraw](https://hub.docker.com/r/excalidraw/excalidraw) |
| [GitHub · excalidraw/excalidraw](https://github.com/excalidraw/excalidraw) | [https://github.com/excalidraw/excalidraw](https://github.com/excalidraw/excalidraw) |
| [发布提交 · b2b2815954f6](https://github.com/excalidraw/excalidraw/commit/b2b2815954f6) | [https://github.com/excalidraw/excalidraw/commit/b2b2815954f6](https://github.com/excalidraw/excalidraw/commit/b2b2815954f6) |
| [Excalidraw 文档](https://docs.excalidraw.com/) | [https://docs.excalidraw.com/](https://docs.excalidraw.com/) |
| [Excalidraw 官网](https://excalidraw.com/) | [https://excalidraw.com/](https://excalidraw.com/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/excalidraw-docker-deploy


