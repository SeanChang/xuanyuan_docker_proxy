---
image: solace/pubsubplus-prometheus-exporter
description: "Solace PubSub+ 事件代理 Prometheus 导出器，配合Solace PubSub+ 事件代理 Operator，为Kubernetes环境中的Prometheus监控提供指标。"
source: https://xuanyuan.cloud/zh/r/solace/pubsubplus-prometheus-exporter
canonical: https://xuanyuan.cloud/zh/r/solace/pubsubplus-prometheus-exporter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/solace/pubsubplus-prometheus-exporter" title="solace/pubsubplus-prometheus-exporter Docker 镜像中文简介、标签列表与拉取命令">solace/pubsubplus-prometheus-exporter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Solace PubSub+ 事件代理 Prometheus 导出器

## 镜像概述和主要用途
Solace PubSub+ 事件代理 Prometheus 导出器是 Solace PubSub+ 事件代理 Operator 的补充组件，旨在为 Kubernetes 环境中的 Prometheus 监控提供指标支持。通过该导出器，用户可以将 Solace PubSub+ 事件代理的运行指标集成到 Prometheus 监控系统中，实现对事件代理的实时监控和性能分析。

## 核心功能和特性
- 与 Solace PubSub+ 事件代理 Operator 无缝集成，扩展 Kubernetes 环境下的监控能力
- 提供 Prometheus 兼容的指标数据，支持标准的 Prometheus 数据采集和处理流程
- 简化事件代理监控指标的获取和集成过程

## 使用场景和适用范围
适用于在 Kubernetes 集群中部署了 Solace PubSub+ 事件代理，且需要通过 Prometheus 进行监控的场景。特别适合需要对事件代理的运行状态、性能指标进行实时跟踪和分析的用户，如 DevOps 团队、系统管理员和平台监控人员。

## 使用方法和配置说明
详细的使用文档可参考 [Solace PubSub+ 事件代理 Operator 用户指南](https://github.com/SolaceProducts/pubsubplus-kubernetes-operator/blob/main/docs/EventBrokerOperatorUserGuide.md#prometheus-monitoring-support)。

项目源代码及更多信息可从 [GitHub 仓库](https://github.com/SolaceDev/pubsubplus-prometheus-exporter) 获取。

## 许可证
使用本产品即表示您同意 [源代码中概述的条款](https://github.com/SolaceDev/pubsubplus-prometheus-exporter/blob/main/LICENSE) 以及 [Solace 最终用户许可协议](https://solace.com/license-software) 中的条款和条件。
