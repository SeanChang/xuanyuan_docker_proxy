# Docker 部署 Filestash：轻松搭建浏览器文件管理平台

![Docker 部署 Filestash：轻松搭建浏览器文件管理平台](https://imgs.xuanyuan.cloud/docker/blog/filestash/filestash.webp)

*分类: Docker部署教程 | 标签: Filestash,machines/filestash,Docker,轩辕镜像,文件管理,SFTP,私有化部署,部署教程 | 发布时间: 2026-10-14 10:40:05*

> Filestash 是一款面向运维和开发的开源 Web 文件管理器，旨在把 SFTP、WebDAV、S3 等已有存储收进同一个网页，并通过浏览器完成浏览和上传。本文将介绍如何通过 Docker Compose 部署 Filestash，搭建浏览器文件管理平台，帮助你少装客户端、直接管理远程目录，适合服务器文件管理及多种存储集中查看等场景。

*本文基于 [machines/filestash:latest](https://xuanyuan.cloud/zh/r/machines/filestash)。上游没有带版本号的标签，本文使用 **latest**。*

## Filestash 是什么

Filestash 是一套在浏览器里使用的开源文件管理器。它不去替代你原来的磁盘或对象存储，而是连上已经存在的 SFTP、FTP、WebDAV、S3、Git 等入口，在网页里浏览和上传。

和 FileZilla、WinSCP 这类桌面客户端相比，Filestash 不要求每人再装一个软件。多种存储出现在同一个登录页上，点开一种协议，填上连接信息就能进目录。

## Filestash 能做什么

- **连接远程存储**：登录页可以选择 WebDav、FTP、SFTP、GIT、S3。
- **浏览目录**：连上之后可以打开文件夹，也能新建文件和目录。
- **上传文件**：文件列表页右下角有上传按钮。
- **设置管理员**：第一次打开时设置管理员密码，以后用这个密码进后台。
- **在后台查看存储驱动**：管理员可以打开后台，查看当前镜像里已经带上的存储后端。

## 为什么要使用 Filestash

服务器文件走 SFTP 客户端，网盘再换一个网页，对象存储又是另一套控制台。人一多、机器一多，光切换工具就要花时间。

Filestash 把这些入口收进一个浏览器页面。文件仍留在原来的服务器、WebDAV 或对象存储上。适合要同时查看几类已有存储的运维和开发，也适合给同事一个不用安装客户端的查看入口。

## 使用 Docker 部署 Filestash

Filestash 可以用 Docker 跑起来，宿主机不必安装它的运行环境。开始之前准备好 Docker，并想好浏览器要打开的地址。管理员密码会写进数据目录，这个目录需要留下来。

下面用 Docker Compose 启动服务，在浏览器里设置密码，再连上一台 SFTP 服务器。

## 环境要求

本文命令使用 **`machines/filestash:latest`**。上游没有 `1.2.3` 这种版本标签，原因见「标签怎么选」。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）；macOS 把 `/www/wwwroot/filestash` 换成 `~/docker/filestash`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64** 或 **linux/arm64**。`latest` 在轩辕镜像标签页上两种架构都有 |
| 磁盘 | 标签页上 amd64 约 284 MB，arm64 约 274 MB。配置写在 `state/`，按实际再留余量 |
| 端口 | 宿主机 **8334** → 容器 **8334**。这是 Filestash 自己的监听端口 |
| 工作目录 | `/www/wwwroot/filestash` |
| 数据目录 | `state/` 对应容器内 `/app/data/state`。管理员密码在这里 |

登录页会提交存储账号和密码。只在本机打开时可以用 `http://127.0.0.1:8334`。给别人用、或放到公网时，在前面加 HTTPS，见「使用域名访问」。

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

Windows 和 Mac 从 [Docker Desktop](https://www.docker.com/products/docker-desktop/) 安装，安装后启动 Docker Desktop。下文的 `cat > compose.yaml <<'EOF'` 是 bash 写法。PowerShell 不能直接粘贴这一段，请改用 Git Bash、WSL，或在 Linux 上执行。

## 标签怎么选

GitHub 仓库 [mickael-kerjean/filestash](https://github.com/mickael-kerjean/filestash) 没有 Release。Docker Hub 上当前这份镜像的标签是 **`latest`**，2026-10-09 有更新。轩辕镜像标签页上，`latest` 同时提供 linux/amd64 与 linux/arm64。

仓库里还能看到 `lowa`、`trial`、`latest-amd64`、`latest-arm64v8`，以及一串提交哈希。这些都不是 `x.y.z` 版本号。提交哈希停在更早的构建上，不是 2026-10-09 这份 `latest`。下面的命令使用 **`latest`**。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`latest`** | 当前镜像。上游没有带版本号的标签 | **是** |
| `latest-amd64` / `latest-arm64v8` | 按架构拆开的旧标签 | 否 |
| `lowa` / `trial` | 其他构建，不是版本号 | 否 |
| 提交哈希（如 `6b271d3`） | 更早的某次构建 | 否 |

官方安装文档里的 Compose 还包含 Collabora，用来做在线文档。本文只部署 Filestash 本身，不加入那一个服务。

完整标签见[标签列表](https://xuanyuan.cloud/r/machines/filestash/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/machines/filestash:latest
```

完成后，再写下面的 Compose。

## Docker Compose 部署

管理员密码和站点配置在宿主机目录 `state/`，对应容器内 `/app/data/state`。删掉 `state/` 之后，下次打开会再次要求设置密码。`docker compose down` 不加额外参数时，不会删除 `state/`。

`state/` 里已经有配置时，不要清空这个目录，直接执行启动命令。

以前用 `docker run` 创建过同名容器时，先删掉容器再启动 Compose。这一步不删除命名卷。旧命令如果没有挂载 `/app/data/state`，管理员密码在容器里，不在 `state/` 目录中。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/filestash/state
sudo chown -R "$USER":"$USER" /www/wwwroot/filestash
```

同名容器还在时：

```bash
docker rm -f filestash
```

2. 写入 `compose.yaml`。容器监听 8334，宿主机使用同一个端口。

```bash
cd /www/wwwroot/filestash
cat > compose.yaml <<'EOF'
name: filestash

services:
  filestash:
    image: docker.xuanyuan.run/machines/filestash:latest
    container_name: filestash
    restart: unless-stopped
    ports:
      - "8334:8334"
    volumes:
      - ./state:/app/data/state
EOF
```

3. 启动：

```bash
cd /www/wwwroot/filestash
docker compose up -d
```

4. 看状态。`filestash` 应为 Up，端口是 `0.0.0.0:8334->8334/tcp`。

```bash
docker compose ps
```

## 设置管理员密码

容器是 Up 之后，在跑 Docker 的这台机器上打开：

```text
http://127.0.0.1:8334
```

从别的电脑访问时，把 `127.0.0.1` 换成这台机器的 IP，例如 `http://服务器 IP:8334`。云服务器还要在安全组里放行 **8334**。

第一次打开会看到「Welcome Aboard!」。页面原文是「First thing first, setup your password:」。在「Password」里设置管理员密码，然后点右侧箭头。这里没有预置密码。

![首次打开，设置管理员密码](https://img.xuanyuan.dev/docker/blog/docker-filestash-1.png)

这个密码用于进入后台。后台地址是：

```text
http://127.0.0.1:8334/admin
```

存储驱动列表在 `/admin/storage`。当前镜像带了哪些后端，可以打开 `/about`，查看以 `plg_backend` 开头的项目。

## 连接 SFTP

密码设置完成后，登录页上有「WebDav」「FTP」「SFTP」「GIT」「S3」。点「SFTP」。

主表单上的字段是「Hostname」「Username」「Password」。「Hostname」带星号，必填。填服务器 IP 或域名、登录用户名和密码，点击「连接」。

端口不在这个主表单上。SSH 不是 22 时，先勾选「Advanced」，再填写改过的端口。

![SFTP 连接表单，含 Hostname、Username 和 Password](https://img.xuanyuan.dev/docker/blog/docker-filestash-4.png)

连上之后，面包屑会显示当前用户，例如 `Filestash > root`。左侧有「您的文件」。中间可以点「新文件」「新目录」。右下角是上传按钮。

![已连上 SFTP，目录中可见文件](https://img.xuanyuan.dev/docker/blog/docker-filestash-5.png)

同一页上的「WebDav」「FTP」「GIT」「S3」换的是协议。WebDAV 用于 Nextcloud 这类服务，S3 用于 AWS S3 以及 MinIO 这类兼容接口。字段以当前标签页上显示的为准，填完后同样点击「连接」。

## 使用域名访问

只在本机使用时，可以继续用 `http://127.0.0.1:8334`。要用域名给别人打开时，在 Filestash 前面放一层反向代理，并由代理做 HTTPS。官方安装说明把 TLS 放在反向代理上。

下面是一段 Nginx 示例。把 `filestash.example.com` 换成你的域名。Filestash 仍监听本机 8334。

```nginx
server {
    listen 80;
    server_name filestash.example.com;

    location / {
        proxy_pass http://127.0.0.1:8334;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

改完后重载 Nginx。证书和 HTTPS 的其余做法见[官方安装文档](https://www.filestash.app/docs/install-and-upgrade/)。

## 备选：docker run

上面的 Compose 已经在跑时，停在那里即可，不必再做这一节。

没有 Compose、只想短期打开看看时，用一条 `docker run`。8334 上已经有 Compose 里的容器时，先停掉它。数据目录用 `/www/wwwroot/filestash-run/state`，不要挂上面的 `state/`。

```bash
cd /www/wwwroot/filestash
docker compose down
```

```bash
sudo mkdir -p /www/wwwroot/filestash-run/state
sudo chown -R "$USER":"$USER" /www/wwwroot/filestash-run
docker run -d 
  --name filestash 
  --restart unless-stopped 
  -p 8334:8334 
  -v /www/wwwroot/filestash-run/state:/app/data/state 
  docker.xuanyuan.run/machines/filestash:latest
```

然后打开 `http://127.0.0.1:8334`，按「设置管理员密码」填写。

试用结束、要回到 Compose 时，停掉这个容器，再启动原来的 Compose。不要删除 `/www/wwwroot/filestash/state`。

```bash
docker stop filestash && docker rm filestash
cd /www/wwwroot/filestash
docker compose up -d
```

## 常见问题

**Q1：刷新后又要设置密码？**

管理员密码在 `/www/wwwroot/filestash/state`。Compose 没有挂载这个目录时，删掉容器就会丢掉密码。确认 `compose.yaml` 里有 `./state:/app/data/state`，并且没有删过 `state/`。

**Q2：8334 打不开？**

按这个顺序看：

1. `docker compose ps` 里 `filestash` 是否为 Up。
2. 在服务器上打开 `http://127.0.0.1:8334`。本机打不开时，先看 `docker compose logs --tail 80 filestash`。
3. 本机通、别的电脑不通时，再检查安全组和防火墙是否放行了 8334。

**Q3：SFTP 点连接没有进入目录？**

先核对「Hostname」「Username」「Password」。端口不在主表单上，SSH 不是 22 时勾选「Advanced」再改。Filestash 容器要能访问这台 SFTP 服务器，目标机器的防火墙也要允许来自 Filestash 所在主机的连接。

**Q4：登录页上没有 LOCAL？**

本文这张登录页截图里的协议是 WebDav、FTP、SFTP、GIT、S3，没有 LOCAL。本地文件系统是一种存储驱动，要在 `/admin/storage` 里启用。只把宿主机目录用 `-v` 挂进容器，登录页不会自动多出一个 LOCAL 标签。

**Q5：如何升级？**

本文使用 `latest`，这个标签会在上游发布新镜像后发生变化。升级前先保留 `state/`。然后执行：

```bash
cd /www/wwwroot/filestash
docker compose pull
docker compose up -d
```

不要改去使用提交哈希或 `latest-amd64`。`state/` 保持不动。

**Q6：如何停止？**

还要保留管理员密码和后台配置时，不要删除 `state/`。

```bash
cd /www/wwwroot/filestash
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop filestash && docker rm filestash
```

站点不再需要时，再删除数据目录：

```bash
rm -rf /www/wwwroot/filestash/state /www/wwwroot/filestash-run
```

**Q7：官方 Compose 里的 Collabora 要不要一起上？**

本文不部署它。官方下载的 Compose 里还有一个 WOPI 服务，用来做在线文档。只做文件浏览和 SFTP 时，一个 Filestash 容器就够。要按官方那份文件部署时，见[安装文档](https://www.filestash.app/docs/install-and-upgrade/)。

**Q8：可以把 8334 直接暴露到公网吗？**

登录页会提交存储密码。给公网使用时，用「使用域名访问」里的反向代理做 HTTPS，不要长期开放明文的 8334。

## 命令速查

```bash
docker pull docker.xuanyuan.run/machines/filestash:latest

cd /www/wwwroot/filestash
docker compose up -d
docker compose ps
docker compose logs --tail 80 filestash
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://127.0.0.1:8334`，在「Password」里设置管理员密码，再点「SFTP」连接。配置在 `state/`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [machines/filestash 镜像页](https://xuanyuan.cloud/zh/r/machines/filestash) | [https://xuanyuan.cloud/zh/r/machines/filestash](https://xuanyuan.cloud/zh/r/machines/filestash) |
| [machines/filestash 概览](https://xuanyuan.cloud/r/machines/filestash) | [https://xuanyuan.cloud/r/machines/filestash](https://xuanyuan.cloud/r/machines/filestash) |
| [machines/filestash 标签列表](https://xuanyuan.cloud/r/machines/filestash/tags) | [https://xuanyuan.cloud/r/machines/filestash/tags](https://xuanyuan.cloud/r/machines/filestash/tags) |
| [Docker Hub · machines/filestash](https://hub.docker.com/r/machines/filestash) | [https://hub.docker.com/r/machines/filestash](https://hub.docker.com/r/machines/filestash) |
| [GitHub · mickael-kerjean/filestash](https://github.com/mickael-kerjean/filestash) | [https://github.com/mickael-kerjean/filestash](https://github.com/mickael-kerjean/filestash) |
| [Filestash 官网](https://www.filestash.app/) | [https://www.filestash.app/](https://www.filestash.app/) |
| [Install and Upgrade](https://www.filestash.app/docs/install-and-upgrade/) | [https://www.filestash.app/docs/install-and-upgrade/](https://www.filestash.app/docs/install-and-upgrade/) |
| [Guide to Storage](https://www.filestash.app/docs/guide/storage.html) | [https://www.filestash.app/docs/guide/storage.html](https://www.filestash.app/docs/guide/storage.html) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/filestash-docker-deploy


