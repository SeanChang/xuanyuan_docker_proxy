---
image: apache/skywalking-python
description: "Apache SkyWalking 的 Python 代理，为 Python 项目提供原生追踪能力，支持微服务、云原生和容器架构下的应用性能监控，可通过多种协议上报数据至 SkyWalking 后端。"
source: https://xuanyuan.cloud/zh/r/apache/skywalking-python
canonical: https://xuanyuan.cloud/zh/r/apache/skywalking-python
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/skywalking-python" title="apache/skywalking-python Docker 镜像中文简介、标签列表与拉取命令">apache/skywalking-python 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# SkyWalking Python Agent

<img src="http://skywalking.apache.org/assets/logo.svg" alt="Sky Walking logo" height="90px" align="right" />

**SkyWalking-Python**：Apache SkyWalking 的 Python 代理，为 Python 项目提供原生追踪能力。

**SkyWalking**：一款应用性能监控（APM）系统，专为微服务、云原生和基于容器（Docker、Kubernetes、Mesos）的架构设计。

[![GitHub stars](https://img.shields.io/github/stars/apache/skywalking-python.svg?style=for-the-badge&label=Stars&logo=github)](https://github.com/apache/skywalking-python)
[![Twitter Follow](https://img.shields.io/twitter/follow/asfskywalking.svg?style=for-the-badge&label=Follow&logo=twitter)](https://twitter.com/AsfSkyWalking)


[![Build](https://github.com/apache/skywalking-python/workflows/Build/badge.svg?branch=master)](https://github.com/apache/skywalking-python/actions?query=branch%3Amaster+event%3Apush+workflow%3A%22Build%22)

## 概述

SkyWalking Python Agent 是 Apache SkyWalking 的官方 Python 代理组件，旨在为 Python 应用提供分布式追踪、性能指标收集等能力，帮助用户在微服务、云原生及容器化环境中实现对 Python 应用的全链路监控。该代理支持多种数据上报协议（gRPC、HTTP、Kafka），提供自动和手动埋点两种方式，并内置对主流 Python 框架的插件支持。

## 核心功能与特性

- **原生追踪能力**：为 Python 应用提供分布式追踪，支持调用链构建与分析
- **多协议支持**：支持 gRPC、HTTP、Kafka 等多种协议上报监控数据
- **自动埋点**：内置对主流 Python 库（如 Flask、Django、http.server 等）的自动 instrumentation 插件
- **非侵入式集成**：通过 `sw-python` 命令行工具实现零代码侵入式集成
- **日志追踪关联**：支持日志上报与追踪数据关联分析
- **手动埋点 API**：提供灵活的 API 支持自定义追踪逻辑（如创建 span、添加标签等）
- **跨线程传播**：支持追踪上下文在多线程环境中的传播

## 适用场景

- 微服务架构下的 Python 应用性能监控
- 云原生环境中 Python 服务的分布式追踪
- 容器化（Docker、Kubernetes）部署的 Python 应用监控
- 需要对 Python 应用进行性能瓶颈分析和问题定位的场景

## 安装方法

### 从 PyPI 安装

Python 代理模块已发布至 [PyPI](https://pypi.org/project/apache-skywalking/)，可通过 `pip` 安装：

```shell
# 安装最新版本，使用默认 gRPC 协议上报数据至 OAP
pip install "apache-skywalking"

# 安装最新版本，使用 HTTP 协议上报数据至 OAP
pip install "apache-skywalking[http]"

# 安装最新版本，使用 Kafka 协议上报数据至 OAP
pip install "apache-skywalking[kafka]"

# 安装指定版本 x.y.z
# pip install apache-skywalking==x.y.z
pip install apache-skywalking==0.1.0  # 示例：安装 0.1.0 版本
```

### 从 Docker Hub 安装

SkyWalking Python Agent 提供便捷的 Dockerfile 和镜像，利用其自动引导能力实现轻松集成。您可以基于代理启用的 Python 镜像构建 Python 应用镜像，并自动启用 SkyWalking Agent 运行应用。详细构建和配置说明请参考 [dockerfile 指南](docker/README.md)。

### 从源代码安装

请参考 [FAQ](docs/FAQ.md#q-how-to-build-from-sources)。

## 配置与使用指南

### 环境要求

- SkyWalking 8.0+
- Python 3.5+

> 如需试用尚未发布的最新特性，请参考 [指南](docs/FAQ.md#q-how-to-build-from-sources) 从源代码构建。

默认情况下，SkyWalking Python Agent 使用 gRPC 协议上报数据至 SkyWalking 后端。SkyWalking 后端中，gRPC 协议端口为 `11800`，HTTP 协议端口为 `12800`，请根据使用的协议配置 `collector_address`（或环境变量 `SW_AGENT_COLLECTOR_BACKEND_SERVICES`）。

### 非侵入式集成（CLI）

SkyWalking Python Agent 支持无需修改代码即可运行和附加到应用。安装包提供 `sw-python` 命令行工具，可通过以下方式运行 Python 应用：

```shell
sw-python run python abc.py
# 或
sw-python run program arg0 arg1
```

生产环境使用前，请阅读 [CLI 指南](docs/CLI.md) 获取详细介绍。如需要，也可使用以下传统集成方式。

### 通过 gRPC 协议上报数据（默认）

如需使用 gRPC 协议上报数据，配置 `collector_address`（或环境变量 `SW_AGENT_COLLECTOR_BACKEND_SERVICES`）为 `<oap-ip-or-host>:11800`，例如 `127.0.0.1:11800`：

```python
from docker.xuanyuan.run/skywalking import agent, config

config.init(collector_address='127.0.0.1:11800', service_name='your awesome service')
agent.start()
```

### 通过 HTTP 协议上报数据

如需使用 HTTP 协议上报数据，配置 `collector_address`（或环境变量 `SW_AGENT_COLLECTOR_BACKEND_SERVICES`）为 `<oap-ip-or-host>:12800`，例如 `127.0.0.1:12800`：

> 注意：需安装带有 `http` 额外依赖的版本：`pip install "apache-skywalking[http]"`

```python
from docker.xuanyuan.run/skywalking import agent, config

config.init(collector_address='127.0.0.1:12800', service_name='your awesome service')
agent.start()
```

### 通过 Kafka 协议上报数据

如需使用 Kafka 协议上报数据，配置 `kafka_bootstrap_servers`（或环境变量 `SW_KAFKA_REPORTER_BOOTSTRAP_SERVERS`）为 `kafka-brokers`，例如 `127.0.0.1:9200`：

> 注意：需安装带有 `kafka` 额外依赖的版本：`pip install "apache-skywalking[kafka]"`

```python
from docker.xuanyuan.run/skywalking import agent, config

config.init(kafka_bootstrap_servers='127.0.0.1:9200', service_name='your awesome service')
agent.start()
```

此外，也可通过环境变量（如 `SW_AGENT_NAME`、`SW_AGENT_COLLECTOR_BACKEND_SERVICES` 等）传递配置，无需调用 `config.init`。所有支持的环境变量可参考 [此处](docs/EnvVars.md)。

## 日志上报

Python Agent 能够将收集的日志上报至后端（SkyWalking OAP），实现日志与追踪关联。详细指南请参考 [日志上报文档](docs/LogReporter.md)。

## 支持的库

内置插件支持对 Python 库的自动 instrumentation（如 `http.server`、`Flask`、`Django` 等），完整列表可参考 [此处](docs/Plugins.md)。

## 手动埋点 API

除了支持自动 instrumentation 的 [库](#supported-libraries) 外，还提供手动埋点 API。

### 创建 Span

以下代码片段展示如何创建入口 span、出口 span 和本地 span：

```python
from docker.xuanyuan.run/skywalking import Component
from docker.xuanyuan.run/skywalking.trace.context import SpanContext, get_context
from docker.xuanyuan.run/skywalking.trace.tags import Tag

context: SpanContext = get_context()  # 获取追踪上下文
# 创建入口 span，使用 `with` 语句，span 在进入/退出上下文时自动开始/停止
with context.new_entry_span(op='https://github.com/apache') as span:
    span.component = Component.Flask
# 退出 `with` 上下文时 span 自动停止

class TagSinger(Tag):
    key = 'Singer'

with context.new_exit_span(op='https://github.com/apache', peer='localhost:8080', component=Component.Flask) as span:
    span.tag(TagSinger('Nakajima'))

with context.new_local_span(op='https://github.com/apache') as span:
    span.tag(TagSinger('Nakajima'))
```

### 装饰器

```python
from docker.xuanyuan.run/time import sleep

from docker.xuanyuan.run/skywalking import Component
from docker.xuanyuan.run/skywalking.decorators import trace, runnable
from docker.xuanyuan.run/skywalking.trace.context import SpanContext, get_context

@trace()  # 操作名默认为方法名('some_other_method')
def some_other_method():
    sleep(1)


@trace(op='awesome')  # 自定义操作名为 'awesome'
def some_method():
    some_other_method()


@trace(op='async_functions_are_also_supported')
async def async_func():
    return 'asynchronous'


@trace()
async def async_func2():
    return await async_func()


@runnable()  # 跨线程传播
def some_method():
    some_other_method()

from docker.xuanyuan.run/threading import Thread
t = Thread(target=some_method)
t.start()


context: SpanContext = get_context()
with context.new_entry_span(op=str('https://github.com/apache/skywalking')) as span:
    span.component = Component.Flask
    some_method()
```

## 联系我们

- 提交 [issue](https://github.com/apache/skywalking/issues/new)，标题前缀使用 [Python]
- 邮件列表：**dev@skywalking.apache.org**。发送邮件至 `dev-subscribe@skywalking.apache.org`，按照回复订阅邮件列表
- 加入 [Apache Slack](http://s.apache.org/slack-invite) 中的 `skywalking` 频道。如链接无效，可在 [Apache INFRA WIKI](https://cwiki.apache.org/confluence/display/INFRA/Slack+Guest+Invites) 查找最新链接
- Twitter：[ASFSkyWalking](https://twitter.com/ASFSkyWalking)

## 贡献指南

提交拉取请求或推送提交前，请阅读我们的 [贡献指南](CONTRIBUTING.md) 和 [开发者指南](docs/Developer.md)。

## 常见问题

请查看 [FAQ 页面](docs/FAQ.md) 或在其中添加常见问题。

## 许可证

Apache 2.0
