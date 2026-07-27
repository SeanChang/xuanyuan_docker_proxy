# 群晖 NAS 部署 qBittorrent：图形界面全程跟做，浏览器管理下载

![群晖 NAS 部署 qBittorrent：图形界面全程跟做，浏览器管理下载](https://img.xuanyuan.dev/docker/blog/qbittorrent.png)

*分类: Docker部署教程 | 标签: qBittorrent,Docker,轩辕镜像,群晖,NAS,BT下载,私有化部署,部署教程 | 发布时间: 2026-07-13 08:45:30*

> 零基础教程：群晖 Container Manager 配置轩辕镜像仓库、拉取 linuxserver/qbittorrent、卷挂载与 PUID/PGID、Web Station 门户、首次登录改密与添加种子。实测含 19 张截图，文末附 docker run / Compose 命令。

*本文基于 [linuxserver/qbittorrent:version-5.2.3_v2.0.13](https://xuanyuan.cloud/zh/r/linuxserver/qbittorrent) 镜像，群晖 DSM **Container Manager** 图形界面实测（Web 端口 **8080**，BT 端口 **6881**）*

想在 NAS 上挂种、远程管理下载任务，又不想折腾命令行？**qBittorrent** 是开源、轻量且功能完整的 BitTorrent 客户端，支持 Web 远程控制、RSS、搜索插件与跨平台使用。**linuxserver/qbittorrent** 由 [LinuxServer.io](https://www.linuxserver.io/) 维护，定期更新、支持 PUID/PGID 权限映射，非常适合在群晖上长期运行。

本文带你用 **Container Manager 图形界面** 完成一次完整部署：配置轩辕镜像仓库 → 搜索下载镜像 → 创建容器（卷挂载、环境变量、端口）→ Web Station 门户 → 浏览器登录并添加种子——**全程无需 SSH**，附 **19 张截图**。文末补充 **docker run / Docker Compose** 命令，方便 Linux 服务器用户一键复现。

国内用户从 Docker Hub 拉取 `linuxserver/qbittorrent` 可能较慢，本文使用 [轩辕镜像](https://xuanyuan.cloud) 加速。官方文档见 [linuxserver/docker-qbittorrent](https://github.com/linuxserver/docker-qbittorrent)，镜像页 [轩辕镜像 qBittorrent](https://xuanyuan.cloud/zh/r/linuxserver/qbittorrent)。

![群晖 NAS 部署 qBittorrent](https://img.xuanyuan.dev/docker/blog/qbittorrent-17.png)

*图 0：群晖 NAS + Docker 部署完成 qBittorrent 界面*

## 一、qBittorrent 容器是什么？

**linuxserver/qbittorrent** 将 [qBittorrent](https://www.qbittorrent.org/) 打包为 Docker 容器，基于 LinuxServer.io 的 s6 overlay 基础镜像，具备以下特点：

| 能力 | 说明 |
|------|------|
| Web 远程管理 | 浏览器打开 `http://NAS_IP:8080` 即可添加种子、查看进度 |
| 跨架构支持 | x86-64、arm64 均支持，群晖 x86 / arm 机型均可拉取 |
| 权限映射 | 通过 `PUID` / `PGID` 解决卷挂载权限问题 |
| 端口可配 | `WEBUI_PORT` 与 `TORRENTING_PORT` 环境变量与端口映射需一致 |
| 定期更新 | LinuxServer.io 每周基础层更新，应用版本跟进上游稳定版 |

典型使用场景：

- **群晖 / NAS** 7×24 挂种、做种，下载文件直接落到共享目录
- **家庭服务器** 远程添加磁力链，手机浏览器也能管理
- **PT 站点** 配合固定 BT 端口（6881 或自定义）提升连接效率

> **与 Transmission 的区别**：qBittorrent 功能更丰富（内置搜索、RSS、标签分类），Web UI 更现代；若只需极简 BT 客户端，可考虑 `linuxserver/transmission`。

架构示意：

```text
浏览器 ──HTTP:8080──▶ qBittorrent WebUI
qBittorrent 容器 ──BT:6881/tcp+udp──▶ 公网 / 内网 peers
qBittorrent 容器 ──挂载卷──▶ /config（配置）+ /downloads（下载目录）
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 设备 | 群晖 NAS（本文 x86 架构 DSM 实测） |
| 系统 | DSM 7.x，已安装 **Container Manager**（原 Docker 套件） |
| 套件 | 建议同时安装 **Web Station**（用于配置 Web 门户，可选） |
| 内存 | ≥ 1 GB（本文容器限制 **1096 MB**） |
| CPU | 双核即可；资源限制设为「中」优先级 |
| 磁盘 | 视下载量而定；`/config` 存配置与恢复数据 |
| 端口 | **8080**（Web UI）、**6881**（BT TCP/UDP，可在路由器做端口转发） |
| 镜像标签 | 本文实测 **`version-5.2.3_v2.0.13`**（生产建议锁定版本号） |

部署前请先在 **控制面板 → 共享文件夹** 中准备好：

- `/docker/qbittorrent` — 存放容器配置（映射到容器 `/config`）
- `/Download` — 下载文件存放目录（映射到容器 `/downloads`，可按需改名）

群晖 NAS 镜像加速总览见 [群晖 NAS Docker 镜像源配置教程](https://xuanyuan.cloud/usage/synology)。

---

## 三、配置轩辕镜像仓库

群晖通过 **Container Manager**（DSM 7.2+ 由原 Docker 套件更名）的「镜像仓库」功能添加轩辕镜像源。完整图文说明见官方教程：[群晖 NAS Docker 镜像源配置教程](https://xuanyuan.cloud/usage/synology)。

> **配置前准备**：登录 [轩辕镜像](https://xuanyuan.cloud)，在左侧 **个人中心** 查看你的 **专属域名**（格式为 `***.xuanyuan.run`）。群晖 NAS **推荐使用专属域名**，无需填写账号密码，配置更简单。

### 3.1 操作步骤

1. 打开群晖 **DSM 控制面板**
2. 进入 **套件中心**，安装 **Container Manager**（若尚未安装）
3. 打开 **Container Manager**
4. 点击左侧 **镜像仓库**（旧版界面称「注册表」）
5. 点击右上角 **设置** → **添加**

### 3.2 填写注册表信息（二选一）

| 方式 | 注册表 URL | 用户名 / 密码 | 说明 |
|------|------------|---------------|------|
| **方式一：专属域名（推荐）** | `https://你的专属域名.xuanyuan.run` | **留空** | 在个人中心复制专属域名，无需登录验证 |
| **方式二：通用域名** | `https://docker.xuanyuan.run` | 轩辕镜像 **镜像账户** / **镜像密码** | 账户与密码见 [登录认证方式](https://xuanyuan.cloud/usage/login)；忘记密码可在个人中心重置 |

本文实测截图采用 **方式二（通用域名 + 账号密码）**，界面如下：

| 字段 | 填写内容 |
|------|----------|
| 镜像仓库名称 | `轩辕镜像`（可自定义） |
| 镜像仓库 URL | `https://docker.xuanyuan.run` |
| 信任的 SSL 自我签署证书 | 若测试连接报证书错误，可勾选此项 |
| 用户名 / 密码 | 轩辕镜像镜像账户与镜像密码 |

![编辑镜像仓库：配置轩辕镜像](https://img.xuanyuan.dev/docker/blog/qbittorrent-1.png)

*图 1：在 Container Manager 中添加轩辕镜像仓库（通用域名方式）*

6. 点击 **测试连接**，确认提示成功
7. 点击 **应用**（或 **保存**）完成配置

配置成功后，在 **镜像仓库** 搜索 `linuxserver/qbittorrent` 即可从轩辕镜像加速拉取。

> **注册表搜索失败？** 常见原因为代理或 DNS 问题。请关闭群晖网络代理、将 DNS 改为 `223.5.5.5` 或 `114.114.114.114`，或通过 SSH 执行 `docker pull` 验证。详见官方教程 [注册表查询失败排查](https://xuanyuan.cloud/usage/synology#注册表查询失败排查)。

> **流量用尽**：拉取时若返回 `402 Payment Required` 或 `capacity has use up`，表示流量包已耗尽，需在轩辕镜像控制台充值后继续使用。

---

## 四、搜索并下载镜像

### 4.1 在镜像仓库中搜索

配置好镜像仓库后，按 [官方日常使用说明](https://xuanyuan.cloud/usage/synology#日常使用说明) 操作：

1. 进入 **Container Manager → 镜像仓库**
2. 右上角搜索框输入 `linuxserver/qbittorrent`（或简写 `qbittorrent`）
3. 在结果列表中找到 **linuxserver/qbittorrent**（LinuxServer.io 官方描述）
4. 右键选择 **下载此映像**（或点击条目旁的下载按钮）

![镜像仓库搜索 linuxserver/qbittorrent](https://img.xuanyuan.dev/docker/blog/qbittorrent-2.png)

*图 2：搜索并选择 linuxserver/qbittorrent 镜像*

### 4.2 选择版本标签

生产环境建议锁定具体版本，而非 `latest`。可在 [轩辕镜像标签页](https://xuanyuan.cloud/zh/r/linuxserver/qbittorrent) 查看可用标签，本文使用 **`version-5.2.3_v2.0.13`**：

![轩辕镜像标签列表 version-5.2.3_v2.0.13](https://img.xuanyuan.dev/docker/blog/qbittorrent-3.png)

*图 3：轩辕镜像站查看 qBittorrent 可用版本标签*

回到 Container Manager，在 **选择标签** 对话框中手动输入标签名（部分自定义仓库无法自动列出标签）：

![选择标签 version-5.2.3_v2.0.13](https://img.xuanyuan.dev/docker/blog/qbittorrent-4.png)

*图 4：手动输入镜像标签并点击下载*

### 4.3 等待下载完成

切换到 **映像** 页签，可看到镜像正在从 `docker.xuanyuan.run` 拉取：

![镜像正在下载](https://img.xuanyuan.dev/docker/blog/qbittorrent-5.png)

*图 5：镜像下载进行中*

下载完成后，映像列表显示约 **185 MB**，状态为可用：

![镜像下载完成](https://img.xuanyuan.dev/docker/blog/qbittorrent-6.png)

*图 6：镜像拉取完成，可点击「运行」创建容器*

---

## 五、创建容器（图形界面）

选中已下载的镜像，点击 **运行**，按向导逐步配置。

### 5.1 常规设置

| 配置项 | 本文实测值 |
|--------|------------|
| 容器名称 | `linuxserver-qbittorrent` |
| 启用资源限制 | ✅ |
| CPU 优先级 | 中 |
| 内存上限 | 1096 MB |
| 启用自动重新启动 | ✅ |
| 通过 Web Station 设置网页门户 | ✅（需已安装 Web Station） |

端口设置中，确保映射 **8080**（Web UI）与 **6881**（BT）：

![创建容器：常规设置与端口](https://img.xuanyuan.dev/docker/blog/qbittorrent-7.png)

*图 7：容器名称、资源限制与端口预填*

### 5.2 存储空间与端口

在 **高级设置** 中配置卷挂载与端口：

**存储空间设置**：

| 本地文件夹 | 装载路径 | 权限 |
|------------|----------|------|
| `/docker/qbittorrent` | `/config` | 读取/写入 |
| `/Download` | `/downloads` | 读取/写入 |

**端口设置**：

| 本地端口 | 容器端口 | 协议 |
|----------|----------|------|
| 8080 | 8080 | TCP（Web UI） |
| 6881 | 6881 | TCP（BT，建议同时在路由器映射 UDP） |

![存储空间与端口映射](https://img.xuanyuan.dev/docker/blog/qbittorrent-8.png)

*图 8：`/config` 与 `/downloads` 卷挂载，8080 / 6881 端口映射*

> **路径说明**：群晖 GUI 中显示的 `/docker/qbittorrent` 实际对应共享文件夹路径，完整路径通常为 `/volume1/docker/qbittorrent`。`/Download` 同理。

### 5.3 环境变量

点击 **环境** 页签，新增或确认以下变量（**PUID/PGID 请改为你 NAS 用户的实际 uid/gid**）：

| 变量 | 值 | 说明 |
|------|-----|------|
| `PUID` | `1000` | 容器内用户 ID，与宿主机目录属主一致 |
| `PGID` | `1000` | 容器内组 ID |
| `TZ` | `Asia/Shanghai` | 时区 |
| `WEBUI_PORT` | `8080` | Web 界面端口，需与端口映射一致 |
| `TORRENTING_PORT` | `6881` | BT 连接端口，需与端口映射一致 |

![环境变量 PUID PGID TZ WEBUI_PORT TORRENTING_PORT](https://img.xuanyuan.dev/docker/blog/qbittorrent-9.png)

*图 9：关键环境变量配置*

获取群晖用户 uid/gid：**控制面板 → 用户与群组 → 选中用户 → 编辑** 中查看，或通过 SSH 执行 `id 你的用户名`。

### 5.4 网络设置

网络模式保持默认 **bridge** 即可，点击 **下一步**：

![网络 bridge 模式](https://img.xuanyuan.dev/docker/blog/qbittorrent-10.png)

*图 10：网络选择 bridge，保持默认*

### 5.5 摘要确认并创建

在 **摘要** 页核对配置，勾选 **向导完成后运行此容器**，点击 **完成**：

![创建容器摘要确认](https://img.xuanyuan.dev/docker/blog/qbittorrent-11.png)

*图 11：摘要页核对卷、端口、环境变量后点击完成*

弹出提示 **已创建 linuxserver-qbittorrent**，若启用了 Web Station 集成，会提示进入 Web Station 配置网页门户：

![容器创建成功](https://img.xuanyuan.dev/docker/blog/qbittorrent-12.png)

*图 12：容器创建成功提示*

---

## 六、配置 Web Station 门户（可选）

若创建容器时勾选了 **通过 Web Station 设置网页门户**，需打开 **Web Station → 网络门户 → 新增**：

| 配置项 | 值 |
|--------|-----|
| 服务 | `linuxserver-qbittorrent` |
| 门户类型 | 基于端口 |
| 端口 | HTTP **8080** |

![Web Station 配置网页门户 8080](https://img.xuanyuan.dev/docker/blog/qbittorrent-13.png)

*图 13：Web Station 为 qBittorrent 配置 8080 端口门户*

配置完成后，在 **用户定义的门户** 列表中可看到状态为 **正常**，点击 **链接** 图标即可在浏览器打开 Web UI：

![Web Station 门户列表与访问链接](https://img.xuanyuan.dev/docker/blog/qbittorrent-14.png)

*图 14：门户配置完成，点击链接图标访问 Web UI*

> 若未使用 Web Station，也可直接在浏览器访问 `http://你的群晖IP:8080`。

---

## 七、首次登录与修改密码

### 7.1 从容器日志获取临时密码

**linuxserver/qbittorrent** 首次启动时，`admin` 用户的密码会输出到容器日志，**每次重启若未在 Web UI 中修改密码，都会重新生成临时密码**。

打开 **Container Manager → 容器 → linuxserver-qbittorrent → 日志**，找到类似输出：

```text
The WebUI administrator username is: admin
The WebUI administrator password was not set. A temporary password is provided for this session: xxxxxxxx
```

![容器日志中的临时用户名与密码](https://img.xuanyuan.dev/docker/blog/qbittorrent-15.png)

*图 15：从容器日志复制 admin 临时密码*

### 7.2 登录 Web UI

浏览器打开 `http://你的群晖IP:8080`，输入用户名 **admin** 与日志中的临时密码：

![qBittorrent WebUI 登录页](https://img.xuanyuan.dev/docker/blog/qbittorrent-16.png)

*图 16：WebUI 登录界面*

登录成功后进入主界面。建议立即进入 **设置（齿轮图标）→ Web UI**，修改用户名与密码，避免容器重启后密码失效：

![qBittorrent 主界面](https://img.xuanyuan.dev/docker/blog/qbittorrent-17.png)

*图 17：登录成功，进入 qBittorrent 主界面*

---

## 八、添加种子并验证下载

点击工具栏 **添加链接** 图标，粘贴磁力链或种子 URL，点击 **Download**：

![添加磁力链接](https://img.xuanyuan.dev/docker/blog/qbittorrent-18.png)

*图 18：通过 Web UI 添加磁力链接*

添加后可在列表中看到任务状态。底部 **Save Path** 显示 `/downloads`，对应挂载的 `/Download` 共享文件夹；**Free space** 反映 NAS 可用空间，说明卷挂载生效：

![下载任务与保存路径 /downloads](https://img.xuanyuan.dev/docker/blog/qbittorrent-19.png)

*图 19：种子添加成功，保存路径为 /downloads*

可在 **File Station** 中打开 `/Download` 目录，确认文件落盘位置与权限正常。

---

## 九、附录：命令行部署（Linux / SSH）

群晖用户若熟悉 SSH，或需在 Linux 服务器上部署，可使用以下命令。配置与上文图形界面一致。

### 9.1 拉取镜像

```bash
docker pull docker.xuanyuan.run/linuxserver/qbittorrent:version-5.2.3_v2.0.13
```

### 9.2 docker run 一键启动

```bash
docker run -d \
  --name=qbittorrent \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -e WEBUI_PORT=8080 \
  -e TORRENTING_PORT=6881 \
  -p 8080:8080 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -v /volume1/docker/qbittorrent:/config \
  -v /volume1/Download:/downloads \
  --restart unless-stopped \
  docker.xuanyuan.run/linuxserver/qbittorrent:version-5.2.3_v2.0.13
```

请将 `PUID`、`PGID` 及卷路径替换为实际值。群晖上执行 `id 你的用户名` 获取 uid/gid。

### 9.3 Docker Compose（推荐）

创建 `docker-compose.yml`：

```yaml
---
services:
  qbittorrent:
    image: docker.xuanyuan.run/linuxserver/qbittorrent:version-5.2.3_v2.0.13
    container_name: qbittorrent
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      - WEBUI_PORT=8080
      - TORRENTING_PORT=6881
    volumes:
      - /volume1/docker/qbittorrent:/config
      - /volume1/Download:/downloads
    ports:
      - 8080:8080
      - 6881:6881
      - 6881:6881/udp
    restart: unless-stopped
```

启动：

```bash
docker compose up -d
```

### 9.4 常用运维命令

```bash
# 查看临时密码（首次启动）
docker logs qbittorrent 2>&1 | grep -i password

# 实时日志
docker logs -f qbittorrent

# 进入容器 Shell
docker exec -it qbittorrent /bin/bash

# 更新镜像
docker compose pull && docker compose up -d
```

---

## 十、FAQ

**Q1：每次重启容器密码都变了？**

未在 Web UI **设置 → Web UI** 中修改密码时，容器每次启动都会生成新的临时密码。登录后务必修改并保存。

**Q2：下载的文件权限不对，其他用户无法访问？**

检查 `PUID` / `PGID` 是否与 `/Download` 目录属主一致。在群晖 **控制面板 → 用户与群组** 确认 uid/gid，或执行 `chown -R 你的uid:你的gid /volume1/Download`。

**Q3：BT 速度慢、连不上 peer？**

1. 确认 **6881 TCP + UDP** 均已映射（群晖 GUI 可能只显示 TCP，建议在 **容器 → 编辑 → 端口** 中补充 UDP，或使用命令行 `-p 6881:6881/udp`）
2. 在路由器上将 **6881** 端口转发到群晖内网 IP
3. 在 qBittorrent **设置 → 连接** 中确认监听端口为 6881

**Q4：如何修改 Web UI 端口？**

需同时修改三处：端口映射（如 `8123:8123`）、环境变量 `WEBUI_PORT=8123`、Web Station 门户端口（若使用）。详见 [官方 WEBUI_PORT 说明](https://github.com/linuxserver/docker-qbittorrent#webui_port-variable)。

**Q5：8080 端口被占用？**

将端口映射改为例如 `18080:8080`，环境变量 `WEBUI_PORT=8080` 保持不变（容器内仍监听 8080），浏览器访问 `http://NAS_IP:18080`。

**Q6：latest 和 version 标签怎么选？**

| 标签 | 适用场景 |
|------|----------|
| `version-5.2.3_v2.0.13` 等 | **生产推荐**，版本锁定便于回滚 |
| `latest` | 试用或自动跟进最新稳定版 |
| `libtorrentv1` | 需 libtorrent v1 的特定场景 |

**Q7：如何停止与卸载？**

Container Manager 中停止并删除容器即可，`/docker/qbittorrent` 中的配置会保留。命令行：`docker stop qbittorrent && docker rm qbittorrent`。

---

## 十一、命令速查

| 操作 | 说明 |
|------|------|
| Web 访问 | `http://群晖IP:8080` |
| 默认用户名 | `admin`（密码见容器日志） |
| 配置目录 | `/volume1/docker/qbittorrent` → 容器 `/config` |
| 下载目录 | `/volume1/Download` → 容器 `/downloads` |
| 加速拉取 | `docker pull docker.xuanyuan.run/linuxserver/qbittorrent:<标签>` |
| 群晖 GUI 更新 | Container Manager → 映像 → 检查更新 → 重新创建容器 |

---

## 参考链接

| 资源 | 链接 |
|------|------|
| 轩辕镜像 qBittorrent 页 | https://xuanyuan.cloud/zh/r/linuxserver/qbittorrent |
| GitHub 官方仓库 | https://github.com/linuxserver/docker-qbittorrent |
| LinuxServer.io 文档 | https://docs.linuxserver.io/images/docker-qbittorrent |
| 群晖镜像加速配置 | https://xuanyuan.cloud/usage/synology |
| 轩辕镜像登录认证 | https://xuanyuan.cloud/usage/login |
| qBittorrent 官网 | https://www.qbittorrent.org/ |

---

**总结**：群晖部署 qBittorrent 的核心步骤是 **配置轩辕镜像仓库 → 拉取 version 标签 → 创建容器（/config + /downloads 卷、PUID/PGID、8080/6881 端口）→ 日志查临时密码 → Web UI 改密**。图形界面全程可在 Container Manager 完成；Linux 用户可直接使用文末 **docker run / Compose** 命令。长期运行请锁定镜像版本、在路由器转发 BT 端口，并定期备份 `/docker/qbittorrent` 配置目录。


