# 群晖 NAS 自建照片库？群晖 MT Photos Docker 部署实测记录

![群晖 NAS 自建照片库？群晖 MT Photos Docker 部署实测记录](https://img.xuanyuan.dev/docker/blog/mt-photos.png)

*分类: Docker部署教程 | 标签: MT Photos, Docker,轩辕镜像,群晖,NAS,照片管理,私有化部署,部署教程 | 发布时间: 2026-07-08 05:14:46*

> 手机相册、Synology Photos、硬盘散落文件夹……照片越攒越乱，翻一张要翻半天？MT Photos 是面向 NAS 用户的照片管理系统——支持导入已有照片/视频、App 备份手机相册、人脸识别与地图浏览，适合在自有 NAS 上 私有化部署。

*本文基于 [mtphotos/mt-photos:latest](https://xuanyuan.cloud/r/mtphotos/mt-photos) 镜像，群晖 **DS920plus** 实测（访问端口 `8063`）*

手机相册、Synology Photos、硬盘散落文件夹……照片越攒越乱，翻一张要翻半天？**MT Photos** 是面向 NAS 用户的照片管理系统——支持导入已有照片/视频、App 备份手机相册、人脸识别与地图浏览，适合在自有 NAS 上 **私有化部署**。

本文带你用 **Docker 单容器** 在群晖上跑通 MT Photos：轩辕镜像加速拉取、`docker run` 一键启动、挂载已有 `Photos` 目录，再跟做 **Web 安装向导**——全程 DS920plus 实测，附 **11 张截图** 与完整命令；文末 FAQ 收录群晖权限踩坑修复。

---

## 一、MT Photos 是什么？

**MT Photos** 是一款为 **NAS 用户** 准备的照片管理系统，基于 Docker 运行，主要用于帮助用户高效存储、整理和管理各类照片资源。

| 能力 | 说明 |
|------|------|
| 图库管理 | 将不同文件夹的照片、视频合并展示，按用户授权 |
| 已有目录导入 | 把宿主机照片文件夹映射进容器即可扫描 |
| App 备份 | `/upload` 目录接收手机 App 备份的照片/视频 |
| 探索视图 | 人物、地点、场景等智能分类浏览 |
| 管理工具 | 重复文件检查、文件夹整理、人脸识别整理等 |

典型使用场景：群晖 / 威联通等 NAS **集中管理散落照片**；替代或补充 Synology Photos；家庭 **私有化相册** 不经过第三方云。

> **部署要点**：单容器即可跑通基础功能；内置 **PostgreSQL** 数据库，数据写在 `/config/pgsql`，群晖上启动时需设置 `PUID`/`PGID`（见第五节）。若遇权限报错，见 **第十节 FAQ**。OCR / 人脸识别等 AI 功能需额外部署配套容器，不在本文范围。

架构示意：

```text
浏览器 ──HTTP:8063──▶ MT Photos 容器
宿主机 /volume1/docker/mt_photos/config ──▶ /config（数据库、缩略图缓存）
宿主机 /volume1/docker/mt_photos/upload  ──▶ /upload（App 备份）
宿主机 /volume1/homes/你的用户名/Photos  ──▶ /photos（已有照片，可选）
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 设备 | 群晖 NAS（本文 **DS920plus**，x86 架构） |
| 系统 | DSM 7.x，已安装 **Container Manager**（原 Docker 套件） |
| 内存 | ≥ 2 GB（建议 4 GB） |
| CPU | 双核 2.0 GHz 以上 |
| 磁盘 | 视照片库大小而定；`/config` 会存数据库与缩略图缓存 |
| 端口 | **8063**（容器内外一致） |
| SSH | 建议开启，便于命令行部署与排错 |

验证 Docker（SSH 终端）：

```bash
docker --version
```

群晖 NAS 镜像加速配置见 [群晖 NAS Docker 镜像源配置教程](https://xuanyuan.cloud/usage/synology)。

---

## 三、拉取镜像

SSH 登录群晖（或直接在终端操作），拉取 MT Photos 镜像：

```bash
docker pull docker.xuanyuan.run/mtphotos/mt-photos:latest
```

成功时终端类似输出：

```text
latest: Pulling from mtphotos/mt-photos
...
Status: Downloaded newer image for docker.xuanyuan.run/mtphotos/mt-photos:latest
```

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `mtphotos/mt-photos:latest` | `docker pull docker.xuanyuan.run/mtphotos/mt-photos:latest` |

---

## 四、创建数据目录

MT Photos 要求持久化两个必挂目录，删除容器后数据不丢失：

```bash
mkdir -p /volume1/docker/mt_photos/config
mkdir -p /volume1/docker/mt_photos/upload
```

| 宿主机目录 | 容器内路径 | 用途 |
|------------|------------|------|
| `/volume1/docker/mt_photos/config` | `/config` | **必挂**：数据库、缩略图、预览视频等缓存 |
| `/volume1/docker/mt_photos/upload` | `/upload` | **必挂**：App 备份的照片/视频 |
| `/volume1/homes/你的用户名/Photos` | `/photos` | **可选**：已有照片目录 |

### 4.1 确认已有照片路径

可将群晖**你的用户名**对应个人 Photos 目录映射进容器。部署前先确认目录存在（将 `你的用户名` 替换为 DSM 中的实际用户名）：

```bash
ls /volume1/homes/你的用户名/Photos/
```

路径说明：

- `/volume1/photo` — 群晖**共享文件夹**路径（只有建了名为 `photo` 的共享目录时才有）
- `/volume1/homes/你的用户名/Photos/` — DSM 为该用户创建的**个人照片目录**（Synology Photos / 手机备份常用位置）

Web 初始化添加图库时填**容器内路径** `/photos`。

---

## 五、启动容器（docker run）

群晖上建议启动前设置目录属主，并为容器指定 `PUID` / `PGID`，避免内置 PostgreSQL 在 `/config/pgsql` 初始化时遇到权限问题。

### 5.1 获取 NAS 用户 uid/gid

```bash
id 你的用户名
```

示例输出（数值因用户而异）：

```text
uid=1026(你的用户名) gid=100(users) groups=100(users),101(administrators)
```

记下 `uid` 与 `gid`，下文 `PUID` / `PGID` 及 `chown` 均以此为准。

### 5.2 修正目录属主

```bash
chown -R 你的用户名:users /volume1/docker/mt_photos/config
chown -R 你的用户名:users /volume1/docker/mt_photos/upload
```

### 5.3 启动容器

```bash
docker run -d \
  --name mt-photos \
  --restart unless-stopped \
  -p 8063:8063 \
  -v /volume1/docker/mt_photos/config:/config \
  -v /volume1/docker/mt_photos/upload:/upload \
  -v /volume1/homes/你的用户名/Photos:/photos \
  -e TZ=Asia/Shanghai \
  -e PUID=1026 \
  -e PGID=100 \
  docker.xuanyuan.run/mtphotos/mt-photos:latest
```

各参数说明：

| 配置 | 说明 |
|------|------|
| `-p 8063:8063` | Web 访问端口 |
| `-v .../config:/config` | 数据库与缓存持久化 |
| `-v .../upload:/upload` | App 备份目录 |
| `-v .../Photos:/photos` | 已有照片库（容器内路径可自定义） |
| `TZ=Asia/Shanghai` | 时区 |
| `PUID` / `PGID` | 与宿主机用户 uid/gid 一致，群晖上**建议必填** |
| `--restart unless-stopped` | 群晖重启后自动拉起 |

> **注意**：`PUID` / `PGID` **不能为 0**（不能是 root）。上例 `1026` / `100` 仅为示例，请替换为 `id 你的用户名` 的实际输出。

### 5.4 验证启动成功

```bash
docker logs mt-photos --tail 30
```

**DS920plus 实测日志**：

```text
===== initDb =====
waiting for server to start.... done
server started
2026-07-08T12:55:13: PM2 log: Launching in no daemon mode
2026-07-08T12:55:13: PM2 log: App [launcher:0] starting in -fork mode-
2026-07-08T12:55:13: PM2 log: App [launcher:0] online
[MT Photos] : Server started, http port:8063
 ___  ________  ______ _           _
 |  \/  |_   _| | ___ \ |         | |
 | .  . | | |   | |_/ / |__   ___ | |_ ___  ___
 | |\/| | | |   |  __/| '_ \ / _ \| __/ _ \/ __|
 | |  | | | |   | |   | | | | (_) | || (_) \__ \
 \_|  |_/ \_/   \_|   |_| |_|\___/ \__\___/|___/
CREATE INDEX idx_file_clip_vec start
CREATE INDEX idx_file_clip_vec success
CREATE INDEX IDX_people_descriptor_v2_vec start
CREATE INDEX idx_people_descriptor_v2_vec success
```

关键判据：

- 出现 **`Server started, http port:8063`** — 服务已就绪
- **不再出现** `Permission denied` 或 `服务端启动异常`

在 **Container Manager → 容器** 中也能看到 `mt-photos` 状态为绿色运行中：

![Container Manager 容器列表：mt-photos 状态为运行中，映像 docker.xuanyuan.run/mtphotos/mt-photos](https://img.xuanyuan.dev/docker/blog/mt-photos-1.png)

---

## 六、Web 安装向导

浏览器打开：

```text
http://你的群晖IP:8063
```

### 6.1 选择语言

安装向导首页，选择 **简体中文**，点击 **下一步**。

![MT Photos 安装向导：选择显示语言为简体中文](https://img.xuanyuan.dev/docker/blog/mt-photos-2.png)

### 6.2 创建管理员账户

填写管理员用户名与密码。管理员账号用于管理 MT Photos 的所有资源和用户，请妥善保管。

![创建管理员账户：填写用户名与密码，点击下一步](https://img.xuanyuan.dev/docker/blog/mt-photos-3.png)

### 6.3 设置图库

点击 **添加图库**，在弹出的文件夹选择器中选择容器内路径 **`/photos`**（对应宿主机 `/volume1/homes/你的用户名/Photos`）。

![添加图库：选择文件夹弹窗，选中容器内 /photos 目录](https://img.xuanyuan.dev/docker/blog/mt-photos-4.png)

为图库命名（实测创建 **「太湖」** 图库），确认后可在列表中看到已添加的图库卡片，点击 **完成** 结束向导。

![设置图库：已添加太湖图库，路径 /photos/2023年7月1日，点击完成](https://img.xuanyuan.dev/docker/blog/mt-photos-5.png)

---

## 七、登录与主界面

向导完成后进入登录页，使用刚创建的管理员账号登录。

![MT Photos 登录页：输入用户名与密码，点击登录](https://img.xuanyuan.dev/docker/blog/mt-photos-6.png)

登录后进入 **照片** 主界面。系统会按日期分组展示图库中的照片，首次加载时缩略图可能显示为加载中，等待后台索引完成即可。

![MT Photos 照片主界面：按日期 2023-07-01 分组，缩略图索引中](https://img.xuanyuan.dev/docker/blog/mt-photos-7.png)

点击任意照片可进入大图预览，支持旋转、分享、收藏、查看元数据等操作。

![MT Photos 照片预览：大图浏览与顶部工具栏](https://img.xuanyuan.dev/docker/blog/mt-photos-8.png)

---

## 八、图库扫描与管理

进入左侧 **管理 → 图库管理**，可查看已添加的图库、触发扫描。实测「太湖」图库显示 **「更新上传文件信息中」**，表示正在索引 `/photos` 下的照片。

![图库管理：太湖图库扫描中，可点击扫描所有图库](https://img.xuanyuan.dev/docker/blog/mt-photos-9.png)

**管理工具** 页面提供重复文件检查、文件夹整理、人脸识别整理、系统维护任务等高级功能。

![管理工具：图库相关、人脸识别相关与系统维护工具卡片](https://img.xuanyuan.dev/docker/blog/mt-photos-10.png)

索引完成后，**探索** 页面会按人物、地点、场景等维度聚合照片（需照片含 GPS / 人脸等元数据，或部署 AI 配套容器）。

![探索页面：人物、地点、场景分类浏览](https://img.xuanyuan.dev/docker/blog/mt-photos-11.png)

---

## 九、Container Manager 图形界面部署（可选）

若偏好 DSM 可视化管理，可用 **Container Manager → 项目** 创建 Compose 项目。路径建议：`/volume1/docker/mt-photos-project`。

`docker-compose.yml`：

```yaml
version: "3"
services:
  mtphotos:
    image: docker.xuanyuan.run/mtphotos/mt-photos:latest
    container_name: mt-photos
    restart: unless-stopped
    ports:
      - "8063:8063"
    volumes:
      - /volume1/docker/mt_photos/config:/config
      - /volume1/docker/mt_photos/upload:/upload
      # 群晖用户个人 Photos 目录（将 你的用户名 替换为实际用户名，部署前 ls 确认）
      - /volume1/homes/你的用户名/Photos:/photos
    environment:
      - TZ=Asia/Shanghai
      - PUID=1026
      - PGID=100
```

> **注意**：若已用 `docker run` 创建同名容器，需先 `docker stop mt-photos && docker rm mt-photos`，避免 8063 端口与容器名冲突。`PUID` / `PGID` 请替换为你 NAS 用户的实际值。

---

## 十、常见问题 FAQ

**Q1：首次启动报 `Permission denied` `/config/pgsql/data` 怎么办？（群晖高发）**

若未按第五节设置 `PUID`/`PGID`，或 `config` 目录属主不对，日志可能出现：

```text
===== initDb =====
execFile stderr: sh /usr/src/app/initDb.sh initdb: error: could not access directory "/config/pgsql/data": Permission denied

pg_ctl: could not access directory "/config/pgsql/data": Permission denied
...
Debug: id postgres uid=103(postgres) gid=105(postgres) groups=105(postgres),103(ssl-cert)
...
 =========== 服务端启动异常 =============
修复方法： https://mtmt.tech/docs/advanced/ifix
```

**原因**：MT Photos 内置 PostgreSQL 要求 `/config/pgsql` 目录属主为容器内 `postgres`（uid=103, gid=105），权限为 `700`。群晖宿主机 `/volume1/docker/mt_photos/config` 默认属 `root`，容器无法在映射目录内初始化数据库。

**修复步骤**：

```bash
# 1. 停止并删除失败容器
docker stop mt-photos && docker rm mt-photos

# 2. 查看 NAS 用户 uid/gid
id 你的用户名

# 3. 清理不完整的数据库目录
rm -rf /volume1/docker/mt_photos/config/pgsql

# 4. 修正 config 目录属主
chown -R 你的用户名:users /volume1/docker/mt_photos/config

# 5. 带 PUID/PGID 重建容器（uid/gid 替换为 id 命令输出）
docker run -d \
  --name mt-photos \
  --restart unless-stopped \
  -p 8063:8063 \
  -v /volume1/docker/mt_photos/config:/config \
  -v /volume1/docker/mt_photos/upload:/upload \
  -v /volume1/homes/你的用户名/Photos:/photos \
  -e TZ=Asia/Shanghai \
  -e PUID=1026 \
  -e PGID=100 \
  docker.xuanyuan.run/mtphotos/mt-photos:latest

# 6. 验证（应出现 Server started, http port:8063）
docker logs mt-photos --tail 30
```

若仍失败，在 **File Station** 中右键 `/volume1/docker/mt_photos/config` → 属性 → 权限，确认 NAS 用户有**完全控制**，且 **Everyone 有读取**。不要用 SMB/NFS 远程挂载目录作为 `/config`。官方文档：[常见错误及解决方法](https://mtmt.tech/docs/advanced/ifix)。

**Q2：`8063` 端口被占用怎么办？**

改端口映射，例如 `-p 18063:8063`，浏览器访问 `http://群晖IP:18063`。

**Q3：图库里看不到已有照片？**

1. 确认 `docker run` 时已挂载照片目录（如 `-v /volume1/homes/你的用户名/Photos:/photos`）
2. Web 初始化添加图库时选择**容器内路径** `/photos`，不是宿主机路径
3. 进入 **图库管理 → 扫描所有图库** 触发索引

**Q4：PUID/PGID 填什么？**

SSH 执行 `id 你的用户名`，将输出的 `uid` 填 `PUID`、`gid` 填 `PGID`（例如 `1026` / `100`，以实际输出为准）。第五节启动时已应配置。

**Q5：需要人脸识别 / OCR 怎么办？**

基础单容器不含 AI 服务。按 [群晖 7.2+ 官方 Compose 示例](https://mtmt.tech/docs/example/dsm2/) 追加 `mt-photos-ai`（端口 8060）和人脸识别 API 容器（端口 8066）。建议先跑通单容器再扩展。

**Q6：CloudSync 无法感知容器内文件变化？**

群晖不会监听 Docker 容器内对文件的改动。若需触发 CloudSync 同步，官方建议通过 CIFS 挂载 SMB 共享路径，详见 [群晖安装方法](https://mtmt.tech/docs/example/dsm/)。

**Q7：如何停止与卸载？**

```bash
# 停止并删除容器（保留 config / upload / 照片数据）
docker stop mt-photos && docker rm mt-photos

# 删除全部数据（慎用）
rm -rf /volume1/docker/mt_photos
```

---

## 十一、命令速查

| 操作 | 命令 |
|------|------|
| 拉取镜像 | `docker pull docker.xuanyuan.run/mtphotos/mt-photos:latest` |
| 创建目录 | `mkdir -p /volume1/docker/mt_photos/{config,upload}` |
| 确认照片路径 | `ls /volume1/homes/你的用户名/Photos/` |
| 查看 uid/gid | `id 你的用户名` |
| 启动容器 | 见第五节 5.3（含 PUID/PGID 的 docker run） |
| 查看日志 | `docker logs mt-photos --tail 30` |
| Web 访问 | `http://群晖IP:8063` |
| 停止服务 | `docker stop mt-photos && docker rm mt-photos` |

---

## 十二、延伸阅读

| 主题 | 链接 |
|------|------|
| 轩辕镜像页 | https://xuanyuan.cloud/r/mtphotos/mt-photos |
| MT Photos 安装文档 | https://mtmt.tech/docs/start/install/ |
| 群晖 DSM 7.2+ 安装 | https://mtmt.tech/docs/example/dsm2/ |
| 常见错误与修复 | https://mtmt.tech/docs/advanced/ifix |
| Docker Hub | https://hub.docker.com/r/mtphotos/mt-photos |
| 群晖镜像加速配置 | https://xuanyuan.cloud/usage/synology |
| 轩辕镜像 | https://xuanyuan.cloud |

---

**总结**：MT Photos = **NAS 私有化照片管理**，单容器即可跑通。群晖部署要点：**拉镜像 → 建目录 → 设 PUID/PGID → docker run → 浏览器完成安装向导 → 挂载 `/photos` 导入已有图库**。若遇 `Permission denied`，见 **第十节 FAQ**。长期运行注意备份 `/volume1/docker/mt_photos/config`，按需扩展 AI 配套容器。

