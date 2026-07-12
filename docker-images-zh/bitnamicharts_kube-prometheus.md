---
image: bitnamicharts/kube-prometheus
description: "Bitnami的Prometheus Operator Helm图表，用于在Kubernetes上提供简单的监控定义，以及Prometheus实例的部署和管理，包含Prometheus、Alertmanager等组件，便于快速搭建Kubernetes监控系统。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/kube-prometheus
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/kube-prometheus
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/kube-prometheus" title="bitnamicharts/kube-prometheus Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/kube-prometheus 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Prometheus Operator 软件包

Prometheus Operator为Kubernetes服务提供简单的监控定义，并支持Prometheus实例的部署和管理。

[Prometheus Operator 概述](https://github.com/coreos/prometheus-operator)

商标声明：本软件列表由Bitnami打包。产品中提及的 respective 商标归各自公司所有，使用这些商标并不意味着任何关联或背书。

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/kube-prometheus
```

> 提示：您知道此应用也可作为Azure Marketplace上的Kubernetes应用使用吗？Kubernetes应用是在AKS上部署Bitnami的最简单方式。点击[此处](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/bitnami.prometheus-operator-cnab)查看Azure Marketplace上的列表。

希望在生产环境中使用Prometheus Operator？试试[VMware Tanzu Application Catalog](https://bitnami.com/enterprise)，这是Bitnami目录的商业版。

## ⚠️ 重要通知：Bitnami目录即将发生的变更

自2025年8月28日起，Bitnami将改进其公共目录，在新的[Bitnami Secure Images计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)下提供精选的强化、安全聚焦镜像集。作为此次过渡的一部分：

- 首次向社区用户提供流行容器镜像的安全优化版本访问权限。
- Bitnami将开始在其免费层级中弃用对非强化、基于Debian的软件镜像的支持，并将逐步从公共目录中移除非最新标签。因此，社区用户将只能访问数量减少的强化镜像。这些镜像仅以“latest”标签发布，适用于开发目的。
- 从8月28日开始，在两周内，所有现有容器镜像（包括旧版本或特定版本标签，如2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移到“Bitnami Legacy”仓库（docker.io/bitnamilegacy），迁移后将不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用Bitnami Secure Images，其中包括强化容器、更小的攻击面、CVE透明度（通过VEX/KEV）、SBOM以及企业支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提高所有Bitnami用户的安全态势。有关更多详情，请访问[Bitnami Secure Images公告](https://github.com/bitnami/containers/issues/83267)。

## 介绍

此图表使用[Helm](https://helm.sh)包管理器在[Kubernetes](https://kubernetes.io)上引导[Prometheus Operator](https://github.com/bitnami/containers/tree/main/bitnami/prometheus-operator)部署。

在默认配置下，该图表会在Kubernetes集群上部署以下组件：

- [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator)
- [Prometheus](https://github.com/prometheus/prometheus/)
- [Alertmanager](https://github.com/prometheus/alertmanager)

> **:warning: 重要**

集群中应只运行一个Prometheus Operator组件实例。如果您希望部署此图表以**管理集群中的多个Prometheus实例**，则**必须禁用**Prometheus Operator组件的安装，使用`operator.enabled=false`图表安装参数。

## 前提条件

- Kubernetes 1.23+
- Helm 3.8.0+

## 安装图表

要安装发布名称为`my-release`的图表：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/kube-prometheus
```

> 注意：您需要将占位符`REGISTRY_NAME`和`REPOSITORY_NAME`替换为Helm图表仓库和存储库的引用。例如，对于Bitnami，需使用`REGISTRY_NAME=registry-1.docker.io`和`REPOSITORY_NAME=bitnamicharts`。

该命令会以默认配置在Kubernetes集群上部署kube-prometheus。[配置](#configuration-and-installation-details)部分列出了安装过程中可配置的参数。

> **提示**：使用`helm list`列出所有发布

## 配置和安装详情

### 资源请求和限制

Bitnami图表允许为图表部署中的所有容器设置资源请求和限制。这些设置位于`resources`值中（参见参数表）。为生产工作负载设置请求至关重要，应根据您的具体用例进行调整。

为简化此过程，图表包含`resourcesPreset`值，可根据不同预设自动设置`resources`部分。查看[bitnami/common图表](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15)中的这些预设。但是，在生产工作负载中不建议使用`resourcesPreset`，因为它可能无法完全适应您的特定需求。有关容器资源管理的更多信息，请参见[官方Kubernetes文档](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)。

### [滚动标签与不可变标签](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

强烈建议在生产环境中使用不可变标签。这样可确保如果同一标签使用不同镜像更新，您的部署不会自动更改。

如果主容器有新版本、重大变更或严重漏洞，Bitnami将发布新图表更新其容器。

### 额外抓取配置

以下值已被弃用。请参见下面的[升级](#upgrading)部分。

```console
prometheus.additionalScrapeConfigsExternal.enabled
prometheus.additionalScrapeConfigsExternal.name
prometheus.additionalScrapeConfigsExternal.key
```

通过将`prometheus.additionalScrapeConfigs.enabled`设置为`true`并将`prometheus.additionalScrapeConfigs.type`设置为`external`，可以通过Secret注入外部管理的抓取配置。该Secret必须存在于与图表部署相同的命名空间中。使用参数`prometheus.additionalScrapeConfigs.external.name`设置Secret名称，并使用`prometheus.additionalScrapeConfigs.external.key`设置包含额外抓取配置的键。

```text
prometheus.additionalScrapeConfigs.enabled=true
prometheus.additionalScrapeConfigs.type=external
prometheus.additionalScrapeConfigs.external.name=kube-prometheus-prometheus-scrape-config
prometheus.additionalScrapeConfigs.external.key=additional-scrape-configs.yaml
```

还可以通过将`prometheus.additionalScrapeConfigs.enabled`设置为`true`并将`prometheus.additionalScrapeConfigs.type`设置为`internal`，定义由Helm图表管理的抓取配置。然后可以使用`prometheus.additionalScrapeConfigs.internal.jobList`定义Prometheus的额外抓取任务列表。

```text
prometheus.additionalScrapeConfigs.enabled=true
prometheus.additionalScrapeConfigs.type=internal
prometheus.additionalScrapeConfigs.internal.jobList=
      - job_name: 'opentelemetry-collector'
        # metrics_path默认为'/metrics'
        # scheme默认为'http'。
        static_configs:
          - targets: ['opentelemetry-collector:8889']
```

有关更多信息，请参见[额外抓取配置文档](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/additional-scrape-config.md)。

### 额外告警重标签配置

通过将`prometheus.additionalAlertRelabelConfigsExternal.enabled`设置为`true`，可以通过Secret注入外部管理的Prometheus告警重标签配置。该Secret必须存在于与图表部署相同的命名空间中。

使用参数`prometheus.additionalAlertRelabelConfigsExternal.name`设置Secret名称，并使用`prometheus.additionalAlertRelabelConfigsExternal.key`设置包含额外告警重标签配置的键。例如，如果您创建了一个名为`kube-prometheus-prometheus-alert-relabel-config`的Secret，其中包含一个名为`additional-alert-relabel-configs.yaml`的文件，请使用以下参数：

```text
prometheus.additionalAlertRelabelConfigsExternal.enabled=true
prometheus.additionalAlertRelabelConfigsExternal.name=kube-prometheus-prometheus-alert-relabel-config
prometheus.additionalAlertRelabelConfigsExternal.key=additional-alert-relabel-configs.yaml
```

### 备份和恢复

要在Kubernetes上备份和恢复Helm图表部署，您需要从源部署备份持久卷，并使用[Velero](https://velero.io/)（Kubernetes备份/恢复工具）将其附加到新部署。有关使用Velero的说明，请参见[本指南](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html)。

### 设置Pod亲和性

此图表允许使用`XXX.affinity`参数设置自定义Pod亲和性。有关Pod亲和性的更多信息，请参见[Kubernetes文档](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity)。

作为替代方案，可以使用[bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities)图表中提供的Pod亲和性、Pod反亲和性和节点亲和性的预设配置之一。为此，设置`XXX.podAffinityPreset`、`XXX.podAntiAffinityPreset`或`XXX.nodeAffinityPreset`参数。

## 参数

### 全局参数

| 名称 | 描述 | 值 |
| --- | --- | --- |
| `global.imageRegistry` | 全局Docker镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局Docker仓库密钥名称数组 | `[]` |
| `global.defaultStorageClass` | 持久卷的全局默认StorageClass | `""` |
| `global.security.allowInsecureImages` | 允许跳过镜像验证 | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 调整部署的securityContext部分，使其与Openshift restricted-v2 SCC兼容：移除runAsUser、runAsGroup和fsGroup，让平台使用其允许的默认ID。可能的值：auto（如果检测到运行的集群是Openshift则应用）、force（始终执行调整）、disabled（不执行调整） | `auto` |

### 通用参数

| 名称 | 描述 | 值 |
| --- | --- | --- |
| `kubeVersion` | 强制目标Kubernetes版本（如果未设置，则使用Helm能力） | `""` |
| `nameOverride` | 用于部分覆盖`kube-prometheus.name`模板的字符串（将前置发布名称） | `""` |
| `fullnameOverride` | 用于完全覆盖`kube-prometheus.fullname`模板的字符串 | `""` |
| `namespaceOverride` | 用于完全覆盖common.names.namespace的字符串 | `""` |
| `commonAnnotations` | 要添加到所有部署对象的注解 | `{}` |
| `commonLabels` | 要添加到所有部署对象的标签 | `{}` |
| `extraDeploy` | 要随发布一起部署的额外对象数组 | `[]` |
| `clusterDomain` | Kubernetes集群域名 | `cluster.local` |

### Prometheus Operator参数

| 名称 | 描述 | 值 |
| --- | --- | --- |
| `operator.enabled` | 部署Prometheus Operator到集群 | `true` |
| `operator.image.registry` | Prometheus Operator镜像仓库 | `REGISTRY_NAME` |
| `operator.image.repository` | Prometheus Operator镜像存储库 | `REPOSITORY_NAME/prometheus-operator` |
| `operator.image.digest` | Prometheus Operator镜像摘要，格式为sha256:aa.... 注意：如果设置此参数，将覆盖标签 | `""` |
| `operator.image.pullPolicy` | Prometheus Operator镜像拉取策略 | `IfNotPresent` |
| `operator.image.pullSecrets` | 指定docker-registry密钥名称数组 | `[]` |
| `operator.extraArgs` | 传递给Prometheus Operator的额外参数 | `[]` |
| `operator.command` | 覆盖默认容器命令（在使用自定义镜像时有用） | `[]` |
| `operator.args` | 覆盖默认容器参数（在使用自定义镜像时有用） | `[]` |
| `operator.lifecycleHooks` | Prometheus Operator容器的生命周期钩子，用于在启动前后自动配置 | `{}` |
| `operator.extraEnvVars` | 要添加到Prometheus Operator节点的额外环境变量数组 | `[]` |
| `operator.extraEnvVarsCM` | 包含Prometheus Operator节点额外环境变量的现有ConfigMap名称 | `""` |
| `operator.extraEnvVarsSecret` | 包含Prometheus Operator节点额外环境变量的现有Secret名称 | `""` |
| `operator.extraVolumes` | 可选地为Prometheus Operator pod指定额外的卷列表 | `[]` |
| `operator.extraVolumeMounts` | 可选地为Prometheus Operator容器指定额外的volumeMounts列表 | `[]` |
| `operator.sidecars` | 向Prometheus Operator pod添加额外的sidecar容器 | `[]` |
| `operator.initContainers` | 向Prometheus Operator pod添加额外的init容器 | `[]` |
| `operator.automountServiceAccountToken` | 在pod中挂载服务账户令牌 | `true` |
| `operator.hostAliases` | 添加部署主机别名 | `[]` |
| `operator.serviceAccount.create` | 指定是否为Prometheus Operator创建ServiceAccount | `true` |
| `operator.serviceAccount.name` | 要创建的ServiceAccount名称 | `""` |
| `operator.serviceAccount.automountServiceAccountToken` | 为服务器服务账户自动挂载服务账户令牌 | `false` |
| `operator.serviceAccount.annotations` | 服务账户的注解。作为模板计算。仅在`create`为`true`时使用。 | `{}` |
| `operator.schedulerName` | Kubernetes调度器名称（非默认） | `""` |
| `operator.terminationGracePeriodSeconds` | Prometheus Operator pod优雅终止所需的时间（秒） | `""` |
| `operator.topologySpreadConstraints` | pod分配的拓扑扩展约束 | `[]` |
| `operator.podSecurityContext.enabled` | 启用

_注意：此图表的README超过了DockerHub的25000字符长度限制，因此已被截断。完整README可在https://github.com/bitnami/charts/blob/main/bitnami/kube-prometheus/README.md找到_
