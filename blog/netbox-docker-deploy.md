# Docker 部署 NetBox：轻松搭建 IPAM / DCIM 网络资产管理平台

![Docker 部署 NetBox：轻松搭建 IPAM / DCIM 网络资产管理平台](https://imgs.xuanyuan.cloud/docker/blog/nextbox.webp)

*分类: Docker部署教程 | 标签: NetBox,Docker,轩辕镜像,IPAM,DCIM,网络自动化,私有化部署,部署教程 | 发布时间: 2026-08-02 14:34:50*

> 机房又加了两排机柜、业务要划新 VLAN、运营商刚下发一段公网地址——这些变更往往散落在 Excel 表格、Wiki 页面、工单附件，甚至运维群聊天记录里。表格一人一改、版本对不上；Wiki 写了「已分配」实际 ping 不通；排障时才发现同网段被两个人各划过一次。网络与机房资产没有「单一事实来源」时，对账和变更都会变成猜。

*本文基于 [netboxcommunity/netbox:v4.6-5.0.2](https://xuanyuan.cloud/zh/r/netboxcommunity/netbox)（实测显示 **NetBox Community v4.6.7-Docker-5.0.2**），用 **自包含 Docker Compose** 部署。面向 **Ubuntu 24.04** 等 Linux。

机房又加了两排机柜、业务要划新 VLAN、运营商刚下发一段公网地址——这些变更往往散落在 **Excel 表格、Wiki 页面、工单附件，甚至运维群聊天记录** 里。表格一人一改、版本对不上；Wiki 写了「已分配」实际 ping 不通；排障时才发现同网段被两个人各划过一次。网络与机房资产没有「单一事实来源」时，对账和变更都会变成猜。

商业 IPAM / DCIM 授权贵、还常要求数据上云或出域；很多团队其实只需要：**资产台账自己掌控、浏览器能查能改、接口能对接自动化**。内网机房拓扑、公网地址池、专线电路归属，通常也不适合丢到第三方 SaaS。

**NetBox** 正是为此而生的开源 **IPAM（IP 地址管理）+ DCIM（数据中心基础设施管理）** 平台：在浏览器里统一管理站点与机柜、设备与接口、IP 前缀与地址、VLAN / VRF、电路与租户，并把这些数据作为后续 Ansible、脚本、监控、CMDB 对接的「网络源数据」。社区维护的 Docker 镜像坐标为 **`netboxcommunity/netbox`**（见 [镜像页](https://xuanyuan.cloud/zh/r/netboxcommunity/netbox)），配套 PostgreSQL 与 Valkey（Redis 兼容）即可跑通完整栈。

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`netboxcommunity/netbox:v4.6-5.0.2`** 及依赖镜像，本地自包含 Compose 启动（**无需访问 GitHub / clone 官方仓库**），到浏览器创建管理员、登录仪表盘并开始录入资产——全程零基础可跟做，文内附 **2 张实测界面截图**。

> **上手要点**  
> - **端口**：宿主机 **8000** → 容器 **8080**  
> - **账号**：无默认管理员；`SKIP_SUPERUSER=true` 时需 `createsuperuser`（密码默认至少 12 位且含数字）  
> - **标签**：生产优先钉 `vX.Y.Z-a.b.c` / `vX.Y-a.b.c`；本文实测 `v4.6-5.0.2`  
> - **踩坑**：首次建库迁移常需数分钟，期间 `ps` 可能显示 `unhealthy`，日志仍在 `Applying …` 时不要急着 `down -v`；记得配置 `API_TOKEN_PEPPER_1`，并更换示例库密与 `SECRET_KEY`

---

## 一、NetBox 是什么？

一句话：**NetBox = 给网络与机房资产用的「单一事实来源（Source of Truth）」**——先在库里建模，再驱动自动化与变更。

### 1.1 它能管什么

| 模块 | 典型对象 |
|------|----------|
| **DCIM** | 站点 / 机房、机柜、设备类型与设备、接口、线缆 |
| **IPAM** | IP 前缀、IP 地址、VLAN、VRF、AS 号 |
| **电路 / 租户** | 专线电路、供应商、租户与组织归属 |
| **自动化** | REST / GraphQL API、Webhook、自定义脚本与报表、插件生态 |

### 1.2 为什么不用 clone 官方仓库？

官方 Getting Started 常用「clone `netbox-docker` + override」。国内大量环境 **无法稳定访问 GitHub**，本文改为：

- 只写本地 `docker-compose.yml` + `env/*.env`
- 镜像全部走轩辕：`docker.xuanyuan.run/...`
- **不挂载**宿主机 `configuration/`：镜像内已含默认配置（`/etc/netbox/config/`），环境变量即可驱动实验室部署

### 1.3 架构（跟做时先记住这条链）

```text
浏览器 :8000 ──▶ netbox（Web / API，容器内 8080）
                    │
                    ├── postgres（业务库）
                    ├── redis / redis-cache（Valkey，队列与缓存）
                    └── netbox-worker（后台任务）
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04**（本文按此写） |
| Docker | Engine ≥ **20.10.10**；containerd ≥ **1.5.6**；Compose V2 |
| 内存 | 建议 ≥ **4 GB**（Web + Worker + PostgreSQL + 两个 Valkey） |
| 磁盘 | 建议 ≥ **20 GB**（镜像 + 数据库 + 媒体文件） |
| 端口 | 宿主机 **8000** → 容器 **8080**（可在 Compose 中修改） |

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

---

## 三、标签怎么选

镜像约每 24 小时自动构建。**生产环境建议**使用带版本后缀的发布标签。

| 标签形态 | 含义 | 推荐 |
|----------|------|------|
| **`vX.Y.Z-a.b.c` / `vX.Y-a.b.c`** | NetBox `vX.Y(.Z)` + Docker 支持文件 `a.b.c` | **生产首选** |
| `vX.Y.Z` / `vX.Y` | 指向上述带后缀标签的最新构建 | 可用 |
| `latest-a.b.c` / `latest` | 最新稳定 NetBox | 尝鲜 / 非关键环境 |
| `snapshot-a.b.c` / `snapshot` | 预发布 | **仅测试，勿上生产** |

本文跟做固定 **`v4.6-5.0.2`**。完整标签见：[xuanyuan.cloud/r/netboxcommunity/netbox/tags](https://xuanyuan.cloud/r/netboxcommunity/netbox/tags)。

---

## 四、自包含 Compose 部署

工作目录：`/www/wwwroot/netbox`（权限不足可改 `$HOME/netbox`）。

### 4.1 创建目录并生成密钥

```bash
sudo mkdir -p /www/wwwroot/netbox/env
sudo chown -R "$USER:$USER" /www/wwwroot/netbox
cd /www/wwwroot/netbox

# 生成 SECRET_KEY（至少足够长的随机串；下面写入 env 时替换）
openssl rand -base64 48
```

把 `openssl` 输出记下来，下一步写入 `env/netbox.env` 的 `SECRET_KEY=`。

### 4.2 编写环境变量

以下密码为**实验室示例**，生产务必全部更换，且 **多文件中同一用途的密码保持一致**。

```bash
cd /www/wwwroot/netbox

cat > env/postgres.env << 'EOF'
POSTGRES_DB=netbox
POSTGRES_USER=netbox
POSTGRES_PASSWORD=ChangeMe_NetboxDb_2026
EOF

cat > env/redis.env << 'EOF'
REDIS_PASSWORD=ChangeMe_Redis_2026
EOF

cat > env/redis-cache.env << 'EOF'
REDIS_PASSWORD=ChangeMe_RedisCache_2026
EOF

# 再生成一串给 API Token Pepper（与 SECRET_KEY 不同即可）
openssl rand -base64 48

cat > env/netbox.env << 'EOF'
API_TOKEN_PEPPER_1=请替换为第二段 openssl 输出
CORS_ORIGIN_ALLOW_ALL=True
DB_HOST=postgres
DB_NAME=netbox
DB_USER=netbox
DB_PASSWORD=ChangeMe_NetboxDb_2026
REDIS_HOST=redis
REDIS_DATABASE=0
REDIS_PASSWORD=ChangeMe_Redis_2026
REDIS_SSL=false
REDIS_CACHE_HOST=redis-cache
REDIS_CACHE_DATABASE=1
REDIS_CACHE_PASSWORD=ChangeMe_RedisCache_2026
REDIS_CACHE_SSL=false
SECRET_KEY=请替换为第一段 openssl 输出
SKIP_SUPERUSER=true
GRAPHQL_ENABLED=true
WEBHOOKS_ENABLED=true
MEDIA_ROOT=/opt/netbox/netbox/media
# 小规格 VPS（1～2 核）建议限制 worker，避免启动警告
GRANIAN_WORKERS=2
EOF
```

用编辑器把 `SECRET_KEY=`、`API_TOKEN_PEPPER_1=` 换成两段 `openssl` 的真实输出（各一行、勿换行截断）。未设置 `API_TOKEN_PEPPER_1` 时日志会反复提示 `API_TOKEN_PEPPERS is not defined`（不影响先登录用 Web，但 **v2 API Token** 不可用）。

> **配图待补（图 2）**：目录含 `docker-compose.yml` 与 `env/`。建议：`netbox-2.png`。

### 4.3 编写 `docker-compose.yml`

```bash
cat > /www/wwwroot/netbox/docker-compose.yml << 'EOF'
services:
  netbox: &netbox
    image: docker.xuanyuan.run/netboxcommunity/netbox:v4.6-5.0.2
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
      redis-cache:
        condition: service_healthy
    env_file: env/netbox.env
    user: "netbox:root"
    healthcheck:
      test: curl -f http://localhost:8080/login/ || exit 1
      # 首次建库迁移在慢机器上可达数分钟；过短会被判 unhealthy，worker 起不来
      start_period: 600s
      timeout: 5s
      interval: 15s
      retries: 20
    volumes:
      - netbox-media-files:/opt/netbox/netbox/media:rw
    ports:
      - "8000:8080"
    restart: unless-stopped

  netbox-worker:
    <<: *netbox
    depends_on:
      netbox:
        # 用 started 而非 healthy：避免首次长迁移拖垮整栈
        condition: service_started
    ports: []
    command:
      - /opt/netbox/venv/bin/python
      - /opt/netbox/netbox/manage.py
      - rqworker
    healthcheck:
      test: ps -aux | grep -v grep | grep -q rqworker || exit 1
      start_period: 40s
      timeout: 3s
      interval: 15s
      retries: 5

  postgres:
    image: docker.xuanyuan.run/library/postgres:18-alpine
    env_file: env/postgres.env
    volumes:
      - netbox-postgres:/var/lib/postgresql
    healthcheck:
      test: pg_isready -q -t 2 -d $$POSTGRES_DB -U $$POSTGRES_USER
      start_period: 20s
      timeout: 30s
      interval: 10s
      retries: 5
    restart: unless-stopped

  redis:
    image: docker.xuanyuan.run/valkey/valkey:9.1-alpine
    command:
      - sh
      - -c
      - valkey-server --appendonly yes --requirepass $$REDIS_PASSWORD
    env_file: env/redis.env
    volumes:
      - netbox-redis-data:/data
    healthcheck: &redis-healthcheck
      test: '[ $$(valkey-cli --pass "$${REDIS_PASSWORD}" ping) = ''PONG'' ]'
      start_period: 5s
      timeout: 3s
      interval: 1s
      retries: 5
    restart: unless-stopped

  redis-cache:
    image: docker.xuanyuan.run/valkey/valkey:9.1-alpine
    command:
      - sh
      - -c
      - valkey-server --requirepass $$REDIS_PASSWORD
    env_file: env/redis-cache.env
    volumes:
      - netbox-redis-cache-data:/data
    healthcheck: *redis-healthcheck
    restart: unless-stopped

volumes:
  netbox-media-files:
  netbox-postgres:
  netbox-redis-data:
  netbox-redis-cache-data:
EOF
```

核对解析结果：

```bash
cd /www/wwwroot/netbox
docker compose config | grep image
```

应全部为 `docker.xuanyuan.run/...`。

---

## 五、拉取镜像并启动

可先单独拉主镜像验证网络：

```bash
docker pull docker.xuanyuan.run/netboxcommunity/netbox:v4.6-5.0.2
```

**Ubuntu 24.04 实测本地镜像（`docker images`）：**

```text
IMAGE                                                   DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/netboxcommunity/netbox:v4.6-5.0.2   1.26GB       255MB
docker.xuanyuan.run/library/postgres:18-alpine          433MB        121MB
docker.xuanyuan.run/valkey/valkey:9.1-alpine            65.7MB       18.8MB
```

| 官方镜像（Docker Hub） | 轩辕镜像加速拉取 |
|------------------------|------------------|
| `netboxcommunity/netbox:v4.6-5.0.2` | `docker.xuanyuan.run/netboxcommunity/netbox:v4.6-5.0.2` |
| `postgres:18-alpine` | `docker.xuanyuan.run/library/postgres:18-alpine` |
| `valkey/valkey:9.1-alpine` | `docker.xuanyuan.run/valkey/valkey:9.1-alpine` |

一键拉齐并启动：

```bash
cd /www/wwwroot/netbox
docker compose pull
docker compose up -d
```

首次会跑完整库迁移，**常需数分钟**（日志持续 `Applying … OK` 属正常）。请等到初始化结束并出现 Granian 监听后再测登录页：

```bash
docker compose ps
docker compose logs -f netbox
# 另开终端探测（返回 200/302 即 Web 已起来）
curl -I http://127.0.0.1:8000/login/
```

> **说明**：迁移未完成前 healthcheck 会失败，`ps` 可能长期显示 `unhealthy`；只要容器仍是 **Up** 且日志在推进，**不要** `down -v`。Web 起来后健康状态会陆续变绿；再执行一次 `docker compose up -d` 可补起 `netbox-worker`。

**Ubuntu 24.04 实测：启动成功日志（节选）**

```text
⚙️ Applying database migrations
…（大量 Applying xxx... OK）
⚙️ Running trace_paths
… Finished.
⚙️ Removing stale content types
⚙️ Removing expired user sessions
⚙️ Building search index (lazy)
Reindexing 93 models.
… Completed. Total entries: 7
↩️ Skip creating the superuser
✅ Initialisation is done.
[INFO] Starting granian (main PID: 8)
[INFO] Listening at: http://:::8080
[INFO] Spawning worker-1 with PID: …
[INFO] Started worker-1
…
```

判读要点：

| 日志 | 含义 |
|------|------|
| `Applying … OK` | 首次建库迁移进行中，耐心等待 |
| `Skip creating the superuser` | `SKIP_SUPERUSER=true`，需手动 `createsuperuser` |
| `✅ Initialisation is done.` | 初始化完成 |
| `Listening at: http://:::8080` | Web 已监听，可访问宿主机 **8000** |
| `API_TOKEN_PEPPERS is not defined` | 未配 `API_TOKEN_PEPPER_1`；补上后 `docker compose up -d` 重建 netbox 即可 |
| `number of workers … higher than … CPU cores` | 小机器可在 `env/netbox.env` 设 `GRANIAN_WORKERS=2` |

当 `curl` 已通或日志出现 `Listening at` 后，浏览器打开：

```text
http://服务器IP:8000/
```

本机可访问 `http://127.0.0.1:8000/`。应能看到 NetBox 登录页。

**Ubuntu 24.04 实测 `docker compose ps`（healthy 示例）：**

```text
NAME                   IMAGE                                                   STATUS
netbox-netbox-1        docker.xuanyuan.run/netboxcommunity/netbox:v4.6-5.0.2   Up (healthy)   0.0.0.0:8000->8080/tcp
netbox-postgres-1      docker.xuanyuan.run/library/postgres:18-alpine          Up (healthy)
netbox-redis-1         docker.xuanyuan.run/valkey/valkey:9.1-alpine            Up (healthy)
netbox-redis-cache-1   docker.xuanyuan.run/valkey/valkey:9.1-alpine            Up (healthy)
```

若缺少 `netbox-worker`，再执行一次 `docker compose up -d` 即可补起。

> **无默认登录账号**：`SKIP_SUPERUSER=true` 时不会自动建管理员，须按下一节 `createsuperuser`。

### 5.1 停止与清理

```bash
# 停止（保留数据卷）
docker compose stop

# 再启动
docker compose start

# 删除容器与网络（保留卷）
docker compose down

# 危险：连数据卷一并删除（清空库与媒体）
docker compose down -v
```

---

## 六、创建管理员并登录

默认 `SKIP_SUPERUSER=true`，**无内置默认账号**，需手动创建管理员：

```bash
cd /www/wwwroot/netbox
docker compose exec netbox /opt/netbox/netbox/manage.py createsuperuser
```

按提示输入用户名、邮箱、密码。密码策略默认要求：**至少 12 位，且包含数字**；不满足时可提示 `Bypass password validation…`，实验室可输入 `y` 强行创建（生产建议设合规强密码）。

**Ubuntu 24.04 实测（节选）：**

```text
Username: admin
Email address: …
Password:
Password (again):
This password is too short. It must contain at least 12 characters.
Password must have at least one numeral.
Bypass password validation and create user anyway? [y/N]: y
Superuser created successfully.
```

看到 `Superuser created successfully.` 后，浏览器打开：

```text
http://服务器IP:8000/
```

未登录会进入中文界面的 **登录** 页（深色主题）：输入刚才创建的用户名与密码，点击青色 **登录** 按钮。

![NetBox 登录页：中文「登录」表单，含用户名与密码输入框](https://imgs.xuanyuan.cloud/docker/blog/nextbox-1.webp)

### 6.1 可选：自动创建超级用户（适合反复重建实验环境）

编辑 `env/netbox.env`，将：

```text
SKIP_SUPERUSER=true
```

改为：

```text
SKIP_SUPERUSER=false
SUPERUSER_NAME=admin
SUPERUSER_EMAIL=admin@example.com
SUPERUSER_PASSWORD=请换成强密码
```

然后：

```bash
docker compose up -d
```

**勿把真实生产密码写进会公开的文档或仓库。**

---

## 七、登录后怎么用（仪表盘与第一批资产）

登录成功后进入 **仪表盘（Dashboard）**。左侧是按业务拆好的模块导航，中间是可定制的统计小部件；全新安装时各计数多为 **0**，右下角可见版本号（实测：**NetBox Community v4.6.7-Docker-5.0.2**）。右上角显示当前用户（如 `admin 管理员`），顶部搜索框可按对象名快速跳转。

![NetBox 仪表盘：左侧组织机构/机柜/设备/IPAM 等导航，中间各模块对象计数与欢迎部件](https://imgs.xuanyuan.cloud/docker/blog/nextbox-2.webp)

### 7.1 左侧菜单在管什么

对照仪表盘侧栏，日常运维最常用的入口如下（界面为中文时）：

| 侧栏模块 | 典型用途 | 常见子项 |
|----------|----------|----------|
| **组织机构** | 物理/逻辑归属 | 站点、租户、联系人 |
| **机柜** | 机房空间与上架 | 机柜、机柜角色、海拔视图 |
| **设备** | 物理设备台账 | 设备、设备类型、厂商、平台、接口 |
| **连接** | 线缆与端口对接 | 线缆、控制台/电源等连接 |
| **IP地址管理** | 地址与二层规划 | 前缀、IP 地址、VLAN、VRF、AS |
| **虚拟化** | 集群与虚机 | 集群、虚拟机、虚拟磁盘 |
| **广域网线路** | 专线与运营商 | 电路、提供商、电路终端 |
| **无线 / VPN / 电源** | 扩展场景 | WLAN、隧道、电力馈电等 |
| **管理员** | 系统与权限 | 用户、组、API Token、作业、插件配置 |

中间部件（组织机构、IPAM、DCIM、电路、虚拟化）会实时显示各对象数量；录完第一批数据后，这里会从 `0` 变成实际统计。欢迎部件提示仪表盘可拖拽改布局——个人习惯不同可自行调整，不影响数据。

### 7.2 推荐录入顺序（从大到小）

| 顺序 | 操作 | 侧栏路径（中文界面） |
|------|------|----------------------|
| 1 | 创建 **站点** | 组织机构 → 站点 |
| 2 | （可选）机房位置 / **机柜** | 机柜 → 机柜 |
| 3 | 创建 **厂商 / 设备类型** | 设备 → 厂商 / 设备类型 |
| 4 | 创建 **设备** 并挂到站点（或机柜） | 设备 → 设备 |
| 5 | 创建 **前缀**（如 `10.10.0.0/24`） | IP地址管理 → 前缀 |
| 6 | 给设备接口分配 **IP 地址** | IP地址管理 → IP 地址（或设备详情里加接口再绑 IP） |

### 7.3 最小演示路径（跟做）

1. **组织机构 → 站点**：新建站点，名称如 `DC1`，状态选 Active，保存。  
2. **IP地址管理 → 前缀**：新建 `10.10.0.0/24`，状态 Active；需要时可先建 RIR/角色，实验室可先跳过细项。  
3. **设备 → 厂商 / 设备类型**：先建一个厂商（如 `Demo`）和设备类型（如 `Demo-Router`），再在 **设备 → 设备** 里新建一台设备，站点选 `DC1`。  
4. 打开该设备详情，添加接口（如 `eth0`），再分配地址 `10.10.0.10/24`（归属刚才的前缀）。  

完成后回到仪表盘：组织机构 / IPAM / DCIM 相关计数应大于 0；在前缀页可看到已用地址，在设备页可看到关联 IP——这就是 IPAM 与 DCIM 联动的最小闭环。

后续可按同样思路补：VLAN（IP地址管理）、机柜上架（机柜）、专线（广域网线路）、虚机（虚拟化）。需要对外给脚本用时，到 **管理员** 里为用户创建 API Token。

### 7.4 API 快速验证（可选）

在 Web 界面为用户创建 API Token 后（若仍提示 `API_TOKEN_PEPPERS is not defined`，先补 `API_TOKEN_PEPPER_1` 并重建 netbox 容器）：

```bash
curl -s -H "Authorization: Token 你的Token" \
  http://127.0.0.1:8000/api/dcim/sites/ | head
```

---

## 八、生产加固要点（必读摘要）

| 项 | 说明 |
|----|------|
| **更换密钥与密码** | 修改 `env/netbox.env` 的 `SECRET_KEY`、`DB_PASSWORD`，以及 `postgres` / `redis*` 环境文件，保持一致后重建/迁移 |
| **ALLOWED_HOSTS** | 按实际域名/IP 在配置或环境中收紧（默认实验室较宽松） |
| **HTTPS** | 前置 Nginx / Caddy / Traefik 终结 TLS |
| **钉标签** | 使用 `vX.Y.Z-a.b.c`，避免盲目追 `latest` / `snapshot` |
| **备份** | 定期备份 PostgreSQL 卷与媒体卷（`netbox-media-files` 等） |

文中示例凭据**仅适合实验室**；任何可被他人访问的环境都必须轮换。

---

## 九、更新与维护

1. 到 [标签列表](https://xuanyuan.cloud/r/netboxcommunity/netbox/tags) 选定目标版本。  
2. 修改 `docker-compose.yml` 中 `netbox` / `netbox-worker` 的镜像标签。  
3. `docker compose pull && docker compose up -d`。  
4. 关注 `netbox` 健康检查与迁移日志；重大版本升级前先备份卷。

---

## 十、常见问题 FAQ

**Q1：`docker compose` 不可用？**  
安装 Compose V2 插件；验证：`docker compose version`。

**Q2：为什么不用 git clone 官方仓库？**  
国内常无法访问 GitHub。镜像已内置默认配置，本地 Compose + `env/` 即可跟做。

**Q3：`netbox` 报 unhealthy / `dependency failed to start`？**  
多半是**首次迁移超过 healthcheck 宽限期**。日志若在刷 `Applying …`，说明仍在建库——容器 **Up (unhealthy)** 时可继续等，不必删卷。先 `curl -I http://127.0.0.1:8000/login/`；通了再 `docker compose up -d` 补起 worker。Compose 里 `start_period` 建议 **600s**，worker 用 `service_started`。确认安全组放行 **8000**；`SECRET_KEY` / `API_TOKEN_PEPPER_1` 不要留占位字。

**Q4：`manifest unknown`？**  
到 [轩辕标签页](https://xuanyuan.cloud/r/netboxcommunity/netbox/tags) 或 [Docker Hub Tags](https://hub.docker.com/r/netboxcommunity/netbox/tags) 核对标签；确认 Compose 里标签与 `pull` 一致。

**Q5：可以把 `image` 写成短名、只靠 registry-mirrors 吗？**  
本文按 Compose 推荐写法，**直接在 `image:` 使用轩辕完整域名**，行为更明确。

**Q6：`docker compose down -v` 之后数据没了？**  
`-v` 会删除命名卷。生产备份与销毁操作务必分开。

---

## 十一、命令速查

| 步骤 | 命令 |
|------|------|
| 工作目录 | `cd /www/wwwroot/netbox` |
| 拉主镜像 | `docker pull docker.xuanyuan.run/netboxcommunity/netbox:v4.6-5.0.2` |
| 启动 | `docker compose pull && docker compose up -d` |
| 建管理员 | `docker compose exec netbox /opt/netbox/netbox/manage.py createsuperuser` |
| 看状态 | `docker compose ps` / `docker compose logs -f netbox` |
| 访问 | `http://服务器IP:8000/` |

---

## 十二、延伸阅读

| 资源 | 链接 |
|------|------|
| 轩辕镜像页 | https://xuanyuan.cloud/zh/r/netboxcommunity/netbox |
| 标签列表 | https://xuanyuan.cloud/r/netboxcommunity/netbox/tags |
| 轩辕镜像使用手册 | https://xuanyuan.cloud/usage |


