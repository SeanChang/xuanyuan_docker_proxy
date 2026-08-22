# Docker 部署 PassWall：轻松搭建私有密码管理平台

![Docker 部署 PassWall：轻松搭建私有密码管理平台](https://img.xuanyuan.dev/docker/blog/passwall.webp)

*分类: Docker部署教程 | 标签: PassWall,Docker,轩辕镜像,密码管理,私有化部署,部署教程 | 发布时间: 2026-08-04 05:32:38*

> 浏览器自带的密码保存、各类「云同步密码库」用起来省事，但主密码与整库往往落在第三方机房；公司邮箱、跳板机、机柜口令、客户 VPN 等又常散落在备忘录、Excel、微信收藏里，换机或交接时对账困难，还容易把内网凭据带到个人云盘。

*本文基于 [passwall/passwall-server:2.59.0](https://xuanyuan.cloud/zh/r/passwall/passwall-server)，配套 **`postgres:16-alpine`**。面向 **Ubuntu 24.04** 等 Linux。*

浏览器自带的密码保存、各类「云同步密码库」用起来省事，但主密码与整库往往落在第三方机房；公司邮箱、跳板机、机柜口令、客户 VPN 等又常散落在备忘录、Excel、微信收藏里，换机或交接时对账困难，还容易把内网凭据带到个人云盘。

运维与中小团队更常见的诉求是：**敏感凭据不出内网、库在自己服务器、多端仍能同步**。商业私有化密码库授权贵、部署重；纯本地加密文件又难多端一致。

**PassWall** 正是为此而生的开源密码管理平台。部署本镜像后，你得到的是 **PassWall Server**：一台带 REST API 的自托管保险库后端——数据落在 **PostgreSQL**，条目经 **AES-GCM** 加密，登录走 **JWT**；本机安装 [PassWall Desktop](https://github.com/passwall/passwall-desktop)（Tauri）或浏览器扩展，对接你的 API（生产用 **`https://域名`**；实验室可用本机或 SSH 转发后的 **`http://127.0.0.1:3625`**，详见第六节），即可跨设备管理密码与卡片，也可以用 [Postman API 文档](https://documenter.getpostman.com/view/3658426/SzYbyHXj) 做联调。镜像坐标为 **`passwall/passwall-server`**（见 [镜像页](https://xuanyuan.cloud/zh/r/passwall/passwall-server)）。

> **本文只要两个 Docker 镜像**：`passwall/passwall-server` + `postgres`。自托管用辅助脚本调 API 建号，再用 **PassWall Desktop** 登录。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 个人 / 小团队自托管密码库 | Compose 拉起 Server + Postgres → **脚本建号** → Desktop **登录**（指向 HTTPS 域名或本机 `127.0.0.1:3625`） |
| 内网运维凭据集中存放 | 机柜口令、跳板机、交换机、云控制台账号进保险库，数据不出机房 |
| 多设备同步 | 多台电脑安装 Desktop（或扩展），都指向同一 Server，避免「每台本机一份库」 |
| 脚本 / 自动化对接 | 登录拿到 JWT 后调 `/api/*`（注册流程为端到端加密，不适合手写 curl） |

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`passwall/passwall-server:2.59.0`** 与 PostgreSQL，本地 Compose 启动，验证 `/health`，再用脚本建号 + **PassWall Desktop** 对接自建 API。

> **上手要点**  
> - **部署方式**：Docker Compose（`postgres` + `passwall-server`）  
> - **端口**：API **3625**（容器内外默认一致）；健康检查 **`GET /health`**  
> - **账号**：无默认账号；Desktop「注册」指向官网无效；用 `passwall-signup.mjs` 对自建 API 建号，再 SQL 放行 `is_verified` 后用 Desktop **登录**  
> - **标签**：实验室可用 `latest`；生产建议钉 **`2.59.0`**（或更新的发布号）  
> - **持久化**：`postgres-data/` + 宿主机 **`config.yml`（须含 `stripe.plans`，勿留空文件）** 与日志文件  
> - **客户端地址**：Desktop 只接受 **`https://`**，或 **`http://127.0.0.1` / `localhost`**；不要填局域网 IP 的明文 HTTP  
> - **踩坑**：① 勿用浮动 `postgres:alpine`（易落到 18+）；② **空 `config.yml` → `no plan configurations`**；③ README 里的 CLI 路径在当前镜像中不存在；④ 系统代理可能劫持对本机 `:3625` 的请求  
> - **安全**：示例库密为 `password`，上线前务必更换；生产请设置强 `passphrase` / `secret`  

镜像说明见 [passwall/passwall-server](https://xuanyuan.cloud/zh/r/passwall/passwall-server)，标签列表见 [tags](https://xuanyuan.cloud/r/passwall/passwall-server/tags)。上游：[passwall-server](https://github.com/passwall/passwall-server)、[passwall-desktop](https://github.com/passwall/passwall-desktop)、[API 文档（Postman）](https://documenter.getpostman.com/view/3658426/SzYbyHXj)。

---

## 一、PassWall 是什么？

一句话：**PassWall Server = 自托管密码库后端（AES-GCM + JWT API）**；桌面 / 扩展连你自己的服务器读写保险库——**不是**「浏览器里再开一个完整 Bitwarden 网页版」，而是 **后端在 Docker，前端在官方客户端**。

### 1.1 部署后你能存什么、拿来干什么

| 能力 | 说明 | 典型用途 |
|------|------|----------|
| 登录密码 | 站点账号与口令 | 邮箱、控制台、内网 Wiki、客户系统 |
| 信用卡 / 银行账户 | 卡片与账户结构化字段 | 个人财务条目（仍建议合规使用） |
| 笔记等条目 | 非账号类机密文本 | API Key 备注、恢复码、机柜位置说明 |
| REST API + JWT | access / refresh 令牌 | Postman 联调、自研小工具读写保险库 |
| 多客户端 | Desktop / 扩展指向同一 API | 笔记本 + 台式同步；浏览器自动填（扩展） |

加密与防护（官方说明）：AES-GCM、安全中间件、Gorm 防注入、登录速率限制。口令短语等关键配置会落到 `config.yml`，备份时务必连同数据库一起带走。

### 1.2 和「云密码库 / 纯本地文件」差在哪？

| | PassWall（本文） | 浏览器 / SaaS 密码库 | 本地加密文件 / Excel |
|--|------------------|----------------------|----------------------|
| 数据位置 | **自己的服务器 + PostgreSQL** | 第三方云 | 单机文件，难多端一致 |
| 使用方式 | Desktop / 扩展 / API 连自建后端 | 浏览器同步即可 | 靠拷贝或网盘同步文件 |
| 适合 | 内网凭据、要自托管、要 API | 个人大众站点密码 | 临时记几条、不需要同步 |
| 代价 | 要维护 Docker + 备份 | 信任厂商与出域风险 | 换机易丢、协作差 |

### 1.3 组件怎么选？

| 组件 | 镜像 / 项目 | 角色 | 本文是否必装 |
|------|-------------|------|--------------|
| **PassWall Server** | `passwall/passwall-server` | 核心 API 与加密存储 | **是** |
| **PostgreSQL** | `library/postgres` | 业务库 | **是** |
| **PassWall Desktop** | [GitHub](https://github.com/passwall/passwall-desktop) | 桌面客户端（Tauri） | **推荐**（本机安装，非 Docker） |
| **PassWall Extension** | [GitHub](https://github.com/passwall/passwall-extension) | 浏览器扩展 | 可选 |

只拉 Server、不装 Desktop 时，你主要得到的是 **可用的 API 服务**；要用图形界面管理条目，请安装 Desktop（或走 API / 扩展）。**不必**部署 `passwall-web`。

### 1.4 架构（跟做时先记住）

```text
PassWall Desktop / Extension / Postman
              │
              ▼  :3625
      passwall-server（API · AES-GCM · JWT）
              │
              ▼
         PostgreSQL（业务库）
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04**（本文按此写） |
| Docker | Engine + Compose V2 |
| 内存 | 建议 ≥ **1 GB** 可用（API + PostgreSQL） |
| 磁盘 | 镜像较小（Server 约十余 MB 量级；Postgres Alpine 另计）+ 库数据 |
| 端口 | 宿主机 **3625**（API）；实验室若映射 Postgres 则另占 **5432** |
| 架构 | Server 镜像以 **amd64** 为主（以标签页为准）；Postgres Alpine 多为多架构 |

```bash
docker --version
docker compose version
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)

# 备用地址1
bash <(wget -qO- https://get.xuanyuan.dev/docker.sh)

# 备用地址2
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 三、标签怎么选

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`2.59.0`** | 当前发布号之一（与同期 `latest` 同批） | **生产推荐钉版本（本文默认）** |
| `latest` | 指向近期构建 | 实验室可跟做；生产更建议钉号 |
| `2.58.0` 等 | 历史版本 | 仅回滚或对齐旧客户端时 |

完整 Server 标签见 [轩辕镜像标签列表](https://xuanyuan.cloud/r/passwall/passwall-server/tags)。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/passwall/passwall-server:2.59.0
docker pull docker.xuanyuan.run/library/postgres:16-alpine
```

**Ubuntu 24.04 实测输出（节选）：**

```text
# passwall-server:2.59.0
Digest: sha256:b937947840aec010b897a8e473f17044af439fc5877e59af9612763d894e2f3b
Status: Downloaded newer image for docker.xuanyuan.run/passwall/passwall-server:2.59.0
```

> `postgres:16-alpine` 实测 Digest：`sha256:57c72fd2a128e416c7fcc499958864df5301e940bca0a56f58fddf30ffc07777`（PostgreSQL **16.14**）。勿再用会落到 18+ 的浮动标签 `postgres:alpine`。

坐标对照：

| 用途 | Docker Hub | 轩辕加速 |
|------|------------|----------|
| PassWall Server | `passwall/passwall-server:2.59.0` | `docker.xuanyuan.run/passwall/passwall-server:2.59.0` |
| PostgreSQL | `postgres:16-alpine` | `docker.xuanyuan.run/library/postgres:16-alpine` |

---

## 五、快速体验：Docker Compose 部署

官方推荐 Compose 同时拉起 PostgreSQL 与 Server。下文为**自包含**写法：镜像全部走轩辕加速，去掉官方样例里的 `build:`（直接用已发布镜像），并避免把 Postgres 端口无必要地暴露到公网。

### 5.1 准备目录与 `config.yml`

官方镜像把 `config.yml`、日志以**文件**形式挂载。若宿主机路径不存在，Docker 可能建成**目录**导致失败。更关键的是：**不能只 `touch` 一个空 `config.yml`**——当前 Server 启动时会从配置里 **seed 订阅套餐**（`stripe.plans`），列表为空会直接报错退出：

```text
Failed to initialize application: failed to seed database: failed to seed plans: no plan configurations provided in config file
```

请先建目录，再写入实验室用最小配置（含至少一个 `free-monthly` 套餐）：

```bash
sudo mkdir -p /www/wwwroot/passwall
cd /www/wwwroot/passwall

touch passwall-server.log

cat > config.yml << 'EOF'
server:
  env: dev
  host: 0.0.0.0
  port: "3625"
  domain: http://localhost:3625
  frontend_url: http://localhost:5173
  # 实验室示例；生产请换成 openssl rand -base64 32 生成的长随机串
  passphrase: "lab-passphrase-change-me-32b"
  secret: "lab-jwt-secret-change-me-32bytes"
  timeout: 24
  generated_password_length: 16
  access_token_expire_duration: 30m
  refresh_token_expire_duration: 15d

database:
  name: passwall
  username: postgres
  password: password
  host: postgres
  port: "5432"
  log_mode: false
  ssl_mode: disable

# 必填：至少提供一个套餐，否则无法 seed 启动（见上游 seed_plans）
stripe:
  plans:
    - code: free-monthly
      name: Free
      billing_cycle: monthly
      price_cents: 0
      currency: USD
      trial_days: 0
      max_users: 1
      max_collections: 50
      max_items: 500
      features:
        sharing: false
        shared_items: false
        secure_send: false
        passkeys: false
        emergency_access: false
        teams: false
        audit: false
        sso: false
        api_access: true
        priority_support: false
        policies: false
        security_insights: false
        breach_monitoring: false
    - code: pro-monthly
      name: Pro
      billing_cycle: monthly
      price_cents: 299
      currency: USD
      trial_days: 0
      max_users: 1
      max_collections: null
      max_items: null
      features:
        sharing: true
        shared_items: true
        secure_send: true
        passkeys: true
        emergency_access: true
        teams: false
        audit: false
        sso: false
        api_access: true
        priority_support: false
        policies: false
        security_insights: true
        breach_monitoring: false
EOF
```

路径可按习惯改成 `$HOME/passwall-server` 等；下文以 `/www/wwwroot/passwall` 为例。`passphrase` / `secret` 一旦写入并已有加密数据，**勿随意更换**（否则可能无法解密历史条目）。

### 5.2 写入 `docker-compose.yml`

```bash
cd /www/wwwroot/passwall
cat > docker-compose.yml << 'EOF'
services:
  postgres:
    image: docker.xuanyuan.run/library/postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_DB: passwall
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    volumes:
      # 16.x 使用经典路径；若改用 18+，须改为挂载 /var/lib/postgresql（见 FAQ）
      - ./postgres-data:/var/lib/postgresql/data
    # 慢盘 / 老机器首次初始化较慢，放宽健康检查，避免误判 unhealthy
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres -d passwall"]
      interval: 5s
      timeout: 5s
      retries: 12
      start_period: 40s

  passwall-server:
    container_name: passwall-server
    image: docker.xuanyuan.run/passwall/passwall-server:2.59.0
    restart: unless-stopped
    depends_on:
      postgres:
        condition: service_healthy
    environment:
      PORT: "3625"
      PW_DB_NAME: passwall
      PW_DB_USERNAME: postgres
      PW_DB_PASSWORD: password
      PW_DB_HOST: postgres
      PW_DB_PORT: "5432"
      PW_DB_LOG_MODE: "false"
      PW_DB_SSL_MODE: disable
      # 生产务必改为长随机串（见第八节）；也可在下方 config.yml 写 passphrase / secret
      # PW_SERVER_PASSPHRASE: "请换成强口令短语"
      # PW_SERVER_SECRET: "请换成强 JWT Secret"
    ports:
      - "3625:3625"
    volumes:
      - ./config.yml:/app/config.yml
      - ./passwall-server.log:/app/passwall-server.log
EOF
```

> **安全提示**：示例中数据库密码为官方文档常用的 `password`，**仅适合实验室**。上线前请改成强密码，并同步修改 `POSTGRES_PASSWORD` 与 `PW_DB_PASSWORD`。

### 5.3 启动并验证

先看 **Postgres 是否 healthy**，再看 Server 日志（`logs` 跟的是 **Compose 服务名** `postgres` / `passwall-server`，不是容器名 `passwall-postgres-1`）：

```bash
cd /www/wwwroot/passwall
docker compose up -d
docker compose ps
docker compose logs --tail=80 postgres
docker compose logs --tail=80 passwall-server
```

期望 `ps` 里 `postgres` 为 `healthy`，`passwall-server` 为 `Up`（且日志不再刷 `no plan configurations`）。若刚改完 `config.yml` 仍在 `Restarting`，请 **`docker compose down && docker compose up -d`** 完整重建，不要只依赖一次 `up -d`。

另开终端探测 API：

```bash
curl -sS http://127.0.0.1:3625/health
curl -sS -o /dev/null -w "%{http_code}\n" http://127.0.0.1:3625/
```

**Ubuntu 24.04 实测**：

- `GET /health`：返回 `{"status":"ok"}`
- `GET /`：返回 **`404`** 也正常（根路径无页面；能连上即说明端口在听）

若是 `Couldn't connect to server`，说明进程还在崩溃重启，继续看日志。

也可看挂载的日志文件（部分输出在文件而非 `docker logs`）：

```bash
tail -n 50 /www/wwwroot/passwall/passwall-server.log
# 容器内还有 HTTP 访问日志
docker exec passwall-server tail -n 30 /app/passwall-http.log
docker compose logs --tail=50 passwall-server
```

浏览器或其它机器访问：

```text
http://服务器IP:3625/health
```

Server 本身是 **API**，浏览器打开根路径不一定有管理台；确认健康检查通过后，用下一节的 **脚本建号 + Desktop 登录**。

### 5.4 停止与清理

```bash
cd /www/wwwroot/passwall

# 停止（保留数据）
docker compose stop

# 删除容器与网络（保留 ./postgres-data 与 config.yml）
docker compose down

# 危险：连库数据目录一并删掉需手动 rm -rf ./postgres-data
```

---

## 六、创建用户与登录（自托管注意）

### 6.1 为什么 Desktop 点「注册」没反应？

**Ubuntu / Windows 实测结论（Passwall Desktop 1.26.0）：**

登录页长这样（点底部 **Server** 可展开 Server URL）：

![PassWall Desktop 登录页：左侧品牌区与右侧邮箱/主密码表单，底部有 Server、Sign Up、Export logs](https://img.xuanyuan.dev/docker/blog/passwall-1.webp)

登录页的 **Sign Up / 注册** 并不是向你填写的自建地址注册，源码里写死为打开官网：

```text
https://vault.passwall.io/sign-up
```

在 Tauri 桌面端，`window.open` 经常表现为「点了没反应」；导出的 ndjson 里也只有启动与跳转 `/login`，**没有任何** `/auth/signup` 请求。

同时：

- 发布镜像 **`passwall/passwall-server:2.59.0` 不含 `passwall-cli`**（上游 `cmd/passwall-cli.disabled`）
- 注册 API 是零知识协议，不能用手写「邮箱 + SHA256」糊弄

因此：**自托管建号不要点 Desktop 的注册按钮**，改用下面的辅助脚本（或自行按协议调 `POST /auth/signup`）。

### 6.2 用辅助脚本在自建 Server 上注册

发布镜像不含 CLI，Desktop「注册」又对自建无效，实验室用 Node 脚本按零知识协议调用 `POST /auth/signup`（需本机 **Node.js 18+**）。

把文末 **「附录：passwall-signup.mjs」** 全文保存为 `passwall-signup.mjs`（或从文档仓库下载同名文件）。在能访问 API 的机器上执行（把邮箱、密码换成你的；脚本与 Server 不在同一台时，把 `--base` 改成可达地址）：

```bash
node passwall-signup.mjs \
  --base http://127.0.0.1:3625 \
  --email admin@example.com \
  --password 'YourStrongPass123' \
  --name Admin
```

期望 HTTP **201** 与 `user created successfully`。

注册后默认 **`is_verified=false`**，未验证无法登录。实验室直接在库里放行：

```bash
cd /www/wwwroot/passwall
docker compose exec postgres psql -U postgres -d passwall \
  -c "UPDATE users SET is_verified = true WHERE email = 'admin@example.com';"
```

然后打开 Desktop：

1. 点 **Server**，填 API 地址。注意：**Desktop 不允许局域网 IP 的 `http://`**（只认 `https://`，或 `http://127.0.0.1` / `localhost`）。跨机器实验室可用 SSH 本地转发：`ssh -L 3625:127.0.0.1:3625 user@服务器`，再填 `http://127.0.0.1:3625`；生产请上 HTTPS。  
2. 用上面的邮箱 + 密码点 **Login**（不要点 Sign Up）  
3. 进入保险库后即可添加条目  

正确填写示意（本机或经 SSH `-L` 转发后的地址）：

![PassWall Desktop：已填邮箱与 Server URL http://127.0.0.1:3625，准备 Login](https://img.xuanyuan.dev/docker/blog/passwall-2.webp)

登录成功后进入空保险库（侧栏 Passwords / Secure Notes 等，中间「0 all items」）：

![PassWall Desktop 登录成功：Admin FREE 空保险库，中间提示 There is nothing here yet](https://img.xuanyuan.dev/docker/blog/passwall-6.webp)

生产环境应配置真实 SMTP，走邮件验证，而不是 SQL 改 `is_verified`。

### 6.3 API 端点速览（联调用）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/health` | 健康检查（无需登录） |
| GET | `/auth/prelogin` | 登录前取 KDF 参数 |
| POST | `/auth/signup` | 注册（需客户端算好的 ZK 字段） |
| POST | `/auth/signin` | 登录（需已验证邮箱） |
| GET/POST… | `/api/items` 等 | 业务 API（需 JWT） |

完整接口以源码路由与 [Postman 文档](https://documenter.getpostman.com/view/3658426/SzYbyHXj) 为参考；**以当前 2.x 零知识字段为准**。

---

## 七、如何使用（客户端与日常）

第六节跑通登录后，即可在 Desktop 里管理条目。Server URL 规则不变：**`https://域名`**，或本机/SSH 转发后的 **`http://127.0.0.1:3625`**（不要填局域网 IP 的明文 HTTP）。多台设备指向同一 Server 即可同步。桌面端为 Tauri 2 + React（见 [仓库说明](https://github.com/passwall/passwall-desktop)）。

### 7.1 添加第一条密码

侧栏选 **Passwords**，点中间栏 **+**，填写名称、用户名、密码、URL、备注后 **Save**：

![PassWall Desktop 新建密码：NAME 服务器密码、USERNAME root、URL 内网 IP、NOTE 本地服务器密码](https://img.xuanyuan.dev/docker/blog/passwall-8.webp)

保存后列表出现条目，右侧可查看详情并一键复制（右下角会提示 Copied!）：

![PassWall Desktop 密码详情：条目「服务器密码」、用户名 root、URL 与 NOTE 已保存，右下角 Copied 提示](https://img.xuanyuan.dev/docker/blog/passwall-9.webp)

### 7.2 安全笔记 / 地址 / 卡片 / 银行账户

侧栏其它分类同样点 **+** 新建。实测可正常写入中文：

![PassWall Desktop 新建安全笔记：TITLE 秘密记事本，NOTE 为中文测试内容](https://img.xuanyuan.dev/docker/blog/passwall-10.webp)

![PassWall Desktop 新建地址：Addresses 分类，TITLE 填写「添加地址测试」](https://img.xuanyuan.dev/docker/blog/passwall-11.webp)

![PassWall Desktop 新建支付卡：Payment Cards，CARD NAME 填写「信用卡测试」](https://img.xuanyuan.dev/docker/blog/passwall-12.webp)

![PassWall Desktop 新建银行账户：Bank Accounts，BANK NAME 填写「银行账户测试」](https://img.xuanyuan.dev/docker/blog/passwall-13.webp)

### 7.3 密码生成器

侧栏 **Password Generator** 可按长度与字符集生成口令（强度条会显示熵）：

![PassWall Desktop 密码生成器：长度 20、含大小写数字符号，强度 Very Strong](https://img.xuanyuan.dev/docker/blog/passwall-14.webp)

### 7.4 设置与解锁

**Settings** 可改语言、主题、保险库超时、导入导出与导出诊断日志：

![PassWall Desktop Settings：General / Security / Import Export / Diagnostics，含日志路径](https://img.xuanyuan.dev/docker/blog/passwall-7.webp)

会话锁定后进入 **Unlock** 页，只需再输主密码（不必重新填 Server URL）：

![PassWall Desktop 解锁页：显示已登录邮箱，MASTER PASSWORD 与 Unlock 按钮](https://img.xuanyuan.dev/docker/blog/passwall-16.webp)

### 7.5 浏览器扩展（可选）

[passwall-extension](https://github.com/passwall/passwall-extension) 可在浏览网页时配合 Desktop / Server 使用。Desktop 侧栏 **Connected Browsers** 会显示是否已连上扩展：

![PassWall Desktop Connected Browsers：No Browsers Connected，说明扩展需在 Desktop 登录时自动连接](https://img.xuanyuan.dev/docker/blog/passwall-15.webp)

安装扩展后保持 Desktop 已登录运行，扩展会自动连接；密钥由系统钥匙串保管。

### 7.6 日常运维建议

| 动作 | 命令 / 做法 |
|------|-------------|
| 看日志 | `docker compose logs -f passwall-server` |
| 备份库 | 停写或低峰时备份 `./postgres-data`，或 `pg_dump` |
| 备份配置 | 复制宿主机 `config.yml`（含加密相关配置时格外重要） |
| 升级 | 改 Compose 中镜像标签 → `docker compose pull` → `docker compose up -d` |

---

## 八、生产加固建议

实验室跑通后，上线前至少做这些：

1. **更换数据库密码**，并保证 Postgres 与 Server 环境变量一致。  
2. 设置强 **`passphrase` / `secret`**：写在 **`config.yml`**（本文实验室写法）或通过环境变量 **`PW_SERVER_PASSPHRASE` / `PW_SERVER_SECRET`** 注入均可；**不要两边各写一套还互相不一致**。丢失口令短语可能导致无法解密历史数据，请离线保存。  
3. **不要对公网裸露 5432**；API 前加 Nginx / Caddy HTTPS，仅暴露 443（Desktop 生产也应填 `https://域名`）。  
4. 生产钉镜像版本（如 `2.59.0`），避免默默跟随 `latest`。  
5. 定期备份 `postgres-data` 与 `config.yml`；备份文件加密存放。  
6. 防火墙只放行必要端口（反代后通常只放行 443；实验室直连 API 再放行 `3625`）。

官方还提供带 Nginx / Let’s Encrypt 的 Compose 样例（仓库 `build/docker/docker-compose-nginx.yml`），域名与证书邮箱需自行替换；国内网络与镜像源场景下，仍建议先按本文自包含 Compose 跑通，再叠加反代。

### 8.1 常用环境变量速查

| 变量 | 含义 | 备注 |
|------|------|------|
| `PORT` | API 端口 | 默认 `3625` |
| `PW_SERVER_PASSPHRASE` | 加密口令短语 | 生产必设；也可写在 `config.yml` 的 `server.passphrase` |
| `PW_SERVER_SECRET` | JWT Secret | 生产必设；也可写在 `config.yml` 的 `server.secret` |
| `PW_SERVER_ACCESS_TOKEN_EXPIRE_DURATION` | Access Token 有效期 | 默认常见为 `30m`；本文示例 config 为 `30m` |
| `PW_SERVER_REFRESH_TOKEN_EXPIRE_DURATION` | Refresh Token 有效期 | 上游常见默认 `7d`；本文示例 config 为 `15d`，以你实际写入为准 |
| `PW_DB_*` | 数据库连接 | `HOST` 在 Compose 内填服务名 `postgres` |
| `PW_BACKUP_*` | 备份目录 / 轮换 / 周期 | 按需 |

完整列表见 [上游 README](https://github.com/passwall/passwall-server#environment-variables)。

---

## 九、常见问题 FAQ

**Q1：`postgres` 起不来，日志提到 18+ / `/var/lib/postgresql/data (unused mount)`？**  
浮动标签 `postgres:alpine` 当前常指向 **PostgreSQL 18+**，官方改了数据目录约定：再挂宿主机目录到容器内 `/var/lib/postgresql/data` 会直接报错退出。本文已改为钉 **`postgres:16-alpine`**，继续使用经典挂载 `/var/lib/postgresql/data`。

实验室重建（会清空未用上的半残数据）：

```bash
cd /www/wwwroot/passwall
docker compose down
rm -rf ./postgres-data
docker pull docker.xuanyuan.run/library/postgres:16-alpine
# 将 docker-compose.yml 中镜像改为 …/postgres:16-alpine 后：
docker compose up -d
docker compose logs --tail=50 postgres
```

若坚持用 **18+**：把卷改为 `- ./postgres-data:/var/lib/postgresql`（注意路径少一层 `data`），并清空旧目录后重建。

**Q2：`passwall-server` 日志报 `no plan configurations provided in config file`？**  
说明挂载的 `config.yml` 是空文件，或缺少 `stripe.plans`。按 **§5.1** 写入含 `free-monthly` 的完整配置后：

```bash
cd /www/wwwroot/passwall
docker compose restart passwall-server
docker compose logs --tail=50 passwall-server
```

若 `config.yml` 被建成目录（`ls -ld config.yml` 显示 `d`），先删掉再按 §5.1 写成文件。改完配置后若容器仍在刷旧错误，执行 `docker compose down && docker compose up -d`。

**Q3：执行 `/app/passwall-cli` 提示 no such file？**  
正常。**`2.59.0` 镜像不含 CLI**（`ls /app` 只有 `passwall-server`）。请用 §6.2 脚本建号 + Desktop **登录**；不要再跟官方旧 README 的 CLI 步骤。

**Q4：Desktop 填 `http://192.168.x.x:3625` 提示 Please provide a valid server URL？**  
Desktop 客户端校验（`normalizeServerUrl`）：**非开发模式只接受 `https://`，或 `http://` 且主机为 `localhost` / `127.0.0.1`**。局域网 IP 的明文 HTTP 会被直接拒绝，连请求都不会发出：

![PassWall Desktop：Server URL 填局域网 IP 后提示 Please provide a valid server URL](https://img.xuanyuan.dev/docker/blog/passwall-4.webp)

实验室最快绕过（Windows 开到 Ubuntu 的本地转发，再填 localhost）：

```powershell
ssh -L 3625:127.0.0.1:3625 user@服务器IP
```

Desktop Server URL 填：`http://127.0.0.1:3625`（保持 SSH 窗口不关）。

若隧道与 `curl`/`node` 都通、Desktop 仍报 unexpected error：先查本机是否开了系统代理（Clash / NFCLOUD 等）。Tauri 的 HTTP 客户端常会走系统代理；把 `http://127.0.0.1:3625` 交给本地代理转发时经常会超时，界面只显示通用错误。处理见 **Q4c**。

生产请在 Server 前加 Nginx / Caddy **HTTPS**，Desktop 填 `https://你的域名`。

**Q4b：已反代 HTTPS（如 `https://cloud.xxx.test`）仍报 unexpected error？**  
先在 Windows 本机测（**不要**加 `-k`）：

```powershell
curl.exe -sS "https://你的域名/health"
curl.exe -sS "https://你的域名/auth/prelogin?email=你的邮箱"
```

若出现 `SEC_E_WRONG_PRINCIPAL` / certificate verify failed，说明 **证书域名与访问主机名不一致，或证书不被系统信任**。Tauri Desktop 会严格校验证书，加 `-k` 能通、Desktop 不通就是这个问题。

处理：用 **mkcert**（或内网 CA）为该主机名签发证书，并把根 CA 导入 Windows「受信任的根证书颁发机构」；或改用公网域名 + Let’s Encrypt。临时仍可用上面的 SSH `-L` + `http://127.0.0.1:3625`（并注意 **Q4c** 代理绕过）。

**Q4c：SSH 隧道已通、账号也能用脚本登录，Desktop 仍 unexpected error？**  
对照本机日志（Windows：`%LOCALAPPDATA%\io.passwall.desktop\logs\passwall.ndjson`）若 `base_origin` 已是 `http://127.0.0.1:3625`，但 `http.request_failed` 为 `error sending request...` 且 `duration_ms` 约十余秒，多半是 **系统代理劫持了 localhost 请求**。界面上常见表现是 **Login 按钮长时间转圈**，最后只弹出通用 unexpected error：

![PassWall Desktop：Server URL 为 127.0.0.1:3625 时 Login 按钮转圈加载中](https://img.xuanyuan.dev/docker/blog/passwall-3.webp)

复现检测（PowerShell；把代理端口改成你本机实际端口）：

```powershell
# 直连应立刻返回 {"status":"ok"}
curl.exe -sS --noproxy "*" "http://127.0.0.1:3625/health"

# 经本地代理访问本机隧道时，常会超时（示例端口 21081）
curl.exe -sS --max-time 8 -x "http://127.0.0.1:21081" "http://127.0.0.1:3625/health"
```

任选其一绕过：

1. 临时关掉代理软件 / 系统代理，再点 Desktop 登录。
2. 在代理的「绕过列表」里加入 `127.0.0.1`、`localhost`（若走内网域名再加对应主机名）。
3. 用无代理环境启动 Desktop：

```powershell
$env:NO_PROXY = "127.0.0.1,localhost,::1"
$env:HTTP_PROXY = ""
$env:HTTPS_PROXY = ""
& "$env:LOCALAPPDATA\Passwall\passwall-desktop.exe"
```

若 `curl --noproxy "*"` 已通、脚本建号也成功，仍登不进 Desktop，优先查代理 / TLS，而不是反复改密码。

**Q5：Desktop 点「注册」没反应 / 打不开？**  
正常。客户端把注册写死为打开 `https://vault.passwall.io/sign-up`，**不会**对自建 `:3625` 建号。请用 §6.2 的 `passwall-signup.mjs`，再用 Desktop **登录**。

**Q6：注册后登录提示 email not verified？**  
自托管未配 SMTP 时验证邮件发不出。实验室：

```bash
docker compose exec postgres psql -U postgres -d passwall \
  -c "UPDATE users SET is_verified = true WHERE email = '你的邮箱';"
```

生产请配置真实邮件通道。

**Q7：和 Bitwarden / Vaultwarden 怎么选？**  
Bitwarden 生态更成熟、客户端更多；PassWall 更轻、自研栈（Go API + 新版 Tauri 桌面）。已有 Bitwarden 习惯可继续用 Vaultwarden；想跟做轻量开源方案可试用 PassWall。

**Q8：只要 Server、已有外部 PostgreSQL？**  
可只跑 `passwall-server`，把 `PW_DB_HOST` 指到外部库地址，并保证网络与账号权限可达；不要再起 Compose 里的 postgres 服务。

**Q9：ARM 机器拉取失败？**  
查看标签页是否提供对应架构 manifest；Server 部分版本可能仅有 amd64。可换 x86_64 主机，或查更新标签。

---

## 十、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/passwall/passwall-server:2.59.0
docker pull docker.xuanyuan.run/library/postgres:16-alpine

# 目录与配置（config.yml 须含 stripe.plans，见正文 §5.1）
sudo mkdir -p /www/wwwroot/passwall && cd /www/wwwroot/passwall
touch passwall-server.log
# 再按 §5.1 写入 config.yml 与 docker-compose.yml

# 启动 / 状态 / 健康检查
docker compose up -d
docker compose ps
curl -sS http://127.0.0.1:3625/health

# 建号：node passwall-signup.mjs（见 §6.2）；Desktop 填 http://127.0.0.1:3625 或 https://域名
# （镜像内无 passwall-cli；勿填局域网 IP 的明文 http）

# 停止
docker compose down
```

---

## 十一、延伸阅读

- 轩辕镜像：[passwall/passwall-server](https://xuanyuan.cloud/zh/r/passwall/passwall-server) · [标签](https://xuanyuan.cloud/r/passwall/passwall-server/tags)  
- 上游：[passwall-server](https://github.com/passwall/passwall-server) · [Docker 说明](https://github.com/passwall/passwall-server/tree/main/build/docker)  
- 客户端：[passwall-desktop](https://github.com/passwall/passwall-desktop) · [passwall-extension](https://github.com/passwall/passwall-extension)  
- API：[Postman 文档](https://documenter.getpostman.com/view/3658426/SzYbyHXj)  
- 轩辕镜像：[使用手册](https://xuanyuan.cloud/usage) · [Docker 一键安装](https://xuanyuan.cloud/docker.sh)（[备用地址1](https://get.xuanyuan.dev/docker.sh)、[备用地址2](https://get.xuanyuan.me/docker.sh)）

---

## 总结

- **PassWall Server** 是开源密码管理平台的自托管后端，数据落在 **PostgreSQL**，默认 API 端口 **3625**。  
- 用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`passwall/passwall-server:2.59.0`**，Compose 一条链路即可跑通。  
- **无默认管理员**；发布镜像**不含** `passwall-cli`，请用文末 `passwall-signup.mjs` 建号，再用 **PassWall Desktop** 登录管理条目。  
- 上线前务必更换库密与 `config.yml` 中的 `passphrase` / `secret`，并做好数据库与配置备份。

---

## 附录：passwall-signup.mjs

将下列内容保存为 `passwall-signup.mjs` 后执行（见 §6.2）。

```javascript
#!/usr/bin/env node
/**
 * PassWall 自托管注册辅助脚本（实验室用）
 *
 * 用法：
 *   node passwall-signup.mjs \
 *     --base http://127.0.0.1:3625 \
 *     --email admin@example.com \
 *     --password 'YourStrongPass123' \
 *     --name Admin
 *
 * 需要 Node.js 18+。注册成功后需在 Postgres 中置 is_verified=true 才能登录。
 */

import { webcrypto } from "node:crypto";

const crypto = webcrypto;

function parseArgs(argv) {
  const out = {
    base: "http://127.0.0.1:3625",
    email: "",
    password: "",
    name: "Admin",
  };
  for (let i = 2; i < argv.length; i++) {
    const a = argv[i];
    const next = argv[i + 1];
    if (a === "--base" && next) out.base = next.replace(/\/$/, "");
    if (a === "--email" && next) out.email = next;
    if (a === "--password" && next) out.password = next;
    if (a === "--name" && next) out.name = next;
  }
  return out;
}

function toAB(u8) {
  return u8.buffer.slice(u8.byteOffset, u8.byteOffset + u8.byteLength);
}

function b64(u8) {
  return Buffer.from(u8).toString("base64");
}

function hex(u8) {
  return Buffer.from(u8).toString("hex");
}

async function pbkdf2(password, saltUtf8, iterations) {
  const key = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(password),
    "PBKDF2",
    false,
    ["deriveBits"]
  );
  const bits = await crypto.subtle.deriveBits(
    {
      name: "PBKDF2",
      salt: new TextEncoder().encode(saltUtf8),
      iterations,
      hash: "SHA-256",
    },
    key,
    256
  );
  return new Uint8Array(bits);
}

async function hkdfExpand(keyBytes, info, length = 32) {
  const infoBytes = new TextEncoder().encode(info);
  const output = new Uint8Array(length);
  let prev = new Uint8Array(0);
  let offset = 0;
  let counter = 1;
  while (offset < length) {
    const input = new Uint8Array(prev.length + infoBytes.length + 1);
    input.set(prev, 0);
    input.set(infoBytes, prev.length);
    input[input.length - 1] = counter;
    const hmacKey = await crypto.subtle.importKey(
      "raw",
      toAB(keyBytes),
      { name: "HMAC", hash: "SHA-256" },
      false,
      ["sign"]
    );
    const block = new Uint8Array(
      await crypto.subtle.sign("HMAC", hmacKey, toAB(input))
    );
    const n = Math.min(block.length, length - offset);
    output.set(block.subarray(0, n), offset);
    prev = block;
    offset += n;
    counter += 1;
  }
  return output;
}

async function encryptAesCbcHmac(plaintextU8, encKey, macKey) {
  const iv = crypto.getRandomValues(new Uint8Array(16));
  const aesKey = await crypto.subtle.importKey(
    "raw",
    toAB(encKey),
    { name: "AES-CBC" },
    false,
    ["encrypt"]
  );
  const ct = new Uint8Array(
    await crypto.subtle.encrypt(
      { name: "AES-CBC", iv: toAB(iv) },
      aesKey,
      toAB(plaintextU8)
    )
  );
  const dataToMac = new Uint8Array(iv.length + ct.length);
  dataToMac.set(iv, 0);
  dataToMac.set(ct, iv.length);
  const hmacKey = await crypto.subtle.importKey(
    "raw",
    toAB(macKey),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"]
  );
  const mac = new Uint8Array(
    await crypto.subtle.sign("HMAC", hmacKey, toAB(dataToMac))
  );
  return `2.${b64(iv)}|${b64(ct)}|${b64(mac)}`;
}

async function main() {
  const args = parseArgs(process.argv);
  if (!args.email || !args.password) {
    console.error(
      "Usage: node passwall-signup.mjs --base http://127.0.0.1:3625 --email you@example.com --password 'Secret123' [--name Admin]"
    );
    process.exit(1);
  }
  if (args.password.length < 8) {
    console.error("Password must be at least 8 characters");
    process.exit(1);
  }

  const iterations = 600000;
  const kdfSalt = hex(crypto.getRandomValues(new Uint8Array(32)));
  const masterKey = await pbkdf2(args.password, kdfSalt, iterations);
  const authKey = await hkdfExpand(masterKey, "auth", 32);
  const encKey = await hkdfExpand(masterKey, "enc", 32);
  const macKey = await hkdfExpand(masterKey, "mac", 32);

  const userKeyBytes = crypto.getRandomValues(new Uint8Array(64));
  const orgKeyBytes = crypto.getRandomValues(new Uint8Array(64));
  const userEnc = userKeyBytes.slice(0, 32);
  const userMac = userKeyBytes.slice(32, 64);

  const protectedUserKey = await encryptAesCbcHmac(
    userKeyBytes,
    encKey,
    macKey
  );
  const encryptedOrgKey = await encryptAesCbcHmac(
    orgKeyBytes,
    userEnc,
    userMac
  );

  const body = {
    name: args.name,
    email: args.email.toLowerCase().trim(),
    signup_source: "selfhost-script",
    master_password_hash: b64(authKey),
    protected_user_key: protectedUserKey,
    kdf_config: {
      kdf_type: 0,
      kdf_iterations: iterations,
    },
    kdf_salt: kdfSalt,
    encrypted_org_key: encryptedOrgKey,
  };

  const url = `${args.base}/auth/signup`;
  console.log(`POST ${url}`);
  const res = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
  const text = await res.text();
  console.log(`HTTP ${res.status}`);
  console.log(text);

  if (!res.ok) {
    process.exit(1);
  }

  console.log(`
下一步（必做，否则 Desktop 登录会提示 email not verified）：

  docker compose exec postgres psql -U postgres -d passwall -c \\
    \"UPDATE users SET is_verified = true WHERE email = '${args.email.toLowerCase().trim()}';\"

然后在 Desktop 用同一邮箱与密码登录（Server 填 ${args.base}）。
`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
```


