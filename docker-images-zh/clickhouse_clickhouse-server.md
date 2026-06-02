---
image: clickhouse/clickhouse-server
description: "ClickHouse是一款由俄罗斯Yandex公司开发的开源面向列的数据库管理系统，专为在线分析处理（OLAP）场景设计，采用高效的列式存储结构，能够快速处理PB级大规模数据，支持实时数据查询与分析，具备高吞吐量、低延迟的性能优势，广泛应用于数据仓库、日志分析、业务监控等领域，为企业提供高效的数据处理解决方案。"
source: https://xuanyuan.cloud/zh/r/clickhouse/clickhouse-server
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[clickhouse/clickhouse-server](https://xuanyuan.cloud/zh/r/clickhouse/clickhouse-server)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# ClickHouse Server Docker 镜像


## 什么是 ClickHouse？

ClickHouse 是一款开源的列式数据库管理系统（columnar DBMS），专为在线分析处理（OLAP）设计，支持用户通过 SQL 实时生成分析报告。  

ClickHouse 比传统数据库管理系统快 100 到 1000 倍，单服务器每秒可处理数亿至十亿行数据、数十 GB 数据量。其可靠性、易用性和容错能力广受全球用户认可。  

更多信息和文档见 [[]]([])。


## 版本标签说明

- `latest`：指向最新稳定分支的最新版本。  
- 分支标签（如 `22.2`）：指向对应分支的最新版本。  
- 完整版本标签（如 `22.2.3`、`22.2.3.5`）：指向具体版本。  
- `head`：基于默认分支的最新提交构建。  
- 所有标签均支持 `-alpine` 后缀，表示基于 `alpine` 系统构建。  


## 兼容性说明

- **amd64 镜像**：需支持 [SSE3 指令集]()。2005 年后的 x86 处理器基本都支持。  
- **arm64 镜像**：需支持 [ARMv8.2-A 架构]() 及 Load-Acquire RCpc 寄存器（该寄存器在 ARMv8.2-A 中为可选，在 [ARMv8.3-A]() 中为强制要求）。支持 Graviton 2 及以上、Azure 和 GCP 实例；不支持树莓派 4（ARMv8.0-A 架构）、Jetson AGX Xavier/Orin（ARMv8.2-A 架构）等设备。  
- **Ubuntu 镜像（24.11 及以上版本）**：基于 `ubuntu:22.04` 构建，需 Docker 版本 ≥20.10.10（含 [补丁]([])）。若版本不足，可使用 `docker run --security-opt seccomp=unconfined` 作为临时方案，但存在安全风险。  


## 如何使用镜像

### 启动服务实例

```bash
docker run -d --name some-clickhouse-server --ulimit nofile=262144:262144 clickhouse/clickhouse-server
```

默认情况下，ClickHouse 仅通过 Docker 内部网络访问（见下文“网络配置”部分）。服务默认以 `default` 用户启动，无密码。


### 通过原生客户端连接

```bash
# 方法一：使用容器网络
docker run -it --rm --network=container:some-clickhouse-server --entrypoint clickhouse-client clickhouse/clickhouse-server

# 方法二：直接在容器内执行客户端
docker exec -it some-clickhouse-server clickhouse-client
```

更多关于 [ClickHouse 客户端]([]) 的说明。


### 通过 curl 连接

```bash
echo "SELECT 'Hello, ClickHouse!'" | docker run -i --rm --network=container:some-clickhouse-server buildpack-deps:curl curl '[]' -s --data-binary @-
```

更多关于 [ClickHouse HTTP 接口]([]) 的说明。


### 停止/删除容器

```bash
docker stop some-clickhouse-server  # 停止服务
docker rm some-clickhouse-server    # 删除容器
```


### 网络配置

> ⚠️ 注意：预定义用户 `default` 默认没有网络访问权限，除非设置密码（见下文“启动时创建默认数据库和用户”及“管理 `default` 用户”部分）。

如需对外暴露服务，可通过 **端口映射** 将容器内端口映射到主机：

```bash
# 映射 HTTP 端口（8123）和原生客户端端口（9000），并设置密码
docker run -d -p 18123:8123 -p 19000:9000 -e CLICKHOUSE_PASSWORD=changeme --name some-clickhouse-server --ulimit nofile=262144:262144 clickhouse/clickhouse-server

# 测试连接（通过主机端口 18123）
echo 'SELECT version()' | curl '[]' --data-binary @-
```

也可通过 `--network=host` 直接使用主机网络（性能更优）：

```bash
docker run -d --network=host --name some-clickhouse-server --ulimit nofile=262144:262144 clickhouse/clickhouse-server
echo 'SELECT version()' | curl '[]' --data-binary @-  # 直接访问主机 8123 端口
```


## 配置说明

容器暴露 8123 端口（HTTP 接口）和 9000 端口（原生客户端接口）。配置文件为 `config.xml`（[文档]([])）。


### 自定义配置启动服务

```bash
# 将本地配置文件挂载到容器内
docker run -d --name some-clickhouse-server --ulimit nofile=262144:262144 -v /path/to/your/config.xml:/etc/clickhouse-server/config.xml clickhouse/clickhouse-server
```


### 以自定义用户启动服务

```bash
# 当前目录下的 data/clickhouse 和 logs/clickhouse 需存在且归当前用户所有
docker run --rm --user "${UID}:${GID}" --name some-clickhouse-server --ulimit nofile=262144:262144 \
  -v "$PWD/logs/clickhouse:/var/log/clickhouse-server" \
  -v "$PWD/data/clickhouse:/var/lib/clickhouse" \
  clickhouse/clickhouse-server
```

挂载本地目录时，需通过 `--user` 指定用户 ID 和组 ID，确保文件权限正确（否则服务无法启动）。


### 以 root 用户启动（适用于用户命名空间场景）

```bash
docker run --rm -e CLICKHOUSE_RUN_AS_ROOT=1 --name clickhouse-server-userns \
  -v "$PWD/logs/clickhouse:/var/log/clickhouse-server" \
  -v "$PWD/data/clickhouse:/var/lib/clickhouse" \
  clickhouse/clickhouse-server
```


### 启动时创建默认数据库和用户

可通过环境变量创建数据库和用户（默认使用 `default` 用户）：

| 环境变量                     | 说明                                  |
|------------------------------|---------------------------------------|
| `CLICKHOUSE_DB`              | 自动创建的数据库名                    |
| `CLICKHOUSE_USER`            | 用户名（默认 `default`）              |
| `CLICKHOUSE_PASSWORD`        | 用户密码                              |
| `CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT` | 是否开启默认权限管理（设为 `1` 启用） |

示例：

```bash
docker run --rm -e CLICKHOUSE_DB=my_database -e CLICKHOUSE_USER=username -e CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT=1 -e CLICKHOUSE_PASSWORD=password -p 9000:9000/tcp clickhouse/clickhouse-server
```


#### 管理 `default` 用户

若未设置 `CLICKHOUSE_USER`、`CLICKHOUSE_PASSWORD` 或 `CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT`，`default` 用户默认禁用网络访问。如需 **不安全地开放 `default` 用户访问**，可设置 `CLICKHOUSE_SKIP_USER_SETUP=1`：

```bash
docker run --rm -e CLICKHOUSE_SKIP_USER_SETUP=1 -p 9000:9000/tcp clickhouse/clickhouse-server
```


## 扩展镜像

如需基于此镜像添加初始化操作，可在 `/docker-entrypoint-initdb.d` 目录下添加 `*.sql`、`*.sql.gz` 或 `*.sh` 脚本。服务启动时，入口脚本会按顺序执行这些脚本（SQL 文件直接运行，`.sh` 文件需可执行）。  

可通过 `CLICKHOUSE_USER` 和 `CLICKHOUSE_PASSWORD` 环境变量指定初始化时使用的客户端账号。

示例：创建数据库和表（添加脚本 `/docker-entrypoint-initdb.d/init-db.sh`）：

```bash
#!/bin/bash
set -e

# 通过客户端执行 SQL
clickhouse client -n <<-EOSQL
    CREATE DATABASE docker;
    CREATE TABLE docker.docker (x Int32) ENGINE = Log;
EOSQL
```


## 许可证

查看镜像中软件的 [许可证信息]([])。
