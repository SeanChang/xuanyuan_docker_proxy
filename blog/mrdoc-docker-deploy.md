# Docker 部署觅思文档：搭建私有化文档管理系统

![Docker 部署觅思文档：搭建私有化文档管理系统](https://imgs.xuanyuan.cloud/docker/blog/mrdoc.webp)

*分类: Docker部署教程 | 标签: MrDoc,觅思文档,zmister/mrdoc,Docker,轩辕镜像,知识库,文档管理,私有化部署,部署教程 | 发布时间: 2026-09-10 14:15:37*

> MrDoc（觅思文档）是一款开源在线文档与知识库系统，支持文集管理、多人协作与多格式导出。本文将介绍如何通过 Docker Compose 快速部署 zmister/mrdoc 运行环境镜像，轻松搭建可自托管的文档站，适合团队 Wiki、接口说明、内部手册与私有知识库等场景。

*本文基于 [zmister/mrdoc:v9.6](https://xuanyuan.cloud/zh/r/zmister/mrdoc)，跟做标签 **v9.6**，实测应用 **MrDoc 1.1.0**，测试平台 **Ubuntu 24.04** Linux。*

项目说明书、接口约定、排障手记经常各放一处：有人塞网盘文件夹，有人甩微信群文件，有人本地各写一份 Markdown，版本对不上。新人入职第一句是「最新版在哪」；改一行配置要翻半个月聊天记录。Word / Excel 和网页稿并存时更烦——导出 PDF、转 HTML，本机少一个 LibreOffice 或浏览器依赖就卡住。

放到第三方 Wiki 或在线笔记，又会碰到内网隔离、等保和「数据不出域」。很多机房已经有一台跑 Docker 的 Ubuntu，真正缺的是：**运行环境一次拉齐，源码和数据落在自己目录，浏览器打开就能建文集、写文档**。

**MrDoc（觅思文档）**（[官网](https://mrdoc.pro/)、[Gitee · MrDoc](https://gitee.com/zmister/MrDoc)、[镜像页](https://xuanyuan.cloud/zh/r/zmister/mrdoc)）是开源在线文档与知识库。本文用的 **`zmister/mrdoc`** 是官方**运行环境镜像**：用 **uWSGI** 对外服务，内置 **Chromium** 与 **LibreOffice**，**必须把本地 MrDoc 源码挂到** `/app/MrDoc`，开源版与专业版通用。镜像里不带完整业务源码——环境固定，代码和数据由你挂载的目录保管。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 浏览器写文档 | 打开 `http://服务器IP:10086`，管理员登录后建文集、写 Markdown |
| 团队知识库 | 按文集与权限放内部手册、接口说明、运维笔记 |
| 在线表格 | 同一文集下新建表格，做简单台账或对照表 |
| 备份搬家 | 停容器后打包宿主机上的 MrDoc 目录 |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`zmister/mrdoc:v9.6`**，**Docker Compose** 启动：clone 开源版 → 挂载 → `createsuperuser` → 浏览器访问。把下文中的服务器 IP 换成你的。无 Compose 见第八节。文内附 **8** 张实测截图。

> **上手要点**
> - **部署**：第四节 Compose；临时试玩见第八节 `docker run`
> - **前提**：本地已有 **MrDoc 源码**，挂载到 **`/app/MrDoc`**
> - **端口**：宿主机 **10086** → 容器 **10086**
> - **标签**：跟做 **`v9.6`**；勿写 `latest`（介绍页若仍写 `v9.1`，以标签列表为准）
> - **体积**：DISK **3.34GB** / CONTENT **883MB**（含 Chromium、LibreOffice）
> - **首次启动**：迁移 → 重建全文索引 → uWSGI 监听 **10086**
> - **管理员**：无预置账号；`createsuperuser` 可建 **`admin`**；生产用强密码
> - **版本**：后台仪表盘显示应用 **MrDoc 1.1.0**（来自挂载源码；镜像标签是运行环境）
> - **目录**：Linux `/www/wwwroot/mrdoc`；macOS `~/docker/mrdoc`
> - **Windows 宿主机**：`docker_mrdoc.sh` 须为 **LF** 换行

官方：[部署手册 · Docker 镜像](https://doc.mrdoc.pro/doc/3958/) · [镜像页](https://xuanyuan.cloud/zh/r/zmister/mrdoc) · [标签列表](https://xuanyuan.cloud/r/zmister/mrdoc/tags) · [Docker Hub](https://hub.docker.com/r/zmister/mrdoc)

---

## 一、zmister/mrdoc 是什么？

`zmister/mrdoc` 提供的是 **MrDoc 运行时**：Python 依赖、uWSGI、Chromium、LibreOffice 已在镜像内。应用代码、配置、默认 SQLite 与上传文件都在你挂载的宿主机目录里。

| | zmister/mrdoc（本文） | BookStack / Wiki.js | 语雀 / Notion 等 SaaS |
|--|----------------------|---------------------|------------------------|
| 定位 | 自托管文档 / 知识库 | 自托管 Wiki | 公有云协作 |
| 镜像形态 | **环境镜像 + 源码挂载** | 多为应用一体镜像 | 无自托管镜像 |
| 工具链 | 内置 Chromium、LibreOffice | 各产品不同 | 厂商侧 |
| 数据 | 本机 MrDoc 目录 | 本机卷 / 数据库 | 出域云端 |
| 适合 | 要控代码与环境一致性 | 偏 Wiki 书架结构 | 快速协作、少运维 |

```text
浏览器 ──HTTP:10086──▶  zmister/mrdoc（uWSGI）
                           ├── Chromium / LibreOffice（镜像内）
                           └── 宿主机 ./MrDoc ──挂载──▶ /app/MrDoc
                                 ├── 源码与配置
                                 ├── 媒体 / 附件
                                 └── 默认 SQLite 等数据
```

[`/r/`](https://xuanyuan.cloud/r/zmister/mrdoc) 与 [`/zh/r/`](https://xuanyuan.cloud/zh/r/zmister/mrdoc) 是同一镜像的不同页面语言。同站还有 BookStack、Wiki.js、ShowDoc 等，**本文只用 `zmister/mrdoc:v9.6`**。

### 1.1 开源版与专业版

| 需求 | 建议 |
|------|------|
| 试用 / 社区版（本文主路径） | clone [Gitee · MrDoc](https://gitee.com/zmister/MrDoc) 并挂载 |
| 已购专业版 | 按授权从 `git.mrdoc.pro` clone **MrDocPro**，同样挂到 `/app/MrDoc` |
| 官方一键安装脚本 | 可另看 [mrdoc-install](https://gitee.com/zmister/mrdoc-install)；本文只讲 **运行环境镜像 + 显式挂载** |

专业版 clone（把账号换成授权信息，**不要**保留花括号）：

```bash
git clone https://用户名:密码@git.mrdoc.pro/MrDoc/MrDocPro.git
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | **Linux**（建议 Ubuntu 24.04）；能访问 Gitee 或专业版 Git |
| Docker | Engine + **Compose V2**（建议 ≥ 20.10） |
| Git | clone MrDoc 源码 |
| 内存 | 建议可用 ≥ **2 GB**（导出 / 转换时宜更宽裕） |
| 磁盘 | 镜像层约 **3.4 GB**，另加源码、附件与数据库增长空间 |
| 端口 | 宿主机 **10086** |
| 工作目录 | `/www/wwwroot/mrdoc` |

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```

备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 三、拉取镜像

### 3.1 标签怎么选

| 标签 | 说明 | 是否跟做 |
|------|------|----------|
| **`v9.6`** | 当前可用的较新版本号标签（多架构） | **推荐** |
| `v9.5` | 上一版 | 按需回滚 |
| `v9.1` 等旧示例 | 介绍页或旧文档常见 | 仅当标签列表仍有、且需对齐旧源码时 |
| `latest` | 浮动（若存在） | **勿写入跟做命令** |

应用源码版本与运行环境镜像尽量匹配；升级前看官方说明。标签以 [轩辕标签列表](https://xuanyuan.cloud/r/zmister/mrdoc/tags) / [Docker Hub Tags](https://hub.docker.com/r/zmister/mrdoc/tags) 为准。

### 3.2 用轩辕镜像加速拉取

```bash
docker pull docker.xuanyuan.run/zmister/mrdoc:v9.6
```

Ubuntu 24.04 实测：

```text
v9.6: Pulling from zmister/mrdoc
a8ac7f6c67ab: Pull complete
ef814d1090ef: Pull complete
bf8f28e06ecc: Pull complete
4f4fb700ef54: Pull complete
5916320cd9ac: Pull complete
882a85d46148: Pull complete
6128e8861235: Pull complete
c8affae2f3ef: Pull complete
aa7ac4429db3: Pull complete
bf876afdf5ee: Pull complete
e1b56bd28b96: Pull complete
28fc89a753e8: Pull complete
8a9289ca32e0: Pull complete
d16aae9c74d9: Download complete
Digest: sha256:41f6bb835c9ca8274904b67b07c8315738848916b671fc57704e91e29a8ca26c
Status: Downloaded newer image for docker.xuanyuan.run/zmister/mrdoc:v9.6
docker.xuanyuan.run/zmister/mrdoc:v9.6
```

```bash
docker images docker.xuanyuan.run/zmister/mrdoc:v9.6
```

```text
IMAGE                                    ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/zmister/mrdoc:v9.6   41f6bb835c9c       3.34GB          883MB
```

---

## 四、Docker Compose 部署（推荐）

### 4.1 准备目录并拉取开源版源码

```bash
sudo mkdir -p /www/wwwroot/mrdoc
cd /www/wwwroot/mrdoc
# macOS：mkdir -p ~/docker/mrdoc && cd ~/docker/mrdoc

git clone https://gitee.com/zmister/MrDoc.git
```

实测 clone 约 **40 MiB**。目录里已有 `manage.py`、`docker_mrdoc.sh` 则不必再 clone。专业版把目录名换成 `MrDocPro`（或你的本地路径），Compose 挂载一并改。

### 4.2 写入 compose.yml

```bash
cd /www/wwwroot/mrdoc

cat > compose.yml <<'EOF'
services:
  mrdoc:
    image: docker.xuanyuan.run/zmister/mrdoc:v9.6
    container_name: mrdoc
    ports:
      - "10086:10086"
    volumes:
      - ./MrDoc:/app/MrDoc
    restart: unless-stopped
EOF
```

| 项 | 说明 |
|----|------|
| `image` | `docker.xuanyuan.run/zmister/mrdoc:v9.6` |
| `ports` | **10086:10086** |
| `volumes` | **必填**：`./MrDoc` → `/app/MrDoc` |
| `restart` | 异常退出后自动拉起 |

若要接外部数据库或关调试，按官方配置在 Compose 里加 `environment` / 改源码配置，**不要**把未验证的占位密码写进生产。

### 4.3 启动并验证

```bash
docker compose up -d
docker compose ps
docker compose logs -f mrdoc
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network mrdoc_default Created
 ✔ Container mrdoc       Started

NAME      IMAGE                                    COMMAND                  SERVICE   CREATED         STATUS         PORTS
mrdoc     docker.xuanyuan.run/zmister/mrdoc:v9.6   "/usr/local/bin/dock…"   mrdoc     6 seconds ago   Up 2 seconds   0.0.0.0:10086->10086/tcp, [::]:10086->10086/tcp
```

首次启动顺序：**数据库迁移** → **重建全文索引** → **uWSGI 监听 10086**。迁移行很多，看成功标志即可（中间省略）：

```text
================================================
  MrDoc 容器启动
================================================
[INFO] Step 1/3: 执行数据库迁移 ...
/app/MrDoc/app_doc/search/whoosh_cn_backend.py:742: SyntaxWarning: "is" with a literal. Did you mean "=="?
  if value is None or len(value) is 0:
Operations to perform:
  Apply all migrations: admin, app_admin, app_ai, app_api, app_doc, auth, contenttypes, sessions
Running migrations:
  Applying contenttypes.0001_initial... OK
  …
  Applying sessions.0001_initial... OK
[ OK ] 数据库迁移完成
[INFO] Step 2/3: 后台重建全文搜索索引 ...
[INFO] Step 3/3: 启动 Web 服务器，监听端口 10086
[INFO] 使用默认 uwsgi 配置: config/uwsgi.ini
[uWSGI] getting INI configuration from /app/MrDoc/config/uwsgi.ini
…
Indexing 0 文档
```

出现 **`[ OK ] 数据库迁移完成`** 和 **`监听端口 10086`** 即可继续。`SyntaxWarning` 来自上游搜索代码，实测不影响启动；空库时 `Indexing 0 文档` 正常。

浏览器打开：

```text
http://服务器IP:10086
```

### 4.4 创建超级管理员

无预置账号，在容器内创建：

```bash
docker exec -it mrdoc python manage.py createsuperuser
```

实测交互如下（密码输入不回显；**请换成你自己的邮箱与强密码**）：

```text
用户名 (leave blank to use 'admin'): admin
电子邮件地址: hi@sourcecodedance.com
Password:
Password (again):
密码长度太短。密码必须包含至少 8 个字符。
这个密码太常见了。
密码只包含数字。
Bypass password validation and create user anyway? [y/N]: y
Superuser created successfully.
```

- 用户名直接回车，默认就是 **`admin`**。
- 过短、过常见或纯数字密码会触发 Django 校验；实验室可答 **`y`** 强行创建，**上线请答 `N` 并改用强密码**。
- 看到 `Superuser created successfully.` 再去浏览器登录。

---

## 五、浏览器首次使用

1. 打开 `http://服务器IP:10086/`。未登录时右上角为 **游客**，首页是空状态。

![MrDoc 首页空状态：游客身份，提示来写一篇文档](https://imgs.xuanyuan.cloud/docker/blog/mrdoc-1.webp)

2. 点右上角 **游客**，进入登录页；输入上一节的用户名与密码，点 **登录**。

![MrDoc 登录页：用户名或邮箱、密码与登录按钮](https://imgs.xuanyuan.cloud/docker/blog/mrdoc-2.webp)

3. 登录后右上角变为 **admin**（或你设的用户名）。仍无文集时首页依旧为空，点右上角 **新建**。

![MrDoc 登录后首页：右上角显示 admin，仍为空文集列表](https://imgs.xuanyuan.cloud/docker/blog/mrdoc-3.webp)

4. 进入 **文档编辑器**。左侧「请选择一个文集」为必选；还没有文集时，先建文集再写正文、点 **发布**。

![MrDoc 文档编辑器：新建文档，左右分栏 Markdown 编辑与预览](https://imgs.xuanyuan.cloud/docker/blog/mrdoc-4.webp)

5. 在编辑器里打开 **新建文集**，填写名称（实测：**测试文集**），权限可选 **公开**，确定后文档即可归属该文集。

![MrDoc 新建文集弹窗：测试文集，权限公开](https://imgs.xuanyuan.cloud/docker/blog/mrdoc-5.webp)

---

## 六、主界面与核心功能

### 6.1 在线表格

首页或编辑器里通过 **新建** 还可建 **表格**。实测在「测试文集」下创建 **测试表格**，支持多 Sheet 与常规单元格编辑，可存草稿或发布。

![MrDoc 表格编辑器：测试表格，Sheet 多页与工具栏](https://imgs.xuanyuan.cloud/docker/blog/mrdoc-6.webp)

### 6.2 首页文集卡片

发布后回首页，文集以卡片展示（实测 **测试文集** 内有「测试表格」「测试文档第一篇」）。卡片上的 **+** 可继续往该文集加文档。

![MrDoc 首页：测试文集卡片，内含测试表格与测试文档第一篇](https://imgs.xuanyuan.cloud/docker/blog/mrdoc-7.webp)

### 6.3 后台管理

点右上角用户名，进入 **后台管理 → 仪表盘**。可见用户 / 文集 / 文档数量、最近动态，以及应用版本 **MrDoc 1.1.0**；侧栏可进文集、用户、站点等管理项。

![MrDoc 后台仪表盘：统计卡片、MrDoc 1.1.0 与最近动态](https://imgs.xuanyuan.cloud/docker/blog/mrdoc-8.webp)

生产建议在前面加 Nginx / Caddy 反代，配 HTTPS 与域名，并收紧管理入口暴露面。

---

## 七、安全、备份与升级

### 7.1 备份

停写或停容器后，打包宿主机源码目录：

```bash
cd /www/wwwroot/mrdoc
docker compose stop
sudo tar -czf mrdoc-backup-$(date +%Y%m%d).tar.gz MrDoc
docker compose start
```

专业版换成实际挂载目录名。

### 7.2 升级

1. 备份 `MrDoc` 目录。  
2. 源码目录按官方说明 `git pull` 或切到目标标签。  
3. 修改 Compose 中的镜像标签。  
4. `docker compose pull && docker compose up -d`。  
5. 看日志；若该版本要求迁移 / 重建索引，按官方文档执行。

**源码大版本与运行环境镜像标签一起规划**，避免新代码配旧运行时（或反过来）。

### 7.3 生产加固

| 项 | 建议 |
|----|------|
| HTTPS | 反代到 `127.0.0.1:10086` |
| 管理员密码 | 强密码，定期轮换 |
| 调试 | 生产关闭 DEBUG |
| 数据库 | 并发与备份要求高时改用 MySQL / PostgreSQL（按官方配置） |
| 暴露面 | 避免管理后台裸奔公网 |

---

## 八、备选：docker run（临时 / 无 Compose）

仍须先有本地源码。开源版：

```bash
docker run -d \
  --name mrdoc \
  --restart unless-stopped \
  -p 10086:10086 \
  -v /www/wwwroot/mrdoc/MrDoc:/app/MrDoc \
  docker.xuanyuan.run/zmister/mrdoc:v9.6
```

专业版把左侧路径改成 `…/MrDocPro`（或你的目录），右侧仍是 `/app/MrDoc`。

```bash
docker exec -it mrdoc python manage.py createsuperuser
docker logs -f mrdoc
```

---

## 九、常见问题 FAQ

**Q1：为什么只 pull 镜像打不开网站？**  
A：这是**运行环境**镜像，不带完整业务源码。必须把本地 MrDoc / MrDocPro 挂到 `/app/MrDoc`。

**Q2：介绍页写 `v9.1`，为什么跟做 `v9.6`？**  
A：以标签列表上仍存在的版本号为准；介绍页示例可能滞后。要对齐某版源码时，选官方推荐的对应标签即可。

**Q3：容器反复重启（尤其 Windows）？**  
A：确认挂载目录完整；把 `docker_mrdoc.sh` 换成 **LF** 换行；检查 **10086** 是否被占用。

**Q4：日志里有 `SyntaxWarning: "is" with a literal`？**  
A：上游 `whoosh_cn_backend.py` 的提示，实测仍能迁移并启动，可忽略。

**Q5：默认管理员密码是什么？**  
A：没有。必须 `createsuperuser`。弱密码可 Bypass 仅便于冒烟，生产请用强密码。

**Q6：和 BookStack、ShowDoc 怎么选？**  
A：要 MrDoc 的文集 / 文档模型用本文；要书本式 Wiki 或 API 文档站，选对应产品，不要混挂目录。

**Q7：能否改宿主机端口？**  
A：可以，例如 `"18086:10086"`，访问改用新端口。

**Q8：删容器会丢数据吗？**  
A：数据在宿主机挂载目录。只删容器、保留目录则数据还在。

**Q9：后台是 1.1.0，镜像却是 v9.6？**  
A：`v9.6` 是运行环境标签；**1.1.0** 是挂载源码里的应用版本。升级时两边一起看官方说明。

---

## 十、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/zmister/mrdoc:v9.6

# 源码（开源版）
sudo mkdir -p /www/wwwroot/mrdoc && cd /www/wwwroot/mrdoc
git clone https://gitee.com/zmister/MrDoc.git

# Compose
docker compose up -d
docker compose ps
docker compose logs -f mrdoc
docker compose down

# 管理员
docker exec -it mrdoc python manage.py createsuperuser

# 备选 run
docker run -d --name mrdoc --restart unless-stopped \
  -p 10086:10086 \
  -v /www/wwwroot/mrdoc/MrDoc:/app/MrDoc \
  docker.xuanyuan.run/zmister/mrdoc:v9.6
```

---

## 十一、延伸阅读

| 资源 | 链接 |
|------|------|
| [zmister/mrdoc 镜像页](https://xuanyuan.cloud/zh/r/zmister/mrdoc) | [https://xuanyuan.cloud/zh/r/zmister/mrdoc](https://xuanyuan.cloud/zh/r/zmister/mrdoc) |
| [zmister/mrdoc 概览](https://xuanyuan.cloud/r/zmister/mrdoc) | [https://xuanyuan.cloud/r/zmister/mrdoc](https://xuanyuan.cloud/r/zmister/mrdoc) |
| [zmister/mrdoc 标签列表](https://xuanyuan.cloud/r/zmister/mrdoc/tags) | [https://xuanyuan.cloud/r/zmister/mrdoc/tags](https://xuanyuan.cloud/r/zmister/mrdoc/tags) |
| [Docker Hub · zmister/mrdoc](https://hub.docker.com/r/zmister/mrdoc) | [https://hub.docker.com/r/zmister/mrdoc](https://hub.docker.com/r/zmister/mrdoc) |
| [Gitee · MrDoc 开源版](https://gitee.com/zmister/MrDoc) | [https://gitee.com/zmister/MrDoc](https://gitee.com/zmister/MrDoc) |
| [MrDoc 部署手册 · Docker 镜像](https://doc.mrdoc.pro/doc/3958/) | [https://doc.mrdoc.pro/doc/3958/](https://doc.mrdoc.pro/doc/3958/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- **`zmister/mrdoc`** = MrDoc **运行环境**（uWSGI + Chromium + LibreOffice），**必须挂载**本地源码到 `/app/MrDoc`。  
- 跟做 **`v9.6`**，用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取。  
- 主路径：clone → Compose → `createsuperuser` → `:10086`。  
- 生产注意强密码、HTTPS、备份，以及源码版本与镜像标签对齐。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/mrdoc-docker-deploy


