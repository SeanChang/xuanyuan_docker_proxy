# Docker 部署 Piper：轻松搭建本地 TTS 文本转语音平台

![Docker 部署 Piper：轻松搭建本地 TTS 文本转语音平台](https://imgs.xuanyuan.cloud/docker/blog/piper.webp)

*分类: Docker部署教程 | 标签: Piper,Docker,轩辕镜像,TTS,文本转语音,Wyoming,Home Assistant,私有化部署,部署教程 | 发布时间: 2026-08-23 15:40:52*

> 门铃响了、洗衣机洗完、夜里有人按开关——这些事如果交给云端 TTS，句子要先出家门：有延迟、按量计费、断网就哑，门铃和漏水这类家务文本也会落到第三方。手机 App 自带的「云语音」换一家就换一套账号；树莓派或 NAS 上已经跑了 Home Assistant，却仍然缺一块完全本地的「把文字念出来」。

*本文基于 [linuxserver/piper:2.4.2](https://xuanyuan.cloud/zh/r/linuxserver/piper)，实测 **Linuxserver.io 2.4.2-ls123**（wyoming-piper **2.4.2**），测试平台 **Ubuntu 24.04** Linux。*

门铃响了、洗衣机洗完、夜里有人按开关——这些事如果交给云端 TTS，句子要先出家门：有延迟、按量计费、断网就哑，门铃和漏水这类家务文本也会落到第三方。手机 App 自带的「云语音」换一家就换一套账号；树莓派或 NAS 上已经跑了 Home Assistant，却仍然缺一块**完全本地**的「把文字念出来」。

把合成留在自己的机器上，文本不出内网，删容器也不丢已下载的语音模型，Home Assistant 用同一套 Wyoming 协议接入。商业云语音要订阅、内容在厂商侧；自己从源码编译 Piper，对只想先跑通播报的人又不划算。家用 x86 NAS 和树莓派 4 这类设备，缺的是一个现成服务：起容器、选一个中文音色，Assist 就能开口。

**linuxserver/piper**（见 [镜像页](https://xuanyuan.cloud/zh/r/linuxserver/piper)）把开源神经 TTS [Piper](https://github.com/OHF-Voice/piper1-gpl) 封装成 **Wyoming 协议服务器**，监听 **10200**。它没有网页控制台：浏览器打不开「管理后台」，而是给 Home Assistant Assist、自动化 `tts.speak` 以及其它 Wyoming 客户端当本地发音引擎。容器由 [LinuxServer.io](https://docs.linuxserver.io/images/docker-piper/) 维护，带 PUID/PGID 映射。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| Home Assistant 本地 Assist | 在 HA 里加 **Wyoming** 集成，把 Piper 设成文字转语音引擎 |
| 家务 / 安防播报 | 自动化里 `tts.speak`：门铃、漏水、洗衣完成用本机声音念 |
| 隐私敏感环境 | 合成全程在容器内完成，不必把句子交给云 TTS |
| 与本地听写配对 | 另外部署 Whisper 等 STT，组成「听得见、答得出」的本地语音链路 |

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`linuxserver/piper:2.4.2`**，**Docker Compose** 映射 **10200**，默认中文音色 **`zh_CN-huayan-medium`**，再接入 Home Assistant——文内附 **6** 张实测截图。无 Compose 时见文末 **`docker run` 备选**。下文局域网地址以实测 **`192.168.1.35`** 为例，请换成你自己的 IP。

> **上手要点**
> - **部署**：默认 **Compose**（第五节）；临时试玩见 **第九节 docker run**
> - **访问**：无 Web UI；协议口为宿主机 **10200** → 容器 **10200**（Wyoming TCP）
> - **不要用浏览器打开** `http://IP:10200`：未就绪时常见 **ERR_CONNECTION_REFUSED**；日志已有 `Ready` 后常见 **ERR_EMPTY_RESPONSE**。都不是故障，验证请走第六节 Home Assistant
> - **数据卷**：`./config` → 容器 `/config`（模型文件也在这里）
> - **必填**：`PIPER_VOICE`（跟做用 **`zh_CN-huayan-medium`**）
> - **标签**：钉死 **`2.4.2`**（见 [tags](https://xuanyuan.cloud/r/linuxserver/piper/tags)），不要写 `latest`
> - **账号**：无登录、协议无认证；**不要**把 10200 裸暴露公网
> - **首次启动**：默认会访问 **HuggingFace** 更新语音列表并下载 `.onnx`。Ubuntu 实测出现 `Failed to update voices list` / `Network is unreachable`，`config` 为空——按 **5.5 节** 手动放模型并设 `LOCAL_ONLY=true`

官方说明：[LinuxServer · piper](https://docs.linuxserver.io/images/docker-piper/)。HA 本地语音：[Set up a fully local voice assistant](https://www.home-assistant.io/voice_control/voice_remote_local_assistant/)。

---

## 一、Piper 是什么？

本镜像跑的是 **Wyoming 协议上的 Piper TTS**，不是带按钮的网站，也不是「把网页念出来」的浏览器插件。

| | linuxserver/piper（本文） | 云端 TTS（Azure / 讯飞等） |
|--|---------------------------|----------------------------|
| 入口 | Wyoming TCP **:10200** | HTTPS API |
| 数据 | 文本在本机合成，模型挂在 `/config` | 句子发到厂商 |
| 适合 | Home Assistant、内网播报、离线 | 公网应用、多语种托管 |
| 注意 | 无网页后台；首次要下载语音模型 | 费用、延迟、隐私策略 |

```text
Home Assistant / 其它客户端
        │  Wyoming（TCP 10200）
        ▼
  linuxserver/piper 容器
        │  本地神经合成（Piper）
        ▼
     音频流回客户端播放
  宿主机 ./config  ←→  /config（.onnx 语音模型）
```

原始引擎仓库 [rhasspy/piper](https://github.com/rhasspy/piper/) 已于 2025 年 10 月归档，后续开发见 [OHF-Voice/piper1-gpl](https://github.com/OHF-Voice/piper1-gpl)。坐标必须是 **`linuxserver/piper`**，不要拉成数据管道镜像 `meroxa/piper`。

Home Assistant OS 用户也可以装官方 **Piper Add-on**。已经在 Ubuntu / NAS 上用 HA Container（没有附加组件商店）时，用本文这个独立容器。同生态的本地听写可另看 `linuxserver/faster-whisper`。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04**（Docker Desktop 亦可） |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64 / arm64**（树莓派 4 64 位可用） |
| 内存 | ≥ **1 GB**（medium 音色更从容；高品质模型再留余量） |
| 磁盘 | 实测镜像占用约 **636MB**；跟做的 huayan-medium 模型约 **61MB** |
| 端口 | 宿主机 **10200**（Wyoming） |
| 网络 | 首次下载模型需要访问 **HuggingFace**；之后可离线（`LOCAL_ONLY`） |

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

启动前先看 **10200** 是否空闲：

```bash
ss -tlnp | grep 10200
```

> **10200** 被占用时，只改左侧宿主机端口，例如 `"10201:10200"`，Home Assistant 里填 **10201**。容器内仍是 10200。

---

## 三、标签怎么选

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`2.4.2`** | 本文钉死版本，对齐 PyPI **wyoming-piper 2.4.2** | **跟做 / 生产（本文）** |
| **`2.4.2-ls*`** | LinuxServer CI 构建号 | 需与某次构建完全对齐时选用 |
| **`amd64-2.4.2` / `arm64v8-2.4.2`** | 指定架构 | 多架构清单异常时再钉架构 |
| **`latest`** | 浮动指针，会随上游更新 | **不要写入跟做命令** |

完整列表：[linuxserver/piper 标签](https://xuanyuan.cloud/r/linuxserver/piper/tags)。升级时先改 Compose 标签，再 `pull` / `up -d`。

> 撰写时 `latest` 常与 `2.4.2` 指向同一构建，仍应写死 **`2.4.2`**，避免日后环境变量或协议行为静默变化。中文镜像页示例若仍写 `STREAMING`、`PIPER_PROCS`，以 [LinuxServer 文档](https://docs.linuxserver.io/images/docker-piper/) 为准：当前可选开关是 **`NO_STREAMING`**。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/linuxserver/piper:2.4.2
```

Ubuntu 24.04 实测：

```text
2.4.2: Pulling from linuxserver/piper
Digest: sha256:8a188dd841a24bce24128d6b3d5af38e1b7cbb52d77be69e8cab833dd64c6fa9
Status: Downloaded newer image for docker.xuanyuan.run/linuxserver/piper:2.4.2
docker.xuanyuan.run/linuxserver/piper:2.4.2
```

```bash
docker images docker.xuanyuan.run/linuxserver/piper:2.4.2
```

```text
IMAGE                                         ID             DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/linuxserver/piper:2.4.2   8a188dd841a2        636MB          176MB
```

---

## 五、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/piper` |
| **macOS 实测** | **`~/docker/piper`** |
| **Windows（Docker Desktop）** | 如 `C:\docker\piper` |

### 5.1 创建目录

```bash
mkdir -p /www/wwwroot/piper/config
chown -R "$USER:$USER" /www/wwwroot/piper
cd /www/wwwroot/piper

# macOS：mkdir -p ~/docker/piper/config && cd ~/docker/piper
```

非 root 时给 `mkdir` / `chown` 加 `sudo`。用 `id` 查看本机 uid / gid，写入下方 `PUID` / `PGID`。

```bash
id
```

### 5.2 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  piper:
    image: docker.xuanyuan.run/linuxserver/piper:2.4.2
    container_name: piper
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      # 必填：<语言>-<名称>-<质量>；英文官方示例是 en_US-lessac-medium
      - PIPER_VOICE=zh_CN-huayan-medium
      # 连不上 HuggingFace 时：先按 5.5 节放入 .onnx，再取消下一行注释
      # - LOCAL_ONLY=true
      # - PIPER_LENGTH=1.0
      # - PIPER_NOISE=0.667
      # - PIPER_NOISEW=0.333
      # - PIPER_SPEAKER=0
      # 设为任意非空值（如 true）将关闭按句流式合成
      # - NO_STREAMING=true
    volumes:
      - ./config:/config
    ports:
      - "10200:10200"
    restart: unless-stopped
EOF
```

`PUID` / `PGID` 请改成 `id` 输出的数字。语音列表与试听见 [Piper samples](https://rhasspy.github.io/piper-samples/)，模型文件在 [rhasspy/piper-voices](https://huggingface.co/rhasspy/piper-voices/tree/main)。

### 5.3 参数说明

| 参数 | 作用 |
|------|------|
| `10200:10200` | Wyoming 连接端口 |
| `PUID` / `PGID` | 容器内进程用户，避免卷权限错乱 |
| `TZ` | 时区；跟做用 `Asia/Shanghai` |
| `PIPER_VOICE` | **必填**。格式 `<语言>-<名称>-<质量>` |
| `LOCAL_ONLY` | 设为任意值后**不再**请求在线 `voices.json`。**不会**凭空生成模型：`./config` 里仍须已有 `.onnx` + `.onnx.json` |
| `PIPER_LENGTH` | 语速，默认 `1.0`；**小于 1 更快，大于 1 更慢** |
| `PIPER_NOISE` | 音色随机度；超过 1 容易发糊 |
| `PIPER_NOISEW` | 节奏随机度；超过 1 容易口吃、乱停 |
| `PIPER_SPEAKER` | 多说话人模型的说话人编号，从 `0` 起 |
| `NO_STREAMING` | 设为任意值则关闭句边界音频流 |
| `./config:/config` | 配置与语音模型目录 |

### 5.4 启动并验证

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 80
```

Ubuntu 24.04 实测（工作目录 `/www/wwwroot/piper`）：

```text
[+] up 2/2
 ✔ Network piper_default Created
 ✔ Container piper       Started
```

```text
NAME      IMAGE                                         COMMAND   SERVICE   CREATED         STATUS         PORTS
piper     docker.xuanyuan.run/linuxserver/piper:2.4.2   "/init"   piper     7 seconds ago   Up 5 seconds   0.0.0.0:10200->10200/tcp, [::]:10200->10200/tcp
```

容器 **Up 不等于 TTS 可用**。默认会访问 `https://huggingface.co/rhasspy/piper-voices/` 更新语音列表并下载 `zh_CN-huayan-medium` 的 `.onnx`。本机到 HuggingFace **网络不可达**（Errno 101）时，日志会出现：

```text
[custom-init] No custom files found, skipping...
ERROR:wyoming_piper.download:Failed to update voices list
...
OSError: [Errno 101] Network is unreachable
...
urllib.error.URLError: <urlopen error [Errno 101] Network is unreachable>
```

```bash
ls -lh /www/wwwroot/piper/config
```

```text
total 0
```

列表更新失败、模型也没落下。再空等不会自己好，按 **5.5 节** 处理。

宿主机此时已经在听 10200（`docker-proxy` 在听，不代表模型已就绪）：

```bash
ss -tlnp | grep 10200
```

```text
LISTEN 0      4096         0.0.0.0:10200      0.0.0.0:*    users:(("docker-proxy",...))
LISTEN 0      4096            [::]:10200         [::]:*    users:(("docker-proxy",...))
```

**不要用浏览器验证。** Chrome 发的是 HTTP，对端是 Wyoming，不会回网页。未 `Ready` 时常见 **ERR_CONNECTION_REFUSED**；日志已有 `Ready` 后常见 **ERR_EMPTY_RESPONSE**。请直接进入 5.5 节放模型，再按第六节用 Home Assistant 验证。

### 5.5 手动放入中文模型（HuggingFace 不通时）

在**本机**用 `wget` 把两个文件下到 `/www/wwwroot/piper/config/`（官方路径见 [piper-voices · zh_CN/huayan/medium](https://huggingface.co/rhasspy/piper-voices/tree/main/zh/zh_CN/huayan/medium)）。若本机也必须走 HTTP 代理，给 wget 加 `-e use_proxy=yes` 和 `http_proxy` / `https_proxy`（**不要把代理账号写进公开教程**）。

```bash
wget -O /www/wwwroot/piper/config/zh_CN-huayan-medium.onnx.json \
  "https://huggingface.co/rhasspy/piper-voices/resolve/main/zh/zh_CN/huayan/medium/zh_CN-huayan-medium.onnx.json"
wget -c -O /www/wwwroot/piper/config/zh_CN-huayan-medium.onnx \
  "https://huggingface.co/rhasspy/piper-voices/resolve/main/zh/zh_CN/huayan/medium/zh_CN-huayan-medium.onnx"
```

Ubuntu 24.04 实测文件大小：

```text
total 61M
-rw-r--r-- 1 root root  61M  zh_CN-huayan-medium.onnx
-rw-r--r-- 1 root root 4.8K  zh_CN-huayan-medium.onnx.json
```

属主改成与 `PUID`/`PGID` 一致：

```bash
chown 1000:1000 /www/wwwroot/piper/config/zh_CN-huayan-medium.onnx*
```

只放文件、不改环境变量时，进程后面仍可能打出 `Ready`，但每次重启还会去拉 `voices.json`，日志里会继续出现 HuggingFace ERROR。跟做建议打开 `LOCAL_ONLY=true` 再重建一次：

```yaml
      - LOCAL_ONLY=true
```

```bash
cd /www/wwwroot/piper
docker compose up -d
docker compose logs --tail 80
```

只开 `LOCAL_ONLY`、目录仍是空的：进程还是会尝试下载模型，照样失败。必须 **文件 + `LOCAL_ONLY`** 一起做。改环境变量要用 `compose up -d` 重建后才生效。

Ubuntu 24.04 实测（已放模型 + `LOCAL_ONLY=true`）日志干净：

```text
User UID:    1000
User GID:    1000
Linuxserver.io version: 2.4.2-ls123
Build-date: 2026-08-16T13:41:31+00:00
[custom-init] No custom files found, skipping...
INFO:__main__:Ready
Connection to localhost (127.0.0.1) 10200 port [tcp/*] succeeded!
[ls.io-init] done.
```

健康标志：`Ready` + 本机 **10200** 探测成功 + `[ls.io-init] done.`，且**没有** `Network is unreachable`。下一步不是刷新浏览器，而是进入第六节接 Home Assistant。

---

## 六、接入 Home Assistant 并让它开口

Piper **自己不会出声**：它只负责把文字合成音频，要由 HA 里的 **媒体播放器**（手机 App、音箱、投屏）播出来。本镜像没有「浏览器首次初始化」，验证入口就是这一节。

完整 HA 教程见：[想本地掌控智能家居？Docker 部署 Home Assistant](https://xuanyuan.cloud/blog/docker-home-assistant)。**已经有 HA 的读者可跳过 6.0**，从 6.1 开始。下文是与 Piper **同一台 Ubuntu 24.04**（`192.168.1.35`）上的实测命令。

### 6.0 同机部署 Home Assistant Container（可选）

HA 官方常用 host 网络，这里按实测给出 `docker run`（不是 Piper 的主路径）。

```bash
docker pull docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
```

Ubuntu 24.04 实测：

```text
2026.7.1: Pulling from homeassistant/home-assistant
Digest: sha256:f73512ba4fe06bb4d57636fe3578d0820cdec46f81e8f837ab59e451662ff3cb
Status: Downloaded newer image for docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
```

```bash
mkdir -p /www/wwwroot/homeassistant/config
cd /www/wwwroot/homeassistant

docker run -d \
  --name homeassistant \
  --privileged \
  --restart=unless-stopped \
  -e TZ=Asia/Shanghai \
  -v /www/wwwroot/homeassistant/config:/config \
  -v /run/dbus:/run/dbus:ro \
  --network=host \
  docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
```

`--network=host` 时 HA 直接占用宿主机 **8123**。本机 `ufw` 当时为 **inactive**，仍放行端口，以免以后启用防火墙被挡：

```bash
ufw allow 8123/tcp
```

浏览器打开 `http://192.168.1.35:8123` 完成初始化。HA 与 Piper 都在这台机、且 HA 为 host 网络时，Wyoming 主机填 **`127.0.0.1`** 或局域网 IP **`192.168.1.35`** 均可，端口 **`10200`**。截图里用的是局域网 IP。

### 6.1 添加 Wyoming 协议

1. 打开 Home Assistant：**设置 → 设备与服务 → 集成 → 添加集成**。
2. 搜索 **Wyoming Protocol**（Wyoming 协议）。
3. **主机**填 `127.0.0.1`（同机 host 网络）或 `192.168.1.35`，**端口**填 `10200`，点 **提交**。

![Home Assistant 添加 Wyoming Protocol：主机 192.168.1.35、端口 10200](https://imgs.xuanyuan.cloud/docker/blog/piper-1.webp)

4. 成功后会提示 **已为 "piper" 创建了配置**，点 **完成**。集成卡片显示 **1 个实体**。

![Home Assistant：已为 piper 创建 Wyoming 配置，显示 1 个实体](https://imgs.xuanyuan.cloud/docker/blog/piper-2.webp)

5. 进入该集成，**服务**列表里应有 **piper**（仍是 1 个实体）。这就是后面 `tts.speak` 要用的 TTS 引擎。

![Wyoming Protocol 集成页：服务 piper，1 个实体](https://imgs.xuanyuan.cloud/docker/blog/piper-3.webp)

官方说明见 [HA · Wyoming](https://www.home-assistant.io/integrations/wyoming/) 与 [本地语音助手](https://www.home-assistant.io/voice_control/voice_remote_local_assistant/)。

### 6.2 第一次文字转语音（开发者工具 → 动作）

实测播放器：**天翼智屏-8E02**，实体 ID `media_player.tian_yi_zhi_ping_8e02`。没有这台设备时，换成手机 **Home Assistant Companion** 或其它已接入的 `media_player`。

打开左侧 **开发者工具**。顶栏从左到右是：**YAML**、**状态**、**动作**、**模板**、**事件**、**统计**、**语音助手**。

**不要停在「YAML」这一页。** 那一页只用来「检查配置 / 重新加载」，不能执行 TTS。点第三项 **动作**。

![开发者工具顶栏：当前停在 YAML；应改点「动作」才能执行 tts.speak](https://imgs.xuanyuan.cloud/docker/blog/piper-4.webp)

点进 **动作** 后，右上角有两个按钮：**用户界面模式**（默认）和 **YAML 模式**。先用界面模式，不必手写 YAML：

1. 确认右上角高亮的是 **用户界面模式**。
2. **动作** 搜索并选择 **说话**（`tts.speak`）。
3. **目标**选 **piper**（实体 `tts.piper`）。
4. **媒体播放器实体** 选你的音箱；跟做截图是 **天翼智屏-8E02**。
5. **消息** 填：`你好，这是 Piper 本地语音。`
6. 点右下角 **执行操作**。

![开发者工具「动作」页用户界面模式：说话 tts.speak，目标 piper，播放器天翼智屏-8E02](https://imgs.xuanyuan.cloud/docker/blog/piper-6.webp)

若你更习惯 YAML：点右上角 **YAML 模式**（不要回到顶栏那个「YAML」页），粘贴后执行：

```yaml
action: tts.speak
target:
  entity_id: tts.piper
data:
  media_player_entity_id: media_player.tian_yi_zhi_ping_8e02
  message: 你好，这是 Piper 本地语音。
  cache: true
```

![开发者工具「动作」页 YAML 模式：tts.speak 目标 tts.piper，播放到天翼智屏](https://imgs.xuanyuan.cloud/docker/blog/piper-5.webp)

### 6.3 执行了没声音：先分清 Piper 还是播放器

先在 Piper 宿主机看日志：

```bash
cd /www/wwwroot/piper
docker compose logs --tail 40
```

wyoming-piper 默认是 **INFO**：启动会打 `Ready`，**每次合成只写 DEBUG**。执行 TTS 后日志仍停在 `[ls.io-init] done.` **不能**说明「没调用 Piper」。只有 ERROR（如下载失败、VoiceNotFound）才会在默认日志里冒出来。

| 现象 | 结论 |
|------|------|
| 执行后仍只有 `Ready` / `[ls.io-init] done.`，**没有 ERROR** | Piper 进程健康；合成是否发生要看 HA 日志，或换播放器对照 |
| 出现 `Network is unreachable` / `VoiceNotFound` | **Piper 侧失败**，回看 5.5 节 |
| `ss -tnp \| grep 10200` 里出现 **ESTAB**（已建立连接） | HA 确实连上了 Wyoming；`ss -tlnp` 只能看到 LISTEN，看不出客户端 |

更稳的对照：把 `tts.speak` 的播放器换成 **手机 Companion**。手机有声 = Piper + HA 合成都正常，问题在音箱这一侧。

Piper 正常、智屏仍无声时：

1. **开发者工具 → 状态**，看播放器是否为 `unavailable`、是否 `is_volume_muted: true`、`volume_level` 是否一直是 `0`。
2. **HA 里把音量拉到最右，刷新后又变 0**：这台天翼智屏**不接受（或不回报）HA 的音量设置**。TTS 会按设备上报的音量去播，报 0 就等于静音。用智屏**遥控器 / 机身按键**把音量调大。
3. 对同一实体执行 **Media player: Play media**，填一段公网可播的 MP3。能播歌、不能播 TTS：多半是音箱访问不了 HA 的 TTS 文件。到 **设置 → 系统 → 网络**，把 **本地网络 URL** 改成音箱能访问的地址（例如 `http://192.168.1.35:8123`），不要用 `localhost`。
4. 天翼智屏常见限制：音量不能被 HA 持久改写；不一定能拉取 HA 的 `/api/tts_proxy/`。对照用手机 App 或 Chromecast。

### 6.4 设成语音助手的默认 TTS

让 Assist / 语音卫星用 Piper 回答：

1. **设置 → 语音助手**（侧栏偏下）→ 添加助手，或编辑现有助手。
2. **语言**选中文。
3. **文字转语音**选 **Piper**（跟做音色为容器里的 `zh_CN-huayan-medium`）。
4. **听写**（语音转文字）是另一条链路：可暂用云端，或另外部署 Whisper。本文只保证 **念出来** 走本地 Piper。

Home Assistant 2026.7 默认已启用 `assist_pipeline`，一般不用改 `configuration.yaml`。列表是空的，再检查配置里是否被关掉。

---

## 七、自动化播报与音色微调

日常播报不必每次打开开发者工具。在 **设置 → 自动化与场景 → 创建自动化** 里，触发条件用门铃、洗衣完成等，动作仍是同一套 `tts.speak`：

```yaml
action: tts.speak
target:
  entity_id: tts.piper
data:
  media_player_entity_id: media_player.tian_yi_zhi_ping_8e02
  message: 洗衣机已经洗完了。
```

把 `media_player_entity_id` 换成你实际的播放器。更完整的写法见 [Using Piper TTS in automations](https://www.home-assistant.io/voice_control/using_tts_in_automation/)。

换语速：改 Compose 里的 `PIPER_LENGTH`（小于 1 更快），再 `docker compose up -d`。换音色：改 `PIPER_VOICE`；若已开 `LOCAL_ONLY`，须先按 5.5 节放入对应 `.onnx` 文件，否则不会上网去下。

---

## 八、安全与生产注意

- Wyoming **没有**账号密码，能连上 10200 就能请求合成。
- **不要**把 10200 映射到公网；防火墙只放行 Home Assistant 所在网段。
- 语音模型体积不大，但属于运行必需数据，请把 `./config` 纳入备份。
- 只读根文件系统：镜像支持 `--read-only`，细节见 [LinuxServer · read-only](https://docs.linuxserver.io/misc/read-only/)。跟做不必开启。

---

## 九、备选：docker run

无 Compose 或临时试玩时（Linux）：

```bash
docker run -d \
  --name=piper \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -e PIPER_VOICE=zh_CN-huayan-medium \
  -p 10200:10200 \
  -v /www/wwwroot/piper/config:/config \
  --restart unless-stopped \
  docker.xuanyuan.run/linuxserver/piper:2.4.2
```

Windows（PowerShell，一行）：

```powershell
docker run -d --name piper -e PUID=1000 -e PGID=1000 -e TZ=Asia/Shanghai -e PIPER_VOICE=zh_CN-huayan-medium -p 10200:10200 -v C:\docker\piper\config:/config --restart unless-stopped docker.xuanyuan.run/linuxserver/piper:2.4.2
```

HA 中同样填写该主机的 **10200**。连不上 HuggingFace 时，仍按 5.5 节放模型；需要 `LOCAL_ONLY` 时在命令里加 `-e LOCAL_ONLY=true`。

---

## 十、升级、停止与数据

先改 Compose 中的版本标签，再：

```bash
cd /www/wwwroot/piper
docker compose pull
docker compose up -d
```

`./config` 里已下载的模型会保留。

```bash
docker compose down
```

删除全部数据（慎用，会丢掉语音模型，下次还要重新下载）：

```bash
docker compose down
rm -rf /www/wwwroot/piper
```

---

## 十一、常见问题 FAQ

**Q1：浏览器打开 `http://192.168.1.35:10200/` 报 ERR_CONNECTION_REFUSED 或 ERR_EMPTY_RESPONSE？**
A：都不是故障。本镜像没有管理后台。**REFUSED** 多半还没 `Ready`；**EMPTY_RESPONSE** 说明 TCP 已接通，Wyoming 不会回 HTTP。请到 Home Assistant 添加 **Wyoming 协议**（主机 `192.168.1.35`，端口 `10200`）。不要靠反复重启来「修好网页」。

**Q2：日志 `Failed to update voices list` / `Network is unreachable`？**
A：容器直连 HuggingFace 失败（Errno **101**）。后面仍可能出现 `Ready`，但 `config` 为空时 TTS 仍缺模型。按 **5.5 节** 放入 `.onnx` + `.onnx.json`，再设 `LOCAL_ONLY=true` 重建。不要把代理口令写进 Compose 或公开文档。

**Q3：如何改成英文官方示例音色？**
A：把 `PIPER_VOICE` 改成 `en_US-lessac-medium`，`compose up -d`。HA 助手语言也改成英语，避免中文句子用英文模型硬念。

**Q4：中文镜像页写了 `STREAMING`、`PIPER_PROCS`？**
A：过时译文。当前 LinuxServer 文档使用 **`NO_STREAMING`**（设了就**关闭**流式），**没有** `PIPER_PROCS`。跟做以本文 Compose 为准。

**Q5：Home Assistant 提示无法连接 / 超时？**
A：核对 IP 与端口、双方防火墙、以及 HA 是否 `host` 网络。跨 VLAN 时在 Piper 宿主机放行 **10200/tcp**。HA 与 Piper 不在同一 Docker 网络时，不要填容器名 `piper`，填**宿主机可达 IP**。

**Q6：10200 被占用？**
A：只改左侧：

```yaml
ports:
  - "10201:10200"
```

HA 里端口改为 **10201**。

**Q7：权限错误、模型写不进 config？**
A：`PUID`/`PGID` 与宿主机目录所有者一致，例如：

```bash
sudo chown -R 1000:1000 /www/wwwroot/piper/config
```

**Q8：`PIPER_LENGTH=1.2` 为什么更慢？**
A：官方定义：`1.0` 为默认，**小于 1 更快，大于 1 更慢**。不是「越大越快」。

**Q9：和 HA OS 自带的 Piper Add-on 怎么选？**
A：HA OS + 附加组件商店用官方 Add-on 最省事。已经在 Ubuntu / NAS 上用 **HA Container** 时，用本文镜像。不要在同一套 Assist 里重复接两个 Piper，以免选错实体。

**Q10：会不会拉成 meroxa/piper？**
A：坐标必须是 **`linuxserver/piper`**。`meroxa/piper` 是另一个项目。

**Q11：能否完全离线？**
A：镜像用轩辕镜像拉取即可。语音列表和 `.onnx` 默认走 HuggingFace。通不了时按 **5.5 节** 预置文件并设 `LOCAL_ONLY=true`，之后合成不依赖外网。

**Q12：容器名 `/piper` already in use？**
A：`docker stop piper && docker rm piper`，再 `docker compose up -d`。

**Q13：开发者工具里找不到「用 YAML 执行」？**
A：顶栏 **YAML** 页不能播 TTS。点 **动作**，右上角用 **用户界面模式** 搜「说话」即可。要手写 YAML 时，点同一页的 **YAML 模式**，不要回到顶栏「YAML」。步骤与截图见 **6.2 节**。

**Q14：执行了 tts.speak，Piper 日志没有新行，是没调用到吗？**
A：**不一定。** 默认 INFO 只在启动时打 `Ready`，合成过程是 DEBUG，成功合成可以完全没有新日志。没有 ERROR 说明进程没崩。请看 HA **设置 → 系统 → 日志**（搜 wyoming / tts），或把播放器换成手机 Companion。

**Q15：天翼智屏在 HA 里音量默认是 0，拉满刷新又变回 0？**
A：播放器协议问题，不是 Piper。显示 0 时 TTS 可能完全没声。用遥控器把音量调到能听电视的位置后再执行。对照见 **6.3 节**：手机 Companion 有声则 Piper 正常。

---

## 十二、命令速查

```bash
docker pull docker.xuanyuan.run/linuxserver/piper:2.4.2

cd /www/wwwroot/piper
# macOS：cd ~/docker/piper
docker compose up -d
docker compose ps
docker compose logs -f --tail 100
ss -tlnp | grep 10200
# 然后在 Home Assistant 添加 Wyoming：主机 + 端口 10200

docker compose down
```

备选：

```bash
docker run -d --name=piper \
  -e PUID=1000 -e PGID=1000 -e TZ=Asia/Shanghai \
  -e PIPER_VOICE=zh_CN-huayan-medium \
  -p 10200:10200 \
  -v /www/wwwroot/piper/config:/config \
  --restart unless-stopped \
  docker.xuanyuan.run/linuxserver/piper:2.4.2
```

---

## 十三、延伸阅读

- [linuxserver/piper 镜像页](https://xuanyuan.cloud/zh/r/linuxserver/piper) · [标签列表](https://xuanyuan.cloud/r/linuxserver/piper/tags)
- [LinuxServer 官方文档 · piper](https://docs.linuxserver.io/images/docker-piper/)
- [GitHub · linuxserver/docker-piper](https://github.com/linuxserver/docker-piper)
- [GitHub · OHF-Voice/wyoming-piper](https://github.com/OHF-Voice/wyoming-piper)
- [Piper 音色试听](https://rhasspy.github.io/piper-samples/) · [HuggingFace · piper-voices](https://huggingface.co/rhasspy/piper-voices)
- [Home Assistant · 本地语音助手](https://www.home-assistant.io/voice_control/voice_remote_local_assistant/)
- 同系列：[Home Assistant Container 部署](https://xuanyuan.cloud/blog/docker-home-assistant)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)

---

## 总结

- Compose 拉起 `linuxserver/piper:2.4.2`（日志 **2.4.2-ls123**），映射 **10200→10200**，必填 **`PIPER_VOICE`**。
- HuggingFace 不通时：放入中文模型并设 **`LOCAL_ONLY=true`**；重建后日志应为 `Ready` + `10200 succeeded`，无 `Network is unreachable`。
- 没有网页后台；请在 Home Assistant 添加 **Wyoming 协议**（实测主机 **192.168.1.35:10200**），到开发者工具 **动作** 里执行 `tts.speak`。
- 协议口无认证，不要把 10200 映射到公网。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/piper-docker-deploy


