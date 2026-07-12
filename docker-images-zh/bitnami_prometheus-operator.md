---
image: bitnami/prometheus-operator
description: "Bitnami安全镜像，用于部署和管理Prometheus监控系统的prometheus-operator，提供安全加固特性。"
source: https://xuanyuan.cloud/zh/r/bitnami/prometheus-operator
canonical: https://xuanyuan.cloud/zh/r/bitnami/prometheus-operator
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/prometheus-operator" title="bitnami/prometheus-operator Docker 镜像中文简介、标签列表与拉取命令">bitnami/prometheus-operator 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Prometheus Operator 镜像文档


## 镜像概述和主要用途

Bitnami Prometheus Operator 镜像是基于 [Prometheus Operator](https://github.com/coreos/prometheus-operator) 构建的容器化解决方案。Prometheus Operator 旨在简化 Kubernetes 集群中服务的监控定义，以及 Prometheus 实例的部署和管理。该镜像由 Bitnami 打包，提供安全加固、标准化配置和跨环境一致性，适用于开发和生产环境的 Kubernetes 监控场景。


## 核心功能和特性

### Prometheus Operator 核心功能
- **简化监控定义**：通过自定义资源（如 `ServiceMonitor`、`PodMonitor`）声明式配置 Kubernetes 服务监控规则。
- **自动化 Prometheus 管理**：自动部署、扩展和更新 Prometheus 实例，简化生命周期管理。
- **集成 Alertmanager**：支持 Alertmanager 配置和管理，实现告警规则的统一管理。


### Bitnami 镜像特性
- **安全加固**：基于最小化操作系统（Photon Linux）构建，减少攻击面；符合 SLSA-3 合规的软件工厂流程，提供签名验证（Notation）、软件物料清单（SBOM）和病毒扫描报告。
- **FIPS 支持**：支持 FIPS 模式配置，通过环境变量控制 OpenSSL 加密模块合规性。
- **非 root 容器**：默认以非 root 用户运行，增强生产环境安全性。
- **漏洞透明度**：通过 VEX（漏洞可利用性交换）、KEV（已知被利用漏洞）和 EPSS 评分提供 CVE 风险透明度。
- **持续更新**：上游补丁发布后数小时内更新镜像，确保安全性和合规性。


## 使用场景和适用范围

- **Kubernetes 集群监控**：为 Kubernetes 服务、Pod 和节点提供标准化监控配置。
- **开发环境快速部署**：通过 `latest` 标签快速拉起测试环境，验证监控规则和 Prometheus 配置。
- **生产环境安全合规**：适用于对安全加固、漏洞管理和合规性有严格要求的生产 workload。
- **多环境一致性**：与 Bitnami 虚拟机、云镜像使用相同组件和配置，支持跨格式（容器、VM、云镜像）无缝切换。


## 使用方法和配置说明

### 拉取镜像

推荐从 Docker Hub 拉取预构建镜像：

```console
# 拉取最新版
docker pull docker.xuanyuan.run/bitnami/prometheus-operator:latest

# 拉取特定版本（需替换 [TAG] 为具体版本，如 0.70.0）
docker pull docker.xuanyuan.run/bitnami/prometheus-operator:[TAG]
```

> **注意**：2025 年 8 月 28 日后，历史版本标签（如 0.70.0）将迁移至 `docker.io/bitnamilegacy` 仓库，不再接收更新。


### Kubernetes 部署

Bitnami 提供 Helm Chart 简化 Kubernetes 部署，推荐使用 [kube-prometheus Chart](https://github.com/bitnami/charts/tree/master/bitnami/kube-prometheus)：

```console
# 添加 Bitnami Helm 仓库
helm repo add bitnami https://charts.bitnami.com/bitnami

# 更新仓库索引
helm repo update

# 部署 kube-prometheus（包含 Prometheus Operator 及相关组件）
helm install my-prometheus bitnami/kube-prometheus
```


### 配置说明

#### 环境变量

| 环境变量         | 描述                          | 取值范围       | 默认值 |
|------------------|-------------------------------|----------------|--------|
| `OPENSSL_FIPS`   | 控制 OpenSSL 是否启用 FIPS 模式 | `yes`（启用）、`no`（禁用） | `yes`  |


#### 版本标签说明

Bitnami 镜像标签遵循以下策略：
- **滚动标签**（如 `latest`）：指向最新稳定版本，自动更新。
- **不可变标签**（如 `0.70.0`）：固定版本，2025 年 8 月 28 日后迁移至 `bitnamilegacy` 仓库。

详情参见 [Bitnami 标签策略文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。


## 注意事项

### Bitnami 镜像目录调整通知（2025 年 8 月 28 日起）
- **仓库迁移**：所有现有镜像（含历史版本标签）将从 `docker.io/bitnami` 迁移至 `docker.io/bitnamilegacy`，不再更新。
- **免费 tier 变更**：免费用户仅可访问部分安全加固镜像，仅提供 `latest` 标签，适用于开发环境。
- **生产环境建议**：生产 workload 推荐使用 [Bitnami Secure Images 商业版](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)，包含全量应用目录、企业支持和长期更新。

详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


## 贡献与问题反馈

- **贡献代码**：通过 [bitnami/containers](https://github.com/bitnami/containers) 仓库提交 Pull Request。
- **问题反馈**：在 [GitHub Issues](https://github.com/bitnami/containers/issues/new/choose) 提交问题，建议按模板提供详细信息以加快处理。


## 许可证

本软件采用 Apache License 2.0 许可证。详情参见 [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0)。

> **商标说明**：本镜像由 Bitnami 打包，相关商标归各自公司所有，使用不代表附属或背书关系。
