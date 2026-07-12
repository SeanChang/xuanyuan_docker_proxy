---
image: bitnamicharts/thanos
description: "Bitnami提供的Thanos Helm chart，用于简化在Kubernetes环境中部署Thanos，实现Prometheus监控数据的高可用和长期存储。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/thanos
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/thanos
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/thanos" title="bitnamicharts/thanos Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/thanos 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Thanos 镜像文档

## 镜像概述和主要用途

Thanos 是一个高可用的指标系统，可以添加到现有的 Prometheus 部署之上，提供跨所有 Prometheus 实例的全局查询视图。

[Thanos 概述](https://thanos.io/)

**商标说明**：本软件列表由 Bitnami 打包。产品中提到的各个商标分别归各自公司所有，使用这些商标并不意味着任何关联或认可。

## 核心功能和特性

- 跨 Prometheus 实例的全局查询视图
- 长期存储解决方案，支持对象存储集成
- 高可用架构设计，支持多组件部署
- 自动数据压缩和降采样
- 与 Prometheus 和 Alertmanager 无缝集成
- 支持基于时间的数据分区
- 内置监控指标和 ServiceMonitor 支持
- 灵活的 TLS 加密配置选项
- 可定制的资源配置和自动扩缩容

## 使用场景和适用范围

- 大规模 Prometheus 部署的集中式查询
- 需要长期存储监控指标的场景
- 跨多个团队或区域的监控数据聚合
- 对监控系统有高可用性要求的生产环境
- 需要为不同时间段数据优化存储和查询性能的场景
- 希望简化 Prometheus 联邦部署的用户

## 快速开始 (TL;DR)

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/thanos
```

如需在生产环境中使用 Thanos，可尝试 [VMware Tanzu Application Catalog](https://bitnami.com/enterprise)，这是 Bitnami 目录的商业版本。

## ⚠️ 重要通知：Bitnami Catalog 即将变更

自 2025 年 8 月 28 日起，Bitnami 将改进其公共目录，在新的 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications) 下提供精选的强化、安全聚焦的镜像。作为此过渡的一部分：

- 首次向社区用户提供流行容器镜像的安全优化版本访问权限。
- Bitnami 将开始在其免费层级中弃用对非强化、基于 Debian 的软件镜像的支持，并将逐步从公共目录中删除非最新标签。因此，社区用户将可以访问数量减少的强化镜像。这些镜像仅在 "latest" 标签下发布，用于开发目的。
- 从 8 月 28 日开始，在两周内，所有现有容器镜像，包括旧版本或特定版本标签（例如 2.50.0、10.6），将从公共目录 (docker.io/bitnami) 迁移到 "Bitnami Legacy" 仓库 (docker.io/bitnamilegacy)，在那里它们将不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用 Bitnami Secure Images，其中包括强化容器、更小的攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 和企业支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提高所有 Bitnami 用户的安全态势。有关更多详细信息，请访问 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。

## 使用场景和适用范围

Thanos 适用于需要集中管理和查询多个 Prometheus 实例数据的环境，特别适合以下场景：

- 大规模微服务架构的监控系统
- 需要长期存储历史监控数据的组织
- 跨区域或多集群环境的统一监控视图
- 对监控系统可用性和可靠性有高要求的生产环境
- 需要为不同团队提供隔离的监控数据访问的场景

## 详细的使用方法和配置说明

### 前提条件

- Kubernetes 1.23+
- Helm 3.8.0+
- 底层基础设施支持 PV 供应器

### 安装图表

要使用发布名称 "my-release" 安装图表：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/thanos
```

> 注意：您需要将占位符 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 替换为 Helm 图表注册表和仓库的引用。例如，对于 Bitnami，您需要使用 `REGISTRY_NAME=registry-1.docker.io` 和 `REPOSITORY_NAME=bitnamicharts`。

这些命令使用默认配置在 Kubernetes 集群上部署 Thanos。[配置](#configuration-and-installation-details) 部分列出了可以在安装过程中配置的参数。

> **提示**：使用 `helm list` 列出所有发布

### 架构

此图表允许您安装多个 Thanos 组件，因此您可以部署如下架构：

```text
                       +--------------+                  +--------------+      +--------------+
                       | Thanos       |----------------> | Thanos Store |      | Thanos       |
                       | Query        |           |      | Gateway      |      | Compactor    |
                       +--------------+           |      +--------------+      +--------------+
                   push                           |             |                     |
+--------------+   alerts   +--------------+      |             | storages            | Downsample &
| Alertmanager | <----------| Thanos       | <----|             | query metrics       | compact blocks
| (*)          |            | Ruler        |      |             |                     |
+--------------+            +--------------+      |             \/                    |
      ^                            |              |      +----------------+           |
      | push alerts                +--------------|----> | MinIO® (*)     | <---------+
      |                                           |      |                |
+------------------------------+                  |      +----------------+
|+------------+  +------------+|                  |             ^
|| Prometheus |->| Thanos     || <----------------+             |
|| (*)        |<-| Sidecar (*)||    query                       | inspect
|+------------+  +------------+|    metrics                     | blocks
+------------------------------+                                |
                                                         +--------------+
                                                         | Thanos       |
                                                         | Bucket Web   |
                                                         +--------------+
```

> 注意：标有 (*) 的组件由子图表（如 [Bitnami MinIO® 图表](https://github.com/bitnami/charts/tree/main/bitnami/minio)）或外部图表（如 [Bitnami kube-prometheus 图表](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus)）提供。

有关部署此架构的详细说明，请查看 [集成 Thanos 与 Prometheus 和 Alertmanager](#integrate-thanos-with-prometheus-and-alertmanager) 部分。

### 配置和安装详情

#### 资源请求和限制

Bitnami 图表允许为图表部署内的所有容器设置资源请求和限制。这些在 `resources` 值内（检查参数表）。对于生产工作负载，设置请求至关重要，这些请求应根据您的具体用例进行调整。

为简化此过程，图表包含 `resourcesPreset` 值，该值根据不同的预设自动设置 `resources` 部分。在 [bitnami/common 图表](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15) 中查看这些预设。但是，在生产工作负载中不建议使用 `resourcesPreset`，因为它可能无法完全适应您的特定需求。有关容器资源管理的更多信息，请参阅 [官方 Kubernetes 文档](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)。

#### Prometheus 指标

通过将 `metrics.enabled` 设置为 `true`，此图表可以与 Prometheus 集成。这将在服务中公开 Thanos 原生 Prometheus 端点。它将具有必要的注释，可以被 Prometheus 自动抓取。

##### Prometheus 要求

要使集成工作，必须安装 Prometheus 或 Prometheus Operator。安装 [Bitnami Prometheus helm 图表](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) 或 [Bitnami Kube Prometheus helm 图表](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus)，可以轻松在集群中拥有可用的 Prometheus。

##### 与 Prometheus Operator 集成

通过设置值 `metrics.serviceMonitor.enabled=true`，图表可以部署用于与 Prometheus Operator 集成的 `ServiceMonitor` 对象。确保在集群中安装了 Prometheus Operator `CustomResourceDefinitions`，否则将失败并显示以下错误：

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

安装 [Bitnami Kube Prometheus helm 图表](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) 以获得必要的 CRD 和 Prometheus Operator。

#### 使用 TLS 保护流量

Thanos 可以通过设置 `*.tls.enabled=true`（在 `query.grpc.client`、`query.grpc.server`、`storegateway.grpc.server` 和 `receive.grpc.server` 部分下）值来加密通信。图表允许三种配置选项：

- 使用 `*.tls.ca`、`*.tls.cert`、`*.tls.key`（在 `query.grpc.client`、`query.grpc.server`、`storegateway.grpc.server` 和 `receive.grpc.server` 部分下）值提供证书内容。
- 使用 `*.tls.existingSecret`（在 `query.grpc.client`、`query.grpc.server`、`storegateway.grpc.server` 和 `receive.grpc.server` 部分下）值提供您自己的密钥。除了提供密钥名称外，还需要为 `ca-cert`、`tls-cert` 和 `tls-key` 元素设置密钥映射。例如：

```yaml
receive:
  grpc:
    server:
      tls:
        existingSecret:
          name: foo
          keyMapping:
            ca-cert: ca.pem
            tls-cert: cert.pem
            tls-key: key.pem
```

- 使用 `*.tls.autoGenerated=true`（在 `query.grpc.client`、`query.grpc.server`、`storegateway.grpc.server` 和 `receive.grpc.server` 部分下）让图表自动生成证书。

#### 滚动标签与不可变标签

在生产环境中强烈建议使用不可变标签。这确保如果相同的标签使用不同的镜像更新，您的部署不会自动更改。

如果主容器有新版本、重大更改或严重漏洞，Bitnami 将发布新图表更新其容器。

#### 添加额外标志

如果您想向任何 Thanos 组件添加额外标志，可以使用 `XXX.extraFlags` 参数，其中 XXX 是您需要替换为实际组件的占位符。例如，要向 Thanos Store Gateway 添加额外标志，请使用：

```yaml
storegateway:
  extraFlags:
    - --sync-block-duration=3m
    - --chunk-pool-size=2GB
```

这也适用于多行标志。当您想配置特定组件的缓存而不使用 configMap 时，这非常有用。例如，要配置 [Thanos Query Frontend 的 query-range 响应缓存](https://thanos.io/tip/components/query-frontend.md/#memcached)，使用：

```yaml
queryFrontend:
  extraFlags:
    - |
      --query-range.response-cache-config=
      type: MEMCACHED
      config:
        addresses:
          - <MEMCACHED_SERVER>:11211
        timeout: 500ms
        max_idle_connections: 100
        max_async_concurrency: 10
        max_async_buffer_size: 10000
        max_get_multi_concurrency: 100
        max_get_multi_batch_size: 0
        dns_provider_update_interval: 10s
        expiration: 24h
```

#### 使用自定义 Objstore 配置

此 helm 图表支持使用自定义 Objstore 配置。

您可以使用 `objstoreConfig` 参数指定 Objstore 配置。

此外，您还可以使用包含配置文件的外部 Secret。这通过设置 `existingObjstoreSecret` 参数来完成。请注意，这将覆盖先前的选项。如果需要，您还可以使用 `existingObjstoreSecretItems` 提供自定义 Secret Key，请注意您的 Secret 的路径应为 `objstore.yml`。

#### 使用自定义 Query 服务发现配置

此 helm 图表支持为 Query 使用自定义服务发现配置。

您可以使用 `query.sdConfig` 参数指定服务发现配置。

此外，您还可以使用包含服务发现配置文件的外部 ConfigMap。这通过设置 `query.existingSDConfigmap` 参数来完成。请注意，这将覆盖先前的选项。

#### 使用自定义 Ruler 配置

此 helm 图表支持使用自定义 Ruler 配置。

您可以使用 `ruler.config` 参数指定 Ruler 配置。

此外，您还可以使用包含配置文件的外部 ConfigMap。这通过设置 `ruler.existingConfigmap` 参数来完成。请注意，这将覆盖先前的选项。

#### 使用 HTTPS 和基本身份验证运行 Thanos

此 helm 图表支持使用 HTTPS 和基本身份验证。基础功能是实验性的，未来可能会更改，图表中的相关设置也是如此。
有关更多信息，请参阅 [Thanos 文档](https://thanos.io/tip/operating/https.md/#running-thanos-with-https-and-basic-authentication)。

可以使用以下值启用此功能：

- `https.enabled=true`。启用 HTTPS 要求用户提供 Thanos 的 TLS 证书和密钥，可以使用以下选项之一完成：

  - 使用 `https.existingSecret` 提供密钥。该密钥必须包含 `tls.crt` 或 `tls.key` 键（可以使用 `https.keyFilename` 和 `https.certFilename` 值重命名键名）。
  - 在 values.yaml 中的 `https.cert` 和 `https.key` 值下提供证书和密钥。
  - 使用 `https.autoGenerated=true`，使用此值 Helm 将在图表初始化期间生成自签名密钥对。不推荐用于生产环境。

- `auth.basicAuthUsers.*`。一个键/值字典，其中键对应将有权访问 Thanos 的用户，值是明文密码。密码稍后将使用 bcrypt 加密。
- 或者，使用值 `httpConfig` 或 `existingHttpConfigSecret` 提供您自己的 Thanos http 配置文件。这可能导致忽略 `https.*` 或 `auth.*` 下的任何设置，除了与 TLS 证书相关的设置。使用这些参数提供配置文件时，除非应用以下修复之一，否则图表探针将无法初始化：
  - 设置 `https.enabled` 或 `auth.basicAuthUsers` 至少有一个用户，与您提供的配置文件匹配。这样探针将相应地配置 HTTPS 和/或基本身份验证。
  - 使用 `<component>.customLivenessProbe`、`<component>.customReadinessProbe` 和 `<component>.customStartupProbe` 配置您自己的探针。
  - **不推荐**。禁用探针。

#### 存储时间分区

Thanos 存储支持基于时间的分区。

设置时间分区将根据 `timePartitioning` 列表中的项目数创建 N 个存储 statefulsets。每个项目必须包含支持格式的查询最小和最大时间（在 [Thanos 文档](https://thanos.io/tip/components/store.md/#time-based-partitioning) 中找到更多详细信息）。

> 注意：将 `timePartitioning` 列表留空 (`[]`) 将创建一个用于所有数据的单个存储。

例如，要使用 3 个存储，您可以使用如下所示的 **values.yaml**：

```yaml
timePartitioning:
  # 一个用于 6 周前数据的存储
  - min: ""
    max: -6w
  # 一个用于 6 周前至 2 周前数据的存储
  - min: -6w
    max: -2w
  # 一个用于 2 周内数据的存储
  - min: -2w
    max: ""
```

您还可以为每个 storegateway statefulset 指定不同的资源和限制配置。这通过向每个您希望更改的项目添加 `resources.requests` 和 `resources.limits` 来完成，如下所示：

```yaml
timePartitioning:
  # 一个用于 6 周前数据的存储
  - min: ""
    max: -6w
  # 一个用于 6 周前至 2 周前数据的存储
  - min: -6w
    max: -2w
    resources: # 分区的可选资源声明
      requests:
        cpu: 10m
        memory: 100Mi
      limits:
        cpu: 20m
        memory: 100Mi
  # 一个用于 2 周内数据的存储
  - min: -2w
    max: ""
```

#### 集成 Thanos 与 Prometheus 和 Alertmanager

您可以使用此图表和 [Bitnami kube-prometheus 图表](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) 将 Thanos 与 Prometheus 和 Alertmanager 集成，步骤如下：

> 注意：在此示例中，我们将使用 MinIO®（子图表）作为 Objstore。每个组件都将部署在 "monitoring" 命名空间中。

- 创建如下所示的 **values.yaml**：

```yaml
objstoreConfig: |-
  type: s3
  config:
    bucket: thanos
    endpoint: {{ include "thanos.minio.fullname" . }}.{{ .Release.Namespace }}.svc.cluster.local:9000
    access_key: minio
    secret_key: minio123
    insecure: true
query:
  dnsDiscovery:
    sidecarsService: kube-prometheus-prometheus-thanos
    sidecarsNamespace: monitoring
bucketweb:
  enabled: true
compactor:
  enabled: true
store
