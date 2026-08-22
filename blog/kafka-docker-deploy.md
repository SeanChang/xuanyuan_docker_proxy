# Docker 部署 Apache Kafka：轻松搭建分布式消息队列

![Docker 部署 Apache Kafka：轻松搭建分布式消息队列](https://assets.xuanyuan.me/docker/blog/docker-kafka.png)

*分类: Docker部署教程 | 标签: Apache Kafka,Kafka,Docker,轩辕镜像,消息队列,事件流,私有化部署,部署教程 | 发布时间: 2026-07-28 09:36:31*

> Apache Kafka 是 Apache 软件基金会 维护的开源 分布式事件流平台（最初由 LinkedIn 开发并开源）。它把事件按 主题（topic） 落盘保存，生产者写入、消费者按消费组独立拉取；同一条流既能给实时告警用，也能给离线数仓、审计回放用——不是「取走就没」的一次性队列，而是可重放的日志型存储。能力覆盖高吞吐写入、分区扩展、多订阅者并存，以及对接 Kafka Connect（外部系统进出）、Kafka Streams（JVM 流处理）等生态；全球大量组织用它支撑日志收集、事件驱动微服务、CDC 缓冲与实时分析前置层。集群跑在你自己的 Docker / 机器上，段文件与元数据落在本地卷里——本机或内网客户端连上就能收发，不必把核心事件流绑死在某一家公有云 MQ。

*本文基于 [apache/kafka:4.3.1](https://xuanyuan.cloud/zh/r/apache/kafka)，**Ubuntu 24.04** 实测。*

应用日志从十几台机器刷到一台中心机、订单状态在下单 / 支付 / 履约之间跳、前端埋点按秒级涌入、微服务之间又不愿同步 RPC 互相拖死……业务一大，这些「事件」就散落在各服务本地磁盘、临时队列和互不相通的脚本里：下游统计对不上上游、回放一次事故现场要靠翻日志人肉对齐、某个消费者挂了几小时又怕消息已经丢光。公有云消息队列 / 托管 Kafka 能把管道搭起来，但按流量与存储计费、关键业务事件躺在厂商侧、合规要求「数据不出域」、机房完全断公网、或只是想少一份 SaaS 账单时，就需要一条**可自托管、可持久化、可按需回放**的事件管道。

**Apache Kafka** 是 [Apache 软件基金会](https://kafka.apache.org/) 维护的开源 **分布式事件流平台**（最初由 LinkedIn 开发并开源）。它把事件按 **主题（topic）** 落盘保存，生产者写入、消费者按消费组独立拉取；同一条流既能给实时告警用，也能给离线数仓、审计回放用——不是「取走就没」的一次性队列，而是可重放的日志型存储。能力覆盖高吞吐写入、分区扩展、多订阅者并存，以及对接 **Kafka Connect**（外部系统进出）、**Kafka Streams**（JVM 流处理）等生态；全球大量组织用它支撑日志收集、事件驱动微服务、CDC 缓冲与实时分析前置层。集群跑在你自己的 Docker / 机器上，段文件与元数据落在本地卷里——本机或内网客户端连上就能收发，不必把核心事件流绑死在某一家公有云 MQ。

上手不是「`docker run` 一下就完事」。官方镜像默认以 **KRaft**（无 ZooKeeper）跑 **broker + controller 合一**；要从宿主机连，必须映射 **9092** 并写全 `KAFKA_*` 环境变量（**覆盖任意一项后默认配置整组失效**）。绑定数据目录时，容器内进程是 **`appuser`（uid=1000）**——`sudo mkdir` 出来的目录若不 `chown`，会直接 `AccessDeniedException` 重启循环。验证请用 **`docker exec`** 调镜像自带的 `kafka-topics.sh` 等工具，别在宿主机目录里找脚本。

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`apache/kafka:4.3.1`**，Compose 拉起单节点，**强制 `chown 1000:1000`**，再用一次性 `docker exec` 创建主题、生产 `hello`/`world`、从头消费验证。**Ubuntu 24.04** 全程实测，文末附运维命令与 FAQ。

> **说明**：本文 Compose 用于**短期试用 / 学习**，演示为 **PLAINTEXT**（无认证）。勿把 9092 裸暴露公网；生产请规划 SASL/TLS、多副本与运维方案。

镜像说明见 [apache/kafka 镜像页](https://xuanyuan.cloud/zh/r/apache/kafka)，标签列表见 [tags](https://xuanyuan.cloud/r/apache/kafka/tags)。官方文档：[Kafka Documentation](https://kafka.apache.org/documentation/)；延伸阅读：[Books and Papers](https://kafka.apache.org/books-and-papers)。

---

## 一、Apache Kafka 是什么？

**Apache Kafka** 面向「持续产生、需要被多方可靠消费」的数据：不是单纯的点对点任务队列，而是把事件写成**可追加、可分区、可保留一段时间的日志**。生产者往 topic 写，消费者用 **offset（位点）** 记住读到哪里；换一个消费组、或把位点拨回更早位置，就能重新处理同一批历史事件——这对排障回放、补数、多下游并行（实时大盘 + 离线入仓）特别有价值。

和「进程内 Channel / Redis List / 临时文件接力」相比，Kafka 的价值在于：**解耦写入与消费节奏**、**一写多读**、以及在磁盘上留下可审计的事件轨迹。代价是要理解 topic / 分区 / 消费组，以及运维上的磁盘、副本与监听地址（`advertised.listeners`）——这也是本文用 Compose 把单节点 KRaft 配齐、再用 CLI 走通收发的原因。

核心能力一览：

| 能力 | 说明 |
|------|------|
| 发布 / 订阅 | 多生产者写入；多消费组各自独立进度，互不抢消息 |
| 持久化与回放 | 消息按段落盘，可按保留策略保存；可从指定位点重放 |
| 分区与扩展 | topic 可多分片，吞吐与并行度随分区扩展（单节点演示用 1 分区） |
| 高吞吐 | 适合日志、埋点、订单与状态变更等大规模连续写入 |
| KRaft | 新版本默认内置共识管理元数据，**无需再挂 ZooKeeper** |
| 生态 | Connect（管道式进出）、Streams、各类语言客户端与 Flink 等下游 |
| 自托管 | 官方 Docker 镜像即可单节点跑通；数据落在自有卷 |

典型场景：

- 多机应用 / 访问日志汇聚后再进 ELK、ClickHouse 或对象存储
- 微服务之间的领域事件总线（下单、支付、库存变更异步通知）
- 数据库 CDC、数仓入湖前的缓冲与削峰
- 需要「先落盘、再多路消费」的实时指标与风控流水

架构（本文单节点 combined：broker 与 controller 同容器）：

```text
宿主机 / 客户端 ──PLAINTEXT:9092──▶ kafka 容器
                                      │
                         broker + controller（KRaft）
                                      │
                              ./data ──▶ /var/lib/kafka/data
```

> **版本与定位**：本文使用 **`apache/kafka:4.3.1`**，单节点 **PLAINTEXT** 仅适合试用与学习。生产请固定三位版本号，规划多副本、认证加密与监控；勿长期用裸 `latest`。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux 建议 **Ubuntu 24.04**（本文实测） |
| Docker | Engine + Compose V2（`docker compose`） |
| 内存 | 演示建议 ≥ **2 GB** 可用 |
| 磁盘 | 镜像约数百 MB + `./data` 增长 |
| 端口 | 宿主机 **9092**（PLAINTEXT） |
| 目录 | `/www/wwwroot/kafka`（数据子目录 `./data`） |
| 权限 | 数据目录属主须为 **uid/gid 1000**（对应容器内 `appuser`） |

```bash
docker --version
docker compose version
```

Linux 未装 Docker 请使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```


备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```
更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 三、标签怎么选

| 标签 | 用途 | 推荐 |
|------|------|------|
| `4.3.1` | 固定稳定版（本文实测） | **试用 / 本文首选** |
| `4.2.1` / `4.1.x` 等 | 较旧稳定线 | 仅业务要求留旧版 |
| `latest` | 跟踪最新稳定 | 仅临时试用 |
| `*-rc*` | 候选发布 | **勿上生产** |

[Apache Kafka 镜像标签列表](https://xuanyuan.cloud/r/apache/kafka/tags)。

---

## 四、拉取镜像（轩辕加速）

上游为 Docker Hub（`docker.io`）。轩辕镜像公共登录域 `docker.xuanyuan.run`：**首次**需 `docker login`；已登录则直接 pull。规范见 [登录拉取教程](https://xuanyuan.cloud/usage/login)。

```bash
grep -q '"docker.xuanyuan.run"' ~/.docker/config.json && echo "已登录" || echo "未登录"
# 未登录时：
# docker login docker.xuanyuan.run
```

```bash
sudo mkdir -p /www/wwwroot/kafka/data
cd /www/wwwroot/kafka

docker pull docker.xuanyuan.run/apache/kafka:4.3.1
```

实测拉取输出：

```text
4.3.1: Pulling from apache/kafka
6e338134b21e: Pull complete
4f4fb700ef54: Pull complete
da9d0fb3345c: Pull complete
5ef4bf1bda35: Pull complete
9ee28cb5e924: Pull complete
c62d3fe6c586: Pull complete
f9f362c352e2: Pull complete
cb74ead52f10: Pull complete
6a0ac1617861: Pull complete
625afcf9df2f: Pull complete
2d1a277377d1: Pull complete
42516208460b: Pull complete
32a86b41ef58: Download complete
Digest: sha256:77e3df9054047a88b520d0cc46e16696d3b22022e1d580aeccd2632df6532837
Status: Downloaded newer image for docker.xuanyuan.run/apache/kafka:4.3.1
docker.xuanyuan.run/apache/kafka:4.3.1
```

---

## 五、Docker Compose 部署

### 5.1 修正数据目录权限（必做）

镜像内进程用户为 **`appuser`（uid=1000, gid=1000）**。若 `./data` 属主是 root，启动时会出现：

```text
Error while writing meta.properties file /var/lib/kafka/data: java.nio.file.AccessDeniedException: /var/lib/kafka/data/bootstrap.checkpoint.tmp
```

容器会反复重启（`docker ps` 可能仍显示 Up，但 Up 时间很短）。部署前执行：

```bash
cd /www/wwwroot/kafka
sudo chown -R 1000:1000 /www/wwwroot/kafka/data
```

### 5.2 编写 docker-compose.yml

```bash
vim /www/wwwroot/kafka/docker-compose.yml
```

内容：

```yaml
services:
  broker:
    image: docker.xuanyuan.run/apache/kafka:4.3.1
    container_name: kafka
    restart: unless-stopped
    ports:
      - "9092:9092"
    environment:
      KAFKA_NODE_ID: 1
      KAFKA_PROCESS_ROLES: broker,controller
      KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@localhost:9093
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
      KAFKA_NUM_PARTITIONS: 1
      KAFKA_LOG_DIRS: /var/lib/kafka/data
    volumes:
      - ./data:/var/lib/kafka/data
```

| 配置项 | 说明 |
|--------|------|
| `KAFKA_PROCESS_ROLES` | `broker,controller`：单节点 combined（KRaft） |
| `KAFKA_ADVERTISED_LISTENERS` | 客户端拿到的连接地址；本机用 `localhost:9092`；局域网访问请改成服务器 IP |
| `KAFKA_LOG_DIRS` | 数据目录，对应挂载 `./data` |
| 副本相关 `*=1` | 单节点必须为 1，否则内部主题无法满足副本数 |

> **重要**：一旦设置任意 `KAFKA_*` 覆盖项，镜像内默认 broker 配置**不再生效**，须像上文一样写全 KRaft combined 必需变量。未设置 `CLUSTER_ID` 时，镜像会使用内置默认值（实测日志：`5L6g3nShT-eMCtK--X86sw`）。

### 5.3 启动与检查

```bash
cd /www/wwwroot/kafka
docker compose up -d
docker ps --filter name=kafka
docker logs kafka --tail 50
```

期望日志含 `Running in KRaft mode`、`Launching`、`Using provided cluster id ...`，且**不再**刷 `AccessDeniedException`。容器 Up 时间应持续增长。

若仍失败且 `./data` 里有半截脏文件（演示环境可清空后重来）：

```bash
docker compose down
sudo rm -rf ./data/*
sudo chown -R 1000:1000 ./data
docker compose up -d
```

实测 `docker ps` 正常时类似：

```text
CONTAINER ID   IMAGE                                    STATUS          PORTS                                         NAMES
39580d30b738   docker.xuanyuan.run/apache/kafka:4.3.1   Up …            0.0.0.0:9092->9092/tcp, [::]:9092->9092/tcp   kafka
```

---

## 六、验证：建主题 / 生产 / 消费

工具在镜像 `/opt/kafka/bin`。**推荐一次性 `docker exec`**，避免交互 shell 退出后在宿主机误跑 `./kafka-topics.sh`（会报 `No such file or directory`）。

刚 `up` 后 broker 可能还需数秒就绪；若建 topic 卡住，可先 `sleep 5` 再试。

```bash
# 建议稍等 broker 就绪
sleep 5

# 创建主题
docker exec --workdir /opt/kafka/bin kafka \
  ./kafka-topics.sh --bootstrap-server localhost:9092 --create --topic test-topic

# 列出主题（应看到 test-topic）
docker exec --workdir /opt/kafka/bin kafka \
  ./kafka-topics.sh --bootstrap-server localhost:9092 --list

# 生产两条消息（非交互）
docker exec --workdir /opt/kafka/bin kafka \
  sh -c 'printf "hello\nworld\n" | ./kafka-console-producer.sh --bootstrap-server localhost:9092 --topic test-topic'

# 从头消费（超时退出，避免一直挂住）
docker exec --workdir /opt/kafka/bin kafka \
  ./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test-topic --from-beginning --timeout-ms 5000
```

实测成功时，consumer 输出类似：

```text
The consumer rebalance protocol (KIP-848) is production-ready! ...
hello
world
[…] ERROR … TimeoutException
Processed a total of 2 messages
```

- 已打印 `hello` / `world`，且 `Processed a total of 2 messages` → **验证成功**。
- 末尾 `TimeoutException` 来自 `--timeout-ms 5000`，是**预期退出**，不是部署失败。
- KIP-848 相关提示为信息性日志，可忽略。
- 重跑 `--create` 若报 `Topic 'test-topic' already exists` → 主题已在，用 `--list` 即可。

若坚持交互进入容器：

```bash
docker exec -it --workdir /opt/kafka/bin kafka sh
# 确认提示符类似 /opt/kafka/bin $ 后再执行 ./kafka-topics.sh ...
# exit 后若提示符变回 root@主机名，说明已回到宿主机，勿再跑相对路径脚本
```

宿主机另装 Kafka 发行版客户端时，可用 `localhost:9092` 做同样验证（需与 `ADVERTISED_LISTENERS` 一致）。

---

## 七、进阶：多节点学习（非生产）

官方示例常见为 **3 controller + 3 broker**（KRaft isolated），并分别映射 `29092` / `39092` / `49092` 等端口，便于宿主机与 Docker 网络双路径访问。配置更长，且仍是学习向拓扑。

本文主路径保持单节点。需要多节点时，可参考 [apache/kafka 镜像页](https://xuanyuan.cloud/zh/r/apache/kafka) 中的 Compose 示例与 [Kafka 官方文档](https://kafka.apache.org/documentation/)，**勿直接当生产集群**。

---

## 八、常见问题 FAQ

**Q：日志出现 `AccessDeniedException: /var/lib/kafka/data/...`，容器反复重启？**  
A：`./data` 属主是 root，容器内 `appuser`（1000）写不进去。执行 `sudo chown -R 1000:1000 ./data` 后 `docker compose down && docker compose up -d`。演示环境若目录已脏，可先清空 `./data` 再 chown。

**Q：`./kafka-topics.sh: No such file or directory`？**  
A：命令跑在了**宿主机**，不是容器内。改用本文的 `docker exec --workdir /opt/kafka/bin kafka ./kafka-topics.sh ...`；或确认仍在容器 shell（提示符为 `/opt/kafka/bin $`）再执行。

**Q：刚启动就建 topic，命令一直卡住？**  
A：broker 尚未完全就绪。`sleep 5` 后再试，或先看 `docker logs kafka` 是否还有错误循环。

**Q：`Topic 'test-topic' already exists`？**  
A：主题已创建成功。用 `--list` 确认，或换一个主题名。

**Q：consumer 末尾报 `TimeoutException`，是不是失败了？**  
A：用了 `--timeout-ms 5000` 时，读完现有消息后超时退出是**预期行为**。只要已看到消息且有 `Processed a total of N messages` 即成功。

**Q：局域网其它机器连不上 `服务器IP:9092`？**  
A：把 `KAFKA_ADVERTISED_LISTENERS` 改成 `PLAINTEXT://服务器IP:9092`（或可解析主机名），重启 Compose；并放行防火墙 / 安全组 9092。客户端拿到的 advertised 地址必须是对方可达的。

**Q：为什么要写这么多 `KAFKA_*`？官方裸 `docker run` 不是更简单？**  
A：默认启动适合**容器内**客户端。要从宿主机映射端口连接，必须改 advertised 等项；而官方约定**一旦覆盖任意配置，默认整组失效**，因此要写全 KRaft combined 变量。

**Q：`docker pull` 报 401 / 402？**  
A：401 → 公共登录域需 `docker login docker.xuanyuan.run`（或凭证失效）。402 → 流量用尽，需充值，**不要**靠重新 login 解决。见 [轩辕 FAQ](https://xuanyuan.cloud/faq)。

**Q：9092 端口被占用？**  
A：改 Compose 的 `ports` 左侧（如 `"19092:9092"`），并同步改 `KAFKA_ADVERTISED_LISTENERS` 为客户端实际访问的宿主机端口。

**Q：`compose down` 会丢数据吗？**  
A：挂载了 `./data` 时，`down` 不删宿主机目录。只有清空 `./data` 或换空卷才会丢。加 `-v` 时注意是否误删命名卷（本文为绑定挂载）。

---

## 九、命令速查

```bash
# 登录态（docker.io 公共域）
grep -q '"docker.xuanyuan.run"' ~/.docker/config.json && echo "已登录" || echo "未登录"

# 拉取
docker pull docker.xuanyuan.run/apache/kafka:4.3.1

# 目录与权限
sudo mkdir -p /www/wwwroot/kafka/data
cd /www/wwwroot/kafka
sudo chown -R 1000:1000 ./data

# 启动 / 状态 / 日志
docker compose up -d
docker ps --filter name=kafka
docker logs kafka --tail 50

# 验证
docker exec --workdir /opt/kafka/bin kafka \
  ./kafka-topics.sh --bootstrap-server localhost:9092 --list

# 停止（保留 ./data）
docker compose down
```

---

## 十、延伸阅读

- [apache/kafka 轩辕镜像页](https://xuanyuan.cloud/zh/r/apache/kafka)
- [apache/kafka 标签列表](https://xuanyuan.cloud/r/apache/kafka/tags)
- [kafka 官方文档](https://kafka.apache.org/documentation/)
- [书籍与论文 Books and Papers](https://kafka.apache.org/books-and-papers)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)

---

## 总结

- 轩辕加速拉取 **`apache/kafka:4.3.1`**，Compose 单节点 **KRaft combined**，宿主机 **9092**
- **必做** `chown -R 1000:1000 ./data`，否则 `AccessDeniedException` 重启循环
- 用 **`docker exec`** 建 topic、生产、消费；consumer 的 `TimeoutException`（配合 `--timeout-ms`）是预期退出
- 演示为 PLAINTEXT，适合学习；生产需另行加固


