# Docker 部署 JumpServer：轻松搭建开源堡垒机平台

![Docker 部署 JumpServer：轻松搭建开源堡垒机平台](https://imgs.xuanyuan.cloud/docker/blog/jumpserver.webp)

*分类: Docker部署教程 | 标签: JumpServer, jumpserver/jms_all, 堡垒机, Docker, 轩辕镜像, SSH, 运维审计, 私有化部署, 部署教程 | 发布时间: 2026-09-22 08:21:42*

> JumpServer 是开源堡垒机，支持 SSH、RDP、数据库等资产的授权、审计与 Web 终端。本文将介绍如何通过 Docker Compose 部署官方 all-in-one 镜像 jumpserver/jms_all，用轩辕镜像加速拉取，适合内网运维审计与小团队自托管。

*本文基于 [jumpserver/jms_all:v5.0.0](https://xuanyuan.cloud/zh/r/jumpserver/jms_all)，实测引擎 **JumpServer v5.0.0**，测试平台 **Ubuntu 24.04** Linux。*

运维群里还在传 `root` 密码：有人记在 Excel，有人贴到企业微信，有人把跳板机的 `authorized_keys` 拷来拷去。新人入职要连三台机器，旧同事离职了密钥还在；出了事故回看聊天记录，说不清谁在哪台机器敲过什么。RDP、数据库、云主机的入口又各一套，权限一散，审计更难。

把账号交到公有云堡垒或第三方跳板，又会碰到内网隔离、等保和「会话录像不出域」。很多机房已经有一台跑 Docker 的 Ubuntu，缺的是：镜像能拉下来、密钥和数据落在自己盘上、浏览器里就能授权资产、Web 终端连上去并留下会话记录。

**JumpServer**（[官网](https://www.jumpserver.org/)、[文档](https://docs.jumpserver.org/)、[镜像页](https://xuanyuan.cloud/r/jumpserver/jms_all)）是开源堡垒机。本文跟做 **`jumpserver/jms_all`**：官方 all-in-one 镜像，控制台、Web 终端、资产与授权打进一个容器，内置 PostgreSQL。浏览器管资产、发授权、开终端；会话走 JumpServer，口令不必再在群里传。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 统一入口 | 运维用各自的 JumpServer 账号登录，不再共用一台机的 `root` 口令 |
| 纳管主机 | 把内网 Linux / Windows / 数据库加进资产树，凭据保存在 JumpServer |
| Web 终端 | 授权后在浏览器里连 SSH / RDP，会话可审计 |
| 权限回收 | 人员变动时停账号或改授权，不必逐台改密钥、清 `authorized_keys` |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`jumpserver/jms_all:v5.0.0`**，**Docker Compose** 启动。把文中的服务器 IP、`DOMAINS` 换成你的访问地址。

官方：[JumpServer 官网](https://www.jumpserver.org/) · [快速入门](https://docs.jumpserver.org/zh/v4/quick_start/) · [all-in-one Dockerfile](https://github.com/jumpserver/Dockerfile) · [镜像页](https://xuanyuan.cloud/r/jumpserver/jms_all) · [标签列表](https://xuanyuan.cloud/r/jumpserver/jms_all/tags)

---

## 一、jumpserver/jms_all 是什么？

`jumpserver/jms_all` 是 JumpServer 的**单容器一体化**镜像：Web 控制台、终端组件和内置 PostgreSQL 同容器运行。业务数据进命名卷 `jsdata`（`/opt/data`），数据库进 `pgdata`（`/var/lib/postgresql`）。浏览器访问宿主机 **8080**，SSH 相关入口映射 **2222**。本镜像走**纯 B/S**：用浏览器管理与连资产，不提供独立 Client。

```text
浏览器 ──HTTP:8080──▶  Web 控制台 / Web 终端
SSH 客户端 ──:2222──▶  终端组件（Koko 等）
        │
        ▼
  jumpserver/jms_all:v5.0.0
        ├── /opt/data           ← 命名卷 jsdata
        └── /var/lib/postgresql ← 命名卷 pgdata
```

跟做坐标：**`jumpserver/jms_all:v5.0.0`**。[`/r/`](https://xuanyuan.cloud/r/jumpserver/jms_all) 与 [`/zh/r/`](https://xuanyuan.cloud/zh/r/jumpserver/jms_all) 为同一镜像的不同页面语言。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04**；macOS 用 `~/docker/jms-all` |
| Docker | Engine + **Compose V2** |
| 架构 | **`v5.0.0` 当前为 linux/amd64**；arm64 请核 [标签页](https://xuanyuan.cloud/r/jumpserver/jms_all/tags)，或选用带 arm64 的旧版（如 `v4.10.19`） |
| 内存 | **≥ 4 GB**；偏紧时启动慢或 OOM |
| 磁盘 | Hub 标注压缩约 **1.05 GB**；解压与录像另计 |
| 端口 | 宿主机 **8080**（HTTP）、**2222**（SSH）；容器内 **80 / 2222** |

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

---

## 三、拉取镜像

### 3.1 标签怎么选

| 标签 | 说明 | 是否跟做 |
|------|------|----------|
| **`v5.0.0`** | 撰写时较新的具体版本，与当时 `latest` 同源；amd64 | **推荐** |
| `v4.10.19` 等 | v4 线；部分标签有 amd64 / arm64 | 需要 arm64 或暂留 v4 |
| `latest` | 浮动标签 | **勿写入跟做命令** |

完整列表见 [标签页](https://xuanyuan.cloud/r/jumpserver/jms_all/tags)。升级只改镜像标签，**密钥与命名卷保持不变**。

### 3.2 用轩辕镜像加速拉取

```bash
docker pull docker.xuanyuan.run/jumpserver/jms_all:v5.0.0
```

Ubuntu 24.04 实测：

```text
v5.0.0: Pulling from jumpserver/jms_all
3f4f5203236f: Pull complete
52ad27bdf382: Pull complete
4f4fb700ef54: Pull complete
6b37362b3da7: Pull complete
8e2145ee0a08: Pull complete
44136fa355b3: Download complete
4bc33203a324: Download complete
Digest: sha256:027460f2d0c3b55b20497b7a8599aab70864e679d31417ce55a08e4add2f59c8
Status: Downloaded newer image for docker.xuanyuan.run/jumpserver/jms_all:v5.0.0
docker.xuanyuan.run/jumpserver/jms_all:v5.0.0
```

体积较大，首次拉取预留时间与磁盘即可。

---

## 四、Docker Compose 部署（主路径）

顺序：**建目录 → 写 `.env` → 写 compose.yaml → `up -d` → 等就绪 → 浏览器登录**。

上游示例常占宿主机 **80**。本机若已有 Nginx / 面板，会冲突，故改为 **8080→80**；SSH 仍为 **2222**。访问 `http://IP:8080`。

持久化与上游一致：用命名卷 `jsdata`、`pgdata`。**不要**把空目录绑到 `/var/lib/postgresql`，否则会盖住镜像内 PostgreSQL，出现 `17/main is not accessible` 并卡在 `wait for database`（FAQ 有排障）。

### 4.1 准备目录

```bash
sudo mkdir -p /www/wwwroot/jms-all
cd /www/wwwroot/jms-all
```

macOS 换成 `~/docker/jms-all`。数据在命名卷里，不必再 `mkdir` 业务子目录。

### 4.2 生成密钥与访问地址写入 `.env`

`SECRET_KEY`、`BOOTSTRAP_TOKEN` 用于加密与组件注册；**升级时必须与首次一致**，否则库里加密字段解不开。勿含特殊字符；长度建议分别 ≥ 50、≥ 24。

**`DOMAINS`** 填浏览器地址栏的 **主机:端口**（不要 `http://`）。局域网示例 `192.168.1.35:8080`；多个入口用英文逗号分隔。漏配或写错时，登录页会红框提示设置 `DOMAINS`。

```bash
cd /www/wwwroot/jms-all
SECRET_KEY=$(openssl rand -base64 48 | tr -d '/+=' | cut -c1-50)
BOOTSTRAP_TOKEN=$(openssl rand -hex 16)
# 将 DOMAINS 改成你的访问地址
cat > .env <<EOF
SECRET_KEY=${SECRET_KEY}
BOOTSTRAP_TOKEN=${BOOTSTRAP_TOKEN}
LOG_LEVEL=ERROR
DOMAINS=192.168.1.35:8080
EOF
chmod 600 .env
```

`grep -E 'SECRET_KEY|DOMAINS' .env` 确认即可。`.env` 勿提交公开仓库。

### 4.3 写入 compose.yaml

```bash
cd /www/wwwroot/jms-all
cat > compose.yaml <<'EOF'
services:
  jms_all:
    image: docker.xuanyuan.run/jumpserver/jms_all:v5.0.0
    container_name: jms_all
    restart: unless-stopped
    ports:
      - "8080:80"
      - "2222:2222"
    env_file:
      - .env
    volumes:
      - jsdata:/opt/data
      - pgdata:/var/lib/postgresql

volumes:
  jsdata:
  pgdata:
EOF
```

| 项 | 含义 |
|----|------|
| `8080:80` | 宿主机 **8080** → 容器 **80** |
| `2222:2222` | SSH / 终端入口 |
| `env_file` | 读入密钥与 **`DOMAINS`** |
| `jsdata` / `pgdata` | 业务数据与内置 PostgreSQL |

### 4.4 启动与验证

```bash
cd /www/wwwroot/jms-all
docker compose up -d
docker compose ps
docker compose logs -f --tail 100 jms_all
```

首次冷启动常需 **几分钟**：建库、跑完 Django migration，再起 supervisor（core / koko / web）。其间短暂刷 `wait for jms_core` 或 `connection refused` 属正常，等 Core 起来即可；另开终端探测也可以。

Ubuntu 24.04 实测摘录：

```text
>> Init database
>> Start database postgre
ALTER ROLE
CREATE DATABASE
>> Update database structure
… Running migrations: … OK
Time: 2026-09-22 15:49:40
… success: core entered RUNNING state …
… success: koko entered RUNNING state …
… success: web entered RUNNING state …
```

```bash
curl -sI http://127.0.0.1:8080/
```

实测：

```text
HTTP/1.1 200 OK
Server: nginx
Date: Tue, 22 Sep 2026 07:52:41 GMT
Content-Type: text/html
Content-Length: 3763
Connection: keep-alive
```

浏览器打开 `http://192.168.1.35:8080`（换成你的 IP）会跳到登录页。`Ctrl+C` 只结束 `logs -f`，容器继续跑。

可忽略：`rm: cannot remove '/var/log/nginx'`、偶发 logs 目录 `mv` 提示、Django `RuntimeWarning`、supervisor 以 root 运行。若见 `kael stopped ... codex-cli`，只影响 AI 助手，不挡登录（见 FAQ）。

---

## 五、浏览器首次登录

1. 打开 `http://<服务器IP>:8080`（实测：`http://192.168.1.35:8080`）。
2. 默认账号：**admin** / **ChangeMe**。
3. 按提示改密、完善资料后进入控制台。

### 5.1 登录页

语言选「中文 (简体)」，填入账号后登录。

![JumpServer 登录页，简体中文，地址 192.168.1.35:8080](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-1.webp)

若顶部红框要求设置 `DOMAINS=…`，说明 `.env` 与地址栏不一致。改对 `DOMAINS` 后执行 `docker compose up -d --force-recreate`（命令见 FAQ）。

![JumpServer 登录页提示须设置 DOMAINS](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-2.webp)

### 5.2 强制改密

默认口令会被判定过简，弹出「请修改密码」，确认后进入重置页，提交新密码。

![JumpServer 提示请修改密码](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-3.webp)

![JumpServer 重置密码表单](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-4.webp)

### 5.3 完善个人信息

「个人信息完善」中用户名多为 `admin`，名称、邮箱可改；勾选同意条款后提交。页面上的 `admin(Administrator)` 水印是 JumpServer 的防截图水印，属正常。

![JumpServer 个人信息完善页](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-5.webp)

进入系统后，可在系统设置里填写「当前站点 URL」（内网示例：`http://192.168.1.35:8080`），邮件链接等会用到。默认口令见上游 [all-in-one README](https://github.com/jumpserver/Dockerfile/blob/master/allinone/README.md)。公网务必强密码 + HTTPS / 来源限制。

---

## 六、主界面与核心功能

下列截图来自局域网实测空库环境：尚未纳管真实主机，侧重菜单与首次界面。加资产、授权的逐步字段说明见 [官方快速入门](https://docs.jumpserver.org/zh/v4/quick_start/)。

### 6.1 仪表盘

控制台「仪表盘」汇总在线会话、用户与资产。新装常见用户 **1**（Administrator）、资产 **0**。

![JumpServer 仪表盘，用户 1、资产 0](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-6.webp)

### 6.2 用户与资产

「用户管理 → 用户列表」可改管理员、再建运维账号。

![JumpServer 用户列表中的 admin](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-7.webp)

「资产管理 → 资产列表」按主机、数据库等分类；点「创建」添加第一台机器。

![JumpServer 资产列表为空](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-8.webp)

「网域列表」用来描述资产所在位置（机房、VPC 等），创建后再挂网关与资产。

![JumpServer 创建网域对话框](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-9.webp)

### 6.3 账号与授权

「账号管理」保存连资产的凭据；「账号模版」可预设用户名与密文策略，便于批量推送。

![JumpServer 账号列表](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-10.webp)

![JumpServer 创建账号模版](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-11.webp)

「资产授权」把用户（组）绑到资产与账号；「命令过滤」可对危险命令拒绝或告警。

![JumpServer 资产授权列表](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-12.webp)

![JumpServer 创建命令过滤规则](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-13.webp)

### 6.4 系统设置

「平台列表」内置 Linux、Windows 等协议模板；「通知设置」可配 SMTP；「远程应用」可见 WebLite、DBeaver 等内置项。「AI 助手」默认关闭，不配也能用堡垒主流程。

![JumpServer 系统设置 · 平台列表](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-14.webp)

![JumpServer 系统设置 · AI 助手未启用](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-15.webp)

![JumpServer 系统设置 · 邮件通知](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-16.webp)

![JumpServer 系统设置 · 远程应用](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-17.webp)

### 6.5 Web 终端

从顶栏进入 Web 终端：左侧资产树，右侧会话区。尚无资产时显示快捷键与「未连接」；完成纳管与授权后，右键资产即可连接。

![JumpServer Web 终端工作台](https://imgs.xuanyuan.cloud/docker/blog/jumpserver-18.webp)

---

## 七、升级与密钥注意

1. 备份 `.env` 中的密钥：

```bash
grep -E 'SECRET_KEY|BOOTSTRAP_TOKEN|DOMAINS' /www/wwwroot/jms-all/.env
```

2. 备份命名卷（卷名以 `docker volume ls | grep jms` 为准，项目目录为 `jms-all` 时多为 `jms-all_jsdata` / `jms-all_pgdata`）：

```bash
mkdir -p /www/wwwroot/jms-all/backup
docker run --rm -v jms-all_jsdata:/from -v /www/wwwroot/jms-all/backup:/to alpine \
  tar czf /to/jsdata-$(date +%F).tgz -C /from .
docker run --rm -v jms-all_pgdata:/from -v /www/wwwroot/jms-all/backup:/to alpine \
  tar czf /to/pgdata-$(date +%F).tgz -C /from .
```

3. 只改 `compose.yaml` 里的镜像标签，**不要改** `.env` 的 `SECRET_KEY` / `BOOTSTRAP_TOKEN`。
4. 滚动升级：

```bash
cd /www/wwwroot/jms-all
docker compose pull
docker compose up -d
```

---

## 八、备选：docker run

无 Compose 时可用命名卷直接跑：

```bash
docker volume create jsdata
docker volume create pgdata

SECRET_KEY=$(openssl rand -base64 48 | tr -d '/+=' | cut -c1-50)
BOOTSTRAP_TOKEN=$(openssl rand -hex 16)

docker run -d \
  --name jms_all \
  --restart unless-stopped \
  -p 8080:80 \
  -p 2222:2222 \
  -e SECRET_KEY="${SECRET_KEY}" \
  -e BOOTSTRAP_TOKEN="${BOOTSTRAP_TOKEN}" \
  -e LOG_LEVEL=ERROR \
  -e DOMAINS=192.168.1.35:8080 \
  -v jsdata:/opt/data \
  -v pgdata:/var/lib/postgresql \
  docker.xuanyuan.run/jumpserver/jms_all:v5.0.0
```

把 `DOMAINS` 和密钥记下来；升级时密钥必须一致。

```bash
docker ps --filter name=jms_all
docker logs --tail 100 jms_all
docker rm -f jms_all   # 命名卷仍保留
```

---

## 九、常见问题

**为什么不用 `latest`？**  
会随仓库滚动，界面与依赖可能和文档脱节。跟做写 **`v5.0.0`**。

**为什么宿主机是 8080？**  
容器内 Web 是 **80**；宿主机 80 常被 Nginx / 面板占用。确认空闲时可自行改成 `"80:80"`。

**登录提示「配置文件存在问题 / DOMAINS=…」？**  
把地址栏的主机:端口写入 `.env`（不要 `http://`），再重建：

```bash
cd /www/wwwroot/jms-all
grep -q '^DOMAINS=' .env \
  && sed -i 's|^DOMAINS=.*|DOMAINS=192.168.1.35:8080|' .env \
  || echo 'DOMAINS=192.168.1.35:8080' >> .env
docker compose up -d --force-recreate
```

本机与局域网并用时可写：`DOMAINS=192.168.1.35:8080,127.0.0.1:8080`。

**`postgresql/17/main is not accessible`，一直 `wait for database`？**  
空目录绑过 `/var/lib/postgresql`。改回命名卷后：

```bash
cd /www/wwwroot/jms-all
docker compose down
# compose 中应为 pgdata:/var/lib/postgresql，并有 volumes: 声明
docker compose up -d
```

**冷启动一直 `wait for jms_core`？**  
等容器内 Core 健康检查，常见于 migration 刚结束。用 `curl -sI http://127.0.0.1:8080/` 探测；与「空绑定盖库」不是同一类问题。

**日志里 `kael stopped` / `codex-cli`？**  
AI 组件 Kael 退出。控制台、资产、Web 终端不受影响；「AI 助手」可保持关闭。

**和 Installer / 拆分镜像怎么选？**  
本文是单机 all-in-one、纯 B/S。要多节点、Client 或按企业清单上生产，走 [官方文档](https://docs.jumpserver.org/) 的 Installer 与拆分镜像，那是另一条线。

**页面打不开？**  
看 `docker compose ps` 与 `logs --tail 200`；确认内存、防火墙放行 **8080** / **2222**。

**升级后解不开数据？**  
核对 `.env` 密钥是否与首次一致，命名卷是否仍是原来的 `jsdata` / `pgdata`。

**要外置 MySQL / Redis 吗？**  
主路径用内置库即可。外置要求见 [allinone/README](https://github.com/jumpserver/Dockerfile/blob/master/allinone/README.md)。

**可以公网吗？**  
本文按内网写。公网请强密码、HTTPS、限制来源，并评估是否改用标准部署。

---

## 十、命令速查

```bash
docker pull docker.xuanyuan.run/jumpserver/jms_all:v5.0.0

sudo mkdir -p /www/wwwroot/jms-all && cd /www/wwwroot/jms-all
SECRET_KEY=$(openssl rand -base64 48 | tr -d '/+=' | cut -c1-50)
BOOTSTRAP_TOKEN=$(openssl rand -hex 16)
cat > .env <<EOF
SECRET_KEY=${SECRET_KEY}
BOOTSTRAP_TOKEN=${BOOTSTRAP_TOKEN}
LOG_LEVEL=ERROR
DOMAINS=192.168.1.35:8080
EOF
chmod 600 .env
# compose.yaml 见第四节

docker compose up -d
docker compose ps
docker compose logs --tail 100 jms_all
curl -sI http://127.0.0.1:8080/

# 备选 run（须带 DOMAINS）
docker volume create jsdata && docker volume create pgdata
docker run -d --name jms_all --restart unless-stopped \
  -p 8080:80 -p 2222:2222 \
  -e SECRET_KEY=... -e BOOTSTRAP_TOKEN=... -e LOG_LEVEL=ERROR \
  -e DOMAINS=192.168.1.35:8080 \
  -v jsdata:/opt/data -v pgdata:/var/lib/postgresql \
  docker.xuanyuan.run/jumpserver/jms_all:v5.0.0
```

浏览器：`http://<IP>:8080` · **admin / ChangeMe**（登录后改密）· **`v5.0.0`** · 卷 **`jsdata` / `pgdata`** · 必配 **`DOMAINS`**

---

## 十一、延伸阅读

| 资源 | 链接 |
|------|------|
| [jumpserver/jms_all 镜像页](https://xuanyuan.cloud/r/jumpserver/jms_all) | [https://xuanyuan.cloud/r/jumpserver/jms_all](https://xuanyuan.cloud/r/jumpserver/jms_all) |
| [中文镜像页](https://xuanyuan.cloud/zh/r/jumpserver/jms_all) | [https://xuanyuan.cloud/zh/r/jumpserver/jms_all](https://xuanyuan.cloud/zh/r/jumpserver/jms_all) |
| [镜像标签列表](https://xuanyuan.cloud/r/jumpserver/jms_all/tags) | [https://xuanyuan.cloud/r/jumpserver/jms_all/tags](https://xuanyuan.cloud/r/jumpserver/jms_all/tags) |
| [Docker Hub · jumpserver/jms_all](https://hub.docker.com/r/jumpserver/jms_all) | [https://hub.docker.com/r/jumpserver/jms_all](https://hub.docker.com/r/jumpserver/jms_all) |
| [GitHub · jumpserver/Dockerfile](https://github.com/jumpserver/Dockerfile) | [https://github.com/jumpserver/Dockerfile](https://github.com/jumpserver/Dockerfile) |
| [all-in-one README](https://github.com/jumpserver/Dockerfile/blob/master/allinone/README.md) | [https://github.com/jumpserver/Dockerfile/blob/master/allinone/README.md](https://github.com/jumpserver/Dockerfile/blob/master/allinone/README.md) |
| [JumpServer 官网](https://www.jumpserver.org/) | [https://www.jumpserver.org/](https://www.jumpserver.org/) |
| [JumpServer 快速入门](https://docs.jumpserver.org/zh/v4/quick_start/) | [https://docs.jumpserver.org/zh/v4/quick_start/](https://docs.jumpserver.org/zh/v4/quick_start/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/jms-all-docker-deploy


