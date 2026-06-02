<!-- xuanyuan-docker-images-zh
image: bitnamicharts/kube-state-metrics
source: https://xuanyuan.cloud/zh/r/bitnamicharts/kube-state-metrics
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/kube-state-metrics
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [bitnamicharts/kube-state-metrics — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/bitnamicharts/kube-state-metrics "bitnamicharts/kube-state-metrics Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/bitnamicharts/kube-state-metrics

# Bitnami Kube State Metrics 镜像文档

## 镜像概述和主要用途

kube-state-metrics 是一个简单的服务，它监听 Kubernetes API 服务器并生成关于对象状态的指标。Bitnami 提供的此 Helm Chart 可在 Kubernetes 集群上轻松部署和配置 kube-state-metrics。

[Kube State Metrics 概述](https://github.com/kubernetes/kube-state-metrics)

**商标说明**：本软件列表由 Bitnami 打包。产品中提及的 respective 商标归 respective 公司所有，使用这些商标并不意味着任何关联或认可。

## 核心功能和特性

- 自动生成 Kubernetes 集群中各种资源对象的状态指标
- 高度可配置的资源监控范围
- 支持 RBAC 权限控制，确保安全访问 Kubernetes API
- 可自定义的资源请求和限制配置
- 支持添加 sidecar 和 init 容器
- 提供 Pod 亲和性和反亲和性配置选项
- 支持 Pod 中断预算 (PDB) 配置
- 兼容 OpenShift 环境

## 使用场景和适用范围

- Kubernetes 集群监控和可观测性平台构建
- 容器化应用的状态指标收集
- DevOps 和 SRE 团队监控 Kubernetes 资源利用率和健康状态
- 与 Prometheus、Grafana 等监控工具集成，构建完整监控解决方案
- 适用于开发、测试和生产环境

## 详细使用方法和配置说明

### 环境要求

- Kubernetes 1.23+
- Helm 3.8.0+

### 快速开始

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/kube-state-metrics
```

### 重要通知：Bitnami 镜像仓库即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共镜像仓库，在新的 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)下提供精选的强化安全镜像。此过渡包括：

- 首次向社区用户提供流行容器镜像的安全优化版本
- Bitnami 将开始在免费层级中弃用对非强化的 Debian 基础软件镜像的支持，并将逐步从公共仓库中移除非最新标签。因此，社区用户将只能访问数量减少的强化镜像，这些镜像仅以 "latest" 标签发布，适用于开发目的
- 从 8 月 28 日开始，在两周内，所有现有容器镜像（包括旧版本或特定版本标签，如 2.50.0、10.6）将从公共仓库 (docker.io/bitnami) 迁移到 "Bitnami Legacy" 仓库 (docker.io/bitnamilegacy)，并且不再接收更新
- 对于生产工作负载和长期支持，建议用户采用 Bitnami Secure Images，包括强化容器、更小的攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 和企业支持

### 安装 Chart

使用发布名称 `my-release` 安装 chart：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/kube-state-metrics
```

> 注意：需要将占位符 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 替换为 Helm chart 仓库和存储库的引用。例如，对于 Bitnami，应使用 `REGISTRY_NAME=registry-1.docker.io` 和 `REPOSITORY_NAME=bitnamicharts`。

该命令使用默认配置在 Kubernetes 集群上部署 kube-state-metrics。配置部分列出了可在安装过程中配置的参数。

### 配置与安装详情

#### 资源请求和限制

Bitnami charts 允许为 chart 部署中的所有容器设置资源请求和限制。这些配置位于 `resources` 值中（参见参数表）。设置请求对于生产工作负载至关重要，应根据具体使用情况进行调整。

为简化此过程，chart 包含 `resourcesPreset` 值，可根据不同预设自动设置 `resources` 部分。可在 [bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15) 中查看这些预设。然而，在生产工作负载中不建议使用 `resourcesPreset`，因为它可能无法完全适应您的特定需求。有关容器资源管理的更多信息，请参阅 [官方 Kubernetes 文档](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)。

#### 滚动标签与不可变标签

强烈建议在生产环境中使用不可变标签。这可确保如果相同标签使用不同镜像更新，部署不会自动更改。

如果主容器有新版本、重大更改或严重漏洞，Bitnami 将发布更新其容器的新 chart。

#### 备份和恢复

要在 Kubernetes 上备份和恢复 Helm chart 部署，需要从源部署备份持久卷，并使用 Kubernetes 备份/恢复工具 [Velero](https://velero.io/) 将它们附加到新部署。在 [本指南](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html) 中查找使用 Velero 的说明。

#### 使用 Sidecars 和 Init Containers

如果在同一个 pod 中需要额外的容器（例如额外的指标或日志导出器），可以使用 `sidecars` 配置参数定义它们。

```yaml
sidecars:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
    containerPort: 1234
```

如果这些 sidecars 导出额外的端口，可以使用 `service.extraPorts` 参数添加额外的端口定义（如果可用），如下例所示：

```yaml
service:
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

> 注意：此 Helm chart 已包含 Prometheus 导出器的 sidecar 容器（如适用）。可以在部署时添加 `--enable-metrics=true` 参数来激活它们。因此，`sidecars` 参数应仅用于任何额外的 sidecar 容器。

如果在同一个 pod 中需要额外的 init 容器，可以使用 `initContainers` 参数定义它们。以下是一个示例：

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

了解更多关于 [sidecar 容器](https://kubernetes.io/docs/concepts/workloads/pods/) 和 [init 容器](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) 的信息。

#### 设置 Pod 亲和性

此 chart 允许使用 `affinity` 参数设置自定义 Pod 亲和性。在 [Kubernetes 文档](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) 中查找有关 Pod 亲和性的更多信息。

作为替代方案，可以使用 [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart 中提供的 pod 亲和性、pod 反亲和性和节点亲和性的预设配置之一。为此，请设置 `podAffinityPreset`、`podAntiAffinityPreset` 或 `nodeAffinityPreset` 参数。

### 参数

#### 全局参数

| 名称 | 描述 | 值 |
|------|------|-----|
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局 Docker 镜像仓库密钥名称数组 | `[]` |
| `global.security.allowInsecureImages` | 允许跳过镜像验证 | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 调整部署的 securityContext 部分，使其与 Openshift restricted-v2 SCC 兼容：删除 runAsUser、runAsGroup 和 fsGroup，让平台使用其允许的默认 ID。可能的值：auto（如果检测到运行的集群是 Openshift，则应用），force（始终执行适配），disabled（不执行适配） | `auto` |

#### 通用参数

| 名称 | 描述 | 值 |
|------|------|-----|
| `kubeVersion` | 强制目标 Kubernetes 版本（如果未设置，则使用 Helm 功能） | `""` |
| `nameOverride` | 用于部分覆盖 `kube-state-metrics.name` 模板的字符串（将前置发布名称） | `""` |
| `fullnameOverride` | 用于完全覆盖 `kube-state-metrics.fullname` 模板的字符串 | `""` |
| `namespaceOverride` | 用于完全覆盖 common.names.namespace 的字符串 | `""` |
| `commonLabels` | 为所有部署的资源添加标签 | `{}` |
| `commonAnnotations` | 为所有部署的资源添加注释 | `{}` |
| `extraDeploy` | 要与发布一起部署的额外对象数组 | `[]` |
| `diagnosticMode.enabled` | 启用诊断模式（所有探针将被禁用，命令将被覆盖） | `false` |
| `diagnosticMode.command` | 用于覆盖 deployment(s)/statefulset(s) 中的所有容器的命令 | `["sleep"]` |
| `diagnosticMode.args` | 用于覆盖 deployment(s)/statefulset(s) 中的所有容器的参数 | `["infinity"]` |

#### kube-state-metrics 参数

| 名称 | 描述 | 值 |
|------|------|-----|
| `automountServiceAccountToken` | 在 pod 中挂载服务账户令牌 | `true` |
| `hostAliases` | 添加部署主机别名 | `[]` |
| `rbac.create` | 是否创建和使用 RBAC 资源 | `true` |
| `rbac.pspEnabled` | 是否创建 PodSecurityPolicy 并与 RBAC 绑定。警告：PodSecurityPolicy 在 Kubernetes v1.21 或更高版本中已弃用，在 v1.25 或更高版本中不可用 | `true` |
| `rbac.rules` | 要设置的自定义 RBAC 规则 | `[]` |
| `serviceAccount.create` | 指定是否应创建 ServiceAccount | `true` |
| `serviceAccount.name` | 要使用的服务账户名称。如果未设置且 create 为 true，则使用 fullname 模板生成名称 | `""` |
| `serviceAccount.automountServiceAccountToken` | 为服务器服务账户自动挂载服务账户令牌 | `false` |
| `serviceAccount.annotations` | 服务账户的注释。作为模板评估。仅在 `create` 为 `true` 时使用 | `{}` |
| `image.registry` | kube-state-metrics 镜像仓库 | `REGISTRY_NAME` |
| `image.repository` | kube-state-metrics 镜像仓库路径 | `REPOSITORY_NAME/kube-state-metrics` |
| `image.digest` | kube-state-metrics 镜像摘要，格式为 sha256:aa.... 请注意，如果设置此参数，将覆盖标签 | `""` |
| `image.pullPolicy` | kube-state-metrics 镜像拉取策略 | `IfNotPresent` |
| `image.pullSecrets` | 指定 docker-registry 密钥名称数组 | `[]` |
| `extraArgs` | 要传递给 kube-state-metrics 的额外命令行参数 | `{}` |
| `command` | 覆盖默认容器命令（在使用自定义镜像时有用） | `[]` |
| `args` | 覆盖默认容器参数（在使用自定义镜像时有用） | `[]` |
| `lifecycleHooks` | 用于 kube-state-metrics 容器的生命周期钩子，用于在启动前后自动配置 | `{}` |
| `extraEnvVars` | 要添加到 kube-state-metrics 节点的额外环境变量数组 | `[]` |
| `extraEnvVarsCM` | 包含 kube-state-metrics pod(s) 额外环境变量的现有 ConfigMap 名称 | `""` |
| `extraEnvVarsSecret` | 包含 kube-state-metrics pod(s) 额外环境变量的现有 Secret 名称 | `""` |
| `extraVolumes` | 可选地指定 kube-state-metrics pod(s) 的额外卷列表 | `[]` |
| `extraVolumeMounts` | 可选地指定 kube-state-metrics 容器的额外 volumeMounts 列表 | `[]` |
| `sidecars` | 向 kube-state-metrics pod(s) 添加额外的 sidecar 容器 | `[]` |
| `initContainers` | 向 kube-state-metrics pod(s) 添加额外的 init 容器 | `[]` |
| `pdb.create` | 启用/禁用 Pod 中断预算创建 | `true` |
| `pdb.minAvailable` | 应保持调度的最小 pod 数量/百分比 | `""` |
| `pdb.maxUnavailable` | 可能不可用的最大 pod 数量/百分比。如果 `pdb.minAvailable` 和 `pdb.maxUnavailable` 都为空，则默认为 `1` | `""` |
| `namespaces` | 要启用的命名空间的逗号分隔列表。默认为所有命名空间。作为模板评估 | `""` |
| `kubeResources.certificatesigningrequests` | 启用 `certificatesigningrequests` 资源监控 | `true` |
| `kubeResources.configmaps` | 启用 `configmaps` 资源监控 | `true` |
| `kubeResources.cronjobs` | 启用 `cronjobs` 资源监控 | `true` |
| `kubeResources.daemonsets` | 启用 `daemonsets` 资源监控 | `true` |
| `kubeResources.deployments` | 启用 `deployments` 资源监控 | `true` |
| `kubeResources.endpoints` | 启用 `endpoints` 资源监控 | `true` |
| `kubeResources.horizontalpodautoscalers` | 启用 `horizontalpodautoscalers` 资源监控 | `true` |
| `kubeResources.ingresses` | 启用 `ingresses` 资源监控 | `true` |
| `kubeResources.jobs` | 启用 `jobs` 资源监控 | `true` |
| `kubeResources.leases` | 启用 `leases` 资源监控 | `true` |
| `kubeResources.limitranges` | 启用 `limitranges` 资源监控 | `true` |

> 注意：此 chart 的完整 README 超出了 DockerHub 的 25000 字符限制，因此已被截断。完整 README 可在 https://github.com/bitnami/charts/blob/main/bitnami/kube-state-metrics/README.md 找到。
