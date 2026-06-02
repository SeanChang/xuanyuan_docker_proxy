---
image: zabbix/zabbix-agent2
description: "Zabbix agent 2是一款用于系统与网络监控的数据采集代理程序，其支持TLS加密功能，能够在数据从监控目标设备传输至Zabbix服务器的过程中提供安全防护，有效防止数据在传输环节被非法窃听、篡改或泄露，从而提升监控系统整体的数据传输安全性与可靠性，适用于对数据安全有较高要求的企业级监控场景。"
source: https://xuanyuan.cloud/zh/r/zabbix/zabbix-agent2
canonical: https://xuanyuan.cloud/zh/r/zabbix/zabbix-agent2
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zabbix/zabbix-agent2" title="zabbix/zabbix-agent2 Docker 镜像中文简介、标签列表与拉取命令">zabbix/zabbix-agent2 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

![logo]()

# 什么是 Zabbix？

Zabbix 是一款企业级开源分布式监控解决方案。它能监控网络的多项参数，以及服务器的健康状态与完整性。Zabbix 具备灵活的通知机制，支持用户为几乎所有事件配置邮件告警，帮助快速响应服务器问题。同时，它基于存储数据提供优秀的报表和数据可视化功能，非常适合容量规划。

更多信息及 Zabbix 组件的相关下载，可访问 [] 和  什么是 Zabbix agent 2？

Zabbix agent 2 部署在被监控目标上，用于主动监控本地资源与应用（如硬盘、内存、处理器统计等）。


# Zabbix agent 2 镜像

以下是官方发布的 Zabbix agent 2 Docker 镜像，基于 Alpine Linux v3.22、Ubuntu 24.04（noble）、CentOS Stream 10、Oracle Linux 10、Windows 10 LTSC 2019 和 Windows 11 LTSC 2022 构建。支持的 Zabbix agent 2 版本及对应标签如下：

- Zabbix agent 2 6.0（标签：alpine-6.0-latest、ubuntu-6.0-latest、ol-6.0-latest）
- Zabbix agent 2 6.0.*（标签：alpine-6.0.*、ubuntu-6.0.*、ol-6.0.*、ltsc2019-6.0.*、ltsc2022-6.0.*）
- Zabbix agent 2 7.0（标签：alpine-7.0-latest、ubuntu-7.0-latest、ol-7.0-latest）
- Zabbix agent 2 7.0.*（标签：alpine-7.0.*、ubuntu-7.0.*、ol-7.0.*、ltsc2019-7.0.*、ltsc2022-7.0.*）
- Zabbix agent 2 7.2（标签：alpine-7.2-latest、ubuntu-7.2-latest、ol-7.2-latest）
- Zabbix agent 2 7.2.*（标签：alpine-7.2.*、ubuntu-7.2.*、ol-7.2.*、ltsc2019-7.2.*、ltsc2022-7.2.*）
- Zabbix agent 2 7.4（标签：alpine-7.4-latest、ubuntu-7.4-latest、ol-7.4-latest、alpine-latest、ubuntu-latest、ol-latest、ltsc2019-latest、ltsc2022-latest、latest）
- Zabbix agent 2 7.4.*（标签：alpine-7.4.*、ubuntu-7.4.*、ol-7.4.*、ltsc2019-7.4.*、ltsc2022-7.4.*）
- Zabbix agent 2 8.0（标签：alpine-trunk、ubuntu-trunk、ol-trunk、ltsc2019-trunk、ltsc2022-trunk）

镜像会随新版本发布更新，`latest` 标签默认基于 Alpine Linux。


# 如何使用此镜像

## 启动 `zabbix-agent2`

通过以下命令启动 Zabbix agent 2 容器：

```bash
docker run --name some-zabbix-agent -e ZBX_HOSTNAME="some-hostname" -e ZBX_SERVER_HOST="some-zabbix-server" --init -d zabbix/zabbix-agent2:tag
```

参数说明：  
- `some-zabbix-agent`：自定义容器名称  
- `some-hostname`：主机名（对应 Zabbix agent 2 配置文件中的 `Hostname` 参数）  
- `some-zabbix-server`：Zabbix 服务器或代理的 IP 或 DNS 名称  
- `tag`：指定版本的标签（见上文列表或 [完整标签列表]([])）  


## 从其他容器中的 Zabbix 服务器/代理连接（被动检查）

此镜像暴露 Zabbix agent 2 的标准端口（`10050`）用于被动检查。通过容器链接，可让 Zabbix 服务器/代理容器访问 agent 实例。启动服务器/代理容器时链接 agent：

```console
$ docker run --name some-zabbix-server --link some-zabbix-agent:zabbix-agent2 --init -d zabbix/zabbix-server:latest
```


## 连接到 Zabbix 服务器/代理容器（主动检查）

镜像支持主动检查，通过容器链接可让 agent 访问服务器/代理容器。启动 agent 时链接服务器/代理：

```console
$ docker run --name some-zabbix-agent --link some-zabbix-server:zabbix-server --init -d zabbix/zabbix-agent2:latest
```


## 容器命令行访问与日志查看

使用 `docker exec` 进入容器命令行：

```console
$ docker exec -ti some-zabbix-agent /bin/bash
```

通过 Docker 日志查看 agent 运行日志：

```console
$ docker logs some-zabbix-agent
```


## 特权模式

默认容器权限有限，无法访问主机资源。若需监控系统资源，可使用特权模式或挂载系统卷：

```console
# 特权模式
$ docker run --name some-zabbix-agent --link some-zabbix-server:zabbix-server --privileged --init -d zabbix/zabbix-agent2:latest

# 挂载特定卷（如磁盘）
$ docker run --name some-zabbix-agent --link some-zabbix-server:zabbix-server -v /dev/sdc:/dev/sdc --init -d zabbix/zabbix-agent2:latest
```


## 环境变量

启动容器时，可通过环境变量调整 agent 配置，常用变量如下：

### `ZBX_HOSTNAME`  
- 说明：唯一主机名（区分大小写），对应配置文件中的 `Hostname` 参数  
- 默认值：容器 hostname  

### `ZBX_SERVER_HOST`  
- 说明：Zabbix 服务器/代理的 IP 或 DNS 名称，对应配置文件中的 `Server` 参数  
- 默认值：`zabbix-server`  
- 注：可通过 `ZBX_SERVER_PORT` 指定非默认端口  

### `ZBX_PASSIVE_ALLOW`  
- 说明：是否启用被动检查（`true`/`false`）  
- 默认值：`true`  

### `ZBX_PASSIVESERVERS`  
- 说明：允许连接 agent 的服务器/代理主机列表（逗号分隔）  

### `ZBX_ACTIVE_ALLOW`  
- 说明：是否启用主动检查（`true`/`false`）  
- 默认值：`true`  

### `ZBX_ACTIVESERVERS`  
- 说明：允许 agent 连接的服务器/代理列表（支持指定端口，如 `zabbix-server:10061`）  

### `ZBX_DEBUGLEVEL`  
- 说明：日志调试级别（0-5，数值越高日志越详细）  
- 默认值：`3`（警告）  
- 级别说明：0（启动/停止信息）、1（严重错误）、2（错误）、3（警告）、4（调试）、5（详细调试）  

### `ZBX_TIMEOUT`  
- 说明：检查超时时间（秒）  
- 默认值：`3`  

### 其他变量  
以下变量对应 `zabbix_agent2.conf` 配置参数，默认值已标注：  
```
ZBX_ENABLEPERSISTENTBUFFER=false  # 启用持久化缓冲区（5.0.0+支持）
ZBX_PERSISTENTBUFFERPERIOD=1h      # 缓冲区周期（5.0.0+支持）
ZBX_ENABLESTATUSPORT=              # 状态端口
ZBX_SOURCEIP=                      # 源 IP
ZBX_HEARTBEAT_FREQUENCY=60         # 心跳频率（6.2.0+支持）
ZBX_ENABLEREMOTECOMMANDS=0         # 启用远程命令（5.0.0+已弃用）
ZBX_LOGREMOTECOMMANDS=0            # 记录远程命令
ZBX_STARTAGENTS=3                  # 被动检查进程数
ZBX_HOSTNAMEITEM=system.hostname   # 主机名获取项
ZBX_METADATA=                      # 元数据
ZBX_METADATAITEM=                  # 元数据获取项
ZBX_REFRESHACTIVECHECKS=120        # 主动检查刷新间隔（秒）
ZBX_BUFFERSEND=5                   # 发送缓冲区大小（秒）
ZBX_BUFFERSIZE=100                 # 缓冲区大小（值数量）
ZBX_MAXLINESPERSECOND=20           # 每秒最大行数
ZBX_LISTENIP=                      # 监听 IP
ZBX_LISTENPORT=10051               # 监听端口
ZBX_UNSAFEUSERPARAMETERS=0         # 允许不安全的用户参数
ZBX_TLSCONNECT=unencrypted         # TLS 连接方式
ZBX_TLSACCEPT=unencrypted          # TLS 接受方式
ZBX_TLSCAFILE=                     # TLS CA 文件路径
ZBX_TLSCA=                         # TLS CA 内容（明文）
ZBX_TLSCRLFILE=                    # TLS CRL 文件路径
ZBX_TLSCRL=                        # TLS CRL 内容（明文）
ZBX_TLSSERVERCERTISSUER=           # 服务器证书颁发者
ZBX_TLSSERVERCERTSUBJECT=          # 服务器证书主题
ZBX_TLSCERTFILE=                   # TLS 证书文件路径
ZBX_TLSCERT=                       # TLS 证书内容（明文）
ZBX_TLSKEYFILE=                    # TLS 密钥文件路径
ZBX_TLSKEY=                        # TLS 密钥内容（明文）
ZBX_TLSPSKIDENTITY=                # TLS PSK 标识
ZBX_TLSPSKFILE=                    # TLS PSK 文件路径
ZBX_TLSPSK=                        # TLS PSK 内容（明文）
ZBX_DENYKEY=system.run[*]          # 禁用的键（5.0.0+支持）
ZBX_ALLOWKEY=                      # 允许的键（5.0.0+支持）
```

更多配置说明见 [官方文档]()。


## 支持的卷挂载

### `/etc/zabbix/zabbix_agentd.d`  
用于挂载自定义配置文件（`.conf` 格式），扩展 `UserParameter` 功能。

### `/var/lib/zabbix/enc`  
存储 TLS 相关文件（如 CA 证书、密钥），需配合 `ZBX_TLSCAFILE` 等变量指定文件名。也可通过 `ZBX_TLSCA` 等变量直接传入明文内容。

### `/var/lib/zabbix/buffer`  
启用持久化缓冲区（`ZBX_ENABLEPERSISTENTBUFFER=true`）时，用于存储 SQLite 数据库文件（5.0.0+支持）。


# 镜像变体

## `zabbix-agent2:alpine-<version>`  
基于 Alpine Linux（~5MB 体积），适合追求最小镜像的场景。使用 musl libc，部分依赖 glibc 的软件可能存在兼容性问题。

## `zabbix-agent2:ubuntu-<version>`  
默认推荐镜像，基于 Ubuntu，兼容性好，适合通用场景。

## `zabbix-agent2:ol-<version>`  
基于 Oracle Linux，针对 Oracle 工作负载优化，支持 Ksplice、DTrace 等企业级特性。


# 支持的 Docker 版本

官方支持 Docker 1.12.0 及以上版本，1.6 及以下版本仅提供有限兼容。  
升级 Docker 可参考 [官方安装文档]([])。


# 用户反馈

## 文档  
镜像文档存储在 [zabbix-docker 仓库]([]) 的 `agent2/` 目录下，使用前建议先阅读 [仓库 README]([])。

## 问题反馈  
如有问题，可通过 [GitHub Issue]([]) 提交。  
**已知问题**：暂不支持 `ZBX_ALIAS` 环境变量，需通过 `/etc/zabbix/zabbix_agent.d` 卷挂载包含 `Alias` 配置的文件。

## 贡献代码  
欢迎提交功能、修复或更新，建议先通过 GitHub Issue 讨论计划，再提交 PR。

## 许可证  
Zabbix 7.0 及以上版本基于 GNU Affero General Public License v3 (AGPLv3) 发布，6.4 及以下版本基于 GPLv2。具体条款见 [FSF 文档]([])。商业用户可通过购买技术支持支持开发。
