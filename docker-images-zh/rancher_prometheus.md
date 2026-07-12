---
image: rancher/prometheus
description: "Rancher 维护的 Prometheus Docker 镜像，用于 Rancher/Kubernetes 环境下的指标采集与监控存储，适合与 Grafana 等组件组成可观测性栈，支持容器化快速部署。"
source: https://xuanyuan.cloud/zh/r/rancher/prometheus
canonical: https://xuanyuan.cloud/zh/r/rancher/prometheus
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rancher/prometheus" title="rancher/prometheus Docker 镜像中文简介、标签列表与拉取命令">rancher/prometheus 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Rancher Prometheus 镜像

Rancher 提供的 Prometheus 相关镜像，用于在 Rancher 管理的 Kubernetes 或 Docker 环境中采集与存储监控指标，常与 Grafana、Alertmanager 等组件配合，支撑集群与应用可观测性。

## 适用场景

- Rancher 集群内置监控栈部署
- 与 Rancher 监控方案集成的指标采集
- 开发测试环境中的 Prometheus 快速拉起

具体标签与配置请以 Rancher 官方文档为准，拉取后根据编排文件挂载 `prometheus.yml` 与数据卷。
