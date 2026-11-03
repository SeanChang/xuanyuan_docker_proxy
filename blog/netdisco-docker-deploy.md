# Docker 部署 Netdisco：轻松搭建网络设备发现与端口定位平台

![Docker 部署 Netdisco：轻松搭建网络设备发现与端口定位平台](https://imgs.xuanyuan.cloud/docker/blog/netdisco/netdisco.webp)

*分类: Docker部署教程 | 标签: Netdisco,Docker,轩辕镜像,网络发现,SNMP,私有化部署,部署教程 | 发布时间: 2026-11-02 15:29:19*

> Netdisco 是一款面向网络管理员的开源网络管理工具，旨在把设备、IP 和 MAC 地址收进 PostgreSQL，并通过网页定位端口、查看设备清单和拓扑。本文将介绍如何通过 Docker Compose 部署 Netdisco，搭建私有化网络发现平台，帮助运维人员更高效地查清终端接在哪台交换机的哪个端口，适合园区网、机房和需要把网络台账留在内网的场景。

## Netdisco 是什么

Netdisco 是 Netdisco 项目维护的网页网络管理工具，面向从小到很大的网络。它用 SNMP、命令行或设备 API 把 IP 和 MAC 收进 PostgreSQL，再在网页里查询设备、端口和连接关系。同一套部署里有网页、负责采集的后端守护进程，以及排障用的命令行。

和登录每台交换机翻 MAC 地址表、或把端口记在表格里相比，Netdisco 把采集到的地址和端口放进同一套数据库。网页上按 MAC 或 IP 查到这台机器接在哪台交换机的哪个端口，查的是设备上实际采到的状态。

## Netdisco 能做什么

- **按地址定位端口**：用 MAC 或 IP 查出这台机器接在哪台交换机的哪个端口。
- **盘点网络设备**：按型号、厂商、软件和操作系统查看设备清单。
- **查看网络拓扑**：在页面上查看设备之间的连接关系。
- **管理交换机端口**：关闭端口，或修改端口的 VLAN 和 PoE 状态。
- **持续采集地址表**：后端守护进程把 IP 和 MAC 写入 PostgreSQL，并按计划重复采集。

## 为什么要使用 Netdisco

终端换了网口、地址又被回收之后，表格、工单和交换机上的 MAC 表经常对不上。一台一台登录去查，范围一大就慢，换个人接手也不知道上次查到哪。

Netdisco 把发现结果留在你自己的数据库里，浏览器按地址查端口。适合维护园区网、机房，以及要把网络台账留在内网的管理员。

## 使用 Docker 部署 Netdisco

用 Docker 跑 Netdisco 时，网页、采集进程和 PostgreSQL 由各自的容器启动，宿主机不用再安装 Perl 和数据库软件包。开始之前准备好 Docker，并确认这台机器能访问要发现的网络设备。

接下来用 Docker Compose 写好这些服务，启动后在浏览器里打开页面，再对一台设备做发现。

## 环境要求

本文命令使用同一版本的三份标签：**`2.117000-web`**、**`2.117000-backend`**、**`2.117000-postgresql`**。打开首页后，System Information 显示 **App::Netdisco 2.117000**、PostgreSQL **16.6**。`2.117000-postgresql-13` 只在升级旧的 PostgreSQL 13 数据时使用，新安装不拉取。

2026-10-30，GitHub 发布了 **2.117000**，Docker Hub 上这三份标签同日推送，并提供 **linux/amd64** 和 **linux/arm64**。Hub 上 amd64 的压缩大小约为 Web **105.88 MB**、后端 **170.66 MB**、PostgreSQL **114.49 MB**。解压后的磁盘占用更大，库文件还会随设备数量增长。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）。macOS 把 `/www/wwwroot/netdisco` 换成 `~/docker/netdisco`，并跳过下面的 `chown 901`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64** |
| 内存 | 小网络先留 **2 GB** 可用内存。配置注释写着 SNMP 工作进程默认是 CPU 核数的两倍，设备多再加内存 |
| 磁盘 | 三份镜像加上 `netdisco/postgresql` 里的库文件。压缩包合计约 **391 MB**（amd64），请再留数据库增长空间 |
| 端口 | 宿主机 **5000** → 网页容器 **5000**。数据库不映射到宿主机 |
| 工作目录 | `/www/wwwroot/netdisco` |
| 目录权限 | `logs`、`config`、`nd-site-local` 要让容器用户 **uid 901** 可写 |
| 账号 | 初次打开不登录。`no_auth: true` 时，用户 **guest** 拥有完整管理权限，包括控制端口。数据库用户 **netdisco**，口令 **netdisco** |

5000 只给可信地址访问。免登录还开着时，来源收在可信网段里。

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

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=netdisco-docker-deploy)。

Windows 和 Mac 从 [Docker Desktop](https://www.docker.com/products/docker-desktop/) 安装，安装后启动 Docker Desktop。下文的 `cat > compose.yaml <<'EOF'` 是 bash 写法。PowerShell 不能直接粘贴这一段，请改用 Git Bash、WSL，或在 Linux 上执行。

## 标签怎么选

2026-11-02 查看 Docker Hub 时，`latest-web` 与 `2.117000-web` 是同一份镜像。`latest-backend`、`latest-postgresql` 同一天的摘要也与对应的 `2.117000-*` 一致。`latest-*` 会在下一次发布后改指向。

官方 Compose 示例写的是 `latest-web`、`latest-backend`、`latest-postgresql`。下面的命令使用 **`2.117000`**。网页、后端、数据库初始化、数据库使用同一组版本号。

| 标签 | 说明 | 是否写入新安装命令 |
|------|------|------------------|
| **`2.117000-web`** | 2026-10-30 的网页，容器内监听 5000 | **是** |
| **`2.117000-backend`** | 同一版本的采集进程；数据库初始化用同一份镜像 | **是** |
| **`2.117000-postgresql`** | 同一版本附带的数据库；实测界面显示 PostgreSQL **16.6** | **是** |
| `2.117000-postgresql-13` | 同一版本附带的 PostgreSQL 13，只用于迁出旧数据目录 | 否 |
| `latest-web`、`latest-backend`、`latest-postgresql` | 浮动标签，2026-11-02 与上表 `2.117000-*` 相同 | 否 |
| `2.116000-*`、`2.115000-*` 及更早 | 更早的 Netdisco 版本 | 否 |

完整标签见 [标签列表](https://xuanyuan.cloud/r/netdisco/netdisco/tags?xy_from=netdisco-docker-deploy)。这一版的发布页是 [2.117000](https://github.com/netdisco/netdisco/releases/tag/2.117000)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud/?xy_from=netdisco-docker-deploy) **加速拉取**。数据库初始化会再用到后端这份镜像，拉一次即可。

网页：

```bash
docker pull docker.xuanyuan.run/netdisco/netdisco:2.117000-web
```

Ubuntu 24.04 实测：

```text
2.117000-web: Pulling from netdisco/netdisco
462f23831b68: Pull complete
7b229517ed22: Pull complete
e9878767e99b: Pull complete
4f4fb700ef54: Pull complete
754ea9e89c8a: Pull complete
36e35e08fa39: Pull complete
6b01064bd42b: Pull complete
f109a39a736b: Pull complete
d8b99ee6a725: Pull complete
Digest: sha256:1236d3a537c1383f1e3397bcf015a1ac5665dc81581b90e8596e4d7789bfbd0f
Status: Downloaded newer image for docker.xuanyuan.run/netdisco/netdisco:2.117000-web
docker.xuanyuan.run/netdisco/netdisco:2.117000-web
```

后端：

```bash
docker pull docker.xuanyuan.run/netdisco/netdisco:2.117000-backend
```

```text
2.117000-backend: Pulling from netdisco/netdisco
4f4fb700ef54: Pull complete
9797c1bc6411: Pull complete
3371f016ad7e: Pull complete
4f31eefbf1e2: Pull complete
8199f124b120: Pull complete
4a52e781742e: Pull complete
Digest: sha256:5b2dda09fd1798632afa79459c7f29f5cb331db9c0d507bbb443aca104a5d7c8
Status: Downloaded newer image for docker.xuanyuan.run/netdisco/netdisco:2.117000-backend
docker.xuanyuan.run/netdisco/netdisco:2.117000-backend
```

数据库：

```bash
docker pull docker.xuanyuan.run/netdisco/netdisco:2.117000-postgresql
```

```text
2.117000-postgresql: Pulling from netdisco/netdisco
c636fe474156: Pull complete
a79cb36b2d47: Pull complete
8a06bdb27c21: Pull complete
04d6f1f64405: Pull complete
13930ab5cb14: Pull complete
9cfc5a06059d: Pull complete
242c5d565900: Pull complete
f0f97016fb12: Pull complete
432e82ade628: Pull complete
ca102eb59e0e: Pull complete
9b7e1e6003c9: Pull complete
Digest: sha256:fbaf86ad9cdd0d537683a5c155be515e993786f799f35b9745d8b050119e4ba6
Status: Downloaded newer image for docker.xuanyuan.run/netdisco/netdisco:2.117000-postgresql
docker.xuanyuan.run/netdisco/netdisco:2.117000-postgresql
```

## Docker Compose 部署

工作目录是 `/www/wwwroot/netdisco`。Compose 文件放在这一层，数据在下一层的 `netdisco/` 目录，和官方目录名一致。

| 服务 | 镜像标签 | 作用 |
|------|----------|------|
| `netdisco-postgresql` | `2.117000-postgresql` | 数据库。健康检查访问主机名 `netdisco-postgresql`，`container_name` 和 `hostname` 保持这个名字 |
| `netdisco-db-init` | `2.117000-backend` | 建库、写入 guest，跑完退出。退出码为 0 之后，网页和后端才会启动 |
| `netdisco-backend` | `2.117000-backend` | 采集守护进程 |
| `netdisco-web` | `2.117000-web` | 网页 |
| `netdisco-postgresql-13` | `2.117000-postgresql-13` | 带配置档 `with-pg-upgrade`。`docker compose up -d` 不会启动它 |

| 宿主机 | 容器内 | 用途 |
|--------|--------|------|
| **5000** | **5000** | 网页。本机打开 `http://127.0.0.1:5000` |
| 不映射 | **5432** | 数据库只在 Compose 网络里，主机名 `netdisco-postgresql` |
| `netdisco/config` | `/home/netdisco/environments` | `deployment.yml`。容器以 uid **901** 写入 |
| `netdisco/logs` | `/home/netdisco/logs` | 日志 |
| `netdisco/nd-site-local` | `/home/netdisco/nd-site-local` | 本地插件 |
| `netdisco/postgresql` | `/var/lib/postgresql` | 当前库文件。由数据库容器在首次启动时创建 |
| `netdisco/pgdata` | 见 Compose | 旧的 PostgreSQL 13 数据。新安装保持为空，不要往里面放文件 |

同目录如果有 `.env`，Compose 会用其中的 `NETDISCO_DOMAIN`、`NETDISCO_DB_HOST`、`NETDISCO_CURRENT_PG_VERSION`、`DEPLOY_ADMIN_USER`、`IPV` 替换文件里的默认值。数据库名、用户和口令在对应环境变量为空时，由镜像设为 **netdisco** / **netdisco** / **netdisco**。

1. 先看 5000 是否已有进程监听。有输出时，下一步把 `compose.yaml` 里 `5000:5000` 冒号左边改成空闲端口，浏览器地址跟着改。没有输出再继续：

```bash
sudo ss -lntp | grep -E ':5000' || true
```

2. 创建工作目录，并把容器要写的三个目录交给 uid **901**。数据库目录不要提前改成 901，交给数据库容器自己初始化：

```bash
sudo mkdir -p /www/wwwroot/netdisco
sudo chown -R "$USER":"$USER" /www/wwwroot/netdisco
cd /www/wwwroot/netdisco
mkdir -p netdisco/{logs,config,nd-site-local}
sudo chown -R 901:901 netdisco
```

3. 写入 `compose.yaml`：

```bash
cat > compose.yaml <<'EOF'
# https://docs.docker.com/compose/how-tos/environment-variables/envvars-precedence/
x-common-environment: &common-environment
  NETDISCO_DOMAIN: '${NETDISCO_DOMAIN:-discover}'
  NETDISCO_DB_TENANT:
  NETDISCO_DB_NAME:
  NETDISCO_DB_HOST: '${NETDISCO_DB_HOST:-netdisco-postgresql}'
  NETDISCO_DB_PORT:
  NETDISCO_DB_USER:
  NETDISCO_DB_PASS:
  NETDISCO_RO_COMMUNITY:
  PGDATABASE:
  PGHOST:
  PGPORT:
  PGUSER:
  PGPASSWORD:
  NETDISCO_CURRENT_PG_VERSION: '${NETDISCO_CURRENT_PG_VERSION:-18}'

services:

  netdisco-postgresql:
    container_name: netdisco-postgresql
    image: docker.xuanyuan.run/netdisco/netdisco:2.117000-postgresql
    restart: unless-stopped
    shm_size: 128mb
    hostname: netdisco-postgresql
    volumes:
      - "./netdisco/postgresql:/var/lib/postgresql"
    environment:
      <<: *common-environment
      NETDISCO_DB_SUPERUSER:

  netdisco-postgresql-13:
    container_name: netdisco-postgresql-13
    image: docker.xuanyuan.run/netdisco/netdisco:2.117000-postgresql-13
    shm_size: 128mb
    hostname: netdisco-postgresql-13
    volumes:
      - "./netdisco/pgdata:/var/lib/postgresql/data"
    environment:
      <<: *common-environment
      NETDISCO_DB_SUPERUSER:
    profiles:
      - with-pg-upgrade

  netdisco-db-init:
    container_name: netdisco-db-init
    image: docker.xuanyuan.run/netdisco/netdisco:2.117000-backend
    entrypoint: ''
    command: "/home/netdisco/bin/netdisco-env /home/netdisco/bin/netdisco-updatedb.sh"
    user: postgres
    depends_on:
      netdisco-postgresql:
        condition: service_healthy
    volumes:
      - "./netdisco/pgdata:/var/lib/pgversions/pg13"
      - "./netdisco/postgresql:/var/lib/pgversions/new"
      - "./netdisco/config:/home/netdisco/environments"
    environment:
      <<: *common-environment
      DEPLOY_ADMIN_USER: '${DEPLOY_ADMIN_USER:-YES}'
      NETDISCO_ADMIN_USER:
      NETDISCO_DB_DEPLOY_ARGS:

  netdisco-backend:
    container_name: netdisco-backend
    image: docker.xuanyuan.run/netdisco/netdisco:2.117000-backend
    restart: unless-stopped
    hostname: netdisco-backend
    depends_on:
      netdisco-db-init:
        condition: service_completed_successfully
    init: true
    volumes:
      - "./netdisco/nd-site-local:/home/netdisco/nd-site-local"
      - "./netdisco/config:/home/netdisco/environments"
      - "./netdisco/logs:/home/netdisco/logs"
    environment:
      <<: *common-environment
    dns_opt:
      - 'ndots:0'
      - 'timeout:1'
      - 'retries:0'
      - 'attempts:1'
      - edns0
      - trustad

  netdisco-web:
    container_name: netdisco-web
    image: docker.xuanyuan.run/netdisco/netdisco:2.117000-web
    restart: unless-stopped
    hostname: netdisco-web
    depends_on:
      netdisco-db-init:
        condition: service_completed_successfully
    init: true
    volumes:
      - "./netdisco/nd-site-local:/home/netdisco/nd-site-local"
      - "./netdisco/config:/home/netdisco/environments"
      - "./netdisco/logs:/home/netdisco/logs"
    environment:
      <<: *common-environment
      IPV: '${IPV:-4}'
      PORT:
    ports:
      - "5000:5000"
    dns_opt:
      - 'ndots:0'
      - 'timeout:1'
      - 'retries:0'
      - 'attempts:1'
      - edns0
      - trustad
EOF
```

4. 启动。数据库健康之后，初始化容器跑完并退出，网页和后端接着起来。宿主机重启后，数据库、后端和网页会自动拉起；初始化容器不设置重启策略：

```bash
docker compose up -d
docker compose ps -a
```

Ubuntu 24.04 实测：

```text
[+] up 5/5
 ✔ Network netdisco_default      Created
 ✔ Container netdisco-postgresql Healthy
 ✔ Container netdisco-db-init    Exited
 ✔ Container netdisco-backend    Started
 ✔ Container netdisco-web        Started

NAME                  IMAGE                                                       COMMAND                  SERVICE               CREATED          STATUS                     PORTS
netdisco-backend      docker.xuanyuan.run/netdisco/netdisco:2.117000-backend      "/home/netdisco/bin/…"   netdisco-backend      38 seconds ago   Up 4 seconds
netdisco-db-init      docker.xuanyuan.run/netdisco/netdisco:2.117000-backend      "/home/netdisco/bin/…"   netdisco-db-init      39 seconds ago   Exited (0) 6 seconds ago
netdisco-postgresql   docker.xuanyuan.run/netdisco/netdisco:2.117000-postgresql   "/usr/local/bin/netd…"   netdisco-postgresql   41 seconds ago   Up 36 seconds (healthy)    5432/tcp
netdisco-web          docker.xuanyuan.run/netdisco/netdisco:2.117000-web          "/home/netdisco/bin/…"   netdisco-web          38 seconds ago   Up 4 seconds               0.0.0.0:5000->5000/tcp, [::]:5000->5000/tcp
```

看这四项：`netdisco-postgresql` 为 healthy，`netdisco-db-init` 已退出且退出码为 0，`netdisco-backend` 和 `netdisco-web` 在运行。初始化还在跑时，后两项会暂时缺席，等一会儿再执行 `docker compose ps -a`。初始化退出码不是 0 时，先看 `docker compose logs netdisco-db-init`，不要删 `netdisco/postgresql`。

5. 等配置文件出现。这个文件由容器写入，出现之后再改：

```bash
test -f netdisco/config/deployment.yml && echo OK
```

打印 `OK` 再继续。没有打印时，确认 `netdisco/config` 属于 uid **901**，并查看 `docker compose logs netdisco-web`。

网页日志里会出现绑定 **5000** 和版本号 **2.117000**：

```bash
docker compose logs netdisco-web
```

Ubuntu 24.04 实测：

```text
netdisco-web  | Attempting to create directory /home/netdisco/perl5
netdisco-web  | config watcher: watching /home/netdisco/environments for updates.
netdisco-web  | 2026/11/02-07:13:38 Starman::Server (type Net::Server::PreFork) starting! pid(8)
netdisco-web  | Binding to TCP port 5000 on host * with IPv4
netdisco-web  | Setting gid to "901 901 901"
netdisco-web  | [13] 2026-11-02 07:13:40  warn App::Netdisco 2.117000 web
```

## 打开页面并发现设备

在服务器本机打开 `http://127.0.0.1:5000`。给局域网里的人用时，浏览器地址换成这台机器的地址，端口仍是 **5000**（若你改过宿主机端口，用改过的那个）。本文实测局域网地址是 **`http://192.168.1.35:5000/`**。此时 `no_auth` 仍是 true，能打开这个地址的人就是管理员。

页面右上角是 **guest**。下方 System Information 里，Statistics 还是 0 devices；右侧 Built using Open Source 显示 **App::Netdisco 2.117000**、PostgreSQL **16.6**。

![Netdisco 首页 Welcome：Find Anything、Discover 与 System Information，用户 guest](https://imgs.xuanyuan.cloud/docker/blog/netdisco/netdisco-1.webp)

设备使用 SNMP 只读团体字 `public` 时，在首页输入这台设备的地址，点 **Discover**。采集由后端容器发出。默认桥接网络会做地址转换，设备侧一般要允许这台宿主机访问 **UDP 161**。发现不会马上铺满整页，后端队列跑完后，设备、端口和地址才会出现。

也可以在 **Admin** 里打开 **Job Queue**，看 Discover、Discoverall、Macwalk 等任务是否在跑。实测里有一条 Discoverall 处于 Running，Macwalk 与 Stats 已 Done。

![Netdisco Job Queue：Discoverall Running，Macwalk 与 Stats Done](https://imgs.xuanyuan.cloud/docker/blog/netdisco/netdisco-3.webp)

团体字不是 `public` 时，先改 Compose 里的 `NETDISCO_RO_COMMUNITY`，写成实际只读团体字，再执行 `docker compose up -d`，然后回到首页点 Discover。不要把团体字提交到公开仓库。

注释里的默认定时是每天 **7:05** 做全网发现（discoverall），每小时第 **20** 分钟采集 MAC（macwalk），第 **50** 分钟采集 ARP（arpwalk）。按这个默认运行时，不用取消 `schedule` 的注释。要改频率，再编辑 `netdisco/config/deployment.yml` 里的这一段。保存后，守护进程会重新加载。

默认团体字只有只读。关闭端口、改 VLAN 或 PoE 会作用于现网设备，需要在 `device_auth` 里按文件里的注释另加一条 `write: true` 的团体字，并先在测试设备上做。

排障可以看 `netdisco/logs/`，也可以执行：

```bash
docker compose logs netdisco-backend
docker compose exec netdisco-backend netdisco-do
```

第二条不带动作时，会打印 `netdisco-do` 的用法。

## 改为登录后访问

能打开 5000 的人目前都拥有 guest 的完整权限。先建好自己的账号，再关闭免登录。顺序反了会进不去页面。

1. 在页面打开 **Admin**，进入 **User Management**。初次部署会看到用户 **guest**，Password 为 **Bypassed**，Administrator 已勾选。在上方空白行填写账号和口令，点 **+ Add**。先用这个账号能完成创建，再做下一步。

![Netdisco User Management：guest 为 Administrator，Password 为 Bypassed](https://imgs.xuanyuan.cloud/docker/blog/netdisco/netdisco-2.webp)

2. 把免登录关掉。Linux 上可以执行：

```bash
sudo sed -i 's/^no_auth: true$/no_auth: false/' netdisco/config/deployment.yml
sudo grep -n '^no_auth:' netdisco/config/deployment.yml
```

输出应是 `no_auth: false`。macOS 自带的 sed 参数不同，用编辑器改同一行即可。

3. 保存后守护进程会重新加载。再打开页面时，应要求登录，使用上一步的账号。页面仍是免登录时，执行：

```bash
docker compose restart netdisco-web netdisco-backend
```

## 升级

新安装的库在 `netdisco/postgresql`。以后只换同一大版本的镜像时，把 `compose.yaml` 里的 `2.117000-web`、`2.117000-backend`、`2.117000-postgresql` 改成同一组新版本号，然后执行：

```bash
cd /www/wwwroot/netdisco
docker compose pull
docker compose up -d
```

数据还在旧目录 `netdisco/pgdata`（PostgreSQL 13）时，再把 `2.117000-postgresql-13` 一起改成同一版本，并带上升级配置档：

```bash
docker compose down
docker compose --profile with-pg-upgrade pull
docker compose --profile with-pg-upgrade up --remove-orphans --force-recreate -d
```

这个配置档会启动 PostgreSQL 13 容器，把旧库迁到当前库，同时更新 Netdisco 的表结构。不要手工对调 `netdisco/postgresql` 和 `netdisco/pgdata`。

结构升级停住时，`netdisco-db-init` 会退出，网页和后端不会起来。日志里会给出要填写的参数。把它写进同目录的 `.env`，例如：

```bash
cat > .env <<'EOF'
NETDISCO_DB_DEPLOY_ARGS=--force-step 57
EOF
```

日志里的数字和上面的 57 不一致时，以日志为准。然后重新执行刚才的 `up` 命令。栈起来之后删掉这一行。留下 `--force-step` 只会告警；留下 `--redeploy-all` 会在每次启动时重放全部结构变更。

## 备选：docker run

没有 Compose 时，按下面的顺序启动同一组容器。已经用 Compose 跑着时，不要再执行这一节，容器名会冲突。

1. 目录和「Docker Compose 部署」里的第 2 步相同，并进入该目录。还没有名为 `netdisco` 的网络时再创建：

```bash
cd /www/wwwroot/netdisco
docker network create netdisco
```

2. 写入环境变量。空值保留，和 Compose 里的空变量一样，交给镜像使用默认的库名、用户和口令：

```bash
cat > netdisco.env <<'EOF'
NETDISCO_DOMAIN=discover
NETDISCO_DB_TENANT=
NETDISCO_DB_NAME=
NETDISCO_DB_HOST=netdisco-postgresql
NETDISCO_DB_PORT=
NETDISCO_DB_USER=
NETDISCO_DB_PASS=
NETDISCO_RO_COMMUNITY=
PGDATABASE=
PGHOST=
PGPORT=
PGUSER=
PGPASSWORD=
NETDISCO_CURRENT_PG_VERSION=18
EOF
```

3. 启动数据库。健康检查要解析主机名 `netdisco-postgresql`，所以 `--hostname` 和 `--name` 都用这个名字：

```bash
docker run -d 
  --name netdisco-postgresql 
  --hostname netdisco-postgresql 
  --network netdisco 
  --restart unless-stopped 
  --shm-size 128m 
  --env-file netdisco.env 
  -v "$PWD/netdisco/postgresql:/var/lib/postgresql" 
  docker.xuanyuan.run/netdisco/netdisco:2.117000-postgresql
```

4. 等到健康检查通过，再做初始化。一直不是 `healthy` 时，用 `docker logs netdisco-postgresql` 看原因，不要继续执行后面的容器：

```bash
for i in $(seq 1 40); do
  status="$(docker inspect -f '{{.State.Health.Status}}' netdisco-postgresql 2>/dev/null || true)"
  if [ "$status" = "healthy" ]; then
    break
  fi
  sleep 2
done
docker inspect -f '{{.State.Health.Status}}' netdisco-postgresql
```

最后一行应是 `healthy`。

5. 初始化数据库。这一步在前台跑完再退出，成功时命令结束且退出码为 0：

```bash
docker run --rm 
  --name netdisco-db-init 
  --network netdisco 
  --user postgres 
  --env-file netdisco.env 
  -e DEPLOY_ADMIN_USER=YES 
  -v "$PWD/netdisco/pgdata:/var/lib/pgversions/pg13" 
  -v "$PWD/netdisco/postgresql:/var/lib/pgversions/new" 
  -v "$PWD/netdisco/config:/home/netdisco/environments" 
  --entrypoint "" 
  docker.xuanyuan.run/netdisco/netdisco:2.117000-backend 
  /home/netdisco/bin/netdisco-env /home/netdisco/bin/netdisco-updatedb.sh
```

6. 启动后端和网页：

```bash
docker run -d 
  --name netdisco-backend 
  --hostname netdisco-backend 
  --network netdisco 
  --restart unless-stopped 
  --init 
  --env-file netdisco.env 
  --dns-opt ndots:0 
  --dns-opt timeout:1 
  --dns-opt retries:0 
  --dns-opt attempts:1 
  --dns-opt edns0 
  --dns-opt trustad 
  -v "$PWD/netdisco/nd-site-local:/home/netdisco/nd-site-local" 
  -v "$PWD/netdisco/config:/home/netdisco/environments" 
  -v "$PWD/netdisco/logs:/home/netdisco/logs" 
  docker.xuanyuan.run/netdisco/netdisco:2.117000-backend

docker run -d 
  --name netdisco-web 
  --hostname netdisco-web 
  --network netdisco 
  --restart unless-stopped 
  --init 
  --env-file netdisco.env 
  -e IPV=4 
  --dns-opt ndots:0 
  --dns-opt timeout:1 
  --dns-opt retries:0 
  --dns-opt attempts:1 
  --dns-opt edns0 
  --dns-opt trustad 
  -p 5000:5000 
  -v "$PWD/netdisco/nd-site-local:/home/netdisco/nd-site-local" 
  -v "$PWD/netdisco/config:/home/netdisco/environments" 
  -v "$PWD/netdisco/logs:/home/netdisco/logs" 
  docker.xuanyuan.run/netdisco/netdisco:2.117000-web
```

然后按「打开页面并发现设备」和「改为登录后访问」继续。改 `no_auth` 之后若页面没有变化，执行：

```bash
docker restart netdisco-web netdisco-backend
```

停掉这一组容器：

```bash
docker stop netdisco-web netdisco-backend netdisco-postgresql
docker rm netdisco-web netdisco-backend netdisco-postgresql
```

`netdisco/` 目录还在，库和配置都还在。确认可以清空时，再删整个 `/www/wwwroot/netdisco`。

## 常见问题

### 打开就是管理界面，没有登录框

`deployment.yml` 里 `no_auth: true` 时，页面以 **guest** 进入，并拥有完整管理权限。按「改为登录后访问」先建账号，再把这一行改成 `false`。

### 浏览器打不开页面

先看 `docker compose ps -a`。`netdisco-web` 应在运行，并且映射了宿主机 **5000**。初始化容器还没成功退出时，网页不会启动。本机用 `http://127.0.0.1:5000`。从别的机器访问时，放行 5000，并限制来源地址。

### config 目录里没有 deployment.yml

`netdisco/config` 需要 uid **901** 可写，容器才会把默认配置写出来。目录属于 root 时，执行 `sudo chown -R 901:901 netdisco`，再 `docker compose up -d`。不要先手写一份缺项的配置盖住镜像里的默认文件。

### Discover 之后没有设备

确认设备开放 **UDP 161**，并且只读团体字和 `NETDISCO_RO_COMMUNITY`（空着则是 `public`）一致。设备上的访问控制要允许这台宿主机。然后看 `netdisco/logs/` 和 `docker compose logs netdisco-backend`。

### 改了 deployment.yml 没有生效

保存这个文件后，守护进程会重新加载。页面仍是旧行为时，执行 `docker compose restart netdisco-web netdisco-backend`。改的是 Compose 环境变量时，用 `docker compose up -d` 重建容器，只 restart 不会读到新的环境变量。

### 关掉免登录之后进不去

还没有自己的账号就改了 `no_auth`。把该行改回 `no_auth: true`，重启网页和后端，用免登录进入并建好账号，再改回 `false`。

### 初始化容器退出后，网页没有起来

退出码不是 0 时，网页和后端会停在依赖上。执行 `docker compose logs netdisco-db-init`。结构升级失败时，按「升级」里的 `NETDISCO_DB_DEPLOY_ARGS` 处理。库目录已经初始化过之后，不要为了重试去删 `netdisco/postgresql`，除非确定这套数据可以放弃。

### 可以用 latest 吗

2026-11-02，`latest-web` 与 `2.117000-web` 是同一份镜像。下次发布后 `latest-*` 会改指向。本文命令使用 `2.117000`。

### 网页、后端和数据库的版本号要一致吗

要一致。网页、后端、数据库初始化和数据库使用同一组版本号，例如全部是 `2.117000`。`postgresql-13` 也用这一版本，新安装不启动它。

### 数据库端口放在哪里

数据库只留在 Compose 网络里，主机名是 `netdisco-postgresql`，不映射到宿主机。默认用户和口令都是 `netdisco`。要在第一次初始化之前改口令，在 `.env` 里设置 `NETDISCO_DB_PASS`，并保持以后启动都用这个值。库文件已经生成之后，只改变量不会改掉库里的口令。

要用已有的 PostgreSQL，官方提供 [compose.mixin.extpg.yaml](https://github.com/netdisco/netdisco-docker/blob/master/compose.mixin.extpg.yaml)。同一台机器上的库，主机名用 `host.docker.internal`，或设置 `NETDISCO_DB_HOST`。`with-pg-upgrade` 不负责外部数据库的大版本升级。

### 想清空重来

`docker compose down` 不会删除绑定挂载。确认 `netdisco/postgresql` 里的库可以放弃后，停掉容器，再删除整个 `/www/wwwroot/netdisco`。还要保留配置时，只删除 `netdisco/postgresql`。

## 命令速查

```bash
docker pull docker.xuanyuan.run/netdisco/netdisco:2.117000-web
docker pull docker.xuanyuan.run/netdisco/netdisco:2.117000-backend
docker pull docker.xuanyuan.run/netdisco/netdisco:2.117000-postgresql

cd /www/wwwroot/netdisco
docker compose up -d
docker compose ps -a
docker compose logs netdisco-db-init
docker compose logs netdisco-backend

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。网页是 `http://127.0.0.1:5000`。初次访问不登录；建好账号后把 `no_auth` 改成 `false`。数据库用户和口令默认都是 `netdisco`，端口不映射到宿主机。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [netdisco/netdisco 镜像页](https://xuanyuan.cloud/zh/r/netdisco/netdisco?xy_from=netdisco-docker-deploy) | [https://xuanyuan.cloud/zh/r/netdisco/netdisco](https://xuanyuan.cloud/zh/r/netdisco/netdisco?xy_from=netdisco-docker-deploy) |
| [netdisco/netdisco 概览](https://xuanyuan.cloud/r/netdisco/netdisco?xy_from=netdisco-docker-deploy) | [https://xuanyuan.cloud/r/netdisco/netdisco](https://xuanyuan.cloud/r/netdisco/netdisco?xy_from=netdisco-docker-deploy) |
| [netdisco/netdisco 标签列表](https://xuanyuan.cloud/r/netdisco/netdisco/tags?xy_from=netdisco-docker-deploy) | [https://xuanyuan.cloud/r/netdisco/netdisco/tags](https://xuanyuan.cloud/r/netdisco/netdisco/tags?xy_from=netdisco-docker-deploy) |
| [Docker Hub · netdisco/netdisco](https://hub.docker.com/r/netdisco/netdisco) | [https://hub.docker.com/r/netdisco/netdisco](https://hub.docker.com/r/netdisco/netdisco) |
| [GitHub · netdisco/netdisco](https://github.com/netdisco/netdisco) | [https://github.com/netdisco/netdisco](https://github.com/netdisco) |
| [GitHub · netdisco/netdisco-docker](https://github.com/netdisco/netdisco-docker) | [https://github.com/netdisco/netdisco-docker](https://github.com/netdisco/netdisco-docker) |
| [2.117000 发布说明](https://github.com/netdisco/netdisco/releases/tag/2.117000) | [https://github.com/netdisco/netdisco/releases/tag/2.117000](https://github.com/netdisco/netdisco/releases/tag/2.117000) |
| [配置项说明](https://github.com/netdisco/netdisco/wiki/Configuration) | [https://github.com/netdisco/netdisco/wiki/Configuration](https://github.com/netdisco/netdisco/wiki/Configuration) |
| [环境变量](https://github.com/netdisco/netdisco/wiki/Environment-Variables) | [https://github.com/netdisco/netdisco/wiki/Environment-Variables](https://github.com/netdisco/netdisco/wiki/Environment-Variables) |
| [项目首页](https://netdisco.org/) | [https://netdisco.org/](https://netdisco.org/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=netdisco-docker-deploy) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage?xy_from=netdisco-docker-deploy) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/netdisco-docker-deploy?xy_from=netdisco-docker-deploy)

*本文基于 [netdisco/netdisco:2.117000-web](https://xuanyuan.cloud/zh/r/netdisco/netdisco?xy_from=netdisco-docker-deploy)，以 **2.117000** 版本实测，System Information 显示 PostgreSQL **16.6**，测试平台 **Ubuntu 24.04** Linux。*


