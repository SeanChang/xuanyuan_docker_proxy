# Docker 部署 Home Assistant：轻松搭建本地智能家居平台

![Docker 部署 Home Assistant：轻松搭建本地智能家居平台](https://imgs.xuanyuan.cloud/docker/blog/home-assistant-1.webp)

*分类: Docker部署教程 | 标签: Home Assistant,Docker,轩辕镜像,群晖,NAS,智能家居,私有化部署,部署教程 | 发布时间: 2025-10-03 07:50:22*

> Home Assistant 是开源的家庭自动化平台，把灯、传感器、打印机和摄像头接到同一套本地控制台，自动化规则跑在你自己的机器上。本文用 Docker Compose 部署 homeassistant/home-assistant 之后，可以在浏览器里完成初始化，并把局域网里发现的设备加进仪表盘。适合已有 Ubuntu 服务器或群晖 NAS、想替换多个品牌 App、并且希望断网后规则仍能执行的家庭。

*本文基于 [homeassistant/home-assistant:2026.7.1](https://xuanyuan.cloud/r/homeassistant/home-assistant)，以 **2026.7.1** 版本实测，测试平台 **Ubuntu 24.04** Linux。*

晚上回到家，客厅的灯在米家 App 里，空气净化器在另一个牌子的 App 里，打印机还要打开电脑上的状态页才知道墨还够不够。每个 App 各记一套账号，场景存在厂家云上。路由器闪断一下，手机里的开关就开始转圈。人在外面想看传感器，也要先等厂商服务器有响应。灯、传感器和打印机各走各的云，家里没有一块屏能同时看见它们。

这些开关记录、家庭位置和设备名单，默认会留在多家云上。家里往往已经有一台常开的 Ubuntu 服务器，或者一台群晖 NAS，电费和硬盘都在自己这边。缺的是跑在这台机器上的控制台：设备发现走局域网，自动化写在本地磁盘里。外网断了，已经配好的灯和传感器规则还能继续执行。

**Home Assistant**（[GitHub · home-assistant/core](https://github.com/home-assistant/core)、[镜像页](https://xuanyuan.cloud/r/homeassistant/home-assistant)）是开源的家庭自动化平台。浏览器打开 Web 界面就能看仪表盘、写自动化，把灯、传感器和打印机收进同一套面板。镜像 **`homeassistant/home-assistant`** 以单容器运行，配置、数据库和自动化落在挂载的 `/config`。本文使用 **`homeassistant/home-assistant:2026.7.1`** 版本实测。这里部署的是 Container 安装，不含 Add-on 商店。

服务起来之后，初始化向导会扫一遍局域网。本文这台环境里，它发现了 HP Smart Tank 网络打印机；加进客厅区域后，仪表盘上能看到四色墨盒余量和空闲状态。

---

## 一、环境要求

Home Assistant Container 直接占用宿主机的 **8123**。后文 Compose 使用 `network_mode: host`，不要改成 `8123:8123` 这种端口映射，否则局域网里的 mDNS 发现会失败。

### 1.1 Ubuntu 服务器（本文实测）

| 项目 | 建议 |
|------|------|
| 操作系统 | Linux（本文 **Ubuntu 24.04**）；macOS 把 `/www/wwwroot/homeassistant` 换成 `~/docker/homeassistant` |
| Docker | **Docker Engine ≥ 23.0**，并带 **Compose V2**（`docker compose`）。Docker Desktop 不适用 |
| 内存 | ≥ 2 GB（推荐 4 GB） |
| CPU | 双核 2.0 GHz 以上 |
| 磁盘 | ≥ 10 GB（镜像约 3.42 GB，再加上 `/config` 里的数据库和日志） |
| 端口 | **8123/tcp**（host 网络，由宿主机上的 Home Assistant 进程直接监听） |
| 工作目录 | `/www/wwwroot/homeassistant` |

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

### 1.2 群晖 NAS

本文的启动命令在 Ubuntu 24.04 上执行。群晖沿用同一份 Compose，只把配置目录换成 `/volume1/docker/homeassistant`。Web 向导与后文截图相同，截图来自 Ubuntu。

| 项目 | 建议 |
|------|------|
| 设备 | 群晖 NAS（x86 或 arm64 均可，架构须与镜像标签一致） |
| 系统 | DSM 7.x，已安装 **Container Manager**（原 Docker 套件） |
| 内存 | ≥ 2 GB（建议 4 GB） |
| CPU | 双核 2.0 GHz 以上 |
| 磁盘 | ≥ 10 GB |
| 端口 | **8123/tcp**（host 网络下由 DSM 直接占用） |
| SSH | 建议开启。图形界面里 host 网络和特权模式容易漏配 |
| 工作目录 | `/volume1/docker/homeassistant` |

群晖上配置镜像加速见 [群晖 NAS Docker 镜像源配置教程](https://xuanyuan.cloud/usage/synology)。

---

## 二、标签怎么选

本文命令只写 **`2026.7.1`**。`stable`、`latest` 会随仓库移动，界面和集成行为可能与本文不一致，不要写进 `compose.yaml` 或 `docker run`。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`2026.7.1`** | 本文实测的版本号，标签本身不随时间改指向 | **是** |
| `stable` | 随稳定版发布移动 | 否 |
| `latest` | 通常指向最新稳定构建，指向可能变化 | 否 |
| `beta` | 测试通道，含未正式发布的功能 | 否 |
| `rc` | 稳定版发布前的候选版本 | 否 |

长期开在家里的实例用具体版本号。要升级时，先备份 `/config`，再改 Compose 里的标签。`beta` 和 `rc` 只适合短期试验。

完整列表见 [homeassistant/home-assistant 标签页](https://xuanyuan.cloud/r/homeassistant/home-assistant/tags)。官方 Linux Container 文档的示例标签是 `stable`，这个标签会移动。本文命令使用 `2026.7.1`。

---

## 三、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
```

Ubuntu 24.04 实测：

```text
2026.7.1: Pulling from homeassistant/home-assistant
5835c1c32669: Pull complete
...
Digest: sha256:f73512ba4fe06bb4d57636fe3578d0820cdec46f81e8f837ab59e451662ff3cb
Status: Downloaded newer image for docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
```

拉取完成后确认本地镜像：

```bash
docker images
```

```text
IMAGE                                                       ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1   f73512ba4fe0       3.42GB          622MB    U
```

| 项目 | 数值 |
|------|------|
| 磁盘占用（DISK USAGE） | **3.42 GB** |
| 镜像内容大小（CONTENT SIZE） | **622 MB** |
| 本次 digest | `sha256:f73512ba4fe06bb4d57636fe3578d0820cdec46f81e8f837ab59e451662ff3cb` |

---

## 四、Docker Compose 部署

配置、数据库和自动化都写在容器内的 `/config`。这个目录必须挂到宿主机；删掉容器后，只要目录还在，重建即可恢复。

启动前先满足这三项，缺一项设备发现或写盘会异常：

- **`network_mode: host`**：Home Assistant 监听宿主机 8123，mDNS 依赖 host 网络。不要写成 `ports: ["8123:8123"]`。
- **`privileged: true`**：设备发现和部分硬件集成需要。
- **`/config` 挂载**：Ubuntu 用 `/www/wwwroot/homeassistant/config`，群晖用 `/volume1/docker/homeassistant/config`。

关系可以看成：

```text
浏览器 ── HTTP :8123 ──▶ Home Assistant 容器（host 网络）
宿主机 config 目录 ──▶ /config（配置、数据库、自动化）
容器 ── mDNS / 局域网 ──▶ 灯、传感器、打印机
USB Zigbee 棒（可选）──▶ /dev/ttyUSB0
```

### 4.1 Ubuntu

1. 创建目录并写入 `compose.yaml`：

```bash
mkdir -p /www/wwwroot/homeassistant/config
cd /www/wwwroot/homeassistant
cat > compose.yaml <<'EOF'
services:
  homeassistant:
    container_name: homeassistant
    image: docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
    volumes:
      - /www/wwwroot/homeassistant/config:/config
      - /etc/localtime:/etc/localtime:ro
      - /run/dbus:/run/dbus:ro
    restart: unless-stopped
    stop_grace_period: 60s
    privileged: true
    network_mode: host
    environment:
      TZ: Asia/Shanghai
EOF
```

`stop_grace_period: 60s` 来自当前官方 Compose 示例。Docker 默认大约 10 秒后会强行停容器，数据库有时来不及写完。这是停机等待的上限，容器正常退出后会立刻结束，不会每次都空等 60 秒。

2. 第一次部署跳过本步。若已经有同名容器（例如以前用 `docker run` 创建过），先停掉并删除。`/config` 在宿主机上，删除容器不会删掉该目录：

```bash
docker stop homeassistant
docker rm homeassistant
```

3. 启动：

```bash
docker compose up -d
```

### 4.2 群晖 NAS

在群晖 SSH 里执行。文件内容与 Ubuntu 相同，只有 `/config` 的宿主机路径不同。也可以在 **File Station** 里先建好 `docker/homeassistant/config` 文件夹。

```bash
mkdir -p /volume1/docker/homeassistant/config
cd /volume1/docker/homeassistant
cat > compose.yaml <<'EOF'
services:
  homeassistant:
    container_name: homeassistant
    image: docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
    volumes:
      - /volume1/docker/homeassistant/config:/config
      - /etc/localtime:/etc/localtime:ro
      - /run/dbus:/run/dbus:ro
    restart: unless-stopped
    stop_grace_period: 60s
    privileged: true
    network_mode: host
    environment:
      TZ: Asia/Shanghai
EOF
```

已有同名容器时，先 `docker stop homeassistant && docker rm homeassistant`。然后：

```bash
docker compose up -d
```

若这台 DSM 上没有 `docker compose` 子命令，用第九节的 `docker run`。Container Manager 的「项目」也可以加载同一份 YAML，加载前核对 **host 网络** 和 **特权模式** 两项都在。

### 4.3 参数

| 参数 | 说明 |
|------|------|
| `network_mode: host` | Home Assistant 监听宿主机 8123，mDNS 设备发现依赖它 |
| `privileged: true` | 设备发现和部分硬件集成需要 |
| `TZ: Asia/Shanghai` | 时区。国内用上海 |
| `/config` 挂载 | 配置、SQLite 数据库、自动化、集成数据 |
| `/run/dbus` 只读挂载 | 蓝牙集成使用。没有蓝牙时可以删掉这一行 |
| `/etc/localtime` 只读挂载 | 让容器读取宿主机本地时间 |
| `restart: unless-stopped` | 宿主机或群晖重启后自动拉起 |
| `stop_grace_period: 60s` | 停机时最多再等 60 秒，便于写完数据库 |

有 Zigbee 或 Z-Wave USB 棒时，先用 `lsusb` 和 `ls -l /dev/serial/by-id/` 确认节点，再在服务下追加（群晖上常见 `/dev/ttyUSB0` 或 `/dev/ttyACM0`）：

```yaml
    devices:
      - /dev/ttyUSB0:/dev/ttyUSB0
```

### 4.4 确认已经启动

```bash
docker ps -a | grep homeassistant
```

状态为 `Up` 时类似：

```text
9fae6b9a3846   docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1   "/init"   ...   Up ...   homeassistant
```

看日志：

```bash
docker logs -f homeassistant
```

首次启动会先做初始化，完整起来通常要 **2～20 分钟**。日志里若出现 Python `SyntaxWarning`（例如 `'return' in a 'finally' block`），来自依赖库，可以忽略。

确认 8123 已在监听：

```bash
ss -tlnp | grep 8123
```

有输出表示核心进程已起来：

```text
LISTEN 0      128          0.0.0.0:8123       0.0.0.0:*    users:(("python3",pid=3555006,fd=9))
LISTEN 0      128             [::]:8123          [::]:*    users:(("python3",pid=3555006,fd=11))
```

本机再测一次。`curl -I` 发的是 HEAD，Home Assistant 只接受 GET，因此返回 `HTTP/1.1 405 Method Not Allowed` 表示服务已经在响应：

```bash
curl -I http://127.0.0.1:8123
```

改用 GET 看状态码：

```bash
curl -s -o /dev/null -w "%{http_code}
" http://127.0.0.1:8123
```

返回 `200` 或 `302` 即可打开浏览器。群晖在 SSH 里用同一条 `curl`。

### 4.5 放行 8123

本机 `curl` 正常，只说明容器在听 127.0.0.1。局域网里的浏览器还要过防火墙。

**Ubuntu。** 本文访问 `http://192.168.1.18:8123` 时出现 **ERR_CONNECTION_TIMED_OUT**。当时 UFW 是 `active`，放行列表里没有 8123。

```bash
ufw status
ufw allow 8123/tcp
```

使用宝塔面板时，在「安全」里再放行 **8123**。确认网卡地址：

```bash
ip addr | grep 192.168.1
```

本文输出：`inet 192.168.1.18/24 ... enp0s25`。

**群晖。** 群晖没有 UFW。浏览器打开 `http://群晖IP:8123` 超时，而 SSH 里对 `127.0.0.1:8123` 的 `curl` 已是 `200` 或 `302` 时，到 **控制面板 → 安全性 → 防火墙**，为入站 **TCP 8123** 加一条允许规则。若要确认是不是防火墙拦住的，可在同一局域网内临时关掉防火墙试一次，确认后记得按原策略开回去。

---

## 五、浏览器初始化

Ubuntu 与群晖打开的是同一套向导。下面把 IP 换成你的机器地址：

```text
http://192.168.1.18:8123
http://群晖IP:8123
```

截图来自 Ubuntu 24.04。

### 5.1 欢迎页

首次进入是欢迎页。语言可以先切到简体中文。要全新安装时，点击 **「创建我的智能家居」**。已有备份时，改走上传备份或 Home Assistant Cloud 还原，不必从空配置开始。

![Home Assistant 欢迎页：创建我的智能家居、上传备份、Home Assistant Cloud 还原](https://img.xuanyuan.dev/docker/blog/homeassistant-1.png)

### 5.2 创建用户

填写姓名、用户名和密码，点击 **「创建账户」**。本文账户姓名是 Sean Chang。这个账户拥有全部管理权限，密码请单独保存。

![Home Assistant 创建用户：姓名、用户名、密码与确认密码](https://img.xuanyuan.dev/docker/blog/homeassistant-2.png)

### 5.3 家的位置

搜索家庭所在城市。本文选择 **杭州市**，地图会落到对应坐标。日出日落和天气集成会用这个位置。

![Home Assistant 家的位置：搜索杭州并在地图上确认坐标](https://img.xuanyuan.dev/docker/blog/homeassistant-3.png)

### 5.4 分析与隐私

向导询问是否分享匿名使用数据。各项都可以关掉，然后点击 **「下一步」**。

![Home Assistant 分析与隐私：基础分析、使用情况、统计数据、诊断信息开关](https://img.xuanyuan.dev/docker/blog/homeassistant-4.png)

### 5.5 自动发现

向导扫描局域网。本文扫到 **Internet Printing Protocol (IPP)** 打印机集成。确认列表后点击 **「完成」**。

![Home Assistant 自动发现：Internet Printing Protocol IPP 集成](https://img.xuanyuan.dev/docker/blog/homeassistant-5.png)

---

## 六、主界面

初始化结束后进入主界面。左侧是导航，右侧是各模块。

### 6.1 概览

默认 **概览** 显示欢迎语、客厅 / 厨房 / 卧室 / 设备等区域卡片，以及右侧摘要。本文右侧是「1 个设备可添加」和杭州天气 33.5°C、阴。

![Home Assistant 概览：欢迎语、区域卡片、天气与待添加设备](https://img.xuanyuan.dev/docker/blog/homeassistant-6.png)

### 6.2 地图

**地图** 用 OpenStreetMap 标出前面选的家庭位置（杭州市）。

![Home Assistant 地图：杭州市位置标记与 OpenStreetMap 底图](https://img.xuanyuan.dev/docker/blog/homeassistant-7.png)

### 6.3 能源

**能源** 用 6 步向导配置电网、太阳能等监控。不需要能源统计时可以跳过。下图是第 1 步。

![Home Assistant 能源向导第 1 步：电力公司与电网连接](https://img.xuanyuan.dev/docker/blog/homeassistant-8.png)

### 6.4 活动

**活动** 记录系统事件。本文能看到 `Home Assistant started`，以及 Sun 实体的日出、日落变化。启动时间 **13:51:49** 与容器日志一致。

![Home Assistant 活动日志：Home Assistant started 与 Sun 白天夜间切换](https://img.xuanyuan.dev/docker/blog/homeassistant-9.png)

### 6.5 媒体

**媒体** 列出本机可用的媒体源，包括 AI 生成图片、摄像头、Radio Browser 和文字转语音。

![Home Assistant 媒体源：AI 图片、Camera、Radio Browser、Text-to-speech](https://img.xuanyuan.dev/docker/blog/homeassistant-10.png)

### 6.6 待办事项

内置 **购物清单**。列表为空时可以直接加项目，也可以另建清单。

![Home Assistant 待办事项：购物清单为空，可添加项目](https://img.xuanyuan.dev/docker/blog/homeassistant-11.png)

### 6.7 设置

**设置** 集中放着集成、自动化、区域、人员、备份和重启。

![Home Assistant 设置页：设备与服务、自动化与场景、系统](https://img.xuanyuan.dev/docker/blog/homeassistant-12.png)

---

## 七、把 HP Smart Tank 加进客厅

向导结束后，概览仍可能提示有未添加的设备。本文局域网里的打印机是 **HP Smart Tank 210-220 series**，与 [CUPS Docker 部署教程](https://xuanyuan.cloud/blog/cups-docker-deploy) 里的是同一台。

### 7.1 发现弹窗

概览弹出 **「您想要添加什么？」**。已发现列表里有这台 HP Smart Tank。

![Home Assistant 设备发现弹窗：HP Smart Tank 210-220 series IPP 打印机](https://img.xuanyuan.dev/docker/blog/homeassistant-13.png)

### 7.2 确认添加

点开 HP Smart Tank 这一条。页面询问 **「您想设置 HP Smart Tank 210-220 series [DAD28A] 吗？」**。点击 **「提交」**。

![Home Assistant 确认添加打印机：HP Smart Tank 210-220 series](https://img.xuanyuan.dev/docker/blog/homeassistant-14.png)

### 7.3 命名并指定区域

名称保持默认 **HP Smart Tank 210-220 series** 即可。区域选 **客厅**，点击 **「完成」**。

![Home Assistant 命名设备：名称与区域选择客厅](https://img.xuanyuan.dev/docker/blog/homeassistant-15.png)

### 7.4 在客厅里看状态

**客厅** 卡片上出现打印机。本文四色墨盒余量都是 **100%**，状态为 **空闲**。

![Home Assistant 客厅：HP Smart Tank 墨盒余量与空闲状态](https://img.xuanyuan.dev/docker/blog/homeassistant-16.png)

### 7.5 设备详情

设备页能看到制造商 HP、固件版本、序列号和 IPP 集成。传感器列出各色墨盒余量与打印机状态。

![Home Assistant 设备详情：HP Smart Tank 固件、序列号、IPP 集成与传感器](https://img.xuanyuan.dev/docker/blog/homeassistant-17.png)

### 7.6 接到自动化（可选）

同一设备页可以把打印机用作触发器、条件或动作，用来新建自动化或脚本。

![Home Assistant 自动化：把 HP Smart Tank 用作触发器、条件或动作](https://img.xuanyuan.dev/docker/blog/homeassistant-18.png)

---

## 八、备份、升级与可选硬件

### 8.1 记下 digest

标签 `2026.7.1` 已经固定到本文实测的这一版。若要再核对镜像摘要，在拉取它的机器上执行：

```bash
docker inspect docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1 --format='{{index .RepoDigests 0}}'
```

本文结果为 `sha256:f73512ba4fe06bb4d57636fe3578d0820cdec46f81e8f837ab59e451662ff3cb`。

### 8.2 备份 /config

Ubuntu：

```bash
tar -czf homeassistant-config-backup-$(date +%Y%m%d).tar.gz -C /www/wwwroot/homeassistant config
```

群晖：

```bash
tar -czf /volume1/docker/homeassistant-config-backup-$(date +%Y%m%d).tar.gz -C /volume1/docker/homeassistant config
```

Web 里也可以做：**设置 → 系统 → 备份**。Ubuntu 和群晖的这个页面相同。

### 8.3 更换版本

先按上一节备份。打开 `compose.yaml`，把 `image` 里的标签改成要升级的版本号，保存后再执行。

Ubuntu：

```bash
cd /www/wwwroot/homeassistant
docker compose pull
docker compose up -d
```

群晖把目录换成 `/volume1/docker/homeassistant`，命令相同。`up -d` 发现镜像或 `stop_grace_period` 等配置变化后会重建容器，宿主机上的 `/config` 目录保留。

### 8.4 用域名访问（示例）

只在局域网用 IP 和 8123 时，不必加反向代理。要改成域名和 HTTPS 时，可以在本机 Nginx 上做一层转发，并在 Home Assistant 的 `configuration.yaml` 里配置 `http:` 信任代理。信任代理的字段见 [HTTP 集成里的反向代理说明](https://www.home-assistant.io/integrations/http/#reverse-proxies)。

```nginx
server {
    listen 443 ssl;
    server_name ha.example.com;

    location / {
        proxy_pass http://127.0.0.1:8123;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

不要把 8123 直接暴露到公网。公网入口另加认证，或改用 [Home Assistant Cloud](https://www.nabucasa.com/) 的隧道。

### 8.5 USB 控制器与蓝牙

Zigbee、Z-Wave 等 USB 棒按 4.3 节追加 `devices`。`docker run` 里对应的是 `--device /dev/ttyUSB0:/dev/ttyUSB0`。

蓝牙使用已经写进 Compose 的 `/run/dbus:/run/dbus:ro`。没有蓝牙需求时删掉该行，然后 `docker compose up -d` 重建。

部分 ARM64 机器页大小大于 4K，启动日志可能出现 `Unsupported system page size`。出现这句话时，在 `environment` 里加上 `DISABLE_JEMALLOC: true`（`docker run` 则是 `-e DISABLE_JEMALLOC=true`），再重建容器。

---

## 九、备选：docker run

机器上没有 Compose 时，用下面的命令。网络、特权和 `/config` 与第四节相同。

Ubuntu：

```bash
docker run -d 
  --name homeassistant 
  --privileged 
  --restart=unless-stopped 
  --stop-timeout 60 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/homeassistant/config:/config 
  -v /run/dbus:/run/dbus:ro 
  --network=host 
  docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
```

群晖只改配置目录：

```bash
docker run -d 
  --name homeassistant 
  --privileged 
  --restart=unless-stopped 
  --stop-timeout 60 
  -e TZ=Asia/Shanghai 
  -v /volume1/docker/homeassistant/config:/config 
  -v /run/dbus:/run/dbus:ro 
  --network=host 
  docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
```

`--stop-timeout 60` 与 Compose 的 `stop_grace_period: 60s` 是同一件事。USB 棒再追加 `--device /dev/ttyUSB0:/dev/ttyUSB0`。之后的端口检查、防火墙和浏览器向导仍按第四、五节操作。

改回 Compose 前，先 `docker stop homeassistant && docker rm homeassistant`，避免容器名冲突。

---

## 十、常见问题

**Q1：浏览器打开 8123 超时，但 `curl 127.0.0.1:8123` 返回 200 或 302？**

服务已经在本机监听，包多半被防火墙丢掉。Ubuntu 上执行 `ufw allow 8123/tcp`；用了宝塔时，在安全面板里同步放行 8123。本文 Ubuntu 实测就是这个情况。群晖到 **控制面板 → 安全性 → 防火墙**，添加入站 **TCP 8123**。

**Q2：群晖能不能只用 Container Manager 点选部署？**

可以加载项目，但 host 网络和特权模式在图形界面里容易漏。本文把群晖主路径写成 SSH 里的 `compose.yaml`。DSM 上若没有 `docker compose`，用第九节的 `docker run`。部署完成后打开 `http://群晖IP:8123`，向导与 Ubuntu 相同。

**Q3：能不能用 `-p 8123:8123` 代替 host 网络？**

本文使用 host 网络，与官方 Container 安装一致。普通端口映射下，mDNS 发现以及 Cast、Sonos 一类依赖组播的集成可能异常。

**Q4：第一次启动要多久才能打开页面？**

通常 **2～20 分钟**。先用 `ss -tlnp | grep 8123` 看到监听，再打开浏览器。

**Q5：`curl -I` 返回 405，是启动失败吗？**

不是。`curl -I` 发送 HEAD，Home Assistant 只接受 GET，所以返回 405，说明进程已经在应答。浏览器访问是 GET。需要状态码时用第四节的 GET 那条 `curl`。

**Q6：Container 和 Home Assistant OS 怎么选？**

| 功能 | Home Assistant OS | Container（本文） |
|------|-------------------|-------------------|
| 自动化、仪表盘、集成 | 有 | 有 |
| Add-on 商店 | 有 | 无 |
| 系统更新 | 系统内一键更新 | 修改镜像标签后重新拉取 |
| Thread、Z-Wave 官方 Add-on | 有 | 无，需自己映射 USB 等设备 |

机器上已经有 Linux 和 Docker 时，用本文的 Container。需要 Add-on 商店或官方的 Thread、Z-Wave 附加组件时，改用 [Home Assistant OS](https://www.home-assistant.io/installation/)。

**Q7：日志里的 SyntaxWarning 要处理吗？**

本文出现的 `SyntaxWarning: 'return' in a 'finally' block` 来自依赖库，可以忽略，服务仍能正常打开。

**Q8：怎么重启？**

```bash
docker restart homeassistant
```

使用 Compose 时：

```bash
docker compose restart
```

也可以在 **设置 → 系统** 里重启。重启前如果数据库较大，保留 `stop_grace_period` 或 `--stop-timeout 60`，避免默认约 10 秒就被切断。官方文档写明，切断过早时下次启动可能出现 SQLite 未正常关闭的警告。

**Q9：8123 已经被占用怎么办？**

```bash
ss -tlnp | grep 8123
```

先确认没有别的进程占着 8123。Home Assistant 可以在 `configuration.yaml` 的 `http:` 里改监听端口；host 网络下，浏览器地址里的端口要一起改。

**Q10：人在外面怎么访问？**

局域网继续用 `http://服务器IP:8123`。要对家外面开放时，用第八节的 Nginx 示例加上 HTTPS 和认证，或使用 [Home Assistant Cloud](https://www.nabucasa.com/)。不要把 8123 直接映射到公网。

**Q11：配置文件在哪？**

Ubuntu 在 `/www/wwwroot/homeassistant/config`，群晖在 `/volume1/docker/homeassistant/config`。删除容器不会删除这两个目录。重建时挂上同一路径即可恢复。

**Q12：群晖要不要设置 PUID 和 PGID？**

Home Assistant 在容器里以 root 写入 `/config`。直接挂载 `/volume1/docker/homeassistant/config` 即可。不必像 MT Photos 那样为数据库用户改目录属主。

**Q13：`stable`、`latest` 和 `2026.7.1` 用哪个？**

本文命令使用 **`2026.7.1`**。`stable` 和 `latest` 会移动，不要替换 Compose 里的标签。试验性的 `beta`、`rc` 不要放在长期开着的家里实例上。可选标签见 [标签列表](https://xuanyuan.cloud/r/homeassistant/home-assistant/tags)。

**Q14：部分 ARM 设备报 `Unsupported system page size`？**

这与 jemalloc 在大于 4K 的页上不兼容有关。按 8.5 节设置 `DISABLE_JEMALLOC=true` 后重建容器。没有这句报错时不必加。

---

## 十一、命令速查

| 操作 | Ubuntu | 群晖 NAS |
|------|--------|----------|
| 拉取镜像 | `docker pull docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1` | 同左 |
| 创建目录 | `mkdir -p /www/wwwroot/homeassistant/config` | `mkdir -p /volume1/docker/homeassistant/config` |
| 启动 | `cd /www/wwwroot/homeassistant && docker compose up -d` | `cd /volume1/docker/homeassistant && docker compose up -d` |
| 查看状态 | `docker compose ps` | 同左 |
| 查看日志 | `docker logs -f homeassistant` | 同左 |
| 本机测试 | `curl -s -o /dev/null -w "%{http_code}
" http://127.0.0.1:8123` | 同左 |
| 防火墙 | `ufw allow 8123/tcp` | 控制面板 → 安全性 → 防火墙 → 允许 TCP 8123 |
| 浏览器 | `http://服务器IP:8123` | `http://群晖IP:8123` |
| 停止并删除容器 | `docker compose down` | 同左 |
| 没有 Compose | 第九节 `docker run` | 同左 |

`docker compose down` 会删掉容器，不会删除绑定挂载的 config 目录。

---

## 十二、延伸阅读

| 资源 | 链接 |
|------|------|
| [homeassistant/home-assistant 镜像页](https://xuanyuan.cloud/zh/r/homeassistant/home-assistant) | [https://xuanyuan.cloud/zh/r/homeassistant/home-assistant](https://xuanyuan.cloud/zh/r/homeassistant/home-assistant) |
| [homeassistant/home-assistant 概览](https://xuanyuan.cloud/r/homeassistant/home-assistant) | [https://xuanyuan.cloud/r/homeassistant/home-assistant](https://xuanyuan.cloud/r/homeassistant/home-assistant) |
| [homeassistant/home-assistant 标签列表](https://xuanyuan.cloud/r/homeassistant/home-assistant/tags) | [https://xuanyuan.cloud/r/homeassistant/home-assistant/tags](https://xuanyuan.cloud/r/homeassistant/home-assistant/tags) |
| [Docker Hub · homeassistant/home-assistant](https://hub.docker.com/r/homeassistant/home-assistant) | [https://hub.docker.com/r/homeassistant/home-assistant](https://hub.docker.com/r/homeassistant/home-assistant) |
| [GitHub · home-assistant/core](https://github.com/home-assistant/core) | [https://github.com/home-assistant/core](https://github.com/home-assistant/core) |
| [Home Assistant 安装方式](https://www.home-assistant.io/installation/) | [https://www.home-assistant.io/installation/](https://www.home-assistant.io/installation/) |
| [Linux 上安装 Container](https://www.home-assistant.io/installation/linux/) | [https://www.home-assistant.io/installation/linux/](https://www.home-assistant.io/installation/linux/) |
| [HTTP 集成与反向代理](https://www.home-assistant.io/integrations/http/) | [https://www.home-assistant.io/integrations/http/](https://www.home-assistant.io/integrations/http/) |
| [CUPS Docker 部署教程](https://xuanyuan.cloud/blog/cups-docker-deploy) | [https://xuanyuan.cloud/blog/cups-docker-deploy](https://xuanyuan.cloud/blog/cups-docker-deploy) |
| [群晖 NAS Docker 镜像源配置](https://xuanyuan.cloud/usage/synology) | [https://xuanyuan.cloud/usage/synology](https://xuanyuan.cloud/usage/synology) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |
| [Home Assistant Cloud](https://www.nabucasa.com/) | [https://www.nabucasa.com/](https://www.nabucasa.com/) |

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/docker-home-assistant


