# Docker 部署 ArchivesSpace：轻松搭建档案信息管理平台

![Docker 部署 ArchivesSpace：轻松搭建档案信息管理平台](https://imgs.xuanyuan.cloud/docker/blog/archivesspace.webp)

*分类: Docker部署教程 | 标签: ArchivesSpace,Docker,轩辕镜像,档案管理,特藏,私有化部署,部署教程 | 发布时间: 2026-09-08 05:32:56*

> ArchivesSpace 是面向档案馆、特藏与文化遗产机构的开源档案信息管理系统，用于著录档案、手稿与数字对象并提供 Web 检索。本文将介绍如何通过 Docker Compose 快速部署 archivesspace/archivesspace，轻松搭建可自托管的档案信息管理平台，适合档案馆、图书馆特藏部与研究机构等场景。

*本文基于 [archivesspace/archivesspace:4.2.1](https://xuanyuan.cloud/zh/r/archivesspace/archivesspace)，实测引擎 **ArchivesSpace 4.2.1**，配套 [archivesspace/solr:4.2.1](https://xuanyuan.cloud/zh/r/archivesspace/solr) 与 [library/mysql:8.0](https://xuanyuan.cloud/zh/r/library/mysql)，测试平台 **Ubuntu 24.04** Linux。*

特藏室里一箱箱手稿、捐赠清单、案卷目录：有人在 Excel 里改字段，有人在共享盘翻 PDF，有人下班前还在对「这份文件到底挂在哪个系列下」。检索靠文件名，权限靠口头约定，交接时版本对不上——馆长要一份在线检索页，业务侧却还在等「系统什么时候能上」。

著录、权限与数字对象往往要留在本机或内网盘上。公有云档案 SaaS 要过合规与出域评审；纯网盘又缺元数据标准与角色审计。很多机构已经有一台跑 Docker 的 Ubuntu，缺的是：**镜像能拉下来、MySQL / Solr / 应用能一起起来、浏览器能进 Staff**——而不是先上整套数字人文中台。

**ArchivesSpace**（[官网](https://archivesspace.org)、[GitHub](https://github.com/archivesspace/archivesspace)）是由档案管理员参与设计的开源档案信息管理应用：支持档案与特藏的著录、整理、数字对象关联，并提供 **Staff（馆员）** 与 **Public（公众）** 两套 Web 界面。自 **v4.0.0** 起官方推荐 Docker。本文用 **`archivesspace/archivesspace`**（[镜像页](https://xuanyuan.cloud/zh/r/archivesspace/archivesspace)），须配套 **MySQL** 与同版本 **`archivesspace/solr`**；许可证为 **Educational Community License 2.0**。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 馆员著录 | Staff `http://服务器IP:8080`，默认 **`admin` / `admin`**（立刻改密） |
| 公众检索 | Public `http://服务器IP:8081` |
| 建库与权限 | System → Manage Repositories；再管用户与角色 |
| 备份搬家 | 停栈后备份 MySQL 数据目录、Solr 卷与 `app-data` 卷 |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`archivesspace/archivesspace:4.2.1`**（及同版本 Solr、MySQL 8.0），**Docker Compose** 做主路径。实测局域网 IP **`192.168.1.35`**，请换成你的，并同步改 `APPCONFIG_*_PROXY_URL`。无 Compose 见第八节。文内 **7** 张截图。

> **上手要点**
> - **部署**：第五节 Compose；`docker run` 见第八节
> - **端口**：宿主机 **8080** → Staff；**8081** → Public
> - **标签**：应用与 Solr 跟做 **`4.2.1`**；勿写 `latest` / `ANW-*`
> - **依赖**：MySQL 8 + `archivesspace/solr:4.2.1`（不是 PostgreSQL）
> - **配置**：挂载 `./config` 时必须有 **`config/config.rb`**（可几乎为空），否则迁完后会 `GEM_HOME` 重启
> - **内存**：建议 **≥ 4 GB 可用，推荐 8 GB**；2 GB 仅能勉强验证，体验很差
> - **冷启动**：空库首次会跑约 **175** 步迁移；等日志 **`Started ServerConnector …:8080`** 再开浏览器
> - **账号**：`admin` / `admin`（务必改密）
> - **工作目录**：Linux `/www/wwwroot/archivesspace`；macOS `~/docker/archivesspace`

官方：[Running with Docker](https://docs.archivesspace.org/administration/docker/) · [Getting started](https://docs.archivesspace.org/administration/getting_started/) · [镜像页](https://xuanyuan.cloud/zh/r/archivesspace/archivesspace) · [标签列表](https://xuanyuan.cloud/r/archivesspace/archivesspace/tags)

---

## 一、ArchivesSpace 镜像是什么？

`archivesspace/archivesspace` 是官方主应用镜像，内含 Staff / Public / Backend。业务数据在 **MySQL**，全文检索靠同版本 **`archivesspace/solr`**。官方推荐用 Compose（或发布页的 Docker Configuration Package）一次拉起整栈。

| | ArchivesSpace（本文） | 网盘 / 共享文件夹 | 商业档案 SaaS |
|--|----------------------|-------------------|---------------|
| 定位 | 自托管档案信息管理 | 文件存储 | 厂商托管 |
| 适合 | 著录、检索、权限、数字对象 | 粗放共享 | 少运维、按席计费 |
| 数据 | 本机卷 / 内网库 | 本机或云盘 | 出域云端 |
| 代价 | 自己盯备份与升级 | 缺元数据与审计 | 合规与订阅成本 |

```text
浏览器 Staff   ──:8080──▶  archivesspace
浏览器 Public  ──:8081──▶  同上
应用           ──3306──▶  MySQL（./mysql/data）
应用           ──8983──▶  archivesspace/solr
应用 data      ──卷──▶  /archivesspace/data
```

同组织还有 [`archivesspace/solr`](https://xuanyuan.cloud/zh/r/archivesspace/solr)、[`archivesspace/proxy`](https://xuanyuan.cloud/zh/r/archivesspace/proxy)；社区另有历史镜像 `lyrasis/archivesspace`。**本文固定 `archivesspace/archivesspace:4.2.1` + 同标签 Solr + `library/mysql:8.0`。**

> 部分镜像页中文简介写成 PostgreSQL / 单容器即可——**与官方不符**。以 [官方 Docker 文档](https://docs.archivesspace.org/administration/docker/) 为准。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64**（官方写明 `linux/x86_64`） |
| 内存 | **≥ 4 GB 可用，推荐 8 GB**。实测 2 GB 可跑通但迁移与页面极慢，**不推荐跟做** |
| 磁盘 | 三份镜像 DISK 约 **5.2 GB** + 数据增长；建议预留 **20 GB+** |
| 端口 | **8080**、**8081**（冲突则改映射左侧，并改 PROXY_URL） |

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
ss -tlnp | grep -E ':8080|:8081'
```

---

## 三、标签怎么选

跟做 **`4.2.1`**（与 [v4.2.1](https://github.com/archivesspace/archivesspace/releases/tag/v4.2.1) 及 `archivesspace-docker-v4.2.1.zip` 对齐）。列表：[tags](https://xuanyuan.cloud/r/archivesspace/archivesspace/tags)。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`4.2.1`** | 具体发行版 | **本文跟做**（Solr 同标签） |
| `4.2.0` / `4.1.1` 等 | 历史发行版 | 仅兼容既有环境 |
| `latest` | 浮动构建 | **勿写入跟做命令** |
| `ANW-*` | 工单 / 开发构建 | **勿当教程默认** |

应用与 Solr **必须同一发行版标签**。升级时改 pull / Compose / run 三处标签，并核对 [Release Notes](https://docs.archivesspace.org/)；含 Solr schema 变更时按官方文档重建 Solr 卷并重索引。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/archivesspace/archivesspace:4.2.1
docker pull docker.xuanyuan.run/archivesspace/solr:4.2.1
docker pull docker.xuanyuan.run/library/mysql:8.0
```

Ubuntu 24.04（`ikuai-ubuntu2404`）实测：

```text
4.2.1: Pulling from archivesspace/archivesspace
Digest: sha256:f46223c4e3fe5f32384779b0796f777b83db3ce878f76c727adf5aa96d88f4de
Status: Downloaded newer image for docker.xuanyuan.run/archivesspace/archivesspace:4.2.1

4.2.1: Pulling from archivesspace/solr
Digest: sha256:22d3e2002e1875385da83d3edfbd5931591fd410bd3e5be16823c8af6accbec4
Status: Downloaded newer image for docker.xuanyuan.run/archivesspace/solr:4.2.1

8.0: Pulling from library/mysql
Digest: sha256:7dcddc01f13bab2f15cde676d44d01f61fc9f99fe7785e86196dfc07d358ae2b
Status: Downloaded newer image for docker.xuanyuan.run/library/mysql:8.0
```

```bash
docker images | grep -E 'archivesspace|mysql'
```

```text
docker.xuanyuan.run/archivesspace/archivesspace:4.2.1   f46223c4e3fe       2.85GB         1.06GB
docker.xuanyuan.run/archivesspace/solr:4.2.1            22d3e2002e18       1.21GB          484MB
docker.xuanyuan.run/library/mysql:8.0                   7dcddc01f13b        1.1GB          249MB
```

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq)。

---

## 五、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/archivesspace` |
| **macOS** | **`~/docker/archivesspace`** |
| **Windows（Docker Desktop）** | 如 `C:\docker\archivesspace` |

下文是精简三容器（应用 + MySQL + Solr，直连 **8080 / 8081**）。官方 zip 包还带 Nginx 与定时备份，见第七节。

### 5.1 准备目录

```bash
mkdir -p /www/wwwroot/archivesspace/mysql/data \
  /www/wwwroot/archivesspace/{config,sql}
cd /www/wwwroot/archivesspace

# 挂载 ./config 时必须有此文件（可几乎为空）
printf '%s\n' '# ArchivesSpace overrides; APPCONFIG_* in .env still apply.' > config/config.rb

# macOS：
# mkdir -p ~/docker/archivesspace/mysql/data ~/docker/archivesspace/{config,sql}
# cd ~/docker/archivesspace && printf '%s\n' '# ArchivesSpace overrides' > config/config.rb
```

非 root 给 `mkdir` 加 `sudo`。不要挂载空的 `plugins` / `locales` / `stylesheets`（会盖掉镜像默认内容）。

### 5.2 编写 .env 与 docker-compose.yml

把 **`192.168.1.35`** 换成你的 IP（本机自测可用 `127.0.0.1`）。库密码改成强密码，并保证 JDBC URL 里的 user/password 与 `MYSQL_USER` / `MYSQL_PASSWORD`、healthcheck 的 `-p` **四处一致**。

```bash
cat > .env <<'EOF'
APPCONFIG_FRONTEND_PROXY_URL=http://192.168.1.35:8080
APPCONFIG_PUBLIC_PROXY_URL=http://192.168.1.35:8081
APPCONFIG_OAI_PROXY_URL=http://192.168.1.35:8082

APPCONFIG_DB_URL=jdbc:mysql://db:3306/archivesspace?useUnicode=true&characterEncoding=UTF-8&user=as&password=ChangeMe_As_Pwd&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
ASPACE_DB_MIGRATE=true

APPCONFIG_SOLR_URL=http://solr:8983/solr/archivesspace
SOLR_JAVA_MEM=-Xms1g -Xmx1g

ASPACE_JAVA_XMX=-Xmx2048m
JAVA_OPTS=-Djava.awt.headless=true -Dfile.encoding=UTF-8 -server -Xss1024k -Djavax.accessibility.assistive_technologies=

MYSQL_ROOT_PASSWORD=ChangeMe_Root_Pwd
MYSQL_DATABASE=archivesspace
MYSQL_USER=as
MYSQL_PASSWORD=ChangeMe_As_Pwd
EOF
```

> 上文堆内存适合 **≥4 GB** 可用内存的机器。总内存更紧时须下调 `ASPACE_JAVA_XMX` / `SOLR_JAVA_MEM` / MySQL `innodb_buffer_pool_size`，否则容易互相挤爆。

```bash
cat > docker-compose.yml <<'EOF'
services:
  db:
    image: docker.xuanyuan.run/library/mysql:8.0
    platform: linux/amd64
    container_name: archivesspace-mysql
    restart: unless-stopped
    cap_add:
      - SYS_NICE
    command:
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_unicode_ci
      - --innodb_buffer_pool_size=512M
      - --innodb_buffer_pool_instances=1
      - --log_bin_trust_function_creators=1
    env_file:
      - .env
    volumes:
      - ./mysql/data:/var/lib/mysql
      - ./sql:/docker-entrypoint-initdb.d
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "127.0.0.1", "-uroot", "-pChangeMe_Root_Pwd"]
      interval: 10s
      timeout: 5s
      retries: 36
      start_period: 180s

  solr:
    image: docker.xuanyuan.run/archivesspace/solr:4.2.1
    platform: linux/amd64
    container_name: archivesspace-solr
    restart: unless-stopped
    env_file:
      - .env
    command:
      - solr-precreate
      - archivesspace
      - /opt/solr/server/solr/configsets/archivesspace
    volumes:
      - solr-data:/var/solr

  app:
    image: docker.xuanyuan.run/archivesspace/archivesspace:4.2.1
    platform: linux/amd64
    container_name: archivesspace
    restart: unless-stopped
    depends_on:
      db:
        condition: service_healthy
      solr:
        condition: service_started
    env_file:
      - .env
    ports:
      - "8080:8080"
      - "8081:8081"
    volumes:
      - app-data:/archivesspace/data
      - ./config:/archivesspace/config

volumes:
  app-data:
  solr-data:
EOF
```

| 项 | 说明 |
|----|------|
| `8080` / `8081` | Staff / Public |
| `platform: linux/amd64` | 与官方一致 |
| `config/config.rb` | 必须存在；缺了会 `KeyError: GEM_HOME` |
| `app-data` / `solr-data` | 命名卷（避免直接 bind 应用 data） |
| healthcheck | `-p` 与密码之间**无空格**；首次建库较慢，已放宽 `start_period` / `retries` |

### 5.3 启动并验证

```bash
docker compose up -d
docker compose ps
docker compose logs -f app
```

实测（2 GB 内存机，仅作参考；**4 GB+ 会明显更快**）：

```text
✔ Container archivesspace-mysql  Healthy                                                                 285.5s
✔ Container archivesspace-solr   Started                                                                   8.4s
✔ Container archivesspace        Started                                                                 292.9s
```

`Started` **不等于可登录**。空库首次会跑迁移（约 **v1→v175**）；本机约 **34 分钟**，其中 **v1 一步约 11 分钟**。迁移期间常见：

| 现象 | 含义 |
|------|------|
| `Begin applying migration version N` | 正常推进 |
| `ps` 显示 `(unhealthy)` | 健康检查探 **8089**，UI 未起前可忽略 |
| `curl :8080` 无输出 | 尚未监听，继续等 |
| `All done.` | 迁移结束，接着起 Jetty |
| **`Started ServerConnector …{0.0.0.0:8080}`** | Staff 已可访问 |

迁移日志节选：

```text
Detected MySQL connector 8+
Running migrations against jdbc:mysql://db:3306/archivesspace?…
I, […] INFO -- : Begin applying migration version 1, direction: up
I, […] INFO -- : Finished applying migration version 1, … took 677.69 seconds
…
I, […] INFO -- : Finished applying migration version 175, …
All done.
```

本机在补齐 `config.rb` 后 recreate，库已迁完则秒级 `All done.`，约 **5 分钟** 后出现：

```text
Loading ArchivesSpace configuration file from path: /archivesspace/config/config.rb
…
INFO: Started ServerConnector@…{HTTP/1.1, (http/1.1)}{0.0.0.0:8080}
I, […] INFO -- : Processing by WelcomeController#index as HTML
I, […] INFO -- : Completed 200 OK in …ms
```

```bash
curl -sI http://127.0.0.1:8080 | head -n 5
curl -sI http://127.0.0.1:8081 | head -n 5
```

实测：

```text
HTTP/1.1 200 OK
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Download-Options: noopen
```

官方日志里的「Welcome to ArchivesSpace」横幅不一定出现；以 **8080 监听 + HTTP 200** 为准。`GEM_HOME` 重启循环见 FAQ。

---

## 六、浏览器首次初始化

### 6.1 登录 Staff

打开：

```text
http://192.168.1.35:8080
```

| 项 | 值 |
|----|-----|
| 用户名 | `admin` |
| 密码 | `admin` |

页脚可见 **v4.2.1**。点 **Sign In** 后会出现绿色 **Login Successful. Redirecting...**。登录后请立刻改密。

![ArchivesSpace Staff 登录页：Please Sign In，已填 admin，页脚 v4.2.1](https://imgs.xuanyuan.cloud/docker/blog/archivesspace-1.webp)

![ArchivesSpace 登录成功：绿色 Login Successful Redirecting 提示](https://imgs.xuanyuan.cloud/docker/blog/archivesspace-2.webp)

### 6.2 登录后欢迎页

进入 Staff 后会看到 **Welcome to ArchivesSpace**，并提示到 **System → Manage Repositories** 创建第一个 Repository。

![ArchivesSpace Staff 欢迎页：提示 System → Manage Repositories](https://imgs.xuanyuan.cloud/docker/blog/archivesspace-3.webp)

### 6.3 创建 Repository

打开 **System → Manage Repositories**。全新实例为 **No records found**，点 **Create Repository**。

![ArchivesSpace Repositories 列表：No records found，Create Repository 按钮](https://imgs.xuanyuan.cloud/docker/blog/archivesspace-4.webp)

填写 **Repository Short Name**、**Repository Name**（示例均为 `test-repository`），需要对外公开时勾选 **Publish?**，再 **Save Repository**。未建库前多数著录菜单不可用。

![ArchivesSpace 新建 Repository 表单：Short Name 与 Name 填 test-repository](https://imgs.xuanyuan.cloud/docker/blog/archivesspace-5.webp)

保存成功后出现 **Repository Created**，并提示 **Repository is Currently Selected**；顶栏显示当前库（未发布时带 **Unpublished**）。此后可用 **Browse / Create** 著录。

![ArchivesSpace Repository 详情：Repository Created，当前选中 test-repository](https://imgs.xuanyuan.cloud/docker/blog/archivesspace-6.webp)

### 6.4 公众界面（Public）

```text
http://192.168.1.35:8081
```

Public 提供检索入口；馆员工作仍在 **8080**。页脚有 **Staff Interface** 回链。

![ArchivesSpace Public 界面：Welcome 与 Search The Archives 表单](https://imgs.xuanyuan.cloud/docker/blog/archivesspace-7.webp)

已发布资源可在 Public 检索；索引可能有短暂延迟。

---

## 七、安全、设置与生产加固

| 项 | 建议 |
|----|------|
| 密码 | 立刻改 `admin`；MySQL 用强密码 |
| HTTPS | 前面加 Nginx / Caddy，或改用官方 Docker 包自带 proxy |
| 端口 | 勿把 **3306 / 8983** 暴露到公网 |
| 配置 | 写入 `./config/config.rb`；常见项也可用 `APPCONFIG_*` |
| 官方完整包 | [v4.2.1 Assets](https://github.com/archivesspace/archivesspace/releases/tag/v4.2.1) 下载 `archivesspace-docker-v4.2.1.zip`；镜像前缀改为 `docker.xuanyuan.run/…` |
| 备份 | `mysqldump` 或官方包 `db-backup`；一并备份 `app-data` / `solr-data` |

升级（无 Solr schema 变更时）：

```bash
docker compose pull
docker compose up -d --force-recreate
```

含 Solr schema 变更时，按官方 Upgrading 重建 Solr 卷并重索引——**先备份**。

---

## 八、备选：docker run（临时 / 无 Compose）

整栈三容器，**优先 Compose**。无 Compose 时先准备 `config/config.rb`，再按网络拉起（密码与 PROXY_URL 请改成你的）：

```bash
mkdir -p /www/wwwroot/archivesspace/{mysql/data,config}
printf '%s\n' '# ArchivesSpace overrides' > /www/wwwroot/archivesspace/config/config.rb

docker network create archivesspace-net

docker run -d --name archivesspace-mysql --network archivesspace-net \
  --restart unless-stopped \
  -e MYSQL_ROOT_PASSWORD=ChangeMe_Root_Pwd \
  -e MYSQL_DATABASE=archivesspace \
  -e MYSQL_USER=as \
  -e MYSQL_PASSWORD=ChangeMe_As_Pwd \
  -v /www/wwwroot/archivesspace/mysql/data:/var/lib/mysql \
  --platform linux/amd64 \
  docker.xuanyuan.run/library/mysql:8.0 \
  --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci \
  --log_bin_trust_function_creators=1

# 等 MySQL ready 后再起 Solr / 应用
docker run -d --name archivesspace-solr --network archivesspace-net \
  --restart unless-stopped \
  -e SOLR_JAVA_MEM="-Xms1g -Xmx1g" \
  --platform linux/amd64 \
  docker.xuanyuan.run/archivesspace/solr:4.2.1 \
  solr-precreate archivesspace /opt/solr/server/solr/configsets/archivesspace

docker run -d --name archivesspace --network archivesspace-net \
  --restart unless-stopped \
  -p 8080:8080 -p 8081:8081 \
  -e ASPACE_DB_MIGRATE=true \
  -e APPCONFIG_DB_URL='jdbc:mysql://archivesspace-mysql:3306/archivesspace?useUnicode=true&characterEncoding=UTF-8&user=as&password=ChangeMe_As_Pwd&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC' \
  -e APPCONFIG_SOLR_URL='http://archivesspace-solr:8983/solr/archivesspace' \
  -e APPCONFIG_FRONTEND_PROXY_URL='http://192.168.1.35:8080' \
  -e APPCONFIG_PUBLIC_PROXY_URL='http://192.168.1.35:8081' \
  -e ASPACE_JAVA_XMX='-Xmx2048m' \
  -v /www/wwwroot/archivesspace/config:/archivesspace/config \
  --platform linux/amd64 \
  docker.xuanyuan.run/archivesspace/archivesspace:4.2.1
```

```bash
docker logs -f archivesspace
```

清理（保留本机 `./mysql/data`；命名卷需另行处理）：

```bash
docker rm -f archivesspace archivesspace-solr archivesspace-mysql
docker network rm archivesspace-net
```

---

## 九、常见问题 FAQ

**Q: 镜像页写 PostgreSQL，可以吗？**  
A: 不可以。官方 Docker 路径是 **MySQL + Solr**，以本文 Compose 与 [官方文档](https://docs.archivesspace.org/administration/docker/) 为准。

**Q: 只拉一个 `archivesspace/archivesspace` 容器能用吗？**  
A: 本文生产路径必须配 MySQL + Solr。

**Q: 浏览器打不开 / `curl` 无输出 / `ps` 显示 unhealthy？**  
A: 空库首次迁移很长。本机 **v1 约 11 分钟**，整段约 **34 分钟**（2 GB 机）。此间 `(unhealthy)` 与 `curl` 失败属正常。盯：

```bash
docker compose logs -f app | grep -E 'migration version|ServerConnector|All done|Error|GEM_HOME'
```

见到 **`Started ServerConnector …:8080`** 再访问。并确认 `APPCONFIG_*_PROXY_URL` 与浏览器地址一致。

**Q: 页面很卡 / 迁移很慢？**  
A: 加内存。**建议 ≥4 GB 可用，推荐 8 GB**。2 GB 虽能验证通，但体验差，不适合日常跟做。

**Q: `All done.` 后报 `KeyError: GEM_HOME` 并不断 restarting？**  
A: `./config` 挂载了空目录且没有 `config.rb`。修复：

```bash
cd /www/wwwroot/archivesspace
printf '%s\n' '# ArchivesSpace overrides' > config/config.rb
# 去掉对空 plugins/locales/stylesheets 的挂载（若有）
docker compose up -d --force-recreate app
```

库已迁完，不必删卷重来。

**Q: ARM 报 no matching manifest？**  
A: 当前发行镜像以 **amd64** 为主。可保留 `platform: linux/amd64` 走模拟，或换 x86_64 主机。

**Q: Solr checksum / schema 报错？**  
A: 多为应用与 Solr **版本不一致**，或升级后未按官方重建 Solr 卷。保持 **`4.2.1` 成对**。

**Q: 为什么不用 `latest`？**  
A: 浮动标签会与文档步骤脱节。跟做固定 **`4.2.1`**。

---

## 十、命令速查

```bash
docker pull docker.xuanyuan.run/archivesspace/archivesspace:4.2.1
docker pull docker.xuanyuan.run/archivesspace/solr:4.2.1
docker pull docker.xuanyuan.run/library/mysql:8.0

cd /www/wwwroot/archivesspace
docker compose up -d
docker compose ps
docker compose logs -f app
docker compose down
```

---

## 十一、延伸阅读

| 资源 | 链接 |
|------|------|
| [archivesspace/archivesspace 镜像页](https://xuanyuan.cloud/zh/r/archivesspace/archivesspace) | [https://xuanyuan.cloud/zh/r/archivesspace/archivesspace](https://xuanyuan.cloud/zh/r/archivesspace/archivesspace) |
| [标签列表](https://xuanyuan.cloud/r/archivesspace/archivesspace/tags) | [https://xuanyuan.cloud/r/archivesspace/archivesspace/tags](https://xuanyuan.cloud/r/archivesspace/archivesspace/tags) |
| [archivesspace/solr 镜像页](https://xuanyuan.cloud/zh/r/archivesspace/solr) | [https://xuanyuan.cloud/zh/r/archivesspace/solr](https://xuanyuan.cloud/zh/r/archivesspace/solr) |
| [Running with Docker（官方）](https://docs.archivesspace.org/administration/docker/) | [https://docs.archivesspace.org/administration/docker/](https://docs.archivesspace.org/administration/docker/) |
| [Getting started（官方）](https://docs.archivesspace.org/administration/getting_started/) | [https://docs.archivesspace.org/administration/getting_started/](https://docs.archivesspace.org/administration/getting_started/) |
| [GitHub 发布页 v4.2.1](https://github.com/archivesspace/archivesspace/releases/tag/v4.2.1) | [https://github.com/archivesspace/archivesspace/releases/tag/v4.2.1](https://github.com/archivesspace/archivesspace/releases/tag/v4.2.1) |
| [ArchivesSpace 官网](https://archivesspace.org) | [https://archivesspace.org](https://archivesspace.org) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- 跟做 **`archivesspace/archivesspace:4.2.1`** + 同版本 Solr + MySQL 8.0，Compose 拉起。
- Staff **`http://IP:8080`**，Public **`http://IP:8081`**，默认 **`admin` / `admin`**（改密）。
- 必须有 **`config/config.rb`**；内存建议 **4 GB+**。
- 用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取；勿用 `latest` / `ANW-*`。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/archivesspace-docker-deploy


