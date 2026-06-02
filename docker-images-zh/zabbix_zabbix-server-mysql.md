---
image: zabbix/zabbix-server-mysql
description: "Zabbix Server是一款广泛应用的开源监控解决方案，主要用于对网络设备、服务器、虚拟机及各类应用程序进行实时性能监控与状态管理，而支持MySQL数据库则使其能够高效存储、查询和管理海量监控数据，包括性能指标、事件日志及告警信息等，通过与MySQL的深度整合，进一步提升了监控系统的数据处理能力、稳定性和可扩展性，满足企业级监控场景下对数据可靠性与高效分析的需求。"
source: https://xuanyuan.cloud/zh/r/zabbix/zabbix-server-mysql
canonical: https://xuanyuan.cloud/zh/r/zabbix/zabbix-server-mysql
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [zabbix/zabbix-server-mysql — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/zabbix/zabbix-server-mysql)

含镜像标签、拉取命令、部署文档与相关推荐。

[zabbix/zabbix-server-mysql Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/zabbix/zabbix-server-mysql)

![logo]()

# 什么是 Zabbix？

Zabbix 是一款企业级开源分布式监控解决方案。  

它能监控网络的多项参数及服务器的健康状态与完整性，支持灵活的通知机制，允许用户为几乎任何事件配置基于邮件的告警，以便快速响应服务器问题。同时，Zabbix 基于存储数据提供出色的报表和数据可视化功能，非常适合容量规划。  

更多信息及组件下载可访问：[] 和   


# 什么是 Zabbix server？

Zabbix server 是 Zabbix 软件的核心进程。  

它负责数据的轮询与捕获、触发器计算、向用户发送通知。Zabbix 代理（agents）和代理服务器（proxies）会向其上报系统的可用性和完整性数据。此外，server 自身可通过简单的服务检查远程监控网络服务（如 Web 服务器、邮件服务器）。  


# Zabbix server 镜像

以下是官方唯一的 Zabbix server Docker 镜像，基于 Alpine Linux v3.22、Ubuntu 24.04（noble）、CentOS Stream 10 和 Oracle Linux 10 构建。支持的 Zabbix server 版本及标签如下：  

- Zabbix server 6.0（标签：alpine-6.0-latest、ubuntu-6.0-latest、ol-6.0-latest）  
- Zabbix server 6.0.*（标签：alpine-6.0.*、ubuntu-6.0.*、ol-6.0.*）  
- Zabbix server 7.0（标签：alpine-7.0-latest、ubuntu-7.0-latest、ol-7.0-latest）  
- Zabbix server 7.0.*（标签：alpine-7.0.*、ubuntu-7.0.*、ol-7.0.*）  
- Zabbix server 7.2（标签：alpine-7.2-latest、ubuntu-7.2-latest、ol-7.2-latest）  
- Zabbix server 7.2.*（标签：alpine-7.2.*、ubuntu-7.2.*、ol-7.2.*）  
- Zabbix server 7.4（标签：alpine-7.4-latest、ubuntu-7.4-latest、ol-7.4-latest、alpine-latest、ubuntu-latest、ol-latest、latest）  
- Zabbix server 7.4.*（标签：alpine-7.4.*、ubuntu-7.4.*、ol-7.4.*）  
- Zabbix server 8.0（标签：alpine-trunk、ubuntu-trunk、ol-trunk）  

镜像会随新版本发布更新，`latest` 标签基于 Alpine Linux。  

镜像使用 MySQL 数据库，启动流程如下：  
1. 检查数据库可用性；  
2. 若指定 `MYSQL_ROOT_PASSWORD` 或 `MYSQL_ALLOW_EMPTY_PASSWORD`，尝试创建 `MYSQL_USER` 用户并设置 `MYSQL_PASSWORD`，供 Zabbix server 使用；  
3. 检查 `MYSQL_DATABASE` 数据库是否存在，不存在则创建；  
4. 检查 `dbversion` 表是否存在，不存在则创建 Zabbix server 数据库 schema 并导入初始数据样本。  


# 如何使用此镜像

## 启动 `zabbix-server-mysql`

通过以下命令启动 Zabbix server 容器：  

```bash
docker run --name some-zabbix-server-mysql -e DB_SERVER_HOST="some-mysql-server" -e MYSQL_USER="some-user" -e MYSQL_PASSWORD="some-password" --init -d zabbix/zabbix-server-mysql:tag
```  

参数说明：  
- `some-zabbix-server-mysql`：容器名称；  
- `some-mysql-server`：MySQL 服务器的 IP 或 DNS 名称；  
- `some-user`/`some-password`：连接 Zabbix 数据库的用户及密码；  
- `tag`：指定镜像版本标签（见上文“Zabbix server 镜像”中的标签列表）。  

> [!NOTE]  
> Zabbix server 可通过 `fping` 工具执行 ICMP 检查。若容器运行在无 root 模式或受限制环境中，可能出现 `fping: Operation not permitted` 错误或丢包问题。此时需在 `docker run` 或 `podman run` 命令中添加 `--cap-add=net_raw`，并修改系统参数：  
> ```bash
> sysctl -w net.ipv4.ping_group_range=0 1995  # 1995 为 zabbix 用户组 GID
> ```  


## 容器 shell 访问与日志查看

### 进入容器 shell  
使用 `docker exec` 命令进入容器：  

```bash
docker exec -ti some-zabbix-server-mysql /bin/bash
```  

### 查看 Zabbix server 日志  
通过 Docker 容器日志查看：  

```bash
docker logs some-zabbix-server-mysql
```  


## 环境变量

启动镜像时，可通过 `-e` 参数指定环境变量调整 Zabbix server 配置。  

### 核心数据库变量  
- **`DB_SERVER_HOST`**：MySQL 服务器 IP 或 DNS 名称，默认 `mysql-server`；  
- **`DB_SERVER_PORT`**：MySQL 端口，默认 `3306`；  
- **`MYSQL_USER`/`MYSQL_PASSWORD`**：连接数据库的用户及密码，默认均为 `zabbix`；  
- **`MYSQL_USER_FILE`/`MYSQL_PASSWORD_FILE`**：从文件读取用户/密码（适用于 Docker Swarm/Kubernetes 密钥管理），与 `MYSQL_USER`/`MYSQL_PASSWORD` 互斥，只能选一种。  

#### 示例：使用文件传递凭据（非 Swarm/K8s 环境）  
```bash
docker run --name some-zabbix-server-mysql \
  -e DB_SERVER_HOST="some-mysql-server" \
  -v ./.MYSQL_USER:/run/secrets/MYSQL_USER -e MYSQL_USER_FILE=/run/secrets/MYSQL_USER \
  -v ./.MYSQL_PASSWORD:/run/secrets/MYSQL_PASSWORD -e MYSQL_PASSWORD_FILE=/var/run/secrets/MYSQL_PASSWORD \
  --init -d zabbix/zabbix-server-mysql:tag
```  

#### 示例：使用 Docker Swarm 密钥  
```bash
printf "zabbix" | docker secret create MYSQL_USER -  # 创建用户密钥
printf "zabbix" | docker secret create MYSQL_PASSWORD -  # 创建密码密钥
docker run --name some-zabbix-server-mysql \
  -e DB_SERVER_HOST="some-mysql-server" \
  -e MYSQL_USER_FILE=/run/secrets/MYSQL_USER \
  -e MYSQL_PASSWORD_FILE=/run/secrets/MYSQL_PASSWORD \
  --init -d zabbix/zabbix-server-mysql:tag
```  

### 其他常用变量  
- **`ZBX_LOADMODULE`**：逗号分隔的可加载模块列表（需配合 `/var/lib/zabbix/modules` 卷），如 `dummy1.so,dummy2.so`；  
- **`ZBX_DEBUGLEVEL`**：调试级别（0-5，默认 3），对应 `zabbix_server.conf` 中的 `DebugLevel`；  
- **`ZBX_TIMEOUT`**：检查超时时间（默认 4 秒）；  
- **`ZBX_JAVAGATEWAY_ENABLE`**：是否启用 Java Gateway（默认 `false`）。  

更多变量（如 `ZBX_STARTPOLLERS`、`ZBX_CACHESIZE` 等）及默认值见下方，均对应 `zabbix_server.conf` 中的参数：  

```
ZBX_ALLOWUNSUPPORTEDDBVERSIONS=0  # 支持非兼容数据库版本（6.0.0+）
ZBX_DEBUGLEVEL=3  # 调试级别（0-5）
ZBX_TIMEOUT=4  # 检查超时时间（秒）
ZBX_STARTPOLLERS=5  # 轮询进程数
ZBX_STARTPINGERS=1  # ICMP 检查进程数
ZBX_CACHESIZE=8M  # 缓存大小
ZBX_HISTORYCACHESIZE=16M  # 历史数据缓存大小
```  

完整参数说明可参考 [zabbix_server.conf 官方文档]()。  


## 容器支持的卷

### `/usr/lib/zabbix/alertscripts`  
自定义告警脚本目录，对应 `zabbix_server.conf` 中的 `AlertScriptsPath`。  

### `/usr/lib/zabbix/externalscripts`  
外部检查脚本目录（用于 Item 类型为“外部检查”），对应 `ExternalScripts`。  

### `/var/lib/zabbix/modules`  
存放可加载模块，配合 `ZBX_LOADMODULE` 变量扩展功能。  

### `/var/lib/zabbix/enc`  
存放 TLS 相关文件（如 CA 证书、密钥），需通过 `ZBX_TLSCAFILE` 等变量指定文件名。  

### `/var/lib/zabbix/ssh_keys`  
SSH 检查/动作的密钥目录，对应 `SSHKeyLocation`。  

### `/var/lib/zabbix/snmptraps`  
`snmp traps.log` 文件目录，需与 `zabbix-snmptraps` 容器共享，并设置 `ZBX_ENABLE_SNMP_TRAPS=true` 启用 SNMP traps 处理。  


# 镜像变体

## `zabbix-server-mysql:alpine-<version>`  
基于 Alpine Linux，体积极小（~5MB 基础镜像），适合对镜像大小敏感的场景。使用 musl libc，部分依赖 glibc 的软件可能不兼容。  

## `zabbix-server-mysql:ubuntu-<version>`  
基于 Ubuntu，默认推荐版本。使用 glibc，兼容性更广，适合大多数通用场景。  

## `zabbix-server-mysql:ol-<version>`  
基于 Oracle Linux，针对 Oracle 工作负载优化，支持 Ksplice 内核热补丁、DTrace 诊断等 Oracle 特有功能。  


# 支持的 Docker 版本

官方支持 Docker 1.12.0 及以上版本，1.6 及以上旧版本提供有限支持。  
升级 Docker 可参考 [Docker 官方安装文档]([])。  


# 用户反馈

## 文档  
镜像文档存放于 [zabbix-docker 仓库的 `server-mysql/` 目录]([])，提交 PR 前建议先阅读仓库 [README.md]([])。  

## 问题反馈  
使用中遇到问题可通过 [GitHub Issue]([]) 提交。  

## 贡献代码  
欢迎提交功能改进、bug 修复或更新，建议先通过 GitHub Issue 讨论方案。  

## 许可证  
- Zabbix 7.0 及以上版本：采用 GNU Affero General Public License v3（AGPLv3）；  
- 6.4 及以下版本：采用 GNU General Public License v2（GPLv2）。  
商业场景使用建议购买技术支持，详情见 [Zabbix 官网]()。
