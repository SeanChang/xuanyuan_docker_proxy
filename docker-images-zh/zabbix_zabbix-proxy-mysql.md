---
image: zabbix/zabbix-proxy-mysql
description: "Zabbix proxy是开源监控解决方案Zabbix的分布式监控代理组件，其支持MySQL数据库作为后端存储，能够在分布式监控架构中承担数据收集、预处理与转发任务，有效减轻Zabbix server的负载压力，借助MySQL的稳定性能与可扩展性提升监控数据的存储效率和管理灵活性，适用于大规模网络环境下对多节点、多类型设备及服务的集中化监控需求。"
source: https://xuanyuan.cloud/zh/r/zabbix/zabbix-proxy-mysql
canonical: https://xuanyuan.cloud/zh/r/zabbix/zabbix-proxy-mysql
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zabbix/zabbix-proxy-mysql" title="zabbix/zabbix-proxy-mysql Docker 镜像中文简介、标签列表与拉取命令">zabbix/zabbix-proxy-mysql 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

![logo]()

# 什么是 Zabbix？

Zabbix 是一款企业级开源分布式监控解决方案。它能监控网络的多项参数及服务器的健康状态与完整性，支持灵活的通知机制，允许用户为几乎任何事件配置基于电子邮件的告警，以便快速响应服务器问题。同时，Zabbix 基于存储的数据提供出色的报表和数据可视化功能，非常适合容量规划。

更多信息及 Zabbix 组件的相关下载，请访问 [] 和  什么是 Zabbix 代理？

Zabbix 代理（Zabbix proxy）是一个进程，可从一个或多个被监控设备收集监控数据，并将信息发送到 Zabbix 服务器，本质上代表服务器工作。所有收集的数据会先在本地缓冲，然后传输到该代理所属的 Zabbix 服务器。


# Zabbix 代理镜像

以下是官方唯一的 Zabbix 代理 Docker 镜像，基于 Alpine Linux v3.22、Ubuntu 24.04（noble）、CentOS Stream 10 和 Oracle Linux 10 构建。可用的 Zabbix 代理版本及标签如下：

- Zabbix 代理 6.0（标签：alpine-6.0-latest、ubuntu-6.0-latest、ol-6.0-latest）
- Zabbix 代理 6.0.*（标签：alpine-6.0.*、ubuntu-6.0.*、ol-6.0.*）
- Zabbix 代理 7.0（标签：alpine-7.0-latest、ubuntu-7.0-latest、ol-7.0-latest）
- Zabbix 代理 7.0.*（标签：alpine-7.0.*、ubuntu-7.0.*、ol-7.0.*）
- Zabbix 代理 7.2（标签：alpine-7.2-latest、ubuntu-7.2-latest、ol-7.2-latest）
- Zabbix 代理 7.2.*（标签：alpine-7.2.*、ubuntu-7.2.*、ol-7.2.*）
- Zabbix 代理 7.4（标签：alpine-7.4-latest、ubuntu-7.4-latest、ol-7.4-latest、alpine-latest、ubuntu-latest、ol-latest、latest）
- Zabbix 代理 7.4.*（标签：alpine-7.4.*、ubuntu-7.4.*、ol-7.4.*）
- Zabbix 代理 8.0（标签：alpine-trunk、ubuntu-trunk、ol-trunk）

镜像会随新版本发布更新，`latest` 标签基于 Alpine Linux。

该镜像使用 MySQL 数据库存储收集的数据（发送到 Zabbix 服务器前），启动流程如下：
1. 检查数据库可用性
2. 若指定 `MYSQL_ROOT_PASSWORD` 或 `MYSQL_ALLOW_EMPTY_PASSWORD`，实例会尝试创建 `MYSQL_USER` 用户（密码为 `MYSQL_PASSWORD`），供 Zabbix 服务器后续使用
3. 检查 `MYSQL_DATABASE` 数据库是否存在，不存在则创建
4. 检查 `dbversion` 表是否存在，若不存在则创建 Zabbix 代理数据库 schema


# 如何使用此镜像

## 启动 `zabbix-proxy-mysql`

启动 Zabbix 代理容器的命令如下：

```console
docker run --name some-zabbix-proxy-mysql -e DB_SERVER_HOST="some-mysql-server" -e MYSQL_USER="some-user" -e MYSQL_PASSWORD="some-password" -e ZBX_HOSTNAME=some-hostname -e ZBX_SERVER_HOST=some-zabbix-server --init -d docker.xuanyuan.run/zabbix/zabbix-proxy-mysql:tag
```

参数说明：
- `some-zabbix-proxy-mysql`：容器名称
- `some-mysql-server`：MySQL 服务器的 IP 或 DNS 名称
- `some-user`：连接 MySQL 服务器上 Zabbix 数据库的用户
- `some-password`：连接 MySQL 服务器的密码
- `some-hostname`：Zabbix 代理配置文件中的 Hostname 参数值
- `some-zabbix-server`：Zabbix 服务器的 IP 或 DNS 名称
- `tag`：指定版本的标签（见上文版本列表），完整标签可查看 [标签列表] 

> [!NOTE]
> Zabbix 服务器可通过 `fping` 工具执行 ICMP 检查。若容器运行在无 root 模式或受限环境中，可能会遇到 `fping: Operation not permitted` 或「所有资源丢包」等错误，此时需在 `docker run` 或 `podman run` 命令中添加 `--cap-add=net_raw`。此外，非 root 环境下运行 `fping` 可能需要修改 sysctl：`net.ipv4.ping_group_range=0 1995`（1995 为 `zabbix` 用户组 GID）。

## 连接 Zabbix 服务器（被动代理模式）

若设置 `ZBX_PROXYMODE=1`（被动代理模式），此镜像会暴露标准 Zabbix 代理端口（10051）。启动 Zabbix 服务器容器并关联代理容器的命令如下：

```console
$ docker run --name some-zabbix-server --link some-zabbix-proxy-mysql:zabbix-proxy-mysql --init -d zabbix/zabbix-server:latest
```

## 连接 Zabbix 服务器（主动代理模式）

默认模式为主动代理模式，启动代理容器并关联 Zabbix 服务器的命令如下：

```console
$ docker run --name some-zabbix-proxy-mysql --link some-zabbix-server:zabbix-server --init -d zabbix/zabbix-proxy-mysql:latest
```

## 容器命令行访问与日志查看

通过 `docker exec` 可在容器内执行命令，例如进入 bash 终端：

```console
$ docker exec -ti some-zabbix-proxy-mysql /bin/bash
```

Zabbix 代理日志可通过 Docker 容器日志查看：

```console
$ docker logs some-zabbix-proxy-mysql
```


## 环境变量

启动镜像时，可通过 `docker run` 命令行传递环境变量调整 Zabbix 代理配置，常用变量如下：

### `ZBX_PROXYMODE`
- 说明：切换代理模式
- 默认值：`0`（主动代理）
- 允许值：`0`（主动）、`1`（被动）

### `ZBX_HOSTNAME`
- 说明：代理唯一主机名（区分大小写），对应配置文件中的 `Hostname` 参数
- 默认值：容器名 `zabbix-proxy-mysql`

### `ZBX_SERVER_HOST`
- 说明：Zabbix 服务器或上级代理的 IP 或 DNS 名称，对应配置文件中的 `Server` 参数
- 默认值：`zabbix-server`
- 备注：若需指定非默认端口（主动检查），可在值后加 `:端口号`（例如 `ZBX_SERVER_HOST=some-server:10052`）

### `ZBX_SERVER_PORT`
- 说明：Zabbix 服务器监听端口
- 默认值：`10051`
- 备注：6.0 及以上版本不再使用此参数，端口需直接附加到 `ZBX_SERVER_HOST`（如 `ZBX_SERVER_HOST=some-server:10052`）

### `DB_SERVER_HOST`
- 说明：MySQL 服务器的 IP 或 DNS 名称
- 默认值：`mysql-server`

### `DB_SERVER_PORT`
- 说明：MySQL 服务器端口
- 默认值：`3306`

### `MYSQL_USER`、`MYSQL_PASSWORD`、`MYSQL_USER_FILE`、`MYSQL_PASSWORD_FILE`
- 说明：Zabbix 代理连接数据库的凭据。`_FILE` 变量可指定存储凭据的文件路径（适用于 Docker Swarm/Kubernetes 密钥管理），需注意 `MYSQL_USER` 与 `MYSQL_USER_FILE` 互斥
- 使用示例（通过文件传递凭据）：
  ```console
  docker run --name some-zabbix-proxy-mysql -e DB_SERVER_HOST="some-mysql-server" -v ./.MYSQL_USER:/run/secrets/MYSQL_USER -e MYSQL_USER_FILE=/run/secrets/MYSQL_USER -v ./.MYSQL_PASSWORD:/run/secrets/MYSQL_PASSWORD -e MYSQL_PASSWORD_FILE=/var/run/secrets/MYSQL_PASSWORD -e ZBX_HOSTNAME=some-hostname -e ZBX_SERVER_HOST=some-zabbix-server --init -d docker.xuanyuan.run/zabbix/zabbix-proxy-mysql:tag
  ```
- Docker Swarm 密钥示例：
  ```console
  printf "zabbix" | docker secret create MYSQL_USER -
  printf "zabbix" | docker secret create MYSQL_PASSWORD -
  docker run --name some-zabbix-proxy-mysql -e DB_SERVER_HOST="some-mysql-server" -e MYSQL_USER_FILE=/run/secrets/MYSQL_USER -e MYSQL_PASSWORD_FILE=/run/secrets/MYSQL_PASSWORD -e ZBX_SERVER_HOST="some-zabbix-server" -e ZBX_HOSTNAME=some-hostname --init -d docker.xuanyuan.run/zabbix/zabbix-proxy-mysql:tag
  ```
- 默认值：`MYSQL_USER=zabbix`，`MYSQL_PASSWORD=zabbix`

### `MYSQL_DATABASE`
- 说明：Zabbix 数据库名称
- 默认值：`zabbix_proxy`

### `ZBX_LOADMODULE`
- 说明：逗号分隔的可加载模块列表，需配合 `/var/lib/zabbix/modules` 卷使用
- 示例：`dummy1.so,dummy2.so`

### `ZBX_DEBUGLEVEL`
- 说明：调试级别，对应配置文件中的 `DebugLevel` 参数
- 默认值：`3`（警告）
- 允许值：`0`（启动/停止信息）、`1`（关键信息）、`2`（错误信息）、`3`（警告）、`4`（调试）、`5`（详细调试）

### `ZBX_TIMEOUT`
- 说明：检查处理超时时间（秒）
- 默认值：`4`

### `ZBX_JAVAGATEWAY_ENABLE`
- 说明：是否启用与 Zabbix Java Gateway 的通信（收集 Java 相关检查数据）
- 默认值：`false`


### 其他环境变量

镜像还支持通过环境变量配置 `zabbix_proxy.conf` 中的多数参数，部分常用变量及默认值如下：

```
ZBX_ALLOWUNSUPPORTEDDBVERSIONS=0 # 6.0.0+ 支持
ZBX_DBTLSCONNECT= # 5.0.0+ 支持（数据库 TLS 连接模式）
ZBX_DBTLSCAFILE= # 5.0.0+ 支持（数据库 CA 证书文件路径）
ZBX_ENABLEREMOTECOMMANDS=0 # 3.4.0+ 支持（允许远程命令）
ZBX_STARTPOLLERS=5 # 轮询进程数
ZBX_STARTPREPROCESSORS=3 # 4.2.0+ 支持（预处理进程数）
ZBX_STARTPINGERS=1 # ICMP 检查进程数
ZBX_JAVAGATEWAY=zabbix-java-gateway # Java Gateway 地址
ZBX_JAVAGATEWAYPORT=10052 # Java Gateway 端口
ZBX_STARTJAVAPOLLERS=0 # Java 检查进程数
ZBX_CACHESIZE=8M # 缓存大小
ZBX_HISTORYCACHESIZE=16M # 历史数据缓存大小
```

完整参数说明可参考官方 [zabbix_proxy.conf 文档]()。


## Zabbix 代理容器的允许卷

### `/usr/lib/zabbix/externalscripts`
- 用途：存放外部检查（External checks）脚本，对应配置文件中的 `ExternalScripts` 参数

### `/var/lib/zabbix/modules`
- 用途：存放可加载模块（通过 `ZBX_LOADMODULE` 启用），用于扩展 Zabbix 代理功能

### `/var/lib/zabbix/enc`
- 用途：存放 TLS 相关文件（如 CA 证书、密钥），需通过 `ZBX_TLSCAFILE`、`ZBX_TLSKEYFILE` 等变量指定文件名；也可直接通过 `ZBX_TLSCA`、`ZBX_TLSKEY` 等变量传入明文内容

### `/var/lib/zabbix/ssh_keys`
- 用途：存放 SSH 检查/动作所需的公私钥，对应配置文件中的 `SSHKeyLocation` 参数

### `/var/lib/zabbix/ssl/certs`、`/var/lib/zabbix/ssl/keys`、`/var/lib/zabbix/ssl/ssl_ca`
- 用途：分别存放 SSL 客户端证书、私钥、CA 证书，对应配置文件中的 `SSLCertLocation`、`SSLKeyLocation`、`SSLCALocation` 参数

### `/var/lib/zabbix/snmptraps`
- 用途：存放 `snmptraps.log` 文件，可与 `zabbix-snmptraps` 容器共享（通过 `volumes_from` 继承），配合 `ZBX_ENABLE_SNMP_TRAPS=true` 启用 SNMP 陷阱处理

### `/var/lib/zabbix/mibs`
- 用途：存放 SNMP MIB 文件（不支持子目录，需直接放在此路径）


# 镜像变体

`zabbix-proxy-mysql` 提供多种镜像变体，适用于不同场景：

## `zabbix-proxy-mysql:alpine-<version>`
- 基于 [Alpine Linux] ，镜像体积极小（~5MB 基础镜像），适合对镜像大小敏感的场景
- 注意：使用 musl libc 而非 glibc，部分依赖 glibc 的软件可能存在兼容性问题

## `zabbix-proxy-mysql:ubuntu-<version>`
- 基于 Ubuntu 24.04（默认变体），兼容性好，适合大多数通用场景，可直接作为基础镜像构建其他镜像

## `zabbix-proxy-mysql:ol-<version>`
- 基于 Oracle Linux，针对 Oracle 工作负载优化，支持 Ksplice（零停机内核补丁）、DTrace（实时诊断）等特性


# 支持的 Docker 版本

官方支持 Docker 1.12.0 及以上版本，1.6~1.11 版本提供有限支持（尽力而为）。升级 Docker 引擎可参考 [Docker 安装文档] 。


# 用户反馈

## 文档
镜像文档存放于 [`zabbix/zabbix-docker` GitHub 仓库]  的 [`proxy-mysql/` 目录] ，提交 PR 前建议先阅读仓库 [README.md] 。

## 问题反馈
若使用中遇到问题或有疑问，可通过 [GitHub Issue]  联系我们。

## 贡献
欢迎提交新功能、修复或更新（无论大小），我们会尽快处理 PR。代码贡献前建议通过 GitHub Issue 讨论计划，确保方向一致。

## 许可协议
- Zabbix 7.0 及以上版本采用 GNU Affero General Public License v3（AGPLv3）
- 7.0 以下版本采用 GNU General Public License v2（GPLv2）
- 商业场景使用 Zabbix 时，建议购买技术支持服务。许可协议详情见 []
