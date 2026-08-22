# Docker 部署 Harness Open Source：轻松搭建代码托管与 CI/CD 平台

![Docker 部署 Harness Open Source：轻松搭建代码托管与 CI/CD 平台](https://assets.xuanyuan.me/docker/blog/harness.webp)

*分类: Docker部署教程 | 标签: Harness Open Source,Gitness,Docker,轩辕镜像,Git,CI/CD,代码托管,私有化部署,部署教程 | 发布时间: 2026-08-18 12:14:10*

> 小团队自建代码托管，常见拆法是 Gitea / GitLab 管仓库，再另起 Jenkins、Drone 或一套 Runner 跑构建。Webhook、权限和备份各管各的，出问题要在两套后台之间对账。源码和制品若不能出内网，公有云托管按席位计费，完整企业 DevOps 套件又往往过重。更常见的目标是：**一台机器上同时有 Git、流水线和制品入口**，浏览器能管，数据落在自己的磁盘。

*本文基于 [harness/harness:3.3.0](https://xuanyuan.cloud/zh/r/harness/harness)，实测版本 **3.3.0**，测试平台 **Ubuntu 24.04** Linux。*

小团队自建代码托管，常见拆法是 Gitea / GitLab 管仓库，再另起 Jenkins、Drone 或一套 Runner 跑构建。Webhook、权限和备份各管各的，出问题要在两套后台之间对账。

源码和制品若不能出内网，公有云托管按席位计费，完整企业 DevOps 套件又往往过重。更常见的目标是：**一台机器上同时有 Git、流水线和制品入口**，浏览器能管，数据落在自己的磁盘。

**Harness Open Source**（镜像 **`harness/harness`**，[镜像页](https://xuanyuan.cloud/zh/r/harness/harness)）把代码仓库、CI/CD、Gitspaces 与制品 registry 放在同一套自托管服务里。前身社区名 **Gitness**，所以环境变量仍是 **`GITNESS_*`**，欢迎页也会出现 Gitness 字样。本文只跟做 Docker 自托管，不安装 [harness.io](https://www.harness.io/) 商业平台，也不拉 **`harness/delegate`**。产品介绍见 [Harness Open Source](https://www.harness.io/open-source)。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 私有 Git | 建 Project / Repository，HTTP 或 SSH 克隆 |
| 内置 CI/CD | 挂载 docker.sock 后，流水线步骤用宿主机 Docker 执行 |
| 制品与开发环境 | 侧栏进入 Artifact Registries、Gitspaces（实测已打开入口页） |
| 团队权限 | 首个注册用户为项目 Owner，再邀请成员 |

本文用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`harness/harness:3.3.0`**，以 **Docker Compose** 启动；文末附 **`docker run` 备选**。Ubuntu 实测访问 **`http://192.168.1.251:13300`**，文内附 **10** 张截图。

> **上手要点**  
> - **部署**：默认 **Compose**（第五节）；无 Compose 时见 **第九节**  
> - **标签**：**`3.3.0`**（勿把 `latest` / `unstable` 写入跟做命令）  
> - **端口**：宿主机 **13300 → 容器 3000**（Web / HTTP Git）；**3022 → 3022**（SSH Git）  
> - **数据卷**：`./data` → **`/data`**  
> - **流水线**：挂载 **`/var/run/docker.sock`**（权限等同操作宿主机 Docker）  
> - **访问地址**：`GITNESS_URL_BASE` 必须与浏览器地址一致（局域网勿写 `127.0.0.1`）  
> - **账号**：无默认密码；先点登录页 **No Account? Sign Up**  

镜像：[harness/harness](https://xuanyuan.cloud/zh/r/harness/harness) · [tags](https://xuanyuan.cloud/r/harness/harness/tags)。文档：[Get Started](https://developer.harness.io/docs/open-source/installation/quick-start) · [Configurations](https://developer.harness.io/docs/open-source/installation/settings) · [Data](https://developer.harness.io/docs/open-source/installation/data)。源码：[GitHub · harness/harness](https://github.com/harness/harness)。许可证：**Apache-2.0**（含第三方组件，商用请自行核对）。

---

## 一、Harness Open Source 是什么？

同一容器里提供 Web 控制台、HTTP/SSH Git，以及流水线（经 docker.sock 调宿主机 Docker）。默认用 SQLite 把元数据写在 **`/data`**，仓库也在该目录下；团队规模上去可改外置 Postgres。

| | Harness Open Source（本文） | GitLab CE | Gitea / Forgejo + 外置 CI |
|--|-----------------------------|-----------|---------------------------|
| 定位 | Git + CI + 制品/Gitspaces 入口，单容器即可起 | 完整 DevOps 全家桶 | 轻量 Git，流水线另配 |
| 适合 | 小团队先跑通一体机 | 已有 GitLab 运维能力 | 只要托管代码 |

同一组织下 **`harness/delegate`** 是商业平台的执行器，**不要**当成 Open Source 主服务来拉。`/r/`、`/zh/r/`、`/tags` 是同一镜像的不同页面。

```text
浏览器 / git HTTP  ──:13300──▶  容器内 :3000
git SSH            ──:3022──▶  SSH（GITNESS_SSH_ENABLE=true）
宿主机 ./data      ──挂载──▶  /data
docker.sock        ──挂载──▶  流水线在宿主机上起临时容器
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 内存 | ≥ **2 GB** 可用；跑流水线时再给构建镜像留余量 |
| 磁盘 | 镜像实测 DISK USAGE 约 **315 MB**（CONTENT SIZE 约 **86.1 MB**）；`./data` 随仓库增长 |
| 架构 | 实测 **amd64**；其它架构先查 [tags](https://xuanyuan.cloud/r/harness/harness/tags) |
| 端口 | 宿主机 **13300**、**3022** |
| 权限 | 要用流水线就必须能访问 **docker.sock** |

```bash
docker --version
docker compose version
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

容器内默认监听 **3000**。教程改映 **`13300:3000`**，避免和本机前端开发抢口。浏览器一律访问 `http://服务器IP:13300`。

---

## 三、标签怎么选

撰写时 **`3.3.0`** 是最新固定发布版（当时与 `latest` 同源）。跟做命令只写 **`3.3.0`**。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`3.3.0`** | 固定发布版 | **本文跟做** |
| `3.2.0` 等 | 更旧发布版 | 回滚或兼容旧数据 |
| `latest` | 浮动 | **勿写入跟做命令** |
| `unstable` / `unstable-uiv2` | 开发线 | 生产勿用 |
| `3.0.0-beta.*` | 历史 Beta | 勿作默认 |

完整列表：[tags](https://xuanyuan.cloud/r/harness/harness/tags)。升级时 pull、Compose、`docker run` **三处一起改标签**，并先备份 `./data`。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/harness/harness:3.3.0
```

Ubuntu 24.04 实测：

```text
3.3.0: Pulling from harness/harness
8a10a787d84d: Pull complete
0596a995cde5: Pull complete
c29519fc98c7: Pull complete
9824c27679d3: Pull complete
845c0ff8b041: Pull complete
f788310835d1: Pull complete
d8dd7b853280: Download complete
Digest: sha256:c1bd76817ad7d2e7d78827653a54c55d4aec87c2777a586ebbad1ed01fc9e83f
Status: Downloaded newer image for docker.xuanyuan.run/harness/harness:3.3.0
docker.xuanyuan.run/harness/harness:3.3.0
```

```bash
docker images docker.xuanyuan.run/harness/harness:3.3.0
```

```text
IMAGE                                       ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/harness/harness:3.3.0   c1bd76817ad7        315MB         86.1MB
```

---

## 五、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/harness` |
| **macOS 实测** | **`~/docker/harness`** |

### 5.1 创建目录

```bash
mkdir -p /www/wwwroot/harness/data
chown -R "$USER:$USER" /www/wwwroot/harness
cd /www/wwwroot/harness
```

非 root 时给 `mkdir` / `chown` 加 `sudo`。

### 5.2 编写 docker-compose.yml

**`GITNESS_URL_BASE`** 写成浏览器实际打开的地址（含协议和宿主机端口）。局域网示例与实测一致：`http://192.168.1.251:13300`；只在本机开浏览器时才用 `http://127.0.0.1:13300`；有域名则写 `https://git.example.com`（见 [custom DNS](https://developer.harness.io/docs/open-source/installation/dns)）。

生成加密密钥，填进 `GITNESS_ENCRYPTER_SECRET`（**改密钥后旧密文无法解密**，也勿把别人的密钥抄进自己的 Compose）：

```bash
openssl rand -hex 16
```

```bash
cat > docker-compose.yml <<'EOF'
services:
  harness:
    image: docker.xuanyuan.run/harness/harness:3.3.0
    container_name: harness
    restart: unless-stopped
    ports:
      - "13300:3000"
      - "3022:3022"
    volumes:
      - ./data:/data
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - TZ=Asia/Shanghai
      - GITNESS_URL_BASE=http://192.168.1.251:13300
      - GITNESS_HTTP_PORT=3000
      - GITNESS_SSH_ENABLE=true
      - GITNESS_SSH_PORT=3022
      - GITNESS_USER_SIGNUP_ENABLED=true
      - GITNESS_URL_CONTAINER=http://host.docker.internal:13300
      - GITNESS_ENCRYPTER_SECRET=换成 openssl rand -hex 16 的输出
    extra_hosts:
      - "host.docker.internal:host-gateway"
EOF
```

把 `GITNESS_URL_BASE` 里的 IP 换成你的宿主机地址。`GITNESS_URL_CONTAINER` 给流水线容器回连本服务用，与宿主机发布口 **13300** 对齐；`extra_hosts` 让 Linux 能解析 `host.docker.internal`。

| 配置项 | 说明 |
|--------|------|
| `13300:3000` | Web 与 HTTP Git |
| `3022:3022` | SSH Git（已开 `GITNESS_SSH_ENABLE`） |
| `./data:/data` | 官方数据目录 |
| `docker.sock` | 流水线用；公网不要裸暴露 Web |

### 5.3 启动服务

```bash
docker compose pull
docker compose up -d
docker compose ps
docker compose logs -f --tail 100
```

Ubuntu 实测：

```text
[+] up 2/2
 ✔ Network harness_default Created
 ✔ Container harness       Started

NAME      IMAGE                                       COMMAND                 SERVICE   CREATED          STATUS          PORTS
harness   docker.xuanyuan.run/harness/harness:3.3.0   "/app/gitness server"   harness   55 seconds ago   Up 52 seconds   0.0.0.0:3022->3022/tcp, [::]:3022->3022/tcp, 0.0.0.0:13300->3000/tcp, [::]:13300->3000/tcp
```

首次启动会跑一串 SQLite migrate。看到下面几行即可 `Ctrl+C` 退出跟踪：

```text
{"level":"info","time":"...","message":"Completed setup of system service 'gitness' (id: 1)."}
{"level":"info","time":"...","message":"Completed setup of pipeline service 'pipeline' (id: 2)."}
{"level":"info","time":"...","message":"Completed setup of gitspace service 'gitspace' (id: 3)."}
{"level":"info","host":"","port":3000,"revision":"","repository":"","version":"3.3.0","time":"...","message":"server started"}
```

启动时还可能出现：未设 `GITNESS_REGISTRY_HTTP_SECRET` 的 warn，以及拉取 GitHub plugins zip 超时（`could not populate plugins`）。二者**不挡** Web 起来，说明见 FAQ。

本机探测：

```bash
curl -sI http://127.0.0.1:13300 | head -n 5
```

期望 **HTTP 200** 或 **302**。局域网用 **`http://宿主机IP:13300`**（实测 `http://192.168.1.251:13300`），不要用容器网桥 IP。改过环境变量后执行 `docker compose up -d` 才会生效。

---

## 六、浏览器首次初始化

### 6.1 打开地址

| 方式 | 地址 |
|------|------|
| 本机 | `http://127.0.0.1:13300` |
| 局域网 | `http://服务器IP:13300`（实测 **`http://192.168.1.251:13300`**） |

首次会落到 **Sign In**（`/signin`）。没有内置账号，右侧是 **Email / User ID** 和 **Password**。点标题旁 **No Account? Sign Up**，不要在登录框试 `admin`。

![Harness Open Source 登录页 Sign In：左侧 Open Source DevOps 介绍，右侧 Email / User ID 与 Password](https://assets.xuanyuan.me/docker/blog/harness-1.webp)

### 6.2 注册

填写 **User ID**、**Email**、**Password**、**Confirm Password**，点 **Sign Up**。已有账号则走「Already have an account? Sign In」。

公开注册由 `GITNESS_USER_SIGNUP_ENABLED=true` 打开。上线后如何关掉并预置管理员，见第八节。

![Harness Open Source 注册页 Sign Up：填写 User ID、Email、Password 与 Confirm Password](https://assets.xuanyuan.me/docker/blog/harness-2.webp)

### 6.3 新建项目

注册后进入欢迎页。文案仍是 **get you started with Gitness**。侧栏底部是当前用户（实测 **xuanyuan**），中间点 **+ New Project**。

![Harness Open Source 欢迎页：Welcome xuanyuan、提示创建 Project、蓝色 + New Project](https://assets.xuanyuan.me/docker/blog/harness-3.webp)

**Create a project** 填 **Name**（实测 `xuanyuan-cloud`）和可选 **Description**（实测「轩辕镜像」），再点 **Create Project**。

![Harness Open Source 创建项目对话框：Name xuanyuan-cloud、Description 轩辕镜像、Create Project](https://assets.xuanyuan.me/docker/blog/harness-4.webp)

侧栏会出现项目名，以及 Repositories、Artifact Registries、Gitspaces 等菜单。

---

## 七、主界面与核心功能

克隆地址里的主机名来自 **`GITNESS_URL_BASE`**。官方入门是先建仓库，再写流水线，见 [Get Started](https://developer.harness.io/docs/open-source/installation/quick-start)。

### 7.1 Repositories

默认打开 **Repositories**。空项目提示 *There are no repositories in this project*。点 **+ New Repository** 新建；按钮下拉可导入已有 Git 仓库。页面给出的 HTTP / SSH 地址应带你的 IP 或域名和 **13300** / **3022**，而不是 `localhost:3000`。

![Harness Open Source 项目 xuanyuan-cloud 的 Repositories 空状态：+ New Repository](https://assets.xuanyuan.me/docker/blog/harness-5.webp)

### 7.2 Artifact Registries / Gitspaces / Secrets

侧栏另外三个入口，实测均可打开：

- **Artifact Registries**：空状态 *There are no registries available*，**+ New Artifact Registry**。可按 Registry Type、Package Types 筛选。  
- **Gitspaces**：介绍页说明从 Git 克隆、在环境里构建调试，并可连 VS Code；点 **Get Started Now**。能否真正起开发环境还取决于本机 Docker 与出网，本文只确认页面可访问。  
- **Secrets**：空状态 *There are no secrets*，**+ New Secret**。流水线要用的 Token 放这里。加密依赖 `GITNESS_ENCRYPTER_SECRET`。

![Harness Open Source Artifact Registries 空状态：+ New Artifact Registry](https://assets.xuanyuan.me/docker/blog/harness-6.webp)

![Harness Open Source Gitspaces 介绍页：克隆代码、Build Test Debug、连接 VS Code](https://assets.xuanyuan.me/docker/blog/harness-7.webp)

![Harness Open Source Secrets 空状态：There are no secrets、+ New Secret](https://assets.xuanyuan.me/docker/blog/harness-8.webp)

### 7.3 Members 与 Settings

**Members** 列出项目角色。实测首个用户 **xuanyuan** 为 **Owner**。协作点 **+ Add Member**。实例级账号在侧栏底部 **User Management**。

![Harness Open Source Members：用户 xuanyuan 角色 Owner](https://assets.xuanyuan.me/docker/blog/harness-9.webp)

**Settings → General** 可改 Name / Description。**Upgrade to Harness** 指向商业软件交付平台，不是再装一遍本文镜像。底部 **Delete Project** 会删掉项目及其中全部仓库。另有 **Labels**、**Rules** 两个标签页。

![Harness Open Source 项目 Settings General：xuanyuan-cloud、轩辕镜像、Upgrade to Harness 与 Delete Project](https://assets.xuanyuan.me/docker/blog/harness-10.webp)

---

## 八、生产加固

公网或多人共用时，在 Compose 的 `environment` 里至少补这几项（改完 `docker compose up -d`）：

```yaml
      - GITNESS_USER_SIGNUP_ENABLED=false
      - GITNESS_PRINCIPAL_ADMIN_EMAIL=mail@example.com
      - GITNESS_PRINCIPAL_ADMIN_PASSWORD=换成足够长的强密码
```

`GITNESS_PRINCIPAL_ADMIN_EMAIL` 与 `GITNESS_PRINCIPAL_ADMIN_PASSWORD` **必须成对出现**。已有数据目录时，不要指望改这两项会覆盖已经注册的 Owner，需在界面里管理用户。

| 项 | 做法 |
|----|------|
| HTTPS | 反代终止 TLS，并把 `GITNESS_URL_BASE` 写成 `https://域名` |
| docker.sock | 只在可信网络使用；Web 口加来源限制 |
| 防火墙 | 仅放行可信来源访问 **13300**、**3022** |
| 制品上传（多实例） | 各节点设置相同的 `GITNESS_REGISTRY_HTTP_SECRET` |
| 数据库 | 共享实例可改 Postgres：`GITNESS_DATABASE_DRIVER` / `GITNESS_DATABASE_DATASOURCE` |
| 备份 | 定期备份 **`./data`** |

变量全集：[Configurations](https://developer.harness.io/docs/open-source/installation/settings)。

---

## 九、备选：docker run

仅临时试玩或没有 Compose 时使用。把 `GITNESS_URL_BASE` 和密钥换成你自己的值。

```bash
mkdir -p /www/wwwroot/harness/data
cd /www/wwwroot/harness

docker run -d \
  --name harness \
  --restart unless-stopped \
  -p 13300:3000 \
  -p 3022:3022 \
  -e TZ=Asia/Shanghai \
  -e GITNESS_URL_BASE=http://192.168.1.251:13300 \
  -e GITNESS_HTTP_PORT=3000 \
  -e GITNESS_SSH_ENABLE=true \
  -e GITNESS_SSH_PORT=3022 \
  -e GITNESS_USER_SIGNUP_ENABLED=true \
  -e GITNESS_URL_CONTAINER=http://host.docker.internal:13300 \
  -e GITNESS_ENCRYPTER_SECRET=换成 openssl rand -hex 16 的输出 \
  --add-host=host.docker.internal:host-gateway \
  -v /www/wwwroot/harness/data:/data \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker.xuanyuan.run/harness/harness:3.3.0
```

与 Compose 容器重名时先 `docker compose down` 或换 `--name`。

---

## 十、迁移 / 升级

1. `docker compose stop`，备份整个 **`./data`**。  
2. 改 Compose 标签为新版号，先查 [tags](https://xuanyuan.cloud/r/harness/harness/tags) 与上游说明。  
3. `docker compose pull && docker compose up -d`。  
4. 登录后抽查项目列表、克隆地址；有流水线再跑一条。  
5. 异常则改回旧标签 `up -d`，必要时从备份恢复 `./data`。

不要在未备份时用 `unstable` 覆盖生产数据目录。

---

## 十一、常见问题 FAQ

**Q1：和 harness.io、harness/delegate 是一回事吗？**  
不是。跟做镜像是 **`harness/harness`**。Settings 里的 **Upgrade to Harness** 指向商业平台。

**Q2：环境变量为什么叫 GITNESS_*？欢迎页还写 Gitness？**  
产品前身是 Gitness，键名和部分文案没改完。

**Q3：打不开 `http://IP:13300`？**  
看 `docker compose ps` / `logs` 是否已 `server started`；映射是否为 **`13300:3000`**；防火墙是否放行。局域网用宿主机 IP，不要用网桥 IP。

**Q4：克隆 URL 里的主机不对？**  
改 **`GITNESS_URL_BASE`** 后 `docker compose up -d`。有域名见 [custom DNS](https://developer.harness.io/docs/open-source/installation/dns)。

**Q5：流水线起不来？**  
确认挂了 **docker.sock**、有 **`extra_hosts`**，且 **`GITNESS_URL_CONTAINER=http://host.docker.internal:13300`**。也可改用 `GITNESS_CI_CONTAINER_NETWORKS` 加容器名访问，见官方说明。

**Q6：SSH 克隆失败？**  
`GITNESS_SSH_ENABLE=true` 且映射了 **3022**；客户端用页面给出的 SSH URL。

**Q7：默认用户名密码是什么？**  
没有。`/signin` 只给已注册用户。第一次走 **Sign Up**。开发仓库 CLI 示例里的 `admin` / `changeit` 不适用于本镜像默认配置。要预置管理员用成对的 `GITNESS_PRINCIPAL_ADMIN_*`（见第八节）。

**Q8：数据会丢吗？**  
未挂卷就会丢。务必 **`./data:/data`**，并备份。见 [How to manage Data](https://developer.harness.io/docs/open-source/installation/data)。

**Q9：挂载 docker.sock 安全吗？**  
容器几乎能操作宿主机上所有容器。只给可信环境用，公网限制来源并尽快上 HTTPS、关掉公开注册。

**Q10：日志 `could not populate plugins`？**  
实测访问 `https://github.com/bradrydzewski/plugins/archive/refs/heads/master.zip` 发生 TLS 超时。只影响插件目录，**不挡** `server started`。需要插件时再解决出网或改 `GITNESS_CI_PLUGINS_ZIP_URL`。

**Q11：日志 `No HTTP secret provided`？**  
单机可忽略。多实例或负载均衡时设相同的 **`GITNESS_REGISTRY_HTTP_SECRET`**。

**Q12：拉取失败 401 / 402？**  
401：按 [登录认证](https://xuanyuan.cloud/usage/login) 检查镜像账户。402：流量用尽，需 [充值](https://xuanyuan.cloud/recharge)。其它见 [常见问题](https://xuanyuan.cloud/faq)。

---

## 十二、命令速查

```bash
docker pull docker.xuanyuan.run/harness/harness:3.3.0

cd /www/wwwroot/harness
docker compose up -d
docker compose ps
docker compose logs -f --tail 100

# 浏览器 http://服务器IP:13300 → Sign Up（无默认账号）

docker compose down
```

---

## 十三、延伸阅读

- [harness/harness 镜像页](https://xuanyuan.cloud/zh/r/harness/harness) · [标签列表](https://xuanyuan.cloud/r/harness/harness/tags)
- [Harness 官网](https://www.harness.io/) · [Open Source 产品页](https://www.harness.io/open-source)
- [Get Started](https://developer.harness.io/docs/open-source/installation/quick-start)
- [Configurations](https://developer.harness.io/docs/open-source/installation/settings)
- [How to manage Data](https://developer.harness.io/docs/open-source/installation/data)
- [Custom DNS](https://developer.harness.io/docs/open-source/installation/dns)
- [GitHub · harness/harness](https://github.com/harness/harness)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)

---

## 总结

- 跟做 **`harness/harness:3.3.0`**，Compose 映射 **13300→3000** 与 **3022**，挂载 **`./data`** 和 **docker.sock**。  
- **`GITNESS_URL_BASE`** 与浏览器地址一致；先 **Sign Up**，再 **New Project**。  
- 欢迎页和变量仍带 **Gitness** 旧名；不要去拉 **delegate**。  
- 公网关掉公开注册，保管 **`GITNESS_ENCRYPTER_SECRET`**，并备份 `./data`。

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/harness-docker-deploy


