# Docker 部署 CloudDrive2：轻松搭建多云盘本地挂载平台

![Docker 部署 CloudDrive2：轻松搭建多云盘本地挂载平台](https://img.xuanyuan.dev/docker/blog/clouddrive.webp)

*分类: Docker部署教程 | 标签: CloudDrive2,Docker,轩辕镜像,多云盘,FUSE,网盘挂载,私有化部署,部署教程 | 发布时间: 2026-08-02 15:21:10*

> 百度、阿里、115、天翼、迅雷……账号越开越多，客户端也越装越多：备份脚本要写一堆 SDK，媒体库又想「直接扫某个目录」，结果文件还是散在各个网盘里。商业聚合工具要么收费，要么数据要经第三方；纯 Web 列表类工具（如 AList）适合在线浏览，却未必能把云盘挂成宿主机上的真实目录。

*本文基于 [cloudnas/clouddrive2:latest](https://xuanyuan.cloud/zh/r/cloudnas/clouddrive2)（实测 **CloudDrive2 v1.0.13**），面向 **Ubuntu 24.04** 等 Linux。*

百度、阿里、115、天翼、迅雷……账号越开越多，客户端也越装越多：备份脚本要写一堆 SDK，媒体库又想「直接扫某个目录」，结果文件还是散在各个网盘里。商业聚合工具要么收费，要么数据要经第三方；纯 Web 列表类工具（如 AList）适合在线浏览，却未必能把云盘 **挂成宿主机上的真实目录**。

**CloudDrive2** 正是为此而生的多云盘管理工具：在浏览器里添加各类云存储，再用 **FUSE** 把它们挂到容器内的 `/CloudNAS`，并通过 Docker 卷的 `shared` 传播，让你在宿主机上像操作本地硬盘一样读、写、扫库。社区维护的 Docker 镜像坐标为 **`cloudnas/clouddrive2`**（见 [镜像页](https://xuanyuan.cloud/zh/r/cloudnas/clouddrive2)）。

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`cloudnas/clouddrive2:latest`**，完成 FUSE / MountFlags 宿主机准备，Compose 启动，浏览器访问 **`:19798`**——注册登录、添加迅雷云盘、配置挂载点与 WebDAV，并浏览系统设置与会员能力边界。全程零基础可跟做，文内附 **19 张实测界面截图**。

> **上手要点**  
> - **端口**：默认 Web **19798**（常用 `network_mode: host`，此时不要再写 `ports`）  
> - **权限**：需要 `/dev/fuse` + **`privileged: true`**（或等价能力）；并启用 **shared** 挂载传播  
> - **目录**：`/Config` 存配置与缓存；`/CloudNAS` 是云盘挂载点（宿主机路径需 `:shared`）  
> - **标签**：稳定通道用本文的 `cloudnas/clouddrive2`；官方部分示例写的是 `clouddrive2-unstable`（新功能尝鲜，见第三节）  
> - **账号**：无固定默认密码；首次打开 Web 点 **注册** 创建账户后再登录  
> - **防火墙**：本机 `curl` 通但浏览器超时 → 多为 `ufw` 未放行 19798（见 FAQ）

镜像说明见 [cloudnas/clouddrive2](https://xuanyuan.cloud/zh/r/cloudnas/clouddrive2)，标签列表见 [tags](https://xuanyuan.cloud/r/cloudnas/clouddrive2/tags)。项目站点：[clouddrive2.com](https://www.clouddrive2.com/)。

---

## 一、CloudDrive2 是什么？

一句话：**CloudDrive2 = 多云盘 Web 管理 + FUSE 本地挂载**，把分散网盘收成「本机目录」。

### 1.1 它能做什么

| 能力 | 说明 |
|------|------|
| 多云接入 | OneDrive、Google Drive、百度、阿里云盘 Open、115open、天翼、迅雷、123、PikPak，以及 WebDAV / S3 / SFTP / FTP / SMB / 本地文件夹等 |
| 本地挂载 | 通过 fuse3 挂到 `/CloudNAS`，宿主机路径可直接 `ls` / 给媒体库扫描 |
| Web 管理 | 浏览器配置账号、挂载点、任务、备份；默认端口 **19798** |
| WebDAV | 内置 WebDAV 服务（如 `http://IP:19798/dav`），方便第三方客户端接入 |
| 多架构 | amd64 / arm64 / armv7（arm32） |

典型场景：家用 NAS 统一挂多网盘做备份源；给 Jellyfin / Emby 等扫「已挂载」的媒体目录；脚本与同步工具按本地路径读写云端文件。

### 1.2 和 AList 一类工具差在哪？

| | CloudDrive2 | AList 等 Web 列表 |
|--|-------------|-------------------|
| 核心形态 | **FUSE 挂载**到本机文件系统 | 主要在浏览器 / API 里列目录 |
| 适合 | 需要「路径即文件」、给其他程序直接读目录 | 在线浏览、分享、聚合入口 |
| 部署注意 | 强依赖 FUSE、privileged、shared 卷 | 一般只需端口与数据卷 |

两者可并存：AList 做 Web 入口，CloudDrive2 做本机挂载，按需求选用。

### 1.3 架构（跟做时先记住）

```text
浏览器 :19798 ──▶ CloudDrive2（Web / 任务）
                      │
                      ├── /Config     （配置、缓存，持久化）
                      └── /CloudNAS   （FUSE 云盘挂载点，:shared 传到宿主机）
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04**（本文按此写）；需支持 FUSE |
| Docker | Engine + Compose V2 |
| 权限 | 容器需访问 `/dev/fuse`；推荐 `privileged: true`；`pid: host` |
| 内存 | 建议 ≥ **1 GB** 可用（挂载多盘、缓存大时再加） |
| 磁盘 | `/Config` 与缓存会增长；云文件本身在远端，本地主要吃缓存 |
| 端口 | **19798**（host 网络时直接占用宿主机该端口） |
| 内核 | 宿主机需有 FUSE；多数发行版默认可用 |

```bash
docker --version
docker compose version
ls -l /dev/fuse
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)

# 备用地址
bash <(wget -qO- https://get.xuanyuan.dev/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

> **说明**：Windows / macOS 桌面 Docker 对 FUSE 与 shared 挂载支持有限，**强烈建议在 Linux 服务器或 NAS 上部署**。群晖等 NAS 请额外确认套件 / 内核是否允许 FUSE 与 privileged 容器。

---

## 三、标签与镜像怎么选

| 镜像 / 标签 | 说明 | 推荐 |
|-------------|------|------|
| **`cloudnas/clouddrive2:latest`** | 稳定通道（本文跟做） | **试用 / 日常首选** |
| `cloudnas/clouddrive2:<具体版本标签>` | 钉版本，便于回滚 | **生产可钉死具体 tag** |
| `cloudnas/clouddrive2-unstable` | 新功能更激进；官方部分 README 示例用此坐标 | 仅尝鲜 / 测试 |
| 架构相关标签 | 镜像页说明 x86-64→amd64、arm64、armv7→arm32 | 一般多架构 `latest` 即可；异常再指定 |

完整标签见：[xuanyuan.cloud/r/cloudnas/clouddrive2/tags](https://xuanyuan.cloud/r/cloudnas/clouddrive2/tags)。

> 镜像页中文简介里的 Compose 示例有时写成 `clouddrive2-unstable`。本文统一用稳定镜像 **`cloudnas/clouddrive2`**；若你要跟官方最新特性，把 `image:` 换成 `docker.xuanyuan.run/cloudnas/clouddrive2-unstable:latest` 即可，其余参数相同。

---

## 四、运行前准备（FUSE / shared，必做）

CloudDrive2 用 **fuse3** 挂载云存储，并把挂载点共享到宿主机。下列 **二选一**（推荐选项 1，一次配好）。

### 4.1 选项 1：Docker 服务 MountFlags=shared（推荐）

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d/

sudo tee /etc/systemd/system/docker.service.d/clear_mount_propagation_flags.conf >/dev/null <<'EOF'
[Service]
MountFlags=shared
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker
```

> 重启 Docker 会短暂中断所有容器，请选维护窗口操作。

### 4.2 选项 2：仅对挂载接收目录 make-shared

先建目录，再对该路径执行：

```bash
sudo mkdir -p /www/wwwroot/clouddrive2/{CloudNAS,Config,media}
sudo mount --make-shared /www/wwwroot/clouddrive2/CloudNAS
```

重启后若挂载传播丢失，需重新执行 `mount --make-shared`，或改用选项 1。

### 4.3 创建数据目录

```bash
sudo mkdir -p /www/wwwroot/clouddrive2/{CloudNAS,Config,media}
sudo chown -R "$USER:$USER" /www/wwwroot/clouddrive2
cd /www/wwwroot/clouddrive2
```

| 宿主机目录 | 容器内路径 | 用途 |
|------------|------------|------|
| `CloudNAS/` | `/CloudNAS:shared` | **云盘挂载点**（必填；必须 shared） |
| `Config/` | `/Config` | 配置、缓存、应用数据（必填） |
| `media/` | `/media:shared` | 可选：额外本机媒体目录 |

路径可按磁盘规划修改，但 Compose / `docker run` 里两处要一致。

---

## 五、拉取镜像（轩辕镜像加速）

```bash
cd /www/wwwroot/clouddrive2

docker pull docker.xuanyuan.run/cloudnas/clouddrive2:latest
```

实测拉取输出（**Ubuntu 24.04**）：

```text
latest: Pulling from cloudnas/clouddrive2
d4b89421a3d2: Pull complete
b782f8067a66: Pull complete
7487fd4fc677: Pull complete
2977c4b8091a: Pull complete
68b66f9e268b: Pull complete
55afa1ecc21d: Pull complete
505a07c398c6: Download complete
Digest: sha256:5491c21fb14a5774576515f8483ecdbe2780bf525985f426785b99488e7cc09d
Status: Downloaded newer image for docker.xuanyuan.run/cloudnas/clouddrive2:latest
docker.xuanyuan.run/cloudnas/clouddrive2:latest
```

确认本地镜像：

```bash
docker images | grep -i clouddrive2
```

实测可见类似：

```text
docker.xuanyuan.run/cloudnas/clouddrive2:latest   5491c21fb14a       68.8MB           21MB
```

| 官方镜像（Docker Hub） | 轩辕镜像加速拉取 |
|------------------------|------------------|
| `cloudnas/clouddrive2:latest` | `docker pull docker.xuanyuan.run/cloudnas/clouddrive2:latest` |

---

## 六、快速体验：Docker Compose（推荐）

### 6.1 编写 `docker-compose.yml`

```bash
cd /www/wwwroot/clouddrive2

cat > docker-compose.yml << 'EOF'
services:
  cloudnas:
    image: docker.xuanyuan.run/cloudnas/clouddrive2:latest
    container_name: clouddrive2
    environment:
      - TZ=Asia/Shanghai
      - CLOUDDRIVE_HOME=/Config
    volumes:
      - /www/wwwroot/clouddrive2/CloudNAS:/CloudNAS:shared
      - /www/wwwroot/clouddrive2/Config:/Config
      - /www/wwwroot/clouddrive2/media:/media:shared
    devices:
      - /dev/fuse:/dev/fuse
    restart: unless-stopped
    pid: "host"
    privileged: true
    network_mode: "host"
    # 若 host 网络不可用，可注释 network_mode，改用：
    # ports:
    #   - "19798:19798"
EOF
```

### 6.2 参数在干什么

| 项 | 作用 |
|----|------|
| `CLOUDDRIVE_HOME=/Config` | 应用数据根目录（与卷一致） |
| `/CloudNAS:shared` | 云挂载点；**缺 shared 时宿主机往往看不到挂载** |
| `/dev/fuse` | FUSE 设备 |
| `privileged: true` | 多数环境挂载必需；部分系统可试仅 `cap_add: [SYS_ADMIN]`，失败则改回 privileged |
| `pid: host` | 官方推荐 |
| `network_mode: host` | 简化网络；Web 在宿主机 **19798**。不生效时改端口映射 |

### 6.3 启动并验证

```bash
cd /www/wwwroot/clouddrive2
docker compose up -d
docker ps --filter name=clouddrive2
docker logs clouddrive2 --tail 50
```

实测 `docker ps` 可见容器 **Up**；日志出现类似：

```text
welcome to clouddrive v1.0.13 with cloudapi v1.0.13 build 26-07-23 20:58:43
database schema upgraded to version 1
database initialized
```

**先在服务器本机探测**（确认服务已监听）：

```bash
ss -lntp | grep 19798
curl -sI --max-time 5 http://127.0.0.1:19798/ | head -n 5
hostname -I
```

本机应看到 `LISTEN … *:19798`，以及 `HTTP/1.1 200 OK`。浏览器用 `hostname -I` 的局域网地址访问（本文实测为 `192.168.1.10`）：

```text
http://192.168.1.10:19798
```

若本机 `curl` 通、浏览器超时：执行 `sudo ufw allow 19798/tcp && sudo ufw reload`（见第十节 FAQ）。

---

## 七、备选：一条 `docker run`

与 Compose 等价，适合快速试用：

```bash
docker run -d \
  --name clouddrive2 \
  --restart unless-stopped \
  --env TZ=Asia/Shanghai \
  --env CLOUDDRIVE_HOME=/Config \
  -v /www/wwwroot/clouddrive2/CloudNAS:/CloudNAS:shared \
  -v /www/wwwroot/clouddrive2/Config:/Config \
  -v /www/wwwroot/clouddrive2/media:/media:shared \
  --network host \
  --pid host \
  --privileged \
  --device /dev/fuse:/dev/fuse \
  docker.xuanyuan.run/cloudnas/clouddrive2:latest
```

停止 / 删除（数据在宿主机目录，删容器不删配置）：

```bash
docker stop clouddrive2 && docker rm clouddrive2
```

---

## 八、浏览器首次使用：注册与登录

打开 `http://<主机IP>:19798`，进入登录页。全新实例没有默认管理员，先点 **注册**。

![CloudDrive2 登录页：用户名、密码，可勾选同步数据到云端与记住我](https://img.xuanyuan.dev/docker/blog/clouddrive-1.webp)

填写邮箱、密码、确认密码后点 **创建账户**。

![CloudDrive2 创建新账户：邮箱与密码，创建账户按钮](https://img.xuanyuan.dev/docker/blog/clouddrive-2.webp)

创建成功后回到登录页，会出现绿色提示「账户创建成功！请使用您的凭据登录」。填入账号密码，按需勾选 **同步数据到云端** / **记住我**，点 **登录**。

![账户创建成功后的登录页，绿色横幅提示可使用凭据登录](https://img.xuanyuan.dev/docker/blog/clouddrive-3.webp)

> **同步数据到云端**：便于多端 / 换机恢复账号侧配置；若你只想数据留在本机，可取消勾选（以产品当前策略为准）。密码请用密码管理器保存，不要用弱口令。

---

## 九、仪表盘：先认识主界面

登录后进入 **仪表盘**。左侧按「概览 / 浏览 / 管理 / 系统管理」分组；顶部显示在线状态与访问地址（实测 `192.168.1.10:19798`）。

首次未添加任何云盘时，卡片计数多为 0：文件浏览器、挂载、云存储、备份、API 令牌等；WebDAV 可能已显示默认用户数。底部有系统任务与性能监控占位。

![CloudDrive2 仪表盘：欢迎语与文件/挂载/云存储等概览卡片](https://img.xuanyuan.dev/docker/blog/clouddrive-4.webp)

| 侧栏入口 | 用途 |
|----------|------|
| **云存储** | 添加 / 管理各类网盘账号 |
| **挂载** | 把云端目录挂到容器路径（如 `/CloudNAS`） |
| **文件** | Web 内浏览已接入的存储 |
| **任务 / 备份** | 传输任务与备份策略 |
| **WebDAV** | 对外提供 WebDAV 地址 |
| **设置 / 性能 / 关于** | 缓存、界面、监控与版本信息 |

日常上手建议顺序：**云存储 → 挂载 → 文件**，需要第三方客户端时再开 WebDAV。

---

## 十、添加云存储（以迅雷云盘为例）

侧栏进入 **管理 → 云存储**，点 **+ 添加云盘**。弹窗分两块：

- **云存储**：OneDrive、Google Drive、百度网盘、阿里云盘 Open、115open、天翼云盘、迅雷云盘、123云盘、光鸭（PikPak）等  
- **本地 / 协议**：WebDAV、CloudDrive、S3、SFTP、FTP、SMB、本地文件夹  

![添加云存储弹窗：可选多家公有云盘与 WebDAV/S3/SMB 等协议](https://img.xuanyuan.dev/docker/blog/clouddrive-5.webp)

本文实测选择 **迅雷云盘**。进入授权页后点 **授权 Xunlei**，会打开身份验证窗口。

![添加迅雷云盘：点击授权 Xunlei，可展开代理设置](https://img.xuanyuan.dev/docker/blog/clouddrive-6.webp)

在授权登录页核对权限说明（用户管理、获取头像昵称与会员状态等），点 **同意**。

![迅雷授权登录：CloudDrive 请求权限，同意或取消](https://img.xuanyuan.dev/docker/blog/clouddrive-7.webp)

授权成功后，**云存储** 列表会出现卡片，展示已用 / 总量与进度条；可 **打开** 浏览、**配置** 或 **移除**。

![云存储列表：已添加迅雷云盘，显示容量与打开/配置/移除](https://img.xuanyuan.dev/docker/blog/clouddrive-8.webp)

点 **打开**，或侧栏 **浏览 → 文件**，即可像资源管理器一样进入「迅雷云盘」目录，查看名称、大小、修改时间。

![文件浏览：进入迅雷云盘目录，列表显示文件夹与修改时间](https://img.xuanyuan.dev/docker/blog/clouddrive-9.webp)

> 其他网盘流程类似：选提供商 → OAuth / 扫码 / 账号授权 → 回到云存储列表。注意各家 API 与会员策略不同，限速与权限以网盘方为准。

---

## 十一、配置挂载点（让宿主机能当本地盘用）

Web 里能浏览还不够——要把云端目录挂到 Docker 映射的 **`/CloudNAS`**，宿主机 `/www/wwwroot/clouddrive2/CloudNAS` 才能被 `ls`、媒体库、脚本使用。

侧栏 **管理 → 挂载**，点 **+ 添加挂载点**：

| 字段 | 建议 |
|------|------|
| **挂载名称** | 自定义标识，默认常见为 `CloudDrive` |
| **源目录** | 选已授权云盘下的目录（或根） |
| **挂载点** | 选容器内路径，跟做请选 **`/CloudNAS`**（或 `/CloudNAS/子目录`） |
| **只读** | 仅读取时勾选，更安全 |
| **启动时自动挂载** | 建议勾选，容器重启后自动恢复 |

![添加挂载点：挂载名称、源目录、挂载点、只读与启动时自动挂载](https://img.xuanyuan.dev/docker/blog/clouddrive-10.webp)

点挂载点旁的文件夹图标，在 **选择挂载点** 对话框里选中 `CloudNAS`（列表中还有 `Config`、`media` 等），再点 **选择**。

![选择挂载点对话框：容器内目录列表含 CloudNAS、Config、media](https://img.xuanyuan.dev/docker/blog/clouddrive-11.webp)

保存后，在宿主机验证：

```bash
ls -la /www/wwwroot/clouddrive2/CloudNAS
```

应能看到对应挂载内容。媒体库（Jellyfin / Emby 等）可把库路径指到该目录下的影片文件夹。

> 若 Web 里已挂载但宿主机仍为空：回头检查第四节 MountFlags / `make-shared`，以及 Compose 里是否写了 `:shared`。

---

## 十二、WebDAV：给其他软件用同一套存储

侧栏 **系统管理 → WebDAV**。服务可一键启用；实测地址形如：

```text
http://192.168.1.10:19798/dav
```

可开启 **CloudDrive 账户** 认证（根路径 `/`），**匿名访问** 默认关闭（公网务必保持关闭）。也可按需添加独立 WebDAV 用户。

![WebDAV 服务器：已启用，地址 http://IP:19798/dav，CloudDrive 账户认证开关](https://img.xuanyuan.dev/docker/blog/clouddrive-12.webp)

适合：把聚合后的存储挂进支持 WebDAV 的同步盘、播放器或办公软件。生产环境建议前面加 HTTPS 反向代理，不要长期明文暴露。

---

## 十三、设备、设置与性能

### 13.1 设备

**系统管理 → 设备** 显示当前运行主机（实测设备名 `ubuntu2404`、版本 **1.0.13**、平台 LINUX），用于确认实例身份与多端绑定情况。

![设备页：ubuntu2404，版本 1.0.13，属性与移除按钮](https://img.xuanyuan.dev/docker/blog/clouddrive-13.webp)

### 13.2 设置 · WebUI / 媒体

**系统 → 设置 → WebUI**：启动页、最近文件、视频缩略图、每页文件数、语言与主题等。右侧 **媒体** 可设幻灯片间隔、默认字幕编码（中文环境常见 **gb18030**）。

![设置 WebUI：启动页面、最近文件、视频缩略图与字幕编码](https://img.xuanyuan.dev/docker/blog/clouddrive-14.webp)

### 13.3 设置 · 系统 / 缓存

**设置 → 系统**：设备名称、启动延迟、目录缓存时间、临时文件路径（默认 `/Config/temp`）、文件缓冲磁盘缓存（默认 `/Config/file_buffer_cache`，实测上限 512MB、LRU）、更新通道（正式版）等。

![设置系统：目录缓存、临时文件、磁盘缓存路径与更新通道](https://img.xuanyuan.dev/docker/blog/clouddrive-15.webp)

这些路径都在已映射的 `/Config` 下，备份 `Config/` 即可带走大部分本地状态。

### 13.4 性能监控

**系统 → 性能**：实时 CPU / 内存 / 上下行，以及近 60 秒曲线与句柄、缓存等详情，便于排查卡顿或异常流量。

![性能监控：CPU 内存与网络实时指标及历史曲线](https://img.xuanyuan.dev/docker/blog/clouddrive-16.webp)

---

## 十四、个人资料、会员与关于

### 14.1 个人资料

**系统 → 个人资料**：查看邮箱与套餐、验证邮箱、启用双因素认证、修改密码 / 邮箱、退出登录。建议至少设置强密码；对外可访问时务必开 **双因素认证**。

![个人资料：账户详情、双因素认证入口、修改密码与邮箱](https://img.xuanyuan.dev/docker/blog/clouddrive-17.webp)

### 14.2 会员与功能边界

**系统 → 会员** 展示当前套餐（实测 **Basic**）及功能开关：例如云盘账号数、挂载点数、多云备份、跨云秒传、加密、WebDAV 多用户、直链等。部分高级能力在 Basic 下为「已禁用」，需按官方会员说明开通；底部可输入激活码。

![会员页：Basic 套餐与核心/高级功能启用状态列表](https://img.xuanyuan.dev/docker/blog/clouddrive-18.webp)

跟做部署与基础挂载一般在 Basic 即可完成；是否升级取决于你是否需要高级传输 / 加密等能力。

### 14.3 关于与版本

**系统 → 关于** 可核对产品名、版本（实测 **1.0.13** Build `26-07-23 20:58:43`）、CLOUDAPI / WEBUI 版本、检查更新、重启服务或清除缓存重载，并链到官网与许可协议。

![关于页：CloudDrive2 v1.0.13、检查更新与重启服务](https://img.xuanyuan.dev/docker/blog/clouddrive-19.webp)

---

## 十五、日常用法速查

| 场景 | 做法 |
|------|------|
| 当本地盘用 | 宿主机访问 `…/CloudNAS/`（或你设的挂载子路径） |
| Web 浏览 / 整理 | 侧栏 **文件**，进入对应云盘目录 |
| 媒体库扫库 | Jellyfin / Emby / Plex 库路径指向 CloudNAS 下媒体目录 |
| 第三方客户端 | 启用 WebDAV：`http://IP:19798/dav` + 账户认证 |
| 多网盘 | **云存储** 继续添加；再按需增加挂载点（受会员额度限制） |
| 换机迁移 | 备份整个 `Config/`，新机同样完成 FUSE / MountFlags 后再启动 |

> **合规与安全**：请遵守各网盘服务条款；勿把管理员 Web 端口裸奔公网，建议内网访问或加反向代理 + HTTPS + 访问控制。`privileged` 容器权限很高，务必限制谁能访问 Docker 与宿主机。

---

## 十六、升级与备份

| 操作 | 建议 |
|------|------|
| 备份 | 停容器后备份整个 `Config/`；云文件在远端，一般不必备份 CloudNAS 内容本身 |
| 升级 | `docker compose pull && docker compose up -d`；或在 **关于** 页检查更新；也可钉 [tags](https://xuanyuan.cloud/r/cloudnas/clouddrive2/tags) 后改 `image:` |
| 回滚 | 改回旧 tag，重新 `up -d`；保留 `Config/` |
| 换机 | 拷贝 `Config/`（及 Compose），新机完成 FUSE / MountFlags 后再启动 |

```bash
cd /www/wwwroot/clouddrive2
docker compose pull
docker compose up -d
```

---

## 十七、常见问题 FAQ

**Q1：容器 Up 了，但宿主机 `CloudNAS` 是空的？**  
多数是 **未启用 shared 挂载传播**，或 Web 里尚未添加挂载点。检查第四节 MountFlags / `make-shared`；Compose 卷后缀必须是 `:shared`；并在 **挂载** 页完成源目录 → `/CloudNAS`。

**Q2：日志提示 fuse / Operation not permitted？**  
确认映射了 `/dev/fuse`，并使用 `privileged: true`。部分发行版仅加 `SYS_ADMIN` 不够。

**Q3：浏览器 `ERR_CONNECTION_TIMED_OUT` / 打不开 :19798？**  

Ubuntu 24.04 实测：容器已 Up、本机 `curl http://127.0.0.1:19798/` 返回 **200 OK**，但浏览器超时——原因是 **`ufw` 已启用却未放行 19798**。放行后即可访问。

按顺序排查：

1. **IP**：用 `hostname -I` 的局域网地址（本文示例环境为 `192.168.1.10`；换机器勿照抄）。  
2. **本机是否已监听**：`ss -lntp | grep 19798`；`curl -sI http://127.0.0.1:19798/`。本机都不通 → 看 `docker logs clouddrive2`。  
3. **防火墙（最常见）**：

```bash
sudo ufw status
sudo ufw allow 19798/tcp
sudo ufw reload
```

云主机还要在 **安全组** 放行入站 **19798/tcp**。  
4. **仍不通**：去掉 `network_mode: host`，改映射端口后重建：

```yaml
    # network_mode: "host"
    ports:
      - "19798:19798"
```

```bash
docker compose down && docker compose up -d
```

**Q4：和镜像页示例的 `clouddrive2-unstable` 有何区别？**  
`clouddrive2` 偏稳定；`clouddrive2-unstable` 更新更勤、功能可能更新也更易变。本文用稳定坐标；尝鲜可换 unstable。

**Q5：群晖 / 飞牛上能跑吗？**  
理论上可以，但取决于 NAS 是否提供 FUSE、是否允许 privileged。若套件限制严格，优先考虑带完整 Docker 的 Linux 主机。

**Q6：拉取很慢或失败？**  
确认使用 `docker.xuanyuan.run/cloudnas/clouddrive2:…`；报错码对照 [轩辕镜像常见问题](https://xuanyuan.cloud/faq)。**不要**一失败就改回直连官方源作为默认策略。

**Q7：可以去掉 privileged 吗？**  
部分环境可试：

```yaml
    # privileged: true
    cap_add:
      - SYS_ADMIN
```

若挂载失败，改回 `privileged: true`。

**Q8：Basic 会员不够用？**  
在 **会员** 页查看当前额度与禁用项；按需购买 / 激活官方套餐。基础「添加云盘 + 挂载 + Web 浏览」通常可先在 Basic 验证流程。

---

## 十八、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/cloudnas/clouddrive2:latest

# Compose 启停
cd /www/wwwroot/clouddrive2
docker compose up -d
docker compose ps
docker compose logs -f --tail=100
docker compose down

# 宿主机看挂载
ls -la /www/wwwroot/clouddrive2/CloudNAS

# 防火墙（实测必需）
sudo ufw allow 19798/tcp && sudo ufw reload

# Web
# http://<主机IP>:19798
# WebDAV 示例：http://<主机IP>:19798/dav
```

---

## 十九、延伸阅读

- [cloudnas/clouddrive2 镜像页（中文）](https://xuanyuan.cloud/zh/r/cloudnas/clouddrive2)
- [标签列表](https://xuanyuan.cloud/r/cloudnas/clouddrive2/tags)
- [CloudDrive 官网](https://www.clouddrive2.com/)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)
- [轩辕镜像常见问题](https://xuanyuan.cloud/faq)
- 同类参考：[Nextcloud AIO 部署教程](https://xuanyuan.cloud/blog/docker-nextcloud-aio)（私有云同步协作，定位不同）

---

## 总结

- CloudDrive2 用 Docker + FUSE 把多网盘 **挂到本机目录**，浏览器 **19798** 管理。  
- 部署关键三件套：**FUSE 设备、privileged、CloudNAS 的 shared 卷**（外加 MountFlags 或 make-shared）；Ubuntu 上别忘了 **`ufw allow 19798`**。  
- 用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 `cloudnas/clouddrive2:latest`，Compose 一键启动。  
- 用法主线：**注册登录 → 云存储授权 → 挂载到 `/CloudNAS` →（可选）WebDAV / 设置与会员**。

