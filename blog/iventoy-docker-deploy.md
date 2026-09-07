# Docker 部署 iVentoy：轻松搭建 PXE 网络装机平台

![Docker 部署 iVentoy：轻松搭建 PXE 网络装机平台](https://imgs.xuanyuan.cloud/docker/blog/iventoy.webp)

*分类: Docker部署教程 | 标签: iVentoy,Docker,轩辕镜像,PXE,网络装机,HTTPBoot,私有化部署,部署教程 | 发布时间: 2026-09-03 13:23:58*

> 机房里新到一批裸机：有人抱着一摞 U 盘逐台烧 Ubuntu，有人在 BIOS 里改启动项装到一半才发现 ISO 放错版本，有人半夜还在给 Windows 装机包拷盘。想「网线一插就能选系统」，常见做法是自建 DHCP + TFTP + HTTP，再手写菜单——规则散在 Wiki 和脚本里，换架构或加一张 ISO 就要重配一轮...

*本文基于 [szabis/iventoy:1.0.39](https://xuanyuan.cloud/zh/r/szabis/iventoy)，实测引擎 **iVentoy 1.0.39**（Free Edition · Linux x86_64），测试平台 **Ubuntu 24.04** Linux。*

机房里新到一批裸机：有人抱着一摞 U 盘逐台烧 Ubuntu，有人在 BIOS 里改启动项装到一半才发现 ISO 放错版本，有人半夜还在给 Windows 装机包拷盘。想「网线一插就能选系统」，常见做法是自建 DHCP + TFTP + HTTP，再手写菜单——规则散在 Wiki 和脚本里，换架构或加一张 ISO 就要重配一轮。

另一层更硬：**装机流量和 ISO 最好留在内网盘上**。公有云模板不适合专有云 / 等保机房；纯手工 PXE 又容易和现网 DHCP、67/69 端口打架。很多团队其实已经有一台跑 Docker 的 Ubuntu，缺的只是镜像能拉、**26000** 能开、ISO 落在挂载目录。

**iVentoy**（[中文官网](https://www.iventoy.com/cn/index.html)、[GitHub · ventoy/PXE](https://github.com/ventoy/PXE)）是增强版 **PXE / HTTPBoot** 服务器：ISO 直接投放、无需拆包，可同时给多台机器网络启动与安装；支持 Legacy / 各架构 UEFI（含安全启动）及鲲鹏、飞腾、龙芯等信创机型，覆盖 Windows / WinPE / Linux 等 **110+** 类系统。社区镜像 **`szabis/iventoy`**（[镜像页](https://xuanyuan.cloud/zh/r/szabis/iventoy)）把能力装进容器；管理台 **26000**，PXE HTTP **16000**。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 打开管理台 | `http://服务器IP:26000`（建议 Chrome / Firefox） |
| 投放 ISO | 拷到 `./iso`（文件名勿含空格与非 ASCII），在「镜像管理」刷新 |
| 启 PXE | 选局域网 IP（勿选 docker0），点绿色启动；现网可改 External DHCP |
| 访问控制 | MAC 过滤（谁能 PXE）/ 用户过滤（谁能开管理台） |
| 备份搬家 | 停容器后打包 `./data`、`./iso`、`./user` |

本文用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`szabis/iventoy:1.0.39`**，**Docker Compose** 以 **host 网络 + privileged + `AUTO_START_PXE=false`** 启动。实测局域网 IP **`192.168.1.35`**，请换成你的。无 Compose 见第八节。文内 **7** 张实测截图。

> **上手要点**
> - **部署**：第五节 Compose；备选 `docker run` 见第八节
> - **访问**：宿主 **26000** → GUI；PXE HTTP **16000**（host 模式直接占宿主端口）
> - **硬性**：`privileged: true` + `network_mode: host`
> - **自动启**：镜像默认 `AUTO_START_PXE=true`。跟做须写 **`false`**（省略 ≠ 关闭）；否则进程会退出，`curl` 得 `000`（见 5.4）
> - **Server IP**：GUI 常默认 `docker0` / `172.17.0.1`——装机改选局域网（实测 **`192.168.1.35` / br0`）
> - **数据**：`./data`、`./iso`、`./driver`、`./log`、`./user` → `/opt/iventoy/...`
> - **标签**：跟做 **`1.0.39`**，勿写 `latest`；体积 DISK **253MB** / CONTENT **74.4MB**
> - **现网**：已有 DHCP 时先改 External / Proxy，或隔离实验网段

官方：[中文官网](https://www.iventoy.com/cn/index.html) · [快速开始](https://www.iventoy.com/en/doc_start.html) · [第三方 DHCP](https://www.iventoy.com/en/doc_ext_dhcp.html) · [镜像页](https://xuanyuan.cloud/zh/r/szabis/iventoy)

---

## 一、iVentoy 是什么？

相对「自己拼 DHCP + TFTP + nginx」，iVentoy 更偏 **浏览器里管多 ISO 网络启动**：ISO 放进目录即可，菜单可中文显示，并按客户端架构过滤镜像。不熟悉 PXE / DHCP / TFTP 时，**不要**直接在生产办公网开内置 DHCP。

| | iVentoy（本文） | 手工 PXE | 云厂商装机模板 |
|--|-----------------|----------|----------------|
| 入口 | 浏览器 `:26000` | 多份配置文件 | 厂商控制台 |
| ISO | 目录投放 + Web 刷新 / 上传 | 手写路径与菜单 | 预置镜像 |
| 客户端 | Legacy / UEFI / ARM64 / 龙芯等 | 自配引导 | 云侧 |
| DHCP | 内置或第三方协作 | 自建 | 云侧 |
| 适合 | 机房批量装机、实验网、信创机型 | 已有完整 PXE 栈 | 公有云虚机 |

```text
浏览器（管理台）
   │  :26000
   ▼
szabis/iventoy  （host + privileged）
   ├── ./data → /opt/iventoy/data
   ├── ./iso  → /opt/iventoy/iso
   ├── ./user / ./driver / ./log
   ├── :16000  PXE HTTP
   └── :67/udp :69/udp …（按 DHCP 模式）
```

能力说明见 [iVentoy 中文简介](https://www.iventoy.com/cn/index.html)。[`/r/`](https://xuanyuan.cloud/r/szabis/iventoy) 与 [`/zh/r/`](https://xuanyuan.cloud/zh/r/szabis/iventoy) 为同一镜像不同页面。同站还有其它社区 iventoy 镜像；**本文固定 `szabis/iventoy:1.0.39`**。上游官网若已发新版本资讯，Docker 标签仍以 [tags](https://xuanyuan.cloud/r/szabis/iventoy/tags) 为准。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64**（以 [tags](https://xuanyuan.cloud/r/szabis/iventoy/tags) 为准） |
| 权限 | 能跑 **privileged**；建议 root |
| 内存 | ≥ **1 GB** 可用；ISO 多再加 |
| 磁盘 | DISK **253MB** / CONTENT **74.4MB** + ISO 体积 |
| 网络 | **host**；测试建议独立 VLAN / 实验交换机 |
| 端口 | **26000**、**16000**、**69/udp** 等；冲突时换机或停占用进程 |

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
ss -tlnp | grep -E ':26000|:16000'
ss -ulnp | grep -E ':67|:69'
```

host 网络下**不能**像桥接那样改映射左侧端口，只能停掉占用进程，或在 iVentoy「参数配置」里改服务端口。

> **安全**：PXE 可让可达客户端拉起安装菜单。勿把 **26000 / 16000** 裸暴露公网；生产网优先第三方 DHCP + External，并限制二层域。

---

## 三、标签怎么选

跟做使用 **`1.0.39`**。完整列表：[tags](https://xuanyuan.cloud/r/szabis/iventoy/tags)。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`1.0.39`** | 稳定发行（撰写时与 `latest` 同 Digest） | **本文跟做** |
| `1.0.38` / `1.0.x` | 历史小版本 | 回滚 |
| `latest` | 浮动线 | **勿写入跟做命令** |
| `1.3` / `1.2` / `1.1` / `1.0` | 早期镜像线 | 仅特殊兼容 |

升级前备份 `./data` 与 `./iso`，同步改 pull、Compose、`docker run` 三处标签，并核对维护者 changelog / 上游说明。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/szabis/iventoy:1.0.39
```

Ubuntu 24.04 实测：

```text
1.0.39: Pulling from szabis/iventoy
1b89f26c9bf9: Pull complete
1c24335ddd46: Pull complete
6f5c5aa4e145: Pull complete
86281a433bb8: Pull complete
938d92953e2b: Pull complete
fae021f388e1: Pull complete
Digest: sha256:64b80533370881587c8e958f5d572729934cecdfe036f48ba138f2036e8fe741
Status: Downloaded newer image for docker.xuanyuan.run/szabis/iventoy:1.0.39
docker.xuanyuan.run/szabis/iventoy:1.0.39
```

```bash
docker images docker.xuanyuan.run/szabis/iventoy:1.0.39
```

```text
IMAGE                                       ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/szabis/iventoy:1.0.39   64b805333708        253MB         74.4MB
```

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `szabis/iventoy:1.0.39` | `docker pull docker.xuanyuan.run/szabis/iventoy:1.0.39` |

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq)。

---

## 五、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/iventoy` |
| **macOS** | **`~/docker/iventoy`**（Docker Desktop 通常无法给局域网裸机做 PXE，仅适合看 GUI） |
| **Windows（Docker Desktop）** | 如 `C:\docker\iventoy`（装机请用 Linux 宿主机） |

容器须以 root 跑，且 **`privileged: true`**、**`network_mode: host`**。host 下 Compose 的 `ports:` **不生效**，故下文不写端口映射。

### 5.1 准备目录

```bash
mkdir -p /www/wwwroot/iventoy/{data,driver,iso,log,user}
cd /www/wwwroot/iventoy

# macOS：mkdir -p ~/docker/iventoy/{data,driver,iso,log,user} && cd ~/docker/iventoy
```

非 root 给 `mkdir` 加 `sudo`。ISO 可稍后放入 `iso/`（见 6.5）；官方要求**目录名与文件名不要含空格和非 ASCII**，也可用 `ln -s` 链到大容量盘。

### 5.2 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  iventoy:
    image: docker.xuanyuan.run/szabis/iventoy:1.0.39
    container_name: iventoy
    hostname: iventoy
    network_mode: host
    privileged: true
    restart: unless-stopped
    environment:
      - TZ=Asia/Shanghai
      - AUTO_START_PXE=false
    healthcheck:
      test: ["CMD", "curl", "--fail", "--silent", "--head", "http://localhost:26000/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 2m
    volumes:
      - ./data:/opt/iventoy/data
      - ./driver:/opt/iventoy/driver
      - ./iso:/opt/iventoy/iso
      - ./log:/opt/iventoy/log
      - ./user:/opt/iventoy/user
EOF
```

| 项 | 说明 |
|----|------|
| `network_mode: host` | 与宿主共网栈（PXE 必须） |
| `privileged: true` | 维护者要求 |
| `TZ=Asia/Shanghai` | 覆盖镜像默认 `Europe/Budapest` |
| **`AUTO_START_PXE=false`** | 镜像默认 `true`。`true` 时入口跑 `iventoy.sh -R start`；无有效配置会直接退出。首次跟做必须写 `false` |
| 五个卷 | 配置、驱动、ISO、日志、用户脚本 |

宿主端口对照（核对占用用，**不是** Compose 映射）：

| 端口 | 用途 |
|------|------|
| `67/udp` | DHCP（内置模式） |
| `69/udp` | TFTP |
| `3260` / `10809` / `12049` | iSCSI / NBD / NFS |
| `16000` | PXE HTTP |
| `26000` | Web GUI |

### 5.3 启动并验证

```bash
docker compose up -d
docker compose ps
```

Ubuntu 24.04 实测：

```text
[+] up 1/1
 ✔ Container iventoy Started
```

```text
NAME      IMAGE                                       COMMAND                  SERVICE   CREATED         STATUS                            PORTS
iventoy   docker.xuanyuan.run/szabis/iventoy:1.0.39   "/opt/iventoy/entryp…"   iventoy   4 seconds ago   Up 2 seconds (health: starting)
```

> host 下 **PORTS** 列常为空。`Up` ≠ GUI 已就绪，以日志与 `curl` 为准。

```bash
docker compose logs -f iventoy
```

成功关键行（实测，`AUTO_START_PXE=false`）：

```text
iventoy  | [INFO] Timezone set to Asia/Shanghai
iventoy  | [INFO] Auto start disabled
iventoy  | iventoy start SUCCESS PID=31
iventoy  | #################### iVentoy 1.0.39 ####################
iventoy  | [HTTP] HTTP API service is running on 0.0.0.0:26000 ...
iventoy  |   [5] 192.168.1.35      255.255.255.0     192.168.1.1       br0
iventoy  | iVentoy entering main loop ...
iventoy  | [HTTP] 200 HEAD / size 0
```

若仍是 **`Auto start enabled`** 或随后出现 `Main loop break`，见 **5.4**。装机用局域网 IP（上表 **`192.168.1.35` / br0`），不要用 `172.x` 的 docker 网桥。

`Ctrl+C` 只退出日志跟踪。再探测：

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:26000/
```

```text
200
```

浏览器打开：

```text
http://192.168.1.35:26000
```

界面步骤见第六节。

### 5.4 踩坑：自动启默认开、脏 `config.dat`

镜像 ENV 默认 **`AUTO_START_PXE=true`**。Compose **省略**该变量时仍会自动启。

**现象**：日志 `Auto start enabled`，随后 `No config.dat exist, can NOT auto run` 或 `DHCP server ip is 0`，再 `Main loop break`；`curl` 得 **`000`**。失败退出时还会写出残缺 `config.dat`（`ip:0.0.0.0`），下次自动启仍会挂。

**修复**：

```bash
cd /www/wwwroot/iventoy
docker compose down
rm -f ./data/config.dat
# 确认 compose 含 AUTO_START_PXE=false
docker compose up -d --force-recreate
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:26000/
```

期望日志出现 **`Auto start disabled`** 与 **`entering main loop`**，`curl` 为 **200**。GUI 选好局域网 IP、点过绿色 Start 并确认 PXE 可用后，再视需要改回 `AUTO_START_PXE=true`。

---

## 六、浏览器首次配置与体验

建议 **Chrome** 或 **Firefox**。打开 `http://192.168.1.35:26000`。

### 6.1 启动信息：改选局域网 IP 并启 PXE

首次进入多为 **启动信息**。下拉「选择本机 IP」常默认 **`docker0` / `172.17.0.1`**——局域网裸机装机**必须改选** `192.168.1.35`（或你的 br0 / eth0），再按需改地址池 / 网关 / DNS，最后点右侧 **绿色启动**。

![iVentoy 启动信息：默认选中 docker0 172.17.0.1，须改选局域网 IP](https://imgs.xuanyuan.cloud/docker/blog/iventoy-1.webp)

页脚可见 **Version 1.0.39 Linux x86_64** 与免费版提示。

![iVentoy 启动信息：页脚 Version 1.0.39 与绿色启动按钮](https://imgs.xuanyuan.cloud/docker/blog/iventoy-2.webp)

### 6.2 参数配置：DHCP 与端口

**参数配置** 可改 TFTP 超时、HTTP **16000** / NBD / iSCSI / NFS，以及 DHCP 模式、二次 DHCP、启动背景、Legacy/UEFI 引导文件等。改完点 **保存**。

| 场景 | 建议 DHCP 模式 |
|------|----------------|
| 独立实验网 / 无其它 DHCP | **Internal**（实测默认） |
| 同网段已有路由器 / 域控 DHCP | **External**（或 Proxy） |
| 跨 VLAN | **ExternalNet** 等（对第三方 DHCP 要求更高） |

External 时在第三方 DHCP 设：`next-server` = iVentoy IP；`bootfile` = `iventoy_loader_16000`（HTTP 端口改过则后缀跟着改）。见 [第三方 DHCP](https://www.iventoy.com/en/doc_ext_dhcp.html)。

![iVentoy 参数配置：DHCP Internal、HTTP 16000 与启动参数](https://imgs.xuanyuan.cloud/docker/blog/iventoy-3.webp)

### 6.3 MAC 过滤

控制哪些客户端可获得 **PXE** 服务：白名单 / 黑名单，支持 `*` 模糊匹配。办公网建议至少看一眼，避免无关机器误进装机菜单。

![iVentoy MAC 过滤：黑名单模式与说明](https://imgs.xuanyuan.cloud/docker/blog/iventoy-4.webp)

### 6.4 用户过滤

按 IP 限制谁能打开 **管理台**（不是 PXE 客户端）。支持 `192.168.1.*` 通配；生产建议只放运维网段。

![iVentoy 用户过滤：按 IP 限制管理台访问](https://imgs.xuanyuan.cloud/docker/blog/iventoy-5.webp)

### 6.5 镜像管理

空目录时界面会提示：把镜像放到 **`iso` 目录** 后点 **刷新**（也可 **上传**）。

```bash
cp /path/to/ubuntu-24.04-live-server-amd64.iso /www/wwwroot/iventoy/iso/
# GUI 点「刷新」；文件名勿含空格与非 ASCII
```

![iVentoy 镜像管理：未检测到镜像，提示放入 iso 目录后刷新](https://imgs.xuanyuan.cloud/docker/blog/iventoy-6.webp)

刷新后列表应出现 ISO。客户端开网络启动，即可进入 iVentoy 菜单选系统；装机流量走 **16000** 等端口，需保证二层/三层可达。

### 6.6 注册信息

可核对 **`1.0.39 Linux x86_64`**、免费版标识与机器码（升级专业版时用）。

![iVentoy 注册信息：免费版 1.0.39 与机器码](https://imgs.xuanyuan.cloud/docker/blog/iventoy-7.webp)

### 6.7 可选：配置成功后再开自动启

仅当 GUI 已选好局域网 IP、点过绿色 Start、PXE 确认可用后，再把 Compose 改为 `AUTO_START_PXE=true` 并 `docker compose up -d`。此前保持 **`false`**（原因见 5.4）。

### 6.8 生产加固

- **26000** 仅内网或 VPN；配合用户过滤限制运维 IP  
- 现网优先第三方 DHCP + External  
- MAC 过滤限制可装机客户端  
- 升级前备份 `./data` 与 ISO；勿把 privileged 容器暴露公网  

---

## 七、备份、升级与迁移

```bash
cd /www/wwwroot/iventoy
docker compose stop
tar -czf iventoy-backup-$(date +%F).tar.gz data driver iso user log docker-compose.yml
docker compose start
```

ISO 很大时可只备份 `data` / `user`，ISO 库另做存储快照。

升级：查 [tags](https://xuanyuan.cloud/r/szabis/iventoy/tags) → 改 Compose 标签 → `docker compose pull && docker compose up -d` → 打开 `:26000` 核对版本。迁移时恢复同结构目录与 `docker-compose.yml`，在新机改选 Server IP 后启动。

---

## 八、备选：docker run

无 Compose 时可临时使用；日常仍建议第五节。

```bash
mkdir -p /www/wwwroot/iventoy/{data,driver,iso,log,user}

docker run -d --name iventoy \
  --network host \
  --privileged \
  --restart unless-stopped \
  -e TZ=Asia/Shanghai \
  -e AUTO_START_PXE=false \
  --health-cmd='curl --fail --silent --head http://localhost:26000/ || exit 1' \
  --health-interval=30s \
  --health-timeout=10s \
  --health-retries=3 \
  --health-start-period=2m \
  -v /www/wwwroot/iventoy/data:/opt/iventoy/data \
  -v /www/wwwroot/iventoy/driver:/opt/iventoy/driver \
  -v /www/wwwroot/iventoy/iso:/opt/iventoy/iso \
  -v /www/wwwroot/iventoy/log:/opt/iventoy/log \
  -v /www/wwwroot/iventoy/user:/opt/iventoy/user \
  docker.xuanyuan.run/szabis/iventoy:1.0.39
```

host 下 `-p` 无效。首次必须 **`AUTO_START_PXE=false`**；曾失败则先删 `data/config.dat`。

```bash
docker ps --filter name=iventoy
docker logs -f iventoy
docker stop iventoy && docker rm iventoy
```

---

## 九、常见问题 FAQ

**Q1：和现网 DHCP 冲突？**  
立刻停容器或改 External / Proxy，并在路由器配 `next-server` 与 `bootfile`。实验用独立交换机。

**Q2：`curl` 得 `000` / 打不开 26000？**  
看是否 `Auto start enabled` 后进程退出，或存在脏 `config.dat`——按 **5.4** 处理。再查防火墙与访问 IP（用 `192.168.1.35`，勿用 `172.x`）。

**Q3：ISO 放了但镜像管理是空的？**  
去掉空格与中文文件名；确认挂载的是宿主机 `./iso`；GUI 点刷新。

**Q4：必须 privileged + host 吗？**  
按维护者说明，**是**。桥接 + 普通权限通常跑不稳完整 PXE。

**Q5：Docker Desktop 能给办公室电脑装系统吗？**  
管理台或许能开，局域网裸机 PXE **不可靠**。装机用 Linux 物理机或桥接网卡的虚拟机。

**Q6：GUI 里 Server IP 选哪个？**  
选局域网地址（实测 **`192.168.1.35` / br0`）。默认的 `docker0` / `172.17.0.1` 只服务 Docker 网桥，物理机进不了装机菜单。

**Q7：为什么不用 `latest`？**  
浮动标签会静默升级，步骤可能与文档脱节。跟做固定 **`1.0.39`**。

**Q8：Compose 删了 `AUTO_START_PXE` 为何还是 Auto start enabled？**  
镜像默认就是 `true`。必须显式写 **`false`**。Hub 示例里的 `true` 仅适合已有成功配置之后。

---

## 十、命令速查

```bash
docker pull docker.xuanyuan.run/szabis/iventoy:1.0.39

cd /www/wwwroot/iventoy
docker compose up -d
docker compose ps
docker compose logs -f iventoy
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:26000/

# 修复自动启失败
docker compose down && rm -f ./data/config.dat && docker compose up -d --force-recreate

docker compose pull && docker compose up -d
docker compose down
```

---

## 十一、延伸阅读

| 资源 | 链接 |
|------|------|
| [szabis/iventoy 镜像页](https://xuanyuan.cloud/zh/r/szabis/iventoy) | [https://xuanyuan.cloud/zh/r/szabis/iventoy](https://xuanyuan.cloud/zh/r/szabis/iventoy) |
| [szabis/iventoy 概览](https://xuanyuan.cloud/r/szabis/iventoy) | [https://xuanyuan.cloud/r/szabis/iventoy](https://xuanyuan.cloud/r/szabis/iventoy) |
| [szabis/iventoy 标签列表](https://xuanyuan.cloud/r/szabis/iventoy/tags) | [https://xuanyuan.cloud/r/szabis/iventoy/tags](https://xuanyuan.cloud/r/szabis/iventoy/tags) |
| [iVentoy 中文官网](https://www.iventoy.com/cn/index.html) | [https://www.iventoy.com/cn/index.html](https://www.iventoy.com/cn/index.html) |
| [iVentoy · 快速开始](https://www.iventoy.com/en/doc_start.html) | [https://www.iventoy.com/en/doc_start.html](https://www.iventoy.com/en/doc_start.html) |
| [iVentoy · 第三方 DHCP](https://www.iventoy.com/en/doc_ext_dhcp.html) | [https://www.iventoy.com/en/doc_ext_dhcp.html](https://www.iventoy.com/en/doc_ext_dhcp.html) |
| [GitHub · ventoy/PXE](https://github.com/ventoy/PXE) | [https://github.com/ventoy/PXE](https://github.com/ventoy/PXE) |
| [Docker Hub · szabis/iventoy](https://hub.docker.com/r/szabis/iventoy) | [https://hub.docker.com/r/szabis/iventoy](https://hub.docker.com/r/szabis/iventoy) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- 跟做 **`szabis/iventoy:1.0.39`**：Compose + **host** + **privileged** + **`AUTO_START_PXE=false`**  
- 管理台 `http://IP:26000`；Server IP 选局域网，勿用 docker0；ISO 进 `./iso`  
- 现网处理好 DHCP；可用 MAC / 用户过滤加固  
- 自动启失败：删 `./data/config.dat` 并保持 `false`，GUI 跑通后再改 `true`  

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/iventoy-docker-deploy

