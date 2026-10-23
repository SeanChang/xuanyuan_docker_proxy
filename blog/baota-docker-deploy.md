# Docker 部署宝塔面板：轻松搭建网站与服务器管理平台

![Docker 部署宝塔面板：轻松搭建网站与服务器管理平台](https://imgs.xuanyuan.cloud/docker/blog/baota/baota.webp)

*分类: Docker部署教程 | 标签: 宝塔面板,宝塔,btpanel/baota,Docker,轩辕镜像,网站管理,私有化部署,部署教程 | 发布时间: 2026-10-22 14:18:32*

> 宝塔面板是堡塔安全面向 Linux 服务器运维的管理软件，旨在把网站、数据库、FTP 和运行环境放在同一套网页里管理，并通过软件商店安装 LNMP 或 LAMP。本文将介绍如何通过 Docker Compose 部署宝塔面板，搭建网站与服务器管理平台，帮助个人和站长在容器里安装环境并管理站点，适合单独准备的 Linux 服务器及内网试用等场景。

*本文基于 [btpanel/baota:9.0_lts_lnmp](https://xuanyuan.cloud/zh/r/btpanel/baota)。Docker Hub 简介将该标签标为 **9.0.0 LTS** 稳定版，在 **Ubuntu 24.04** Linux 上部署并登录。*

## 宝塔面板是什么

宝塔面板是堡塔安全发布的 Linux 服务器管理软件，也叫宝塔 Linux 面板。它在网页里安装网站运行环境，并管理网站、FTP 和数据库。官方镜像 `btpanel/baota` 由堡塔安全发布，提供 x86_64 和 arm64。

与直接在操作系统里执行安装脚本不同，这个镜像把面板放在容器里。Docker Hub 简介写明，容器里默认隐藏左侧「安全」和「Docker」，并且不提供 systemd。登录后的左侧菜单里也没有这两项。面板管理的是容器中的网站和数据库。

## 宝塔面板能做什么

- **查看运行状况**：首页同时显示负载、CPU、内存和磁盘。
- **添加网站**：填写域名和根目录，选择 Nginx 与 PHP 版本。
- **管理 FTP 和数据库**：在网页里新建 FTP 用户和 MySQL 库。
- **从软件商店安装组件**：商店里可以查看已经装上的 Nginx、MySQL、FTP 和 phpMyAdmin。
- **浏览网站目录**：文件页打开容器里的网站根目录。

## 为什么要使用宝塔面板

在系统里直接跑安装脚本，会改这台机器上的软件和开机服务。只想在一台单独的机器上用网页管网站时，可以把面板放进容器。

它适合还没有占用 80 和 443 的 Linux 服务器，也适合先在内网打开界面。宿主机上已经有 Nginx，或者已经装过另一套宝塔时，先看端口是否空着，再启动。

## 使用 Docker 部署宝塔面板

堡塔安全提供了现成的容器镜像，本机不必再执行面板的安装脚本。开始之前，先准备好 Docker，并确认要发布到宿主机的端口没有被占用。

接下来用 Docker Compose 写好端口和数据目录，启动服务。面板起来之后先设置登录密码，再在浏览器里登录，并修改用户名、密码和安全入口。

## 环境要求

本文命令使用 `btpanel/baota:9.0_lts_lnmp`。标签怎么对应，见「标签怎么选」。

仓库 README 写明镜像支持 **x86_64** 和 **arm64**。Docker Hub 上 `9.0_lts_lnmp` 同时有 **linux/amd64** 和 **linux/arm64**，拉取时会按本机架构选择。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）。macOS 把 `/www/wwwroot/baota` 换成 `~/docker/baota` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64** |
| 磁盘 | 镜像本身，以及 `wwwroot/`、`mysql/`、`vhost/` |
| 端口 | 宿主机 **38888** → 容器 **8888**（面板）。网站 **8080** → **80**，**8443** → **443** |
| 工作目录 | `/www/wwwroot/baota` |

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

## 标签怎么选

新安装使用 **`9.0_lts_lnmp`**。Docker Hub 简介把这一标签写成 **9.0.0 LTS** 稳定版，推送时间是 **2024-09-24**，amd64 与 arm64 都有。

仓库 README 还写了 **11.0.0** 正式版和 **10.0.0 LTS**，并写除带 `9.0_lts`、`10.0_lts` 的标签外，其它镜像为 **11.8.1**。仓库里没有 `11.8.1` 这个标签。Docker Hub 简介仍把 `latest` 写成 **9.3.0**、Debian 12，仓库 README 则写成 Debian 13。`latest` 和 `lnmp` 都会随下一次构建变化，本文命令不使用。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`9.0_lts_lnmp`** | Docker Hub 简介中的 **9.0.0 LTS** 稳定版拉取标签，**2024-09-24** 推送 | **是** |
| `10.0_lts` | 仓库 README 点名的 **10.0.0 LTS**。Docker Hub 上 **2025-08-14** 推送。README 没有写这个标签预装了哪些 Web 组件 | 否 |
| `9.0_lts_lib` | README：基于 Debian 12，稳定版面板，以及后续装环境用的依赖。**2025-01-07** 推送 | 否 |
| `9.0_lts_fresh` | README：基于 Debian 12，安装稳定版面板。**2025-01-07** 推送 | 否 |
| `lnmp` | Docker Hub 简介：面板、依赖包，以及 LNMP（Nginx 1.26、MySQL 8、PHP 8）。**2025-08-14** 推送。没有面板版本号 | 否 |
| `lamp` | Docker Hub 简介：面板、依赖包，以及 LAMP（Apache 2.4、MySQL 8、PHP 8）。**2025-08-14** 推送 | 否 |
| `latest` | 简介与仓库 README 对版本和 Debian 版本的写法不一致。**2026-07-23** 推送 | 否 |
| `nas` | README：基于 Debian 13，安装面板和 Nginx 1.30。**2026-07-23** 推送 | 否 |
| `slim` | README：基于 `debian:bookworm-slim`，只安装面板。**2025-01-07** 推送 | 否 |
| `7.9.4-lnmp` | Docker Hub 简介中的旧版 LNMP：Nginx 1.22、MySQL 5.7、PHP 7.4。简介写 arm 架构的 MySQL 是 5.6。**2024-03-11** 推送 | 否 |

完整标签见[标签列表](https://xuanyuan.cloud/r/btpanel/baota/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/btpanel/baota:9.0_lts_lnmp
```

Ubuntu 24.04 拉取：

```text
9.0_lts_lnmp: Pulling from btpanel/baota
1c58f7e4ec1a: Pull complete
387823b46a63: Pull complete
35349fddfb39: Pull complete
07cd130114f7: Pull complete
cf301ef6b658: Pull complete
b99293c3a024: Pull complete
d3cfce06d169: Pull complete
3d3bffcb6a25: Pull complete
150facbcbab5: Pull complete
2d473b07cdd5: Pull complete
2e30de9b630b: Pull complete
Digest: sha256:7b08b8269b78f469e43681b1c100852ba1ee2c9d8b00294e4807792efb0f98a1
Status: Downloaded newer image for docker.xuanyuan.run/btpanel/baota:9.0_lts_lnmp
docker.xuanyuan.run/btpanel/baota:9.0_lts_lnmp
```

## Docker Compose 部署

容器内面板监听 **8888**，网站监听 **80** 和 **443**，phpMyAdmin 监听 **888**，SSH 监听 **22**。仓库 Compose 示例把这些端口改映到宿主机的高位端口，避开宿主机自己的 22、80、443。本文按这个示例。仓库示例里还有 `33306:3306`。不从别的机器连接数据库时，本文不映射 **3306**。

这台机器专门用来放网站，并且宿主机 **80**、**443** 是空的时，把 `8080:80` 改成 `80:80`，把 `8443:443` 改成 `443:443`。面板仍用 **38888**。不用 SSH 或 phpMyAdmin 时，删掉对应的两行端口。登录之前不要把 **38888** 暴露到公网。

镜像里的面板、Nginx 和 PHP 放在容器的 `/www/server`。宿主机目录是空的时，不能整份盖住 `/www`。空目录会把这些文件挡住，38888 上没有进程，浏览器会显示连接被拒绝。

Docker Hub 的部署命令只挂出三个子目录：网站、MySQL 数据、站点配置。面板程序仍留在镜像里。仓库 README 的 `-v ~/www:/www` 不要用在这个标签上。Ubuntu 24.04 上这样挂过空目录，日志里是 `/www/server/panel: No such file or directory`，`curl` 连不上 38888。

下面的命令都在 `/www/wwwroot/baota` 里执行。`compose.yaml` 若写在上一级目录，`./wwwroot` 会指到别的路径，Compose 项目名也会变成那一层目录的名字。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/baota/wwwroot /www/wwwroot/baota/mysql /www/wwwroot/baota/vhost
sudo chown -R "$USER":"$USER" /www/wwwroot/baota
cd /www/wwwroot/baota
```

2. 写入 `compose.yaml`。左边是宿主机端口，右边是容器端口。

```bash
cat > compose.yaml <<'EOF'
services:
  baota:
    image: docker.xuanyuan.run/btpanel/baota:9.0_lts_lnmp
    container_name: baota
    restart: unless-stopped
    ports:
      - "38888:8888"
      - "8080:80"
      - "8443:443"
      - "22022:22"
      - "32888:888"
    volumes:
      - ./wwwroot:/www/wwwroot
      - ./mysql:/www/server/data
      - ./vhost:/www/server/panel/vhost
EOF
```

| 配置 | 说明 |
|------|------|
| `38888:8888` | 宿主机 **38888** → 容器 **8888**，面板网页 |
| `8080:80`、`8443:443` | 网站 HTTP / HTTPS |
| `22022:22` | 容器 SSH。密码见「登录面板」 |
| `32888:888` | phpMyAdmin |
| `./wwwroot` | 容器内 `/www/wwwroot`，网站文件 |
| `./mysql` | 容器内 `/www/server/data`，MySQL 数据 |
| `./vhost` | 容器内 `/www/server/panel/vhost`，站点配置 |
| `unless-stopped` | 手动 `docker stop` 之后不会自动再启动 |
| `9.0_lts_lnmp` | 具体版本标签，与拉取命令一致 |

仓库 Compose 示例还写了 2 核 CPU 和 **1024M** 内存上限。这次首页显示的内存是 1796 MB，MySQL 8.0.24 已经在跑。本文不写这条上限。

3. 启动：

```bash
docker compose up -d
docker compose ps
docker compose logs baota
```

`mysql/` 第一次是空的，盖住了镜像里原来的数据库目录，MySQL **8.0.24** 会在这个目录里重新初始化。容器会先显示 **unhealthy**。初始化没写完时，访问 38888 可能得到 `Connection reset by peer`。这时不要 `docker compose down`，中断会留下写了一半的数据目录。

Ubuntu 24.04 上，初始化阶段的日志是：

```text
/www/server/mysql/bin/mysqld (mysqld 8.0.24) initializing of server in progress
InnoDB initialization has ended.
root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
```

随后日志里会出现「启动面板HTTP服务」。看到这一行，再去「登录面板」设置密码。

4. 云服务器在安全组放行 **38888**。网站要用 **8080** 或 **8443** 时，一并放行。本机开了防火墙时：

```bash
sudo ufw allow 38888/tcp
sudo ufw allow 8080/tcp
sudo ufw allow 8443/tcp
```

## 登录面板

浏览器打开 `http://服务器IP:38888/btpanel`。`bt default` 打印的外网地址和内网地址都是容器端口 **8888**，宿主机 **8888** 没有映射，那两个地址打不开。

1. 打印面板给出的账户：

```bash
docker exec baota bt default
```

Ubuntu 24.04 实测：

```text
==================================================================
BT-Panel default info!
==================================================================
外网面板地址: http://115.195.97.30:8888/btpanel
内网面板地址: http://172.18.0.2:8888/btpanel
username: btpanel
password: 4aae623f
Warning:
If you cannot access the panel,
release the following port (8888|888|80|443|20|21) in the security group
注意：初始密码仅在首次登录面板前能正确获取，其它时间请通过 bt 5 命令修改密码
==================================================================
```

用户名是 `btpanel`，打印出的密码是 `4aae623f`。用它登录 `http://192.168.1.35:38888/btpanel` 时，页面提示错误。输出里的说明是：初始密码只在首次登录前有效，其它时间用 `bt 5` 修改。镜像说明里的 `btpaneldocker` 也不是这次能用的面板密码。

2. 设置新密码。提示「请输入新的面板密码」时，输入你自己的密码。

```bash
docker exec -it baota bt 5
```

Ubuntu 24.04 实测，输入 `123456` 后的结果是：

```text
===============================================
正在执行(5)...
===============================================
请输入新的面板密码：123456
|-用户名: btpanel
|-新密码: 123456
```

3. 用用户名 `btpanel` 和刚设的密码登录 `http://服务器IP:38888/btpanel`。这次 `123456` 可以登录。

4. 登录后打开左侧「面板设置」，修改用户名、密码和安全入口。安全入口改掉之后，`/btpanel` 会失效，按新地址访问。`123456` 只用于这次测试，登录后马上换成别的密码。

镜像说明里的容器 SSH 密码是 `btpaneldocker`。`bt default` 不打印这一项，也没有写 SSH 用户名。需要进容器时，在服务器上执行：

```bash
docker exec -it baota bash
```

不要凭记忆去猜 SSH 用户名。不用 SSH 时，从 `compose.yaml` 里删掉 `22022:22`，然后重新执行 `docker compose up -d`。

网站、数据库和运行环境在登录后的界面里继续安装。安装出来的网站监听容器 **80** / **443**，按上面的映射从宿主机 **8080** / **8443** 访问。

## 登录后的界面

登录 `http://192.168.1.35:38888/btpanel` 之后，页面按下面的顺序出现。

1. 先看到用户协议。协议最后更新日期是 2020-03-16。勾选「我已阅读并同意《用户协议》」，再点「进入面板」。

![宝塔面板用户协议：勾选我已阅读并同意，按钮为进入面板](https://imgs.xuanyuan.cloud/docker/blog/baota/baota-1.webp)

2. 中间是「绑定宝塔官网账号」。这里要填的是宝塔官网的账号和密码，不是刚才 `bt 5` 设的面板密码。左侧菜单已经可以点「首页」。菜单里没有「安全」和「Docker」。

![宝塔面板绑定官网账号：填写宝塔官网账号和密码](https://imgs.xuanyuan.cloud/docker/blog/baota/baota-2.webp)

3. 「首页」显示负载、CPU、内存和磁盘。这次是 4 核，CPU 使用率 3.8%，内存 585 MB / 1796 MB。磁盘列出 `/`、`/www/wwwroot`、`/www/server/data`、`/www/server/panel/vhost`，容量都是 21.65 GB / 97.87 GB。后三个路径是本文挂进容器的网站目录、MySQL 数据和站点配置，和根分区在同一块磁盘上，所以容量相同。顶栏写着 CentOS 7，这是面板显示的系统，测试机是 Ubuntu 24.04。红色提示写着当前面板使用 HTTP 访问，因为地址是 `http://192.168.1.35:38888/btpanel`。

![宝塔面板首页：4 核 CPU、内存占用，以及 wwwroot、MySQL 数据和 vhost 的磁盘](https://imgs.xuanyuan.cloud/docker/blog/baota/baota-3.webp)

4. 「网站」里点添加站点。根目录默认是 `/www/wwwroot`，页面上的 Nginx 是 1.26.1，PHP 版本可以选择 PHP-82。

![宝塔面板添加站点：根目录 /www/wwwroot，Nginx 1.26.1，PHP-82](https://imgs.xuanyuan.cloud/docker/blog/baota/baota-4.webp)

5. 「FTP」页写着当前地址 `ftp://192.168.1.35:21`，服务是 Pure-FTPd 1.0.49。本文没有把容器 **21** 映到宿主机，局域网连这个地址进不了容器里的 FTP。要使用时，在 `compose.yaml` 里加上端口映射，再执行 `docker compose up -d`。添加用户的根目录是 `/www/wwwroot`。

![宝塔面板添加 FTP 用户：根目录为 /www/wwwroot，服务为 Pure-FTPd](https://imgs.xuanyuan.cloud/docker/blog/baota/baota-5.webp)

6. 「数据库」里添加库时，本地服务器是 `127.0.0.1`，版本是 MySQL 8.0.24。截图里这一行的状态是「连接中」。同一页有 phpMyAdmin。

![宝塔面板添加数据库：MySQL 8.0.24，本地服务器 127.0.0.1 显示连接中](https://imgs.xuanyuan.cloud/docker/blog/baota/baota-6.webp)

7. 「软件商店」已安装的是 Nginx 1.26.1、MySQL 8.0.24、Pure-FTPd 1.0.49 和 phpMyAdmin 5.1。

![宝塔面板软件商店：已安装 Nginx 1.26.1、MySQL 8.0.24、Pure-FTPd 1.0.49、phpMyAdmin 5.1](https://imgs.xuanyuan.cloud/docker/blog/baota/baota-7.webp)

8. 「文件」打开 `/www/wwwroot`。目录里有 `.Recycle_bin`，所有者是 root，修改时间是 2026-10-22 13:41:49。这就是宿主机 `wwwroot/` 挂进容器后的位置。

![宝塔面板文件：/www/wwwroot 中的 .Recycle_bin，所有者为 root](https://imgs.xuanyuan.cloud/docker/blog/baota/baota-8.webp)

9. 「面板设置」打开后，当前页是「全部设置」。服务器 IP 是 192.168.1.35，时间是 2026-10-22 13:58:19。默认建站目录是 `/www/wwwroot`，默认备份目录是 `/www/backup`。改用户名、密码和安全入口在旁边的「面板设置」页，不在这一张图上。

![宝塔面板全部设置：服务器 IP 192.168.1.35，默认建站目录 /www/wwwroot，备份目录 /www/backup](https://imgs.xuanyuan.cloud/docker/blog/baota/baota-9.webp)

## 备选：docker run

没有 Docker Compose 时，用下面这条命令。端口和数据目录与「Docker Compose 部署」相同。先完成那一节的建目录步骤，并进入 `/www/wwwroot/baota`。

```bash
docker run -d 
  --name baota 
  --restart unless-stopped 
  -p 38888:8888 
  -p 8080:80 
  -p 8443:443 
  -p 22022:22 
  -p 32888:888 
  -v /www/wwwroot/baota/wwwroot:/www/wwwroot 
  -v /www/wwwroot/baota/mysql:/www/server/data 
  -v /www/wwwroot/baota/vhost:/www/server/panel/vhost 
  docker.xuanyuan.run/btpanel/baota:9.0_lts_lnmp
```

查看状态：

```bash
docker ps --filter name=baota
docker logs baota
```

Docker Hub 简介里的另一种写法使用 `--net=host`，不映射端口，面板地址变成 `http://服务器IP:8888/btpanel`。那种写法会让容器直接占用宿主机的 **22**、**80**、**443**、**8888** 等端口。这些端口已经被占用时不要用。需要时见「常见问题」。

## 常见问题

**Q1：为什么本文不用 `latest` 或 `lnmp`？**

这两个标签都没有固定的面板版本号，下次构建会换成别的内容。Docker Hub 简介和仓库 README 对 `latest` 的版本、Debian 版本写法也不一样。对照见「标签怎么选」。本文命令使用 `9.0_lts_lnmp`。

**Q2：浏览器应该打开 8888 还是 38888？**

容器里面板是 **8888**，安全入口是 `/btpanel`。本文把 **8888** 映到宿主机 **38888**，地址是 `http://IP:38888/btpanel`。`bt default` 打印的地址带的是 **8888**，那是容器端口。宿主机 8888 没有映射，打开会失败。`curl -I http://127.0.0.1:38888/btpanel` 会返回 `404`，这是 HEAD 请求的结果，浏览器打开同一地址仍是登录页。

**Q3：网站为什么不在 80 端口？**

本文把容器 **80** 映到宿主机 **8080**，把容器 **443** 映到宿主机 **8443**，这样不会占掉宿主机已经在用的 80 和 443。这台机器的 80、443 是空的，并且希望用域名直接访问时，改 `compose.yaml` 里对应的两行，再执行：

```bash
cd /www/wwwroot/baota
docker compose up -d
```

**Q4：容器是 Up，浏览器却显示连接被拒绝？**

先看日志里有没有 `/www/server/panel: No such file or directory`。把空目录挂到容器 `/www` 时就是这个结果。面板、Nginx、PHP 都在镜像的 `/www/server` 里，空目录把它们挡住了。同样的报错会反复出现：

```text
cat: /www/server/panel/data/o.pl: No such file or directory
/etc/init.d/bt: line 25: cd: /www/server/panel: No such file or directory
/etc/init.d/nginx: line 55: /www/server/nginx/sbin/nginx: No such file or directory
/usr/bin/python: can't open file '/www/server/panel/tools.py': [Errno 2] No such file or directory
```

在写着这份 `compose.yaml` 的目录里停掉容器，改成「Docker Compose 部署」里的三个挂载，再启动。不要把空目录挂到 `/www`，也不要挂到整个 `/www/server/panel`。

日志里没有上面这些行时，再按这个顺序看：

1. `docker compose ps` 里 `baota` 是否为 Up。日志里是否已经有「启动面板HTTP服务」。MySQL 还在初始化时，38888 会重置连接，等这一行出现再打开页面。
2. 在服务器浏览器打开 `http://127.0.0.1:38888/btpanel`。本机能开、别的机器不能开时，再检查云服务器安全组和本机防火墙是否放行了 **38888**。
3. 地址如果写成 `:8888`，连的是没有映射的宿主机端口。本文的面板在 **38888**。

**Q5：删掉容器之后，网站和数据库还在吗？**

网站文件在 `/www/wwwroot/baota/wwwroot`，MySQL 数据在 `mysql/`，站点配置在 `vhost/`。`docker compose down` 或 `docker rm` 不会删除这三个目录。

面板程序在镜像里。Docker Hub 的示例没有挂载 `/www/server/panel/data`。用户名、密码和安全入口如果写在这个目录，会留在容器的可写层里，不在上面三个宿主机目录中。删容器会丢掉这一部分。确认网站、数据库和面板账号都不再需要之后，再删除整个工作目录。

**Q6：和装在系统里的宝塔有什么差别？**

左侧菜单里没有「安全」和「Docker」，容器里也没有 systemd。面板管的是容器里的网站和数据库，不是宿主机的开机服务。仓库 README 写过：要在面板里使用 Docker，可以再挂载宿主机的 `/usr/bin/docker` 和 `/run/docker.sock`。挂上之后，容器里的进程可以操作这台机器上的 Docker。本文不挂这两项。

**Q7：宿主机端口已经被占用怎么办？**

`docker compose up` 报端口占用时，先看是哪一行。80、443 被 Nginx 或另一套面板占用时，保持本文的 **8080** 和 **8443**，不要改成 `80:80`。38888 也被占用时，把宿主机这一侧改成别的空闲端口，例如 `39888:8888`，浏览器端口跟着改。容器一侧的 **8888** 不要改。

**Q8：arm 机器需要单独的标签吗？**

不需要。`9.0_lts_lnmp` 在 Docker Hub 上有 amd64 和 arm64，直接拉取即可。简介里「arm 架构的 MySQL 是 5.6」写在 **7.9.4** 的 LNMP / LAMP 标签下，不要套到 `9.0_lts_lnmp` 上。

**Q9：如何换标签？**

先保留 `wwwroot/`、`mysql/`、`vhost/`。改 `compose.yaml` 的 `image` 标签后执行：

```bash
cd /www/wwwroot/baota
docker compose pull
docker compose up -d
```

用 `docker run` 启动的，执行 `docker stop baota && docker rm baota`，再按「备选：docker run」用新标签启动。`-v` 后面的宿主机目录保持不变。

**Q10：机器是空的，想让容器直接使用宿主机网络？**

先确认宿主机的 **22**、**80**、**443**、**8888**、**888** 都没有被占用。`--net=host` 不会做端口映射，容器会直接监听这些端口，其中 **22** 是宿主机自己的 SSH。确认之后可以这样启动：

```bash
docker run -d 
  --restart unless-stopped 
  --name baota 
  --net=host 
  -v /www/wwwroot/baota/wwwroot:/www/wwwroot 
  -v /www/wwwroot/baota/mysql:/www/server/data 
  -v /www/wwwroot/baota/vhost:/www/server/panel/vhost 
  docker.xuanyuan.run/btpanel/baota:9.0_lts_lnmp
```

这时面板地址是 `http://服务器IP:8888/btpanel`，不再是 38888。已经用本文 Compose 启动过的，先 `docker compose down`，不要让两套方式同时占用同一个容器名 `baota`。

**Q11：如何停止与卸载？**

确认不再需要网站和面板数据之前，不要删除 `wwwroot/`、`mysql/`、`vhost/`。

Compose 停止并保留数据目录：

```bash
cd /www/wwwroot/baota
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop baota && docker rm baota
```

数据都不再需要时，再删除整个目录：

```bash
rm -rf /www/wwwroot/baota
```

## 命令速查

```bash
docker pull docker.xuanyuan.run/btpanel/baota:9.0_lts_lnmp

cd /www/wwwroot/baota
docker compose up -d
docker compose ps
docker compose logs baota

docker exec baota bt default
docker exec -it baota bt 5

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://服务器IP:38888/btpanel`。`bt default` 打印的初始密码这次无法登录，用 `bt 5` 设置的密码登录。用户名是 `btpanel`。登录后到「面板设置」修改用户名、密码和安全入口。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [btpanel/baota 镜像页](https://xuanyuan.cloud/zh/r/btpanel/baota) | [https://xuanyuan.cloud/zh/r/btpanel/baota](https://xuanyuan.cloud/zh/r/btpanel/baota) |
| [btpanel/baota 概览](https://xuanyuan.cloud/r/btpanel/baota) | [https://xuanyuan.cloud/r/btpanel/baota](https://xuanyuan.cloud/r/btpanel/baota) |
| [btpanel/baota 标签列表](https://xuanyuan.cloud/r/btpanel/baota/tags) | [https://xuanyuan.cloud/r/btpanel/baota/tags](https://xuanyuan.cloud/r/btpanel/baota/tags) |
| [Docker Hub · btpanel/baota](https://hub.docker.com/r/btpanel/baota) | [https://hub.docker.com/r/btpanel/baota](https://hub.docker.com/r/btpanel/baota) |
| [Docker Hub 标签](https://hub.docker.com/r/btpanel/baota/tags) | [https://hub.docker.com/r/btpanel/baota/tags](https://hub.docker.com/r/btpanel/baota/tags) |
| [Dockerfile 仓库 · btpanel/btpanel](https://cnb.cool/btpanel/btpanel) | [https://cnb.cool/btpanel/btpanel](https://cnb.cool/btpanel/btpanel) |
| [宝塔官网](https://www.bt.cn/) | [https://www.bt.cn/](https://www.bt.cn/) |
| [宝塔面板 Docker 反馈帖](https://www.bt.cn/bbs/thread-79499-1-1.html) | [https://www.bt.cn/bbs/thread-79499-1-1.html](https://www.bt.cn/bbs/thread-79499-1-1.html) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/baota-docker-deploy


