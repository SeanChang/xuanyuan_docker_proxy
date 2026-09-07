# Docker 部署 Zabbix：轻松搭建企业级监控与告警平台

![Docker 部署 Zabbix：轻松搭建企业级监控与告警平台](https://imgs.xuanyuan.cloud/docker/blog/zabbix.webp)

*分类: Docker部署教程 | 标签: Zabbix,Docker,轩辕镜像,监控,告警,可观测性,私有化部署,部署教程 | 发布时间: 2026-09-02 16:35:13*

> 交换机还在闪灯，业务群已经在刷「接口超时」：有人盯 top，有人翻 Nginx error.log，有人打开云控制台对账——故障窗口一拉长，排障就变成多端接力。想把主机、网络和应用收拢到一处，常见做法是各装 Agent / exporter，再拼告警脚本和值班 Wiki，规则散落、交接时版本也对不上。

*本文基于 [zabbix/zabbix-web-nginx-mysql:alpine-7.4.14](https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-nginx-mysql)，实测引擎 **Zabbix 7.4.14**（Alpine + Nginx + MySQL），配套 [zabbix/zabbix-server-mysql:alpine-7.4.14](https://xuanyuan.cloud/zh/r/zabbix/zabbix-server-mysql) 与 [library/mysql:8.0](https://xuanyuan.cloud/zh/r/library/mysql)，测试平台 **Ubuntu 24.04** Linux。*

交换机还在闪灯，业务群已经在刷「接口超时」：有人盯 `top`，有人翻 Nginx `error.log`，有人打开云控制台对账——故障窗口一拉长，排障就变成多端接力。想把主机、网络和应用收拢到一处，常见做法是各装 Agent / exporter，再拼告警脚本和值班 Wiki，规则散落、交接时版本也对不上。

还有一层更硬的约束：**配置、历史曲线和告警详情最好留在自己的盘上**。公有云监控按探针和保留时长计费，也不适合专有云 / 等保内网；自建又容易变成 Prometheus + Grafana + Alertmanager + 机器人四件套。很多团队其实已经有一台跑 Docker 的 Ubuntu，缺的是镜像能拉、Web 能开、库和 Server 落在挂载目录。

**Zabbix**（[官网](https://www.zabbix.com)、[zabbix-docker](https://github.com/zabbix/zabbix-docker)）是企业级开源监控：采主机与网络指标，触发器可接邮件等通知，报表适合容量规划。本文主角 **`zabbix/zabbix-web-nginx-mysql`**（[镜像页](https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-nginx-mysql)）是官方 **Nginx + MySQL** Web 前端，浏览器里管资源、看图与告警。它**不能单独跑**，必须与同版本 **MySQL**、**`zabbix-server-mysql`** 一起用；7.0 起许可证为 **AGPLv3**。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 打开控制台 | `http://服务器IP:8080`，默认 **`Admin` / `zabbix`**（立刻改密） |
| 加监控对象 | 主机 / 模板 / 触发器；需要时再装 Agent 或用 SNMP |
| 看问题与报表 | 问题列表、仪表盘、历史曲线 |
| 备份搬家 | 停容器后打包 `./mysql/data`（按需带上 `./zabbix`） |

本文用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`alpine-7.4.14`**，**Docker Compose** 拉起 MySQL 8.0 + Server + Web：宿主机 **8080** → 容器 **8080**，**10051** → Server。实测局域网 IP **`192.168.1.35`**，请换成你的。无 Compose 见第八节。文内 **8** 张截图。

> **上手要点**
> - **部署**：第五节 Compose；临时试玩见第八节
> - **端口**：宿主机 **8080** → Web **8080**；**10051** → Server **10051**
> - **冷启动**：MySQL 首次建目录约 **2～3 分钟**（实测约 **150s** 至 Healthy）；Server 灌 `create.sql.gz`（含大量 `images`）在约 **2 GB** 内存机上可再要 **十几～数十分钟**。等日志出现 **`current database version`** 与 **`server #0 started`** 再登录
> - **内存**：建议 ≥ **4 GB**；约 **2 GB** 能跑通但建表很慢
> - **数据**：`./mysql/data` → MySQL；`./zabbix/*` 可选脚本 / 导出目录
> - **日志**：`docker compose logs -f mysql-server`（**服务名**，不是 `container_name`）
> - **账号**：`Admin` / `zabbix`（用户名大小写敏感）；登录后改密、可改中文
> - **标签**：跟做 **`alpine-7.4.14`**，Web 与 Server 同标签；勿写 `latest` / `*-trunk`
> - **密码**：Compose 里库密码改成你自己的；`MYSQL_*` 三处与 healthcheck 的 `-p` **四处一致**
> - **默认主机红灯**：精简栈未装 Agent，接口 `127.0.0.1:10050` 会红——**不影响登录**，消警见 6.4 / 第七节

官方：[容器安装](https://www.zabbix.com/documentation/7.4/en/manual/installation/containers) · [zabbix-docker](https://github.com/zabbix/zabbix-docker) · [标签列表](https://xuanyuan.cloud/r/zabbix/zabbix-web-nginx-mysql/tags)

---

## 一、Zabbix Web（Nginx + MySQL）是什么？

本镜像只提供 **Web**（Nginx + PHP）。采集与告警在 **Zabbix Server**，数据在 **MySQL**。官方还有 Apache / PostgreSQL 组合；本文固定 **Nginx + MySQL**。

| | Zabbix（本文） | Prometheus + Grafana + Alertmanager | 云监控 / 商业 APM |
|--|----------------|-------------------------------------|-------------------|
| 入口 | 浏览器 `:8080` | 多组件分散配置 | 厂商控制台 |
| 组成 | Server + Web + DB | 时序库 + 面板 + 告警链 | 探针 / SaaS |
| 数据 | 本机 MySQL 卷 | 自建时序库 | 厂商侧 |
| 适合 | 企业监控、内网合规 | 已有 Prometheus 生态 | 预算与厂商支持到位 |

```text
浏览器
   │  :8080
   ▼
zabbix-web-nginx-mysql
   ├── mysql-server:3306
   └── zabbix-server:10051
              │
              ▼
        MySQL（./mysql/data）
```

同系列还有 `zabbix-web-apache-mysql`、`zabbix-web-nginx-pgsql` 等，见 [镜像页](https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-nginx-mysql)。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2**（官方示例建议 ≥ **2.24.0**） |
| 架构 | **amd64 / arm64**（以 [tags](https://xuanyuan.cloud/r/zabbix/zabbix-web-nginx-mysql/tags) 为准） |
| 内存 | ≥ **4 GB** 可用；约 **2 GB** 可跟做，首次灌库会很慢 |
| 磁盘 | 三份镜像 + `./mysql/data` 增长 |
| 端口 | **8080**、**10051**（冲突则改映射左侧） |

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
ss -tlnp | grep -E ':8080|:10051'
```

被占用时改为如 `"18080:8080"`、`"11051:10051"`。

---

## 三、标签怎么选

跟做使用 **`alpine-7.4.14`**（体积更小）。完整列表：[tags](https://xuanyuan.cloud/r/zabbix/zabbix-web-nginx-mysql/tags)。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`alpine-7.4.14`** | 具体小版本 + Alpine | **本文跟做**（Server 同标签） |
| `ubuntu-7.4.14` / `ol-7.4.14` | 同版本、不同基础系统 | 需要 glibc / 企业基础镜像时 |
| `alpine-7.4-latest` | 7.4 线浮动小版本 | **勿写入跟做命令** |
| `latest` / `alpine-latest` | 跟踪当前稳定大版本 | **勿写入跟做命令** |
| `alpine-7.0.*` / `alpine-6.0.*` | 旧线 / LTS | 仅兼容既有环境 |
| `alpine-trunk` | 开发构建 | **勿当教程 / 生产默认** |

Web 与 Server（及 Proxy，若用）必须**同一小版本**。升级时改 pull、Compose、`docker run` 三处标签，并核对 [Release Notes](https://www.zabbix.com/rn/rn7.4.14)。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/zabbix/zabbix-web-nginx-mysql:alpine-7.4.14
docker pull docker.xuanyuan.run/zabbix/zabbix-server-mysql:alpine-7.4.14
docker pull docker.xuanyuan.run/library/mysql:8.0
```

Ubuntu 24.04 实测：

```text
alpine-7.4.14: Pulling from zabbix/zabbix-web-nginx-mysql
Digest: sha256:ebadc364583e5703188f8ea9fb9c6a12ea4d51c056b86c1866dd820346a737fd
Status: Downloaded newer image for docker.xuanyuan.run/zabbix/zabbix-web-nginx-mysql:alpine-7.4.14

alpine-7.4.14: Pulling from zabbix/zabbix-server-mysql
Digest: sha256:60009f2b526c73bfef56df0dccefb2112e9cd845ed1f9914016fba743fbbab8e
Status: Downloaded newer image for docker.xuanyuan.run/zabbix/zabbix-server-mysql:alpine-7.4.14

8.0: Pulling from library/mysql
Digest: sha256:7dcddc01f13bab2f15cde676d44d01f61fc9f99fe7785e86196dfc07d358ae2b
Status: Downloaded newer image for docker.xuanyuan.run/library/mysql:8.0
```

```bash
docker images | grep -E 'zabbix-web-nginx-mysql|zabbix-server-mysql|mysql'
```

```text
docker.xuanyuan.run/library/mysql:8.0                             7dcddc01f13b        1.1GB          249MB
docker.xuanyuan.run/zabbix/zabbix-server-mysql:alpine-7.4.14      60009f2b526c        147MB         37.1MB
docker.xuanyuan.run/zabbix/zabbix-web-nginx-mysql:alpine-7.4.14   ebadc364583e        247MB         60.7MB
```

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `zabbix/zabbix-web-nginx-mysql:alpine-7.4.14` | `docker pull docker.xuanyuan.run/zabbix/zabbix-web-nginx-mysql:alpine-7.4.14` |
| `zabbix/zabbix-server-mysql:alpine-7.4.14` | `docker pull docker.xuanyuan.run/zabbix/zabbix-server-mysql:alpine-7.4.14` |
| `library/mysql:8.0` | `docker pull docker.xuanyuan.run/library/mysql:8.0` |

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq)。

---

## 五、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/zabbix` |
| **macOS** | **`~/docker/zabbix`** |
| **Windows（Docker Desktop）** | 如 `C:\docker\zabbix` |

按官方 [容器安装](https://www.zabbix.com/documentation/7.4/en/manual/installation/containers)：MySQL 使用 `utf8mb4` / `utf8mb4_bin`，并开启 `log-bin-trust-function-creators`，便于 Server 初始化 schema。下文是**精简三容器**（无 Agent）；完整栈见 [zabbix-docker](https://github.com/zabbix/zabbix-docker) 的 `compose.yaml`。

### 5.1 准备目录

```bash
mkdir -p /www/wwwroot/zabbix/mysql/data \
  /www/wwwroot/zabbix/zabbix/{alertscripts,externalscripts,export}
cd /www/wwwroot/zabbix

# macOS：mkdir -p ~/docker/zabbix/mysql/data ~/docker/zabbix/zabbix/{alertscripts,externalscripts,export} && cd ~/docker/zabbix
```

非 root 给 `mkdir` 加 `sudo`。

### 5.2 编写 docker-compose.yml

将密码改成强密码，并保证 **MySQL / Server / Web 的 `MYSQL_PASSWORD` 与 healthcheck 的 `-p` 一致**：

```bash
cat > docker-compose.yml <<'EOF'
services:
  mysql-server:
    image: docker.xuanyuan.run/library/mysql:8.0
    container_name: zabbix-mysql
    restart: unless-stopped
    command:
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_bin
      - --log-bin-trust-function-creators=1
    environment:
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: ChangeMe_Zabbix_Pwd
      MYSQL_ROOT_PASSWORD: ChangeMe_Root_Pwd
    volumes:
      - ./mysql/data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "127.0.0.1", "-uroot", "-pChangeMe_Root_Pwd"]
      interval: 10s
      timeout: 5s
      retries: 18
      start_period: 120s

  zabbix-server:
    image: docker.xuanyuan.run/zabbix/zabbix-server-mysql:alpine-7.4.14
    container_name: zabbix-server
    restart: unless-stopped
    init: true
    depends_on:
      mysql-server:
        condition: service_healthy
    ports:
      - "10051:10051"
    environment:
      DB_SERVER_HOST: mysql-server
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: ChangeMe_Zabbix_Pwd
      TZ: Asia/Shanghai
    volumes:
      - ./zabbix/alertscripts:/usr/lib/zabbix/alertscripts:ro
      - ./zabbix/externalscripts:/usr/lib/zabbix/externalscripts:ro
      - ./zabbix/export:/var/lib/zabbix/export:rw

  zabbix-web:
    image: docker.xuanyuan.run/zabbix/zabbix-web-nginx-mysql:alpine-7.4.14
    container_name: zabbix-web
    restart: unless-stopped
    depends_on:
      mysql-server:
        condition: service_healthy
      zabbix-server:
        condition: service_started
    ports:
      - "8080:8080"
    environment:
      ZBX_SERVER_HOST: zabbix-server
      ZBX_SERVER_PORT: 10051
      DB_SERVER_HOST: mysql-server
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: ChangeMe_Zabbix_Pwd
      PHP_TZ: Asia/Shanghai
      ZBX_SERVER_NAME: Zabbix Lab
EOF
```

| 项 | 说明 |
|----|------|
| `8080:8080` | Web（容器内 Nginx 听 **8080**，不是 80） |
| `10051:10051` | Server trapper |
| `./mysql/data` | MySQL 数据 |
| `start_period: 120s` | 首次建库慢；过短易判 unhealthy（实测约 2～3 分钟） |
| healthcheck `-p…` | 与 `MYSQL_ROOT_PASSWORD` 相同，且 `-p` 与密码之间**无空格** |

### 5.3 启动并验证

```bash
docker compose up -d
docker compose ps
```

实测（MySQL 约 **150s** 后 Healthy）：

```text
✔ Network zabbix_default  Created
✔ Container zabbix-mysql  Healthy                                                                 149.7s
✔ Container zabbix-server Started                                                                 148.1s
✔ Container zabbix-web    Started                                                                 149.5s
```

`docker compose logs` 用**服务名**（`mysql-server` / `zabbix-server` / `zabbix-web`）。

```bash
docker compose logs -f mysql-server
```

首次关键行：`Initializing database files` → `MySQL init process done` → `ready for connections`（**port: 3306**）。

再跟 Server，直到库版本核对成功、主进程起来（灌库可能很久，见 FAQ）：

```bash
docker compose logs -f zabbix-server
```

本机成功节选：

```text
** Creating 'zabbix' schema in MySQL
…
current database version (mandatory/optional): 07040000/07040011
required mandatory version: 07040000
HA manager started in active mode
server #0 started [main process]
server #1 started [service manager #1]
…
```

**过早打开浏览器**会出现：

![Zabbix 过早访问：Database error，dbversion 表尚未创建](https://imgs.xuanyuan.cloud/docker/blog/zabbix-1.webp)

继续等 Server；出现 `current database version` 后再刷新或点 **Retry**。

Web 侧 HTTP 跟做可忽略缺证书提示：

```bash
docker compose logs -f zabbix-web
```

```text
** Preparing Zabbix web-interface (Nginx) with MySQL database
**** Impossible to enable SSL support for Nginx. Certificates are missing.
NOTICE: ready to handle connections
```

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/
```

```text
200
```

`curl` 得 **200** 只说明 Nginx/PHP 在听，**不等于** schema 已完成。浏览器：`http://192.168.1.35:8080`（换成你的 IP）。

---

## 六、浏览器首次登录与界面

### 6.1 登录

| 项 | 值 |
|----|-----|
| 地址 | `http://服务器IP:8080` |
| 用户名 | **`Admin`**（**A 大写**） |
| 密码 | **`zabbix`** |

右上角为 `ZBX_SERVER_NAME`（本文 **Zabbix Lab**）。勾选 Remember me 后点 **Sign in**。

![Zabbix 登录页：Username 填 Admin，右上角 Zabbix Lab](https://imgs.xuanyuan.cloud/docker/blog/zabbix-2.webp)

### 6.2 全球视图

进入 **Dashboards → Global view**。系统信息应显示 Server **running: Yes**（`zabbix-server:10051`），前后端版本 **7.4.14**。

未装 Agent 时，默认主机常为红色 **Not available**，CPU/内存小部件可能 **No data**——先改密与语言即可。

![Zabbix Global view：7.4.14 运行中，默认主机 Not available](https://imgs.xuanyuan.cloud/docker/blog/zabbix-3.webp)

### 6.3 改语言、时区与密码

**User settings → Profile**：

1. **Language** → **Chinese (zh_CN)**  
2. **Time zone** → **System default: (UTC+08:00) Asia/Shanghai**  
3. **Change password** 改掉默认口令  
4. **Update**

![Zabbix 用户 Profile：语言 Chinese zh_CN，时区 Asia/Shanghai](https://imgs.xuanyuan.cloud/docker/blog/zabbix-4.webp)

保存后界面变中文，顶部可能提示 **用户已更新**：

![Zabbix 中文全球视图：系统信息与主机可用性](https://imgs.xuanyuan.cloud/docker/blog/zabbix-5.webp)

### 6.4 默认「Agent 不可用」告警

**监测 → 问题** 常见一条一般严重：`Linux: Zabbix agent is not available`。

![Zabbix 问题列表：Zabbix agent is not available](https://imgs.xuanyuan.cloud/docker/blog/zabbix-6.webp)

**监测 → 主机** 上默认主机接口为 **`127.0.0.1:10050`**，**ZBX** 红色：精简 Compose **没有 Agent**，且容器内 `127.0.0.1` 也不是宿主机。消警见第七节；不需要自监控时可暂时禁用该主机或相关触发器。

![Zabbix 主机列表：Zabbix server 接口 127.0.0.1:10050，ZBX 红色](https://imgs.xuanyuan.cloud/docker/blog/zabbix-7.webp)

### 6.5 模板组

**数据采集 → 模板组** 可见内置模板分类（应用、云、数据库、网络设备、操作系统等），页脚 **Zabbix 7.4.14**。

![Zabbix 模板组：Applications、Cloud、Databases 等内置分类](https://imgs.xuanyuan.cloud/docker/blog/zabbix-8.webp)

不要把 **8080** 裸暴露公网；生产前置反向代理 + HTTPS，并限制来源。

---

## 七、安全、设置与扩展

| 项 | 建议 |
|----|------|
| 默认账号 | Profile 改掉 `Admin` / `zabbix` |
| 库密码 | 勿用文中占位串；四处一致 |
| 暴露面 | Web 仅内网 / VPN；**10051** 按需对 Agent 网段开放 |
| HTTPS | 映射 **8443**，挂载 `/etc/ssl/nginx`（`ssl.crt` / `ssl.key` / `dhparam.pem`） |
| 完整栈 | [zabbix-docker](https://github.com/zabbix/zabbix-docker) `7.4` 分支，`make up` 或 `compose.yaml`（可加 Agent 等 profile；镜像前缀可改轩辕） |

**可选：加 Agent 消掉默认主机红灯**（与 Server 同一 Compose 网络，示意）：

```bash
docker run -d --name zabbix-agent \
  --network zabbix_default \
  --restart unless-stopped \
  -e ZBX_SERVER_HOST=zabbix-server \
  -e ZBX_HOSTNAME=Zabbix\ server \
  docker.xuanyuan.run/zabbix/zabbix-agent:alpine-7.4.14
```

然后在 Web 把默认主机接口从 `127.0.0.1:10050` 改成 Agent 容器可达地址（例如服务名 / 容器 IP），保存后等可用性变绿。细节以 [Agent 镜像说明](https://xuanyuan.cloud/zh/r/zabbix/zabbix-agent) 为准。

---

## 八、备选：docker run（临时 / 无 Compose）

生产仍用第五节。密码请自行更换；`DB_SERVER_HOST` 使用**容器名**（与 `--name` 一致）。

```bash
docker network create zabbix-net

docker run -d --name zabbix-mysql \
  --network zabbix-net \
  --restart unless-stopped \
  -e MYSQL_DATABASE=zabbix \
  -e MYSQL_USER=zabbix \
  -e MYSQL_PASSWORD=ChangeMe_Zabbix_Pwd \
  -e MYSQL_ROOT_PASSWORD=ChangeMe_Root_Pwd \
  -v /www/wwwroot/zabbix/mysql/data:/var/lib/mysql \
  docker.xuanyuan.run/library/mysql:8.0 \
  --character-set-server=utf8mb4 \
  --collation-server=utf8mb4_bin \
  --log-bin-trust-function-creators=1
```

等 MySQL `ready for connections` 后再起 Server：

```bash
docker run -d --name zabbix-server \
  --network zabbix-net \
  --restart unless-stopped \
  --init \
  -p 10051:10051 \
  -e DB_SERVER_HOST=zabbix-mysql \
  -e MYSQL_DATABASE=zabbix \
  -e MYSQL_USER=zabbix \
  -e MYSQL_PASSWORD=ChangeMe_Zabbix_Pwd \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/zabbix/zabbix-server-mysql:alpine-7.4.14
```

等 Server 出现 `current database version` / `server #0 started` 后再起 Web：

```bash
docker run -d --name zabbix-web \
  --network zabbix-net \
  --restart unless-stopped \
  -p 8080:8080 \
  -e ZBX_SERVER_HOST=zabbix-server \
  -e DB_SERVER_HOST=zabbix-mysql \
  -e MYSQL_DATABASE=zabbix \
  -e MYSQL_USER=zabbix \
  -e MYSQL_PASSWORD=ChangeMe_Zabbix_Pwd \
  -e PHP_TZ=Asia/Shanghai \
  -e ZBX_SERVER_NAME="Zabbix Lab" \
  docker.xuanyuan.run/zabbix/zabbix-web-nginx-mysql:alpine-7.4.14
```

```bash
docker logs -f zabbix-server
docker logs -f zabbix-web
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/
```

---

## 九、迁移 / 升级

| 场景 | 做法 |
|------|------|
| 同机搬家 | `docker compose down` 后打包 `/www/wwwroot/zabbix`（至少 `mysql/data`） |
| 小版本升级 | 先备份库；Web + Server **同步**改标签 → `pull` + `up -d` |
| 换基础 OS 标签 | 如 `alpine-7.4.14` → `ubuntu-7.4.14`，版本号仍一致 |
| 官方全量布局 | 可迁到 [zabbix-docker](https://github.com/zabbix/zabbix-docker) 的 `zbx_env`，注意路径与密钥 |

跨大版本先读官方 Upgrade notes。

---

## 十、常见问题 FAQ

**Q：只拉 Web 镜像能用吗？**  
不能。必须有已初始化的库和运行中的 Server。本文 Compose 已含三件套。

**Q：`dependency failed` / MySQL unhealthy？**  
先看：`docker compose logs --tail=80 mysql-server`（或 `docker logs zabbix-mysql`）。常见：首次建库超过 healthcheck 等待、`-p` 与 root 密码不一致。空目录重来（会丢库，仅适合刚跟做失败）：

```bash
cd /www/wwwroot/zabbix
docker compose down
rm -rf ./mysql/data/*
docker compose up -d
```

确认 compose 中 `start_period: 120s` 且 healthcheck `-p` 正确。

**Q：`docker compose logs zabbix-mysql` 报 no such service？**  
那是 `container_name`。应：`docker compose logs -f mysql-server`，或 `docker logs -f zabbix-mysql`。

**Q：页面 `dbversion` was not found？**  
Server 还在建表。跟 `docker compose logs -f zabbix-server`，等到 `current database version` / `server #0 started` 后再 Retry。`curl` 200 ≠ 库已就绪。

**Q：`Creating 'zabbix' schema` 十几分钟没新日志？**  
多半在灌库，尤其是往 `images` 插 PNG。自查：

```bash
docker top zabbix-server
# 仍有 gzip / mariadb（mysql）管道 → 还在导入

docker exec zabbix-mysql mysql -uzabbix -pChangeMe_Zabbix_Pwd -N -e \
  "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='zabbix';"

docker exec zabbix-mysql mysql -uroot -pChangeMe_Root_Pwd -e "SHOW FULL PROCESSLIST;"
# 常见：INSERT INTO images … waiting for handler commit
```

表数上涨、MySQL CPU 高 → 继续等。表数长期为 0 且无 SQL、Server 反复重启 → 再考虑重启或清库。约 **1.75 GiB** 整机内存时，灌库超过 **20 分钟** 仍可能正常；有条件加到 **≥ 4 GB**。

**Q：Web 日志 Certificates are missing？**  
HTTP 跟做可忽略。HTTPS 见第七节。

**Q：CONNECTION_REFUSED / 打不开页？**  
`docker compose ps` 看是否 Up；再查 mysql-server / zabbix-server 日志。

**Q：提示连不上数据库？**  
核对 `MYSQL_PASSWORD`、`DB_SERVER_HOST=mysql-server`、字符集 `utf8mb4` / `utf8mb4_bin`。

**Q：Agent is not available、ZBX 红色？**  
精简栈无 Agent，默认接口 `127.0.0.1:10050` 不可达，属预期。消警见第七节；connector / IPMI / Java 等 not supported 同理（未启对应组件）。

**Q：Admin 登录失败？**  
用户名是 **`Admin`** 不是 `admin`。若已改密或旧数据卷残留，用实际密码或清卷重建。

**Q：为什么不用 `latest`？**  
浮动标签会静默升级，步骤易与文档脱节。跟做固定 **`alpine-7.4.14`**。

**Q：为什么不用宿主机 80？**  
常被面板 / 反代占用；默认 **8080**。空闲可改 `"80:8080"`。

**Q：和 HertzBeat / Prometheus？**  
Zabbix 偏企业触发器监控；HertzBeat 偏无代理快速落地；Prometheus 偏云原生指标。可并存。

**Q：能用 MariaDB 吗？**  
官方示例以 MySQL 为主；本文固定 **MySQL 8.0**。MariaDB 需自行验证。

---

## 十一、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/zabbix/zabbix-web-nginx-mysql:alpine-7.4.14
docker pull docker.xuanyuan.run/zabbix/zabbix-server-mysql:alpine-7.4.14
docker pull docker.xuanyuan.run/library/mysql:8.0

# Compose
cd /www/wwwroot/zabbix
docker compose up -d
docker compose ps
docker compose logs -f mysql-server
docker compose logs -f zabbix-server
docker compose down

# 验证（schema 完成后再登录）
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/
# http://服务器IP:8080  →  Admin / zabbix
```

---

## 十二、延伸阅读

| 资源 | 链接 |
|------|------|
| [zabbix/zabbix-web-nginx-mysql 镜像页](https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-nginx-mysql) | [https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-nginx-mysql](https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-nginx-mysql) |
| [zabbix/zabbix-web-nginx-mysql 概览](https://xuanyuan.cloud/r/zabbix/zabbix-web-nginx-mysql) | [https://xuanyuan.cloud/r/zabbix/zabbix-web-nginx-mysql](https://xuanyuan.cloud/r/zabbix/zabbix-web-nginx-mysql) |
| [标签列表](https://xuanyuan.cloud/r/zabbix/zabbix-web-nginx-mysql/tags) | [https://xuanyuan.cloud/r/zabbix/zabbix-web-nginx-mysql/tags](https://xuanyuan.cloud/r/zabbix/zabbix-web-nginx-mysql/tags) |
| [zabbix/zabbix-server-mysql 镜像页](https://xuanyuan.cloud/zh/r/zabbix/zabbix-server-mysql) | [https://xuanyuan.cloud/zh/r/zabbix/zabbix-server-mysql](https://xuanyuan.cloud/zh/r/zabbix/zabbix-server-mysql) |
| [zabbix/zabbix-agent 镜像页](https://xuanyuan.cloud/zh/r/zabbix/zabbix-agent) | [https://xuanyuan.cloud/zh/r/zabbix/zabbix-agent](https://xuanyuan.cloud/zh/r/zabbix/zabbix-agent) |
| [library/mysql 镜像页](https://xuanyuan.cloud/zh/r/library/mysql) | [https://xuanyuan.cloud/zh/r/library/mysql](https://xuanyuan.cloud/zh/r/library/mysql) |
| [GitHub · zabbix-docker](https://github.com/zabbix/zabbix-docker) | [https://github.com/zabbix/zabbix-docker](https://github.com/zabbix/zabbix-docker) |
| [官方文档 · Installation from containers](https://www.zabbix.com/documentation/7.4/en/manual/installation/containers) | [https://www.zabbix.com/documentation/7.4/en/manual/installation/containers](https://www.zabbix.com/documentation/7.4/en/manual/installation/containers) |
| [Zabbix 7.4.14 Release Notes](https://www.zabbix.com/rn/rn7.4.14) | [https://www.zabbix.com/rn/rn7.4.14](https://www.zabbix.com/rn/rn7.4.14) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- 镜像：**`alpine-7.4.14`**（Web + Server）+ **MySQL 8.0**，轩辕镜像加速拉取  
- 主路径：Compose；**8080** / **10051**；等 `current database version` 再登录  
- 账号：`Admin` / `zabbix` → 改密、可改中文；默认主机 Agent 红灯需另装 Agent  
- 扩展：HTTPS、官方全量 Compose、Agent 见第七节  

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/zabbix-docker-deploy


