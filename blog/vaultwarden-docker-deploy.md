# Docker 部署 Vaultwarden：轻松搭建私有化密码管理平台

![Docker 部署 Vaultwarden：轻松搭建私有化密码管理平台](https://imgs.xuanyuan.cloud/docker/blog/vaultwarden/vaultwarden.webp)

*分类: Docker部署教程 | 标签: Vaultwarden,vaultwarden/server,Docker,Nginx,轩辕镜像,密码管理,Bitwarden,私有化部署,部署教程 | 发布时间: 2026-11-03 14:06:45*

> Vaultwarden 是兼容 Bitwarden 客户端的轻量密码管理服务端，用 Rust 实现，适合自托管部署。本文将介绍如何通过 Docker Compose 与 Nginx 部署 vaultwarden/server，搭建可在浏览器注册使用的私有密码库，适合家用 NAS、内网自建，以及需要继续使用官方 Bitwarden 应用的场景。

## Vaultwarden 是什么

Vaultwarden 是兼容 Bitwarden 客户端 API 的非官方服务端，用 Rust 编写，面向自托管。它自带 Web 密码库，也可对接官方 Bitwarden 手机、桌面和浏览器扩展。

与官方 Bitwarden 服务端相比，它更轻，单容器即可跑常用功能。它不是 Bitwarden 公司产品，但协议兼容，客户端用法与连官方服务器时基本一致。

## Vaultwarden 能做什么

- **自托管密码库**：把保险库数据保存在本机卷上，备份与访问边界由自己控制。
- **兼容 Bitwarden 客户端**：用官方手机、桌面和浏览器扩展连接自建地址。
- **浏览器 Web 库**：在网页里注册、登录，并管理登录项等条目。
- **安全发送 Send**：创建限时文本或文件链接，用于分享敏感信息。
- **生成器与报告**：在网页里生成密码，并查看弱密码、重复使用等检查项。

## 为什么要使用 Vaultwarden

口令若都放在第三方云端，迁移、备份和访问策略都受服务商约束。家用 NAS 和内网机器长期在线，却常常缺一个能接上常用客户端的密码库服务端。

Vaultwarden 把服务收成容器，数据落在本机目录。适合要自建密码库、又想继续用 Bitwarden 客户端的人，也适合小团队内网私有化。

## 使用 Docker 部署 Vaultwarden

Vaultwarden 可以用 Docker 启动，不必在宿主机单独装一套服务端运行时。部署前准备好 Docker，并规划数据目录和 HTTPS 入口。

接下来先用 Compose 确认服务能起来，再加入 Nginx 做 HTTPS 反代，最后在浏览器里注册并关闭开放注册。

## 环境要求

本文使用 **`vaultwarden/server:1.37.5`** 与 **`library/nginx:1.28.0-alpine`** 版本实测。测试平台是 Ubuntu 24.04（主机名 `ikuai-ubuntu2404`）。`1.37.5` 与同日推送的 `latest` 当前指向同一索引；下次发版后 `latest` 会改指向，本文仍固定 `1.37.5`。Docker Hub 上 Vaultwarden **linux/amd64** 压缩体积约 **88.5 MB**，另有 arm64 / arm/v7 / arm/v6。实测 Web 库页脚为 **Vaultwarden Web 2026.10.1**。

容器内 Vaultwarden 听 **80**（明文）。Web 库依赖浏览器安全上下文，**不能**把明文 `http://IP:端口` 当正式入口；本文最终用 Nginx 在宿主机 **11443** 提供 HTTPS。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文按 Ubuntu 目录）；macOS 把 `/www/wwwroot/vaultwarden` 换成 `~/docker/vaultwarden` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64**、**linux/arm/v7**、**linux/arm/v6** |
| 内存 | 建议 ≥ **256 MB** 可用 |
| 磁盘 | 镜像约数十至上百 MB，另加 `data`、`ssl` 空间 |
| 端口 | 探活可用 **11001→80**；Web 库用 **11443→443**（Nginx） |
| 工作目录 | `/www/wwwroot/vaultwarden` |
| 账号 | 无默认密码；在 HTTPS 入口自行注册 |

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

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=vaultwarden-docker-deploy)。

## 标签怎么选

新安装使用 Vaultwarden **`1.37.5`**、Nginx **`1.28.0-alpine`**。不要把 `latest` 写进 Compose。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`1.37.5`** | Vaultwarden 当前发行版（Debian 底） | **是** |
| **`1.28.0-alpine`** | Nginx 稳定线 Alpine 变体 | **是** |
| `1.37.5-alpine` | 同版本 Vaultwarden Alpine 底，更小 | 否。改用时同步改拉取与 Compose |
| `1.37.4` 及更早 | 更早 Vaultwarden | 否 |
| `latest` / `stable-alpine` 等 | 浮动标签 | 否 |
| `testing` / `testing-alpine` | Vaultwarden 测试线 | 否 |

Vaultwarden 标签见 [标签列表](https://xuanyuan.cloud/r/vaultwarden/server/tags?xy_from=vaultwarden-docker-deploy)。发布说明见 [1.37.5](https://github.com/dani-garcia/vaultwarden/releases/tag/1.37.5)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud/?xy_from=vaultwarden-docker-deploy) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/vaultwarden/server:1.37.5
```

Ubuntu 24.04 上拉取完成：

```text
1.37.5: Pulling from vaultwarden/server
88b906c6a864: Pull complete
6fc242d221a6: Pull complete
4319820c19d0: Pull complete
9eaeeea3b170: Pull complete
d927b0341946: Pull complete
44136fa355b3: Download complete
f0aea1dcd1c5: Download complete
Digest: sha256:4fe17f415f90087377d37c755e0ea3cf189dcc6794e49cdd2a9adbb4937d9e1f
Status: Downloaded newer image for docker.xuanyuan.run/vaultwarden/server:1.37.5
docker.xuanyuan.run/vaultwarden/server:1.37.5
```

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq?xy_from=vaultwarden-docker-deploy)。Nginx 镜像在后文反代节再拉。

## Docker Compose 部署

工作目录：Linux **`/www/wwwroot/vaultwarden`**。macOS 用 **`~/docker/vaultwarden`**。

本阶段先单独启动 Vaultwarden，用日志和 `curl` 确认进程正常。浏览器此时还不能完成注册，见下一节。

| 宿主机目录 | 容器内路径 | 用途 |
|------------|------------|------|
| `data/` | `/data` | 数据库、附件、RSA 密钥、图标缓存等 |

### 1. 创建目录

```bash
sudo mkdir -p /www/wwwroot/vaultwarden/data
sudo chown -R "$USER":"$USER" /www/wwwroot/vaultwarden
cd /www/wwwroot/vaultwarden
```

macOS：

```bash
mkdir -p ~/docker/vaultwarden/data
cd ~/docker/vaultwarden
```

### 2. 写入 compose.yaml

`11001:80` 表示宿主机 **11001** 对应容器内 **80**。`SIGNUPS_ALLOWED` 先保持 `true`，等 HTTPS 就绪并建号后再改为 `false`。

```bash
cat > compose.yaml <<'EOF'
services:
  vaultwarden:
    image: docker.xuanyuan.run/vaultwarden/server:1.37.5
    container_name: vaultwarden
    restart: unless-stopped
    ports:
      - "11001:80"
    environment:
      SIGNUPS_ALLOWED: "true"
      TZ: Asia/Shanghai
    volumes:
      - ./data:/data
EOF
```

| 配置 | 说明 |
|------|------|
| `image` | 标签 `1.37.5` |
| `11001:80` | 宿主机 **11001** → 容器 **80**，仅作探活 |
| `SIGNUPS_ALLOWED` | 允许注册；建号后改为 `false` |
| `TZ` | 时区，本文为 `Asia/Shanghai` |
| `./data` | 持久化数据 |

自 **1.31.0** 起，WebSocket 已走主端口 **80**，不必再映射 **3012**，也不要写已废弃的 `WEBSOCKET_ENABLED`。

### 3. 启动并确认状态

```bash
docker compose up -d
docker compose ps
```

这次启动完成：

```text
[+] up 2/2
 ✔ Network vaultwarden_default Created
 ✔ Container vaultwarden       Started

NAME          IMAGE                                           COMMAND       SERVICE       CREATED         STATUS                            PORTS
vaultwarden   docker.xuanyuan.run/vaultwarden/server:1.37.5   "/start.sh"   vaultwarden   5 seconds ago   Up 4 seconds (health: starting)   0.0.0.0:11001->80/tcp, [::]:11001->80/tcp
```

再看日志：

```bash
docker compose logs --no-color --tail=80 vaultwarden
```

这次日志是：

```text
vaultwarden  | /--------------------------------------------------------------------
vaultwarden  | |                        Starting Vaultwarden                        |
vaultwarden  | |                           Version 1.37.5                           |
vaultwarden  | |--------------------------------------------------------------------|
vaultwarden  | | This is an *unofficial* Bitwarden implementation, DO NOT use the   |
vaultwarden  | | official channels to report bugs/features, regardless of client.   |
vaultwarden  | | Send usage/configuration questions or feature requests to:         |
vaultwarden  | |   https://github.com/dani-garcia/vaultwarden/discussions or        |
vaultwarden  | |   https://vaultwarden.discourse.group/                             |
vaultwarden  | | Report suspected bugs/issues in the software itself at:            |
vaultwarden  | |   https://github.com/dani-garcia/vaultwarden/issues/new            |
vaultwarden  | --------------------------------------------------------------------/
vaultwarden  |
vaultwarden  | [2026-11-03 13:39:57.700][vaultwarden::auth][INFO] Private key 'data/rsa_key.pem' created correctly
vaultwarden  | [2026-11-03 13:40:00.922][start][INFO] Rocket has launched from http://0.0.0.0:80
```

看到 `Version 1.37.5` 与 `Rocket has launched from http://0.0.0.0:80` 即可。首次启动会在 `data/` 下生成 `rsa_key.pem`。

本机探测：

```bash
curl -I http://127.0.0.1:11001
```

这次返回：

```text
HTTP/1.1 200 OK
server: Rocket
x-frame-options: SAMEORIGIN
x-content-type-options: nosniff
```

**200** 只说明 HTTP 服务在听。接下来看浏览器直连会发生什么。

## 浏览器直连 HTTP 会报错（预期现象）

打开：

```text
http://你的服务器IP:11001
```

实测中，左上角会出现英文提示：未使用安全上下文，Subtle Crypto API 需要启用 HTTPS。此时无法正常注册或解锁。

![Vaultwarden 用 HTTP 打开：提示需要启用 HTTPS 才能使用 Subtle Crypto](https://imgs.xuanyuan.cloud/docker/blog/vaultwarden/vaultwarden-22.webp)

若写成 `https://服务器IP:11001`，会报 `ERR_SSL_PROTOCOL_ERROR`：**11001** 上没有 TLS。

**11001** 只用于确认容器起来；Web 库入口按下一节改为 Nginx 的 HTTPS。

## Nginx 反向代理启用 HTTPS

用 **`library/nginx:1.28.0-alpine`** 终止 TLS，再反代到 Vaultwarden 的 **80**。内网可用自签证书：浏览器会提示证书不受信任，选择继续访问后即可进入安全上下文。

下文以 **`192.168.1.35`**、HTTPS 端口 **`11443`** 为例。把 IP 换成你的；改端口时同步改映射、`DOMAIN` 和浏览器地址。

### 1. 拉取 Nginx 镜像

```bash
docker pull docker.xuanyuan.run/library/nginx:1.28.0-alpine
```

Ubuntu 24.04 上拉取完成：

```text
1.28.0-alpine: Pulling from library/nginx
3e300a7cb18c: Pull complete
f637881d1138: Pull complete
b8554c5f1ad0: Pull complete
8e049f0fd151: Pull complete
71a39d0d04b2: Pull complete
c4fca37af7b3: Pull complete
bc1d7488b05e: Pull complete
e6918dcfd20d: Pull complete
cc7884611f32: Download complete
a48e28c27c4a: Download complete
Digest: sha256:30f1c0d78e0ad60901648be663a710bdadf19e4c10ac6782c235200619158284
Status: Downloaded newer image for docker.xuanyuan.run/library/nginx:1.28.0-alpine
docker.xuanyuan.run/library/nginx:1.28.0-alpine
```

只拉镜像、不改 `compose.yaml`，再执行 `docker compose up -d` 仍会是单个 `vaultwarden`。须先完成证书、配置和 Compose 更新。

### 2. 生成自签证书

把 `VW_HOST` 换成你的 IP：

```bash
cd /www/wwwroot/vaultwarden
VW_HOST=192.168.1.35
mkdir -p ssl nginx
openssl req -x509 -nodes -newkey rsa:2048 
  -keyout ssl/key.pem 
  -out ssl/cert.pem 
  -days 3650 
  -subj "/CN=${VW_HOST}" 
  -addext "subjectAltName=IP:${VW_HOST}"
chmod 644 ssl/cert.pem
chmod 600 ssl/key.pem
```

已有 Let's Encrypt 等证书时，把证书与私钥放到 `ssl/`，并在 Nginx 配置里改文件名；`DOMAIN` 写成 `https://你的域名`（默认 **443** 可不带端口）。

### 3. 写入 Nginx 配置

上游使用 Compose 服务名 `vaultwarden:80`：

```bash
cat > nginx/default.conf <<'EOF'
upstream vaultwarden-default {
  zone vaultwarden-default 64k;
  server vaultwarden:80;
  keepalive 2;
}

map $http_upgrade $connection_upgrade {
  default upgrade;
  ''      "";
}

server {
  listen 443 ssl;
  listen [::]:443 ssl;
  http2 on;
  server_name _;

  ssl_certificate     /etc/nginx/certs/cert.pem;
  ssl_certificate_key /etc/nginx/certs/key.pem;

  client_max_body_size 525M;

  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection $connection_upgrade;
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Proto $scheme;

  location / {
    proxy_pass http://vaultwarden-default;
  }
}
EOF
```

### 4. 更新 compose.yaml

覆盖为双服务：Vaultwarden 不再映射宿主机端口，只给 Nginx 访问；对外只暴露 **11443→443**。`DOMAIN` 中的 IP 须与证书、浏览器地址一致：

```bash
cd /www/wwwroot/vaultwarden
cat > compose.yaml <<'EOF'
services:
  vaultwarden:
    image: docker.xuanyuan.run/vaultwarden/server:1.37.5
    container_name: vaultwarden
    restart: unless-stopped
    environment:
      DOMAIN: "https://192.168.1.35:11443"
      SIGNUPS_ALLOWED: "true"
      TZ: Asia/Shanghai
    volumes:
      - ./data:/data

  nginx:
    image: docker.xuanyuan.run/library/nginx:1.28.0-alpine
    container_name: vaultwarden-nginx
    restart: unless-stopped
    depends_on:
      - vaultwarden
    ports:
      - "11443:443"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
      - ./ssl:/etc/nginx/certs:ro
EOF
```

| 配置 | 说明 |
|------|------|
| `DOMAIN` | 与浏览器地址完全一致，含协议和端口 |
| Vaultwarden 无 `ports` | 不再对外暴露明文 **11001** |
| `11443:443` | 宿主机 HTTPS 入口 |
| `nginx` 镜像 | `1.28.0-alpine` |

### 5. 启动并确认

确认文件齐全后启动：

```bash
cd /www/wwwroot/vaultwarden
ls ssl/cert.pem ssl/key.pem nginx/default.conf
docker compose up -d
docker compose ps
```

这次启动完成：

```text
[+] up 2/2
 ✔ Container vaultwarden       Started
 ✔ Container vaultwarden-nginx Started

NAME                IMAGE                                             COMMAND                  SERVICE       CREATED         STATUS                           PORTS
vaultwarden         docker.xuanyuan.run/vaultwarden/server:1.37.5     "/start.sh"              vaultwarden   8 seconds ago   Up 1 second (health: starting)   80/tcp
vaultwarden-nginx   docker.xuanyuan.run/library/nginx:1.28.0-alpine   "/docker-entrypoint.…"   nginx         3 seconds ago   Up Less than a second            80/tcp, 0.0.0.0:11443->443/tcp, [::]:11443->443/tcp
```

`ps` 应同时有 `vaultwarden` 与 `vaultwarden-nginx`，且出现 `0.0.0.0:11443->443/tcp`。

本机探测（自签证书加 `-k`）：

```bash
curl -kI https://127.0.0.1:11443
```

这次返回：

```text
HTTP/2 200
server: nginx/1.28.0
date: Tue, 03 Nov 2026 05:54:48 GMT
x-content-type-options: nosniff
x-frame-options: SAMEORIGIN
```

浏览器打开：

```text
https://192.168.1.35:11443
```

通过证书警告后，左上角不应再出现 Subtle Crypto 提示，即可注册。

## 登录并开始使用

### 1. 打开登录页

通过证书警告后，进入「登录」页：填写「电子邮箱地址」，可勾选「记住电子邮箱」，点「继续」；下方有「创建账户」。页脚为 **Vaultwarden Web 2026.10.1**。

![Vaultwarden HTTPS 登录页：电子邮箱地址、继续与创建账户](https://imgs.xuanyuan.cloud/docker/blog/vaultwarden/vaultwarden-1.webp)

### 2. 创建账户

1. 点击「创建账户」。
2. 填写「电子邮箱地址」与「名称」，点「继续」。

![Vaultwarden 创建账户：电子邮箱地址、名称与继续](https://imgs.xuanyuan.cloud/docker/blog/vaultwarden/vaultwarden-2.webp)

3. 在「设置强密码」中填写「主密码」与「确认主密码」（至少 12 个字符；界面提示遗忘后无法恢复，请自行妥善保存），按需填写「主密码提示」，再点「创建账户」。

![Vaultwarden 设置强密码：主密码、确认主密码与创建账户](https://imgs.xuanyuan.cloud/docker/blog/vaultwarden/vaultwarden-3.webp)

第一个注册用户即你的保险库账号，没有预置默认密码。

### 3. 注册完成进入密码库

成功后会出现「您的新账户已成功创建！」，并可点「获取扩展」或「稍后添加」。

![Vaultwarden 账户创建成功：获取扩展与稍后添加](https://imgs.xuanyuan.cloud/docker/blog/vaultwarden/vaultwarden-4.webp)

随后可能弹出「您已成功加入！欢迎使用 Bitwarden」（界面沿用上游文案），可点「跳过」或「开始导览」。

![Vaultwarden 欢迎导览：跳过与开始导览](https://imgs.xuanyuan.cloud/docker/blog/vaultwarden/vaultwarden-5.webp)

进入「所有密码库」后，可见「开始使用您的密码库」清单；库为空时显示「密码库中没有项目」，可点「添加项目」。

![Vaultwarden 密码库主界面：开始使用清单与添加项目](https://imgs.xuanyuan.cloud/docker/blog/vaultwarden/vaultwarden-6.webp)

### 4. 关闭开放注册

建号后编辑 `compose.yaml`，将 `SIGNUPS_ALLOWED` 改为 `"false"`，再执行：

```bash
cd /www/wwwroot/vaultwarden
docker compose up -d
```

需要加人时，可用组织邀请，或临时打开注册并配合 `SIGNUPS_DOMAINS_WHITELIST`。

### 5. 连接 Bitwarden 客户端

1. 打开官方 Bitwarden 手机、桌面或浏览器扩展。
2. 在自托管 / 自定义服务器中填写 **`https://192.168.1.35:11443`**（换成你的地址；不要填 `http://IP:11001`）。
3. 客户端若校验证书失败，导入 `ssl/cert.pem` 到系统或客户端信任区；公网正式证书一般可直接通过。
4. 用同一账号登录并确认同步。

需要 `/admin` 管理页时，再配置 `ADMIN_TOKEN`（生产环境优先用上游推荐的 Argon2 字符串），本文未展开实测。

## 功能演示

### Send

侧栏进入「Send」。空库时标题为「安全地发送敏感信息」，可点「创建 Send」建立文本或文件 Send。

![Vaultwarden Send 页：安全地发送敏感信息与创建 Send](https://imgs.xuanyuan.cloud/docker/blog/vaultwarden/vaultwarden-7.webp)

### 生成器

「工具 → 生成器」可切换「密码」「密码短语」「用户名」，并设置长度与字符选项。

![Vaultwarden 生成器：密码长度与包含字符选项](https://imgs.xuanyuan.cloud/docker/blog/vaultwarden/vaultwarden-8.webp)

### 报告

「工具 → 报告」可打开「暴露的密码」「重复使用的密码」「弱密码」「不安全的网站」「未激活两步登录」「数据泄露」等检查。

![Vaultwarden 报告页：暴露的密码与弱密码等卡片](https://imgs.xuanyuan.cloud/docker/blog/vaultwarden/vaultwarden-9.webp)

## 备选：docker run

没有 Compose 时，可先用下面命令临时拉起 Vaultwarden（仍是明文 **11001**，Web 库不可用，还需自行加 HTTPS 反代）：

```bash
sudo mkdir -p /www/wwwroot/vaultwarden/data
sudo chown -R "$USER":"$USER" /www/wwwroot/vaultwarden

docker run -d 
  --name vaultwarden 
  --restart unless-stopped 
  -p 11001:80 
  -e SIGNUPS_ALLOWED=true 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/vaultwarden/data:/data 
  docker.xuanyuan.run/vaultwarden/server:1.37.5
```

查看状态：

```bash
docker ps --filter name=vaultwarden
docker logs --tail 80 vaultwarden
```

正式使用请改回上文 Compose + Nginx 主路径。

## 备份与升级

```bash
cd /www/wwwroot/vaultwarden
docker compose stop
tar -czf vaultwarden-backup.tar.gz data ssl nginx compose.yaml
docker compose start
```

升级时改 `compose.yaml` 中的镜像标签，保留 `data`、`ssl`、`nginx` 后执行：

```bash
docker compose pull
docker compose up -d
```

升级前阅读对应 Release 说明。

## 常见问题

### 有没有默认账号密码

没有。在 HTTPS 入口自行注册。

### 注册完成后还要做什么

把 `SIGNUPS_ALLOWED` 改为 `false` 并执行 `docker compose up -d`。

### 打开 http://IP:11001 出现 “need to enable HTTPS”

预期现象。请用 **`https://IP:11443`**（Nginx 入口）。

### 打开 https://IP:11001 报 ERR_SSL_PROTOCOL_ERROR

**11001** 没有 TLS。HTTPS 走 **11443**。

### 自签证书浏览器一直拦截

需手动继续访问。客户端校验证书失败时，导入 `ssl/cert.pem`，或改用公网域名与 Let's Encrypt。

### curl 连不上 11443 / 只有 up 1/1

Nginx 未进 Compose。确认已写入含 `nginx:` 的 `compose.yaml`，并存在 `ssl/` 与 `nginx/default.conf`，再 `docker compose up -d`。`ps` 里应同时有 `vaultwarden` 与 `vaultwarden-nginx`。

### Nginx 502 或启动失败

查看 `docker compose logs nginx` 与 `vaultwarden`。确认证书文件已挂载，上游为 `vaultwarden:80`，且两服务在同一 Compose 项目。

### 必须设置 DOMAIN 吗

启用 Nginx 后必须设置，且与浏览器地址完全一致（含 `https://` 与端口 **11443**）。

### 还要映射 3012 吗

不要。WebSocket 已并入主端口 **80**。

### 数据如何备份迁移

打包 `data`（建议连同 `ssl`、`nginx`、`compose.yaml`）。新机器挂回后启动。

### 可以用 latest 吗

不要。本文使用 **`1.37.5`** 与 **`1.28.0-alpine`**。见「标签怎么选」。

### 为什么先有 11001 又改用 11443

**11001** 用于确认 Vaultwarden 进程；正式 Web 库入口是 **11443**。

## 命令速查

```bash
docker pull docker.xuanyuan.run/vaultwarden/server:1.37.5
docker pull docker.xuanyuan.run/library/nginx:1.28.0-alpine

cd /www/wwwroot/vaultwarden
# 生成 ssl/、写入 nginx/default.conf 与含 nginx 的 compose.yaml 后：
docker compose up -d
docker compose ps
curl -kI https://127.0.0.1:11443

# 浏览器打开 https://服务器IP:11443 ，通过证书警告后注册
# 建号后将 SIGNUPS_ALLOWED 改为 false

docker compose down
```

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [vaultwarden/server 镜像页](https://xuanyuan.cloud/r/vaultwarden/server?xy_from=vaultwarden-docker-deploy) | [https://xuanyuan.cloud/r/vaultwarden/server](https://xuanyuan.cloud/r/vaultwarden/server?xy_from=vaultwarden-docker-deploy) |
| [vaultwarden/server 中文镜像页](https://xuanyuan.cloud/zh/r/vaultwarden/server?xy_from=vaultwarden-docker-deploy) | [https://xuanyuan.cloud/zh/r/vaultwarden/server](https://xuanyuan.cloud/zh/r/vaultwarden/server?xy_from=vaultwarden-docker-deploy) |
| [vaultwarden/server 标签列表](https://xuanyuan.cloud/r/vaultwarden/server/tags?xy_from=vaultwarden-docker-deploy) | [https://xuanyuan.cloud/r/vaultwarden/server/tags](https://xuanyuan.cloud/r/vaultwarden/server/tags?xy_from=vaultwarden-docker-deploy) |
| [library/nginx 镜像页](https://xuanyuan.cloud/r/library/nginx?xy_from=vaultwarden-docker-deploy) | [https://xuanyuan.cloud/r/library/nginx](https://xuanyuan.cloud/r/library/nginx?xy_from=vaultwarden-docker-deploy) |
| [Docker Hub · vaultwarden/server](https://hub.docker.com/r/vaultwarden/server) | [https://hub.docker.com/r/vaultwarden/server](https://hub.docker.com/r/vaultwarden/server) |
| [Docker Hub · nginx](https://hub.docker.com/_/nginx) | [https://hub.docker.com/_/nginx](https://hub.docker.com/_/nginx) |
| [GitHub · dani-garcia/vaultwarden](https://github.com/dani-garcia/vaultwarden) | [https://github.com/dani-garcia/vaultwarden](https://github.com/dani-garcia/vaultwarden) |
| [Vaultwarden Wiki · Proxy examples](https://github.com/dani-garcia/vaultwarden/wiki/Proxy-examples) | [https://github.com/dani-garcia/vaultwarden/wiki/Proxy-examples](https://github.com/dani-garcia/vaultwarden/wiki/Proxy-examples) |
| [Release 1.37.5](https://github.com/dani-garcia/vaultwarden/releases/tag/1.37.5) | [https://github.com/dani-garcia/vaultwarden/releases/tag/1.37.5](https://github.com/dani-garcia/vaultwarden/releases/tag/1.37.5) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=vaultwarden-docker-deploy) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage?xy_from=vaultwarden-docker-deploy) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/vaultwarden-docker-deploy?xy_from=vaultwarden-docker-deploy)

*本文基于 [vaultwarden/server:1.37.5](https://xuanyuan.cloud/r/vaultwarden/server?xy_from=vaultwarden-docker-deploy) 与 [library/nginx:1.28.0-alpine](https://xuanyuan.cloud/r/library/nginx?xy_from=vaultwarden-docker-deploy)，以 **1.37.5** / **1.28.0-alpine** 版本实测，Web 库 **2026.10.1**，测试平台 **Ubuntu 24.04** Linux。*


