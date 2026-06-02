<!-- xuanyuan-docker-images-zh
image: timescale/timescaledb-ha
source: https://xuanyuan.cloud/zh/r/timescale/timescaledb-ha
canonical: https://xuanyuan.cloud/zh/r/timescale/timescaledb-ha
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [timescale/timescaledb-ha — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/timescale/timescaledb-ha "timescale/timescaledb-ha Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/timescale/timescaledb-ha

# TimescaleDB with Patroni 高可用镜像文档


## 一、镜像概述和主要用途

本镜像整合了 TimescaleDB（基于 PostgreSQL 的时序数据库）和 Patroni（PostgreSQL 高可用解决方案），旨在提供开箱即用的高可用时序数据库部署方案。通过 Patroni 的自动故障转移与主从复制能力，结合 TimescaleDB 对时序数据的优化特性，实现时序数据存储的高可用性、可靠性与性能优化。


## 二、核心功能和特性

### 2.1 TimescaleDB 核心特性
- **时序数据优化**：针对时间序列数据设计的自动分区（按时间/空间）、数据保留策略、时序聚合函数
- **PostgreSQL 兼容**：完全兼容 PostgreSQL 生态，支持 SQL 标准、索引类型（B-tree、GiST 等）及扩展
- **高性能写入**：优化批量写入性能，支持每秒数十万级时序数据点插入
- **数据压缩**：时序分区数据自动压缩，降低存储成本（最高可达 90% 压缩率）

### 2.2 Patroni 高可用特性
- **自动故障转移**：主节点故障时自动提升从节点为新主，恢复服务可用性
- **主从复制管理**：基于 PostgreSQL 流式复制，支持异步/同步复制模式配置
- **集群配置一致性**：通过分布式配置存储（默认支持 etcd、Consul、ZooKeeper）维护集群状态
- **自愈能力**：节点故障恢复后自动重新加入集群，同步数据并恢复复制关系


## 三、使用场景和适用范围

### 3.1 适用场景
- **监控与可观测性系统**：存储服务器、应用、网络设备的监控指标（如 Prometheus 后端存储）
- **IoT 数据平台**：处理海量传感器、设备的时序数据流（温度、湿度、位置等）
- **日志与事件分析**：存储应用日志、用户行为事件等带时间戳的结构化数据
- **金融交易记录**：存储高频交易数据，需保证数据完整性和服务连续性

### 3.2 适用范围
- 对数据可用性要求高（SLA ≥ 99.9%）的业务场景
- 时序数据量较大（TB 级以上）且需长期存储的场景
- 需要简化数据库集群运维（自动故障处理、配置管理）的场景


## 四、详细使用方法和配置说明

### 4.1 环境要求
- Docker Engine ≥ 20.10
- Docker Compose ≥ 2.10（集群部署时）
- 分布式配置存储（etcd/Consul/ZooKeeper，集群模式必需）
- 每个节点至少 2 CPU 核心、4GB 内存（生产环境建议 4 CPU/8GB 起）


### 4.2 基本使用（单节点测试）

#### 4.2.1 启动命令
```bash
docker run -d \
  --name timescaledb-patroni-test \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=StrongPassword123 \
  -e REPLICATION_PASSWORD=ReplPassword456 \
  -e PATRONI_SCOPE=timescale-cluster \
  -e PATRONI_MODE=standalone \
  -v timescaledb-data:/var/lib/postgresql/data \
  timescale/timescaledb-ha:latest
```

#### 4.2.2 参数说明
- `-p 5432:5432`：映射 PostgreSQL 默认端口
- `-v timescaledb-data:/var/lib/postgresql/data`：持久化存储数据目录
- `POSTGRES_PASSWORD`：数据库管理员（postgres 用户）密码
- `REPLICATION_PASSWORD`：复制用户（replicator）密码（用于主从同步）
- `PATRONI_SCOPE`：Patroni 集群标识（同一集群需一致）
- `PATRONI_MODE=standalone`：单节点模式（非集群）


### 4.3 集群部署（高可用模式）

#### 4.3.1 前置条件
- 部署 etcd 集群（示例使用单节点 etcd 测试，生产环境建议 3/5 节点集群）：
  ```bash
  docker run -d \
    --name etcd \
    -p 2379:2379 \
    -e ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379 \
    -e ETCD_ADVERTISE_CLIENT_URLS=http://etcd:2379 \
    quay.io/coreos/etcd:v3.5.9
  ```

#### 4.3.2 Docker Compose 集群配置（主从架构）
创建 `docker-compose.yml`：
```yaml
version: '3.8'

services:
  # 主节点
  patroni-master:
    image: timescale/timescaledb-ha:latest
    container_name: patroni-master
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_PASSWORD=StrongPassword123
      - REPLICATION_PASSWORD=ReplPassword456
      - PATRONI_SCOPE=timescale-cluster
      - PATRONI_MODE=master
      - PATRONI_ETCD_HOSTS=etcd:2379
      - PATRONI_RETRY_TIMEOUT=10
      - PATRONI_INITIAL_CLUSTER_SIZE=2
      - TIMESCALEDB_TELEMETRY=off  # 禁用遥测（可选）
    volumes:
      - master-data:/var/lib/postgresql/data
    depends_on:
      - etcd
    networks:
      - tsdb-network

  # 从节点
  patroni-replica:
    image: timescale/timescaledb-ha:latest
    container_name: patroni-replica
    ports:
      - "5433:5432"  # 避免端口冲突
    environment:
      - POSTGRES_PASSWORD=StrongPassword123
      - REPLICATION_PASSWORD=ReplPassword456
      - PATRONI_SCOPE=timescale-cluster
      - PATRONI_MODE=replica
      - PATRONI_ETCD_HOSTS=etcd:2379
      - PATRONI_RETRY_TIMEOUT=10
      - TIMESCALEDB_TELEMETRY=off
    volumes:
      - replica-data:/var/lib/postgresql/data
    depends_on:
      - etcd
    networks:
      - tsdb-network

  # etcd 配置存储
  etcd:
    image: quay.io/coreos/etcd:v3.5.9
    container_name: etcd
    ports:
      - "2379:2379"
    environment:
      - ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379
      - ETCD_ADVERTISE_CLIENT_URLS=http://etcd:2379
    volumes:
      - etcd-data:/default.etcd
    networks:
      - tsdb-network

volumes:
  master-data:
  replica-data:
  etcd-data:

networks:
  tsdb-network:
    driver: bridge
```

#### 4.3.3 启动集群
```bash
docker-compose up -d
```


### 4.4 核心配置参数说明

#### 4.4.1 Patroni 高可用配置（环境变量）
| 参数名                | 说明                                  | 默认值          |
|-----------------------|---------------------------------------|-----------------|
| `PATRONI_SCOPE`       | 集群唯一标识（所有节点需一致）        | `timescale`     |
| `PATRONI_MODE`        | 节点角色（`master`/`replica`/`standalone`） | `standalone`    |
| `PATRONI_ETCD_HOSTS`  | etcd 集群地址（格式：`host:port`）    | `localhost:2379`|
| `PATRONI_RETRY_TIMEOUT` | 故障转移重试间隔（秒）                | `10`            |
| `PATRONI_INITIAL_CLUSTER_SIZE` | 初始集群节点数（用于自动发现） | `1`             |
| `PATRONI_POSTGRESQL_DATA_DIR` | PostgreSQL 数据目录          | `/var/lib/postgresql/data` |

#### 4.4.2 TimescaleDB/PostgreSQL 配置（环境变量）
| 参数名                | 说明                                  | 默认值          |
|-----------------------|---------------------------------------|-----------------|
| `POSTGRES_PASSWORD`   | `postgres` 用户密码（必填）           | -               |
| `REPLICATION_PASSWORD` | 复制用户（`replicator`）密码（必填）  | -               |
| `POSTGRES_DB`         | 初始数据库名称                        | `postgres`      |
| `MAX_CONNECTIONS`     | 最大连接数                            | `100`           |
| `SHARED_BUFFERS`       | 共享内存缓冲区（建议物理内存 1/4）    | `128MB`         |
| `TIMESCALEDB_AUTO_CREATE_HYPERTABLES` | 是否自动创建时序表 | `on`            |


### 4.5 故障转移测试

1. **模拟主节点故障**：
   ```bash
   docker stop patroni-master
   ```

2. **观察从节点自动提升**：
   Patroni 会通过 etcd 检测主节点心跳丢失（默认 30 秒内），自动将从节点提升为新主。可通过以下命令验证新主节点：
   ```bash
   # 进入从节点容器
   docker exec -it patroni-replica bash
   # 查看 Patroni 状态
   patronictl -c /etc/patroni.yml list
   ```

3. **恢复原主节点**：
   重启原主节点后，Patroni 会自动将其作为从节点重新加入集群，同步新主数据：
   ```bash
   docker start patroni-master
   ```


## 五、部署注意事项

1. **数据持久化**：必须通过卷（Volume）挂载 `/var/lib/postgresql/data`，避免容器重启导致数据丢失。
2. **密码安全**：生产环境需使用强密码，并通过 Docker Secrets 或环境变量文件管理，避免明文暴露。
3. **etcd 高可用**：生产环境 etcd 集群需部署 3/5 节点（奇数），防止配置存储单点故障。
4. **资源配置**：根据数据量调整 `shared_buffers`、`work_mem` 等参数，建议参考 PostgreSQL 性能调优最佳实践。
5. **网络隔离**：集群节点间需保证网络互通（5432 端口用于复制，2379 端口用于 etcd 通信），生产环境建议配置防火墙规则限制访问。
