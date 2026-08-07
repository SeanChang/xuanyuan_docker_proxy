# Docker 部署 ERPNext：轻松搭建开源 ERP 企业管理平台

![Docker 部署 ERPNext：轻松搭建开源 ERP 企业管理平台](https://img.xuanyuan.dev/docker/blog/erpnext.webp)

*分类: Docker部署教程 | 标签: ERPNext,Frappe,Docker,轩辕镜像,ERP,进销存,私有化部署,部署教程 | 发布时间: 2026-07-28 03:02:49*

> ERPNext 是 Frappe Technologies 维护的免费开源 企业资源规划（ERP） 系统，跑在自家的 Frappe 低代码框架上。同一套 Web Desk 里集成财务会计（总账、应收应付、发票与报表）、供应链（采购、库存、销售）、生产制造（BOM、工单、委外）、固定资产、项目与质量，以及公司 / 用户 / 权限等组织主数据；业务流程可按行业勾选模块，单据之间能互相带出，减少「多系统对账」。源代码可按需二次开发，无按席位收取的许可费。实例跑在你自己的 Docker 主机上，库表与附件落在本地卷里——浏览器打开就能管进销存与账本，不必把核心经营数据绑死在某一家公有云 ERP。

*本文基于 [frappe/erpnext:v16.29.0](https://xuanyuan.cloud/zh/r/frappe/erpnext)，**Ubuntu 24.04** 实测。*

报价、采购单、入库出库、销售开票、应收应付……公司一大，这些单据就散落在 Excel、微信群和好几套互不相通的小软件里：库存对不上账、财务月底对账靠人肉、销售一问交期仓库答不上来。商业 ERP / SaaS 能把流程串起来，但授权贵、定制慢，关键主数据还躺在厂商云上——合规要求「数据不出域」、内网要断公网、或只是想少一份年费时，就需要一套**可自托管的开源 ERP**。

**ERPNext** 是 [Frappe Technologies](https://frappe.io/) 维护的免费开源 **企业资源规划（ERP）** 系统，跑在自家的 **Frappe** 低代码框架上。同一套 Web Desk 里集成财务会计（总账、应收应付、发票与报表）、供应链（采购、库存、销售）、生产制造（BOM、工单、委外）、固定资产、项目与质量，以及公司 / 用户 / 权限等组织主数据；业务流程可按行业勾选模块，单据之间能互相带出，减少「多系统对账」。源代码可按需二次开发，无按席位收取的许可费。实例跑在你自己的 Docker 主机上，库表与附件落在本地卷里——浏览器打开就能管进销存与账本，不必把核心经营数据绑死在某一家公有云 ERP。

上手不是「拉一个容器」那么简单。官方运行时镜像要配合 **MariaDB + 双 Redis + backend / frontend / worker / scheduler / websocket** 多服务栈。国内又常访问不了 GitHub，没法直接 `git clone frappe_docker`。本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 加速域 `docker.xuanyuan.run` 拉取 **`frappe/erpnext:v16.29.0` + `mariadb:11.8` + `redis:6.2-alpine`**，在本地目录粘贴**完整 Compose**（逻辑对齐官方演示栈 `pwd.yml`，**无需 clone**），等 `create-site` 建站完成后访问 **8080**，走完登录与 Welcome 向导，再把界面切到**简体中文**（实测：搜 `Chinese` 会 No Results，应搜 **「中文」或 `zh`**），并逛一眼组织、会计、资产、库存、生产与全局默认值。**Ubuntu 24.04** 全程实测，附 **15 张截图**、运维命令与 FAQ。

> **说明**：本文 Compose 用于**短期试用 / 学习**，不是生产加固方案。生产请参考官方 [frappe_docker](https://github.com/frappe/frappe_docker) 的 `compose.yaml` + overrides（可在能访问外网的环境准备，或自行内嵌 YAML）。默认管理员密码仅演示用，上线务必修改。

镜像说明见 [frappe/erpnext 镜像页](https://xuanyuan.cloud/zh/r/frappe/erpnext)，标签列表见 [tags](https://xuanyuan.cloud/r/frappe/erpnext/tags)。上游项目：[ERPNext](https://github.com/frappe/erpnext)；用户文档：[docs.erpnext.com](https://docs.erpnext.com)。

![ERPNext 登录页 Sign In](https://img.xuanyuan.dev/docker/blog/erpnext-1.webp)

*图 1：浏览器打开 8080 后的登录页*

---

## 一、ERPNext 是什么？

**ERPNext** 面向中小企业与成长型团队，把「进销存 + 财务 + 生产」收拢到一个浏览器工作台（Desk）。它不是单一进销存插件，而是按模块拼装的一体化平台：开票与收款进会计科目，采购收货进库存余额，工单耗料再回写成本——单据链路打通后，报表才有可信度。

核心能力一览：

| 能力 | 说明 |
|------|------|
| 财务会计 | 总账、应收应付、销售/采购发票、付款与日记账、损益等报表 |
| 供应链 | 询价/采购订单、收货、库存批次、销售订单与出库、交货相关单据 |
| 生产制造 | 物料清单（BOM）、生产工单、工序任务、委外加工 |
| 固定资产 | 资产卡片、折旧计划、资产移动与维护 |
| 项目 / 质量 | 项目任务与成本、质量检验相关流程 |
| 组织与权限 | 多公司、部门、角色权限、用户与系统默认值 |
| 自托管与扩展 | Docker / K8s 部署；基于 Frappe 可做 DocType / 工作流二次开发 |

和「只做库存的进销存」或「只做记账的财务软件」相比，ERPNext 的价值在于**同一主数据、多模块协同**：客户 / 供应商 / 物料只维护一份，销售、采购、仓库、财务共用。代价是栈更重（数据库 + 缓存队列 + 多进程），部署与运维门槛高于单容器小工具——这也是本文用 Compose 多服务跟做的原因。

典型场景：贸易/电商后台的进销存与对账、小型工厂的 BOM 与工单、需要私有化试点以替代昂贵 SaaS ERP 的团队。全球社区持续维护版本线（本文为 **v16**）；中文界面可用，但个别术语翻译可能未 100% 覆盖。

> **版本与依赖**：本文使用 **`frappe/erpnext:v16.29.0`**，配套 **MariaDB 11.8**、**Redis 6.2**。生产请固定三位版本号，勿用 `latest` / `develop`。

架构（本文演示栈）：

```text
浏览器 ──HTTP:8080──▶ frontend (nginx)
                         │
         ┌───────────────┼───────────────┐
         ▼               ▼               ▼
      backend:8000   websocket:9000   sites/logs 卷
         │
    ┌────┼────┬────────────┐
    ▼    ▼    ▼            ▼
  MariaDB  redis-cache  redis-queue  queue/scheduler
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux 建议 **Ubuntu 24.04**（本文实测） |
| CPU | **无 AVX 硬性要求**；`v16.29.0` 提供 **amd64 + arm64** |
| 核数 / 内存 | 演示建议 **≥2 vCPU、≥4 GB RAM**；生产常见 **4 vCPU / 8 GB** 起 |
| Docker | Engine + Compose V2 |
| 磁盘 | 镜像较大（erpnext 单镜像约 800MB+），整栈建议 **≥20–40 GB** SSD |
| 端口 | 宿主机 **8080**（frontend） |
| 目录 | `/www/wwwroot/erpnext` |

```bash
docker --version
docker compose version
```

Linux 未装 Docker：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)

# 备用地址
bash <(wget -qO- https://get.xuanyuan.dev/docker.sh)
```

ARM 主机若误拉 amd64 会走模拟变慢，可在 compose 各服务加 `platform: linux/arm64`。

---

## 三、标签怎么选

| 标签 | 用途 | 推荐 |
|------|------|------|
| `v16.29.0` | 固定稳定版（与官方演示栈对齐） | **试用 / 本文首选** |
| `v16` / `version-16` | 跟踪 v16 最新 | 可跟主线；生产仍钉三位号 |
| `v15.x` | v15 维护线 | 仅业务要求留 v15 |
| `latest` | 最新稳定 | 仅临时试用 |
| `develop` | 开发构建 | **勿上生产** |

标签列表：[xuanyuan.cloud/r/frappe/erpnext/tags](https://xuanyuan.cloud/r/frappe/erpnext/tags)。

---

## 四、拉取镜像（轩辕加速）

上游为 Docker Hub（`docker.io`）。公共登录域 `docker.xuanyuan.run`：**首次**需 `docker login`；已登录则直接 pull。规范见 [agents.md](https://xuanyuan.cloud/agents.md)。

```bash
grep -q '"docker.xuanyuan.run"' ~/.docker/config.json && echo "已登录" || echo "未登录"
# 未登录时：
# docker login docker.xuanyuan.run
```

```bash
sudo mkdir -p /www/wwwroot/erpnext
cd /www/wwwroot/erpnext

docker pull docker.xuanyuan.run/frappe/erpnext:v16.29.0
docker pull docker.xuanyuan.run/library/mariadb:11.8
docker pull docker.xuanyuan.run/library/redis:6.2-alpine
```

实测拉取摘要：

```text
Digest: sha256:a951e8c905161ec50246d5f6da8e324d89ffb8bb3b407b3508208890f6a9483c
Status: Downloaded newer image for docker.xuanyuan.run/frappe/erpnext:v16.29.0

Digest: sha256:efb4959ef2c835cd735dbc388eb9ad6aab0c78dd64febcd51bc17481111890c4
Status: Downloaded newer image for docker.xuanyuan.run/library/mariadb:11.8

Digest: sha256:ec5e187c913d422cdf60f4216a5fdfb95246792c6de6fe21ff5bed75cbfc8c23
Status: Downloaded newer image for docker.xuanyuan.run/library/redis:6.2-alpine
```

失败时按错误码分流（401→登录，402→充值，manifest→核对标签），**不要**默认改回 Docker Hub 直拉。

---

## 五、部署：免 clone 的完整 Compose

**不要**依赖 `git clone https://github.com/frappe/frappe_docker`（国内常连不上）。在目录内新建 `docker-compose.yml`，粘贴下文即可。

### 5.1 完整 docker-compose.yml

```yaml
# docker-compose.yml — ERPNext 演示栈（基于 frappe_docker pwd.yml）
# 访问 http://<主机IP>:8080  账号 Administrator / admin
services:
  backend:
    image: docker.xuanyuan.run/frappe/erpnext:v16.29.0
    networks:
      - frappe_network
    deploy:
      restart_policy:
        condition: on-failure
    volumes:
      - sites:/home/frappe/frappe-bench/sites
      - logs:/home/frappe/frappe-bench/logs
    environment:
      DB_HOST: db
      DB_PORT: "3306"
      MYSQL_ROOT_PASSWORD: admin
      MARIADB_ROOT_PASSWORD: admin
    depends_on:
      configurator:
        condition: service_completed_successfully

  configurator:
    image: docker.xuanyuan.run/frappe/erpnext:v16.29.0
    networks:
      - frappe_network
    deploy:
      restart_policy:
        condition: none
    entrypoint:
      - bash
      - -c
    command:
      - >
        ls -1 apps > sites/apps.txt;
        bench set-config -g db_host $$DB_HOST;
        bench set-config -gp db_port $$DB_PORT;
        bench set-config -g redis_cache "redis://$$REDIS_CACHE";
        bench set-config -g redis_queue "redis://$$REDIS_QUEUE";
        bench set-config -g redis_socketio "redis://$$REDIS_QUEUE";
        bench set-config -gp socketio_port $$SOCKETIO_PORT;
    environment:
      DB_HOST: db
      DB_PORT: "3306"
      REDIS_CACHE: redis-cache:6379
      REDIS_QUEUE: redis-queue:6379
      SOCKETIO_PORT: "9000"
    volumes:
      - sites:/home/frappe/frappe-bench/sites
      - logs:/home/frappe/frappe-bench/logs

  create-site:
    image: docker.xuanyuan.run/frappe/erpnext:v16.29.0
    networks:
      - frappe_network
    deploy:
      restart_policy:
        condition: none
    volumes:
      - sites:/home/frappe/frappe-bench/sites
      - logs:/home/frappe/frappe-bench/logs
    entrypoint:
      - bash
      - -c
    command:
      - >
        wait-for-it -t 120 db:3306;
        wait-for-it -t 120 redis-cache:6379;
        wait-for-it -t 120 redis-queue:6379;
        export start=`date +%s`;
        until [[ -n `grep -hs ^ sites/common_site_config.json | jq -r ".db_host // empty"` ]] && \
             [[ -n `grep -hs ^ sites/common_site_config.json | jq -r ".redis_cache // empty"` ]] && \
             [[ -n `grep -hs ^ sites/common_site_config.json | jq -r ".redis_queue // empty"` ]];
        do
          echo "Waiting for sites/common_site_config.json to be created";
          sleep 5;
          if (( `date +%s`-start > 120 )); then
            echo "could not find sites/common_site_config.json with required keys";
            exit 1
          fi
        done;
        echo "sites/common_site_config.json found";
        if [ -d "sites/frontend" ]; then
          echo "Site frontend already exists, skipping creation";
        else
          bench new-site --mariadb-user-host-login-scope='%' --admin-password=admin --db-root-username=root --db-root-password=admin --install-app erpnext --set-default frontend;
        fi;

  db:
    image: docker.xuanyuan.run/library/mariadb:11.8
    networks:
      - frappe_network
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      start_period: 5s
      interval: 5s
      timeout: 5s
      retries: 5
    deploy:
      restart_policy:
        condition: on-failure
    command:
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_unicode_ci
      - --skip-character-set-client-handshake
    environment:
      MYSQL_ROOT_PASSWORD: admin
      MARIADB_ROOT_PASSWORD: admin
    volumes:
      - db-data:/var/lib/mysql

  frontend:
    image: docker.xuanyuan.run/frappe/erpnext:v16.29.0
    networks:
      - frappe_network
    depends_on:
      - websocket
      - backend
    deploy:
      restart_policy:
        condition: on-failure
    command:
      - nginx-entrypoint.sh
    environment:
      BACKEND: backend:8000
      FRAPPE_SITE_NAME_HEADER: frontend
      SOCKETIO: websocket:9000
      UPSTREAM_REAL_IP_ADDRESS: 127.0.0.1
      UPSTREAM_REAL_IP_HEADER: X-Forwarded-For
      UPSTREAM_REAL_IP_RECURSIVE: "off"
      PROXY_READ_TIMEOUT: 120
      CLIENT_MAX_BODY_SIZE: 50m
    volumes:
      - sites:/home/frappe/frappe-bench/sites
      - logs:/home/frappe/frappe-bench/logs
    ports:
      - "8080:8080"

  queue-long:
    image: docker.xuanyuan.run/frappe/erpnext:v16.29.0
    networks:
      - frappe_network
    deploy:
      restart_policy:
        condition: on-failure
    command:
      - bench
      - worker
      - --queue
      - long,default,short
    volumes:
      - sites:/home/frappe/frappe-bench/sites
      - logs:/home/frappe/frappe-bench/logs
    environment:
      FRAPPE_REDIS_CACHE: redis://redis-cache:6379
      FRAPPE_REDIS_QUEUE: redis://redis-queue:6379
    depends_on:
      configurator:
        condition: service_completed_successfully

  queue-short:
    image: docker.xuanyuan.run/frappe/erpnext:v16.29.0
    networks:
      - frappe_network
    deploy:
      restart_policy:
        condition: on-failure
    command:
      - bench
      - worker
      - --queue
      - short,default
    volumes:
      - sites:/home/frappe/frappe-bench/sites
      - logs:/home/frappe/frappe-bench/logs
    environment:
      FRAPPE_REDIS_CACHE: redis://redis-cache:6379
      FRAPPE_REDIS_QUEUE: redis://redis-queue:6379
    depends_on:
      configurator:
        condition: service_completed_successfully

  redis-queue:
    image: docker.xuanyuan.run/library/redis:6.2-alpine
    networks:
      - frappe_network
    deploy:
      restart_policy:
        condition: on-failure
    volumes:
      - redis-queue-data:/data

  redis-cache:
    image: docker.xuanyuan.run/library/redis:6.2-alpine
    networks:
      - frappe_network
    deploy:
      restart_policy:
        condition: on-failure

  scheduler:
    image: docker.xuanyuan.run/frappe/erpnext:v16.29.0
    networks:
      - frappe_network
    deploy:
      restart_policy:
        condition: on-failure
    command:
      - bench
      - schedule
    volumes:
      - sites:/home/frappe/frappe-bench/sites
      - logs:/home/frappe/frappe-bench/logs
    depends_on:
      configurator:
        condition: service_completed_successfully

  websocket:
    image: docker.xuanyuan.run/frappe/erpnext:v16.29.0
    networks:
      - frappe_network
    deploy:
      restart_policy:
        condition: on-failure
    command:
      - node
      - /home/frappe/frappe-bench/apps/frappe/socketio.js
    environment:
      FRAPPE_REDIS_CACHE: redis://redis-cache:6379
      FRAPPE_REDIS_QUEUE: redis://redis-queue:6379
    volumes:
      - sites:/home/frappe/frappe-bench/sites
      - logs:/home/frappe/frappe-bench/logs
    depends_on:
      configurator:
        condition: service_completed_successfully

volumes:
  db-data:
  redis-queue-data:
  sites:
  logs:

networks:
  frappe_network:
    driver: bridge
```

数据落在 Compose **命名卷**（`sites` / `logs` / `db-data` / `redis-queue-data`），无需再挂宿主机子目录。

### 5.2 启动与建站日志

```bash
cd /www/wwwroot/erpnext
docker compose up -d
docker compose logs -f create-site
```

实测启动成功时大致为：

```text
✔ Network erpnext_frappe_network    Created
✔ Volume erpnext_redis-queue-data   Created
✔ Volume erpnext_sites              Created
✔ Volume erpnext_logs               Created
✔ Volume erpnext_db-data            Created
✔ Container erpnext-db-1            Started
✔ Container erpnext-redis-queue-1   Started
✔ Container erpnext-create-site-1   Started
✔ Container erpnext-configurator-1  Exited
✔ Container erpnext-redis-cache-1   Started
✔ Container erpnext-queue-long-1    Started
✔ Container erpnext-backend-1       Started
✔ Container erpnext-queue-short-1   Started
✔ Container erpnext-scheduler-1     Started
✔ Container erpnext-websocket-1     Started
✔ Container erpnext-frontend-1      Started
```

`create-site` 正常结束示例：

```text
wait-for-it: db:3306 is available after 28 seconds
sites/common_site_config.json found
Installing frappe...
Installing erpnext...
Current Site set to frontend
create-site-1 exited with code 0
```

首次建站可能要数分钟。看到 `exited with code 0` 后再打开浏览器。

| 容器 | 期望 |
|------|------|
| `erpnext-configurator-1` | **Exited**（一次性配置，正常） |
| `erpnext-create-site-1` | **Exited (0)**（建站完成） |
| `erpnext-frontend-1` 等 | Up，`0.0.0.0:8080->8080/tcp` |

访问：`http://<服务器IP>:8080`  
默认账号：**Administrator** / **admin**（仅演示）。

---

## 六、浏览器：登录与 Welcome 向导

### 6.1 登录

打开 `http://<IP>:8080`，进入 **Sign In**。邮箱可填 `Administrator`，密码 `admin`，点 **Continue**。

![ERPNext 登录页 Email 与 Password](https://img.xuanyuan.dev/docker/blog/erpnext-1.webp)

*图 1：登录页*

### 6.2 Welcome：语言 / 国家 / 时区 / 货币

首次会进入 **Welcome**。国家选 **China** 后，时区常见为 **Asia/Chongqing**，货币 **CNY**。  
语言默认常为 **English**——**不会**因选了 China 自动变中文。若此处下拉不好用，可先英文走完向导，登录后再改（见第七节）。

![ERPNext Welcome：语言国家时区货币](https://img.xuanyuan.dev/docker/blog/erpnext-2.webp)

*图 2：Welcome——语言、国家、时区、货币*

### 6.3 创建账户

填写 **Full Name**、**Email Address**（登录 ID）、**Password**，点 **Next**。

![ERPNext 向导：设置姓名邮箱密码](https://img.xuanyuan.dev/docker/blog/erpnext-3.webp)

*图 3：Let's set up your account*

### 6.4 业务画像与模块

按提示选择团队规模、工作类型等，并可勾选计划启用的模块（如 Accounting、Manufacturing、Stock、Project Management）。

![ERPNext 向导：业务画像与模块勾选](https://img.xuanyuan.dev/docker/blog/erpnext-4.webp)

*图 4：A little about you——模块勾选*

### 6.5 等待初始化

出现 **Setting up your system** / **Starting Frappe ...** 时耐心等待，完成后进入 Desk。

![ERPNext 向导：Setting up your system 进度](https://img.xuanyuan.dev/docker/blog/erpnext-5.webp)

*图 5：系统初始化进度*

---

## 七、切换简体中文（重要踩坑）

### 7.1 为什么搜 Chinese 没有结果？

语言显示名是 **「简体中文」**（代码 **`zh`**），**不是**英文词 `Chinese`。在 Language 的 Autocomplete 里搜 `Chinese` 会显示 **No Results**——这不代表镜像没有中文。

**正确做法（已实测）：**

1. 打开用户资料（或 Awesome Bar 搜 User）→ 找到 **Language**
2. 清空原有 `English`，输入 **`中文`** 或 **`zh`**
3. 选中结果（如 `zh` / 中文）→ **Save**
4. 等待 **Refreshing...**，再 **Ctrl+Shift+R** 强刷

![ERPNext Select Language：输入中文匹配到 zh](https://img.xuanyuan.dev/docker/blog/erpnext-7.webp)

*图 7：搜索「中文」即可匹配到 zh*

![ERPNext 用户语言已改为中文并 Refreshing](https://img.xuanyuan.dev/docker/blog/erpnext-8.webp)

*图 8：Language 保存为中文，页面刷新中*

命令行兜底（站点名本栈为 `frontend`）：

```bash
docker compose exec backend bench --site frontend set-language zh
docker compose exec backend bench --site frontend clear-cache
```

### 7.2 中文 Desk 主页

切换成功后，主页图标为中文模块名：组织、会计、资产、采购、生产、项目、质量、销售、库存、委外、ERPNext 设置等。

![ERPNext 中文 Desk 模块图标首页](https://img.xuanyuan.dev/docker/blog/erpnext-6.webp)

*图 6：简体中文 Desk 首页*

部分菜单/术语仍可能夹杂英文，属社区翻译覆盖不全，属正常。

---

## 八、功能演示：组织、会计、资产、库存、生产与设置

以下截图用于熟悉系统，演示数据来自实测环境（公司名示例「轩辕镜像」）。

### 8.1 组织：公司列表

进入 **组织**，可见公司主数据（国家中国、货币 CNY）。右下角 **Getting Started** 会提示完成公司、用户、邮箱、权限等引导步骤。

![ERPNext 组织模块：公司列表与 Getting Started](https://img.xuanyuan.dev/docker/blog/erpnext-9.webp)

*图 9：组织——公司列表*

### 8.2 会计：快捷入口与开票工作区

点击 **会计** 可看到开票、付款、报表、税、银行等快捷入口；进入 **开票管理** 可见损益相关图表与应收应付入口。

![ERPNext 会计模块快捷入口](https://img.xuanyuan.dev/docker/blog/erpnext-10.webp)

*图 10：会计——功能快捷入口*

![ERPNext 开票管理工作区与损益图](https://img.xuanyuan.dev/docker/blog/erpnext-11.webp)

*图 11：开票管理工作区*

### 8.3 资产

**资产** 模块提供固定资产价值分析、折旧、维护等入口；新站点图表可能为空，按 Getting Started 逐步建分类与资产即可。

![ERPNext 资产模块工作区](https://img.xuanyuan.dev/docker/blog/erpnext-12.webp)

*图 12：资产工作区*

### 8.4 库存与生产

继续点开 **库存**、**生产** 等工作区：左侧为单据与报表导航，中间为趋势图与 KPI（新站多为 0），右下角有模块向导。

![ERPNext 库存相关工作区](https://img.xuanyuan.dev/docker/blog/erpnext-13.webp)

*图 13：库存等工作区*

![ERPNext 生产模块：工单与产量图](https://img.xuanyuan.dev/docker/blog/erpnext-14.webp)

*图 14：生产工作区*

### 8.5 全局默认值

在 **ERPNext 设置 → 全局默认值** 可核对默认公司、国家、默认货币（CNY）等，改完点 **Save**。

![ERPNext 全局默认值：公司国家货币 CNY](https://img.xuanyuan.dev/docker/blog/erpnext-15.webp)

*图 15：全局默认值*

官方语言说明：[Set Language](https://docs.frappe.io/erpnext/set-language)。

---

## 九、运维命令速查

```bash
cd /www/wwwroot/erpnext

docker compose ps -a
docker compose logs -f frontend
docker compose logs -f backend
docker compose logs -f create-site

# 改语言兜底
docker compose exec backend bench --site frontend set-language zh
docker compose exec backend bench --site frontend clear-cache

# 停止 / 销毁（演示环境可直接 down；加 -v 会删命名卷数据）
docker compose down
# docker compose down -v
```

---

## 十、FAQ

**Q：能不能 `docker run` 单个 erpnext 容器？**  
A：不能当完整 ERP 用。需要 MariaDB、Redis 与多个进程角色，请用本文 Compose。

**Q：国内 clone 不了 frappe_docker 怎么办？**  
A：不必 clone。把本文 `docker-compose.yml` 存到本地目录即可。

**Q：CPU 有没有 AVX 之类限制？**  
A：无 AVX 硬性要求。`v16.29.0` 支持 amd64/arm64。真正卡点是内存与核数（建议 ≥4 GB / 2 核起）。

**Q：搜 Chinese 没有语言？**  
A：搜 **「中文」** 或 **`zh`**。详见第七节。

**Q：create-site 一直不退出？**  
A：看 `docker compose logs -f create-site` 与 `db` 日志；确认内存够用、8080 未被占用。正常结束为 `exited with code 0`。

**Q：默认密码安全吗？**  
A：`Administrator` / `admin` 与库 root 密码 `admin` 仅演示。公网暴露前必须改密并加防火墙 / 反代 HTTPS。

**Q：这套能直接上生产吗？**  
A：不建议。请改用官方生产 Compose（HTTPS、密码、备份、资源限制等），本文仅作试用。

---

## 十一、延伸阅读

- [frappe/erpnext 镜像页](https://xuanyuan.cloud/zh/r/frappe/erpnext)
- [frappe/erpnext 镜像标签列表](https://xuanyuan.cloud/r/frappe/erpnext/tags)
- [轩辕镜像 agents.md](https://xuanyuan.cloud/agents.md)
- [ERPNext 文档](https://docs.erpnext.com)
- [Set Language](https://docs.frappe.io/erpnext/set-language)
- [frappe_docker（官方容器编排，需可访问 GitHub）](https://github.com/frappe/frappe_docker)
- [ERPNext 源码仓库](https://github.com/frappe/erpnext)


