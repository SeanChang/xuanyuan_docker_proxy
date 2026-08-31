# Docker Compose 部署 Apache Superset：轻松搭建数据可视化 BI 平台

![Docker Compose 部署 Apache Superset：轻松搭建数据可视化 BI 平台](https://imgs.xuanyuan.cloud/docker/blog/superset.webp)

*分类: Docker部署教程 | 标签: Apache Superset,Superset,Docker,轩辕镜像,BI,数据可视化,私有化部署,部署教程 | 发布时间: 2026-07-22 14:09:54*

> 运营要周报大盘、产品要漏斗转化、老板要「打开浏览器就能看数」——很多团队会先把报表绑在商业 SaaS BI 上：按席位 / 按查询量计费，看板一多成本就上去；数据还得出境或落到第三方租户里，合规与安全评审往往过不了。退回 Excel / 本地透视表？又慢、难协作、版本满天飞，更谈不上统一口径与权限。于是「自己服务器上跑一套开源 BI」成了常见诉求。

> *本文基于 [apache/superset](https://xuanyuan.cloud/zh/r/apache/superset) 镜像 **`6.1.0-dev`**，配套 **Postgres 17 + Redis 7**。

运营要周报大盘、产品要漏斗转化、老板要「打开浏览器就能看数」——很多团队会先把报表绑在商业 SaaS BI 上：按席位 / 按查询量计费，看板一多成本就上去；数据还得出境或落到第三方租户里，合规与安全评审往往过不了。退回 Excel / 本地透视表？又慢、难协作、版本满天飞，更谈不上统一口径与权限。于是「自己服务器上跑一套开源 BI」成了常见诉求。

**Apache Superset** 正是为此而生：它是 Apache 软件基金会旗下的开源 **数据探索与可视化平台**（现代 BI）。你在浏览器里连接 MySQL、PostgreSQL、Presto/Trino 等几乎任意 SQL 数据源，用**无代码图表构建器**拖拽维度与指标做出柱状图、折线图、地图等可视化，再拼成可筛选、可分享的**交互式仪表盘**；进阶同学还可以进 **SQL Lab** 直接写 SQL 探数、把查询沉淀为数据集。轻量语义层（Dataset 上的指标 / 维度）让业务与数仓同学能对齐口径，而不必每人一份私有 SQL。角色权限（Admin / Alpha / Gamma 等）适合内网多角色协作。典型落地包括：经营与运营看板、自助取数与即席分析、用开源栈部分替代 Tableau / Power BI / 云 BI 的内网场景。

本文用 [轩辕镜像](https://xuanyuan.cloud) 加速，在 Linux 上用 **自包含 Docker Compose** 拉起 **Superset + Postgres + Redis**：**无需 clone GitHub**，固定标签、挂载 `superset_config.py`（元数据进 Postgres，避免落到默认 SQLite），浏览器登录后即可连库出图。

镜像页见 [apache/superset](https://xuanyuan.cloud/zh/r/apache/superset)，标签列表见 [tags](https://xuanyuan.cloud/r/apache/superset/tags)，官方介绍见 [Superset Intro](https://superset.apache.org/docs/intro)，Docker 构建说明见 [Docker Builds](https://superset.apache.org/docs/installation/docker-builds)。

> **定位说明**：本文方案适合 **单机试用 / 小团队体验**。官方声明其 Docker Compose 构造**不作为生产高可用方案**；生产请自建 lean 镜像加驱动，并考虑 K8s / Helm、外部托管元数据库与备份。当前 Compose **未包含 Celery worker**，定时报表 / 重异步任务能力有限。

---

## 一、Apache Superset 是什么？

**Apache Superset** 是 Apache 软件基金会旗下的开源 **数据探索与可视化平台**（现代 BI）：连接几乎任何支持 SQLAlchemy 的数据源，在浏览器里做图表、仪表盘与 SQL 查询。

| 能力 | 说明 |
|------|------|
| 无代码出图 | Charts / Dashboards，拖拽维度指标即可 |
| SQL Lab | 浏览器里写 SQL、探数、保存查询 |
| 多数据源 | PostgreSQL、MySQL、Presto 等；还可从列表选更多引擎 |
| 语义层 | 数据集（Dataset）上定义指标与维度 |
| 场景 | 运营看板、自助分析、内网 BI 替代部分商业工具 |

数据流（本文 Compose）：

```text
浏览器 ──HTTP:8088──▶  superset_app
                          │
                          ├──元数据──▶  postgres:17（必须挂配置，勿落 SQLite）
                          └──缓存────▶  redis:7
业务库（MySQL / PG / …）◀── UI「Connect a database」──  superset_app
```

### 1.1 标签怎么选（必看）

依据官方 [Docker Builds](https://superset.apache.org/docs/installation/docker-builds)：

| 标签 | 含义 | 本文 |
|------|------|------|
| **`6.1.0-dev`** | 正式版 6.1.0 的 **dev** 构建，含 `psycopg2` 等，可连 Postgres 元数据库 | **采用** |
| `6.1.0` / `latest` | **lean**：几乎无数据库驱动，连元数据 Postgres 也要自装驱动 | 生产可衍生，不作开箱方案 |
| `latest-dev` | 浮动标签，历史上可能滞后 | **不推荐**（文稿固定版本） |
| `master` / `master-dev` | 开发主干 | 不用 |

更多标签见 [apache/superset tags](https://xuanyuan.cloud/r/apache/superset/tags)。

### 1.2 为什么不用 git clone 官方仓库？

官方文档常用「clone 仓库 + `docker-compose-image-tag.yml`」。国内大量环境 **无法稳定访问 GitHub**，本文改为：

- 只写本地 `docker-compose.yml` + `.env` + **`superset_config.py`**
- 镜像全部走轩辕：`docker.xuanyuan.run/...`
- **不依赖** clone / Scarf 网关

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 操作系统 | **Linux x86_64**（本文 Ubuntu 24.04；官方 Compose **不支持 Windows**） |
| Docker | Docker Engine + **Compose V2**（`docker compose`） |
| 内存 | 建议 ≥ **4～8 GB** 可用 |
| CPU | **无 AVX2 / x86-64-v2 硬性限制**；正式版镜像支持 amd64 / arm64 |
| 端口 | **8088**（Superset Web） |
| 工作目录 | `/data/superset`（示例） |

```bash
docker --version
docker compose version
```

若未装 Docker 可用轩辕一键安装脚本：

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

```bash
docker pull docker.xuanyuan.run/apache/superset:6.1.0-dev
docker pull docker.xuanyuan.run/library/postgres:17
docker pull docker.xuanyuan.run/library/redis:7
```

实测输出（节选）：

```text
Digest: sha256:5822dff49c41fd745ce33e38af502f9c64df30d133aeba148c5d89b35a1004ef
Status: Downloaded newer image for docker.xuanyuan.run/apache/superset:6.1.0-dev
docker.xuanyuan.run/apache/superset:6.1.0-dev

Digest: sha256:a426e44bac0b759c95894d68e1a0ac03ecc20b619f498a91aae373bf06d8508d
Status: Downloaded newer image for docker.xuanyuan.run/library/postgres:17
docker.xuanyuan.run/library/postgres:17

Digest: sha256:a8f08480e1f88f2647fed492d1178c06abb0d0c1fbf02c682a61e2f483fb3954
Status: Downloaded newer image for docker.xuanyuan.run/library/redis:7
docker.xuanyuan.run/library/redis:7
```

---

## 四、自包含 Compose 部署

### 4.1 创建目录与密钥

```bash
sudo mkdir -p /data/superset && cd /data/superset
openssl rand -base64 42
```

把输出写入 `.env`（**勿把示例密钥原样用于生产**）：

```bash
cat > /data/superset/.env << 'EOF'
SUPERSET_SECRET_KEY=请替换为 openssl 输出的随机串
POSTGRES_PASSWORD=superset
ADMIN_USERNAME=admin
ADMIN_PASSWORD=admin
ADMIN_EMAIL=admin@example.com
EOF
```

### 4.2 必须：`superset_config.py`（否则元数据落 SQLite）

仅设置 `DATABASE_*` 环境变量时，镜像默认仍可能走 **SQLite**（init 日志会出现 `Context impl SQLiteImpl`）。必须挂载配置，显式指定 Postgres：

```bash
cat > /data/superset/superset_config.py << 'EOF'
import os

SECRET_KEY = os.environ["SUPERSET_SECRET_KEY"]

SQLALCHEMY_DATABASE_URI = (
    "postgresql+psycopg2://"
    f"{os.environ['DATABASE_USER']}:{os.environ['DATABASE_PASSWORD']}"
    f"@{os.environ['DATABASE_HOST']}:{os.environ['DATABASE_PORT']}"
    f"/{os.environ['DATABASE_DB']}"
)

REDIS_HOST = os.environ.get("REDIS_HOST", "redis")
REDIS_PORT = os.environ.get("REDIS_PORT", "6379")

CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_DEFAULT_TIMEOUT": 300,
    "CACHE_KEY_PREFIX": "superset_",
    "CACHE_REDIS_HOST": REDIS_HOST,
    "CACHE_REDIS_PORT": REDIS_PORT,
    "CACHE_REDIS_DB": 1,
}
DATA_CACHE_CONFIG = CACHE_CONFIG
FILTER_STATE_CACHE_CONFIG = CACHE_CONFIG
EXPLORE_FORM_DATA_CACHE_CONFIG = CACHE_CONFIG

class CeleryConfig:
    broker_url = f"redis://{REDIS_HOST}:{REDIS_PORT}/0"
    result_backend = f"redis://{REDIS_HOST}:{REDIS_PORT}/1"
    imports = ("superset.sql_lab", "superset.tasks.scheduler")
    worker_prefetch_multiplier = 1
    task_acks_late = False

CELERY_CONFIG = CeleryConfig
EOF
```

### 4.3 `docker-compose.yml`

```bash
cat > /data/superset/docker-compose.yml << 'EOF'
x-superset-env: &superset-env
  SUPERSET_CONFIG_PATH: /app/pythonpath/superset_config.py
  SUPERSET_SECRET_KEY: ${SUPERSET_SECRET_KEY}
  DATABASE_USER: superset
  DATABASE_PASSWORD: ${POSTGRES_PASSWORD}
  DATABASE_HOST: db
  DATABASE_PORT: "5432"
  DATABASE_DB: superset
  REDIS_HOST: redis
  REDIS_PORT: "6379"

services:
  db:
    image: docker.xuanyuan.run/library/postgres:17
    container_name: superset_db
    restart: unless-stopped
    environment:
      POSTGRES_DB: superset
      POSTGRES_USER: superset
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - db_home:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U superset -d superset"]
      interval: 10s
      timeout: 5s
      retries: 10

  redis:
    image: docker.xuanyuan.run/library/redis:7
    container_name: superset_cache
    restart: unless-stopped
    volumes:
      - redis:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 10

  superset-init:
    image: docker.xuanyuan.run/apache/superset:6.1.0-dev
    container_name: superset_init
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    environment:
      <<: *superset-env
    volumes:
      - ./superset_config.py:/app/pythonpath/superset_config.py:ro
    user: root
    restart: "no"
    command:
      - /bin/bash
      - -c
      - |
        set -e
        superset db upgrade
        superset fab create-admin \
          --username ${ADMIN_USERNAME} \
          --firstname Admin \
          --lastname User \
          --email ${ADMIN_EMAIL} \
          --password ${ADMIN_PASSWORD} \
          || true
        superset init

  superset:
    image: docker.xuanyuan.run/apache/superset:6.1.0-dev
    container_name: superset_app
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
      superset-init:
        condition: service_completed_successfully
    ports:
      - "8088:8088"
    environment:
      <<: *superset-env
    volumes:
      - ./superset_config.py:/app/pythonpath/superset_config.py:ro
      - superset_home:/app/superset_home
    user: root
    restart: unless-stopped
    command: ["/app/docker/entrypoints/run-server.sh"]

volumes:
  db_home:
  redis:
  superset_home:
EOF
```

### 4.4 启动

```bash
cd /data/superset
docker compose up -d
```

实测输出：

```text
[+] Running 8/8
 ✔ Network superset_default       Created
 ✔ Volume superset_superset_home  Created
 ✔ Volume superset_db_home        Created
 ✔ Volume superset_redis          Created
 ✔ Container superset_cache       Healthy
 ✔ Container superset_db          Healthy
 ✔ Container superset_init        Exited
 ✔ Container superset_app         Started
```

> **`superset_init` 显示 Exited 是正常的**：它只做一次性初始化（`db upgrade` → 创建 admin → `superset init`），成功后退出码应为 **0**，然后 `superset_app` 才会启动。`docker compose ps` 默认可能不列出已退出容器，可用 `docker compose ps -a` 查看。

---

## 五、验证启动

确认元数据走的是 **Postgres**（而不是 SQLite）：

```bash
docker logs --tail=80 superset_init | grep -E 'SQLite|Postgres|postgresql|Admin User|ERROR'
```

实测关键行：

```text
Context impl PostgresqlImpl.
Admin User admin created.
```

探测登录页：

```bash
curl -I http://127.0.0.1:8088/login/
```

实测：

```text
HTTP/1.1 200 OK
Server: gunicorn
Content-Type: text/html; charset=utf-8
```

浏览器访问：`http://<服务器IP>:8088`（本文截图环境为 `http://192.168.1.10:8088`）。

---

## 六、浏览器登录与日常使用

默认管理员（与 `.env` 一致）：

| 项 | 值 |
|----|-----|
| 用户名 | **admin** |
| 密码 | **admin** |

首次登录后建议立即在右上角 **Settings** 中修改密码。

### 6.1 登录页

打开 `http://IP:8088`，输入 **admin / admin**，点击 **Sign in**。

![Apache Superset 登录页，输入默认账号 admin](https://imgs.xuanyuan.cloud/docker/blog/superset-1.webp)

### 6.2 登录后首页

登录成功进入 **Home**。全新实例下 Dashboards / Charts 为空（No results），可点 **+ Dashboard** / **+ Chart** 开始创建。顶部导航：**Dashboards**、**Charts**、**Datasets**、**SQL**。

![Superset 首页 Home，仪表盘与图表为空可新建](https://imgs.xuanyuan.cloud/docker/blog/superset-2.webp)

### 6.3 Dashboards（仪表盘）

顶部点 **Dashboards**，进入仪表盘列表。空实例显示 No Data，点右上角 **+ Dashboard** 新建看板，之后把图表拖进去即可。

![Superset Dashboards 列表为空，点击 + Dashboard 新建](https://imgs.xuanyuan.cloud/docker/blog/superset-3.webp)

### 6.4 Charts（图表）

**Charts** 页管理所有可视化。点 **+ Chart**，选择数据集与图表类型后保存；保存的图可挂到仪表盘上。

![Superset Charts 列表为空，点击 + Chart 创建图表](https://imgs.xuanyuan.cloud/docker/blog/superset-4.webp)

### 6.5 Datasets（数据集）

**Datasets** 是「表 / SQL 结果」到图表之间的语义层。连上数据库后，在这里用 **+ Dataset** 选表或写自定义 SQL，再去出图。

![Superset Datasets 列表为空，点击 + Dataset 添加数据集](https://imgs.xuanyuan.cloud/docker/blog/superset-5.webp)

### 6.6 SQL Lab（写 SQL 探数）

顶部 **SQL** → **SQL Lab**。左侧选数据库与 schema，点 **Add** 开新标签页写 SQL。适合先探数，再把结果沉淀为 Dataset / Chart。

![Superset SQL Lab 界面，从 SQL 菜单进入](https://imgs.xuanyuan.cloud/docker/blog/superset-6.webp)

### 6.7 连接业务数据库（STEP 1）

在 SQL Lab 或 Settings 中发起连接时，会出现 **Connect a database** 向导（STEP 1 OF 3）。可快速选 **PostgreSQL / Presto / MySQL / SQLite**，或从下方列表选更多引擎。

![Connect a database 第一步：选择数据库类型如 PostgreSQL MySQL](https://imgs.xuanyuan.cloud/docker/blog/superset-7.webp)

### 6.8 填写连接信息（STEP 2，以 PostgreSQL 为例）

填写 Host、Port（默认 5432）、Database name、Username、Password、Display Name，再点 **Connect**。

![Connect a database 第二步：填写 PostgreSQL 主机端口与账号](https://imgs.xuanyuan.cloud/docker/blog/superset-8.webp)

**连库主机怎么填（易踩坑）：**

| 业务库位置 | Host 怎么写 |
|------------|-------------|
| 与 Superset **同一 Compose 网络**内的服务 | 用**服务名**（例如本文元数据库服务名是 `db`，但请勿把业务分析库与元数据库混为一谈） |
| 跑在**宿主机**上 | 容器内不要用 `127.0.0.1`（那是容器自己）；用宿主机局域网 IP，或 `host.docker.internal`（视 Docker 版本 / 额外 `--add-host`） |
| 远程服务器 | 填可达的 IP / 域名，并放行防火墙端口 |

连上库之后的推荐路径：

```text
Connect database → Datasets（+ Dataset）→ Charts（+ Chart）→ Dashboards（+ Dashboard）
```

也可先在 **SQL Lab** 写查询，再保存为数据集或图表。

---

## 七、日常运维

```bash
cd /data/superset
docker compose ps
docker compose logs -f --tail=100 superset
docker compose restart
docker compose down          # 保留 named volume，元数据不丢
docker compose up -d
# docker compose down -v   # 会清空 Postgres / Redis / home，慎用
```

升级：改 Compose 中镜像标签为新版本 → `docker compose pull && docker compose up -d`（升级前建议备份 volume）。换大版本请先阅读官方 [UPDATING.md](https://github.com/apache/superset/blob/master/UPDATING.md)。

---

## 八、FAQ

**Q：为什么不用 git clone 官方仓库？**  
A：国内常无法访问 GitHub。本文自包含 Compose + 配置文件即可，镜像走轩辕加速域。

**Q：为什么必须挂 `superset_config.py`？**  
A：不挂时 init 可能出现 `SQLiteImpl`，看板与用户落在容器内 SQLite，Postgres 白开。挂上后应看到 `PostgresqlImpl`。

**Q：`superset_init` 为什么是 Exited？**  
A：一次性初始化容器，成功即退出；属预期行为。用 `docker inspect superset_init --format '{{.State.ExitCode}}'` 确认应为 `0`。

**Q：默认账号密码是什么？**  
A：**admin / admin**（与 `.env` 中 `ADMIN_*` 一致）。请尽快修改。

**Q：CPU 有 AVX2 之类要求吗？**  
A：**没有**（不像 Doris / ES 9.x）。正式版镜像支持 amd64 与 arm64。

**Q：能连 MySQL / ClickHouse 吗？**  
A：UI 支持选多种引擎；`6.1.0-dev` 自带部分驱动，缺驱动时需按官方文档扩展 lean 镜像或在容器内安装对应 Python 包。

**Q：适合生产吗？**  
A：本文偏体验。生产需强化 `SECRET_KEY`、外部备份 Postgres、反向代理 HTTPS、按需加 Celery worker，并参考官方 K8s / Helm。

**Q：端口 8088 被占用怎么办？**  
A：改 Compose 映射左侧端口，例如 `"18088:8088"`，浏览器改访新端口。

---

## 九、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/apache/superset:6.1.0-dev
docker pull docker.xuanyuan.run/library/postgres:17
docker pull docker.xuanyuan.run/library/redis:7

# 目录与启动（需已写好 .env / superset_config.py / docker-compose.yml）
cd /data/superset
docker compose up -d

# 验证
docker logs --tail=80 superset_init | grep -E 'SQLite|Postgres|Admin User'
curl -I http://127.0.0.1:8088/login/

# 浏览器
# http://<IP>:8088   账号 admin / admin

# 停止（保留数据）
docker compose down
```

---

## 十、延伸阅读

- 轩辕镜像页：[apache/superset](https://xuanyuan.cloud/zh/r/apache/superset)
- 标签列表：[apache/superset tags](https://xuanyuan.cloud/r/apache/superset/tags)
- 官方介绍：[Superset Intro](https://superset.apache.org/docs/intro)
- Docker 构建与标签：[Docker Builds](https://superset.apache.org/docs/installation/docker-builds)
- Docker Compose（官方）：[Docker Compose](https://superset.apache.org/docs/installation/docker-compose)
- 轩辕使用手册：[xuanyuan.cloud/usage](https://xuanyuan.cloud/usage)

---

## 总结

- 标签用固定版 **`6.1.0-dev`**（含 Postgres 驱动），配套 **Postgres 17 + Redis 7**，全程轩辕加速。  
- **无需 clone GitHub**；必须挂载 **`superset_config.py`**，确认 init 日志为 `PostgresqlImpl`。  
- `superset_init` **Exited** 属正常；浏览器 `http://IP:8088`，默认 **admin / admin**。  
- 日常路径：连库 → Dataset → Chart → Dashboard；也可用 SQL Lab 探数。  

