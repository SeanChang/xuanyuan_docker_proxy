# Docker 部署 HertzBeat：轻松搭建无代理实时监控与告警平台

![Docker 部署 HertzBeat：轻松搭建无代理实时监控与告警平台](https://imgs.xuanyuan.cloud/docker/blog/hertzbeat.webp)

*分类: Docker部署教程 | 标签: HertzBeat,Apache HertzBeat,Docker,轩辕镜像,监控,告警,可观测性,私有化部署,部署教程 | 发布时间: 2026-09-01 13:37:41*

> 机房里 Nginx、MySQL、Redis、Kafka 各跑各的：有人盯 `ss`，有人刷厂商控制台，有人半夜被业务方电话叫醒才发现接口已经超时。想把可用性收拢到一处，常见路径是每台机装 Agent、配 Prometheus exporter，再串 Alertmanager 和钉钉脚本——规则散在 YAML 与 Wiki 里，交接时对账很慢。

*本文基于 [apache/hertzbeat:1.8.0](https://xuanyuan.cloud/zh/r/apache/hertzbeat)，实测引擎 **HertzBeat 1.8.0**，测试平台 **Ubuntu 24.04** Linux。*

机房里 Nginx、MySQL、Redis、Kafka 各跑各的：有人盯 `ss`，有人刷厂商控制台，有人半夜被业务方电话叫醒才发现接口已经超时。想把可用性收拢到一处，常见路径是每台机装 Agent、配 Prometheus exporter，再串 Alertmanager 和钉钉脚本——规则散在 YAML 与 Wiki 里，交接时对账很慢。

另一层约束更硬：**指标、主机列表和故障详情最好留在自己的盘上**。公有云监控按探针计费，也不适合专有云 / 合规内网；纯开源拼装又变成「Prometheus + Grafana + Alertmanager + 机器人」四件套，学习和维护都不轻。很多团队其实已经有一台跑 Docker 的 Ubuntu，缺的只是镜像能拉、**1157** 能开、配置落在挂载目录。

**Apache HertzBeat**（[官网](https://hertzbeat.apache.org)、[GitHub · apache/hertzbeat](https://github.com/apache/hertzbeat)）把采集、告警、通知放进同一套 Web：**无代理**为主，浏览器里加网站 / 数据库 / 中间件等目标，协议可用 HTTP、JMX、SSH、SNMP、JDBC、Prometheus 等模板配置，告警可发到邮件、钉钉、飞书、Webhook。官方镜像 **`apache/hertzbeat`**（[镜像页](https://xuanyuan.cloud/zh/r/apache/hertzbeat)）默认 **1157**（Web）、**1158**（采集器通信），许可证 **Apache-2.0**。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 打开控制台 | `http://服务器IP:1157`，默认 **`admin` / `hertzbeat`** |
| 新建监控 | 例如 HTTP API 探官网、再扩到 MySQL / Linux |
| 配告警通知 | 阈值规则 + 钉钉 / 邮件等接收对象与策略 |
| 备份搬家 | 停容器后打包 `./data`（日志按需备份 `./logs`） |

本文用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`apache/hertzbeat:1.8.0`**，**Docker Compose** 映射 **1157 / 1158**。局域网示例 IP **`192.168.1.10`**，请换成你的地址。无 Compose 见第八节。文内附 **12** 张实测截图。

> **上手要点**
> - **部署**：第五节 Compose；临时试玩见第八节
> - **访问**：宿主机 **1157** → 容器 **1157**；**1158** → **1158**
> - **冷启动**：镜像 CONTENT **636MB** / DISK **1.72GB**；首次常需 **1～3 分钟**，等日志 **`Started HertzBeatApplication`** 再打开浏览器（过早访问会 `CONNECTION_REFUSED` / `curl` 得 `000`）
> - **数据**：`./data` → `/opt/hertzbeat/data`；`./logs` → `/opt/hertzbeat/logs`
> - **账号**：默认 **`admin` / `hertzbeat`**（另有 `tom` / `guest`）；登录后改密
> - **标签**：跟做 **`1.8.0`**，勿写 `latest` / `nightly`
> - **生产**：内置 H2 适合体验；长期建议 PostgreSQL + VictoriaMetrics 等方案（第七节）

官方说明：[Docker 安装](https://hertzbeat.apache.org/docs/start/docker-deploy) · [Docker Compose](https://hertzbeat.apache.org/docs/start/docker-compose-deploy) · [下载页](https://hertzbeat.apache.org/docs/download)

---

## 一、HertzBeat 是什么？

相对「先铺 exporter 再拼告警链」，HertzBeat 更偏 **浏览器里直接管监控与通知**：目标多数无需装 Agent（目标网络可达即可），告警通道也在同一控制台配置。

| | HertzBeat（本文） | Prometheus + Grafana + Alertmanager | 商业 APM / 云监控 |
|--|-------------------|-------------------------------------|-------------------|
| 入口 | 浏览器 `:1157` | 多组件分散配置 | 厂商控制台 |
| Agent | 无代理为主 | 常需 exporter | 探针 / Agent |
| 告警通知 | 内置阈值 + 多渠道 | Alertmanager 另配 | 厂商通道 |
| 数据 | 本机卷 / 可接外置库 | 自建时序库 | 厂商侧 |
| 适合 | 中小团队快速落地、内网合规 | 已有 Prometheus 生态 | 预算与厂商支持到位 |

```text
浏览器（监控 / 告警 / 状态页）
   │  :1157
   ▼
apache/hertzbeat
   ├── /opt/hertzbeat/data  ← ./data
   ├── /opt/hertzbeat/logs  ← ./logs
   └── :1158                ← 采集器集群（可选）
```

多网段或云边场景可再部署 **`apache/hertzbeat-collector`**，回连主服务 **1158**。本文主路径只跑 **`apache/hertzbeat` 单机**。[`/r/`](https://xuanyuan.cloud/r/apache/hertzbeat) 与 [`/zh/r/`](https://xuanyuan.cloud/zh/r/apache/hertzbeat) 是同一镜像的不同页面。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64 / arm64**（以 [tags](https://xuanyuan.cloud/r/apache/hertzbeat/tags) 为准） |
| 内存 | ≥ **2 GB** 可用；目标多再加 |
| 磁盘 | 镜像 CONTENT **636MB** / DISK **1.72GB** + `./data` 增长 |
| 端口 | **1157**、**1158**（冲突时改映射左侧） |

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
ss -tlnp | grep -E ':1157|:1158'
```

被占用时改为如 `"11157:1157"`、`"11158:1158"`，浏览器改访新的左侧端口。

---

## 三、标签怎么选

跟做使用 **`1.8.0`**。完整列表：[tags](https://xuanyuan.cloud/r/apache/hertzbeat/tags)。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`1.8.0`** | 稳定发行版（撰写时与 `latest` 同构建） | **本文跟做** |
| `1.7.3` / `1.7.x` | 上一大版本线 | 回滚或锁定 1.7 |
| `latest` | 浮动稳定线 | **勿写入跟做命令** |
| `nightly` | 每日构建 | **勿当教程 / 生产默认** |
| `v1.6.x` | 更早版本 | 仅兼容旧环境 |

升级前备份 `./data`，同步改 pull、Compose、`docker run` 三处标签，并核对 [Releases](https://github.com/apache/hertzbeat/releases)。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/apache/hertzbeat:1.8.0
```

Ubuntu 24.04 实测：

```text
1.8.0: Pulling from apache/hertzbeat
4f4fb700ef54: Pull complete
459abcfc7fd6: Pull complete
ea2da89a9958: Pull complete
a3629ac5b9f4: Pull complete
323ed809c33a: Pull complete
833ed0d46f70: Pull complete
50b8f0d04f35: Pull complete
7903badbd42c: Pull complete
8bd41871f58f: Pull complete
3b6c3453bfed: Pull complete
43965ea666d3: Pull complete
94c41261f18a: Download complete
Digest: sha256:75d48a62748fe42e4b2354e393ce567f51f7d46764b404763ec885cd23d74a0d
Status: Downloaded newer image for docker.xuanyuan.run/apache/hertzbeat:1.8.0
docker.xuanyuan.run/apache/hertzbeat:1.8.0
```

```bash
docker images docker.xuanyuan.run/apache/hertzbeat:1.8.0
```

```text
IMAGE                                        ID             DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/apache/hertzbeat:1.8.0   75d48a62748f       1.72GB          636MB
```

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `apache/hertzbeat:1.8.0` | `docker pull docker.xuanyuan.run/apache/hertzbeat:1.8.0` |

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq)。

---

## 五、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/hertzbeat` |
| **macOS** | **`~/docker/hertzbeat`** |
| **Windows（Docker Desktop）** | 如 `C:\docker\hertzbeat` |

对齐官方 [Docker 安装](https://hertzbeat.apache.org/docs/start/docker-deploy) 的数据与日志路径，用 Compose 管生命周期。单机内置 H2 **适合体验**；生产外置库见第七节。

### 5.1 准备目录

```bash
mkdir -p /www/wwwroot/hertzbeat/{data,logs}
cd /www/wwwroot/hertzbeat

# macOS：mkdir -p ~/docker/hertzbeat/{data,logs} && cd ~/docker/hertzbeat
```

非 root 给 `mkdir` 加 `sudo`。

> 本地还没有完整文件时，**不要**挂载 `application.yml` / `sureness.yml`——空文件会导致启动失败。需要自定义时先下载官方样例再挂（见 FAQ）。

### 5.2 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  hertzbeat:
    image: docker.xuanyuan.run/apache/hertzbeat:1.8.0
    container_name: hertzbeat
    restart: unless-stopped
    ports:
      - "1157:1157"
      - "1158:1158"
    environment:
      TZ: Asia/Shanghai
      LANG: en_US.UTF-8
    volumes:
      - ./data:/opt/hertzbeat/data
      - ./logs:/opt/hertzbeat/logs
EOF
```

| 项 | 说明 |
|----|------|
| `1157:1157` | Web UI |
| `1158:1158` | 采集器通信 |
| `./data` | 内置 H2 与监控配置 |
| `./logs` | 应用日志 |
| `TZ` | `Asia/Shanghai` |
| `1.8.0` | 具体版本；升级只改标签 |

### 5.3 启动并验证

```bash
docker compose up -d
docker compose ps
```

Ubuntu 24.04 实测：

```text
[+] Running 2/2
 ✔ Network hertzbeat_default  Created
 ✔ Container hertzbeat        Started
```

```text
NAME        IMAGE                                        COMMAND                 SERVICE     CREATED         STATUS         PORTS
hertzbeat   docker.xuanyuan.run/apache/hertzbeat:1.8.0   "./bin/entrypoint.sh"   hertzbeat   7 seconds ago   Up 5 seconds   22/tcp, 0.0.0.0:1157-1158->1157-1158/tcp, [::]:1157-1158->1157-1158/tcp
```

容器 **Up** 只说明进程在跑，**不等于** Web 已监听。跟日志直到出现启动完成行：

```bash
docker compose logs -f hertzbeat
```

启动中会先出现横幅与 Spring 初始化（节选）：

```text
hertzbeat  |   _   _           _       ____             _
hertzbeat  |  | | | | ___ _ __| |_ ___| __ )  ___  __ _| |_
hertzbeat  |  | |_| |/ _ \ '__| __|_  /  _ \ / _ \/ _` | __|        Profile: prod
hertzbeat  |  |  _  |  __/ |  | |_ / /| |_) |  __/ (_| | |_         Name: a91d49c8649311 Port: 1157 Pid: 11
hertzbeat  |  |_| |_|\___|_|   \__/___|____/ \___|\__,_|\__|        https://hertzbeat.apache.org/
hertzbeat  |
hertzbeat  | 2026-09-01 20:34:19 [main] INFO  ... HertzBeatApplication - Starting HertzBeatApplication v2.0-SNAPSHOT using Java 21.0.10 with PID 11 (/opt/hertzbeat/apache-hertzbeat-1.8.0.jar ...)
hertzbeat  | 2026-09-01 20:34:19 [main] INFO  ... HertzBeatApplication - The following 1 profile is active: "prod"
hertzbeat  | 2026-09-01 20:34:26 [main] INFO  ... RepositoryConfigurationDelegate - Bootstrapping Spring Data JPA repositories in DEFAULT mode.
```

> 日志里的 **`v2.0-SNAPSHOT`** 是应用内部版本串；镜像标签与 jar 名仍是 **`1.8.0`**，登录页脚也显示 **v1.8.0**。以镜像 tag / 页脚为准即可。

继续等到类似：

```text
Started HertzBeatApplication in xx.xxx seconds
```

常见约 **1～3 分钟**（内存紧会更慢）。`Ctrl+C` 只退出日志跟踪，不停容器。

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:1157
```

未就绪时常为 **`000`**；就绪后实测：

```text
200
```

浏览器打开（换成你的 IP，勿用 `172.x` 容器地址）：

```text
http://192.168.1.10:1157
```

---

## 六、浏览器首次登录与体验

### 6.1 登录

页脚可见 **Apache HertzBeat™ v1.8.0**。

| 项 | 值 |
|----|-----|
| 用户名 | `admin` |
| 密码 | `hertzbeat` |

另有 `tom` / `guest`（密码同为 `hertzbeat`）。登录后请到用户管理改密；生产勿把 1157 裸暴露公网。

![HertzBeat 登录页：admin 账号与 v1.8.0 页脚](https://imgs.xuanyuan.cloud/docker/blog/hertzbeat-1.webp)

### 6.2 欢迎弹窗与仪表盘

首次登录会弹出 **Welcome**（版本 **v1.8.0**），关闭后进左侧导航。

![HertzBeat 首次登录 Welcome 弹窗：v1.8.0 能力介绍](https://imgs.xuanyuan.cloud/docker/blog/hertzbeat-2.webp)

**仪表盘**可见监控分类、标签云、类型占比，以及默认采集器 **main-default-collector**；底部是最近告警。

![HertzBeat 仪表盘：监控分类卡片与 main-default-collector](https://imgs.xuanyuan.cloud/docker/blog/hertzbeat-3.webp)

### 6.3 监控中心：新增 HTTP API

进入 **监控 → 监控中心**，点 **新增 HTTP API**（或 **新增监控**）添加网站 / 接口探测。目标机**不必装 Agent**，但须能被 HertzBeat 所在网络访问。

实测：名称 **轩辕镜像官网**，目标 `xuanyuan.cloud:443`，类型 **HTTP API**，状态 **正常**。

![HertzBeat 监控中心：HTTP API 监控轩辕镜像官网状态正常](https://imgs.xuanyuan.cloud/docker/blog/hertzbeat-6.webp)

同一入口可继续加 Linux、MySQL、Redis、中间件等类型。

### 6.4 阈值规则

进入 **告警 → 阈值规则**。列表示例：**网站超时预警**（指标实时，`severity:critical`，已启用）。

![HertzBeat 阈值规则列表：网站超时预警已启用](https://imgs.xuanyuan.cloud/docker/blog/hertzbeat-4.webp)

编辑时可设指标类型（如 **HTTP API / 监控可用性**）、宕机或不可达时触发、表达式（如 `equals(__app__,"api") && equals(__available__,"down")`）、级别、触发次数与告警文案。

![HertzBeat 编辑实时阈值：网站超时预警表达式与严重告警](https://imgs.xuanyuan.cloud/docker/blog/hertzbeat-5.webp)

### 6.5 消息通知

在侧栏找到 **消息通知**（与告警配置相邻，具体分组以界面为准），按「媒介 → 策略 → 模板」三步把告警发出去：

1. **通知媒介**：新增钉钉机器人、邮箱等接收对象  
2. **通知策略**：绑定媒介与模板并启用  
3. **通知模板**：优先用系统内置（邮件 / WebHook / 企微 / 钉钉 / 飞书）

![HertzBeat 通知媒介：钉钉机器人与邮箱接收对象](https://imgs.xuanyuan.cloud/docker/blog/hertzbeat-7.webp)

编辑钉钉对象时填 ACCESS_TOKEN、密钥等，可用 **发送告警测试** 验证。截图里 Token 已打码；对外分享时勿泄露明文。

![HertzBeat 编辑接收对象：钉钉机器人 ACCESS_TOKEN 配置表单](https://imgs.xuanyuan.cloud/docker/blog/hertzbeat-8.webp)

![HertzBeat 通知策略：告警通知绑定钉钉与邮箱并启用](https://imgs.xuanyuan.cloud/docker/blog/hertzbeat-9.webp)

![HertzBeat 通知模板：系统内置邮件钉钉飞书等模板列表](https://imgs.xuanyuan.cloud/docker/blog/hertzbeat-10.webp)

走邮件通道还需在 `application.yml` 配 SMTP（见 FAQ）。单机未接时序库时，历史曲线能力有限，见第七节。

### 6.6 采集集群

**采集集群**页可看到内置 **`main-default-collector`**（**在线**）。多网段再点 **部署采集器**，或按第七节启动 `hertzbeat-collector`。

![HertzBeat 采集集群：main-default-collector 在线](https://imgs.xuanyuan.cloud/docker/blog/hertzbeat-11.webp)

### 6.7 系统配置

进入 **系统配置**：建议时区 **Asia/Shanghai**，主题按需；语言可在下拉中切换（实测界面曾为 `en_US`，需要中文就在此改）。点 **确认更新**。

![HertzBeat 系统配置：语言时区与浅色主题](https://imgs.xuanyuan.cloud/docker/blog/hertzbeat-12.webp)

---

## 七、生产加固与外置存储（可选）

第五节 Compose 用内置 **H2**，适合试用。官方生产更推荐 **HertzBeat + PostgreSQL + VictoriaMetrics**（另有 MySQL / TDengine / IoTDB / GreptimeDB 等组合）。

1. 从 [下载页](https://hertzbeat.apache.org/docs/download) 取 `apache-hertzbeat-*-docker-compose.tar.gz`，或用仓库 [`script/docker-compose`](https://github.com/apache/hertzbeat/tree/master/script/docker-compose)  
2. 进入 `hertzbeat-postgresql-victoria-metrics`，按该目录 README 执行 `docker compose up -d`  
3. 把镜像改成 `docker.xuanyuan.run/apache/hertzbeat:1.8.0`（版本与跟做一致）  
4. 仍访问 `http://IP:1157`，账号同上  

文档：[Install via Docker Compose](https://hertzbeat.apache.org/docs/start/docker-compose-deploy)。

扩展采集器示例（`MANAGER_HOST` 换成主服务可达 IP，勿填对端不可达的 `127.0.0.1`）：

```bash
docker run -d \
  --name hertzbeat-collector \
  --restart unless-stopped \
  -e IDENTITY=collector-01 \
  -e MODE=public \
  -e MANAGER_HOST=192.168.1.10 \
  -e MANAGER_PORT=1158 \
  docker.xuanyuan.run/apache/hertzbeat-collector:1.8.0
```

采集器标签与主服务保持同版本线：[hertzbeat-collector tags](https://hub.docker.com/r/apache/hertzbeat-collector/tags)。

另建议：1157 / 1158 仅内网或反代；定期备份 `./data`；改默认密码；细粒度账号再挂载自定义 `sureness.yml`。

---

## 八、备选：docker run（临时 / 无 Compose）

与第五节同等挂载与端口；启动后同样要等 **`Started HertzBeatApplication`**，再 `curl` / 浏览器访问。

```bash
mkdir -p /www/wwwroot/hertzbeat/{data,logs}
cd /www/wwwroot/hertzbeat

docker run -d \
  --name hertzbeat \
  --restart unless-stopped \
  -p 1157:1157 \
  -p 1158:1158 \
  -e TZ=Asia/Shanghai \
  -e LANG=en_US.UTF-8 \
  -v /www/wwwroot/hertzbeat/data:/opt/hertzbeat/data \
  -v /www/wwwroot/hertzbeat/logs:/opt/hertzbeat/logs \
  docker.xuanyuan.run/apache/hertzbeat:1.8.0
```

```bash
docker logs -f hertzbeat
docker ps --filter name=hertzbeat
```

```bash
docker stop hertzbeat && docker rm hertzbeat
```

长期运行仍建议第五节 Compose。

---

## 九、升级与备份

1. `docker compose down`  
2. 备份 `/www/wwwroot/hertzbeat`（至少 `./data`）  
3. 改 `docker-compose.yml` 中镜像标签  
4. `docker pull docker.xuanyuan.run/apache/hertzbeat:<新标签>`  
5. `docker compose up -d`，确认日志 `Started` 与登录页版本  

跨大版本先读 Release Note；外置库方案需同步迁移元数据库与时序库。

---

## 十、常见问题 FAQ

**Q：浏览器 `ERR_CONNECTION_REFUSED`，curl 返回 `000`？**  
多半是冷启动未完成。容器已 `Up` 时 JVM 仍可能停在 Hibernate / JPA 初始化，**1157 尚未监听**。执行 `docker compose logs -f hertzbeat`，等到 **`Started HertzBeatApplication`** 再访问。内存不足会拖慢甚至反复重启，可先 `free -h` 再 `docker compose restart`。

**Q：打开 http://IP:1157 没有界面？**  
先确认已 `Started`。再查容器是否仍 Up、日志 ERROR、防火墙是否放行 1157。若误挂了空的 `application.yml`，去掉挂载或换成完整样例后重建。

**Q：历史图表提示未配置时序数据库？**  
单机 H2 主要管元数据与短期数据；完整历史曲线需 VictoriaMetrics / TDengine / IoTDB 等，见第七节。

**Q：同机 MySQL / 时序库用 localhost 连不上？**  
容器 bridge 网络里，`localhost` 不是宿主机。改成宿主机局域网 IP、Compose 服务名，或（仅 Linux、慎用）`--network host`。

**Q：如何改默认密码？**  
Web「用户管理」修改；或下载 [`sureness.yml`](https://github.com/apache/hertzbeat/blob/master/script/sureness.yml) 挂到 `/opt/hertzbeat/config/sureness.yml` 后重启（文件须事先完整存在）。

**Q：要不要挂 application.yml？**  
可选。改数据源、SMTP、时序库时再挂。样例：[`script/application.yml`](https://github.com/apache/hertzbeat/blob/master/script/application.yml)。

**Q：和 Grafana / Prometheus 什么关系？**  
HertzBeat 可监控 Prometheus 类目标，并自带告警通知；Grafana 更偏通用可视化。可并存，不必二选一。

**Q：为什么不用 `latest`？**  
避免镜像静默更新后步骤与文档不一致。跟做与生产使用具体版本 **`1.8.0`**（或你选定的版本号）。

---

## 十一、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/apache/hertzbeat:1.8.0

# Compose（主路径）
cd /www/wwwroot/hertzbeat
docker compose up -d
docker compose ps
docker compose logs -f hertzbeat   # 等到 Started HertzBeatApplication
docker compose down

# docker run（备选）
docker run -d --name hertzbeat --restart unless-stopped \
  -p 1157:1157 -p 1158:1158 \
  -e TZ=Asia/Shanghai \
  -v /www/wwwroot/hertzbeat/data:/opt/hertzbeat/data \
  -v /www/wwwroot/hertzbeat/logs:/opt/hertzbeat/logs \
  docker.xuanyuan.run/apache/hertzbeat:1.8.0

# 验证（须在 Started 之后）
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:1157
```

---

## 十二、延伸阅读

| 资源 | 链接 |
|------|------|
| [apache/hertzbeat 镜像页](https://xuanyuan.cloud/zh/r/apache/hertzbeat) | [https://xuanyuan.cloud/zh/r/apache/hertzbeat](https://xuanyuan.cloud/zh/r/apache/hertzbeat) |
| [apache/hertzbeat 概览](https://xuanyuan.cloud/r/apache/hertzbeat) | [https://xuanyuan.cloud/r/apache/hertzbeat](https://xuanyuan.cloud/r/apache/hertzbeat) |
| [apache/hertzbeat 标签列表](https://xuanyuan.cloud/r/apache/hertzbeat/tags) | [https://xuanyuan.cloud/r/apache/hertzbeat/tags](https://xuanyuan.cloud/r/apache/hertzbeat/tags) |
| [GitHub · apache/hertzbeat](https://github.com/apache/hertzbeat) | [https://github.com/apache/hertzbeat](https://github.com/apache/hertzbeat) |
| [官方文档 · Docker 安装](https://hertzbeat.apache.org/docs/start/docker-deploy) | [https://hertzbeat.apache.org/docs/start/docker-deploy](https://hertzbeat.apache.org/docs/start/docker-deploy) |
| [官方文档 · Docker Compose](https://hertzbeat.apache.org/docs/start/docker-compose-deploy) | [https://hertzbeat.apache.org/docs/start/docker-compose-deploy](https://hertzbeat.apache.org/docs/start/docker-compose-deploy) |
| [Docker Hub · apache/hertzbeat](https://hub.docker.com/r/apache/hertzbeat) | [https://hub.docker.com/r/apache/hertzbeat](https://hub.docker.com/r/apache/hertzbeat) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- 跟做镜像：**`apache/hertzbeat:1.8.0`**，轩辕镜像加速拉取  
- 主路径：Compose 挂载 `./data`、`./logs`，映射 **1157 / 1158**；等 **`Started`** 再访问  
- 登录：`admin` / `hertzbeat`（务必改密）  
- 生产：优先官方 PostgreSQL + VictoriaMetrics；采集器用 `hertzbeat-collector`  

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/hertzbeat-docker-deploy


