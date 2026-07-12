---
image: bitnamicharts/consul
description: "Bitnami提供的HashiCorp Consul Helm chart，用于在Kubernetes集群上部署和管理Consul服务发现与配置工具，支持安全强化、Prometheus监控及自定义配置等功能。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/consul
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/consul
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/consul" title="bitnamicharts/consul Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/consul 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami HashiCorp Consul Helm Chart

HashiCorp Consul是用于在基础设施中发现和配置服务的工具。

[HashiCorp Consul概述](https://consul.io)

商标声明：本软件列表由Bitnami打包。所提及的相关商标归各自公司所有，使用这些商标并不意味着任何关联或背书。

## 快速开始

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/consul
```

希望在生产环境中使用HashiCorp Consul？请尝试[VMware Tanzu Application Catalog](https://bitnami.com/enterprise)，即Bitnami目录的商业版。

## ⚠️ 重要通知：Bitnami目录即将变更

自2025年8月28日起，Bitnami将升级其公共目录，通过新的[Bitnami Secure Images计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)提供精选的强化、安全聚焦镜像集。作为此次转型的一部分：

- 首次向社区用户提供热门容器镜像的安全优化版本访问权限。
- Bitnami将开始在免费层中弃用对非强化、基于Debian的软件镜像的支持，并将逐步从公共目录中移除非最新标签。因此，社区用户将只能访问数量减少的强化镜像，这些镜像仅以“latest”标签发布，仅供开发使用。
- 从8月28日开始，在两周内，所有现有容器镜像（包括旧版本或带版本的标签，如2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移到“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用Bitnami Secure Images，包括强化容器、更小的攻击面、CVE透明度（通过VEX/KEV）、SBOM以及企业支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提高所有Bitnami用户的安全态势。更多详情，请访问[Bitnami Secure Images公告](https://github.com/bitnami/containers/issues/83267)。

## 介绍

此chart使用[Helm](https://helm.sh)包管理器在[Kubernetes](https://kubernetes.io)集群上引导[HashiCorp Consul](https://github.com/bitnami/containers/tree/main/bitnami/consul)部署。

## 前提条件

- Kubernetes 1.23+
- Helm 3.8.0+
- 底层基础设施支持PV供应

## 安装Chart

要使用发布名称`my-release`安装chart：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/consul
```

> 注意：您需要将占位符`REGISTRY_NAME`和`REPOSITORY_NAME`替换为Helm chart仓库和存储库的引用。例如，对于Bitnami，需使用`REGISTRY_NAME=registry-1.docker.io`和`REPOSITORY_NAME=bitnamicharts`。

这些命令使用默认配置在Kubernetes集群上部署HashiCorp Consul。[参数](#parameters)部分列出了可在安装期间配置的参数。

> **提示**：使用`helm list`列出所有发布

## 配置和安装详情

### 资源请求和限制

Bitnami charts允许为chart部署中的所有容器设置资源请求和限制，这些配置位于`resources`值中（参见参数表）。为生产工作负载设置请求至关重要，且应根据您的具体用例进行调整。

为简化此过程，chart包含`resourcesPreset`值，可根据不同预设自动设置`resources`部分。有关这些预设，请查看[bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15)。然而，在生产工作负载中不建议使用`resourcesPreset`，因为它可能无法完全适应您的特定需求。有关容器资源管理的更多信息，请参阅[Kubernetes官方文档](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)。

### [滚动标签与不可变标签](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

强烈建议在生产环境中使用不可变标签。这可确保如果相同标签使用不同镜像更新，您的部署不会自动更改。

如果主容器有新版本、重大变更或严重漏洞，Bitnami将发布新的chart来更新其容器。

### Prometheus指标

通过将`metrics.enabled`设置为`true`，此chart可与Prometheus集成。这将在所有pod中部署带有[consul_exporter](https://github.com/prometheus/consul_exporter)的边车容器，以及可在`metrics.service`部分配置的`metrics`服务。此`metrics`服务将具有必要的注解，以便被Prometheus自动抓取。

#### Prometheus要求

要使集成正常工作，需要安装Prometheus或Prometheus Operator。安装[Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus)或[Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus)，可轻松在集群中部署可用的Prometheus。

#### 与Prometheus Operator集成

通过设置`metrics.serviceMonitor.enabled=true`，chart可部署`ServiceMonitor`对象以与Prometheus Operator集成。确保集群中已安装Prometheus Operator `CustomResourceDefinitions`，否则将失败并显示以下错误：

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

安装[Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus)以获取必要的CRD和Prometheus Operator。

### 使用自定义配置

此helm chart支持自定义整个配置文件。

您可以使用`configuration`参数指定Hashicorp Consul配置。

此外，您还可以设置包含所有配置文件的外部ConfigMap，通过设置`existingConfigmap`参数实现。注意，这将覆盖上述选项。

### Ingress

此chart提供对Ingress资源的支持。如果集群上安装了Ingress控制器（如[nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller)或[contour](https://github.com/bitnami/charts/tree/main/bitnami/contour)），您可以利用Ingress控制器来提供应用服务。

要启用Ingress集成，请将`ingress.enabled`设置为`true`。

#### 主机

通常，您可能只需要一个主机名映射到此Consul安装。如果是这种情况，`ingress.hostname`属性将设置它。不过，也可以有多个主机。为方便实现，`ingress.extraHosts`对象可指定为数组。您还可以使用`ingress.extraTLS`为额外主机添加TLS配置。

对于`ingress.extraHosts`中指定的每个主机，请指明`name`、`path`以及您希望Ingress控制器了解的任何`annotations`。

关于注解，请参阅[此文档](https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/nginx-configuration/annotations.md)。并非所有注解都受所有Ingress控制器支持，但本文档很好地说明了哪些注解受许多流行Ingress控制器支持。

### 使用TLS保护流量

此chart将帮助创建用于Ingress控制器的TLS密钥，但这不是必需的。常见用例有三种：

- Helm生成/管理证书密钥
- 用户单独生成/管理证书
- 其他工具（如cert-manager）为应用管理密钥

在前两种情况下，需要证书和密钥。预期格式如下：

- 证书文件应如下所示（如果存在证书链，可包含多个证书）

```console
-----BEGIN CERTIFICATE-----
MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
...
jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
-----END CERTIFICATE-----
```

- 密钥应如下所示：

```console
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
...
wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
-----END RSA PRIVATE KEY-----
```

如果要使用Helm管理证书，请将这些值复制到给定`ingress.secrets`条目的`certificate`和`key`值中。

如果要在Helm外部管理TLS密钥，请了解您可以创建TLS密钥（例如命名为`consul-ui.local-tls`）。

更多信息请参见[此示例](https://github.com/kubernetes/contrib/tree/master/ingress/controllers/nginx/examples/tls)。

#### 启用服务器间TLS加密

您必须手动创建包含PEM编码的证书颁发机构、PEM编码的证书和PEM编码的私钥的密钥。

> 请注意，您需要创建具有适当配置的config map。

如果指定了密钥，chart将在`/opt/bitnami/consul/certs/`位置找到这些文件，因此您需要在config map中使用以下代码段配置HashiCorp Consul TLS加密：

```json
  "ca_file": "/opt/bitnami/consul/certs/ca.pem",
  "cert_file": "/opt/bitnami/consul/certs/consul.pem",
  "key_file": "/opt/bitnami/consul/certs/consul-key.pem",
  "verify_incoming": true,
  "verify_outgoing": true,
  "verify_server_hostname": true,
```

创建密钥后，您可以使用`--set tlsEncryptionSecretName=consul-tls-encryption`安装helm chart指定密钥名称。

### 指标

chart可选择在端口`9107`为[prometheus](https://prometheus.io)启动指标导出端点。端点公开的数据旨在由集群内部署的prometheus chart使用，因此端点不会暴露到集群外部。

### 添加额外环境变量

如果需要添加额外环境变量（用于高级操作，如自定义初始化脚本），可使用`extraEnvVars`属性。

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

或者，您可以使用包含环境变量的ConfigMap或Secret。为此，使用`.extraEnvVarsCM`或`extraEnvVarsSecret`属性。

### 设置Pod亲和性

此chart允许使用`affinity`参数设置自定义亲和性。有关Pod亲和性的更多信息，请参阅[Kubernetes文档](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity)。

作为替代方案，您可以使用[bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart中提供的Pod亲和性、Pod反亲和性和节点亲和性预设配置。为此，设置`podAffinityPreset`、`podAntiAffinityPreset`或`nodeAffinityPreset`参数。

### Sidecars和Init容器

如果需要在与Consul相同的pod中运行额外容器，可通过`sidecars`配置参数实现。只需根据Kubernetes容器规范定义您的容器。

```yaml
sidecars:
  - name: your-image-name
    image: docker.xuanyuan.run/your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

类似地，您可以使用`initContainers`参数添加额外的init容器。

```yaml
initContainers:
  - name: your-image-name
    image: docker.xuanyuan.run/your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

### 备份和恢复

要在Kubernetes上备份和恢复Helm chart部署，需要使用[Velero](https://velero.io/)（Kubernetes备份/恢复工具）备份源部署的持久卷，并将其附加到新部署。有关使用Velero的说明，请参阅[本指南](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html)。

## 持久化

[Bitnami HashiCorp Consul](https://github.com/bitnami/containers/tree/main/bitnami/consul)镜像将HashiCorp Consul数据存储在容器的`/bitnami`路径下。

持久卷声明（PVC）用于在部署之间保留数据。已知在GCE、AWS和minikube中有效。
请参阅[参数](#parameters)部分配置PVC或禁用持久化。

### 调整持久卷挂载点权限

由于镜像默认以非root用户运行，因此需要调整持久卷的所有权，以便容器可以写入数据。

默认情况下，chart配置为使用Kubernetes安全上下文自动更改卷的所有权。但此功能并非在所有Kubernetes发行版中都有效。

作为替代方案，此chart支持使用initContainer在将卷挂载到最终目标之前更改卷的所有权。

您可以通过将`volumePermissions.enabled`设置为`true`来启用此initContainer。

## 参数

### 全局参数

| 名称 | 描述 | 值 |
| --- | --- | --- |
| `global.imageRegistry` | 全局Docker镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局Docker仓库密钥名称数组 | `[]` |
| `global.defaultStorageClass` | 持久卷的全局默认StorageClass | `""` |
| `global.storageClass` | 已弃用：使用global.defaultStorageClass替代 | `""` |
| `global.security.allowInsecureImages` | 允许跳过镜像验证 | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 调整部署的securityContext部分以使其与OpenShift restricted-v2 SCC兼容：移除runAsUser、runAsGroup和fsGroup，让平台使用其允许的默认ID。可能值：auto（如果检测到运行的集群是OpenShift则应用）、force（始终执行调整）、disabled（不执行调整） | `auto` |

### 通用参数

| 名称 | 描述 | 值 |
| --- | --- | --- |
| `kubeVersion` | 覆盖Kubernetes版本 | `""` |
| `nameOverride` | 部分覆盖common.names.fullname的字符串 | `""` |
| `fullnameOverride` | 完全覆盖common.names.fullname的字符串 | `""` |
| `commonLabels` | 添加到所有部署对象的标签（不包括子chart） | `{}` |
| `commonAnnotations` | 添加到所有部署对象的注解（不包括子chart） | `{}` |
| `clusterDomain` | Kubernetes集群域名 | `cluster.local` |
| `extraDeploy` | 随发布部署的额外对象数组 | `[]` |
| `diagnosticMode.enabled` | 启用诊断模式（所有探针将被禁用，命令将被覆盖） | `false` |
| `diagnosticMode.command` | 覆盖部署中所有容器的命令 | `["sleep"]` |
| `diagnosticMode.args` | 覆盖部署中所有容器的参数 | `["infinity"]` |

### HashiCorp Consul参数

| 名称 | 描述 | 值 |
| --- | --- | --- |
| `image.registry` | HashiCorp Consul镜像仓库 | `REGISTRY_NAME` |
| `image.repository` | HashiCorp Consul镜像存储库 | `REPOSITORY_NAME/consul` |
| `image.digest` | HashiCorp Consul镜像摘要，格式为sha256:aa....注意：如果设置此参数，将覆盖标签 | `""` |
| `image.pullPolicy` | HashiCorp Consul镜像拉取策略 | `IfNotPresent` |
| `image.pullSecrets` | HashiCorp Consul镜像拉取密钥 | `[]` |
| `image.debug` | 启用镜像调试模式 | `false` |
| `datacenterName` | Consul数据中心名称。如果未提供，将使用Consul默认值 | `dc1` |
| `domain` | Consul域名 | `consul` |
| `raftMultiplier` | 用于缩放关键Raft计时参数的乘数 | `1` |
| `gossipKey` | 所有成员的Gossip密钥。密钥必须是base64编码的，可使用$(consul keygen)生成 | `""` |
| `tlsEncryptionSecretName` | 包含TLS加密数据的现有密钥名称 | `""` |
| `automountServiceAccountToken` | 在pod中挂载服务账户令牌 | `false` |
| `hostAliases` | 部署pod的主机别名 | `[]` |
| `configuration` | 要注入为ConfigMap的HashiCorp Consul配置 | `""` |
| `existingConfigmap` | 包含HashiCorp Consul配置的ConfigMap | `""` |
| `local
