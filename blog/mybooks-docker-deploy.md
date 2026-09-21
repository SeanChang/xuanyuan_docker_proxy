# Docker 部署 MyBooks：轻松搭建个人电子书管理平台

![Docker 部署 MyBooks：轻松搭建个人电子书管理平台](https://imgs.xuanyuan.cloud/docker/blog/mybooks.webp)

*分类: Docker部署教程 | 标签: MyBooks,Talebook,poxenstudio/mybooks,Docker,轩辕镜像,电子书,书库,Calibre,私有化部署,部署教程 | 发布时间: 2026-09-21 15:55:41*

> MyBooks 是基于 Calibre 与 Vue 的个人电子书管理系统，可在浏览器里管理电子书、实体书和阅读状态，并做格式转换与有声书。本文将介绍如何通过 Docker Compose 部署社区镜像 poxenstudio/mybooks，用轩辕镜像加速拉取，适合家庭书库、多设备借阅与私有化藏书管理。

*本文基于 [poxenstudio/mybooks:v4.3.1](https://xuanyuan.cloud/zh/r/poxenstudio/mybooks)，实测引擎 **MyBooks v4.3.1**，镜像内置 **Calibre 7.6**，测试平台 **Ubuntu 24.04** Linux。*

微信文件传输助手里躺着没封面的 epub，Kindle 还在等「发送到 Kindle」那封邮件，另一半要借一本，只能再拷一次 U 盘。书房那台 Windows 上的 Calibre 能改作者、转格式，人一离开桌子，手机和平板就进不去书库。NAS 的下载目录把电子书和电影种子堆在一起，用文件管理器点开，没有「在读」，也没有丛书顺序。

把整库同步到微信读书或 Kindle 云，文件还在，账号和阅读记录却在别人那边。项目说明里也写了：这个程序给个人和家庭管书，不适合做成公开书站。家里已经有一台跑 Docker 的 Ubuntu 或 NAS，缺的是一个内网网址：浏览器打开就能检索、在线读、记阅读状态。

**MyBooks**（[PoxenStudio/mybooks](https://github.com/PoxenStudio/mybooks)，[项目首页](https://mybooks.top/)）是基于 Calibre 和 Vue 的个人图书网站。浏览器里可以检索、在线读、记阅读状态，也能管实体书和有声书。镜像页是 [poxenstudio/mybooks](https://xuanyuan.cloud/r/poxenstudio/mybooks)，书库和配置放在容器里的 `/data`。第一次启动会在这个目录里放好书库，然后在网页上完成安装。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 个人书库 | 打开 `http://192.168.1.35:8082`，按作者、标签、丛书找书，浏览器里读或下载 |
| 家庭账号 | 安装时创建管理员，再在后台加家人账号；私藏书只对上传者可见 |
| 阅读器与网盘 | WebDAV：`http://IP:8082/books`；也可推到支持 Wi-Fi 传书的设备或 Kindle |
| 有声与转换 | 管理里把 EPUB 转有声书，或在 EPUB、AZW3、PDF 之间转换 |

官方说明：[MyBooks 首页](https://mybooks.top/)、[GitHub README](https://github.com/PoxenStudio/mybooks)、[使用指南](https://github.com/PoxenStudio/mybooks/blob/master/document/UserGuide.zh_CN.md)。许可证见仓库 [LICENSE](https://github.com/PoxenStudio/mybooks/blob/master/LICENSE)。

---

## 一、MyBooks 是什么？

网页负责检索、阅读记录和推送；书文件按 Calibre 书库结构躺在你挂载的磁盘上。

| | MyBooks（本文） | Calibre-Web | Calibre 桌面 |
|--|-----------------|-------------|--------------|
| 入口 | 浏览器 `IP:8082` | 浏览器 `IP:8083` | 本机图形界面 |
| 书库 | 容器首次启动准备 `/data` | 必须已有 `metadata.db` | 本机书库文件夹 |
| 界面 | Vue，含深色模式与简版 `/wap` | 经典 Web 书库 | 桌面程序 |
| 适合 | 个人/家庭藏书、实体书、有声书、推送到设备 | 给现成 Calibre 库做网页前端 | 入库、批量转换、插件 |
| 注意 | 只建议个人使用；PUID 不要用 0 | 不要和桌面同时写同一个库 | 要显示器或远程桌面 |

```text
浏览器 / WebDAV / 阅读器
        │  HTTP :8082     HTTPS :8443
        ▼
  poxenstudio/mybooks（nginx → 应用）
        └── /data  ← 宿主机 ./data
              ├── books/     书库与导入目录
              ├── reader/    阅读相关数据
              ├── sync/      同步
              └── log/       含 mybooks.log
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04**；macOS 目录用 `~/docker/mybooks` |
| Docker | Engine + **Compose V2** |
| 架构 | **linux/amd64**、**linux/arm64**（`v4.3.1` 两个架构都有） |
| 内存 | 浏览、上传即可；格式转换和有声书更吃内存，不要同时转很多本 |
| 磁盘 | Hub 标签页标注 amd64 压缩约 **688 MB**；解压后占用与书库另计 |
| 端口 | 宿主机 **8082**（HTTP）、**8443**（HTTPS）。容器内仍是 **80 / 443** |

```bash
docker --version
docker compose version
id -u
id -g
```

`id` 若不是 `1000`，后文 Compose 里的 `PUID` / `PGID` 和 `chown` 改成你的数字，两边保持一致。

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```

备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

---

## 三、拉取镜像

### 3.1 标签怎么选

| 标签 | 说明 | 是否跟做 |
|------|------|----------|
| **`v4.3.1`** | 当前较新的具体版本，amd64 / arm64。界面「版本变更」日期 **2026-09-22**：样式自定义、封面支持 WebP、分类可拖拽排序 | **推荐** |
| `v4.3.0` | 与 `latest` 摘要相同；GitHub Release 说明补录阅读时间、EPUB 合并/美化、目录提取、动态工具等 | 可回退 |
| `v4.2.2` 及更早 | 旧线 | 仅在新标签不适配时使用 |
| `latest` | 浮动标签，目前指向的是 `v4.3.0` 那一份，不是 `v4.3.1` | **勿写入跟做命令** |

完整列表见 [标签页](https://xuanyuan.cloud/r/poxenstudio/mybooks/tags)。升级时只改 Compose 里的标签，数据卷保持不动，并对照 [上游 Releases](https://github.com/PoxenStudio/mybooks/releases)。

### 3.2 用轩辕镜像加速拉取

```bash
docker pull docker.xuanyuan.run/poxenstudio/mybooks:v4.3.1
```

Ubuntu 24.04 实测：

```text
v4.3.1: Pulling from poxenstudio/mybooks
384c1a306f90: Pull complete
86f1d3c6100a: Pull complete
4f999672cf78: Pull complete
ea4fde388bb6: Pull complete
0dcce47e152f: Pull complete
0d3c46a944f1: Pull complete
7eb114863ab1: Pull complete
9f59433206d1: Pull complete
8bc56c7e8827: Pull complete
32087922cec2: Pull complete
05f50a56c1b6: Pull complete
ef99b07e9440: Pull complete
49b1eabc87b3: Pull complete
a6abe7de7f1f: Pull complete
b1615684f23e: Pull complete
c04e049990d9: Pull complete
25bfaf540d62: Pull complete
edd1ed89f0d4: Pull complete
0ca65c545c39: Pull complete
9e65d9cbfcbf: Pull complete
0611d854016c: Pull complete
d218a61167a7: Pull complete
ffe9cc2bd9bb: Pull complete
98799b28a660: Pull complete
b771065d6756: Download complete
Digest: sha256:05a7482c93e7492b840f078c2438027035301f9b8fab3d69e30e17ba027c1f2d
Status: Downloaded newer image for docker.xuanyuan.run/poxenstudio/mybooks:v4.3.1
docker.xuanyuan.run/poxenstudio/mybooks:v4.3.1
```

---

## 四、Docker Compose 部署（主路径）

推荐顺序：**建目录并改属主 → 写入 compose.yaml → `up -d` → 浏览器安装向导**。

官方仓库里的 [docker-compose.yml](https://github.com/PoxenStudio/mybooks/blob/master/docker-compose.yml) 把 HTTP 映成宿主机 **3000**，数据卷示例是 `/tmp/mybooks`，镜像也没写版本号。下面改成 `/www/wwwroot/mybooks`、宿主机 **8082** 和 **`v4.3.1`**。卷仍是 `/data`，`PUID` / `PGID` / `TZ` 与上游一致，HTTPS 仍映 **443**。

### 4.1 准备目录

```bash
sudo mkdir -p /www/wwwroot/mybooks/data
sudo chown -R 1000:1000 /www/wwwroot/mybooks/data
cd /www/wwwroot/mybooks
```

macOS 把 `/www/wwwroot/mybooks` 换成 `~/docker/mybooks`，`chown` 的数字与 `id -u`、`id -g` 一致。

容器入口会在 `/data` 下准备 `books`、`sync`、`reader`、`log`，以及有声书导入目录 `books/imports/audiobooks`。目录属主若与 `PUID:PGID` 不符，启动脚本会尝试改回来；仍然建议宿主机先 `chown`，避免你在外面读不到日志和书库。

### 4.2 写入 compose.yaml

```bash
cd /www/wwwroot/mybooks
cat > compose.yaml <<'EOF'
services:
  mybooks:
    image: docker.xuanyuan.run/poxenstudio/mybooks:v4.3.1
    container_name: mybooks
    restart: unless-stopped
    ports:
      - "8082:80"
      - "8443:443"
    volumes:
      - ./data:/data
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
EOF
```

| 项 | 作用 |
|----|------|
| `"8082:80"` | 浏览器 HTTP。左侧可改，右侧保持 **80** |
| `"8443:443"` | HTTPS。跟做先用 HTTP；没有证书时不要改用 `https://` 当默认入口 |
| `./data:/data` | 书库、配置、日志。换机器时拷这个目录 |
| `PUID` / `PGID` | 容器内写文件的用户。**不要写 0** |
| `TZ` | 阅读时间和日志的时区 |

官网示例还会再挂一个豆瓣元数据容器。该镜像目前只有浮动标签，本文主路径不包含它，见 FAQ。

### 4.3 启动

```bash
cd /www/wwwroot/mybooks
docker compose up -d
docker compose ps
docker compose logs --tail 80
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network mybooks_default Created  0.3s
 ✔ Container mybooks       Started  2.3s
```

```text
NAME      IMAGE                                            COMMAND                  SERVICE   CREATED         STATUS         PORTS
mybooks   docker.xuanyuan.run/poxenstudio/mybooks:v4.3.1   "/var/www/mybooks/do…"   mybooks   5 seconds ago   Up 3 seconds   0.0.0.0:8082->80/tcp, [::]:8082->80/tcp, 0.0.0.0:8443->443/tcp, [::]:8443->443/tcp
```

容器显示 **Up** 只说明进程已启动，nginx 这时往往还没听 80。启动后约 3 秒抓到的日志停在改权限：

```text
mybooks  | [MyBooks]Starting....
mybooks  | [MyBooks] Checked and parepared the default folders.
mybooks  | [MyBooks] Checked the library
mybooks  | [MyBooks] Checking the permission...
mybooks  | updating '/data/' permission to 1000:1000
mybooks  | [MyBooks] permission updated!
```

日志里的 `parepared` 是脚本原文的拼写，不是报错。权限改完后还要初始化书库和数据库。这段时间执行 `curl -sI http://127.0.0.1:8082/` 会没有任何输出，`-s` 把连接失败藏掉了。再等一会儿，`--tail 40` 里能看到应用日志。Ubuntu 24.04 实测就绪时，关键行是：

```text
mybooks  | INFO:root:Init library with [/data/books/library]
mybooks  | INFO:root:Init AuthDB  with [sqlite:////data/books/calibre-webserver.db]
mybooks  | INFO:root:SQLite journal_mode set to WAL
mybooks  | INFO:root:Using library path: [/data/books/library]
mybooks  | INFO:root:The installed version is NONE,  need to check or upgrade table structure.
mybooks  | INFO:root:Now, Running...
```

横幅右下角印着 **v4.3.1**，最后是 `INFO:root:Now, Running...`。接着可能刷出 jieba 的 `SyntaxWarning: invalid escape sequence`，那是依赖库的正则提示，安装页可以打开。`The installed version is NONE` 表示还没走过网页安装，书库目录本身已经由入口脚本铺好。若出现 `目录权限异常，无法写入`，核对 `PUID`/`PGID` 与 `./data` 属主，不要写成 0。

然后在浏览器打开 `http://192.168.1.35:8082`。这是实测那台机器的地址，换成你自己的局域网 IP。页面是安装向导。

---

## 五、浏览器初始化

### 5.1 安装向导

第一次打开是「安装 MyBooks」。网站标题保持 **MyBooks**，默认语言选 **中文**，管理员用户名用预填的 **admin**，密码和邮箱自己填。**「开启私人图书馆模式」不要勾**，勾上之后访客浏览会受限制。

提交后蓝条会变成「正在写入配置文件...配置文件写入成功！」和「正在检测服务器...」。装完就不能再进这个页面。想重装，先 `docker compose down`，备份并清空 `./data`，再 `up -d`。

![MyBooks 安装页：网站标题 MyBooks、语言中文、管理员 admin，配置写入成功](https://imgs.xuanyuan.cloud/docker/blog/mybooks-1.webp)

### 5.2 先看首页，再登录

提交成功后进入首页，侧栏此时仍是「登录」，安装并不会自动保持登录。第一次会弹出「版本变更」：**v4.3.1**（2026-09-22），内容是样式自定义、封面上传支持 WebP、分类可拖拽排序。点「关闭」。

页脚是「基于 Calibre 构建」，系统版本 **v4.3.1**。库里已经有一本内置 EPUB：《MyBooks 产品功能帮助文档》，所以在库数量是 1。

![MyBooks 首页版本变更弹窗：v4.3.1，2026-09-22](https://imgs.xuanyuan.cloud/docker/blog/mybooks-2.webp)

右上角调色板里可以换浅色 / 深色、主色、顶栏颜色，也能改圆角和背景纹理。不改，默认深色就能用。

![MyBooks 外观设置：浅色深色、主色与顶栏颜色](https://imgs.xuanyuan.cloud/docker/blog/mybooks-3.webp)

未登录也能点开侧栏里的作者、分类、有声书、实体书。作者计数为 1，就是那本帮助文档。

![MyBooks 首页侧栏：有声书、实体书、作者与分类](https://imgs.xuanyuan.cloud/docker/blog/mybooks-4.webp)

帮助文档约 1MB。详情页能阅读和下载。往下翻到帮助正文第 2 页，写明两件事：新书丢进容器 **`/data/books/imports/`**（宿主机 `./data/books/imports/`），再用网页扫描导入；已有 Calibre 书库，把 `library` 放进 **`/data/books/`**。

![MyBooks 帮助文档详情：EPUB、阅读与下载](https://imgs.xuanyuan.cloud/docker/blog/mybooks-5.webp)

![MyBooks 内置帮助第 2 页：导入目录 /data/books/imports](https://imgs.xuanyuan.cloud/docker/blog/mybooks-6.webp)

上传和系统管理要先登录。侧栏顶部「登录」指向 `http://192.168.1.35:8082/login`。用户名填 **admin**，密码填安装时设的那一串。

![MyBooks 首页侧栏：登录入口](https://imgs.xuanyuan.cloud/docker/blog/mybooks-7.webp)

![MyBooks 登录页：欢迎访问，用户名 admin](https://imgs.xuanyuan.cloud/docker/blog/mybooks-8.webp)

登录后侧栏多出「我的账户」「系统管理」「我的阅读」。首页出现阅读时长、下载/推送和阅读热力图。右下角红色按钮上传文件，绿色按钮手动加一条书目。

![MyBooks 登录后首页：阅读时长、热力图与新书推荐](https://imgs.xuanyuan.cloud/docker/blog/mybooks-9.webp)

### 5.3 上传一本书

点右下角上传，弹出「上传书籍」，可以多选。实测传了宫泽贤治《银河铁道之夜》。批量导入结果里进度是「正在扫描导入 (1/1)」，标签为「导入成功」。

![MyBooks 上传书籍弹窗：可多选电子书](https://imgs.xuanyuan.cloud/docker/blog/mybooks-10.webp)

![MyBooks 批量导入结果：银河铁道之夜导入成功](https://imgs.xuanyuan.cloud/docker/blog/mybooks-11.webp)

关掉弹窗后，在库数量变成 **2**（两本都是电子书）。新书推荐里能看到《银河铁道之夜》（AZW3）和原来的帮助文档（EPUB）。

![MyBooks 首页：在库 2 本，新书推荐含银河铁道之夜](https://imgs.xuanyuan.cloud/docker/blog/mybooks-12.webp)

---

## 六、读一本书，并看系统管理

《银河铁道之夜》详情里，作者是宫泽贤治，格式 **AZW3**，约 2MB，出版社是百花洲文艺出版社（2011）。点「设为在读」后，首页阅读状态里能对上这本书；点「阅读」进入阅读器。

![MyBooks 银河铁道之夜详情：AZW3、设为在读、阅读与下载](https://imgs.xuanyuan.cloud/docker/blog/mybooks-13.webp)

阅读器是深色双栏，左侧目录。实测打开的是「01 夜鹰星」，页码 **4 / 133**。

![MyBooks 阅读器：银河铁道之夜目录与双栏正文](https://imgs.xuanyuan.cloud/docker/blog/mybooks-14.webp)

「系统管理」是一列折叠项。这次只用看清它们在哪：基础信息里核对站点标题；用户设置里以后加家人账号；邮件服务留到要推 Kindle 时再填，发信账号不要写进 `compose.yaml`。AI 助手、社交登录、友情链接可以先不动。

![MyBooks 系统管理：基础信息、AI 助手、邮件服务与书籍分类](https://imgs.xuanyuan.cloud/docker/blog/mybooks-15.webp)

右上角铃铛里会依次出现导入成功、目录提取完成、格式转换完成。转换结束后，同一本书同时有 AZW3 和 EPUB。读过开头几页后，首页阅读时长从 0 变成 **0.01** 小时。

![MyBooks 消息通知：格式转换、目录提取与导入成功](https://imgs.xuanyuan.cloud/docker/blog/mybooks-16.webp)

这些都不用改 Compose：

| 能力 | 怎么用 |
|------|--------|
| 丢文件导入 | 电子书放到宿主机 `./data/books/imports/`，再在网页里扫描导入 |
| 迁入 Calibre 库 | 把原来的 `library` 放进 `./data/books/`。不要和 Calibre 桌面同时写这一份库 |
| WebDAV | `http://192.168.1.35:8082/books`。Windows 未启用 HTTPS 时，要先允许 WebClient 使用 HTTP 基本认证，步骤见 [上游说明](https://github.com/PoxenStudio/mybooks#使用webdav连接) |
| 简版页面 | `http://192.168.1.35:8082/wap` |
| OPDS | 页脚「OPDS 介绍」里的地址，给 KOReader 等阅读器订阅 |

有声书和格式转换吃 CPU。通知里出现「转换完成」就说明转好了，不必因为 jieba 的 `SyntaxWarning` 去重启容器。

---

## 七、升级与备份

升级只改标签，不要删数据卷：

```bash
cd /www/wwwroot/mybooks
# 编辑 compose.yaml，把 image 标签换成新的具体版本
docker compose pull
docker compose up -d
```

备份：

```bash
cd /www/wwwroot/mybooks
docker compose stop
sudo tar -C /www/wwwroot/mybooks -czf mybooks-data-$(date +%F).tar.gz data
docker compose start
```

恢复时停容器，把 `data` 解回同一路径，再 `up -d`。属主仍须是 Compose 里的 `PUID:PGID`。

---

## 八、备选：docker run

没有 Compose 时再用。参数与第四节相同。

```bash
sudo mkdir -p /www/wwwroot/mybooks/data
sudo chown -R 1000:1000 /www/wwwroot/mybooks/data

docker run -d \
  --name mybooks \
  --restart unless-stopped \
  -p 8082:80 \
  -p 8443:443 \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -v /www/wwwroot/mybooks/data:/data \
  docker.xuanyuan.run/poxenstudio/mybooks:v4.3.1
```

查看状态：

```bash
docker ps --filter name=mybooks
docker logs --tail 80 mybooks
```

停掉并删除容器（数据仍在 `/www/wwwroot/mybooks/data`）：

```bash
docker rm -f mybooks
```

---

## 九、常见问题

**刚启动时 `curl` 没有输出？**  
容器状态已经是 **Up** 时，80 端口可能还没听。`curl -sI` 的 `-s` 会把连接失败藏掉。等 `docker compose logs --tail 40` 里出现 `Now, Running...`，再打开 `http://192.168.1.35:8082`。

**为什么不用 `latest`？**  
`latest` 会跟着仓库更新，界面步骤可能和本文对不上。Hub 上它目前和 **`v4.3.0`** 是同一份镜像，**`v4.3.1`** 是更新的一份。命令里写 `v4.3.1`。

**官方 Compose 是 3000，为什么这里是 8082？**  
容器内 HTTP 就是 **80**。宿主机 **3000** 容易和本机 Node / 前端开发冲突，所以改映 **8082**，与 [官网安装示例](https://mybooks.top/) 的 HTTP 端口一致。访问写 `http://IP:8082`，不要写成 `:3000`。

**页面 500，或日志说目录不可写。**  
先看宿主机 `/www/wwwroot/mybooks/data/log/mybooks.log` 里最后一次 `Traceback`。最常见是 `./data` 属主不是 `PUID:PGID`。把 `PUID`/`PGID` 设成 `id -u` / `id -g`，**不要设 0**：官方说明设成 root 时，部分封面抽不出来，导入也可能失败。

**和 Calibre-Web 怎么选？**  
已有 Calibre 书库、只想在网页上借阅，用 [Calibre-Web](https://xuanyuan.cloud/blog/calibre-web-docker-deploy)。要从网页安装向导建库，还要实体书、有声书和中文简繁搜索，用 MyBooks。两个程序各用各的数据目录。

**以前的镜像叫 talebook？**  
改名之后的镜像是 `poxenstudio/mybooks`。旧容器如果还在跑，继续用它原来的数据目录；这次新建的目录是 `/www/wwwroot/mybooks/data`。

**要不要再跑豆瓣接口？**  
上传和阅读不依赖它。官网示例另起 `poxenstudio/douban-api-rs`，装好后在系统管理里把互联网书籍信息源设为 `http://douban-rs-api:80/`。该镜像目前只有 `latest`，所以没有放进本文命令。需要刮削时再按 [官网](https://mybooks.top/) 追加，MyBooks 本身仍用 **`v4.3.1`**。

**阅读器空白，或静读天下打不开。**  
阅读器空白时，先关掉广告拦截（例如 uBlock Origin）再试。静读天下不带 Cookie，需要按 [使用指南](https://github.com/PoxenStudio/mybooks/blob/master/document/UserGuide.zh_CN.md) 关闭「私人图书馆」，并打开允许访客下载，否则登录会失败。

**可以放到公网吗？**  
本文按内网写。8082 不要直接暴露到公网。项目定位是个人书库，不适合做成公开书站。

---

## 十、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/poxenstudio/mybooks:v4.3.1

# 目录
sudo mkdir -p /www/wwwroot/mybooks/data
sudo chown -R 1000:1000 /www/wwwroot/mybooks/data
cd /www/wwwroot/mybooks

# Compose（compose.yaml 见第四节）
docker compose up -d
docker compose ps
docker compose logs --tail 80 mybooks
docker compose down

# 探测（等日志出现 Now, Running... 之后）
curl -sI http://127.0.0.1:8082/

# 备选 run
docker run -d --name mybooks --restart unless-stopped \
  -p 8082:80 -p 8443:443 \
  -e PUID=1000 -e PGID=1000 -e TZ=Asia/Shanghai \
  -v /www/wwwroot/mybooks/data:/data \
  docker.xuanyuan.run/poxenstudio/mybooks:v4.3.1
```

浏览器：`http://<服务器IP>:8082` · 标签 **`v4.3.1`** · 卷 **`/data`**

---

## 十一、延伸阅读

| 资源 | 链接 |
|------|------|
| [poxenstudio/mybooks 镜像页](https://xuanyuan.cloud/r/poxenstudio/mybooks) | [https://xuanyuan.cloud/r/poxenstudio/mybooks](https://xuanyuan.cloud/r/poxenstudio/mybooks) |
| [镜像标签列表](https://xuanyuan.cloud/r/poxenstudio/mybooks/tags) | [https://xuanyuan.cloud/r/poxenstudio/mybooks/tags](https://xuanyuan.cloud/r/poxenstudio/mybooks/tags) |
| [Docker Hub · poxenstudio/mybooks](https://hub.docker.com/r/poxenstudio/mybooks) | [https://hub.docker.com/r/poxenstudio/mybooks](https://hub.docker.com/r/poxenstudio/mybooks) |
| [GitHub · PoxenStudio/mybooks](https://github.com/PoxenStudio/mybooks) | [https://github.com/PoxenStudio/mybooks](https://github.com/PoxenStudio/mybooks) |
| [MyBooks 首页](https://mybooks.top/) | [https://mybooks.top/](https://mybooks.top/) |
| [使用指南](https://github.com/PoxenStudio/mybooks/blob/master/document/UserGuide.zh_CN.md) | [https://github.com/PoxenStudio/mybooks/blob/master/document/UserGuide.zh_CN.md](https://github.com/PoxenStudio/mybooks/blob/master/document/UserGuide.zh_CN.md) |
| [Calibre-Web 部署教程](https://xuanyuan.cloud/blog/calibre-web-docker-deploy) | [https://xuanyuan.cloud/blog/calibre-web-docker-deploy](https://xuanyuan.cloud/blog/calibre-web-docker-deploy) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/mybooks-docker-deploy


