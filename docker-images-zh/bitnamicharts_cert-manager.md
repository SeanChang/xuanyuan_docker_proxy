---
image: bitnamicharts/cert-manager
description: "Bitnami提供的cert-manager Helm chart，用于在Kubernetes集群中部署和管理TLS证书的自动化工具。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/cert-manager
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/cert-manager
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/cert-manager" title="bitnamicharts/cert-manager Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/cert-manager 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami cert-manager 软件包

cert-manager 是一个 Kubernetes 插件，用于自动化管理和签发来自各种签发源的 TLS 证书。

[cert-manager 概述](https://github.com/jetstack/cert-manager)

商标声明：本软件列表由 Bitnami 打包。产品中提及的相关商标归各自公司所有，使用这些商标并不意味着任何关联或背书。


## 快速入门

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/cert-manager
```

如需在生产环境中使用 cert-manager？请尝试 [VMware Tanzu Application Catalog](https://bitnami.com/enterprise)，即 Bitnami 目录的商业版。


## ⚠️ 重要通知：Bitnami 目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共目录，通过新的 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications) 提供精选的强化、安全聚焦的镜像。作为此次过渡的一部分：

- 首次向社区用户开放热门容器镜像的安全优化版本。
- Bitnami 将开始在免费层中弃用对非强化、基于 Debian 的软件镜像的支持，并逐步从公共目录中移除非最新标签。因此，社区用户将只能访问数量减少的强化镜像，这些镜像仅以“latest”标签发布，适用于开发目的。
- 从 8 月 28 日开始，在两周内，所有现有容器镜像（包括旧版本或带版本的标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移到“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用 Bitnami Secure Images，包括强化容器、更小的攻击面、CVE 透明度（通过 VEX/KEV）、SBOMs 和企业支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提高所有 Bitnami 用户的安全态势。更多详情，请访问 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


## 简介

Bitnami Helm 图表经过精心设计、积极维护，是在 Kubernetes 集群上部署容器的最快、最简单方式，可直接用于生产工作负载。

本图表使用 [Helm](https://helm.sh) 包管理器在 [Kubernetes](https://kubernetes.io) 集群中引导 [cert-manager](https://cert-manager.io/) 部署。


## 前提条件

- Kubernetes 1.23+
- Helm 3.8.0+
- 底层基础设施支持 PV 供应


## 安装图表

要使用发布名称 `my-release` 安装图表：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/cert-manager
```

> 注意：需将占位符 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 替换为 Helm 图表仓库和仓库名称。例如，对于 Bitnami，需使用 `REGISTRY_NAME=registry-1.docker.io` 和 `REPOSITORY_NAME=bitnamicharts`。
> **提示**：使用 `helm list` 列出所有发布。


## 配置与安装详情

### 资源请求与限制

Bitnami 图表允许为图表部署中的所有容器设置资源请求和限制，这些配置位于 `resources` 值中（参见参数表格）。设置请求对于生产工作负载至关重要，应根据具体使用场景调整。

为简化此过程，图表包含 `resourcesPreset` 值，可根据不同预设自动设置 `resources` 部分。可在 [bitnami/common 图表](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15) 中查看这些预设。但在生产工作负载中，不建议使用 `resourcesPreset`，因其可能无法完全适应具体需求。有关容器资源管理的更多信息，请参阅 [Kubernetes 官方文档](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)。


### [滚动标签与不可变标签](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

强烈建议在生产环境中使用不可变标签。这可确保如果相同标签更新为不同镜像时，部署不会自动变更。

如果主容器有新版本、重大变更或存在严重漏洞，Bitnami 将发布新图表更新其容器。


### 备份与恢复

要在 Kubernetes 上备份和恢复 Helm 图表部署，需使用 [Velero](https://velero.io/)（Kubernetes 备份/恢复工具）备份源部署的持久卷，并将其附加到新部署。有关使用 Velero 的说明，请参阅 [此指南](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html)。


### 添加额外环境变量

如需添加额外环境变量（用于高级操作，如自定义初始化脚本），可使用 `extraEnvVars` 属性：

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

或者，可使用包含环境变量的 ConfigMap 或 Secret。为此，使用 `extraEnvVarsCM` 或 `extraEnvVarsSecret` 值。


### Prometheus 指标

通过将 `metrics.enabled` 设置为 `true`，可将本图表与 Prometheus 集成。这将在服务中公开 cert-manager 原生 Prometheus 端点，并添加必要注解以实现 Prometheus 自动抓取。

#### Prometheus 要求

需安装 Prometheus 或 Prometheus Operator 才能使集成生效。可安装 [Bitnami Prometheus Helm 图表](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) 或 [Bitnami Kube Prometheus Helm 图表](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus)，轻松在集群中部署 Prometheus。

#### 与 Prometheus Operator 集成

本图表可部署 `ServiceMonitor` 对象，用于与 Prometheus Operator 集成。为此，将 `metrics.serviceMonitor.enabled` 设置为 `true`。确保集群中已安装 Prometheus Operator 自定义资源定义（CRDs），否则将失败并显示以下错误：

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

安装 [Bitnami Kube Prometheus Helm 图表](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) 可获取必要的 CRDs 和 Prometheus Operator。


### Sidecars 和 Init 容器

如需在 cert-manager 应用的同一 Pod 中运行额外容器（如额外指标或日志导出器），可通过 `sidecars` 配置参数定义。只需根据 Kubernetes 容器规范定义容器：

```yaml
sidecars:
  - name: your-image-name
    image: docker.xuanyuan.run/your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

类似地，可使用 `initContainers` 参数添加额外 Init 容器：

```yaml
initContainers:
  - name: your-image-name
    image: docker.xuanyuan.run/your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```


### 使用自签名签发者生成 TLS 证书

cert-manager 支持通过不同签发者签发证书。例如，可使用自签名签发者（Self Signed Issuer）签发证书。

自签名签发者本身并不代表证书颁发机构，而是表示证书将使用给定私钥“自签名”。

> 注意：有关可用签发者的列表，请参阅 [cert-manager 官方文档](https://cert-manager.io/docs/configuration/#supported-issuer-types)。

要配置 cert-manager，需创建 Issuer 对象。对象结构因签发者类型而异。自签名签发者的配置非常简单。

要创建自签名签发者以生成自签名证书，请声明如下的 Issuer、ClusterIssuer 和 Certificate：

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-ca
  namespace: sandbox
spec:
  ca:
    secretName: letsencrypt-ca
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: letsencrypt-ca
  namespace: sandbox
spec:
  isCA: true
  commonName: osm-system
  secretName: letsencrypt-ca
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
    group: cert-manager.io
```

接下来，使用 ClusterIssuer 为 Kubernetes 集群中的应用生成证书。[了解如何保护 Ingress 资源](#使用-cert-manager-保护-ingress-资源)。

Ingress 资源就绪后，cert-manager 将创建包含生成的 TLS 证书的 Secret。可通过以下命令检查：

```text
$ kubectl get secret --namespace=sandbox
NAME                  TYPE                                  DATA   AGE
letsencrypt-ca        kubernetes.io/tls                     3      Xs
```


### 使用 ACME 签发者生成 TLS 证书

cert-manager 支持通过不同签发者签发证书。例如，可使用公共 ACME（自动化证书管理环境）服务器签发证书。

> 注意：有关可用签发者的列表，请参阅 [cert-manager 官方文档](https://cert-manager.io/docs/configuration/#supported-issuer-types)。

要配置 cert-manager，需创建 Issuer 对象。对象结构因签发者类型而异。对于 ACME，需包含在 ACME 证书颁发机构服务器中注册的单个账户信息。

配置 cert-manager 使用 ACME 后，它将验证您是否是所请求证书域名的所有者。cert-manager 使用两种不同的挑战来验证域名所有权：HTTP01 或 DNS01。[了解更多关于 ACME 挑战](https://cert-manager.io/docs/concepts/acme-orders-challenges/#challenge-scheduling)。

> 注意：有关解决挑战的流程，请参阅 [官方文档](https://cert-manager.io/docs/configuration/acme/#solving-challenges)。

要创建用于 Let's Encrypt 的 ACME 签发者，请声明如下 ClusterIssuer：

```yaml
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    # 必须将此电子邮件地址替换为您自己的地址。
    # Let's Encrypt 将通过此地址联系您，通知证书过期或账户相关问题。
    # 将 EMAIL-ADDRESS 占位符替换为正确的电子邮件账户
    email: EMAIL-ADDRESS
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-prod
    # 添加单个挑战解决器，使用 nginx 的 HTTP01
    solvers:
    - http01:
        ingress:
          class: nginx
```

接下来，使用 ClusterIssuer 为 Kubernetes 集群中的应用生成证书。[了解如何保护 Ingress 资源](#使用-cert-manager-保护-ingress-资源)。

Ingress 资源就绪后，cert-manager 将通过 HTTP01/DNS01 挑战验证域名。验证过程中，可通过控制器日志检查状态：

```text
$ kubectl get certificates
NAME                     READY   SECRET                   AGE
letencrypt-ca            False   letencrypt-ca             X
```

验证进行中时，状态为 *False*。HTTP01 验证成功完成后，状态将变为 *True*：

```text
$ kubectl get certificates
NAME                     READY   SECRET                   AGE
letencrypt-ca            True    letencrypt-ca             X

$ kubectl get secrets
NAME                                  TYPE                                  DATA   AGE
letencrypt-ca                      kubernetes.io/tls                        3      Xm
```


### 使用 cert-manager 保护 Ingress 资源

配置 cert-manager 的签发者（[自签名签发者](#使用自签名签发者生成-tls-证书) 或 [ACME 签发者](#使用-acme-签发者生成-tls-证书)）后，cert-manager 将使用该签发者创建包含证书的 TLS Secret。cert-manager 仅在应用已暴露时才能创建此 Secret。一种方法是使用 Ingress 资源暴露应用，并包含 cert-manager 的相应注解。

通过 Ingress 控制器暴露应用并使用 cert-manager 管理 TLS 证书有两种方式：

- 部署另一个支持通过 Ingress 控制器暴露应用的 Helm 图表。例如，使用 [Bitnami WordPress Helm 图表](https://github.com/bitnami/charts/tree/main/bitnami/wordpress) 并 [为 WordPress 配置 Ingress](https://github.com/bitnami/charts/tree/main/bitnami/wordpress#ingress)。要启用与 cert-manager 的集成，需将以下注解添加到 `ingress.annotations` 参数：

  ```text
  # 下方设置 ingress.class（本示例使用 nginx ingress 控制器）
  kubernetes.io/ingress.class: nginx
  cert-manager.io/cluster-issuer: letsencrypt-prod
  ```

- 创建如下自定义 Ingress 资源：

  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: ingress-test
    annotations:
      # 下方设置 ingress.class（本示例使用 nginx ingress 控制器）
      kubernetes.io/ingress.class: "nginx"
      cert-manager.io/issuer: "letsencrypt-prod"
  spec:
    tls:
    # 将 DOMAIN 占位符替换为正确的域名
    - hosts:
      - DOMAIN
      secretName: letsencrypt-ca
    rules:
    # 将 DOMAIN 占位符替换为正确的域名
    - host: DOMAIN
      http:
        paths:
        - path: /
          pathType: Exact
          backend:
            service:
              name: ingress-test
              port:
                number: 80
  ```


### 部署额外资源

如需部署额外对象（如包含应用配置的 ConfigMap 或应用使用的微服务部署），可使用 `extraDeploy` 参数添加其他对象的完整规范。


### 设置 Pod 亲和性

本图表允许使用 `controller.affinity`、`cainjector.affinity` 或 `webhook.affinity` 参数设置自定义亲和性。有关 Pod 亲和性的更多信息，请参阅 [Kubernetes 文档](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity)。

作为替代方案，可使用 [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) 图表中预设的 Pod 亲和性、Pod 反亲和性和节点亲和性配置。为此，设置 `controller.podAffinityPreset`、`cainjector.podAffinityPreset`、`webhook.podAffinityPreset`、`controller.podAntiAffinityPreset`、`cainjector.podAntiAffinityPreset`、`webhook.podAntiAffinityPreset`、`controller.nodeAffinityPreset`、`cainjector.nodeAffinityPreset` 或 `webhook.nodeAffinityPreset` 参数。


## 参数

### 全局参数

| 名称 | 描述 | 默认值 |
|------|------|--------|
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局 Docker 仓库密钥名称数组 | `[]` |
| `global.defaultStorageClass` | 持久卷的全局默认 StorageClass | `""` |
| `global.storageClass` | 已弃用：使用 global.defaultStorageClass 替代 | `""` |
| `global.security.allowInsecureImages` | 允许跳过镜像验证 | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 调整部署的 securityContext 部分以兼容 OpenShift restricted-v2 SCC：移除 runAsUser、runAsGroup 和 fsGroup，让平台使用允许的默认 ID。可能值：auto（如果检测到运行集群为 OpenShift 则应用）、force（始终执行调整）、disabled（不执行调整） | `auto` |


### 通用参数

| 名称 | 描述 | 默认值 |
|------|------|--------|
| `kubeVersion` | 覆盖 Kubernetes 版本 | `""` |
| `nameOverride` | 部分覆盖 common.names.fullname 的字符串 | `""` |
| `fullnameOverride` | 完全覆盖 common.names.fullname 的字符串 | `""` |
| `commonLabels` | 添加到所有部署对象的标签 | `{}` |
| `commonAnnotations` | 添加到所有部署对象的注解 | `{}` |
| `extraDeploy` | 随发布部署的额外对象数组 | `[]` |
| `logLevel` | 设置 cert-manager 日志级别 | `2` |
| `clusterResourceNamespace` | 用于存储 ClusterIssuer 资源的 DNS 提供商凭据等的命名空间。若为空，使用控制器部署的命名空间 | `""` |
| `leaderElection.namespace` | leaderElection 工作的命名空间 | `kube-system` |
| `installCRDs` | 安装 cert-manager CRDs 的标志 | `false` |
| `replicaCount` | cert-manager 副本数 | `1` |


### 控制器部署参数

| 名称 | 描述 | 默认值 |
