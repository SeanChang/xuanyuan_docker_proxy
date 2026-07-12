---
image: emqx/nanomq
description: "NanoMQ是一款轻量级、高性能的MQTT broker，适用于IoT边缘平台，支持MQTT 5.0/3.1.1、桥接、消息持久化、规则引擎等功能，提供多版本Docker镜像满足不同需求。"
source: https://xuanyuan.cloud/zh/r/emqx/nanomq
canonical: https://xuanyuan.cloud/zh/r/emqx/nanomq
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/emqx/nanomq" title="emqx/nanomq Docker 镜像中文简介、标签列表与拉取命令">emqx/nanomq 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# NanoMQ

## 快速参考

官方网站：

https://nanomq.io/

获取帮助与提交问题：

https://github.com/emqx/nanomq/issues 或 https://slack-invite.emqx.io/ 或 https://discord.gg/xYGf3fQnES

支持的架构

POSIX兼容架构


## 什么是NanoMQ

Nano MQTT Broker（NanoMQ）是一款轻量级且高性能的[MQTT Broker](https://www.emqx.com/en/blog/the-ultimate-guide-to-mqtt-broker-comparison)，适用于IoT边缘平台。NanoMQ以高效方式统一边缘与云端之间的动态数据和在用数据。

其高性价比、高性能、高兼容性和互操作性使其成为边缘消息代理和数据总线的理想选择。

## 特性

- 完全兼容MQTT 5.0

  全面支持MQTT 5.0/3.1.1，兼容所有标准开源[MQTT SDK](https://www.emqx.com/en/mqtt-client-sdk)。

- MQTT桥接

  支持从边缘向多个云端桥接消息，可直接连接全球云服务。

- 消息持久化

  通过内置数据持久化功能保护业务关键数据，连接恢复后自动恢复上传。

- 规则引擎

  基于SQL的规则引擎释放数据灵活性，与eKuiper集成，为边缘带来流处理能力。

- 可集成性

  通过事件驱动的WebHook降低边缘计算应用集成成本，提供EdgeOps友好的HTTP API，易于维护。

- 全面多协议支持

  支持ZeroMQ/nanomsg/NNG/WebSocket等多种协议，实现边缘灵活多样的路由拓扑。通过TLS/SSL保障IoT连接安全。

## 如何使用此镜像

```bash
docker pull docker.xuanyuan.run/emqx/nanomq:latest
```

运行特定版本的NanoMQ：

```bash
docker run -d -p 1883:1883 -p 8883:8883 --name nanomq docker.xuanyuan.run/emqx/nanomq:latest
```

NanoMQ Docker镜像分为三种类型：

默认版：基于Alpine镜像，体积最小，仅包含基础MQTT broker功能。

```bash
docker pull docker.xuanyuan.run/emqx/nanomq:0.14.1
```

精简版（Slim）：基于Ubuntu镜像，体积适中，包含TLS/SSL、SQLite和规则引擎等必要功能。

```bash
docker pull docker.xuanyuan.run/emqx/nanomq:0.14.1-slim
```

完整版（Full）：包含所有功能的全面镜像，如QUIC桥接、ZeroMQ网关和基准测试工具。

```bash
docker pull docker.xuanyuan.run/emqx/nanomq:0.14.1-full
```

### NanoMQ配置文件

Docker版本：
  从主机指定配置文件路径：

  ```bash
docker run -d -p 1883:1883 -v {本地路径}:/etc \            --name nanomq  emqx/nanomq:0.14.1
  ```

推荐使用环境变量配置NanoMQ

#### NanoMQ环境变量

| 变量                          | 类型    | 值                                                          |
| ----------------------------- | ------- | ---------------------------------------------------------- |
| NANOMQ_BROKER_URL             | String  | 'nmq-tcp://主机:端口', 'tls+nmq-tcp://主机:端口'             |
| NANOMQ_DAEMON                 | Boolean | 设置nanomq为守护进程（默认：false）。                       |
| NANOMQ_NUM_TASKQ_THREAD       | Integer | 任务队列线程数，值需大于0且小于256。                        |
| NANOMQ_MAX_TASKQ_THREAD       | Integer | 最大任务队列线程数，值需大于0且小于256。                    |
| NANOMQ_PARALLEL               | Long    | 并行数。                                                    |
| NANOMQ_PROPERTY_SIZE          | Integer | MQTT用户属性的最大大小。                                    |
| NANOMQ_MSQ_LEN                | Integer | 重发消息的队列长度。                                        |
| NANOMQ_QOS_DURATION           | Integer | QoS定时器间隔。                                             |
| NANOMQ_ALLOW_ANONYMOUS        | Boolean | 允许匿名登录（默认：true）。                                |
| NANOMQ_WEBSOCKET_ENABLE       | Boolean | 启用WebSocket监听器（默认：true）。                         |
| NANOMQ_WEBSOCKET_URL          | String  | 'nmq-ws://主机:端口/路径', 'nmq-wss://主机:端口/路径'        |
| NANOMQ_HTTP_SERVER_ENABLE     | Boolean | 启用HTTP服务器（默认：false）。                             |
| NANOMQ_HTTP_SERVER_PORT       | Integer | HTTP服务器端口（默认：8081）。                              |
| NANOMQ_HTTP_SERVER_USERNAME   | String  | HTTP服务器认证用户名。                                      |
| NANOMQ_HTTP_SERVER_PASSWORD   | String  | HTTP服务器认证密码。                                        |
| NANOMQ_TLS_ENABLE             | Boolean | 启用TLS连接。                                              |
| NANOMQ_TLS_URL                | String  | 'tls+nmq-tcp://主机:端口'。                                 |
| NANOMQ_TLS_CA_CERT_PATH       | String  | 包含PEM编码CA证书的文件路径。                               |
| NANOMQ_TLS_CERT_PATH          | String  | 用户证书文件路径。                                          |
| NANOMQ_TLS_KEY_PATH           | String  | 包含用户私钥PEM编码的文件路径。                             |
| NANOMQ_TLS_KEY_PASSWORD       | String  | 用户私钥密码（仅在私钥文件受密码保护时使用）。               |
| NANOMQ_TLS_VERIFY_PEER        | Boolean | 验证对等证书（默认：false）。                               |
| NANOMQ_TLS_FAIL_IF_NO_PEER_CERT | Boolean | 客户端无证书时服务器失败（默认：false）。                     |
| NANOMQ_CONF_PATH              | String  | NanoMQ主配置文件路径（默认：/etc/nanomq.conf）。             |

- 指定代理URL。
  在主机系统：

  ```bash
  export NANOMQ_BROKER_URL="nmq-tcp://0.0.0.0:1883"
  export NANOMQ_TLS_ENABLE=true
  export NANOMQ_TLS_URL="tls+nmq-tcp://0.0.0.0:8883"
  ```

  创建Docker容器：

  ```bash
  docker run -d -p 1883:1883 -p 8883:8883 \
             -e NANOMQ_BROKER_URL="nmq-tcp://0.0.0.0:1883" \
             -e NANOMQ_TLS_ENABLE=true \
             -e NANOMQ_TLS_URL="tls+nmq-tcp://0.0.0.0:8883" \
             --name nanomq docker.xuanyuan.run/emqx/nanomq:0.14.1-full
  ```

- 指定NanoMQ配置文件路径。
  在主机系统：

  ```bash
  export NANOMQ_CONF_PATH="/usr/local/etc/nanomq.conf"
  ```

  创建Docker容器：

  ```bash
  docker run -d -p 1883:1883 -e NANOMQ_CONF_PATH="/usr/local/etc/nanomq.conf" \
              [-v {本地路径}:{容器路径}] \
              --name nanomq emqx/nanomq:0.14.0-slim
  ```

### 性能调优

为在您的平台上获得最佳性能，建议修改以下设置：

| 名称                     | 类型    | 描述                                                          |
| ------------------------ | ------- | ------------------------------------------------------------- |
| system.num_taskq_thread  | Integer | 任务队列线程数。（等于CPU核心数）                              |
| system.max_taskq_thread  | Integer | 最大任务队列线程数。（等于CPU核心数）                          |
| system.parallel          | Long    | 并行数。（等于CPU核心数 * 2）                                 |
| mqtt.session.msq_len     | Integer | 重发消息的飞行窗口/队列长度。（建议设为最大值65535，视内存情况调整） |
