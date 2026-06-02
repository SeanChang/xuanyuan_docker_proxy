---
image: ubuntu/rabbitmq
description: "基于Ubuntu的RabbitMQ镜像 - 一个开源的多协议消息代理。"
source: https://xuanyuan.cloud/zh/r/ubuntu/rabbitmq
canonical: https://xuanyuan.cloud/zh/r/ubuntu/rabbitmq
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [ubuntu/rabbitmq — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/ubuntu/rabbitmq)

含镜像标签、拉取命令、部署文档与相关推荐。

[ubuntu/rabbitmq Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/ubuntu/rabbitmq)

# rabbitmq | Ubuntu

当前的 rabbitmq Docker 镜像[来自 Canonical](https://ubuntu.com/security/docker-images)，基于 Ubuntu。接收安全更新并滚动到更新的 rabbitmq 或 Ubuntu 版本。**此仓库可免费使用，不受每用户速率限制。**


## 关于 rabbitmq

RabbitMQ 是一个可靠且成熟的消息和流代理，易于在云环境、本地部署和本地机器上部署。目前全球有数百万用户在使用。

## 标签和架构
![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)
LTS 频道提供长达 5 年的免费安全维护。

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)
通过 [Canonical 的受限仓库](https://ubuntu.com/security/docker-images#get-in-touch) 提供长达 10 年的客户安全维护。


| 频道标签 | 支持至 | 当前版本 | 架构 |
|---|---|---|---|
| **`3.12-24.04_edge`** | 2029年05月 | Ubuntu 24.04 LTS 上的 rabbitmq 3.12 | `amd64`、`arm64` |
| `3.9-22.04_edge` | 2027年06月 | Ubuntu 22.04 LTS 上的 rabbitmq 3.9 | `arm64`、`amd64` |
| _`track_risk`_ |


频道标签按 `stable`（稳定版）、`candidate`（候选版）、`beta`（测试版）、`edge`（边缘版）的顺序显示该追踪的最稳定频道。风险更高的频道始终隐式可用。因此，如果列出了 `beta`，您也可以拉取 `edge`；如果列出了 `candidate`，您可以拉取 `beta` 和 `edge`；如果列出了 `stable`，则四个版本均可用。镜像保证按 `edge` → `beta` → `candidate` → `stable` 的顺序推进。

### 商业用途和扩展安全维护频道
如果您的使用场景包括商业再分发，或需要 ESM 或未列出的频道/版本，请[联系 Canonical 团队](https://ubuntu.com/security/docker-images#get-in-touch)（或发送邮件至 rocks@canonical.com）。

## 使用方法

在本地启动此镜像：

```sh
docker run -d --name rabbitmq-container -e TZ=UTC -p 5672:5672 -p 15672:15672 ubuntu/rabbitmq:3.12-24.04_edge
```
使用 AMQP 和 HTTPS 客户端（无 TLS）访问您的 RabbitMQ 实例。

#### 参数

| 参数 | 描述 |
|---|---|
| `-p 5672:5672` | 将 RabbitMQ 暴露在 `localhost:5672`，供无 TLS 的 AMQP 客户端使用。 |
| `-p 5671:5671` | 将 RabbitMQ 暴露在 `localhost:5671`，供有 TLS 的 AMQP 客户端使用。 |
| `-p 15672:15672` | 将 RabbitMQ 暴露在 `localhost:15672`，供无 TLS 的 HTTP 客户端使用。 |
| `-p 15671:15671` | 将 RabbitMQ 暴露在 `localhost:15692`，供有 TLS 的 HTTP 客户端 UI 使用。 |


#### 测试/调试

要调试容器：

```sh
docker logs -f rabbitmq-container
```

获取交互式 shell：

```sh
docker exec -it rabbitmq-container /bin/bash
```

### 测试/调试

配置默认用户和密码：

```bash
docker exec rabbitmq-container /scripts/config-defaults.sh
docker exec rabbitmq-container pebble restart rabbitmq-server
```

注意，配置默认用户和密码后，此容器不再适合生产环境。生产部署请参考[官方文档](https://www.rabbitmq.com/docs/configure)。

查询节点状态：

```bash
curl -u guest:guest http://localhost:15672/api/healthchecks/node
```


## Bugs 和功能请求

如果您在我们的镜像中发现 bug 或想要请求特定功能，请在此提交 bug：

[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

请将 bug 标题设为 “`rabbitmq: <问题摘要>`”。确保包含您使用的镜像的摘要，可通过以下命令获取：

```sh
docker images --no-trunc --quiet ubuntu/rabbitmq:<tag>
```


## 已弃用的频道和标签
这些频道（标签）不再更新。请升级到更新的频道，如无法升级，请[联系我们](https://ubuntu.com/security/docker-images#get-in-touch)。

| 追踪 | 版本 | 生命周期结束 | 升级路径 |
|---|---|---|---|
| _`track`_ |
