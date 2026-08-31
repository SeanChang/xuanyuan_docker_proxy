# Docker 一键部署 Kasm Desktop：快速搭建容器化 Ubuntu 桌面

![Docker 一键部署 Kasm Desktop：快速搭建容器化 Ubuntu 桌面](https://imgs.xuanyuan.cloud/docker/blog/kasmweb-desktop.webp)

*分类: Docker部署教程 | 标签: Kasm Desktop,KasmVNC,Docker,轩辕镜像,远程桌面,浏览器桌面,私有化部署,部署教程 | 发布时间: 2026-08-07 08:24:26*

> 云服务器、VPS、家用 NAS 多半是纯命令行 Linux：没有显示器、没有桌面环境。装带界面的安装向导、数据库客户端或办公软件，只能靠 SSH；给宿主机装一整套 GNOME / KDE，又占内存、又难和维护中的 Web / 数据库服务共存；传统 VNC / RDP 还要额外装客户端，证书与权限也更碎。

*本文基于 [kasmweb/desktop:1.18.0](https://xuanyuan.cloud/zh/r/kasmweb/desktop)，实测标签 **1.18.0**，测试平台 **Ubuntu 24.04** Linux。*

云服务器、VPS、家用 NAS 多半是 **纯命令行 Linux**：没有显示器、没有桌面环境。装带界面的安装向导、数据库客户端或办公软件，只能靠 SSH；给宿主机装一整套 GNOME / KDE，又占内存、又难和维护中的 Web / 数据库服务共存；传统 VNC / RDP 还要额外装客户端，证书与权限也更碎。

内网和小团队更实际的做法是：**宿主机继续保持无图形界面**，按需起一个容器，用本机浏览器进完整 Linux 桌面，用完可停，不污染系统。商业云桌面贵、数据出域不可控；自建整套虚拟化或编排平台对「只想临时开个桌面」又偏重。

**Kasm Desktop**（镜像 **`kasmweb/desktop`**，见 [镜像页](https://xuanyuan.cloud/zh/r/kasmweb/desktop)）是 [Kasm Workspaces](https://kasmweb.com/) 提供的 **容器化 Ubuntu 桌面**：画面经开源 **[KasmVNC](https://github.com/kasmtech/KasmVNC)** 推到浏览器，实测为 **XFCE**，预装 **Chrome** 与 **Firefox**。镜像面向 Workspaces 编排，也支持 **独立部署**——本文只跟做独立部署，一条 Compose 即可跑通。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 云服务器图形化操作 | 浏览器打开 `https://IP:6901`，登录后操作 XFCE 桌面 |
| 临时办公 / 开发 | 用内置 Chrome / Firefox、终端、文件管理器，宿主机不必装桌面 |
| 隔离试用 Linux GUI | 容器内试软件，停掉即走 |
| 评估 Kasm 生态 | 先独立跑通，再决定是否安装完整 [Kasm Workspaces](https://www.kasmweb.com/docs/latest/install.html) |

本文用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`kasmweb/desktop:1.18.0`**，以 **Docker Compose** 完成启动与浏览器登录；文末附 **`docker run` 备选**。文内附 **8** 张实测截图。

> **上手要点**  
> - **部署**：默认 **Compose**（第五节）；临时试玩见 **第八节 docker run**  
> - **标签**：**`1.18.0`**（钉死发布版；上游通常无 `latest`）  
> - **端口**：宿主机 **6901 → 容器 6901**（**必须 HTTPS**）  
> - **账号**：**`kasm_user`** / 环境变量 **`VNC_PW`**（务必改成强密码）  
> - **共享内存**：**`shm_size: 512m`**（过小易导致容器内浏览器崩溃）  
> - **桌面**：实测 **XFCE**；预装 Chrome / Firefox  
> - **暴露**：公网限制来源 IP + 强密码；自签名证书需浏览器点「高级 → 继续前往」  
> - **边界**：独立部署部分能力不完整（见第六节）；多用户 / 完整能力用 Workspaces  

镜像说明：[kasmweb/desktop](https://xuanyuan.cloud/zh/r/kasmweb/desktop) · [tags](https://xuanyuan.cloud/r/kasmweb/desktop/tags)。相关：[KasmVNC](https://github.com/kasmtech/KasmVNC) · [workspaces-images](https://github.com/kasmtech/workspaces-images) · [自定义镜像](https://www.kasmweb.com/docs/latest/how_to/building_images.html) · [问题反馈](https://github.com/kasmtech/workspaces-issues/issues)。

---

## 一、Kasm Desktop 是什么？

一句话：**Docker 里跑 Ubuntu + XFCE，浏览器打开就能用桌面**——不必给服务器装图形界面，也不必另装 VNC 客户端。

| 能力 | 说明 |
|------|------|
| 浏览器访问 | `https://IP:6901`，画面由 **KasmVNC** 推流 |
| 桌面环境 | Ubuntu Jammy + **XFCE**；预装 Chrome、Firefox |
| 部署方式 | **独立部署**（本文）或挂到 **Kasm Workspaces** 做多用户编排 |
| 自定义 | 可基于官方 Core / 默认镜像扩展，见 [Building Custom Images](https://www.kasmweb.com/docs/latest/how_to/building_images.html) |

和常见方案比：

| | Kasm Desktop（本文） | 宿主机装 GNOME/KDE | [Webtop](https://xuanyuan.cloud/blog/docker-webtop) |
|--|----------------------|---------------------|--------------------------------------------------|
| 宿主机 | 可保持无桌面 | 直接装桌面，占资源 | 可保持无桌面 |
| 访问方式 | 浏览器 + KasmVNC | 本机或另配远程 | 浏览器 + Selkies |
| 适合 | 试用 Kasm、临时 GUI | 长期本机图形环境 | LinuxServer 生态 |

**易混对象（只需跟做一个镜像）：**

| 对象 | 说明 |
|------|------|
| **`kasmweb/desktop`** | **本文跟做镜像** |
| **KasmVNC** | 推流组件，已打进镜像，**不用单独 pull** |
| **workspaces-images** | 官方构建源码库（含 `dockerfile-kasm-desktop` 等），不是第二个 Desktop 镜像 |
| **Kasm Workspaces** | 完整平台（用户、会话、策略）；本文不安装 |
| 轩辕 `/r/` 与 `/zh/r/` | **同一镜像**的概览页 / 中文简介页，不是两个仓库 |

```text
浏览器 ──HTTPS:6901──▶ KasmVNC ──▶ XFCE + Chrome / Firefox
认证：kasm_user + VNC_PW
共享内存：shm_size ≥ 512m
```

官方限时演示（非自建）：[Kasm Live Demo](https://app.kasmweb.com/#/cast/8174664824)。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 内存 | ≥ **2～4 GB** 可用（桌面 + 浏览器较吃内存） |
| 磁盘 | CONTENT SIZE 约 **1.58 GB**（DISK USAGE 约 **5.31 GB**）+ 工作目录 |
| 架构 | 实测 **amd64**；其它架构先查 [tags](https://xuanyuan.cloud/r/kasmweb/desktop/tags) |
| 端口 | 宿主机 **6901**（HTTPS） |

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

> **6901** 已被占用时，Compose 改为 `"16901:6901"`，访问 `https://IP:16901`。

---

## 三、标签怎么选

Kasm 镜像标签与 Workspaces 发版对齐，**通常不提供 `latest`**。本文钉死 **`1.18.0`**。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`1.18.0`** | 固定发布版 | **本文跟做** |
| **`1.19.0`** 等 | 更新的固定发布版 | 升级前核对说明与架构 |
| **`*-rolling*`** | 滚动重建 | 尝鲜；生产勿当默认 |
| **`develop`** | 开发测试 | 仅测试 |

完整列表：[tags](https://xuanyuan.cloud/r/kasmweb/desktop/tags)。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/kasmweb/desktop:1.18.0
```

Ubuntu 24.04 实测：

```text
1.18.0: Pulling from kasmweb/desktop
09710af56a6b: Pull complete
d3e7c97af490: Pull complete
4f4fb700ef54: Pull complete
7a22b210ffa5: Pull complete
0f18855c5fad: Pull complete
0ca4d1fe6073: Pull complete
1fcfa6cf3103: Pull complete
668a930d1f3a: Pull complete
008a1600738f: Pull complete
6e13916b2f2b: Pull complete
71985e4f0615: Pull complete
8f23b650c150: Pull complete
67c9d22e1b6e: Pull complete
4a05668217a1: Pull complete
17d47f6c67d6: Pull complete
Digest: sha256:9a94316372b8858d0238134ba507812e867fcb903d0db599c8cfd9ff8bcd0bfb
Status: Downloaded newer image for docker.xuanyuan.run/kasmweb/desktop:1.18.0
docker.xuanyuan.run/kasmweb/desktop:1.18.0
```

```bash
docker images docker.xuanyuan.run/kasmweb/desktop:1.18.0
```

```text
IMAGE                                        ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/kasmweb/desktop:1.18.0   9a94316372b8       5.31GB         1.58GB    U
```

首次拉取体积较大，请预留磁盘与时间。

---

## 五、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/kasm-desktop` |
| **macOS 实测** | **`~/docker/kasm-desktop`** |

### 5.1 创建目录

```bash
mkdir -p /www/wwwroot/kasm-desktop
chown -R "$USER:$USER" /www/wwwroot/kasm-desktop
cd /www/wwwroot/kasm-desktop
```

非 root 时给 `mkdir` / `chown` 加 `sudo`。

### 5.2 编写 docker-compose.yml

把 **`ChangeMe_StrongPass`** 换成你自己的强密码（浏览器登录密码 = `VNC_PW`）：

```bash
cat > docker-compose.yml <<'EOF'
services:
  kasm-desktop:
    image: docker.xuanyuan.run/kasmweb/desktop:1.18.0
    container_name: kasm-desktop
    restart: unless-stopped
    ports:
      - "6901:6901"
    environment:
      - VNC_PW=ChangeMe_StrongPass
    shm_size: "512m"
EOF
```

| 配置项 | 说明 |
|--------|------|
| `image` | 轩辕镜像加速坐标 + 标签 **`1.18.0`** |
| `6901:6901` | HTTPS 桌面入口 |
| `VNC_PW` | 登录密码；**务必修改**，勿把示例密码长期暴露在公网 |
| `shm_size: 512m` | **必设**；共享内存不足时容器内浏览器易崩溃 |

未挂数据卷时，桌面内文件随容器生命周期变化；要长期保留请自行备份，或改用 Workspaces 的 Persistent Profiles。

### 5.3 启动服务

```bash
docker compose pull
docker compose up -d
docker compose ps
docker compose logs -f --tail 100
```

Ubuntu 实测：

```text
[+] Running 2/2
 ✔ Network kasm-desktop_default  Created
 ✔ Container kasm-desktop        Started

NAME           IMAGE                                        COMMAND                  SERVICE        CREATED         STATUS         PORTS
kasm-desktop   docker.xuanyuan.run/kasmweb/desktop:1.18.0   "/dockerstartup/kasm…"   kasm-desktop   5 seconds ago   Up 4 seconds   4901/tcp, 5901/tcp, 0.0.0.0:6901->6901/tcp, [::]:6901->6901/tcp
```

日志关键行（节选）：

```text
Starting KasmVNC
Paste this url in your browser:
https://192.168.96.2:6901
------------------ Xfce4 window manager startup------------------
Starting XFCE
------------------ KasmVNC environment started ------------------
vncext: Listening for websocket connections on 0.0.0.0 interface(s), port 6901
Kasm User () started container id b5e456028ee1 with local IP address 192.168.96.2
```

> 日志中的 `https://192.168.96.2:6901` 是**容器网桥地址**，局域网请用 **`https://宿主机IP:6901`**（本文实测 `https://192.168.1.10:6901`）。  
> `KasmGamepadServer`、`polkit`、`colord`、`UDisks2` 等告警在独立容器里常见，一般**不影响**桌面使用。

看到 **Up**，且出现 **Starting XFCE**、**Listening … port 6901** 后，按 `Ctrl+C` 退出日志跟踪。

---

## 六、浏览器访问与使用

### 6.1 打开地址（必须 HTTPS）

| 方式 | 地址 | 说明 |
|------|------|------|
| **HTTPS** | `https://服务器IP:6901` | 自签名证书；**不要用 HTTP**（日志会出现 `non-SSL connection disallowed`） |

本文实测：`https://192.168.1.10:6901`。本机可试 `https://127.0.0.1:6901`。

首次会提示「您的连接不是私密连接」（`NET::ERR_CERT_AUTHORITY_INVALID`）：点 **高级** → **继续前往 …（不安全）**。

![Kasm Desktop：Chrome 提示连接不是私密连接，ERR_CERT_AUTHORITY_INVALID](https://imgs.xuanyuan.cloud/docker/blog/kasmweb-desktop-1.webp)

### 6.2 登录

| 项 | 值 |
|----|-----|
| 用户名 | **`kasm_user`** |
| 密码 | Compose 里的 **`VNC_PW`** |

![Kasm Desktop 登录框：https://IP:6901，用户名与密码](https://imgs.xuanyuan.cloud/docker/blog/kasmweb-desktop-2.webp)

登录后进入 **XFCE**：左侧为 **Downloads**、**Uploads**、**Google Chrome**、**Firefox**；屏幕左缘小箭头为 Kasm 控制条（剪贴板、画质等）。

![Kasm Desktop：XFCE 桌面，Downloads、Uploads、Chrome、Firefox 图标](https://imgs.xuanyuan.cloud/docker/blog/kasmweb-desktop-3.webp)

### 6.3 桌面里能做什么

双击 **Google Chrome**，可正常上网（本文打开轩辕镜像首页）：

![Kasm Desktop 内 Chrome 打开 xuanyuan.cloud 轩辕镜像首页](https://imgs.xuanyuan.cloud/docker/blog/kasmweb-desktop-4.webp)

打开桌面 **Downloads**，文件管理器路径一般为 `/home/kasm-user/Desktop/Downloads/`：

![Kasm Desktop：Thunar 打开 Desktop/Downloads，用户 kasm-user](https://imgs.xuanyuan.cloud/docker/blog/kasmweb-desktop-5.webp)

顶栏 **Applications** 可进 Terminal、File Manager、Settings 等：

![Kasm Desktop：Applications 菜单展开 Settings 子项](https://imgs.xuanyuan.cloud/docker/blog/kasmweb-desktop-6.webp)

打开 **Terminal Emulator**，执行 `uname -a`：主机名与容器 ID 一致（实测 `b5e456028ee1`）：

![Kasm Desktop 终端：uname -a 显示容器主机名与内核](https://imgs.xuanyuan.cloud/docker/blog/kasmweb-desktop-7.webp)

再执行 `top`，可看到 `Xvnc`、`ffmpeg` 及 `kasm_*` 相关进程：

![Kasm Desktop 终端：top 显示 Xvnc 与 kasm 相关进程](https://imgs.xuanyuan.cloud/docker/blog/kasmweb-desktop-8.webp)

> **独立部署限制**：官方说明音频、上传/下载、麦克风直通等在 stand-alone 下可能不完整，完整能力通常需要 [Kasm Workspaces](https://www.kasmweb.com/docs/latest/install.html)。桌面上的 Uploads / Downloads 是否可用，以你实测为准。

---

## 七、日常运维与安全

```bash
cd /www/wwwroot/kasm-desktop
docker compose ps
docker compose logs -f --tail 100
docker compose restart
docker compose stop
```

修改 `VNC_PW` 后执行 `docker compose up -d`。

公网暴露时建议：

- 防火墙仅放行可信来源访问 **6901**
- 使用强密码，并定期更换
- 有域名时前置反向代理 + 可信证书（注意 WebSocket / HTTPS 透传）

问题反馈：[workspaces-issues](https://github.com/kasmtech/workspaces-issues/issues)。

---

## 八、备选：docker run

仅临时试玩或没有 Compose 时使用；日常跟做仍用第五节。

```bash
docker run -d \
  --name kasm-desktop \
  --restart unless-stopped \
  --shm-size=512m \
  -p 6901:6901 \
  -e VNC_PW=ChangeMe_StrongPass \
  docker.xuanyuan.run/kasmweb/desktop:1.18.0
```

一次性前台试玩（退出即删容器）：

```bash
docker run --rm -it \
  --shm-size=512m \
  -p 6901:6901 \
  -e VNC_PW=ChangeMe_StrongPass \
  docker.xuanyuan.run/kasmweb/desktop:1.18.0
```

与 Compose 容器重名时先 `docker compose down` 或换 `--name`。

---

## 九、迁移 / 升级

1. `docker compose stop`，备份仍需保留的桌面文件（若有）  
2. 将 Compose 中标签改为目标版本（如 `1.19.0`），先查 [tags](https://xuanyuan.cloud/r/kasmweb/desktop/tags)  
3. `docker compose pull && docker compose up -d`  
4. 浏览器重新登录，抽查 Chrome / 终端  
5. 异常则改回旧标签再 `up -d`  

滚动标签（`*-rolling*`）会定期重建，升级前记下可回退的固定版号或 Digest。

---

## 十、常见问题 FAQ

**Q1：KasmVNC 还要再拉一个镜像吗？**  
不用。跟做 **`kasmweb/desktop`** 即可。要改预装软件再看 [workspaces-images](https://github.com/kasmtech/workspaces-images) 与 [自定义镜像](https://www.kasmweb.com/docs/latest/how_to/building_images.html)。

**Q2：打不开 `https://IP:6901`？**  
查 `docker compose ps` / `logs`；放行 **6901**；确认映射 `6901:6901`。自签名证书点「高级 → 继续前往」。**必须用 HTTPS**；HTTP 会触发 `non-SSL connection disallowed`。不要用日志里的容器网桥 IP（如 `192.168.96.2`）当访问地址。

**Q3：用户名密码是什么？**  
用户名 **`kasm_user`**；密码为 **`VNC_PW`**。改密码后执行 `docker compose up -d`。

**Q4：容器里浏览器崩溃？**  
确认 **`shm_size: "512m"`**（或更大）；内存不足时关掉多余标签页或加大宿主机可用内存。

**Q5：日志里 Gamepad / polkit / colord 报错？**  
独立部署常见告警，多数不影响使用。成功看 **Starting XFCE** 与 **Listening … port 6901**。

**Q6：为什么没有 `latest`？**  
Kasm 一般不提供 `latest`。请显式写 `1.18.0` 等固定标签。

**Q7：独立部署还是装完整 Workspaces？**  
个人试用、单桌面 → 本文。多用户、会话策略、完整音频/传文件 → 按 [Installation](https://www.kasmweb.com/docs/latest/install.html) 安装平台。

**Q8：和 Webtop 怎么选？**  
都是浏览器远程桌面。要 Kasm 生态选本文；要 LinuxServer / Selkies 看 [Webtop 教程](https://xuanyuan.cloud/blog/docker-webtop)。不必两个都装。

**Q9：拉取失败 401 / 402？**  
401：按 [登录认证](https://xuanyuan.cloud/usage/login) 检查镜像账户。402：流量用尽，需 [充值](https://xuanyuan.cloud/recharge)。其它问题见 [常见问题](https://xuanyuan.cloud/faq)。

---

## 十一、命令速查

```bash
docker pull docker.xuanyuan.run/kasmweb/desktop:1.18.0

cd /www/wwwroot/kasm-desktop
docker compose up -d
docker compose ps
docker compose logs -f --tail 100

# 浏览器 https://服务器IP:6901
# 用户 kasm_user / 密码 = VNC_PW

docker compose down
```

---

## 十二、延伸阅读

- [kasmweb/desktop 镜像页](https://xuanyuan.cloud/zh/r/kasmweb/desktop) · [标签列表](https://xuanyuan.cloud/r/kasmweb/desktop/tags)
- [GitHub · KasmVNC](https://github.com/kasmtech/KasmVNC)
- [GitHub · workspaces-images](https://github.com/kasmtech/workspaces-images)
- [Kasm Workspaces 安装](https://www.kasmweb.com/docs/latest/install.html)
- [Building Custom Images](https://www.kasmweb.com/docs/latest/how_to/building_images.html)
- [workspaces-issues](https://github.com/kasmtech/workspaces-issues/issues)
- [官方演示 Cast](https://app.kasmweb.com/#/cast/8174664824)
- [Webtop 对照教程](https://xuanyuan.cloud/blog/docker-webtop)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)

---

## 总结

- 跟做 **`kasmweb/desktop:1.18.0`**：Compose 映射 **6901**，设置 **`VNC_PW`** 与 **`shm_size: 512m`**。  
- 浏览器用 **HTTPS** 登录 **`kasm_user`**，进入 **XFCE**（Chrome / Firefox 已预装）。  
- **KasmVNC** 是推流技术、**workspaces-images** 是构建源码，都不必再单独拉 Desktop 镜像。  
- 独立部署适合试用；多用户与完整能力请上 **Kasm Workspaces**。

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/kasm-desktop-docker-deploy


