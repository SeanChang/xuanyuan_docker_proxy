# Docker 部署 ezBookkeeping：轻松搭建自托管个人记账平台

![Docker 部署 ezBookkeeping：轻松搭建自托管个人记账平台](https://imgs.xuanyuan.cloud/docker/blog/ezBookkeeping/ezBookkeeping.webp)

*分类: Docker部署教程 | 标签: ezBookkeeping,mayswind/ezbookkeeping,Docker,轩辕镜像,个人记账,财务管理,私有化部署,部署教程 | 发布时间: 2026-11-03 17:49:04*

> ezBookkeeping 是开源的自托管个人财务应用，用来记录日常收支，并支持分类检索与图表分析。本文将介绍如何通过 Docker Compose 部署 mayswind/ezbookkeeping，把账本和附件留在本机目录，适合家用 NAS、树莓派与内网自建。

## ezBookkeeping 是什么

ezBookkeeping 是开源的自托管个人财务应用。它面向日常收支记录，桌面与手机浏览器都能用，也可以按 PWA 方式加到主屏幕。数据保存在你部署的那台机器上。

和只在手机本地存账单的 App 不同，它把服务放在服务器或 NAS，多设备共用同一套账本。定位偏个人与家庭记账：单容器即可起步，默认用 SQLite，需要时再换成 MySQL 或 PostgreSQL。

## ezBookkeeping 能做什么

- **日常记账**：记录收入、支出与转账，支持二级账户与分类，并可附图片、地点。
- **检索与筛选**：按条件搜索、过滤账单，找回历史流水。
- **图表分析**：用内置图表看趋势，也可按自定义维度统计。
- **导入导出**：支持多种常见账单格式，便于从其他工具迁入。
- **多端与本地化**：桌面与移动浏览器可用，并支持多语言、多币种与时区。

## 为什么要使用 ezBookkeeping

商业记账 App 把账单放在对方服务里，导出和备份往往受平台限制。家用 NAS、树莓派和内网机器已经在线，却常常还没有一套自己的记账服务。

ezBookkeeping 用容器跑起来后，数据库和附件落在本机目录。适合个人或家庭自建账本；本文先用 SQLite 跑通，正式长期使用可再换 MySQL 或 PostgreSQL。

## 使用 Docker 部署 ezBookkeeping

ezBookkeeping 可以用 Docker 启动，不必在宿主机单独编译或安装运行时。部署前准备好 Docker，并规划数据目录与访问地址。

接下来用 Docker Compose 写好镜像、端口、密钥与卷，启动服务，再在浏览器里注册、添加账户并记一笔账。

## 环境要求

本文使用 **`mayswind/ezbookkeeping:2.1.1`** 版本实测。测试平台是 Ubuntu 24.04（主机名 `ikuai-ubuntu2404`）。`2.1.1` 与同日推送的 `latest` 当前指向同一索引；下次发版后 `latest` 会改指向，本文仍固定 `2.1.1`。镜像提供 **linux/amd64**、**linux/arm64** 与 ARM 变体；Docker Hub 上 amd64 压缩体积约 **28 MB**。登录页脚为 **Powered by ezBookkeeping v2.1.1**。

容器内 Web 服务听 **8080**，本文宿主机也映射 **8080**。没有预置账号，打开后自行注册。启动前必须写入随机 `secret_key`，并把 `domain` 设成浏览器实际访问用的主机名或 IP。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文按 Ubuntu 目录书写）；macOS 把 `/www/wwwroot/ezbookkeeping` 换成 `~/docker/ezbookkeeping` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64**、**linux/arm**（含常见 ARM 变体） |
| 内存 | 建议 ≥ **256 MB** 可用 |
| 磁盘 | 镜像约数十 MB，另加 `data`、`storage` 增长空间 |
| 端口 | 宿主机 **8080** → 容器 **8080** |
| 工作目录 | `/www/wwwroot/ezbookkeeping` |
| 账号 | 无默认密码；首次访问自行注册 |
| 目录权限 | 容器进程 UID/GID 为 **1000:1000** |

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

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=ezbookkeeping-docker-deploy)。

## 标签怎么选

新安装使用 **`2.1.1`**。不要把 `latest` 或 `latest-snapshot` 写进 Compose。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`2.1.1`** | 当前发行版，本文采用 | **是** |
| `2.1.0`、`2.0.1` 等 | 更早的固定版本，便于回滚 | 否 |
| `2.1` | 同主版本上的滚动线 | 否 |
| `latest` | 浮动标签，当前与 `2.1.1` 同 Digest，发版后会变 | 否 |
| `latest-snapshot` / `SNAPSHOT-*` | 每日构建，不稳定 | 否 |

完整列表见 [标签列表](https://xuanyuan.cloud/r/mayswind/ezbookkeeping/tags?xy_from=ezbookkeeping-docker-deploy)。发布说明见 [v2.1.1](https://github.com/mayswind/ezbookkeeping/releases/tag/v2.1.1)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud/?xy_from=ezbookkeeping-docker-deploy) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/mayswind/ezbookkeeping:2.1.1
```

Ubuntu 24.04 上拉取完成：

```text
2.1.1: Pulling from mayswind/ezbookkeeping
e2de96513ba9: Pull complete
e45c9796bd98: Pull complete
1b7a12669c77: Pull complete
f8753cfb3f35: Pull complete
4f4fb700ef54: Pull complete
2d6eedab9c46: Pull complete
2426482b2a0b: Pull complete
bb2c07336c1f: Pull complete
9ae65ad47b48: Pull complete
e64699b54316: Pull complete
4ef6a8bc1a6a: Pull complete
44136fa355b3: Download complete
72ba8fb4fc3f: Download complete
Digest: sha256:584e4d7f6fc1642773e840b56296f8782912e3bb17abfe3c49097508b198cdb7
Status: Downloaded newer image for docker.xuanyuan.run/mayswind/ezbookkeeping:2.1.1
docker.xuanyuan.run/mayswind/ezbookkeeping:2.1.1
```

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq?xy_from=ezbookkeeping-docker-deploy)。

## Docker Compose 部署

工作目录：Linux **`/www/wwwroot/ezbookkeeping`**。macOS 用 **`~/docker/ezbookkeeping`**。

本文默认使用内置 **SQLite**，并把数据库与附件目录挂到宿主机。官方建议长期使用时改用 MySQL 或 PostgreSQL；SQLite 适合先跑通和个人轻量场景，见「常见问题」。

| 宿主机目录 | 容器内路径 | 用途 |
|------------|------------|------|
| `data/` | `/ezbookkeeping/data` | SQLite 数据库等 |
| `storage/` | `/ezbookkeeping/storage` | 头像、交易图片等附件 |
| `log/` | `/ezbookkeeping/log` | 应用日志（可选，本文一并挂载） |

### 1. 创建目录

容器内进程以 UID/GID **1000** 运行，挂载目录需可被该用户读写。

```bash
sudo mkdir -p /www/wwwroot/ezbookkeeping/{data,storage,log}
sudo chown -R 1000:1000 /www/wwwroot/ezbookkeeping
cd /www/wwwroot/ezbookkeeping
```

macOS：

```bash
mkdir -p ~/docker/ezbookkeeping/{data,storage,log}
sudo chown -R 1000:1000 ~/docker/ezbookkeeping
cd ~/docker/ezbookkeeping
```

### 2. 生成密钥并写入 .env

正式使用必须设置随机 `secret_key`。先生成密钥，再把访问主机名写进 `.env`：

```bash
SECRET_KEY=$(openssl rand -base64 32)
cat > .env <<EOF
EBK_SECURITY_SECRET_KEY=${SECRET_KEY}
EBK_SERVER_DOMAIN=127.0.0.1
EOF
```

`EBK_SERVER_DOMAIN` 必须等于浏览器地址栏里的主机名或 IP。只在服务器本机打开时，保留 `127.0.0.1`；从手机或其他电脑访问时，改成那些设备能访问到的 IP 或域名（例如 `192.168.1.50`）。写错时，头像、交易图片和邮件里的链接会异常。

本文实测在服务器本机访问，`.env` 使用 `127.0.0.1`，日志中 `RootUrl` 为 `http://127.0.0.1:8080/`。

若前面还有反向代理，实际协议或端口与容器内 `http` + `8080` 不一致，在 `.env` 再增加一行，例如：

```text
EBK_SERVER_ROOT_URL=https://ezbookkeeping.example.com/
```

### 3. 写入 compose.yaml

`8080:8080` 表示宿主机 **8080** 对应容器内 **8080**。若本机 8080 已被占用，把左侧改成空闲端口，并同步设置 `EBK_SERVER_ROOT_URL`。

```bash
cat > compose.yaml <<'EOF'
services:
  ezbookkeeping:
    image: docker.xuanyuan.run/mayswind/ezbookkeeping:2.1.1
    container_name: ezbookkeeping
    restart: unless-stopped
    ports:
      - "8080:8080"
    env_file:
      - .env
    environment:
      EBK_SERVER_ENABLE_GZIP: "true"
      EBK_LOG_MODE: console file
      TZ: Asia/Shanghai
    volumes:
      - ./data:/ezbookkeeping/data
      - ./storage:/ezbookkeeping/storage
      - ./log:/ezbookkeeping/log
EOF
```

| 配置 | 说明 |
|------|------|
| `image` | 具体版本标签 `2.1.1` |
| `8080:8080` | 宿主机 **8080** → 容器 **8080** |
| `env_file` | 读取 `.env` 中的密钥与 `EBK_SERVER_DOMAIN` |
| `EBK_SERVER_ENABLE_GZIP` | 开启 gzip |
| `./data` | SQLite 等数据 |
| `./storage` | 头像与交易图片等附件 |
| `./log` | 日志目录 |
| `TZ` | 时区，本文写 `Asia/Shanghai` |

### 4. 启动并确认状态

```bash
docker compose up -d
docker compose ps
```

这次启动完成：

```text
[+] up 2/2
 ✔ Network ezbookkeeping_default Created
 ✔ Container ezbookkeeping       Started

NAME            IMAGE                                              COMMAND                  SERVICE         CREATED         STATUS         PORTS
ezbookkeeping   docker.xuanyuan.run/mayswind/ezbookkeeping:2.1.1   "/docker-entrypoint.…"   ezbookkeeping   5 seconds ago   Up 3 seconds   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp
```

再看日志：

```bash
docker compose logs --no-color --tail=80 ezbookkeeping
```

首次启动会依次维护用户、账户、交易等表结构，最后监听端口。关键行：

```text
ezbookkeeping  | 2026-11-03 17:36:40 [INFO] [initializer.initializeSystem] will load configuration from default config path /ezbookkeeping/conf/ezbookkeeping.ini
ezbookkeeping  | 2026-11-03 17:36:40 [INFO] [database.updateAllDatabaseTablesStructure] user table maintained successfully
ezbookkeeping  | 2026-11-03 17:36:42 [INFO] [database.updateAllDatabaseTablesStructure] transaction table maintained successfully
ezbookkeeping  | 2026-11-03 17:36:45 [INFO] [cron_container.registerJob] job "RemoveExpiredTokens" has been registered
ezbookkeeping  | 2026-11-03 17:36:45 [INFO] [cron_container.registerJob] job "CreateScheduledTransaction" has been registered
ezbookkeeping  | 2026-11-03 17:36:45 [INFO] [webserver.startWebServer] will run at http://0.0.0.0:8080
```

配置摘要里应出现 `Domain` 为你在 `.env` 中写入的值，且 `SecretKeyNoSet` 为 `false`。看到 `will run at http://0.0.0.0:8080` 后做本机探测：

```bash
curl -I http://127.0.0.1:8080
```

这次返回：

```text
HTTP/1.1 200 OK
Accept-Ranges: bytes
Content-Length: 12434
Content-Type: text/html; charset=utf-8
```

在浏览器打开（本机用下面地址；其他设备把主机名换成 `.env` 里的 `EBK_SERVER_DOMAIN`）：

```text
http://127.0.0.1:8080
```

## 注册并开始记账

### 1. 打开登录页

打开上面的地址后进入登录页，右侧标题为「欢迎使用 ezBookkeeping」，页脚为 **Powered by ezBookkeeping v2.1.1 (3dcc316)**。没有账号时，点击「还没有账号？创建新账号」。

![ezBookkeeping 登录页：欢迎使用，页脚为 v2.1.1](https://imgs.xuanyuan.cloud/docker/blog/ezBookkeeping/ezBookkeeping-1.webp)

### 2. 注册：填写用户信息

注册向导分两步。第一步是「用户信息」：填写用户名、昵称、电子邮箱、密码，并选择语言、默认货币与每周第一天。本次实测选择「中文 (简体)」、「人民币 CNY」、「星期一」。填完后点「下一步」。

![ezBookkeeping 注册第一步：填写用户信息与默认货币](https://imgs.xuanyuan.cloud/docker/blog/ezBookkeeping/ezBookkeeping-2.webp)

### 3. 注册：选择预设分类

第二步是「交易分类」。打开「使用预设交易分类」后，可预览收入分类（如职业收入、金融投资）与支出分类（如食品饮料、服饰外观、住宅家居）。确认后点「提交」。

![ezBookkeeping 注册第二步：开启预设交易分类后提交](https://imgs.xuanyuan.cloud/docker/blog/ezBookkeeping/ezBookkeeping-3.webp)

提交后直接进入已登录的概览页。若实例会暴露到公网，做完验证后关闭开放注册，见「常见问题」。

### 4. 确认概览页

概览顶部有首页、交易、统计、账户等入口；中间是本月支出/收入、资产摘要、交易热力图与日历；底部是今天、本周、本月、今年的汇总。尚未记账时，金额均为 **¥ 0.00**。

![ezBookkeeping 登录后概览：本月收支与资产摘要均为零](https://imgs.xuanyuan.cloud/docker/blog/ezBookkeeping/ezBookkeeping-4.webp)

### 5. 添加账户

记账前需要至少一个账户。点顶部账户相关入口，打开「添加账户」。选择「单一账户」，账户名称填「我的账户」，分类选「现金」，货币选「人民币 CNY」，再点「添加」。

![ezBookkeeping 添加账户：单一账户，分类现金，货币人民币](https://imgs.xuanyuan.cloud/docker/blog/ezBookkeeping/ezBookkeeping-5.webp)

### 6. 记一笔收入

点顶部「+」，打开「添加交易」。左侧类型选「收入」，金额填 **¥ 1000.00**，分类选「职业收入 > 工资收入」，账户选「我的账户」，再点「添加」。

![ezBookkeeping 添加收入：工资收入 1000 元](https://imgs.xuanyuan.cloud/docker/blog/ezBookkeeping/ezBookkeeping-7.webp)

再点顶部交易列表入口。页面底部会出现「您已经添加新交易」；列表按日汇总总流入与总流出。

![ezBookkeeping 交易列表：新增工资收入后的提示](https://imgs.xuanyuan.cloud/docker/blog/ezBookkeeping/ezBookkeeping-8.webp)

### 7. 再记一笔支出

再次点「+」打开「添加交易」。左侧类型选「支出」，金额填 **¥ 8.00**，分类选「食品饮料 > 食品」，账户仍选「我的账户」，再点「添加」。

![ezBookkeeping 添加支出：食品饮料 8 元](https://imgs.xuanyuan.cloud/docker/blog/ezBookkeeping/ezBookkeeping-6.webp)

回到交易列表，同月会同时出现流入与流出。本次实测为总流入 **¥ 1,000.00**、总流出 **¥ 8.00**，日期为 2026 年 11 月 3 日。

![ezBookkeeping 交易列表：同日工资收入与食品支出](https://imgs.xuanyuan.cloud/docker/blog/ezBookkeeping/ezBookkeeping-9.webp)

### 8. 数据落在哪里

删除容器不会删除宿主机上的 `data/`、`storage/`、`log/`。删掉 `data/` 会丢掉账本数据库；删掉 `storage/` 会丢掉头像与交易图片。迁移时把这三个目录和 `.env` 一起打包。

## 备选：docker run

没有 Compose 时，可用下面的命令临时试玩。先准备目录与密钥，再启动：

```bash
sudo mkdir -p /www/wwwroot/ezbookkeeping/{data,storage,log}
sudo chown -R 1000:1000 /www/wwwroot/ezbookkeeping

SECRET_KEY=$(openssl rand -base64 32)

docker run -d 
  --name ezbookkeeping 
  --restart unless-stopped 
  -p 8080:8080 
  -e EBK_SECURITY_SECRET_KEY="${SECRET_KEY}" 
  -e EBK_SERVER_DOMAIN=127.0.0.1 
  -e EBK_SERVER_ENABLE_GZIP=true 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/ezbookkeeping/data:/ezbookkeeping/data 
  -v /www/wwwroot/ezbookkeeping/storage:/ezbookkeeping/storage 
  -v /www/wwwroot/ezbookkeeping/log:/ezbookkeeping/log 
  docker.xuanyuan.run/mayswind/ezbookkeeping:2.1.1
```

从其他设备访问时，把 `EBK_SERVER_DOMAIN` 换成实际主机名或 IP。查看状态：

```bash
docker ps --filter name=ezbookkeeping
docker logs --tail 80 ezbookkeeping
```

停止并删除容器后，宿主机上述三个目录仍会保留。

## 备份与升级

备份前先停容器，再打包数据目录与 `.env`：

```bash
cd /www/wwwroot/ezbookkeeping
docker compose stop
tar -czf ezbookkeeping-backup.tar.gz data storage log .env
docker compose start
```

升级时只改 `compose.yaml` 里的镜像标签，保留上述目录与 `.env` 后执行：

```bash
docker compose pull
docker compose up -d
```

不要在已有数据后更换 `EBK_SECURITY_SECRET_KEY`。密钥一变，已依赖该密钥的内容可能无法正常使用。

## 常见问题

### 默认用户名和密码是什么

没有默认账号。首次启动后数据库为空，需要自行注册。

### 必须设置 secret_key 吗

必须。用 `openssl rand -base64 32` 生成随机串，写入 `.env` 的 `EBK_SECURITY_SECRET_KEY`。首次启动前设好，之后保持不变。

### 头像或交易图片打不开

核对 `EBK_SERVER_DOMAIN` 是否与浏览器地址栏主机名一致。经反向代理改了协议或端口时，再在 `.env` 设置正确的 `EBK_SERVER_ROOT_URL`，然后 `docker compose up -d`。

### 如何关闭注册

注册并确认能记账后，在 Compose 的 `environment` 中增加：

```yaml
EBK_USER_ENABLE_REGISTER: "false"
```

再执行 `docker compose up -d`。

### 可以用 MySQL 或 PostgreSQL 吗

可以。官方更推荐正式环境使用 MySQL 或 PostgreSQL。设置 `EBK_DATABASE_TYPE`、`EBK_DATABASE_HOST`、`EBK_DATABASE_NAME`、`EBK_DATABASE_USER`、`EBK_DATABASE_PASSWD`，并另行准备数据库服务。本文主路径为 SQLite，便于单容器先跑通。

### 目录权限报错怎么办

确认 `data`、`storage`、`log` 属主为 **1000:1000**：

```bash
sudo chown -R 1000:1000 /www/wwwroot/ezbookkeeping
```

### 可以用 latest 吗

`latest` 是浮动标签。当前虽与 `2.1.1` 同 Digest，发版后会改指向。本文命令使用 **`2.1.1`**。说明见「标签怎么选」。

### 宿主机 8080 被占用怎么办

把 Compose 里的 `"8080:8080"` 改成例如 `"18080:8080"`，访问 `http://IP:18080`，并在 `.env` 增加：

```text
EBK_SERVER_ROOT_URL=http://你的服务器IP:18080/
```

然后执行 `docker compose up -d`。

## 命令速查

```bash
docker pull docker.xuanyuan.run/mayswind/ezbookkeeping:2.1.1

cd /www/wwwroot/ezbookkeeping
docker compose up -d
docker compose ps
docker compose logs --no-color --tail=80 ezbookkeeping

# 本机打开 http://127.0.0.1:8080 自行注册；公网环境验证后关闭注册

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [mayswind/ezbookkeeping 镜像页](https://xuanyuan.cloud/r/mayswind/ezbookkeeping?xy_from=ezbookkeeping-docker-deploy) | [https://xuanyuan.cloud/r/mayswind/ezbookkeeping](https://xuanyuan.cloud/r/mayswind/ezbookkeeping?xy_from=ezbookkeeping-docker-deploy) |
| [mayswind/ezbookkeeping 标签列表](https://xuanyuan.cloud/r/mayswind/ezbookkeeping/tags?xy_from=ezbookkeeping-docker-deploy) | [https://xuanyuan.cloud/r/mayswind/ezbookkeeping/tags](https://xuanyuan.cloud/r/mayswind/ezbookkeeping/tags?xy_from=ezbookkeeping-docker-deploy) |
| [Docker Hub · mayswind/ezbookkeeping](https://hub.docker.com/r/mayswind/ezbookkeeping) | [https://hub.docker.com/r/mayswind/ezbookkeeping](https://hub.docker.com/r/mayswind/ezbookkeeping) |
| [GitHub · mayswind/ezbookkeeping](https://github.com/mayswind/ezbookkeeping) | [https://github.com/mayswind/ezbookkeeping](https://github.com/mayswind/ezbookkeeping) |
| [官方文档 · Docker 安装](https://ezbookkeeping.mayswind.net/installation/installation-docker) | [https://ezbookkeeping.mayswind.net/installation/installation-docker](https://ezbookkeeping.mayswind.net/installation/installation-docker) |
| [官方文档 · 配置说明](https://ezbookkeeping.mayswind.net/configuration/) | [https://ezbookkeeping.mayswind.net/configuration/](https://ezbookkeeping.mayswind.net/configuration/) |
| [在线演示](https://ezbookkeeping-demo.mayswind.net) | [https://ezbookkeeping-demo.mayswind.net](https://ezbookkeeping-demo.mayswind.net) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=ezbookkeeping-docker-deploy) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage?xy_from=ezbookkeeping-docker-deploy) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/ezbookkeeping-docker-deploy?xy_from=ezbookkeeping-docker-deploy)

*本文基于 [mayswind/ezbookkeeping:2.1.1](https://xuanyuan.cloud/r/mayswind/ezbookkeeping?xy_from=ezbookkeeping-docker-deploy)，以 **2.1.1** 版本实测，测试平台 **Ubuntu 24.04** Linux（`ikuai-ubuntu2404`）。*


