---
image: grafana/alloy
description: "Grafana Alloy是厂商无关的OpenTelemetry Collector发行版，具备可编程管道能力，用于构建、运行和调试强大的可观测性管道，支持多遥测生态系统集成。"
source: https://xuanyuan.cloud/zh/r/grafana/alloy
canonical: https://xuanyuan.cloud/zh/r/grafana/alloy
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/grafana/alloy" title="grafana/alloy Docker 镜像中文简介、标签列表与拉取命令">grafana/alloy — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/grafana/alloy" title="grafana/alloy Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/grafana/alloy</a>

**警告**：v1.0版本意外推送了名为`latest-nanoserver-1809`的标签。此标签将不再更新，并将在未来版本中移除。对于最新的Windows镜像，请改用`nanoserver-1809`。

<p align="center"><img src="https://raw.githubusercontent.com/grafana/alloy/main/docs/sources/assets/logo_alloy_dark.svg" alt="Grafana Alloy logo" height="100px"></p>

<p align="center">
  <a href="https://github.com/grafana/alloy/releases"><img src="https://img.shields.io/github/release/grafana/alloy.svg" alt="最新版本"></a>
  <a href="https://grafana.com/docs/alloy/latest"><img src="https://img.shields.io/badge/文档-链接-blue?logo=gitbook" alt="文档链接"></a>
</p>

Grafana Alloy是厂商无关的OpenTelemetry Collector发行版，具备编写、运行和调试强大管道的额外能力。

<p>
<img src="https://raw.githubusercontent.com/grafana/alloy/main/docs/sources/assets/alloy_screenshot.png">
</p>

## 概述与主要用途

Grafana Alloy作为OpenTelemetry Collector的发行版，旨在提供强大的可观测性管道解决方案。它采用厂商无关的设计理念，支持多种遥测生态系统集成，适用于构建灵活、可扩展的观测性数据处理流程，满足从简单到复杂的监控需求。

## 核心功能与特性

### 可编程管道
使用丰富的[基于表达式的语法][syntax]配置强大的可观测性管道。

### OpenTelemetry Collector发行版
Alloy是[OpenTelemetry Collector的发行版][distribution]，支持其数十种组件，同时提供利用Alloy可编程管道的新组件。

### 厂商无关
Alloy秉持Grafana的"大帐篷"理念，拥有可与多个遥测生态系统完美集成的组件：
- [OpenTelemetry Collector][]
- [Prometheus][]
- [Grafana Loki][]
- [Grafana Pyroscope][]

### Kubernetes原生
通过组件与原生及自定义Kubernetes资源交互，无需学习单独的Kubernetes operator。

### 可共享管道
使用[模块][modules]与全球共享你的管道。

### 自动工作负载分配
配置Alloy实例形成[集群][cluster]以实现自动工作负载分配。

### 集中式配置支持
Alloy支持从[服务器][remotecfg]检索配置，实现集中式配置管理。

### 调试工具
使用[内置UI][ui]可视化和调试管道。

## 使用场景与适用范围

Alloy适用于各类需要构建可观测性管道的场景，包括：
- 多遥测系统集成（如同时使用Prometheus、Loki、OpenTelemetry的环境）
- Kubernetes集群内的观测性数据收集与处理
- 需要自定义数据处理逻辑的复杂监控场景
- 团队间共享标准化观测性配置的需求
- 大规模部署中需要自动负载分配和集中管理的场景

## 使用方法与配置示例

### 示例配置

```alloy
otelcol.receiver.otlp "example" {
  grpc {
    endpoint = "127.0.0.1:4317"
  }

  output {
    metrics = [otelcol.processor.batch.example.input]
    logs    = [otelcol.processor.batch.example.input]
    traces  = [otelcol.processor.batch.example.input]
  }
}

otelcol.processor.batch "example" {
  output {
    metrics = [otelcol.exporter.otlp.default.input]
    logs    = [otelcol.exporter.otlp.default.input]
    traces  = [otelcol.exporter.otlp.default.input]
  }
}

otelcol.exporter.otlp "default" {
  client {
    endpoint = "my-otlp-grpc-server:4317"
  }
}
```

## 快速开始

查看[官方文档][documentation]了解：
- [安装说明][install]
- [快速入门步骤][get-started]
- [组件列表][components]

## 发布周期

计划每六周发布一个次要版本。发布周期为最佳实践：如有必要，可能会在周期外发布版本，或调整计划发布日期。周期内发布的次要版本会更新上游OpenTelemetry Collector代码的依赖（如新版本可用），周期外发布的次要版本可能不包含这些依赖更新。补丁和安全版本可能随时发布。

## 社区

参与Alloy社区：
- 在Grafana Slack的`#alloy`频道交流（通过<https://slack.grafana.com/>获取邀请）
- 在[讨论页][discussions]提问
- [提交issue][issue]反馈bug、问题和功能建议
- 参加每月[社区会议][community-call]

## 贡献指南

参考[贡献者指南][contributors guide]了解如何贡献。感谢所有已贡献的开发者！

<a href="https://github.com/grafana/alloy/graphs/contributors">
  <img src="https://contributors-img.web.app/image?repo=grafana/alloy" />
</a>

[syntax]: https://grafana.com/docs/alloy/latest/concepts/config-syntax/
[distribution]: https://opentelemetry.io/docs/collector/distributions/
[OpenTelemetry Collector]: https://opentelemetry.io
[Prometheus]: https://prometheus.io
[Grafana Loki]: https://github.com/grafana/loki
[Grafana Pyroscope]: https://github.com/grafana/pyroscope
[modules]: https://grafana.com/docs/alloy/latest/concepts/modules/
[cluster]: https://grafana.com/docs/alloy/latest/concepts/clustering/
[remotecfg]: https://grafana.com/docs/alloy/latest/reference/config-blocks/remotecfg/
[ui]: https://grafana.com/docs/alloy/latest/tasks/debug/

[documentation]: https://grafana.com/docs/alloy/latest
[install]: https://grafana.com/docs/alloy/latest/setup/install/
[get-started]: https://grafana.com/docs/alloy/latest/getting_started/
[components]: https://grafana.com/docs/alloy/latest/reference/components/

[discussions]: https://github.com/grafana/agent/discussions
[issue]: https://github.com/grafana/alloy/issues/new
[community-call]: https://docs.google.com/document/d/1TqaZD1JPfNadZ4V81OCBPCG_TksDYGlNlGdMnTWUSpo

[contributors guide]: https://github.com/grafana/alloy/blob/main/docs/developer/contributing.md
