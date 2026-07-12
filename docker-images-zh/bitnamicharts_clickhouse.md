---
image: bitnamicharts/clickhouse
description: "Bitnami提供的Helm chart，用于在Kubernetes环境中简化ClickHouse列式数据库的部署、配置与管理，适用于OLAP场景下的数据分析需求。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/clickhouse
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/clickhouse
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/clickhouse" title="bitnamicharts/clickhouse Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/clickhouse 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami ClickHouse Helm Chart 文档

## 镜像概述和主要用途

Bitnami ClickHouse Helm Chart 用于在 Kubernetes 集群中部署 ClickHouse——一个开源的列式 OLAP (在线分析处理) 数据库管理系统。该 Chart 由 Bitnami 精心构建和维护，旨在提供快速、可靠且易于扩展的 ClickHouse 部署方案，适用于需要高性能数据分析、线性可扩展性和硬件效率优化的场景。

[ClickHouse 官方概述](https://clickhouse.com/)

**商标说明**：本软件列表由 Bitnami 打包。所提及的 respective 商标归各自公司所有，使用这些商标并不意味着任何关联或背书。


## 核心功能和特性

- **高可用性部署**：支持多副本和分片配置，依赖 ClickHouse Keeper 或外部 ZooKeeper 实现集群协调
- **监控集成**：原生支持 Prometheus 指标暴露，可配置 ServiceMonitor 与 Prometheus Operator 集成
- **安全强化**：支持 TLS 加密通信，可配置自定义证书或通过 CertManager 自动生成
- **灵活配置**：支持通过 ConfigMap 覆盖默认配置文件，或添加额外配置至 `config.d` 和 `users.d` 目录
- **持久化存储**：使用 Persistent Volume Claims (PVC) 确保数据持久化，支持多节点存储扩展
- **外部依赖支持**：可连接外部 ZooKeeper 集群，无需部署内置 ClickHouse Keeper
- **自定义工作流**：支持初始化脚本（initdb）和启动脚本（startdb），以及 Sidecar 容器扩展功能
- **资源优化**：可配置资源请求与限制，支持预设资源配置或自定义调整


## 使用场景和适用范围

- **大规模数据分析**：适用于需要对海量数据进行快速查询和聚合的场景，如日志分析、用户行为分析
- **业务智能平台**：作为 BI 工具的后端数据库，支持复杂报表生成和实时数据可视化
- **实时监控系统**：处理高吞吐量的时序数据，支持实时监控指标存储与查询
- **Kubernetes 环境部署**：专为 Kubernetes 集群设计，支持 Helm 一键部署和管理，适合容器化基础设施
- **开发与生产环境**：提供灵活配置，满足开发环境快速搭建和生产环境高可用、安全强化需求


## 详细使用方法和配置说明

### TL;DR

快速部署命令：

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/clickhouse
```

> **提示**：此应用也可作为 Azure Marketplace 上的 Kubernetes 应用使用。Kubernetes 应用是在 AKS 上部署 Bitnami 应用的最简单方式。点击 [此处](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/bitnami.clickhouse-cnab) 查看 Azure Marketplace 列表。

如需在生产环境使用 ClickHouse，可尝试 [VMware Tanzu Application Catalog](https://bitnami.com/enterprise)，这是 Bitnami 目录的商业版本。


### ⚠️ 重要通知：Bitnami 目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共目录，在新的 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications) 下提供精选的强化、安全聚焦镜像。此次变更包括：

- 首次向社区用户开放流行容器镜像的安全优化版本访问权限
- Bitnami 将开始在免费层中弃用对非强化 Debian 基础软件镜像的支持，并逐步从公共目录中移除非最新标签。因此，社区用户将只能访问数量减少的强化镜像，这些镜像仅以 “latest” 标签发布，仅供开发使用
- 自 8 月 28 日起，两周内所有现有容器镜像（包括旧版本或带版本的标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至 “Bitnami Legacy” 仓库（docker.io/bitnamilegacy），且不再接收更新
- 对于生产工作负载和长期支持，建议用户采用 Bitnami Secure Images，包括强化容器、更小的攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 以及企业支持

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提升所有 Bitnami 用户的安全态势。更多详情，请访问 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


### 前提条件

- Kubernetes 集群版本 1.23+
- Helm 版本 3.8.0+
- 底层基础设施支持 PV 供应器
- 支持 ReadWriteMany 卷（用于部署扩展）

> 若使用 Kubernetes 1.18，需注释以下代码：
> ```yaml
> seccompProfile:
>   type: "RuntimeDefault"
> ```


### 安装 Helm Chart

#### 基本安装

使用发布名称 `my-release` 安装 Chart：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/clickhouse
```

> **注意**：需将占位符 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 替换为 Helm 仓库地址。例如，Bitnami 官方仓库需使用 `REGISTRY_NAME=registry-1.docker.io` 和 `REPOSITORY_NAME=bitnamicharts`。

上述命令将以默认配置在 Kubernetes 集群中部署 ClickHouse。配置参数可在安装时通过 `--set` 或 `-f` 指定，详见 [参数](#参数) 部分。

> **提示**：使用 `helm list` 查看所有发布版本。


### 配置与部署细节

#### 资源请求与限制

Bitnami Chart 允许为部署中的所有容器设置资源请求（requests）和限制（limits），配置路径为 `resources`（见参数表）。生产环境中必须设置资源请求，并根据实际场景调整。

为简化配置，Chart 提供 `resourcesPreset` 参数，可根据预设自动设置 `resources` 部分。预设定义详见 [bitnami/common Chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15)。**生产环境不建议使用 `resourcesPreset`**，因其可能无法完全适配具体需求。更多容器资源管理详情，请参考 [Kubernetes 官方文档](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)。


#### Prometheus 指标集成

通过设置 `metrics.enabled=true` 可启用 Prometheus 集成，此时将暴露 ClickHouse 原生 Prometheus 端点，并添加自动抓取所需的注解。

##### 前提条件

需已安装 Prometheus 或 Prometheus Operator。推荐安装 [Bitnami Prometheus Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) 或 [Bitnami Kube Prometheus Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus)。

##### 与 Prometheus Operator 集成

设置 `metrics.serviceMonitor.enabled=true` 可部署 `ServiceMonitor` 对象，实现与 Prometheus Operator 集成。需确保集群中已安装 Prometheus Operator CustomResourceDefinitions，否则会报错：

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```


#### 滚动标签 vs 不可变标签

**生产环境强烈建议使用不可变标签**，以避免标签更新导致部署自动变更。Bitnami 会在主容器版本更新、重大变更或发现严重漏洞时，发布新的 Chart 以更新容器镜像。


#### 更新凭证

Bitnami Chart 在首次启动时配置凭证，后续更新需手动操作：

1. 按 [上游文档](https://clickhouse.com/docs/en/sql-reference/statements/alter/user) 更新用户密码
2. 更新密码 Secret（替换 `SECRET_NAME` 和 `PASSWORD` 占位符）：

```shell
kubectl create secret generic SECRET_NAME --from-literal=admin-password=PASSWORD --dry-run -o yaml | kubectl apply -f -
```


#### ClickHouse Keeper

默认情况下，Chart 会部署 ClickHouse Keeper（轻量级 ZooKeeper 替代方案）作为独立 StatefulSet。**当 ClickHouse 副本数 >1 或使用分片时，Keeper 为必填组件**。


#### 外部 ZooKeeper 支持

如需连接外部 ZooKeeper 而非内置 Keeper（如使用托管服务或共享集群），可通过 `externalZookeeper` 参数配置，并禁用 Keeper：

```console
helm install my-release oci://... --set keeper.enabled=false \
  --set externalZookeeper.servers[0]=myexternalhost \
  --set externalZookeeper.port=2888
```


#### 配置 ClickHouse

ClickHouse 配置支持两种扩展方式：

1. **覆盖默认配置**：通过 `configuration` 参数自定义 `config.xml`，或使用 `existingConfigmap` 从 ConfigMap 加载配置
2. **添加额外配置**：通过 `configdFiles` 和 `usersdFiles` 参数添加文件至 `config.d` 和 `users.d` 目录（详见 [上游文档](https://clickhouse.com/docs/operations/configuration-files)），或使用 `existingConfigdConfigmap` 和 `existingUsersdConfigmap` 从 ConfigMap 加载

> **注意**：Chart 默认会在 `config.d` 挂载一系列自动生成的配置文件（前缀为 `01-`、`02-`...`06-`）。自定义文件需使用更高前缀（如 `99-`）以避免被覆盖。


#### Ingress 配置

若集群已安装 Ingress 控制器（如 [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) 或 [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour)），可通过 Ingress 暴露服务。设置 `ingress.enabled=true` 启用 Ingress 集成。

- **单主机配置**：通过 `ingress.hostname` 设置主机名，`ingress.tls` 配置 TLS
- **多主机配置**：通过 `ingress.extraHosts` 添加额外主机，`ingress.extraTLS` 配置对应 TLS

> **注意**：`ingress.extraHosts` 需指定名称、路径及 Ingress 控制器所需注解。注解支持情况因控制器而异，参考 [注解列表](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md)。


#### TLS 加密通信

设置 `tls.enabled=true` 启用 TLS 加密，需创建包含证书的 Secret，并通过以下参数传入：

- `tls.existingCASecret`：CA 证书 Secret（包含 `tls.crt` 和 `tls.key`）
- `tls.server.existingSecret`：服务端证书 Secret

**证书生成方式**：

1. **手动创建**：

```console
kubectl create secret generic ca-tls-secret --from-file=./tls.crt --from-file=./tls.key
```

2. **自动生成**：
   - **Helm 引擎**：`tls.autoGenerated.enabled=true` 且 `tls.autoGenerated.engine=helm`
   - **CertManager**：`tls.autoGenerated.enabled=true` 且 `tls.autoGenerated.engine=cert-manager`，可通过 `tls.autoGenerated.certManager.existingIssuer` 指定现有 Issuer/ClusterIssuer


#### 额外环境变量

通过 `extraEnvVars` 添加额外环境变量：

```yaml
clickhouse:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

或通过 ConfigMap/Secret 加载：

- `extraEnvVarsCM`：从 ConfigMap 加载环境变量
- `extraEnvVarsSecret`：从 Secret 加载环境变量


#### Sidecar 容器

通过 `sidecars` 参数添加 Sidecar 容器（如指标导出器、日志收集器）：

```yaml
sidecars:
- name: metrics-exporter
  image: docker.xuanyuan.run/my-exporter:latest
  imagePullPolicy: Always
  ports:
  - name: metrics
    containerPort: 9100
```

如需暴露 Sidecar 端口，通过 `service.extraPorts` 配置：

```yaml
service:
  extraPorts:
  - name: exporter-port
    port: 9100
    targetPort: metrics
```


#### 自定义脚本

支持初始化脚本（首次启动执行）和启动脚本（每次启动执行），脚本挂载路径分别为 `/docker-entrypoint.initdb.d` 和 `/docker-entrypoint.startdb.d`：

- **直接配置**：通过 `initdbScripts` 和 `startdbScripts` 参数定义脚本
- **通过 Secret 加载**：通过 `initdbScriptsSecret` 和 `startdbScriptsSecret` 指定包含脚本的 Secret

```yaml
initdbScriptsSecret: init-scripts-secret  # 包含初始化脚本的 Secret 名称
startdbScriptsSecret: start-scripts-secret  # 包含启动脚本的 Secret 名称
```


#### Pod 亲和性配置

通过 `affinity` 参数自定义 Pod 亲和性，或使用 [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) Chart 提供的预设：

- `podAffinityPreset`：Pod 亲和性预设
- `podAntiAffinityPreset`：Pod 反亲和性预设
- `nodeAffinityPreset`：节点亲和性预设

详情参考 [Kubernetes 亲和性文档](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity)。


#### 备份与恢复

使用 [Velero](https://velero.io/)（Kubernetes 备份工具）备份持久卷并恢复部署。操作指南参考 [Bitnami 备份恢复文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html)。


### 持久性

Bitnami ClickHouse 镜像将数据和配置存储在容器的 `/bitnami/clickhouse` 路径。通过 Persistent Volume Claims (PVC) 实现数据持久化，支持 GCE、AWS、minikube 等环境。


### 参数

#### 全局参数

| 参数名 | 描述 | 默认值 |
| --- | --- | --- |
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局镜像拉取密钥数组 | `[]` |
| `global.defaultStorageClass` | 持久卷默认 StorageClass | `""` |
| `global.security.allowInsecureImages` | 是否允许不安全镜像（跳过验证） | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 适配 OpenShift restricted-v2 SCC（auto/force/disabled） | `auto` |

#### 通用参数

| 参数名 | 描述 | 默认值 |
| --- | --- | --- |
| `kubeVersion` | 覆盖 Kubernetes 版本 | `""` |
| `apiVersions` | 覆盖 .Capabilities 报告的 API 版本 | `[]` |
| `nameOverride` | 部分覆盖资源名称前缀 | `""` |
| `fullnameOverride` | 完全覆盖资源全名 | `""` |
| `namespaceOverride` | 覆盖命名空间 | `""` |
| `commonLabels` | 所有资源标签 | `{}` |
| `commonAnnotations` | 所有资源注解 | `{}` |
| `clusterDomain` | Kubernetes 集群域名 | `cluster.local` |
| `extraDeploy` | 额外部署的 Kubernetes 对象数组 | `[]` |
| `usePasswordFiles` | 以文件方式挂载凭证（而非环境变量） | `true` |
| `diagnosticMode.enabled` | 启用诊断模式（禁用探针，覆盖命令） | `false` |
| `diagnosticMode.command` | 诊断模式命令 | `["sleep"]` |
| `diagnosticMode.args` | 诊断模式参数 | `["infinity"]` |

#### 默认初始化容器参数

| 参数名 | 描述 | 默认值 |
| --- | --- | --- |
| `defaultInitContainers.volumePermissions.enabled` | 启用修改持久卷权限的初始化容器 | `false` |
| `defaultInitContainers.volumePermissions.image.registry` | volume-permissions 镜像仓库 | `REGISTRY_NAME` |
| `defaultInitContainers.volumePermissions.image.repository` | volume-permissions 镜像仓库路径 | `REPOSITORY_NAME/os-shell` |
| `defaultInitContainers.volumePermissions.image.digest` | 镜像摘要（覆盖标签） | `""` |
| `defaultInitContainers.volumePermissions.image.pullPolicy` | 镜像拉取策略 | `IfNotPresent` |

> **注**：完整参数列表请参考 [Bitnami ClickHouse Chart 官方文档](https://github.com/bitnami/charts/blob/main/bitnami/clickhouse/README.md)。
