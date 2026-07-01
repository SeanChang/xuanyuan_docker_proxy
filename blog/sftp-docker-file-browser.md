# 服务器文件不想 SFTP 传？Docker 跑个 File Browser，浏览器就能管理文件

![服务器文件不想 SFTP 传？Docker 跑个 File Browser，浏览器就能管理文件](https://img.xuanyuan.dev/docker/blog/filebrowser.png)

*分类: Docker部署教程 | 标签: File Browser,Docker,轩辕镜像,文件管理,私有化部署,部署教程 | 发布时间: 2026-06-29 13:33:15*

> 服务器上有文件要传、要删、要预览，每次开 SFTP 或 scp 太麻烦？File Browser 是一款开源 Web 文件管理器——一条 docker run 就能跑，浏览器里上传、下载、重命名、预览，数据目录完全在你自己的磁盘上。
> 
> 本文带你完成一次 File Browser 一条命令 Docker 部署：从轩辕镜像拉取、docker run 一键启动、从日志读取 admin 随机密码，到 Web 界面新建文件夹、上传文档、预览与下载——全程零基础可跟做，文末附 7 张实测截图。

*本文基于 [filebrowser/filebrowser:v2.63.17-s6](https://xuanyuan.cloud/zh/r/filebrowser/filebrowser) 镜像（实测版本 **2.63.17**），Ubuntu 24.04 服务器实测*

服务器上有文件要传、要删、要预览，每次开 SFTP 或 `scp` 太麻烦？**File Browser** 是一款开源 Web 文件管理器——**一条 `docker run` 就能跑**，浏览器里上传、下载、重命名、预览，数据目录完全在你自己的磁盘上。

本文带你完成一次 **File Browser 一条命令 Docker 部署**：从轩辕镜像拉取、`docker run` 一键启动、从日志读取 **admin 随机密码**，到 Web 界面新建文件夹、上传文档、预览与下载——全程零基础可跟做，文末附 **7 张实测截图**。

国内用户从 Docker Hub 拉取 `filebrowser/filebrowser` 可能较慢，本文使用 [轩辕镜像](https://xuanyuan.cloud) 加速域 `docker.xuanyuan.run`。官方文档见 [filebrowser.org](https://filebrowser.org)，源码仓库 [filebrowser/filebrowser](https://github.com/filebrowser/filebrowser)。

---

## 一、File Browser 是什么？

**File Browser** 是一款 **开源、自托管的 Web 文件管理器**，在指定目录内提供完整的文件操作界面。核心能力：

| 能力 | 说明 |
|------|------|
| Web 管理 | 浏览器内上传、下载、重命名、删除、预览文件 |
| 多用户 | 支持创建多个用户，每人可绑定独立目录与权限 |
| 轻量部署 | 单 Go 二进制，Docker 镜像约 **44MB**；配置与用户存 SQLite |
| 两种镜像 | 官方提供 **Alpine 裸镜像** 与 **S6 Overlay 镜像**（本文用后者，基于 linuxserver.io） |

典型使用场景：

- VPS / 家用 NAS **远程传文件**，替代 SFTP / FTP 客户端
- 小团队 **共享静态资源目录**（文档、备份包、安装包）
- 开发机 **内网文件交换**，数据不经过第三方网盘

> **与网盘的区别**：File Browser 不提供协作编辑与版本历史，胜在 **部署极简、目录即所见、完全自控**。若需要同步与分享链接，可配合反向代理与 HTTPS 对外发布；详见 [官方部署文档](https://filebrowser.org/deployment)。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 操作系统 | Linux（本文 Ubuntu 24.04） |
| Docker | 已安装 Docker 与 Docker Compose V2 |
| 内存 | ≥ 256 MB（空闲约 30～50 MB） |
| CPU | 单核即可 |
| 磁盘 | ≥ 500 MB（镜像 + 数据库 + 待管理文件） |
| 端口 | **8080**（宿主机映射，容器内监听 **80**） |

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

## 三、快速体验：单容器部署

适合：个人 VPS、内网文件交换、快速试用。

本文使用 **S6 Overlay 镜像**（标签含 `-s6`），需挂载三个目录并设置 `PUID` / `PGID` 以匹配宿主机文件权限。

### 3.1 创建数据目录

```bash
sudo mkdir -p /www/wwwroot/filebrowser/{srv,database,config}
sudo chown -R $USER:$USER /www/wwwroot/filebrowser
cd /www/wwwroot/filebrowser
```

| 宿主机目录 | 容器内路径 | 用途 |
|------------|------------|------|
| `srv/` | `/srv` | **文件根目录**（Web 界面管理的所有文件） |
| `database/` | `/database` | 存放 `filebrowser.db`（用户与权限） |
| `config/` | `/config` | 存放 `settings.json`（站点配置） |

> 若希望管理整个家目录，可将 `-v` 中的 `srv` 路径改为 `/home:/srv`；生产环境请 **最小权限** 挂载，勿把整个 `/` 暴露给 Web。

### 3.2 拉取并启动容器

拉取镜像（若已拉取可跳过）：

```bash
docker pull docker.xuanyuan.run/filebrowser/filebrowser:v2.63.17-s6
```

启动 File Browser：

```bash
docker run -d \
  --name filebrowser \
  --restart unless-stopped \
  -p 8080:80 \
  -v /www/wwwroot/filebrowser/srv:/srv \
  -v /www/wwwroot/filebrowser/database:/database \
  -v /www/wwwroot/filebrowser/config:/config \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  docker.xuanyuan.run/filebrowser/filebrowser:v2.63.17-s6
```

各参数说明：

| 配置 | 说明 |
|------|------|
| `-p 8080:80` | 宿主机 **8080** 映射容器内 **80**（Web 访问端口） |
| `-v ...:/srv` | 持久化待管理的文件目录 |
| `-v ...:/database` | 持久化 SQLite 数据库 |
| `-v ...:/config` | 持久化站点配置 |
| `PUID` / `PGID` | 与宿主机用户 UID/GID 一致，避免读写权限问题 |
| `v2.63.17-s6` | 固定版本 + S6 初始化（实测 **2.63.17**） |
| `--restart unless-stopped` | 宿主机重启后自动拉起 |

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `filebrowser/filebrowser:v2.63.17-s6` | `docker pull docker.xuanyuan.run/filebrowser/filebrowser:v2.63.17-s6` |

### 3.3 验证启动

查看日志：

```bash
docker logs filebrowser
```

成功时终端类似输出（**Ubuntu 24.04 实测**）：

```text
[custom-init] No custom services found, skipping...
[migrations] started
[migrations] no migrations found
...
User UID:    0
User GID:    0
...
2026/06/29 13:18:38 Using config file: /config/settings.json
2026/06/29 13:18:38 WARNING: filebrowser.db can't be found. Initialing in /database/
2026/06/29 13:18:38 Using database: /database/filebrowser.db
2026/06/29 13:18:38 Performing quick setup
2026/06/29 13:18:38 User 'admin' initialized with randomly generated password: nhGDwQZh2GRG1AzM
2026/06/29 13:18:39 Listening on [::]:80
```

重点关注两行：

- **`User 'admin' initialized with randomly generated password:`** — 后面即为 **admin 初始密码**（**每次全新部署随机生成，请以你自己的日志为准**）
- **`Listening on [::]:80`** — 容器内 Web 服务已就绪

另开终端快速探测：

```bash
curl -I http://127.0.0.1:8080
```

应返回 HTTP `200` 或 `302`。确认容器状态：

```bash
docker ps | grep filebrowser
ls config/ database/ srv/
```

首次启动后，`config/settings.json` 与 `database/filebrowser.db` 会自动创建。

### 3.4 首次登录

浏览器打开：

```text
http://你的服务器IP:8080
```

进入 File Browser 登录页。用户名固定为 **`admin`**，密码使用 **3.3 节日志中的随机字符串**。

![File Browser 登录页：用户名 admin，点击蓝色「登录」按钮进入](https://img.xuanyuan.dev/docker/blog/filebrowser-1.png)

> **安全提示**：初始密码只出现在 **首次启动的 `docker logs` 输出** 中，请立即登录并在 **Settings → Profile** 中修改密码。若对公网开放 8080，务必尽快改密；生产环境建议关闭公网直连，改用 **第四节 Compose + 反向代理 HTTPS**。

### 3.5 登录后主界面

登录成功后进入文件管理主界面。左侧为导航（My files、New folder、Settings 等），顶部为搜索与工具栏；若 `/srv` 为空，中间会显示 **「It feels lonely here...」**。

![File Browser 登录后主界面：空目录与左侧导航，版本 2.63.17](https://img.xuanyuan.dev/docker/blog/filebrowser-2.png)

左下角可看到 **磁盘用量**（如 `14.9 GiB of 108 GiB used`）与版本号 **File Browser 2.63.17**。

### 3.6 新建文件夹

点击左侧 **New folder**，在弹窗中输入文件夹名（实测创建 **`testuploadfile`**），点击 **CREATE**。

![File Browser 新建文件夹：输入 testuploadfile，路径预览为根目录下子文件夹](https://img.xuanyuan.dev/docker/blog/filebrowser-3.png)

创建成功后，根目录下会出现该文件夹（与宿主机 `srv/testuploadfile/` 对应）。

![File Browser 根目录：Folders 区域显示 testuploadfile 文件夹](https://img.xuanyuan.dev/docker/blog/filebrowser-4.png)

宿主机验证：

```bash
ls srv/testuploadfile/
```

### 3.7 上传文件

进入 `testuploadfile` 文件夹，点击顶部 **Upload** 图标，选择 **File** 或 **Folder** 上传。

![File Browser 上传弹窗：选择 File 上传单个文件或 Folder 上传整个目录](https://img.xuanyuan.dev/docker/blog/filebrowser-5.png)

实测上传 **`验收测试报告模板.docx`**（约 27.46 KiB），上传完成后文件卡片出现在 **Files** 区域。

![File Browser 文件列表：testuploadfile 目录下的 docx 文件与大小信息](https://img.xuanyuan.dev/docker/blog/filebrowser-6.png)

宿主机同步可见：

```bash
ls srv/testuploadfile/
# 验收测试报告模板.docx
```

**日常用法速记**：

- 顶部工具栏支持 **下载、删除、重命名、移动、复制**
- 左侧 **Search** 可按文件名检索
- 支持 **网格 / 列表** 视图切换
- 手机浏览器访问同一地址即可 **跨设备管理文件**

### 3.8 预览与下载

点击文件名可进入预览页。Office 文档（如 `.docx`）在浏览器内 **无法内嵌预览**，会提示 **「Preview is not available for this file.」**，可点击 **DOWNLOAD** 下载或 **OPEN FILE** 在新标签打开。

![File Browser 文件预览：docx 不支持内嵌预览，提供下载与打开选项](https://img.xuanyuan.dev/docker/blog/filebrowser-7.png)

图片、PDF、文本等格式通常可直接在浏览器内预览。

---

## 四、生产推荐：Docker Compose

适合：长期运行、需要可复现配置、便于 `git` 管理部署文件的场景。

### 4.1 目录结构

```bash
cd /www/wwwroot/filebrowser
```

将包含：

```text
/www/wwwroot/filebrowser/
├── docker-compose.yml
├── srv/           # 文件根目录
├── database/      # filebrowser.db
└── config/        # settings.json
```

### 4.2 编写 `docker-compose.yml`

```yaml
services:
  filebrowser:
    image: docker.xuanyuan.run/filebrowser/filebrowser:v2.63.17-s6
    container_name: filebrowser
    restart: unless-stopped
    ports:
      - "8080:80"
    volumes:
      - ./srv:/srv
      - ./database:/database
      - ./config:/config
    environment:
      PUID: 1000   # 改为宿主机实际 UID：id -u
      PGID: 1000   # 改为宿主机实际 GID：id -g
      TZ: Asia/Shanghai
```

> 若以 root 运行（如本文实测 `UID/GID: 0`），将 `PUID` / `PGID` 设为 `0`，并确保 `./srv` 等目录权限一致。

### 4.3 启动与运维

```bash
docker compose up -d
docker compose ps
docker compose logs -f filebrowser
```

常用运维命令：

```bash
# 查看日志（含 admin 初始密码，仅首次）
docker compose logs filebrowser

# 停止（保留 srv / database / config）
docker compose down

# 升级：拉新镜像后重建
docker compose pull
docker compose up -d
```

### 4.4 生产环境注意

- **HTTPS**：将 File Browser 放在 Nginx、Caddy 或 Traefik **反向代理** 之后，对外只暴露 443。详见 [官方部署文档](https://filebrowser.org/deployment)。
- **最小挂载**：仅挂载需要 Web 管理的目录，避免暴露敏感系统路径。
- **备份**：定期备份 `./database/filebrowser.db`（用户与权限）及 `./config/settings.json`；`./srv` 为实际文件数据，务必一并备份。
- **防火墙**：若必须直连端口，可 `sudo ufw allow 8080/tcp`；云服务器需在 **安全组** 放行。更推荐仅反代对外、8080 仅内网访问。
- **多用户**：登录 **Settings → User Management** 可新增用户并限制可见目录。

### 4.5 镜像标签说明

| 标签 | 适用场景 |
|------|----------|
| `v2.63.17-s6` | **S6 版固定版本**（本文实测，含 linuxserver 初始化） |
| `s6` / `v2-s6` | S6 版滚动标签，跟随最新 v2 |
| `v2.63.17` | Alpine 裸镜像固定版本（无需 PUID/PGID，卷用法略有不同） |
| `latest` | 偏开发向，**不建议生产使用** |

Alpine 裸镜像快速启动示例（供对比）：

```bash
docker run -d \
  --name filebrowser-alpine \
  --restart unless-stopped \
  -p 8080:80 \
  -v filebrowser_data:/srv \
  -v filebrowser_database:/database \
  -v filebrowser_config:/config \
  docker.xuanyuan.run/filebrowser/filebrowser:v2.63.17
```

---

## 五、目录与卷速查

| 容器路径 | 说明 |
|----------|------|
| `/srv` | Web 界面管理的文件根目录 |
| `/database/filebrowser.db` | SQLite 数据库（用户、权限、分享链接等） |
| `/config/settings.json` | 站点配置（端口、品牌、认证方式等） |

S6 镜像环境变量：

| 变量 | 说明 |
|------|------|
| `PUID` | 运行 File Browser 进程的 UID，与宿主机文件所有者一致 |
| `PGID` | 运行 File Browser 进程的 GID |
| `TZ` | 时区（可选，如 `Asia/Shanghai`） |

---

## 六、常见问题 FAQ

**Q1：`8080` 端口被占用怎么办？**

单容器启动时改映射，例如宿主机用 8095：

```bash
docker run -d --name filebrowser --restart unless-stopped \
  -p 8095:80 \
  -v /www/wwwroot/filebrowser/srv:/srv \
  -v /www/wwwroot/filebrowser/database:/database \
  -v /www/wwwroot/filebrowser/config:/config \
  -e PUID=$(id -u) -e PGID=$(id -g) \
  docker.xuanyuan.run/filebrowser/filebrowser:v2.63.17-s6
```

浏览器访问 `http://服务器IP:8095`。Compose 中把 `ports` 改为 `"8095:80"` 即可。

**Q2：忘记 admin 密码怎么办？**

初始密码仅在 **首次启动日志** 中出现。若已丢失且未改密，可停止容器后删除数据库重新初始化（**会丢失用户与权限配置**）：

```bash
docker stop filebrowser && docker rm filebrowser
rm /www/wwwroot/filebrowser/database/filebrowser.db
# 再执行第三节 docker run，重新查看 docker logs 获取新密码
```

已改密的情况请参考 [官方文档](https://filebrowser.org) 或通过 SQLite 重置。建议首次登录后立即修改并妥善保存。

**Q3：上传文件后宿主机看不到？**

检查 `-v` 挂载路径是否正确、容器内 `/srv` 是否对应宿主机 `srv/`。用 `docker inspect filebrowser` 查看 Mounts。同时确认 `PUID`/`PGID` 与目录所有者一致，避免权限导致写入失败。

**Q4：日志里 `usermod: user abc is currently used by process 1` 有影响吗？**

S6 镜像初始化时的常见提示，**不影响 File Browser 正常启动**。只要日志末尾出现 `Listening on [::]:80` 即可使用。

**Q5：如何升级 File Browser？**

```bash
# 单容器
docker pull docker.xuanyuan.run/filebrowser/filebrowser:v2.63.17-s6
docker stop filebrowser && docker rm filebrowser
# 再执行第三节 docker run（srv / database / config 卷不变）

# Compose
cd /www/wwwroot/filebrowser
docker compose pull
docker compose up -d
```

升级前建议备份 `database/` 与 `config/`。

**Q6：与 Docker Hub 官方镜像的关系？**

功能相同。`docker.xuanyuan.run/filebrowser/filebrowser:v2.63.17-s6` 为轩辕镜像加速的 Docker Hub 同步版，便于国内拉取。配置中将镜像名替换为轩辕域即可，其余命令与 [官方安装文档](https://filebrowser.org/installation) 一致。

**Q7：可以管理多个目录吗？**

默认单用户绑定 `/srv` 根目录。可通过 **Settings → User Management** 为不同用户设置不同 **Scope**（子目录范围），或在 `settings.json` 中调整 `root` 路径（需重启容器）。

**Q8：如何停止与卸载？**

```bash
# 单容器（保留 srv / database / config）
docker stop filebrowser && docker rm filebrowser

# Compose
cd /www/wwwroot/filebrowser && docker compose down

# 删除全部数据（慎用，文件与账户将全部丢失）
rm -rf /www/wwwroot/filebrowser
```

**Q9：容器启动后浏览器无法访问？**

依次检查：`docker ps` 确认容器为 `Up`；`docker logs filebrowser` 看报错；本机 `curl -I http://127.0.0.1:8080` 是否通；云服务器 **安全组 / 防火墙** 是否放行 8080；若仅绑定了内网 IP，需用正确地址访问。

---

## 七、命令速查

| 操作 | 命令 |
|------|------|
| 拉取镜像 | `docker pull docker.xuanyuan.run/filebrowser/filebrowser:v2.63.17-s6` |
| 快速启动 | `docker run -d --name filebrowser --restart unless-stopped -p 8080:80 -v /www/wwwroot/filebrowser/srv:/srv -v /www/wwwroot/filebrowser/database:/database -v /www/wwwroot/filebrowser/config:/config -e PUID=$(id -u) -e PGID=$(id -g) docker.xuanyuan.run/filebrowser/filebrowser:v2.63.17-s6` |
| Compose 启动 | `cd /www/wwwroot/filebrowser && docker compose up -d` |
| 查看日志（读 admin 密码） | `docker logs filebrowser` |
| 健康检查 | `curl -I http://127.0.0.1:8080` |
| Web 访问 | `http://服务器IP:8080` |
| 停止服务 | `docker stop filebrowser && docker rm filebrowser` |

---

## 八、延伸阅读

| 主题 | 链接 |
|------|------|
| 项目首页 | https://filebrowser.org |
| 安装文档 | https://filebrowser.org/installation |
| 部署与安全 | https://filebrowser.org/deployment |
| 配置说明 | https://filebrowser.org/configuration |
| GitHub 源码 | https://github.com/filebrowser/filebrowser |
| Docker Hub | https://hub.docker.com/r/filebrowser/filebrowser |
| 轩辕镜像页 | https://xuanyuan.cloud/zh/r/filebrowser/filebrowser |
| 轩辕镜像 | https://xuanyuan.cloud |

---

**总结**：File Browser = **私有化 Web 文件管理**，镜像约 44MB、一条命令就能跑。个人试用选 **第三节单容器**，`docker logs` 读 **admin 随机密码** → 浏览器登录 → 建文件夹 → 上传文件；长期运行选 **第四节 Compose**，配合 **数据备份** 与 **反向代理 HTTPS**，文件完全在自己服务器磁盘上。

