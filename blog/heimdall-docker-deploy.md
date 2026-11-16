# Docker 部署 Heimdall：轻松搭建自托管应用导航仪表盘

![Docker 部署 Heimdall：轻松搭建自托管应用导航仪表盘](https://imgs.xuanyuan.cloud/docker/blog/heimdall/heimdall.webp)

*分类: Docker部署教程 | 标签: Heimdall,linuxserver/heimdall,Docker,轩辕镜像,应用导航,起始页,仪表盘,私有化部署,部署教程 | 发布时间: 2026-11-15 16:27:42*

> Heimdall 是面向自托管的应用导航仪表盘，把常用网站与内网服务收成一页入口，也可当作浏览器起始页。本文将介绍如何通过 Docker Compose 部署 linuxserver/heimdall，在浏览器里添加并钉住常用链接，适合家用 NAS、内网服务入口，以及希望把书签统一到自建面板的场景。

## Heimdall 是什么

Heimdall Application Dashboard 是一款开源应用导航面板，由 [linuxserver.io](https://www.linuxserver.io/) 维护与支持。它把常用网站、自建服务和任意链接排在同一页，用图标区分，也可以当作浏览器起始页，并带有 Google、Bing 或 DuckDuckGo 搜索栏。

和浏览器书签栏不同，它跑在 NAS 或家用服务器上：家里人打开同一个内网地址就能进各服务。页面里没有 iframe 嵌套，点进去就是目标站点本身。

## Heimdall 能做什么

- **集中入口**：把 NAS、监控、下载、文档等常用地址排成一页。
- **添加链接**：手填名称与 URL，也可选用站点图标；部分应用支持从目录匹配图标与配色。
- **浏览器起始页**：把面板地址设为起始页，打开浏览器先到自己的导航。
- **搜索栏**：在面板上直接用 Google、Bing 或 DuckDuckGo 搜索。
- **可选访问保护**：可用 Nginx `htpasswd` 给整站加基本认证。

## 为什么要使用 Heimdall

家里或办公室常有一堆自建服务，地址散落在便签、聊天记录和浏览器书签里，换设备就要再找一遍。

Heimdall 用一个容器把入口留在本机目录。适合已经在跑 Docker 的 NAS 或小主机，也适合想给家人一个统一内网首页的人。

## 使用 Docker 部署 Heimdall

用 Docker 跑 Heimdall，不必在宿主机单独装 PHP 和 Nginx。部署前准备好 Docker，并规划配置目录与端口。

接下来用 Docker Compose 写好镜像、环境变量与数据卷，启动服务，再在浏览器里添加链接。

## 环境要求

本文使用 **`linuxserver/heimdall:2.8.4`** 版本实测。测试平台是 Ubuntu 24.04（主机名 `ikuai-ubuntu2404`）。`2.8.4` 是当前稳定线；同线还有 `version-v2.8.4`、`v2.8.4-ls373` 等写法。`latest` 会随发版改指向，本文固定 `2.8.4`。

镜像提供 **linux/amd64**、**linux/arm64**；Docker Hub 上 amd64 压缩体积约 **51 MB**。实测容器为 **v2.8.4-ls373**，响应头为 **PHP/8.5.12**。

容器内 HTTP 听 **80**，HTTPS 听 **443**。本文把宿主机 **11080** 映到 **80**、**11443** 映到 **443**，避免占用宿主机常见的 **80** / **443**。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文按 Ubuntu 目录）；macOS 把 `/www/wwwroot/heimdall` 换成 `~/docker/heimdall` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64** |
| 内存 | 建议 ≥ **256 MB** 可用 |
| 磁盘 | 镜像约数十 MB，另加 `config` 空间 |
| 端口 | **11080→80**（HTTP）；**11443→443**（HTTPS，可选） |
| 工作目录 | `/www/wwwroot/heimdall` |
| 账号 | 无默认管理员口令；需要时再配置 `htpasswd` |

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

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=heimdall-docker-deploy)。

## 标签怎么选

新安装使用 **`2.8.4`**。不要把 `latest`、`development` 写进 Compose。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`2.8.4`** | 当前稳定发行版 | **是** |
| `version-v2.8.4` / `v2.8.4-ls373` | 同一版本的其他写法 | 否 |
| `2.8.3` 及更早 | 更早稳定版 | 否 |
| `latest` | 浮动到当前稳定线 | 否 |
| `development` | 上游 2.x 分支最新提交 | 否 |
| `amd64-2.8.4` / `arm64v8-2.8.4` | 只含一种架构 | 必须指定架构时再用 |

标签见 [标签列表](https://xuanyuan.cloud/r/linuxserver/heimdall/tags?xy_from=heimdall-docker-deploy)。应用发布说明见 [Heimdall v2.8.4](https://github.com/linuxserver/Heimdall/releases/tag/v2.8.4)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud/?xy_from=heimdall-docker-deploy) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/linuxserver/heimdall:2.8.4
```

Ubuntu 24.04 上拉取完成：

```text
2.8.4: Pulling from linuxserver/heimdall
b493e69404db: Pull complete
2d0e4ca7fdd5: Pull complete
84441b06e389: Pull complete
efc1a479174c: Pull complete
681a252c2496: Pull complete
f6a4c3e338ed: Pull complete
d3ae61b552ec: Pull complete
7970ef2aa55e: Pull complete
01dcaa168b62: Pull complete
e2a4e0d6c6f8: Pull complete
23b6a4730181: Pull complete
44136fa355b3: Download complete
03d7efd05426: Download complete
7c663429eabd: Download complete
Digest: sha256:47f70751f900be4499017a48c01206c02ab9d18f34a580c6213a13d24cdc1a4a
Status: Downloaded newer image for docker.xuanyuan.run/linuxserver/heimdall:2.8.4
docker.xuanyuan.run/linuxserver/heimdall:2.8.4
```

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq?xy_from=heimdall-docker-deploy)。

## Docker Compose 部署

工作目录：Linux **`/www/wwwroot/heimdall`**。macOS 用 **`~/docker/heimdall`**。

| 宿主机目录 | 容器内路径 | 用途 |
|------------|------------|------|
| `config/` | `/config` | 站点配置、Nginx、应用数据与日志 |

### 1. 创建目录

```bash
sudo mkdir -p /www/wwwroot/heimdall/config
sudo chown -R 1000:1000 /www/wwwroot/heimdall
cd /www/wwwroot/heimdall
```

`id` 不是 `1000` 时，把这里的数字和 Compose 里的 `PUID`、`PGID` 改成同一个用户。macOS：

```bash
mkdir -p ~/docker/heimdall/config
cd ~/docker/heimdall
```

### 2. 写入 compose.yaml

`11080:80` 表示宿主机 **11080** 对应容器内 HTTP **80**；`11443:443` 对应 HTTPS **443**。日常内网访问用 HTTP 端口即可。

```bash
cd /www/wwwroot/heimdall
cat > compose.yaml <<'EOF'
services:
  heimdall:
    image: docker.xuanyuan.run/linuxserver/heimdall:2.8.4
    container_name: heimdall
    restart: unless-stopped
    environment:
      PUID: "1000"
      PGID: "1000"
      TZ: Asia/Shanghai
      # 需要探测内网私有 IP 时再改为 true，见常见问题
      ALLOW_INTERNAL_REQUESTS: "false"
    volumes:
      - ./config:/config
    ports:
      - "11080:80"
      - "11443:443"
EOF
```

| 配置 | 说明 |
|------|------|
| `image` | 固定 `2.8.4` |
| `PUID` / `PGID` | 与 `config/` 属主一致 |
| `TZ` | 容器时区 |
| `ALLOW_INTERNAL_REQUESTS` | 默认 `false`，阻止对私有 / 保留地址的探测 |
| `./config` | 持久化配置 |
| `11080:80` / `11443:443` | HTTP / HTTPS 入口 |

### 3. 启动

```bash
cd /www/wwwroot/heimdall
docker compose up -d
docker compose ps
docker compose logs --tail 80 heimdall
```

若出现 `all predefined address pools have been fully subnetted`，先执行 `docker network prune -f`，再重新 `up -d`，见「常见问题」。

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network heimdall_default Created
 ✔ Container heimdall       Started

NAME       IMAGE                                            COMMAND   SERVICE    CREATED         STATUS         PORTS
heimdall   docker.xuanyuan.run/linuxserver/heimdall:2.8.4   "/init"   heimdall   5 seconds ago   Up 3 seconds   0.0.0.0:11080->80/tcp, [::]:11080->80/tcp, 0.0.0.0:11443->443/tcp, [::]:11443->443/tcp
```

首次启动会生成自签证书和应用密钥。日志关键行：

```text
User UID:    1000
User GID:    1000
Linuxserver.io version: v2.8.4-ls373
Build-date: 2026-11-13T23:34:43+00:00
generating self-signed keys in /config/keys, you can replace these with your own keys if required
New container detected, installing Heimdall
Creating app key. This may take a while on slower systems
[ls.io-init] done.
```

初始化未完成时，`curl` 可能报 `Connection reset by peer`。等日志出现 `[ls.io-init] done.` 后再测：

```bash
curl -sI http://127.0.0.1:11080
```

Ubuntu 24.04 实测：

```text
HTTP/1.1 200 OK
Server: nginx
Content-Type: text/html; charset=utf-8
X-Powered-By: PHP/8.5.12
Cache-Control: no-cache, private
```

首页 **200** 后即可打开浏览器。若添加页 `/items/create` 返回 **500**，多半是应用列表 `appslist.heimdall.site` 拉取失败，见「常见问题」。

## 浏览器首次使用

浏览器访问：

```text
http://服务器IP:11080
```

把 `服务器IP` 换成你的主机地址。实测为 `http://192.168.1.35:11080/`。

### 1. 打开空面板

首次打开是空面板。顶部白条提示还没有钉住的应用，可点其中的「Add an application here」：

![Heimdall 空面板：提示 There are currently no pinned applications，可点 Add an application here](https://imgs.xuanyuan.cloud/docker/blog/heimdall/heimdall-1.webp)

### 2. 添加应用

进入添加页后：

1. 打开右上角 **PINNED**，保存后才会出现在首页。
2. 在 **Website** 填入目标地址（实测为 `https://xuanyuan.cloud/`），可点红色「Go」拉取可选图标。
3. 填写 **Application name**（实测为「轩辕镜像 - 国内 Docker 镜像下载加速」），按需改颜色、标签与说明。
4. 点「SAVE」保存。

![Heimdall 添加应用：PINNED 开启，填写轩辕镜像名称与 URL，预览磁贴并选择图标](https://imgs.xuanyuan.cloud/docker/blog/heimdall/heimdall-2.webp)

添加页打不开或一直 **500** 时，见「常见问题」中的应用列表处理。

### 3. 确认首页磁贴

返回首页后，已 PINNED 的条目会出现在面板中央。点击磁贴即可打开目标站点。实测首页钉住了「轩辕镜像」：

![Heimdall 首页已钉住轩辕镜像磁贴](https://imgs.xuanyuan.cloud/docker/blog/heimdall/heimdall-3.webp)

可选：在浏览器里把起始页设为该地址；在设置里打开搜索栏；若要用容器自带 HTTPS，访问 `https://服务器IP:11443`（默认自签证书，浏览器可能提示不安全，仅适合内网试用）。

面板默认对访客开放。需要整站口令时，见下一节。

## 可选：htpasswd 基本认证

LinuxServer 文档说明可用 `htpasswd` 保护整站。在运行中的容器里生成密码文件：

```bash
docker exec -it heimdall htpasswd -c /config/nginx/.htpasswd 你的用户名
```

按提示输入密码。然后编辑：

```text
/www/wwwroot/heimdall/config/nginx/site-confs/default.conf
```

找到与 basic auth / `htpasswd` 相关的注释行，去掉注释并保存，再重启：

```bash
cd /www/wwwroot/heimdall
docker compose restart heimdall
```

再次打开 `http://服务器IP:11080` 时，浏览器会弹出基本认证框。

## 备选：docker run

没有 Compose 时可用下面命令。目录、端口与镜像与上文相同。Compose 已在跑时，先到工作目录执行 `docker compose down`，再跑这些命令，避免容器名和端口冲突。

```bash
sudo mkdir -p /www/wwwroot/heimdall/config
sudo chown -R 1000:1000 /www/wwwroot/heimdall

docker run -d 
  --name heimdall 
  --restart unless-stopped 
  -e PUID=1000 
  -e PGID=1000 
  -e TZ=Asia/Shanghai 
  -e ALLOW_INTERNAL_REQUESTS=false 
  -p 11080:80 
  -p 11443:443 
  -v /www/wwwroot/heimdall/config:/config 
  docker.xuanyuan.run/linuxserver/heimdall:2.8.4
```

查看状态：

```bash
docker ps --filter name=heimdall
docker logs --tail 80 heimdall
```

## 常见问题

**Q1：为什么访问地址是 11080，不是 80？**

容器内仍是 **80**。宿主机改成 **11080**，是为了避开已占用 **80** 的网站或其他面板。HTTPS 同理用 **11443** 映容器 **443**。

**Q2：面板打不开？**

看 `docker compose ps` 是否在运行。马上退出时看 `docker compose logs --tail 80 heimdall`。端口被占用时，改 Compose 左侧端口后再 `docker compose up -d`。`config/` 属主须与 `PUID` / `PGID` 一致。首次安装未完成时，`curl` 可能报 `Connection reset by peer`，等日志出现 `[ls.io-init] done.` 后再访问。

**Q3：`docker compose up` 报 `all predefined address pools have been fully subnetted`？**

Compose 项目过多时，Docker 默认网段池会耗尽，建不出 `heimdall_default`。先执行：

```bash
docker network prune -f
cd /www/wwwroot/heimdall
docker compose up -d
```

`prune` 只删除未被容器使用的网络。

**Q4：首页能开，但 `/items/create` 返回 500？**

首次安装会请求 `https://appslist.heimdall.site/list.json`（超时约 15 秒）。网络慢或中断时，日志会出现 `GuzzleHttpExceptionConnectException`：首页仍可能 **200**，添加页则 **500**。

处理：取得完整 `list.json`（勿用截断文件；撰写时完整体积为 **329581** 字节），放到宿主机例如 `/tmp/list.json`，再写入容器内站点根 `/app/www/public`（只拷到 `/config/www/public` 时，Nginx 读不到）：

```bash
wc -c /tmp/list.json

docker cp /tmp/list.json heimdall:/app/www/public/list.json
docker cp /tmp/list.json heimdall:/app/www/storage/app/supportedapps.json
docker exec heimdall chown abc:abc 
  /app/www/public/list.json 
  /app/www/storage/app/supportedapps.json

sudo mkdir -p /www/wwwroot/heimdall/config/www/public 
  /www/wwwroot/heimdall/config/www/storage/app
sudo cp /tmp/list.json /www/wwwroot/heimdall/config/www/public/list.json
sudo cp /tmp/list.json /www/wwwroot/heimdall/config/www/storage/app/supportedapps.json
sudo chown -R 1000:1000 /www/wwwroot/heimdall/config/www/public 
  /www/wwwroot/heimdall/config/www/storage

if ! grep -q '^APP_SOURCE=' /www/wwwroot/heimdall/config/www/.env 2>/dev/null; then
  echo 'APP_SOURCE=http://127.0.0.1/' | sudo tee -a /www/wwwroot/heimdall/config/www/.env
else
  sudo sed -i 's|^APP_SOURCE=.*|APP_SOURCE=http://127.0.0.1/|' 
    /www/wwwroot/heimdall/config/www/.env
fi
sudo chown 1000:1000 /www/wwwroot/heimdall/config/www/.env

docker exec heimdall curl -sI http://127.0.0.1/list.json | head -n 5
docker exec heimdall php /app/www/artisan config:clear

cd /www/wwwroot/heimdall
docker compose restart heimdall
sleep 8
curl -s -o /dev/null -w "%{http_code}
" http://127.0.0.1:11080/items/create
```

`list.json` 的 `Content-Length` 应与完整文件一致；添加页期望 **200**。`docker cp` 写入 `/app/www/public/` 的文件在容器重建后可能丢失，重建后需再拷一次。

**Q5：链接到内网服务时探测失败？**

默认 `ALLOW_INTERNAL_REQUESTS=false`，会阻止对私有或保留 IP 的探测。实例只在内网使用、或已有访问保护时，可在 Compose 里改为 `"true"`，再执行 `docker compose up -d`。

**Q6：如何升级？**

先备份 `config/`，把 Compose 与 `docker pull` 中的标签改成目标版本，再执行：

```bash
cd /www/wwwroot/heimdall
docker compose pull
docker compose up -d
```

**Q7：如何停止？**

还要保留配置时，不要删除 `config/`：

```bash
cd /www/wwwroot/heimdall
docker compose down
```

不再需要时，再删除工作目录：

```bash
sudo rm -rf /www/wwwroot/heimdall
```

## 命令速查

```bash
docker pull docker.xuanyuan.run/linuxserver/heimdall:2.8.4

cd /www/wwwroot/heimdall
docker compose up -d
docker compose ps
docker compose logs --tail 80 heimdall
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器入口是 `http://服务器IP:11080`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [linuxserver/heimdall 镜像页](https://xuanyuan.cloud/r/linuxserver/heimdall?xy_from=heimdall-docker-deploy) | [https://xuanyuan.cloud/r/linuxserver/heimdall](https://xuanyuan.cloud/r/linuxserver/heimdall?xy_from=heimdall-docker-deploy) |
| [linuxserver/heimdall 中文镜像页](https://xuanyuan.cloud/zh/r/linuxserver/heimdall?xy_from=heimdall-docker-deploy) | [https://xuanyuan.cloud/zh/r/linuxserver/heimdall](https://xuanyuan.cloud/zh/r/linuxserver/heimdall?xy_from=heimdall-docker-deploy) |
| [linuxserver/heimdall 标签列表](https://xuanyuan.cloud/r/linuxserver/heimdall/tags?xy_from=heimdall-docker-deploy) | [https://xuanyuan.cloud/r/linuxserver/heimdall/tags](https://xuanyuan.cloud/r/linuxserver/heimdall/tags?xy_from=heimdall-docker-deploy) |
| [Docker Hub · linuxserver/heimdall](https://hub.docker.com/r/linuxserver/heimdall) | [https://hub.docker.com/r/linuxserver/heimdall](https://hub.docker.com/r/linuxserver/heimdall) |
| [LinuxServer · heimdall 文档](https://docs.linuxserver.io/images/docker-heimdall/) | [https://docs.linuxserver.io/images/docker-heimdall/](https://docs.linuxserver.io/images/docker-heimdall/) |
| [GitHub · linuxserver/docker-heimdall](https://github.com/linuxserver/docker-heimdall) | [https://github.com/linuxserver/docker-heimdall](https://github.com/linuxserver/docker-heimdall) |
| [GitHub · linuxserver/Heimdall](https://github.com/linuxserver/Heimdall) | [https://github.com/linuxserver/Heimdall](https://github.com/linuxserver/Heimdall) |
| [Release v2.8.4](https://github.com/linuxserver/Heimdall/releases/tag/v2.8.4) | [https://github.com/linuxserver/Heimdall/releases/tag/v2.8.4](https://github.com/linuxserver/Heimdall/releases/tag/v2.8.4) |
| [Heimdall 官网](https://heimdall.site/) | [https://heimdall.site/](https://heimdall.site/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=heimdall-docker-deploy) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage?xy_from=heimdall-docker-deploy) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/heimdall-docker-deploy?xy_from=heimdall-docker-deploy)

*本文基于 [linuxserver/heimdall:2.8.4](https://xuanyuan.cloud/r/linuxserver/heimdall?xy_from=heimdall-docker-deploy)，以 **2.8.4** 版本实测，容器 **v2.8.4-ls373**，**PHP/8.5.12**，测试平台 **Ubuntu 24.04** Linux。*


