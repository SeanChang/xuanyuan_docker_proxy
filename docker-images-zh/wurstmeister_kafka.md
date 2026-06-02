<!-- xuanyuan-docker-images-zh
image: wurstmeister/kafka
source: https://xuanyuan.cloud/zh/r/wurstmeister/kafka
canonical: https://xuanyuan.cloud/zh/r/wurstmeister/kafka
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/wurstmeister/kafka" title="wurstmeister/kafka Docker 镜像中文简介、标签列表与拉取命令">wurstmeister/kafka — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/wurstmeister/kafka" title="wurstmeister/kafka Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/wurstmeister/kafka</a></p>

# wurstmeister/kafka 镜像文档


## 镜像概述和主要用途

`wurstmeister/kafka` 是一个基于 Apache Kafka 的 Docker 镜像，提供了 Docker 化的 Kafka 部署方案。该镜像支持多 Broker 集群部署，可灵活配置 Broker 参数、网络监听规则和主题管理，适用于开发、测试及生产环境中快速搭建和扩展 Kafka 集群。镜像已发布至 [Docker Hub](https://hub.docker.com/r/wurstmeister/kafka/)，支持自动创建主题、动态扩展 Broker 节点及集成 ZooKeeper 等核心功能。


## 核心功能和特性

- **多 Broker 集群支持**：通过 `docker-compose scale` 快速扩展集群节点数量。
- **灵活的 Broker ID 配置**：支持手动指定或通过命令自动生成 Broker ID，适配动态扩缩容场景。
- **自动主题创建**：可通过环境变量预定义主题，指定分区数、副本数及清理策略。
- **多网络监听器配置**：支持内外网流量隔离，适配不同协议（如 PLAINTEXT、SSL）的监听需求。
- **动态广告地址/端口**：通过命令动态获取主机名或端口，解决容器网络环境下的地址暴露问题。
- **Broker Rack 亲和性**：支持通过环境变量或命令配置 Broker 机架信息，优化数据副本分布。
- **JMX 监控集成**：可配置 JMX 参数，支持外部监控工具接入。
- **自定义 Kafka 参数**：通过环境变量直接覆盖 Kafka 配置（如 `KAFKA_MESSAGE_MAX_BYTES`）。
- **log4j 配置定制**：通过 `LOG4J_` 前缀环境变量自定义日志配置。
- **Docker Swarm 适配**：支持 Swarm 模式下的全局部署和主机网络绑定，确保外部连接稳定性。


## 使用场景和适用范围

- **开发/测试环境**：快速搭建单节点或多节点 Kafka 集群，无需手动配置复杂依赖。
- **动态扩缩容场景**：需要根据负载动态调整 Broker 数量的生产环境。
- **网络隔离需求**：需区分内外网访问（如内部 Broker 通信与外部客户端接入）的场景。
- **自动化主题管理**：通过环境变量预定义主题，避免手动执行 `kafka-topics.sh` 命令。
- **容器编排集成**：适配 Docker Compose、Docker Swarm 等容器编排工具，简化集群部署流程。


## 详细的使用方法和配置说明


### 前置条件

1. **安装 Docker Compose**：参考 [官方文档](https://docs.docker.com/compose/install/) 安装。
2. **配置网络参数**：
   - 修改 `docker-compose.yml` 中的 `KAFKA_ADVERTISED_HOST_NAME` 为 Docker 主机 IP（**不可使用 localhost/127.0.0.1**，否则多 Broker 集群无法通信）。
   - 如需自定义 Kafka 参数（如消息最大字节数），直接添加环境变量（例如 `KAFKA_MESSAGE_MAX_BYTES: 2000000`）。
3. **网络连接注意事项**：容器网络配置可能存在端口映射、跨主机通信等问题，详细参考 [Connectivity Guide](https://github.com/wurstmeister/kafka-docker/wiki/Connectivity)。


### 基本使用方法

#### 启动集群

使用默认配置启动单节点集群（含 ZooKeeper）：

```bash
# 下载官方 docker-compose.yml
curl -O https://raw.githubusercontent.com/wurstmeister/kafka-docker/master/docker-compose.yml

# 修改 KAFKA_ADVERTISED_HOST_NAME 为 Docker 主机 IP
# 启动集群（后台运行）
docker-compose up -d
```

#### 扩展 Broker 节点

```bash
# 扩展至 3 个 Broker 节点
docker-compose scale kafka=3
```

#### 停止集群

```bash
# 停止并保留容器（数据持久化）
docker-compose stop

# 停止并删除容器（数据不保留）
docker-compose down
```


### 关键配置说明

#### 1. Broker ID 配置

Broker ID 用于标识集群中的节点，支持两种配置方式：

- **手动指定**：通过 `KAFKA_BROKER_ID` 环境变量直接设置（适用于固定节点数量场景）。
  
  ```yaml
  environment:
    KAFKA_BROKER_ID: 1  # 固定 Broker ID 为 1
  ```

- **自动生成**：通过 `BROKER_ID_COMMAND` 执行命令生成（适用于动态扩缩容场景）。
  
  ```yaml
  environment:
    BROKER_ID_COMMAND: "hostname | awk -F'-' '{print $2}'"  # 从容器 hostname 提取 ID
  ```

> **注意**：自动生成 ID 时，建议使用 `docker-compose up --no-recreate` 避免容器重建导致 ID 变化。


#### 2. 自动创建主题

通过 `KAFKA_CREATE_TOPICS` 环境变量预定义主题，格式为：  
`"主题名:分区数:副本数[:清理策略]"`，多主题用逗号分隔（可通过 `KAFKA_CREATE_TOPICS_SEPARATOR` 自定义分隔符）。

**示例**：
```yaml
environment:
  KAFKA_CREATE_TOPICS: "Topic1:3:2,Topic2:1:1:compact"  # Topic1:3分区2副本；Topic2:1分区1副本，清理策略为 compact
  KAFKA_CREATE_TOPICS_SEPARATOR: "$$'\n'"  # 可选，使用换行符分隔主题（需符合 Docker Compose 转义规则）
```


#### 3. 广告主机名/端口配置

容器环境中需将 Broker 地址暴露给外部客户端，支持动态获取主机名或端口：

- **广告主机名（Advertised Hostname）**：
  - 手动指定：`KAFKA_ADVERTISED_HOST_NAME: 192.168.1.100`
  - 自动获取：通过 `HOSTNAME_COMMAND` 执行命令（如 AWS 元数据服务）：
    
    ```yaml
    environment:
      HOSTNAME_COMMAND: "wget -t3 -T2 -qO- http://169.254.169.254/latest/meta-data/local-ipv4"  # 获取 AWS 实例私有 IP
    ```

- **广告端口（Advertised Port）**：
  - 动态获取：通过 `PORT_COMMAND` 提取容器映射端口：
    
    ```yaml
    environment:
      PORT_COMMAND: "docker port $$(hostname) 9092/tcp | cut -d: -f2"  # 获取 9092 端口的宿主机映射端口
      KAFKA_ADVERTISED_LISTENERS: "PLAINTEXT://192.168.1.100:_{PORT_COMMAND}"  # 引用 PORT_COMMAND 结果
    ```


#### 4. 监听器配置

Kafka 0.9+ 支持多监听器配置，用于区分内外网流量或不同协议（如 PLAINTEXT/SSL）。需配置以下参数：

| 参数                          | 说明                                  | 示例                                  |
|-------------------------------|---------------------------------------|---------------------------------------|
| `KAFKA_LISTENERS`             | 监听地址列表（格式：协议://地址:端口） | `INSIDE://:9092,OUTSIDE://:9094`      |
| `KAFKA_ADVERTISED_LISTENERS`  | 客户端可见的监听地址列表              | `INSIDE://:9092,OUTSIDE://{IP}:9094`  |
| `KAFKA_LISTENER_SECURITY_PROTOCOL_MAP` | 协议与安全策略映射 | `INSIDE:PLAINTEXT,OUTSIDE:SSL`       |
| `KAFKA_INTER_BROKER_LISTENER_NAME` | Broker 间通信使用的协议名 | `INSIDE`                              |

**示例配置（AWS 环境）**：
```yaml
environment:
  HOSTNAME_COMMAND: "curl http://169.254.169.254/latest/meta-data/public-hostname"  # 获取公网主机名
  KAFKA_LISTENERS: "INSIDE://:9092,OUTSIDE://:9094"
  KAFKA_ADVERTISED_LISTENERS: "INSIDE://:9092,OUTSIDE://_{HOSTNAME_COMMAND}:9094"  # 引用 HOSTNAME_COMMAND 结果
  KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: "INSIDE:PLAINTEXT,OUTSIDE:PLAINTEXT"
  KAFKA_INTER_BROKER_LISTENER_NAME: "INSIDE"  # Broker 间通过 INSIDE 协议通信
```

**规则**：
- 监听器端口不可重复。
- `advertised.listeners` 中的协议和端口必须在 `listeners` 中存在。


#### 5. Broker Rack 配置

配置 Broker 机架信息（如 AWS 可用区），优化副本分布：

- **手动指定**：`KAFKA_BROKER_RACK: "us-west-2a"`
- **自动获取**：通过 `RACK_COMMAND` 执行命令（如 AWS 元数据服务）：
  
  ```yaml
  environment:
    RACK_COMMAND: "curl http://169.254.169.254/latest/meta-data/placement/availability-zone"  # 获取可用区
  ```


#### 6. JMX 监控配置

通过 `KAFKA_JMX_OPTS` 和 `JMX_PORT` 启用 JMX 监控：

```yaml
environment:
  KAFKA_JMX_OPTS: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=127.0.0.1 -Dcom.sun.management.jmxremote.rmi.port=1099"
  JMX_PORT: 1099  # JMX 监听端口
ports:
  - "1099:1099"  # 映射 JMX 端口到宿主机
```

**连接示例**：`jconsole 127.0.0.1:1099`


### Docker Compose 部署示例

#### 单节点 Kafka 集群（含 ZooKeeper）

创建 `docker-compose-single-broker.yml`：

```yaml
version: '2'
services:
  zookeeper:
    image: wurstmeister/zookeeper
    ports:
      - "2181:2181"
  kafka:
    image: wurstmeister/kafka
    ports:
      - "9092:9092"
    environment:
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181  # 必填：ZooKeeper 连接地址
      KAFKA_ADVERTISED_HOST_NAME: 192.168.1.100  # 替换为 Docker 主机 IP
      KAFKA_BROKER_ID: 0  # 固定 Broker ID
      KAFKA_CREATE_TOPICS: "test-topic:3:1"  # 创建 test-topic（3分区1副本）
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock  # 用于动态获取容器信息
```

启动集群：
```bash
docker-compose -f docker-compose-single-broker.yml up -d
```


#### 多节点 Kafka 集群（动态扩缩容）

创建 `docker-compose.yml`：

```yaml
version: '2'
services:
  zookeeper:
    image: wurstmeister/zookeeper
    ports:
      - "2181:2181"
  kafka:
    image: wurstmeister/kafka
    ports:
      - "9092"  # 动态分配宿主机端口
    environment:
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_HOST_NAME: 192.168.1.100
      BROKER_ID_COMMAND: "hostname | awk -F'-' '{print $2}'"  # 自动生成 Broker ID
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

启动 3 节点集群：
```bash
docker-compose up -d
docker-compose scale kafka=3  # 扩展至 3 个 Broker
```


## 环境变量参考

| 环境变量                          | 必填 | 说明                                                                 | 示例值                                  |
|-----------------------------------|------|----------------------------------------------------------------------|-----------------------------------------|
| `KAFKA_ZOOKEEPER_CONNECT`         | 是   | ZooKeeper 连接字符串（格式：`host:port[,host:port]`）               | `zookeeper:2181`                        |
| `KAFKA_BROKER_ID`                 | 否   | 手动指定 Broker ID                                                   | `1`                                     |
| `BROKER_ID_COMMAND`               | 否   | 生成 Broker ID 的命令（与 `KAFKA_BROKER_ID` 二选一）                 | `"hostname | awk -F'-' '{print $2}'"`   |
| `KAFKA_CREATE_TOPICS`             | 否   | 自动创建的主题列表（格式：`主题:分区:副本[:清理策略]`）              | `"Topic1:3:2,Topic2:1:1:compact"`      |
| `KAFKA_CREATE_TOPICS_SEPARATOR`   | 否   | 主题分隔符（默认 `,`）                                               | `"$$'\n'"`（换行符）                    |
| `KAFKA_ADVERTISED_HOST_NAME`      | 否   | 手动指定广告主机名（与 `HOSTNAME_COMMAND` 二选一）                   | `192.168.1.100`                         |
| `HOSTNAME_COMMAND`                | 否   | 生成广告主机名的命令                                                 | `"curl http://169.254.169.254/latest/meta-data/local-ipv4"` |
| `PORT_COMMAND`                    | 否   | 生成广告端口的命令                                                   | `"docker port $$(hostname) 9092/tcp | cut -d: -f2"` |
| `KAFKA_LISTENERS`                 | 否   | 监听器列表（格式：`协议://地址:端口`）                               | `"INSIDE://:9092,OUTSIDE://:9094"`      |
| `KAFKA_ADVERTISED_LISTENERS`      | 否   | 广告监听器列表                                                       | `"INSIDE://:9092,OUTSIDE://{IP}:9094"`  |
| `KAFKA_LISTENER_SECURITY_PROTOCOL_MAP` | 否 | 协议-安全策略映射                                   | `"INSIDE:PLAINTEXT,OUTSIDE:SSL"`        |
| `KAFKA_INTER_BROKER_LISTENER_NAME` | 否   | Broker 间通信协议名                                                 | `"INSIDE"`                              |
| `KAFKA_BROKER_RACK`               | 否   | 手动指定 Broker 机架信息                                             | `"us-west-2a"`                          |
| `RACK_COMMAND`                    | 否   | 生成机架信息的命令                                                   | `"curl http://169.254.169.254/latest/meta-data/placement/availability-zone"` |
| `KAFKA_JMX_OPTS`                  | 否   | JMX 配置参数                                                         | `"-Dcom.sun.management.jmxremote ..."`  |
| `JMX_PORT`                        | 否   | JMX 监听端口                                                        | `1099`                                  |


## 注意事项

1. **网络配置**：容器网络环境复杂时（如跨主机通信），需参考 [Connectivity Guide](https://github.com/wurstmeister/kafka-docker/wiki/Connectivity) 排查端口映射、防火墙规则等问题。
2. **Broker ID 稳定性**：默认配置下，Broker 重启可能导致 ID 变化（自动生成场景），生产环境建议手动指定 `KAFKA_BROKER_ID` 或使用 `--no-recreate` 避免容器重建。
3. **监听器与广告地址兼容性**：使用 `KAFKA_LISTENERS` 时，请勿同时设置 `KAFKA_ADVERTISED_HOST_NAME` 和 `KAFKA_ADVERTISED_PORT`，避免配置冲突。
4. **ZooKeeper 依赖**：Kafka 依赖 ZooKeeper 存储元数据，需确保 `KAFKA_ZOOKEEPER_CONNECT` 指向可用的 ZooKeeper 集群。


## 参考链接

- [GitHub 项目主页](https://github.com/wurstmeister/kafka-docker)
- [Kafka 官方文档](https://kafka.apache.org/documentation/)
- [Docker Compose 配置参考](https://docs.docker.com/compose/compose-file/)
- [Connectivity Guide（网络连接指南）](https://github.com/wurstmeister/kafka-docker/wiki/Connectivity)

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/wurstmeister/kafka" title="wurstmeister/kafka Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/wurstmeister/kafka</a></p>
