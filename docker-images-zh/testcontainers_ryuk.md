---
image: testcontainers/ryuk
description: "Moby Ryuk镜像可根据指定过滤器在设定延迟后自动移除Docker容器、网络、卷及镜像，用于Docker资源的延迟清理。"
source: https://xuanyuan.cloud/zh/r/testcontainers/ryuk
canonical: https://xuanyuan.cloud/zh/r/testcontainers/ryuk
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/testcontainers/ryuk" title="testcontainers/ryuk Docker 镜像中文简介、标签列表与拉取命令">testcontainers/ryuk 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Moby Ryuk

## 镜像概述与主要用途

Moby Ryuk 是一个用于在指定延迟后根据给定过滤器自动删除 Docker 资源的工具。它支持按条件清理容器、网络、卷和镜像，通过 TCP 连接接收资源过滤规则，并在连接关闭或超时后执行清理操作，适用于自动化资源管理场景。


## 核心功能与特性

- **多类型资源清理**：支持删除容器、网络、卷和镜像等 Docker 资源。
- **灵活过滤规则**：通过键值对过滤器（如标签、健康状态）匹配目标资源。
- **TCP 动态配置**：通过 TCP 连接实时接收过滤规则，支持多次发送和确认。
- **超时控制机制**：可配置首次连接超时、Docker 重连超时等参数，保障稳定性。
- **自动化延迟清理**：连接关闭后按预设逻辑延迟执行资源删除操作。


## 使用场景与适用范围

- **自动化测试环境**：测试结束后自动清理临时容器、网络等资源，避免环境残留。
- **CI/CD 流水线**：清理构建过程中产生的临时 Docker 资源，释放系统空间。
- **不健康资源监控**：按健康状态过滤器（如 `health=unhealthy`）清理异常容器。
- **临时资源管理**：通过标签（如 `label=temp=true`）标记临时资源，统一定时清理。


## 使用方法

### 1. 启动 Ryuk 容器

需挂载 Docker 守护进程套接字（`/var/run/docker.sock`）以操作 Docker 资源，并配置端口映射：

```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock -e RYUK_PORT=8080 -p 8080:8080 docker.io/testcontainers/ryuk
```


### 2. 建立 TCP 连接

通过 TCP 客户端（如 `nc`）连接到 Ryuk 服务：

```bash
nc localhost 8080
```


### 3. 发送资源过滤规则

连接建立后，发送过滤规则（键值对格式），每条规则需以 `ACK` 确认：

```bash
# 示例：删除标签为 testing=true 且健康状态为 unhealthy 的资源
label=testing=true&health=unhealthy
ACK

# 示例：删除标签为 something 的资源
label=something
ACK
```


### 4. 关闭连接触发清理

关闭 TCP 连接后，Ryuk 会在延迟后执行清理。


### 5. 一次性发送过滤规则

通过管道一次性发送过滤规则（无需手动确认 `ACK`）：

```bash
printf "label=something_else" | nc localhost 8080
```


### 清理日志示例

资源删除后，Ryuk 会输出清理日志，示例如下：

```
2018/01/15 18:38:52 Timed out waiting for connection
2018/01/15 18:38:52 Deleting {"label":{"something":true}}
2018/01/15 18:38:52 Deleting {"label":{"something_else":true}}
2018/01/15 18:38:52 Deleting {"health":{"unhealthy":true},"label":{"testing=true":true}}
2018/01/15 18:38:52 Removed 1 container(s), 0 network(s), 0 volume(s), 0 image(s)
```


## 配置说明

Ryuk 支持通过环境变量配置行为，具体参数如下：

| 环境变量                | 描述                                                                 | 默认值  | 格式说明                                                                 |
|-------------------------|----------------------------------------------------------------------|---------|--------------------------------------------------------------------------|
| `RYUK_CONNECTION_TIMEOUT` | 首次连接超时时间（未收到连接时的等待时间）                           | 60s     | 遵循 Go 语言 `time.ParseDuration` 格式，如 `30s`（30秒）、`5m`（5分钟）。 |
| `RYUK_PORT`              | Ryuk 服务绑定的端口                                                 | 8080    | 整数端口号，需与容器端口映射一致。                                       |
| `RYUK_RECONNECTION_TIMEOUT` | Docker 连接断开后的重连超时时间                                     | 10s     | 遵循 Go 语言 `time.ParseDuration` 格式，如 `5s`（5秒）、`1m`（1分钟）。  |


## 部署示例

### Docker Run 命令

```bash
# 自定义端口和超时配置示例
docker run \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e RYUK_PORT=9090 \
  -e RYUK_CONNECTION_TIMEOUT=30s \
  -e RYUK_RECONNECTION_TIMEOUT=5s \
  -p 9090:9090 \
  docker.io/testcontainers/ryuk
```

### Docker Compose 配置（示例）

```yaml
version: '3'
services:
  ryuk:
    image: docker.io/testcontainers/ryuk
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - RYUK_PORT=8080
      - RYUK_CONNECTION_TIMEOUT=60s
      - RYUK_RECONNECTION_TIMEOUT=10s
    ports:
      - "8080:8080"
