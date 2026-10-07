# Docker 部署 CloudDrive2：轻松搭建多云盘本地挂载平台

![Docker 部署 CloudDrive2：轻松搭建多云盘本地挂载平台](https://imgs.xuanyuan.cloud/docker/blog/clouddrive.webp)

*分类: Docker部署教程 | 标签: CloudDrive2,Docker,轩辕镜像,多云盘,FUSE,网盘挂载,私有化部署,部署教程 | 发布时间: 2026-08-02 15:21:10*

> CloudDrive2 是多云盘管理工具，可在浏览器里接入网盘，再用 FUSE 挂到本机目录。本文将介绍如何通过 Docker Compose 部署 cloudnas/clouddrive2，轻松搭建可自托管的多云盘本地挂载平台，适合 NAS 统一备份、媒体库扫目录与按本地路径读写云端文件等场景。

*本文基于 [cloudnas/clouddrive2:latest](https://xuanyuan.cloud/zh/r/cloudnas/clouddrive2)，以 **latest** 拉取，实测 CloudDrive2 **v1.0.13** / WEBUI 3.0.13，测试平台 **Ubuntu 24.04** Linux。*

百度、阿里、115、天翼、迅雷……账号越开越多，客户端也越装越多：备份脚本要写一堆 SDK，媒体库又想「直接扫某个目录」，结果文件还是散在各个网盘里。商业聚合工具要么收费，要么数据要经第三方；纯 Web 列表类工具（如 AList）适合在线浏览，却未必能把云盘 **挂成宿主机上的真实目录**。

把网盘再交给另一套商业聚合，授权和目录还要过一道第三方。自己有一台跑 Docker 的 Ubuntu 时，缺的是：配置和缓存留在本机、云盘能出现在宿主机目录里、浏览器打开就能加网盘。

**CloudDrive2**（[官网](https://www.clouddrive2.com/)、[镜像页](https://xuanyuan.cloud/zh/r/cloudnas/clouddrive2)）是多云盘管理工具：在浏览器里添加各类云存储，再用 **FUSE** 把它们挂到容器内的 `/CloudNAS`，并通过 Docker 卷的 `shared` 传播，让你在宿主机上像操作本地硬盘一样读、写、扫库。社区维护的 Docker 镜像是 **`cloudnas/clouddrive2`**。

跑通之后，可以在浏览器里注册账户、接入迅雷等网盘，再把云端目录挂到宿主机路径，让媒体库和脚本按本地目录读取。配置和缓存写在本机目录里。

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

### 1.3 架构（部署前先看这三处）

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
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```

备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见[轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

> **说明**：Windows / macOS 桌面 Docker 对 FUSE 与 shared 挂载支持有限，**强烈建议在 Linux 服务器或 NAS 上部署**。群晖等 NAS 请额外确认套件 / 内核是否允许 FUSE 与 privileged 容器。

---

## 三、标签与镜像怎么选

| 镜像 / 标签 | 说明 | 推荐 |
|-------------|------|------|
| **`cloudnas/clouddrive2:latest`** | 稳定通道。本文拉取这个标签，实测界面为 v1.0.13 | **本文采用** |
| `cloudnas/clouddrive2:<具体版本标签>` | 固定为具体版本，便于回滚 | 需要固定版本时选用 |
| `cloudnas/clouddrive2-unstable` | 新功能更激进；官方部分 README 示例用此坐标 | 仅尝鲜 / 测试 |
| 架构相关标签 | 镜像页说明 x86-64→amd64、arm64、armv7→arm32 | 一般多架构 `latest` 即可；异常再指定 |

完整标签见：[xuanyuan.cloud/r/cloudnas/clouddrive2/tags](https://xuanyuan.cloud/r/cloudnas/clouddrive2/tags)。

镜像页中文简介里的 Compose 示例有时写成 `clouddrive2-unstable`。本文使用稳定镜像 **`cloudnas/clouddrive2`**。若要试用该示例里的新特性，把 `image:` 换成 `docker.xuanyuan.run/cloudnas/clouddrive2-unstable:latest`，其余参数保持相同。

---

## 四、运行前准备（FUSE / shared，必做）

CloudDrive2 用 **fuse3** 挂载云存储，并把挂载点共享到宿主机。下列 **二选一**（推荐选项 1，一次配好）。

### 4.1 选项 1：Docker 服务 MountFlags=shared（推荐）

重启 Docker 会短暂停止这台机器上的全部容器。请在维护窗口执行下面的命令。

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d/

sudo tee /etc/systemd/system/docker.service.d/clear_mount_propagation_flags.conf >/dev/null <<'EOF'
[Service]
MountFlags=shared
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker
```

### 4.2 选项 2：仅对挂载接收目录 make-shared

选这个做法之前先知道限制：机器重启后，挂载传播可能会丢失。丢失后要重新执行 `mount --make-shared`，或者改回选项 1。

先创建目录。再对 `CloudNAS` 执行 `mount --make-shared`。

```bash
sudo mkdir -p /www/wwwroot/clouddrive2/{CloudNAS,Config,media}
sudo mount --make-shared /www/wwwroot/clouddrive2/CloudNAS
```

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

路径可以按磁盘规划修改。修改之后，Compose 和 `docker run` 里的宿主机路径必须与这里相同。

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

**先在服务器本机确认端口已在监听。**

```bash
ss -lntp | grep 19798
curl -sI --max-time 5 http://127.0.0.1:19798/ | head -n 5
hostname -I
```

本机应看到 `LISTEN … *:19798`，以及 `HTTP/1.1 200 OK`。

再用 `hostname -I` 得到的局域网地址打开浏览器。本文实测地址是：

```text
http://192.168.1.10:19798
```

本机 `curl` 返回 200、浏览器仍然超时时，再放行防火墙。步骤见 FAQ「浏览器打不开 :19798」。

---

## 七、备选：一条 `docker run`

这一节只用于临时试用。

第六节的 Compose 已经在运行时，先在 `/www/wwwroot/clouddrive2` 执行 `docker compose down`。

不先停止时，容器名 `clouddrive2` 会冲突。

```bash
docker run -d 
  --name clouddrive2 
  --restart unless-stopped 
  --env TZ=Asia/Shanghai 
  --env CLOUDDRIVE_HOME=/Config 
  -v /www/wwwroot/clouddrive2/CloudNAS:/CloudNAS:shared 
  -v /www/wwwroot/clouddrive2/Config:/Config 
  -v /www/wwwroot/clouddrive2/media:/media:shared 
  --network host 
  --pid host 
  --privileged 
  --device /dev/fuse:/dev/fuse 
  docker.xuanyuan.run/cloudnas/clouddrive2:latest
```

停止 / 删除（数据在宿主机目录，删容器不删配置）：

```bash
docker stop clouddrive2 && docker rm clouddrive2
```

---

## 八、浏览器首次使用：注册与登录

打开页面前，把地址中的主机 IP 换成 `hostname -I` 的结果。本文实测地址是 `http://192.168.1.10:19798`。

全新实例没有默认管理员。

1. 打开 `http://<主机IP>:19798`。
2. 在登录页点击「注册」。

   ![CloudDrive2 登录页：用户名、密码，可勾选同步数据到云端与记住我](https://img.xuanyuan.dev/docker/blog/clouddrive-1.webp)

3. 填写邮箱、密码和确认密码。
4. 点击「创建账户」。

   ![CloudDrive2 创建新账户：邮箱与密码，创建账户按钮](https://img.xuanyuan.dev/docker/blog/clouddrive-2.webp)

创建成功后，页面回到登录页，并出现绿色提示「账户创建成功！请使用您的凭据登录」。

5. 填入刚创建的账号和密码。
6. 按需要勾选「同步数据到云端」和「记住我」。
7. 点击「登录」。

   ![账户创建成功后的登录页，绿色横幅提示可使用凭据登录](https://img.xuanyuan.dev/docker/blog/clouddrive-3.webp)

勾选「同步数据到云端」后，账号侧配置可以在多台设备或换机时恢复。只想把数据留在本机时，取消勾选。是否仍会同步，以产品当前说明为准。密码放进密码管理器，不要使用弱口令。

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

日常使用按这个顺序做：

1. 打开「云存储」。
2. 添加网盘。
3. 打开「挂载」。
4. 把云端目录挂到本机路径。
5. 打开「文件」，确认目录能浏览。

需要第三方客户端时，再打开「WebDAV」。

---

## 十、添加云存储（以迅雷云盘为例）

1. 打开侧栏「管理 → 云存储」。
2. 点击「+ 添加云盘」。

弹窗分两块：

- 「云存储」：OneDrive、Google Drive、百度网盘、阿里云盘 Open、115open、天翼云盘、迅雷云盘、123云盘、光鸭（PikPak）等
- 「本地 / 协议」：WebDAV、CloudDrive、S3、SFTP、FTP、SMB、本地文件夹

![添加云存储弹窗：可选多家公有云盘与 WebDAV/S3/SMB 等协议](https://img.xuanyuan.dev/docker/blog/clouddrive-5.webp)

本文实测选择「迅雷云盘」。

3. 在授权页点击「授权 Xunlei」。

系统随后打开身份验证窗口。

![添加迅雷云盘：点击授权 Xunlei，可展开代理设置](https://img.xuanyuan.dev/docker/blog/clouddrive-6.webp)

4. 核对权限说明。说明里包括用户管理、获取头像昵称和会员状态。
5. 点击「同意」。

![迅雷授权登录：CloudDrive 请求权限，同意或取消](https://img.xuanyuan.dev/docker/blog/clouddrive-7.webp)

授权成功后，「云存储」列表出现这张云盘卡片，并显示已用空间、总容量和进度条。卡片上可以「打开」「配置」或「移除」。

![云存储列表：已添加迅雷云盘，显示容量与打开/配置/移除](https://img.xuanyuan.dev/docker/blog/clouddrive-8.webp)

6. 点击「打开」，或打开侧栏「浏览 → 文件」。

随后进入「迅雷云盘」目录，可以查看名称、大小和修改时间。

![文件浏览：进入迅雷云盘目录，列表显示文件夹与修改时间](https://img.xuanyuan.dev/docker/blog/clouddrive-9.webp)

其他网盘按同样的顺序做：先选提供商，再完成 OAuth、扫码或账号授权，然后回到云存储列表。各家 API 和会员策略不同。限速和权限以网盘方为准。

---

## 十一、配置挂载点（让宿主机能当本地盘用）

Web 里能浏览还不够——要把云端目录挂到 Docker 映射的 **`/CloudNAS`**，宿主机 `/www/wwwroot/clouddrive2/CloudNAS` 才能被 `ls`、媒体库、脚本使用。

侧栏 **管理 → 挂载**，点 **+ 添加挂载点**：

| 字段 | 建议 |
|------|------|
| **挂载名称** | 自定义标识，默认常见为 `CloudDrive` |
| **源目录** | 选已授权云盘下的目录（或根） |
| **挂载点** | 选容器内路径。本文选 **`/CloudNAS`**，也可以选 `/CloudNAS/子目录` |
| **只读** | 仅读取时勾选，更安全 |
| **启动时自动挂载** | 建议勾选，容器重启后自动恢复 |

![添加挂载点：挂载名称、源目录、挂载点、只读与启动时自动挂载](https://img.xuanyuan.dev/docker/blog/clouddrive-10.webp)

点挂载点旁的文件夹图标，在 **选择挂载点** 对话框里选中 `CloudNAS`（列表中还有 `Config`、`media` 等），再点 **选择**。

![选择挂载点对话框：容器内目录列表含 CloudNAS、Config、media](https://img.xuanyuan.dev/docker/blog/clouddrive-11.webp)

保存后，在宿主机查看挂载目录：

```bash
ls -la /www/wwwroot/clouddrive2/CloudNAS
```

目录里应能看到对应的挂载内容。媒体库（Jellyfin / Emby 等）可以把库路径指到该目录下的影片文件夹。

Web 里已经显示挂载、宿主机目录仍为空时，先不要继续加挂载点。回到第四节检查 MountFlags 或 `make-shared`，并确认 Compose 卷写了 `:shared`。

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

按本文部署和做基础挂载，一般在 Basic 套餐即可完成。是否升级，取决于你是否需要高级传输或加密等能力。

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
| 升级 | 先备份 `Config/`。再执行 `docker compose pull && docker compose up -d`。也可以在「关于」页检查更新。需要固定版本时，从[标签列表](https://xuanyuan.cloud/r/cloudnas/clouddrive2/tags)选择具体版本标签，再改 `image:` |
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

现象是容器状态为 Up，宿主机目录 `/www/wwwroot/clouddrive2/CloudNAS` 里没有云盘文件。

先打开 Web 的「挂载」页，确认已经添加挂载点，源目录指向 `/CloudNAS`。

再检查两处配置：第四节的 MountFlags 或 `make-shared` 是否做过；Compose 卷后缀是否为 `:shared`。

多数情况是还没有启用 shared 挂载传播，或 Web 里还没有添加挂载点。

**Q2：日志提示 fuse / Operation not permitted？**

日志出现 fuse 或 `Operation not permitted` 时，先确认已经映射 `/dev/fuse`。

再确认 Compose 使用了 `privileged: true`。

部分发行版只加 `SYS_ADMIN` 仍然不够。

**Q3：浏览器 `ERR_CONNECTION_TIMED_OUT`，或打不开 :19798？**

Ubuntu 24.04 实测：容器已 Up，本机 `curl http://127.0.0.1:19798/` 返回 **200 OK**，浏览器仍然超时。原因是 **`ufw` 已启用，但没有放行 19798**。放行之后可以访问。

按这个顺序检查：

1. 执行 `hostname -I`，使用输出的局域网地址。本文示例是 `192.168.1.10`。换机器时不要照抄这个地址。
2. 执行 `ss -lntp | grep 19798`，确认本机已在监听。
3. 执行 `curl -sI http://127.0.0.1:19798/`。本机也不通时，再看 `docker logs clouddrive2`。
4. 执行 `sudo ufw status`，查看防火墙是否拦截 19798。

本机 curl 已返回 200、浏览器仍然超时时，放行端口：

```bash
sudo ufw status
sudo ufw allow 19798/tcp
sudo ufw reload
```

云主机还要在安全组放行入站 **19798/tcp**。

上面都做过仍然不通时，去掉 `network_mode: host`，改成端口映射后重建容器：

```yaml
    # network_mode: "host"
    ports:
      - "19798:19798"
```

```bash
docker compose down && docker compose up -d
```

**Q4：和镜像页示例的 `clouddrive2-unstable` 有何区别？**

`clouddrive2` 偏稳定。

`clouddrive2-unstable` 更新更勤，功能可能更新，也更易变。

本文使用稳定镜像。要尝鲜时，再换成 unstable。

**Q5：群晖 / 飞牛上能跑吗？**

能不能跑，取决于 NAS 是否提供 FUSE，以及是否允许 privileged 容器。

套件限制严格时，优先改用带完整 Docker 的 Linux 主机。

**Q6：拉取很慢或失败？**

确认拉取地址是 `docker.xuanyuan.run/cloudnas/clouddrive2:…`。

报错码对照轩辕镜像常见问题。不要一失败就把默认拉回官方源。

| 标题 | URL |
|------|-----|
| 轩辕镜像常见问题 | `https://xuanyuan.cloud/faq` |

**Q7：可以去掉 privileged 吗？**

可以先试下面的能力，代替 `privileged: true`：

```yaml
    # privileged: true
    cap_add:
      - SYS_ADMIN
```

挂载失败时，改回 `privileged: true`。

**Q8：Basic 会员不够用？**

打开「会员」页，查看当前额度和显示为已禁用的项目。

按需要购买或激活官方套餐。

基础的添加云盘、挂载和 Web 浏览，通常可以先在 Basic 套餐里走通。

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

| 资源 | 链接 |
|------|------|
| [cloudnas/clouddrive2 镜像页（中文）](https://xuanyuan.cloud/zh/r/cloudnas/clouddrive2) | [https://xuanyuan.cloud/zh/r/cloudnas/clouddrive2](https://xuanyuan.cloud/zh/r/cloudnas/clouddrive2) |
| [标签列表](https://xuanyuan.cloud/r/cloudnas/clouddrive2/tags) | [https://xuanyuan.cloud/r/cloudnas/clouddrive2/tags](https://xuanyuan.cloud/r/cloudnas/clouddrive2/tags) |
| [CloudDrive 官网](https://www.clouddrive2.com/) | [https://www.clouddrive2.com/](https://www.clouddrive2.com/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |
| [轩辕镜像常见问题](https://xuanyuan.cloud/faq) | [https://xuanyuan.cloud/faq](https://xuanyuan.cloud/faq) |
| [Nextcloud AIO 部署教程](https://xuanyuan.cloud/blog/docker-nextcloud-aio) | [https://xuanyuan.cloud/blog/docker-nextcloud-aio](https://xuanyuan.cloud/blog/docker-nextcloud-aio) |

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/docker-clouddrive2



