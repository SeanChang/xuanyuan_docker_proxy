# 1Panel Docker 容器化部署指南：轻松管理你的 Linux 服务器

![1Panel Docker 容器化部署指南：轻松管理你的 Linux 服务器](https://imgs.xuanyuan.cloud/docker/blog/docker-1panel.png)

*分类: Docker部署教程 | 标签: linux,部署教程 | 发布时间: 2026-03-11 13:05:57*

> 1Panel 是开源的 Linux 服务器运维面板，用网页管理网站、数据库、容器、证书和备份。本文将通过 Docker Compose 部署社区镜像 moelin/1panel，用安全入口登录面板，适合把运维界面留在自己服务器上的场景。

## 1Panel 是什么

1Panel 是飞致云开源的 Linux 服务器运维管理面板，也是一个轻量的 AI 管理入口。网站、数据库、容器、文件、证书、计划和备份都在同一套网页里操作，用来代替逐条敲命令完成日常运维。

官方安装是在宿主机上跑安装脚本。本文用的是社区镜像 **`moelin/1panel`**：面板进程放在容器里，通过挂载 Docker 套接字管理宿主机上的容器，端口、账号和安全入口用环境变量设置。数据和它创建的应用目录留在挂载出来的宿主机路径里。

## 1Panel 能做什么

- **在网页里看主机**：负载、内存、磁盘和网卡流量集中在概览页。
- **管理容器和镜像**：查看容器，拉取镜像，用编排创建一组服务。
- **建站和管数据库**：应用商店安装网站程序、数据库和 Web 服务器，并配置证书。
- **做备份**：把站点、应用和数据库备份到本机或云存储。
- **收口安全设置**：防火墙、面板超时、运行环境区域和安全入口都在面板设置里。

## 为什么要使用 1Panel

命令行能管住一台 Linux，站点、证书、数据库和容器一多，配置就散在不同目录里。交给面板之后，这些对象有统一入口，备份和计划任务也不用各自写一套脚本。

把固定版本放进容器，数据目录留在宿主机，换机器时带走这个目录即可。适合想在自己的服务器上用网页做运维、又不想把面板装进系统包管理器的人。已经用官方脚本装好、并且运行稳定的，不必为了换成容器再迁一次。

## 使用 Docker 部署 1Panel

Docker 可以把这套面板跑起来。部署前准备好 Docker，并想好面板端口、管理员密码和安全入口。密码不要用示例里的原文，入口也不要留空。

接下来用 Docker Compose 写好网络、数据目录和环境变量，启动服务，再用带入口路径的地址登录。

## 环境要求

本文使用 **`moelin/1panel:v2.4.2`** 版本实测。测试平台是 Ubuntu 24.04（主机名 `ikuai-ubuntu2404`，架构 x86_64，本机地址 192.168.1.35）。面板右下角显示的版本是 **v2.4.2**。镜像提供 **linux/amd64**、**linux/arm64**、**linux/arm**、**linux/ppc64le**、**linux/s390x**。Docker Hub 上 amd64 压缩体积约 **187 MB**；面板镜像列表里这份本地镜像约 **767 MB**。

容器使用宿主机网络。面板端口由环境变量 `PORT` 决定，本文是 **10086**，不写 `ports` 映射。数据目录是宿主机 `/opt`，面板文件在 `/opt/1panel`。必须挂载 Docker 套接字，否则面板不能管理本机容器。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）。macOS 把 Compose 文件目录 `/www/wwwroot/1panel` 换成 `~/docker/1panel`；数据目录仍要和 `BASE_DIR` 一致 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64**、**linux/arm**、**linux/ppc64le**、**linux/s390x** |
| 磁盘 | 至少能放下镜像，并留出 `/opt/1panel` 以及以后安装的应用 |
| 端口 | 宿主机 **10086** 需空闲。这是 `PORT` 指定的监听端口，不是端口映射 |
| 工作目录 | Compose 文件放 `/www/wwwroot/1panel`；面板数据在 `/opt` |
| 账号 | 用户名 **`admin`**；密码由你设置。安全入口本文示例为 **`myentrance`** |

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

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=1panel-docker-linux)。

## 标签怎么选

新安装使用 **`v2.4.2`**。它是中国版 V2。`v2` 和 `latest` 在 2026-11-10 与 `v2.4.2` 的清单 digest 相同，下次发版会改指向，不写入本文命令。国际版是另一条标签线，digest 不同。

V1 与 V2 不能在面板里直接升级。已有 V1 数据继续用 V1 标签维护；要换到 V2，按文末的官方迁移说明来，不要点面板右下角的更新。

| 标签 | 说明 | 是否写入本文主命令 |
|------|------|------------------|
| **`v2.4.2`** | 中国版 V2，与本次面板显示版本一致 | **是** |
| `v2`、`latest` | 中国版浮动别名，当前与 `v2.4.2` 相同 | 否 |
| `global-v2.4.2` | 国际版 V2 | 需要国际版安装源时再换 |
| `v1.10.34-lts` | 中国版 V1，给已有 V1 数据继续用 | 仅「已有 V1 数据」 |
| `global-v1.10.34-lts` | 国际版 V1 | 否 |
| `v1`、`global-v1`、`global-v2` | 浮动别名 | 否 |

完整列表见 [标签列表](https://xuanyuan.cloud/r/moelin/1panel/tags?xy_from=1panel-docker-linux)。镜像说明见 [okxlin/docker-1panel](https://github.com/okxlin/docker-1panel)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud/?xy_from=1panel-docker-linux) **加速拉取**。

```bash
docker pull docker.xuanyuan.run/moelin/1panel:v2.4.2
```

Ubuntu 24.04 上，浮动标签 `v2` 的拉取结果与 `v2.4.2` 是同一份清单。输出如下：

```text
v2: Pulling from moelin/1panel
edafa32f5d9e: Pull complete
0fb531ebe58f: Pull complete
f3f25b84a7d7: Pull complete
266241b8a2f5: Pull complete
b09c0156f102: Pull complete
c1fd09137ed4: Pull complete
5afd565bb0e2: Pull complete
0494db36d3df: Pull complete
bd13d97e466e: Pull complete
44136fa355b3: Download complete
ca174e23b7fe: Download complete
Digest: sha256:79e4ca0938aa6fae0402c62cc5952f0b64771df92d2689f48d6a483ed4436e43
Status: Downloaded newer image for docker.xuanyuan.run/moelin/1panel:v2
docker.xuanyuan.run/moelin/1panel:v2
```

## 使用 Docker Compose 部署

先改密码。下面文件里的 `your_secure_password` 和 `myentrance` 只是示例，分别换成你的管理员密码和安全入口。入口不要带前后斜杠。

`BASE_DIR` 必须是宿主机上的真实目录，并且和卷的宿主机一侧相同。本文两边都是 `/opt`，面板会把数据写到 `/opt/1panel`。`/opt` 里如果已经有别的业务数据，先确认不会和 `1panel` 这个子目录冲突。

宿主机 **10086** 需要空闲。容器使用 host 网络，端口占用发生在宿主机上。

```bash
sudo mkdir -p /www/wwwroot/1panel
sudo chown -R "$USER":"$USER" /www/wwwroot/1panel
cd /www/wwwroot/1panel
cat > compose.yaml <<'EOF'
services:
  1panel:
    image: docker.xuanyuan.run/moelin/1panel:v2.4.2
    container_name: 1panel-v2
    restart: always
    network_mode: host
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /opt:/opt
    environment:
      - TZ=Asia/Shanghai
      - PORT=10086
      - USERNAME=admin
      - PASSWORD=your_secure_password
      - ENTRANCE=myentrance
      - BASE_DIR=/opt
    labels:
      createdBy: Apps
EOF
docker compose up -d
docker compose ps
```

这次在同一台主机上用相同的镜像、卷和环境变量启动过，容器 ID：

```text
47c3d20d20d3a6237b548f733bd8f7b7866a9b43ee72c128e06484c002dbf561
```

`/opt/1panel` 里如果已经有面板数据，启动时会沿用原来的用户名、密码、端口和入口，环境变量不会覆盖。处理方式见「已有数据时入口和密码没变」。

## 打开安全入口

浏览器要打开的是带入口的地址，不是端口根路径。按本文示例：

`http://192.168.1.35:10086/myentrance`

把 `192.168.1.35` 换成你的服务器地址。用户名是 `USERNAME`，本文为 **admin**。密码是你写进 `PASSWORD` 的那一串。

只打开 `http://192.168.1.35:10086/` 时，页面会停留在安全入口拦截页，英文原文是：

```text
Access Temporarily Unavailable
The current environment has enabled secure login access.

Run the following SSH command to view the panel login URL:

1pctl user-info
```

中文界面下对应「暂时无法访问 / 当前环境已经开启了安全入口登录」。这表示面板已经在听 **10086**，根路径被入口拦住了。把 `ENTRANCE` 的值接在端口后面即可。

`1pctl` 装在容器里。在宿主机上直接执行会提示 `Command '1pctl' not found`。要核对实际入口、用户名和密码时，在容器里执行：

```bash
docker exec -it 1panel-v2 1pctl user-info
```

输出里的入口路径接到 `http://服务器IP:10086/` 后面。随机密码写在容器日志里：

```bash
docker logs 1panel-v2
```

未设置密码，或密码仍是默认的 `1panel_password` 时，首次启动会生成随机密码，只能从这段日志里看。本文设置了自定义密码，登录用你自己写的那一串。

## 登录并改成中文

用入口地址登录后，概览页会显示主机名、系统和资源占用。这次主机名是 `ikuai-ubuntu2404`，右下角版本是 v2.4.2。

![1Panel 概览：主机名 ikuai-ubuntu2404、负载与内存，右下角版本 v2.4.2](https://imgs.xuanyuan.cloud/docker/blog/1panel/1panel-1.webp)

界面若是英文，打开左侧「面板设置」。在「面板」页把系统语言改成 **中文（简体）**，运行环境保持 **中国大陆 / 国际通用区域（默认）**。超时时间、面板别名也在这一页。

![1Panel 面板设置：系统语言为中文（简体），运行环境为中国大陆 / 国际通用区域](https://imgs.xuanyuan.cloud/docker/blog/1panel/1panel-2.webp)

右下角的「更新」不要点。这个镜像把特定版本的程序打进了镜像里，面板内更新会和镜像版本不一致。要换版本时，改 Compose 里的标签，再 `docker compose up -d`，并保留 `/opt` 这卷。

## 在面板里拉取镜像

一键安装脚本会给 Docker 配好加速。面板里还可以单独指定镜像加速地址：进入「容器 → 配置 → 镜像加速」。

Docker Hub 镜像填写 `https://***.xuanyuan.run`，把 `***` 换成你在轩辕镜像个人中心的专属前缀。GHCR 用 `https://***-ghcr.xuanyuan.run`，Quay 用 `https://***-quay.xuanyuan.run`。不要把 `ghcr.io` 或 `quay.io` 写进主站这个加速地址里。

![1Panel 容器配置：镜像加速弹窗，Docker 已启用](https://imgs.xuanyuan.cloud/docker/blog/1panel/1panel-3.webp)

保存后，在「容器 → 镜像」里拉取 Hub 镜像。这次填的是 `docker.io/nginx`。

![1Panel 拉取镜像：仓库选 Docker Hub，镜像名 docker.io/nginx](https://imgs.xuanyuan.cloud/docker/blog/1panel/1panel-4.webp)

拉取会记到轩辕镜像的拉取日志里。这次日志中的镜像名是 `library/nginx`，状态码 **200**。

![轩辕镜像拉取日志：library/nginx，仓库 Docker Hub，状态码 200](https://imgs.xuanyuan.cloud/docker/blog/1panel/1panel-5.webp)

面板任务日志在全部层完成之后显示拉取成功。

![1Panel 镜像任务：nginx 各层 Pull complete，任务结束](https://imgs.xuanyuan.cloud/docker/blog/1panel/1panel-6.webp)

回到镜像列表，能看到正在使用的 1Panel 镜像，以及未使用的 `nginx:latest`。

![1Panel 镜像列表：1Panel 镜像为已使用，nginx:latest 为未使用](https://imgs.xuanyuan.cloud/docker/blog/1panel/1panel-7.webp)

同样的步骤可以再拉一个数据库镜像。这次镜像名是 `docker.io/mysql`。

![1Panel 拉取镜像：镜像名 docker.io/mysql](https://imgs.xuanyuan.cloud/docker/blog/1panel/1panel-8.webp)

![1Panel 镜像任务：mysql 拉取成功并结束](https://imgs.xuanyuan.cloud/docker/blog/1panel/1panel-9.webp)

![1Panel 镜像列表：新增未使用的 mysql:latest](https://imgs.xuanyuan.cloud/docker/blog/1panel/1panel-10.webp)

## 用编排创建容器

「容器 → 编排」可以按 Compose 文件创建一组容器。面板把项目写到 `/opt/1panel/docker/compose/项目名/`。这次项目名是 `test`，任务日志里拉取了 `louislam/uptime-kuma:2.5.7`，并提示该文件里的 `version` 字段已经过时。本文前面的 Compose 不写 `version`。

![1Panel 编排任务：拉取 uptime-kuma 2.5.7，并提示 version 字段已过时](https://imgs.xuanyuan.cloud/docker/blog/1panel/1panel-11.webp)

网络和容器创建完成后，任务以启动成功结束。

![1Panel 编排任务：uptime-kuma 容器已启动，任务结束](https://imgs.xuanyuan.cloud/docker/blog/1panel/1panel-12.webp)

## 备选：docker run

没有 Compose 时，用下面的命令。密码和入口同样先换成你自己的。参数与上一节的 Compose 一致。

```bash
docker run -d 
  --name 1panel-v2 
  --restart always 
  --network host 
  -v /var/run/docker.sock:/var/run/docker.sock 
  -v /opt:/opt 
  -e TZ=Asia/Shanghai 
  -e PORT=10086 
  -e USERNAME=admin 
  -e PASSWORD=your_secure_password 
  -e ENTRANCE=myentrance 
  -e BASE_DIR=/opt 
  docker.xuanyuan.run/moelin/1panel:v2.4.2
```

登录地址仍是 `http://服务器IP:10086/myentrance`。查看入口：

```bash
docker exec -it 1panel-v2 1pctl user-info
```

## 已有 V1 数据

V2 相对 V1 架构变了，官方说明目前不能从 V1 在线直接升级到 V2。容器里的 V1 也不要在面板里点升级。

只继续维护 V1 时，镜像用 **`v1.10.34-lts`**。环境变量从这一版才生效。旧部署再保留 `/var/lib/docker/volumes` 和 `/root` 两个挂载。本文这次启动验证的是 V2，下面这段是镜像给出的 V1 维护方式：

```bash
sudo mkdir -p /www/wwwroot/1panel
sudo chown -R "$USER":"$USER" /www/wwwroot/1panel
cd /www/wwwroot/1panel
cat > compose.yaml <<'EOF'
services:
  1panel:
    image: docker.xuanyuan.run/moelin/1panel:v1.10.34-lts
    container_name: 1panel
    restart: always
    network_mode: host
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
      - /opt:/opt
      - /root:/root
    environment:
      - TZ=Asia/Shanghai
      - PORT=10086
      - USERNAME=admin
      - PASSWORD=your_secure_password
      - ENTRANCE=myentrance
      - BASE_DIR=/opt
    labels:
      createdBy: Apps
EOF
docker compose up -d
```

确定要从 Docker 里的 V1 迁到 V2 时，先备份 `/opt/1panel`。镜像项目提供了从 Docker 运行切回宿主机运行的脚本，切过去之后再按官方迁移工具升级：

```bash
wget -O 1panel_docker_to_sys.sh https://raw.githubusercontent.com/okxlin/ToolScript/refs/heads/main/1Panel/1panel-execution-mode/1panel_docker_to_sys.sh
chmod +x 1panel_docker_to_sys.sh
bash 1panel_docker_to_sys.sh
```

国内下载：

```bash
wget -O 1panel_docker_to_sys.sh https://cdn.jsdelivr.net/gh/okxlin/ToolScript@main/1Panel/1panel-execution-mode/1panel_docker_to_sys.sh
chmod +x 1panel_docker_to_sys.sh
bash 1panel_docker_to_sys.sh
```

升级说明和操作步骤见 [从 V1 版本升级](https://docs.fit2cloud.com/1panel/installation/v1-migrate/) 与 [操作步骤](https://docs.fit2cloud.com/1panel/installation/v1-migrate-steps/)。迁移工具仓库是 [1Panel-dev/1panel-migrator](https://github.com/1Panel-dev/1panel-migrator)。官方文档写明：升级会清空 V1 的网站、应用和数据库备份记录，自定义过的 OpenResty 主配置要事先备份。

## 备份与更换版本

备份整个数据目录：

```bash
sudo tar -C /opt -czf /root/1panel-opt-$(date +%F).tar.gz 1panel
```

按镜像说明，V2 的库在 `/opt/1panel/db/core.db` 和 `/opt/1panel/db/agent.db`。V1 的库在 `/opt/1panel/db/1Panel.db`。

更换版本时只改 `compose.yaml` 里的标签，保留 `/opt` 这卷，然后：

```bash
cd /www/wwwroot/1panel
docker compose pull
docker compose up -d
```

容器内不要点面板更新。`docker compose down` 默认不删宿主机上的 `/opt`。不要把 `/opt/1panel` 删掉，除非你确认要清空面板数据。

## 常见问题

### 打开端口只有 Access Temporarily Unavailable

面板已经起来了。根路径 `http://IP:10086/` 会被安全入口拦住。地址改成 `http://IP:10086/你的入口`。本文示例入口是 `myentrance`。

入口和启动时写的不一致时，在容器里查看：

```bash
docker exec -it 1panel-v2 1pctl user-info
```

### 宿主机提示 1pctl: command not found

这条命令在容器里。用上一节的 `docker exec`。宿主机不需要再 `apt install` 一个同名包。

### 环境变量里的密码和入口没有生效

容器用 `/opt/1panel/.docker_initialized` 判断是不是已经初始化过。标记文件已经在，再次启动会保留原来的账号、密码、端口和入口。

要按当前环境变量重写这四项时，先停掉容器，在原来的 `docker run` 或 Compose 环境里加上 `RESET=true`，启动一次。确认新入口可以登录后，再去掉 `RESET`，避免每次启动都重写。`RESET` 改的是账号、密码、端口和入口。

想保留已有账号、只是换了一台新容器时，不要设置 `RESET=true`。数据库在、标记文件不在时，入口脚本会按首次初始化处理。需要保住原密码时，先放上标记文件再启动：

```bash
sudo touch /opt/1panel/.docker_initialized
```

### 忘记密码

密码是你自定义的那一串时，用「环境变量里的密码和入口没有生效」里的 `RESET=true` 重写。首次启动生成的随机密码在 `docker logs 1panel-v2` 里。

### 页面打不开，连接被拒绝

先看容器是否在跑：

```bash
docker ps --filter name=1panel-v2
docker logs --tail=80 1panel-v2
```

容器在跑、但浏览器连不上时，检查宿主机防火墙是否放行 `PORT`（本文 **10086**）。云服务器再核对安全组。能打开安全入口拦截页，说明端口已经通了，下一步是补入口路径。

### 为什么不用宿主机 3000

本文端口是 **10086**，由 `PORT` 指定，容器走 host 网络。不要改成宿主机 **3000**，本机前端开发经常占用这个端口。

### 可以用 v2 或 latest 吗

可以拉到当前镜像，但下次发版这两个标签会改指向。本文命令使用 **`v2.4.2`**。说明见「标签怎么选」。

### 国际版怎么换

把镜像标签换成 `global-v2.4.2`，容器名换成别的，避免和中国版抢同一个 `PORT`。国际版与中国版的 digest 不同，不要混用数据目录。

## 命令速查

```bash
docker pull docker.xuanyuan.run/moelin/1panel:v2.4.2

cd /www/wwwroot/1panel
docker compose up -d
docker compose ps
docker logs --tail=80 1panel-v2

# 浏览器打开 http://服务器IP:10086/myentrance
docker exec -it 1panel-v2 1pctl user-info

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。用户名是 **admin**，密码和安全入口以你写进环境变量的值为准。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [moelin/1panel 镜像页](https://xuanyuan.cloud/zh/r/moelin/1panel?xy_from=1panel-docker-linux) | [https://xuanyuan.cloud/zh/r/moelin/1panel](https://xuanyuan.cloud/zh/r/moelin/1panel?xy_from=1panel-docker-linux) |
| [moelin/1panel 概览](https://xuanyuan.cloud/r/moelin/1panel?xy_from=1panel-docker-linux) | [https://xuanyuan.cloud/r/moelin/1panel](https://xuanyuan.cloud/r/moelin/1panel?xy_from=1panel-docker-linux) |
| [moelin/1panel 标签列表](https://xuanyuan.cloud/r/moelin/1panel/tags?xy_from=1panel-docker-linux) | [https://xuanyuan.cloud/r/moelin/1panel/tags](https://xuanyuan.cloud/r/moelin/1panel/tags?xy_from=1panel-docker-linux) |
| [Docker Hub · moelin/1panel](https://hub.docker.com/r/moelin/1panel) | [https://hub.docker.com/r/moelin/1panel](https://hub.docker.com/r/moelin/1panel) |
| [GitHub · okxlin/docker-1panel](https://github.com/okxlin/docker-1panel) | [https://github.com/okxlin/docker-1panel](https://github.com/okxlin/docker-1panel) |
| [1Panel 产品介绍](https://docs.fit2cloud.com/1panel/product-intro/) | [https://docs.fit2cloud.com/1panel/product-intro/](https://docs.fit2cloud.com/1panel/product-intro/) |
| [1Panel 在线安装](https://docs.fit2cloud.com/1panel/installation/online-installation/) | [https://docs.fit2cloud.com/1panel/installation/online-installation/](https://docs.fit2cloud.com/1panel/installation/online-installation/) |
| [从 V1 版本升级](https://docs.fit2cloud.com/1panel/installation/v1-migrate/) | [https://docs.fit2cloud.com/1panel/installation/v1-migrate/](https://docs.fit2cloud.com/1panel/installation/v1-migrate/) |
| [V1 升级操作步骤](https://docs.fit2cloud.com/1panel/installation/v1-migrate-steps/) | [https://docs.fit2cloud.com/1panel/installation/v1-migrate-steps/](https://docs.fit2cloud.com/1panel/installation/v1-migrate-steps/) |
| [1pctl 命令行工具](https://docs.fit2cloud.com/1panel/installation/cli/) | [https://docs.fit2cloud.com/1panel/installation/cli/](https://docs.fit2cloud.com/1panel/installation/cli/) |
| [GitHub · 1Panel-dev/1Panel](https://github.com/1Panel-dev/1Panel) | [https://github.com/1Panel-dev/1Panel](https://github.com/1Panel-dev/1Panel) |
| [GitHub · 1panel-migrator](https://github.com/1Panel-dev/1panel-migrator) | [https://github.com/1Panel-dev/1panel-migrator](https://github.com/1Panel-dev/1panel-migrator) |
| [1Panel 官网](https://1panel.cn/) | [https://1panel.cn/](https://1panel.cn/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=1panel-docker-linux) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage?xy_from=1panel-docker-linux) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/1panel-docker-linux?xy_from=1panel-docker-linux)

*本文基于 [moelin/1panel:v2.4.2](https://xuanyuan.cloud/zh/r/moelin/1panel?xy_from=1panel-docker-linux)，以 **v2.4.2** 版本实测，测试平台 **Ubuntu 24.04** Linux。*


