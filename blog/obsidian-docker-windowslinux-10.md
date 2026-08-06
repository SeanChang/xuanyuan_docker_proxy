# Obsidian Docker 部署｜Windows+Linux 通用，新手也能10分钟上手

![Obsidian Docker 部署｜Windows+Linux 通用，新手也能10分钟上手](https://img.xuanyuan.dev/docker/blog/docker-obsidian-2.png)

*分类: Docker部署教程 | 标签: Obsidian,部署教程,笔记软件 | 发布时间: 2026-04-21 07:33:20*

> Obsidian 作为一款备受欢迎的本地知识管理工具，凭借其灵活的笔记链接、本地存储优势，成为很多开发者、知识管理者的首选。而通过 Docker 部署 Obsidian，不仅能实现跨环境快速部署，还能轻松实现数据持久化，适配 NAS、服务器、个人电脑等多种场景。本文将详细介绍 Windows 和 Linux 两大系统下，通过 Docker 部署 Obsidian 的完整流程，同时提供 Docker 一键安装命令，降低部署门槛。

*本文基于 [linuxserver/obsidian:1.13.4](https://xuanyuan.cloud/zh/r/linuxserver/obsidian)，实测版本 **1.13.4**，测试平台 **Ubuntu 24.04** Linux。*

笔记散在 Notion、语雀和各台电脑的本地库里，换机就要拷文件夹或开同步盘；出门只能打开手机上看，回到工位又对不上版本。双链、插件、图谱这些 Obsidian 强项，一旦绑死在某一台笔记本上，就很难当成「随时可开的知识库」。

更稳妥的做法是把库放在自己的 NAS 或家用服务器上：**数据不出内网、删容器不丢笔记、手机和电脑用浏览器同一入口**。商业在线笔记要订阅、内容在厂商侧；纯本地客户端又难在多台设备间共用同一份库。

**linuxserver/obsidian**（见 [镜像页](https://xuanyuan.cloud/zh/r/linuxserver/obsidian)）把桌面版 Obsidian 装进容器，用 **Selkies** 把画面推到浏览器。宿主机不必装桌面环境；跟做时请用 **`https://服务器IP:3001`**——当前镜像对 HTTP 直连会提示需要安全连接。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 私有知识库 | 打开 `https://服务器IP:3001`，切中文、建库、写双链笔记 |
| NAS / 家服集中存储 | `/config` 挂卷保存配置与笔记，多设备共用同一实例 |
| 图谱 / 画布 / 日记 | 关系图谱、Canvas、日记、命令面板均可在浏览器里用 |
| 本机与容器传文件 | Selkies 侧边栏上传 / 下载，附件落到容器桌面目录 |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`linuxserver/obsidian:1.13.4`**，**Docker Compose** 映射 **13300→3000（HTTP，反代备用）**、**3001→3001（HTTPS，推荐）**，信任自签名证书后进入界面。文内附 **14** 张实测截图；无 Compose 时见文末 **`docker run` 备选**。Windows / macOS 可用 Docker Desktop，工作目录见第五节。

> **上手要点**  
> - **部署**：默认 **Compose**（第五节）；临时试玩见 **第十一节 docker run**  
> - **访问**：**必须** `https://服务器IP:3001`（自签名证书需手动继续访问）  
> - **端口**：宿主机 **13300** → 容器 **3000**（HTTP）；宿主机 **3001** → 容器 **3001**（HTTPS）  
> - **数据卷**：`./config` → 容器 `/config`  
> - **共享内存**：必须设 `shm_size: "1gb"`  
> - **标签**：钉死 **`1.13.4`**（见 [tags](https://xuanyuan.cloud/r/linuxserver/obsidian/tags)），不要写 `latest`  
> - **暴露**：默认无认证；公网务必反代 + 强认证，勿裸奔  

官方镜像说明：[LinuxServer · obsidian](https://docs.linuxserver.io/images/docker-obsidian/)。源码：[linuxserver/docker-obsidian](https://github.com/linuxserver/docker-obsidian)。

![Obsidian 中文主界面：欢迎笔记与关系图谱](https://img.xuanyuan.dev/docker/blog/obsidian-3.webp)

*图 1：部署成功后，浏览器中的 Obsidian（简体中文欢迎笔记与关系图谱）*

---

## 一、Obsidian 容器是什么？

本镜像跑的是**完整桌面客户端**，不是精简 Web 编辑器：容器内启动 Obsidian，浏览器通过 Selkies 远程操作。

| | linuxserver/obsidian（本文） | 官方桌面客户端 |
|--|------------------------------|----------------|
| 入口 | 浏览器（HTTPS :3001） | 本机安装包 |
| 数据 | 挂卷集中在服务器 / NAS | 多在本机目录 |
| 适合 | 远程访问、多设备共用同一库 | 单机重度写作（更流畅） |
| 注意 | 强制 HTTPS；默认无强认证 | 无推流开销 |

```text
浏览器  ──HTTPS:3001──▶  Selkies ──▶ 桌面版 Obsidian
              │
         HTTP:13300 仅作反代上游（直连常被拒绝）
```

个人电脑单独重度使用，仍建议装 [Obsidian 官方客户端](https://obsidian.md/)；本文侧重服务器 / NAS 自托管。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04**（Docker Desktop 亦可） |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64 / arm64**（以标签页为准） |
| 内存 | ≥ **2 GB**（推荐 4 GB） |
| 磁盘 | ≥ **2 GB**（镜像较大，另加笔记空间） |
| 端口 | 宿主机 **13300**（HTTP）、**3001**（HTTPS） |
| 共享内存 | **`shm_size: 1gb`**（必填） |

```bash
docker --version
docker compose version
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

```bash
ss -tlnp | grep -E ':13300|:3001'
```

> **3001** 被占用时，只改左侧宿主机端口，例如 `"13001:3001"`，访问改为 `https://IP:13001`。

---

## 三、标签怎么选

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`1.13.4`** | 本文钉死版本（上游桌面 v1.13.4） | **跟做 / 生产（本文）** |
| **`v1.13.4-ls*`** | LinuxServer CI 构建号 | 需与上游构建完全对齐时选用 |
| **`latest`** | 浮动指针，会随上游更新 | **不要写入跟做命令** |

完整列表：[tags](https://xuanyuan.cloud/r/linuxserver/obsidian/tags)。升级时先改 Compose 标签，再 `pull` / `up -d`。

> 本文拉取时 `latest` 与 `1.13.4` Digest 相同，仍应写死 **`1.13.4`**，避免日后漂移。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/linuxserver/obsidian:1.13.4
```

Ubuntu 24.04 实测：

```text
1.13.4: Pulling from linuxserver/obsidian
Digest: sha256:90fd8a7b03ec5cafb53e596296bbbe99f2dca2ef553bbd3d40d295ef90419921
Status: Downloaded newer image for docker.xuanyuan.run/linuxserver/obsidian:1.13.4
docker.xuanyuan.run/linuxserver/obsidian:1.13.4
```

---

## 五、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/obsidian` |
| **macOS 实测** | **`~/docker/obsidian`** |
| **Windows（Docker Desktop）** | 如 `C:\docker\obsidian` |

### 5.1 创建目录

```bash
mkdir -p /www/wwwroot/obsidian/config
chown -R "$USER:$USER" /www/wwwroot/obsidian
cd /www/wwwroot/obsidian

# macOS：mkdir -p ~/docker/obsidian/config && cd ~/docker/obsidian
```

非 root 时给 `mkdir` / `chown` 加 `sudo`。用 `id` 查看本机 uid / gid，写入下方 `PUID` / `PGID`。

### 5.2 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  obsidian:
    image: docker.xuanyuan.run/linuxserver/obsidian:1.13.4
    container_name: obsidian
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      # 可选：开启 HTTP Basic 认证（仅适合受信内网）
      # - CUSTOM_USER=admin
      # - PASSWORD=请改成强密码
      # 老 CPU 无 AVX2 / Wayland 异常时可取消下一行注释
      # - PIXELFLUX_WAYLAND=false
    volumes:
      - ./config:/config
    ports:
      - "13300:3000"   # HTTP，仅反代备用；浏览器直连请用 HTTPS
      - "3001:3001"    # HTTPS（推荐）
    shm_size: "1gb"
    restart: unless-stopped
EOF
```

| 项 | 说明 |
|----|------|
| `13300:3000` | 宿主机避开 **3000**；HTTP 供反代，浏览器直连常被拒绝 |
| `3001:3001` | **推荐访问口**（HTTPS，自签名证书） |
| `shm_size` | Electron 必需，过小易黑屏或崩溃 |
| `PUID`/`PGID` | 与宿主机用户一致，减少 `config` 权限问题 |

### 5.3 启动与验证

```bash
docker compose up -d
docker compose ps
docker compose logs -f --tail 100
```

本文实测：

```text
[+] Running 2/2
 ✔ Network obsidian_default  Created
 ✔ Container obsidian        Started
```

```text
NAME       IMAGE                                             COMMAND   SERVICE    CREATED         STATUS         PORTS
obsidian   docker.xuanyuan.run/linuxserver/obsidian:1.13.4   "/init"   obsidian   5 seconds ago   Up 5 seconds   0.0.0.0:3001->3001/tcp, [::]:3001->3001/tcp, 0.0.0.0:13300->3000/tcp, [::]:13300->3000/tcp
```

日志关键行（节选）：

```text
obsidian  | User UID:    1000
obsidian  | User GID:    1000
obsidian  | [ls.io-init] done.
obsidian  | INFO:selkies.__main__:Starting Selkies in 'websockets' mode.
obsidian  | INFO:main:Upload directory ensured: /config/Desktop
obsidian  | INFO:main:Initial Encoder: x264enc, Framerate: 60
obsidian  | INFO:main:SelkiesStreamingApp initialized: encoder=x264enc, display=1024x768
obsidian  | INFO:main:All main components initialized. Running server...
obsidian  | INFO:data_websocket:Data WebSocket Server listening on port 8082
obsidian  | [svc-de] /config/.XDG/wayland-1 found launching de
```

容器 `Up`、端口 **3001 / 13300** 已映射，且出现 **`All main components initialized`** 与 **`launching de`** 后，再打开浏览器。

---

## 六、浏览器访问（必须 HTTPS）

| 方式 | 地址 | 说明 |
|------|------|------|
| **HTTPS（推荐）** | `https://服务器IP:3001` | 完整功能；需信任自签名证书 |
| HTTP | `http://服务器IP:13300` | 直连常报需要安全连接；仅作反代上游 |

本文实测：`https://192.168.1.10:3001`

首次打开会提示连接不安全——容器自带自签名证书，内网体验属正常。Chrome / Edge 选「高级」→「继续访问」。之后可点地址栏锁 / 感叹号，建议打开**剪贴板**权限，方便与本机复制粘贴：

![浏览器提示 192.168.1.10:3001 连接不安全并显示剪贴板权限](https://img.xuanyuan.dev/docker/blog/obsidian-9.webp)

*图 2：HTTPS 自签名证书提示（可继续访问；建议开启剪贴板）*

若用 `http://…` 访问，常见报错：

```text
Error: This application requires a secure connection
```

改回 `https://服务器IP:3001` 即可。旧教程里的 `-p 3005:3000` + `http://IP:3005` 也会踩同一问题，见 FAQ。

---

## 七、首次初始化：语言与建库

进入后先看到欢迎页，顶部为 **Version 1.13.4**（与镜像标签一致）。

1. 底部语言改为 **简体中文**  
2. 点 **创建**（创建新仓库）；也可点 **Quick start** 快速开始  
3. 按向导选路径并完成建库  

![Obsidian 欢迎页英文：Version 1.13.4 与 Quick start](https://img.xuanyuan.dev/docker/blog/obsidian-1.webp)

*图 3：首次欢迎页（英文），版本 1.13.4*

![Obsidian 欢迎页已切换简体中文](https://img.xuanyuan.dev/docker/blog/obsidian-2.webp)

*图 4：切换为「简体中文」后的欢迎页*

建库完成后：左侧文件列表、中间「欢迎」笔记、右侧「关系图谱」：

![Obsidian 欢迎笔记与关系图谱中文主界面](https://img.xuanyuan.dev/docker/blog/obsidian-3.webp)

*图 5：中文主界面（欢迎笔记 + 关系图谱）*

---

## 八、主界面功能演示

下列步骤用于确认远程桌面里的 Obsidian 可用，不必一次全做。

### 8.1 关系图谱

左侧点**关系图谱**图标，或把图谱拖到另一栏。有链接的笔记会连成节点；新建画布、日记后节点会增加：

![Obsidian 双栏关系图谱视图](https://img.xuanyuan.dev/docker/blog/obsidian-4.webp)

*图 6：关系图谱（可分栏）*

### 8.2 Canvas 画布

左侧点 **Canvas**（或命令面板搜索「画布」）新建。按界面提示：从下方拖入卡片、空格 + 拖动平移、Ctrl + 滚轮缩放：

![Obsidian Canvas 画布与右侧关系图谱](https://img.xuanyuan.dev/docker/blog/obsidian-5.webp)

*图 7：Canvas 与关系图谱同屏*

### 8.3 日记

左侧点**日记**相关入口，新建当日笔记（本文示例 `2026-08-07`）。图谱中对应节点会高亮：

![Obsidian 日记笔记 2026-08-07 与关系图谱](https://img.xuanyuan.dev/docker/blog/obsidian-6.webp)

*图 8：日记笔记与图谱节点*

### 8.4 命令面板

`Ctrl+P` 打开「选择命令…」，可搜索拆分、书签、保存等：

![Obsidian 命令面板选择命令](https://img.xuanyuan.dev/docker/blog/obsidian-7.webp)

*图 9：命令面板*

### 8.5 表格视图（Bases）

新建 Base / 表格视图后，可列出库内文件并做排序、筛选：

![Obsidian 表格列出仓库文件并与图谱对照](https://img.xuanyuan.dev/docker/blog/obsidian-8.webp)

*图 10：表格视图*

### 8.6 搜索

左侧点搜索图标，支持 `path:`、`file:`、`tag:` 等语法：

![Obsidian 搜索选项语法说明](https://img.xuanyuan.dev/docker/blog/obsidian-10.webp)

*图 11：搜索选项*

---

## 九、Selkies 侧边栏

页面最左侧可展开 **Selkies** 面板——这是远程桌面推流设置，与 Obsidian 自己的设置是两套菜单。卡顿、文字发糊、传文件时优先看这里。

### 9.1 统计信息

CPU、内存、FPS、带宽、延迟：

![Selkies 侧边栏统计信息 CPU 内存 FPS](https://img.xuanyuan.dev/docker/blog/obsidian-11.webp)

*图 12：统计信息*

### 9.2 屏幕设置

可开 **HiDPI**、抗锯齿，界面缩放调到 **150%**（高分屏更易读）：

![Selkies 屏幕设置 HiDPI 与 150% 缩放](https://img.xuanyuan.dev/docker/blog/obsidian-12.webp)

*图 13：屏幕设置*

### 9.3 视频设置

默认 **x264enc**、帧率 **60**、Video CRF **25**（与日志 `Initial Encoder: x264enc, Framerate: 60` 一致）。文字发糊可尝试 **Full Color 4:4:4**（更吃资源）：

![Selkies 视频设置 x264enc 与帧率](https://img.xuanyuan.dev/docker/blog/obsidian-13.webp)

*图 14：视频设置*

### 9.4 剪贴板、文件与共享

侧边栏提供服务器剪贴板、**上传 / 下载**，以及只读共享链接（本文示例 `https://192.168.1.10:3001/#shared`）：

![Selkies 剪贴板文件传输与共享链接](https://img.xuanyuan.dev/docker/blog/obsidian-14.webp)

*图 15：剪贴板、文件互传与共享（HTTPS:3001）*

上传默认落到 `/config/Desktop`（日志中有 `Upload directory ensured: /config/Desktop`）。

---

## 十、安全提醒

- **默认无认证**——未设 `CUSTOM_USER` / `PASSWORD` 时，能访问端口即可操作界面。  
- Web 界面含 **无密码 sudo 终端**，有 GUI 访问权约等于容器内 root。  
- **不要裸奔公网**；内网也建议防火墙限制来源 IP，并加 Basic 认证或反代认证。  
- 公网用 **Nginx / SWAG** 等反代时，上游可指 **HTTP `13300`**，由反代终结正式证书。

---

## 十一、备选：docker run

无 Compose 或临时试玩时（Linux）：

```bash
docker run -d \
  --name=obsidian \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -p 13300:3000 \
  -p 3001:3001 \
  -v /www/wwwroot/obsidian/config:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  docker.xuanyuan.run/linuxserver/obsidian:1.13.4
```

Windows（PowerShell，一行）：

```powershell
docker run -d --name obsidian -e PUID=1000 -e PGID=1000 -e TZ=Asia/Shanghai -p 13300:3000 -p 3001:3001 -v C:\docker\obsidian:/config --shm-size="1gb" --restart unless-stopped docker.xuanyuan.run/linuxserver/obsidian:1.13.4
```

访问：`https://localhost:3001`。

---

## 十二、升级、停止与数据

先改 Compose 中的版本标签，再：

```bash
cd /www/wwwroot/obsidian
docker compose pull
docker compose up -d
```

`./config` 数据会保留。

```bash
docker compose down
```

删除全部数据（慎用）：

```bash
docker compose down
rm -rf /www/wwwroot/obsidian
```

---

## 十三、常见问题 FAQ

**Q1：提示 `This application requires a secure connection`？**  
A：请用 `https://服务器IP:3001` 并接受自签名证书。不要用 `http://IP:13300` 当主入口。

**Q2：按旧文映射了 `3005:3000`，容器正常但网页报错？**  
A：协议/端口不对。停掉旧容器后按第五节重建（含 `3001:3001`），用 HTTPS；挂载目录里的笔记一般还在。

```bash
docker stop obsidian && docker rm obsidian
```

**Q3：3000 / 3001 被占用？**  
A：只改左侧宿主机端口：

```yaml
ports:
  - "13300:3000"
  - "13001:3001"
```

访问改为 `https://IP:13001`。本系列默认避开宿主机 **3000**。

**Q4：黑屏或 Obsidian 崩溃？**  
A：确认 `shm_size: "1gb"`。仍异常可加：

```yaml
security_opt:
  - seccomp:unconfined
```

或 `-e PIXELFLUX_WAYLAND=false`（老 CPU / 无 AVX2）。

**Q5：文字模糊？**  
A：Selkies「视频设置」尝试 **Full Color 4:4:4**，或提高界面缩放（第九节）。

**Q6：容器名 `/obsidian` already in use？**  
A：`docker stop obsidian && docker rm obsidian`，再 `docker compose up -d`。

**Q7：权限不足？**  
A：核对 `PUID`/`PGID`；或 `sudo chown -R 1000:1000 /www/wwwroot/obsidian/config`。

**Q8：Windows PowerShell 换行报错？**  
A：不要用 CMD 的 `^`。写成一行，或用反引号 `` ` `` 换行。

**Q9：和官方桌面客户端怎么选？**  
A：单机重度写作用官方客户端；NAS / 服务器集中访问用本文容器。

---

## 十四、命令速查

```bash
docker pull docker.xuanyuan.run/linuxserver/obsidian:1.13.4

cd /www/wwwroot/obsidian
# macOS：cd ~/docker/obsidian
docker compose up -d
docker compose ps
docker compose logs -f --tail 100
# 浏览器 https://服务器IP:3001

docker compose down
```

备选：

```bash
docker run -d --name=obsidian \
  -e PUID=1000 -e PGID=1000 -e TZ=Asia/Shanghai \
  -p 13300:3000 -p 3001:3001 \
  -v /www/wwwroot/obsidian/config:/config \
  --shm-size="1gb" --restart unless-stopped \
  docker.xuanyuan.run/linuxserver/obsidian:1.13.4
```

---

## 十五、延伸阅读

- [linuxserver/obsidian 镜像页](https://xuanyuan.cloud/zh/r/linuxserver/obsidian) · [标签列表](https://xuanyuan.cloud/r/linuxserver/obsidian/tags)
- [LinuxServer 官方文档 · obsidian](https://docs.linuxserver.io/images/docker-obsidian/)
- [GitHub · linuxserver/docker-obsidian](https://github.com/linuxserver/docker-obsidian)
- [Obsidian 官网](https://obsidian.md/)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)
- 同类 Selkies 容器：[WPS Office 部署](https://xuanyuan.cloud/blog/docker-wps-office)（同样须 HTTPS）

---

## 总结

- Compose 拉起 `linuxserver/obsidian:1.13.4`，映射 **13300→3000**、**3001→3001**，并设 **`shm_size: 1gb`**。  
- 浏览器必须用 `https://服务器IP:3001`；HTTP 会报需要安全连接。  
- 切简体中文并建库后，可验证图谱、画布、日记与 Selkies 侧边栏。  
- 数据在 `./config`；默认无强认证，公网勿裸奔。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/obsidian-docker-windowslinux-10


