---
image: bitnamicharts/jaeger
description: "Bitnami提供的Jaeger分布式追踪系统Helm chart，用于在Kubernetes环境中便捷部署和管理Jaeger服务。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/jaeger
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/jaeger
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/jaeger" title="bitnamicharts/jaeger Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/jaeger 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Jaeger Helm Chart 文档

## 镜像概述和主要用途

Jaeger 是一个分布式追踪系统，用于监控和排查基于微服务的分布式系统。Bitnami 提供的此 Helm Chart 可在 Kubernetes 集群上快速部署和配置 Jaeger，简化分布式追踪能力的集成过程。

[Jaeger 官方概述](https://jaegertracing.io/)

**商标说明**：本软件列表由 Bitnami 打包。所提及的商标分属各自公司所有，使用此类商标不意味着任何关联或背书。


## 核心功能和特性

### Jaeger 核心功能
- 分布式追踪：跟踪请求在微服务间的流转路径
- 性能监控：识别系统瓶颈和性能问题
- 根因分析：定位分布式系统中的故障源头
- 服务依赖图谱：可视化微服务间的调用关系
- 上下文传播：跨服务传递追踪上下文信息

### Bitnami Chart 特性
- 简化部署：通过 Helm 一键部署 Jaeger 组件
- 灵活配置：支持自定义参数、外部数据库集成
- 安全合规：支持私有镜像仓库、安全上下文配置
- 可扩展性：支持副本集配置、资源按需调整
- 监控集成：兼容 Prometheus 指标采集（需启用指标支持）


## 使用场景和适用范围

### 适用场景
- 微服务架构的分布式系统监控
- 分布式事务追踪与故障排查
- 性能瓶颈分析与系统优化
- 服务依赖关系可视化
- 开发、测试及生产环境的分布式追踪需求

### 适用范围
- Kubernetes 集群环境（1.23+ 版本）
- 需要分布式追踪能力的微服务应用
- 对系统可观测性有较高要求的业务场景


## 前提条件

- Kubernetes 集群版本 1.23+
- Helm 版本 3.8.0+
- 底层基础设施支持持久卷（PV）供应
- 支持 ReadWriteMany 访问模式的存储卷（用于部署扩展）


## 详细使用方法和配置说明

### 快速开始（TL;DR）

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/jaeger
```

**生产环境建议**：如需在生产环境使用 Jaeger，建议尝试 [VMware Tanzu Application Catalog](https://bitnami.com/enterprise)（Bitnami 目录的商业版本）。


### 安装 Chart

使用以下命令安装名为 `my-release` 的 Chart：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/jaeger
```

> **注意**：需将占位符 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 替换为实际的 Helm Chart 仓库地址。例如，Bitnami 官方仓库需使用 `REGISTRY_NAME=registry-1.docker.io` 和 `REPOSITORY_NAME=bitnamicharts`。

上述命令将以默认配置在 Kubernetes 集群部署 Jaeger。可通过 [配置参数](#配置参数) 部分自定义部署选项。

> **提示**：使用 `helm list` 命令查看所有已安装的 release。


### 卸载 Chart

卸载名为 `my-release` 的部署：

```console
helm delete my-release
```

该命令将移除与 Chart 关联的所有 Kubernetes 资源并删除 release。如需同时删除所有历史记录，可添加 `--purge` 选项。


### 配置与部署详情

#### 资源请求与限制

Bitnami Charts 允许为部署中的所有容器设置资源请求和限制，通过 `resources` 参数配置（详见参数表）。生产环境中建议显式设置资源请求，以适配具体业务需求。

Chart 提供 `resourcesPreset` 参数，可根据预设自动配置 `resources` 部分（预设定义见 [bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15)）。但生产环境不建议依赖 `resourcesPreset`，因其可能无法完全适配实际需求。更多容器资源管理信息参见 [Kubernetes 官方文档](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)。


#### 滚动标签与不可变标签

生产环境强烈建议使用不可变标签，确保部署不会因标签指向的镜像更新而自动变更。Bitnami 会在主容器更新、重大变更或存在严重漏洞时，发布新的 Chart 以更新容器镜像。

[滚动标签与不可变标签详解](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)


#### 外部数据库支持

可配置 Jaeger 连接外部数据库（而非在集群内安装），适用于使用托管数据库服务或共享数据库服务器的场景。通过 `externalDatabase` 参数指定外部数据库凭证，并禁用内置 Cassandra：

```yaml
cassandra.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.port=9042
```

**注意**：需在部署前在外部 Cassandra 数据库中创建 Jaeger 键空间，否则 Jaeger 无法初始化。


#### 额外环境变量

如需为 Jaeger 组件添加额外环境变量（如自定义初始化脚本），可通过 `collector` 和 `query` 子部分的 `extraEnvVars` 参数配置：

```yaml
collector:
  extraEnvVars:
    - name: ENV_VAR_NAME
      value: ENV_VAR_VALUE

query:
  extraEnvVars:
    - name: ENV_VAR_NAME
      value: ENV_VAR_VALUE
```

也可通过现有 ConfigMap 或 Secret 注入环境变量，分别使用 `extraEnvVarsCM` 或 `extraEnvVarsSecret` 参数指定资源名称。


#### 边车容器与初始化容器

如需在 Jaeger Pod 中添加额外容器（如指标或日志导出器），可通过 `collector`、`query` 等子部分的 `sidecars` 参数定义边车容器：

```yaml
sidecars:
- name: your-image-name
  image: docker.xuanyuan.run/your-image
  imagePullPolicy: Always
  ports:
  - name: portname
    containerPort: 1234
```

如需暴露边车容器的额外端口，可通过 `service.extraPorts` 参数添加端口定义：

```yaml
service:
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

> **注意**：本 Helm Chart 已包含 Prometheus 导出器边车容器（需通过 `--enable-metrics=true` 启用）。`sidecars` 参数仅用于添加额外边车容器。

如需添加初始化容器，通过 `initContainers` 参数定义：

```yaml
initContainers:
  - name: your-image-name
    image: docker.xuanyuan.run/your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

更多边车容器和初始化容器信息参见 [Kubernetes 官方文档](https://kubernetes.io/docs/concepts/workloads/pods/)。


#### Pod 亲和性配置

可通过 `affinity` 参数自定义 Pod 亲和性规则，详情参见 [Kubernetes 亲和性文档](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity)。

也可使用 [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) Chart 提供的预设配置（Pod 亲和性、反亲和性、节点亲和性），通过 `distributor`、`compactor`、`ingester`、`querier`、`queryFrontend` 和 `vulture` 子部分的 `podAffinityPreset`、`podAntiAffinityPreset` 或 `nodeAffinityPreset` 参数启用。


#### 备份与恢复

如需备份和恢复 Kubernetes 上的 Helm Chart 部署，需通过 [Velero](https://velero.io/)（Kubernetes 备份/恢复工具）备份源部署的持久卷，并将其挂载到新部署。操作指南参见 [Velero 使用文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html)。


#### 持久化

[Bitnami Jaeger 镜像](https://github.com/bitnami/containers/tree/main/bitnami/jaeger) 将追踪数据存储在外部数据库中，通过持久卷声明（Persistent Volume Claims）保证数据在部署间的持久性。


## 配置参数

### 全局参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局 Docker 仓库密钥名称数组 | `[]` |
| `global.defaultStorageClass` | 持久卷的全局默认存储类 | `""` |
| `global.security.allowInsecureImages` | 允许跳过镜像验证 | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 调整 securityContext 以适配 OpenShift restricted-v2 SCC（移除 runAsUser、runAsGroup 和 fsGroup，由平台使用默认 ID）。可选值：auto（自动检测 OpenShift 集群时应用）、force（强制应用）、disabled（禁用） | `auto` |


### 通用参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `nameOverride` | 部分覆盖 common.names.fullname 的字符串 | `""` |
| `fullnameOverride` | 完全覆盖 common.names.fullname 的字符串 | `""` |
| `kubeVersion` | 强制指定目标 Kubernetes 版本（未设置则使用 Helm 能力检测） | `""` |
| `commonLabels` | 添加到所有部署对象的标签（不包含子 Chart） | `{}` |
| `commonAnnotations` | 添加到所有部署对象的注解 | `{}` |
| `diagnosticMode.enabled` | 启用诊断模式（禁用所有探针并覆盖命令） | `false` |
| `diagnosticMode.command` | 覆盖部署中所有容器的命令 | `["sleep"]` |
| `diagnosticMode.args` | 覆盖部署中所有容器的参数 | `["infinity"]` |


### Jaeger 参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `image.registry` | Jaeger 镜像仓库 | `REGISTRY_NAME` |
| `image.repository` | Jaeger 镜像仓库路径 | `REPOSITORY_NAME/jaeger` |
| `image.digest` | Jaeger 镜像摘要（格式：sha256:aa....，设置后将覆盖标签） | `""` |
| `image.pullPolicy` | 镜像拉取策略 | `IfNotPresent` |
| `image.pullSecrets` | Jaeger 镜像拉取密钥 | `[]` |
| `image.debug` | 启用镜像调试模式 | `false` |


### 查询部署参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `query.command` | 容器运行命令（未设置则使用默认，数组格式） | `[]` |
| `query.args` | 容器运行参数（未设置则使用默认，数组格式） | `[]` |
| `query.automountServiceAccountToken` | 在 Pod 中挂载服务账户令牌 | `false` |
| `query.hostAliases` | 设置 Pod 的 hostAliases | `[]` |
| `query.lifecycleHooks` | 覆盖默认容器生命周期钩子 | `{}` |
| `query.extraEnvVars` | 额外环境变量 | `[]` |
| `query.extraEnvVarsCM` | 包含额外环境变量的现有 ConfigMap 名称 | `""` |
| `query.extraEnvVarsSecret` | 包含额外环境变量的现有 Secret 名称 | `""` |
| `query.replicaCount` | Jaeger 查询组件副本数 | `1` |
| `query.livenessProbe.enabled` | 启用查询节点的存活探针 | `true` |
| `query.livenessProbe.initialDelaySeconds` | 存活探针初始延迟秒数 | `10` |
| `query.livenessProbe.periodSeconds` | 存活探针周期秒数 | `10` |
| `query.livenessProbe.timeoutSeconds` | 存活探针超时秒数 | `1` |
| `query.livenessProbe.failureThreshold` | 存活探针失败阈值 | `3` |
| `query.livenessProbe.successThreshold` | 存活探针成功阈值 | `1` |
| `query.startupProbe.enabled` | 启用查询容器的启动探针 | `false` |
| `query.startupProbe.initialDelaySeconds` | 启动探针初始延迟秒数 | `10` |
| `query.startupProbe.periodSeconds` | 启动探针周期秒数 | `10` |
| `query.startupProbe.timeoutSeconds` | 启动探针超时秒数 | `1` |
| `query.startupProbe.failureThreshold` | 启动探针失败阈值 | `15` |
| `query.startupProbe.successThreshold` | 启动探针成功阈值 | `1` |
| `query.readinessProbe.enabled` | 启用就绪探针 | `true` |
| `query.readinessProbe.initialDelaySeconds` | 就绪探针初始延迟秒数 | `10` |
| `query.readinessProbe.periodSeconds` | 就绪探针周期秒数 | `10` |
| `query.readinessProbe.timeoutSeconds` | 就绪探针超时秒数 | `1` |
| `query.readinessProbe.failureThreshold` | 就绪探针失败阈值 | `15` |
| `query.readinessProbe.successThreshold` | 就绪探针成功阈值 | `1` |
| `query.customLivenessProbe` | 自定义存活探针（覆盖默认） | `{}` |
| `query.customStartupProbe` | 自定义启动探针（覆盖默认） | `{}` |
| `query.customReadinessProbe` | 自定义就绪探针（覆盖默认） | `{}` |


> **注意**：本 Chart 的完整 README 超出 DockerHub 25000 字符限制，已被截断。完整文档参见 [GitHub](https://github.com/bitnami/charts/blob/main/bitnami/jaeger/README.md)。


## ⚠️ 重要通知：Bitnami 目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共目录，通过新的 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications) 提供精选的强化安全镜像。过渡期安排如下：

- 首次向社区用户开放热门容器镜像的安全优化版本。
- Bitnami 将开始弃用免费层中非强化的 Debian 基础镜像，并逐步从公共目录中移除非最新标签。社区用户将只能访问数量减少的强化镜像，且仅发布 "latest" 标签，适用于开发场景。
- 8 月 28 日起，两周内所有现有容器镜像（包括旧版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至 "Bitnami Legacy" 仓库（docker.io/bitnamilegacy），且不再接收更新。
- 生产环境和长期支持建议采用 Bitnami Secure Images，包含强化容器、更小攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 和企业支持。

这些变更旨在通过推广软件供应链完整性最佳实践和最新部署，提升所有 Bitnami 用户的安全态势。更多详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


## 使用场景和适用范围

- **开发环境**：快速集成分布式追踪能力，调试微服务交互问题。
- **测试环境**：验证系统在分布式场景下的稳定性和性能。
- **生产环境**：监控关键业务流程，实时排查线上故障（建议配合 Bitnami Secure Images 以获得长期支持）。

适用于所有基于微服务架构的分布式系统，尤其是需要追踪请求流、分析性能瓶颈或定位跨服务故障的场景。
