---
image: bitnamicharts/prometheus
description: "Bitnami提供的Helm图表，用于在Kubernetes集群中简化Prometheus监控工具的部署与管理。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/prometheus
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/prometheus
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/prometheus" title="bitnamicharts/prometheus Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/prometheus — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnamicharts/prometheus" title="bitnamicharts/prometheus Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnamicharts/prometheus</a>

# Bitnami Prometheus Helm Chart

## 镜像概述和主要用途

Prometheus 是一款开源的监控和告警系统，能够通过配置的目标定期采集指标，帮助系统管理员监控基础设施。Bitnami 提供的 Prometheus Helm Chart 经过精心设计和维护，可快速、简便地在 Kubernetes 集群中部署 Prometheus，适用于开发和生产环境的容器化应用监控需求。

[Prometheus 官方概述](https://prometheus.io/)

**商标说明**：本软件列表由 Bitnami 打包。所提及的商标分别归各自公司所有，使用这些商标并不意味着任何关联或认可。


## 核心功能和特性

- **指标采集**：支持从配置的目标以指定间隔采集监控指标
- **告警管理**：集成 Alertmanager 实现告警规则配置和通知分发
- **灵活集成**：可与 Thanos、Grafana Mimir、Grafana 等工具无缝集成
- **资源优化**：支持自定义资源请求与限制，适配不同负载需求
- **持久化存储**：支持 PV 存储，确保监控数据持久化
- **安全强化**：遵循容器安全最佳实践，后续将迁移至 Bitnami Secure Images
- **Kubernetes 原生**：支持 Kubernetes 服务发现、Pod 亲和性/反亲和性配置


## 使用场景和适用范围

### 适用场景
- Kubernetes 集群基础设施监控
- 微服务应用性能指标采集与分析
- 自定义业务指标监控与告警
- 与 Grafana 结合构建可视化监控面板
- 与 Thanos 集成实现长期指标存储和查询

### 适用范围
- **开发环境**：适合使用社区版“latest”标签镜像进行开发测试
- **生产环境**：建议采用 Bitnami Secure Images（提供硬化容器、CVE 透明度、SBOM 和企业支持）


## 前提条件

- Kubernetes 1.23+
- Helm 3.8.0+
- 底层基础设施支持 PV 供应
- 支持 ReadWriteMany 卷（用于部署扩展）


## 详细使用方法和配置说明

### 快速安装（TL;DR）

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/prometheus
```

> 注意：生产环境建议使用 [VMware Tanzu Application Catalog](https://bitnami.com/enterprise)（Bitnami 商业版目录）。


### 安装步骤

使用发布名称 `my-release` 安装 Chart：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/prometheus
```

> 注意：需替换占位符 `REGISTRY_NAME` 和 `REPOSITORY_NAME`。例如，Bitnami 官方仓库需使用 `REGISTRY_NAME=registry-1.docker.io` 和 `REPOSITORY_NAME=bitnamicharts`。

默认配置将在 Kubernetes 集群中部署 Prometheus。可通过 [参数](#参数说明) 部分配置自定义选项。

> 提示：使用 `helm list` 查看所有发布。


### 配置详情

#### 资源请求与限制

Bitnami Charts 允许为部署中的所有容器设置资源请求和限制，通过 `resources` 参数配置。生产环境必须设置资源请求，并根据实际需求调整。

可通过 `resourcesPreset` 参数应用预设资源配置（详见 [bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15)），但生产环境不建议依赖预设，需根据具体负载自定义。更多信息参见 [Kubernetes 容器资源管理文档](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)。


#### 滚动标签与不可变标签

生产环境强烈建议使用不可变标签，避免因标签更新导致部署自动变更。Bitnami 会在主容器更新、重大变更或存在严重漏洞时发布新 Chart 更新容器镜像。


#### 部署额外资源

可通过 `extraDeploy` 参数部署额外 Kubernetes 对象（如 ConfigMap、Deployment 等），需提供完整对象规格。


#### 备份与恢复

使用 [Velero](https://velero.io/)（Kubernetes 备份/恢复工具）备份源部署的持久卷，并将其附加到新部署。详见 [Velero 使用指南](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html)。


#### Pod 亲和性配置

可通过 `XXX.affinity` 参数设置自定义亲和性，或使用 [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) Chart 提供的预设配置（`XXX.podAffinityPreset`、`XXX.podAntiAffinityPreset`、`XXX.nodeAffinityPreset`）。


### 集成示例

#### 与 Thanos 集成

使用 Prometheus Chart 与 [Bitnami Thanos Chart](https://github.com/bitnami/charts/tree/main/bitnami/thanos) 集成（以 MinIO 作为对象存储，部署在 `monitoring` 命名空间）：

1. 创建 Thanos 配置文件 `values.yaml`：

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
    sidecarsService: prometheus-thanos
    sidecarsNamespace: monitoring
bucketweb:
  enabled: true
compactor:
  enabled: true
storegateway:
  enabled: true
ruler:
  enabled: true
  alertmanagers:
    - http://prometheus-alertmanager.monitoring.svc.cluster.local:9093
  config: |-
    groups:
      - name: "metamonitoring"
        rules:
          - alert: "PrometheusDown"
            expr: absent(up{prometheus="monitoring/prometheus"})
metrics:
  enabled: true
  serviceMonitor:
    enabled: true
minio:
  enabled: true
  auth:
    rootPassword: minio123
    rootUser: minio
  monitoringBuckets: thanos
  accessKey:
    password: minio
  secretKey:
    password: minio123
```

2. 安装 Prometheus 和 Thanos：

```console
kubectl create namespace monitoring
helm install prometheus \
    --set prometheus.thanos.create=true \
    --namespace monitoring \
    oci://registry-1.docker.io/bitnamicharts/prometheus
helm install thanos \
    --values values.yaml \
    --namespace monitoring \
    oci://registry-1.docker.io/bitnamicharts/thanos
```


#### 与 Grafana Mimir 集成

通过 `remoteWrite` 配置将 Prometheus 与 Grafana Mimir 集成：

1. 创建 Prometheus 配置文件 `values.yaml`：

```yaml
server:
  remoteWrite:
    - url: http://grafana-mimir-gateway.svc.cluster.local/api/v1/push
      headers:
        X-Scope-OrgID: demo
```

2. 安装 Prometheus 和 Grafana Mimir：

```console
kubectl create namespace monitoring
helm install prometheus \
    --values values.yaml \
    --namespace monitoring \
    oci://registry-1.docker.io/bitnamicharts/prometheus
helm install grafana-mimir \
    oci://registry-1.docker.io/bitnamicharts/grafana-mimir
```


#### 与 Grafana 集成

配置 Grafana 数据源连接 Prometheus：

1. 创建 Grafana 配置文件 `values.yaml`：

```yaml
datasources:
  secretDefinition:
    apiVersion: 1
    datasources:
      - name: Prometheus
        type: prometheus
        access: proxy
        orgId: 1
        url: http://prometheus.monitoring.svc.cluster.local
        version: 1
        editable: true
        isDefault: true
      - name: Alertmanager
        uid: alertmanager
        type: alertmanager
        access: proxy
        orgId: 1
        url: http://prometheus-alertmanager.monitoring.svc.cluster.local:9093
        version: 1
        editable: true
```

2. 安装 Prometheus 和 Grafana：

```console
kubectl create namespace monitoring
helm install prometheus \
    --namespace monitoring \
    oci://registry-1.docker.io/bitnamicharts/prometheus
helm install grafana \
    --values values.yaml \
    --namespace monitoring \
    oci://registry-1.docker.io/bitnamicharts/grafana
```


#### 添加自定义监控目标

通过 `server.extraScrapeConfigs` 参数添加自定义监控目标，格式遵循 Prometheus [scrape_configs](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config)。示例：监控 default 命名空间中的 WordPress：

```yaml
server:
  extraScrapeConfigs:
    - job_name: wordpress
      kubernetes_sd_configs:
        - role: endpoints
          namespaces:
            names:
            - default
      metrics_path: /metrics
      relabel_configs:
        - source_labels: [job]
          target_label: __tmp_wordpress_job_name
        - action: keep
          source_labels: [__meta_kubernetes_service_label_app_kubernetes_io_instance, __meta_kubernetes_service_labelpresent_app_kubernetes_io_instance]
          regex: (wordpress);true
        - action: keep
          source_labels: [__meta_kubernetes_service_label_app_kubernetes_io_name, __meta_kubernetes_service_labelpresent_app_kubernetes_io_name]
          regex: (wordpress);true
        - action: keep
          source_labels: [__meta_kubernetes_endpoint_port_name]
          regex: metrics
        # 更多 relabel 配置...
```


## 参数说明

### 全局参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局 Docker 镜像拉取密钥数组 | `[]` |
| `global.defaultStorageClass` | 持久卷全局默认 StorageClass | `""` |
| `global.storageClass` | 已弃用：使用 global.defaultStorageClass 替代 | `""` |
| `global.security.allowInsecureImages` | 是否允许跳过镜像验证 | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 适配 OpenShift restricted-v2 SCC 的安全上下文（auto/force/disabled） | `auto` |


### 通用参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `kubeVersion` | 覆盖 Kubernetes 版本 | `""` |
| `nameOverride` | 部分覆盖资源名称前缀 | `""` |
| `fullnameOverride` | 完全覆盖资源全名 | `""` |
| `namespaceOverride` | 覆盖命名空间 | `""` |
| `commonLabels` | 添加到所有资源的标签 | `{}` |
| `commonAnnotations` | 添加到所有资源的注解 | `{}` |
| `clusterDomain` | Kubernetes 集群域名 | `cluster.local` |
| `extraDeploy` | 额外部署的 Kubernetes 对象数组 | `[]` |
| `diagnosticMode.enabled` | 启用诊断模式（禁用探针并覆盖命令） | `false` |
| `diagnosticMode.command` | 诊断模式下覆盖所有容器的命令 | `["sleep"]` |
| `diagnosticMode.args` | 诊断模式下覆盖所有容器的参数 | `["infinity"]` |
| `ingress.apiVersion` | 强制 Ingress API 版本（自动检测如果未设置） | `""` |


### Alertmanager 参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `alertmanager.enabled` | 是否启用 Alertmanager | `true` |
| `alertmanager.image.registry` | Alertmanager 镜像仓库 | `REGISTRY_NAME` |
| `alertmanager.image.repository` | Alertmanager 镜像名称 | `REPOSITORY_NAME/alertmanager` |
| `alertmanager.image.digest` | 镜像摘要（覆盖标签，建议使用不可变标签） | `""` |
| `alertmanager.image.pullPolicy` | 镜像拉取策略 | `IfNotPresent` |
| `alertmanager.image.pullSecrets` | 镜像拉取密钥 | `[]` |
| `alertmanager.configuration` | Alertmanager 配置（模板化内容） | `""` |
| `alertmanager.replicaCount` | 副本数 | `1` |
| `alertmanager.containerPorts.http` | HTTP 端口 | `9093` |
| `alertmanager.containerPorts.cluster` | 集群 HA 端口 | `9094` |
| `alertmanager.livenessProbe.enabled` | 是否启用存活探针 | `true` |
| `alertmanager.livenessProbe.initialDelaySeconds` | 存活探针初始延迟（秒） | `5` |
| `alertmanager.livenessProbe.periodSeconds` | 存活探针周期（秒） | `20` |
| `alertmanager.livenessProbe.timeoutSeconds` | 存活探针超时（秒） | `5` |


> 注意：完整参数列表请参见 [GitHub 文档](https://github.com/bitnami/charts/blob/main/bitnami/prometheus/README.md)（原 README 因长度限制被截断）。


## ⚠️ 重要通知：Bitnami 镜像目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共目录，通过 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications) 提供精选的硬化、安全聚焦镜像。过渡要点：

- 首次向社区用户开放流行容器镜像的安全优化版本
- 社区版将逐步弃用非硬化 Debian 基础镜像，仅保留“latest”标签的硬化镜像（用于开发）
- 8 月 28 日起两周内，所有现有容器镜像（含历史版本标签，如 2.50.0、10.6）将从公共仓库（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再更新
- 生产环境建议采用 Bitnami Secure Images，包含硬化容器、更小攻击面、CVE 透明度（VEX/KEV）、SBOM 和企业支持

更多详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。
