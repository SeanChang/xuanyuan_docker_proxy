---
image: cilium/cilium
description: "Cilium是基于eBPF数据平面的容器网络、可观测性和安全解决方案，支持多集群L3网络（覆盖网络/原生路由模式），提供L3-L7基于身份的网络策略，实现分布式负载均衡并可替代kube-proxy，具备API保护、带宽管理及深度可观测性（如Hubble）。"
source: https://xuanyuan.cloud/zh/r/cilium/cilium
canonical: https://xuanyuan.cloud/zh/r/cilium/cilium
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cilium/cilium" title="cilium/cilium Docker 镜像中文简介、标签列表与拉取命令">cilium/cilium 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Cilium 镜像文档

## 概述

Cilium是一款基于eBPF数据平面的网络、可观测性和安全解决方案。它提供简单的扁平L3网络，支持多集群跨域部署（原生路由或覆盖网络模式），具备L7协议感知能力，可基于与网络地址解耦的身份安全模型实施L3-L7网络策略。Cilium实现了Pod间及外部服务的分布式负载均衡，能完全替代kube-proxy，通过eBPF高效哈希表支持近乎无限扩展，同时提供集成的入口/出口网关、带宽管理、服务网格等高级功能，以及深度网络与安全可见性监控。

[eBPF](https://ebpf.io)是Cilium的技术基础，支持在Linux内核的网络IO、应用套接字、跟踪点等集成点动态插入eBPF字节码，实现安全、网络和可观测性逻辑，兼具高效性与灵活性。

## 核心功能与特性

### 协议感知的安全策略

透明保护和安全API，支持REST/HTTP、gRPC、Kafka等现代应用协议的细粒度控制，超越传统L3/L4防火墙：
- 过滤HTTP请求（如允许`GET /public/.*`，拒绝其他）
- 控制Kafka消息（如允许`service1`生产`topic1`，`service2`消费`topic1`）
- 验证HTTP头（如要求`X-Token: [0-9]+`）

### 基于身份的服务通信安全

为共享相同安全策略的应用容器组分配安全身份，关联网络数据包，在接收节点验证身份，避免传统基于IP/端口的防火墙在容器动态扩缩容时的规模限制。身份管理通过键值存储实现。

### 外部服务访问控制

支持基于标签的集群内部访问控制，同时通过传统CIDR-based安全策略（入站/出站）限制容器与外部服务的访问，控制IP范围级别的访问权限。

### 简化网络模型

提供扁平L3网络，支持跨多集群连接，IP分配采用主机范围分配器（无需主机间协调），支持两种多节点网络模型：
- **覆盖网络（Overlay）**：基于封装的虚拟网络（VXLAN、Geneve等），基础设施要求低，仅需主机间IP连通性。
- **原生路由（Native Routing）**：利用Linux主机路由表，适用于IPv6网络、云网络路由器或已有路由守护进程的场景。

### 分布式负载均衡

完全替代kube-proxy，通过eBPF高效哈希表实现分布式负载均衡：
- **南北向**：优化性能，可附加到XDP，支持直接服务器返回（DSR）和Maglev一致性哈希。
- **东西向**：在Linux内核套接字层（如TCP连接时）执行服务到后端转换，避免低层逐包NAT开销。

### 带宽管理

通过基于EDT（最早 departure 时间）的eBPF速率限制实现带宽管理，减少应用传输尾延迟，避免多队列NIC下的锁定问题，优于传统HTB/TBF方法。

### 可观测性与监控

提供深度网络与安全可见性：
- 带元数据的事件监控（如丢包时提供发送者/接收者标签信息）
- Prometheus指标导出，集成现有仪表板
- [Hubble](https://github.com/cilium/hubble/)：Cilium专用可观测平台，提供服务依赖图、操作监控、基于流日志的应用与安全可见性。

## 架构与版本支持

### 架构支持

Cilium镜像支持AMD64和AArch64架构。

### 稳定版本

社区维护最近三个次要版本的稳定版，更早版本视为EOL。所有镜像包含SPDX格式的软件物料清单（SBOM），详情见[Cilium SBOM](https://docs.cilium.io/en/latest/configuration/sbom/)。升级请参考[Cilium升级指南](https://docs.cilium.io/en/stable/operations/upgrade/)。

### 开发版本

提供快照、早期候选版本（RC）和CI容器镜像（基于[main分支](https://github.com/cilium/cilium/commits/main)构建），仅用于开发测试，不建议生产环境使用。测试升级请参考开发版[Cilium升级指南](https://docs.cilium.io/en/stable/operations/upgrade/)。

## 使用场景

- **API保护**：细粒度控制HTTP/gRPC/Kafka等协议请求（方法、路径、主题、头信息等）。
- **服务间通信安全**：基于身份而非IP/端口的服务访问控制，适应容器动态扩缩容。
- **外部服务访问控制**：通过CIDR策略限制容器与外部服务的IP范围访问。
- **负载均衡替代**：替代kube-proxy，提供更高性能和扩展性的eBPF负载均衡。
- **带宽管理**：控制容器出口流量带宽，优化传输延迟。
- **多集群网络**：跨集群的覆盖网络或原生路由连接，实现统一网络平面。

## 部署与配置

Cilium推荐通过Helm chart部署（Artifact Hub地址：https://artifacthub.io/packages/helm/cilium/cilium）。详细部署步骤、配置参数及示例请参考官方文档：
- [安装Cilium](https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/)
- [配置指南](https://docs.cilium.io/en/stable/configuration/)

## 社区与支持

- **Slack**：加入[Cilium Slack频道](https://slack.cilium.io)与开发者和用户交流。
- **特别兴趣小组（SIG）**：详情见[Special Interest Groups](https://docs.cilium.io/en/stable/community/community/#special-interest-groups)。
- **开发者会议**：每周Zoom会议，时间和纪要见[Cilium文档](https://docs.cilium.io/en/latest/community/community/)。
- **直播**：每周[eCHO直播](https://www.youtube.com/channel/UCJFUxkVQTBJh3LD1wYBWvuQ)（eBPF & Cilium Office Hours），内容及建议见[eCHO仓库](https://github.com/isovalent/eCHO)。

## 许可证

- 用户空间组件：[Apache License, Version 2.0](LICENSE)
- BPF代码模板：双许可证 [GPL-2.0-only](bpf/LICENSE.GPL-2.0) 和 [BSD-2-Clause](bpf/LICENSE.BSD-2-Clause)（可选择任一许可证条款）
