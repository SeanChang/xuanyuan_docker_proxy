---
image: islandora/activemq
description: "消息代理镜像，用于在分布式系统中传递、路由、存储和转发消息，实现应用间异步通信与解耦。"
source: https://xuanyuan.cloud/zh/r/islandora/activemq
canonical: https://xuanyuan.cloud/zh/r/islandora/activemq
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/islandora/activemq" title="islandora/activemq Docker 镜像中文简介、标签列表与拉取命令">islandora/activemq — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/islandora/activemq" title="islandora/activemq Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/islandora/activemq</a>

# ActiveMQ Docker镜像文档


## 1. 镜像概述与主要用途

本镜像为[ActiveMQ](http://activemq.apache.org/) 5.19.0版本的Docker化部署包，基于[Islandora-DevOps/isle-buildkit activemq](https://github.com/Islandora-DevOps/isle-buildkit/tree/main/activemq)项目构建。ActiveMQ是一款开源的企业级消息代理（Message Broker），支持多种消息协议，提供可靠的异步消息传递能力，适用于分布式系统间的通信解耦。


## 2. 核心功能与特性

- **多协议支持**：兼容MQTT、AMQP、STOMP、OpenWire、WS等多种消息协议，满足不同应用场景需求。
- **Web控制台**：内置Web管理界面（WebConsole），支持消息队列监控、配置管理等操作。
- **安全认证**：可通过环境变量配置用户、密码及角色，支持多用户及分组管理。
- **日志管理**：支持常规日志与审计日志分级配置，可通过环境变量调整日志级别。
- **消息持久化**：消息存储目录支持卷挂载，确保消息数据持久化。


## 3. 使用场景与适用范围

- **企业应用集成**：作为中间件实现不同系统间的异步消息通信，降低系统耦合度。
- **分布式系统通信**：在微服务架构中提供跨服务的可靠消息传递，支持服务解耦与流量削峰。
- **IoT设备数据传输**：通过MQTT协议接入物联网设备，处理海量设备消息。
- **跨平台消息交互**：支持多协议特性，适配Java、Python、Node.js等多语言客户端。


## 4. 使用方法

### 4.1 快速启动

通过以下命令可快速启动ActiveMQ实例，默认启用Web控制台（`http://localhost:8161`），默认登录凭据为`admin/password`：

```bash
docker run --rm -ti -p 8161:8161 islandora/activemq
```

> **注意**：若未配置凭据（环境变量），将无法登录Web控制台。


### 4.2 完整部署示例

#### 4.2.1 Docker Run参数说明

```bash
docker run -d \
  --name activemq \
  -p 1883:1883 \    # MQTT协议端口
  -p 5672:5672 \    # AMQP协议端口
  -p 8161:8161 \    # Web控制台端口
  -p 61613:61613 \  # STOMP协议端口
  -p 61614:61614 \  # WS协议端口
  -p 61616:61616 \  # OpenWire协议端口
  -v activemq-data:/opt/activemq/data \  # 挂载消息存储卷
  -e ACTIVEMQ_USER=admin \               # 消息服务用户名
  -e ACTIVEMQ_PASSWORD=Secure@123 \      # 消息服务密码
  -e ACTIVEMQ_LOG_LEVEL=DEBUG \          # 日志级别设为DEBUG
  islandora/activemq
```


#### 4.2.2 Docker Compose配置示例

```yaml
version: '3.8'
services:
  activemq:
    image: islandora/activemq
    container_name: activemq
    restart: always
    ports:
      - "8161:8161"   # Web控制台
      - "61616:61616" # OpenWire主力协议
      - "1883:1883"   # MQTT物联网协议
      - "5672:5672"   # AMQP协议
    volumes:
      - activemq-data:/opt/activemq/data  # 持久化消息存储
    environment:
      - ACTIVEMQ_USER=admin
      - ACTIVEMQ_PASSWORD=Secure@123
      - ACTIVEMQ_WEB_ADMIN_PASSWORD=Secure@123  # Web控制台密码
      - ACTIVEMQ_LOG_LEVEL=INFO                 # 常规日志级别
      - ACTIVEMQ_AUDIT_LOG_LEVEL=WARN           # 审计日志级别
volumes:
  activemq-data:  # 定义命名卷，确保数据持久化
```


## 5. 配置说明

### 5.1 端口映射

| 端口   | 描述                | 协议/服务                     |
|--------|---------------------|------------------------------|
| 1883   | MQTT协议端口        | [MQTT](https://activemq.apache.org/mqtt) |
| 5672   | AMQP协议端口        | [AMQP](https://activemq.apache.org/amqp) |
| 8161   | Web控制台端口       | [WebConsole](https://activemq.apache.org/web-console) |
| 61613  | STOMP协议端口       | [STOMP](https://activemq.apache.org/stomp) |
| 61614  | WebSocket端口       | [WS](https://activemq.apache.org/ws-notification) |
| 61616  | OpenWire协议端口    | [OpenWire](https://activemq.apache.org/openwire) |


### 5.2 卷挂载

| 路径                  | 描述                | 用途                     |
|-----------------------|---------------------|--------------------------|
| `/opt/activemq/data`  | 消息存储目录        | [AMQ Message Store](https://activemq.apache.org/amq-message-store)，用于持久化消息数据 |


### 5.3 环境变量配置

#### 5.3.1 基础环境变量（默认配置）

| 环境变量                  | 默认值       | 描述                                                                 |
|---------------------------|--------------|----------------------------------------------------------------------|
| `ACTIVEMQ_AUDIT_LOG_LEVEL` | `INFO`       | 审计日志级别，可选值：OFF、FATAL、ERROR、WARN、INFO、DEBUG、TRACE、ALL |
| `ACTIVEMQ_LOG_LEVEL`       | `INFO`       | 常规日志级别，可选值同上                                             |
| `ACTIVEMQ_PASSWORD`        | `password`   | 消息服务默认用户密码（对应`credentials.properties`）                 |
| `ACTIVEMQ_USER`            | `admin`      | 消息服务默认用户名（对应`credentials.properties`）                   |
| `ACTIVEMQ_WEB_ADMIN_NAME`  | `admin`      | Web控制台管理员用户名（对应`jetty-realm.properties`）                |
| `ACTIVEMQ_WEB_ADMIN_PASSWORD` | `password` | Web控制台管理员密码（对应`jetty-realm.properties`）                  |
| `ACTIVEMQ_WEB_ADMIN_ROLES` | `admin`      | Web控制台管理员角色（对应`jetty-realm.properties`）                  |


#### 5.3.2 额外用户与组配置

可通过环境变量扩展用户、组及Web控制台用户，遵循以下命名规则：

| 环境变量格式                  | 描述                                      | 对应配置文件                     |
|-------------------------------|-------------------------------------------|----------------------------------|
| `ACTIVEMQ_USER_{USER}_NAME`   | 消息服务用户名称（`{USER}`为自定义标识）  | `users.properties`               |
| `ACTIVEMQ_USER_{USER}_PASSWORD` | 消息服务用户密码                         | `users.properties`               |
| `ACTIVEMQ_GROUP_{GROUP}_NAME` | 用户组名称（`{GROUP}`为自定义标识）       | `groups.properties`              |
| `ACTIVEMQ_GROUP_{GROUP}_MEMBERS` | 用户组成员（逗号分隔用户名）             | `groups.properties`              |
| `ACTIVEMQ_WEB_USER_{USER}_NAME` | Web控制台用户名称                        | `jetty-realm.properties`         |
| `ACTIVEMQ_WEB_USER_{USER}_PASSWORD` | Web控制台用户密码                       | `jetty-realm.properties`         |
| `ACTIVEMQ_WEB_USER_{USER}_ROLES` | Web控制台用户角色（逗号分隔）            | `jetty-realm.properties`         |

**示例**：添加Web控制台用户`operator`（角色`viewer`）：

```bash
-e ACTIVEMQ_WEB_USER_OPERATOR_NAME=operator \
-e ACTIVEMQ_WEB_USER_OPERATOR_PASSWORD=operator123 \
-e ACTIVEMQ_WEB_USER_OPERATOR_ROLES=viewer
```


## 6. 日志管理

### 6.1 日志类型

- **常规日志**：记录服务运行状态、连接信息等，通过`ACTIVEMQ_LOG_LEVEL`控制级别。
- **审计日志**：记录用户操作、权限变更等安全相关事件，通过`ACTIVEMQ_AUDIT_LOG_LEVEL`控制级别。


### 6.2 日志级别配置

日志级别按优先级从高到低为：`OFF` > `FATAL` > `ERROR` > `WARN` > `INFO` > `DEBUG` > `TRACE` > `ALL`。默认级别为`INFO`，可通过环境变量调整（如设为`DEBUG`用于问题排查）。


## 参考链接

- [ActiveMQ官方文档](https://activemq.apache.org/components/classic/documentation)
- [ActiveMQ安全配置](https://activemq.apache.org/security)
- [Web控制台使用指南](https://activemq.apache.org/web-console)
- [消息存储机制](https://activemq.apache.org/amq-message-store)
