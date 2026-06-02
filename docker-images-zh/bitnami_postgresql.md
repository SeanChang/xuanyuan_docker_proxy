---
image: bitnami/postgresql
description: "Bitnami PostgreSQL安全镜像是一款专为PostgreSQL数据库设计的预配置、安全强化型容器镜像，集成自动更新的安全补丁、最小化攻击面架构、合规性验证工具及行业最佳安全实践，旨在简化数据库部署流程，同时保障数据存储与访问的安全性、稳定性及可靠性，适用于企业级应用场景下高效、安全的数据库环境搭建。"
source: https://xuanyuan.cloud/zh/r/bitnami/postgresql
canonical: https://xuanyuan.cloud/zh/r/bitnami/postgresql
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/postgresql" title="bitnami/postgresql Docker 镜像中文简介、标签列表与拉取命令">bitnami/postgresql 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami PostgreSQL 软件包


## 什么是 PostgreSQL？

PostgreSQL（简称 Postgres）是一款开源对象关系型数据库，以可靠性和数据完整性著称。它符合 ACID 标准，支持外键、连接、视图、触发器及存储过程。

[PostgreSQL 概述]([])  
商标说明：本软件列表由 Bitnami 打包。所提及的相关商标分属各自公司所有，使用这些商标不意味着任何关联或背书。


## 快速启动

```console
docker run --name postgresql bitnami/postgresql:latest
```

**警告**：此快速设置仅适用于开发环境。建议修改不安全的默认凭据，并参考 [配置](#配置) 部分了解更多安全部署的可用选项。


### Bitnami 安全镜像说明
该镜像是由 Bitnami 构建和维护的强化型、最小化 CVE 镜像。Bitnami 安全镜像基于云优化、安全强化的企业级操作系统 [Photon Linux]([])。选择 BSI 镜像的理由包括：  
- 提供热门开源软件的强化安全镜像，漏洞数量接近零  
- 结合 VEX 声明、KEV 和 EPSS 评分，对漏洞进行分类和优先级排序  
- 注重合规性，支持 FIPS、STIG 和离线部署选项，包括安全物料清单（SBOM）  
- 通过 in-toto 提供软件供应链来源证明  
- 原生支持主流 Helm 图表  

每个镜像均附带有价值的安全元数据，可在 [公共目录]([]) 中查看。注：部分数据需 [订阅 BSI 商业版]([]) 方可获取。  

如需基于 Debian Linux 的旧版镜像，可查看 Bitnami Legacy 仓库。


## 配置

### 环境变量

#### 可自定义环境变量

| 名称                                       | 说明                                                                 | 默认值                                      |
|--------------------------------------------|----------------------------------------------------------------------|---------------------------------------------|
| `POSTGRESQL_VOLUME_DIR`                    | 持久化基础目录                                                       | `/bitnami/postgresql`                       |
| `POSTGRESQL_DATA_DIR`                      | PostgreSQL 数据目录                                                  | `${POSTGRESQL_VOLUME_DIR}/data`             |
| `POSTGRESQL_EXTRA_FLAGS`                   | PostgreSQL 初始化额外参数                                            | `nil`                                       |
| `POSTGRESQL_INIT_MAX_TIMEOUT`              | 初始化最大等待超时时间（秒）                                         | `60`                                        |
| `POSTGRESQL_PGCTLTIMEOUT`                  | pg_ctl 命令最大等待超时时间（秒）                                    | `60`                                        |
| `POSTGRESQL_SHUTDOWN_MODE`                 | pg_ctl stop 命令默认模式                                             | `fast`                                      |
| `POSTGRESQL_CLUSTER_APP_NAME`              | 复制集群默认应用名称                                                 | `walreceiver`                               |
| `POSTGRESQL_DATABASE`                      | 默认数据库名称                                                       | `postgres`                                  |
| `POSTGRESQL_INITDB_ARGS`                   | initdb 操作可选参数                                                  | `nil`                                       |
| `ALLOW_EMPTY_PASSWORD`                     | 是否允许无密码访问                                                   | `no`                                        |
| `POSTGRESQL_INITDB_WAL_DIR`                | initdb WAL 目录（可选）                                              | `nil`                                       |
| `POSTGRESQL_MASTER_HOST`                   | 主库主机地址（从库使用）                                             | `nil`                                       |
| `POSTGRESQL_MASTER_PORT_NUMBER`            | 主库端口（从库使用）                                                 | `5432`                                      |
| `POSTGRESQL_NUM_SYNCHRONOUS_REPLICAS`      | 同步复制的从库数量                                                   | `0`                                         |
| `POSTGRESQL_SYNCHRONOUS_REPLICAS_MODE`     | 同步复制模式（可选值：空、FIRST、ANY）                               | `nil`                                       |
| `POSTGRESQL_PORT_NUMBER`                   | 数据库端口                                                           | `5432`                                      |
| `POSTGRESQL_ALLOW_REMOTE_CONNECTIONS`      | 是否修改 pg_hba 配置允许外部访问                                     | `yes`                                       |
| `POSTGRESQL_REPLICATION_MODE`              | 复制模式（可选值：master、slave）                                    | `master`                                    |
| `POSTGRESQL_REPLICATION_USER`              | 复制用户名称                                                         | `nil`                                       |
| `POSTGRESQL_REPLICATION_USE_PASSFILE`      | 是否使用 PGPASSFILE 而非 PGPASSWORD                                  | `no`                                        |
| `POSTGRESQL_REPLICATION_PASSFILE_PATH`     | 密码文件存储路径                                                     | `${POSTGRESQL_CONF_DIR}/.pgpass`            |
| `POSTGRESQL_SR_CHECK`                      | 是否创建流复制检查用户                                               | `no`                                        |
| `POSTGRESQL_SR_CHECK_USERNAME`             | 流复制检查用户名                                                     | `sr_check_user`                             |
| `POSTGRESQL_SR_CHECK_DATABASE`             | 流复制检查数据库                                                     | `postgres`                                  |
| `POSTGRESQL_SYNCHRONOUS_COMMIT_MODE`       | 从库同步提交模式（数量由 `POSTGRESQL_NUM_SYNCHRONOUS_REPLICAS` 定义）| `on`                                        |
| `POSTGRESQL_FSYNC`                         | 是否启用 WAL 日志 fsync                                              | `on`                                        |
| `POSTGRESQL_USERNAME`                      | 默认用户名                                                           | `postgres`                                  |
| `POSTGRESQL_ENABLE_LDAP`                   | 是否启用 LDAP 认证                                                   | `no`                                        |
| `POSTGRESQL_LDAP_URL`                      | LDAP 服务器 URL（需 `POSTGRESQL_ENABLE_LDAP=yes`）                   | `nil`                                       |
| `POSTGRESQL_LDAP_PREFIX`                   | LDAP 前缀（需 `POSTGRESQL_ENABLE_LDAP=yes`）                         | `nil`                                       |
| `POSTGRESQL_LDAP_SUFFIX`                   | LDAP 后缀（需 `POSTGRESQL_ENABLE_LDAP=yes`）                         | `nil`                                       |
| `POSTGRESQL_LDAP_SERVER`                   | LDAP 服务器地址（需 `POSTGRESQL_ENABLE_LDAP=yes`）                   | `nil`                                       |
| `POSTGRESQL_LDAP_PORT`                     | LDAP 端口（需 `POSTGRESQL_ENABLE_LDAP=yes`）                         | `nil`                                       |
| `POSTGRESQL_LDAP_SCHEME`                   | LDAP 协议（需 `POSTGRESQL_ENABLE_LDAP=yes`）                         | `nil`                                       |
| `POSTGRESQL_LDAP_TLS`                      | LDAP TLS 设置（需 `POSTGRESQL_ENABLE_LDAP=yes`）                      | `nil`                                       |
| `POSTGRESQL_LDAP_BASE_DN`                  | LDAP 基础 DN（需 `POSTGRESQL_ENABLE_LDAP=yes`）                      | `nil`                                       |
| `POSTGRESQL_LDAP_BIND_DN`                  | LDAP 绑定 DN（需 `POSTGRESQL_ENABLE_LDAP=yes`）                      | `nil`                                       |
| `POSTGRESQL_LDAP_BIND_PASSWORD`            | LDAP 绑定密码（需 `POSTGRESQL_ENABLE_LDAP=yes`）                     | `nil`                                       |
| `POSTGRESQL_LDAP_SEARCH_ATTR`              | LDAP 搜索属性（需 `POSTGRESQL_ENABLE_LDAP=yes`）                     | `nil`                                       |
| `POSTGRESQL_LDAP_SEARCH_FILTER`            | LDAP 搜索过滤器（需 `POSTGRESQL_ENABLE_LDAP=yes`）                   | `nil`                                       |
| `POSTGRESQL_INITSCRIPTS_USERNAME`          | `/docker-entrypoint.initdb` 中 psql 脚本的用户名                      | `$POSTGRESQL_USERNAME`                      |
| `POSTGRESQL_PASSWORD`                      | 默认用户密码                                                         | `nil`                                       |
| `POSTGRESQL_POSTGRES_PASSWORD`             | postgres 用户密码                                                    | `nil`                                       |
| `POSTGRESQL_REPLICATION_PASSWORD`          | 复制用户密码                                                         | `nil`                                       |
| `POSTGRESQL_SR_CHECK_PASSWORD`             | 流复制检查用户密码                                                   | `nil`                                       |
| `POSTGRESQL_INITSCRIPTS_PASSWORD`          | 初始化脚本用户密码                                                   | `$POSTGRESQL_PASSWORD`                      |
| `POSTGRESQL_ENABLE_TLS`                    | 是否启用 TLS 加密                                                   | `no`                                        |
| `POSTGRESQL_TLS_CERT_FILE`                 | TLS 证书文件路径                                                     | `nil`                                       |
| `POSTGRESQL_TLS_KEY_FILE`                  | TLS 密钥文件路径                                                     | `nil`                                       |
| `POSTGRESQL_TLS_CA_FILE`                   | TLS CA 证书文件路径                                                  | `nil`                                       |
| `POSTGRESQL_TLS_CRL_FILE`                  | 证书吊销列表文件路径                                                 | `nil`                                       |
| `POSTGRESQL_TLS_PREFER_SERVER_CIPHERS`     | 是否优先使用服务器 TLS 密码套件                                     | `yes`                                       |
| `POSTGRESQL_SHARED_PRELOAD_LIBRARIES`      | 初始化时预加载的库列表                                               | `pgaudit`                                   |
| `POSTGRESQL_PGAUDIT_LOG`                   | pgaudit 日志记录动作（逗号分隔列表）                                 | `nil`                                       |
| `POSTGRESQL_PGAUDIT_LOG_CATALOG`           | 是否启用 pgaudit 目录日志（pgaudit.log_catalog 设置）                | `nil`                                       |
| `POSTGRESQL_PGAUDIT_LOG_PARAMETER`         | 是否启用 pgaudit 参数日志（pgaudit.log_parameter 设置）              | `nil`                                       |
| `POSTGRESQL_LOG_CONNECTIONS`               | 是否记录用户连接日志                                                 | `nil`                                       |
| `POSTGRESQL_LOG_DISCONNECTIONS`            | 是否记录用户断开连接日志                                             | `nil`                                       |
| `POSTGRESQL_LOG_HOSTNAME`                  | 是否记录客户端主机名                                                 | `nil`                                       |
| `POSTGRESQL_CLIENT_MIN_MESSAGES`           | 客户端错误日志级别                                                   | `error`                                     |
| `POSTGRESQL_LOG_LINE_PREFIX`               | 日志行前缀格式                                                       | `nil`                                       |
| `POSTGRESQL_LOG_TIMEZONE`                  | 日志时区                                                             | `nil`                                       |
| `POSTGRESQL_TIMEZONE`                      | 数据库时区                                                           | `nil`                                       |
| `POSTGRESQL_MAX_CONNECTIONS`               | 最大连接数                                                           | `nil`                                       |
| `POSTGRESQL_TCP_KEEPALIVES_IDLE`           | TCP 保活空闲时间                                                     | `nil`                                       |
| `POSTGRESQL_TCP_KEEPALIVES_INTERVAL`       | TCP 保活间隔时间                                                     | `nil`                                       |
| `POSTGRESQL_TCP_KEEPALIVES_COUNT`          | TCP 保活探测次数                                                     | `nil`                                       |
| `POSTGRESQL_STATEMENT_TIMEOUT`             | SQL 语句超时时间                                                     | `nil`                                       |
| `POSTGRESQL_PGHBA_REMOVE_FILTERS`          | 需移除的 pg_hba.conf 行内容（逗号分隔，如：md5, local）               | `nil`                                       |
| `POSTGRESQL_USERNAME_CONNECTION_LIMIT`     | 默认用户连接数限制                                                   | `nil`                                       |
| `POSTGRESQL_POSTGRES_CONNECTION_LIMIT`     | postgres 用户连接数限制                                              | `nil`                                       |
| `POSTGRESQL_WAL_LEVEL`                     | WAL 日志级别                                                        | `replica`                                   |
| `POSTGRESQL_DEFAULT_TOAST_COMPRESSION`     | 默认 TOAST 压缩方式                                                  | `nil`                                       |
| `POSTGRESQL_PASSWORD_ENCRYPTION`           | 密码加密方式                                                        | `nil`                                       |
| `POSTGRESQL_DEFAULT_TRANSACTION_ISOLATION` | 默认事务隔离级别                                                    | `nil`                                       |
| `POSTGRESQL_REPLICATION_NODES`             | 重写 postgresql.conf 中的 synchronous_standby_names（需设置 `REPMGR_NODE_NAME` 时使用） | `nil` |
| `POSTGRESQL_PERFORM_RESTORE`               | 是否保留 `recovery.signal` 文件以启用原生恢复（如通过 `wal-g`）       | `no`                                        |
| `POSTGRESQL_AUTOCTL_CONF_DIR`              | pg_autoctl 命令配置目录                                             | `${POSTGRESQL_AUTOCTL_VOLUME_DIR}/.config`  |
| `POSTGRESQL_AUTOCTL_MODE`                  | pgAutoFailover 节点类型（可选值：monitor、postgres）                 | `postgres`                                  |
| `POSTGRESQL_AUTOCTL_MONITOR_HOST`          | 监控组件主机名                                                       | `monitor`                                   |
| `POSTGRESQL_AUTOCTL_HOSTNAME`              | PostgreSQL 服务访问主机名                                            | `$(hostname --fqdn)`                        |


#### 只读环境变量

| 名称                                         | 说明                                                               | 值                                            |
|----------------------------------------------|--------------------------------------------------------------------|-----------------------------------------------|
| `POSTGRESQL_BASE_DIR`                        | PostgreSQL 安装目录                                                | `/opt/bitnami/postgresql`                      |
| `POSTGRESQL_DEFAULT_CONF_DIR`                | 默认配置目录                                                       | `$POSTGRESQL_BASE_DIR/conf.default`           |
| `POSTGRESQL_CONF_DIR`                        | 配置目录                                                           | `$POSTGRESQL_BASE_DIR/conf`                   |
| `POSTGRESQL_MOUNTED_CONF_DIR`                | 挂载的配置目录                                                     | `$POSTGRESQL_VOLUME_DIR/conf`                 |
| `POSTGRESQL_CONF_FILE`                       | 主配置文件                                                         | `$POSTGRESQL_CONF_DIR/postgresql.conf`        |
| `POSTGRESQL_PGHBA_FILE`                      | pg_hba 配置文件                                                    | `$POSTGRESQL_CONF_DIR/pg_hba.conf`            |
| `POSTGRESQL_RECOVERY_FILE`                   | 恢复配置文件                                                       | `$POSTGRESQL_DATA_DIR/recovery.conf`          |
| `POSTGRESQL_LOG_DIR`                         | 日志目录                                                           | `$POSTGRESQL_BASE_DIR/logs`                   |
| `POSTGRESQL_LOG_FILE`                        | 日志文件                                                           | `$POSTGRESQL_LOG_DIR/postgresql.log`          |
| `POSTGRESQL_TMP_DIR`                         | 临时目录                                                           | `$POSTGRESQL_BASE_DIR/tmp`                    |
| `POSTGRESQL_PID_FILE`                        | PID 文件                                                           | `$POSTGRESQL_TMP_DIR/postgresql.pid`          |
| `POSTGRESQL_BIN_DIR`                         | 可执行文件目录                                                     | `$POSTGRESQL_BASE_DIR/bin`                    |
| `POSTGRESQL_INITSCRIPTS_DIR`                 | 初始化脚本目录                                                     | `/docker-entrypoint-initdb.d`                 |
| `POSTGRESQL_PREINITSCRIPTS_DIR`              | 预初始化脚本目录                                                   | `/docker-entrypoint-preinitdb.d`              |
| `POSTGRESQL_DAEMON_USER`                     | 系统用户                                                           | `postgres`                                    |
| `POSTGRESQL_DAEMON_GROUP`                    | 系统用户组                                                         | `postgres`                                    |
| `POSTGRESQL_USE_CUSTOM_PGHBA_INITIALIZATION` | 是否使用挂载的自定义 pg_hba.conf 初始化数据库                       | `no`                                          |
| `POSTGRESQL_AUTOCTL_VOLUME_DIR`              | pg_autoctl 主目录                                                 | `${POSTGRESQL_VOLUME_DIR}/pgautoctl`          |
| `POSTGRESQL_PGBACKREST_VOLUME_DIR`           | pgbackrest 主目录                                                  | `${POSTGRESQL_VOLUME_DIR}/pgbackrest`         |
| `POSTGRESQL_PGBACKREST_LOGS_DIR`             | pgbackrest 日志目录                                                | `${POSTGRESQL_PGBACKREST_VOLUME_DIR}/logs`    |
| `POSTGRESQL_PGBACKREST_BACKUPS_DIR`          | pgbackrest 备份目录                                                | `${POSTGRESQL_PGBACKREST_VOLUME_DIR}/backups` |
| `POSTGRESQL_PGBACKREST_SPOOL_DIR`            | pgbackrest 缓存目录                                                | `${POSTGRESQL_PGBACKREST_VOLUME_DIR}/spool`   |
| `POSTGRESQL_PGBACKREST_CONF_FILE`            | pgbackrest 配置文件                                                | `${POSTGRESQL_DATA_DIR}/pgbackrest.conf`      |
| `POSTGRESQL_FIRST_BOOT`                      | 首次启动标记（repmgr 需用）                                        | `yes`                                         |
| `NSS_WRAPPER_LIB`                            | NSS 包装库路径（repmgr 需用）                                      | `/opt/bitnami/common/lib/libnss_wrapper.so`   |
