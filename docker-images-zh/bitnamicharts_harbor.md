<!-- xuanyuan-docker-images-zh
image: bitnamicharts/harbor
source: https://xuanyuan.cloud/zh/r/bitnamicharts/harbor
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/harbor
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/bitnamicharts/harbor" title="bitnamicharts/harbor Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/harbor — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/bitnamicharts/harbor" title="bitnamicharts/harbor Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnamicharts/harbor</a></p>

# Harbor 镜像文档

## 镜像概述和主要用途

Harbor 是一个开源的可信云原生 registry，用于存储、签名和扫描内容。它在开源 Docker distribution 的基础上，添加了安全、身份认证和管理等功能，适用于企业级容器镜像的全生命周期管理。

[Harbor 官方概述](https://goharbor.io/)

## 核心功能和特性

Bitnami Harbor Helm Chart 基于 [goharbor/harbor-helm](https://github.com/goharbor/harbor-helm) 开发，具备以下特性：

- 支持从私有 registry 拉取所有所需镜像（通过全局 Docker 镜像参数配置）
- Redis® 和 PostgreSQL 作为 chart 依赖进行管理
- 为所有部署提供可配置的存活探针（Liveness Probe）和就绪探针（Readiness Probe）
- 采用新的 Helm chart 标签格式
- 默认使用 Bitnami 非 root 容器镜像
- 支持 Harbor 可选组件部署
- 可配置资源请求与限制，适应不同负载场景
- 内置 Prometheus 监控集成能力
- 支持内部 TLS 加密通信，可自定义证书或自动生成
- 灵活的流量暴露方式（Ingress/Proxy）
- 支持数据库 schema 自动迁移
- 兼容 Sidecar 和 Init 容器扩展
- 支持自定义环境变量注入

## 使用场景和适用范围

Harbor 适用于需要安全管理容器镜像的云原生环境，主要使用场景包括：

- **企业内部容器镜像仓库**：提供私有、安全的镜像存储，支持访问控制和权限管理
- **CI/CD 流程集成**：作为镜像构建流水线的存储端点，支持镜像签名和漏洞扫描，确保部署安全性
- **多集群镜像分发**：通过复制功能实现跨集群镜像同步，适用于混合云或多云环境
- **合规与审计**：提供镜像操作审计日志，满足企业合规要求
- **开发与测试环境**：为开发团队提供本地镜像仓库，加速镜像拉取和部署流程

## 前提条件

部署 Harbor 需满足以下环境要求：

- Kubernetes 集群版本 1.23+
- Helm 版本 3.8.0+
- 底层基础设施支持 PV 动态供应
- 支持 ReadWriteMany 卷（用于部署扩展）

## 安装方法

### Helm 安装（推荐）

#### 快速安装

使用默认配置安装 chart，发布名称为 `my-release`：

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/harbor
```

#### 自定义安装

指定自定义 registry 和仓库路径：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/harbor
```

> 注意：需将 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 替换为实际的 Helm chart 仓库地址。例如，Bitnami 官方仓库需使用 `REGISTRY_NAME=registry-1.docker.io` 和 `REPOSITORY_NAME=bitnamicharts`。

## 配置说明

### 资源请求与限制

Bitnami charts 允许为所有容器设置资源请求（requests）和限制（limits），配置位于 `resources` 参数下。生产环境中必须设置资源请求，并根据实际负载调整。

chart 提供 `resourcesPreset` 参数，可通过预设自动配置 `resources` 部分（详见 [bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15)）。但生产环境不建议依赖预设，需根据具体需求手动配置。

### 滚动标签与不可变标签

生产环境强烈建议使用不可变标签（immutable tags），避免因标签更新导致部署意外变更。Bitnami 会在主容器更新、重大变更或发现严重漏洞时，发布新的 chart 版本。

### Prometheus 监控集成

通过设置 `metrics.enabled=true` 可启用 Prometheus 监控集成，将 Harbor 原生 Prometheus 端口暴露在容器和服务中，并添加自动发现注解。

#### 前置条件

需已安装 Prometheus 或 Prometheus Operator。推荐使用 [Bitnami Prometheus Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) 或 [Bitnami Kube Prometheus Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus)。

#### Prometheus Operator 集成

设置 `metrics.serviceMonitor.enabled=true` 可部署 `ServiceMonitor` 对象，实现与 Prometheus Operator 的集成。需确保集群已安装 Prometheus Operator CRDs，否则会报错：

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

### 流量暴露配置

Harbor 核心服务支持两种暴露方式：

#### Ingress 控制器（推荐生产环境）

设置 `exposureType=ingress`，需满足：

- 集群已安装 Ingress 控制器
- 若禁用 TLS，拉取/推送镜像时需显式指定端口（详见 [Issue #5291](https://github.com/goharbor/harbor/issues/5291)）

#### NGINX Proxy（简单测试环境）

设置 `exposureType=proxy`，支持三种服务类型：

- **ClusterIP**：仅集群内部可访问，通过集群内 IP 暴露
- **NodePort**：通过节点 IP:静态端口暴露，集群外部可访问
- **LoadBalancer**：使用云厂商负载均衡器暴露，需配置 DNS 解析

### 外部 URL 配置

外部 URL 用于在 Harbor 门户中生成 docker/helm 命令示例，格式为 `protocol://domain[:port]`。配置规则：

- Ingress 暴露：`domain` 为 `ingress.core.hostname` 的值
- ClusterIP 暴露：`domain` 为 `service.clusterIP` 的值
- NodePort 暴露：`domain` 为 Kubernetes 节点 IP
- LoadBalancer 暴露：`domain` 为自定义域名，需配置 CNAME 指向云厂商提供的负载均衡器地址
- 代理后端部署：设置为代理服务器 URL

### 数据库 Schema 更新

通过设置 `migration.enabled=true` 启用数据库 schema 迁移 Job。该 Job 依赖 Helm hooks，升级操作会等待迁移完成后继续。

### 内部 TLS 加密

设置 `internalTLS.enabled=true` 可启用 core、jobservice、portal、registry 和 trivy 组件间的 TLS 通信。支持两种配置方式：

- 通过 `*.tls.existingSecret`（各组件配置项下）指定现有证书密钥
- 未指定时自动生成证书

可通过 `internalTLS.caBundleSecret` 注入自定义 CA 证书（密钥需包含 `ca.crt` 文件）。

### 数据持久化配置

支持三种持久化方式：

- **禁用**：数据不持久化，Pod 重建后丢失
- **Persistent Volume Claim（默认）**：需集群存在默认 StorageClass，或通过 `storageClass` 指定存储类，也可通过 `existingClaim` 使用现有 PV
- **外部存储（仅镜像和图表）**：支持 `azure`、`gcs`、`s3`、`swift` 和 `oss`

### 密钥与证书管理

- **密钥（Secrets）**：用于加密和组件间安全通信，通过 `core.secret`、`jobservice.secret` 和 `registry.secret` 配置，需提供密钥内容（非密钥名称）
- **证书**：用于令牌加密/解密，通过 `core.secretName` 指定现有密钥

为避免 Helm 升级时密钥变更，需提前配置并固定密钥值（详见 [Issue #107](https://github.com/goharbor/harbor-helm/issues/107)）。支持通过 `existingSecret` 和 `existingEnvVarsSecret` 完全自定义密钥对象。

> 注意：`HARBOR_ADMIN_PASSWORD` 仅用于初始化，后续通过门户修改密码后，密钥中的值不会同步更新。

### Sidecar 和 Init 容器配置

可通过各组件的 `sidecars` 参数添加 Sidecar 容器：

```yaml
core:
  sidecars:
    - name: metrics-exporter
      image: your-exporter-image:latest
      imagePullPolicy: Always
      ports:
        - name: metrics
          containerPort: 9100
```

通过 `initContainers` 参数添加 Init 容器：

```yaml
core:
  initContainers:
    - name: init-config
      image: busybox:latest
      command: ["sh", "-c", "echo 'init config' > /config/init.txt"]
      volumeMounts:
        - name: config
          mountPath: /config
```

### 环境变量注入

通过各组件的 `extraEnvVars` 添加环境变量：

```yaml
core:
  extraEnvVars:
    - name: LOG_LEVEL
      value: "error"
```

也可通过 `extraEnvVarsCM` 或 `extraEnvVarsSecret` 引用 ConfigMap 或 Secret 中的环境变量。

## 配置参数

### 全局参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `global.imageRegistry` | 全局 Docker 镜像仓库地址 | `""` |
| `global.imagePullSecrets` | 全局镜像拉取密钥数组 | `[]` |
| `global.defaultStorageClass` | 全局默认存储类 | `""` |
| `global.security.allowInsecureImages` | 是否允许跳过镜像验证 | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 调整安全上下文以兼容 OpenShift restricted-v2 SCC（可选值：auto/force/disabled） | `auto` |

### 通用参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `nameOverride` | 部分覆盖资源名称（保留 release 名称） | `""` |
| `fullnameOverride` | 完全覆盖资源名称 | `""` |
| `apiVersions` | 覆盖 .Capabilities 报告的 Kubernetes API 版本 | `[]` |
| `kubeVersion` | 覆盖 .Capabilities 报告的 Kubernetes 版本 | `""` |
| `clusterDomain` | Kubernetes 集群域名 | `cluster.local` |
| `commonAnnotations` | 所有资源的通用注解 | `{}` |
| `commonLabels` | 所有资源的通用标签 | `{}` |
| `extraDeploy` | 额外部署的资源清单（模板化） | `[]` |
| `diagnosticMode.enabled` | 启用诊断模式（禁用所有探针并覆盖命令） | `false` |
| `diagnosticMode.command` | 诊断模式下覆盖所有容器的命令 | `["sleep"]` |
| `diagnosticMode.args` | 诊断模式下覆盖所有容器的参数 | `["infinity"]` |

### Harbor 通用参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `adminPassword` | Harbor 管理员初始密码（建议通过门户修改） | `""` |
| `existingSecret` | 存储管理员密码的现有 Secret 名称 | `""` |
| `existingSecretAdminPasswordKey` | 现有 Secret 中管理员密码的密钥名（默认 HARBOR_ADMIN_PASSWORD） | `""` |
| `externalURL` | Harbor 核心服务的外部 URL | `https://core.harbor.domain` |
| `proxy.httpProxy` | HTTP 代理服务器 URL | `""` |
| `proxy.httpsProxy` | HTTPS 代理服务器 URL | `""` |
| `proxy.noProxy` | 不使用代理的地址列表 | `127.0.0.1,localhost,.local,.internal` |
| `proxy.components` | 应用代理配置的组件列表 | `["core","jobservice","trivy"]` |
| `logLevel` | Harbor 服务日志级别（可选值：fatal/error/warn/info/debug/trace） | `debug` |
| `internalTLS.enabled` | 为核心组件启用内部 TLS 通信 | `false` |
| `internalTLS.caBundleSecret` | 包含自定义 CA 的 Secret 名称（注入信任链） | `""` |
| `ipFamily.ipv6.enabled` | 为 NGINX 组件启用 IPv6 监听 | `true` |
| `ipFamily.ipv4.enabled` | 为 NGINX 组件启用 IPv4 监听 | `true` |
| `cache.enabled` | 启用 Redis 清单缓存（提升并发拉取性能） | `false` |
| `cache.expireHours` | 缓存过期时间（小时） | `24` |
| `database.maxIdleConns` | 每个组件的数据库空闲连接池上限 | `100` |
| `database.maxOpenConns` | 每个组件的数据库最大打开连接数 | `900` |

### 流量暴露参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `exposureType` | 流量暴露方式（可选值：ingress/proxy/none） | `proxy` |
| `service.type` | NGINX Proxy 服务类型 | `LoadBalancer` |
| `service.ports.http` | NGINX Proxy HTTP 端口 | `80` |
| `service.ports.https` | NGINX Proxy HTTPS 端口 | `443` |
| `service.nodePorts.http` | NodePort 模式下的 HTTP 端口 | `""` |
| `service.nodePorts.https` | NodePort 模式下的 HTTPS 端口 | `""` |

## ⚠️ 重要通知：Bitnami 镜像仓库即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共镜像仓库，推出 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)，主要变更如下：

- 首次向社区用户开放安全优化版容器镜像
- 逐步弃用免费 tier 中的非强化 Debian 基础镜像，仅保留少量强化镜像（仅 `latest` 标签，用于开发环境）
- 8 月 28 日起，两周内所有现有镜像（含历史版本标签，如 2.50.0、10.6）将从公共仓库（docker.io/bitnami）迁移至 "Bitnami Legacy" 仓库（docker.io/bitnamilegacy），且不再更新
- 生产环境建议使用 Bitnami Secure Images，包含强化容器、更小攻击面、CVE 透明度（VEX/KEV）、SBOM 和企业支持

这些变更旨在提升软件供应链安全性，推广最佳实践。详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/bitnamicharts/harbor" title="bitnamicharts/harbor Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/bitnamicharts/harbor</a></p>
