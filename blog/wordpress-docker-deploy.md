# Docker 部署 WordPress：轻松搭建开源内容管理平台

![Docker 部署 WordPress：轻松搭建开源内容管理平台](https://imgs.xuanyuan.cloud/docker/blog/wordpress/wordpress.webp)

*分类: Docker部署教程 | 标签: WordPress,Docker,轩辕镜像,内容管理,私有化部署,部署教程 | 发布时间: 2026-10-10 16:57:31*

> WordPress 是一款面向网站与博客的开源内容管理系统，用来发布文章、页面和媒体，并通过主题与插件分开管理版式和功能。本文将介绍如何通过 Docker 快速部署 WordPress，搭建可自托管的站点，帮助个人与团队在自己的服务器上维护内容，适合博客、企业官网及内容站点等场景。

*本文基于 [library/wordpress:7.1.3-php8.4-apache](https://xuanyuan.cloud/zh/r/library/wordpress) 与 [library/mysql:8.4.11](https://xuanyuan.cloud/zh/r/library/mysql)，实测 WordPress **7.1.3**、Apache **2.4.68**、PHP **8.4.26**，数据库 MySQL **8.4.11**，测试平台 **Ubuntu 24.04** Linux。*

## WordPress 是什么

WordPress 是一套开源的博客和内容管理系统，用 PHP 编写，数据放在 MySQL 或 MariaDB 里。文章、页面和媒体在后台维护，版式用主题，表单等额外功能用插件。

静态页面要把版式写进每一篇文章。托管建站把数据和后台放在服务商那里。WordPress 把文章留在数据库里，换主题只改展示，后台用浏览器更新。

## WordPress 能做什么

- **写文章和页面**：在后台编辑器里写，文章可以开评论，并用分类和标签归类。
- **放媒体**：图片和音视频进媒体库，再插入文章和页面。
- **换主题**：主题管版式和样式，在「外观」里启用。
- **装插件**：表单、缓存等功能用插件加上。
- **分角色**：管理员、编辑、作者看到的后台菜单不同。

## 为什么要使用 WordPress

文章放在托管平台上时，导出、换域名和停用账号都要按对方的规则来。WordPress 的程序和数据库在自己的服务器上，适合个人博客、企业官网，以及要长期自己保管内容的站点。

## 使用 Docker 部署 WordPress

官方镜像里已经有 PHP 和 Apache。再加一个 MySQL 容器，本机不必单独安装 PHP。开始之前，先准备好 Docker，并留出存放网站文件和数据库的目录。

下面用 Docker Compose 写好这两部分的参数，启动两个容器，并在浏览器里完成安装向导。

## 环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux（本文 Ubuntu 24.04）；macOS 把 `/www/wwwroot/wordpress` 换成 `~/docker/wordpress` |
| Docker | Engine + **Compose V2**（`docker compose`） |
| 架构 | 两份镜像一起用时选 **linux/amd64** 或 **linux/arm64**。WordPress 的 Apache 变体还有更多架构；MySQL `8.4.11` 只有 amd64 与 arm64v8 |
| 磁盘 | Ubuntu 24.04 上 `docker images` 显示 WordPress DISK **1.13GB**、CONTENT **287MB**，MySQL DISK **1.12GB**、CONTENT **255MB**（amd64）；数据库和上传文件另计 |
| 端口 | 宿主机 **8080/tcp** → WordPress 容器 **80**。MySQL 只在 Compose 网络内访问，不映射到宿主机 |
| 工作目录 | `/www/wwwroot/wordpress` |

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

[Docker Hub 官方镜像](https://hub.docker.com/_/wordpress) 当前的 WordPress 版本线是 **7.1.3**。[WordPress 7.1 服务器兼容说明](https://make.wordpress.org/hosting/handbook/compatibility/version/7-1/) 写明：新装建议 PHP **8.4** 或 **8.5**，数据库建议 MySQL **8.4**。MySQL 8.0 已于 2026-04-30 结束维护。

本文命令使用 **`7.1.3-php8.4-apache`**：WordPress 7.1.3、PHP 8.4、Apache。Apache 已在镜像里，浏览器直接访问容器的 80 端口。数据库使用 **`8.4.11`**。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`7.1.3-php8.4-apache`** | WordPress 7.1.3、PHP 8.4、Apache | **是** |
| `7.1.3-php8.5-apache` | 同一 WordPress 版本，PHP 8.5 | 要改用 PHP 8.5 时，只替换这一处标签 |
| `7.1.3-php8.3-apache` | 与 `latest`、`apache`、`7.1.3` 同一变体，PHP 8.3 | 否 |
| `7.1`、`7`、`apache`、`php8.4`、`latest` | 浮动标签，之后会改指向 | 否 |
| `7.1.3-php8.4-fpm`、`fpm-alpine` | 只有 PHP-FPM，前面必须有反向代理 | 否。不要把 FPM 端口发布到宿主机 |
| `cli-2.12.0-php8.4` | WP-CLI，不含整站文件 | 仅排障时使用 |

| 数据库标签 | 说明 | 是否写入本文命令 |
|------------|------|------------------|
| **`8.4.11`** | MySQL 8.4 LTS 的具体版本 | **是** |
| `8.4`、`8`、`lts` | 随 8.4 小版本移动 | 否 |
| `8.0` | 已结束维护。官方 Compose 示例里仍能看到 `mysql:8.0` | 否 |

镜像页中文简介里仍能看到 `6.8.3` 和 PHP 8.1 的标签说明。以 [标签列表](https://xuanyuan.cloud/r/library/wordpress/tags) 和上表为准。升级时同时改 WordPress 与 MySQL 的标签，并先备份「Docker Compose 部署」里的两个目录。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/library/wordpress:7.1.3-php8.4-apache
docker pull docker.xuanyuan.run/library/mysql:8.4.11
```

Ubuntu 24.04 实测：

```text
Digest: sha256:309307430abf80009378a63a79df73554a6449b700fac59a991b4959e6dda8ca
Status: Downloaded newer image for docker.xuanyuan.run/library/wordpress:7.1.3-php8.4-apache
docker.xuanyuan.run/library/wordpress:7.1.3-php8.4-apache
```

```text
Digest: sha256:6ea90827b1100f8f2ae306a539f86d2c264a26ed435a2a9f75551dd5c3aeb242
Status: Downloaded newer image for docker.xuanyuan.run/library/mysql:8.4.11
docker.xuanyuan.run/library/mysql:8.4.11
```

拉取完成后确认本地有这两个标签：

```bash
docker images docker.xuanyuan.run/library/wordpress:7.1.3-php8.4-apache
docker images docker.xuanyuan.run/library/mysql:8.4.11
```

```text
IMAGE                                                       ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/library/wordpress:7.1.3-php8.4-apache   309307430abf       1.13GB          287MB

IMAGE                                      ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/library/mysql:8.4.11   6ea90827b110       1.12GB          255MB
```

## Docker Compose 部署

工作目录是 `/www/wwwroot/wordpress`。`html` 对应容器内 `/var/www/html`，存放 WordPress 程序、主题、插件和上传文件。`mysql` 对应 `/var/lib/mysql`，存放数据库文件。

第一次启动前，这两个目录保持为空。`html` 里已经有 `index.php` 或 `wp-includes/version.php` 时，入口脚本不再从镜像复制 WordPress。`mysql` 里已经有数据时，`MYSQL_DATABASE` 等初始化变量不会再生效。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/wordpress/html /www/wwwroot/wordpress/mysql
sudo chown -R "$USER":"$USER" /www/wwwroot/wordpress
```

2. `mysql/` 仍为空时，再生成数据库口令并写入 `compose.yaml`。目录里已经有 MySQL 数据时，不要重新执行这一步，否则新口令和已初始化的账号对不上。口令写在 `db_password.txt`，这是数据库账号 `wordpress` 的口令。站点管理员口令在「浏览器首次使用」里另设。`umask 077` 让 `db_password.txt` 和 `compose.yaml` 只有当前用户可读；写完后把 umask 调回 `022`，避免后面新建的文件也变成仅本人可读。

```bash
cd /www/wwwroot/wordpress
DB_PASSWORD="$(openssl rand -hex 24)"
umask 077
printf '%s
' "$DB_PASSWORD" > db_password.txt
cat > compose.yaml <<EOF
name: wordpress

services:
  wordpress:
    image: docker.xuanyuan.run/library/wordpress:7.1.3-php8.4-apache
    container_name: wordpress
    restart: unless-stopped
    depends_on:
      db:
        condition: service_healthy
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: ${DB_PASSWORD}
      WORDPRESS_DB_NAME: wordpress
      TZ: Asia/Shanghai
    volumes:
      - ./html:/var/www/html

  db:
    image: docker.xuanyuan.run/library/mysql:8.4.11
    container_name: wordpress-db
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: ${DB_PASSWORD}
      MYSQL_RANDOM_ROOT_PASSWORD: "yes"
      TZ: Asia/Shanghai
    volumes:
      - ./mysql:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "127.0.0.1", "-uwordpress", "-p${DB_PASSWORD}", "--silent"]
      interval: 10s
      timeout: 5s
      retries: 30
      start_period: 40s
EOF
unset DB_PASSWORD
umask 022
```

| 参数 | 说明 |
|------|------|
| `8080:80` | 宿主机 **8080** → 容器 **80**（Apache） |
| `WORDPRESS_DB_HOST: db` | 数据库主机名用 Compose 服务名 `db` |
| `WORDPRESS_DB_NAME` 与 `MYSQL_DATABASE` | 都写成 `wordpress`。库由 MySQL 在 `mysql/` 为空时创建，WordPress 容器不建库 |
| `WORDPRESS_DB_PASSWORD` 与 `MYSQL_PASSWORD` | 同一串口令，来自上一步的 `db_password.txt` |
| `MYSQL_RANDOM_ROOT_PASSWORD` | `root` 使用随机口令，写在 `wordpress-db` 的日志里 |
| `./html`、`./mysql` | 网站文件与数据库文件落在宿主机目录 |
| `depends_on` + `healthcheck` | MySQL 能应答 `mysqladmin ping` 之后，再启动 WordPress |

3. 启动：

```bash
cd /www/wwwroot/wordpress
docker compose up -d
```

Ubuntu 24.04 实测：数据库健康检查通过后 WordPress 才启动，用时 93.5 秒。

```text
[+] up 3/3
 ✔ Network wordpress_default Created  0.4s
 ✔ Container wordpress-db    Healthy  93.5s
 ✔ Container wordpress       Started  93.5s
```

4. 看两个容器是否在运行。`wordpress-db` 的状态应为 healthy，`wordpress` 为 Up。`3306/tcp` 只出现在数据库容器内部，没有映射到宿主机：

```bash
docker compose ps
```

```text
NAME           IMAGE                                                       COMMAND                  SERVICE     CREATED         STATUS                   PORTS
wordpress      docker.xuanyuan.run/library/wordpress:7.1.3-php8.4-apache   "docker-entrypoint.s…"   wordpress   3 minutes ago   Up 2 minutes             0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
wordpress-db   docker.xuanyuan.run/library/mysql:8.4.11                    "docker-entrypoint.s…"   db          3 minutes ago   Up 3 minutes (healthy)   3306/tcp, 33060/tcp
```

5. 看 WordPress 容器日志。入口脚本在网站目录为空时会复制程序，并在发现 `WORDPRESS_` 变量且还没有 `wp-config.php` 时写入配置。`AH00558` 是未设置 `ServerName` 的提示，后面的 `AH00163` 表示 Apache 已开始工作。

```bash
docker compose logs -f --tail 100 wordpress
```

```text
wordpress  | WordPress not found in /var/www/html - copying now...
wordpress  | Complete! WordPress has been successfully copied to /var/www/html
wordpress  | No 'wp-config.php' found in /var/www/html, but 'WORDPRESS_...' variables supplied; copying 'wp-config-docker.php' (WORDPRESS_DB_HOST WORDPRESS_DB_NAME WORDPRESS_DB_PASSWORD WORDPRESS_DB_USER)
wordpress  | AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.24.0.3. Set the 'ServerName' directive globally to suppress this message
wordpress  | AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.24.0.3. Set the 'ServerName' directive globally to suppress this message
wordpress  | [Sat Oct 10 12:08:09.373906 2026] [mpm_prefork:notice] [pid 1:tid 1] AH00163: Apache/2.4.68 (Debian) PHP/8.4.26 configured -- resuming normal operations
wordpress  | [Sat Oct 10 12:08:09.373981 2026] [core:notice] [pid 1:tid 1] AH00094: Command line: 'apache2 -D FOREGROUND'
```

6. 在服务器本机看响应头。安装向导尚未完成时，实测为 **302**，`Location` 指向 `/wp-admin/install.php`：

```bash
curl -sI http://127.0.0.1:8080/
```

```text
HTTP/1.1 302 Found
Date: Sat, 10 Oct 2026 04:10:28 GMT
Server: Apache/2.4.68 (Debian)
X-Powered-By: PHP/8.4.26
Expires: Wed, 11 Jan 1984 05:00:00 GMT
Cache-Control: no-cache, must-revalidate, max-age=0, no-store, private
X-Redirect-By: WordPress
Location: http://127.0.0.1:8080/wp-admin/install.php
Content-Type: text/html; charset=UTF-8
```

浏览器访问 `http://服务器IP:8080`。本机调试用 `http://127.0.0.1:8080`。

## 浏览器首次使用

数据库参数已经由环境变量写入 `wp-config.php`，安装向导不再询问数据库主机和口令。站点标题和管理员账号在这一步创建，镜像不带默认管理员口令。

1. 打开 `http://服务器IP:8080`。语言列表里选「简体中文」，点「继续」。页眉仍是英文 `Select a default language`，按钮已经是中文。

![WordPress 安装向导选择默认语言，简体中文已选中，按钮为继续](https://imgs.xuanyuan.cloud/docker/blog/wordpress/wordpress-1.webp)

2. 下一页标题是「欢迎」。填写「站点标题」「用户名」「密码」和「您的邮箱」。这一页没有数据库主机和数据库口令。用户名由你填写。密码用向导生成的那一组，或在输入框里换成另一组。「建议搜索引擎不索引本站点」默认未勾选，不勾时允许搜索引擎索引。本文安装时站点标题为「轩辕镜像的博客」，用户名为 `xuanyuan_cloud`。

![WordPress 欢迎页，站点标题为轩辕镜像的博客，用户名 xuanyuan_cloud，按钮为安装 WordPress](https://imgs.xuanyuan.cloud/docker/blog/wordpress/wordpress-2.webp)

3. 点「安装 WordPress」。完成后页面标题是「成功！」，用户名与上一步一致，密码一栏写着「您选择的密码。」

![WordPress 安装成功页，用户名 xuanyuan_cloud，下方有登录链接](https://imgs.xuanyuan.cloud/docker/blog/wordpress/wordpress-3.webp)

4. 点「登录」，进入 `http://服务器IP:8080/wp-admin`。用上一步的用户名和密码登录。登录页的语言已经是「简体中文」。

![WordPress 登录页，用户名 xuanyuan_cloud，语言为简体中文](https://imgs.xuanyuan.cloud/docker/blog/wordpress/wordpress-4.webp)

登录后的仪表盘标题是「欢迎使用 WordPress！」，并写明 **7.1.3** 版本。左侧有「文章」「媒体」「页面」「外观」「插件」「用户」。概览里是 1 篇已发布的文章、1 个已发布的页面、1 条评论，主题为 Twenty Twenty-Five。这三样是安装程序放进去的示例，还没在后台写过新文章。

![WordPress 仪表盘，版本 7.1.3，主题 Twenty Twenty-Five，已有一篇文章和一个页面](https://imgs.xuanyuan.cloud/docker/blog/wordpress/wordpress-5.webp)

前台地址是 `http://服务器IP:8080/`。站点名是「轩辕镜像的博客」。示例文章标题是「世界，您好！」，日期为 2026 年 10 月 10 日，页脚主题名是 Twenty Twenty-Five。

![站点前台，标题轩辕镜像的博客，文章世界，您好，主题 Twenty Twenty-Five](https://imgs.xuanyuan.cloud/docker/blog/wordpress/wordpress-6.webp)

上传的图片在宿主机目录 `/www/wwwroot/wordpress/html/wp-content/uploads`。主题目录是 `html/wp-content/themes/`，插件目录是 `html/wp-content/plugins/`。

## 数据、升级与访问

数据库口令在 `db_password.txt` 和 `compose.yaml` 里。后台管理员口令在安装向导里设定，两者不是同一个。`root` 的随机口令在数据库容器日志中：

```bash
docker compose logs wordpress-db 2>&1 | grep 'GENERATED ROOT PASSWORD'
```

备份前先停容器，再打包两个目录。`db_password.txt` 和 `compose.yaml` 里有数据库口令，备份不要放到公开位置。

压缩包放在 `/www/wwwroot/wordpress-backup.tar.gz`，与站点目录并列。

```bash
cd /www/wwwroot/wordpress
docker compose stop
tar -C /www/wwwroot -czf /www/wwwroot/wordpress-backup.tar.gz wordpress
docker compose start
```

更换 WordPress 镜像标签会换掉容器里的 PHP 和 Apache。`html/` 里已经有 `index.php` 时，入口脚本不再从镜像复制程序。WordPress 核心、主题和插件在后台「仪表盘 → 更新」里升级。

要对公网提供访问，在前面加 HTTPS 反向代理，并让代理传入 `X-Forwarded-Proto`。镜像在设置了 `WORDPRESS_` 环境变量时，会把这段判断写入 `wp-config.php`。本文的 `8080` 适合本机或内网。不要把未加访问控制的 `8080` 直接暴露到公网，也不要额外映射 MySQL 的 `3306`。

`WORDPRESS_DEBUG` 不要设成 `1`，除非正在查具体报错。查完后去掉 `WORDPRESS_DEBUG`，再执行 `docker compose up -d`。

## 备选：docker run

没有 Compose 时，目录和 `db_password.txt` 仍按「Docker Compose 部署」的前两步准备，不要执行那里的 `docker compose up -d`。已经用 Compose 起过名为 `wordpress` 或 `wordpress-db` 的容器时，先在 `/www/wwwroot/wordpress` 执行 `docker compose down`，再跑下面的命令，避免容器名冲突。

`mysql/` 已经初始化过时，继续使用原来的口令。

1. 读出数据库口令。网络 `wordpress` 还不存在时再创建；若提示 `network with name wordpress already exists`，直接进行下一步：

```bash
cd /www/wwwroot/wordpress
DB_PASSWORD="$(cat db_password.txt)"
docker network create wordpress
```

2. 启动 MySQL：

```bash
docker run -d 
  --name wordpress-db 
  --network wordpress 
  --restart unless-stopped 
  -e MYSQL_DATABASE=wordpress 
  -e MYSQL_USER=wordpress 
  -e MYSQL_PASSWORD="$DB_PASSWORD" 
  -e MYSQL_RANDOM_ROOT_PASSWORD=yes 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/wordpress/mysql:/var/lib/mysql 
  docker.xuanyuan.run/library/mysql:8.4.11
```

3. 等数据库能应答后再启动 WordPress。刚启动时下面这条可能失败，隔几秒再执行。`--silent` 成功时没有输出，退出码为 0 再进行下一步：

```bash
docker exec wordpress-db mysqladmin ping -h 127.0.0.1 -uwordpress -p"$DB_PASSWORD" --silent
```

4. 启动 WordPress。用户自定义网络上的容器名 `wordpress-db` 就是数据库主机名：

```bash
docker run -d 
  --name wordpress 
  --network wordpress 
  --restart unless-stopped 
  -p 8080:80 
  -e WORDPRESS_DB_HOST=wordpress-db 
  -e WORDPRESS_DB_USER=wordpress 
  -e WORDPRESS_DB_PASSWORD="$DB_PASSWORD" 
  -e WORDPRESS_DB_NAME=wordpress 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/wordpress/html:/var/www/html 
  docker.xuanyuan.run/library/wordpress:7.1.3-php8.4-apache
unset DB_PASSWORD
```

查看与停止：

```bash
docker ps --filter name=wordpress
docker logs -f --tail 100 wordpress
curl -sI http://127.0.0.1:8080/
docker stop wordpress wordpress-db
```

浏览器地址与「浏览器首次使用」相同。

## 常见问题

**Q1：`latest` 或 `7.1` 能不能写进 Compose？**

不能。`latest`、`7.1`、`apache` 和无 PHP 版本号的 `7.1.3` 当前是 PHP 8.3，之后还会改指向。对照见「标签怎么选」。本文命令是 `7.1.3-php8.4-apache` 和 `8.4.11`。

**Q2：镜像页中文简介仍是 6.8.3？**

中文简介仍写着 `6.8.3` 和 PHP 8.1。本文拉取的是 `docker.xuanyuan.run/library/wordpress:7.1.3-php8.4-apache`，以[标签列表](https://xuanyuan.cloud/r/library/wordpress/tags)为准。

**Q3：安装向导仍要求填写数据库主机和密码？**

入口脚本只在还没有 `wp-config.php`、并且环境里存在 `WORDPRESS_` 变量时写入配置。看 `/www/wwwroot/wordpress/html/wp-config.php` 是否已生成，以及 `compose.yaml` 里 `WORDPRESS_DB_HOST`、`WORDPRESS_DB_USER`、`WORDPRESS_DB_PASSWORD`、`WORDPRESS_DB_NAME` 是否都在。改完后执行 `docker compose up -d`，再刷新浏览器。

**Q4：页面出现 `Error establishing a database connection`？**

先看 `wordpress-db` 是不是 healthy，再核对口令是否与 `db_password.txt` 一致：

```bash
cd /www/wwwroot/wordpress
docker compose ps
docker compose logs --tail 80 wordpress-db
```

`mysql/` 若是用另一组口令初始化的，只改 Compose 不会改掉已有账号。本文启动时没有出现这句报错。

**Q5：上传主题或插件提示不能写入？**

主题放在 `html/wp-content/themes/` 的子目录，插件放在 `html/wp-content/plugins/` 的子目录。Apache 变体里的站点用户是 `www-data`，UID 为 **33**。从宿主机拷进去的目录若属主是 root，在宿主机上把这个子目录交给 33：

```bash
sudo chown -R 33:33 /www/wwwroot/wordpress/html/wp-content/themes/你的主题
sudo chown -R 33:33 /www/wwwroot/wordpress/html/wp-content/plugins/你的插件
```

**Q6：换了镜像标签，后台版本没有变？**

`html/` 里已有 `index.php` 时，换标签只换 PHP 和 Apache。核心版本在后台「仪表盘 → 更新」里升级。说明和备份命令见「数据、升级与访问」。

**Q7：能不能改用 FPM 标签并映射 9000？**

`fpm` 与 `fpm-alpine` 只提供 FastCGI，前面要有 Nginx 或 Apache。FastCGI 不要用 `-p` 发布到宿主机。本文主路径是带 Apache 的 `7.1.3-php8.4-apache`。

**Q8：忘记后台管理员密码？**

这套镜像不带发信组件，登录页「忘记密码？」发出的邮件可能到不了「您的邮箱」。可以用 WP-CLI 改密码。把 `站点用户名` 和 `新密码` 换成你的值，数据库口令仍用 `db_password.txt`。`cli` 变体基于 Alpine，默认 UID 是 **82**；本文 Apache 镜像的站点文件属主是 **33**，所以要加 `--user 33:33`。

```bash
cd /www/wwwroot/wordpress
DB_PASSWORD="$(cat db_password.txt)"
docker run -it --rm 
  --volumes-from wordpress 
  --network container:wordpress 
  --user 33:33 
  -e HOME=/tmp 
  -e WORDPRESS_DB_HOST=db 
  -e WORDPRESS_DB_USER=wordpress 
  -e WORDPRESS_DB_PASSWORD="$DB_PASSWORD" 
  -e WORDPRESS_DB_NAME=wordpress 
  docker.xuanyuan.run/library/wordpress:cli-2.12.0-php8.4 
  user update 站点用户名 --user_pass='新密码'
unset DB_PASSWORD
```

这条命令假定站点是用本文 Compose 启动的，数据库主机名是服务名 `db`。用「备选：docker run」启动时，把 `WORDPRESS_DB_HOST` 改成 `wordpress-db`。

**Q9：上传大文件被拦住？**

体积上限来自 PHP 的 `upload_max_filesize` 与 `post_max_size`。本文部署没有改这两项。要调高时，在 `/www/wwwroot/wordpress` 写一份 ini，再基于本文镜像构建。`post_max_size` 要大于或等于 `upload_max_filesize`。

```bash
cd /www/wwwroot/wordpress
cat > custom.ini <<'EOF'
upload_max_filesize = 64M
post_max_size = 64M
EOF
cat > Dockerfile <<'EOF'
FROM docker.xuanyuan.run/library/wordpress:7.1.3-php8.4-apache
COPY custom.ini $PHP_INI_DIR/conf.d/
EOF
docker build -t wordpress-upload:7.1.3-php8.4 .
```

把 `compose.yaml` 里 WordPress 的 `image:` 改成 `wordpress-upload:7.1.3-php8.4`，再执行 `docker compose up -d`。`wordpress-upload` 是本机构建的标签，不要写进 `docker pull`。

**Q10：拉取报 `no matching manifest`？**

`7.1.3-php8.4-apache` 有多套架构。`8.4.11` 只有 linux/amd64 与 linux/arm64。到[标签页](https://xuanyuan.cloud/r/library/wordpress/tags)核对架构。32 位 ARM 可以拉 WordPress 的部分标签，但拉不到这份 MySQL 8.4 镜像。

**Q11：官方示例里的 `mysql:8.0` 还能用吗？**

官方 Compose 示例仍写 `mysql:8.0`。MySQL 8.0 已于 2026-04-30 结束维护。本文数据库标签是 `8.4.11`，见「标签怎么选」。

## 命令速查

```bash
docker pull docker.xuanyuan.run/library/wordpress:7.1.3-php8.4-apache
docker pull docker.xuanyuan.run/library/mysql:8.4.11

cd /www/wwwroot/wordpress
docker compose up -d
docker compose ps
docker compose logs -f --tail 100 wordpress
curl -sI http://127.0.0.1:8080/

docker compose restart wordpress
docker compose stop
docker compose start
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://服务器IP:8080`，后台是 `http://服务器IP:8080/wp-admin`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [library/wordpress 镜像页](https://xuanyuan.cloud/zh/r/library/wordpress) | [https://xuanyuan.cloud/zh/r/library/wordpress](https://xuanyuan.cloud/zh/r/library/wordpress) |
| [library/wordpress 概览](https://xuanyuan.cloud/r/library/wordpress) | [https://xuanyuan.cloud/r/library/wordpress](https://xuanyuan.cloud/r/library/wordpress) |
| [library/wordpress 标签列表](https://xuanyuan.cloud/r/library/wordpress/tags) | [https://xuanyuan.cloud/r/library/wordpress/tags](https://xuanyuan.cloud/r/library/wordpress/tags) |
| [library/mysql 镜像页](https://xuanyuan.cloud/zh/r/library/mysql) | [https://xuanyuan.cloud/zh/r/library/mysql](https://xuanyuan.cloud/zh/r/library/mysql) |
| [library/mysql 标签列表](https://xuanyuan.cloud/r/library/mysql/tags) | [https://xuanyuan.cloud/r/library/mysql/tags](https://xuanyuan.cloud/r/library/mysql/tags) |
| [Docker Hub · wordpress](https://hub.docker.com/_/wordpress) | [https://hub.docker.com/_/wordpress](https://hub.docker.com/_/wordpress) |
| [Docker Hub · mysql](https://hub.docker.com/_/mysql) | [https://hub.docker.com/_/mysql](https://hub.docker.com/_/mysql) |
| [GitHub · docker-library/wordpress](https://github.com/docker-library/wordpress) | [https://github.com/docker-library/wordpress](https://github.com/docker-library/wordpress) |
| [WordPress 官网](https://wordpress.org/) | [https://wordpress.org/](https://wordpress.org/) |
| [WordPress 运行要求](https://wordpress.org/about/requirements/) | [https://wordpress.org/about/requirements/](https://wordpress.org/about/requirements/) |
| [WordPress 7.1 服务器兼容说明](https://make.wordpress.org/hosting/handbook/compatibility/version/7-1/) | [https://make.wordpress.org/hosting/handbook/compatibility/version/7-1/](https://make.wordpress.org/hosting/handbook/compatibility/version/7-1/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/wordpress-docker-deploy


