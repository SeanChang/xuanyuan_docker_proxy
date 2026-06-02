---
image: mher/flower
description: "Flower的自动化构建Docker镜像，提供监控和管理Celery集群的Web界面，支持便捷部署与版本更新。"
source: https://xuanyuan.cloud/zh/r/mher/flower
canonical: https://xuanyuan.cloud/zh/r/mher/flower
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mher/flower" title="mher/flower Docker 镜像中文简介、标签列表与拉取命令">mher/flower — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/mher/flower" title="mher/flower Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mher/flower</a>

# Flower

## 镜像概述与主要用途

Flower 是一款基于 Web 的 Celery 集群监控与管理工具。通过直观的 Web 界面和丰富的 API，Flower 提供了对 Celery 任务、工人节点（Worker）及消息代理（Broker）的实时监控与远程控制能力，帮助开发者和运维人员高效管理分布式任务调度系统。


## 核心功能与特性

### 实时监控
- **任务监控**：实时跟踪任务进度与历史记录，展示任务详情（参数、开始时间、运行时长等），提供任务执行统计图表。
- **工人监控**：查看工人节点状态与性能指标，包括当前运行任务、已完成任务数、错误率等。

### 远程控制
- **工人管理**：支持工人节点的启动/关闭、池大小调整、自动扩缩容配置修改。
- **队列管理**：查看并修改工人节点消费的队列，监控队列长度与任务分布。
- **任务控制**：查看/终止运行中任务、计划任务（ETA/countdown）、保留任务及撤销任务；应用时间限制与速率限制；配置查看与修改。

### Broker 监控
- 展示所有 Celery 队列的统计信息，生成队列长度趋势图表。

### 其他特性
- **HTTP API**：通过 REST API 实现集群管理、任务调用等操作。
- **认证机制**：支持 Basic Auth 及 Google、Github、Gitlab、Okta OAuth 认证。
- **Prometheus 集成**：提供指标暴露接口，支持与 Prometheus 监控系统集成。


## 使用场景与适用范围

- **Celery 集群监控**：实时掌握分布式任务执行状态，排查任务延迟或失败问题。
- **生产环境管理**：远程调整工人节点配置（如池大小、队列消费策略），无需重启服务。
- **任务调度优化**：通过队列长度图表和任务统计，优化任务分发与资源分配。
- **监控系统集成**：结合 Prometheus 等工具构建全面的集群监控体系。
- **开发调试**：跟踪任务执行细节，快速定位任务逻辑或性能问题。


## 镜像获取与部署

### 镜像信息
- **Docker Hub 镜像**：`mher/flower`


### Docker 部署示例

#### 基础部署
启动 Flower 服务，默认监听 5555 端口：
```bash
docker run -d -p 5555:5555 --name flower mher/flower
```
访问 Web 界面：`http://localhost:5555`


#### 指定端口与地址
自定义绑定端口（如 5566）和地址（如 0.0.0.0，允许外部访问）：
```bash
docker run -d -p 5566:5566 mher/flower celery flower --port=5566 --address=0.0.0.0
```


#### 传递 Celery 参数
通过 Celery 参数指定应用路径、Broker URL 等（需放在 `celery` 命令后、`flower` 子命令前）：
```bash
docker run -d -p 5555:5555 mher/flower celery -A proj --broker=amqp://guest:guest@rabbitmq:5672// flower
```
- `-A proj`：指定 Celery 应用路径为 `proj`。
- `--broker`：指定消息代理 URL（此处连接到名为 `rabbitmq` 的容器）。


#### 启用基本认证
通过 `--basic-auth` 参数配置用户名密码认证（格式：`用户名:密码`）：
```bash
docker run -d -p 5555:5555 mher/flower celery flower --basic-auth=admin:secret
```


#### Docker Compose 示例
与 Celery 应用、RabbitMQ  broker 联动的 `docker-compose.yml`：
```yaml
version: '3'
services:
  rabbitmq:
    image: rabbitmq:3-management
    ports:
      - "5672:5672"  # Broker 端口
      - "15672:15672"  # RabbitMQ 管理界面

  celery-app:
    build: ./your-celery-app  # 构建 Celery 应用镜像
    depends_on:
      - rabbitmq
    command: celery -A proj worker --loglevel=info

  flower:
    image: mher/flower
    depends_on:
      - celery-app
      - rabbitmq
    ports:
      - "5555:5555"
    command: celery -A proj --broker=amqp://guest:guest@rabbitmq:5672// flower --port=5555 --address=0.0.0.0
```


## 使用方法与配置说明

### 基本命令格式
Flower 需通过 Celery 命令启动，格式如下：
```bash
celery [celery参数] flower [flower参数]
```
- **Celery 参数**：用于配置 Celery 应用环境（如应用路径、Broker 地址），需放在 `celery` 命令后、`flower` 子命令前。
- **Flower 参数**：用于配置 Flower 服务本身（如端口、认证），需放在 `flower` 子命令后。


### 常用参数说明

#### Celery 核心参数
| 参数                | 说明                                  | 示例                                  |
|---------------------|---------------------------------------|---------------------------------------|
| `-A, --app`         | 指定 Celery 应用路径                  | `-A proj`（应用包路径为 `proj`）      |
| `-b, --broker`      | 指定消息代理 URL                      | `--broker=amqp://guest@rabbitmq:5672` |
| `--result-backend`  | 指定任务结果存储后端                  | `--result-backend=redis://redis:6379` |


#### Flower 核心参数
| 参数                | 说明                                  | 示例                                  |
|---------------------|---------------------------------------|---------------------------------------|
| `--port`            | 绑定端口（默认 5555）                 | `--port=5566`                         |
| `--address`         | 绑定地址（默认 0.0.0.0）              | `--address=127.0.0.1`                 |
| `--unix-socket`     | 使用 Unix 套接字而非 TCP 端口         | `--unix-socket=/tmp/flower.sock`      |
| `--basic-auth`      | 启用基本认证（用户名:密码）           | `--basic-auth=admin:secret`           |
| `--auth_provider`   | 启用 OAuth 认证（如 GitHub、Google）  | `--auth_provider=github --auth_config=oauth.cfg` |
| `--prometheus-port` | 暴露 Prometheus 指标的端口            | `--prometheus-port=9090`              |


### 高级配置示例

#### 启用 GitHub OAuth 认证
1. 创建 OAuth 配置文件 `oauth.cfg`：
```ini
[github]
client_id = YOUR_GITHUB_CLIENT_ID
client_secret = YOUR_GITHUB_CLIENT_SECRET
redirect_uri = http://localhost:5555/login
orgs = your-github-org  # 限制指定组织成员访问
```
2. 通过 Docker 启动并挂载配置文件：
```bash
docker run -d -p 5555:5555 -v $(pwd)/oauth.cfg:/oauth.cfg mher/flower celery flower --auth_provider=github --auth_config=/oauth.cfg
```


#### 集成 Prometheus
启动时暴露 Prometheus 指标端口，供 Prometheus 采集：
```bash
docker run -d -p 5555:5555 -p 9090:9090 mher/flower celery flower --prometheus-port=9090
```
Prometheus 指标地址：`http://localhost:9090/metrics`


## API 接口

Flower 提供 HTTP API 和 WebSocket 接口，支持集群管理与实时事件订阅。

### HTTP API 示例

#### 重启工人节点
```bash
curl -X POST http://localhost:5555/api/worker/pool/restart/myworker
```
（`myworker` 为工人节点名称）


#### 异步调用任务
```bash
curl -X POST -d '{"args":[1,2]}' http://localhost:5555/api/task/async-apply/tasks.add
```
（调用 `tasks.add` 任务，参数为 `[1,2]`）


#### 终止任务
```bash
curl -X POST -d 'terminate=True' http://localhost:5555/api/task/revoke/8a4da87b-e12b-4547-b89a-e92e4d1f8efd
```
（终止 ID 为 `8a4da87b-e12b-4547-b89a-e92e4d1f8efd` 的任务）


### WebSocket 实时事件
订阅任务成功事件：
```javascript
var ws = new WebSocket("ws://localhost:5555/api/task/events/task-succeeded/");
ws.onmessage = function (event) {
    console.log("任务成功:", event.data);  // 输出任务详情 JSON
};
```


## 许可证
Flower 采用 BSD 3-Clause License 许可协议。详细内容参见 [LICENSE](https://github.com/mher/flower/blob/master/LICENSE) 文件。
