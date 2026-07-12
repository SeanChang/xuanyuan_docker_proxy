---
image: bitnamicharts/nginx-ingress-controller
description: "Bitnami Helm 图表，用于在 Kubernetes 集群中部署 NGINX Ingress Controller，管理 HTTP 服务的外部访问。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/nginx-ingress-controller
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/nginx-ingress-controller
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/nginx-ingress-controller" title="bitnamicharts/nginx-ingress-controller Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/nginx-ingress-controller 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami 软件包：NGINX Ingress Controller

NGINX Ingress Controller 是一款 Ingress 控制器，用于通过 NGINX 管理 Kubernetes 集群中 HTTP 服务的外部访问。

[NGINX Ingress Controller 概述](https://kubernetes.github.io/ingress-nginx/)

商标声明：本软件列表由 Bitnami 打包。所提及的相关商标归各自公司所有，使用这些商标并不意味着任何关联或背书。

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/nginx-ingress-controller
```

希望在生产环境中使用 NGINX Ingress Controller？请尝试 [VMware Tanzu Application Catalog](https://bitnami.com/enterprise)，即 Bitnami 目录的商业版。

## ⚠️ 重要通知：Bitnami 目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共目录，通过新的 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications) 提供精选的强化、安全聚焦镜像集。作为此次过渡的一部分：

- 首次向社区用户开放热门容器镜像的安全优化版本访问权限。
- Bitnami 将开始在免费层级中弃用对非强化、基于 Debian 的软件镜像的支持，并将逐步从公共目录中移除非最新标签。因此，社区用户将只能访问数量减少的强化镜像。这些镜像仅以“latest”标签发布，适用于开发目的。
- 自 8 月 28 日起，在两周内，所有现有容器镜像（包括旧版或特定版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用 Bitnami Secure Images，包括强化容器、更小的攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 以及企业支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提升所有 Bitnami 用户的安全态势。更多详情，请访问 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。

## 简介

Bitnami Helm 图表经过精心设计、积极维护，是在 Kubernetes 集群上部署容器的最快、最简单方式，可直接用于处理生产工作负载。

本图表使用 [Helm](https://helm.sh) 包管理器在 [Kubernetes](https://kubernetes.io) 集群上引导 [ingress-nginx](https://github.com/kubernetes/ingress-nginx) 部署。

## 前提条件

- Kubernetes 1.23+
- Helm 3.8.0+

## 安装图表

要使用发布名称 `my-release` 安装图表，请执行：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/nginx-ingress-controller
```

> 注意：您需要将占位符 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 替换为 Helm 图表仓库和存储库的引用。例如，对于 Bitnami，需使用 `REGISTRY_NAME=registry-1.docker.io` 和 `REPOSITORY_NAME=bitnamicharts`。

这些命令将以默认配置在 Kubernetes 集群上部署 nginx-ingress-controller。

> **提示**：使用 `helm list` 列出所有发布。

## 配置与安装详情

### 资源请求与限制

Bitnami 图表允许为图表部署内的所有容器设置资源请求和限制，这些配置位于 `resources` 值中（参见参数表）。设置请求对于生产工作负载至关重要，应根据具体使用场景进行调整。

为简化此过程，图表包含 `resourcesPreset` 值，可根据不同预设自动设置 `resources` 部分。有关这些预设的详情，请参见 [bitnami/common 图表](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15)。但在生产工作负载中，不建议使用 `resourcesPreset`，因为它可能无法完全适应您的特定需求。有关容器资源管理的更多信息，请参见 [Kubernetes 官方文档](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)。

### Prometheus 指标

通过将 `metrics.enabled` 设置为 `true`，可将本图表与 Prometheus 集成。这将公开 nginx-ingress-controller 原生 Prometheus 端点和 `metrics` 服务，后者可通过 `metrics.service` 部分进行配置，并包含自动被 Prometheus 抓取所需的注解。

#### Prometheus 要求

需安装 Prometheus 或 Prometheus Operator 才能使集成生效。安装 [Bitnami Prometheus Helm 图表](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) 或 [Bitnami Kube Prometheus Helm 图表](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus)，即可轻松在集群中部署可用的 Prometheus。

#### 与 Prometheus Operator 集成

本图表可部署 `ServiceMonitor` 对象以与 Prometheus Operator 集成。需将 `metrics.serviceMonitor.enabled` 设置为 `true`。确保集群中已安装 Prometheus Operator `CustomResourceDefinitions`，否则将失败并显示以下错误：

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

安装 [Bitnami Kube Prometheus Helm 图表](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) 以获取必要的 CRD 和 Prometheus Operator。

### 滚动标签与不可变标签

[滚动标签与不可变标签](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

强烈建议在生产环境中使用不可变标签。这可确保即使相同标签的镜像更新，部署也不会自动变更。

如果主容器有新版本、重大变更或存在严重漏洞，Bitnami 将发布新图表以更新其容器。

### 备份与恢复

要在 Kubernetes 上备份和恢复 Helm 图表部署，需使用 Kubernetes 备份/恢复工具 [Velero](https://velero.io/) 备份源部署的持久卷，并将其附加到新部署。有关使用 Velero 的说明，请参见 [此指南](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html)。

### Sidecar 容器和 Init 容器

如果需要在 NGINX Ingress Controller 所在的 Pod 中运行额外容器（例如，额外的指标或日志导出器），可通过 `sidecars` 配置参数实现。只需根据 Kubernetes 容器规范定义容器：

```yaml
sidecars:
  - name: your-image-name
    image: docker.xuanyuan.run/your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

类似地，可使用 `initContainers` 参数添加额外的 init 容器：

```yaml
initContainers:
  - name: your-image-name
    image: docker.xuanyuan.run/your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

### 部署额外资源

有时可能需要部署额外对象（如包含应用配置的 ConfigMap 或微服务的额外部署），本图表允许通过 `extraDeploy` 参数添加其他对象的完整规范。

### 设置 Pod 亲和性

本图表允许通过 `affinity` 参数设置自定义亲和性。有关 Pod 亲和性的更多信息，请参见 [Kubernetes 文档](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity)。

作为替代方案，可使用 [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) 图表中提供的 Pod 亲和性、Pod 反亲和性和节点亲和性预设配置。为此，需设置 `podAffinityPreset`、`podAntiAffinityPreset` 或 `nodeAffinityPreset` 参数。

## 参数

### 全局参数

| 名称 | 描述 | 值 |
|------|------|------|
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局 Docker 仓库密钥名称数组 | `[]` |
| `global.security.allowInsecureImages` | 允许跳过镜像验证 | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 调整部署的 securityContext 部分以使其与 OpenShift restricted-v2 SCC 兼容：移除 runAsUser、runAsGroup 和 fsGroup，让平台使用允许的默认 ID。可能的值：auto（如果检测到运行的集群是 OpenShift 则应用）、force（始终执行调整）、disabled（不执行调整） | `auto` |

### 通用参数

| 名称 | 描述 | 值 |
|------|------|------|
| `kubeVersion` | 强制目标 Kubernetes 版本（未设置则使用 Helm 能力检测） | `""` |
| `nameOverride` | 部分覆盖 common.names.fullname 的字符串 | `""` |
| `fullnameOverride` | 完全覆盖 common.names.fullname 的字符串 | `""` |
| `namespaceOverride` | 完全覆盖 common.names.namespace 的字符串 | `""` |
| `commonLabels` | 为所有部署的资源添加标签 | `{}` |
| `commonAnnotations` | 为所有部署的资源添加注解 | `{}` |
| `extraDeploy` | 随发布一起部署的额外对象数组 | `[]` |
| `clusterDomain` | Kubernetes 集群域名 | `cluster.local` |

### NGINX Ingress Controller 参数

| 名称 | 描述 | 值 |
|------|------|------|
| `image.registry` | NGINX Ingress Controller 镜像仓库 | `REGISTRY_NAME` |
| `image.repository` | NGINX Ingress Controller 镜像存储库 | `REPOSITORY_NAME/nginx-ingress-controller` |
| `image.digest` | NGINX Ingress Controller 镜像摘要，格式为 sha256:aa.... 注意：如果设置此参数，将覆盖标签 | `""` |
| `image.pullPolicy` | NGINX Ingress Controller 镜像拉取策略 | `IfNotPresent` |
| `image.pullSecrets` | 镜像拉取密钥名称数组 | `[]` |
| `containerPorts.http` | NGINX Ingress Controller HTTP 端口 | `8080` |
| `containerPorts.https` | NGINX Ingress Controller HTTPS 端口 | `8443` |
| `containerPorts.defaultServer` | NGINX Ingress Controller 默认服务器端口 | `8181` |
| `containerPorts.metrics` | NGINX Ingress Controller 指标端口 | `10254` |
| `containerPorts.profiler` | NGINX Ingress Controller 分析器端口 | `10245` |
| `containerPorts.status` | NGINX Ingress Controller 状态端口 | `10246` |
| `containerPorts.stream` | NGINX Ingress Controller 流端口 | `10247` |
| `automountServiceAccountToken` | 在 Pod 中挂载服务账户令牌 | `true` |
| `hostAliases` | 部署 Pod 的主机别名 | `[]` |
| `config` | NGINX 的自定义配置选项 | `{}` |
| `proxySetHeaders` | 发送流量到后端前的自定义头 | `{}` |
| `addHeaders` | 发送响应流量到客户端前的自定义头 | `{}` |
| `defaultBackendService` | 默认 404 后端服务；仅当 `defaultBackend.enabled = false` 时需要 | `""` |
| `electionID` | 用于状态更新的选举 ID | `ingress-controller-leader` |
| `allowSnippetAnnotations` | 允许用户设置片段注解 | `false` |
| `reportNodeInternalIp` | 如果使用 `hostNetwork=true`，设置 `reportNodeInternalIp=true` 将向 NGINX Ingress Controller 传递 `report-node-internal-ip-address` 标志 | `false` |
| `watchIngressWithoutClass` | 处理没有 ingressClass 注解/ingressClassName 字段的 Ingress 对象 | `false` |
| `ingressClassResource.name` | IngressClass 资源名称 | `nginx` |
| `ingressClassResource.enabled` | 创建 IngressClass 资源 | `true` |
| `ingressClassResource.default` | 将创建的 IngressClass 资源设为默认类 | `false` |
| `ingressClassResource.controllerClass` | 控制器的 IngressClass 标识符 | `k8s.io/ingress-nginx` |
| `ingressClassResource.parameters` | 控制器的可选参数 | `{}` |
| `publishService.enabled` | 在 Ingress 对象上设置端点记录以反映服务上的端点 | `false` |
| `publishService.pathOverride` | 允许覆盖要绑定的发布服务 | `""` |
| `scope.enabled` | 限制控制器的作用域 | `false` |
| `scope.namespace` | 作用域命名空间。默认为 `.Release.Namespace` | `""` |
| `configMapNamespace` | 允许自定义 configmap/nginx-configmap 的命名空间 | `""` |
| `tcpConfigMapNamespace` | 允许自定义 tcp-services-configmap 的命名空间 | `""` |
| `udpConfigMapNamespace` | 允许自定义 udp-services-configmap 的命名空间 | `""` |
| `maxmindLicenseKey` | 用于下载 Geolite2 数据库的许可证密钥 | `""` |
| `dhParam` | base64 编码的 Diffie-Hellman 参数 | `""` |
| `tcp` | TCP 服务键值对 | `{}` |
| `udp` | UDP 服务键值对 | `{}` |
| `svcPortNamesPrefix` | Ingress 控制器服务中 TCP 和 UDP 端口名称的前缀 | `""` |
| `command` | 覆盖默认容器命令（使用自定义镜像时有用） | `[]` |
| `args` | 覆盖默认容器参数（使用自定义镜像时有用） | `[]` |
| `lifecycleHooks` | 为 %%MAIN_CONTAINER_NAME%% 容器自动配置启动前后操作 | `{}` |
| `extraArgs` | 传递给 nginx-ingress-controller 的额外命令行参数 | `{}` |
| `extraEnvVars` | 要在 NGINX Ingress 容器上设置的额外环境变量 | `[]` |
| `extraEnvVarsCM` | 包含额外环境变量的现有 ConfigMap 名称 | `""` |
| `extraEnvVarsSecret` | 包含额外环境变量的现有 Secret 名称 | `""` |

### NGINX Ingress 部署/守护进程集参数

| 名称 | 描述 | 值 |
|------|------|------|
| `kind` | 安装为 Deployment 或 DaemonSet | `Deployment` |
| `daemonset.useHostPort` | 如果 `kind` 是 `DaemonSet`，是否使用主机端口 | `false` |

注意：本图表的 README 超出了 DockerHub 25000 字符的长度限制，因此已被截断。完整 README 可参见 https://github.com/bitnami/charts/blob/main/bitnami/nginx-ingress-controller/README.md
