# Docker 部署 Portainer CE：轻松搭建容器管理平台

![Docker 部署 Portainer CE：轻松搭建容器管理平台](https://imgs.xuanyuan.cloud/docker/blog/portainer-ce/portainer-ce.webp)

*分类: Docker部署教程 | 标签: Portainer,Portainer CE,portainer/portainer-ce,Docker,轩辕镜像,容器管理,私有化部署,部署教程 | 发布时间: 2026-10-10 21:37:59*

> Portainer CE 是一款面向自托管场景的开源容器管理平台，旨在把 Docker 等环境中的容器、镜像、卷和网络放在同一套网页里查看，并通过图形界面完成启停与 Compose 部署。本文将介绍如何通过 Docker Compose 部署 Portainer CE，搭建本机容器管理平台，帮助个人和小团队在浏览器里查看容器、启停服务并提交 Compose，适合单机 Docker 及内网运维等场景。

*本文基于 [portainer/portainer-ce:2.45.2](https://xuanyuan.cloud/zh/r/portainer/portainer-ce)，以 **2.45.2** 版本实测，界面显示 Docker **29.8.2**，测试平台 **Ubuntu 24.04.5** Linux。*

## Portainer CE 是什么

Portainer CE（Community Edition）是 Portainer 的社区版，用一个容器提供网页管理界面。它用来查看和操作 Docker 里的容器、镜像、卷和网络。

和只在终端里管理容器相比，这些操作改在浏览器里完成。本机 Docker 通过套接字接入，其它环境通过 Agent 接入。角色权限和镜像仓库管理在商业版里提供。

## Portainer CE 能做什么

- **对照查看环境**：容器、镜像、卷、网络和主机信息放在同一套页面里。
- **启停并查看日志**：对容器做启动、停止和重启，并打开对应日志。
- **提交 Compose**：把 Compose 作为 Stack 部署到已经接入的环境。
- **按模板创建应用**：从内置模板列表部署一批常见应用。
- **接入更多环境**：除本机 Docker 外，还可以管理 Swarm、Kubernetes 和 ACI。

## 为什么要使用 Portainer CE

容器一多，在终端里来回看状态和日志就不容易对照。只为了看一眼状态，也不必把宿主机登录账号交给每个人。

Portainer CE 把查看和启停放到浏览器里，适合个人服务器、家用 NAS，以及要在内网里看容器状态的人。使用时会把 Docker 套接字交给这个容器，所以把它放在你自己管理的机器上。

## 使用 Docker 部署 Portainer CE

官方提供现成的容器镜像，本机不必再安装 Portainer 的程序。开始之前，先准备好 Docker。

下面用 Docker Compose 写好运行参数，启动服务，并在浏览器里创建管理员、确认能看到本机的 Docker。

## 环境要求

社区版 **2.45.2** LTS 于 2026-10-08 发布。官方对这一版验证过的 Docker 版本是 **28.5.1** 与 **29.8.1**，架构是 **ARM64** 与 **x86_64**。这次实测系统是 Ubuntu 24.04.5 LTS，Docker 是 **29.8.2**。

官方不建议在 Ubuntu 上使用 snap 安装的 Docker，这种装法可能不兼容。下面的命令假定 Docker 以 root 运行。rootless Docker 的限制见「常见问题」。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（这次实测 Ubuntu 24.04.5 LTS）；macOS 把 `/www/wwwroot/portainer-ce` 换成 `~/docker/portainer-ce`，套接字路径仍写 `/var/run/docker.sock` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | 官方验证 **ARM64**、**x86_64**。命令使用多架构标签 `2.45.2` |
| 磁盘 | 镜像和 `data/` 里的数据库；若在网页里用 Git 部署，仓库会克隆到这个目录 |
| 端口 | 宿主机 **9443** → 容器 **9443**（HTTPS）。不映射 **8000**、**9000** |
| 工作目录 | `/www/wwwroot/portainer-ce` |

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

新安装使用具体版本标签 **`2.45.2`**。这是官方要求表里社区版最新的 LTS，发布于 2026-10-08。更早的 **2.39** 补丁线仍列在同一张表里。已经在用那一支、且短期不升级的实例，可以继续留在那一支。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`2.45.2`** | 社区版当前 LTS 版本号，2026-10-08 发布 | **是** |
| `lts` | 长期支持浮动标签。官方安装示例写这个标签，它会随补丁变化 | 否 |
| `sts` | 短期支持浮动标签 | 否 |
| `latest` | 浮动标签 | 否 |
| `2.45.2-alpine` | Alpine 变体。官方 Linux 安装文档用的不是这一支 | 否 |
| `2.45.2-linux-amd64` 等 | 单一架构标签 | 否 |

下面的命令使用 Linux 上的 `2.45.2`。Windows 容器要另选带 `windows` 的标签。完整标签见[标签列表](https://xuanyuan.cloud/r/portainer/portainer-ce/tags)，版本说明见 [Release 2.45.2](https://github.com/portainer/portainer/releases/tag/2.45.2)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/portainer/portainer-ce:2.45.2
```

Ubuntu 24.04 实测：

```text
Digest: sha256:03f94a406496dc84d37b552795fc424ccad8d0d7200353b6a82915f6e8f73ab0
Status: Downloaded newer image for docker.xuanyuan.run/portainer/portainer-ce:2.45.2
docker.xuanyuan.run/portainer/portainer-ce:2.45.2
```

## Docker Compose 部署

下面这份 Compose 会把宿主机的 `/var/run/docker.sock` 挂进容器。挂上之后，容器里的进程可以控制这台机器上的 Docker。只在你自己的机器上这样做，不要把 `9443` 直接暴露到公网。

数据库在容器内 `/data`，对应宿主机目录 `data/`。删除容器不会删除这个目录。官方示例使用命名卷 `portainer_data`；用目录挂载时，备份可以直接复制 `data/`。

官方安装文档还会映射 `8000:8000`，供 Edge Agent 回连。下面只映射 9443。要加 8000 或旧的 HTTP 端口 9000 时，见「常见问题」。

| 宿主机 | 容器内 | 用途 |
|--------|--------|------|
| `/var/run/docker.sock` | `/var/run/docker.sock` | 让 Portainer 控制本机 Docker |
| `data/` | `/data` | 数据库和配置，含 `portainer.db` |

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/portainer-ce/data
sudo chown -R "$USER":"$USER" /www/wwwroot/portainer-ce
cd /www/wwwroot/portainer-ce
```

2. 写入 `compose.yaml`。`9443:9443` 是宿主机端口到容器端口。

```bash
cat > compose.yaml <<'EOF'
services:
  portainer:
    image: docker.xuanyuan.run/portainer/portainer-ce:2.45.2
    container_name: portainer
    restart: unless-stopped
    ports:
      - "9443:9443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data:/data
EOF
```

| 配置 | 说明 |
|------|------|
| `9443:9443` | 宿主机 **9443** → 容器 **9443**，网页走 HTTPS |
| `/var/run/docker.sock` | 本机 Docker 套接字。没有这项就看不到本机容器 |
| `./data` | 数据库 `portainer.db` 和配置 |
| `unless-stopped` | 手动 `docker stop` 之后不会自动再启动 |
| `2.45.2` | 社区版 LTS 的具体版本 |

3. 启动，并查看状态和日志：

```bash
docker compose up -d
docker compose ps
docker compose logs portainer
```

Ubuntu 24.04 上这次启动的输出：

```text
[+] up 2/2
 ✔ Network portainer-ce_default Created  0.2s
 ✔ Container portainer          Started  2.2s
```

```text
NAME        IMAGE                                               COMMAND        SERVICE     CREATED          STATUS         PORTS
portainer   docker.xuanyuan.run/portainer/portainer-ce:2.45.2   "/portainer"   portainer   11 seconds ago   Up 9 seconds   8000/tcp, 9000/tcp, 0.0.0.0:9443->9443/tcp, [::]:9443->9443/tcp
```

`8000/tcp` 和 `9000/tcp` 只在容器内监听，没有映射到宿主机。对外只有 `9443`。

日志里和这次启动有关的几行：

```text
portainer  | 2026/10/10 10:09AM INF github.com/portainer/portainer/api/cmd/portainer/main.go:357 > encryption key file not present | filename=/run/secrets/portainer
portainer  | 2026/10/10 10:09AM INF github.com/portainer/portainer/api/cmd/portainer/main.go:395 > proceeding without encryption key |
portainer  | 2026/10/10 10:09AM INF github.com/portainer/portainer/api/database/boltdb/db.go:163 > loading PortainerDB | filename=portainer.db
portainer  | 2026/10/10 10:09AM INF github.com/portainer/portainer/api/internal/ssl/ssl.go:79 > no cert files found, generating self signed SSL certificates |
portainer  | ==========================
portainer  | setup_token=<一串十六进制>
portainer  | Paste it into the setup screen, or send it in the X-Setup-Token header.
portainer  | Start with --no-setup-token to disable.
portainer  | ========================== |
portainer  | 2026/10/10 10:09:49 server: Listening on http://0.0.0.0:8000
portainer  | 2026/10/10 10:09AM INF github.com/portainer/portainer/api/cmd/portainer/main.go:705 > starting Portainer | build_number=40 go_version=go1.26.6 image_tag=2.45.2-linux-amd64 nodejs_version=v22.23.3 pnpm_version=10.27.0 version=2.45.2 webpack_version=5.107.2
portainer  | 2026/10/10 10:09AM INF github.com/portainer/portainer/api/http/server.go:371 > starting HTTPS server | bind_address=:9443
portainer  | 2026/10/10 10:09AM INF github.com/portainer/portainer/api/http/server.go:355 > starting HTTP server | bind_address=:9000
```

没有把密钥放到 `/run/secrets/portainer` 时，开头两行是正常提示，后面仍会继续启动。`no cert files found, generating self signed SSL certificates` 表示容器正在生成自签证书。`setup_token=` 等号后面是一串十六进制，创建第一个管理员时粘贴到网页；正文不保留这串值。看到 `version=2.45.2` 和 `starting HTTPS server | bind_address=:9443` 时，网页端口已经在容器内监听。`Listening on http://0.0.0.0:8000` 与 `starting HTTP server | bind_address=:9000` 对应 `docker compose ps` 里没有映射出去的那两个端口。日志里的 `image_tag` 是 `2.45.2-linux-amd64`。

4. 在服务器本机确认 9443 有响应。证书是容器自己生成的，所以加上 `-k`：

```bash
curl -k -I https://127.0.0.1:9443
```

这次返回 `HTTP/1.1 200 OK`。判断服务是否起来，看这几行：

```text
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 14269
Last-Modified: Thu, 08 Oct 2026 00:30:04 GMT
X-Content-Type-Options: nosniff
Date: Sat, 10 Oct 2026 10:10:06 GMT
```

## 在浏览器里创建管理员

从 **2.43** / **2.39.4** 起，全新实例在创建第一个管理员时要填写 setup token。这个值只出现在服务日志里，用来避免别人抢先占住刚启动的实例。已经有管理员的实例不受影响。token 只用一次，创建完成后不必保存。

1. 在浏览器打开 `https://192.168.1.35:9443`，把这个地址换成你的服务器。容器使用自己生成的证书，浏览器会提示不受信任。确认地址是这台服务器后再继续。

2. 从「Docker Compose 部署」的日志里复制 `setup_token=` 等号后面的值。官方要求在 **5** 分钟内完成创建。日志已经滚走时，再执行：

```bash
cd /www/wwwroot/portainer-ce
docker compose logs portainer
```

3. 在「New Portainer installation」填写用户名、密码和「Setup token」，点「Create user」。用户名默认是 `admin`，可以改。页面写着密码至少 **12** 个字符，满足后这一行会打勾。同一页还有「Restore Portainer from backup」，全新安装不用打开它。

![Portainer 首次安装页，用户名为 admin，密码已填写，Setup token 已填入，提示密码至少 12 个字符，按钮为 Create user](https://imgs.xuanyuan.cloud/docker/blog/portainer-ce/portainer-ce-1.webp)

4. 下一页是「Set up Edge Compute」。这一页上「Enable Edge Compute features」和「Enable Edge Environment Waiting Room」显示为打开，「Portainer API server URL」预填为 `https://192.168.1.35:9443`。点「Enable and continue」会启用 Edge，但 8000 没有映射到宿主机，Edge Agent 无法回连。这次点「Skip」。

![Portainer 的 Edge Compute 设置页，两项开关为打开，API 地址为 https://192.168.1.35:9443，按钮为 Enable and continue 与 Skip](https://imgs.xuanyuan.cloud/docker/blog/portainer-ce/portainer-ce-2.webp)

5. 环境向导会写明已经连上本机 Docker。不追加其它环境时，点「Get Started」。左下角显示 Portainer Community Edition **2.45.2** LTS。顶部「Upgrade to Business Edition」通向商业版，继续用社区版时不必点它。

![Portainer 环境向导，提示已连接本机 Docker，按钮为 Get Started 与 Add Environments，左下角为 Community Edition 2.45.2 LTS](https://imgs.xuanyuan.cloud/docker/blog/portainer-ce/portainer-ce-3.webp)

## 登录后查看本机环境

点「Get Started」进入 Home。环境名是 `local`，状态为 Up，平台是 Standalone **29.8.2**，连接方式是 `unix:///var/run/docker.sock`。右上角用户是 `admin`。

![Portainer Home，local 环境为 Up，平台 Standalone 29.8.2，套接字 unix:///var/run/docker.sock，1/1 容器、4 核、1.9 GB 内存](https://imgs.xuanyuan.cloud/docker/blog/portainer-ce/portainer-ce-4.webp)

点 `local` 进入 Dashboard。当时正在运行的容器只有 **1** 个。旁边的 **22** 个卷和 **11** 个网络里，大部分是这台机器上以前的项目留下的。

![Portainer Dashboard，环境 local，Docker Standalone 29.8.2，1 个 Stack、1 个运行中的容器、1 个镜像、22 个卷、11 个网络](https://imgs.xuanyuan.cloud/docker/blog/portainer-ce/portainer-ce-5.webp)

左侧「Templates」→「Application」是应用模板。这次没有从模板创建容器。

![Portainer 应用模板列表，含 Caddy、CommandBox、CrateDB 等条目](https://imgs.xuanyuan.cloud/docker/blog/portainer-ce/portainer-ce-6.webp)

「Containers」里 `portainer` 为 running，镜像是 `docker.xuanyuan.run/portainer/portainer-ce:2.45.2`，Stack 为 `portainer-ce`，地址 `172.25.0.2`，发布端口 `9443:9443`。创建时间显示 **18:09**，是这台机器的本地时间，对应日志里的 **10:09** GMT。

![Portainer 容器列表，portainer 为 running，镜像 docker.xuanyuan.run/portainer/portainer-ce:2.45.2，地址 172.25.0.2，端口 9443:9443](https://imgs.xuanyuan.cloud/docker/blog/portainer-ce/portainer-ce-7.webp)

「Host」→「Details」用来核对这台机器：主机名 `ikuai-ubuntu2404`，Ubuntu **24.04.5** LTS，内核 **6.8.0-146-generic**，**4** 核，**1.9 GB** 内存，Docker **29.8.2**（API **1.56**），数据目录 `/var/lib/docker`，存储驱动 overlayfs。Disk usage 为 Not available。

![Portainer 主机详情，主机名 ikuai-ubuntu2404，Ubuntu 24.04.5 LTS，内核 6.8.0-146-generic，Docker 29.8.2，4 核，1.9 GB 内存](https://imgs.xuanyuan.cloud/docker/blog/portainer-ce/portainer-ce-8.webp)

「Images」里 `docker.xuanyuan.run/portainer/portainer-ce:2.45.2` 的大小是 **201 MB**。

![Portainer 镜像列表，标签 docker.xuanyuan.run/portainer/portainer-ce:2.45.2，大小 201 MB](https://imgs.xuanyuan.cloud/docker/blog/portainer-ce/portainer-ce-9.webp)

「Networks」里 Compose 创建的网络是 `portainer-ce_default`，子网 `172.25.0.0/16`，网关 `172.25.0.1`。容器地址 `172.25.0.2` 在这个网段内。

![Portainer 网络列表，含 portainer-ce_default，子网 172.25.0.0/16，网关 172.25.0.1](https://imgs.xuanyuan.cloud/docker/blog/portainer-ce/portainer-ce-10.webp)

「Volumes」列出的是 Docker 命名卷。数据库在宿主机目录 `data/`，所以这里没有单独的 Portainer 卷。不要删除列表里其它项目的卷。

![Portainer 卷列表，显示这台 Docker 上已有的命名卷，状态多为 Unused](https://imgs.xuanyuan.cloud/docker/blog/portainer-ce/portainer-ce-11.webp)

「Events」是 Docker 引擎的事件，会混入其它容器的记录。这次画面里不是 Portainer 的报错。

![Portainer 事件列表，记录本机 Docker 上其它容器的 exec 事件](https://imgs.xuanyuan.cloud/docker/blog/portainer-ce/portainer-ce-12.webp)

「Stacks」里有一条 `portainer-ce`，类型是 Compose，「Control」为 Limited。这个栈是在网页外用 `docker compose` 创建的，网页里不能像在 Portainer 里新建的栈那样改它。要改端口或挂载，编辑 `compose.yaml` 后再执行 `docker compose up -d`。

![Portainer Stacks 列表，portainer-ce 类型为 Compose，Control 为 Limited](https://imgs.xuanyuan.cloud/docker/blog/portainer-ce/portainer-ce-13.webp)

## 备选：docker run

没有 Compose 时再用这一节。已经用「Docker Compose 部署」启动过时，先停掉，避免容器名和 9443 端口冲突：

```bash
cd /www/wwwroot/portainer-ce
docker compose down
```

目录还没有时，先建好。风险与 Compose 相同：套接字挂进容器后，容器可以控制本机 Docker。

```bash
sudo mkdir -p /www/wwwroot/portainer-ce/data
sudo chown -R "$USER":"$USER" /www/wwwroot/portainer-ce
```

```bash
docker run -d 
  --name portainer 
  --restart unless-stopped 
  -p 9443:9443 
  -v /var/run/docker.sock:/var/run/docker.sock 
  -v /www/wwwroot/portainer-ce/data:/data 
  docker.xuanyuan.run/portainer/portainer-ce:2.45.2
```

查看状态、日志，并在本机确认端口：

```bash
docker ps --filter name=portainer
docker logs portainer
curl -k -I https://127.0.0.1:9443
```

然后按「在浏览器里创建管理员」操作。读 token 时把 `docker compose logs portainer` 换成 `docker logs portainer`。

## 常见问题

**Q1：浏览器提示证书不受信任？**

首次启动会生成自签证书，浏览器提示不受信任是预期现象。确认地址是你的服务器后再继续。要换成自己的证书，使用 `--sslcert` 与 `--sslkey`，说明见「延伸阅读」里的升级文档。

**Q2：Setup token 填错，或页面拒绝创建用户？**

提交被拒绝时，回到日志重新复制 `setup_token=` 等号后面的值，填进「Setup token」。超过 **5** 分钟还没创建成功时，同样重新复制。这个值只用一次，创建完成后不必保存。

**Q3：能不能跳过 setup token？**

可以，但只在你完全信任的隔离网络上这样做。参数必须在创建第一个管理员之前生效。在 `compose.yaml` 的 `portainer` 服务下增加：

```yaml
    command: ["--no-setup-token"]
```

然后重新创建容器：

```bash
cd /www/wwwroot/portainer-ce
docker compose up -d
```

用 `docker run` 时，把 `--no-setup-token` 写在镜像名后面。已经有管理员的实例不受这个参数影响。不能看日志的托管安装，官方建议改用 `--admin-password-file` 在启动时写入管理员密码，此时不会生成 token。

**Q4：要不要映射 8000 和 9000？**

只在浏览器里管理本机 Docker 时，不要把这两项映射到宿主机。8000 是 Edge Agent 的回连端口，要用 Edge 时再加 `"8000:8000"`。9000 是旧的 HTTP 端口；从社区版 2.9 起，网页默认走 9443 的 HTTPS。确实要保留 HTTP 时，再加 `"9000:9000"`。日志里的 `Listening on http://0.0.0.0:8000` 和 `bind_address=:9000` 只表示容器内部在监听。

**Q5：为什么命令里不写 `lts` 或 `latest`？**

这两个标签会在补丁发布后指向新镜像。命令使用具体版本 **2.45.2**，选择理由见「标签怎么选」。官方 Linux 安装示例写的是 `portainer/portainer-ce:lts`。要升级时，改 `compose.yaml` 里的标签，再按「如何升级」拉取。

**Q6：如何升级？**

先备份 `/www/wwwroot/portainer-ce/data`。官方说明：从 1.x 升级必须先升到 **2.0.0**，再升到更新版本，否则会出问题。这次的 Compose 只启动了 Portainer Server。若另外部署了 Agent，Agent 版本要和 Server 一致；升到 2.45.2 时 Agent 也用 2.45.2。

改 `compose.yaml` 的 `image` 标签后执行：

```bash
cd /www/wwwroot/portainer-ce
docker compose pull
docker compose up -d
```

用 `docker run` 启动的，备份 `data/` 后执行 `docker stop portainer && docker rm portainer`，再按「备选：docker run」用新标签启动。`data/` 的路径保持不变。其它容器不会被这两条命令删除。

**Q7：容器起来了，浏览器打不开？**

按这个顺序看：

1. `docker ps` 里 `portainer` 是否为 Up。
2. `docker logs portainer` 里有没有报错。
3. 在服务器上执行 `curl -k -I https://127.0.0.1:9443`，看本机是否通。
4. 本机通、外网不通时，再检查云服务器安全组和本机防火墙是否放行了 **9443**。

**Q8：网页里看不到本机容器？**

先看套接字是否挂上：

```bash
docker inspect portainer
```

在 Mounts 里确认容器内 `/var/run/docker.sock` 来自宿主机同一路径。官方说明 rootless Docker 有限制，需要额外配置。启用了 SELinux 时，要给容器加上 `privileged: true`。Ubuntu 默认不是 SELinux，所以上面的 `compose.yaml` 没有 `privileged`。

**Q9：和商业版是什么关系？**

命令里的镜像是社区版 `portainer/portainer-ce`。商业版镜像是 `portainer/portainer-ee`，安装时需要许可证。不要把镜像名改成 `portainer-ee`。

**Q10：如何停止与卸载？**

确认不再需要账号和配置之前，不要删除 `data/`。

Compose 停止并保留数据目录：

```bash
cd /www/wwwroot/portainer-ce
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop portainer && docker rm portainer
```

账号和配置都不再需要时，再删除整个目录：

```bash
rm -rf /www/wwwroot/portainer-ce
```

## 命令速查

```bash
docker pull docker.xuanyuan.run/portainer/portainer-ce:2.45.2

cd /www/wwwroot/portainer-ce
docker compose up -d
docker compose ps
docker compose logs portainer
curl -k -I https://127.0.0.1:9443

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `https://服务器IP:9443`。用户名默认 `admin`，密码在创建时自行设置，Setup token 在首次启动日志的 `setup_token=` 后面。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [portainer/portainer-ce 镜像页](https://xuanyuan.cloud/zh/r/portainer/portainer-ce) | [https://xuanyuan.cloud/zh/r/portainer/portainer-ce](https://xuanyuan.cloud/zh/r/portainer/portainer-ce) |
| [portainer/portainer-ce 概览](https://xuanyuan.cloud/r/portainer/portainer-ce) | [https://xuanyuan.cloud/r/portainer/portainer-ce](https://xuanyuan.cloud/r/portainer/portainer-ce) |
| [portainer/portainer-ce 标签列表](https://xuanyuan.cloud/r/portainer/portainer-ce/tags) | [https://xuanyuan.cloud/r/portainer/portainer-ce/tags](https://xuanyuan.cloud/r/portainer/portainer-ce/tags) |
| [Docker Hub · portainer/portainer-ce](https://hub.docker.com/r/portainer/portainer-ce) | [https://hub.docker.com/r/portainer/portainer-ce](https://hub.docker.com/r/portainer/portainer-ce) |
| [GitHub · portainer/portainer](https://github.com/portainer/portainer) | [https://github.com/portainer/portainer](https://github.com/portainer/portainer) |
| [Release 2.45.2](https://github.com/portainer/portainer/releases/tag/2.45.2) | [https://github.com/portainer/portainer/releases/tag/2.45.2](https://github.com/portainer/portainer/releases/tag/2.45.2) |
| [Linux 安装文档](https://docs.portainer.io/start/install-ce/server/docker/linux) | [https://docs.portainer.io/start/install-ce/server/docker/linux](https://docs.portainer.io/start/install-ce/server/docker/linux) |
| [首次设置](https://docs.portainer.io/start/install-ce/server/setup) | [https://docs.portainer.io/start/install-ce/server/setup](https://docs.portainer.io/start/install-ce/server/setup) |
| [Setup token 说明](https://docs.portainer.io/faqs/installing/setup-token) | [https://docs.portainer.io/faqs/installing/setup-token](https://docs.portainer.io/faqs/installing/setup-token) |
| [Docker Standalone 升级](https://docs.portainer.io/start/upgrade/docker) | [https://docs.portainer.io/start/upgrade/docker](https://docs.portainer.io/start/upgrade/docker) |
| [要求与先决条件](https://docs.portainer.io/start/requirements-and-prerequisites) | [https://docs.portainer.io/start/requirements-and-prerequisites](https://docs.portainer.io/start/requirements-and-prerequisites) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/portainer-ce-docker-deploy


