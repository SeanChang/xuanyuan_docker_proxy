# Docker 部署 go2rtc：轻松搭建摄像头多协议流媒体平台

![Docker 部署 go2rtc：轻松搭建摄像头多协议流媒体平台](https://imgs.xuanyuan.cloud/docker/blog/go2rtc.webp)

*分类: Docker部署教程 | 标签: go2rtc,alexxit/go2rtc,Docker,轩辕镜像,摄像头,RTSP,WebRTC,HomeKit,FFmpeg,小米,私有化部署,部署教程 | 发布时间: 2026-09-07 01:18:06*

> 门口门铃响了，人已经走到门口，手机米家里画面还在转圈；客厅摄像头的 RTSP 抄在便签上，浏览器一开就提示要插件；有人在本机用 FFmpeg 转 HLS，延迟高到对讲对不上；有人把 Frigate、Home Assistant 直接怼摄像头，协议对不上、双向音频又断。想「一条源进、网页 WebRTC 出」，YAML 和端口散在 NAS、工控机、笔记本三处，换一台机器就得重配。

*本文基于 [alexxit/go2rtc:1.9.14](https://xuanyuan.cloud/zh/r/alexxit/go2rtc)，实测引擎 **go2rtc 1.9.14**（revision **b5948cf**），测试平台 **Ubuntu 24.04** Linux。*

门口门铃响了，人已经走到门口，手机米家里画面还在转圈；客厅摄像头的 RTSP 抄在便签上，浏览器一开就提示要插件；有人在本机用 FFmpeg 转 HLS，延迟高到对讲对不上；有人把 Frigate、Home Assistant 直接怼摄像头，协议对不上、双向音频又断。想「一条源进、网页 WebRTC 出」，YAML 和端口散在 NAS、工控机、笔记本三处，换一台机器就得重配。

监控画面和账号最好留在自己的盘上。云监控按路数计费，等保机房、内网演示也不宜把实时画面送出域。很多团队已经有一台跑 Docker 的 Ubuntu，缺的是 **1984 能开 WebUI、8554 能出 RTSP、WebRTC 能通**，配置挂在目录里——而不是再装一整套 NVR。

**go2rtc**（[GitHub · AlexxIT/go2rtc](https://github.com/AlexxIT/go2rtc)）是轻量摄像头流媒体应用：接入 RTSP / ONVIF / 小米等源，输出 WebRTC、MSE、MJPEG、HLS、HomeKit、RTSP，必要时用内置 FFmpeg 转码，常作 Frigate、Home Assistant 的前端流网关。官方镜像 **`alexxit/go2rtc`**（[镜像页](https://xuanyuan.cloud/zh/r/alexxit/go2rtc)）自带 WebUI；默认 **API / WebUI 1984**、**RTSP 8554**、**WebRTC 8555**。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 打开 WebUI | `http://服务器IP:1984/`，顶栏改 config / 看 log |
| 加 RTSP | config 里写 `streams`，Save & Restart 后首页点 **stream** |
| 加小米摄像头 | `add.html` → Xiaomi 登录 → load devices → 把 `url` 写入 `streams` |
| 给其它软件拉流 | `rtsp://IP:8554/流名`，或 API 出 HLS / MP4 |
| 备份搬家 | 停容器后打包 `./config` 与 Compose |

本文用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`alexxit/go2rtc:1.9.14`**，**Docker Compose** 以 **host 网络**启动。实测局域网 IP **`192.168.1.35`**，请换成你的。无 Compose 见第八节。文内附 **8** 张实测截图。

> **上手要点**
> - **部署**：第五节 Compose；临时试玩见第八节
> - **访问**：宿主 **1984**（WebUI / API）、**8554**（RTSP）、**8555**（WebRTC）；host 下勿写 `ports:`
> - **数据**：`./config` → `/config`（`go2rtc.yaml`，也可在 WebUI 编辑）
> - **特权**：硬件转码才开 `privileged`；跟做默认可注释（见 5.2）
> - **标签**：跟做 **`1.9.14`**，勿写 `latest` / `master`；GPU 用 **`1.9.14-hardware`**
> - **体积**：DISK **362MB** / CONTENT **94.6MB**
> - **安全**：默认无鉴权；公网务必加账号或反代（见 6.5）
> - **小米**：`add.html` 左侧是账号、右侧是 China 等地区；列表要写入 `streams` 后才能播（见 6.3、FAQ Q9）
> - **macOS**：host 基本不可用，见 5.5

官方：[GitHub](https://github.com/AlexxIT/go2rtc) · [Xiaomi 源](https://github.com/AlexxIT/go2rtc/blob/master/internal/xiaomi/README.md) · [硬件加速](https://github.com/AlexxIT/go2rtc/wiki/Hardware-acceleration) · [镜像页](https://xuanyuan.cloud/zh/r/alexxit/go2rtc) · [标签](https://xuanyuan.cloud/r/alexxit/go2rtc/tags)

---

## 一、go2rtc 是什么？

一种输入可以对应多种输出：浏览器预览走 WebRTC / MSE，录像软件拉本机 RTSP，智能家居再接 HomeKit——不必为每种播放器各写一套转码脚本。

| | go2rtc（本文） | 厂商 App / 云监控 | SRS / ZLMediaKit（直播向） |
|--|----------------|-------------------|----------------------------|
| 入口 | 浏览器 `:1984` | 厂商账号 / App | 推流口 + 播放页 |
| 输入 | RTSP / ONVIF / 小米等 | 自家设备 | 偏 RTMP / SRT 推流 |
| 输出 | WebRTC / MSE / HLS / HomeKit / RTSP | App 内 | HTTP-FLV / HLS / WebRTC 等 |
| 数据 | 本机 `/config` | 出域 / 订阅 | 本机卷 |
| 适合 | 摄像头预览、HA / Frigate 前端 | 免运维家用 | 直播联调、大规模推拉 |

```text
摄像头 / NVR / 小米（局域网）
        │
        ▼
alexxit/go2rtc  （host 网络）
   ├── ./config → /config（go2rtc.yaml）
   ├── :1984  WebUI / HTTP API
   ├── :8554  RTSP 输出
   └── :8555  WebRTC（TCP/UDP）
```

[`/r/`](https://xuanyuan.cloud/r/alexxit/go2rtc) 与 [`/zh/r/`](https://xuanyuan.cloud/zh/r/alexxit/go2rtc) 是同一镜像的不同页面语言。同站另有社区 fork（如 `skrashevich/go2rtc`），**本文只用 `alexxit/go2rtc:1.9.14`**。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04**（host 网络在 Linux 上可靠） |
| Docker | Engine + **Compose V2** |
| 架构 | `amd64` / `386` / `arm` / `arm64`（以 [tags](https://xuanyuan.cloud/r/alexxit/go2rtc/tags) 为准） |
| 内存 | ≥ **512 MB**；多路转码再加 |
| 磁盘 | DISK **362MB** / CONTENT **94.6MB** + `./config` |
| 端口 | host 下占用宿主 **1984 / 8554 / 8555** |

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
ss -tlnp | grep -E ':1984|:8554|:8555'
```

被占用时改 `go2rtc.yaml` 里对应 `listen`（见 FAQ Q7），或停掉占用进程。host 下**不能**靠 Compose `ports` 左侧改宿主机端口。

> **安全**：默认 WebUI 与 RTSP **无鉴权**。信任内网可先跟做；公网或不可信局域网请限制监听、加账号或反代（见 6.5）。

---

## 三、标签怎么选

跟做使用 **`1.9.14`**（上游 [Release v1.9.14](https://github.com/AlexxIT/go2rtc/releases/tag/v1.9.14)，2026-01-19）。完整列表：[tags](https://xuanyuan.cloud/r/alexxit/go2rtc/tags)。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`1.9.14`** | 稳定版，Alpine；视主机可含 Intel iGPU / 树莓派硬件转码 | **本文跟做** |
| `1.9.14-hardware` | Debian，**amd64**，Intel / AMD / NVIDIA GPU | 需要 GPU 转码 |
| `1.9.14-rockchip` | Rockchip RK35xx（arm64） | 对应板卡 |
| `1.9` / `latest` / `latest-hardware` | 浮动线 | **勿写入跟做命令** |
| `master` / `master-hardware` | 开发线 | **勿当教程默认** |

升级前备份 `./config`，同步改 pull、Compose、`docker run` 三处标签，并核对 [Releases](https://github.com/AlexxIT/go2rtc/releases)。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/alexxit/go2rtc:1.9.14
```

Ubuntu 24.04 实测：

```text
1.9.14: Pulling from alexxit/go2rtc
690bef5913ee: Pull complete
d14a6c2dd57f: Pull complete
34a945589e3f: Pull complete
f04c14cf051a: Pull complete
fbe816074e42: Pull complete
1d6a5f48389f: Pull complete
559463677b82: Pull complete
1074353eec0d: Pull complete
1108790ab071: Download complete
Digest: sha256:675c318b23c06fd862a61d262240c9a63436b4050d177ffc68a32710d9e05bae
Status: Downloaded newer image for docker.xuanyuan.run/alexxit/go2rtc:1.9.14
docker.xuanyuan.run/alexxit/go2rtc:1.9.14
```

```bash
docker images docker.xuanyuan.run/alexxit/go2rtc:1.9.14
```

```text
IMAGE                                       ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/alexxit/go2rtc:1.9.14   675c318b23c0        362MB         94.6MB
```

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `alexxit/go2rtc:1.9.14` | `docker pull docker.xuanyuan.run/alexxit/go2rtc:1.9.14` |

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq)。

---

## 五、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/go2rtc` |
| **macOS** | **`~/docker/go2rtc`**（须用 5.5 bridge，勿照搬 host） |

### 5.1 准备目录

```bash
sudo mkdir -p /www/wwwroot/go2rtc/config
sudo chown -R "$USER:$USER" /www/wwwroot/go2rtc
cd /www/wwwroot/go2rtc
```

可选：先放一份最小配置（没有摄像头也能先起 WebUI）：

```bash
cat > config/go2rtc.yaml <<'EOF'
# 把下面改成你的摄像头；没有摄像头可先删掉 streams 段，只验证 WebUI
streams:
  # cam1: rtsp://用户名:密码@192.168.1.100:554/Streaming/Channels/101
EOF
```

### 5.2 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  go2rtc:
    image: docker.xuanyuan.run/alexxit/go2rtc:1.9.14
    container_name: go2rtc
    network_mode: host
    # privileged: true   # 仅 FFmpeg 硬件转码需要；纯软解可保持注释
    restart: unless-stopped
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ./config:/config
EOF
```

| 项 | 说明 |
|----|------|
| `network_mode: host` | WebRTC、HomeKit、UDP 摄像头官方推荐 |
| `privileged` | **硬件转码**才必须；跟做默认注释 |
| `./config` | `go2rtc.yaml`；WebUI 改配置会写回此目录 |
| 勿写 `ports:` | host 下端口映射不生效 |

GPU 转码：换 `1.9.14-hardware`、打开 `privileged`，并按主机加 GPU 设备（见第七节）。

### 5.3 启动并验证

```bash
docker compose up -d
docker compose ps
```

Ubuntu 24.04 实测：

```text
[+] up 1/1
 ✔ Container go2rtc Started

NAME      IMAGE                                       COMMAND                  SERVICE   CREATED         STATUS         PORTS
go2rtc    docker.xuanyuan.run/alexxit/go2rtc:1.9.14   "/sbin/tini -- go2rt…"   go2rtc    7 seconds ago   Up 5 seconds
```

host 模式下 `PORTS` 列为空是正常的。

```bash
docker compose logs -f go2rtc
```

成功关键行（实测；其余 `172.x.0.1:8555` 是本机 Docker 网桥，可忽略，局域网看 **`192.168.1.35`**）：

```text
go2rtc  | 08:14:40.866 INF go2rtc platform=linux/amd64 revision=b5948cf version=1.9.14
go2rtc  | 08:14:40.866 INF config path=/config/go2rtc.yaml
go2rtc  | 08:14:40.867 INF [rtsp] listen addr=:8554
go2rtc  | 08:14:40.867 INF [api] listen addr=:1984
go2rtc  | 08:14:40.870 INF [webrtc] listen tcp addr=[::]:8555
go2rtc  | 08:14:40.873 INF [webrtc] listen udp addr=192.168.1.35:8555
```

WebUI 保存配置后进程会重启，日志里可能再出现同一段启动信息。`Ctrl+C` 只退出日志跟踪。

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:1984/
```

实测 **200**。浏览器打开 `http://192.168.1.35:1984/`（换成你的 IP）。也可在顶栏 **log** 对照启动信息：

![go2rtc WebUI 日志页：version 1.9.14，api :1984、rtsp :8554、webrtc 含 192.168.1.35:8555](https://imgs.xuanyuan.cloud/docker/blog/go2rtc-4.webp)

加流与预览见第六节。

### 5.4 常见踩坑：host 与防火墙

- **UFW / 云安全组**：host 下 Docker 不会像 bridge 那样自动插发布规则，需自行放行 **1984/tcp**（以及要用的 8554、8555）。
- **本机通、局域网不通**：查防火墙与网卡绑定。
- **改配置后短暂退出**：属保存重载；`restart: unless-stopped` 会拉起。

### 5.5 备选：bridge（macOS / 无 host）

Docker Desktop（Mac）上 **host 基本不可用**。可改 bridge + 映射；WebRTC / HomeKit / 部分 UDP 源可能受限，仅适合本机试 WebUI：

```yaml
services:
  go2rtc:
    image: docker.xuanyuan.run/alexxit/go2rtc:1.9.14
    container_name: go2rtc
    restart: unless-stopped
    environment:
      - TZ=Asia/Shanghai
    ports:
      - "1984:1984"
      - "8554:8554"
      - "8555:8555"
      - "8555:8555/udp"
    volumes:
      - ./config:/config
```

工作目录用 **`~/docker/go2rtc`**。摄像头场景仍优先 Linux + host。

---

## 六、浏览器：WebUI 与加流

### 6.1 打开 WebUI

打开 `http://192.168.1.35:1984/`。顶栏：**go2rtc / add / config / log / net**。首页 **stream** 列出已配置的流（刚部署时为空）；页脚为 **version: 1.9.14** 与 `config: /config/go2rtc.yaml`。

![go2rtc 首页 stream：空流列表，modes 勾选 webrtc/mse/hls/mjpeg，页脚 version 1.9.14](https://imgs.xuanyuan.cloud/docker/blog/go2rtc-1.webp)

点 **add**（或打开 `/add.html`）可按厂商 / 协议加源，含 Temporary stream、ONVIF、**Xiaomi** 等：

![go2rtc add 页：Temporary stream 至 Xiaomi、WebTorrent 等源列表](https://imgs.xuanyuan.cloud/docker/blog/go2rtc-2.webp)

### 6.2 添加 RTSP 摄像头

点 **config**（或改宿主机 `./config/go2rtc.yaml`）。实测初始内容与 5.1 一致：

![go2rtc config：Save & Restart，streams 下注释示例 RTSP cam1](https://imgs.xuanyuan.cloud/docker/blog/go2rtc-3.webp)

取消注释或写成正式流（账号、IP、路径换成你的）：

```yaml
streams:
  cam1: rtsp://admin:密码@192.168.1.100:554/Streaming/Channels/101
```

点 **Save & Restart**，回首页点该行的 **stream** 预览（modes 可勾 webrtc / mse 等）。

### 6.3 添加小米摄像头（Add → Xiaomi）

步骤见 [Xiaomi README](https://github.com/AlexxIT/go2rtc/blob/master/internal/xiaomi/README.md)。地区须与米家 App 里设备绑定区域一致，国内选 **China**（`cn`）。

1. 打开 **add** → **Xiaomi**，输入账号密码；按提示完成验证码或短信。

![go2rtc add Xiaomi：验证码与手机号校验，左侧账号下拉为空、右侧 China、load devices](https://imgs.xuanyuan.cloud/docker/blog/go2rtc-5.webp)

2. 登录成功后，`go2rtc.yaml` 会出现 `xiaomi:` 段，**左侧下拉**才有账号 ID。左侧空、右侧已是 China，说明账号还没落盘（见 FAQ Q9），不是「China 没选项」。
3. 左侧选账号、右侧选 **China**，点 **load devices**。表格列出摄像头（`name` / `info` / `url`）：

![go2rtc Xiaomi load devices：摄像头列表含 name、info、xiaomi:// url](https://imgs.xuanyuan.cloud/docker/blog/go2rtc-6.webp)

4. **列表不能直接播**。复制某一行的 **`url`**（`xiaomi://…`），再：
   - **临时**：同页 **Temporary stream**，`name` 如 `cam2`，`src` 粘贴 url 后提交；或
   - **持久**：在 **config** 写入 `streams`（可与 RTSP 并存）。实测：`cam1` 为 RTSP，`cam2` 为小米，`xiaomi:` 为登录写入的 token：

![go2rtc config：streams 含 cam1 RTSP 与 cam2 xiaomi://，下方 xiaomi 账号段](https://imgs.xuanyuan.cloud/docker/blog/go2rtc-7.webp)

```yaml
streams:
  cam1: rtsp://用户名:密码@摄像头IP:554/…
  cam2: xiaomi://账号ID:cn@摄像头局域网IP?did=设备DID&model=型号编码

xiaomi:
  "账号ID": V1:***   # 登录成功后由 WebUI 写入
```

5. **Save & Restart**，回首页。出现 **cam1 / cam2** 后点 **stream** 看画面；**links** 可复制给其它播放器：

![go2rtc 首页：cam1/cam2 流列表，commands 含 stream、links、delete](https://imgs.xuanyuan.cloud/docker/blog/go2rtc-8.webp)

也可直接打开 `http://192.168.1.35:1984/stream.html?src=cam2`。连机时宿主机要能访问小米云拿密钥，且与摄像头在**局域网**；并非所有型号都支持（见 [支持列表讨论](https://github.com/AlexxIT/go2rtc/issues/1982)）。

### 6.4 给其它软件拉流

以实测流名 **`cam2`**、IP **`192.168.1.35`** 为例：

| 用途 | 示例 URL |
|------|----------|
| RTSP | `rtsp://192.168.1.35:8554/cam2` |
| HLS | `http://192.168.1.35:1984/api/stream.m3u8?src=cam2` |
| 浏览器预览 | `http://192.168.1.35:1984/stream.html?src=cam2` |
| 加流页 | `http://192.168.1.35:1984/add.html` |

更多参数见 [上游 README](https://github.com/AlexxIT/go2rtc)。

### 6.5 生产加固（建议）

默认局域网可匿名访问。不可信网络时：

```yaml
api:
  listen: ":1984"
  username: "admin"
  password: "换成强密码"
```

或仅本机监听，前面再挂 TLS 反代：

```yaml
api:
  listen: "127.0.0.1:1984"
rtsp:
  listen: "127.0.0.1:8554"
```

勿把 **1984 / 8554 / 8555** 裸暴露公网；小米 token 与摄像头密码勿提交公开仓库。

---

## 七、硬件加速版本（可选）

需要 GPU 硬件转码时：

1. 拉取 `docker.xuanyuan.run/alexxit/go2rtc:1.9.14-hardware`
2. Compose 改 `image`，打开 `privileged: true`
3. NVIDIA 等再按驱动加 `--gpus` / 设备映射
4. 配置见 [Hardware-acceleration](https://github.com/AlexxIT/go2rtc/wiki/Hardware-acceleration)

Rockchip 用 `1.9.14-rockchip`，勿在普通 x86 上误用。

---

## 八、备选：docker run

无 Compose 时可用；日常仍建议第五节。

```bash
docker run -d \
  --name go2rtc \
  --network host \
  --restart unless-stopped \
  -e TZ=Asia/Shanghai \
  -v /www/wwwroot/go2rtc/config:/config \
  docker.xuanyuan.run/alexxit/go2rtc:1.9.14
```

硬件转码再加 `--privileged`，并换 `1.9.14-hardware`（及 GPU 参数）。

```bash
docker ps --filter name=go2rtc
docker logs -f go2rtc
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:1984/
docker stop go2rtc && docker rm go2rtc
```

---

## 九、备份、升级与迁移

```bash
cd /www/wwwroot/go2rtc
docker compose stop
tar -czf go2rtc-backup-$(date +%F).tar.gz config docker-compose.yml
docker compose start
```

升级：查 [tags](https://xuanyuan.cloud/r/alexxit/go2rtc/tags) → 改 Compose 标签 → `docker compose pull && docker compose up -d` → 打开 `:1984` 确认流仍在。搬家恢复同结构目录即可。

---

## 十、常见问题 FAQ

**Q1：浏览器打不开 `:1984`？**  
确认容器 `Up`、host 下防火墙已放行、本机 `curl 127.0.0.1:1984` 是否通。Mac 用 5.5 bridge。

**Q2：WebRTC 黑屏 / 连不上？**  
优先 **host**；放行 **8555** TCP/UDP；跨网段注意 NAT。bridge 下 WebRTC 常不稳定。

**Q3：为什么不用 `latest`？**  
浮动标签会静默升级，界面与步骤可能和文档不一致。跟做固定 **`1.9.14`**。

**Q4：必须 `privileged` 吗？**  
不必。官方主要用于 **FFmpeg 硬件转码**；软解可省略。

**Q5：和 SRS / ZLMediaKit 怎么选？**  
SRS / ZLM 偏直播推拉；go2rtc 偏摄像头接入与 HA / Frigate 前端。本站另有 [SRS](https://xuanyuan.cloud/blog/srs-docker-deploy)、[ZLMediaKit](https://xuanyuan.cloud/blog/zlmediakit-docker-deploy) 教程。

**Q6：有默认管理员账号吗？**  
没有。要鉴权请配 `api.username` / `password` 或反代。

**Q7：可以改 API 端口吗？**  
可以，例如 `api.listen: ":11984"`；host 下改的是宿主端口。

**Q8：Home Assistant / Frigate 怎么接？**  
常见做法是让 HA 的 WebRTC Camera / go2rtc 集成，或 Frigate 的 go2rtc 段指向本机 `1984`。细节以上游文档为准；本文只保证容器与 WebUI 跑通。

**Q9：小米登录后，China 左侧下拉是空的？**  
左侧是**已落盘账号**，右侧才是地区。左侧空 = `xiaomi:` 还没写进配置。

```bash
grep -A5 '^xiaomi:' /www/wwwroot/go2rtc/config/go2rtc.yaml
curl -s http://127.0.0.1:1984/api/xiaomi
```

有账号时 `api/xiaomi` 应为非空数组。可试：`docker compose restart` 后刷新再点 Xiaomi；重新登录；部分用户反馈改密后再登有效。上游讨论见 [#2063](https://github.com/AlexxIT/go2rtc/issues/2063)、[#2157](https://github.com/AlexxIT/go2rtc/issues/2157)；手机验证相关修复（如 [#2450](https://github.com/AlexxIT/go2rtc/pull/2450)）**不一定已进 `1.9.14`**。跟做稳定版时以 `xiaomi:` 是否落盘为准；急用再评估 `master`（不稳定）或改用 RTSP 等其它源。

**Q10：日志里很多 `172.x.0.1:8555`？**  
Docker 网桥地址。局域网客户端用你的网卡 IP（实测 **`192.168.1.35:8555`**）即可。

---

## 十一、命令速查

```bash
docker pull docker.xuanyuan.run/alexxit/go2rtc:1.9.14

cd /www/wwwroot/go2rtc
docker compose up -d
docker compose ps
docker compose logs -f go2rtc
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:1984/

docker compose pull && docker compose up -d
docker compose down
```

---

## 十二、延伸阅读

| 资源 | 链接 |
|------|------|
| [alexxit/go2rtc 镜像页](https://xuanyuan.cloud/zh/r/alexxit/go2rtc) | [https://xuanyuan.cloud/zh/r/alexxit/go2rtc](https://xuanyuan.cloud/zh/r/alexxit/go2rtc) |
| [alexxit/go2rtc 概览](https://xuanyuan.cloud/r/alexxit/go2rtc) | [https://xuanyuan.cloud/r/alexxit/go2rtc](https://xuanyuan.cloud/r/alexxit/go2rtc) |
| [alexxit/go2rtc 标签列表](https://xuanyuan.cloud/r/alexxit/go2rtc/tags) | [https://xuanyuan.cloud/r/alexxit/go2rtc/tags](https://xuanyuan.cloud/r/alexxit/go2rtc/tags) |
| [GitHub · AlexxIT/go2rtc](https://github.com/AlexxIT/go2rtc) | [https://github.com/AlexxIT/go2rtc](https://github.com/AlexxIT/go2rtc) |
| [GitHub Release · v1.9.14](https://github.com/AlexxIT/go2rtc/releases/tag/v1.9.14) | [https://github.com/AlexxIT/go2rtc/releases/tag/v1.9.14](https://github.com/AlexxIT/go2rtc/releases/tag/v1.9.14) |
| [Xiaomi 源说明](https://github.com/AlexxIT/go2rtc/blob/master/internal/xiaomi/README.md) | [https://github.com/AlexxIT/go2rtc/blob/master/internal/xiaomi/README.md](https://github.com/AlexxIT/go2rtc/blob/master/internal/xiaomi/README.md) |
| [硬件加速 Wiki](https://github.com/AlexxIT/go2rtc/wiki/Hardware-acceleration) | [https://github.com/AlexxIT/go2rtc/wiki/Hardware-acceleration](https://github.com/AlexxIT/go2rtc/wiki/Hardware-acceleration) |
| [Docker Hub · alexxit/go2rtc](https://hub.docker.com/r/alexxit/go2rtc) | [https://hub.docker.com/r/alexxit/go2rtc](https://hub.docker.com/r/alexxit/go2rtc) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

同站流媒体：[SRS](https://xuanyuan.cloud/blog/srs-docker-deploy) · [ZLMediaKit](https://xuanyuan.cloud/blog/zlmediakit-docker-deploy)。

---

## 总结

- 跟做 **`alexxit/go2rtc:1.9.14`**：Compose + **host**，`./config` → `/config`
- WebUI `:1984`；小米先 load devices，再把 `url` 写入 `streams`，首页点 **stream**
- 默认无鉴权；公网加固。GPU 转码用 **`1.9.14-hardware`**
- 升级改具体版本标签，勿跟 `latest` / `master`

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/go2rtc-docker-deploy


