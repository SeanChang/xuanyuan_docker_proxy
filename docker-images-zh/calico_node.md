---
image: calico/node
description: "Calico的每个节点DaemonSet容器镜像，作为开源的Kubernetes网络与安全解决方案核心组件，通过实现容器网络接口（CNI）标准，为Kubernetes集群提供高效的网络连接管理和精细化的网络策略控制，确保集群中Pod间通信的安全、稳定与高效，其DaemonSet部署模式可保障每个节点均能稳定运行该网络组件，有效支撑Kubernetes的网络功能实现。"
source: https://xuanyuan.cloud/zh/r/calico/node
canonical: https://xuanyuan.cloud/zh/r/calico/node
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/calico/node" title="calico/node Docker 镜像中文简介、标签列表与拉取命令">calico/node 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

### 关于 `calico/node`  

`calico/node` 是 Calico 在 Kubernetes 集群中于每个节点运行的 DaemonSet 组件，负责实现 CNI 网络连接与 NetworkPolicy 策略下发，保障 Pod 间通信的安全与稳定。

该镜像通常与 `calico/cni`、`calico/kube-controllers` 等组件配合部署，是 Calico 网络方案的核心运行时之一。若需了解整体架构，可查阅 Calico 组件架构文档：[Calico component architecture]
