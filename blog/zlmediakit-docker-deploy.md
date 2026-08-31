# Docker 部署 ZLMediaKit：轻松搭建高性能流媒体服务平台

![Docker 部署 ZLMediaKit：轻松搭建高性能流媒体服务平台](https://imgs.xuanyuan.cloud/docker/blog/zlmediakit.webp)

*分类: Docker部署教程 | 标签: ZLMediaKit,Docker,轩辕镜像,流媒体,RTSP,RTMP,WebRTC,HLS,GB28181,私有化部署,部署教程 | 发布时间: 2026-08-07 07:31:26*

> 做直播联调、安防预览或 WebRTC 低延迟播放时，常要把摄像头 / OBS / FFmpeg 的流转成浏览器能播的 HTTP-FLV、HLS、WebRTC。很多人先在本机堆 FFmpeg：推一路、转一路、再挂 Nginx 出 HLS——端口和路径一乱就难维护。协议再多一点（RTSP 设备、RTMP 推流、网页播放、国标 GB28181），临时脚本很快变成互不相干的一堆进程。

*本文基于 [zlmediakit/zlmediakit:master](https://xuanyuan.cloud/zh/r/zlmediakit/zlmediakit)，实测 **ZLMediaKit git hash `0e9e59b`（branch: master，2026-08-06）**，测试平台 **Ubuntu 24.04** Linux。*

做直播联调、安防预览或 WebRTC 低延迟播放时，常要把摄像头 / OBS / FFmpeg 的流转成浏览器能播的 HTTP-FLV、HLS、WebRTC。很多人先在本机堆 FFmpeg：推一路、转一路、再挂 Nginx 出 HLS——端口和路径一乱就难维护。协议再多一点（RTSP 设备、RTMP 推流、网页播放、国标 GB28181），临时脚本很快变成互不相干的一堆进程。

内网和小团队更想要的是**一台机器上的流媒体中枢**：能收推流、能转协议、能按需拉流，HTTP API / WebHook 好对接业务，媒体不出自己的服务器。商业云直播贵、出域不可控；从源码编译 MediaServer 又劝退运维。

**ZLMediaKit** 是开源的高性能流媒体服务框架（C++11），内置完整 **MediaServer**，支持 RTSP/RTMP/HLS/HTTP-FLV/WebSocket-FLV/HTTP-TS/fMP4/WebRTC/GB28181/SRT 等协议及互转，并提供 [RESTful API](https://github.com/ZLMediaKit/ZLMediaKit/wiki/MediaServer支持的HTTP-API) 与 [WebHook](https://github.com/ZLMediaKit/ZLMediaKit/wiki/MediaServer支持的HTTP-HOOK-API)。官方镜像 **`zlmediakit/zlmediakit`**（[镜像页](https://xuanyuan.cloud/zh/r/zlmediakit/zlmediakit)）由 GitHub CI 构建；本文跟做标签为 **`master`**。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 直播推流联调 | FFmpeg / OBS 推 `rtmp://IP:1935/live/test`，浏览器播 HTTP-FLV / HLS / WebRTC |
| 监控 / 设备接入 | RTSP 收流或 GB28181 / RTP，再转网页可播协议 |
| 低延迟网页播放 | WebRTC（UDP **8000**）与其它协议互转 |
| 业务对接 | HTTP API 查流、截图、录制；WebHook 做鉴权与统计 |

本文用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`zlmediakit/zlmediakit:master`**，以 **Docker Compose** 为主路径完成启动、FFmpeg 推流与 WebRTC / Swagger / webassist 验证；文末附 **`docker run` 备选**。文内附 **11** 张实测截图。

> **上手要点**  
> - **部署**：默认 **Compose**（第五节）；临时试玩见 **第八节 docker run**  
> - **标签**：**`master`**（上游无 semver 版号，见第三节）  
> - **端口**：宿主机 **8080 → 80**；另映射 1935、8554→554、8443→443、10000 TCP/UDP、8000/udp、9000/udp  
> - **数据卷**：`./conf` → `/opt/media/conf`，`./www` → `/opt/media/bin/www`  
> - **API secret**：首次启动常会**自动改写**并写回挂载的 `config.ini`，以 `grep '^secret='` 为准  
> - **首页**：`http://IP:8080/` 是目录索引；演示进 **`webrtc/`**，API 进 **`swagger/`**  
> - **暴露**：公网请防火墙 + 保管 secret + HTTPS / 反代  

镜像说明：[zlmediakit/zlmediakit](https://xuanyuan.cloud/zh/r/zlmediakit/zlmediakit) · [tags](https://xuanyuan.cloud/r/zlmediakit/zlmediakit/tags)。项目：[GitHub · ZLMediaKit](https://github.com/ZLMediaKit/ZLMediaKit) · [快速开始](https://github.com/ZLMediaKit/ZLMediaKit/wiki/快速开始)。许可证：**MIT**（含第三方依赖，商用请自行核对）。

---

## 一、ZLMediaKit 是什么？

| 能力 | 说明 |
|------|------|
| 多协议 | RTSP[S] / RTMP[S] / HLS / HTTP-FLV / WS-FLV / HTTP-TS / fMP4 / WebRTC / GB28181 / SRT 等 |
| 互转 | 推一种协议，可按需转其它协议播放 |
| MediaServer | 免二次开发即可当流媒体服务器；配置热加载 |
| 业务扩展 | HTTP API、WebHook、虚拟主机、按需拉流、录制与点播 |

| 方案 | 适合 |
|------|------|
| **ZLMediaKit（本文）** | 自托管多协议互转 + API，Docker 即可起 |
| 纯 FFmpeg 脚本 | 单路临时转码，不需要长期服务 |
| Nginx-RTMP 等 | 场景偏单一，WebRTC / GB28181 能力较弱 |
| 商业云直播 | 要免运维，可接受出域与按量费用 |

轩辕上的 `/r/`、`/zh/r/`、`/tags` 指向**同一镜像** `zlmediakit/zlmediakit`（概览 / 中文简介 / 标签列表），不是多个仓库。镜像页「相关推荐」里的 **`panjjo/zlmediakit`** 是第三方坐标，本文不跟做。

```text
浏览器 / 播放器 ──:8080──▶ HTTP（容器内 :80）/ API、静态页
OBS / FFmpeg    ──:1935──▶ RTMP
播放器 / NVR    ──:8554──▶ RTSP（容器内 :554）
WebRTC          ──:8000/udp──▶ WebRTC
国标 / RTP      ──:10000──▶ TCP/UDP
SRT             ──:9000/udp──▶ SRT
./conf          ──挂载──▶ /opt/media/conf
./www           ──挂载──▶ /opt/media/bin/www
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 内存 | ≥ **1～2 GB** 可用（并发与转协议越高要求越高） |
| 磁盘 | CONTENT SIZE 约 **356 MB**（DISK USAGE 约 **1.38 GB**）+ 录制 / HLS 增长 |
| 架构 | **amd64 / arm64** |
| 端口 | 至少 **8080**；完整推拉流再放行 1935、8554、8443、10000、8000/udp、9000/udp |

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

> 宿主机 **8080** 占用时改为 `"18080:80"`，文中访问地址同步改端口。**1935** 冲突则改 `"11935:1935"`，推流 URL 一并修改。

---

## 三、标签怎么选

该仓库目前**没有** `1.x.y` 这类版号标签，只有分支 / 特性浮动标签。官方 README 的 `docker run` 示例使用 **`master`**，故本文主路径钉 **`master`**（滚动更新，生产建议另记 Digest 或预发验证）。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`master`** | 跟随 master 分支 CI | **本文跟做** |
| **`master_py`** | 含 pymkui 等 Python 插件构建 | 明确需要该能力时再换 |
| `feature-*` | 特性 / 实验线 | 仅尝鲜 |

完整列表：[tags](https://xuanyuan.cloud/r/zlmediakit/zlmediakit/tags)。日常直播联调不必换 `master_py`；升级前备份 `conf/` 与录制目录。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/zlmediakit/zlmediakit:master
```

Ubuntu 24.04 实测：

```text
master: Pulling from zlmediakit/zlmediakit
6677595589fa: Pull complete
966c395d29cb: Pull complete
4f4fb700ef54: Pull complete
d4661f06ddf1: Pull complete
36d95e920650: Pull complete
454d489d482f: Pull complete
e679ae3bc3c0: Pull complete
61119d72111f: Download complete
Digest: sha256:36410213e44faf95ab55fda6d2f3c8f19fc29e42209821464c3cece07b5481d4
Status: Downloaded newer image for docker.xuanyuan.run/zlmediakit/zlmediakit:master
docker.xuanyuan.run/zlmediakit/zlmediakit:master
```

```bash
docker images docker.xuanyuan.run/zlmediakit/zlmediakit:master
```

```text
IMAGE                                              ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/zlmediakit/zlmediakit:master   36410213e44f       1.38GB          356MB
```

---

## 五、Docker Compose 部署（推荐）

工作目录：`/www/wwwroot/zlmediakit`（macOS 请用 **`~/docker/zlmediakit`**）。

### 5.1 创建目录

```bash
mkdir -p /www/wwwroot/zlmediakit/{conf,www,logs}
chown -R "$USER:$USER" /www/wwwroot/zlmediakit
cd /www/wwwroot/zlmediakit
```

非 root 时给 `mkdir` / `chown` 加 `sudo`。

### 5.2 导出默认配置（首次）

把镜像内默认 `config.ini` 与 `www` 拷到宿主机，便于改配置、挂载持久化：

```bash
docker create --name zlm-tmp docker.xuanyuan.run/zlmediakit/zlmediakit:master
docker cp zlm-tmp:/opt/media/conf/. ./conf/
docker cp zlm-tmp:/opt/media/bin/www/. ./www/
docker rm zlm-tmp
```

可先启动；首次若判定默认 `api.secret` 无效，MediaServer 会**自动生成新 secret 并写回**挂载的 `config.ini`。之后以 `grep '^secret=' conf/config.ini` 为准。其它项见 [配置文件详解](https://github.com/ZLMediaKit/ZLMediaKit/wiki/配置文件详解)。

### 5.3 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  zlmediakit:
    image: docker.xuanyuan.run/zlmediakit/zlmediakit:master
    container_name: zlmediakit
    restart: unless-stopped
    ports:
      - "1935:1935"           # RTMP
      - "8080:80"             # HTTP（网页 / HLS / HTTP-FLV / API）
      - "8443:443"            # HTTPS
      - "8554:554"            # RTSP
      - "10000:10000"         # RTP / GB28181 等（TCP）
      - "10000:10000/udp"
      - "8000:8000/udp"       # WebRTC
      - "9000:9000/udp"       # SRT
    environment:
      TZ: Asia/Shanghai
    volumes:
      - ./conf:/opt/media/conf
      - ./www:/opt/media/bin/www
      - ./logs:/opt/media/bin/log
EOF
```

| 项 | 作用 |
|----|------|
| `"8080:80"` | 浏览器、HTTP 播放、API |
| `"1935:1935"` | RTMP 推拉 |
| `"8554:554"` | RTSP（沿用官方示例映射） |
| `"8000:8000/udp"` | WebRTC |
| `./conf` → `/opt/media/conf` | 配置（含 secret） |
| `./www` → `/opt/media/bin/www` | HTTP 根目录 |

端口与官方 README 示例一致。

### 5.4 启动与验证

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 80
```

Ubuntu 实测：

```text
[+] Running 2/2
 ✔ Network zlmediakit_default  Created
 ✔ Container zlmediakit        Started

NAME         IMAGE                                              COMMAND                  SERVICE      CREATED         STATUS         PORTS
zlmediakit   docker.xuanyuan.run/zlmediakit/zlmediakit:master   "./MediaServer -s de…"   zlmediakit   5 seconds ago   Up 4 seconds   0.0.0.0:8000->8000/udp, ... 0.0.0.0:1935->1935/tcp, ... 0.0.0.0:8080->80/tcp, ... 0.0.0.0:8554->554/tcp, ...
```

日志关键行（节选）：

```text
ZLMediaKit(git hash:0e9e59b/2026-08-06T21:27:05+08:00,branch:master,build time:2026-08-06T13:44:03)
The api.secret is invalid, modified it to: <已自动生成>, saved config file: ../conf/config.ini
已启动http api 接口
已启动http hook 接口
TCP server[mediakit::HttpSession] listening on [::]: 80
TCP server[mediakit::RtmpSession] listening on [::]: 1935
TCP server[mediakit::RtspSession] listening on [::]: 554
UDP server[mediakit::WebRtcSession] bind to [::]: 8000
```

```bash
grep '^secret=' /www/wwwroot/zlmediakit/conf/config.ini
```

浏览器打开 `http://服务器IP:8080/`，看到 **Index of /**：

![ZLMediaKit 首页 Index of /：readme、swagger、webassist、webrtc 等目录](https://imgs.xuanyuan.cloud/docker/blog/zlmediakit-1.webp)

| 目录 | 作用 |
|------|------|
| **`webrtc/`** | WebRTC 推 / 播演示（下一节） |
| **`swagger/`** | HTTP API 文档 |
| **`webassist/`** | 调试助手（须带 `?secret=`；空目录时见第七节） |
| `readme/` | 说明 |

打开 `http://服务器IP:8080/webrtc/` 时，在纯 HTTP 下可能弹出「浏览器推流需 HTTPS」——点确定即可。用 FFmpeg 推流 + 页面 **play** 播放，不依赖该提示。

![ZLMediaKit WebRTC 演示：HTTP 下提示浏览器推流需 HTTPS](https://imgs.xuanyuan.cloud/docker/blog/zlmediakit-2.webp)

---

## 六、推流与播放

以下以应用名 **`live`**、流 ID **`test`** 为例。宿主机 HTTP 口为 **8080** 时，播放 URL 用 **8080**（不是容器内 80）。

### 6.1 FFmpeg 推 RTMP

测试源（无视频文件也可）：

```bash
ffmpeg -re -f lavfi -i testsrc=size=1280x720:rate=25 -f lavfi -i sine=frequency=1000 \
  -c:v libx264 -preset veryfast -tune zerolatency -c:a aac -f flv \
  rtmp://127.0.0.1:1935/live/test
```

Ubuntu 实测：FFmpeg **6.1.1**，H.264 1280×720@25 + AAC，推到 `rtmp://127.0.0.1:1935/live/test`；`q` / Ctrl+C 结束即可。

本地文件或 OBS：

```bash
ffmpeg -re -i 你的视频文件.mp4 -c copy -f flv rtmp://127.0.0.1:1935/live/test
```

OBS：服务选「自定义」，服务器 `rtmp://服务器IP:1935/live`，串流密钥 `test`。

### 6.2 浏览器 WebRTC 播放

打开 `http://服务器IP:8080/webrtc/`，**method** 选 **`play`**，url 保持与推流一致：

```text
http://服务器IP:8080/index/api/webrtc?app=live&stream=test&type=play
```

点 **开始(start)**。

![ZLMediaKit /webrtc/：method 选 play，url 指向 live/test](https://imgs.xuanyuan.cloud/docker/blog/zlmediakit-3.webp)

若勾选了 `useCamera`，左侧多为**本地摄像头 / 预览**（彩条或实景）；右侧才是 WebRTC **播放**窗口。验证 FFmpeg 推流是否在线时，以右侧播放、以及下一节的 `getMediaList` 为准。

![ZLMediaKit /webrtc/：左侧本地预览，右侧 WebRTC 播放区](https://imgs.xuanyuan.cloud/docker/blog/zlmediakit-4.webp)

其它播放地址（推流保持时可用 VLC 等试）：

| 协议 | 示例 URL |
|------|----------|
| HTTP-FLV | `http://服务器IP:8080/live/test.live.flv` |
| HLS | `http://服务器IP:8080/live/test/hls.m3u8` |
| RTMP | `rtmp://服务器IP:1935/live/test` |
| RTSP | `rtsp://服务器IP:8554/live/test` |

路径规则见 [播放 URL 规则](https://github.com/ZLMediaKit/ZLMediaKit/wiki/播放url规则)。浏览器内 **push**（摄像头推 WebRTC）在非 HTTPS 下常被浏览器拦截，见 [开启 HTTPS](https://github.com/ZLMediaKit/ZLMediaKit/wiki/怎么开启https相关功能)。

### 6.3 HTTP API / Swagger

```bash
grep '^secret=' /www/wwwroot/zlmediakit/conf/config.ini
SECRET='粘贴上一步的值'
curl -s "http://127.0.0.1:8080/index/api/getMediaList?secret=${SECRET}"
```

有推流时应能看到 `live` / `test`。也可用 Swagger：`http://服务器IP:8080/swagger/`，展开 `getMediaList`，填入 secret 后执行。

![ZLMediaKit Swagger UI：HTTP API 列表含 getMediaList、addStreamProxy 等](https://imgs.xuanyuan.cloud/docker/blog/zlmediakit-5.webp)

接口说明：[MediaServer 支持的 HTTP API](https://github.com/ZLMediaKit/ZLMediaKit/wiki/MediaServer支持的HTTP-API)。

---

## 七、webassist 调试助手

[zlm_webassist](https://github.com/1002victor/zlm_webassist) 是纯前端调试页：流列表、踢 Session、拉/推流代理、FFmpeg 任务、RTP 口、部分配置。**URL 必须带 secret**，否则调不了 API：

```text
http://服务器IP:8080/webassist/?secret=你的secret
```

首页（无推流时「暂无数据」正常）：

![ZLMediaKit webassist 首页：流信息与连接信息表](https://imgs.xuanyuan.cloud/docker/blog/zlmediakit-7.webp)

| 菜单 | 用途 |
|------|------|
| WebRTC测试 | 与 `/webrtc/` 类似的推 / 播调试 |
| 拉流代理 | 填源地址，让 ZLM 拉流转发 |
| 推流代理 | 把已有流（如 `live/test`）转推到远端 |
| FFmpeg推拉流 | 用服务端 FFmpeg 模板做推拉 |
| Rtp服务 | 开 RTP 收流口（国标等） |
| 服务器配置 | 读 / 改部分配置（谨慎） |

![ZLMediaKit webassist · WebRTC测试：url 指向 live/test，method 选 play](https://imgs.xuanyuan.cloud/docker/blog/zlmediakit-6.webp)

![ZLMediaKit webassist · 拉流代理：应用名 live、流 id test](https://imgs.xuanyuan.cloud/docker/blog/zlmediakit-8.webp)

![ZLMediaKit webassist · 推流代理：填写转推地址后点增加](https://imgs.xuanyuan.cloud/docker/blog/zlmediakit-9.webp)

![ZLMediaKit webassist · FFmpeg推拉流：源地址与目的地址](https://imgs.xuanyuan.cloud/docker/blog/zlmediakit-10.webp)

![ZLMediaKit webassist · Rtp服务：应用名 rtp、被动模式](https://imgs.xuanyuan.cloud/docker/blog/zlmediakit-11.webp)

官方仓库里 `www/webassist` 是 **git 子模块**，镜像 `docker cp` 出来常是空目录。若只有 Index、没有管理界面：

```bash
cd /www/wwwroot/zlmediakit
rm -rf www/webassist
git clone --depth 1 https://github.com/1002victor/zlm_webassist.git www/webassist
```

乱码时把 `conf/config.ini` 中 `[http]` 的 `charSet` 改为 `utf-8`，再 `docker compose restart`。作者写明**不建议公网对外开放**此助手。

最小闭环用 **`/webrtc/`** + **`/swagger/`** 即可；webassist 适合当调试台。生产另做鉴权、TLS，并限制端口暴露。

---

## 八、备选：docker run

仅临时试玩或没有 Compose 时使用；日常跟做仍用第五节。

```bash
docker run -d \
  --name zlmediakit \
  --restart unless-stopped \
  -p 1935:1935 \
  -p 8080:80 \
  -p 8443:443 \
  -p 8554:554 \
  -p 10000:10000 \
  -p 10000:10000/udp \
  -p 8000:8000/udp \
  -p 9000:9000/udp \
  -v /www/wwwroot/zlmediakit/conf:/opt/media/conf \
  -v /www/wwwroot/zlmediakit/www:/opt/media/bin/www \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/zlmediakit/zlmediakit:master
```

一次性试玩可去掉 `-d` / 挂载并加 `--rm`。与 Compose 容器重名时先 `docker compose down` 或换 `--name`。

---

## 九、迁移 / 升级

1. `docker compose stop`，备份 `conf/`、`www/`、录制与日志  
2. `docker pull docker.xuanyuan.run/zlmediakit/zlmediakit:master`（或已验证 Digest）  
3. `docker compose up -d`  
4. 推测试流 + `getMediaList` + 抽查一种播放协议  
5. 异常则回退旧 Digest / 备份配置  

`master` 会随上游滚动，生产做好备份与变更窗口。

---

## 十、常见问题 FAQ

**Q1：`master` 和 `master_py` 怎么选？**  
默认 **`master`**。需要 pymkui 等 Python 插件时再换 **`master_py`**。

**Q2：打不开 `http://IP:8080`？**  
查 `docker compose ps` / `logs`；放行 **8080**；确认映射是 `8080:80`。

**Q3：打开 `/webrtc/` 弹出「需要 https」？**  
浏览器摄像头推流需要安全上下文。点确定后，用 **FFmpeg/OBS 推 RTMP** + 页面 **play** 即可验证；浏览器 push 请配 HTTPS（8443）或反代证书。

**Q4：能推流但播不了？**  
核对应用名 / 流 ID（本文为 `live` / `test`）；WebRTC 页 method 为 **play**，url 含 `app=live&stream=test`。HLS 有切片延迟属正常。见 [播放 URL 规则](https://github.com/ZLMediaKit/ZLMediaKit/wiki/播放url规则)。

**Q5：API / webassist 无权限？**  
敏感接口需要 `secret=`，以挂载的 `conf/config.ini` 为准（首次启动可能已自动改写）。勿使用网上流传的旧默认值。

**Q6：WebRTC 连不上？**  
放行 **8000/udp**，并按官方 Wiki 配置对外 IP / 证书。

**Q7：GB28181 怎么接？**  
涉及 SIP 与设备侧，见官方 GB28181 Wiki；确保 **10000** TCP/UDP 可达。

**Q8：为什么不用 `latest`？**  
官方示例与可用主线标签是 **`master`**，且暂无稳定 semver。勿与第三方 `panjjo/zlmediakit` 混淆。

**Q9：改了 config.ini 不生效？**  
确认挂载 `/opt/media/conf`；不确定时 `docker compose restart`。

**Q10：日志里还有 3000 / 3001？**  
容器内 WebRTC 信令会监听这些端口；本文 Compose **未**映射到宿主机（也避免占用宿主机 3000）。HTTP / 常用 WebRTC API 走 **8080→80** 即可。

---

## 十一、命令速查

```bash
docker pull docker.xuanyuan.run/zlmediakit/zlmediakit:master

cd /www/wwwroot/zlmediakit
docker compose up -d
docker compose ps
docker compose logs -f --tail 100
grep '^secret=' conf/config.ini

# 浏览器 http://服务器IP:8080/webrtc/
# 推流 rtmp://服务器IP:1935/live/test
# curl -s "http://127.0.0.1:8080/index/api/getMediaList?secret=你的secret"

docker compose down
```

---

## 十二、延伸阅读

- [zlmediakit/zlmediakit 镜像页](https://xuanyuan.cloud/zh/r/zlmediakit/zlmediakit) · [标签列表](https://xuanyuan.cloud/r/zlmediakit/zlmediakit/tags)
- [GitHub · ZLMediaKit](https://github.com/ZLMediaKit/ZLMediaKit)
- [快速开始](https://github.com/ZLMediaKit/ZLMediaKit/wiki/快速开始) · [播放 URL 规则](https://github.com/ZLMediaKit/ZLMediaKit/wiki/播放url规则) · [配置文件详解](https://github.com/ZLMediaKit/ZLMediaKit/wiki/配置文件详解)
- [HTTP API](https://github.com/ZLMediaKit/ZLMediaKit/wiki/MediaServer支持的HTTP-API) · [HTTP HOOK](https://github.com/ZLMediaKit/ZLMediaKit/wiki/MediaServer支持的HTTP-HOOK-API)
- [zlm_webassist](https://github.com/1002victor/zlm_webassist)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)

---

## 总结

- 跟做镜像 **`zlmediakit/zlmediakit:master`**；`/r/` 与 `/zh/r/` 是同一镜像的不同页面，`master_py` 为同仓库可选变体。  
- **Compose** 映射官方端口并挂载 **`conf` / `www`**；secret 以启动后的 `config.ini` 为准。  
- FFmpeg 推 `live/test` 后，用 `/webrtc/`（play）、`/swagger/` 或 `webassist/?secret=…` 验证。

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/zlmediakit-docker-deploy


