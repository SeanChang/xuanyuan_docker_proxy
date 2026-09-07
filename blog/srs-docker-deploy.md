# Docker 部署 SRS：轻松搭建实时音视频流媒体平台

![Docker 部署 SRS：轻松搭建实时音视频流媒体平台](https://imgs.xuanyuan.cloud/docker/blog/ossrs.webp)

*分类: Docker部署教程 | 标签: SRS,ossrs/srs,Docker,轩辕镜像,流媒体,RTMP,WebRTC,HLS,HTTP-FLV,SRT,私有化部署,部署教程 | 发布时间: 2026-09-03 14:14:51*

> 联调室里 OBS 已经亮着「正在直播」，教室网页却还是一块黑：有人改 Stream Key，有人在本机再开一路 FFmpeg 转 HLS，有人把 Nginx-RTMP 的 application 写成 `live2`，三个人对不上同一条 URL。推上去了播放器打不开、手机要看 m3u8、网页又要低延迟——端口和脚本散在便签上，换一台机器就得重配。

*本文基于 [ossrs/srs:6.0.191](https://xuanyuan.cloud/zh/r/ossrs/srs)，实测引擎 **SRS 6.0.191**（v6.0-r1），测试平台 **Ubuntu 24.04** Linux。*

联调室里 OBS 已经亮着「正在直播」，教室网页却还是一块黑：有人改 Stream Key，有人在本机再开一路 FFmpeg 转 HLS，有人把 Nginx-RTMP 的 application 写成 `live2`，三个人对不上同一条 URL。推上去了播放器打不开、手机要看 m3u8、网页又要低延迟——端口和脚本散在便签上，换一台机器就得重配。

云直播按流量出账，内网课、等保机房、客户演示往往不能把画面送出域；自己编译音视频服务器又要一堆依赖。很多团队已经有一台 Ubuntu 跑着 Docker，要的是 **1935 能推、8080 能播**，切片落在自己的盘上。

**SRS**（Simple Realtime Server，[官网](https://ossrs.io)、[GitHub · ossrs/srs](https://github.com/ossrs/srs)）是开源实时音视频服务器，支持 **RTMP、HTTP-FLV、HLS、WebRTC、SRT、MPEG-DASH、GB28181** 等。官方镜像 **`ossrs/srs`**（[镜像页](https://xuanyuan.cloud/zh/r/ossrs/srs)）默认跑 `conf/docker.conf`：RTMP、HTTP API、HTTP / HLS、以及 RTMP ↔ WebRTC。许可证 **MIT**（第三方库另有协议，商用请自行核对）。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 打开 Status 页 | `http://服务器IP:8080/`，看到 **Congratulations! SRS works!** |
| OBS / FFmpeg 推流 | 服务器 `rtmp://IP/live`，推流码 **`livestream`** |
| 浏览器播 HTTP-FLV / HLS | `http://IP:8080/live/livestream.flv` / `.m3u8` |
| 查版本 / 流列表 | `http://IP:1985/api/v1/versions` |
| 备份搬家 | 停容器后打包 `./html` 与 `docker-compose.yml` |

本文用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`ossrs/srs:6.0.191`**，**Docker Compose** 映射 **1935 / 1985 / 8080**（WebRTC 再加 **8000/udp**）。实测局域网 IP **`192.168.1.35`**，请换成你的地址。无 Compose 见第八节。文内附 **4** 张实测截图。

> **上手要点**
> - **部署**：第五节 Compose；临时试玩见第八节
> - **访问**：宿主机 **8080** → 容器 **8080**；**1935** → RTMP；**1985** → HTTP API
> - **数据**：先把镜像里的 html 拷到 `./html`，再挂到 `/usr/local/srs/objs/nginx/html`。空目录会盖掉 Status / 控制台，`:8080/` 变 **404**（推流和 API 仍可用，见 5.4）
> - **WebRTC**：映射 **8000/udp**；**`CANDIDATE`** 填客户端能访问的宿主机 IP，勿填 `127.0.0.1`
> - **标签**：跟做 **`6.0.191`**（与 Release **v6.0-r1** 同构建）；勿写 `latest` 或浮动标签 `6`
> - **体积**：DISK **230MB** / CONTENT **59.9MB**
> - **账号**：无默认登录页；默认也无推流鉴权，勿把 **1935 / 1985 / 8080** 裸暴露公网

官方：[Getting Started](https://ossrs.io/lts/en-us/docs/v6/doc/getting-started) · [中文入门](https://ossrs.net/lts/zh-cn/docs/v6/doc/getting-started) · [镜像页](https://xuanyuan.cloud/zh/r/ossrs/srs)

---

## 一、SRS 是什么？

推一路 RTMP，即可按需拉 HTTP-FLV / HLS / WebRTC；HTTP API 方便对接业务。不必先拼 Nginx-RTMP 再另挂播放页。

| | SRS（本文） | Nginx-RTMP 等 | 商业云直播 |
|--|-------------|---------------|------------|
| 入口 | 浏览器 `:8080` + API | 多份配置与模块 | 厂商控制台 |
| 协议 | RTMP / HTTP-FLV / HLS / WebRTC / SRT 等 | 偏 RTMP→HLS | 厂商协议 |
| WebRTC | 内置（需 `CANDIDATE`） | 通常另接 | 厂商侧 |
| 数据 | 本机卷 / 内网 | 自建 | 出域 / 按量 |
| 适合 | 自托管联调、低延迟互动、内网合规 | 已有 Nginx 栈、场景单一 | 免运维、可接受费用 |

```text
OBS / FFmpeg     ──:1935/tcp──▶ RTMP
浏览器 / 播放器  ──:8080/tcp──▶ HTTP-FLV / HLS / Status / 控制台
curl / 业务      ──:1985/tcp──▶ HTTP API
WebRTC           ──:8000/udp──▶ RTC
./html           ──挂载──▶ /usr/local/srs/objs/nginx/html
```

[`/r/`](https://xuanyuan.cloud/r/ossrs/srs) 与 [`/zh/r/`](https://xuanyuan.cloud/zh/r/ossrs/srs) 是同一镜像的不同页面。同站 `ossrs/oryx`、`ossrs/srs-stack` 是另一套产品，**本文只用 `ossrs/srs:6.0.191`**。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64 / arm64 / arm/v7**（以 [tags](https://xuanyuan.cloud/r/ossrs/srs/tags) 为准） |
| 内存 | ≥ **1 GB** 可用；路数多再加 |
| 磁盘 | DISK **230MB** / CONTENT **59.9MB** + `./html` 随 HLS 增长 |
| 端口 | **1935**、**1985**、**8080**；WebRTC 再放行 **8000/udp** |

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

```bash
ss -tlnp | grep -E ':1935|:1985|:8080'
ss -ulnp | grep ':8000'
```

被占用时改 Compose 映射**左侧**端口（例如 `"18080:8080"`），浏览器和推流地址跟着改。

> **安全**：默认 `docker.conf` **没有推流鉴权**。公网请加 hook / 业务鉴权、反代 HTTPS，并限制来源 IP。

---

## 三、标签怎么选

跟做使用 **`6.0.191`**。完整列表：[tags](https://xuanyuan.cloud/r/ossrs/srs/tags)。对应上游 [Release v6.0-r1](https://github.com/ossrs/srs/releases/tag/v6.0-r1)（2026-08-12）。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`6.0.191`** | 精确修订号（与 `v6.0-r1` 同构建） | **本文跟做** |
| `v6.0-r1` / `6.0-r1` | 6.0 release1 | 可等价选用 |
| `6` | 6.x 浮动线 | **勿写入跟做命令** |
| `5` / `5.0.x` | 上一大版本 | 回滚或锁定 5.x |
| `v7.0-d0` 等 | 7.0 开发线 | **勿当教程 / 生产默认** |
| `latest` | 浮动线 | **勿写入跟做命令** |

升级前备份 `./html`，同步改 pull、Compose、`docker run` 三处标签，并核对 [Releases](https://github.com/ossrs/srs/releases)。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/ossrs/srs:6.0.191
```

Ubuntu 24.04 实测：

```text
6.0.191: Pulling from ossrs/srs
4f4fb700ef54: Pull complete
6e088533516f: Pull complete
73702da16f1a: Download complete
Digest: sha256:2be08a0fe28737bf28bae8a575bb5776e09b620366dd1e62dd4f8a41cf4310f3
Status: Downloaded newer image for docker.xuanyuan.run/ossrs/srs:6.0.191
docker.xuanyuan.run/ossrs/srs:6.0.191
```

```bash
docker images docker.xuanyuan.run/ossrs/srs:6.0.191
```

```text
IMAGE                                   ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/ossrs/srs:6.0.191   2be08a0fe287        230MB         59.9MB
```

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `ossrs/srs:6.0.191` | `docker pull docker.xuanyuan.run/ossrs/srs:6.0.191` |

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq)。

---

## 五、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/srs` |
| **macOS** | **`~/docker/srs`** |

把 **`CANDIDATE`** 换成你的服务器可达 IP（本文实测 `192.168.1.35`）。只在本机试 RTMP、暂不做 WebRTC 时可以先不改，但浏览器跨机播 WebRTC 前必须改对。

### 5.1 准备目录并拷出静态页

镜像自带 Status 页和控制台在 `/usr/local/srs/objs/nginx/html`。跟做先拷到宿主机，再挂卷：

```bash
mkdir -p /www/wwwroot/srs
cd /www/wwwroot/srs

docker create --name srs-html docker.xuanyuan.run/ossrs/srs:6.0.191
docker cp srs-html:/usr/local/srs/objs/nginx/html ./html
docker rm srs-html

# macOS：把 /www/wwwroot/srs 换成 ~/docker/srs
```

非 root 给 `mkdir` / `docker` 加 `sudo`。拷完后 `./html` 里应有 `console` 等文件。已经用空目录启动过的，跳到 **5.4**。

### 5.2 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  srs:
    image: docker.xuanyuan.run/ossrs/srs:6.0.191
    container_name: srs
    restart: unless-stopped
    environment:
      - TZ=Asia/Shanghai
      - CANDIDATE=192.168.1.35
    ports:
      - "1935:1935"
      - "1985:1985"
      - "8080:8080"
      - "8000:8000/udp"
      - "10080:10080/udp"
    volumes:
      - ./html:/usr/local/srs/objs/nginx/html
EOF
```

| 项 | 说明 |
|----|------|
| 默认命令 | `./objs/srs -c conf/docker.conf`（RTMP、API、HTTP、HLS、RTC） |
| `CANDIDATE` | WebRTC 用；填客户端能访问的 IP，勿用 `127.0.0.1` |
| `./html` | Status / 控制台 / HLS 切片；须先按 5.1 拷出 |
| `10080/udp` | 留给以后换 `srt.conf`；默认配置**不会**收 SRT |
| 端口冲突 | 只改映射左侧 |

### 5.3 启动并验证

```bash
docker compose up -d
docker compose ps
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network srs_default Created
 ✔ Container srs       Started
```

```text
NAME      IMAGE                                   COMMAND                  SERVICE   CREATED         STATUS         PORTS
srs       docker.xuanyuan.run/ossrs/srs:6.0.191   "./objs/srs -c conf/…"   srs       4 seconds ago   Up 3 seconds   0.0.0.0:1935->1935/tcp, [::]:1935->1935/tcp, 0.0.0.0:1985->1985/tcp, [::]:1985->1985/tcp, 5060/tcp, 0.0.0.0:8000->8000/udp, [::]:8000->8000/udp, 0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp, 9000/tcp, 0.0.0.0:10080->10080/udp, [::]:10080->10080/udp
```

`PORTS` 里的 **5060 / 9000** 是镜像 EXPOSE，本文未映射，可忽略。

```bash
docker compose logs -f srs
```

成功关键行（实测；日志里的 `(Hang)` 是 6.0 发行代号，不是卡住）：

```text
srs  | [2026-09-03 13:39:35.739][INFO][1][5p8d1201] XCORE-SRS/6.0.191(Hang)
srs  | [2026-09-03 13:39:35.739][INFO][1][5p8d1201] SRS/6.0.191(Hang), MIT
srs  | [2026-09-03 13:39:35.740][INFO][1][5p8d1201] SRS on amd64 x86_64, conf:conf/docker.conf, limit:1000
srs  | [2026-09-03 13:39:35.753][INFO][1][5p8d1201] http: root mount to ./objs/nginx/html
srs  | [2026-09-03 13:39:35.753][INFO][1][5p8d1201] RTMP listen at tcp://0.0.0.0:1935, fd=9
srs  | [2026-09-03 13:39:35.753][INFO][1][5p8d1201] HTTP-API listen at tcp://0.0.0.0:1985, fd=10
srs  | [2026-09-03 13:39:35.753][INFO][1][5p8d1201] HTTP-Server listen at tcp://0.0.0.0:8080, fd=11
srs  | [2026-09-03 13:39:35.753][INFO][1][5p8d1201] http: api mount /console to ./objs/nginx/html/console
srs  | [2026-09-03 13:39:35.754][INFO][1][5p8d1201] rtc listen at udp://0.0.0.0:8000, fd=12
```

`Ctrl+C` 只退出日志跟踪。再探测：

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/
curl -s http://127.0.0.1:1985/api/v1/versions
```

按 **5.1** 拷过静态页后，`:8080/` 应为 **200**。API 实测：

```text
{"code":0,"server":"vid-134quy1","service":"q39qzpom","pid":"1","data":{"major":6,"minor":0,"revision":191,"version":"6.0.191"}}
```

服务是否起来，以 API 的 `"version":"6.0.191"` 为准。根路径若是 **404**，按 **5.4** 处理，不要当容器没启动。

浏览器打开 `http://192.168.1.35:8080/`，界面见第六节。

### 5.4 踩坑：空目录挂载导致 `:8080/` 返回 404

第一次实测时只建了空的 `./html` 就 `compose up`，根路径 **404**，但 API 已返回 `6.0.191`：HTTP 在听，只是把镜像里的 Status / 控制台盖掉了。HTTP-FLV 仍可播（`.flv` 走 remux，不靠首页文件）。

补拷（不改 Compose）：

```bash
cd /www/wwwroot/srs
docker compose stop
docker create --name srs-html docker.xuanyuan.run/ossrs/srs:6.0.191
docker cp srs-html:/usr/local/srs/objs/nginx/html/. ./html/
docker rm srs-html
docker compose start
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/
```

实测：`Successfully copied 10.7MB to /www/wwwroot/srs/html/`，随后 **200**。

---

## 六、推流与播放验证

同一局域网用 OBS 或 FFmpeg 推一路，再用浏览器或 VLC 拉。

### 6.1 Status 页

打开 `http://192.168.1.35:8080/`，应看到 **Congratulations! SRS works!**。页内已写好 OBS / FFmpeg 示例，IP 会带上当前主机地址。

![SRS Status 页：Congratulations! SRS works，OBS 与 FFmpeg 推流说明](https://imgs.xuanyuan.cloud/docker/blog/ossrs-1.webp)

控制台在页内链接，或直接打开 `http://192.168.1.35:8080/console/`（见 6.5）。

### 6.2 OBS 推流

OBS → **设置 → 直播**：

| 项 | 值 |
|----|-----|
| 服务 | **自定义…** |
| 服务器 | `rtmp://192.168.1.35/live` |
| 推流码 | `livestream` |
| 使用身份认证 | 可不勾 |

完整地址即 `rtmp://192.168.1.35/live/livestream`。确定后回主界面点「开始推流」。

![OBS 直播设置：服务自定义，服务器 rtmp://192.168.1.35/live](https://imgs.xuanyuan.cloud/docker/blog/ossrs-2.webp)

### 6.3 FFmpeg 推流（可选）

宿主机已装 FFmpeg 时：

```bash
ffmpeg -re -i /path/to/your.flv -c copy -f flv rtmp://192.168.1.35/live/livestream
```

官方文档也可用 `ossrs/srs:encoder` 镜像推示例片；Linux 上把目标写成宿主机 IP，不要写 `localhost`。本文未实测该镜像。

### 6.4 播放 HTTP-FLV / HLS

| 协议 | URL |
|------|-----|
| RTMP（VLC） | `rtmp://192.168.1.35/live/livestream` |
| HTTP-FLV | `http://192.168.1.35:8080/live/livestream.flv` |
| HLS | `http://192.168.1.35:8080/live/livestream.m3u8` |

Status 页点 **SRS播放器** 进入 LivePlayer，填 HTTP-FLV 地址后点 **Play**。也可用 VLC：**媒体 → 打开网络串流**。

![SRS LivePlayer：播放 http://192.168.1.35:8080/live/livestream.flv](https://imgs.xuanyuan.cloud/docker/blog/ossrs-3.webp)

HLS 把地址改成 `.m3u8` 即可。推流后稍等几秒再刷新切片。

### 6.5 控制台与 HTTP API

打开 `http://192.168.1.35:8080/console/`，进入 **概览**。实测可见 **SRS/6.0.191**、容器内 **PID 1**。

![SRS 控制台概览：SRS/6.0.191、运行时长与 PID 1](https://imgs.xuanyuan.cloud/docker/blog/ossrs-4.webp)

```bash
curl -s http://192.168.1.35:1985/api/v1/versions
curl -s http://192.168.1.35:1985/api/v1/streams/
```

推上之后，streams 里应能看到 `live/livestream`。

### 6.6 WebRTC（可选）

默认配置已开 RTC，并打开 RTMP ↔ WebRTC。要跨机在浏览器里播：

1. **`CANDIDATE`** 填对端能访问的 IP（日志里的 `172.28.0.2` 是容器网卡，不要填它）
2. 防火墙 / 安全组放行 **8000/udp**
3. 非本机推 WebRTC 时，浏览器通常要求 **HTTPS**（反代或官方 `https.docker.conf`）

WHEP 示例：

```text
http://192.168.1.35:1985/rtc/v1/whep/?app=live&stream=livestream
```

步骤以 [WebRTC 文档](https://ossrs.io/lts/en-us/docs/v6/doc/webrtc) / [中文](https://ossrs.net/lts/zh-cn/docs/v6/doc/webrtc) 为准。LivePlayer 顶栏也有 **WHIP / WHEP**。

### 6.7 生产加固

- **1935 / 1985 / 8080** 放内网或 VPN；公网前加反代与 TLS  
- 用 HTTP callback 做推流 / 播放鉴权  
- 改配置：拷出 `docker.conf` 挂回去，或启动命令改为 `./objs/srs -c conf/你的.conf`  
- DVR 路径指到已挂载目录，避免录在容器可写层里  
- 升级前备份 `./html`  

---

## 七、备份、升级与迁移

```bash
cd /www/wwwroot/srs
docker compose stop
tar -czf srs-backup-$(date +%F).tar.gz html docker-compose.yml
docker compose start
```

若另有自定义 `conf/`，一并打进包。

升级：查 [tags](https://xuanyuan.cloud/r/ossrs/srs/tags) → 改 Compose 标签 → `docker compose pull && docker compose up -d` → 用 API 与 `:8080` 核对版本。搬家时恢复同结构目录，在新机改 **`CANDIDATE`** 再启动。

---

## 八、备选：docker run

无 Compose 时可用；日常仍建议第五节。先按 **5.1** 拷出 `html`。

```bash
docker run -d --name srs \
  --restart unless-stopped \
  -e TZ=Asia/Shanghai \
  -e CANDIDATE=192.168.1.35 \
  -p 1935:1935 \
  -p 1985:1985 \
  -p 8080:8080 \
  -p 8000:8000/udp \
  -p 10080:10080/udp \
  -v /www/wwwroot/srs/html:/usr/local/srs/objs/nginx/html \
  docker.xuanyuan.run/ossrs/srs:6.0.191
```

```bash
docker ps --filter name=srs
docker logs -f srs
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/
docker stop srs && docker rm srs
```

---

## 九、常见问题 FAQ

**Q1：`:8080/` 是 404，但 API 正常？**  
空目录盖掉了静态页。按 **5.4** 补拷。API 返回 `"version":"6.0.191"` 就说明进程已起来。

**Q2：推流后黑屏？**  
确认 OBS 已「开始推流」，路径是 `live` / `livestream`。可直接用 `.flv` 或 VLC 播 RTMP，不必先打开 Status 页。

**Q3：WebRTC 连不上？**  
改对 **`CANDIDATE`**，放行 **8000/udp**；跨机推流注意 HTTPS。

**Q4：HLS 也是 404？**  
要先推上流，等切片出现在 `./html/live/`。刚开播时刷新稍等几秒。

**Q5：映射了 10080/udp 却推不了 SRT？**  
默认是 `docker.conf`，没开 SRT。要推 SRT 需改用官方 `conf/srt.conf`。

**Q6：可以改宿主机 8080 吗？**  
可以，例如 `"18080:8080"`，访问改为 `http://IP:18080/`。

**Q7：为什么不用 `latest` 或 `6`？**  
浮动标签会静默升级，步骤可能和文档对不上。跟做固定 **`6.0.191`**。

**Q8：和 ZLMediaKit 怎么选？**  
都是自托管流媒体。SRS 在 RTMP / WebRTC 直播文档上更常见；ZLMediaKit 在 RTSP / GB28181 上也很强。本站另有 [ZLMediaKit 部署教程](https://xuanyuan.cloud/blog/zlmediakit-docker-deploy)。

**Q9：有默认管理员账号吗？**  
没有。安全靠网络隔离和业务鉴权，不要把推流口暴露公网。

---

## 十、命令速查

```bash
docker pull docker.xuanyuan.run/ossrs/srs:6.0.191

cd /www/wwwroot/srs
# 先按 5.1 拷出 html
docker compose up -d
docker compose ps
docker compose logs -f srs
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/
curl -s http://127.0.0.1:1985/api/v1/versions

docker compose pull && docker compose up -d
docker compose down
```

---

## 十一、延伸阅读

| 资源 | 链接 |
|------|------|
| [ossrs/srs 镜像页](https://xuanyuan.cloud/zh/r/ossrs/srs) | [https://xuanyuan.cloud/zh/r/ossrs/srs](https://xuanyuan.cloud/zh/r/ossrs/srs) |
| [ossrs/srs 概览](https://xuanyuan.cloud/r/ossrs/srs) | [https://xuanyuan.cloud/r/ossrs/srs](https://xuanyuan.cloud/r/ossrs/srs) |
| [ossrs/srs 标签列表](https://xuanyuan.cloud/r/ossrs/srs/tags) | [https://xuanyuan.cloud/r/ossrs/srs/tags](https://xuanyuan.cloud/r/ossrs/srs/tags) |
| [SRS 官网 · Getting Started](https://ossrs.io/lts/en-us/docs/v6/doc/getting-started) | [https://ossrs.io/lts/en-us/docs/v6/doc/getting-started](https://ossrs.io/lts/en-us/docs/v6/doc/getting-started) |
| [SRS 中文 · 入门](https://ossrs.net/lts/zh-cn/docs/v6/doc/getting-started) | [https://ossrs.net/lts/zh-cn/docs/v6/doc/getting-started](https://ossrs.net/lts/zh-cn/docs/v6/doc/getting-started) |
| [GitHub · ossrs/srs](https://github.com/ossrs/srs) | [https://github.com/ossrs/srs](https://github.com/ossrs/srs) |
| [GitHub Release · v6.0-r1](https://github.com/ossrs/srs/releases/tag/v6.0-r1) | [https://github.com/ossrs/srs/releases/tag/v6.0-r1](https://github.com/ossrs/srs/releases/tag/v6.0-r1) |
| [Docker Hub · ossrs/srs](https://hub.docker.com/r/ossrs/srs) | [https://hub.docker.com/r/ossrs/srs](https://hub.docker.com/r/ossrs/srs) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

同站流媒体对照：[ZLMediaKit Docker 部署](https://xuanyuan.cloud/blog/zlmediakit-docker-deploy)。

---

## 总结

- 跟做 **`ossrs/srs:6.0.191`**：先拷 `html`，再 Compose 映射 **1935 / 1985 / 8080 / 8000/udp**  
- 打开 `http://IP:8080/`；OBS 推 `rtmp://IP/live` + 推流码 `livestream`；播 `.flv` / `.m3u8`  
- WebRTC 改对 **`CANDIDATE`**；公网不要裸露推流口和 API  
- 升级改具体版本标签，勿跟 `latest` / 浮动 `6`  

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/srs-docker-deploy


