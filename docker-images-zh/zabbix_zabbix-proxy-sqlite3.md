---
image: zabbix/zabbix-proxy-sqlite3
description: "Zabbix代理是Zabbix监控系统的关键组件，用于分布式监控架构中，承担数据采集、转发及本地缓存任务，能有效减轻中心服务器负载并提升监控响应效率；而支持SQLite3数据库的Zabbix代理，采用轻量级嵌入式数据库技术，无需独立数据库服务，配置简便且资源占用低，适用于中小型监控场景或资源受限环境，为用户提供灵活高效的本地数据存储与管理解决方案。"
source: https://xuanyuan.cloud/zh/r/zabbix/zabbix-proxy-sqlite3
canonical: https://xuanyuan.cloud/zh/r/zabbix/zabbix-proxy-sqlite3
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zabbix/zabbix-proxy-sqlite3" title="zabbix/zabbix-proxy-sqlite3 Docker 镜像中文简介、标签列表与拉取命令">zabbix/zabbix-proxy-sqlite3 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

![logo]()


# 什么是 Zabbix？

Zabbix 是一款企业级开源分布式监控解决方案。  

它能够监控网络的多项参数及服务器的健康状态与完整性，支持灵活的通知机制，允许用户为几乎所有事件配置邮件告警，以便快速响应服务器问题。同时，Zabbix 基于存储数据提供出色的报表和数据可视化功能，非常适合容量规划。  

更多信息及 Zabbix 组件的相关下载，可访问 [] 和  什么是 Zabbix 代理？

Zabbix 代理（proxy）是一个进程，可从一个或多个被监控设备收集监控数据，并将信息发送至 Zabbix 服务器，相当于代表服务器工作。所有收集的数据会先在本地缓存，再传输至其所属的 Zabbix 服务器。


# Zabbix 代理镜像

以下是官方唯一的 Zabbix 代理 Docker 镜像，基于 Alpine Linux v3.22、Ubuntu 24.04（noble）、CentOS Stream 10 及 Oracle Linux 10 构建。支持的 Zabbix 代理版本及对应标签如下：  

- Zabbix 代理 6.0（标签：alpine-6.0-latest、ubuntu-6.0-latest、ol-6.0-latest）  
- Zabbix 代理 6.0.*（标签：alpine-6.0.*、ubuntu-6.0.*、ol-6.0.*）  
- Zabbix 代理 7.0（标签：alpine-7.0-latest、ubuntu-7.0-latest、ol-7.0-latest）  
- Zabbix 代理 7.0.*（标签：alpine-7.0.*、ubuntu-7.0.*、ol-7.0.*）  
- Zabbix 代理 7.2（标签：alpine-7.2-latest、ubuntu-7.2-latest、ol-7.2-latest）  
- Zabbix 代理 7.2.*（标签：alpine-7.2.*、ubuntu-7.2.*、ol-7.2.*）  
- Zabbix 代理 7.4（标签：alpine-7.4-latest、ubuntu-7.4-latest、ol-7.4-latest、alpine-latest、ubuntu-latest、ol-latest、latest）  
- Zabbix 代理 7.4.*（标签：alpine-7.4.*、ubuntu-7.4.*、ol-7.4.*）  
- Zabbix 代理 8.0（标签：alpine-trunk、ubuntu-trunk、ol-trunk）  

镜像会随新版本发布更新，`latest` 标签基于 Alpine Linux。镜像使用 SQLite3 数据库存储待发送至 Zabbix 服务器的收集数据。


# 如何使用本镜像

## 启动 `zabbix-proxy-sqlite3`

通过以下命令启动 Zabbix 代理容器：  

```bash
docker run --name some-zabbix-proxy-sqlite3 -e ZBX_HOSTNAME=some-hostname -e ZBX_SERVER_HOST=some-zabbix-server --init -d zabbix/zabbix-proxy-sqlite3:tag
```

参数说明：  
- `some-zabbix-proxy-sqlite3`：自定义容器名称；  
- `some-hostname`：代理主机名（对应 Zabbix 代理配置文件中的 Hostname 参数）；  
- `some-zabbix-server`：Zabbix 服务器的 IP 或 DNS 名称；  
- `tag`：指定版本标签（参考上述列表或查看[完整标签列表]([])）。  

> **注意**  
> Zabbix 服务器可通过 `fping` 工具执行 ICMP 检查。若容器以无 root 模式或受限制环境运行，可能出现 `fping: Operation not permitted` 或「所有资源丢包」错误。此时需在 `docker run` 或 `podman run` 命令中添加 `--cap-add=net_raw`。此外，非 root 环境下运行 `fping` 可能需要修改系统参数：`net.ipv4.ping_group_range=0 1995`（其中 1995 为 `zabbix` 用户组 ID）。


## 从 Zabbix 服务器连接（被动代理模式）

若需将代理配置为被动模式（`ZBX_PROXYMODE=1`），镜像会暴露标准 Zabbix 代理端口（10051）。启动 Zabbix 服务器容器并关联代理容器的命令如下：  

```console
$ docker run --name some-zabbix-server --link some-zabbix-proxy-sqlite3:zabbix-proxy-sqlite3 --init -d zabbix/zabbix-server:latest
```


## 连接至 Zabbix 服务器（主动代理模式）

镜像默认以主动代理模式运行。启动代理容器并关联 Zabbix 服务器容器的命令如下：  

```console
$ docker run --name some-zabbix-proxy-sqlite3 --link some-zabbix-server:zabbix-server --init -d zabbix/zabbix-proxy-sqlite3:latest
```


## 容器命令行访问与日志查看

通过 `docker exec` 命令可进入容器命令行：  

```console
$ docker exec -ti some-zabbix-proxy-sqlite3 /bin/bash
```

通过容器日志查看 Zabbix 代理运行日志：  

```console
$ docker logs some-zabbix-proxy-sqlite3
```


## 环境变量

启动容器时，可通过 `docker run` 命令行传入环境变量调整代理配置，常用变量如下：  

### `ZBX_PROXYMODE`  
- 功能：切换代理模式；  
- 默认值：`0`（主动代理）；  
- 允许值：`0`（主动代理）、`1`（被动代理）。  

### `ZBX_HOSTNAME`  
- 功能：代理唯一主机名（区分大小写）；  
- 默认值：容器名 `zabbix-proxy-sqlite3`；  
- 对应配置：`zabbix_proxy.conf` 中的 `Hostname` 参数。  

### `ZBX_SERVER_HOST`  
- 功能：Zabbix 服务器或上级代理的 IP/DNS 名称；  
- 默认值：`zabbix-server`；  
- 对应配置：`zabbix_proxy.conf` 中的 `Server` 参数。若需指定非默认端口（主动检查），可在该变量后添加端口（如 `some-zabbix-server:10052`），无需单独设置 `ZBX_SERVER_PORT`（6.0+ 版本不再支持该变量）。  

### `ZBX_SERVER_PORT`  
- 功能：Zabbix 服务器监听端口；  
- 默认值：`10051`；  
- **注意**：6.0 及以上版本不再使用该变量，直接在 `ZBX_SERVER_HOST` 后加端口（如 `ZBX_SERVER_HOST=some-server:10052`）。  

### `ZBX_LOADMODULE`  
- 功能：指定加载的 Zabbix 模块（逗号分隔）；  
- 使用方式：需配合卷 `/var/lib/zabbix/modules`，格式如 `dummy1.so,dummy2.so`。  

### `ZBX_DEBUGLEVEL`  
- 功能：日志调试级别；  
- 默认值：`3`（警告）；  
- 允许值：`0`（启动/停止信息）、`1`（ critical）、`2`（错误）、`3`（警告）、`4`（调试）、`5`（详细调试）。  

### `ZBX_TIMEOUT`  
- 功能：检查超时时间（秒）；  
- 默认值：`4`。  

### `ZBX_JAVAGATEWAY_ENABLE`  
- 功能：启用与 Zabbix Java Gateway 的通信（收集 Java 相关监控项）；  
- 默认值：`false`。  

### 其他变量  
还支持以下配置变量（默认值见等号后）：  

```
ZBX_ENABLEREMOTECOMMANDS=0（3.4.0+ 支持）
ZBX_LOGREMOTECOMMANDS=0（3.4.0+ 支持）
ZBX_SOURCEIP=
ZBX_HOSTNAMEITEM=system.hostname
ZBX_PROXYLOCALBUFFER=0
ZBX_PROXYOFFLINEBUFFER=1
ZBX_PROXYHEARTBEATFREQUENCY=60（6.4.0+ 已废弃）
ZBX_CONFIGFREQUENCY=3600（6.4.0+ 已废弃）
ZBX_PROXYCONFIGFREQUENCY=10（6.4.0+ 支持）
ZBX_DATASENDERFREQUENCY=1
ZBX_STARTPOLLERS=5
ZBX_STARTPREPROCESSORS=3（4.2.0+ 支持）
ZBX_STARTIPMIPOLLERS=0
ZBX_STARTPOLLERSUNREACHABLE=1
ZBX_STARTTRAPPERS=5
ZBX_STARTPINGERS=1
ZBX_STARTDISCOVERERS=1
ZBX_STARTHISTORYPOLLERS=1（5.4.0-6.0.0 支持）
ZBX_STARTHTTPPOLLERS=1
ZBX_STARTODBCPOLLERS=1（6.0.0+ 支持）
ZBX_JAVAGATEWAY=zabbix-java-gateway
ZBX_JAVAGATEWAYPORT=10052
ZBX_STARTJAVAPOLLERS=0
ZBX_STATSALLOWEDIP=（4.0.5+ 支持）
ZBX_STARTVMWARECOLLECTORS=0
ZBX_VMWAREFREQUENCY=60
ZBX_VMWAREPERFFREQUENCY=60
ZBX_VMWARECACHESIZE=8M
ZBX_VMWARETIMEOUT=10
ZBX_ENABLE_SNMP_TRAPS=false
ZBX_LISTENIP=
ZBX_LISTENPORT=10051
ZBX_LISTENBACKLOG=
ZBX_HOUSEKEEPINGFREQUENCY=1
ZBX_CACHESIZE=8M
ZBX_STARTDBSYNCERS=4
ZBX_HISTORYCACHESIZE=16M
ZBX_HISTORYINDEXCACHESIZE=4M
ZBX_TRAPPERTIMEOUT=300
ZBX_UNREACHABLEPERIOD=45
ZBX_UNAVAILABLEDELAY=60
ZBX_UNREACHABLEDELAY=15
ZBX_LOGSLOWQUERIES=3000
ZBX_TLSLISTEN=（7.4.0+ 支持）
ZBX_TLSCONNECT=unencrypted
ZBX_TLSACCEPT=unencrypted
ZBX_TLSCAFILE=
ZBX_TLSCA=
ZBX_TLSCRLFILE=
ZBX_TLSCRL=
ZBX_TLSSERVERCERTISSUER=
ZBX_TLSSERVERCERTSUBJECT=
ZBX_TLSCERTFILE=
ZBX_TLSCERT=
ZBX_TLSKEYFILE=
ZBX_TLSKEY=
ZBX_TLSPSKIDENTITY=
ZBX_TLSPSKFILE=
ZBX_TLSPSK=
ZBX_TLSCIPHERALL=（4.4.7+ 支持）
ZBX_TLSCIPHERALL13=（4.4.7+ 支持）
ZBX_TLSCIPHERCERT=（4.4.7+ 支持）
ZBX_TLSCIPHERCERT13=（4.4.7+ 支持）
ZBX_TLSCIPHERPSK=（4.4.7+ 支持）
ZBX_TLSCIPHERPSK13=（4.4.7+ 支持）
ZBX_WEBDRIVERURL=（7.0.0+ 支持）
ZBX_STARTBROWSERPOLLERS=1（7.0.0+ 支持）
ZBX_STARTSNMPPOLLERS=1（7.0.0+ 支持）
```

上述变量与 `zabbix_proxy.conf` 中的参数一一对应（如 `ZBX_LOGSLOWQUERIES` 对应 `LogSlowQueries`），详情可参考 [官方配置文档]()。


# 支持的卷（Volumes）

### `/usr/lib/zabbix/externalscripts`  
用于存放外部检查脚本（对应 `zabbix_proxy.conf` 中的 `ExternalScripts` 参数）。  

### `/var/lib/zabbix/db_data`  
存储 SQLite3 数据库文件，可用于外部数据持久化。  

### `/var/lib/zabbix/modules`  
存放需加载的 Zabbix 模块（配合 `ZBX_LOADMODULE` 使用）。  

### `/var/lib/zabbix/enc`  
存放 TLS 相关文件（如 CA 证书、密钥），对应变量 `ZBX_TLSCAFILE`、`ZBX_TLSKEYFILE` 等；也可通过 `ZBX_TLSCA`、`ZBX_TLSKEY` 等变量传入明文内容。  

### `/var/lib/zabbix/ssh_keys`  
存放 SSH 检查及操作所需的公私钥（对应 `zabbix_proxy.conf` 中的 `SSHKeyLocation` 参数）。  

### `/var/lib/zabbix/ssl/certs`  
存放 SSL 客户端证书（对应 `SSLCertLocation` 参数）。  

### `/var/lib/zabbix/ssl/keys`  
存放 SSL 私钥（对应 `SSLKeyLocation` 参数）。  

### `/var/lib/zabbix/ssl/ssl_ca`  
存放 SSL 服务器证书验证所需的 CA 文件（对应 `SSLCALocation` 参数）。  

### `/var/lib/zabbix/snmptraps`  
存放 `snmptraps.log` 文件，可与 `zabbix-snmptraps` 容器共享（通过 `volumes_from` 继承）。启用 SNMP 陷阱功能需将 `ZBX_ENABLE_SNMP_TRAPS` 设为 `true`。  

### `/var/lib/zabbix/mibs`  
存放 SNMP MIB 文件（不支持子目录，需直接放在该路径下）。  


# 镜像变体

`zabbix-proxy-sqlite3` 提供多种镜像变体，适用于不同场景：  

## `zabbix-proxy-sqlite3:alpine-<version>`  
基于 [Alpine Linux]([])（轻量级发行版，镜像体积 ~5MB），适合对镜像大小有严格要求的场景。需注意其使用 `musl libc` 而非 `glibc`，部分依赖 `glibc` 的软件可能不兼容。  

## `zabbix-proxy-sqlite3:ubuntu-<version>`  
基于 Ubuntu 官方镜像，兼容性好，适合通用场景。  

## `zabbix-proxy-sqlite3:ol-<version>`  
基于 Oracle Linux（开源操作系统，支持 Oracle 工作负载），提供 Ksplice（零停机内核更新）、DTrace（实时诊断）等特性。  


# 支持的 Docker 版本

官方支持 Docker 1.12.0 及以上版本，1.6 及以下版本提供有限支持。升级 Docker 可参考 [官方安装文档]([])。  


# 用户反馈

## 文档  
镜像文档存放于 [zabbix-docker 仓库]([]) 的 `proxy-sqlite3/` 目录，提交 PR 前建议先阅读仓库 [README.md]([])。  

## 问题反馈  
使用问题可通过 [GitHub Issues]([]) 提交。  

## 贡献代码  
欢迎提交功能改进、bug 修复或更新（大小不限）。重大贡献建议先通过 GitHub Issue 讨论，以确保方向一致。  

## 许可证  
- Zabbix 7.0 及以上版本采用 GNU Affero 通用公共许可证第 3 版（AGPLv3）；  
- 6.4 及以下版本采用 GNU 通用公共许可证第 2 版（GPLv2）。  
具体条款可参考 [自由软件基金会文档]([])。商业环境中使用 Zabbix 建议购买技术支持以支持项目开发。
