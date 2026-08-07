# Docker Compose 部署 ClickHouse 列式数据库实测

![Docker Compose 部署 ClickHouse 列式数据库实测](https://img.xuanyuan.dev/docker/blog/clickhouse.webp)

*分类: Docker部署教程 | 标签: ClickHouse,Docker,轩辕镜像,OLAP,列式数据库,私有化部署,部署教程 | 发布时间: 2026-07-20 14:45:41*

> 业务日志、埋点、指标堆成山，用传统行存库做聚合又慢又贵？ClickHouse 是开源列式 OLAP 数据库——专为实时分析设计，单机即可扛住大规模写入与聚合查询，数据落在你自己的服务器上。

> *本文基于 [library/clickhouse:26.5.5.8](https://xuanyuan.cloud/zh/r/library/clickhouse) 官方镜像，**Linux（Ubuntu 24.04）** 环境；Compose 配置与验证命令可直接复用。旧 CPU / 虚拟机阉割指令集时会启动失败，见文中 CPU 说明与 FAQ。*

业务日志、埋点、指标堆成山，用传统行存库做聚合又慢又贵？**ClickHouse** 是开源列式 OLAP 数据库——专为实时分析设计，单机即可扛住大规模写入与聚合查询，数据落在你自己的服务器上。

本文用 [轩辕镜像](https://xuanyuan.cloud)，在 Linux 上以 **Docker Compose 单容器** 跑通 ClickHouse：固定标签 `26.5.5.8`、数据/日志持久化、设置密码以开放网络访问，再用 **HTTP（8123）**、内置 **Play** 页面与 **clickhouse-client（9000）** 验证，最后建表示例。镜像页见 [library/clickhouse](https://xuanyuan.cloud/zh/r/library/clickhouse)。

---

## 一、ClickHouse 是什么？

**ClickHouse** 是开源的 **列式数据库管理系统（DBMS）**，面向联机分析处理（OLAP），可用 SQL 实时做聚合与报表。相对传统行存数据库，分析类查询通常快一到三个数量级，适合日志分析、业务监控、埋点与数仓场景。

| 能力 | 说明 |
|------|------|
| 列式存储 | 扫列不扫行，聚合、过滤更省 IO |
| SQL | 标准 SQL 风格查询，生态驱动丰富 |
| 吞吐 | 单机可处理海量行级写入与查询 |
| 自托管 | Docker 官方镜像即可单节点跑通 |

典型使用场景：

- 应用 / 访问日志集中查询与统计
- 实时指标与漏斗、留存类分析
- 与 Grafana 等可视化工具对接（HTTP 或原生协议）

架构示意（本文单节点）：

```text
curl / SDK  ──HTTP:8123──▶  ClickHouse 容器
clickhouse-client ──Native:9000──▶  同上
./data ──▶ /var/lib/clickhouse（数据）
./logs ──▶ /var/log/clickhouse-server（日志）
```

> **部署前必看 CPU**：官方 amd64 镜像依赖较新的 CPU 指令集。宿主机或虚拟机若 **没有 SSE4.2**（较新版本还倾向要求 **x86-64-v3 / AVX2**），容器会不断重启。详见 **§二** 与 **§七 FAQ**。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 操作系统 | Linux x86_64（本文以 **Ubuntu 24.04** 为例） |
| Docker | Docker Engine + **Compose V2**（`docker compose`） |
| 内存 | 建议 ≥ **2 GB** 可用（分析负载再加） |
| CPU | **必须支持 SSE4.2**；当前官方 amd64 发行更偏向 **x86-64-v3（含 AVX2 等）** |
| 磁盘 | ≥ 2 GB（镜像约数百 MB～1 GB 级 + 数据增长） |
| 端口 | **8123**（HTTP）、**9000**（原生协议） |
| 工作目录 | `/data/clickhouse`（独立目录，可与 `/data/elk` 等并列） |

验证 Docker：

```bash
docker --version
docker compose version
```

若尚未安装 Docker，可使用轩辕镜像一键脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)

# 备用地址
bash <(wget -qO- https://get.xuanyuan.dev/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

### 2.1 部署前自检 CPU（强烈建议）

```bash
grep -o 'sse4_2' /proc/cpuinfo | head -1 || echo 'SSE4.2 NOT found'
grep -o 'avx2' /proc/cpuinfo | head -1 || echo 'AVX2 NOT found'
lscpu | grep -E 'Model name|Flags|Hypervisor'
```

| 结果 | 说明 |
|------|------|
| 有 `sse4_2`（最好还有 `avx2`） | 可继续拉取与启动本文 Compose |
| **`SSE4.2 NOT found`** | **不要硬启动**：官方镜像会报指令集检查失败并 `Restarting`。请换支持 SSE4.2 的机器，或把虚拟机 CPU 改为 **host / 透传** 后再试 |

实测对照：在一台 **无 SSE4.2** 的 Ubuntu 24.04 上，`docker compose up -d` 后容器状态为 `Restarting (1)`，日志反复出现：

```text
Instruction check fail. The CPU does not support SSE4.2 instruction set.
```

此时改密码、改端口、加 `cap_add` **均无效**。官方 Docker Hub 的 `library/clickhouse` **没有** 面向老 CPU 的 `amd64compat` 类标签可降级；只能换机或打开虚拟机指令集透传。

---

## 三、拉取镜像

本文固定标签 **`26.5.5.8`**（版本可复现）。生产环境也可按 [标签列表](https://xuanyuan.cloud/r/library/clickhouse/tags) 锁定其它小版本；不建议生产长期用裸 `latest`。

```bash
docker pull docker.xuanyuan.run/library/clickhouse:26.5.5.8
```

完整输出示例：

```text
26.5.5.8: Pulling from library/clickhouse
d6834b4a794c: Pull complete
e157edf0dcc9: Pull complete
4abec04979fc: Pull complete
ddeb76a8062c: Pull complete
430f5f983823: Pull complete
999829a9d4af: Pull complete
a2c9618c1f0b: Pull complete
761bc9ffbe9f: Pull complete
Digest: sha256:709afe0ea57d8ae72d44c272ecd61b507e1aea476f657016fc0d94f2a6da449d
Status: Downloaded newer image for docker.xuanyuan.run/library/clickhouse:26.5.5.8
docker.xuanyuan.run/library/clickhouse:26.5.5.8
```

> 国内建议全程使用 `docker.xuanyuan.run`。需登录轩辕仓库时见 [登录认证说明](https://xuanyuan.cloud/usage)。

---

## 四、Docker Compose 部署

### 4.1 创建目录与监听配置

```bash
mkdir -p /data/clickhouse/{data,logs,config.d,users.d}
cd /data/clickhouse
```

容器内常默认尝试监听 IPv6 的 `[::1]`；许多 Docker 环境未启用 IPv6，日志会出现 `Listen [::1]:8123 failed`，结果 **HTTP 8123 从宿主机访问被 Connection reset**，而 `docker exec` 里的 client（走容器回环 9000）仍可能正常。部署前写入监听配置：

```bash
cat > /data/clickhouse/config.d/listen.xml <<'EOF'
<?xml version="1.0"?>
<clickhouse>
    <!-- 仅 IPv4；Docker 端口映射需监听 0.0.0.0，勿只绑 127.0.0.1 -->
    <listen_host>0.0.0.0</listen_host>
</clickhouse>
EOF
```

### 4.2 编写 docker-compose.yml

```bash
vim docker-compose.yml
```

内容：

```yaml
services:
  clickhouse:
    image: docker.xuanyuan.run/library/clickhouse:26.5.5.8
    container_name: clickhouse
    restart: unless-stopped
    ports:
      - "8123:8123"
      - "9000:9000"
    environment:
      CLICKHOUSE_DB: analytics
      CLICKHOUSE_USER: default
      CLICKHOUSE_PASSWORD: Changeme_CH_2026
      CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT: "1"
    ulimits:
      nofile:
        soft: 262144
        hard: 262144
    volumes:
      - ./data:/var/lib/clickhouse
      - ./logs:/var/log/clickhouse-server
      - ./config.d:/etc/clickhouse-server/config.d
      - ./users.d:/etc/clickhouse-server/users.d
```

| 配置项 | 说明 |
|--------|------|
| `CLICKHOUSE_PASSWORD` | **必填（若要从网络访问）**。未设密码时，`default` 用户默认禁止网络访问 |
| `CLICKHOUSE_DB=analytics` | 启动时创建业务库 |
| `CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT=1` | 启用访问控制相关初始化 |
| `ulimits.nofile` | 官方建议的文件描述符上限 |
| `./data` → `/var/lib/clickhouse` | 数据持久化 |
| `./logs` → `/var/log/clickhouse-server` | 日志持久化 |
| `config.d/listen.xml` | **`listen_host=0.0.0.0`**，避免 IPv6/`::1` 监听失败导致宿主机 HTTP 重置 |

> 请将 `Changeme_CH_2026` 换成你自己的强密码；下文验证命令中的密码需同步修改。**勿将弱口令暴露到公网。**

### 4.3 启动

```bash
docker compose up -d
docker compose ps
docker logs clickhouse --tail 50
```

期望：`STATUS` 为 **`Up`**（不是 `Restarting`）。日志中可见创建用户、创建库 `analytics` 一类提示，例如：

```text
/entrypoint.sh: create new user 'default' instead 'default'
...
/entrypoint.sh: create database 'analytics'
```

可用下面确认错误日志里**不再**刷 `Listen [::1]:8123 failed`：

```bash
docker exec clickhouse grep -E 'Listen \[::1\]|Application: Ready' /var/log/clickhouse-server/clickhouse-server.err.log | tail -20
```

若一上来就是 `Restarting` 且日志刷 SSE4.2，先 `docker compose down`，回到 **§2.1** 处理 CPU，不要空耗磁盘写日志。

---

## 五、验证与使用

### 5.1 HTTP 接口（8123）

在 **系统 Shell** 中执行（不要在 `clickhouse-client` 交互提示符里粘贴 curl）：

```bash
echo 'SELECT version()' | curl -sS \
  'http://127.0.0.1:8123/?user=default&password=Changeme_CH_2026' \
  --data-binary @-
```

期望输出类似：

```text
26.5.5.8
```

指定业务库：

```bash
echo 'SHOW TABLES' | curl -sS \
  'http://127.0.0.1:8123/?database=analytics&user=default&password=Changeme_CH_2026' \
  --data-binary @-
```

局域网其它机器访问时，把 `127.0.0.1` 换成服务器 IP，并放行防火墙 **8123/9000**。

### 5.2 浏览器 Play（推荐）

容器就绪后，浏览器打开（把 IP 换成你的服务器）：

```text
http://<服务器IP>:8123/play
```

首次进入为深色 SQL 编辑器：右上角填写 **user** / **password**，中间空白处写 SQL，点黄色 **Run**（或 `Ctrl/Cmd+Enter`）。

![ClickHouse Play 初始页：空白查询框与 user、password 输入](https://img.xuanyuan.dev/docker/blog/clickhouse-1.webp)

*图 1：Play 初始页（`http://服务器IP:8123/play`），右上角填写账号密码*

**务必**使用与 Compose 中 `CLICKHOUSE_PASSWORD` **完全一致**的密码。密码错误或未填时会出现 `Code: 516` / `AUTHENTICATION_FAILED`：

![ClickHouse Play 认证失败 Code 516 Authentication failed](https://img.xuanyuan.dev/docker/blog/clickhouse-2.webp)

*图 2：密码不正确时的 Code 516 报错；核对 `docker-compose.yml` 中的 `CLICKHOUSE_PASSWORD` 后重试*

填写正确后，右上角会显示版本（如 `v26.5.5.8`）与用户 `default`。先跑连通性查询：

```sql
SELECT version(), currentDatabase();
```

![Play 执行 SELECT version 与 currentDatabase 成功返回 26.5.5.8](https://img.xuanyuan.dev/docker/blog/clickhouse-3.webp)

*图 3：认证成功后查询版本与当前库，结果为 `26.5.5.8` / `default`*

再确认业务库是否已由环境变量创建：

```sql
SHOW DATABASES;
```

列表中应能看到 **`analytics`**（以及 `default`、`system` 等）：

![Play 执行 SHOW DATABASES 列出 analytics 等库](https://img.xuanyuan.dev/docker/blog/clickhouse-4.webp)

*图 4：`SHOW DATABASES` 可见 `analytics`（与 `CLICKHOUSE_DB` 对应）*

### 5.3 原生客户端（容器内）

单条查询：

```bash
docker exec -it clickhouse clickhouse-client \
  --user default --password Changeme_CH_2026 \
  -q "SELECT version(), currentDatabase()"
```

期望类似：

```text
26.5.5.8	default
```

交互进入：

```bash
docker exec -it clickhouse clickhouse-client \
  --user default --password Changeme_CH_2026
```

进入后提示符类似 `容器短ID :)`，只输入 SQL，例如：

```sql
SELECT version();
```

退出：输入 `exit` 或按 `Ctrl+D`，回到系统 Shell 后再跑 `curl` / `docker` 命令。

### 5.4 建表冒烟

可用 client 批量执行：

```bash
docker exec -it clickhouse clickhouse-client \
  --user default --password Changeme_CH_2026 -n <<-EOSQL
CREATE TABLE IF NOT EXISTS analytics.events (
  ts DateTime,
  msg String
) ENGINE = MergeTree
ORDER BY ts;

INSERT INTO analytics.events VALUES (now(), 'hello clickhouse');

SELECT * FROM analytics.events;
EOSQL
```

也可在 **Play** 中分步执行（适合跟截图对照）：

```sql
CREATE TABLE IF NOT EXISTS analytics.events
(
    ts DateTime,
    msg String
)
ENGINE = MergeTree
ORDER BY ts;

INSERT INTO analytics.events VALUES (now(), 'hello from play');

SELECT * FROM analytics.events ORDER BY ts DESC LIMIT 10;
```

查询成功时可见写入的行，例如 `msg = hello from play`：

![Play 查询 analytics.events 返回 hello from play](https://img.xuanyuan.dev/docker/blog/clickhouse-5.webp)

*图 5：查询 `analytics.events`，确认建表与插入成功*

### 5.5 连接信息一览

| 项 | 值 |
|----|-----|
| HTTP / Play | `http://<服务器IP>:8123` · `http://<服务器IP>:8123/play` |
| Native | `<服务器IP>:9000` |
| 用户 | `default` |
| 密码 | 与 Compose 中 `CLICKHOUSE_PASSWORD` 一致 |
| 库 | `analytics`（已创建）或 `default` |
| 数据目录 | `/data/clickhouse/data` |
| 日志目录 | `/data/clickhouse/logs` |

> Play 为内置简易 SQL 页；若打不开仍可用 curl 与 `clickhouse-client`。认证失败时优先核对密码，勿与空密码或其它服务口令混用。

---

## 六、日常运维

```bash
cd /data/clickhouse
docker compose ps
docker compose logs -f --tail=100
docker compose restart
docker compose down          # 停止，保留 ./data ./logs
docker compose up -d         # 再启动
```

升级小版本：改 `image` 标签 → `docker compose pull && docker compose up -d`。升级前建议备份 `/data/clickhouse/data`。

等价 `docker run`（无 Compose 时可用，参数与上文一致）：

```bash
docker run -d \
  --name clickhouse \
  --restart unless-stopped \
  --ulimit nofile=262144:262144 \
  -p 8123:8123 -p 9000:9000 \
  -e CLICKHOUSE_DB=analytics \
  -e CLICKHOUSE_USER=default \
  -e CLICKHOUSE_PASSWORD=Changeme_CH_2026 \
  -e CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT=1 \
  -v /data/clickhouse/data:/var/lib/clickhouse \
  -v /data/clickhouse/logs:/var/log/clickhouse-server \
  docker.xuanyuan.run/library/clickhouse:26.5.5.8
```

---

## 七、FAQ

**Q：容器一直 `Restarting`，日志里是 `Instruction check fail. The CPU does not support SSE4.2`？**  
A：宿主机/虚拟机 **未暴露 SSE4.2**。官方 `library/clickhouse` 无法在这种 CPU 上运行。请：

1. `grep sse4_2 /proc/cpuinfo` 确认；  
2. 虚拟机把 CPU 类型改为 **host / passthrough** 后重启系统再 `up`；  
3. 或换一台支持 SSE4.2（更好有 AVX2）的机器。  
不要指望换镜像小版本标签绕过——Docker Official Image 侧没有面向「无 SSE4.2」的兼容标签。

**Q：为何必须设置 `CLICKHOUSE_PASSWORD`？**  
A：官方镜像在未配置用户密码等相关变量时，`default` 用户 **禁止网络访问**。只映射 `8123/9000` 而不设密码，外连会失败。`CLICKHOUSE_SKIP_USER_SETUP=1` 仅适合本地极不安全的试验，生产勿用。

**Q：Play 报 `Code: 516` / `Authentication failed`？**  
A：右上角 **password** 与 `CLICKHOUSE_PASSWORD` 不一致（或未填）。见图 2。用 `grep CLICKHOUSE_PASSWORD docker-compose.yml` 核对后重填；也可用 `clickhouse-client --password '…' -q "SELECT 1"` 交叉验证。

**Q：`curl` 粘贴后报 `Syntax error: failed at position 1 (echo)`？**  
A：你还在 **clickhouse-client** 交互里（提示符带 `:)`）。先 `exit` 回到系统 Shell，再执行 curl。

**Q：HTTP 刚启动时 `curl` 无输出？**  
A：等几秒后再试，或先看 `docker logs clickhouse` 是否已完成初始化；也可用 `clickhouse-client -q "SELECT version()"` 交叉验证。

**Q：8123 和 9000 有什么区别？**  
A：**8123** 是 HTTP 接口（curl、多数 SDK、部分 BI）；**9000** 是原生协议（官方 `clickhouse-client`、部分驱动）。单节点两个都映射即可。

**Q：本机 `curl 127.0.0.1:8123` 报 `Connection reset by peer`，但 `docker exec … clickhouse-client` 正常？**  
A：看错误日志是否有：

```text
Listen [::1]:8123 failed: … Cannot assign requested address
```

容器未启用 IPv6 时，默认去绑 `[::1]` 会失败；HTTP 未正确监听在 `0.0.0.0`，Docker 端口映射进来的连接会被重置，而容器内走 `127.0.0.1:9000` 的 client 仍可用。处理：

```bash
cat > config.d/listen.xml <<'EOF'
<?xml version="1.0"?>
<clickhouse>
    <listen_host>0.0.0.0</listen_host>
</clickhouse>
EOF
docker compose restart
```

然后再测：`curl -sS http://127.0.0.1:8123/play` 与带密码的 `SELECT version()`。

**Q：本机 curl 已通，局域网浏览器访问 `http://服务器IP:8123/play` 却「连接已重置」？**  
A：按下面顺序查（多数是防火墙或端口未对外）：

1. 宿主机确认容器 `Up`，且映射为 `0.0.0.0:8123->8123`（`docker compose ps` / `docker port clickhouse`）。  
2. **在跑 ClickHouse 的机器上**：先确认本机 `curl http://127.0.0.1:8123/play` 成功，再用局域网 IP 自测。  
3. **放行防火墙**（Ubuntu 示例）：`sudo ufw allow 8123/tcp && sudo ufw reload`（云主机还需在安全组放行 8123）。  
4. 从访问端先测通端口：`curl -v http://服务器IP:8123/`；若这里就 RESET/超时，与 `/play` 无关。  
5. Compose 不要写成 `127.0.0.1:8123:8123`（只绑回环则外网不可达）。

**Q：数据会丢吗？**  
A：挂载了 `./data` → `/var/lib/clickhouse` 后，`docker compose down` 不会删数据。只有手工清空 `./data` 或换空目录才会丢。

**Q：和 Elastic / MySQL 怎么选？**  
A：ClickHouse 擅长 **分析型聚合与宽表扫描**；全文检索与业务事务型负载仍更适合 Elasticsearch / 传统 OLTP。可按场景并存。

---

## 八、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/library/clickhouse:26.5.5.8

# 启动 / 状态 / 日志
cd /data/clickhouse
docker compose up -d
docker compose ps
docker logs clickhouse --tail 50

# HTTP 验证
echo 'SELECT version()' | curl -sS \
  'http://127.0.0.1:8123/?user=default&password=Changeme_CH_2026' --data-binary @-

# 客户端验证
docker exec -it clickhouse clickhouse-client \
  --user default --password Changeme_CH_2026 \
  -q "SELECT version(), currentDatabase()"

# 停止
docker compose down
```

---

## 九、延伸阅读

- 轩辕镜像页：[library/clickhouse](https://xuanyuan.cloud/zh/r/library/clickhouse)
- Docker Hub 官方说明：[clickhouse](https://hub.docker.com/_/clickhouse)
- 项目仓库：[ClickHouse/ClickHouse](https://github.com/ClickHouse/ClickHouse)
- 官方文档：[clickhouse.com/docs](https://clickhouse.com/docs)
- 轩辕使用手册：[xuanyuan.cloud/usage](https://xuanyuan.cloud/usage)


