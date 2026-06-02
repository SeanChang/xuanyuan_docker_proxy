---
image: prom/mysqld-exporter
description: "Prometheus MySQL导出器，用于收集MySQL数据库性能指标并暴露给Prometheus监控系统，支持实时监控与指标分析。"
source: https://xuanyuan.cloud/zh/r/prom/mysqld-exporter
canonical: https://xuanyuan.cloud/zh/r/prom/mysqld-exporter
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/prom/mysqld-exporter" title="prom/mysqld-exporter Docker 镜像中文简介、标签列表与拉取命令">prom/mysqld-exporter — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/prom/mysqld-exporter" title="prom/mysqld-exporter Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/prom/mysqld-exporter</a>

# MySQL Server Exporter 镜像文档


## 1. 镜像概述

MySQL Server Exporter（`prom/mysqld-exporter`）是 Prometheus 生态中的一款指标导出工具，用于收集 MySQL 服务器的性能指标并提供给 Prometheus 进行监控。  

**支持版本**：  
- MySQL ≥ 5.6  
- MariaDB ≥ 10.3  

> **注意**：部分收集方法在 MySQL/MariaDB < 5.6 版本中不支持。


## 2. 核心功能与特性

- **多目标监控**：支持单实例模式（监控单个 MySQL 实例）和多目标模式（单个导出器监控多个 MySQL 实例）。  
- **丰富的指标收集**：提供对 MySQL 核心指标的收集，包括全局状态（`global_status`）、复制状态（`slave_status`）、性能模式（`perf_schema`）、信息模式（`info_schema`）等。  
- **安全配置**：支持 TLS 加密、基本认证，以及通过配置文件管理数据库认证信息。  
- **灵活的权限控制**：可通过数据库用户权限限制避免监控对 MySQL 服务器造成负载压力。  
- **心跳机制**：集成 `pt-heartbeat` 支持，可监控主从复制延迟。  


## 3. 使用场景

- **单实例监控**：适用于独立 MySQL 服务器的性能指标采集，如业务数据库实例。  
- **多目标监控**：适用于需要集中监控多个 MySQL 实例的场景（如数据库集群、多租户环境），通过单个导出器实例统一采集多个目标的指标。  


## 4. 使用方法与配置

### 4.1 前置准备：数据库用户权限配置

导出器需要通过 MySQL 用户连接数据库并采集指标，需预先创建具有以下权限的用户：

```sql
-- 创建用户（限制最大连接数避免监控过载，部分版本不支持该参数，见下方注意）
CREATE USER 'exporter'@'localhost' IDENTIFIED BY '密码' WITH MAX_USER_CONNECTIONS 3;
-- 授权必要权限
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'localhost';
```

> **注意**：  
> - `MAX_USER_CONNECTIONS` 用于限制监控连接数，避免高负载下影响数据库，但部分版本（如 Ubuntu 18.04 自带的 MariaDB 10.1）不支持该参数。  
> - 用户主机（如 `localhost`）需根据导出器部署位置调整（例如导出器部署在容器中时，需授权 `'exporter'@'%'`）。


### 4.2 运行方式

#### 4.2.1 单目标模式

通过本地 `.my.cnf` 配置文件连接 MySQL 实例：

```bash
./mysqld_exporter < flags >
```

配置文件 `.my.cnf` 示例（需包含数据库连接信息）：
```ini
[client]
user=exporter
password=密码
host=localhost
port=3306
```


#### 4.2.2 多目标模式

通过 HTTP 请求动态指定目标 MySQL 实例，请求端点为 `/probe?target=目标DSN`，其中 `target` 为 MySQL 实例的 DSN（如 `mysql://user:pass@host:3306`）。  

**配置文件示例**（支持多节配置，避免 URL 中暴露敏感信息）：
```ini
[client]          # 默认配置节
user=默认用户
password=默认密码

[client.server1]  # 自定义配置节（通过 auth_module 指定）
user=server1用户
password=server1密码

[client.server2]
user=server2用户
password=server2密码
```

**Prometheus 配置示例**（多目标采集）：
```yaml
- job_name: 'mysql-multi-target'
  metrics_path: /probe  # 多目标模式端点
  params:
    auth_module: [client.server1]  # 指定配置文件中的认证节（默认使用 [client]）
  static_configs:
    - targets:
      - server1:3306          # MySQL 实例 1
      - server2:3306          # MySQL 实例 2
      - unix:///run/mysqld/mysqld.sock  # Unix 套接字
  relabel_configs:
    - source_labels: [__address__]
      target_label: __param_target  # 将目标地址传递给 target 参数
    - source_labels: [__param_target]
      target_label: instance        # 指标中添加 instance 标签（目标地址）
    - target_label: __address__
      replacement: localhost:9104   # 导出器地址
```


### 4.3 配置参数

#### 4.3.1 收集器标志（Collector Flags）

通过标志启用/禁用特定指标收集器（格式：`--collect.<收集器名>` 启用，`--no-collect.<收集器名>` 禁用）。部分收集器依赖 MySQL 版本，具体如下：

| 标志名称 | 支持 MySQL 版本 | 描述 |
|-------------------------------|----------------|--------------------------------------------------------------------------|
| collect.auto_increment.columns | 5.1+ | 从 `information_schema` 收集自增列及最大值 |
| collect.binlog_size | 5.1+ | 收集所有已注册 binlog 文件的当前大小 |
| collect.engine_innodb_status | 5.1+ | 从 `SHOW ENGINE INNODB STATUS` 收集指标 |
| collect.engine_tokudb_status | 5.6+ | 从 `SHOW ENGINE TOKUDB STATUS` 收集指标 |
| collect.global_status | 5.1+ | 从 `SHOW GLOBAL STATUS` 收集指标（默认启用） |
| collect.global_variables | 5.1+ | 从 `SHOW GLOBAL VARIABLES` 收集指标（默认启用） |
| collect.heartbeat | 5.1+ | 从心跳表收集复制延迟指标（需配合 `pt-heartbeat`） |
| collect.heartbeat.database | 5.1+ | 心跳表所在数据库（默认：`heartbeat`） |
| collect.heartbeat.table | 5.1+ | 心跳表名（默认：`heartbeat`） |
| collect.heartbeat.utc | 5.1+ | 使用 UTC 时间戳（默认：`false`） |
| collect.info_schema.clientstats | 5.5+ | 启用 `userstat=1` 时，收集客户端统计信息 |
| collect.info_schema.innodb_metrics | 5.6+ | 从 `information_schema.innodb_metrics` 收集指标 |
| collect.info_schema.innodb_tablespaces | 5.7+ | 从 `information_schema.innodb_sys_tablespaces` 收集指标 |
| collect.info_schema.processlist | 5.1+ | 从 `information_schema.processlist` 收集线程状态计数 |
| collect.info_schema.processlist.min_time | 5.1+ | 线程状态计数的最小持续时间（默认：0 秒） |
| collect.slave_status | 5.1+ | 从 `SHOW SLAVE STATUS` 收集复制状态（默认启用） |
| collect.slave_hosts | 5.1+ | 从 `SHOW SLAVE HOSTS` 收集从库信息 |
| collect.perf_schema.eventsstatements | 5.6+ | 从 `performance_schema.events_statements_summary_by_digest` 收集指标 |


#### 4.3.2 通用标志（General Flags）

| 标志名称 | 描述 |
|---------------------------|--------------------------------------------------------------------------|
| mysqld.address | MySQL 连接地址，格式：`host:port`（默认：`localhost:3306`） |
| mysqld.username | MySQL 连接用户名 |
| config.my-cnf | 数据库配置文件路径（默认：`~/.my.cnf`），用于存储认证信息 |
| log.level | 日志级别（默认：`info`） |
| exporter.lock_wait_timeout | 连接的 `lock_wait_timeout`（秒，默认：2），避免元数据锁等待 |
| exporter.enable_lock_wait_timeout | 是否启用 `lock_wait_timeout`（默认：`true`） |
| web.listen-address | 导出器 HTTP 服务监听地址（默认：`:9104`） |
| web.telemetry-path | 指标暴露路径（默认：`/metrics`） |
| version | 打印版本信息 |


### 4.4 环境变量

| 环境变量 | 描述 |
|-------------------------|------------------------------------------|
| MYSQLD_EXPORTER_PASSWORD | MySQL 连接密码（优先级低于配置文件） |


### 4.5 配置优先级

若同时通过命令行标志（如 `--mysqld.username`）和配置文件（`.my.cnf`）配置参数，**配置文件中的 `[client]` 节配置会覆盖命令行标志**。


### 4.6 TLS 与基本认证

导出器支持通过 `--web.config.file` 指定配置文件启用 TLS 和基本认证，配置文件格式参考 [exporter-toolkit 文档](https://github.com/prometheus/exporter-toolkit/blob/master/docs/web-configuration.md)。


### 4.7 SSL 连接配置

若 MySQL 服务器启用 SSL，需在配置文件（`.my.cnf`）中指定 SSL 证书：

```ini
[client]
ssl-ca=/path/to/ca.pem          # CA 证书路径
ssl-key=/path/to/client-key.pem # 客户端私钥路径
ssl-cert=/path/to/client-cert.pem # 客户端证书路径
```


## 5. Docker 部署

### 5.1 使用 `docker run` 部署

```bash
# 创建网络（若导出器与 MySQL 容器需通信）
docker network create my-mysql-network

# 运行导出器（挂载本地配置文件 .my.cnf 到容器内）
docker run -d \
  --name mysqld-exporter \
  -p 9104:9104 \
  -v /本地路径/.my.cnf:/.my.cnf \  # 挂载配置文件（包含数据库认证信息）
  --network my-mysql-network \      # 加入 MySQL 所在网络（若需容器内通信）
  prom/mysqld-exporter
```

> **说明**：配置文件 `.my.cnf` 需包含 `[client]` 节及数据库连接信息（用户、密码、地址等）。


### 5.2 使用 `docker-compose` 部署

创建 `docker-compose.yml`：

```yaml
version: '3'
services:
  mysqld-exporter:
    image: prom/mysqld-exporter
    container_name: mysqld-exporter
    ports:
      - "9104:9104"
    volumes:
      - ./my.cnf:/.my.cnf  # 挂载本地配置文件
    networks:
      - my-network
    restart: unless-stopped

networks:
  my-network:
    external: true  # 使用已创建的网络（需提前创建：docker network create my-network）
```

启动：`docker-compose up -d`


## 6. 心跳机制（Heartbeat）

启用 `collect.heartbeat` 后，导出器可通过心跳机制监控主从复制延迟，需配合 [pt-heartbeat](https://www.percona.com/doc/percona-toolkit/2.2/pt-heartbeat.html)（Percona 工具包中的心跳工具）使用。`pt-heartbeat` 在主库写入心跳记录，从库读取并计算延迟，导出器从心跳表中采集延迟指标。


## 7. 过滤启用的收集器

默认情况下，导出器暴露所有启用的收集器指标。可通过 Prometheus 配置中的 `collect[]` 参数过滤需采集的指标（适用于按需采集特定指标的场景）：

```yaml
# Prometheus  scrape 配置示例
scrape_configs:
  - job_name: 'mysql-filtered'
    static_configs:
      - targets: ['localhost:9104']
    params:
      collect[]:  # 仅采集以下收集器指标
        - global_status
        - slave_status
```


## 8. 示例规则与告警

导出器配套的 [mysqld-mixin](https://github.com/prometheus/mysqld_exporter/tree/main/mysqld-mixin) 提供了示例监控规则、告警规则和 Grafana 仪表板，可直接集成到 Prometheus 和 Grafana 中。
