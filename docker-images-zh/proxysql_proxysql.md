---
image: proxysql/proxysql
description: "官方ProxySQL Docker镜像，提供高性能MySQL数据库代理功能，用于数据库连接管理、读写分离、负载均衡及高可用部署。"
source: https://xuanyuan.cloud/zh/r/proxysql/proxysql
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[proxysql/proxysql](https://xuanyuan.cloud/zh/r/proxysql/proxysql)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# ProxySQL Docker镜像文档

![ProxySQL Latest](https://i0.wp.com/proxysql.com/wp-content/uploads/2020/04/ProxySQL-Colour-Logo.png?fit=800%2C278&ssl=1)

## 镜像概述和主要用途

ProxySQL是一款高性能、高可用、协议感知的代理工具，专为MySQL及其分支（如Percona Server、MariaDB）设计。该工具基于GPL开源许可证，提供完全的使用自由度。其开发初衷是解决现有开源代理工具在高性能场景下的不足，主要用途是作为MySQL数据库的中间层，实现连接管理、负载均衡、高可用等功能。

## 核心功能和特性

- **高性能与高可用**：针对MySQL协议优化，提供高效的连接代理和请求转发能力，保障数据库服务的稳定运行。
- **协议感知**：深度理解MySQL协议，支持复杂的查询路由和流量控制。
- **广泛兼容性**：支持MySQL及主流分支（如Percona Server、MariaDB）。
- **开源自由**：基于GPL许可证，允许自由使用、修改和分发。
- **轻量部署**：Docker镜像基于Debian系统构建，精简高效，以前台进程模式运行。
- **无MySQL客户端**：镜像中不包含MySQL客户端工具，需自行安装。

## 使用场景和适用范围

- **数据库负载均衡**：在多MySQL实例集群中分发客户端请求，提高资源利用率。
- **读写分离**：将读请求路由至从库，写请求路由至主库，优化数据库性能。
- **高可用架构**：配合数据库集群实现故障自动切换，提升系统可用性。
- **开发测试环境**：快速部署代理服务，模拟生产环境中的数据库代理层配置。
- **连接管理**：集中管理数据库连接，减少直接连接数据库的开销，优化连接复用。

## 使用方法

### 拉取镜像

拉取最新版本镜像：
```bash
docker pull proxysql/proxysql
```

拉取特定版本镜像（以2.1.0为例）：
```bash
docker pull proxysql/proxysql:2.1.0
```

### 运行容器

通过自定义配置文件启动ProxySQL容器，需映射必要端口并挂载配置文件：

```bash
docker run -p 16032:6032 -p 16033:6033 -p 16070:6070 -d -v /path/to/proxysql.cnf:/etc/proxysql.cnf proxysql/proxysql
```

**参数说明**：
- `-p 16032:6032`：映射容器内管理接口端口（6032）到宿主机16032端口，用于ProxySQL管理操作。
- `-p 16033:6033`：映射容器内MySQL客户端连接端口（6033）到宿主机16033端口，用于客户端通过ProxySQL访问数据库。
- `-p 16070:6070`：映射其他服务端口（如HTTP监控端口）。
- `-v /path/to/proxysql.cnf:/etc/proxysql.cnf`：挂载宿主机自定义配置文件到容器内默认配置路径。
- `-d`：后台运行容器。

**注意**：需在配置文件中定义第二对管理员凭据（`admin_credentials`），以支持从容器外部连接管理接口。

### 配置文件说明

#### 示例配置文件

以下为基础配置文件示例（对应上述命令中的`/path/to/proxysql.cnf`），适用于开发环境，支持通过第二对管理员凭据远程连接容器：

```
datadir="/var/lib/proxysql"  # 数据存储目录

admin_variables=  # 管理接口配置
{
    admin_credentials="admin:admin;radmin:radmin"  # 管理员凭据，分号分隔多对（容器内/外部连接）
    mysql_ifaces="0.0.0.0:6032"  # 管理接口监听地址和端口
}

mysql_variables=  # MySQL代理配置
{
    threads=4  # 工作线程数
    max_connections=2048  # 最大客户端连接数
    default_query_delay=0  # 默认查询延迟（毫秒）
    default_query_timeout=36000000  # 默认查询超时（毫秒）
    have_compress=true  # 启用压缩
    poll_timeout=2000  # 轮询超时（毫秒）
    interfaces="0.0.0.0:6033"  # 客户端连接监听地址和端口
    default_schema="information_schema"  # 默认数据库
    stacksize=1048576  # 线程栈大小（字节）
    server_version="5.5.30"  # 对外展示的MySQL版本
    connect_timeout_server=3000  # 连接后端MySQL超时（毫秒）
    monitor_username="monitor"  # 监控用户
    monitor_password="monitor"  # 监控密码
    monitor_history=600000  # 监控历史保留时间（毫秒）
    monitor_connect_interval=60000  # 后端连接监控间隔（毫秒）
    monitor_ping_interval=10000  # 后端Ping监控间隔（毫秒）
    monitor_read_only_interval=1500  # 只读状态监控间隔（毫秒）
    monitor_read_only_timeout=500  # 只读状态监控超时（毫秒）
    ping_interval_server_msec=120000  # 后端服务器Ping间隔（毫秒）
    ping_timeout_server=500  # 后端服务器Ping超时（毫秒）
    commands_stats=true  # 启用命令统计
    sessions_sort=true  # 启用会话排序
    connect_retries_on_failure=10  # 连接失败重试次数
}
```

#### 远程连接示例

使用第二对管理员凭据（`radmin:radmin`）连接容器内的ProxySQL管理接口：

```bash
mysql -h127.0.0.1 -P16032 -uradmin -pradmin --prompt "ProxySQL Admin>"
```

## Dockerfile信息

镜像构建细节请参考官方GitHub仓库：[ProxySQL Docker-Images](https://github.com/ProxySQL/docker-images/tree/main/proxysql-images)
