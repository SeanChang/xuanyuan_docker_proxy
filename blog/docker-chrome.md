# Docker 部署 Chrome：轻松搭建远程浏览器

![Docker 部署 Chrome：轻松搭建远程浏览器](https://imgs.xuanyuan.cloud/docker/blog/docker-linuxserver-chrome.png)

*分类: Docker部署教程 | 标签: Chrome,linuxserver/chrome,Docker,轩辕镜像,远程浏览器,私有化部署,部署教程 | 发布时间: 2026-06-16 03:02:27*

> linuxserver/chrome 由 LinuxServer.io 维护，面向只有命令行的服务器，旨在把 Google Chrome 放在容器里运行，并通过网页远程操作。本文将介绍如何通过 Docker Compose 快速部署 Chrome，搭建远程浏览器，帮助你在 SSH 环境里打开网页和登录内网后台，适合临时调试及隔离浏览等场景。

*本文基于 [linuxserver/chrome:149.0.7827.114-1-ls99](https://xuanyuan.cloud/r/linuxserver/chrome)，以 **149.0.7827.114-1-ls99** 版本实测，测试平台 **Ubuntu 24.04** Linux。*

## Chrome 是什么

linuxserver/chrome 是 LinuxServer.io 维护的容器镜像，里面运行 Google Chrome。画面通过网页推到你正在使用的浏览器，宿主机不必安装桌面。

和无头 Chrome 相比，这个镜像给出完整窗口，可以用鼠标点击、输入和翻页。桌面环境留在容器里，不装到宿主机上。

## Chrome 能做什么

- **远程打开网页**：在没有桌面的机器上使用 Chrome，用浏览器即可操作。
- **登录内网后台**：打开只在内网提供的管理页面。
- **隔离浏览**：网页在容器里打开，和宿主机分开。
- **固定测试环境**：使用具体版本的 Chrome 做页面调试。
- **保留浏览数据**：书签、设置和登录状态放在配置目录里。

## 为什么要使用 Chrome

云服务器、VPS 和家里的小主机常常只有 SSH。调试网页、登录内网管理后台，或在隔离环境里浏览，都需要一个图形浏览器。在宿主机上安装整套桌面会占内存，也增加维护成本。

把 Chrome 放进容器后，用网页就能操作，用完可以停掉。适合临时调试、隔离浏览，以及需要统一 Chrome 版本的测试。

## 使用 Docker 部署 Chrome

用 Docker 可以在不安装桌面的系统上把 Chrome 跑起来。开始之前准备好 Docker，并定好你要从哪台机器的浏览器访问它。

下面用 Docker Compose 写好参数，启动容器，然后在浏览器里登录并打开网页。

## 环境要求

本文使用 **149.0.7827.114-1-ls99** 版本实测，测试平台 **Ubuntu 24.04**。这个标签的镜像清单是 **linux/amd64**。官方变更记录写明 aarch64 自 2026-07-27 起提供，不在这个标签里。

官方没有给出最低内存。容器里是完整的 Chrome，打开网页后再留出余量。该标签的 amd64 镜像约 **1.13 GiB**。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（本文 **Ubuntu 24.04**）；macOS 把 `/www/wwwroot/chrome` 换成 `~/docker/chrome` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**。本文标签不提供 arm64 |
| 内存 | 能跑完整 Chrome 和要打开的网页 |
| 磁盘 | 镜像约 1.13 GiB，另加 `/config` 里的用户数据 |
| 端口 | 宿主机 **13000** → 容器 **3000**（HTTP）。宿主机 **13001** → 容器 **3001**（HTTPS，日常用这个） |
| 工作目录 | `/www/wwwroot/chrome` |
| 其他 | 生成基本认证密码需要 `openssl` |

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

## 标签怎么选

[GitHub Release 149.0.7827.114-1-ls99](https://github.com/linuxserver/docker-chrome/releases/tag/149.0.7827.114-1-ls99) 发布于 2026-06-11，对应 Chrome **149.0.7827.114-1**。下面的命令使用这个标签。

Ubuntu 24.04 实测拉取时，命令写的是 `latest`，Digest 为 `sha256:2a11c605af839426ef19ba3583d4612abbf9514cc7a66faf35387f59d1d76a6c`。这个 Digest 与 `149.0.7827.114-1-ls99` 一致。`latest` 之后还会指向更新的构建，不写入本文命令。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`149.0.7827.114-1-ls99`** | 本文实测。仅 amd64 | **是** |
| `version-149.0.7827.114-1` | 与上一行同一 Digest | 否 |
| `latest` | 浮动标签。实测截图里的拉取命令是它 | 否 |
| `155.0.8059.39-1-ls129` | 更新的标签。本文没有用它复测 | 否 |

完整标签见[标签列表](https://xuanyuan.cloud/r/linuxserver/chrome/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/linuxserver/chrome:149.0.7827.114-1-ls99
```

拉取完成后再写 Compose。

Ubuntu 24.04 实测（当时命令写的是 `latest`，Digest 与上面的标签相同）：

```text
Digest: sha256:2a11c605af839426ef19ba3583d4612abbf9514cc7a66faf35387f59d1d76a6c
Status: Downloaded newer image for docker.xuanyuan.run/linuxserver/chrome:latest
```

![Ubuntu 24.04 终端拉取 linuxserver/chrome，各层下载完成并打印 Digest](https://img.xuanyuan.dev/docker/blog/docker-linuxserver-chrome-4.png)

截图里的命令是当时的 `latest`。请改用本节上面的具体标签。

## Docker Compose 部署

配置、书签和登录状态保存在宿主机目录 `/www/wwwroot/chrome/config`，对应容器内 `/config`。删除容器不会删除这个目录。删掉 `config/` 会丢掉浏览数据。

基本认证密码写在 `basic_auth_password.txt` 和 `compose.yaml` 里。用户名是 `admin`。镜像默认不启用认证，本文设置 `CUSTOM_USER` 和 `PASSWORD` 后才会出现登录框。

容器内 HTTP 端口是 **3000**，HTTPS 端口是 **3001**。宿主机不占用 **3000**，改映到 **13000** 和 **13001**。日常在浏览器里打开 HTTPS 的 **13001**。`3000` 只适合放到反向代理后面。

`shm_size` 设为 **1gb**。官方说明现代网站需要这块共享内存。

已经有 `compose.yaml` 时，不要重新执行下面写入文件的那一步，否则基本认证密码会换成新值。`config/` 里已有数据时也不要删除。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/chrome/config
sudo chown -R "$(id -u)":"$(id -g)" /www/wwwroot/chrome
```

2. 生成密码并写入 `compose.yaml`。`umask 077` 让密码文件和 Compose 只有当前用户可读；写完后把 umask 调回 `022`。`PUID` 和 `PGID` 取自 `id`，与目录属主一致。

```bash
cd /www/wwwroot/chrome
PUID="$(id -u)"
PGID="$(id -g)"
PASSWORD="$(openssl rand -hex 16)"
umask 077
printf '%s
' "$PASSWORD" > basic_auth_password.txt
cat > compose.yaml <<EOF
name: chrome

services:
  chrome:
    image: docker.xuanyuan.run/linuxserver/chrome:149.0.7827.114-1-ls99
    container_name: chrome
    restart: unless-stopped
    environment:
      PUID: "${PUID}"
      PGID: "${PGID}"
      TZ: Asia/Shanghai
      LC_ALL: zh_CN.UTF-8
      CUSTOM_USER: admin
      PASSWORD: "${PASSWORD}"
    ports:
      - "13000:3000"
      - "13001:3001"
    volumes:
      - /www/wwwroot/chrome/config:/config
    shm_size: "1gb"
EOF
umask 022
```

3. 启动容器：

```bash
cd /www/wwwroot/chrome
docker compose up -d
```

4. 查看状态。确认 `chrome` 为 Up 后，再打开浏览器：

```bash
cd /www/wwwroot/chrome
docker compose ps
docker compose logs --tail 50 chrome
```

| 参数 | 作用 |
|------|------|
| `13000:3000` | 宿主机 HTTP。给反向代理用，不作为日常入口 |
| `13001:3001` | 宿主机 HTTPS。浏览器打开这个端口 |
| `/www/wwwroot/chrome/config:/config` | 持久化配置、书签和登录状态 |
| `shm_size: "1gb"` | 共享内存。官方要求，供现代网页使用 |
| `PUID` / `PGID` | 与目录属主一致，避免写不进 `/config` |
| `TZ` | 时区。本文为 `Asia/Shanghai` |
| `LC_ALL` | 界面语言。`zh_CN.UTF-8` 为中文 |
| `CUSTOM_USER` / `PASSWORD` | HTTP 基本认证。用户名 `admin`，密码在 `basic_auth_password.txt` |

要从外网打开，在云服务器安全组放行 **13001/tcp**。本机若使用 ufw，再执行：

```bash
sudo ufw allow 13001/tcp
```

## 浏览器访问

容器为 Up 之后，在你自己的浏览器打开：

```text
https://服务器IP:13001/
```

把「服务器 IP」换成这台机器的地址。用的是 HTTPS。镜像默认是自签名证书，浏览器会提示连接不安全，继续访问即可。

1. 打开上面的地址，并继续访问自签名证书。

2. 在「登录」框填写用户名和密码。用户名是 `admin`。密码用下面的命令查看，不要把密码贴到聊天或工单里：

```bash
cat /www/wwwroot/chrome/basic_auth_password.txt
```

![浏览器访问远程 Chrome 时弹出的「登录」框，需填写用户名和密码](https://img.xuanyuan.dev/docker/blog/docker-linuxserver-chrome-1.png)

3. 登录后进入 Chrome。本文这次看到的是中文「新标签页」。

![登录后的 Chrome「新标签页」，搜索框为中文](https://img.xuanyuan.dev/docker/blog/docker-linuxserver-chrome-2.png)

## 打开网页

登录后可以像本机 Chrome 一样输入地址或搜索。下面是在这个远程 Chrome 里打开必应、搜索「轩辕镜像」的结果。

![在远程 Chrome 中用必应搜索「轩辕镜像」后的结果页](https://img.xuanyuan.dev/docker/blog/docker-linuxserver-chrome-3.png)

可选：让 Chrome 启动时打开指定地址。官方把这一串完整传给 Chrome。不需要指定时，保持 Compose 里不写 `CHROME_CLI`。

要改的话，在 `environment` 里增加一行，把网址换成你的地址，然后重新创建容器：

```yaml
CHROME_CLI: https://www.linuxserver.io/
```

```bash
cd /www/wwwroot/chrome
docker compose up -d
```

## 安全说明

官方写明：这个容器的网页里带有终端，并且可以无密码使用 sudo。能打开界面的人，可以在容器内获得 root。不要把没有认证的端口暴露到公网，也不要交给不可信的人。

1. 本文已经设置 `CUSTOM_USER` 和 `PASSWORD`。没有这两项时，官方默认不启用认证。
2. 基本认证只适合可信网络。公网访问时，把服务放到 Nginx、Caddy 等反向代理后面，并另加认证。反向代理的写法见 [Selkies 反向代理说明](https://docs.linuxserver.io/selkies/user-guide/reverse-proxy/)。
3. 日常使用 HTTPS 端口 **13001**。官方写明音视频相关的 WebCodecs 只在安全上下文里可用。容器 **3001** 直接提供 HTTPS；容器 **3000** 只给反向代理。
4. 反向代理如果校验上游证书，需要放过这张自签名证书。
5. 不要加 `--privileged`，也不要挂载 `/var/run/docker.sock`，除非你明确要在容器里控制 Docker。

更多说明见 [Selkies 安全说明](https://docs.linuxserver.io/selkies/user-guide/security/)。

GPU 可以不挂。官方写明 CPU 编码在普通机器上就够用。本文没有加显卡设备。

## 备选：docker run

没有 Docker Compose 时用这一节。不要和已经用 Compose 启动的同名容器一起跑。

若「Docker Compose 部署」里已经写好目录和 `basic_auth_password.txt`，直接执行 `docker run`。还没有密码文件时，先做下面两步。

1. 创建目录并生成密码：

```bash
sudo mkdir -p /www/wwwroot/chrome/config
sudo chown -R "$(id -u)":"$(id -g)" /www/wwwroot/chrome
cd /www/wwwroot/chrome
umask 077
openssl rand -hex 16 > basic_auth_password.txt
umask 022
```

2. 启动容器。密码从文件读入，避免写进 shell 历史：

```bash
cd /www/wwwroot/chrome
docker run -d 
  --name=chrome 
  -e PUID="$(id -u)" 
  -e PGID="$(id -g)" 
  -e TZ=Asia/Shanghai 
  -e LC_ALL=zh_CN.UTF-8 
  -e CUSTOM_USER=admin 
  -e PASSWORD="$(cat /www/wwwroot/chrome/basic_auth_password.txt)" 
  -p 13000:3000 
  -p 13001:3001 
  -v /www/wwwroot/chrome/config:/config 
  --shm-size=1gb 
  --restart unless-stopped 
  docker.xuanyuan.run/linuxserver/chrome:149.0.7827.114-1-ls99
```

然后同样打开 `https://服务器IP:13001/`。

## 常见问题

**Q1：启动时报 3000 端口已被占用怎么办？**

把宿主机端口直接写成 `3000:3000` 时，可能看到：

```text
docker: Error response from daemon: failed to set up container networking:
driver failed programming external connectivity on endpoint chrome (...):
failed to bind host port 0.0.0.0:3000/tcp: address already in use
```

这表示宿主机的 **3000** 端口已经有程序在听，端口没有绑上。常见占用者是本机的前端或别的 Web 服务，具体是哪一个要看监听进程。

本文命令使用宿主机 **13000** 和 **13001**，不占用 **3000**。若这两个端口也被占用，只改冒号左边，容器内仍是 **3000** 和 **3001**。先看谁在听：

```bash
sudo ss -tlnp | grep -E ':13000|:13001'
```

例如改成 **18000** 和 **18001** 时，Compose 里写成 `"18000:3000"` 和 `"18001:3001"`，浏览器改为 `https://服务器IP:18001/`，再执行 `docker compose up -d`。

**Q2：页面卡住或标签页崩溃怎么办？**

先确认 Compose 里有 `shm_size: "1gb"`。官方说明现代网站依赖这块共享内存。改完后执行 `docker compose up -d`。

**Q3：用户名和密码是什么？**

用户名是 `admin`。密码在 `/www/wwwroot/chrome/basic_auth_password.txt`。镜像没有预置密码；未设置 `PASSWORD` 时，官方默认不启用认证。

**Q4：浏览器提示连接不安全怎么办？**

镜像使用自签名证书。确认地址是 `https://服务器IP:13001/` 后，选择继续访问。这不是把 HTTP 端口当成 HTTPS 来开。

**Q5：配置目录没有写权限怎么办？**

目录属主要和容器里的 `PUID`、`PGID` 一致。先看 Compose 里这两项，再改属主。下面按当前用户的 id 修正；若 Compose 里写的是别的数字，把属主改成那一组数字。

```bash
sudo chown -R "$(id -u)":"$(id -g)" /www/wwwroot/chrome/config
cd /www/wwwroot/chrome
docker compose up -d
```

**Q6：如何升级？**

先保留 `config/` 和 `basic_auth_password.txt`。本文命令使用 `149.0.7827.114-1-ls99`。要换更新的具体版本时，把 `compose.yaml` 里的标签改成那个版本，然后执行：

```bash
cd /www/wwwroot/chrome
docker compose pull
docker compose up -d
```

不要把标签改成 `latest`。配置目录保持不动。

**Q7：容器是 Up，浏览器却打不开？**

按这个顺序看：

1. `docker compose ps` 里 `chrome` 是否为 Up。
2. `docker compose logs --tail 50 chrome` 里是否还在报端口或权限错误。
3. 浏览器地址是否为 `https://服务器IP:13001/`。日志或文档里的 **3001** 是容器端口，日常入口是宿主机 **13001**。
4. 本机能开、外网不能开时，再检查云安全组和防火墙是否放行了 **13001/tcp**。

**Q8：如何停止与卸载？**

确认不再需要浏览数据之前，不要删除 `config/`。

Compose 停止并保留配置：

```bash
cd /www/wwwroot/chrome
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop chrome && docker rm chrome
```

站点不再需要时，再删除目录。密码文件里也有登录密码。

```bash
rm -rf /www/wwwroot/chrome
```

**Q9：可以在 arm64 上用这个标签吗？**

不可以。`149.0.7827.114-1-ls99` 的镜像清单是 linux/amd64。官方写明 aarch64 支持加在 2026-07-27 的变更里，请另选带 arm64 的更新标签，不要沿用本文标签。

**Q10：和 Docker Hub 上的镜像是什么关系？**

本文使用的 `linuxserver/chrome:149.0.7827.114-1-ls99` 与 Docker Hub 上的同名标签是同一份镜像，通过轩辕镜像加速拉取。参数见 [linuxserver/chrome 文档](https://docs.linuxserver.io/images/docker-chrome/)。

## 命令速查

```bash
docker pull docker.xuanyuan.run/linuxserver/chrome:149.0.7827.114-1-ls99

cd /www/wwwroot/chrome
docker compose up -d
docker compose ps
docker compose logs --tail 50 chrome

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `https://服务器IP:13001/`，用户名 `admin`，密码在 `basic_auth_password.txt`。

```bash
docker ps
docker logs -f chrome
docker exec -it chrome /bin/bash
```

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [linuxserver/chrome 镜像页](https://xuanyuan.cloud/zh/r/linuxserver/chrome) | [https://xuanyuan.cloud/zh/r/linuxserver/chrome](https://xuanyuan.cloud/zh/r/linuxserver/chrome) |
| [linuxserver/chrome 概览](https://xuanyuan.cloud/r/linuxserver/chrome) | [https://xuanyuan.cloud/r/linuxserver/chrome](https://xuanyuan.cloud/r/linuxserver/chrome) |
| [linuxserver/chrome 标签列表](https://xuanyuan.cloud/r/linuxserver/chrome/tags) | [https://xuanyuan.cloud/r/linuxserver/chrome/tags](https://xuanyuan.cloud/r/linuxserver/chrome/tags) |
| [Docker Hub · linuxserver/chrome](https://hub.docker.com/r/linuxserver/chrome) | [https://hub.docker.com/r/linuxserver/chrome](https://hub.docker.com/r/linuxserver/chrome) |
| [GitHub · linuxserver/docker-chrome](https://github.com/linuxserver/docker-chrome) | [https://github.com/linuxserver/docker-chrome](https://github.com/linuxserver/docker-chrome) |
| [Release 149.0.7827.114-1-ls99](https://github.com/linuxserver/docker-chrome/releases/tag/149.0.7827.114-1-ls99) | [https://github.com/linuxserver/docker-chrome/releases/tag/149.0.7827.114-1-ls99](https://github.com/linuxserver/docker-chrome/releases/tag/149.0.7827.114-1-ls99) |
| [linuxserver/chrome 文档](https://docs.linuxserver.io/images/docker-chrome/) | [https://docs.linuxserver.io/images/docker-chrome/](https://docs.linuxserver.io/images/docker-chrome/) |
| [Selkies 安全说明](https://docs.linuxserver.io/selkies/user-guide/security/) | [https://docs.linuxserver.io/selkies/user-guide/security/](https://docs.linuxserver.io/selkies/user-guide/security/) |
| [Selkies 反向代理](https://docs.linuxserver.io/selkies/user-guide/reverse-proxy/) | [https://docs.linuxserver.io/selkies/user-guide/reverse-proxy/](https://docs.linuxserver.io/selkies/user-guide/reverse-proxy/) |
| [linuxserver/firefox 镜像页](https://xuanyuan.cloud/r/linuxserver/firefox) | [https://xuanyuan.cloud/r/linuxserver/firefox](https://xuanyuan.cloud/r/linuxserver/firefox) |
| [browserless/chrome 镜像页](https://xuanyuan.cloud/r/browserless/chrome) | [https://xuanyuan.cloud/r/browserless/chrome](https://xuanyuan.cloud/r/browserless/chrome) |
| [Docker Run 在线助手](https://xuanyuan.cloud/docker/run) | [https://xuanyuan.cloud/docker/run](https://xuanyuan.cloud/docker/run) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

`browserless/chrome` 是无头 Chrome，适合截图和自动化。`linuxserver/firefox` 是同一团队的远程 Firefox。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/chrome-docker-deploy

