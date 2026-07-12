---
image: bitnami/hubble-ui
description: "Bitnami提供的安全镜像，用于部署Hubble UI，支持服务网格的可视化与监控。"
source: https://xuanyuan.cloud/zh/r/bitnami/hubble-ui
canonical: https://xuanyuan.cloud/zh/r/bitnami/hubble-ui
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/hubble-ui" title="bitnami/hubble-ui Docker 镜像中文简介、标签列表与拉取命令">bitnami/hubble-ui 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Hubble UI 镜像

## 概述

Bitnami Hubble UI 镜像是 Cilium Hubble 的开源用户界面的容器化版本，由 Bitnami 打包分发。Hubble UI 提供可视化界面，用于监控和管理基于 Cilium 的容器网络，支持流量可视化、策略管理及网络性能分析等功能。该镜像基于 Bitnami 安全最佳实践构建，适用于开发环境及需要快速部署网络监控工具的场景。


## 核心功能与特性

### 安全强化
- 基于 Bitnami Secure Images 标准构建，采用最小化 Photon Linux 操作系统，减少攻击面
- 支持 FIPS 模式配置，通过环境变量控制 OpenSSL 加密模块合规性
- 提供 CVE 透明度（VEX/KEV 标准）、SBOM 清单及 SLSA-3 合规的构建元数据

### 容器优化
- 非 root 用户运行，降低权限滥用风险
- 与 Bitnami 其他容器（虚拟机、云镜像）使用一致的组件和配置策略，便于跨环境迁移
- 镜像签名（Notation）及病毒扫描报告，确保供应链完整性

### 功能完整性
- 完整支持 Hubble 核心功能：流量可视化、服务依赖图谱、策略执行监控
- 与 Cilium 网络插件无缝集成，实时展示网络流量指标


## 使用场景

- **开发环境网络监控**：在 Kubernetes 开发集群中快速部署，可视化容器间网络通信
- **Cilium 策略调试**：通过 UI 直观验证网络策略的生效状态及流量拦截情况
- **安全合规场景**：需满足 FIPS 加密标准的开发或测试环境
- **学习与演示**：作为 Cilium/Hubble 功能演示的轻量级部署方案


## 快速启动

使用以下命令快速启动 Hubble UI 容器：

```bash
docker run --name hubble-ui docker.xuanyuan.run/bitnami/hubble-ui:latest
```


## 获取镜像

### 推荐方式：从 Docker Hub 拉取

```bash
# 拉取最新版本
docker pull docker.xuanyuan.run/bitnami/hubble-ui:latest

# 拉取特定版本（需注意标签迁移通知）
docker pull docker.xuanyuan.run/bitnami/hubble-ui:[TAG]
```

### 标签说明
- **滚动标签**（如 `latest`）：指向最新稳定版本，持续更新
- **固定标签**（如 `v1.12.0`）：对应特定版本，2025年8月28日后将逐步迁移至 `bitnamilegacy` 仓库

### 镜像迁移通知
自2025年8月28日起，Bitnami 将逐步调整公共镜像分发策略：
- 所有旧版本标签（如 `2.50.0`、`10.6`）将从 `docker.io/bitnami` 迁移至 `docker.io/bitnamilegacy` 仓库，且不再接收更新
- 免费 tier 仅提供最新标签（`latest`）的强化镜像，用于开发环境
- 生产环境建议使用 Bitnami Secure Images 商业版，获取长期支持及完整安全特性


## 使用方法

### 运行容器
基础运行命令（默认配置）：
```bash
docker run -d \
  --name hubble-ui \
  -p 8080:8080 \
  docker.xuanyuan.run/bitnami/hubble-ui:latest
```

### 配置 FIPS 模式
通过环境变量 `OPENSSL_FIPS` 启用/禁用 FIPS 加密模式：
```bash
docker run -d \
  --name hubble-ui \
  -e OPENSSL_FIPS=no \  # 禁用FIPS模式（默认值为yes）
  bitnami/hubble-ui:latest
```

### 通过 Helm Chart 部署
生产环境建议使用 Bitnami Hubble Helm Chart，支持 Kubernetes 集群集成：
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install hubble bitnami/hubble --set ui.enabled=true
```


## 配置参数

| 环境变量       | 描述                     | 默认值 | 可选值       |
|----------------|--------------------------|--------|--------------|
| `OPENSSL_FIPS` | 控制 OpenSSL FIPS 模式启用 | `yes`  | `yes`/`no`   |


## 注意事项

- **标签支持变更**：2025年8月28日起，非 `latest` 标签将迁移至 `bitnamilegacy` 仓库，不再更新
- **生产环境建议**：免费版镜像仅用于开发，生产环境需订阅 Bitnami Secure Images 商业版以获取企业级支持、CVE 修复及合规保障
- **非 root 限制**：镜像默认以非 root 用户运行，不支持需要特权权限的操作（如主机网络修改）


## 贡献与支持

- 提交功能需求或问题：[GitHub Issues](https://github.com/bitnami/containers/issues)
- 代码贡献：通过 [GitHub Pull Requests](https://github.com/bitnami/containers/pulls) 提交改进


## 许可证

本镜像基于 Apache License 2.0 许可分发。相关商标归各自所有者所有，Bitnami 对第三方商标的使用不暗示任何关联或背书。

版权所有 © 2025 Broadcom Inc. 及其子公司。
