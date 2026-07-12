---
image: kubeovn/kube-ovn
description: "专为企业打造的Kubernetes网络架构，功能丰富且易于运维，能够满足企业复杂的网络需求，简化管理流程，提升运维效率，为企业在Kubernetes环境下的网络部署、运行与扩展提供稳定可靠的支持，助力企业轻松应对大规模容器网络挑战。"
source: https://xuanyuan.cloud/zh/r/kubeovn/kube-ovn
canonical: https://xuanyuan.cloud/zh/r/kubeovn/kube-ovn
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kubeovn/kube-ovn" title="kubeovn/kube-ovn Docker 镜像中文简介、标签列表与拉取命令">kubeovn/kube-ovn 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kube-OVN 介绍

![kube_ovn_logo] 

[中文教程] 


Kube-OVN 将基于 OVN 的网络虚拟化能力与 Kubernetes 深度集成，为企业级容器网络提供功能丰富、操作便捷的高级网络架构。


## 社区参与

Kube-OVN 社区期待你的加入！
- 在[]()关注我们的动态
- 加入[Slack] 与开发者实时交流
- 其他问题可发送邮件至[[邮箱已删除]](mailto:[邮箱已删除])
- 微信用户可添加联系人 **liumengxinfly** 进入“Kube-OVN 开源交流群”，请备注“Kube-OVN”及个人信息


## 功能特性

### 命名空间级子网
每个命名空间可拥有独立子网（由逻辑交换机支持），命名空间内的 Pod 将从该子网分配 IP 地址；也支持多个命名空间共享同一子网。

### 子网隔离
可配置子网拒绝来自非本网段子网 IP 地址的流量，支持白名单指定特定 IP 地址及 IP 段。

### 网络策略
通过高性能 OVN ACL 实现 networking.k8s.io/NetworkPolicy API。

### 工作负载静态IP地址
可为工作负载分配随机或静态 IP 地址。

### 多集群网络
将不同集群连接到同一三层网络。

### 多网卡IP地址管理
为 Kube-OVN 之外的 CNI 插件（如 macvlan/vlan/host-device）提供集群级 IP 地址管理能力，使其可复用 Kube-OVN 的子网及静态 IP 分配功能。

### 动态服务质量
支持动态配置 Pod/网关的入站/出站流量速率限制。

### 嵌入式负载均衡
使用 OVN 嵌入式高性能分布式二层负载均衡替代 kube-proxy。

### 分布式网关
每个节点均可作为网关，提供外部网络连通性。

### 命名空间级网关
每个命名空间可拥有独立网关用于出站流量。

### 直接外部连通性
Pod IP 可直接暴露至外部网络。

### BGP 协议支持
通过 BGP 路由协议将 Pod IP 暴露至外部网络。

### 流量镜像
复制容器网络流量用于监控、诊断及回放。

### 硬件卸载
将 OVS 流表卸载至硬件，提升网络性能并节省 CPU 资源。

### VLAN 支持
支持 Underlay VLAN 模式网络，提供更高性能与吞吐量。

### DPDK 支持
可在 Pod 中运行基于 OVS-DPDK 的 DPDK 应用。

### IPv6 支持
支持纯 IPv6 模式的 Pod 网络。

### ARM 架构支持
可运行于 x86_64 及 arm64 平台。

### 故障排查工具
提供便捷工具用于诊断、追踪、监控及抓取容器网络流量，助力解决复杂网络问题。

### Prometheus 与 Grafana 集成
以 Prometheus 格式暴露网络质量指标，如 Pod/节点/服务/DNS 的连通性及延迟。


## 未来规划
- 基于策略的服务质量
- 更多指标与流量图表
- 更多诊断与追踪工具


更多信息请查看[Kube-OVN]
