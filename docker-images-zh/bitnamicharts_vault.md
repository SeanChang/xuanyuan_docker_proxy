---
image: bitnamicharts/vault
description: "Bitnami提供的HashiCorp Vault Helm chart，用于在Kubernetes集群上部署Vault——一款通过统一界面安全管理和访问密钥的工具，支持安全存储、动态密钥、数据加密及撤销功能。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/vault
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/vault
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/vault" title="bitnamicharts/vault Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/vault 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami HashiCorp Vault 软件包

Vault 是一款通过统一界面安全管理和访问密钥的工具，具备安全存储、动态密钥、数据加密和撤销等功能。

[HashiCorp Vault 概述](https://www.vaultproject.io/)

商标声明：本软件列表由 Bitnami 打包。产品中提及的相关商标归各自公司所有，使用这些商标并不意味着任何关联或认可。

## 快速入门

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/vault
```

希望在生产环境中使用 HashiCorp Vault？试试 [VMware Tanzu Application Catalog](https://bitnami.com/enterprise)，即 Bitnami 目录的商业版。

## ⚠️ 重要通知：Bitnami 目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共目录，在新的 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)下提供精选的强化、安全聚焦镜像集。作为此次转型的一部分：

- 首次向社区用户开放热门容器镜像的安全优化版本访问权限。
- Bitnami 将开始在免费层级中弃用对非强化、基于 Debian 的软件镜像的支持，并将逐步从公共目录中移除非最新标签。因此，社区用户将可访问数量减少的强化镜像，这些镜像仅以“latest”标签发布，适用于开发目的。
- 自 8 月 28 日起，在两周内，所有现有容器镜像（包括旧版本或特定版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用 Bitnami Secure Images，其中包括强化容器、更小的攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 以及企业支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提升所有 Bitnami 用户的安全态势。更多详情，请访问 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。

## 简介

本 chart 使用 [Helm](https://helm.sh) 包管理器在 [Kubernetes](https://kubernetes.io) 集群上引导部署 [HashiCorp Vault](https://github.com/bitnami/containers/tree/main/bitnami/vault)。

## 前提条件

- Kubernetes 1.23+
- Helm 3.8.0+

## 安装 Chart

要安装发布名称为 `my-release` 的 chart：

```console
helm install my-release my-repo/vault
```

该命令使用默认配置在 Kubernetes 集群上部署 Vault。[参数](#parameters) 部分列出了安装过程中可配置的参数。

> **提示**：使用 `helm list` 查看所有发布

## 配置和安装详情

### 资源请求和限制

Bitnami charts 允许为 chart 部署内的所有容器设置资源请求和限制，这些配置位于 `resources` 值中（参见参数表）。设置请求对于生产工作负载至关重要，应根据具体使用场景进行调整。

为简化此过程，chart 包含 `resourcesPreset` 值，可根据不同预设自动设置 `resources` 部分。有关这些预设的详细信息，请参见 [bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15)。但在生产工作负载中，不建议使用 `resourcesPreset`，因为它可能无法完全适应您的特定需求。有关容器资源管理的更多信息，请参阅 [Kubernetes 官方文档](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)。

### Prometheus 指标

通过将 `server.metrics.enabled` 设置为 `true`，本 chart 可与 Prometheus 集成。这将在服务中暴露 Vault 原生的 Prometheus 端点，并添加必要的注解以实现 Prometheus 自动抓取。

#### Prometheus 要求

要使集成正常工作，需在集群中安装 Prometheus 或 Prometheus Operator。安装 [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) 或 [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus)，可轻松在集群中部署可用的 Prometheus。

#### 与 Prometheus Operator 集成

本 chart 可部署 `ServiceMonitor` 对象，以与 Prometheus Operator 安装集成。为此，需将值 `server.metrics.serviceMonitor.enabled` 设置为 `true`。确保集群中已安装 Prometheus Operator `CustomResourceDefinitions`，否则将出现以下错误：

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

安装 [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) 可获取必要的 CRD 和 Prometheus Operator。

### [滚动标签与不可变标签](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

强烈建议在生产环境中使用不可变标签。这可确保如果相同标签更新为不同镜像时，部署不会自动更改。

如果主容器有新版本、重大变更或存在严重漏洞，Bitnami 将发布新的 chart 以更新其容器。

### Ingress

本 chart 支持 Ingress 资源。如果集群中安装了 Ingress 控制器（如 [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) 或 [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour)），可利用 Ingress 控制器提供应用服务。要启用 Ingress 集成，需将 `server.ingress.enabled` 设置为 `true`。

最常见的场景是将一个主机名映射到部署，此时可使用 `server.ingress.hostname` 属性设置主机名，使用 `server.ingress.tls` 参数添加该主机的 TLS 配置。

此外，也支持多个主机。为此，可通过设置 `server.ingress.extraHosts` 参数（如可用）指定主机名数组，并通过 `server.ingress.extraTLS` 参数（如可用）为额外主机添加 TLS 配置。

> 注意：对于 `server.ingress.extraHosts` 参数中指定的每个主机，需设置名称、路径以及 Ingress 控制器应了解的任何注解。并非所有注解都受所有 Ingress 控制器支持，但 [此注解参考文档](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) 列出了许多流行 Ingress 控制器支持的注解。

添加 TLS 参数（如可用）将使 chart 生成 HTTPS URL，应用将在 443 端口可用。TLS 密钥不必由本 chart 生成，但如果启用了 TLS，Ingress 记录需在 TLS 密钥存在后才能正常工作。

[了解更多关于 Ingress 控制器的信息](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)。

### TLS 密钥

本 chart 便于创建用于 Ingress 控制器的 TLS 密钥（尽管这不是必需的）。常见使用场景包括：

- 基于 chart 参数生成证书密钥。
- 启用外部生成的证书。
- 通过外部服务（如 [cert-manager](https://github.com/jetstack/cert-manager/)）管理应用证书。
- 在 chart 内创建自签名证书（如支持）。

在前两种情况下，需要证书和密钥，文件应为 `.pem` 格式。

证书文件示例：

> 注意：如果存在证书链，可能包含多个证书。

```text
-----BEGIN CERTIFICATE-----
MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
...
jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
-----END CERTIFICATE-----
```

证书密钥示例：

```text
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
...
wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
-----END RSA PRIVATE KEY-----
```

- 如果使用 Helm 基于参数管理证书，将这些值复制到 `*.ingress.secrets` 条目的 `certificate` 和 `key` 值中。
- 如果单独管理 TLS 密钥，需创建名称为 `INGRESS_HOSTNAME-tls` 的 TLS 密钥（其中 `INGRESS_HOSTNAME` 需替换为使用 `*.ingress.hostname` 参数设置的主机名）。
- 如果集群具有 [cert-manager](https://github.com/jetstack/cert-manager) 插件以自动管理和颁发 TLS 证书，需在 `*.ingress.annotations` 中添加 cert-manager 的 [相应注解](https://cert-manager.io/docs/usage/ingress/#supported-annotations)。
- 如果使用 Helm 创建的自签名证书，需将 `*.ingress.tls` 和 `*.ingress.selfSigned` 均设置为 `true`。

### 额外环境变量

如需添加额外环境变量（用于高级操作，如自定义初始化脚本），可在 `server`、`csiProvider` 和 `injector` 部分使用 `extraEnvVars` 属性。

```yaml
server:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

或者，可使用 ConfigMap 或 Secret 存储环境变量。为此，在 `server`、`csiProvider` 和 `injector` 部分使用 `extraEnvVarsCM` 或 `extraEnvVarsSecret` 值。

### 边车容器（Sidecars）

如需在 Vault 所在的 Pod 中添加额外容器（如额外的指标或日志导出器），可在 `server`、`csiProvider` 和 `injector` 部分使用 `sidecars` 参数定义。

```yaml
sidecars:
- name: your-image-name
  image: docker.xuanyuan.run/your-image
  imagePullPolicy: Always
  ports:
  - name: portname
    containerPort: 1234
```

如果这些边车容器暴露额外端口，可使用 `service.extraPorts` 参数（如可用）添加额外端口定义，示例如下：

```yaml
service:
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

> 注意：本 Helm chart 已包含 Prometheus 导出器的边车容器（如适用）。可在部署时添加 `--enable-metrics=true` 参数激活这些容器。`sidecars` 参数仅用于添加额外的边车容器。

如需在同一 Pod 中添加额外的初始化容器，可使用 `initContainers` 参数定义，示例如下：

```yaml
initContainers:
  - name: your-image-name
    image: docker.xuanyuan.run/your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

了解更多关于 [边车容器](https://kubernetes.io/docs/concepts/workloads/pods/) 和 [初始化容器](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) 的信息。

### Pod 亲和性

本 chart 允许使用 `affinity` 参数设置自定义亲和性。有关 Pod 亲和性的更多信息，请参阅 [Kubernetes 文档](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity)。

作为替代方案，可使用 [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart 中提供的 Pod 亲和性、Pod 反亲和性和节点亲和性预设配置。为此，在 `server`、`csiProvider` 和 `injector` 部分设置 `podAffinityPreset`、`podAntiAffinityPreset` 或 `nodeAffinityPreset` 参数。

### 备份和恢复

要在 Kubernetes 上备份和恢复 Helm chart 部署，需使用 [Velero](https://velero.io/)（一款 Kubernetes 备份/恢复工具）备份源部署的持久卷，并将其附加到新部署。有关使用 Velero 的说明，请参阅 [本指南](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html)。

## 持久性

[Bitnami vault](https://github.com/bitnami/containers/tree/main/bitnami/vault) 镜像将 vault 数据和配置存储在容器的 `/bitnami` 路径下。持久卷声明（Persistent Volume Claims）用于在部署之间保留数据，已知在 GCE、AWS 和 minikube 中可正常工作。

## 参数

### 全局参数

| 名称 | 描述 | 值 |
| --- | --- | --- |
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局 Docker 镜像仓库密钥名称数组 | `[]` |
| `global.defaultStorageClass` | 持久卷的全局默认 StorageClass | `""` |
| `global.storageClass` | 已弃用：使用 global.defaultStorageClass 替代 | `""` |
| `global.security.allowInsecureImages` | 允许跳过镜像验证 | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 调整部署的 securityContext 部分以使其与 OpenShift restricted-v2 SCC 兼容：移除 runAsUser、runAsGroup 和 fsGroup，让平台使用其允许的默认 ID。可能值：auto（如果检测到运行的集群是 OpenShift 则应用）、force（始终执行调整）、disabled（不执行调整） | `auto` |

### 通用参数

| 名称 | 描述 | 值 |
| --- | --- | --- |
| `kubeVersion` | 覆盖 Kubernetes 版本 | `""` |
| `nameOverride` | 部分覆盖 common.names.name 的字符串 | `""` |
| `fullnameOverride` | 完全覆盖 common.names.fullname 的字符串 | `""` |
| `namespaceOverride` | 完全覆盖 common.names.namespace 的字符串 | `""` |
| `commonLabels` | 添加到所有部署对象的标签 | `{}` |
| `commonAnnotations` | 添加到所有部署对象的注解 | `{}` |
| `clusterDomain` | Kubernetes 集群域名 | `cluster.local` |
| `extraDeploy` | 随发布一起部署的额外对象数组 | `[]` |
| `diagnosticMode.enabled` | 启用诊断模式（所有探针将被禁用，命令将被覆盖） | `false` |
| `diagnosticMode.command` | 覆盖部署中所有容器的命令 | `["sleep"]` |
| `diagnosticMode.args` | 覆盖部署中所有容器的参数 | `["infinity"]` |

### Vault Server 参数

| 名称 | 描述 | 值 |
| --- | --- | --- |
| `server.enabled` | 启用 Vault Server | `true` |
| `server.image.registry` | Vault Server 镜像仓库 | `REGISTRY_NAME` |
| `server.image.repository` | Vault Server 镜像仓库路径 | `REPOSITORY_NAME/vault` |
| `server.image.digest` | Vault Server 镜像摘要，格式为 sha256:aa.... 注意：如果设置此参数，将覆盖镜像标签（建议使用不可变标签） | `""` |
| `server.image.pullPolicy` | Vault Server 镜像拉取策略 | `IfNotPresent` |
| `server.image.pullSecrets` | Vault Server 镜像拉取密钥 | `[]` |
| `server.image.debug` | 启用 Vault Server 镜像调试模式 | `false` |
| `server.replicaCount` | 要部署的 Vault Server 副本数 | `1` |
| `server.podManagementPolicy` | Pod 管理策略 | `Parallel` |
| `server.containerPorts.http` | Vault Server HTTP 容器端口 | `8200` |
| `server.containerPorts.internal` | Vault Server 内部（HTTPS）容器端口 | `8201` |
| `server.livenessProbe.enabled` | 启用 Vault Server 容器的 livenessProbe | `false` |
| `server.livenessProbe.initialDelaySeconds` | livenessProbe 初始延迟秒数 | `5` |
| `server.livenessProbe.periodSeconds` | livenessProbe 周期秒数 | `10` |
| `server.livenessProbe.timeoutSeconds` | livenessProbe 超时秒数 | `5` |
| `server.livenessProbe.failureThreshold` | livenessProbe 失败阈值 | `5` |
| `server
