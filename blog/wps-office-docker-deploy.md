# 不用安装 Office：Docker 部署 WPS，浏览器即可编辑 Word、Excel、PPT

![不用安装 Office：Docker 部署 WPS，浏览器即可编辑 Word、Excel、PPT](https://img.xuanyuan.dev/docker/blog/wps-office.png)

*分类: Docker部署教程 | 标签: WPS Office,Docker,轩辕镜像,在线办公,远程桌面,私有化部署,部署教程 | 发布时间: 2026-07-13 03:49:15*

> 零基础教程：WPS Office 容器是什么、轩辕镜像加速拉取 linuxserver/wps-office:version-11.1.0.11723-2、Docker Compose 部署、3000 端口冲突与 HTTPS 访问、中文界面与文件上传编辑实测。

*本文基于 [linuxserver/wps-office:version-11.1.0.11723-2](https://xuanyuan.cloud/zh/r/linuxserver/wps-office) 镜像，Ubuntu 24.04 服务器实测*

云服务器、NAS 上想编辑 Word、Excel、PPT，又不想装完整桌面或买云办公订阅？**linuxserver/wps-office** 把 **WPS Office 办公套件** 装进 Docker 容器，通过 **浏览器** 远程操作——宿主机保持纯命令行，你在本机打开网页就是完整 WPS 界面，支持文档、表格、演示和 PDF。

本文带你完成一次 **WPS Office Docker Compose 部署**：轩辕镜像加速拉取、检查端口冲突、编写 `docker-compose.yml`、HTTPS 登录、新建文档、侧边栏上传文件并编辑——全程 Ubuntu 24.04 实测，文末 **FAQ 含端口占用、HTTPS 强制与 AVX2 兼容**，附 **9 张截图**。

国内用户从 Docker Hub 拉取 `linuxserver/wps-office` 可能较慢，本文使用 [轩辕镜像](https://xuanyuan.cloud) 加速。官方文档见 [linuxserver/docker-wps-office](https://github.com/linuxserver/docker-wps-office)，镜像页 [轩辕镜像 WPS Office](https://xuanyuan.cloud/zh/r/linuxserver/wps-office)。

![浏览器中的 WPS Office 中文主界面](https://img.xuanyuan.dev/docker/blog/wps-office-4.png)

*图 1：部署成功后，浏览器里就是完整 WPS Office 中文界面*

## 一、WPS Office 容器是什么？

**linuxserver/wps-office** 是 [LinuxServer.io](https://www.linuxserver.io/) 维护的 **容器化 WPS Office 办公套件**，基于 Selkies 技术把 GUI 画面编码后通过 Web 推流到浏览器。核心特点：

| 能力 | 说明 |
|------|------|
| 浏览器访问 | 打开 `https://服务器IP:3001` 即可操作 WPS，无需 VNC 客户端 |
| 全功能办公 | 支持 Writer（文字）、Spreadsheet（表格）、Presentation（演示）、PDF |
| 宿主机无桌面 | WPS 跑在 **容器内**，宿主机保持纯 CLI |
| 中文界面 | 通过 `LC_ALL=zh_CN.UTF-8` 设置中文 |
| 文件传输 | 侧边栏支持浏览器与容器之间 **上传 / 下载** 文件 |
| 持久化 | `/config` 卷保存用户配置、桌面文件与文档 |

典型使用场景：

- **云服务器 / VPS** 临时编辑合同、报告、表格，无需本地装 Office
- **内网办公** 在可信局域网中共享在线办公环境
- **低资源设备** 服务器或 NAS 上按需启动，用完即关
- **开发测试** 在隔离容器里验证 Office 文档兼容性

> **与 OnlyOffice / LibreOffice 的区别**：本镜像提供 **完整 WPS 桌面客户端体验**（非纯 Web 协作套件），通过 Selkies 推流实现远程 GUI。适合个人或小团队内网使用，不适合高并发协作编辑。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 操作系统 | Linux（本文 Ubuntu 24.04） |
| Docker | 已安装 Docker 与 Docker Compose V2 |
| 架构 | **x86-64（amd64）**；arm64 不支持 |
| 内存 | ≥ 2 GB（推荐 4 GB；WPS + 编码推流较吃内存） |
| CPU | 双核即可；**无 AVX2 的老 CPU 需加 `PIXELFLUX_WAYLAND=false`** |
| 磁盘 | ≥ 5 GB（镜像 + `/config` 持久化） |
| 端口 | **13000**（HTTP，本文实测）、**3001**（HTTPS，推荐） |

验证 Docker：

```bash
docker --version
docker compose version
```

若尚未安装 Docker，可使用轩辕镜像一键脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

更多安装说明见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 三、拉取镜像

本文使用固定版本标签 **`version-11.1.0.11723-2`**（WPS 11.1.0），便于复现与回滚。生产环境也可换 `latest`。

```bash
docker pull docker.xuanyuan.run/linuxserver/wps-office:version-11.1.0.11723-2
```

Ubuntu 24.04 实测完整输出：

```text
version-11.1.0.11723-2: Pulling from linuxserver/wps-office
ebd99e197b6d: Pull complete
8eb9195ac8d0: Pull complete
a4c5c5a5606a: Pull complete
df4acc3037f5: Pull complete
b7c8f1ef6a4b: Pull complete
8d85ba752c94: Pull complete
80a0bd48ddad: Pull complete
c61b8d29a329: Pull complete
405e531e7e9d: Pull complete
5247bc98f40d: Pull complete
36227c001b4f: Pull complete
b23116718359: Pull complete
fd89c7f2f53f: Pull complete
aefea6f5b66e: Pull complete
adcfd3ce330f: Pull complete
40cf526054ff: Pull complete
147ddd33c7b6: Pull complete
b0684693caf6: Download complete
54fc262d1467: Download complete
Digest: sha256:c72d29b8f113f381ec7f62a9f1936c1f5ef4eda112b32df2ce3169bc9cbc2b96
Status: Downloaded newer image for docker.xuanyuan.run/linuxserver/wps-office:version-11.1.0.11723-2
docker.xuanyuan.run/linuxserver/wps-office:version-11.1.0.11723-2
```

> 首次拉取体积较大（数 GB），国内建议全程使用 `docker.xuanyuan.run` 加速域。

---

## 四、部署前：检查端口与用户 ID

启动前先确认宿主机端口未被占用，并记录 `PUID` / `PGID`：

```bash
ss -tlnp | grep -E ':3000|:3001'
id
```

本文实测结果：

```text
LISTEN 0 511 0.0.0.0:3000 0.0.0.0:* users:(("PM2 v7.0.1: God",pid=1266811,fd=3))

uid=0(root) gid=0(root) groups=0(root)
```

| 项目 | 结论 |
|------|------|
| **3000** | 被 **PM2** 占用 → 宿主机改用 **13000** 映射 |
| **3001** | **空闲** → 直接使用 **3001** |
| **PUID/PGID** | root 用户 → **0 / 0** |

---

## 五、Docker Compose 部署

### 5.1 创建目录

```bash
mkdir -p /www/wwwroot/wps-office/config
cd /www/wwwroot/wps-office
```

> 当前为 root，无需 `chown`；若改用普通用户部署，执行 `chown -R $(id -u):$(id -g) config`。

### 5.2 编写 docker-compose.yml

```yaml
services:
  wps-office:
    image: docker.xuanyuan.run/linuxserver/wps-office:version-11.1.0.11723-2
    container_name: wps-office
    environment:
      - PUID=0
      - PGID=0
      - TZ=Asia/Shanghai
      - LC_ALL=zh_CN.UTF-8
      - CUSTOM_USER=admin
      - PASSWORD=你的强密码
      - PIXELFLUX_WAYLAND=false
    volumes:
      - ./config:/config
    ports:
      - "13000:3000"
      - "3001:3001"
    shm_size: "1gb"
    restart: unless-stopped
```

| 配置项 | 说明 |
|--------|------|
| `PUID` / `PGID` | 与宿主机用户一致，运行 `id` 查看；避免 `/config` 权限错乱 |
| `CUSTOM_USER` / `PASSWORD` | **HTTP 基本认证**，务必设置；默认无认证极不安全 |
| `LC_ALL=zh_CN.UTF-8` | WPS 中文界面 |
| `shm_size: 1gb` | **必设**，Electron 应用必需，否则易崩溃 |
| `13000:3000` | 避开宿主机 **3000** 被 PM2 等占用 |
| `3001:3001` | HTTPS 推荐访问方式 |
| `PIXELFLUX_WAYLAND=false` | 老 CPU 无 AVX2 时强制 X11，更稳定 |

### 5.3 启动服务

```bash
docker compose up -d
docker compose logs -f wps-office
```

Ubuntu 24.04 实测启动输出：

```text
[+] Running 2/2
 ✔ Network wps-office_default  Created
 ✔ Container wps-office        Started
```

成功时日志关键行：

```text
[ls.io-init] CPU does not support AVX2. Falling back to X11
INFO:selkies.__main__:Starting Selkies in 'websockets' mode.
INFO:data_websocket:Data WebSocket Server listening on port 8082
INFO:main:SelkiesStreamingApp initialized: encoder=x264enc, display=1024x768
```

看到 `Falling back to X11` 表示 CPU 无 AVX2，已自动回退到 X11 模式，**可正常使用**。按 `Ctrl+C` 退出日志跟踪，容器继续在后台运行。

---

## 六、浏览器访问与登录

### 6.1 访问地址

| 方式 | 地址 | 说明 |
|------|------|------|
| HTTP | `http://服务器IP:13000` | 能打开登录框，但 WPS 可能提示需 HTTPS |
| **HTTPS（推荐）** | `https://服务器IP:3001` | 自签名证书，需手动信任；完整功能 |

本文实测地址：`https://192.168.1.10:3001`

### 6.2 HTTP 基本认证

浏览器会弹出登录框，输入 `docker-compose.yml` 中的 `CUSTOM_USER` 与 `PASSWORD`：

![HTTP 基本认证登录框](https://img.xuanyuan.dev/docker/blog/wps-office-1.png)

*图 2：访问 `http://192.168.1.10:13000` 时的 HTTP 基本认证界面*

### 6.3 必须使用 HTTPS

若通过 HTTP 进入后看到以下报错，说明 **WPS 强制要求 HTTPS**（WebCodecs 等现代浏览器特性仅在安全连接下可用）：

![HTTPS 强制要求报错](https://img.xuanyuan.dev/docker/blog/wps-office-2.png)

*图 3：HTTP 访问时提示 "This application requires a secure connection (HTTPS)"*

**处理**：改用 `https://服务器IP:3001` 访问。HTTPS 登录框如下：

![HTTPS 基本认证登录框](https://img.xuanyuan.dev/docker/blog/wps-office-3.png)

*图 4：访问 `https://192.168.1.10:3001` 时的 HTTPS 登录界面*

证书警告：镜像使用 **自签名证书**，内网可点「高级 → 继续访问」；公网建议 Nginx 反代并配置正式证书。

---

## 七、WPS Office 使用指南

### 7.1 主界面

登录成功后进入 **WPS Office 中文主界面**（见文首图 1），左侧可新建/打开文档，中间显示最近文件列表。

### 7.2 打开文件

点击 **打开**，可按类型筛选文字、表格、演示、PDF：

![打开文件对话框](https://img.xuanyuan.dev/docker/blog/wps-office-5.png)

*图 5：打开文件对话框，支持按文档类型筛选*

### 7.3 新建文档

点击 **新建**，可选择文字、表格、演示、PDF 及在线文档类型；左侧 **本地 → 桌面** 可浏览容器内桌面目录：

![新建文档界面](https://img.xuanyuan.dev/docker/blog/wps-office-6.png)

*图 6：新建界面——支持文字、表格、演示、PDF 及思维导图等*

### 7.4 创建 Word 文档

选择 **文字 → 空白文档** 或从模板创建：

![WPS Writer 新建文档模板](https://img.xuanyuan.dev/docker/blog/wps-office-7.png)

*图 7：WPS 文字新建页——空白文档与商业计划书等模板*

### 7.5 侧边栏上传文件

Selkies 侧边栏 **Files** 面板支持从浏览器上传文件到容器。本文实测上传 `开户确认书.docx` 到 `/config/Desktop/`，日志显示：

```text
INFO:data_websocket:Upload started: /config/Desktop/开户确认书.docx
INFO:data_websocket:Upload finished: /config/Desktop/开户确认书.docx
```

上传后在 **本地 → 桌面** 可见该文件：

![桌面上的已上传文档](https://img.xuanyuan.dev/docker/blog/wps-office-8.png)

*图 8：侧边栏上传后，桌面目录出现「开户确认书.docx」*

### 7.6 编辑文档

双击打开文档，即可在浏览器中完整编辑 Word 内容：

![编辑 Word 文档](https://img.xuanyuan.dev/docker/blog/wps-office-9.png)

*图 9：在 WPS Writer 中编辑「开户确认书.docx」*

> 底部若提示 **「缺失字体」**，属 Linux 容器常见现象，一般不影响编辑；需要特定字体可通过 `proot-apps` 或挂载字体目录解决。

---

## 八、环境变量与卷速查

| 变量 | 说明 |
|------|------|
| `PUID` / `PGID` | 文件所有者 UID/GID |
| `TZ` | 时区，如 `Asia/Shanghai` |
| `LC_ALL` | 语言，如 `zh_CN.UTF-8`（中文）、`ja_JP.UTF-8`（日文） |
| `CUSTOM_USER` / `PASSWORD` | HTTP 基本认证（**强烈建议设置**） |
| `PIXELFLUX_WAYLAND` | `false` 强制 X11；老 CPU 必备 |
| `SUBFOLDER` | 反代子路径，如 `/wps/`（需前后斜杠） |
| `TITLE` | 浏览器页面标题，默认 `Selkies` |

| 容器路径 | 说明 |
|----------|------|
| `/config` | 持久化配置、用户主目录 |
| `/config/Desktop` | 桌面目录，侧边栏上传默认落点 |

---

## 九、安全提醒

官方文档强调：

- **默认无认证**——未设 `PASSWORD` 时任何人可访问 WPS 界面。
- Web 界面含 **无密码 sudo 终端**，有 GUI 访问权的人等同容器内 root。
- **不要裸奔公网**；内网也建议强密码 + 防火墙限制 IP。
- 完整音视频等功能依赖 **HTTPS**。
- 公网暴露请用 **Nginx / SWAG 反代 + 正式证书 + 更强认证**。

---

## 十、常见问题与踩坑 FAQ

**Q1：`3000` 端口被占用，启动报错 `address already in use`？**

**原因**：宿主机 3000 已被其他服务占用（本文实测为 PM2）。

**处理**：只改 **左侧宿主机端口**，容器内仍用 3000 / 3001：

```yaml
ports:
  - "13000:3000"
  - "3001:3001"
```

排查占用：

```bash
ss -tlnp | grep :3000
```

**Q2：页面提示需要 HTTPS，HTTP 无法使用？**

WPS Office 基于 Selkies，**强制 HTTPS** 才能完整运行。请访问 `https://服务器IP:3001`，并接受自签名证书。

**Q3：日志里 `CPU does not support AVX2. Falling back to X11` 有影响吗？**

无 AVX2 的老 CPU 会自动回退 X11，**可正常使用**。建议同时设置 `PIXELFLUX_WAYLAND=false`。

**Q4：界面黑屏或 WPS 崩溃？**

确认 `shm_size: "1gb"` 已设置。若仍有问题，可尝试加：

```yaml
security_opt:
  - seccomp=unconfined
```

**Q5：文字模糊怎么办？**

在 Selkies 侧边栏开启 **FullColor 4:4:4** 编码，或切换为 **jpeg** 编码模式。

**Q6：如何访问宿主机文件？**

在 `volumes` 增加挂载，例如 `- /www/wwwroot:/data`，重启后在 WPS 中通过打开文件访问 `/data`。

**Q7：如何升级 WPS Office？**

```bash
cd /www/wwwroot/wps-office
docker compose pull
docker compose down
docker compose up -d
```

`/config` 卷数据保留。

**Q8：如何停止与卸载？**

```bash
cd /www/wwwroot/wps-office
docker compose down

# 删除全部数据（慎用）
docker compose down
rm -rf /www/wwwroot/wps-office
```

**Q9：与 Docker Hub 官方镜像的关系？**

功能相同。`docker.xuanyuan.run/linuxserver/wps-office` 为轩辕镜像加速的同步版，便于国内拉取。

---

## 十一、命令速查

| 操作 | 命令 |
|------|------|
| 拉取镜像 | `docker pull docker.xuanyuan.run/linuxserver/wps-office:version-11.1.0.11723-2` |
| 检查端口 | `ss -tlnp \| grep -E ':3000\|:3001'` |
| 启动 | `cd /www/wwwroot/wps-office && docker compose up -d` |
| 查看日志 | `docker compose logs -f wps-office` |
| HTTPS 访问 | `https://服务器IP:3001` |
| HTTP 访问 | `http://服务器IP:13000` |
| 进入容器 | `docker exec -it wps-office /bin/bash` |
| 停止服务 | `cd /www/wwwroot/wps-office && docker compose down` |

---

## 十二、延伸阅读

| 主题 | 链接 |
|------|------|
| LinuxServer GitHub | https://github.com/linuxserver/docker-wps-office |
| Docker Hub | https://hub.docker.com/r/linuxserver/wps-office |
| 轩辕镜像页 | https://xuanyuan.cloud/zh/r/linuxserver/wps-office |
| 同类：Webtop 远程桌面 | https://xuanyuan.cloud/blog/docker-webtop |
| 轩辕镜像 | https://xuanyuan.cloud |

---

**总结**：linuxserver/wps-office = **不给宿主机装 Office，浏览器里就是 WPS 办公环境**。`docker compose up -d` → `https://服务器IP:3001` 登录 → 新建/打开/编辑文档，侧边栏可上传文件到桌面。踩坑记住三点：**3000 改映射 13000**、**必须用 HTTPS（3001）**、**老 CPU 加 PIXELFLUX_WAYLAND=false**。按需启停，用完 `docker compose down` 释放内存。

