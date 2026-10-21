# Docker 部署 Portainer CE 中文版：轻松搭建容器管理平台

![Docker 部署 Portainer CE 中文版：轻松搭建容器管理平台](https://imgs.xuanyuan.cloud/docker/blog/portainer-zh/portainer-zh.webp)

*分类: Docker部署教程 | 标签: Portainer,Portainer CE,6053537/portainer-ce,Docker,轩辕镜像,容器管理,私有化部署,部署教程 | 发布时间: 2026-10-21 21:06:10*

> Portainer CE 中文版是一款面向自托管场景的社区汉化容器管理界面，旨在把 Docker 中的容器、镜像、卷和网络放在同一套中文网页里查看，并通过图形界面完成启停与 Compose 部署。本文将介绍如何通过 Docker Compose 部署 Portainer CE 中文版，搭建本机容器管理平台，帮助个人和小团队更方便地查看容器并启停服务，适合家用服务器及内网运维等场景。

*本文基于 [6053537/portainer-ce:2.45.2](https://xuanyuan.cloud/zh/r/6053537/portainer-ce)， **2.45.2** 版本实测，测试平台 **Ubuntu 24.04.5** Linux。*

## Portainer CE 中文版是什么

Portainer CE 中文版是社区维护者 6053537 发布的容器管理网页，镜像说明里称为中文汉化版。它基于 Portainer 社区版，在浏览器里查看和操作 Docker 中的容器、镜像、存储卷和网络。

与官方英文界面 `portainer/portainer-ce` 相比，安装页、左侧菜单和向导是中文。本机 Docker 通过套接字接入，查看和启停在网页里完成。

## Portainer CE 中文版能做什么

- **用中文查看环境**：容器、镜像、存储卷、网络和这台机器的资源放在同一套页面里。
- **启停并查看日志**：对容器做启动、停止和重启，并打开对应日志。
- **看到 Compose 项目**：仪表盘上有堆栈数量，容器列表里有「所属堆栈」。
- **按模板创建应用**：从应用模板列表部署一批常见应用。模板条目下的简介仍是英文。
- **添加环境**：环境向导里可以继续使用已经连上的本机 Docker，也可以再添加其它环境。

## 为什么要使用 Portainer CE 中文版

容器一多，在终端里来回看状态和日志就不容易对照。官方英文界面能做这些事，菜单和安装页是英文。

中文版把查看和启停放到中文网页里，适合家用服务器、NAS，以及要在内网里看容器状态的人。使用时会把 Docker 套接字交给这个容器，容器里的进程可以控制这台机器上的 Docker，所以只放在你自己管理的机器上。

## 使用 Docker 部署 Portainer CE 中文版

维护者提供了现成的容器镜像，本机不必再安装 Portainer 的程序。开始之前，先准备好 Docker。

下面用 Docker Compose 写好运行参数，启动服务，并在浏览器里创建管理员、确认能看到本机的 Docker。

## 环境要求

本文命令使用 `6053537/portainer-ce:2.45.2`。标签怎么对应，见「标签怎么选」。

上游社区版 **2.45.2** LTS 于 2026-10-08 发布。要求页里这一版列出的 Docker 版本是 **28.5.1** 与 **29.8.1**，架构是 **ARM64** 与 **x86_64**。中文镜像的维护者写明，自己只在 **arm64** 和 **amd64** 上测过。

这次实测主机是 `ikuai-ubuntu2404`，系统是 Ubuntu 24.04.5。欢迎页上 Docker 是 Standalone **29.8.2**，**4** 核心，**1.9 GB** 内存。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）。macOS 把 `/www/wwwroot/portainer-ce-zh` 换成 `~/docker/portainer-ce-zh`，套接字路径仍写 `/var/run/docker.sock` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | 维护者测过 **linux/amd64**、**linux/arm64**。命令使用多架构标签 `2.45.2` |
| 磁盘 | 镜像和 `data/` 里的数据库 |
| 端口 | 宿主机 **9000** → 容器 **9000**（HTTP）。不映射 **8000**、**9443** |
| 工作目录 | `/www/wwwroot/portainer-ce-zh` |

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

新安装使用具体版本标签 **`2.45.2`**。Docker Hub 上这个标签的推送时间是 **2026-10-11**。镜像说明仍写着「已更新到 2.19.4」，源码仓库 `master` 最近一次提交是 **2025-10-30**，首页的版本说明还是旧的上游模板。安装时以标签列表里的版本号为准。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`2.45.2`** | 标签列表里版本号最高的一支，2026-10-11 推送 | **是** |
| `2.45.1` | 上一支，2026-09-24 推送 | 否 |
| `2.39.4` | 更早的补丁线，2026-07-05 推送。已经在用、且短期不升级的实例可以继续留在这一支 | 否 |
| `latest` | 2026-06-05 推送，停在比 `2.39.4` 更早的构建上。镜像页 Compose 示例写的是这个标签 | 否 |
| `2.19.4` | 镜像说明文字里提到的旧版本，2024-03-30 推送 | 否 |

下面的命令使用 Linux 上的 `2.45.2`。`latest` 停在 2026-06-05，不会改指向 `2.45.2`。Windows 容器另见「常见问题」。完整标签见[标签列表](https://xuanyuan.cloud/r/6053537/portainer-ce/tags)。上游这一版的说明见 [Release 2.45.2](https://github.com/portainer/portainer/releases/tag/2.45.2)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/6053537/portainer-ce:2.45.2
```

Ubuntu 24.04 实测：

```text
2.45.2: Pulling from 6053537/portainer-ce
9680ccd7c2de: Pull complete
6b1a001e5723: Pull complete
0602b0461d81: Pull complete
70351e344504: Pull complete
496a609b2162: Pull complete
73d87cdfeed7: Pull complete
92468d92c28f: Pull complete
4f4fb700ef54: Pull complete
fa898690cd24: Download complete
Digest: sha256:d2c92288e7b014ff233bfcbc73e8074bd1c51fba954998622bfe1d4070ea441a
Status: Downloaded newer image for docker.xuanyuan.run/6053537/portainer-ce:2.45.2
docker.xuanyuan.run/6053537/portainer-ce:2.45.2
```

## Docker Compose 部署

下面这份 Compose 会把宿主机的 `/var/run/docker.sock` 挂进容器。挂上之后，容器里的进程可以控制这台机器上的 Docker。只在你自己的机器上这样做。

网页走容器内 **9000** 的 HTTP。镜像页把端口写成 `127.0.0.1:9000:9000`，那样只能在服务器本机打开。这里写成 `9000:9000`，便于在局域网的浏览器里访问。只在服务器本机打开时，把这一行改成 `127.0.0.1:9000:9000`。不要把 **9000** 暴露到公网，这条链路没有 TLS。

数据库在容器内 `/data`，对应宿主机目录 `data/`。删除容器不会删除这个目录。镜像页的 Compose 使用命名卷 `portainer_data`；挂目录时，备份可以直接复制 `data/`。镜像页的一行 `docker run` 没有挂载 `/data`，管理员和配置会写在容器可写层里，删掉容器就没了。下面的 Compose 和「备选：docker run」都挂上 `data/`。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/portainer-ce-zh/data
sudo chown -R "$USER":"$USER" /www/wwwroot/portainer-ce-zh
cd /www/wwwroot/portainer-ce-zh
```

2. 写入 `compose.yaml`。`9000:9000` 是宿主机端口到容器端口。

```bash
cat > compose.yaml <<'EOF'
services:
  portainer:
    image: docker.xuanyuan.run/6053537/portainer-ce:2.45.2
    container_name: portainer
    restart: unless-stopped
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data:/data
EOF
```

| 配置 | 说明 |
|------|------|
| `9000:9000` | 宿主机 **9000** → 容器 **9000**，网页走 HTTP |
| `/var/run/docker.sock` | 本机 Docker 套接字。没有这项就看不到本机容器 |
| `./data` | 数据库 `portainer.db` 和配置 |
| `unless-stopped` | 手动 `docker stop` 之后不会自动再启动 |
| `2.45.2` | 具体版本标签，与拉取命令一致 |

3. 启动，并查看状态和日志：

```bash
docker compose up -d
docker compose ps
docker compose logs portainer
```

Ubuntu 24.04 上这次启动的输出：

```text
[+] up 1/1
 ✔ Container portainer Started  2.9s
```

```text
NAME        IMAGE                                             COMMAND        SERVICE     CREATED         STATUS        PORTS
portainer   docker.xuanyuan.run/6053537/portainer-ce:2.45.2   "/portainer"   portainer   3 seconds ago   Up 1 second   8000/tcp, 9443/tcp, 0.0.0.0:9000->9000/tcp, [::]:9000->9000/tcp
```

`8000/tcp` 和 `9443/tcp` 只在容器内监听，没有映射到宿主机。对外只有 `9000`。

这次的 `compose.yaml` 写在已有项目目录 `/www/wwwroot/excalidraw` 里，所以输出只有容器启动，没有新建网络。截图里的堆栈名因此是 `excalidraw`。按本文在空的 `/www/wwwroot/portainer-ce-zh` 里启动时，输出还会多一行创建网络，堆栈名是 `portainer-ce-zh`。

日志里和这次启动有关的几行：

```text
portainer  | 2026/10/20 02:48PM INF github.com/portainer/portainer/api/cmd/portainer/main.go:357 > encryption key file not present | filename=/run/secrets/portainer
portainer  | 2026/10/20 02:48PM INF github.com/portainer/portainer/api/cmd/portainer/main.go:395 > proceeding without encryption key |
portainer  | 2026/10/20 02:48PM INF github.com/portainer/portainer/api/database/boltdb/db.go:163 > loading PortainerDB | filename=portainer.db
portainer  | 2026/10/20 02:48PM INF github.com/portainer/portainer/api/internal/ssl/ssl.go:79 > no cert files found, generating self signed SSL certificates |
portainer  | 2026/10/20 02:48PM INF github.com/portainer/portainer/pkg/libhelm/cache/manager.go:30 > Helm registry cache initialized | user_session_timeout=8h
portainer  | ==========================
portainer  | setup_token=<一串十六进制>
portainer  | Paste it into the setup screen, or send it in the X-Setup-Token header.
portainer  | Start with --no-setup-token to disable.
portainer  | ========================== |
portainer  | 2026/10/20 02:48PM INF github.com/portainer/portainer/api/chisel/service.go:229 > generated a new Chisel private key file | private-key=/data/chisel/private-key.pem
portainer  | 2026/10/20 14:48:39 server: Reverse tunnelling enabled
portainer  | 2026/10/20 14:48:39 server: Listening on http://0.0.0.0:8000
portainer  | 2026/10/20 02:48PM INF github.com/portainer/portainer/api/cmd/portainer/main.go:705 > starting Portainer | build_number=40 go_version=go1.26.6 image_tag=2.45.2-linux-amd64 nodejs_version=v22.23.3 pnpm_version=10.27.0 version=2.45.2 webpack_version=5.107.2
portainer  | 2026/10/20 02:48PM INF github.com/portainer/portainer/api/http/server.go:371 > starting HTTPS server | bind_address=:9443
portainer  | 2026/10/20 02:48PM INF github.com/portainer/portainer/api/http/server.go:355 > starting HTTP server | bind_address=:9000
```

没有把密钥放到 `/run/secrets/portainer` 时，开头两行是正常提示，后面仍会继续启动。`no cert files found, generating self signed SSL certificates` 表示容器正在生成自签证书。`setup_token=` 等号后面是一串十六进制，填进网页的「设置令牌」。`version=2.45.2` 和 `image_tag=2.45.2-linux-amd64` 对得上本次拉取的标签。`starting HTTP server | bind_address=:9000` 表示网页端口已在容器内监听。`Listening on http://0.0.0.0:8000` 与 `starting HTTPS server | bind_address=:9443` 是没有映射到宿主机的那两个端口。

4. 在服务器本机确认 9000 有响应：

```bash
curl -I http://127.0.0.1:9000
```

这次返回 `HTTP/1.1 200 OK`。判断服务是否起来，看这几行：

```text
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 14277
Last-Modified: Sun, 11 Oct 2026 03:34:38 GMT
X-Content-Type-Options: nosniff
Date: Tue, 20 Oct 2026 14:48:48 GMT
```

`Last-Modified` 是 **2026-10-11 03:34:38 GMT**，与 Docker Hub 上 `2.45.2` 的推送时间同在这一天。

## 在浏览器里创建管理员

镜像说明写明：程序不含预设密码或加密。空的 `data/` 第一次打开是「新安装 Portainer」。若一打开就是登录页，见「常见问题」。

从上游 **2.43** / **2.39.4** 起，全新实例创建第一个管理员时要填写设置令牌。这个值只出现在服务日志的 `setup_token=` 后面，用来避免别人抢先占住刚启动的实例。已经有管理员的实例不再出现这一页。令牌只用一次。页面写着密码长度至少需要 **12** 个字符，并要求在 **5** 分钟内创建完成。用户名默认是 `admin`，可以改。

1. 在浏览器打开 `http://192.168.1.35:9000`。这是这次实测的地址，换成你的服务器。

2. 从「Docker Compose 部署」的日志里复制 `setup_token=` 等号后面的值。超过 **5** 分钟还没提交时，重新复制。日志已经滚走时，再执行：

```bash
cd /www/wwwroot/portainer-ce-zh
docker compose logs portainer
```

3. 在「新安装 Portainer」填写用户名、密码、确认密码和「设置令牌 (Setup token)」，点「创建用户」。密码长度够了以后，「密码长度至少需要 12 个字符」这一行会打勾。同一页下方的「从备份恢复 Portainer」是折叠的，全新安装不用展开。

![Portainer 中文版新安装页，标题为新安装 Portainer，用户名为 admin，设置令牌已填入，提示密码长度至少需要 12 个字符，按钮为创建用户，下方折叠着从备份恢复 Portainer](https://imgs.xuanyuan.cloud/docker/blog/portainer-zh/portainer-zh-1.webp)

展开后有两项：「上传备份文件」和标着 Business Feature 的「从 S3 获取」。恢复同样要填密码和设置令牌，按钮是「恢复 Portainer」。全新安装点回上面的「新安装 Portainer」。

![Portainer 中文版从备份恢复页，选中上传备份文件，从 S3 获取标为 Business Feature，下方有设置令牌和恢复 Portainer](https://imgs.xuanyuan.cloud/docker/blog/portainer-zh/portainer-zh-2.webp)

4. 下一页标题是「设置边缘计算 (Edge Compute)」。这次画面上「启用边缘计算功能」是关闭的，按钮是「继续」和「跳过」。没有映射 **8000** 时，边缘 Agent 无法回连。点「跳过」。

![Portainer 中文版边缘计算设置页，标题为设置边缘计算 (Edge Compute)，启用边缘计算功能为关闭，按钮为继续与跳过](https://imgs.xuanyuan.cloud/docker/blog/portainer-zh/portainer-zh-3.webp)

5. 环境向导写着「已将您的本地 docker 环境连接至 Portainer」。不追加其它环境时，点「开始使用」。左下角是 Portainer 社区版 **2.45.2** LTS，右上角用户是 `admin`。这一页没有升级企业版的按钮。

![Portainer 中文版环境向导，标题为环境向导，提示已将本地 docker 环境连接至 Portainer，按钮为开始使用与添加环境，左下角为社区版 2.45.2 LTS](https://imgs.xuanyuan.cloud/docker/blog/portainer-zh/portainer-zh-4.webp)

## 登录后查看本机环境

点「开始使用」进入欢迎页。环境名是 `local`，状态为 Up，平台是 Standalone **29.8.2**，连接方式是 `unix:///var/run/docker.sock`。统计是 **1/1** 容器、**1** 堆栈、**4** 核心、**1.9 GB** 内存。时间 **2026-10-20 22:49:43** 是这台机器的本地时间。

![Portainer 中文版欢迎页，local 为 Up，Standalone 29.8.2，套接字 unix:///var/run/docker.sock，1/1 容器、1 堆栈、4 核心、1.9 GB 内存](https://imgs.xuanyuan.cloud/docker/blog/portainer-zh/portainer-zh-5.webp)

点 `local` 进入仪表盘。地址是 `/var/run/docker.sock`。当时 **1** 个堆栈、**1** 个运行中的容器、**1** 个镜像（**261.1 MB**）、**24** 个存储卷、**22** 个网络。卷和网络里包含这台机器上其它项目，后面的列表里有这些项目的名字。

![Portainer 中文版仪表盘，local，Standalone 29.8.2，1 个堆栈、1 个容器、1 个镜像 261.1 MB、24 个存储卷、22 个网络](https://imgs.xuanyuan.cloud/docker/blog/portainer-zh/portainer-zh-6.webp)

左侧「应用模板」打开后，标题是「应用模板列表」。能看到 Anyviz Cloud Adaptor、Caddy、CommandBox、ContentBox、CrateDB、Datadog agent。分类和按钮是中文，条目说明是英文。这次没有从这里创建容器。

![Portainer 中文版应用模板列表，含 Anyviz Cloud Adaptor、Caddy、CommandBox、ContentBox、CrateDB、Datadog agent](https://imgs.xuanyuan.cloud/docker/blog/portainer-zh/portainer-zh-7.webp)

「容器」里 `portainer` 为运行中，镜像是 `docker.xuanyuan.run/6053537/portainer-ce:2.45.2`，所属堆栈为 `excalidraw`，地址 `192.168.80.2`，端口映射 `9000:9000`，创建时间 **2026-10-20 22:48:35**，比日志里的 **14:48** UTC 晚 **8** 小时。堆栈名来自当时的项目目录。按本文在 `/www/wwwroot/portainer-ce-zh` 启动时，所属堆栈是 `portainer-ce-zh`。要改端口或挂载，编辑 `compose.yaml` 后再执行 `docker compose up -d`。

![Portainer 中文版容器列表，portainer 为运行中，镜像 docker.xuanyuan.run/6053537/portainer-ce:2.45.2，堆栈 excalidraw，地址 192.168.80.2，端口 9000:9000](https://imgs.xuanyuan.cloud/docker/blog/portainer-zh/portainer-zh-8.webp)

「镜像」里这一条的大小是 **261.1 MB**，创建时间 **2026-10-11 11:35:45**。页顶「拉取镜像」在普通模式下，镜像框下方有提示「镜像是必填项」。

![Portainer 中文版镜像列表，标签 docker.xuanyuan.run/6053537/portainer-ce:2.45.2，大小 261.1 MB，创建时间 2026-10-11 11:35:45，提示镜像是必填项](https://imgs.xuanyuan.cloud/docker/blog/portainer-zh/portainer-zh-9.webp)

打开「高级模式」后，提示是 `When using advanced mode, image and repository must be publicly available.` 这次在这里填了另一条公开镜像。

![Portainer 中文版镜像页的高级模式，英文提示仓库必须可公开访问，列表中仍是 portainer-ce 2.45.2](https://imgs.xuanyuan.cloud/docker/blog/portainer-zh/portainer-zh-10.webp)

拉取完成后，右上角出现「镜像拉取成功」。列表在 **261.1 MB** 那条下面多出一条 **313.7 MB**、状态为「未使用」的镜像，名称对应 `library/nginxinc/trixie-perl`。

![Portainer 中文版镜像拉取成功，portainer-ce 为 261.1 MB，另有一条 313.7 MB 且状态为未使用的镜像](https://imgs.xuanyuan.cloud/docker/blog/portainer-zh/portainer-zh-11.webp)

「网络」里 `excalidraw_default` 的子网是 `192.168.80.0/20`，网关是 `192.168.80.1`。容器地址 `192.168.80.2` 在这个网段内。同一页还有这台机器上其它项目的网络。在 `/www/wwwroot/portainer-ce-zh` 启动时，对应网络名是 `portainer-ce-zh_default`。

![Portainer 中文版网络列表，含 excalidraw_default，子网 192.168.80.0/20，网关 192.168.80.1](https://imgs.xuanyuan.cloud/docker/blog/portainer-zh/portainer-zh-12.webp)

「存储卷」列出的是 Docker 命名卷，多条状态为「未使用」。`portainer.db` 在宿主机目录 `data/`，所以列表里没有单独的 Portainer 卷。不要删除其它项目的卷。

![Portainer 中文版存储卷列表，多条状态为未使用，没有单独的 Portainer 卷](https://imgs.xuanyuan.cloud/docker/blog/portainer-zh/portainer-zh-13.webp)

「事件」按时间记下镜像操作。这次画面里是 `docker.xuanyuan.run/library/nginxinc/trixie-perl` 的拉取、标签变更和删除。

![Portainer 中文版事件列表，类型为 image，详情为镜像拉取、标签变更和删除](https://imgs.xuanyuan.cloud/docker/blog/portainer-zh/portainer-zh-14.webp)

「用户管理」里已有用户 `admin`，角色是管理员，认证方式是内部认证。添加新用户要填写用户名和密码。表单上的「系统管理员」是关闭的。

![Portainer 中文版用户管理，添加新用户表单在上方，用户列表中 admin 为管理员、内部认证](https://imgs.xuanyuan.cloud/docker/blog/portainer-zh/portainer-zh-15.webp)

## 备选：docker run

没有 Compose 时再用这一节。已经用「Docker Compose 部署」启动过时，先停掉，避免容器名和 9000 端口冲突：

```bash
cd /www/wwwroot/portainer-ce-zh
docker compose down
```

目录还没有时，先建好。风险与 Compose 相同：套接字挂进容器后，容器可以控制本机 Docker。镜像页那一行没有挂载 `/data`，也没有版本标签。下面这条带上数据目录和 `2.45.2`。

```bash
sudo mkdir -p /www/wwwroot/portainer-ce-zh/data
sudo chown -R "$USER":"$USER" /www/wwwroot/portainer-ce-zh
```

```bash
docker run -d 
  --name portainer 
  --restart unless-stopped 
  -p 9000:9000 
  -v /var/run/docker.sock:/var/run/docker.sock 
  -v /www/wwwroot/portainer-ce-zh/data:/data 
  docker.xuanyuan.run/6053537/portainer-ce:2.45.2
```

查看状态、日志，并在本机确认端口：

```bash
docker ps --filter name=portainer
docker logs portainer
curl -I http://127.0.0.1:9000
```

然后按「在浏览器里创建管理员」操作。读 token 时把 `docker compose logs portainer` 换成 `docker logs portainer`。

## 常见问题

**Q1：打开网页直接是登录，没有创建管理员？**

镜像说明写明，程序不含预设密码。出现登录页时，多半是 `data/` 里留着以前的数据库，包括以前装过的英文版或其它人发布的版本。用当时的账号登录。确定要全新安装时，先停掉容器，再换一个空目录挂到 `/data`。不要删掉还要用的那份数据。

**Q2：设置令牌填错，或页面拒绝创建用户？**

提交被拒绝时，回到日志重新复制 `setup_token=` 等号后面的值，填进「设置令牌 (Setup token)」。超过 **5** 分钟还没创建成功时，同样重新复制。这个值只用一次。说明见上游的 [Setup token 说明](https://docs.portainer.io/faqs/installing/setup-token)。

**Q3：能不能跳过设置令牌？**

可以，但只在你完全信任的隔离网络上这样做。参数必须在创建第一个管理员之前生效。在 `compose.yaml` 的 `portainer` 服务下增加：

```yaml
    command: ["--no-setup-token"]
```

然后重新创建容器：

```bash
cd /www/wwwroot/portainer-ce-zh
docker compose up -d
```

用 `docker run` 时，把 `--no-setup-token` 写在镜像名后面。已经有管理员的实例不受这个参数影响。不能看日志的托管安装，上游建议改用 `--admin-password-file` 在启动时写入管理员密码，此时不会生成 token。

**Q4：要不要映射 8000 和 9443？**

只在浏览器里用 HTTP 管理本机 Docker 时，不要把这两项映射到宿主机。8000 是 Edge Agent 的回连端口，要用 Edge 时再加 `"8000:8000"`。9443 是 HTTPS，上游安装文档把网页放在这个端口。要改用 HTTPS 时，把 Compose 的端口改成 `"9443:9443"`，浏览器打开 `https://服务器IP:9443`。容器使用自己生成的证书时，浏览器会提示不受信任，确认地址是这台服务器后再继续。要换成自己的证书，使用 `--sslcert` 与 `--sslkey`，参数放在镜像名后面，卷挂载仍写在镜像名前面。

**Q5：为什么命令里不写 `latest`？**

镜像页上的 Compose 示例写着 `latest`。这个标签停在 2026-06-05，不会改指向 `2.45.2`。pull、Compose 和 `docker run` 都写版本标签 **2.45.2**。对照见「标签怎么选」。

**Q6：如何升级？**

先备份 `/www/wwwroot/portainer-ce-zh/data`。上游说明：从 1.x 升级必须先升到 **2.0.0**，再升到更新版本，否则会出问题。这次的 Compose 只启动了 Portainer Server。若另外部署了 Agent，Agent 版本要和 Server 一致。

改 `compose.yaml` 的 `image` 标签后执行：

```bash
cd /www/wwwroot/portainer-ce-zh
docker compose pull
docker compose up -d
```

用 `docker run` 启动的，备份 `data/` 后执行 `docker stop portainer && docker rm portainer`，再按「备选：docker run」用新标签启动。`data/` 的路径保持不变。其它容器不会被这两条命令删除。

**Q7：容器起来了，浏览器打不开？**

按这个顺序看：

1. `docker ps` 里 `portainer` 是否为 Up。
2. `docker logs portainer` 里有没有报错。
3. 在服务器上执行 `curl -I http://127.0.0.1:9000`，看本机是否通。
4. 本机通、别的机器不通时，再检查云服务器安全组和本机防火墙是否放行了 **9000**。Compose 若写成 `127.0.0.1:9000:9000`，局域网也打不开，这是绑定地址造成的。

**Q8：网页里看不到本机容器？**

先看套接字是否挂上：

```bash
docker inspect portainer
```

在 Mounts 里确认容器内 `/var/run/docker.sock` 来自宿主机同一路径。上游说明 rootless Docker 有限制，需要额外配置。启用了 SELinux 时，要给容器加上 `privileged: true`。Ubuntu 默认不是 SELinux，所以上面的 `compose.yaml` 没有 `privileged`。

**Q9：和官方 `portainer/portainer-ce` 一起跑会怎样？**

两份镜像不要共用同一个容器名 `portainer`，也不要同时占用宿主机 **9000**。想沿用原来的管理员时，停掉原来的容器，把原来的数据目录挂到 `/data`，用原来的账号登录。不要让两个进程同时写同一份数据库。要官方英文界面时，看文末的官方镜像部署教程。

**Q10：Windows 上怎么启动？**

正文命令按 Linux 编写。Docker Desktop on Windows 使用命名管道，镜像页给出的写法是把 `\.pipedocker_engine` 挂进容器，数据卷挂到容器内 `C:data`。加上本文的版本标签后是：

```bash
docker run -d -p 9000:9000 --name portainer --restart unless-stopped -v \.pipedocker_engine:\.pipedocker_engine -v portainer_data:C:data docker.xuanyuan.run/6053537/portainer-ce:2.45.2
```

**Q11：如何停止与卸载？**

确认不再需要账号和配置之前，不要删除 `data/`。

Compose 停止并保留数据目录：

```bash
cd /www/wwwroot/portainer-ce-zh
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop portainer && docker rm portainer
```

账号和配置都不再需要时，再删除整个目录：

```bash
rm -rf /www/wwwroot/portainer-ce-zh
```

## 命令速查

```bash
docker pull docker.xuanyuan.run/6053537/portainer-ce:2.45.2

cd /www/wwwroot/portainer-ce-zh
docker compose up -d
docker compose ps
docker compose logs portainer
curl -I http://127.0.0.1:9000

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://服务器IP:9000`。程序不含预设密码。用户名默认 `admin`，密码在创建时自行设置。「设置令牌」填日志里 `setup_token=` 等号后面的值。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [6053537/portainer-ce 镜像页](https://xuanyuan.cloud/zh/r/6053537/portainer-ce) | [https://xuanyuan.cloud/zh/r/6053537/portainer-ce](https://xuanyuan.cloud/zh/r/6053537/portainer-ce) |
| [6053537/portainer-ce 概览](https://xuanyuan.cloud/r/6053537/portainer-ce) | [https://xuanyuan.cloud/r/6053537/portainer-ce](https://xuanyuan.cloud/r/6053537/portainer-ce) |
| [6053537/portainer-ce 标签列表](https://xuanyuan.cloud/r/6053537/portainer-ce/tags) | [https://xuanyuan.cloud/r/6053537/portainer-ce/tags](https://xuanyuan.cloud/r/6053537/portainer-ce/tags) |
| [Docker Hub · 6053537/portainer-ce](https://hub.docker.com/r/6053537/portainer-ce) | [https://hub.docker.com/r/6053537/portainer-ce](https://hub.docker.com/r/6053537/portainer-ce) |
| [Docker Hub 标签](https://hub.docker.com/r/6053537/portainer-ce/tags) | [https://hub.docker.com/r/6053537/portainer-ce/tags](https://hub.docker.com/r/6053537/portainer-ce/tags) |
| [GitHub · eysp/portainer-ce](https://github.com/eysp/portainer-ce) | [https://github.com/eysp/portainer-ce](https://github.com/eysp/portainer-ce) |
| [Release 2.45.2](https://github.com/portainer/portainer/releases/tag/2.45.2) | [https://github.com/portainer/portainer/releases/tag/2.45.2](https://github.com/portainer/portainer/releases/tag/2.45.2) |
| [上游首次设置](https://docs.portainer.io/start/install/server/setup) | [https://docs.portainer.io/start/install/server/setup](https://docs.portainer.io/start/install/server/setup) |
| [Setup token 说明](https://docs.portainer.io/faqs/installing/setup-token) | [https://docs.portainer.io/faqs/installing/setup-token](https://docs.portainer.io/faqs/installing/setup-token) |
| [Linux 安装文档](https://docs.portainer.io/start/install-ce/server/docker/linux) | [https://docs.portainer.io/start/install-ce/server/docker/linux](https://docs.portainer.io/start/install-ce/server/docker/linux) |
| [Docker Standalone 升级](https://docs.portainer.io/start/upgrade/docker) | [https://docs.portainer.io/start/upgrade/docker](https://docs.portainer.io/start/upgrade/docker) |
| [要求与先决条件](https://docs.portainer.io/start/requirements-and-prerequisites) | [https://docs.portainer.io/start/requirements-and-prerequisites](https://docs.portainer.io/start/requirements-and-prerequisites) |
| [portainer/portainer-ce 部署教程](https://xuanyuan.cloud/blog/portainer-ce-docker-deploy) | [https://xuanyuan.cloud/blog/portainer-ce-docker-deploy](https://xuanyuan.cloud/blog/portainer-ce-docker-deploy) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

要官方英文界面时，用上面的 `portainer/portainer-ce` 部署教程。那一篇使用官方镜像，网页走 **9443** 的 HTTPS。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/portainer-ce-zh-docker-deploy


