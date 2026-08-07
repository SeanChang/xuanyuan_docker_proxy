# Docker 部署 EMQX：轻松搭建物联网 MQTT 消息平台

![Docker 部署 EMQX：轻松搭建物联网 MQTT 消息平台](https://img.xuanyuan.dev/docker/blog/emqx.webp)

*分类: Docker部署教程 | 标签: EMQX,MQTT,Docker,轩辕镜像,IoT,消息代理,私有化部署,部署教程 | 发布时间: 2026-07-30 07:12:52*

> 公有云物联网平台 / 托管 MQTT 能少运维，但按连接数与消息量计费、设备数据落在厂商侧、合规要求「数据不出域」、或机房完全断公网时，就需要一台自己可控的 MQTT Broker（消息代理）——设备连你的服务器，消息在你的机器上转发，管理界面也跑在你浏览器里打开的内网地址上。

*本文基于 [emqx/emqx:6.2.2](https://xuanyuan.cloud/zh/r/emqx/emqx)，**Ubuntu 24.04** 实测。

传感器上报温湿度、门锁推送开合状态、车机回传轨迹、工厂 PLC 周期性吐点位……这些「设备侧」消息有几个共同点：连接数可以很大、单条载荷往往很小、网络不稳定时还得靠 QoS 重试、业务方要的是**按主题路由**而不是每人自建一套长连接。协议选型里 **MQTT** 几乎是默认答案：发布 / 订阅、可保留消息、适合弱网与海量终端。

公有云物联网平台 / 托管 MQTT 能少运维，但按连接数与消息量计费、设备数据落在厂商侧、合规要求「数据不出域」、或机房完全断公网时，就需要一台**自己可控的 MQTT Broker（消息代理）**——设备连你的服务器，消息在你的机器上转发，管理界面也跑在你浏览器里打开的内网地址上。

手工编译、配 Erlang、调系统参数，对多数人成本偏高。官方 Docker 镜像把 **Broker + Dashboard（Web 管理控制台）** 打成一条命令：拉起来后，设备连 `1883` 发主题消息，运维打开 `18083` 看连接、订阅与流量——**EMQX 本身不是业务 App**，而是站在设备与后端中间的「邮局」。

**EMQX**（[GitHub: emqx/emqx](https://github.com/emqx/emqx)，约 1.6 万 Star）是面向 AI、物联网（IoT）、工业物联网（IIoT）、车联网等场景的高可扩展 **MQTT 消息平台**。它负责：

- 接受海量 MQTT 客户端连接（手机 App、网关、传感器固件、后端服务均可）
- 按 **主题（topic）** 把发布端的消息路由给订阅端（例如 `sensors/room1/temp` → 所有订阅了该主题或 `sensors/#` 的客户端）
- 提供认证、ACL、会话、保留消息、规则引擎与数据集成（可转到 Kafka、数据库、Webhook 等）
- 提供 **Dashboard**：用浏览器完成概览监控、踢客户端、看订阅、配规则，而不必只会敲 CLI

协议上完整支持 **MQTT 5.0 / 3.1.1 / 3.1**，并可选 MQTT over QUIC、WebSocket，以及通过网关扩展 CoAP / LwM2M 等。自 **v5.9.0** 起，原开源版与企业版能力统一到同一 Docker 镜像，采用 **BSL 1.1**：**单节点**（含开发 / 测试，以及符合条款的单节点生产）一般可用社区版许可证；**集群（≥2 节点）**、把 EMQX 当商业托管转售、或嵌入商业产品分发等场景需商业许可证。镜像启动日志可能显示 *EMQX Enterprise*，Dashboard 也会标 Enterprise / 社区版许可证——这是统一镜像的品牌呈现，**不等于**你已经买了多节点商业授权。

上手要点：坐标用 **`emqx/emqx`**（旧官方库 `library/emqx` 已弃用）。常用端口 **1883**（MQTT TCP）、**8083**（WebSocket）、**8883**（MQTTS，需证书）、**18083**（Dashboard）。首次登录 **`admin` / `public`**，会强制改密。长期运行请挂载 `/opt/emqx/data` 并固定节点名（见后文 Compose）；本文快速体验用 `docker run`，数据在容器层，删容器即丢。

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`emqx/emqx:6.2.2`**，`docker run` 启动，浏览器登录 Dashboard，再用 Mosquitto 客户端验证 `demo/hello` 收发，并对照界面学会看客户端与订阅。另附持久化 Compose、集群许可证说明与 FAQ。

镜像说明见 [emqx/emqx 镜像页](https://xuanyuan.cloud/zh/r/emqx/emqx)，标签列表见 [tags](https://xuanyuan.cloud/r/emqx/emqx/tags)。官方文档：[docs.emqx.com](https://docs.emqx.com/)。

---

## 一、EMQX 是什么？

一句话：**EMQX = 可自托管的 MQTT 消息代理 + Web 控制台**。设备或程序以「客户端」身份连上它，按主题发布或订阅；EMQX 在中间转发，并让你用浏览器看见谁连着、订了什么、流量多大。

### 1.1 和「自己写个 WebSocket 服务」差在哪？

| 自己搭临时通道 | EMQX |
|----------------|------|
| 每加一类设备就要改连接与路由代码 | 主题树天然解耦：发布端与订阅端互不感知 |
| 断线重连、QoS、会话要自己搓 | MQTT 协议与 Broker 已实现 |
| 难水平扩展到成千上万连接 | 面向海量连接与高吞吐设计 |
| 排障靠日志 | Dashboard 可看客户端、订阅、指标 |

### 1.2 核心能力

| 能力 | 说明 |
|------|------|
| MQTT Broker | 连接管理、主题路由、QoS、保留消息、共享订阅等 |
| Dashboard | 集群概览、客户端列表、订阅、规则与集成、访问控制 |
| 规则引擎 / 集成 | SQL 处理流转数据，对接 Kafka、DB、云服务、Webhook |
| 安全 | TLS / WSS、用户名密码 / JWT / 证书等认证，ACL 授权 |
| 协议扩展 | MQTT over QUIC、WebSocket；网关侧其他 IoT 协议 |
| 自托管 | 官方镜像即可单节点跑通；数据可落本地卷 |

### 1.3 典型场景

- 智能家居 / 工业现场：设备遥测上报、云端或本地指令下发
- 车联网、智慧城市：位置、告警、状态实时汇聚
- 边缘与中心之间的 MQTT 通道（再经规则引擎进 Kafka / 数仓）
- 内网合规：消息与连接元数据不出自己的机房

与 **Apache Kafka** 的区别：Kafka 偏**可回放的事件流存储**；**EMQX 偏设备侧 MQTT 接入与实时路由**。生产里常「设备 → EMQX →（规则）→ Kafka」，本文只部署 EMQX 单节点。

架构（本文 `docker run` 快速体验）：

```text
设备 / mosquitto_pub|sub ──MQTT:1883──▶ emqx 容器
浏览器                 ──HTTP:18083──▶ Dashboard
```

> **版本与许可证**：本文实测 **`emqx/emqx:6.2.2`**。单节点跟做即可；**≥2 节点集群在 v5.9.0+ 需商业许可证**。勿长期依赖裸 `latest`；勿把 1883 / 18083 无防护裸奔公网。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux 建议 **Ubuntu 24.04**（本文实测） |
| Docker | Engine（Compose V2 用于后文持久化方案） |
| 内存 | 演示建议 ≥ **1 GB** 可用；生产按连接数加码 |
| 磁盘 | 镜像约 **464MB**（本地 `docker images` 显示）+ 数据增长 |
| 端口 | 至少 **1883**、**18083**；本文一并映射 8083 / 8084 / 8883 |
| 目录 | `/www/wwwroot/emqx` |

```bash
docker --version
docker compose version
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)

# 备用地址
bash <(wget -qO- https://get.xuanyuan.dev/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 三、标签怎么选

| 标签 | 说明 | 推荐 |
|------|------|------|
| **`6.2.2`** | 6.x 固定补丁版（本文实测） | **试用 / 生产钉死版本首选** |
| `6.2` / `6` | 滚动到该大/小版本最新补丁 | 仅接受自动跟补丁时使用 |
| `5.10.4` / `5.9.3` | 仍在维护的 5.x 线 | 业务锁定 5.x 时选用 |
| `latest` | 跟踪最新稳定 | 仅临时试用 |
| `*-rc*` / `*-beta*` | 预发布 | **勿上生产** |
| `*-elixir` | Elixir 变体 | 一般跟做用默认即可 |

标签列表：[xuanyuan.cloud/r/emqx/emqx/tags](https://xuanyuan.cloud/r/emqx/emqx/tags)。

> 请统一使用 **`emqx/emqx`**；勿再跟已停更的官方库短名 `emqx`（`library/emqx`）。

---

## 四、拉取镜像（轩辕镜像加速）

```bash
sudo mkdir -p /www/wwwroot/emqx/{data,log}
cd /www/wwwroot/emqx

docker pull docker.xuanyuan.run/emqx/emqx:6.2.2
```

实测拉取输出（**Ubuntu 24.04**）：

```text
6.2.2: Pulling from emqx/emqx
4f4fb700ef54: Pull complete
aaf5045899f1: Pull complete
5084ba2a413e: Pull complete
ecddb4ca0c0c: Pull complete
f37017262c9e: Pull complete
ddbd4e187fd4: Pull complete
a448ba66fc47: Pull complete
Digest: sha256:0ba29902a8e552f7152754860b4b61b49a7e16fa376035bcf10021e944b2c0a0
Status: Downloaded newer image for docker.xuanyuan.run/emqx/emqx:6.2.2
docker.xuanyuan.run/emqx/emqx:6.2.2
```

确认本地镜像：

```bash
docker images
```

实测可见类似：

```text
IMAGE                                 ID             DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/emqx/emqx:6.2.2   0ba29902a8e5        464MB          150MB
```

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `emqx/emqx:6.2.2` | `docker pull docker.xuanyuan.run/emqx/emqx:6.2.2` |

---

## 五、快速体验：单容器 `docker run`

适合先验证「能起来、能打开 Dashboard、能收发 MQTT」。数据落在容器可写层，**删容器即丢**；要长期用请看第九节 Compose。

```bash
docker run -d --name emqx \
  --restart unless-stopped \
  -p 1883:1883 \
  -p 8083:8083 \
  -p 8084:8084 \
  -p 8883:8883 \
  -p 18083:18083 \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/emqx/emqx:6.2.2
```

实测返回容器 ID：

```text
9939fc58260cfe9620af27ce3ae5146defa203b32657e31151c6168738661fcd
```

| 端口 | 用途 |
|------|------|
| **1883** | MQTT TCP（最常用） |
| **8083** | MQTT over WebSocket |
| **8084** | MQTT over WSS（需证书） |
| **8883** | MQTT over SSL/TLS（需证书） |
| **18083** | Dashboard（HTTP） |

验证：

```bash
docker ps --filter name=emqx
docker logs emqx --tail 50
docker exec emqx emqx ctl status
```

实测 `docker ps`（端口已映射）：

```text
CONTAINER ID   IMAGE                                 STATUS         PORTS                                                                 NAMES
9939fc58260c   docker.xuanyuan.run/emqx/emqx:6.2.2   Up …           0.0.0.0:1883->1883/tcp, …, 0.0.0.0:18083->18083/tcp, …               emqx
```

实测日志关键行：

```text
Starting EMQX Enterprise 6.2.2
WARNING: Default (insecure) Erlang cookie is in use.
WARNING: Configure node.cookie in /opt/emqx/etc/emqx.conf or override from environment variable EMQX_NODE__COOKIE
EMQX_NODE__NAME [node.name]: emqx@172.17.0.2
```

实测状态：

```text
Node 'emqx@172.17.0.2' 6.2.2 is started
```

> **说明**：`WARNING: Default (insecure) Erlang cookie` 在**单节点试用**可暂时忽略；若以后做集群，须为所有节点配置**相同且非默认**的 cookie（如环境变量 `EMQX_NODE__COOKIE`）。未固定 `EMQX_HOST` 时，节点名会带上 Docker 网桥 IP（此处为 `emqx@172.17.0.2`），与 Dashboard「节点信息」一致。

浏览器访问（把 IP 换成你的服务器）：

```text
http://192.168.1.10:18083
```

本机可用 `http://127.0.0.1:18083`。

---

## 六、浏览器：登录、改密与许可证提示

### 6.1 登录页

打开 Dashboard 后进入登录页（标题为「登录 - EMQX Enterprise」）。左侧示意 MQTT / WebSocket / TLS / QUIC 等能力；右侧填写账号。

**默认用户名**：`admin`  
**默认密码**：`public`

![EMQX Dashboard 登录页：用户名填 admin，点击登录](https://img.xuanyuan.dev/docker/blog/emqx-1.webp)

输入后点「登录」。若打不开页面，先确认 `docker ps` 中 18083 已映射、防火墙已放行。

### 6.2 强制修改默认密码

首次用默认口令登录后，系统会进入「修改密码」页，要求换掉不安全的默认密码：

- 长度 **8～64** 字符
- 至少包含字母、数字、符号中的**两种**

建议直接设强密码并点「确定」。演示环境可点「跳过」，但**生产务必改密**。

![EMQX 首次登录强制修改默认密码：长度与复杂度要求](https://img.xuanyuan.dev/docker/blog/emqx-2.webp)

忘记密码时可在容器内重置：

```bash
docker exec emqx emqx ctl admins passwd admin 'NewPass'
```

### 6.3 社区版许可证说明（单节点）

进入控制台后，常会弹出许可证说明：当前为 **EMQX 社区版许可证（单节点）**。弹窗会概括：非生产活动、符合条款的单节点生产等可免费使用；**集群（≥2 节点）**、商业托管转售、嵌入商业产品等需商业许可证。可勾选「不再提示」，再点「知道了」进入概览。

![EMQX 社区版单节点许可证提示：知道了后进入集群概览](https://img.xuanyuan.dev/docker/blog/emqx-3.webp)

这与本文「单节点跟做、集群需许可证」一致，不必紧张——**单节点 Docker 试用不需要先去申请商业 License**。

---

## 七、主界面：集群概览怎么看

关闭提示后，默认落在 **集群概览 / 概览**。学会读这几块，就知道 Broker「活着没有、有没有人连」：

| 区域 | 看什么 |
|------|--------|
| 消息流入 / 流出速率 | 当前 msg/s；刚启动且无客户端时多为 `0` |
| 总会话 / 在线会话 / 主题 / 订阅 | 有客户端订阅后会上升（实测订阅后可见会话、主题、订阅为 1） |
| 节点图「emqxcl - 1 节点」 | 确认是单节点 |
| 节点信息 | **节点名称**（如 `emqx@172.17.0.2`）、角色 core、版本 **6.2.2 (Enterprise)**、连接数等 |

![EMQX 集群概览：单节点 6.2.2，节点名 emqx@172.17.0.2，已有 1 个在线会话](https://img.xuanyuan.dev/docker/blog/emqx-4.webp)

左侧图标栏可进入监控、客户端、订阅、集成、访问控制、工具等——后文 MQTT 验证后，重点用「客户端」核对连接。

---

## 八、怎么用：MQTT 收发 + Dashboard 对照

目标：用官方常用的 Mosquitto 命令行客户端，向主题 `demo/hello` 发一条 `world`，订阅端收到；同时在 Dashboard 里学会**查客户端、看订阅、看指标**。

### 8.1 拉取 Mosquitto 客户端镜像

```bash
docker pull docker.xuanyuan.run/library/eclipse-mosquitto:2
```

实测 Digest：

```text
Digest: sha256:6f8d8a947c506f8a2290ec65cd4bd2bc7cb4d43fb5f6271f861cb013e2ef9797
Status: Downloaded newer image for docker.xuanyuan.run/library/eclipse-mosquitto:2
```

### 8.2 先订阅（终端 A，保持运行）

```bash
docker run --rm -it --network host \
  docker.xuanyuan.run/library/eclipse-mosquitto:2 \
  mosquitto_sub -h 127.0.0.1 -p 1883 -t 'demo/#' -v
```

`demo/#` 表示订阅所有以 `demo/` 开头的多级主题。`--network host` 让客户端容器直接访问宿主机已映射的 1883。

### 8.3 再发布（终端 B）

```bash
docker run --rm --network host \
  docker.xuanyuan.run/library/eclipse-mosquitto:2 \
  mosquitto_pub -h 127.0.0.1 -p 1883 -t 'demo/hello' -m 'world'
```

订阅端（终端 A）实测应打印：

```text
demo/hello world
```

说明：**Broker 已正确完成发布 / 订阅路由**。本机若已安装 `mosquitto-clients`，也可直接用 `mosquitto_sub` / `mosquitto_pub`，参数相同。

### 8.4 在 Dashboard 看「客户端」列表

浏览器打开左侧 **客户端**（或监控相关入口下的客户端列表）。有订阅进程连着时，应出现一条 **已连接** 记录：随机 Client ID、来源 IP（Docker 场景常见为网桥网关如 `172.17.0.1`）、心跳 60 等。可按客户端 ID / 用户名 / IP 筛选，也可导出。

![EMQX 客户端列表：已连接的 MQTT 客户端及 IP、心跳信息](https://img.xuanyuan.dev/docker/blog/emqx-5.webp)

**用途**：设备「连不上」时，先看这里有没有对应 Client ID；异常连接可在此排查或踢下线。

### 8.5 点进某个客户端：连接与会话

点击蓝色客户端 ID，进入详情 **「客户端信息」**：协议版本（如 MQTT v3.1.1）、所在节点、清除会话、订阅数、消息队列 / 飞行窗口等。

![EMQX 客户端详情：连接信息与会话信息（协议 MQTT v3.1.1）](https://img.xuanyuan.dev/docker/blog/emqx-6.webp)

**用途**：确认设备到底连到了哪台节点、会话是否 Clean Start、队列是否堆积（排障「收得到连得上但消息堵」时很有用）。

### 8.6 当前订阅：核对主题

同一详情页切到 **「当前订阅」**。若按上文用 `demo/#` 订阅，此处应看到主题 **`demo/#`**、QoS **0**。也可在此「添加订阅」或「取消订阅」（运维代操作客户端订阅时可用）。

![EMQX 当前订阅：主题 demo/#，QoS 0](https://img.xuanyuan.dev/docker/blog/emqx-7.webp)

**用途**：发布了消息但业务收不到时，先核对订阅主题是否写错、通配符是否匹配。

### 8.7 指标：流量与报文

再切到 **「指标」**：接收 / 发送字节、TCP / MQTT 报文数、按 QoS 统计的消息收发与丢弃原因等。做完一次 `pub` 后，通常能看到接收消息计数增加。

![EMQX 客户端指标：流量字节、报文与消息收发统计](https://img.xuanyuan.dev/docker/blog/emqx-8.webp)

**用途**：区分「完全没连上」和「连上了但 QoS / 队列导致丢消息」；对接真实设备前，用这一页确认联调流量符合预期。

### 8.8 环境变量配置速查

`etc/emqx.conf` 中的配置多可通过 **`EMQX_` 前缀**环境变量覆盖：去掉前缀、转小写、`_` 换成 `.`。例如把默认 MQTT TCP 监听改到 `1884`：

```bash
docker run -d --name emqx \
  -e EMQX_LISTENERS__TCP__DEFAULT__BIND=1884 \
  -p 1884:1884 -p 18083:18083 \
  docker.xuanyuan.run/emqx/emqx:6.2.2
```

更多见 [EMQX 配置文档](https://docs.emqx.com/)。

---

## 九、生产向：Docker Compose + 持久化

`docker run` 适合试用。要保留 Dashboard 改密后的账号、规则与运行数据，请挂载卷并**固定节点名**（数据路径含节点名；IP 一变容易「像新装」）。

### 9.1 `compose.yml`

```yaml
# /www/wwwroot/emqx/compose.yml
name: emqx

services:
  emqx:
    image: docker.xuanyuan.run/emqx/emqx:6.2.2
    container_name: emqx
    restart: unless-stopped
    ports:
      - "1883:1883"
      - "8083:8083"
      - "8084:8084"
      - "8883:8883"
      - "18083:18083"
    environment:
      TZ: Asia/Shanghai
      EMQX_NAME: emqx
      EMQX_HOST: 127.0.0.1
      # 可选：集群时再设非默认 cookie
      # EMQX_NODE__COOKIE: "change-me-to-a-long-secret"
      # 可选：仅首次初始化 Dashboard 密码
      # EMQX_DASHBOARD__DEFAULT_PASSWORD: "ChangeMe_Strong_Pass"
    volumes:
      - ./data:/opt/emqx/data
      - ./log:/opt/emqx/log
```

| 配置 | 说明 |
|------|------|
| `EMQX_NAME` / `EMQX_HOST` | 组成稳定节点名；**务必固定** |
| `./data` → `/opt/emqx/data` | 运行时数据（必挂） |
| `./log` → `/opt/emqx/log` | 日志（推荐） |

> 若绑定挂载后 Permission denied：`docker exec emqx id` 查看 uid，再 `chown` 宿主机目录（常见 `1000:1000`），或改用命名卷。

### 9.2 启动

若已有同名 `emqx` 容器，先停掉再切 Compose：

```bash
docker rm -f emqx
cd /www/wwwroot/emqx
docker compose up -d
docker exec emqx emqx ctl status
```

---

## 十、集群说明（本文不展开实操）

自 **v5.9.0** 起，**超过 1 个节点** 须加载许可证。单节点跟做不必准备。静态种子集群需配置发现策略、seeds 与稳定节点名；完整步骤见官方文档。**勿把未加固的多节点示例直接当生产。**

---

## 十一、常见问题 FAQ

**Q：Dashboard 打不开？**  
A：确认已映射 **18083**，防火墙已放行；`docker ps` 为 Up；`docker logs emqx` 无崩溃循环。

**Q：默认 `admin` / `public` 登不进去？**  
A：可能已改密或用环境变量初始化过。用 `emqx ctl admins passwd` 重置。

**Q：日志里有 Erlang cookie 警告？**  
A：单节点试用可暂忽略；集群必须配置统一的非默认 `EMQX_NODE__COOKIE`。

**Q：挂了卷，重建后像新装？**  
A：固定 `EMQX_NAME` 与 `EMQX_HOST`（或完整 `EMQX_NODE_NAME`）。见 [emqx#3427](https://github.com/emqx/emqx/issues/3427) 讨论背景。

**Q：订阅端收不到消息？**  
A：先开 `mosquitto_sub` 再 `pub`；在 Dashboard「当前订阅」确认主题（如 `demo/#`）匹配；检查是否连错主机/端口。

**Q：要不要拉 `library/emqx`？**  
A：勿用。请用 **`emqx/emqx:6.2.2`**。

**Q：界面写 Enterprise，要钱吗？**  
A：统一镜像的界面文案；单节点社区版许可证可按弹窗条款使用。集群等场景才需商业 License。

**Q：`docker pull` 报 401 / 402？**  
A：见 [轩辕 FAQ](https://xuanyuan.cloud/faq)。

**Q：1883 / 18083 被占用？**  
A：改映射左侧宿主机端口，客户端与浏览器同步改。

---

## 十二、命令速查

```bash
sudo mkdir -p /www/wwwroot/emqx/{data,log}
cd /www/wwwroot/emqx
docker pull docker.xuanyuan.run/emqx/emqx:6.2.2

docker run -d --name emqx --restart unless-stopped \
  -p 1883:1883 -p 8083:8083 -p 8084:8084 -p 8883:8883 -p 18083:18083 \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/emqx/emqx:6.2.2

docker ps --filter name=emqx
docker logs emqx --tail 50
docker exec emqx emqx ctl status

# MQTT 验证
docker pull docker.xuanyuan.run/library/eclipse-mosquitto:2
docker run --rm -it --network host docker.xuanyuan.run/library/eclipse-mosquitto:2 \
  mosquitto_sub -h 127.0.0.1 -p 1883 -t 'demo/#' -v
# 另一终端：
docker run --rm --network host docker.xuanyuan.run/library/eclipse-mosquitto:2 \
  mosquitto_pub -h 127.0.0.1 -p 1883 -t 'demo/hello' -m 'world'

docker exec emqx emqx ctl admins passwd admin 'NewPass'
```

---

## 十三、延伸阅读

- 轩辕镜像页：[emqx/emqx](https://xuanyuan.cloud/zh/r/emqx/emqx)
- 标签列表：[emqx/emqx/tags](https://xuanyuan.cloud/r/emqx/emqx/tags)
- 项目仓库：[github.com/emqx/emqx](https://github.com/emqx/emqx)
- 官方文档：[docs.emqx.com](https://docs.emqx.com/)
- Dashboard 说明：[Dashboard Introduction](https://docs.emqx.com/en/emqx/latest/dashboard/introduction.html)
- Docker 持久化讨论背景：[emqx#3427](https://github.com/emqx/emqx/issues/3427)
- 轩辕镜像使用手册：[xuanyuan.cloud/usage](https://xuanyuan.cloud/usage)

---

## 总结

- 轩辕镜像加速拉取 **`emqx/emqx:6.2.2`**，`docker run` 映射 **1883 + 18083**，实测节点 `emqx@172.17.0.2` 已启动
- Dashboard：**`admin` / `public`** → 改密 → 阅读单节点社区版许可证提示 → 在概览 / 客户端 / 订阅 / 指标里监控
- 用 Mosquitto 对 `demo/#` 收发，订阅端应看到 `demo/hello world`
- 生产请上 Compose 挂卷并固定节点名；集群需许可证；勿裸奔公网


