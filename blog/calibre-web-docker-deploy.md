# Docker 部署 Calibre-Web：轻松搭建网页版电子书管理平台

![Docker 部署 Calibre-Web：轻松搭建网页版电子书管理平台](https://imgs.xuanyuan.cloud/docker/blog/calibre-web.webp)

*分类: Docker部署教程 | 标签: Calibre-Web,Docker,轩辕镜像,电子书,书库,私有化部署,部署教程 | 发布时间: 2026-08-25 10:12:42*

> 书房那台 Windows 整天开着 Calibre：搜书、改标签、看系列，都得坐在那张桌子前。Kindle 还在等「发送到 Kindle」邮件；iPad 的文件 App 里一堆没封面、没作者的 epub。换一台笔记本，书库还留在旧硬盘。NAS 的下载目录把电子书和电影种子堆在一起，用文件管理器点开，没有「已读」，家人要借一本，只能再拷一遍 U 盘。

*本文基于 [linuxserver/calibre-web:0.6.27](https://xuanyuan.cloud/zh/r/linuxserver/calibre-web)，实测引擎 **Calibre-Web 0.6.27**，Python **3.12.3**，测试平台 **Ubuntu 24.04** Linux。*

书房那台 Windows 整天开着 Calibre：搜书、改标签、看系列，都得坐在那张桌子前。Kindle 还在等「发送到 Kindle」邮件；iPad 的文件 App 里一堆没封面、没作者的 epub。换一台笔记本，书库还留在旧硬盘。NAS 的下载目录把电子书和电影种子堆在一起，用文件管理器点开，没有「已读」，家人要借一本，只能再拷一遍 U 盘。

把整库交到微信读书或 Kindle 云，文件是自己的，账号却是别人的。商业「家庭图书馆」要订阅，阅读记录也落在厂商侧。家里已经有一台跑 Docker 的 Ubuntu 或 NAS，缺的是一个内网网址：手机、平板、KOReader 打开就能借。

**Calibre-Web**（[janeczku/calibre-web](https://github.com/janeczku/calibre-web)）给**现有 Calibre 书库**做网页前端：浏览、搜索、在线读、下载、改元数据，也支持 OPDS。镜像 **`linuxserver/calibre-web`**（[镜像页](https://xuanyuan.cloud/zh/r/linuxserver/calibre-web)）由 [LinuxServer.io](https://docs.linuxserver.io/images/docker-calibre-web/) 维护，容器内 **8083**，用 PUID/PGID 对齐目录权限。它不是带完整桌面的 `linuxserver/calibre`，也不会把一堆散落 epub 扫成书库——根目录必须有 `metadata.db`。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 个人书库 | 打开 `http://192.168.1.35:8083`，按作者 / 标签 / 系列找书，浏览器里读或下载 |
| 家庭共享 | 给家人单独账号，按权限限制下载或查看 |
| 阅读器订阅 | KOReader、Moon+ 等用 OPDS：`http://IP:8083/opds` |
| 与 Calibre 桌面分工 | 桌面负责入库、转换；Web 负责随时读。不要两边同时写同一个 `metadata.db` |

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`linuxserver/calibre-web:0.6.27`**，**Docker Compose** 映射 **8083 → 8083**，空库 wget `metadata.db`、登录后填 `/books`，再启用上传、在线阅读——文内附 **13** 张实测截图。无 Compose 时见文末 **`docker run`**。局域网以实测 **`192.168.1.35`** 为例，请换成你的 IP。

> **上手要点**
> - **部署**：第五节 Compose；临时试玩见第八节
> - **访问**：宿主机 **8083** → 容器 **8083**，实测 `http://192.168.1.35:8083`（`curl` **302** 正常）
> - **顺序**：先 **admin / admin123** 登录，再把书库路径填 **`/books`**；**Separate Book Files**、**Use Google Drive?** 都不要勾
> - **数据**：`./config` → `/config`；`./books` → `/books`。空目录先起容器，再按 6.2 wget 空库；属主必须是 **PUID/PGID**（跟做 **1000:1000**）
> - **账号**：默认 **admin / admin123**（[LinuxServer 文档](https://docs.linuxserver.io/images/docker-calibre-web/)），登录后立刻改密
> - **标签**：**`0.6.27`**（[tags](https://xuanyuan.cloud/r/linuxserver/calibre-web/tags)），不要写 `latest` 或 `nightly`
> - **上传**：管理里先启用上传，顶栏才有「上传书籍」
> - **转换**：关于页默认显示转换器未安装；要转格式再加 Docker Mod（7.8）

官方说明：[LinuxServer · calibre-web](https://docs.linuxserver.io/images/docker-calibre-web/)。应用：[GitHub · janeczku/calibre-web](https://github.com/janeczku/calibre-web)，许可证 **GPL-3.0**。

---

## 一、Calibre-Web 是什么？

网页只负责借阅和管理；书仍按 Calibre 的目录结构躺在磁盘上。

| | Calibre-Web（本文） | Calibre 桌面 | 网文 / Kindle 云 |
|--|---------------------|-------------|------------------|
| 入口 | 浏览器 `IP:8083` | 本机图形界面 | App + 账号 |
| 书文件 | 自己的 `/books` | 本机书库文件夹 | 厂商云端 |
| 适合 | 手机 / 平板 / 内网借阅 | 入库、批量转换、插件 | 买书、订阅 |
| 注意 | 需要 `metadata.db` | 要显示器或远程桌面 | 书与进度受平台约束 |

```text
浏览器 / OPDS 阅读器
        │  HTTP :8083
        ▼
  linuxserver/calibre-web
        ├── /config  ← 宿主机 ./config（用户、设置、app.db）
        └── /books   ← 宿主机 ./books（Calibre 书库，含 metadata.db）
```

拉 **`linuxserver/calibre-web`**。同站还有 `johngong/calibre-web`、已弃用的 `janeczku/calibre-web` 镜像，端口和是否预装转换工具都不一样。完整 Calibre 桌面（拖文件入库、插件）看 `linuxserver/calibre`，不是本文。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64 / arm64** |
| 内存 | 仅 Web：**≥ 512 MB**；加转换 Mod 建议 **≥ 2 GB** |
| 磁盘 | 实测镜像 DISK USAGE **1.13GB** / CONTENT SIZE **265MB**；书库另算 |
| 端口 | 宿主机 **8083**（可改左侧；右侧保持 **8083**） |

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
ss -tlnp | grep 8083
id
```

**8083** 被占用时改成 `"18083:8083"`，访问 `http://IP:18083`。把 `id` 的 uid/gid 写入 Compose 的 `PUID`/`PGID`，并让 `config`、`books` 属于同一用户。用 **root** 登录时不要 `chown "$USER:$USER"`，那会变成 `root:root`，上传时 SQLite 只读。

---

## 三、标签怎么选

跟做只写 **`0.6.27`**。撰写时它常与 `latest`、`version-0.6.27` 同一条稳定线，浮动标签不要写进命令。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`0.6.27`** | 当前稳定应用版本 | **本文跟做** |
| `version-0.6.27` | 同一版本的另一种写法 | 可等同 |
| `0.6.27-ls*` | LinuxServer CI 构建号 | 必须对齐某次构建时 |
| `amd64-0.6.27` / `arm64v8-0.6.27` | 指定架构 | 清单异常时再钉 |
| `latest` | 浮动指针 | **不要写入跟做命令** |
| `nightly` | 上游 master | **不要用于生产** |

完整列表：[tags](https://xuanyuan.cloud/r/linuxserver/calibre-web/tags)。升级时 pull、Compose、`docker run` 三处一起改标签。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/linuxserver/calibre-web:0.6.27
```

Ubuntu 24.04 实测：

```text
0.6.27: Pulling from linuxserver/calibre-web
Digest: sha256:1870b57874a831d7c0c389547826e5be38089c437276299e1646b7c81a497347
Status: Downloaded newer image for docker.xuanyuan.run/linuxserver/calibre-web:0.6.27
docker.xuanyuan.run/linuxserver/calibre-web:0.6.27
```

```bash
docker images docker.xuanyuan.run/linuxserver/calibre-web:0.6.27
```

```text
IMAGE                                                ID             DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/linuxserver/calibre-web:0.6.27   1870b57874a8        1.13GB          265MB
```

---

## 五、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/calibre-web` |
| **macOS** | **`~/docker/calibre-web`** |
| **Windows（Docker Desktop）** | 如 `C:\docker\calibre-web` |

### 5.1 准备目录

```bash
mkdir -p /www/wwwroot/calibre-web/{config,books}
chown -R 1000:1000 /www/wwwroot/calibre-web
cd /www/wwwroot/calibre-web

# macOS：mkdir -p ~/docker/calibre-web/{config,books} && cd ~/docker/calibre-web
```

`id` 不是 1000 时，把这里的数字和 Compose 里 `PUID`/`PGID` 一起改。非 root 给 `mkdir` / `chown` 加 `sudo`。

此时 `books` **可以是空的**。有现成 Calibre 书库，把**整个书库根**（含 `metadata.db` 和作者子目录）拷进来，或把卷改成那个绝对路径。只有散落的 epub，先用 Calibre 桌面建库再拷。完全空白则等容器起来后按 **6.2** wget。不要挂 Windows「Calibre Library」的上一级目录，也不要和 Calibre 桌面**同时写**同一份 `metadata.db`。

### 5.2 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  calibre-web:
    image: docker.xuanyuan.run/linuxserver/calibre-web:0.6.27
    container_name: calibre-web
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      # 可选：x86-64 电子书转换，见 7.8
      # - DOCKER_MODS=linuxserver/mods:universal-calibre
      # - OAUTHLIB_RELAX_TOKEN_SCOPE=1
    volumes:
      - ./config:/config
      - ./books:/books
    ports:
      - "8083:8083"
    restart: unless-stopped
EOF
```

| 项 | 说明 |
|----|------|
| `image` | 钉死 **`0.6.27`** |
| `ports` | **8083→8083** |
| `./config:/config` | 用户、界面选项、内部 `app.db` |
| `./books:/books` | Calibre 书库 |
| `TZ` | `Asia/Shanghai`（官方示例常用 `Etc/UTC`，只影响日志时间） |
| `DOCKER_MODS` | 默认注释掉；转换会再拉一层 |

### 5.3 启动并验证

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 80
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network calibre-web_default Created
 ✔ Container calibre-web       Started
```

```text
NAME          IMAGE                                                COMMAND   SERVICE       CREATED          STATUS         PORTS
calibre-web   docker.xuanyuan.run/linuxserver/calibre-web:0.6.27   "/init"   calibre-web   10 seconds ago   Up 8 seconds   0.0.0.0:8083->8083/tcp, [::]:8083->8083/tcp
```

日志关键行（首次创建 `/config/app.db`；LSIO 会预写 kepubify 路径，关于页仍可能显示「未安装」，见 7.8）：

```text
calibre-web  | User UID:    1000
calibre-web  | User GID:    1000
calibre-web  | First time run, creating app.db...
calibre-web  | Successfully set kepubify paths in '/config/app.db'!
calibre-web  | [custom-init] No custom files found, skipping...
```

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8083/
```

```text
302
```

**302** 表示还没配完书库，浏览器会进登录页或 `/admin/dbconfig`。连接拒绝时先看容器是否 Up、宿主机端口是否写错。

---

## 六、浏览器首次初始化

```text
http://192.168.1.35:8083
```

本机用 `http://127.0.0.1:8083`。防火墙放行 **8083/tcp**。

### 6.1 登录

| 项 | 值 |
|----|-----|
| 用户名 | `admin` |
| 密码 | `admin123` |

可勾选「记住我」。公网或家庭共用前改掉这组默认密码。

![Calibre-Web 登录页：用户名密码与记住我](https://imgs.xuanyuan.cloud/docker/blog/calibre-web-1.webp)

### 6.2 指定书库路径

登录后若尚未指定书库，会进入 **Database Configuration**（之后也可在管理页再打开）。

| 字段 | 怎么填 |
|------|--------|
| **Location of Calibre Database** | **`/books`**（容器内路径，对应 `/www/wwwroot/calibre-web/books`） |
| **Separate Book Files from Library** | **不要勾** |
| **Use Google Drive?** | **不要勾** |

不要填宿主机路径。右侧文件夹按钮在容器文件系统里点选，点到 `/books` 即可。

![Calibre-Web Database Configuration：尚未填写书库路径](https://imgs.xuanyuan.cloud/docker/blog/calibre-web-2.webp)

**Save 之前** `books` 里必须已有 `metadata.db`。空目录实测：

```text
ls: cannot access '/www/wwwroot/calibre-web/books/metadata.db': No such file or directory
```

不要从容器里拷：LinuxServer 镜像没有 `/app/calibre-web/library/metadata.db`。

```text
cp: cannot stat '/app/calibre-web/library/metadata.db': No such file or directory
```

改用上游空库（约 **404 KB**）：

```bash
wget -O /www/wwwroot/calibre-web/books/metadata.db \
  https://github.com/janeczku/calibre-web/raw/master/library/metadata.db

chown -R 1000:1000 /www/wwwroot/calibre-web/books
chmod u+rwX /www/wwwroot/calibre-web/books
chmod u+rw /www/wwwroot/calibre-web/books/metadata.db
ls -ln /www/wwwroot/calibre-web/books
```

Ubuntu 实测 wget 得到 `Length: 413696`。直连 GitHub / `raw.githubusercontent.com` 若卡住，用你本机已有的 HTTP 代理即可。

```text
-rw-r--r-- 1 1000 1000 413696 Aug 25 09:41 metadata.db
```

属主必须是 **1000 1000**，否则上传会报只读数据库。回到网页填 `/books`，两个复选框保持不勾，点 **Save**。成功后顶部出现 **Database Settings updated**。

![Calibre-Web Database Configuration：路径 /books 已保存](https://imgs.xuanyuan.cloud/docker/blog/calibre-web-3.webp)

### 6.3 语言与密码

点右上角用户名 **admin** 进资料。默认邮箱 `admin@example.org`。**Language** 选 **中文 (简体, 中国)** 后保存。同一页的 **Password** 用来改掉 `admin123`。发送到 Kindle 一类阅读器的邮箱也在这里填。

![Calibre-Web 管理员资料：界面语言选简体中文](https://imgs.xuanyuan.cloud/docker/blog/calibre-web-4.webp)

---

## 七、主界面、上传与阅读

界面改成中文后，顶栏是「任务列表 / 管理权限 / admin / 注销」，侧栏按书籍、作者、丛书等浏览。空库没有封面，先建书架或直接去开上传都行。

### 7.1 创建书架

侧栏或书架相关入口进入 **创建书架**。标题实测填 **我的图书**，「书架将被公开」不勾，保存。此时书架还是空的，上传后再回来看封面。

![Calibre-Web 创建书架：标题我的图书](https://imgs.xuanyuan.cloud/docker/blog/calibre-web-5.webp)

### 7.2 关于页

在 **管理权限** 里打开关于。实测空库 **0** 本书；**Calibre Web 0.6.27**，Python **3.12.3**，内核 **6.8.0-138-generic**，ImageMagick **6.9.12-98**，UNRAR **7.23**。**Ebook converter**、**Kepubify** 显示未安装：启动日志虽写入过 kepubify 路径，界面仍要在「外部程序」里确认，转换还要 Docker Mod（7.8）。这不代表容器没起来。

![Calibre-Web 关于页：0.6.27 空库，转换工具未安装](https://imgs.xuanyuan.cloud/docker/blog/calibre-web-6.webp)

### 7.3 管理权限

**管理权限**汇总用户、SMTP、配置和计划任务。跟做时数据库路径 **`/books`**、端口 **8083**。**上传**默认是叉号，下一步去基本配置打开。

![Calibre-Web 管理权限：数据库路径 /books，上传尚未启用](https://imgs.xuanyuan.cloud/docker/blog/calibre-web-7.webp)

### 7.4 网页上传

顶栏默认没有「上传书籍」。

1. **管理权限 → 编辑基本配置**，展开 **功能配置**，勾选 **启用上传**。旁注会提醒用户也要有上传权限。允许的格式默认可含 epub、mobi、azw3、pdf、txt、docx 等，按需改。保存。

![Calibre-Web 功能配置：已勾选启用上传](https://imgs.xuanyuan.cloud/docker/blog/calibre-web-8.webp)

2. `admin` 一般已有上传权限。给以后新建的账号默认打开：**编辑界面配置 → 新用户默认权限设置 → 允许上传书籍**。保存后顶栏出现 **上传书籍**。

![Calibre-Web 界面配置：允许上传书籍，顶栏出现上传按钮](https://imgs.xuanyuan.cloud/docker/blog/calibre-web-9.webp)

3. 回到书库主界面（不要停在货架排序页），点 **上传书籍**，或把文件拖到页面中间，可一次多本。文件进入 `/books` 并写入 `metadata.db`。不要用文件管理器把 epub 直接丢进 `books` 文件夹。若报只读数据库，见 FAQ Q8。

### 7.5 书籍详情与元数据

点封面可改书名、作者、标签、出版社、简介，也可删书。实测上传《爱读书的孩子，不会变坏》（宋怡慧，北京日报出版社，EPUB）。未装 Calibre 转换层时，详情页的「书籍格式转换」不可用。

![Calibre-Web 编辑书籍：爱读书的孩子不会变坏](https://imgs.xuanyuan.cloud/docker/blog/calibre-web-10.webp)

保存后顶部提示 **已成功更新元数据**。可 **下载书籍**（实测 EPUB 约 1.3 MB）或 **在线阅读**。

![Calibre-Web 书籍详情：元数据已更新，可下载与在线阅读](https://imgs.xuanyuan.cloud/docker/blog/calibre-web-11.webp)

### 7.6 内置阅读器

点 **在线阅读** 用浏览器翻 EPUB。实测为双栏目录，左右翻页，右上角有书签和设置，底部进度从 0% 起，地址仍在 `192.168.1.35:8083`。

![Calibre-Web 内置阅读器：爱读书的孩子不会变坏目录页](https://imgs.xuanyuan.cloud/docker/blog/calibre-web-12.webp)

### 7.7 书架

再打开 **我的图书**，封面会出现在书架上。顶栏仍有 **上传书籍**。可下载、删书架、改属性。

![Calibre-Web 书架我的图书：已显示上传的封面](https://imgs.xuanyuan.cloud/docker/blog/calibre-web-13.webp)

### 7.8 外部程序与格式转换

镜像带 **unrar**。在 **基本配置 → 外部程序** 填写：

| 用途 | 路径 |
|------|------|
| Unrar | `/usr/bin/unrar` |
| Kepubify（EPUB → KEPUB） | `/usr/bin/kepubify` |

网页里 EPUB 转 PDF / MOBI 需要完整 Calibre 转换栈。x86-64 可加：

```yaml
      - DOCKER_MODS=linuxserver/mods:universal-calibre
```

国内拉取这一层时可写成 `docker.xuanyuan.run/linuxserver/mods:universal-calibre`。改完 `docker compose up -d`，再把 **Calibre 转换工具路径** 设为 **`/usr/bin/`**（0.6.22 及以上只填目录）。Mod 会明显增大镜像；官方按 **x86-64** 提供。

### 7.9 OPDS

```text
http://192.168.1.35:8083/opds
```

阅读器里按需填 Calibre-Web 用户名和密码。公网走 HTTPS 反代，不要把带密码的 OPDS 明文暴露出去。

---

## 八、备选：docker run

仅临时试玩或没有 Compose 时使用。路径、端口、标签与第五节相同。

```bash
mkdir -p /www/wwwroot/calibre-web/{config,books}
chown -R 1000:1000 /www/wwwroot/calibre-web

docker run -d \
  --name=calibre-web \
  --restart unless-stopped \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -p 8083:8083 \
  -v /www/wwwroot/calibre-web/config:/config \
  -v /www/wwwroot/calibre-web/books:/books \
  docker.xuanyuan.run/linuxserver/calibre-web:0.6.27
```

访问同样是 `http://IP:8083`。与 Compose 重名时先 `docker compose down`，或换 `--name`。

---

## 九、生产加固与升级

| 项 | 建议 |
|----|------|
| 版本 | 保持 **`0.6.27`** 这类具体标签 |
| 密码 | 改掉 `admin123`；按人建号 |
| HTTPS | 前置 Nginx / Caddy / Traefik，反代 `127.0.0.1:8083` |
| 暴露 | 优先内网或 VPN；公网必须 HTTPS + 强密码 |
| 书库锁 | 不要与 Calibre 桌面同时写同一 `metadata.db` |
| 备份 | 备份 `./config` 与整个 `./books` |
| 升级 | 改标签后 `docker compose pull && docker compose up -d` |

忘记密码（换成你的账号和新密码）：

```bash
docker exec -it calibre-web python3 /app/calibre-web/cps.py -p /config/app.db -s <user>:<pass>
```

必须指定 **`/config/app.db`**。指错库时命令看起来会成功，网页登录仍是旧密码。

```bash
cd /www/wwwroot/calibre-web
docker compose pull
docker compose up -d
```

---

## 十、常见问题 FAQ

**Q1：打不开 `:8083`？**  
看 `compose ps` 是否 Up、本机 `curl` 是否 **200/302**、防火墙是否放行。冲突则 `"18083:8083"`。

**Q2：Save 提示书库路径无效？**  
填容器内 **`/books`**，不要填 `/www/wwwroot/...`。目录里要有 **`metadata.db`**，属主与 PUID 一致。只放了 epub、没有 Calibre 书库结构，不行。

**Q3：没有 metadata.db？**  
镜像里没有 `/app/calibre-web/library/metadata.db`。按 **6.2** wget 上游空库（约 404KB），`chown 1000:1000` 后再 Save。

**Q4：默认账号？**  
**admin / admin123**。登录后立刻改密。

**Q5：和 linuxserver/calibre 有什么区别？**  
本文是 Web 借阅。`linuxserver/calibre` 是完整桌面，体积和内存都大得多。可以桌面入库、Web 阅读，不要同时写同一库。

**Q6：和 johngong/calibre-web 呢？**  
另一份社区镜像。本文只跟做 **`linuxserver/calibre-web:0.6.27`**。

**Q7：关于页显示转换器未安装？**  
默认没有 Calibre 转换层。按 **7.8** 填外部程序路径，或加 `DOCKER_MODS`。官方按 x86-64 提供转换 Mod。

**Q8：上传报「attempt to write a readonly database」？**  
`metadata.db` 或 `books` 目录对 uid **1000** 不可写。root 下 `chown "$USER:$USER"`，或 wget 之后没改属主，都会这样。SQLite 还要在目录里写 `-journal` / `-wal`：

```bash
chown -R 1000:1000 /www/wwwroot/calibre-web/config /www/wwwroot/calibre-web/books
chmod u+rwX /www/wwwroot/calibre-web/books
chmod u+rw /www/wwwroot/calibre-web/books/metadata.db
ls -ln /www/wwwroot/calibre-web/books
```

不必重建容器，再上传一次即可。

**Q9：Calibre 桌面提示数据库锁定？**  
Calibre-Web 正在用这份库。先停容器，或只在一边写入。

**Q10：挂到子路径 `/calibre/`？**  
要同时改应用的根路径 / 反代配置，不能只写 Nginx `location`。更省事的是独立域名或独立端口。

**Q11：右上角没有「上传书籍」？**  
先启用上传，再确认当前用户允许上传。不要停在货架排序页再拖文件。

**Q12：拉取 401 / 402？**  
401：见 [登录认证](https://xuanyuan.cloud/usage/login)。402：流量用尽，见 [充值](https://xuanyuan.cloud/recharge)。其它见 [常见问题](https://xuanyuan.cloud/faq)。

---

## 十一、命令速查

```bash
docker pull docker.xuanyuan.run/linuxserver/calibre-web:0.6.27

cd /www/wwwroot/calibre-web
# macOS：cd ~/docker/calibre-web
docker compose up -d
docker compose ps
docker compose logs -f --tail 100
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8083/

# 空库：
wget -O /www/wwwroot/calibre-web/books/metadata.db \
  https://github.com/janeczku/calibre-web/raw/master/library/metadata.db
chown -R 1000:1000 /www/wwwroot/calibre-web/books

# 浏览器 http://192.168.1.35:8083
# 登录 admin / admin123 ，路径填 /books

docker compose down
```

备选：

```bash
docker run -d --name=calibre-web --restart unless-stopped \
  -e PUID=1000 -e PGID=1000 -e TZ=Asia/Shanghai \
  -p 8083:8083 \
  -v /www/wwwroot/calibre-web/config:/config \
  -v /www/wwwroot/calibre-web/books:/books \
  docker.xuanyuan.run/linuxserver/calibre-web:0.6.27
```

---

## 十二、延伸阅读

- [linuxserver/calibre-web 镜像页](https://xuanyuan.cloud/zh/r/linuxserver/calibre-web) · [概览](https://xuanyuan.cloud/r/linuxserver/calibre-web) · [标签列表](https://xuanyuan.cloud/r/linuxserver/calibre-web/tags)
- [LinuxServer 官方文档 · calibre-web](https://docs.linuxserver.io/images/docker-calibre-web/)
- [GitHub · linuxserver/docker-calibre-web](https://github.com/linuxserver/docker-calibre-web)
- [GitHub · janeczku/calibre-web](https://github.com/janeczku/calibre-web) · [Wiki](https://github.com/janeczku/calibre-web/wiki)
- [Docker Hub · linuxserver/calibre-web](https://hub.docker.com/r/linuxserver/calibre-web)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)

---

## 总结

- Compose 拉起 `linuxserver/calibre-web:0.6.27`，**8083→8083**；实测 `curl` **302**，关于页 **0.6.27** / Python **3.12.3**。
- 先登录 **admin / admin123**，再把书库填 **`/books`**。
- 空库：wget 上游 `metadata.db`（404KB）并 **`chown 1000:1000`**；不要从镜像里拷模板。
- 启用上传后加书、改元数据、在线阅读；生产钉死标签，公网加 HTTPS。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/calibre-web-docker-deploy


