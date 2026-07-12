---
image: prometheuscommunity/postgres-exporter
description: "Prometheus社区维护的PostgreSQL数据库指标导出器，用于收集PostgreSQL性能指标并暴露给Prometheus监控系统。"
source: https://xuanyuan.cloud/zh/r/prometheuscommunity/postgres-exporter
canonical: https://xuanyuan.cloud/zh/r/prometheuscommunity/postgres-exporter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/prometheuscommunity/postgres-exporter" title="prometheuscommunity/postgres-exporter Docker 镜像中文简介、标签列表与拉取命令">prometheuscommunity/postgres-exporter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PostgreSQL Server Exporter

## 镜像概述和主要用途

PostgreSQL Server Exporter是一个Prometheus exporter，用于收集PostgreSQL服务器的指标。它能够从PostgreSQL数据库实例中提取各种性能和状态指标，并以Prometheus可抓取的格式暴露这些指标，便于监控和告警。

CI测试过的PostgreSQL版本：`13`、`14`、`15`、`16`、`17`。

## 核心功能和特性

- 收集多种PostgreSQL性能指标，包括数据库统计、连接数、复制状态、锁信息等
- 支持通过环境变量或配置文件配置数据库连接
- 多目标支持（BETA），可从单个exporter实例监控多个PostgreSQL实例
- 可配置的指标收集器，支持启用/禁用特定指标集
- 支持TLS和基本身份验证保护指标端点
- 容器化部署，使用非root用户运行，增强安全性

## 使用场景和适用范围

- PostgreSQL数据库服务器的性能监控
- 数据库健康状态检查和告警
- 性能瓶颈分析和容量规划
- 多数据库实例集中监控
- 云环境或容器化环境中的PostgreSQL监控

## 详细的使用方法和配置说明

### 快速开始

该软件包提供Docker镜像：

```bash
# 启动示例数据库
docker run --net=host -it --rm -e POSTGRES_PASSWORD=password docker.xuanyuan.run/postgres

# 连接到数据库
docker run \
  --net=host \
  -e DATA_SOURCE_URI="localhost:5432/postgres?sslmode=disable" \
  -e DATA_SOURCE_USER=postgres \
  -e DATA_SOURCE_PASS=password \
  ***-quay.xuanyuan.run/prometheuscommunity/postgres-exporter
```

测试指标暴露：
```bash
curl "http://localhost:9187/metrics"
```

Prometheus配置示例：
```yaml
scrape_configs:
  - job_name: postgres
    static_configs:
      - targets: ["127.0.0.1:9187"]  # 如果在独立网络中运行容器，请将IP替换为docker容器的主机名
```

建议使用DATA_SOURCE_PASS_FILE配合挂载文件来存储密码，避免将密码存储在环境变量中。容器进程使用uid/gid 65534运行（对文件权限很重要）。

### 多目标支持（BETA）

**此功能处于测试阶段，未来版本可能会有变化。欢迎提供反馈。**

该exporter支持[多目标模式](https://prometheus.io/docs/guides/multi-target-exporter/)。这允许运行单个exporter实例来监控多个PostgreSQL目标。此功能是**可选的**，适用于无法将exporter作为sidecar安装的场景，例如SaaS托管服务。

要使用多目标功能，向端点`/probe?target=foo:5432`发送HTTP请求，其中target设置为要抓取指标的PostgreSQL实例的DSN。

为避免在URL中包含用户名和密码等敏感信息，通过配置文件的[auth_modules](#auth_modules)部分支持预配置的身份验证模块。通过指定`?auth_module=foo`HTTP参数，可以在`/probe`端点使用DSN的auth_modules。

Prometheus配置示例：
```yaml
scrape_configs:
  - job_name: 'postgres'
    static_configs:
      - targets:
        - server1:5432
        - server2:5432
    metrics_path: /probe
    params:
      auth_module: [foo]
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: 127.0.0.1:9116  # postgres exporter的实际主机名:端口
```

### 配置文件

配置文件控制exporter的行为。可以使用`--config.file`命令行标志设置，默认为`postgres_exporter.yml`。

#### auth_modules

此部分定义用于[多目标端点](#多目标支持-beta)的预设身份验证和连接参数。`auth_modules`是模块映射，键是可在`/probe`端点中使用的标识符。目前仅支持`userpass`类型。

示例：
```yaml
auth_modules:
  foo1:  # 可设置为任何名称
    type: userpass
    userpass:
      username: first
      password: firstpass
    options:
      # 选项将成为DSN的key=value参数
      sslmode: disable
```

### 构建和运行

```bash
git clone https://github.com/prometheus-community/postgres_exporter.git
cd postgres_exporter
make build
./postgres_exporter <flags>
```

构建Docker镜像：
```bash
make promu
promu crossbuild -p linux/amd64 -p linux/armv7 -p linux/arm64 -p linux/ppc64le
make docker
```

这将构建名为`prometheuscommunity/postgres_exporter:${branch}`的Docker镜像。

### 命令行标志

| 标志 | 描述 |
|------|------|
| `help` | 显示上下文相关帮助（也可尝试--help-long和--help-man） |
| `[no-]collector.database` | 启用`database`收集器（默认：启用） |
| `[no-]collector.database_wraparound` | 启用`database_wraparound`收集器（默认：禁用） |
| `[no-]collector.locks` | 启用`locks`收集器（默认：启用） |
| `[no-]collector.long_running_transactions` | 启用`long_running_transactions`收集器（默认：禁用） |
| `[no-]collector.postmaster` | 启用`postmaster`收集器（默认：禁用） |
| `[no-]collector.process_idle` | 启用`process_idle`收集器（默认：禁用） |
| `[no-]collector.replication` | 启用`replication`收集器（默认：启用） |
| `[no-]collector.replication_slot` | 启用`replication_slot`收集器（默认：启用） |
| `[no-]collector.stat_activity_autovacuum` | 启用`stat_activity_autovacuum`收集器（默认：禁用） |
| `[no-]collector.stat_bgwriter` | 启用`stat_bgwriter`收集器（默认：启用） |
| `[no-]collector.stat_database` | 启用`stat_database`收集器（默认：启用） |
| `[no-]collector.stat_progress_vacuum` | 启用`stat_progress_vacuum`收集器（默认：启用） |
| `[no-]collector.stat_statements` | 启用`stat_statements`收集器（默认：禁用） |
| `[no-]collector.stat_statements.include_query` | 启用选择语句查询和queryId（默认：禁用） |
| `--collector.stat_statements.query_length` | 语句文本的最大长度，默认120 |
| `[no-]collector.stat_user_tables` | 启用`stat_user_tables`收集器（默认：启用） |
| `[no-]collector.stat_wal_receiver` | 启用`stat_wal_receiver`收集器（默认：禁用） |
| `[no-]collector.statio_user_indexes` | 启用`statio_user_indexes`收集器（默认：禁用） |
| `[no-]collector.statio_user_tables` | 启用`statio_user_tables`收集器（默认：启用） |
| `[no-]collector.wal` | 启用`wal`收集器（默认：启用） |
| `[no-]collector.xlog_location` | 启用`xlog_location`收集器（默认：禁用） |
| `config.file` | 设置配置文件路径，默认为`postgres_exporter.yml` |
| `web.systemd-socket` | 使用systemd套接字激活监听器代替端口监听器（仅限Linux），默认`false` |
| `web.listen-address` | Web界面和遥测的监听地址，默认`:9187` |
| `web.config.file` | 用于TLS和/或基本身份验证的配置文件 |
| `web.telemetry-path` | 暴露指标的路径，默认`/metrics` |
| `disable-default-metrics` | 仅使用`--extend.query-path`提供的指标，默认`false` |
| `disable-settings-metrics` | 不抓取`pg_settings`，默认`false` |
| `auto-discover-databases` (DEPRECATED) | 是否动态发现服务器上的数据库，默认`false` |
| `extend.query-path` (DEPRECATED) | 包含自定义查询的YAML文件路径 |
| `dumpmaps` | 不运行，打印指标映射的内部表示，调试自定义查询文件时有用 |
| `constantLabels` (DEPRECATED) | 所有指标中设置的标签，`label=value`对的列表，用逗号分隔 |
| `version` | 显示应用程序版本 |
| `exclude-databases` (DEPRECATED) | 启用autoDiscoverDatabases时要排除的数据库列表 |
| `include-databases` (DEPRECATED) | 启用autoDiscoverDatabases时仅包含的数据库列表 |
| `log.level` | 设置日志级别：`debug`、`info`、`warn`、`error`之一 |
| `log.format` | 设置日志格式：`logfmt`、`json`之一 |

### 环境变量

以下环境变量用于配置exporter：

| 环境变量 | 描述 |
|---------|------|
| `DATA_SOURCE_NAME` | 默认的传统格式，接受URI形式和key=value形式的参数，URI可包含连接的用户名和密码 |
| `DATA_SOURCE_URI` | `DATA_SOURCE_NAME`的替代方案，仅接受不含用户名和密码的主机名，例如`my_pg_hostname`或`my_pg_hostname:5432/postgres?sslmode=disable` |
| `DATA_SOURCE_URI_FILE` | 与上述相同，但从文件读取URI |
| `DATA_SOURCE_USER` | 使用`DATA_SOURCE_URI`时，用于指定用户名 |
| `DATA_SOURCE_USER_FILE` | 与上述相同，但从文件读取用户名 |
| `DATA_SOURCE_PASS` | 使用`DATA_SOURCE_URI`时，用于指定连接密码 |
| `DATA_SOURCE_PASS_FILE` | 与上述相同，但从文件读取密码 |
| `PG_EXPORTER_WEB_TELEMETRY_PATH` | 暴露指标的路径，默认`/metrics` |
| `PG_EXPORTER_DISABLE_DEFAULT_METRICS` | 仅使用`queries.yaml`提供的指标，值为`true`或`false`，默认`false` |
| `PG_EXPORTER_DISABLE_SETTINGS_METRICS` | 不抓取`pg_settings`，值为`true`或`false`，默认`false` |
| `PG_EXPORTER_AUTO_DISCOVER_DATABASES` (DEPRECATED) | 是否动态发现服务器上的数据库，值为`true`或`false`，默认`false` |
| `PG_EXPORTER_EXTEND_QUERY_PATH` | 包含自定义查询的YAML文件路径 |
| `PG_EXPORTER_CONSTANT_LABELS` (DEPRECATED) | 所有指标中设置的标签，`label=value`对的列表，用逗号分隔 |
| `PG_EXPORTER_EXCLUDE_DATABASES` (DEPRECATED) | 启用autoDiscoverDatabases时要排除的数据库逗号分隔列表，默认为空字符串 |
| `PG_EXPORTER_INCLUDE_DATABASES` (DEPRECATED) | 启用autoDiscoverDatabases时仅包含的数据库逗号分隔列表，默认为空字符串，表示允许所有 |
| `PG_EXPORTER_METRIC_PREFIX` | postgres-exporter导出的每个默认指标使用的前缀，默认为`pg` |

以`PG_`开头的环境变量设置的配置，如果给定了相应的CLI标志，将被CLI标志覆盖。

### 设置PostgreSQL服务器的数据源名称

PostgreSQL服务器的[数据源名称](http://en.wikipedia.org/wiki/Data_source_name)必须通过`DATA_SOURCE_NAME`环境变量设置。

对于在默认Debian/Ubuntu安装上本地运行，以下命令将起作用（可相应地转换为init脚本）：

```bash
sudo -u postgres DATA_SOURCE_NAME="user=postgres host=/var/run/postgresql/ sslmode=disable" postgres_exporter
```

此外，可以设置源列表以从一个exporter设置中抓取不同的实例。只需定义一个逗号分隔的字符串：

```bash
sudo -u postgres DATA_SOURCE_NAME="port=5432,port=6432" postgres_exporter
```

有关格式化连接字符串的其他方式，请参见[github.com/lib/pq](http://github.com/lib/pq)模块。

### 以非超级用户身份运行

要能够以非超级用户身份从PostgreSQL服务器版本>=10的`pg_stat*`视图收集指标，可以将`pg_monitor`或`pg_read_all_stats`[内置角色](https://www.postgresql.org/docs/current/predefined-roles.html)授予该用户。如果需要监控较旧的PostgreSQL服务器，必须以超级用户身份创建函数和视图，并单独为这些用户分配权限。

```sql
-- 要使用IF语句，因此能够在尝试创建用户之前检查用户是否存在，
-- 我们需要切换到过程SQL（PL/pgSQL）而不是标准SQL。
-- 更多信息：https://www.postgresql.org/docs/9.3/plpgsql-overview.html
-- 为了保持与<9.0的兼容性，不使用DO块；而是创建并删除一个函数。
CREATE OR REPLACE FUNCTION __tmp_create_user() returns void as $
BEGIN
  IF NOT EXISTS (
          SELECT                       -- 为此，SELECT列表可以为空
          FROM   docker.xuanyuan.run/pg_catalog.pg_user
          WHERE  usename = 'postgres_exporter') THEN
    CREATE USER postgres_exporter;
  END IF;
END;
$ language plpgsql;

SELECT __tmp_create_user();
DROP FUNCTION __tmp_create_user();

ALTER USER postgres_exporter WITH PASSWORD 'password';
ALTER USER postgres_exporter SET SEARCH_PATH TO postgres_exporter,pg_catalog;

-- 如果以非超级用户部署（例如在AWS RDS中），取消下面的GRANT行注释并将<MASTER_USER>替换为您的root用户。
-- GRANT postgres_exporter TO <MASTER_USER>;

GRANT CONNECT ON DATABASE postgres TO postgres_exporter;
```

如果使用PostgreSQL版本>=10，运行以下命令：
```sql
GRANT pg_monitor to postgres_exporter;
```

仅当使用早于10的PostgreSQL版本时，运行以下SQL命令。在PostgreSQL中，视图以创建它们的用户的权限运行，因此它们可以充当安全屏障。需要创建函数来与非超级用户共享此数据。仅创建视图会遗漏最重要的数据位。

```sql
CREATE SCHEMA IF NOT EXISTS postgres_exporter;
GRANT USAGE ON SCHEMA postgres_exporter TO postgres_exporter;

CREATE OR REPLACE FUNCTION get_pg_stat_activity() RETURNS SETOF pg_stat_activity AS
$$ SELECT * FROM pg_catalog.pg_stat_activity; $$
LANGUAGE sql
VOLATILE
SECURITY DEFINER;

CREATE OR REPLACE VIEW postgres_exporter.pg_stat_activity
AS
  SELECT * from get_pg_stat_activity();

GRANT SELECT ON postgres_exporter.pg_stat_activity TO postgres_exporter;

CREATE OR REPLACE FUNCTION get_pg_stat_replication() RETURNS SETOF pg_stat_replication AS
$$ SELECT * FROM pg_catalog.pg_stat_replication; $$
LANGUAGE sql
VOLATILE
SECURITY DEFINER;

CREATE OR REPLACE VIEW postgres_exporter.pg_stat_replication
AS
  SELECT * FROM get_pg_stat_replication();

GRANT SELECT ON postgres_exporter.pg_stat_replication TO postgres_exporter;

CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE OR REPLACE FUNCTION get_pg_stat_statements() RETURNS SETOF pg_stat_statements AS
$$ SELECT * FROM public.pg_stat_statements; $$
LANGUAGE sql
VOLATILE
SECURITY DEFINER;

CREATE OR REPLACE VIEW postgres_exporter.pg_stat_statements
AS
  SELECT * FROM get_pg_stat_statements();

GRANT SELECT ON postgres_exporter.pg_stat_statements TO postgres_exporter;
```

> **注意**
> <br />请记住在连接字符串中使用`postgres`数据库名称：
> ```
> DATA_SOURCE_NAME=postgresql://postgres_exporter:password@localhost:5432/postgres?sslmode=disable
> ```

## Docker部署方案示例

### 使用docker run部署

基本部署：
```bash
docker run -d \
  --name postgres-exporter \
  -p 9187:9187 \
  -e DATA_SOURCE_URI="postgres:5432/postgres?sslmode=disable" \
  -e DATA_SOURCE_USER=postgres_exporter \
  -e DATA_SOURCE_PASS=secure_password \
  ***-quay.xuanyuan.run/prometheuscommunity/postgres-exporter
```

使用密码文件部署：
```bash
# 创建密码文件
echo "secure_password" > /path/to/passfile
chmod 600 /path/to/passfile

# 运行容器，挂载密码文件
docker run -d \
  --name postgres-exporter \
  -p 9187:9187 \
  -e DATA_SOURCE_URI="postgres:543
