---
image: bitnamicharts/spark
description: "Bitnami Apache Spark的Helm Chart，用于在Kubernetes集群上部署高性能大规模计算引擎，支持数据处理、机器学习和实时流处理，提供Java、Python、Scala和R的API。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/spark
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/spark
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/spark" title="bitnamicharts/spark Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/spark 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Apache Spark 软件包

Apache Spark 是一个高性能的大规模计算任务引擎，适用于数据处理、机器学习和实时数据流等场景。它包含 Java、Python、Scala 和 R 的 API。

[Apache Spark 概述](https://spark.apache.org/)

商标说明：本软件列表由 Bitnami 打包。产品中提及的各个商标分属各自公司所有，使用这些商标并不意味着任何关联或背书。

## 快速入门

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/spark
```

希望在生产环境中使用 Apache Spark？请尝试 [VMware Tanzu Application Catalog](https://bitnami.com/enterprise)，即 Bitnami 目录的商业版。

## ⚠️ 重要通知：Bitnami 目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共目录，在新的 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)下提供精选的强化、安全聚焦镜像集。作为此次转型的一部分：

- 首次向社区用户开放流行容器镜像的安全优化版本访问权限。
- Bitnami 将开始在免费层中弃用对非强化、基于 Debian 的软件镜像的支持，并将逐步从公共目录中移除非最新标签。因此，社区用户将只能访问数量减少的强化镜像。这些镜像仅以“latest”标签发布，适用于开发目的。
- 从 8 月 28 日开始，在两周内，所有现有容器镜像（包括旧版本或带版本号的标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用 Bitnami Secure Images，其中包括强化容器、更小的攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 以及企业支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提升所有 Bitnami 用户的安全态势。更多详情，请访问 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。

## 简介

本 Chart 使用 [Helm](https://helm.sh) 包管理器在 [Kubernetes](https://kubernetes.io) 集群上引导 [Apache Spark](https://github.com/bitnami/containers/tree/main/bitnami/spark) 部署。

Apache Spark 包含 Java、Python、Scala 和 R 的 API。

## 前提条件

- Kubernetes 1.23+
- Helm 3.8.0+

## 安装 Chart

要使用发布名称 `my-release` 安装 Chart：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/spark
```

> 注意：您需要将占位符 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 替换为 Helm Chart 仓库和存储库的引用。例如，对于 Bitnami，需使用 `REGISTRY_NAME=registry-1.docker.io` 和 `REPOSITORY_NAME=bitnamicharts`。

这些命令使用默认配置在 Kubernetes 集群上部署 Apache Spark。[参数](#parameters) 部分列出了可在安装过程中配置的参数。

> **提示**：使用 `helm list` 列出所有发布

## 配置和安装详情

### 资源请求和限制

Bitnami Charts 允许为 Chart 部署内的所有容器设置资源请求和限制。这些配置位于 `resources` 值中（参见参数表）。设置请求对于生产工作负载至关重要，应根据具体使用场景进行调整。

为简化此过程，Chart 包含 `resourcesPreset` 值，可根据不同预设自动设置 `resources` 部分。有关这些预设的详细信息，请参见 [bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15)。但在生产工作负载中，不建议使用 `resourcesPreset`，因为它可能无法完全适应您的特定需求。有关容器资源管理的更多信息，请参阅 [Kubernetes 官方文档](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)。

### Prometheus 指标

通过将 `metrics.enabled` 设置为 `true`，可将此 Chart 与 Prometheus 集成。这将在容器和服务中公开 Spark 原生的 Prometheus 端口。服务还将包含必要的注解，以便被 Prometheus 自动抓取。

#### Prometheus 要求

集成需确保已安装 Prometheus 或 Prometheus Operator。可安装 [Bitnami Prometheus Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) 或 [Bitnami Kube Prometheus Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus)，以在集群中快速部署可用的 Prometheus。

#### 与 Prometheus Operator 集成

通过设置 `metrics.serviceMonitor.enabled=true`，Chart 可部署 `ServiceMonitor` 对象以与 Prometheus Operator 集成。确保集群中已安装 Prometheus Operator `CustomResourceDefinitions`，否则将失败并显示以下错误：

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

安装 [Bitnami Kube Prometheus Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) 以获取必要的 CRD 和 Prometheus Operator。

### [滚动标签与不可变标签](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

强烈建议在生产环境中使用不可变标签。这可确保即使相同标签更新为不同镜像，部署也不会自动更改。

如果主容器有新版本、重大变更或严重漏洞，Bitnami 将发布新的 Chart 以更新其容器。

### 备份和恢复

要在 Kubernetes 上备份和恢复 Helm Chart 部署，需使用 Kubernetes 备份/恢复工具 [Velero](https://velero.io/) 备份源部署的持久卷，并将其附加到新部署。有关使用 Velero 的说明，请参见 [此指南](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html)。

### 定义自定义配置

要使用自定义配置，需创建包含 `spark-env.sh` 文件的 ConfigMap。ConfigMap 名称必须在部署时提供。

要为主节点设置配置，使用 `master.configurationConfigMap=configMapName`；为工作节点设置配置，使用 `worker.configurationConfigMap=configMapName`。

这些值可同时在单个 ConfigMap 中设置，或使用两个 ConfigMap。ConfigMap 中还可提供额外的 `spark-defaults.conf` 文件。您可同时使用这两个文件，或仅使用其中一个。

### 提交应用

要向 Apache Spark 集群提交应用，使用 `spark-submit` 脚本，该脚本可在 [https://github.com/apache/spark/tree/master/bin](https://github.com/apache/spark/tree/master/bin) 获取。

以下命令演示了部署 Apache Spark 随附的示例应用的过程。将 `k8s-apiserver-host`、`k8s-apiserver-port`、`spark-master-svc` 和 `spark-master-port` 占位符替换为您部署的主节点主机/IP 地址和端口。

```console
$ ./bin/spark-submit \
    --class org.apache.spark.examples.SparkPi \
    --conf spark.kubernetes.container.image=bitnami/spark:3 \
    --master k8s://https://k8s-apiserver-host:k8s-apiserver-port \
    --conf spark.kubernetes.driverEnv.SPARK_MASTER_URL=spark://spark-master-svc:spark-master-port \
    --deploy-mode cluster \
    ./examples/jars/spark-examples_2.12-3.2.0.jar 1000
```

此命令示例假设您已下载 Spark 二进制发行版，可在 [Apache Spark 下载](https://spark.apache.org/downloads.html) 获取。

有关使用自定义应用的完整步骤，请参阅 Spark 的 [在 Kubernetes 上运行 Spark](https://spark.apache.org/docs/latest/running-on-kubernetes.html) 指南。

> 注意：如果配置了 RPC 身份验证，目前无法向独立集群提交应用。[了解更多关于此问题](https://issues.apache.org/jira/browse/SPARK-25078)。

### 配置 Spark Master 作为反向代理

Spark 支持将 Spark Master 配置为工作节点和应用 UI 的反向代理。这很有用，因为 Spark Master UI 否则可能使用私有 IPv4 地址链接到 Spark 工作节点和 Spark 应用。

结合 `ingress` 配置，您可设置 `master.configOptions` 和 `worker.configOptions`，告知 Spark 反向代理工作节点和应用 UI，以实现在无需直接访问其主机的情况下进行访问：

```yaml
master:
  configOptions:
    -Dspark.ui.reverseProxy=true
    -Dspark.ui.reverseProxyUrl=https://spark.your-domain.com
worker:
  configOptions:
    -Dspark.ui.reverseProxy=true
    -Dspark.ui.reverseProxyUrl=https://spark.your-domain.com
ingress:
  enabled: true
  hostname: spark.your-domain.com
```

有关参数的详细信息，请参见 [Spark 配置](https://spark.apache.org/docs/latest/configuration.html) 文档。

### 配置 Apache Spark 安全性

#### 配置 SSL 通信

要启用工作节点和主节点之间的安全传输，部署 Helm Chart 时设置 `ssl.enabled=true` Chart 参数。

#### 创建证书和密码密钥

需为密码和证书创建两个密钥。两个密钥的名称应使用 `security.passwordsSecretName` 和 `security.ssl.existingSecret` Chart 参数进行配置。

##### 创建证书和证书密钥

要生成证书密钥，首先生成两个证书并将其重命名为 `spark-keystore.jks` 和 `spark-truststore.jks`。如需测试，可使用 [此脚本生成证书](https://raw.githubusercontent.com/confluentinc/confluent-platform-security-tools/master/kafka-generate-ssl.sh)。

创建证书后，为其创建密钥，文件名为键。键必须命名为 `spark-keystore.jks` 和 `spark-truststore.jks`，内容必须为 JKS 格式的文本。

##### 创建密码密钥

密码密钥应包含三个键：`rpc-authentication-secret`、`ssl-keystore-password` 和 `ssl-truststore-password`。

##### 配置 Chart

创建密钥后，配置 Chart 并设置各种安全相关参数，包括引用先前创建的密钥的 `security.certificatesSecretName` 和 `security.passwordsSecretName` 参数。以下是 Chart 部署的示例配置：

```text
security.certificatesSecretName=my-secret
security.passwordsSecretName=my-passwords-secret
security.rpc.authenticationEnabled=true
security.rpc.encryptionEnabled=true
security.storageEncrytionEnabled=true
security.ssl.enabled=true
security.ssl.needClientAuth=true
```

> 注意：如果配置了 RPC 身份验证，目前无法向独立集群提交应用。[了解更多关于此问题](https://issues.apache.org/jira/browse/SPARK-25078)。

### 设置 Pod 亲和性

此 Chart 允许使用 `XXX.affinity` 参数设置自定义亲和性。有关 Pod 亲和性的更多信息，请参见 [Kubernetes 文档](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity)。

作为替代方案，您可使用 [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) Chart 中提供的 Pod 亲和性、Pod 反亲和性和节点亲和性预设配置。为此，设置 `XXX.podAffinityPreset`、`XXX.podAntiAffinityPreset` 或 `XXX.nodeAffinityPreset` 参数。

## 参数

### 全局参数

| 名称 | 描述 | 值 |
|------|------|-----|
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局 Docker 仓库密钥名称数组 | `[]` |
| `global.defaultStorageClass` | 持久卷的全局默认 StorageClass | `""` |
| `global.storageClass` | 已弃用：使用 global.defaultStorageClass 替代 | `""` |
| `global.security.allowInsecureImages` | 允许跳过镜像验证 | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 调整部署的 securityContext 部分，使其与 Openshift restricted-v2 SCC 兼容：移除 runAsUser、runAsGroup 和 fsGroup，让平台使用其允许的默认 ID。可能的值：auto（如果检测到运行的集群是 Openshift 则应用）、force（始终执行调整）、disabled（不执行调整） | `auto` |

### 通用参数

| 名称 | 描述 | 值 |
|------|------|-----|
| `kubeVersion` | 强制目标 Kubernetes 版本（未设置则使用 Helm 能力） | `""` |
| `nameOverride` | 部分覆盖 common.names.fullname 模板的字符串（将保留发布名称） | `""` |
| `fullnameOverride` | 完全覆盖 common.names.fullname 模板的字符串 | `""` |
| `namespaceOverride` | 完全覆盖 common.names.namespace 的字符串 | `""` |
| `commonLabels` | 添加到所有部署对象的标签 | `{}` |
| `commonAnnotations` | 添加到所有部署对象的注解 | `{}` |
| `clusterDomain` | Kubernetes 集群域名 | `cluster.local` |
| `extraDeploy` | 随发布部署的额外对象数组 | `[]` |
| `initScripts` | 初始化脚本字典，作为模板评估 | `{}` |
| `initScriptsCM` | 包含初始化脚本的 ConfigMap，作为模板评估 | `""` |
| `initScriptsSecret` | 包含初始化时执行的 `/docker-entrypoint-initdb.d` 敏感脚本的密钥，作为模板评估 | `""` |
| `diagnosticMode.enabled` | 启用诊断模式（所有探针将被禁用，命令将被覆盖） | `false` |
| `diagnosticMode.command` | 覆盖部署中所有容器的命令 | `["sleep"]` |
| `diagnosticMode.args` | 覆盖部署中所有容器的参数 | `["infinity"]` |

### Spark 参数

| 名称 | 描述 | 值 |
|------|------|-----|
| `image.registry` | Spark 镜像仓库 | `REGISTRY_NAME` |
| `image.repository` | Spark 镜像存储库 | `REPOSITORY_NAME/spark` |
| `image.digest` | Spark 镜像摘要，格式为 sha256:aa.... 注意：如果设置此参数，将覆盖标签 | `""` |
| `image.pullPolicy` | Spark 镜像拉取策略 | `IfNotPresent` |
| `image.pullSecrets` | 指定 docker-registry 密钥名称数组 | `[]` |
| `image.debug` | 启用镜像调试模式 | `false` |
| `hostNetwork` | 启用主机网络 | `false` |

### Spark 主节点参数

| 名称 | 描述 | 值 |
|------|------|-----|
| `master.enabled` | 部署主节点有状态集 | `true` |
| `master.existingConfigmap` | 包含主节点自定义配置的现有 ConfigMap 名称 | `""` |
| `master.containerPorts.http` | 主节点 HTTP  Web 界面监听端口 | `8080` |
| `master.containerPorts.https` | 主节点 HTTPS Web 界面监听端口 | `8480` |
| `master.containerPorts.cluster` | 主节点与工作节点通信监听端口 | `7077` |
| `master.automountServiceAccountToken` | 在 Pod 中挂载服务账户令牌 | `false` |
| `master.hostAliases` | 部署 Pod 的主机别名 | `[]` |
| `master.extraContainerPorts` | 主节点内运行作业的监听端口 | `[]` |
| `master.daemonMemoryLimit` | 主节点守护进程的内存限制 | `""` |
| `master.configOptions` | 以 "-Dx=y" 形式设置配置选项的字符串 | `""` |
| `master.extraEnvVars` | 传递给主节点容器的额外环境变量 | `[]` |
| `master.extraEnvVarsCM` | 包含主节点额外环境变量的现有 ConfigMap 名称 | `""` |

> 注意：此 Chart 的 README 超出了 DockerHub 25000 字符的长度限制，因此已被截断。完整 README 可在 https://github.com/bitnami/charts/blob/main/bitnami/spark/README.md 查看。
