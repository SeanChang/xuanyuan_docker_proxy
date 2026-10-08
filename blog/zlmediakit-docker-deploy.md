# Docker 部署 ZLMediaKit：轻松搭建多协议流媒体服务平台

![Docker 部署 ZLMediaKit：轻松搭建多协议流媒体服务平台](https://imgs.xuanyuan.cloud/docker/blog/zlmediakit.webp)

*分类: Docker部署教程 | 标签: ZLMediaKit,Docker,轩辕镜像,流媒体,RTSP,RTMP,WebRTC,HLS,GB28181,私有化部署,部署教程 | 发布时间: 2026-08-07 07:31:26*

> ZLMediaKit 是开源流媒体服务，内置 MediaServer，可把 RTSP、RTMP 转成 HLS、HTTP-FLV 与 WebRTC。本文用 Docker Compose 部署 zlmediakit/zlmediakit 之后，可以用 FFmpeg 推一路测试流，并在浏览器里播放。适合直播联调、监控预览与内网低延迟播放。

*本文基于 [zlmediakit/zlmediakit:master](https://xuanyuan.cloud/zh/r/zlmediakit/zlmediakit)，实测引擎 **git hash 0e9e59b**（branch master，2026-08-06），测试平台 **Ubuntu 24.04** Linux。*

做直播联调时，摄像头、OBS 和 FFmpeg 各推一路，网页播放却要 HTTP-FLV 或 HLS，会议室还要再转一路 WebRTC。监控预览走 RTSP，国标设备又是另一套 GB28181。本机上先开 FFmpeg 转封装，再挂 Nginx 切 HLS，端口和路径一对就乱。推得上、浏览器播不出时，日志散在好几个终端里。协议再多一个，临时脚本就变成互不相干的一堆进程。

把流转到商业云直播，延迟和费用按量走，录像还要离开自己的机房。从源码编译一套 MediaServer，依赖和编译参数又劝退日常运维。内网和小团队更想要一台机器上的流媒体服务：能收推流、能转协议、能按需拉流，用 HTTP API 和 WebHook 对接业务，媒体文件留在自己的服务器上。

**ZLMediaKit**（[GitHub](https://github.com/ZLMediaKit/ZLMediaKit)、[镜像页](https://xuanyuan.cloud/zh/r/zlmediakit/zlmediakit)）是开源的流媒体服务框架，内置 MediaServer，支持 RTSP、RTMP、HLS、HTTP-FLV、WebRTC、GB28181、SRT 等协议及互转，并提供 HTTP API 与 WebHook。官方镜像 **`zlmediakit/zlmediakit`** 由 GitHub CI 构建。本文使用 **`zlmediakit/zlmediakit:master`** 版本实测。项目自有代码为 MIT 许可证，含第三方依赖，商用前请自行核对。

跑通之后，可以用 FFmpeg 或 OBS 把测试流推到这台服务器，在浏览器里用 HTTP-FLV、HLS 或 WebRTC 播放。监控设备的 RTSP 和国标也可以转成网页能播的协议。业务侧可以用 HTTP API 查流、截图和录制，用 WebHook 做鉴权。

---

## 一、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 内存 | 至少 **1～2 GB** 可用。并发和转协议越高，占用越高 |
| 磁盘 | 本次实测 CONTENT SIZE 约 **356 MB**，DISK USAGE 约 **1.38 GB**。录制和 HLS 还会继续增长 |
| 架构 | **amd64**、**arm64** |
| 端口 | 至少放行 **8080**。要完整推拉流，再放行 **1935**、**8554**、**8443**、**10000**、**8000/udp**、**9000/udp** |
| 工作目录 | `/www/wwwroot/zlmediakit`。macOS 上改为 `~/docker/zlmediakit` |

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

更多见[轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

宿主机 **8080** 已被占用时，把映射改成 `"18080:80"`，文中的访问地址同步改端口。**1935** 冲突时改成 `"11935:1935"`，推流 URL 一并修改。

---

## 二、标签怎么选

该仓库目前没有 `1.x.y` 这类版本号标签，只有分支和特性标签。官方 README 的 `docker run` 示例使用 **`master`**。上游没有可用的版本号标签，本文因此使用 **`master`**。这个标签会随 master 分支滚动。生产环境请另外记下 Digest，或先在预发环境验证，再替换正在使用的镜像。

| 标签 | 含义 | 建议 |
|------|------|------|
| **`master`** | 跟随 master 分支的 CI 构建 | **本文使用** |
| **`master_py`** | 含 pymkui 等 Python 插件的构建 | 明确需要该能力时再换 |
| `feature-*` | 特性或实验线 | 只作尝鲜 |

完整列表见[标签列表](https://xuanyuan.cloud/r/zlmediakit/zlmediakit/tags)。日常直播联调用 **`master`** 即可。升级前先备份 `conf/` 和录制目录。

---

## 三、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/zlmediakit/zlmediakit:master
```

下面是 Ubuntu 24.04 上的实测输出。`master` 会更新，再次拉取时 Digest 可能和这里不同。

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

## 四、Docker Compose 部署（推荐）

工作目录用 `/www/wwwroot/zlmediakit`。macOS 上改为 **`~/docker/zlmediakit`**。

### 4.1 创建目录

```bash
mkdir -p /www/wwwroot/zlmediakit/{conf,www,logs}
chown -R "$USER:$USER" /www/wwwroot/zlmediakit
cd /www/wwwroot/zlmediakit
```

当前用户不是 root 时，给 `mkdir` 和 `chown` 加上 `sudo`。

### 4.2 导出默认配置（首次）

先把镜像里的默认 `config.ini` 和 `www` 拷到宿主机，再改配置、做持久化。

```bash
docker create --name zlm-tmp docker.xuanyuan.run/zlmediakit/zlmediakit:master
docker cp zlm-tmp:/opt/media/conf/. ./conf/
docker cp zlm-tmp:/opt/media/bin/www/. ./www/
docker rm zlm-tmp
```

首次启动时，若 MediaServer 判定默认 `api.secret` 无效，会自动生成新的 secret，并写回已挂载的 `config.ini`。启动之后以 `grep '^secret=' conf/config.ini` 的输出为准。其它配置项见[配置文件详解](https://github.com/ZLMediaKit/ZLMediaKit/wiki/配置文件详解)。

### 4.3 编写 compose.yaml

```bash
cd /www/wwwroot/zlmediakit
cat > compose.yaml <<'EOF'
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
| `"8080:80"` | 浏览器、HTTP 播放、API。左侧是宿主机端口 |
| `"1935:1935"` | RTMP 推拉 |
| `"8554:554"` | RTSP。沿用官方示例，宿主机 **8554** 对应容器 **554** |
| `"8443:443"` | HTTPS |
| `"8000:8000/udp"` | WebRTC |
| `"9000:9000/udp"` | SRT |
| `"10000:10000"` 与 `"10000:10000/udp"` | RTP、GB28181 |
| `./conf` → `/opt/media/conf` | 配置，含 secret |
| `./www` → `/opt/media/bin/www` | HTTP 根目录 |
| `./logs` → `/opt/media/bin/log` | 日志 |

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

端口与官方 README 示例一致。对公网开放时，用防火墙限制来源，保管 `config.ini` 里的 secret，并用 HTTPS 或反向代理。

### 4.4 启动与验证

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

![ZLMediaKit 首页 Index of /：readme、swagger、webassist、webrtc 等目录](https://img.xuanyuan.dev/docker/blog/zlmediakit-1.webp)

| 目录 | 作用 |
|------|------|
| **`webrtc/`** | WebRTC 推流和播放演示，用法见下一节 |
| **`swagger/`** | HTTP API 文档 |
| **`webassist/`** | 调试助手，地址必须带 `?secret=`。目录是空的时，按「六、webassist 调试助手」补页面 |
| `readme/` | 说明 |

打开 `http://服务器IP:8080/webrtc/` 时，在纯 HTTP 下可能弹出「浏览器推流需 HTTPS」。点确定即可。后面用 FFmpeg 推流，再在页面上选「play」播放，不依赖这条提示。

![ZLMediaKit WebRTC 演示：HTTP 下提示浏览器推流需 HTTPS](https://img.xuanyuan.dev/docker/blog/zlmediakit-2.webp)

---

## 五、推流与播放

以下以应用名 **`live`**、流 ID **`test`** 为例。宿主机 HTTP 端口是 **8080** 时，播放 URL 用 **8080**，不是容器内的 **80**。

### 5.1 FFmpeg 推 RTMP

没有视频文件时，可以用测试源：

```bash
ffmpeg -re -f lavfi -i testsrc=size=1280x720:rate=25 -f lavfi -i sine=frequency=1000 
  -c:v libx264 -preset veryfast -tune zerolatency -c:a aac -f flv 
  rtmp://127.0.0.1:1935/live/test
```

Ubuntu 实测：FFmpeg **6.1.1**，H.264 1280×720@25 + AAC，推到 `rtmp://127.0.0.1:1935/live/test`。按 `q` 或 Ctrl+C 结束。

本地文件：

```bash
ffmpeg -re -i 你的视频文件.mp4 -c copy -f flv rtmp://127.0.0.1:1935/live/test
```

OBS 里服务选「自定义」，服务器填 `rtmp://服务器IP:1935/live`，串流密钥填 `test`。

### 5.2 浏览器 WebRTC 播放

打开 `http://服务器IP:8080/webrtc/`。method 选「play」。url 与推流保持一致：

```text
http://服务器IP:8080/index/api/webrtc?app=live&stream=test&type=play
```

点「开始(start)」。

![ZLMediaKit /webrtc/：method 选 play，url 指向 live/test](https://img.xuanyuan.dev/docker/blog/zlmediakit-3.webp)

若勾选了「useCamera」，左侧多为本地摄像头或预览（彩条或实景），右侧才是 WebRTC 播放窗口。确认 FFmpeg 推流是否在线时，看右侧播放，以及下一节的 `getMediaList`。

![ZLMediaKit /webrtc/：左侧本地预览，右侧 WebRTC 播放区](https://img.xuanyuan.dev/docker/blog/zlmediakit-4.webp)

推流保持时，也可以用 VLC 等播放器试下面的地址：

| 协议 | 示例 URL |
|------|----------|
| HTTP-FLV | `http://服务器IP:8080/live/test.live.flv` |
| HLS | `http://服务器IP:8080/live/test/hls.m3u8` |
| RTMP | `rtmp://服务器IP:1935/live/test` |
| RTSP | `rtsp://服务器IP:8554/live/test` |

路径规则见[播放 URL 规则](https://github.com/ZLMediaKit/ZLMediaKit/wiki/播放url规则)。浏览器里的「push」（用摄像头推 WebRTC）在非 HTTPS 下常被拦截，见[开启 HTTPS](https://github.com/ZLMediaKit/ZLMediaKit/wiki/怎么开启https相关功能)。

### 5.3 HTTP API / Swagger

```bash
grep '^secret=' /www/wwwroot/zlmediakit/conf/config.ini
SECRET='粘贴上一步的值'
curl -s "http://127.0.0.1:8080/index/api/getMediaList?secret=${SECRET}"
```

有推流时，返回里应能看到 `live` 和 `test`。也可以打开 `http://服务器IP:8080/swagger/`，展开 `getMediaList`，填入 secret 后执行。

![ZLMediaKit Swagger UI：HTTP API 列表含 getMediaList、addStreamProxy 等](https://img.xuanyuan.dev/docker/blog/zlmediakit-5.webp)

接口说明见[MediaServer 支持的 HTTP API](https://github.com/ZLMediaKit/ZLMediaKit/wiki/MediaServer支持的HTTP-API)。

---

## 六、webassist 调试助手

[zlm_webassist](https://github.com/1002victor/zlm_webassist) 是纯前端调试页，可以看流列表、踢 Session、配置拉流和推流代理、跑 FFmpeg 任务、开 RTP 口，以及改一部分配置。地址必须带 secret，否则调不了 API：

```text
http://服务器IP:8080/webassist/?secret=你的secret
```

还没有推流时，首页显示「暂无数据」是正常的。

![ZLMediaKit webassist 首页：流信息与连接信息表](https://img.xuanyuan.dev/docker/blog/zlmediakit-7.webp)

| 菜单 | 用途 |
|------|------|
| 「WebRTC测试」 | 与 `/webrtc/` 类似的推流、播放调试 |
| 「拉流代理」 | 填写源地址，让 ZLMediaKit 拉流转发 |
| 「推流代理」 | 把已有流（如 `live/test`）转推到远端 |
| 「FFmpeg推拉流」 | 用服务端 FFmpeg 模板做推拉 |
| 「Rtp服务」 | 开 RTP 收流口，用于国标等 |
| 「服务器配置」 | 读取或修改一部分配置。改之前先备份 `config.ini` |

![ZLMediaKit webassist · WebRTC测试：url 指向 live/test，method 选 play](https://img.xuanyuan.dev/docker/blog/zlmediakit-6.webp)

![ZLMediaKit webassist · 拉流代理：应用名 live、流 id test](https://img.xuanyuan.dev/docker/blog/zlmediakit-8.webp)

![ZLMediaKit webassist · 推流代理：填写转推地址后点增加](https://img.xuanyuan.dev/docker/blog/zlmediakit-9.webp)

![ZLMediaKit webassist · FFmpeg推拉流：源地址与目的地址](https://img.xuanyuan.dev/docker/blog/zlmediakit-10.webp)

![ZLMediaKit webassist · Rtp服务：应用名 rtp、被动模式](https://img.xuanyuan.dev/docker/blog/zlmediakit-11.webp)

官方仓库里 `www/webassist` 是 git 子模块，用 `docker cp` 拷出来时常是空目录。页面只有目录索引、没有管理界面时，再拉取前端：

```bash
cd /www/wwwroot/zlmediakit
rm -rf www/webassist
git clone --depth 1 https://github.com/1002victor/zlm_webassist.git www/webassist
```

页面乱码时，先把 `conf/config.ini` 中 `[http]` 的 `charSet` 改成 `utf-8`，再执行 `docker compose restart`。作者写明不建议把这个助手暴露到公网。

只验证推流和播放时，用 `/webrtc/` 和 `/swagger/` 即可。webassist 适合当作调试台。生产环境另外做鉴权、TLS，并限制端口暴露。

---

## 七、备选：docker run

没有 Compose 时用这一节。日常部署仍用「四、Docker Compose 部署」。已经用 Compose 起过同名容器时，先执行 `docker compose down`，或换一个 `--name`。

```bash
docker run -d 
  --name zlmediakit 
  --restart unless-stopped 
  -p 1935:1935 
  -p 8080:80 
  -p 8443:443 
  -p 8554:554 
  -p 10000:10000 
  -p 10000:10000/udp 
  -p 8000:8000/udp 
  -p 9000:9000/udp 
  -v /www/wwwroot/zlmediakit/conf:/opt/media/conf 
  -v /www/wwwroot/zlmediakit/www:/opt/media/bin/www 
  -e TZ=Asia/Shanghai 
  docker.xuanyuan.run/zlmediakit/zlmediakit:master
```

只想临时看一眼时，去掉 `-d` 和两个 `-v`，并加上 `--rm`。配置和网页目录不会留在宿主机上。

---

## 八、迁移与升级

`master` 会随上游滚动。生产环境先备份，再安排变更窗口。

1. 执行 `docker compose stop`。
2. 备份 `conf/`、`www/`、录制目录和日志。
3. 拉取新镜像。要固定某一次构建时，改用已经验证过的 Digest。

   ```bash
   docker pull docker.xuanyuan.run/zlmediakit/zlmediakit:master
   ```

4. 执行 `docker compose up -d`。
5. 推一路测试流，调用 `getMediaList`，再抽查一种播放协议。
6. 播放或接口异常时，回退到旧 Digest，并恢复备份的配置。

---

## 九、常见问题

**Q1：`master` 和 `master_py` 怎么选？**

日常部署用 **`master`**。需要 pymkui 等 Python 插件时，再把标签换成 **`master_py`**。

**Q2：打不开 `http://IP:8080`？**

先看 `docker compose ps` 和 `docker compose logs`。确认映射是 `8080:80`，并放行宿主机 **8080**。这个端口已被占用时，把左侧改成其它端口，浏览器地址同步修改。

**Q3：打开 `/webrtc/` 后弹出「浏览器推流需 HTTPS」？**

浏览器要用摄像头推流时，需要 HTTPS。点确定后，用 FFmpeg 或 OBS 推 RTMP，页面 method 选「play」，即可验证播放。要在浏览器里直接推流，请配置 HTTPS（宿主机 **8443**）或反向代理证书。

**Q4：能推流但播不了？**

核对应用名和流 ID。本文示例是 `live` 和 `test`。WebRTC 页的 method 选「play」，url 里要有 `app=live&stream=test`。HLS 有切片延迟，属于正常现象。路径规则见[播放 URL 规则](https://github.com/ZLMediaKit/ZLMediaKit/wiki/播放url规则)。

**Q5：API 或 webassist 提示无权限？**

敏感接口要带 `secret=`。值以挂载目录里的 `conf/config.ini` 为准。首次启动时，MediaServer 可能已经自动改写过这个值。不要使用网上流传的旧默认值。

**Q6：WebRTC 连不上？**

放行 **8000/udp**。对外 IP 和证书按官方 Wiki 配置。

**Q7：GB28181 怎么接？**

设备侧还要配 SIP，步骤见官方 GB28181 Wiki。先确认宿主机 **10000** 的 TCP 和 UDP 都能到达容器。

**Q8：为什么不用 `latest`？**

官方示例和当前主线标签是 **`master`**，仓库里还没有稳定的版本号标签。不要和第三方镜像 `panjjo/zlmediakit` 混用。

**Q9：改了 `config.ini` 不生效？**

确认卷挂的是 `/opt/media/conf`。不确定容器是否已读到新文件时，执行 `docker compose restart`。

**Q10：日志里还有 3000 和 3001？**

容器内的 WebRTC 信令会监听这些端口。本文 Compose 没有把它们映射到宿主机，以免占用宿主机 **3000**。HTTP 和常用 WebRTC API 走宿主机 **8080** 到容器 **80**。

---

## 十、命令速查

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

docker run -d 
  --name zlmediakit 
  --restart unless-stopped 
  -p 1935:1935 
  -p 8080:80 
  -p 8443:443 
  -p 8554:554 
  -p 10000:10000 
  -p 10000:10000/udp 
  -p 8000:8000/udp 
  -p 9000:9000/udp 
  -v /www/wwwroot/zlmediakit/conf:/opt/media/conf 
  -v /www/wwwroot/zlmediakit/www:/opt/media/bin/www 
  -e TZ=Asia/Shanghai 
  docker.xuanyuan.run/zlmediakit/zlmediakit:master
```

---

## 十一、延伸阅读

| 资源 | 链接 |
|------|------|
| [zlmediakit/zlmediakit 镜像页](https://xuanyuan.cloud/zh/r/zlmediakit/zlmediakit) | [https://xuanyuan.cloud/zh/r/zlmediakit/zlmediakit](https://xuanyuan.cloud/zh/r/zlmediakit/zlmediakit) |
| [zlmediakit/zlmediakit 概览](https://xuanyuan.cloud/r/zlmediakit/zlmediakit) | [https://xuanyuan.cloud/r/zlmediakit/zlmediakit](https://xuanyuan.cloud/r/zlmediakit/zlmediakit) |
| [zlmediakit/zlmediakit 标签列表](https://xuanyuan.cloud/r/zlmediakit/zlmediakit/tags) | [https://xuanyuan.cloud/r/zlmediakit/zlmediakit/tags](https://xuanyuan.cloud/r/zlmediakit/zlmediakit/tags) |
| [Docker Hub · zlmediakit/zlmediakit](https://hub.docker.com/r/zlmediakit/zlmediakit) | [https://hub.docker.com/r/zlmediakit/zlmediakit](https://hub.docker.com/r/zlmediakit/zlmediakit) |
| [GitHub · ZLMediaKit](https://github.com/ZLMediaKit/ZLMediaKit) | [https://github.com/ZLMediaKit/ZLMediaKit](https://github.com/ZLMediaKit/ZLMediaKit) |
| [快速开始](https://github.com/ZLMediaKit/ZLMediaKit/wiki/快速开始) | [https://github.com/ZLMediaKit/ZLMediaKit/wiki/快速开始](https://github.com/ZLMediaKit/ZLMediaKit/wiki/快速开始) |
| [播放 URL 规则](https://github.com/ZLMediaKit/ZLMediaKit/wiki/播放url规则) | [https://github.com/ZLMediaKit/ZLMediaKit/wiki/播放url规则](https://github.com/ZLMediaKit/ZLMediaKit/wiki/播放url规则) |
| [配置文件详解](https://github.com/ZLMediaKit/ZLMediaKit/wiki/配置文件详解) | [https://github.com/ZLMediaKit/ZLMediaKit/wiki/配置文件详解](https://github.com/ZLMediaKit/ZLMediaKit/wiki/配置文件详解) |
| [MediaServer 支持的 HTTP API](https://github.com/ZLMediaKit/ZLMediaKit/wiki/MediaServer支持的HTTP-API) | [https://github.com/ZLMediaKit/ZLMediaKit/wiki/MediaServer支持的HTTP-API](https://github.com/ZLMediaKit/ZLMediaKit/wiki/MediaServer支持的HTTP-API) |
| [MediaServer 支持的 HTTP HOOK](https://github.com/ZLMediaKit/ZLMediaKit/wiki/MediaServer支持的HTTP-HOOK-API) | [https://github.com/ZLMediaKit/ZLMediaKit/wiki/MediaServer支持的HTTP-HOOK-API](https://github.com/ZLMediaKit/ZLMediaKit/wiki/MediaServer支持的HTTP-HOOK-API) |
| [开启 HTTPS](https://github.com/ZLMediaKit/ZLMediaKit/wiki/怎么开启https相关功能) | [https://github.com/ZLMediaKit/ZLMediaKit/wiki/怎么开启https相关功能](https://github.com/ZLMediaKit/ZLMediaKit/wiki/怎么开启https相关功能) |
| [GitHub · zlm_webassist](https://github.com/1002victor/zlm_webassist) | [https://github.com/1002victor/zlm_webassist](https://github.com/1002victor/zlm_webassist) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/zlmediakit-docker-deploy


