# Docker 部署 Rocket.Chat：轻松搭建私有化团队聊天与协作平台

![Docker 部署 Rocket.Chat：轻松搭建私有化团队聊天与协作平台](https://img.xuanyuan.dev/docker/blog/rocketchat.webp)

*分类: Docker部署教程 | 标签: Rocket.Chat,Docker,轩辕镜像,即时通讯,团队协作,私有化部署,部署教程 | 发布时间: 2026-07-26 14:43:13*

> 研发群、运维告警、项目同步……日常协作几乎离不开即时通讯。钉钉、企业微信、飞书好用，但消息与文件都在公有云上：合规要求「数据不出域」、内网完全断公网、或只是想少一份 SaaS 账单时，就需要一套可自托管的团队聊天。

*本文基于 [rocketchat/rocket.chat:8.6.1](https://xuanyuan.cloud/zh/r/rocketchat/rocket.chat)，**macOS + Docker Desktop** 实测（局域网访问 `http://192.168.1.10:3001`）。Linux（建议 Ubuntu 24.04）同样适用。*

研发群、运维告警、项目同步……日常协作几乎离不开即时通讯。钉钉、企业微信、飞书好用，但消息与文件都在公有云上：合规要求「数据不出域」、内网完全断公网、或只是想少一份 SaaS 账单时，就需要一套**可自托管的团队聊天**。

**Rocket.Chat** 是开源的企业级 **Web 即时通讯与协作平台**（官方称 Secure CommsOS）：公共频道、私有群组、一对一私聊、富文本与 reaction、文件上传、Webhook / API，以及桌面与手机客户端。工作区跑在你自己的 Docker 主机上，会话与附件落在本地 MongoDB 与上传卷里——浏览器打开就能聊，不必把全公司沟通绑死在某一家公有云 IM。

上手并不只是「拉一个容器」那么简单。Rocket.Chat **8.x** 依赖 **MongoDB 8.x 副本集**，官方 Compose 还会带上 **NATS**；x86 机器若 CPU **没有 AVX**，`mongo:8.0` 会直接 unhealthy。首次安装还要完成工作区向导，并把实例注册到 [Rocket.Chat Cloud](https://cloud.rocket.chat/)（在线邮件确认，或内网 **离线换码**）。实测里最容易踩的坑是：**Cloud 必须先注册账号，再收 magic-link**——未注册就点登录，页面显示「已发信」，邮箱却往往收不到。

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`rocketchat/rocket.chat:8.6.1` + `mongo:8.0` + `nats:2.11-alpine`**，Compose 拉起精简三件套（宿主机端口 **3001**，避开常见的 3000 占用），改对 `ROOT_URL`，走完管理员 / 组织向导与 **Cloud 离线注册**，再演示 Home 入门、管理用户、创建频道、目录里的 `#general`、移动端入口与布局设置。**macOS + Docker Desktop** 全程实测（局域网 `http://192.168.1.10:3001`），Linux（建议 Ubuntu 24.04）同样适用；文末附 **16 张截图**、运维命令与 FAQ。

国内从 Docker Hub 直拉常较慢，本文统一走轩辕加速。镜像说明见 [rocketchat/rocket.chat 镜像页](https://xuanyuan.cloud/zh/r/rocketchat/rocket.chat)，标签列表见 [tags](https://xuanyuan.cloud/r/rocketchat/rocket.chat/tags)。官方部署文档：[Deploy with Docker Compose](https://docs.rocket.chat/docs/deploy-with-docker-docker-compose)；离线注册说明：[Air-gapped Workspace Registration](https://docs.rocket.chat/docs/air-gapped-workspace-registration)。

![Rocket.Chat 首次安装：管理员信息](https://img.xuanyuan.dev/docker/blog/rocketchat-1.webp)

*图 1：安装向导第 1 步——创建管理员资料*

---

## 一、Rocket.Chat 是什么？

**Rocket.Chat** 是开源的企业级 **Web 即时通讯与协作平台**（Secure CommsOS）。核心能力：

| 能力 | 说明 |
|------|------|
| 多场景聊天 | 公共频道、私有群组、私聊 |
| 富消息 | Markdown、表情、reaction、编辑删除 |
| 文件与媒体 | 上传、预览；可接本地 / S3 等 |
| 多端 | Web、桌面、iOS / Android 官方客户端 |
| 集成 | REST API、Webhook、Marketplace 应用（需 Cloud 在线能力） |
| 自托管 | Docker / K8s；数据留在自有机房 |

典型场景：企业内部 IM、研发协作、私有社区、客服坐席。

> **版本与依赖**：Rocket.Chat **8.x** 需 **MongoDB 8.x 副本集**，官方 Compose 默认还带 **NATS**。每个版本约支持 **6 个月**；生产请固定三位版本号（本文 `8.6.1`），勿用 `latest` / `develop`。

架构（本文精简栈）：

```text
浏览器 ──HTTP:3001──▶ rocketchat:3000
                         │
              ┌──────────┼──────────┐
              ▼          ▼          ▼
         mongo:8.0    nats     uploads 卷
         (rs0 副本集)
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux 建议 **Ubuntu 24.04**；本文亦在 **macOS + Docker Desktop** 测通 |
| CPU | **x86 必须支持 AVX**（MongoDB 5.0+ 硬性要求）；Apple Silicon 走 arm64 镜像即可 |
| Docker | Engine + Compose V2；macOS 用 Docker Desktop，内存建议 ≥ **4 GB** |
| 内存 | 建议 ≥ **2 GB**（Mongo + Rocket.Chat） |
| 端口 | 容器内 **3000**；宿主机映射 **3001**（避开常见的 3000 占用） |
| 目录 | Linux 示例 `/www/wwwroot/rocketchat`；macOS 示例 `~/docker/rocketchat` |

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

x86 Linux 自检 AVX：

```bash
grep -o 'avx[^ ]*' /proc/cpuinfo | sort -u || echo "无 AVX，勿用 mongo:5/6/7/8"
```

无 AVX 时 Mongo 会反复告警并 **unhealthy**（见 FAQ），需换机器，不要降到 mongo:4.4 去配 RC 8.x。

---

## 三、标签怎么选

| 标签 | 用途 | 推荐 |
|------|------|------|
| `8.6.1` | 固定稳定版 | **生产 / 本文首选** |
| `latest` | 跟踪最新稳定 | 仅试用 |
| `develop` / `sha-*` | 开发构建 | 勿上生产 |

版本以 [GitHub Releases](https://github.com/RocketChat/Rocket.Chat/releases) 为准，再在 [tags 页](https://xuanyuan.cloud/r/rocketchat/rocket.chat/tags) 核对。标签一般为 **`8.x.y`（无 `v` 前缀）**。

---

## 四、拉取镜像（轩辕加速）

按 [agents.md](https://xuanyuan.cloud/agents.md)，docker.io 默认用公共登录域 `docker.xuanyuan.run`（未登录时先一次性 `docker login`）。

```bash
docker pull docker.xuanyuan.run/rocketchat/rocket.chat:8.6.1
docker pull docker.xuanyuan.run/library/mongo:8.0
docker pull docker.xuanyuan.run/library/nats:2.11-alpine
```

macOS 实测摘要：

```text
# rocket.chat:8.6.1
Digest: sha256:c8ee1044c2c0503eddc1abc212240012ec9ba73e2cfa80d001cd23d582ec7c51
Status: Downloaded newer image for docker.xuanyuan.run/rocketchat/rocket.chat:8.6.1

# mongo:8.0
Digest: sha256:5351bff2b5d1563e3fa603a74b9be85ef9323e10aeb0b45cea933a93876e77fd
Status: Downloaded newer image for docker.xuanyuan.run/library/mongo:8.0

# nats:2.11-alpine
Digest: sha256:e4bf19f15fd3218814a4e3c9e0064e1334bd8aa20d5984b9f1a0afd084f8cc00
Status: Downloaded newer image for docker.xuanyuan.run/library/nats:2.11-alpine
```

---

## 五、Compose 部署

### 5.1 建目录

```bash
# macOS 示例（本文实测）
mkdir -p ~/docker/rocketchat
cd ~/docker/rocketchat

# Linux 示例
# sudo mkdir -p /www/wwwroot/rocketchat && cd /www/wwwroot/rocketchat
```

### 5.2 写入 docker-compose.yml

**必改**：`ROOT_URL` 必须与浏览器访问地址一致（协议 + 主机 + 端口）。

```yaml
services:
  mongodb:
    image: docker.xuanyuan.run/library/mongo:8.0
    container_name: rocketchat-mongo
    restart: unless-stopped
    command: ["mongod", "--replSet", "rs0", "--bind_ip_all"]
    volumes:
      - mongodb_data:/data/db
    networks:
      - rocketchat
    healthcheck:
      test: ["CMD-SHELL", "mongosh --quiet mongodb://127.0.0.1:27017/admin --eval 'db.runCommand({ ping: 1 }).ok' | grep -q 1"]
      interval: 10s
      timeout: 10s
      retries: 30
      start_period: 60s

  mongodb-init:
    image: docker.xuanyuan.run/library/mongo:8.0
    container_name: rocketchat-mongo-init
    depends_on:
      mongodb:
        condition: service_healthy
    networks:
      - rocketchat
    restart: "no"
    entrypoint:
      - bash
      - -ec
      - |
        echo "=====> waiting for mongo then initiate rs0"
        for i in $$(seq 1 60); do
          if mongosh --quiet mongodb://mongodb:27017/admin --eval 'db.runCommand({ ping: 1 }).ok' | grep -q 1; then
            break
          fi
          sleep 2
        done
        mongosh --quiet mongodb://mongodb:27017/admin --eval '
          try { rs.status().ok }
          catch (e) {
            rs.initiate({ _id: "rs0", members: [{ _id: 0, host: "mongodb:27017" }] })
          }
        '
        echo "=====> replica set ready"

  nats:
    image: docker.xuanyuan.run/library/nats:2.11-alpine
    container_name: rocketchat-nats
    restart: unless-stopped
    command: ["--http_port", "8222"]
    networks:
      - rocketchat

  rocketchat:
    image: docker.xuanyuan.run/rocketchat/rocket.chat:8.6.1
    container_name: rocketchat
    restart: unless-stopped
    depends_on:
      mongodb-init:
        condition: service_completed_successfully
      nats:
        condition: service_started
    ports:
      - "3001:3000"
    environment:
      ROOT_URL: http://192.168.1.10:3001
      PORT: "3000"
      MONGO_URL: mongodb://mongodb:27017/rocketchat?replicaSet=rs0
      TRANSPORTER: nats://nats:4222
      DEPLOY_METHOD: docker
      DEPLOY_PLATFORM: compose
    volumes:
      - uploads_data:/app/uploads
    networks:
      - rocketchat

networks:
  rocketchat:

volumes:
  mongodb_data:
  uploads_data:
```

| 访问场景 | ROOT_URL 示例 |
|----------|----------------|
| 本机 | `http://localhost:3001` |
| 局域网 | `http://192.168.1.10:3001`（本文） |
| HTTPS 反代 | `https://chat.example.com` |

YAML 缩进错误会导致 `could not find expected ':'`，保存后可用编辑器校验再启动。

### 5.3 启动与验证

```bash
docker compose up -d
docker compose ps -a
```

实测成功时大致为：

```text
✔ Network rocketchat_rocketchat     Created
✔ Volume "rocketchat_mongodb_data"  Created
✔ Volume "rocketchat_uploads_data"  Created
✔ Container rocketchat-mongo        Healthy
✔ Container rocketchat-nats         Started
✔ Container rocketchat-mongo-init   Exited
✔ Container rocketchat              Started
```

| 容器 | 期望状态 |
|------|----------|
| `rocketchat-mongo` | Up (healthy) |
| `rocketchat-nats` | Up |
| `rocketchat-mongo-init` | **Exited (0)**（一次性初始化副本集，正常） |
| `rocketchat` | Up，`0.0.0.0:3001->3000/tcp` |

首次启动可能要 **1～3 分钟**。日志：

```bash
docker compose logs -f rocketchat
docker compose logs -f mongodb
```

Mongo 正常会出现 `Listening on` / `Waiting for connections`，随后 init 完成 `rs.initiate`，Rocket.Chat 连上库后即可访问。

---

## 六、浏览器安装向导

浏览器打开 `ROOT_URL`（本文 `http://192.168.1.10:3001`）。

### 6.1 管理员信息（第 1 / 4 步）

填写姓名、用户名、邮箱、密码。密码规则较严（长度、大小写、数字、符号等），按页面提示设置。

![Rocket.Chat 向导：填写管理员姓名用户名邮箱密码](https://img.xuanyuan.dev/docker/blog/rocketchat-1.webp)

*图 1：第 1 步「管理员信息」*

### 6.2 组织信息（第 2 / 4 步）

填写组织名称、行业、规模、国家。

![Rocket.Chat 向导：组织信息](https://img.xuanyuan.dev/docker/blog/rocketchat-2.webp)

*图 2：第 2 步「组织信息」*

### 6.3 注册工作区：在线或离线

向导会引导把工作区注册到 [Rocket.Chat Cloud](https://cloud.rocket.chat/)，以启用推送、Marketplace 等能力。

**在线路径**会出现「等待确认 / 安全码」页：

![Rocket.Chat 向导：等待邮件确认安全码](https://img.xuanyuan.dev/docker/blog/rocketchat-3.webp)

*图 3：在线注册「等待确认」*

**离线路径**（内网或 Cloud 邮件不畅时）：本地生成 Token A，到 Cloud 换 Token B，再贴回本地。

![Rocket.Chat 离线注册：复制本地 Token](https://img.xuanyuan.dev/docker/blog/rocketchat-4.webp)

*图 4：离线注册——复制本地 Token 并同意条款*

---

## 七、Rocket.Chat Cloud 账号与离线换码（重点）

### 7.1 必须先注册 Cloud 账号

实测结论：

> **必须先在 Cloud 完成「注册账号」，之后 magic-link 登录邮件才会正常发出。**  
> 未注册就直接走「Send login link」时，页面会显示已发信，邮箱往往**收不到**（Resend / 换邮箱也无效）。

正确顺序：

1. 打开 [https://cloud.rocket.chat](https://cloud.rocket.chat/)
2. 点 **Create account / 注册**（不要先只走 Login）
3. 用**可正常收信的邮箱**（优先自有域名企业邮；Gmail / QQ 等免费邮容易失败）
4. 注册完成后再用同一邮箱登录

![Rocket.Chat Cloud 登录页：需先 Create account](https://img.xuanyuan.dev/docker/blog/rocketchat-5.webp)

*图 5：Cloud Login——新用户点 Create account*

登录成功后若走 magic-link，会看到已发信提示：

![Cloud 提示已发送登录链接](https://img.xuanyuan.dev/docker/blog/rocketchat-6.webp)

*图 6：We emailed you a login link*

### 7.2 离线换码两步

登录 Cloud 后：**Workspaces** → **Register self-managed** → **Continue offline**。

**Step 1**：把本地 Token A 贴进 Cloud：

![Cloud：粘贴本地 Token 后 Continue](https://img.xuanyuan.dev/docker/blog/rocketchat-7.webp)

*图 7：Register Offline Workspace Step 1*

**Step 2**：复制 Cloud 生成的 Token B（**务必立刻复制**，离开后无法再看）：

![Cloud：复制 response code](https://img.xuanyuan.dev/docker/blog/rocketchat-8.webp)

*图 8：Step 2——Copy generated code（只显示一次）*

回到本地向导，粘贴 Token B，点 **完成注册**：

![本地粘贴 Cloud Token 并完成注册](https://img.xuanyuan.dev/docker/blog/rocketchat-9.webp)

*图 9：本地「完成注册」*

若按钮一直灰色：清空后完整重贴、点输入框外失焦、换浏览器；Token 极长，粘贴不全最常见。敏感操作可能要求再输一次管理员密码：

![敏感操作再次验证密码](https://img.xuanyuan.dev/docker/blog/rocketchat-10.webp)

*图 10：请输入您的密码*

离线注册会失去部分 Cloud 在线能力（推送、Marketplace 等）；服务器能稳定访问外网时，优先在线注册更省事。官方说明：[Air-gapped Workspace Registration](https://docs.rocket.chat/docs/air-gapped-workspace-registration)。

---

## 八、进入工作区：怎么用

### 8.1 Home 首页

注册完成后进入 Home，可见欢迎语与入门卡片（添加用户、创建频道、移动 / 桌面客户端、文档等）。

![Rocket.Chat Home 首页入门建议](https://img.xuanyuan.dev/docker/blog/rocketchat-11.webp)

*图 11：Home——欢迎与入门建议*

### 8.2 管理用户

打开 **管理 → 用户**：邀请、新建用户，查看角色与座位占用。

![管理面板：用户列表](https://img.xuanyuan.dev/docker/blog/rocketchat-12.webp)

*图 12：管理 → 用户*

### 8.3 创建频道

在界面中创建频道：名称勿含空格或特殊字符；可设话题、成员，「私人」开关控制是否仅邀请加入。

![创建频道对话框](https://img.xuanyuan.dev/docker/blog/rocketchat-13.webp)

*图 13：创建频道*

### 8.4 目录与默认频道

**目录 → 频道** 可浏览公开频道；新工作区通常自带 `#general`。

![目录：频道列表与 general](https://img.xuanyuan.dev/docker/blog/rocketchat-14.webp)

*图 14：目录中的 #general*

### 8.5 移动端

Home 入门卡片可跳转应用商店；Android 可在 Google Play 搜索 **Rocket.Chat** 安装，登录时填写你的工作区 URL（与 `ROOT_URL` 一致）。

![Google Play：Rocket.Chat 移动应用](https://img.xuanyuan.dev/docker/blog/rocketchat-15.webp)

*图 15：Google Play 上的 Rocket.Chat*

### 8.6 布局与外观

**管理 → 布局** 可自定义主页内容、登录页、自定义 CSS / 脚本等。

![管理：布局设置](https://img.xuanyuan.dev/docker/blog/rocketchat-16.webp)

*图 16：管理 → 布局*

---

## 九、日常运维

```bash
cd ~/docker/rocketchat   # 或你的目录

docker compose logs -f rocketchat
docker compose restart rocketchat
docker compose down          # 停容器，保留 volume
# docker compose down -v     # 危险：清空 Mongo 与上传数据

# 升级（先备份！）
# 1) 改 image 标签  2) docker compose pull rocketchat && docker compose up -d rocketchat
```

生产建议：Nginx / Traefik 终结 HTTPS，`ROOT_URL` 改为 `https://…`；限制 Mongo 仅内网；定期备份 `mongodb_data` 卷。更完整栈可参考官方 [rocketchat-compose](https://github.com/RocketChat/rocketchat-compose)（含 Traefik、监控等）。

---

## 十、FAQ

**Q：`rocketchat-mongo is unhealthy`，日志有 AVX？**  
A：CPU 不支持 AVX。换支持 AVX 的机器，或确认虚拟机未隐藏 CPU flags。不要用 mongo:4.4 配 RC 8.x。

**Q：magic-link 提示已发信但永远收不到？**  
A：先在 Cloud **注册账号**，再登录。未注册时常见「假发信」。优先企业域名邮箱。

**Q：「完成注册」按钮灰色？**  
A：Token B 极长，粘贴易截断。清空重贴、失焦、换浏览器；必要时在 Cloud 重新生成（旧码只显示一次）。

**Q：页面打不开或 WebSocket 异常？**  
A：`ROOT_URL` 必须与浏览器地址完全一致（含端口）。

**Q：macOS 要改 Compose 吗？**  
A：服务定义不用改；改目录、`ROOT_URL`，用 Docker Desktop，勿强行 `platform: linux/amd64`（Apple Silicon），继续用 named volume。

**Q：YAML 报 `could not find expected ':'`？**  
A：缩进或引号错误，对照上文完整文件检查。

---

## 十一、命令速查

```bash
# 登录轩辕（未登录时）
echo "镜像密码" | docker login -u 镜像账户 --password-stdin docker.xuanyuan.run

docker pull docker.xuanyuan.run/rocketchat/rocket.chat:8.6.1
docker pull docker.xuanyuan.run/library/mongo:8.0
docker pull docker.xuanyuan.run/library/nats:2.11-alpine

cd ~/docker/rocketchat
docker compose up -d
docker compose ps -a
docker compose logs -f rocketchat
```

访问：`http://你的IP:3001`

---

## 十二、延伸阅读

- [rocketchat/rocket.chat 镜像页](https://xuanyuan.cloud/zh/r/rocketchat/rocket.chat)
- [镜像标签列表](https://xuanyuan.cloud/r/rocketchat/rocket.chat/tags)
- [官方 Docker Compose 部署](https://docs.rocket.chat/docs/deploy-with-docker-docker-compose)
- [离线 / 气隙注册](https://docs.rocket.chat/docs/air-gapped-workspace-registration)
- [Rocket.Chat GitHub](https://github.com/RocketChat/Rocket.Chat)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)
- [agents.md（AI 拉取规范）](https://xuanyuan.cloud/agents.md)


