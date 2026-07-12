---
image: temporalio/auto-setup
description: "工作流即代码（Workflow as Code，TM）是一种将应用构建与运维流程通过代码化方式定义、管理和执行的方法，旨在提升应用的可靠性、可恢复性与持续运行能力，支持开发与运维团队高效协作，实现从构建到运维的全生命周期自动化，确保应用在复杂场景及潜在故障下仍能稳定运行，从而帮助用户构建并运维具备强大韧性的应用系统。"
source: https://xuanyuan.cloud/zh/r/temporalio/auto-setup
canonical: https://xuanyuan.cloud/zh/r/temporalio/auto-setup
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/temporalio/auto-setup" title="temporalio/auto-setup Docker 镜像中文简介、标签列表与拉取命令">temporalio/auto-setup 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Temporal 自动部署镜像说明  


## 基本介绍  
Temporal 自动部署镜像（Temporal auto-setup image）可一键部署 Temporal 服务，并内置预配置数据库，支持 **Cassandra（默认）**、**MySQL** 或 **PostgreSQL**。若需使用外部数据库，可参考 [server 镜像] 。  

此外，Temporal 可选配 Elasticsearch，用于 [可见性]  功能。  


## 资源与支持  
- **docker-compose 示例**：可参考 [docker-compose GitHub 仓库] 。  
- **Temporal Cloud**：[注册账号] 。  
- **社区支持**：在 [Slack 社区]  提问。  
- **专家咨询**：[预约技术专家] 。  
- **文档中心**：查阅 [官方文档] 。  


## 部署配置：环境变量说明  
通过以下环境变量配置部署参数，各变量说明如下：  


### 通用环境变量  

| 变量名       | 描述                                   | 默认值       |  
|--------------|----------------------------------------|--------------|  
| `DB`         | 指定连接的数据库类型，可选 `cassandra`、`mysql8`、`postgres12` | `cassandra`  |  
| `SKIP_SCHEMA_SETUP` | 是否跳过数据库 schema 创建（使用现有 schema 时设为 `true`） | `false`      |  
| `SKIP_DB_CREATE`    | 是否跳过数据库创建（使用现有数据库时设为 `true`）         | `false`      |  


### Cassandra 环境变量  

| 变量名                  | 描述                                                                 | 默认值       |  
|-------------------------|----------------------------------------------------------------------|--------------|  
| `KEYSPACE`              | 指定 Cassandra 键空间名称                                             | `temporal`   |  
| `CASSANDRA_SEEDS`       | 指定 Cassandra 主机名                                                 | 未设置       |  
| `CASSANDRA_PORT`        | 指定 Cassandra 连接端口                                               | 9042         |  
| `CASSANDRA_USER`        | Cassandra 用户名                                                      | 未设置       |  
| `CASSANDRA_PASSWORD`    | Cassandra 密码                                                        | 未设置       |  
| `CASSANDRA_TLS_ENABLED` | 是否启用 TLS 连接 Cassandra                                           | `false`      |  
| `CASSANDRA_CERT`        | TLS 连接时的证书路径（若启用 TLS）                                    | 未设置       |  
| `CASSANDRA_CERT_KEY`    | TLS 连接时的证书密钥路径（若启用 TLS）                                | 未设置       |  
| `CASSANDRA_CA`          | 证书颁发机构（CA）主机（如需）                                        | 未设置       |  
| `CASSANDRA_REPLICATION_FACTOR` | Cassandra 数据库的 [副本数量]  | `1`      |  


### MySQL/PostgreSQL 环境变量  

| 变量名                          | 描述                                                                 | 默认值               |  
|---------------------------------|----------------------------------------------------------------------|----------------------|  
| `DBNAME`                        | 指定 MySQL/PostgreSQL 数据库名称                                      | `temporal`           |  
| `VISIBILITY_DBNAME`             | 指定可见性数据库名称（独立于主 Temporal 数据库）                      | `temporal_visibility`|  
| `DB_PORT`                       | 数据库连接端口                                                       | `3306`               |  
| `MYSQL_SEEDS`                   | MySQL 主机名                                                         | 未设置               |  
| `MYSQL_USER`                    | MySQL 用户名                                                         | 未设置               |  
| `MYSQL_PWD`                     | MySQL 密码                                                           | 未设置               |  
| `MYSQL_TX_ISOLATION_COMPAT`     | 启用与 5.7.20 之前 MySQL 版本的兼容性（如需）                         | `false`              |  
| `POSTGRES_SEEDS`                | PostgreSQL 主机名                                                    | 未设置               |  
| `POSTGRES_USER`                 | PostgreSQL 用户名                                                    | 未设置               |  
| `POSTGRES_PWD`                  | PostgreSQL 密码                                                      | 未设置               |  
| `POSTGRES_TLS_ENABLED`          | 是否启用 TLS 连接 PostgreSQL                                          | `false`              |  
| `POSTGRES_TLS_DISABLE_HOST_VERIFICATION` | 是否跳过主机密钥验证（如使用 Amazon RDS 无法验证服务器证书时） | `false`              |  
| `POSTGRES_TLS_CERT_FILE`        | TLS 连接时的证书路径（若启用 TLS）                                    | 未设置               |  
| `POSTGRES_TLS_KEY_FILE`         | TLS 连接时的证书密钥路径（若启用 TLS）                                | 未设置               |  
| `POSTGRES_TLS_CA_FILE`          | TLS 连接时的 CA 证书路径（如需）                                      | 未设置               |  
| `POSTGRES_TLS_SERVER_NAME`      | TLS 服务器主机名（如需）                                              | 未设置               |  


### Elasticsearch 环境变量  

| 变量名                          | 描述                                                                 | 默认值                     |  
|---------------------------------|----------------------------------------------------------------------|----------------------------|  
| `ENABLE_ES`                     | 是否启用 Elasticsearch                                               | `false`                    |  
| `ES_SCHEME`                     | 连接协议，可选 `http` 或 `https`                                      | `http`                     |  
| `ES_SEEDS`                      | Elasticsearch 节点列表（逗号分隔）                                   | 未设置                     |  
| `ES_PORT`                       | Elasticsearch 连接端口                                               | `9200`                     |  
| `ES_USER`                       | Elasticsearch 用户名                                                 | 未设置                     |  
| `ES_PWD`                        | Elasticsearch 密码                                                   | 未设置                     |  
| `ES_VERSION`                    | Elasticsearch 版本                                                   | `v7`                       |  
| `ES_VIS_INDEX`                  | 可见性索引名称                                                       | `temporal_visibility_v1_dev` |  
| `ES_SEC_VIS_INDEX`              | [二级可见性]  索引名称 | 未设置 |  
| `ES_SCHEMA_SETUP_TIMEOUT_IN_SECONDS` | 索引 schema 创建超时时间（秒），默认 `0` 表示不超时                 | `0`                        |  


### 服务器设置环境变量  

| 变量名                          | 描述                                                                 | 默认值       |  
|---------------------------------|----------------------------------------------------------------------|--------------|  
| `TEMPORAL_ADDRESS`              | Temporal 服务器地址                                                  | 未设置       |  
| `SKIP_DEFAULT_NAMESPACE_CREATION` | 是否跳过默认命名空间创建                                             | `false`      |  
| `DEFAULT_NAMESPACE`             | 默认命名空间名称                                                     | `default`    |  
| `DEFAULT_NAMESPACE_RETENTION`   | 默认命名空间中 [已关闭工作流执行]  的数据保留时间 | `24h` |  
| `SKIP_ADD_CUSTOM_SEARCH_ATTRIBUTES` | 是否跳过自定义搜索属性添加                                         | `false`      |
