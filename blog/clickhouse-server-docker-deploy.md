# Docker 部署 ClickHouse Server：轻松搭建列式 OLAP 分析数据库平台

![Docker 部署 ClickHouse Server：轻松搭建列式 OLAP 分析数据库平台](https://imgs.xuanyuan.cloud/docker/blog/clickhouse-server.webp)

*分类: Docker部署教程 | 标签: ClickHouse,clickhouse-server,Docker,轩辕镜像,OLAP,列式数据库,私有化部署,部署教程 | 发布时间: 2026-09-08 03:28:36*

> ClickHouse Server 是一款面向海量数据的列式 OLAP 数据库，擅长高吞吐写入与低延迟聚合查询。本文将介绍如何通过 Docker Compose 快速部署 clickhouse/clickhouse-server，轻松搭建可自托管的数据分析平台，适合日志分析、业务报表、埋点统计与实时指标等场景。

*本文基于 [clickhouse/clickhouse-server:26.5.5.8](https://xuanyuan.cloud/zh/r/clickhouse/clickhouse-server)，实测引擎 **ClickHouse 26.5.5.8**，测试平台 **Ubuntu 24.04** Linux。*

业务看板要按天、按渠道、按接口路径做下钻：访问日志在几台机器上轮转，有人用 `grep` 拼时间窗，产品又要一张漏斗表。行存库里宽表一 JOIN，聚合拖到分钟级；把明细扔到公有云分析服务，还要过合规与出域评审。值班群里常见画面是：有人盯 Grafana，有人在 Excel 对账，有人等数仓「明天再出数」。

埋点、接口耗时、业务事件这类明细最好落在自己的盘上。机房内网、等保环境、客户合同里的「数据不出域」，往往不允许把分析库托管到公有云。很多团队已经有一台跑 Docker 的 Ubuntu，缺的是：**镜像能拉下来、密码与数据卷设好、浏览器或客户端能跑通第一条 SQL**——而不是先上整套数仓中台。

**ClickHouse**（[官网](https://clickhouse.com/)、[GitHub](https://github.com/ClickHouse/ClickHouse)）是开源列式 DBMS，面向 **OLAP**：列式存储、向量化执行，适合实时报表与海量追加写。本文用官方组织镜像 **`clickhouse/clickhouse-server`**（[镜像页](https://xuanyuan.cloud/zh/r/clickhouse/clickhouse-server)）：HTTP **8123**（含内置 **Play**）、原生协议 **9000**。同站还有 Official Image [`library/clickhouse`](https://xuanyuan.cloud/blog/docker-clickhouse) 教程，产品相同、坐标不同，选型见 **§1.1**。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 浏览器冒烟 | 打开 `http://服务器IP:8123/play`，填账号密码跑 `SELECT version()` |
| HTTP / SDK | curl 或驱动连 **8123**，把日志 / 埋点写入 MergeTree 表 |
| 原生客户端 | `docker exec … clickhouse-client` 走 **9000** |
| 备份搬家 | 停容器后打包 `./data`（按需带上 `./logs`、`config.d`） |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`clickhouse/clickhouse-server:26.5.5.8`**，**Docker Compose** 做主路径：持久化、设密码、映射 **8123 / 9000**。实测局域网 IP **`192.168.1.35`**，请换成你的。无 Compose 见第八节。文内 **4** 张 Play 截图。

> **上手要点**
> - **部署**：第五节 Compose；临时试玩见第八节 `docker run`
> - **端口**：宿主机 **8123** → HTTP / Play；**9000** → 原生协议
> - **标签**：跟做 **`26.5.5.8`**（需 **SSE4.2**）；有 **AVX2** 才考虑升 **26.6+**；勿写 `latest`
> - **CPU**：先跑 §2.1；无 AVX2 却拉 26.6+ 会 `Illegal instruction`
> - **密码**：必须设 `CLICKHOUSE_PASSWORD`，否则 `default` 默认禁止网络访问
> - **数据**：`./data` → `/var/lib/clickhouse`；`./logs` → `/var/log/clickhouse-server`
> - **ulimit**：`nofile` **262144**
> - **工作目录**：Linux `/www/wwwroot/clickhouse-server`；macOS 用 `~/docker/clickhouse-server`

官方：[Docker 镜像说明](https://github.com/ClickHouse/ClickHouse/blob/master/docker/server/README.md) · [配置文件](https://clickhouse.com/docs/operations/configuration_files) · [镜像页](https://xuanyuan.cloud/zh/r/clickhouse/clickhouse-server) · [标签列表](https://xuanyuan.cloud/r/clickhouse/clickhouse-server/tags)

---

## 一、ClickHouse Server 镜像是什么？

`clickhouse/clickhouse-server` 是官方组织维护的 Server 容器：没有安装向导式管理后台，验证靠 HTTP、Play 或 `clickhouse-client`。Play 是内置 SQL 页，不是运维控制台。

| | ClickHouse Server（本文） | 传统行存（MySQL / PostgreSQL） | 托管云分析 |
|--|---------------------------|--------------------------------|------------|
| 定位 | 自托管列式 OLAP | 事务 / 业务库 | 厂商托管 |
| 适合 | 日志、埋点、指标、宽表聚合 | OLTP、强一致事务 | 快速上云、少运维 |
| 数据 | 挂载本机卷 | 本机或托管 | 出域云端 |
| 代价 | 要自己盯磁盘与备份 | 分析扫表往往更慢 | 合规与出域成本 |

```text
curl / SDK / BI     ──HTTP:8123──▶  clickhouse-server
浏览器 Play         ──HTTP:8123/play──▶  同上
clickhouse-client   ──Native:9000──▶  同上
./data              ──挂载──▶  /var/lib/clickhouse
./logs              ──挂载──▶  /var/log/clickhouse-server
./config.d          ──挂载──▶  /etc/clickhouse-server/config.d（可选）
```

[`/r/`](https://xuanyuan.cloud/r/clickhouse/clickhouse-server) 与 [`/zh/r/`](https://xuanyuan.cloud/zh/r/clickhouse/clickhouse-server) 为同一镜像的不同页面语言。同站还有 `yandex/clickhouse-server`、`altinity/clickhouse-server` 等变体，**本文只用 `clickhouse/clickhouse-server:26.5.5.8`**。

### 1.1 与 `library/clickhouse` 怎么选

同站另有 [library/clickhouse 部署教程](https://xuanyuan.cloud/blog/docker-clickhouse)。两边都是 **ClickHouse Server 单节点**，不是两个不同的库。

| | **本文 `clickhouse/clickhouse-server`** | **对照 `library/clickhouse`** |
|--|------------------------------------------|-------------------------------|
| 坐标 | 组织镜像 `clickhouse/clickhouse-server` | Official Image `library/clickhouse`（短名常写 `clickhouse`） |
| 拉取 | `docker.xuanyuan.run/clickhouse/clickhouse-server:…` | `docker.xuanyuan.run/library/clickhouse:…` |
| 接口与配置 | HTTP **8123**、原生 **9000**；`CLICKHOUSE_*`、数据卷路径基本相同 | 同左 |
| 跟做版本 | 均可固定 **`26.5.5.8`**（SSE4.2）；升 **26.6+** 都要 **AVX2** | 同左 |
| 教程侧重 | 无 AVX2 时拉 26.6+ 的 `Illegal instruction` | 无 SSE4.2 的 `Instruction check fail` |
| 目录示例 | `/www/wwwroot/clickhouse-server` | `/data/clickhouse` |

**怎么选：** 新部署任选其一，**整篇命令用同一坐标**；认 Official Image 跟 [library 文](https://xuanyuan.cloud/blog/docker-clickhouse)，脚本里已写 `clickhouse/clickhouse-server` 则跟本文；已有数据目录勿仅为换教程改镜像名。只有 SSE4.2、无 AVX2 时，两条线都先用 **`26.5.5.8`**。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2**；建议 ≥ **20.10.10** |
| CPU | 本文 **`26.5.5.8`** 需 **SSE4.2**；**26.6+** 需 **AVX2（x86-64-v3）**。arm64 需 ARMv8.2-A + RCpc（树莓派 4 等不支持） |
| 内存 | ≥ **2 GB** 可用（分析负载再加） |
| 磁盘 | 镜像约 GB 级 + 数据增长 |
| 端口 | 宿主机 **8123**、**9000** |
| 工作目录 | `/www/wwwroot/clickhouse-server` |

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

### 2.1 部署前自检 CPU（强制）

先跑本节再 `compose up`。自 **26.6** 起，官方默认 amd64 构建目标为 **x86-64-v3（含 AVX2）**。无 AVX2 却拉 `26.8.2.7` 一类新版本时，常见不是友好报错，而是 **`Illegal instruction (core dumped)`**，容器反复重启，**8123 连接被拒绝**——改密码、改端口、加 `listen_host` 都无效。本文跟做 **`26.5.5.8`**（仍按 SSE4.2 / x86-64-v2 一代构建），覆盖更多常见主机。

```bash
grep -o 'avx2' /proc/cpuinfo | head -1 || echo 'AVX2 NOT found'
grep -o 'sse4_2' /proc/cpuinfo | head -1 || echo 'SSE4.2 NOT found'
lscpu | grep -E 'Model name|Flags|Hypervisor'
```

| 结果 | 说明 |
|------|------|
| 有 **`sse4_2`** | 可跟做本文 **`26.5.5.8`** |
| 另有 **`avx2`** | 需要时再升 **26.6+**（完整版本号），勿写 `latest` |
| 无 AVX2 却拉 **26.6+** | 会 `Illegal instruction`（见下方实测） |
| **`SSE4.2 NOT found`** | 换机或虚拟机 CPU 改为 **host / 透传**；官方 Docker 镜像无 `amd64compat` 标签 |

Ubuntu 24.04 实测：仅有 `sse4_2`、无 `avx2`。拉起 **`26.8.2.7`** 时日志反复：

```text
/entrypoint.sh: line 42:    23 Illegal instruction     (core dumped) clickhouse extract-from-config --config-file "$CLICKHOUSE_CONFIG" --key='storage_configuration.disks.*.path'
/entrypoint.sh: line 43:    25 Illegal instruction     (core dumped) clickhouse extract-from-config --config-file "$CLICKHOUSE_CONFIG" --key='storage_configuration.disks.*.metadata_path'
```

改用 **`26.5.5.8`** 后稳定 `Up`，`SELECT version()` 返回 `26.5.5.8`。

宿主机 **8123 / 9000** 已被占用时，Compose 改为例如 `"18123:8123"`、`"19000:9000"`，访问与 curl 同步改端口。

---

## 三、标签怎么选

跟做使用 **`26.5.5.8`**。完整列表：[tags](https://xuanyuan.cloud/r/clickhouse/clickhouse-server/tags)。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`26.5.5.8`** | 26.5 线完整版；默认目标仍为 x86-64-v2 / SSE4.2 | **本文跟做** |
| `26.8.2.7` 等 **26.6+** | 新稳定线；默认按 x86-64-v3 / AVX2 构建 | **仅当** 有 `avx2` |
| `26.8` / `26.5` | 分支滚动最新 | 不如四段版本稳 |
| `26.3.x.y` | 另一条维护分支 | 需要该分支时再选，并固定完整号 |
| `latest` | 最新稳定分支的最新版 | **勿写入跟做命令** |
| `*-alpine` | Alpine 底 | 体积敏感时可选；本文默认非 alpine |
| `head` | 默认分支最新提交 | 仅尝鲜 |

升级时同步改 pull、Compose、`docker run` 三处标签，并核对 [changelog](https://github.com/ClickHouse/ClickHouse/releases) 与 CPU 要求。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/clickhouse/clickhouse-server:26.5.5.8
```

Ubuntu 24.04 实测：

```text
26.5.5.8: Pulling from clickhouse/clickhouse-server
176075be308b: Pull complete
ccc4aff8f872: Pull complete
609d1bd9b62c: Pull complete
07cb56a04913: Pull complete
4e0ed465be94: Pull complete
326841c22bce: Pull complete
40d16f30db40: Pull complete
49f467916923: Pull complete
4f4fb700ef54: Pull complete
c9a868c148f4: Download complete
4ef95b8e0575: Download complete
Digest: sha256:894ae0107b1cedc3c537521539a7ecc76fe0ee6e31efbb2af2c84ab858cb32a4
Status: Downloaded newer image for docker.xuanyuan.run/clickhouse/clickhouse-server:26.5.5.8
docker.xuanyuan.run/clickhouse/clickhouse-server:26.5.5.8
```

有 AVX2 且确需更新线时，再拉对应完整版本（如 `26.8.2.7`）并同步改 Compose；无 AVX2 勿跟做该线。

---

## 五、Docker Compose 部署（推荐）

工作目录：`/www/wwwroot/clickhouse-server`（macOS 用 `~/docker/clickhouse-server`）。

### 5.1 创建目录与监听配置

```bash
sudo mkdir -p /www/wwwroot/clickhouse-server/{data,logs,config.d,users.d}
sudo chown -R "$USER:$USER" /www/wwwroot/clickhouse-server
cd /www/wwwroot/clickhouse-server
```

部分环境未启用 IPv6 时，默认去听 `[::1]` 会失败：宿主机访问 **8123** 出现 `Connection reset`，容器内 `clickhouse-client` 却可能正常。部署前写入：

```bash
cat > config.d/listen.xml <<'EOF'
<?xml version="1.0"?>
<clickhouse>
    <!-- 仅 IPv4；Docker 端口映射需监听 0.0.0.0，勿只绑 127.0.0.1 -->
    <listen_host>0.0.0.0</listen_host>
</clickhouse>
EOF
```

### 5.2 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  clickhouse:
    image: docker.xuanyuan.run/clickhouse/clickhouse-server:26.5.5.8
    container_name: clickhouse-server
    restart: unless-stopped
    ports:
      - "8123:8123"
      - "9000:9000"
    environment:
      TZ: Asia/Shanghai
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
EOF
```

| 配置项 | 说明 |
|--------|------|
| `CLICKHOUSE_PASSWORD` | 要从网络访问就必须设；未设时 `default` 默认禁止网络访问 |
| `CLICKHOUSE_DB=analytics` | 启动时创建业务库 |
| `CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT=1` | 启用访问控制相关初始化 |
| `ulimits.nofile` | 官方建议的文件描述符上限 |
| `./data` → `/var/lib/clickhouse` | 数据持久化 |
| `./logs` → `/var/log/clickhouse-server` | 日志持久化 |
| `config.d/listen.xml` | `listen_host=0.0.0.0`，避免 `::1` 监听失败 |

> 将 `Changeme_CH_2026` 换成你自己的强密码；下文验证命令同步修改。**勿把弱口令暴露到公网。**

### 5.3 启动与验证

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 40
```

Ubuntu 24.04 实测，`STATUS` 稳定 **Up**：

```text
NAME                IMAGE                                                       COMMAND            SERVICE      CREATED         STATUS         PORTS
clickhouse-server   docker.xuanyuan.run/clickhouse/clickhouse-server:26.5.5.8   "/entrypoint.sh"   clickhouse   5 seconds ago   Up 3 seconds   0.0.0.0:8123->8123/tcp, [::]:8123->8123/tcp, 0.0.0.0:9000->9000/tcp, [::]:9000->9000/tcp, 9009/tcp
```

日志关键行：

```text
/entrypoint.sh: create new user 'default' instead 'default'
Processing configuration file '/etc/clickhouse-server/config.xml'.
Merging configuration file '/etc/clickhouse-server/config.d/listen.xml'.
Logging trace to /var/log/clickhouse-server/clickhouse-server.log
Logging errors to /var/log/clickhouse-server/clickhouse-server.err.log

/entrypoint.sh: create database 'analytics'
```

HTTP：

```bash
echo 'SELECT version()' | curl -sS \
  'http://127.0.0.1:8123/?user=default&password=Changeme_CH_2026' \
  --data-binary @-
```

实测：

```text
26.5.5.8
```

客户端：

```bash
docker exec -it clickhouse-server clickhouse-client \
  --user default --password Changeme_CH_2026 \
  -q "SELECT version(), currentDatabase()"
```

实测：

```text
26.5.5.8	default
```

若刷 `Illegal instruction` 或进入 `Restarting`，先 `docker compose down`，回到 **§2.1**，确认未误用 26.6+ 标签。

---

## 六、浏览器 Play 与建表示例

### 6.1 打开 Play

浏览器访问（实测 IP，请换成你的）：

```text
http://192.168.1.35:8123/play
```

右上角填写 **user** / **password**（与 Compose 一致），中间写 SQL，点 **Run**（或 `Ctrl/Cmd+Enter`）。

![ClickHouse Play 初始页：空白查询框与 user、password，地址 192.168.1.35:8123](https://imgs.xuanyuan.cloud/docker/blog/clickhouse-server-1.webp)

连通性：

```sql
SELECT version(), currentDatabase();
```

![Play 执行 SELECT version 返回 26.5.5.8，用户 default](https://imgs.xuanyuan.cloud/docker/blog/clickhouse-server-2.webp)

确认业务库：

```sql
SHOW DATABASES;
```

列表中应有 **`analytics`**：

![Play 执行 SHOW DATABASES 列出 analytics 等库](https://imgs.xuanyuan.cloud/docker/blog/clickhouse-server-3.webp)

密码错误或未填会出现 `Code: 516` / `AUTHENTICATION_FAILED`。用 `grep CLICKHOUSE_PASSWORD docker-compose.yml` 核对后重填。

交互式客户端（可选）：

```bash
docker exec -it clickhouse-server clickhouse-client \
  --user default --password Changeme_CH_2026
```

提示符类似 `:) ` 时只输入 SQL；`exit` 或 `Ctrl+D` 回到系统 Shell 后再跑 `curl` / `docker`。

### 6.2 建表示例

在 Play 中可一次粘贴多条，点 **Run all**：

```sql
CREATE TABLE IF NOT EXISTS analytics.events
(
    event_time DateTime,
    user_id UInt64,
    event_name String
)
ENGINE = MergeTree
ORDER BY (event_time, user_id);

INSERT INTO analytics.events VALUES
    (now(), 1001, 'page_view'),
    (now(), 1002, 'click');

SELECT event_name, count() AS c
FROM analytics.events
GROUP BY event_name
ORDER BY c DESC;
```

![Play 建表插入并按 event_name 聚合，click 与 page_view 各 1 行](https://imgs.xuanyuan.cloud/docker/blog/clickhouse-server-4.webp)

---

## 七、安全与生产加固

| 项 | 建议 |
|----|------|
| 密码 | 强密码；勿用文中占位串上公网 |
| 暴露面 | 优先内网 / VPN；公网前放行防火墙或加反向代理 |
| 能力 | 可选 `cap_add: [SYS_NICE, NET_ADMIN, IPC_LOCK]`（非必须） |
| 配置 | 用 `config.d` / `users.d` 增量 XML，避免整文件覆盖 `config.xml` |
| 初始化 | 可把 `*.sql` / `*.sh` 挂到 `/docker-entrypoint-initdb.d` |
| 备份 | 定期备份 `/var/lib/clickhouse`（停写或按官方流程） |

按需在 Compose 的 `clickhouse` 服务下追加：

```yaml
    cap_add:
      - SYS_NICE
      - NET_ADMIN
      - IPC_LOCK
```

说明见 [capabilities 知识库](https://clickhouse.com/docs/knowledgebase/configure_cap_ipc_lock_and_cap_sys_nice_in_docker)。

---

## 八、备选：docker run

无 Compose 或临时试玩：

```bash
sudo mkdir -p /www/wwwroot/clickhouse-server/{data,logs,config.d}
sudo chown -R "$USER:$USER" /www/wwwroot/clickhouse-server
# 先按第五节写入 config.d/listen.xml

docker run -d \
  --name clickhouse-server \
  --restart unless-stopped \
  --ulimit nofile=262144:262144 \
  -p 8123:8123 \
  -p 9000:9000 \
  -e TZ=Asia/Shanghai \
  -e CLICKHOUSE_DB=analytics \
  -e CLICKHOUSE_USER=default \
  -e CLICKHOUSE_PASSWORD=Changeme_CH_2026 \
  -e CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT=1 \
  -v /www/wwwroot/clickhouse-server/data:/var/lib/clickhouse \
  -v /www/wwwroot/clickhouse-server/logs:/var/log/clickhouse-server \
  -v /www/wwwroot/clickhouse-server/config.d:/etc/clickhouse-server/config.d \
  docker.xuanyuan.run/clickhouse/clickhouse-server:26.5.5.8
```

验证同第五、六节。长期使用建议迁回 Compose，便于升级与复现。

---

## 九、升级与迁移

1. 备份 `./data`（必要），按需备份 `./logs`、`config.d`。  
2. 改 Compose（及 run）中的完整版本标签；升到 **26.6+** 前确认有 **AVX2**。  
3. `docker compose pull && docker compose up -d`。  
4. `SELECT version()` 与业务冒烟确认。  

跨大版本先读官方 release notes，生产建议先在副本验证。

---

## 十、常见问题 FAQ

**Q：应该拉 `latest` 还是具体版本？**  
A：跟做与生产都用完整版本号（本文 **`26.5.5.8`**）。`latest` 会漂移。其它分支到 [标签列表](https://xuanyuan.cloud/r/clickhouse/clickhouse-server/tags) 选完整号，并核对 CPU。

**Q：日志刷 `Illegal instruction`，8123 / Play 连接被拒绝？**  
A：CPU 不够（26.6+ 要 AVX2），不是防火墙或密码问题。处理：

```bash
grep -o 'avx2' /proc/cpuinfo | head -1 || echo 'AVX2 NOT found'
grep -o 'sse4_2' /proc/cpuinfo | head -1 || echo 'SSE4.2 NOT found'

cd /www/wwwroot/clickhouse-server
docker compose down
# 首次部署可：rm -rf data/* logs/*

# 有 SSE4.2、无 AVX2：改回本文标签
sed -i 's|clickhouse/clickhouse-server:.*|clickhouse/clickhouse-server:26.5.5.8|g' docker-compose.yml
docker pull docker.xuanyuan.run/clickhouse/clickhouse-server:26.5.5.8
docker compose up -d
```

官方 Docker 镜像无公开 `amd64compat` 标签。物理机有 AVX2 时，虚拟机可改为 CPU **host / 透传** 再试 26.6+。

**Q：日志提示 `Instruction check fail` / 不支持 SSE4.2？**  
A：连 SSE4.2 都没有。换机或打开指令集透传；改密码、改端口无效。

**Q：为何必须设 `CLICKHOUSE_PASSWORD`？**  
A：未配置相关用户变量时，`default` 禁止网络访问。只映射端口不设密码，外连会失败。`CLICKHOUSE_SKIP_USER_SETUP=1` 仅适合极不安全的本地试验。

**Q：Play 报 `Code: 516`？**  
A：右上角 password 与 Compose 中 `CLICKHOUSE_PASSWORD` 不一致。

**Q：`curl` 报 `Syntax error: failed at position 1 (echo)`？**  
A：还在 `clickhouse-client` 交互里。先 `exit` 再执行 curl。

**Q：本机 curl `Connection reset`，容器内 client 却正常？**  
A：多半是 `Listen [::1]:8123 failed`。按第五节写入 `listen_host=0.0.0.0` 后 `docker compose restart`。

**Q：8123 和 9000 有什么区别？**  
A：**8123** 是 HTTP（curl、多数 SDK、Play）；**9000** 是原生协议（官方 client、部分驱动）。

**Q：和 `library/clickhouse` 教程有何不同？**  
A：见 **§1.1**。对照文：[library 部署教程](https://xuanyuan.cloud/blog/docker-clickhouse)。

**Q：挂载目录后权限报错起不来？**  
A：确认宿主机目录可写；或按官方用匹配的 `--user`。user namespace 场景可评估 `CLICKHOUSE_RUN_AS_ROOT=1`。

---

## 十一、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/clickhouse/clickhouse-server:26.5.5.8

# Compose（推荐）
cd /www/wwwroot/clickhouse-server
docker compose up -d
docker compose ps
docker compose logs -f --tail=100
docker compose down

# HTTP
echo 'SELECT version()' | curl -sS \
  'http://127.0.0.1:8123/?user=default&password=Changeme_CH_2026' \
  --data-binary @-

# 客户端
docker exec -it clickhouse-server clickhouse-client \
  --user default --password Changeme_CH_2026 \
  -q "SELECT version()"

# 备选 run（完整参数见第八节）
docker run -d --name clickhouse-server --ulimit nofile=262144:262144 \
  -p 8123:8123 -p 9000:9000 \
  -e CLICKHOUSE_PASSWORD=Changeme_CH_2026 \
  docker.xuanyuan.run/clickhouse/clickhouse-server:26.5.5.8
```

---

## 十二、延伸阅读

| 资源 | 链接 |
|------|------|
| [clickhouse/clickhouse-server 镜像页](https://xuanyuan.cloud/zh/r/clickhouse/clickhouse-server) | [https://xuanyuan.cloud/zh/r/clickhouse/clickhouse-server](https://xuanyuan.cloud/zh/r/clickhouse/clickhouse-server) |
| [标签列表](https://xuanyuan.cloud/r/clickhouse/clickhouse-server/tags) | [https://xuanyuan.cloud/r/clickhouse/clickhouse-server/tags](https://xuanyuan.cloud/r/clickhouse/clickhouse-server/tags) |
| [官方 Docker README](https://github.com/ClickHouse/ClickHouse/blob/master/docker/server/README.md) | [https://github.com/ClickHouse/ClickHouse/blob/master/docker/server/README.md](https://github.com/ClickHouse/ClickHouse/blob/master/docker/server/README.md) |
| [ClickHouse 官网](https://clickhouse.com/) | [https://clickhouse.com/](https://clickhouse.com/) |
| [配置文件文档](https://clickhouse.com/docs/operations/configuration_files) | [https://clickhouse.com/docs/operations/configuration_files](https://clickhouse.com/docs/operations/configuration_files) |
| [library/clickhouse 部署教程（对照）](https://xuanyuan.cloud/blog/docker-clickhouse) | [https://xuanyuan.cloud/blog/docker-clickhouse](https://xuanyuan.cloud/blog/docker-clickhouse) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- **`clickhouse/clickhouse-server`**：自托管列式 OLAP，HTTP **8123**（含 Play）+ 原生 **9000**。  
- 跟做固定 **`26.5.5.8`**（需 SSE4.2），用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取；主路径 Compose，`docker run` 仅作备选。有 AVX2 再考虑升 26.6+。  
- 必设 **`CLICKHOUSE_PASSWORD`**，挂载数据卷，建议 `listen_host=0.0.0.0` 与 `nofile=262144`。  
- Play 或 `SELECT version()` 冒烟通过后再接业务写入。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/clickhouse-server-docker-deploy


