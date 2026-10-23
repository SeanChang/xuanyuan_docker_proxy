# Docker 部署 DPanel：轻松搭建轻量容器管理平台

![Docker 部署 DPanel：轻松搭建轻量容器管理平台](https://imgs.xuanyuan.cloud/docker/blog/dpanel/dpanel.webp)

*分类: Docker部署教程 | 标签: DPanel,dpanel/dpanel,Docker,轩辕镜像,容器管理,Podman,私有化部署,部署教程 | 发布时间: 2026-10-23 21:54:16*

> DPanel 是一款面向 Docker 与 Podman 的开源容器管理面板，旨在把容器、镜像、Compose 和应用安装放在同一套网页里管理，并通过图形界面完成查看、启停和部署。本文将介绍如何通过 Docker Compose 部署 DPanel，搭建本机容器管理平台，帮助个人和小团队在浏览器里管理容器与 Compose 任务，适合单机 Docker、家用 NAS 及内网运维等场景。

*本文基于 [dpanel/dpanel:1.11.1](https://xuanyuan.cloud/zh/r/dpanel/dpanel)，以 **1.11.1** 版本实测，界面显示 Docker **29.8.2**，测试平台 **Ubuntu 24.04.5** Linux。*

## DPanel 是什么

DPanel 是面向 Docker 和 Podman 的开源容器管理面板。它把容器、镜像、卷、网络和 Compose 任务放在同一套网页里查看和操作。

和只在终端里执行 `docker` 命令相比，容器状态、日志和部署放在同一套网页里对照。除本机套接字外，还可以通过 Docker API 或 SSH 管理其它主机。

## DPanel 能做什么

- **查看和操作容器**：在网页里看容器、镜像、卷和网络，并做启动、停止和重启。
- **用 Compose 部署应用**：在面板里用 YAML 文本、远程地址或 Git 仓库创建任务，任务文件写到数据目录的 `compose/`。
- **接入应用商店**：添加符合 1Panel 或 CasaOS 规范的商店，检索并安装应用。
- **管理更多环境**：通过 Docker API（TLS）或 SSH 接入其它主机，也支持 Podman。
- **绑定域名并申请证书**：标准版内置转发，可以把域名指到容器并处理证书。

## 为什么要使用 DPanel

容器多了以后，状态和日志分散在多次命令的输出里。看状态也要登录宿主机，交出的是整机账号。

DPanel 把查看、启停和 Compose 部署放到浏览器里，适合个人服务器、家用 NAS，以及要在内网里看多台 Docker 的人。挂上 Docker 套接字之后，这个容器可以控制本机 Docker，所以只部署在你自己管理的机器上。

## 使用 Docker 部署 DPanel

DPanel 提供现成的容器镜像，本机不必再单独安装面板程序。开始之前，先准备好 Docker。

接下来通过 Docker Compose 写好运行参数，启动服务，并在浏览器里完成管理员设置和访问验证。

## 环境要求

**1.11.1** 于 2026-10-12 发布。这次实测系统是 Ubuntu 24.04.5 LTS，内核 **6.8.0-146-generic**，主机名 `ikuai-ubuntu2404`。面板概览里 Docker 是 **29.8.2**（Client **1.51**）。容器标签 `com.docker.compose.version` 是 **5.6.0**。`1.11.1` 在 Docker Hub 上包含 **amd64**、**arm** 和 **arm64**，这次拉到的是 **amd64**。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（这次实测 Ubuntu 24.04.5 LTS）。macOS 把 `/www/wwwroot/dpanel` 换成 `~/docker/dpanel`，套接字路径见「常见问题」 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **amd64**、**arm**、**arm64**。命令使用多架构标签 `1.11.1` |
| 磁盘 | 镜像，以及 `data/` 里的数据库和证书。在面板里创建的 Compose 任务也会写进这个目录 |
| 端口 | 宿主机 **8807** → 容器 **8080**（面板）。标准版另映射宿主机 **80** → 容器 **80**、宿主机 **443** → 容器 **443**（域名转发与证书） |
| 工作目录 | `/www/wwwroot/dpanel` |

80、443、8807 里任一项已被占用时，不要按下面的标准版启动。80 或 443 被占用时，改用「常见问题」里的精简版。只有 8807 被占用时，只改面板的宿主机端口。

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

新安装使用具体版本标签 **`1.11.1`**。这是 2026-10-12 发布的标准版，基于 Alpine，包含域名转发和证书申请。2026-10-23 在 Docker Hub 上，`latest` 与 `1.11.1` 的各架构 digest 一致，`lite` 与 `1.11.1-lite` 也一致。`latest` 会在下次发布后改指向，所以命令里写 `1.11.1`。

| 标签 | 说明 | 是否写入本文主路径 |
|------|------|--------------------|
| **`1.11.1`** | Alpine 标准版，含域名转发和证书申请 | **是** |
| `1.11.1-lite` | Alpine 精简版，没有域名转发，不映射 80 和 443 | 否。80 或 443 已被占用时用 |
| `1.11.1-debian` | Debian 构建的标准版 | 否 |
| `1.11.1-lite-debian` | Debian 构建的精简版 | 否 |
| `latest`、`lite` | 浮动标签，会随新版本变化 | 否 |
| `beta`、`beta-lite` | 开发版。2026-10-23 的 digest 与 `1.11.1` 不同 | 否 |
| `1.11.1-darwin`、`1.11.1-windows` 等 | 对应系统的构建 | 否。这次用的是 Linux 标签 |
| `dpanel/dpanel-pe` | 专业版，是另一个镜像 | 否 |

下面的命令使用 Linux 上的 `1.11.1`。完整标签见[标签列表](https://xuanyuan.cloud/r/dpanel/dpanel/tags)，版本说明见 [Release v1.11.1](https://github.com/donknap/dpanel/releases/tag/v1.11.1)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/dpanel/dpanel:1.11.1
```

Ubuntu 24.04 实测：

```text
Digest: sha256:434b4ed67f91f2b5349535e605972ba29383fc178d1e3fb3a6d31eb9341ebf65
Status: Downloaded newer image for docker.xuanyuan.run/dpanel/dpanel:1.11.1
docker.xuanyuan.run/dpanel/dpanel:1.11.1
```

## Docker Compose 部署

下面这份 Compose 会把宿主机的 `/var/run/docker.sock` 挂进容器。挂上之后，容器里的进程可以控制这台机器上的 Docker。只在你自己的机器上这样做，不要把 **8807** 直接暴露到公网。

面板数据在容器内 `/dpanel`，对应宿主机目录 `/www/wwwroot/dpanel/data`。数据库和证书在这个目录里。在面板里新建的 Compose 任务会写到其中的 `compose/`。本文这份 `compose.yaml` 在 `/www/wwwroot/dpanel/compose.yaml`，不在 `data/` 里。删除容器不会删除 `data/`。

标准版会占用宿主机 **80** 和 **443**，给域名转发和证书使用。下一步如果查到这两项已有监听，先看「常见问题」，不要继续启动。

| 宿主机 | 容器内 | 用途 |
|--------|--------|------|
| **8807** | **8080** | 面板网页。浏览器打开 `http://服务器IP:8807/dpanel/ui` |
| **80** | **80** | 标准版的域名转发 |
| **443** | **443** | 标准版的证书与 HTTPS 转发 |
| `/var/run/docker.sock` | `/var/run/docker.sock` | 让 DPanel 控制本机 Docker |
| `data/` | `/dpanel` | 数据库、证书和面板日志。面板里新建的 Compose 任务在 `compose/` |

1. 先看 80、443、8807 是否已有进程监听。有输出就按「常见问题」改端口或改用精简版，没有输出再继续：

```bash
sudo ss -lntp | grep -E ':(80|443|8807)' || true
```

这次没有输出，80、443、8807 都没有进程监听。

2. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/dpanel/data
sudo chown -R "$USER":"$USER" /www/wwwroot/dpanel
cd /www/wwwroot/dpanel
```

3. 写入 `compose.yaml`。`APP_NAME` 必须和 `container_name` 相同，这里都是 `dpanel`。

```bash
cat > compose.yaml <<'EOF'
services:
  dpanel:
    image: docker.xuanyuan.run/dpanel/dpanel:1.11.1
    container_name: dpanel
    restart: always
    ports:
      - "80:80"
      - "443:443"
      - "8807:8080"
    environment:
      - APP_NAME=dpanel
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data:/dpanel
    extra_hosts:
      - "host.dpanel.local:host-gateway"
    logging:
      driver: json-file
      options:
        max-size: "5m"
        max-file: "10"
EOF
```

| 配置 | 说明 |
|------|------|
| `APP_NAME=dpanel` | 必须与 `container_name` 一致。改容器名时两处一起改 |
| `/var/run/docker.sock` | 本机 Docker 套接字。没有这项就看不到本机容器 |
| `./data` | 容器内 `/dpanel`。数据库和证书在这里 |
| `host.dpanel.local` | 容器内访问宿主机时用这个名字。容器里的 `127.0.0.1` 指向容器自己 |
| `always` | Docker 服务再次启动时，这个容器会起来。希望手动停止后保持停止，改成 `unless-stopped` |
| `max-size` / `max-file` | Docker 日志单文件 `5m`，保留 **10** 个。面板自己的警告日志在 `data/logs/` |

4. 启动，并查看状态和日志：

```bash
docker compose up -d
docker compose ps
docker compose logs dpanel
```

Ubuntu 24.04 上这次启动的输出：

```text
[+] up 2/2
 ✔ Network dpanel_default Created  0.3s
 ✔ Container dpanel       Started  2.5s
```

```text
NAME      IMAGE                                      COMMAND                  SERVICE   CREATED         STATUS         PORTS
dpanel    docker.xuanyuan.run/dpanel/dpanel:1.11.1   "/docker/entrypoint.…"   dpanel    7 seconds ago   Up 5 seconds   0.0.0.0:80->80/tcp, [::]:80->80/tcp, 0.0.0.0:443->443/tcp, [::]:443->443/tcp, 0.0.0.0:8807->8080/tcp, [::]:8807->8080/tcp
```

80、443、8807 都映射到了宿主机，IPv4 和 IPv6 各一条，一共 6 条。容器列表里的「端口 6」和这个数量一致。

日志里大量是建表和数据库迁移。下面只留和这次启动有关的几行：

```text
dpanel  | [2026-10-23 21:39:28.951]     [WARN]  default DPanel is a lightweight container management panel; visit https://deepanel.com for more information.
dpanel  | [2026-10-23 21:39:28.951]     [INFO]  default config  {"env": "production", "version": "1.11.1", "date": "[2026-10-23 21:39:28.951]"}
dpanel  | [2026-10-23 21:39:28.951]     [INFO]  default config  {"storage": "/dpanel"}
dpanel  | [2026-10-23 21:39:30.372]     [DEBUG] default run local command       {"cmd": "/usr/bin/ssh-keygen -t rsa -b 4096 -f /dpanel/cert/rsa/id_rsa -N  -C DPanel@https://dpanel.cc", "env": []}
dpanel  | [2026-10-23 21:39:33.543]     [INFO]  default provider load community edition
dpanel  | ********************************************************************
dpanel  | http | Host: 0.0.0.0,Mode: http,Port: 8080,Pid: 12
dpanel  | ********************************************************************
dpanel  | [2026-10-23 21:39:33.551]     [DEBUG] default docker daemon/event start       {"info": {"dockerEnvName":"local","status":{"available":true,"message":""}}}
```

第一行是程序自己打印的说明，服务随后照常监听。日志里的 `version` 是 **1.11.1**。另外还有 `{"migrate": "1.11.2"}`，这是数据库迁移步骤名，不是镜像标签。`ssh-keygen` 这一行是在 `/dpanel/cert/rsa/id_rsa` 生成密钥，只在文件不存在时生成。`provider load community edition` 表示这次是社区版。`Port: 8080` 是容器内端口。`dockerEnvName` 为 `local`，`available` 为 `true`，本机套接字已经连上。

同一段容器详情里，主机名是 `ikuai-ubuntu2404`，容器地址 `172.18.0.2`，网关 `172.18.0.1`，网络 `dpanel_default`。`family` 为 `ce`，`isLite` 为 `false`。

5. 在服务器本机确认面板地址有响应：

```bash
curl -sS -o /dev/null -w "%{http_code}
" http://127.0.0.1:8807/dpanel/ui
```

这次返回：

```text
200
```

## 在浏览器里设置管理员

官方说明：创建容器后，首次进入要先配置管理员用户名和密码。没有预置账号。

1. 在浏览器打开 `http://服务器IP:8807/dpanel/ui`，把「服务器IP」换成这台机器的地址。

2. 页面标题是「配置管理员用户名及密码」。这次用户名填的是 `admin`，下面两行是密码，勾选「保持登录状态」，点「登录」。按钮下方是《用户协议》和《隐私政策》，右侧有「忘记密码？」。没有预置密码，这两行由你自己填写。

![DPanel 首次配置页，标题为配置管理员用户名及密码，用户名为 admin，已勾选保持登录状态，按钮为登录](https://imgs.xuanyuan.cloud/docker/blog/dpanel/dpanel-1.webp)

## 登录后查看本机环境

登录后打开的是「系统概览」，面包屑是「首页 / 系统概览」。右上角用户是 `admin`，服务端是 `local`。面板信息里当前版本 **1.11.1**，版本类型 **ce**，运行环境 **production**。Docker 环境是 `local · unix:///var/run/docker.sock`，Docker 版本 Server **29.8.2** / Client **1.51**，SDK **1.51**，操作系统 Ubuntu 24.04.5 LTS / 6.8.0-146-generic / x86_64。

资源汇总里 CPU **0.02%**、**4** 核，内存使用 **1.91%**（Docker **34.40 MB**，宿主机 **1.76 GB**）。运行健康度 **99/100**，旁边标着「较低」。数据统计里 Docker 环境 **1** 个且在线，Compose 项目 **1** 个且运行中，容器 **1** 个且运行中。右侧容器资源排行只有 `dpanel`。

![DPanel 系统概览，版本 1.11.1，Docker 29.8.2，Ubuntu 24.04.5 LTS，1 个容器运行中，套接字 unix:///var/run/docker.sock](https://imgs.xuanyuan.cloud/docker/blog/dpanel/dpanel-2.webp)

「容器管理」→「容器列表」里，`dpanel` 为运行中，镜像是 `docker.xuanyuan.run/dpanel/dpanel:1.11.1`，创建时间 **2026-10-23 21:39:25**。对外访问显示「端口 6」。

![DPanel 容器列表，dpanel 为运行中，镜像 docker.xuanyuan.run/dpanel/dpanel:1.11.1，对外访问为端口 6](https://imgs.xuanyuan.cloud/docker/blog/dpanel/dpanel-3.webp)

点「创建容器」会打开侧栏。容器标识和镜像标了必填。「容器创建后状态」当前是「启动容器」，网络里选中的是「关联 Bridge 网络」。这次没有点「确定」，列表里仍然只有 `dpanel`。

![DPanel 创建容器侧栏，容器标识和镜像为必填，创建后状态为启动容器，选中关联 Bridge 网络](https://imgs.xuanyuan.cloud/docker/blog/dpanel/dpanel-4.webp)

「Compose」→「任务列表」里有一条 `dpanel`，状态是运行中，对外访问是「端口 6」，更新时间 **2026-10-23 21:39:25**。类型显示「配置丢失」。这份 `compose.yaml` 在宿主机 `/www/wwwroot/dpanel/compose.yaml`，`data/compose/` 里没有同名任务文件。面板列出了已经在跑的项目，数据目录里没有这份 YAML。容器仍在运行。要改端口或挂载，改宿主机上的 `compose.yaml`，再执行 `docker compose up -d`。

![DPanel Compose 任务列表，dpanel 类型为配置丢失，状态为运行中，对外访问为端口 6](https://imgs.xuanyuan.cloud/docker/blog/dpanel/dpanel-5.webp)

「镜像管理」→「镜像列表」里，`docker.xuanyuan.run/dpanel/dpanel:1.11.1` 的架构是 **amd64**，大小 **334.64 MB**。Digest 显示 `434b4ed67f91`，与拉取输出的 Digest 前缀相同。镜像创建时间是 **2026-10-12 14:28:35**。

![DPanel 镜像列表，标签 docker.xuanyuan.run/dpanel/dpanel:1.11.1，amd64，334.64 MB，Digest 显示 434b4ed67f91](https://imgs.xuanyuan.cloud/docker/blog/dpanel/dpanel-6.webp)

「存储&网络」→「网络管理」里，Compose 创建的网络是 `dpanel_default`，类型 bridge，网段 **172.18.0.0/16**，网关 **172.18.0.1**，创建时间 **2026/10/23 21:39:25**。启动日志里的容器地址 `172.18.0.2` 在这个网段内。同页还有系统网络 `bridge`、`host`、`none`。

![DPanel 网络管理，dpanel_default 为 bridge，网段 172.18.0.0/16，网关 172.18.0.1](https://imgs.xuanyuan.cloud/docker/blog/dpanel/dpanel-7.webp)

「系统」→「系统设置」里，创始人配置一栏是 `admin`。用户登录配置写着：配置安全入口、登录失败锁定、默认跳转、双因素验证与 Passkey 登录。自定义主题风格旁边标着 PRO，「配置」按钮不可点。面板设置有「升级面板」「用量与备份」「代码配置」「消息通知配置」。这次没有改这些项。

![DPanel 系统设置，创始人配置为 admin，含用户登录配置、基础主题风格和面板设置](https://imgs.xuanyuan.cloud/docker/blog/dpanel/dpanel-8.webp)

左侧「操作台」打开的是「本地 Shell」，面包屑是「首页 / 操作台」，提示符是 `~ #`。这次没有输入命令。已经登录时，可以在这里执行官方文档里的 `dpanel` 命令。进不了网页时，用「常见问题」里的 `docker exec`。

![DPanel 操作台，本地 Shell 的提示符为 ~ #，Session 1](https://imgs.xuanyuan.cloud/docker/blog/dpanel/dpanel-9.webp)

这次没有打开「文件管理」。官方说明使用它时会自动创建 `dpanel-plugin-explorer`，见「常见问题」。

## 备选：docker run

没有 Compose 时再用这一节。已经用「Docker Compose 部署」启动过时，先停掉，避免容器名和 80、443、8807 端口冲突：

```bash
cd /www/wwwroot/dpanel
docker compose down
```

目录还没有时，先建好。风险与 Compose 相同：套接字挂进容器后，容器可以控制本机 Docker。80 或 443 已被占用时，不要用下面这条标准版命令，改用「常见问题」里的精简版。

```bash
sudo mkdir -p /www/wwwroot/dpanel/data
sudo chown -R "$USER":"$USER" /www/wwwroot/dpanel
```

```bash
docker run -d 
  --name dpanel 
  --restart always 
  -p 80:80 
  -p 443:443 
  -p 8807:8080 
  -e APP_NAME=dpanel 
  --add-host=host.dpanel.local:host-gateway 
  --log-driver json-file 
  --log-opt max-size=5m 
  --log-opt max-file=10 
  -v /var/run/docker.sock:/var/run/docker.sock 
  -v /www/wwwroot/dpanel/data:/dpanel 
  docker.xuanyuan.run/dpanel/dpanel:1.11.1
```

`APP_NAME` 必须和 `--name` 相同。

查看状态、日志，并在本机确认端口：

```bash
docker ps --filter name=dpanel
docker logs dpanel
curl -sS -o /dev/null -w "%{http_code}
" http://127.0.0.1:8807/dpanel/ui
```

然后按「在浏览器里设置管理员」操作。

## 常见问题

**Q1：80 或 443 已经被占用？**

标准版要绑定这两项，给域名转发和证书使用。机器上已经有 Web 服务时，改用精简版 **`1.11.1-lite`**。精简版没有域名转发和证书申请，只保留面板端口，其余配置与标准版相同。

已经启动过标准版时，先停掉，再改文件。`data/` 会保留。

```bash
cd /www/wwwroot/dpanel
docker compose down
```

```bash
cat > compose.yaml <<'EOF'
services:
  dpanel:
    image: docker.xuanyuan.run/dpanel/dpanel:1.11.1-lite
    container_name: dpanel
    restart: always
    ports:
      - "8807:8080"
    environment:
      - APP_NAME=dpanel
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data:/dpanel
    extra_hosts:
      - "host.dpanel.local:host-gateway"
    logging:
      driver: json-file
      options:
        max-size: "5m"
        max-file: "10"
EOF
```

```bash
docker compose up -d
```

用 `docker run` 时，去掉 `-p 80:80` 和 `-p 443:443`，镜像改成 `docker.xuanyuan.run/dpanel/dpanel:1.11.1-lite`。

**Q2：8807 已经被占用？**

只改宿主机端口，容器内仍是 **8080**。例如改成 `18807:8080` 后，浏览器打开 `http://服务器IP:18807/dpanel/ui`。标准版的 80 和 443 保持不动。改完后执行：

```bash
cd /www/wwwroot/dpanel
docker compose up -d
```

**Q3：为什么命令里不写 `latest`？**

`latest` 和 `lite` 会在新版本发布后指向新镜像。和 **1.11.1** 的对照见「标签怎么选」。官方安装示例写的是 `dpanel/dpanel:latest`。升级时按「如何升级」改标签并重新拉取。

**Q4：忘记密码，或打开后直接是登录页？**

首次进入本应先设置管理员。页面已经要求登录、而你还没有可用密码时，在容器运行中执行下面的命令。把引号里的内容换成你要设置的密码：

```bash
docker exec dpanel user:reset --password '你的新密码'
```

不带 `--password` 时，官方说明会改成随机密码。1.10.10 起，这条命令的返回结果不再带明文密码，所以这里直接指定密码。要同时修改用户名时，必须带上密码：

```bash
docker exec dpanel user:reset --password '你的新密码' --username '你的用户名'
```

忘记访问地址或安全入口时，执行：

```bash
docker exec dpanel system:info
```

官方说明：输出里有运行环境、访问地址、安全入口和管理员账号，密码是脱敏的。

**Q5：容器起来了，浏览器打不开？**

按这个顺序看：

1. `docker ps` 里 `dpanel` 是否为 Up。
2. `docker logs dpanel` 里有没有报错。
3. 在服务器上执行 `curl -sS -o /dev/null -w "%{http_code}
" http://127.0.0.1:8807/dpanel/ui`，看本机是否通。
4. 本机通、别的机器不通时，再检查云服务器安全组和本机防火墙是否放行了 **8807**。用了标准版的域名转发时，还要放行 **80** 和 **443**。
5. 地址要带路径 `/dpanel/ui`。自定义过 `DP_SYSTEM_BASEURL` 时，路径会变，用 `system:info` 看当前地址。

**Q6：网页里看不到本机容器？**

先看套接字是否挂上：

```bash
docker inspect dpanel
```

在 Mounts 里确认容器内 `/var/run/docker.sock` 来自宿主机同一路径。没有这项时，改 `compose.yaml` 补上，再执行 `docker compose up -d`。

**Q7：使用文件管理时多出一个容器？**

这是官方说明里的行为。管理容器文件时，面板会自动创建 `dpanel-plugin-explorer`，使用 alpine 镜像，不映射端口，关闭页面后自动删除。不能接受自动创建时，不要使用文件管理。手动创建时，容器名必须是 `dpanel-plugin-explorer`，步骤见「延伸阅读」里的 Docker 安装文档。

**Q8：日志里出现 `disk I/O error: operation not permitted`？**

官方说明：系统开启 Seccomp 后，更新或重建面板容器时可能出现这段报错。出现这段报错时，再给服务加上：

```yaml
    security_opt:
      - seccomp=unconfined
```

放在 `compose.yaml` 里 `dpanel` 服务下，然后执行 `docker compose up -d`。没有这段报错时，不要加。

**Q9：如何升级？**

先备份 `/www/wwwroot/dpanel/data`。官方说明：保留 `/dpanel` 对应的宿主机目录是升级；删掉这个目录或换一个空目录再启动，是重建，管理员和配置会丢失。

改 `compose.yaml` 的 `image` 标签后执行：

```bash
cd /www/wwwroot/dpanel
docker compose pull
docker compose up -d
```

用 `docker run` 启动的，备份 `data/` 后执行 `docker stop dpanel && docker rm dpanel`，再按「备选：docker run」用新标签启动。`/www/wwwroot/dpanel/data` 的路径保持不变。其它容器不会被这两条命令删除。

**Q10：和专业版是什么关系？**

本文部署的是社区版 `dpanel/dpanel`。专业版是另一个镜像 `dpanel/dpanel-pe`。官方说明专业版是社区版的增强，通用功能留在社区版。换成 `dpanel-pe` 就不是这次实测的镜像。

**Q11：macOS 或 Docker Desktop 怎么挂套接字？**

工作目录改成 `~/docker/dpanel`。官方安装文档在 Docker Desktop 上把套接字写成 `//var/run/docker.sock:/var/run/docker.sock`。仓库说明另给出 macOS 路径：`/Users/你的用户名/.docker/run/docker.sock:/var/run/docker.sock`。Windows 的数据目录换成你的磁盘路径，例如 `D:datadpanel:/dpanel`。面板端口仍是宿主机 **8807**，`APP_NAME` 仍是 `dpanel`。

**Q12：如何停止与卸载？**

确认不再需要账号和配置之前，不要删除 `data/`。

Compose 停止并保留数据目录：

```bash
cd /www/wwwroot/dpanel
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop dpanel && docker rm dpanel
```

账号和配置都不再需要时，再删除整个目录：

```bash
rm -rf /www/wwwroot/dpanel
```

## 命令速查

```bash
docker pull docker.xuanyuan.run/dpanel/dpanel:1.11.1

cd /www/wwwroot/dpanel
docker compose up -d
docker compose ps
docker compose logs dpanel
curl -sS -o /dev/null -w "%{http_code}
" http://127.0.0.1:8807/dpanel/ui

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://服务器IP:8807/dpanel/ui`。没有预置账号，首次进入时自己设置管理员用户名和密码。80 或 443 已被占用时，改用 `dpanel/dpanel:1.11.1-lite`，并去掉这两项端口映射。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [dpanel/dpanel 镜像页](https://xuanyuan.cloud/zh/r/dpanel/dpanel) | [https://xuanyuan.cloud/zh/r/dpanel/dpanel](https://xuanyuan.cloud/zh/r/dpanel/dpanel) |
| [dpanel/dpanel 概览](https://xuanyuan.cloud/r/dpanel/dpanel) | [https://xuanyuan.cloud/r/dpanel/dpanel](https://xuanyuan.cloud/r/dpanel/dpanel) |
| [dpanel/dpanel 标签列表](https://xuanyuan.cloud/r/dpanel/dpanel/tags) | [https://xuanyuan.cloud/r/dpanel/dpanel/tags](https://xuanyuan.cloud/r/dpanel/dpanel/tags) |
| [Docker Hub · dpanel/dpanel](https://hub.docker.com/r/dpanel/dpanel) | [https://hub.docker.com/r/dpanel/dpanel](https://hub.docker.com/r/dpanel/dpanel) |
| [GitHub · donknap/dpanel](https://github.com/donknap/dpanel) | [https://github.com/donknap/dpanel](https://github.com/donknap/dpanel) |
| [Release v1.11.1](https://github.com/donknap/dpanel/releases/tag/v1.11.1) | [https://github.com/donknap/dpanel/releases/tag/v1.11.1](https://github.com/donknap/dpanel/releases/tag/v1.11.1) |
| [使用 Docker 安装](https://dpanel.cc/install/docker) | [https://dpanel.cc/install/docker](https://dpanel.cc/install/docker) |
| [使用 Compose 安装](https://dpanel.cc/install/compose) | [https://dpanel.cc/install/compose](https://dpanel.cc/install/compose) |
| [面板控制命令](https://dpanel.cc/install/ctrl) | [https://dpanel.cc/install/ctrl](https://dpanel.cc/install/ctrl) |
| [DPanel 官网](https://dpanel.cc/) | [https://dpanel.cc/](https://dpanel.cc/) |
| [专业版说明](https://dpanel.cc/pro) | [https://dpanel.cc/pro](https://dpanel.cc/pro) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/dpanel-docker-deploy)


