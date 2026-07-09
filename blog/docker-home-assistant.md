# Home Assistant Docker 部署教程：打造本地智能家居平台，手把手教你实战搭建

![Home Assistant Docker 部署教程：打造本地智能家居平台，手把手教你实战搭建](https://img.xuanyuan.dev/docker/blog/docker-home-assistant.png)

*分类: Docker部署教程 | 标签: Home Assistant,Docker,轩辕镜像,群晖,NAS,智能家居,私有化部署,部署教程 | 发布时间: 2025-10-03 07:50:22*

> 米家、涂鸦、各品牌 App 各管各的，数据还往云端跑？Home Assistant 是开源家庭自动化平台——主打 本地控制与隐私优先，把灯、传感器、打印机、摄像头等设备统一接入，自动化规则跑在你自己的服务器上，断网也能继续工作。典型场景：Ubuntu / 云服务器、群晖 / 威联通等 NAS 7×24 常开，作为家庭智能家居中枢。

*本文基于 [homeassistant/home-assistant:2026.7.1](https://xuanyuan.cloud/zh/r/homeassistant/home-assistant) 镜像，**Ubuntu 24.04 服务器**实测（IP `192.168.1.18`，端口 `8123`）；**群晖 NAS** 同样推荐 **SSH + docker run** 部署，Web 访问与初始化步骤一致*

米家、涂鸦、各品牌 App 各管各的，数据还往云端跑？**Home Assistant** 是开源家庭自动化平台——主打 **本地控制与隐私优先**，把灯、传感器、打印机、摄像头等设备统一接入，自动化规则跑在你自己的服务器上，断网也能继续工作。典型场景：Ubuntu / 云服务器、**群晖 / 威联通等 NAS** 7×24 常开，作为家庭智能家居中枢。

本文带你用 **Docker 单容器** 跑通 Home Assistant Container：轩辕镜像加速拉取、**SSH `docker run` 一键启动**（Ubuntu 与群晖均推荐命令行）、持久化 `/config` 挂载，再跟做 **Web 初始化向导**——Ubuntu 24.04 全程实测，附 **18 张截图** 与完整命令；文末 FAQ 收录 **UFW / 群晖 DSM 防火墙 8123 未放行** 踩坑修复，并演示自动发现并集成局域网 **HP Smart Tank** 打印机。

国内用户从 Docker Hub 拉取可能较慢，本文使用 [轩辕镜像](https://xuanyuan.cloud) 加速。官方安装说明见 [Home Assistant Installation](https://www.home-assistant.io/installation/)，Container 专项文档见 [Install on Linux — Container](https://www.home-assistant.io/installation/linux#install-home-assistant-container)。

---

## 一、Home Assistant 是什么？

**Home Assistant** 是一款开源家庭自动化工具，由全球社区维护，适合部署在树莓派、NAS 或本地服务器上。核心理念：**数据留在本地、用户掌握设备管理权**，同时支持上千种设备集成与灵活自动化。

| 能力 | 说明 |
|------|------|
| 设备集成 | 支持灯、开关、传感器、打印机、摄像头等数千种设备 |
| 自动化 | 基于触发器 / 条件 / 动作创建场景与规则 |
| 仪表盘 | 浏览器自定义控制面板，手机 App 可远程访问（需额外配置） |
| 本地优先 | 断网后本地自动化仍可运行，隐私数据不上传云端 |

典型使用场景：Ubuntu / 云服务器、**群晖 / 威联通等 NAS** 作为家庭智能家居中枢；替代各品牌云端 App，**私有化统一管理**设备与自动化。

### Container 与 HA OS 的区别

Home Assistant 有两种主流安装方式。本文采用 **Home Assistant Container**（Docker 单容器），适合已有 Linux + Docker 或 **群晖 Container Manager** 的用户：

| 功能 | HA OS（推荐新手） | Container（本文） |
|------|-------------------|-------------------|
| 自动化 / 仪表盘 / 集成 | ✅ | ✅ |
| Add-on 商店 | ✅ | ❌ |
| 一键系统更新 | ✅ | 需手动 pull 镜像 |
| Thread / Z-Wave Add-on | ✅ | ❌（需自行配置） |
| 部署复杂度 | 需专用镜像/硬件 | 已有 Docker 即可 |

> **部署要点**：Container 模式 **必须** 使用 `--network=host`，**不能** 用 `-p 8123:8123` 简单端口映射替代；配置持久化在宿主机 `/config` 目录。无 Add-on 商店，Thread、Z-Wave 等需 HA OS 的集成在 Container 下需额外方案。

架构示意：

```text
浏览器 ──HTTP:8123──▶ Home Assistant 容器（host 网络）
宿主机 config 目录 ──▶ /config（配置、数据库、自动化）
  · Ubuntu：/www/wwwroot/homeassistant/config
  · 群晖：  /volume1/docker/homeassistant/config
容器 ──mDNS/局域网──▶ 智能设备（打印机、灯、传感器等）
USB Zigbee 棒（可选）──▶ --device /dev/ttyUSB0
```

---

## 二、环境要求

### 2.1 Ubuntu 服务器（本文实测）

| 项目 | 建议 |
|------|------|
| 操作系统 | Linux（本文 **Ubuntu 24.04**） |
| Docker | **Docker Engine ≥ 23.0**（须 Engine，Docker Desktop 不适用） |
| 内存 | ≥ 2 GB（推荐 4 GB） |
| CPU | 双核 2.0 GHz 以上 |
| 磁盘 | ≥ 10 GB（镜像约 **3.42 GB** + `/config` 持久化） |
| 端口 | **8123**（Web 界面，host 网络直接占用） |
| 工作目录 | `/www/wwwroot/homeassistant`（独立目录，勿与其他项目混用） |

验证 Docker：

```bash
docker --version
docker compose version
```

若尚未安装 Docker，可使用轩辕镜像一键脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

### 2.2 群晖 NAS（推荐 SSH 部署）

| 项目 | 建议 |
|------|------|
| 设备 | 群晖 NAS（DS920plus 等 x86 / arm64 均可，需确认架构与镜像标签匹配） |
| 系统 | DSM 7.x，已安装 **Container Manager**（原 Docker 套件） |
| 内存 | ≥ 2 GB（建议 4 GB，HA 常驻内存占用高于轻量容器） |
| CPU | 双核 2.0 GHz 以上 |
| 磁盘 | ≥ 10 GB（镜像约 **3.42 GB** + `/config` 持久化） |
| 端口 | **8123**（host 网络模式下 DSM 直接占用） |
| SSH | **建议开启**，本文推荐 SSH 命令行部署（与 MT Photos 等同理） |
| 工作目录 | `/volume1/docker/homeassistant` |

验证 Docker（SSH 终端）：

```bash
docker --version
```

群晖 NAS 镜像加速配置见 [群晖 NAS Docker 镜像源配置教程](https://xuanyuan.cloud/usage/synology)。

> **为何群晖也推荐 SSH？** Home Assistant Container **必须** `--network=host` 与 `--privileged`，Container Manager 图形界面配置 host 网络、特权模式较繁琐且易漏项；**SSH 一条 `docker run` 与 Ubuntu 完全相同**，复制即用。部署完成后，浏览器访问 `http://群晖IP:8123`，**Web 初始化向导与下文第八～十节完全一致**，无需重复操作。

更多安装说明见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

**镜像标签怎么选？**

Home Assistant 在 Docker Hub 提供多种标签，完整列表见 [轩辕镜像标签页](https://xuanyuan.cloud/r/homeassistant/home-assistant/tags)。常用标签与拉取命令如下：

```bash
docker pull docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1   # 本文实测，固定版本号
docker pull docker.xuanyuan.run/homeassistant/home-assistant:stable     # 当前稳定版通道
docker pull docker.xuanyuan.run/homeassistant/home-assistant:latest     # 最新稳定构建
docker pull docker.xuanyuan.run/homeassistant/home-assistant:beta       # 测试版，含未正式发布功能
docker pull docker.xuanyuan.run/homeassistant/home-assistant:rc         # 候选发布版，稳定版发布前验证用
```

| 标签 | 更新频率 | 适用场景 | 生产环境建议 |
|------|----------|----------|--------------|
| **`2026.7.1`**（版本号） | 固定不变 | 文档复现、生产锁定、升级可控 | **推荐**。本文采用；升级时手动改版本号 |
| **`stable`** | 随稳定版发布推进 | 希望 `pull` 时始终拿到当前稳定版 | 可用；每次 pull 可能跨小版本，升级前建议备份 `/config` |
| **`latest`** | 通常指向最新稳定构建 | 快速体验、个人测试 | 可用但不建议生产；标签指向可能随仓库策略变化 |
| **`beta`** | 每轮开发周期更新 | 尝鲜新功能、参与测试 | **不推荐**生产；可能含未稳定特性 |
| **`rc`** | 稳定版发布前夕 | 验证即将发布的版本 | **不推荐**生产；仅预发布验证 |

**选型建议**：

- **家庭 / 生产 NAS 长期运行**：优先 **`2026.7.1` 等具体版本号**，或 `stable` + 定期备份后手动升级
- **个人尝鲜**：`latest` 或 `beta`
- **升级前**：无论哪种标签，先备份 `/config`，再 `docker pull` → 重建容器

> 官方 GHCR 镜像（`ghcr.io/home-assistant/home-assistant:stable`）与 Docker Hub 标签体系类似；本文统一使用轩辕加速的 **Docker Hub 路径** `homeassistant/home-assistant`。

**镜像大小参考**（Ubuntu 24.04 实测 `2026.7.1`）：

| 项目 | 数值 |
|------|------|
| 磁盘占用（DISK USAGE） | **3.42 GB** |
| 镜像内容大小（CONTENT SIZE） | **622 MB**（压缩层） |
| 建议预留磁盘 | ≥ **10 GB**（镜像 + `/config` 数据库与日志增长） |

---

## 三、拉取镜像

SSH 登录 **Ubuntu 服务器**或**群晖 NAS**，拉取 Home Assistant 镜像（命令相同）。标签选择见 **第二节「镜像标签怎么选」**；更多版本见 [homeassistant/home-assistant 标签列表](https://xuanyuan.cloud/r/homeassistant/home-assistant/tags)。

```bash
docker pull docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
```

成功时终端类似输出：

```text
2026.7.1: Pulling from homeassistant/home-assistant
5835c1c32669: Pull complete
...
Digest: sha256:f73512ba4fe06bb4d57636fe3578d0820cdec46f81e8f837ab59e451662ff3cb
Status: Downloaded newer image for docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
```

拉取完成后，可用 `docker images` 确认本地镜像（`2026.7.1` 磁盘占用约 **3.42 GB**）：

```bash
docker images
```

实测输出（摘要）：

```text
IMAGE                                                       ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1   f73512ba4fe0       3.42GB          622MB    U
```

| 官方镜像 | 轩辕镜像加速拉取 | 说明 |
|----------|------------------|------|
| `homeassistant/home-assistant:2026.7.1` | `docker pull docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1` | 本文主镜像，固定版本 |
| `homeassistant/home-assistant:stable` | `docker pull docker.xuanyuan.run/homeassistant/home-assistant:stable` | 当前稳定版通道 |
| `homeassistant/home-assistant:latest` | `docker pull docker.xuanyuan.run/homeassistant/home-assistant:latest` | 最新稳定构建 |
| `homeassistant/home-assistant:beta` | `docker pull docker.xuanyuan.run/homeassistant/home-assistant:beta` | 测试版 |
| `homeassistant/home-assistant:rc` | `docker pull docker.xuanyuan.run/homeassistant/home-assistant:rc` | 候选发布版 |

镜像页：[homeassistant/home-assistant](https://xuanyuan.cloud/r/homeassistant/home-assistant) · 标签列表：[tags](https://xuanyuan.cloud/r/homeassistant/home-assistant/tags)

---

## 四、创建数据目录

Home Assistant 所有配置、数据库、自动化规则写入容器内 `/config`，**必须**挂载到宿主机持久化。删除容器后，只要保留该目录，重建容器即可恢复全部配置。

### 4.1 Ubuntu

```bash
mkdir -p /www/wwwroot/homeassistant/config
cd /www/wwwroot/homeassistant
```

| 宿主机目录 | 容器内路径 | 用途 |
|------------|------------|------|
| `/www/wwwroot/homeassistant/config` | `/config` | **必挂**：配置、SQLite 数据库、自动化、集成数据 |

### 4.2 群晖 NAS

SSH 登录群晖后执行：

```bash
mkdir -p /volume1/docker/homeassistant/config
cd /volume1/docker/homeassistant
```

| 宿主机目录 | 容器内路径 | 用途 |
|------------|------------|------|
| `/volume1/docker/homeassistant/config` | `/config` | **必挂**：配置、数据库、自动化、集成数据 |

也可在 **File Station** 中手动创建 `docker/homeassistant/config` 文件夹，效果相同。

---

## 五、启动容器（docker run）

Home Assistant Container **必须**使用 host 网络与 privileged 模式。**Ubuntu 与群晖命令结构相同**，仅 `/config` 挂载路径不同。

> **注意**：**不要**使用 `-p 8123:8123` 替代 host 网络——会导致 mDNS 发现失败及部分集成异常。

### 5.1 Ubuntu 服务器

```bash
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

### 5.2 群晖 NAS（SSH，推荐）

```bash
docker run -d \
  --name homeassistant \
  --privileged \
  --restart=unless-stopped \
  -e TZ=Asia/Shanghai \
  -v /volume1/docker/homeassistant/config:/config \
  -v /run/dbus:/run/dbus:ro \
  --network=host \
  docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
```

| 参数 | 说明 |
|------|------|
| `--network=host` | **必须**。HA 监听宿主机 8123，mDNS 设备发现依赖 host 网络 |
| `--privileged` | 设备发现、部分硬件集成需要；群晖上同样必填 |
| `-e TZ=Asia/Shanghai` | 时区，国内建议上海 |
| `-v ...:/config` | 持久化配置与数据库（路径见第四节） |
| `-v /run/dbus:/run/dbus:ro` | 蓝牙集成可选；无蓝牙可省略 |
| `--restart=unless-stopped` | 系统 / 群晖重启后自动恢复 |

若有 Zigbee / Z-Wave USB 棒，追加设备映射（先用 `lsusb` 确认）：

```bash
--device /dev/ttyUSB0:/dev/ttyUSB0
```

群晖 USB 设备路径可能为 `/dev/ttyUSB0` 或 `/dev/ttyACM0`，以 `ls -l /dev/serial/by-id/` 为准。

---

## 六、验证启动与防火墙

### 6.1 确认容器运行

```bash
docker ps -a | grep homeassistant
```

正常时状态为 `Up`：

```text
9fae6b9a3846   docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1   "/init"   ...   Up ...   homeassistant
```

### 6.2 查看日志

```bash
docker logs -f homeassistant
```

首次启动 s6 初始化后，日志可能出现 Python SyntaxWarning，**可忽略**。首次完整启动通常需 **2～20 分钟**。

### 6.3 确认 8123 端口监听

```bash
ss -tlnp | grep 8123
```

有输出表示 HA 核心已启动：

```text
LISTEN 0      128          0.0.0.0:8123       0.0.0.0:*    users:(("python3",pid=3555006,fd=9))
LISTEN 0      128             [::]:8123          [::]:*    users:(("python3",pid=3555006,fd=11))
```

### 6.4 本机 curl 测试

```bash
curl -I http://127.0.0.1:8123
```

返回 `HTTP/1.1 405 Method Not Allowed` 表示 **服务已响应**（`curl -I` 发送 HEAD 请求，HA 仅允许 GET，属正常）。用 GET 验证：

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8123
```

返回 `200` 或 `302` 即 Web 正常。

### 6.5 Ubuntu：UFW 防火墙放行 8123（实测踩坑）

若本机 curl 正常、Windows 浏览器访问 `http://192.168.1.18:8123` 出现 **ERR_CONNECTION_TIMED_OUT**，检查 UFW：

```bash
ufw status
```

本文实测 UFW 为 `active`，放行列表中 **无 8123**，导致局域网无法访问。执行：

```bash
ufw allow 8123/tcp
```

若使用 **宝塔面板**：安全 → 额外放行 **8123** 端口。

确认服务器 IP：

```bash
ip addr | grep 192.168.1
```

本文输出：`inet 192.168.1.18/24 ... enp0s25`

### 6.6 群晖：DSM 防火墙放行 8123

群晖无 UFW，若浏览器访问 `http://群晖IP:8123` 超时，检查 **控制面板 → 安全性 → 防火墙**：

1. 确认防火墙已启用时，新增规则允许 **TCP 8123** 端口入站
2. 或在同一局域网内测试时，临时关闭防火墙验证是否为拦截原因

SSH 本机测试（与 Ubuntu 相同）：

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8123
```

返回 `200` 或 `302` 表示 HA 已就绪，此时若外网/其他设备仍无法访问，优先排查 DSM 防火墙规则。

---

## 七、Docker Compose 方案（可选）

验证 `docker run` 正常后，可改用 Compose 便于后续维护。

### 7.1 Ubuntu

在 `/www/wwwroot/homeassistant/docker-compose.yml`：

```yaml
services:
  homeassistant:
    container_name: homeassistant
    image: docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
    volumes:
      - /www/wwwroot/homeassistant/config:/config
      - /etc/localtime:/etc/localtime:ro
      - /run/dbus:/run/dbus:ro
    restart: unless-stopped
    privileged: true
    network_mode: host
    environment:
      TZ: Asia/Shanghai
```

迁移步骤：

```bash
docker stop homeassistant
docker rm homeassistant
cd /www/wwwroot/homeassistant
docker compose up -d
```

### 7.2 群晖 Container Manager 图形界面（可选）

若偏好 DSM 可视化管理，可用 **Container Manager → 项目** 创建 Compose 项目，路径建议：`/volume1/docker/homeassistant-project`。

`docker-compose.yml`：

```yaml
services:
  homeassistant:
    container_name: homeassistant
    image: docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
    volumes:
      - /volume1/docker/homeassistant/config:/config
      - /etc/localtime:/etc/localtime:ro
      - /run/dbus:/run/dbus:ro
    restart: unless-stopped
    privileged: true
    network_mode: host
    environment:
      TZ: Asia/Shanghai
```

> **注意**：
> - 若已用 SSH `docker run` 创建同名容器，需先 `docker stop homeassistant && docker rm homeassistant`，避免容器名冲突。
> - Compose 中 **`network_mode: host`** 与 **`privileged: true`** 不可省略；图形界面创建项目时务必核对这两项。
> - 仍建议首次部署用 **第五节 SSH `docker run`** 验证通过后再迁移 Compose，排错更直观。

群晖上 Compose 启动后，在 **Container Manager → 容器** 中可看到 `homeassistant` 状态为运行中，Web 访问方式与 Ubuntu **完全相同**：`http://群晖IP:8123`。

---

## 八、Web 初始化向导

浏览器访问（**Ubuntu 与群晖格式相同**，将 IP 换为你的设备地址）：

```text
http://192.168.1.18:8123        # Ubuntu 实测
http://你的群晖IP:8123           # 群晖 NAS
```

> **说明**：无论部署在 Ubuntu 还是群晖，**Web 界面、初始化向导、设备集成步骤完全一致**。下文截图基于 Ubuntu 实测，群晖用户跟做即可。

### 8.1 欢迎页

首次进入显示欢迎界面，点击 **「创建我的智能家居」** 开始全新配置（亦可上传备份还原）：

![Home Assistant 欢迎页：创建我的智能家居、上传备份、Home Assistant Cloud 还原选项](https://img.xuanyuan.dev/docker/blog/homeassistant-1.png)

*图 1：欢迎页；左下角语言已切换为简体中文*

### 8.2 创建用户

填写姓名、用户名、密码，点击 **「创建账户」**：

![创建用户：填写姓名、用户名、密码与确认密码](https://img.xuanyuan.dev/docker/blog/homeassistant-2.png)

*图 2：创建首个管理员账户（本文用户 Sean Chang）*

> **安全提示**：请选择强密码并妥善保存，该账户拥有 Home Assistant 全部管理权限。

### 8.3 设置家的位置

搜索并选择家庭所在城市（本文选择 **杭州市**），地图会定位到对应坐标——影响日出日落、天气等集成：

![家的位置：搜索杭州并在地图上确认坐标](https://img.xuanyuan.dev/docker/blog/homeassistant-3.png)

*图 3：设置家庭地理位置*

### 8.4 分析与隐私

Home Assistant 询问是否分享匿名使用数据，可按需开关各项，点击 **「下一步」**：

![帮助我们帮助你：基础分析、使用情况、统计数据、诊断信息开关](https://img.xuanyuan.dev/docker/blog/homeassistant-4.png)

*图 4：分析与隐私设置（可全部关闭）*

### 8.5 自动发现设备

向导扫描局域网，本文自动发现 **Internet Printing Protocol (IPP)** 打印机集成，点击 **「完成」**：

![我们发现了兼容的设备：Internet Printing Protocol IPP 集成](https://img.xuanyuan.dev/docker/blog/homeassistant-5.png)

*图 5：局域网设备自动发现*

---

## 九、主界面功能概览

初始化完成后进入 Home Assistant 主界面。左侧为导航栏，右侧为各功能模块。

### 9.1 概览仪表盘

默认 **概览** 页显示欢迎语、区域卡片（客厅 / 厨房 / 卧室 / 设备）与右侧摘要（已发现设备、天气）：

![概览仪表盘：欢迎 Sean Chang、区域卡片、天气 33.5°C 阴](https://img.xuanyuan.dev/docker/blog/homeassistant-6.png)

*图 6：概览页；右侧显示 1 个设备可添加、杭州天气*

### 9.2 地图

**地图** 页在 OpenStreetMap 上显示家庭位置标记（杭州市）：

![地图页：杭州市位置标记与 OpenStreetMap 底图](https://img.xuanyuan.dev/docker/blog/homeassistant-7.png)

*图 7：地图模块*

### 9.3 能源

**能源** 模块引导配置电网、太阳能等能源监控（6 步向导，可按需跳过）：

![能源配置向导第 1 步：电力公司与电网连接](https://img.xuanyuan.dev/docker/blog/homeassistant-8.png)

*图 8：能源模块初始化（第 1 步，共 6 步）*

### 9.4 活动（日志）

**活动** 页记录系统事件。本文可见 `Home Assistant started` 及 Sun 实体日出日落变更：

![活动日志：Home Assistant started、Sun 白天/夜间切换事件](https://img.xuanyuan.dev/docker/blog/homeassistant-9.png)

*图 9：活动日志；启动时间 13:51:49 与容器日志一致*

### 9.5 媒体

**媒体** 页提供 AI 生成图片、摄像头、Radio Browser、文字转语音等媒体源：

![媒体源：AI 图片、Camera、Radio Browser、Text-to-speech 等](https://img.xuanyuan.dev/docker/blog/homeassistant-10.png)

*图 10：媒体浏览器*

### 9.6 待办事项清单

内置 **购物清单** 待办列表，可新建其他清单：

![待办事项清单：购物清单为空，可添加项目](https://img.xuanyuan.dev/docker/blog/homeassistant-11.png)

*图 11：待办事项 / 购物清单*

### 9.7 设置

**设置** 页集中管理集成、自动化、区域、人员、系统备份与重启：

![设置页：Home Assistant Cloud、设备与服务、自动化与场景、系统等](https://img.xuanyuan.dev/docker/blog/homeassistant-12.png)

*图 12：设置主页*

---

## 十、添加首个设备：HP Smart Tank 打印机

Home Assistant 在局域网自动发现了 **HP Smart Tank 210-220 series** 网络打印机（与 [CUPS 部署教程](https://xuanyuan.cloud/blog/cups-docker-deploy) 中同一台设备）。以下演示从发现到集成的完整流程。

### 10.1 发现设备弹窗

概览页弹出 **「您想要添加什么？」**，已发现列表中显示 HP Smart Tank：

![您想要添加什么：已发现 HP Smart Tank 210-220 series IPP 打印机](https://img.xuanyuan.dev/docker/blog/homeassistant-13.png)

*图 13：概览页设备发现弹窗*

### 10.2 确认添加打印机

点击 HP Smart Tank 条目，确认 **「您想设置 HP Smart Tank 210-220 series [DAD28A] 吗？」**，点击 **「提交」**：

![已发现的打印机：确认设置 HP Smart Tank 210-220 series](https://img.xuanyuan.dev/docker/blog/homeassistant-14.png)

*图 14：确认添加打印机*

### 10.3 命名与分配区域

为设备命名（默认 **HP Smart Tank 210-220 series**），分配到 **客厅** 区域，点击 **「完成」**：

![命名和分配：设备名称与区域选择客厅](https://img.xuanyuan.dev/docker/blog/homeassistant-15.png)

*图 15：命名设备并分配区域*

### 10.4 客厅仪表盘

集成成功后，**客厅** 区域卡片显示打印机状态：四色墨盒余量 **100%**，打印机状态 **空闲**：

![客厅区域：HP Smart Tank 墨盒余量与空闲状态](https://img.xuanyuan.dev/docker/blog/homeassistant-16.png)

*图 16：打印机集成后的客厅仪表盘*

### 10.5 设备详情

进入设备页查看制造商 HP、固件版本、序列号及 IPP 集成信息；传感器显示墨盒余量与状态：

![设备信息：HP Smart Tank 固件、序列号、IPP 集成与传感器](https://img.xuanyuan.dev/docker/blog/homeassistant-17.png)

*图 17：HP Smart Tank 设备详情与传感器*

### 10.6 创建自动化（可选）

设备页可将打印机作为触发器 / 条件 / 动作，快速创建自动化或脚本：

![添加 HP Smart Tank 至自动化或脚本：创建触发器、条件、动作](https://img.xuanyuan.dev/docker/blog/homeassistant-18.png)

*图 18：基于打印机创建自动化或脚本*

---

## 十一、可选扩展

### 11.1 USB Zigbee / Z-Wave 棒

Container 模式无 Add-on，但可通过 `--device` 映射 USB 控制器：

```bash
# docker run 追加
--device /dev/ttyUSB0:/dev/ttyUSB0
```

Compose 等效：

```yaml
devices:
  - /dev/ttyUSB0:/dev/ttyUSB0
```

### 11.2 蓝牙集成

需挂载 D-Bus（本文 docker run 已包含）：

```bash
-v /run/dbus:/run/dbus:ro
```

### 11.3 ARM 设备 jemalloc 报错

部分 ARM64 硬件（页大小 > 4K）可能出现 `Unsupported system page size`，追加环境变量：

```bash
-e DISABLE_JEMALLOC=true
```

---

## 十二、生产环境建议

### 12.1 固定镜像 digest

```bash
docker pull docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
docker inspect docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1 --format='{{index .RepoDigests 0}}'
```

本文拉取 digest：`sha256:f73512ba4fe06bb4d57636fe3578d0820cdec46f81e8f837ab59e451662ff3cb`

### 12.2 备份 /config

Ubuntu：

```bash
tar -czf homeassistant-config-backup-$(date +%Y%m%d).tar.gz -C /www/wwwroot/homeassistant config
```

群晖：

```bash
tar -czf /volume1/docker/homeassistant-config-backup-$(date +%Y%m%d).tar.gz -C /volume1/docker/homeassistant config
```

也可在 **设置 → 系统 → 备份** 中创建完整备份（Ubuntu / 群晖 Web 界面相同）。

### 12.3 更新镜像

```bash
docker pull docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1
cd /www/wwwroot/homeassistant
docker compose down    # 或 docker stop homeassistant && docker rm homeassistant
docker compose up -d   # 或重新 docker run
```

### 12.4 Nginx 反向代理（示例）

若需通过域名 + HTTPS 访问（生产建议配合 Authentik 或 HA 信任代理配置）：

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

        # WebSocket 支持
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

需在 Home Assistant `configuration.yaml` 中配置 `http:` 信任代理，详见 [官方反向代理文档](https://www.home-assistant.io/integrations/http/#reverse-proxies)。

---

## 十三、常见问题 FAQ

**Q1：浏览器访问 8123 超时，但 `curl 127.0.0.1:8123` 正常？**

- **Ubuntu**：UFW 或宝塔未放行 **8123**。执行 `ufw allow 8123/tcp`，宝塔安全面板同步放行。本文实测即为此场景。
- **群晖**：检查 **控制面板 → 安全性 → 防火墙**，新增允许 **TCP 8123** 入站规则。

**Q2：群晖能用 Container Manager 图形界面部署吗？**

可以，但 **更推荐 SSH + docker run**（见第五节 5.2）。HA 必须 `network_mode: host` + `privileged: true`，图形界面容易漏配；命令与 Ubuntu 仅路径不同。部署完成后访问 `http://群晖IP:8123`，Web 初始化与 Ubuntu **完全相同**。

**Q3：能否用 `-p 8123:8123` 代替 host 网络？**

**不建议**。官方要求 Container 使用 host 网络，否则 mDNS 发现、部分集成（如 Cast、Sonos）可能异常。

**Q4：首次启动多久能访问？**

通常 **2～20 分钟**。用 `ss -tlnp | grep 8123` 确认端口监听后再访问浏览器。

**Q5：`curl -I` 返回 405 是报错吗？**

不是。HA 对 HEAD 请求返回 405，表示服务已运行。浏览器 GET 请求正常。

**Q6：Container 与 HA OS 怎么选？**

已有 Linux + Docker、熟悉命令行 → Container（本文）。想要 Add-on 商店、一键更新、Thread/Z-Wave 官方 Add-on → 选 [HA OS](https://www.home-assistant.io/installation/) 或 Green/Yellow 硬件。

**Q7：日志里 SyntaxWarning 需要处理吗？**

本文出现的 `py.warnings ... SyntaxWarning: 'return' in a 'finally' block` 来自依赖库，**可忽略**，不影响运行。

**Q8：如何重启 Home Assistant？**

```bash
docker restart homeassistant
# 或 Compose
docker compose restart
```

也可在 **设置 → 系统** 中点击重启。

**Q9：8123 端口被占用怎么办？**

```bash
ss -tlnp | grep 8123
```

确认无其他进程占用。Home Assistant 仅支持改 `configuration.yaml` 中 `http:` 端口，但 host 网络下改端口后访问地址也需同步变更。

**Q10：如何远程访问？**

生产环境建议 Nginx 反向代理 + HTTPS + 强认证，或使用 [Home Assistant Cloud](https://www.nabucasa.com/)（Nabu Casa）安全隧道。**勿将 8123 裸暴露到公网**。

**Q11：配置存在哪里？**

- **Ubuntu**：`/www/wwwroot/homeassistant/config`
- **群晖**：`/volume1/docker/homeassistant/config`

删除容器不丢数据，重建时挂载同目录即可恢复。

**Q12：群晖上需要像 MT Photos 那样设置 PUID/PGID 吗？**

**不需要**。Home Assistant 容器以 root 在 `/config` 内写数据，群晖上直接挂载 `/volume1/docker/homeassistant/config` 即可，无 MT Photos 的 PostgreSQL 权限踩坑。

**Q13：`stable`、`latest`、`beta`、`rc` 和 `2026.7.1` 怎么选？**

- **生产 / 长期运行**：用 **`2026.7.1` 等具体版本号**（本文推荐），升级时改版本号并备份 `/config`
- **想始终跟稳定版**：用 `stable` 或 `latest`，每次 `docker pull` 可能跨版本，升级前务必备份
- **尝鲜测试**：`beta` / `rc`，**不要**用于生产

完整标签与拉取命令见 [轩辕镜像标签列表](https://xuanyuan.cloud/r/homeassistant/home-assistant/tags) 及本文第二节。

---

## 十四、命令速查

| 操作 | Ubuntu | 群晖 NAS |
|------|--------|----------|
| 拉取镜像 | `docker pull docker.xuanyuan.run/homeassistant/home-assistant:2026.7.1` | 同左 |
| 创建目录 | `mkdir -p /www/wwwroot/homeassistant/config` | `mkdir -p /volume1/docker/homeassistant/config` |
| 启动容器 | 见 **5.1**（`/www/wwwroot/...` 挂载） | 见 **5.2**（`/volume1/docker/...` 挂载） |
| 查看日志 | `docker logs -f homeassistant` | 同左 |
| 本机测试 | `curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8123` | 同左 |
| 防火墙 | `ufw allow 8123/tcp` | 控制面板 → 安全性 → 防火墙 → 允许 8123 |
| Web 访问 | `http://服务器IP:8123` | `http://群晖IP:8123`（**界面相同**） |
| 停止服务 | `docker stop homeassistant && docker rm homeassistant` | 同左 |

---

## 总结

本文完成了 Home Assistant **2026.7.1 单容器 Container 私有化部署**（**Ubuntu 24.04 实测 + 群晖 NAS SSH 部署说明**）：

- 使用轩辕镜像加速拉取 [homeassistant/home-assistant:2026.7.1](https://xuanyuan.cloud/zh/r/homeassistant/home-assistant)
- **Ubuntu / 群晖均推荐 SSH + `docker run`**，host 网络 + privileged，`/config` 持久化
- Ubuntu 工作目录 `/www/wwwroot/homeassistant`；群晖 `/volume1/docker/homeassistant`
- **UFW / 群晖 DSM 防火墙 8123 未放行** 导致局域网超时，放行后恢复正常
- Web 初始化向导 5 步跟做：**Ubuntu 与群晖访问 `:8123` 后步骤完全相同**
- 自动发现并集成局域网 **HP Smart Tank 210-220** 打印机（18 张配图）

**延伸阅读：**

- [Home Assistant 轩辕镜像页](https://xuanyuan.cloud/zh/r/homeassistant/home-assistant)
- [Home Assistant 镜像标签列表](https://xuanyuan.cloud/r/homeassistant/home-assistant/tags)
- [Home Assistant 官方安装指南](https://www.home-assistant.io/installation/)
- [Linux Container 安装文档](https://www.home-assistant.io/installation/linux#install-home-assistant-container)
- [CUPS Docker 部署教程（同一台 HP 打印机）](https://xuanyuan.cloud/blog/cups-docker-deploy)
- [群晖 NAS Docker 镜像源配置](https://xuanyuan.cloud/usage/synology)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)
- [轩辕镜像 AI 规范 agents.md](https://xuanyuan.cloud/agents.md)


