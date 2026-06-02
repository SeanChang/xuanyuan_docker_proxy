---
image: prom/alertmanager
description: "prom/alertmanager是Prometheus生态的告警管理组件，用于处理来自Prometheus服务器等客户端的告警，提供去重、分组、路由至邮件/PagerDuty等接收器的功能，并支持告警静默和抑制，确保告警高效分发与管理。"
source: https://xuanyuan.cloud/zh/r/prom/alertmanager
canonical: https://xuanyuan.cloud/zh/r/prom/alertmanager
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/prom/alertmanager" title="prom/alertmanager Docker 镜像中文简介、标签列表与拉取命令">prom/alertmanager — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/prom/alertmanager" title="prom/alertmanager Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/prom/alertmanager</a>

# Alertmanager 镜像文档

## 概述

Alertmanager 是 Prometheus 生态系统中的核心组件，负责处理由客户端应用（如 Prometheus 服务器）发送的告警。它提供告警的 deduplication（去重）、grouping（分组）和 routing（路由）功能，可将告警分发至多种接收器（如电子邮件、PagerDuty、OpsGenie 等），同时支持告警的 silencing（静默）和 inhibition（抑制），是构建可靠监控告警系统的关键工具。

## 核心功能与特性

- **告警处理**：接收并处理来自 Prometheus 等客户端的告警信息
- **去重与分组**：合并重复告警，按标签（如 `alertname`、`cluster`）分组同类告警
- **灵活路由**：基于标签匹配规则将告警路由至不同接收器
- **告警抑制**：当高优先级告警触发时，抑制低优先级同类告警
- **静默管理**：临时静音特定告警，支持通过 API 或工具管理
- **多接收器集成**：支持电子邮件、PagerDuty、OpsGenie 及 Webhook 等多种通知机制
- **高可用集群**：内置 HA 模式，通过集群实现告警数据同步与故障转移

## 使用场景

- 企业级监控系统的告警集中管理
- DevOps 流程中的异常事件通知
- 需要按服务/团队分级处理告警的场景
- 对告警可靠性和分发效率有高要求的环境

## Docker 部署与使用

### 镜像获取

Alertmanager 镜像可从以下仓库获取：
- [Quay.io](https://quay.io/repository/prometheus/alertmanager)
- [Docker Hub](https://hub.docker.com/r/prom/alertmanager/)

### 快速启动

使用以下命令启动 Alertmanager 容器进行测试：

```bash
docker run --name alertmanager -d -p 127.0.0.1:9093:9093 quay.io/prometheus/alertmanager
```

容器启动后，可通过 `http://localhost:9093/` 访问 Alertmanager Web 界面。

### 持久化配置

为持久化配置文件，建议挂载本地目录：

```bash
docker run --name alertmanager -d \
  -p 127.0.0.1:9093:9093 \
  -v /path/to/alertmanager/config:/etc/alertmanager \
  quay.io/prometheus/alertmanager \
  --config.file=/etc/alertmanager/alertmanager.yml
```

### Docker Compose 示例

```yaml
version: '3'
services:
  alertmanager:
    image: quay.io/prometheus/alertmanager
    container_name: alertmanager
    ports:
      - "9093:9093"
    volumes:
      - ./alertmanager/config:/etc/alertmanager
    command:
      - '--config.file=/etc/alertmanager/alertmanager.yml'
    restart: unless-stopped
```

## 配置说明

Alertmanager 使用 YAML 格式配置文件，核心包括 `global`、`route`、`inhibit_rules` 和 `receivers` 四部分。

### 配置示例

以下是涵盖主要配置项的示例（完整配置文档见 [Prometheus 官方文档](https://prometheus.io/docs/alerting/configuration/)）：

```yaml
global:
  # 邮件通知的 SMTP 服务器和发件人
  smtp_smarthost: 'localhost:25'
  smtp_from: 'alertmanager@example.org'

# 告警入口路由规则
route:
  # 未匹配子路由的告警默认接收器
  receiver: 'team-X-mails'
  # 告警分组标签（相同标签的告警将被合并）
  group_by: ['alertname', 'cluster']
  # 新告警组首次通知等待时间
  group_wait: 30s
  # 告警组内新告警再次通知等待时间
  group_interval: 5m
  # 重复告警通知间隔
  repeat_interval: 3h

  # 子路由规则
  routes:
  # 匹配 service 为 foo1/foo2/baz 的告警
  - matchers:
      - service=~"^(foo1|foo2|baz)$"
    receiver: 'team-X-mails'
    # 子路由：匹配 severity=critical 的告警
    routes:
    - matchers:
        - severity="critical"
      receiver: 'team-X-pager'

  # 匹配 service=files 的告警
  - matchers:
      - service="files"
    receiver: 'team-Y-mails'
    routes:
    - matchers:
        - severity="critical"
      receiver: 'team-Y-pager'

# 告警抑制规则（当高优先级告警触发时抑制低优先级告警）
inhibit_rules:
- source_matchers:
    - severity="critical"  # 源告警匹配规则
  target_matchers:
    - severity="warning"   # 目标告警匹配规则
  equal: ['alertname']     # 告警名称相同才应用抑制

# 接收器定义
receivers:
- name: 'team-X-mails'
  email_configs:
  - to: 'team-X+alerts@example.org, team-Y+alerts@example.org'

- name: 'team-X-pager'
  email_configs:
  - to: 'team-X+alerts-critical@example.org'
  pagerduty_configs:
  - routing_key: <team-X-key>  # PagerDuty 路由密钥

- name: 'team-Y-mails'
  email_configs:
  - to: 'team-Y+alerts@example.org'

- name: 'team-Y-pager'
  pagerduty_configs:
  - routing_key: <team-Y-key>

- name: 'team-DB-pager'
  pagerduty_configs:
  - routing_key: <team-DB-key>
```

## 命令行工具 amtool

`amtool` 是 Alertmanager 配套的命令行工具，用于管理告警和静默规则。

### 安装

通过 `go install` 安装：

```bash
go install github.com/prometheus/alertmanager/cmd/amtool@latest
```

### 常用操作

#### 查看告警

```bash
# 简单输出
amtool alert

# 详细输出
amtool -o extended alert

# 按标签查询
amtool -o extended alert query alertname="Test_Alert"
```

#### 静默告警

```bash
# 添加静默规则
amtool silence add alertname=Test_Alert

# 查看静默规则
amtool silence query

# 过期静默规则
amtool silence expire <silence-id>
```

#### 测试路由规则

```bash
# 测试告警标签匹配的接收器
amtool config routes test --config.file=alertmanager.yml service=database owner=team-X
```

## 高可用配置

Alertmanager 支持通过集群实现高可用，需配置 `--cluster.*` 系列参数（UDP 和 TCP 协议均需启用）。

### 集群启动示例

```bash
# 节点 1
docker run --name alertmanager-1 -d \
  -p 9093:9093 \
  -p 9094:9094 \
  quay.io/prometheus/alertmanager \
  --cluster.listen-address=0.0.0.0:9094 \
  --cluster.peer=alertmanager-2:9094 \
  --cluster.peer=alertmanager-3:9094

# 节点 2（类似节点 1，调整 peer 为其他节点）
# 节点 3（类似节点 1，调整 peer 为其他节点）
```

### Prometheus 配置

在 Prometheus 配置中指定所有 Alertmanager 实例：

```yaml
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - alertmanager-1:9093
      - alertmanager-2:9093
      - alertmanager-3:9093
```

> **注意**：不要在 Prometheus 与 Alertmanager 之间使用负载均衡，需直接配置所有节点地址以确保告警高可用。

## 参考链接

- [官方文档](http://prometheus.io/docs/alerting/alertmanager/)
- [配置文档](https://prometheus.io/docs/alerting/configuration/)
- [API 文档](http://petstore.swagger.io/?url=https://raw.githubusercontent.com/prometheus/alertmanager/main/api/v2/openapi.yaml)

## 许可证

Apache License 2.0，详见 [LICENSE](https://github.com/prometheus/alertmanager/blob/main/LICENSE)。
