---
image: library/zookeeper
description: "Apache ZooKeeper 是一款开源服务器，专为分布式系统设计，致力于提供高可靠的协调服务，它通过简洁高效的接口支持配置管理、命名服务、分布式锁、集群节点同步等关键功能，帮助分布式应用实现数据一致性维护、节点状态监控及故障自动恢复，是构建稳定、可靠分布式架构不可或缺的基础设施，广泛应用于分布式计算、大数据处理等领域，为各类分布式系统的协调与协作提供坚实保障。"
source: https://xuanyuan.cloud/zh/r/library/zookeeper
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[library/zookeeper](https://xuanyuan.cloud/zh/r/library/zookeeper)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Apache ZooKeeper Docker镜像使用指南


## 基础参考信息

### 维护方  
[Docker社区]([])

### 获取帮助渠道  
[Docker社区Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])


## 支持的标签及对应Dockerfile链接  

- [`3.8.4`, `3.8`, `3.8.4-jre-17`, `3.8-jre-17`]([])  
- [`3.9.4`, `3.9`, `3.9.4-jre-17`, `3.9-jre-17`, `latest`]([])  


## 扩展参考信息  

### 问题反馈地址  
[[]]([])

### 支持的架构  
（[更多信息]([])）  
[`amd64`]([])、[`arm64v8`]([])、[`ppc64le`]([])、[`s390x`]([])

### 镜像 artifact 详情  
[repo-info 仓库的 `repos/zookeeper/` 目录]([])（[历史记录]([])）  
（包含镜像元数据、传输大小等）

### 镜像更新  
[official-images 仓库的 `library/zookeeper` 标签]([])  
[official-images 仓库的 `library/zookeeper` 文件]([])（[历史记录]([])）

### 本文档来源  
[docs 仓库的 `zookeeper/` 目录]([])（[历史记录]([])）  


## 什么是 Apache ZooKeeper？  

Apache ZooKeeper 是 Apache 软件基金会的开源项目，为大型分布式系统提供分布式配置服务、同步服务和命名注册功能。ZooKeeper 原是 Hadoop 的子项目，现已是独立的顶级项目。  

> [.org/wiki/Apache_ZooKeeper]()  

![logo]([])  


## 如何使用本镜像  


### 启动 Zookeeper 服务实例  

```console
$ docker run --name some-zookeeper --restart always -d zookeeper
```  

本镜像暴露端口 `2181`（客户端端口）、`2888`（ follower 端口）、`3888`（选举端口）、`8080`（AdminServer 端口）。标准容器链接可自动将这些端口提供给关联容器使用。由于 Zookeeper 采用“快速失败”机制，建议始终启用自动重启。  


### 从其他 Docker 容器中的应用连接 Zookeeper  

```console
$ docker run --name some-app --link some-zookeeper:zookeeper -d application-that-uses-zookeeper
```  


### 通过 Zookeeper 命令行客户端连接  

```console
$ docker run -it --rm --link some-zookeeper:zookeeper zookeeper zkCli.sh -server zookeeper
```  


### 通过 Docker Compose 使用  

以下是 `compose.yaml` 示例，用于启动 Zookeeper 集群（复制模式）：  

```yaml
services:
  zoo1:
    image: zookeeper
    restart: always
    hostname: zoo1
    ports:
      - 2181:2181
    environment:
      ZOO_MY_ID: 1
      ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=zoo3:2888:3888;2181

  zoo2:
    image: zookeeper
    restart: always
    hostname: zoo2
    ports:
      - 2182:2181
    environment:
      ZOO_MY_ID: 2
      ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=zoo3:2888:3888;2181

  zoo3:
    image: zookeeper
    restart: always
    hostname: zoo3
    ports:
      - 2183:2181
    environment:
      ZOO_MY_ID: 3
      ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=zoo3:2888:3888;2181
```  

此配置启动 Zookeeper [复制模式]([])。执行 `docker compose up` 并等待初始化完成后，端口 `2181-2183` 将被暴露。  

> 注意：单台机器上运行多节点无法提供冗余能力（若机器故障，所有节点均不可用）。完整冗余需每个节点部署在独立物理服务器上，同一物理机的多个虚拟机仍存在单点故障风险。  
> 建议在复制模式下使用 [Docker Swarm]([]) 部署。  


### 配置  

Zookeeper 配置文件位于 `/conf`。修改配置的一种方式是将自定义配置文件挂载为卷：  

```console
$ docker run --name some-zookeeper --restart always -d -v $(pwd)/zoo.cfg:/conf/zoo.cfg zookeeper
```  


### 环境变量  

若未提供 `zoo.cfg`，将使用 Zookeeper 推荐默认配置，可通过以下环境变量覆盖：  

```console
$ docker run -e "ZOO_INIT_LIMIT=10" --name some-zookeeper --restart always -d zookeeper
```  

#### `ZOO_TICK_TIME`  
默认 `2000`。Zookeeper 的 `tickTime`（基本时间单位，毫秒），用于调节心跳和超时（如最小会话超时为 2 个 tick）。  

#### `ZOO_INIT_LIMIT`  
默认 `5`。Zookeeper 的 `initLimit`（ follower 连接并同步到 leader 的最大时间，单位为 tick）。若 Zookeeper 管理数据量大，可增大此值。  

#### `ZOO_SYNC_LIMIT`  
默认 `2`。Zookeeper 的 `syncLimit`（ follower 与 leader 同步的最大时间，单位为 tick）。若 follower 落后过多，将被剔除。  

#### `ZOO_MAX_CLIENT_CNXNS`  
默认 `60`。Zookeeper 的 `maxClientCnxns`（限制单个 IP 客户端到单个 Zookeeper 节点的并发连接数）。  

#### `ZOO_STANDALONE_ENABLED`  
默认 `true`。Zookeeper 的 [`standaloneEnabled`]([])（控制是否允许集群规模动态调整，默认值为 true 时，单节点集群无法扩容，多节点集群无法缩容至 1 个节点）。  

#### `ZOO_ADMINSERVER_ENABLED`  
默认 `true`。Zookeeper 的 [`admin.enableServer`]([])（是否启用嵌入式 Jetty AdminServer，默认端口 8080，提供 HTTP 接口执行四字命令）。  

#### `ZOO_AUTOPURGE_PURGEINTERVAL`  
默认 `0`。Zookeeper 的 [`autoPurge.purgeInterval`]([])（自动清理任务触发间隔，单位小时，设为正整数启用，默认禁用）。  

#### `ZOO_AUTOPURGE_SNAPRETAINCOUNT`  
默认 `3`。Zookeeper 的 [`autoPurge.snapRetainCount`]([])（启用自动清理时保留的最新快照和事务日志数量，默认 3，最小值 3）。  

#### `ZOO_4LW_COMMANDS_WHITELIST`  
默认 `srvr`。Zookeeper 的 [`4lw.commands.whitelist`]([])（允许使用的四字命令列表，逗号分隔，默认仅允许 `srvr` 命令，其他需显式添加）。  


### 高级配置  

#### `ZOO_CFG_EXTRA`  
上述环境变量仅覆盖部分常用配置，可通过 `ZOO_CFG_EXTRA` 添加任意配置参数。例如，启用 Prometheus 指标导出器（端口 7070）：  

```console
$ docker run --name some-zookeeper --restart always -e ZOO_CFG_EXTRA="metricsProvider.className=org.apache.zookeeper.metrics.prometheus.PrometheusMetricsProvider metricsProvider.httpPort=7070" zookeeper
```  

#### `JVMFLAGS`  
可通过 Java 系统属性（`-Dproperty=value`）设置高级配置。例如，使用 Netty 替代默认 NIO 作为服务器通信框架：  

```console
$ docker run --name some-zookeeper --restart always -e JVMFLAGS="-Dzookeeper.serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory" zookeeper
```  

更多支持的系统属性见 [高级配置]([])。  

另例：设置 JVM 最大堆内存为 1 GB：  

```console
$ docker run --name some-zookeeper --restart always -e JVMFLAGS="-Xmx1024m" zookeeper
```  


### 复制模式  

复制模式下需设置以下环境变量：  

#### `ZOO_MY_ID`  
节点 ID，集群内唯一，取值 1-255。若 `/data` 目录已存在 `myid` 文件，此变量无效。  

#### `ZOO_SERVERS`  
指定集群节点列表，格式：`server.id=<address1>:<port1>:<port2>[:role];[<client port address>:]<client port>`（详见 [Zookeeper 动态重配置]([])），多个节点用空格分隔。若 `/conf` 目录已存在 `zoo.cfg`，此变量无效。  


### 数据存储  

本镜像配置了 `/data`（内存数据库快照）和 `/datalog`（事务日志）卷。  

> 注意事务日志存储位置：专用事务日志设备是保证性能的关键，避免将日志放在繁忙设备上。  


### 日志配置  

默认情况下，ZooKeeper 将 stdout/stderr 输出重定向到控制台。3.8 及以上版本使用 [LOGBack]([]) 作为日志后端，默认 `logback.xml` 位于 `/conf`。通过挂载自定义配置覆盖默认日志设置：  

```console
$ docker run --name some-zookeeper --restart always -d -v $(pwd)/logback.xml:/conf/logback.xml zookeeper
```  

更多详情见 [ZooKeeper 日志]([])。  

#### 3.7 版本日志配置  
通过环境变量 `ZOO_LOG4J_PROP` 将日志输出到 `/logs` 目录文件：  

```console
$ docker run --name some-zookeeper --restart always -e ZOO_LOG4J_PROP="INFO,ROLLINGFILE" zookeeper
```  

日志将写入 `/logs/zookeeper.log`，镜像已配置 `/logs` 卷。  


## 许可协议  

查看本镜像包含软件的 [许可信息]([])。  

与所有 Docker 镜像一样，本镜像可能包含其他软件（如基础系统的 Bash 等），这些软件可能具有独立许可协议。  

自动检测到的额外许可信息可在 [repo-info 仓库的 `zookeeper/` 目录]([]) 中找到。  

使用预构建镜像时，用户需自行确保其使用行为符合所有包含软件的许可协议。
