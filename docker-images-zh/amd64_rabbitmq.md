---
image: amd64/rabbitmq
description: "RabbitMQ是开源的多协议消息代理。"
source: https://xuanyuan.cloud/zh/r/amd64/rabbitmq
canonical: https://xuanyuan.cloud/zh/r/amd64/rabbitmq
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amd64/rabbitmq" title="amd64/rabbitmq Docker 镜像中文简介、标签列表与拉取命令">amd64/rabbitmq 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# RabbitMQ Docker 镜像文档

## 概述

### 镜像概述与主要用途
RabbitMQ 是一款开源的多协议消息代理软件（有时称为面向消息的中间件），实现了高级消息队列协议（AMQP）。其服务器端基于 Erlang 编程语言开发，并构建于 Open Telecom Platform 框架之上，支持集群和故障转移。客户端库支持所有主流编程语言，可用于在分布式系统中实现可靠的异步通信。

### 核心功能与特性
- **多协议支持**：原生支持 AMQP，同时可通过插件支持 MQTT、STOMP 等协议
- **可靠消息传递**：提供持久化、确认机制、事务等特性，确保消息可靠投递
- **灵活路由**：支持直接路由、主题路由、扇形交换等多种消息路由模式
- **集群与高可用**：基于 Erlang/OTP 框架，支持节点集群、镜像队列和故障自动转移
- **管理与监控**：通过管理插件提供 Web 界面，支持队列监控、用户管理、策略配置等功能
- **可扩展性**：支持自定义插件扩展功能，如联邦队列、 shovel 跨集群同步等

### 使用场景与适用范围
- **应用解耦**：分离系统组件，减少模块间直接依赖，提高系统弹性
- **异步任务处理**：处理耗时操作（如日志处理、数据转换），避免阻塞主流程
- **分布式系统通信**：作为微服务架构中的消息枢纽，实现服务间松耦合通信
- **流量削峰**：缓冲突发流量，保护下游服务不被过载（如秒杀场景）
- **实时数据流**：处理实时生成的消息流（如监控数据、用户行为跟踪）

## 快速参考

### 维护者
[Docker 社区](https://github.com/docker-library/rabbitmq)

### 支持渠道
[Docker 社区 Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)

### 问题反馈
[GitHub Issues](https://github.com/docker-library/rabbitmq/issues?q=)

### 支持的架构
([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
[`amd64`](https://hub.docker.com/r/amd64/rabbitmq/)、[`arm32v6`](https://hub.docker.com/r/arm32v6/rabbitmq/)、[`arm32v7`](https://hub.docker.com/r/arm32v7/rabbitmq/)、[`arm64v8`](https://hub.docker.com/r/arm64v8/rabbitmq/)、[`i386`](https://hub.docker.com/r/i386/rabbitmq/)、[`ppc64le`](https://hub.docker.com/r/ppc64le/rabbitmq/)、[`riscv64`](https://hub.docker.com/r/riscv64/rabbitmq/)、[`s390x`](https://hub.docker.com/r/s390x/rabbitmq/)

### 镜像元数据
[repo-info 仓库的 `repos/rabbitmq/` 目录](https://github.com/docker-library/repo-info/blob/master/repos/rabbitmq)（包含镜像元数据、传输大小等信息）

### 镜像更新
[official-images 仓库的 `library/rabbitmq` 标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Frabbitmq)  
[official-images 仓库的 `library/rabbitmq` 文件](https://github.com/docker-library/official-images/blob/master/library/rabbitmq)（更新历史）

## 支持的标签及对应 Dockerfile 链接

| 标签 | Dockerfile 链接 |
|------|----------------|
| `4.2.0-rc.1`, `4.2-rc` | [链接](https://github.com/docker-library/rabbitmq/blob/421249429d60a199a8e63eae8914bf19f7aba49b/4.2-rc/ubuntu/Dockerfile) |
| `4.2.0-rc.1-management`, `4.2-rc-management` | [链接](https://github.com/docker-library/rabbitmq/blob/aaf82bfff4fd5ee6c98ec4ce7815e7e580066892/4.2-rc/ubuntu/management/Dockerfile) |
| `4.2.0-rc.1-alpine`, `4.2-rc-alpine` | [链接](https://github.com/docker-library/rabbitmq/blob/421249429d60a199a8e63eae8914bf19f7aba49b/4.2-rc/alpine/Dockerfile) |
| `4.2.0-rc.1-management-alpine`, `4.2-rc-management-alpine` | [链接](https://github.com/docker-library/rabbitmq/blob/aaf82bfff4fd5ee6c98ec4ce7815e7e580066892/4.2-rc/alpine/management/Dockerfile) |
| `4.1.4`, `4.1`, `4`, `latest` | [链接](https://github.com/docker-library/rabbitmq/blob/afa514ae410f3f21127291c2a827c7ed8deda515/4.1/ubuntu/Dockerfile) |
| `4.1.4-management`, `4.1-management`, `4-management`, `management` | [链接](https://github.com/docker-library/rabbitmq/blob/01055a3ed6f0a7a40d4ff1d17d3f0758039e431f/4.1/ubuntu/management/Dockerfile) |
| `4.1.4-alpine`, `4.1-alpine`, `4-alpine`, `alpine` | [链接](https://github.com/docker-library/rabbitmq/blob/afa514ae410f3f21127291c2a827c7ed8deda515/4.1/alpine/Dockerfile) |
| `4.1.4-management-alpine`, `4.1-management-alpine`, `4-management-alpine`, `management-alpine` | [链接](https://github.com/docker-library/rabbitmq/blob/01055a3ed6f0a7a40d4ff1d17d3f0758039e431f/4.1/alpine/management/Dockerfile) |
| `4.0.9`, `4.0` | [链接](https://github.com/docker-library/rabbitmq/blob/472c590ec4dddf4494c8ed6576d6d78588e3cd35/4.0/ubuntu/Dockerfile) |
| `4.0.9-management`, `4.0-management` | [链接](https://github.com/docker-library/rabbitmq/blob/36e4d246e934a96b1c3a920e398f96434f3fc34c/4.0/ubuntu/management/Dockerfile) |
| `4.0.9-alpine`, `4.0-alpine` | [链接](https://github.com/docker-library/rabbitmq/blob/472c590ec4dddf4494c8ed6576d6d78588e3cd35/4.0/alpine/Dockerfile) |
| `4.0.9-management-alpine`, `4.0-management-alpine` | [链接](https://github.com/docker-library/rabbitmq/blob/36e4d246e934a96b1c3a920e398f96434f3fc34c/4.0/alpine/management/Dockerfile) |
| `3.13.7`, `3.13`, `3` | [链接](https://github.com/docker-library/rabbitmq/blob/f60bd8e290f826c6021cbd66e89de6a7ba3a9174/3.13/ubuntu/Dockerfile) |
| `3.13.7-management`, `3.13-management`, `3-management` | [链接](https://github.com/docker-library/rabbitmq/blob/36e4d246e934a96b1c3a920e398f96434f3fc34c/3.13/ubuntu/management/Dockerfile) |
| `3.13.7-alpine`, `3.13-alpine`, `3-alpine` | [链接](https://github.com/docker-library/rabbitmq/blob/f60bd8e290f826c6021cbd66e89de6a7ba3a9174/3.13/alpine/Dockerfile) |
| `3.13.7-management-alpine`, `3.13-management-alpine`, `3-management-alpine` | [链接](https://github.com/docker-library/rabbitmq/blob/36e4d246e934a96b1c3a920e398f96434f3fc34c/3.13/alpine/management/Dockerfile) |


## 如何使用本镜像

### 运行 RabbitMQ 守护进程
RabbitMQ 的数据存储依赖于 "节点名称"（默认与主机名关联）。在 Docker 中使用时，建议显式指定 `--hostname` 以确保数据存储路径稳定：

```bash
docker run -d --hostname my-rabbit --name some-rabbit docker.xuanyuan.run/amd64/rabbitmq:3
```

容器启动后，默认监听 5672 端口（AMQP 协议端口）。通过 `docker logs some-rabbit` 可查看日志，其中包含节点名称、数据目录等关键信息：
```
=INFO REPORT==== 6-Jul-2015::20:47:02 ===
node           : rabbit@my-rabbit
home dir       : /var/lib/rabbitmq
config file(s) : /etc/rabbitmq/rabbitmq.config
cookie hash    : UoNOcDhfxW9uoZ92wh6BjA==
log            : tty
sasl log       : tty
database dir   : /var/lib/rabbitmq/mnesia/rabbit@my-rabbit
```

> 注：镜像默认将 `/var/lib/rabbitmq` 设为数据卷，确保数据持久化。

### 环境变量
RabbitMQ 本身支持的环境变量列表可参考 [官方文档的环境变量部分](https://www.rabbitmq.com/configure.html#supported-environment-variables)。

#### 已弃用变量（RabbitMQ 3.9+）
自 RabbitMQ 3.9 起，以下 Docker 专用变量已弃用，不再生效。建议使用配置文件进行自定义（详见 [RabbitMQ 配置文档](https://www.rabbitmq.com/configure.html)）：
```bash
RABBITMQ_DEFAULT_PASS_FILE
RABBITMQ_DEFAULT_USER_FILE
RABBITMQ_MANAGEMENT_SSL_CACERTFILE
RABBITMQ_MANAGEMENT_SSL_CERTFILE
RABBITMQ_MANAGEMENT_SSL_DEPTH
RABBITMQ_MANAGEMENT_SSL_FAIL_IF_NO_PEER_CERT
RABBITMQ_MANAGEMENT_SSL_KEYFILE
RABBITMQ_MANAGEMENT_SSL_VERIFY
RABBITMQ_SSL_CACERTFILE
RABBITMQ_SSL_CERTFILE
RABBITMQ_SSL_DEPTH
RABBITMQ_SSL_FAIL_IF_NO_PEER_CERT
RABBITMQ_SSL_KEYFILE
RABBITMQ_SSL_VERIFY
RABBITMQ_VM_MEMORY_HIGH_WATERMARK
```

#### 常用环境变量
- `RABBITMQ_DEFAULT_USER`：默认管理员用户名（替代原 `guest`）
- `RABBITMQ_DEFAULT_PASS`：默认管理员密码（替代原 `guest`）
- `RABBITMQ_DEFAULT_VHOST`：默认虚拟主机（默认为 `/`）
- `RABBITMQ_SERVER_ADDITIONAL_ERL_ARGS`：额外 Erlang 参数（用于补充配置，如 `-rabbit channel_max 4007`）


### 设置默认用户和密码
通过环境变量 `RABBITMQ_DEFAULT_USER` 和 `RABBITMQ_DEFAULT_PASS` 自定义管理员账号（需使用带管理插件的镜像）：

```bash
docker run -d \
  --hostname my-rabbit \
  --name some-rabbit \
  -e RABBITMQ_DEFAULT_USER=admin \
  -e RABBITMQ_DEFAULT_PASS=secret \
  docker.xuanyuan.run/amd64/rabbitmq:3-management
```

启动后，通过 `http://localhost:15672` 或 `http://主机IP:15672` 访问管理界面，使用 `admin/secret` 登录。


### 设置默认虚拟主机
通过 `RABBITMQ_DEFAULT_VHOST` 指定默认虚拟主机：

```bash
docker run -d \
  --hostname my-rabbit \
  --name some-rabbit \
  -e RABBITMQ_DEFAULT_VHOST=my_vhost \
  docker.xuanyuan.run/amd64/rabbitmq:3-management
```


### 内存限制配置
RabbitMQ 需感知容器的内存限制（如 `docker run --memory=2g`），以避免因内存不足被系统 OOM 终止。通过配置文件设置 `vm_memory_high_watermark` 参数（详见 [内存告警文档](https://www.rabbitmq.com/memory.html)）：

```ini
# rabbitmq.conf 示例
vm_memory_high_watermark.relative = 0.7  # 允许使用容器内存的 70%
```


### Erlang Cookie 配置
Erlang Cookie 用于节点间认证（集群或 `rabbitmqctl` 远程管理时必需）。默认存储路径为 `/var/lib/rabbitmq/.erlang.cookie`，可通过以下方式自定义：

- **Docker Secrets（Swarm 模式）**：
  ```bash
  docker service create \
    --name rabbitmq \
    --secret source=erlang-cookie,target=/var/lib/rabbitmq/.erlang.cookie,uid=999,gid=999,mode=0600 \
    amd64/rabbitmq:3
  ```

- **本地文件挂载**：
  ```bash
  docker run -d \
    --hostname my-rabbit \
    --name some-rabbit \
    -v /local/path/to/.erlang.cookie:/var/lib/rabbitmq/.erlang.cookie:ro \
    docker.xuanyuan.run/amd64/rabbitmq:3
  ```

> 注：Cookie 文件需设置权限 `0600`，且属主为容器内的 `rabbitmq` 用户（UID/GID 通常为 999）。


### 启用管理插件
带 `-management` 后缀的标签已预装管理插件，默认监听 15672 端口。如需外部访问，可映射端口：

```bash
docker run -d \
  --hostname my-rabbit \
  --name some-rabbit \
  -p 5672:5672  # AMQP 端口
  -p 15672:15672  # 管理界面端口
  amd64/rabbitmq:3-management
```


### 启用额外插件
#### 方法 1：通过 Dockerfile 构建
```dockerfile
FROM docker.xuanyuan.run/amd64/rabbitmq:3.8-management
RUN rabbitmq-plugins enable --offline rabbitmq_mqtt rabbitmq_federation_management rabbitmq_stomp
```

#### 方法 2：挂载插件配置文件
创建 `enabled_plugins` 文件（Erlang 列表格式）：
```erlang
[rabbitmq_federation_management, rabbitmq_management, rabbitmq_mqtt, rabbitmq_stomp].
```

通过挂载文件启用插件：
```bash
docker run -d \
  --hostname my-rabbit \
  --name some-rabbit \
  -v /local/path/to/enabled_plugins:/etc/rabbitmq/enabled_plugins \
  docker.xuanyuan.run/amd64/rabbitmq:3
```


### 高级配置
推荐通过配置文件 `/etc/rabbitmq/rabbitmq.conf` 进行自定义（详见 [RabbitMQ 配置文件文档](https://www.rabbitmq.com/configure.html#configuration-files)）。支持以下挂载方式：

- **本地文件挂载**：
  ```bash
  docker run -d \
    --hostname my-rabbit \
    --name some-rabbit \
    -v /local/path/to/rabbitmq.conf:/etc/rabbitmq/rabbitmq.conf:ro \
    docker.xuanyuan.run/amd64/rabbitmq:3
  ```

- **Docker Configs（Swarm 模式）**：
  ```bash
  docker config create rabbitmq-config /local/path/to/rabbitmq.conf
  docker service create \
    --name rabbitmq \
    --config source=rabbitmq-config,target=/etc/rabbitmq/rabbitmq.conf \
    amd64/rabbitmq:3
  ```


### 健康检查配置
本镜像未预设健康检查。根据 [官方建议](https://github.com/docker-library/
