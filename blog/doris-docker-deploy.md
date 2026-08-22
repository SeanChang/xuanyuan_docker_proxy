# Docker 部署 Apache Doris 完整教程：快速搭建 OLAP 数据库

![Docker 部署 Apache Doris 完整教程：快速搭建 OLAP 数据库](https://img.xuanyuan.dev/docker/blog/doris.webp)

*分类: Docker部署教程 | 标签: Apache Doris,Doris,Docker,轩辕镜像,OLAP,MPP,实时分析,私有化部署,部署教程 | 发布时间: 2026-07-22 02:43:06*

> 业务看板要秒级刷新、运营要按用户/订单做多维下钻，用传统行存库扛聚合又慢又贵；把整仓扔公有云分析服务，又担心成本与数据出境——很多团队会把目光投向可自托管的实时数仓，Apache Doris 正是为此而生。

> *本文基于 [apache/doris](https://xuanyuan.cloud/zh/r/apache/doris) 官方运行时镜像 **`fe-4.1.3` + `be-4.1.3`**，**正文默认 Linux（host 网络）**；含 **持久化挂卷** 与 **macOS bridge** 专节。Compose 与验证命令可直接复用。*

业务看板要秒级刷新、运营要按用户/订单做多维下钻，用传统行存库扛聚合又慢又贵；把整仓扔公有云分析服务，又担心成本与数据出境——很多团队会把目光投向可自托管的实时数仓。**Apache Doris** 正是为此而生：它是 Apache 软件基金会旗下的开源 **MPP 实时分析型数据库**，以「极致速度 + 易用」为卖点——在海量数据上常能做到**亚秒级**查询响应，同一套系统既能扛**高并发点查**（如按主键查明细、画像），也能做**高吞吐复杂分析**（多表 Join、宽表聚合、实时报表）。对运维与研发更友好的是：它高度兼容 **MySQL 协议与 ANSI SQL 风格**，现有的 mysql 客户端、JDBC、DBeaver、各类 BI 往往改连接串就能用；内置 FE Web（默认 **8030**）可直接写 SQL、看节点与日志，不必先搭一整套外围工具。

架构上 Doris 把职责拆成 **FE（Frontend）** 与 **BE（Backend）**：FE 负责接收 SQL、解析规划、管理元数据与节点；BE 负责数据存储与计算执行。生产可多 FE / 多 BE 做高可用，本文用 Docker 先跑通最小形态——**1 FE + 1 BE**。存算一体之外，新版本也支持存算分离等架构，可按业务规模再演进。典型落地包括：对内/对外实时大盘、用户行为与漏斗分析、A/B 实验、日志与可观测分析，以及湖仓联邦查询加速等。

本文用 [轩辕镜像](https://xuanyuan.cloud) 加速，在 Linux 上用 **Docker Compose 拉起 1 FE + 1 BE**：固定标签、验证集群 Alive，再用 **Web（8030）** 与 **MySQL 协议（9030）** 建库查数。

镜像页见 [apache/doris](https://xuanyuan.cloud/zh/r/apache/doris)，官方快速入门见 [Doris Quick Start](https://doris.apache.org/zh-CN/docs/4.x/gettingStarted/quick-start/)，项目主页 [doris.apache.org](https://doris.apache.org/)、仓库 [apache/doris](https://github.com/apache/doris)。

> **定位说明**：官方明确 Docker Quick Start 偏 **本地开发 / 体验**；**§四** 默认 Compose **未挂数据卷**，`docker compose down` 后数据可能丢失。需要数据落盘请用 **§五 持久化 Compose**。生产高可用仍建议官方「本地完整部署」或多节点 / K8s。

---

## 一、Apache Doris 是什么？

**Apache Doris** 是基于 **MPP** 架构的开源实时分析型数据库，以极致速度与易用性著称：海量数据下可提供亚秒级查询，同时覆盖高并发点查与高吞吐复杂分析。高度兼容 **MySQL 协议**，可用 mysql 客户端、JDBC、DBeaver 等直接连接。

| 能力 | 说明 |
|------|------|
| MPP + 向量化 | FE 管元数据与规划，BE 存算执行 |
| MySQL 协议 | 默认查询端口 **9030**，学习成本低 |
| Web UI | FE **8030** 内置登录、Playground、System、Log 等 |
| 场景 | 实时报表、用户行为、湖仓加速、日志与可观测分析 |

架构示意（本文单机 1 FE + 1 BE）：

```text
浏览器 ──HTTP:8030──▶  FE（元数据 / SQL 入口）
mysql / DBeaver ──MySQL:9030──▶  FE
FE ──心跳 / 调度──▶  BE（存储与计算）
```

### 1.1 标签怎么选（必看）

`apache/doris` **不是** 一个 `latest` 就能跑，标签按角色拆分：

| 标签前缀 | 用途 | 本文是否使用 |
|---------|------|-------------|
| `fe-x.y.z` | Frontend | **要**（`fe-4.1.3`） |
| `be-x.y.z` | Backend | **要**（`be-4.1.3`，与 FE **同版本**） |
| `broker-x.y.z` | 外部存储 Broker | 快速体验不需要 |
| `ms-x.y.z` | 存算分离 MetaService | 不需要 |
| `operator-x.y.z` | K8s Operator | 不需要 |
| `build-env-*` | **源码编译环境**，不能当运行时 | **不要** |
| `*-latest` | 浮动标签 | 文稿 / 复现 **不推荐** |

更多标签见 [标签列表](https://xuanyuan.cloud/r/apache/doris/tags)。

### 1.2 Doris 和 ClickHouse 有什么区别？

两者都是主流 **OLAP**，但定位不同：

| | **Apache Doris** | **ClickHouse** |
|--|------------------|----------------|
| 架构 | MPP，**FE + BE** 分角色，偏「一套数据库产品」 | 单节点即可很强，也可分片；偏「分析引擎」 |
| SQL / 接入 | **高度兼容 MySQL 协议**，BI / JDBC 几乎开箱 | 自有协议 + HTTP；也有 MySQL 兼容层，习惯不同 |
| 典型场景 | 实时报表、高并发点查 + 复杂分析、湖仓、面向业务的实时数仓 | 日志 / 埋点 / 指标海量写入与宽表聚合、可观测 |
| 更新 | Unique / Aggregate 等模型，行级更新相对友好 | 偏追加写；更新删除有代价，近年在加强 |
| Docker 形态 | 至少 **两个镜像**（fe + be） | 常 **一个容器** 就能玩 |

**怎么选：**

- 要 MySQL 兼容、报表 / BI、点查与分析一体、团队更熟关系库 → 优先 **Doris**
- 要日志指标狂写狂聚合、单机压榨吞吐 → 优先 **ClickHouse**
- 可并存：ClickHouse 扛流水，Doris 做面向业务的实时数仓。本仓库另有 [ClickHouse Docker 部署教程](../library_clickhouse/clickhouse-docker-deploy.md)。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 操作系统 | **Linux x86_64**（正文默认；Ubuntu 等均可） |
| Docker | Docker Engine + **Compose V2**（`docker compose`） |
| 内存 | 建议 ≥ **8 GB** 可用（FE+BE 同机体验） |
| CPU | amd64 **必须支持 AVX2**（约 Intel 4 代 Haswell / 2013 年后常见 i5 多数支持） |
| 磁盘 | 镜像合计数 GB 级 + 数据增长 |
| 端口 | **8030**（FE Web）、**9030**（MySQL）、另有 9010/9050 等集群内部端口 |
| 工作目录 | `/data/doris`（示例） |

```bash
docker --version
docker compose version
```

未装 Docker 可用轩辕一键脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)

# 备用地址1
bash <(wget -qO- https://get.xuanyuan.dev/docker.sh)

# 备用地址2
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

### 2.1 部署前自检 AVX2（强烈建议）

官方说明：amd64 运行时镜像 **仅支持带 AVX2 的 CPU**；无 AVX2 需按 [Doris docker/runtime](https://github.com/apache/doris/tree/master/docker/runtime) 自建镜像。

```bash
grep -o 'avx2' /proc/cpuinfo | head -1 || echo 'AVX2 NOT found'
```

| 结果 | 说明 |
|------|------|
| 有 `avx2` | 可继续拉取与启动 |
| **`AVX2 NOT found`** | **不要硬启动**官方 fe/be；换机或自建 no-avx2 镜像 |

---

## 三、拉取镜像

本文固定成对标签 **`fe-4.1.3` + `be-4.1.3`**。不要拉 `build-env-*`。

```bash
docker pull docker.xuanyuan.run/apache/doris:fe-4.1.3
docker pull docker.xuanyuan.run/apache/doris:be-4.1.3
```

实测完整输出（节选）：

```text
fe-4.1.3: Pulling from apache/doris
…
Digest: sha256:3dd47644cd9fa8152028bdae449e77170ab0de004bd7a3fa311a204a106c26c7
Status: Downloaded newer image for docker.xuanyuan.run/apache/doris:fe-4.1.3
docker.xuanyuan.run/apache/doris:fe-4.1.3

be-4.1.3: Pulling from apache/doris
…
Digest: sha256:9f84a8b018069cd3c9a65af42ff5ef2c733b3b25e1ca708e0a3e4078361a1eb3
Status: Downloaded newer image for docker.xuanyuan.run/apache/doris:be-4.1.3
docker.xuanyuan.run/apache/doris:be-4.1.3
```

> 国内建议全程使用 `docker.xuanyuan.run`。需登录时见 [登录认证说明](https://xuanyuan.cloud/usage)。

---

## 四、Linux 部署（正文默认）

与官方 `start-doris.sh` 在 Linux 上的行为一致：使用 **`network_mode: host`**，FE/BE 通过 **`127.0.0.1`** 互通。

### 4.1 创建目录与 compose 文件

```bash
mkdir -p /data/doris
cd /data/doris
vim docker-compose.yml
```

内容：

```yaml
services:
  fe:
    image: docker.xuanyuan.run/apache/doris:fe-4.1.3
    hostname: fe
    environment:
      - FE_SERVERS=fe1:127.0.0.1:9010
      - FE_ID=1
    network_mode: host
  be:
    image: docker.xuanyuan.run/apache/doris:be-4.1.3
    hostname: be
    environment:
      - FE_SERVERS=fe1:127.0.0.1:9010
      - BE_ADDR=127.0.0.1:9050
    depends_on:
      - fe
    network_mode: host
```

| 配置项 | 说明 |
|--------|------|
| `FE_SERVERS` | FE 列表，`名称:IP:edit_log_port` |
| `FE_ID=1` | 单 FE 场景固定为 1 |
| `BE_ADDR` | 本机 BE 心跳地址 `IP:9050` |
| `network_mode: host` | Linux 下 FE/BE 共用宿主机网络栈，端口直接落在宿主机 |

> **不要**把下文 macOS 的 `172.20.80.x` 配置抄到 Linux host 模式里混用。

### 4.2 启动

```bash
docker compose up -d
docker compose ps
docker compose logs --tail=50
```

期望两个服务均为 **Up**。首次启动请 **等待 1～2 分钟** 再验证（FE/BE 注册与心跳需要时间）。

> 仅体验可继续用上面这份 Compose。若要 **`compose down` 后仍保留库表与日志**，请改用 **§五**。

---

## 五、持久化 Compose（数据与日志落盘）

§四 的体验 Compose **没有挂卷**：元数据、表数据都在容器可写层里，删容器即丢。官方集群示例与文档约定的落盘路径如下（与 [Doris docker-compose-demo](https://github.com/apache/doris/tree/master/docker/runtime/docker-compose-demo) 一致）：

| 角色 | 宿主机目录（示例） | 容器内路径 | 作用 |
|------|-------------------|------------|------|
| FE | `./fe/doris-meta` | `/opt/apache-doris/fe/doris-meta` | FE 元数据 |
| FE | `./fe/log` | `/opt/apache-doris/fe/log` | FE 日志 |
| BE | `./be/storage` | `/opt/apache-doris/be/storage` | BE 数据盘 |
| BE | `./be/log` | `/opt/apache-doris/be/log` | BE 日志 |

> **关于配置文件**：镜像内已有默认 `fe.conf` / `be.conf`。一般**不要**把空的 `./fe/conf`、`./be/conf` 直接挂进容器（会盖掉镜像默认配置导致起不来）。需要改参数时：先 `docker compose up` 再 `docker cp` 拷出配置到宿主机改好，或只挂你确认完整的 conf 目录；日常持久化 **优先保证 meta / storage / log** 即可。

### 5.1 创建目录

```bash
mkdir -p /data/doris/{fe/doris-meta,fe/log,be/storage,be/log}
cd /data/doris
```

### 5.2 Linux 持久化 docker-compose.yml

在 §四 基础上增加 `volumes` 与 `restart`（网络仍为 host）：

```yaml
services:
  fe:
    image: docker.xuanyuan.run/apache/doris:fe-4.1.3
    hostname: fe
    restart: unless-stopped
    environment:
      - FE_SERVERS=fe1:127.0.0.1:9010
      - FE_ID=1
    volumes:
      - ./fe/doris-meta:/opt/apache-doris/fe/doris-meta
      - ./fe/log:/opt/apache-doris/fe/log
    network_mode: host
  be:
    image: docker.xuanyuan.run/apache/doris:be-4.1.3
    hostname: be
    restart: unless-stopped
    environment:
      - FE_SERVERS=fe1:127.0.0.1:9010
      - BE_ADDR=127.0.0.1:9050
    volumes:
      - ./be/storage:/opt/apache-doris/be/storage
      - ./be/log:/opt/apache-doris/be/log
    depends_on:
      - fe
    network_mode: host
```

```bash
docker compose up -d
docker compose ps
```

验证步骤与 **§六** 相同。之后：

```bash
docker compose down     # 停止并删容器，./fe ./be 数据仍在
docker compose up -d    # 再用同一目录拉起，库表应还在
```

| 操作 | 体验 Compose（§四） | 持久化 Compose（本节） |
|------|---------------------|------------------------|
| `compose down` | 数据易丢 | **meta / storage / log 保留** |
| 换机迁移 | 难 | 打包拷贝 `/data/doris/fe`、`/data/doris/be` |
| 适用 | 试玩、跟教程 | 本机长期用、小团队试用 |

> 若你**已经**用 §四 无卷跑过一版，容器里已有数据：简单加挂卷**不会自动**把旧容器层数据迁到宿主机。建议：导出重要表 / 接受重建，或先 `docker cp` 再切换到持久化 Compose 做**新集群**。生产多副本、高可用仍请走官方完整部署。

### 5.3 macOS 持久化（在 §七 bridge 上加卷）

网络仍用 `172.20.80.0/24`，只增加与 Linux 相同的四条挂载即可，例如：

```yaml
# 在 fe / be 服务中分别增加（其余 ports、environment、networks 同 §七）
# fe:
#   volumes:
#     - ./fe/doris-meta:/opt/apache-doris/fe/doris-meta
#     - ./fe/log:/opt/apache-doris/fe/log
# be:
#   volumes:
#     - ./be/storage:/opt/apache-doris/be/storage
#     - ./be/log:/opt/apache-doris/be/log
```

目录同样先 `mkdir -p fe/doris-meta fe/log be/storage be/log`。

---

## 六、验证与使用（Linux）

### 6.1 MySQL 协议验证（9030）

本机已装 mysql 客户端时：

```bash
mysql -uroot -P9030 -h127.0.0.1 -e 'SELECT `host`, `join`, `alive` FROM frontends()'
mysql -uroot -P9030 -h127.0.0.1 -e 'SELECT `host`, `alive` FROM backends()'
```

未安装客户端时，可用临时容器（建议轩辕拉取，避免直连 Docker Hub 超时）：

```bash
docker run --rm -it docker.xuanyuan.run/library/mysql:8.0 \
  mysql -uroot -P9030 -h127.0.0.1 \
  -e 'SELECT `host`, `join`, `alive` FROM frontends()'

docker run --rm -it docker.xuanyuan.run/library/mysql:8.0 \
  mysql -uroot -P9030 -h127.0.0.1 \
  -e 'SELECT `host`, `alive` FROM backends()'
```

> 若 `library/mysql` 坐标在你环境不可用，可试 `docker.xuanyuan.run/mysql:8.0`（实测可用）。

期望：FE 的 `Join` / `Alive` 为 **true**；BE 的 `Alive` 为 **1**（或 `true`，视版本输出而定）。

也可交互进入：

```bash
mysql -uroot -P9030 -h127.0.0.1
# 或
docker run --rm -it docker.xuanyuan.run/mysql:8.0 \
  mysql -uroot -P9030 -h127.0.0.1
```

```sql
SHOW FRONTENDS\G
SHOW BACKENDS\G
```

### 6.2 建库建表冒烟

```sql
CREATE DATABASE demo;
USE demo;

CREATE TABLE mytable (
  k1 TINYINT,
  k2 DECIMAL(10, 2) DEFAULT "10.05",
  k3 CHAR(10),
  k4 INT NOT NULL DEFAULT "1"
)
DISTRIBUTED BY HASH(k1) BUCKETS 1
PROPERTIES ("replication_num" = "1");

INSERT INTO mytable VALUES
(1, 0.14, 'a1', 20),
(2, 1.04, 'b2', 21);

SELECT * FROM demo.mytable;
```

期望返回 2 行。单机体验请保持 **`replication_num = 1`**（只有一个 BE）。

### 6.3 默认账号与改密

| 项 | 值 |
|----|-----|
| 用户 | `root` |
| 初始密码 | **空**（不填） |
| Web | `http://<服务器IP>:8030` |
| MySQL | `<服务器IP>:9030` |

建议立刻改密（**须在 MySQL 客户端执行**；内置 Web **不能**执行 `SET` 类语句）：

```sql
SET PASSWORD FOR 'root' = PASSWORD('你的强密码');
```

### 6.4 浏览器 Web UI（8030）

打开（把 IP 换成你的服务器）：

```text
http://<服务器IP>:8030/login
```

用户名 `root`，密码初始为空（若已改密则填新密码），点 **Login**。

![Doris Web 登录页 Username Password Login](https://img.xuanyuan.dev/docker/blog/doris-1.webp)

*图 1：FE Web 登录页（`http://服务器IP:8030/login`），默认 `root` / 空密码*

登录后可在 **System** 查看版本与硬件信息（版本类似 `doris-4.1.3-rc02`）：

![Doris System 页显示版本 doris-4.1.3-rc02 与主机信息](https://img.xuanyuan.dev/docker/blog/doris-2.webp)

*图 2：System — 版本、主机名、内存与磁盘等环境信息*

**System** 下还有类似 `/proc` 的 **System Info** 索引（`frontends`、`backends`、`dbs` 等），便于点选查看集群状态：

![Doris System Info 列出 backends frontends dbs 等入口](https://img.xuanyuan.dev/docker/blog/doris-5.webp)

*图 3：System Info — 集群诊断入口列表*

打开 **Playground**，可在浏览器里写 SQL（左侧为库表树，中间为编辑器）：

![Doris Playground 空白 SQL 编辑器](https://img.xuanyuan.dev/docker/blog/doris-3.webp)

*图 4：Playground — 内置 SQL 编辑器*

例如验证 FE 状态：

```sql
SELECT host, join, alive FROM frontends()
```

执行成功后可见 `Alive = true`：

![Playground 执行 frontends 查询 Join Alive 均为 true](https://img.xuanyuan.dev/docker/blog/doris-4.webp)

*图 5：Playground 查询 `frontends()`，Join / Alive 为 true*

**Log** 页可在线查看 FE 日志（路径类似 `/opt/apache-doris/fe/log/fe.warn.log`）：

![Doris Log 页查看 fe.warn.log](https://img.xuanyuan.dev/docker/blog/doris-6.webp)

*图 6：Log — 浏览器查看 FE 告警 / 错误日志*

**QueryProfile** 可查看已完成查询画像（刚部署时常为空）：

![Doris QueryProfile Finished Queries 暂无数据](https://img.xuanyuan.dev/docker/blog/doris-7.webp)

*图 7：QueryProfile — 已完成查询列表（初期可为空）*

**Session** 查看当前会话：

![Doris Session Info 当前无活跃会话](https://img.xuanyuan.dev/docker/blog/doris-8.webp)

*图 8：Session — 会话列表*

**Configuration** 可浏览 FE 配置项（条目很多，便于核对参数）：

![Doris Configuration 配置项列表](https://img.xuanyuan.dev/docker/blog/doris-9.webp)

*图 9：Configuration — FE 配置一览*

---

## 七、macOS 部署（专节）

Docker Desktop（Mac）上 **`network_mode: host` 基本不可用**，请改用官方 Quick Start 同思路的 **bridge + 固定 IP**，并做端口映射。与 Linux 配置 **不能混用**。

### 7.1 macOS Compose

```yaml
networks:
  doris_net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.80.0/24

services:
  fe:
    image: docker.xuanyuan.run/apache/doris:fe-4.1.3
    hostname: fe
    ports:
      - "8030:8030"
      - "9030:9030"
      - "9010:9010"
    environment:
      - FE_SERVERS=fe1:172.20.80.2:9010
      - FE_ID=1
    networks:
      doris_net:
        ipv4_address: 172.20.80.2

  be:
    image: docker.xuanyuan.run/apache/doris:be-4.1.3
    hostname: be
    ports:
      - "8040:8040"
      - "9050:9050"
    environment:
      - FE_SERVERS=fe1:172.20.80.2:9010
      - BE_ADDR=172.20.80.3:9050
    depends_on:
      - fe
    networks:
      doris_net:
        ipv4_address: 172.20.80.3
```

```bash
docker compose up -d
# 等 1～2 分钟
```

### 7.2 macOS 验证差异

| 项 | Linux | macOS |
|----|-------|-------|
| 网络 | host + `127.0.0.1` | bridge `172.20.80.0/24` |
| FE / BE 地址 | `127.0.0.1` | `172.20.80.2` / `172.20.80.3` |
| 端口映射 | 不需要 | 需要 |
| mysql 从容器连 | `-h127.0.0.1` | 常用 `-hhost.docker.internal` |
| Web | `http://127.0.0.1:8030` 或局域网 IP | 同左（已映射 8030） |

```bash
docker run --rm -it docker.xuanyuan.run/mysql:8.0 \
  mysql -uroot -P9030 -hhost.docker.internal \
  -e 'SELECT `host`, `join`, `alive` FROM frontends()'

docker run --rm -it docker.xuanyuan.run/mysql:8.0 \
  mysql -uroot -P9030 -hhost.docker.internal \
  -e 'SELECT `host`, `alive` FROM backends()'
```

实测期望示例：FE `host=172.20.80.2` 且 Alive；BE `host=172.20.80.3` 且 Alive=1。Web 登录与 Playground 步骤同 **§六**（上文截图即在 macOS bridge 环境采集）。需要持久化时按 **§5.3** 给 fe/be 增加 volumes。

---

## 八、日常运维

```bash
cd /data/doris   # 或你的 compose 目录
docker compose ps
docker compose logs -f --tail=100
docker compose restart
docker compose down    # 体验 Compose（§四）停后数据易丢；持久化 Compose（§五）会保留 ./fe ./be
docker compose up -d
```

**日常用法简述：**

1. `docker compose up -d` 启动  
2. 浏览器打开 `http://IP:8030` 写 SQL，或用 mysql / DBeaver 连 `IP:9030`  
3. 用完可 `docker compose down`（已挂卷则数据仍在宿主机）  

升级：同步改 FE/BE 镜像标签为同一版本 → `docker compose pull && docker compose up -d`。升级前建议备份 `/data/doris/fe`、`/data/doris/be`。

---

## 九、FAQ

**Q：可以只拉一个镜像吗？**  
A：快速体验至少需要 **成对的 `fe-x.y.z` 与 `be-x.y.z`**。`build-env-*` 是编译环境，不能当数据库跑。

**Q：配置和数据有没有持久化？**  
A：**§四 体验 Compose 没有。** 需要落盘请用 **§五**：挂载 `fe/doris-meta`、`be/storage` 以及双方 `log`。不要空目录硬挂 `conf`，以免盖掉镜像默认配置。

**Q：容器起来了但 BE Alive 一直不对？**  
A：多等 1～2 分钟；确认 FE/BE **同版本**；Linux 用 host + `127.0.0.1`，macOS 用 bridge 固定 IP，**不要混用**。看 FE Log（图 6）是否有 `No backend available` 一类报错。

**Q：本机提示 `zsh: command not found: mysql`？**  
A：未装客户端。用临时容器连接（见 §6.1 / §7.2），或 `brew install mysql-client`（macOS）。

**Q：拉 `mysql:8.0` 超时？**  
A：国内请走轩辕，例如 `docker.xuanyuan.run/mysql:8.0`，勿直连 `registry-1.docker.io`。

**Q：Web 默认密码是什么？**  
A：`root` / **空密码**。改密用 MySQL 客户端执行 `SET PASSWORD`；Web 不能执行 SET。

**Q：CPU 是 i5 能跑吗？**  
A：关键是 **有没有 AVX2**，不是牌子。约 4 代及以后的桌面 i5 多数可以；用 §2.1 命令自检。

**Q：Docker 部署适合生产吗？**  
A：官方认为 Quick Start Docker **偏体验**；即便加了挂卷，单机单副本仍不等于生产高可用。生产请参考官方完整部署 / 多节点 / K8s Operator。

**Q：和 ClickHouse 怎么选？**  
A：见 **§1.2**。需要 MySQL 协议与「数仓产品」体验偏 Doris；日志指标狂写偏 ClickHouse。

---

## 十、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/apache/doris:fe-4.1.3
docker pull docker.xuanyuan.run/apache/doris:be-4.1.3

# 持久化目录（推荐）
mkdir -p /data/doris/{fe/doris-meta,fe/log,be/storage,be/log}
cd /data/doris

# 启动（使用 §五 的 docker-compose.yml）
docker compose up -d
docker compose ps

# 验证
mysql -uroot -P9030 -h127.0.0.1 -e 'SHOW FRONTENDS'
mysql -uroot -P9030 -h127.0.0.1 -e 'SHOW BACKENDS'

# Web
# http://<IP>:8030

# 停止（持久化后数据仍在 ./fe ./be）
docker compose down
```

---

## 十一、延伸阅读

- 轩辕镜像页：[apache/doris](https://xuanyuan.cloud/zh/r/apache/doris)
- 标签列表：[apache/doris tags](https://xuanyuan.cloud/r/apache/doris/tags)
- 官方快速入门：[5 分钟快速入门](https://doris.apache.org/zh-CN/docs/4.x/gettingStarted/quick-start/)
- 官方网站：[doris.apache.org](https://doris.apache.org/)
- GitHub：[apache/doris](https://github.com/apache/doris)
- 轩辕使用手册：[xuanyuan.cloud/usage](https://xuanyuan.cloud/usage)
- 同系列：[ClickHouse Docker 部署](../library_clickhouse/clickhouse-docker-deploy.md)

