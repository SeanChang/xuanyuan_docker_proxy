---
image: zabbix/zabbix-agent
description: "Zabbix代理（Zabbix agent）是部署在被监控主机上的客户端组件，在Zabbix监控架构中负责采集系统资源、应用程序性能及运行状态等关键数据，并通过支持TLS加密协议与Zabbix服务器或代理服务器进行安全通信，有效保障数据传输过程中的机密性与完整性，防止信息泄露或篡改，适用于对数据安全有严格要求的企业级监控场景，提升整体监控系统的安全性和可靠性。"
source: https://xuanyuan.cloud/zh/r/zabbix/zabbix-agent
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[zabbix/zabbix-agent](https://xuanyuan.cloud/zh/r/zabbix/zabbix-agent)
> 含镜像标签、拉取命令、部署文档与相关推荐。

![logo]()


# 什么是 Zabbix？

Zabbix 是一款企业级开源分布式监控解决方案。它能够监控网络的多项参数，以及服务器的健康状态与完整性。Zabbix 提供灵活的通知机制，支持用户为几乎所有事件配置邮件告警，助力快速响应服务器问题。此外，基于存储数据，Zabbix 还具备强大的报表生成与数据可视化功能，非常适合进行容量规划。

更多信息及 Zabbix 组件的相关下载，可访问：[] 和  什么是 Zabbix agent？

Zabbix agent 部署在被监控目标上，用于主动监控本地资源与应用（如硬盘、内存、处理器统计信息等）。


# Zabbix agent 镜像说明

以下是官方唯一的 Zabbix agent Docker 镜像，基于 Alpine Linux v3.22、Ubuntu 24.04（noble）、CentOS Stream 10、Oracle Linux 10、Windows 10 LTSC 2019 及 Windows 11 LTSC 2022 构建。支持的 Zabbix agent 版本及对应标签如下：

- **Zabbix agent 6.0**：标签 `alpine-6.0-latest`、`ubuntu-6.0-latest`、`ol-6.0-latest`  
- **Zabbix agent 6.0.*（小版本）**：标签 `alpine-6.0.*`、`ubuntu-6.0.*`、`ol-6.0.*`、`ltsc2019-6.0.*`、`ltsc2022-6.0.*`  
- **Zabbix agent 7.0**：标签 `alpine-7.0-latest`、`ubuntu-7.0-latest`、`ol-7.0-latest`  
- **Zabbix agent 7.0.*（小版本）**：标签 `alpine-7.0.*`、`ubuntu-7.0.*`、`ol-7.0.*`、`ltsc2019-7.0.*`、`ltsc2022-7.0.*`  
- **Zabbix agent 7.2**：标签 `alpine-7.2-latest`、`ubuntu-7.2-latest`、`ol-7.2-latest`  
- **Zabbix agent 7.2.*（小版本）**：标签 `alpine-7.2.*`、`ubuntu-7.2.*`、`ol-7.2.*`、`ltsc2019-7.2.*`、`ltsc2022-7.2.*`  
- **Zabbix agent 7.4**：标签 `alpine-7.4-latest`、`ubuntu-7.4-latest`、`ol-7.4-latest`、`alpine-latest`、`ubuntu-latest`、`ol-latest`、`ltsc2019-latest`、`ltsc2022-latest`、`latest`（注：`latest` 标签默认基于 Alpine Linux）  
- **Zabbix agent 7.4.*（小版本）**：标签 `alpine-7.4.*`、`ubuntu-7.4.*`、`ol-7.4.*`、`ltsc2019-7.4.*`、`ltsc2022-7.4.*`  
- **Zabbix agent 8.0（开发版）**：标签 `alpine-trunk`、`ubuntu-trunk`、`ol-trunk`、`ltsc2019-trunk`、`ltsc2022-trunk`  

镜像会随新版本发布自动更新。


# 如何使用该镜像

## 启动 Zabbix agent 容器

通过以下命令启动 Zabbix agent 容器：

```bash
docker run --name some-zabbix-agent -e ZBX_HOSTNAME="some-hostname" -e ZBX_SERVER_HOST="some-zabbix-server" --init -d zabbix/zabbix-agent:tag
```

参数说明：  
- `some-zabbix-agent`：自定义容器名称；  
- `some-hostname`：被监控主机名（对应 Zabbix agent 配置文件中的 `Hostname` 参数）；  
- `some-zabbix-server`：Zabbix 服务器或代理的 IP 或域名；  
- `tag`：指定版本的标签（参考上文标签列表，或查看 [完整标签列表]([])）。  


## 与其他容器中的 Zabbix 服务器/代理连接（被动检查）

该镜像暴露默认 Zabbix agent 端口（`10050`）用于被动检查，通过容器链接可让 Zabbix 服务器/代理访问 agent。示例：将 Zabbix 服务器容器链接到 agent 容器：

```console
$ docker run --name some-zabbix-server --link some-zabbix-agent:zabbix-agent --init -d zabbix/zabbix-server:latest
```


## 连接到 Zabbix 服务器/代理容器（主动检查）

该镜像支持主动检查，通过容器链接可让 agent 访问 Zabbix 服务器/代理。示例：将 agent 容器链接到服务器/代理容器：

```console
$ docker run --name some-zabbix-agent --link some-zabbix-server:zabbix-server --init -d zabbix/zabbix-agent:latest
```


## 容器命令行访问与日志查看

### 进入容器命令行  
使用 `docker exec` 命令进入容器 bash 终端：  
```console
$ docker exec -ti some-zabbix-agent /bin/bash
```

### 查看 Zabbix agent 日志  
通过 Docker 容器日志查看 agent 运行日志：  
```console
$ docker logs some-zabbix-agent
```


## 特权模式

默认 Docker 容器为“非特权”模式，无法访问主机大部分资源。由于 Zabbix agent 需要监控系统资源，需以特权模式运行或挂载系统卷。示例：

```bash
# 特权模式
docker run --name some-zabbix-agent --link some-zabbix-server:zabbix-server --privileged --init -d zabbix/zabbix-agent:latest

# 挂载系统卷（如监控特定磁盘）
docker run --name some-zabbix-agent --link some-zabbix-server:zabbix-server -v /dev/sdc:/dev/sdc --init -d zabbix/zabbix-agent:latest
```


## 环境变量配置

启动容器时，可通过 `-e` 参数传递环境变量调整 Zabbix agent 配置，常用变量如下：

### 核心变量  
- **`ZBX_HOSTNAME`**：唯一主机名（区分大小写），默认值为容器 hostname，对应配置文件 `Hostname` 参数。  
- **`ZBX_SERVER_HOST`**：Zabbix 服务器/代理的 IP 或域名，默认值 `zabbix-server`，对应配置文件 `Server` 参数。可配合 `ZBX_SERVER_PORT` 指定非默认端口。  
- **`ZBX_PASSIVE_ALLOW`**：是否允许被动检查（`true`/`false`），默认 `true`。  
- **`ZBX_ACTIVE_ALLOW`**：是否允许主动检查（`true`/`false`），默认 `true`。  
- **`ZBX_DEBUGLEVEL`**：日志调试级别（0-5），默认 `3`（警告）；0=基本信息，1=严重错误，2=错误，3=警告，4=调试，5=详细调试。  
- **`ZBX_TIMEOUT`**：检查超时时间（秒），默认 `3`。  


### 其他常用变量  
（以下变量默认值已标注，对应 `zabbix_agentd.conf` 配置文件参数）  

```
ZBX_SOURCEIP=                      # 源 IP
ZBX_LOGREMOTECOMMANDS=0            # 记录远程命令日志
ZBX_HEARTBEAT_FREQUENCY=60         # 心跳频率（6.2.0+支持）
ZBX_STARTAGENTS=3                  # 被动检查进程数
ZBX_HOSTNAMEITEM=system.hostname   # 自动获取主机名的键值
ZBX_REFRESHACTIVECHECKS=120        # 主动检查刷新间隔（秒）
ZBX_LISTENPORT=10050               # 监听端口
ZBX_UNSAFEUSERPARAMETERS=0         # 是否允许不安全的用户参数
ZBX_TLSCONNECT=unencrypted         # 出站连接加密方式
ZBX_TLSACCEPT=unencrypted          # 入站连接加密方式
```

更多变量说明可参考 [官方 `zabbix_agentd.conf` 文档]()。


## 支持的挂载卷

### `/etc/zabbix/zabbix_agentd.d`  
挂载该目录可添加自定义 `*.conf` 文件，通过 `UserParameter` 扩展监控项。  

### `/var/lib/zabbix/modules`  
挂载该目录可加载额外模块（通过 `LoadModule` 配置）。  

### `/var/lib/zabbix/enc`  
用于存储 TLS 相关文件（如 CA 证书、密钥），需配合 `ZBX_TLSCAFILE`、`ZBX_TLSCERTFILE` 等变量指定文件路径；也可通过 `ZBX_TLSCA`、`ZBX_TLSCERT` 等变量直接传入文本内容。  


# 镜像变体说明

## `zabbix-agent:alpine-<version>`  
基于 Alpine Linux，镜像体积极小（约 5MB 基础镜像），适合对镜像大小敏感的场景。需注意其使用 musl libc，部分依赖 glibc 的软件可能不兼容。  

## `zabbix-agent:ubuntu-<version>`  
默认推荐镜像，基于 Ubuntu 系统，兼容性好，适合大多数通用场景，可直接作为基础镜像构建其他应用。  

## `zabbix-agent:ol-<version>`  
基于 Oracle Linux，适合 Oracle 工作负载，支持 Ksplice（零停机内核补丁）、DTrace（实时诊断）等独有特性。  


# 支持的 Docker 版本

官方支持 Docker 1.12.0 及以上版本，1.6 及以下版本仅提供有限兼容。升级 Docker 可参考 [Docker 安装文档]([])。


# 用户反馈与支持

## 文档  
镜像文档存于 [GitHub 仓库 `agent/` 目录]([])，使用前建议先阅读 [仓库 README]([])。  

## 问题反馈  
如遇问题，可通过 [GitHub Issues]([]) 提交。  

### 已知问题  
暂不支持通过 `ZBX_ALIAS` 环境变量配置别名，需通过 `/etc/zabbix/zabbix_agent.d` 卷挂载包含 `Alias` 配置的文件。  

## 贡献代码  
欢迎提交新功能、修复或更新，建议先通过 [GitHub Issues]([]) 讨论计划。  


# 许可协议  

- Zabbix 7.0 及以上版本采用 GNU Affero General Public License v3（AGPLv3）；  
- 6.4 及以下版本采用 GNU General Public License v2（GPLv2）。  
详细条款见 [FSF 许可页面]([])。商业场景中使用 Zabbix 时，建议购买技术支持以助力开发。
