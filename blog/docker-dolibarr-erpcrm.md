# Docker 部署 Dolibarr：轻松搭建开源 ERP/CRM 平台

![Docker 部署 Dolibarr：轻松搭建开源 ERP/CRM 平台](https://imgs.xuanyuan.cloud/docker/blog/dolibarr.webp)

*分类: Docker部署教程 | 标签: Dolibarr, dolibarr/dolibarr, ERP, CRM, Docker, 轩辕镜像, MariaDB, 私有化部署, 部署教程 | 发布时间: 2026-09-24 07:33:33*

> Dolibarr 是面向中小企业的开源 ERP 与 CRM 套件，可在浏览器里管客户、报价、发票与库存。本文将介绍如何通过 Docker Compose 部署官方镜像 dolibarr/dolibarr 并配套 MariaDB，用轩辕镜像加速拉取，适合内网自托管与小型团队私有化。

*本文基于 [dolibarr/dolibarr:22.0.5](https://xuanyuan.cloud/r/dolibarr/dolibarr)，以 **22.0.5** 版本实测，测试平台 **Ubuntu 24.04** Linux。*

小公司开报价单还在 Word 里改抬头，客户电话散在销售微信与旧 Excel；仓库盘点一张纸，财务月底再手工对一遍发票号。换人交接时说不清「哪份才是最终版」，催款也要对着聊天记录翻。业务体量不大，却已经需要联系人、报价、订单、库存和简单财务在同一处。

把整套系统塞进公有云 SaaS，客户资料与发票附件会出域；自己从源码装 PHP、配 Apache、再手搓 MySQL，对只要先有一个内网网址的人成本太高。机房或家里已经有一台跑 Docker 的 Ubuntu，缺的是：镜像能拉下来、数据库和应用一起起来、浏览器打开就能建公司与客户。

**Dolibarr**（[官网](https://www.dolibarr.org/)、[GitHub · dolibarr/dolibarr](https://github.com/dolibarr/dolibarr)、[镜像页](https://xuanyuan.cloud/r/dolibarr/dolibarr)）是开源 ERP / CRM：客户与供应商、报价与发票、库存、费用报销、休假等能力按模块开关。官方镜像 **`dolibarr/dolibarr`** 只带 Web（PHP + Apache），**不内置数据库**，需要单独准备 MariaDB 或 MySQL。本文使用 **`dolibarr/dolibarr:22.0.5`** 版本实测：Compose 拉起 Web 与 MariaDB 后，安装程序会自动创建数据库和管理员，附件与外部模块写在本机目录。

跑通之后，可以在浏览器里完善公司资料、按需打开模块，再建客户、开报价，或先走费用报销 / 休假这类人事流程——业务数据都在自己的盘上。

---

## 一、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04**；macOS 目录用 `~/docker/dolibarr` |
| Docker | Engine + **Compose V2** |
| 架构 | **linux/amd64**、**linux/arm64**（`22.0.5` 均有） |
| 内存 | 建议 ≥ **2 GB** 空闲（Web + MariaDB） |
| 磁盘 | 应用 DISK **1.33 GB** / CONTENT **319 MB**；MariaDB DISK **455 MB** / CONTENT **108 MB**；业务数据另计 |
| 端口 | 宿主机 **8088** → 容器 **80** |
| 工作目录 | `/www/wwwroot/dolibarr` |

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

更多见[轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 二、拉取镜像

### 2.1 标签怎么选

| 标签 | 说明 | 本文是否采用 |
|------|------|--------------|
| **`22.0.5`** | 22.x 较新的具体稳定版；amd64 / arm64 | **采用** |
| `22.0.5-php8.2` | 与 `22.0.5` 同源，标明 PHP 8.2 | 可等价选用 |
| `22.0.4` 及更早 | 旧补丁 | 仅回退时用 |
| `develop` | 开发线 | **勿写入生产命令** |
| `latest` | 浮动标签 | **勿写入文中命令** |

完整列表见[标签页](https://xuanyuan.cloud/r/dolibarr/dolibarr/tags)。

升级应用时，只修改 Compose 里的 Dolibarr 镜像标签。

保留 `mariadb`、`documents`、`custom` 三个目录。

`install.lock` 的处理见下文 FAQ 「升级大版本怎么做」。

### 2.2 用轩辕镜像加速拉取

```bash
docker pull docker.xuanyuan.run/dolibarr/dolibarr:22.0.5
docker pull docker.xuanyuan.run/library/mariadb:11.4.13
```

Ubuntu 24.04 实测：

```text
22.0.5: Pulling from dolibarr/dolibarr
...
Digest: sha256:a9f033f7a37a8270d6190c477cb0510fbe3e7da77384715e7773856894cd13ec
Status: Downloaded newer image for docker.xuanyuan.run/dolibarr/dolibarr:22.0.5
docker.xuanyuan.run/dolibarr/dolibarr:22.0.5
```

```text
11.4.13: Pulling from library/mariadb
...
Digest: sha256:70cc072b29b4a89ae07abb2d4da2c64678a7f2dfe092751bb51c87d67dc1338b
Status: Downloaded newer image for docker.xuanyuan.run/library/mariadb:11.4.13
docker.xuanyuan.run/library/mariadb:11.4.13
```

```text
IMAGE                                          DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/dolibarr/dolibarr:22.0.5       1.33GB          319MB
docker.xuanyuan.run/library/mariadb:11.4.13         455MB          108MB
```

---

## 三、Docker Compose 部署（主路径）

按这个顺序做：

1. 建立目录。
2. 写入 `compose.yaml`。
3. 执行 `docker compose up -d`。
4. 等待自动安装完成。
5. 在浏览器登录。

开始之前确认：

- 数据目录使用 `/www/wwwroot/dolibarr`。
- 宿主机端口使用 **8088**，容器端口是 **80**。本机 **80** 上若已有面板或 Nginx，使用 8088 可以避开冲突。
- 应用镜像使用 **`dolibarr/dolibarr:22.0.5`**。数据库镜像使用 MariaDB **`11.4.13`**。

### 3.1 准备目录

在 Linux 上使用 `/www/wwwroot/dolibarr`。

在 macOS 上，把同一路径换成 `~/docker/dolibarr`。

`chown` 的数字改成 `id -u` 和 `id -g` 的结果。

```bash
sudo mkdir -p /www/wwwroot/dolibarr/{mariadb,documents,custom}
sudo chown -R 1000:1000 /www/wwwroot/dolibarr/documents /www/wwwroot/dolibarr/custom
cd /www/wwwroot/dolibarr
```

| 宿主机目录 | 容器路径 | 用途 |
|------------|----------|------|
| `./mariadb` | `/var/lib/mysql` | 数据库 |
| `./documents` | `/var/www/documents` | 附件与 `install.lock` |
| `./custom` | `/var/www/html/custom` | 外部模块 |

### 3.2 写入 compose.yaml

写入文件之前，把 **`DOLI_URL_ROOT`** 改成你的访问地址，地址里要带端口。下文局域网示例是 `http://192.168.1.35:8088`。

```bash
cd /www/wwwroot/dolibarr
cat > compose.yaml <<'EOF'
services:
  mariadb:
    image: docker.xuanyuan.run/library/mariadb:11.4.13
    container_name: dolibarr-mariadb
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: change-me-root-pass
      MYSQL_DATABASE: dolidb
      MYSQL_USER: dolidbuser
      MYSQL_PASSWORD: change-me-db-pass
    volumes:
      - ./mariadb:/var/lib/mysql
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 10s
      timeout: 5s
      retries: 10

  web:
    image: docker.xuanyuan.run/dolibarr/dolibarr:22.0.5
    container_name: dolibarr-web
    restart: unless-stopped
    depends_on:
      mariadb:
        condition: service_healthy
    environment:
      DOLI_INSTALL_AUTO: "1"
      DOLI_INIT_DEMO: "0"
      DOLI_PROD: "1"
      DOLI_DB_HOST: mariadb
      DOLI_DB_NAME: dolidb
      DOLI_DB_USER: dolidbuser
      DOLI_DB_PASSWORD: change-me-db-pass
      DOLI_URL_ROOT: "http://192.168.1.35:8088"
      DOLI_ADMIN_LOGIN: admin
      DOLI_ADMIN_PASSWORD: change-me-admin-pass
      DOLI_COMPANY_NAME: "MyCompany"
      DOLI_COMPANY_COUNTRYCODE: "CN"
      DOLI_CRON: "0"
      WWW_USER_ID: "1000"
      WWW_GROUP_ID: "1000"
      PHP_INI_DATE_TIMEZONE: "Asia/Shanghai"
      PHP_INI_MEMORY_LIMIT: "256M"
    ports:
      - "8088:80"
    volumes:
      - ./documents:/var/www/documents
      - ./custom:/var/www/html/custom
EOF
```

要点：

- `DOLI_DB_PASSWORD` 必须与 `MYSQL_PASSWORD` 相同。
- 首次安装时，安装程序使用 `DOLI_ADMIN_LOGIN` 和 `DOLI_ADMIN_PASSWORD` 创建管理员。
- 上线之前，把管理员密码改成强密码。
- 登录之后，再在页面里修改一次管理员密码。
- 正式环境把 `DOLI_INIT_DEMO` 保持为 `0`。
- 需要演示数据时，才把 `DOLI_INIT_DEMO` 设为 `1`。安装程序会灌入演示数据。
- 需要定时任务时，把 `DOLI_CRON` 设为 `1`。
- 启用定时任务时，写入 `DOLI_CRON_KEY`。

### 3.3 启动并查看状态

在 `/www/wwwroot/dolibarr` 按顺序执行下面的命令。

```bash
cd /www/wwwroot/dolibarr
docker compose up -d
docker compose ps
docker compose logs -f web
```

```text
[+] up 3/3
 ✔ Network dolibarr_default   Created
 ✔ Container dolibarr-mariadb Healthy
 ✔ Container dolibarr-web     Started
```

```text
NAME               IMAGE                                          STATUS                    PORTS
dolibarr-mariadb   docker.xuanyuan.run/library/mariadb:11.4.13    Up … (healthy)            3306/tcp
dolibarr-web       docker.xuanyuan.run/dolibarr/dolibarr:22.0.5   Up …                      0.0.0.0:8088->80/tcp
```

MariaDB 约 **46 s** 变为 `healthy` 之后，Web 容器才会启动。

`logs -f web` 摘录（中间建表日志已省略）：

```text
docker-run.sh started
Current Version of files is : 22.0.5
DOLI_INSTALL_AUTO is on, so we check to initialize or upgrade mariadb database
No table found, we launch initializeDatabase
Importing table from llx_accounting_account.sql ...
...
Create SuperAdmin account ...
Activating module User... OK
Configuring for country : 9:CN:China
Database Version is : 22.0.5
Files Version are   : 22.0.5
Schema update is not required ... Enjoy !
*** You can connect to the running Dolibarr web application with:
http://127.0.0.1:port
Apache/2.4.68 (Debian) configured -- resuming normal operations
```

首次启动会导入大量 `llx_*.sql`，可能持续数分钟。

日志出现就绪句之后，再打开浏览器。

日志出现 **`You can connect to the running Dolibarr web application`**，并且 Apache 已就绪之后，按 `Ctrl+C` 停止跟随日志。

`mkdir … conf: File exists` 和 `AH00558` 可以忽略。

说明见下文 FAQ。

在宿主机检查首页响应：

```bash
curl -sI http://127.0.0.1:8088/ | head -n 5
```

```text
HTTP/1.1 200 OK
Date: Thu, 24 Sep 2026 07:15:53 GMT
Server: Apache
Set-Cookie: DOLSESSID_…=…; path=/; HttpOnly; SameSite=Lax
Expires: Thu, 19 Nov 1981 08:52:00 GMT
```

---

## 四、浏览器初始化

打开页面前，把示例地址中的 IP 换成你的 IP 或域名。

管理员用户名是 **`admin`**。

密码使用 Compose 中的 `DOLI_ADMIN_PASSWORD`。

本文示例值是 `change-me-admin-pass`。

在第 9 步修改管理员密码之前，示例密码仍然可以登录。

1. 打开 `http://192.168.1.35:8088`。
2. 使用用户名 `admin` 登录。

   ![Dolibarr 22.0.5 登录页，用户名 admin，简体中文「登陆」](https://imgs.xuanyuan.cloud/docker/blog/dolibarr-1.webp)

自动安装已经启用用户模块。

其他模块启用之前，侧栏不会出现对应菜单。

3. 打开「设置」。

   页面会提示完善「公司 / 组织」，并启用模块。

   ![Dolibarr 设置首页，提示完善「公司 / 组织」并启用模块](https://imgs.xuanyuan.cloud/docker/blog/dolibarr-2.webp)

4. 打开「公司 / 组织」。
5. 核对公司名和国家。本文实测国家为 **China / CN**。

   主币种仍是欧元时，把主币种改为人民币并保存。

   ![Dolibarr「公司 / 组织」设置，公司名 MyCompany，国家 China](https://imgs.xuanyuan.cloud/docker/blog/dolibarr-4.webp)

6. 打开「模块 / 应用」。
7. 按需要启用模块，例如「第三方」（客户）、「商业提案 / 发票」、「产品与库存」，或人事中的「费用报销」和「休假」。

   ![Dolibarr「模块 / 应用」设置页，按分类列出可启用模块](https://imgs.xuanyuan.cloud/docker/blog/dolibarr-3.webp)

8. 打开「主题 → 语言和呈现」。

   浏览器已经是中文时，语言保持「自动检测」。

   ![Dolibarr「主题」设置：语言和呈现](https://imgs.xuanyuan.cloud/docker/blog/dolibarr-5.webp)

9. 修改管理员密码。
10. 核对浏览器地址栏与 `DOLI_URL_ROOT` 是否一致。

地址不一致时，生成的链接会错。

---

## 五、功能演示

「我的看板」汇总逾期、报销、休假等卡片。新装后的账号多为 SuperAdmin，业务计数为 0。

![Dolibarr「我的看板」，全局视图与登录信息](https://imgs.xuanyuan.cloud/docker/blog/dolibarr-6.webp)

启用人事相关模块之后，顶栏会出现「人事管理」。

新装时，费用报销和休假列表为空。这是正常现象。

可以从「+」新建一张单据，确认页面能打开。

![Dolibarr 费用报销单清单（暂无记录）](https://imgs.xuanyuan.cloud/docker/blog/dolibarr-7.webp)

![Dolibarr 休假列表，状态筛选为待批准](https://imgs.xuanyuan.cloud/docker/blog/dolibarr-8.webp)

销售和库存可以按下面的顺序做：

1. 启用「第三方」等模块。
2. 新建客户或供应商。
3. 创建报价或订单。
4. 开发票。

「产品与库存」模块启用之后，再维护产品和出入库。

合同和 PDF 等附件写在 `documents` 卷中。

备份时，把 `documents`、`mariadb`、`custom` 一起打包。

更细的模块说明见 [Dolibarr Wiki](https://wiki.dolibarr.org/)。

---

## 六、备选：docker run

这一节只用于临时试玩。

第三节的 Compose 已经在运行时，先在 `/www/wwwroot/dolibarr` 执行 `docker compose down`。

不先停止时，容器名会冲突。

先启动 MariaDB。

数据库就绪之后（约数十秒），再启动 Web 容器。

```bash
sudo mkdir -p /www/wwwroot/dolibarr/{mariadb,documents,custom}
sudo chown -R 1000:1000 /www/wwwroot/dolibarr/documents /www/wwwroot/dolibarr/custom

docker network create dolibarr-net

docker run -d 
  --name dolibarr-mariadb 
  --network dolibarr-net 
  --restart unless-stopped 
  -e MYSQL_ROOT_PASSWORD=change-me-root-pass 
  -e MYSQL_DATABASE=dolidb 
  -e MYSQL_USER=dolidbuser 
  -e MYSQL_PASSWORD=change-me-db-pass 
  -v /www/wwwroot/dolibarr/mariadb:/var/lib/mysql 
  docker.xuanyuan.run/library/mariadb:11.4.13

# 等数据库就绪后再启动 Web（约数十秒）
docker run -d 
  --name dolibarr-web 
  --network dolibarr-net 
  --restart unless-stopped 
  -p 8088:80 
  -e DOLI_INSTALL_AUTO=1 
  -e DOLI_DB_HOST=dolibarr-mariadb 
  -e DOLI_DB_NAME=dolidb 
  -e DOLI_DB_USER=dolidbuser 
  -e DOLI_DB_PASSWORD=change-me-db-pass 
  -e DOLI_URL_ROOT=http://192.168.1.35:8088 
  -e DOLI_ADMIN_LOGIN=admin 
  -e DOLI_ADMIN_PASSWORD=change-me-admin-pass 
  -e DOLI_COMPANY_NAME=MyCompany 
  -e DOLI_COMPANY_COUNTRYCODE=CN 
  -e WWW_USER_ID=1000 
  -e WWW_GROUP_ID=1000 
  -v /www/wwwroot/dolibarr/documents:/var/www/documents 
  -v /www/wwwroot/dolibarr/custom:/var/www/html/custom 
  docker.xuanyuan.run/dolibarr/dolibarr:22.0.5
```

```bash
docker ps --filter name=dolibarr
docker logs --tail 100 dolibarr-web
```

---

## 七、常见问题

**为什么不用 `latest`？**  
`latest` 在拉取时会换成当时的新镜像，界面和迁移步骤可能与本文不一致。

本文命令使用 **`22.0.5`**。

升级之前，先备份 `mariadb`、`documents`、`custom`。

然后再修改应用镜像标签。

**为什么宿主机是 8088？**  
容器内监听 **80**。

宿主机 **80** 经常被 Nginx 或宝塔占用。

宿主机 **80** 空闲时，可以把映射改成 `"80:80"`。

改端口之后，把 `DOLI_URL_ROOT` 改成同一个地址。

**和 `tuxgasy/dolibarr` 有什么区别？**  
社区镜像曾常用 `tuxgasy/dolibarr`。

本文使用官方镜像 **`dolibarr/dolibarr`**（见 [dolibarr-docker](https://github.com/Dolibarr/dolibarr-docker)）。

不要让两套镜像共用同一份 `documents` 或数据库目录。

**和 Odoo / ERPNext 怎么选？**  
Dolibarr 更轻，模块可以逐个打开，适合中小团队先完成销售和库存。

Odoo 和 ERPNext 的功能通常更多，学习和运维成本也更高。

按团队规模选择。

不要把 Odoo 或 ERPNext 和本文的 Compose 部署混在一起。

**国家选了 China，主币种仍是欧元？**  
自动安装会写入国家代码。

主币种仍可能保持默认的欧元。

打开「公司 / 组织」。

把主币种改为人民币或你需要的币种，并保存。

**页面空白或安装很久？**  
现象是页面空白，或首次安装长时间没有完成。

先查看 `docker compose logs web` 和 `docker compose logs mariadb`。

数据库未就绪、`DOLI_DB_PASSWORD` 与 `MYSQL_PASSWORD` 不一致、`documents` 目录权限不对，都会让安装停住。

首次启动会导入数百个 SQL 文件，可能要数分钟。

日志出现就绪句，并且 Apache 已启动之后，再打开页面。

**日志里 `mkdir: … conf: File exists`？**  
安装脚本会尝试创建已经存在的 `conf` 目录。

这条日志可以忽略。

**日志里 `AH00558` / ServerName？**  
这是 Apache 没有设置全局 `ServerName` 时的提示。

这条日志可以忽略。

要去掉这条提示时，按上游说明挂载 `servername.conf`。

**升级大版本怎么做？**  
升级前先选定迁移方式。

保持 `DOLI_INSTALL_AUTO=1` 时，安装程序会自动迁移数据库。

也可以打开 `/install`，使用网页向导升级。

1. 备份 `mariadb`、`documents`、`custom`。
2. 删除 `documents/install.lock`。
3. 修改 Compose 中的应用镜像标签。
4. 执行 `docker compose pull && docker compose up -d`。

**如何启用演示数据？**  
只在首次安装之前把 `DOLI_INIT_DEMO` 设为 `1`。

数据库已经创建之后，再改这个变量，不会补进演示数据。

**可以用 PostgreSQL 吗？**  
本文主路径使用 MariaDB。

若改用 PostgreSQL，官方要求首次安装打开网页 `/install`。

`install.lock` 需要自行维护。

把 `DOLI_DB_TYPE` 设为 `pgsql`。

再把数据库连接改到 PostgreSQL。

**密码能否用 Docker Secrets？**  
部分变量支持 `_FILE` 后缀，例如 `DOLI_DB_PASSWORD_FILE`。

写法见上游 [with-secrets](https://github.com/Dolibarr/dolibarr-docker/tree/main/examples/with-secrets)。

---

## 八、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/dolibarr/dolibarr:22.0.5
docker pull docker.xuanyuan.run/library/mariadb:11.4.13

# Compose
cd /www/wwwroot/dolibarr
docker compose up -d
docker compose ps
docker compose logs -f web
docker compose down

# 探测
curl -sI http://127.0.0.1:8088/ | head -n 5
```

---

## 九、延伸阅读

| 资源 | 链接 |
|------|------|
| [dolibarr/dolibarr 镜像页](https://xuanyuan.cloud/r/dolibarr/dolibarr) | [https://xuanyuan.cloud/r/dolibarr/dolibarr](https://xuanyuan.cloud/r/dolibarr/dolibarr) |
| [标签列表](https://xuanyuan.cloud/r/dolibarr/dolibarr/tags) | [https://xuanyuan.cloud/r/dolibarr/dolibarr/tags](https://xuanyuan.cloud/r/dolibarr/dolibarr/tags) |
| [GitHub · Dolibarr/dolibarr-docker](https://github.com/Dolibarr/dolibarr-docker) | [https://github.com/Dolibarr/dolibarr-docker](https://github.com/Dolibarr/dolibarr-docker) |
| [GitHub · dolibarr/dolibarr](https://github.com/dolibarr/dolibarr) | [https://github.com/dolibarr/dolibarr](https://github.com/dolibarr/dolibarr) |
| [Docker Hub · dolibarr/dolibarr](https://hub.docker.com/r/dolibarr/dolibarr) | [https://hub.docker.com/r/dolibarr/dolibarr](https://hub.docker.com/r/dolibarr/dolibarr) |
| [Dolibarr 官网](https://www.dolibarr.org/) | [https://www.dolibarr.org/](https://www.dolibarr.org/) |
| [Dolibarr Wiki](https://wiki.dolibarr.org/) | [https://wiki.dolibarr.org/](https://wiki.dolibarr.org/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/dolibarr-docker-deploy

