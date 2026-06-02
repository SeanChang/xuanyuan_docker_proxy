---
image: bitnamicharts/elasticsearch
description: "Bitnami提供的Elasticsearch Helm chart，用于在Kubernetes环境中便捷部署和管理分布式搜索引擎Elasticsearch。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/elasticsearch
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/elasticsearch
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/elasticsearch" title="bitnamicharts/elasticsearch Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/elasticsearch — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnamicharts/elasticsearch" title="bitnamicharts/elasticsearch Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnamicharts/elasticsearch</a>

# Bitnami Elasticsearch Stack

## 1. 镜像概述和主要用途

Elasticsearch 是一个分布式搜索和分析引擎，适用于网络搜索、日志监控和实时分析场景，是大数据应用的理想选择。本 Bitnami Helm Chart 用于在 Kubernetes 集群上通过 Helm 包管理器快速部署 Elasticsearch 集群。

[Elasticsearch 官方概述](https://www.elastic.co/products/elasticsearch)

**商标说明**：本软件列表由 Bitnami 打包。所提及的商标分属各自公司所有，使用这些商标并不意味着任何关联或背书。


## 2. 核心功能和特性

- **分布式架构**：支持多节点集群部署，包含 master、data、coordinating、ingest 等角色分离
- **监控集成**：可与 Prometheus 集成，通过 elasticsearch_exporter 暴露指标
- **安全特性**：支持 TLS 加密（REST 端点和传输层）、内置用户认证
- **Kibana 集成**：作为子 Chart 提供一键启用 Kibana 的能力
- **灵活部署**：支持单节点模式（所有角色合一）和多节点集群模式
- **数据持久化**：使用 Persistent Volume 存储 Elasticsearch 数据
- **内核参数自动配置**：通过 initContainer 自动调整内核参数（如 vm.max_map_count）
- **快照与恢复**：支持配置共享文件系统作为快照仓库
- **扩展性**：支持添加自定义 Sidecar 容器、Init 容器和环境变量


## 3. 使用场景和适用范围

### 适用场景
- **开发/测试环境**：快速部署 Elasticsearch 集群用于功能验证和集成测试
- **日志管理**：集中收集、存储和分析应用日志、系统日志
- **实时分析**：对实时数据流进行聚合和分析（如用户行为、业务指标）
- **搜索引擎**：构建应用内搜索功能（如商品搜索、文档检索）

### 适用范围
- **社区用户**：可使用公共仓库（docker.io/bitnami）的镜像进行开发，仅支持 "latest" 标签且无长期更新
- **生产环境**：推荐采用 Bitnami Secure Images，包含硬化容器、CVE 透明度（VEX/KEV）、SBOM 和企业支持


## 4. 重要注意事项：Bitnami 镜像仓库变更通知

自 2025 年 8 月 28 日起，Bitnami 将升级其公共镜像仓库，推出 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)，具体变更如下：

- 首次向社区用户开放热门容器镜像的安全优化版本
- 逐步弃用免费 tier 中非硬化的 Debian 基础镜像，公共仓库将仅保留少量硬化镜像，且仅提供 "latest" 标签（用于开发目的）
- 8 月 28 日起，所有现有容器镜像（包括历史版本标签，如 2.50.0、10.6）将从公共仓库（docker.io/bitnami）迁移至 "Bitnami Legacy" 仓库（docker.io/bitnamilegacy），且不再接收更新
- 生产环境建议采用 Bitnami Secure Images，提供硬化容器、更小攻击面、CVE 透明度及长期支持

详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


## 5. 使用方法和配置说明

### 5.1 前提条件

- Kubernetes 集群版本 1.23+
- Helm 版本 3.8.0+
- 底层基础设施支持 PV 动态供应


### 5.2 安装 Chart

#### 快速安装
```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/elasticsearch
```

#### 自定义安装
指定发布名称和仓库参数：
```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/elasticsearch
```
> **注意**：需将 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 替换为实际 Helm 仓库地址。Bitnami 官方仓库示例：`REGISTRY_NAME=registry-1.docker.io`，`REPOSITORY_NAME=bitnamicharts`。


### 5.3 配置详情

#### 5.3.1 资源请求与限制

Bitnami Charts 允许为所有容器设置资源请求和限制，通过 `resources` 参数配置。生产环境必须设置资源请求，且需根据实际场景调整。

可通过 `resourcesPreset` 参数使用预设资源配置（如 `small`、`medium`），但生产环境建议手动配置以适配具体需求。详情参见 [Kubernetes 资源管理文档](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)。


#### 5.3.2 滚动标签与不可变标签

生产环境强烈建议使用不可变标签，避免因标签更新导致部署自动变更。Bitnami 会在主容器版本更新、重大变更或存在严重漏洞时发布新 Chart。


#### 5.3.3 Prometheus 指标集成

通过设置 `metrics.enabled=true` 启用 Prometheus 集成，将在所有 Pod 中部署包含 `elasticsearch_exporter` 的 Sidecar 容器，并创建 `metrics` Service（支持自动被 Prometheus 抓取的注解配置）。

##### 前提条件
需已安装 Prometheus 或 Prometheus Operator。推荐使用 [Bitnami Prometheus Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) 或 [Bitnami Kube Prometheus Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus)。

##### 与 Prometheus Operator 集成
设置 `metrics.serviceMonitor.enabled=true` 可部署 `ServiceMonitor` 对象。需确保集群已安装 Prometheus Operator CRD，否则会报错：
```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```


#### 5.3.4 更改 Elasticsearch 版本

通过 `image.tag` 参数指定 [有效镜像标签](https://hub.docker.com/r/bitnami/elasticsearch/tags/) 以修改 Elasticsearch 版本，例如 `image.tag=X.Y.Z`。此方法同样适用于 exporters 等其他镜像。


#### 5.3.5 更新凭证

Bitnami Charts 在首次启动时配置凭证，后续凭证变更需手动操作：
1. 按照 [官方文档](https://www.elastic.co/guide/en/elasticsearch/reference/current/reset-password.html) 更新用户密码
2. 使用新密码更新 Secret（替换 `SECRET_NAME` 和 `PASSWORD` 占位符）：
```shell
kubectl create secret generic SECRET_NAME --from-literal=elasticsearch-password=PASSWORD --dry-run -o yaml | kubectl apply -f -
```


#### 5.3.6 默认内核设置

Elasticsearch 要求主机内核调整以下参数，否则容器将启动失败：
- 文件描述符限制：[File Descriptor requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/file-descriptors.html)
- 虚拟内存限制：[Virtual memory requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html)

本 Chart 通过特权 initContainer 自动配置内核参数：
```shell
sysctl -w vm.max_map_count=262144 && sysctl -w fs.file-max=65536
```
可通过 `sysctlImage.enabled=false` 禁用此 initContainer。


#### 5.3.7 启用内置 Kibana

通过设置 `global.kibanaEnabled=true` 启用 Kibana 子 Chart。安装时添加 `--render-subchart-notes` 参数可查看 Kibana 操作说明。

##### TLS 加密配置注意事项
当启用 Elasticsearch REST 加密时，需同步配置 Kibana：
```yaml
security:
  enabled: true
  elasticPassword: "<PASSWORD>"  # 需与 Elasticsearch 密码一致
  tls:
    autoGenerated: true  # 自动生成 TLS 证书

kibana:
  elasticsearch:
    security:
      auth:
        enabled: true
        kibanaUsername: "<USERNAME>"  # 默认用户为 elastic
        kibanaPassword: "<PASSWORD>"  # 与 Elasticsearch 密码一致
      tls:
        enabled: true  # 必须与 Elasticsearch REST 加密状态一致
        existingSecret: RELEASENAME-elasticsearch-coordinating-crt  # 证书 Secret 名称
        usePemCerts: true  # 自动生成的证书为 PEM 格式
```

**核心一致项**：启用 Elasticsearch REST 加密后，需确保以下值一致：
```yaml
security:
  tls:
    restEncryption: true

kibana:
  elasticsearch:
    security:
      tls:
        enabled: true
```


#### 5.3.8 部署单节点集群

通过以下配置部署单节点集群（单 master 节点承担所有角色）：
```yaml
master:
  masterOnly: false
  replicaCount: 1
data:
  replicaCount: 0
coordinating:
  replicaCount: 0
ingest:
  replicaCount: 0
```
单节点集群将启用 [单节点发现模式](https://www.elastic.co/guide/en/elasticsearch/reference/current/bootstrap-checks.html#single-node-discovery)。

**扩缩容注意事项**：如需扩展至多节点，需先刷新现有 StatefulSet 配置（例如先缩容至 0 副本避免配置不一致）：
```console
kubectl scale statefulset <DEPLOYMENT_NAME>-master --replicas=0
helm upgrade <DEPLOYMENT_NAME> oci://REGISTRY_NAME/REPOSITORY_NAME/elasticsearch --reset-values --set master.masterOnly=false
```


#### 5.3.9 添加额外环境变量

通过 `extraEnvVars` 直接添加环境变量：
```yaml
extraEnvVars:
  - name: ELASTICSEARCH_VERSION
    value: 7.0
```
或通过 ConfigMap/Secret 挂载：
- `extraEnvVarsCM`: 引用包含环境变量的 ConfigMap 名称
- `extraEnvVarsSecret`: 引用包含环境变量的 Secret 名称


#### 5.3.10 使用自定义 Init 脚本

通过以下参数挂载自定义初始化脚本（路径：`/docker-entrypoint.init-db`）：
- `initScripts`: 直接在 values.yaml 中定义脚本内容
- `initScriptsCM`: 引用包含脚本的 ConfigMap 名称
- `initScriptsSecret`: 引用包含敏感脚本的 Secret 名称

示例：
```yaml
initScriptsCM: special-scripts
initScriptsSecret: special-scripts-sensitive
```


#### 5.3.11 快照与恢复操作

需先注册快照仓库（参考 [官方文档](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-filesystem-repository)）。通过以下配置使用共享文件系统存储快照：
```yaml
extraVolumes:
  - name: snapshot-repository
    nfs:
      server: nfs.example.com  # 替换为 NFS 服务器地址
      path: /share1  # 替换为共享路径
extraVolumeMounts:
  - name: snapshot-repository
    mountPath: /snapshots
snapshotRepoPath: "/snapshots"  # 快照仓库路径
```


#### 5.3.12 Sidecars 与 Init 容器

通过 `XXX.sidecars` 参数（XXX 为节点角色，如 `master.sidecars`）添加 Sidecar 容器：
```yaml
sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

通过 `initContainers` 参数添加 Init 容器：
```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
```


#### 5.3.13 Pod 亲和性配置

通过 `XXX.affinity` 参数自定义亲和性规则，或使用 `XXX.podAffinityPreset`、`XXX.podAntiAffinityPreset`、`XXX.nodeAffinityPreset` 应用预设配置（参考 [bitnami/common Chart](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities)）。


#### 5.3.14 备份与恢复

使用 [Velero](https://velero.io/) 备份和恢复 Helm Chart 部署，需备份源部署的持久卷并挂载至新部署。详情参见 [Velero 使用指南](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html)。


## 6. 持久性存储

Elasticsearch 数据存储路径为容器内 `/bitnami/elasticsearch/data`。默认通过动态卷供应创建 Persistent Volume Claim (PVC)。

### 权限调整
由于镜像默认以非 root 用户运行，需确保持久卷挂载路径权限正确。可通过以下方式配置：
- **Security Context**：使用 Kubernetes Security Context 自动调整所有权（部分 Kubernetes 发行版不支持）
- **Volume Permissions Init Container**：设置 `volumePermissions.enabled=true` 启用 initContainer 调整权限


## 7. 配置参数

### 7.1 全局参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局 Docker 仓库密钥数组 | `[]` |
| `global.defaultStorageClass` | 持久卷全局默认 StorageClass | `""` |
| `global.storageClass` | 已弃用，使用 `global.defaultStorageClass` 替代 | `""` |
| `global.elasticsearch.service.name` | Kibana 子 Chart 引用的 Elasticsearch 服务名（当 `kibanaEnabled=false` 或设置 `global.elasticsearch.service.fullname` 时忽略） | `elasticsearch` |
| `global.elasticsearch.service.fullname` | Kibana 子 Chart 引用的 Elasticsearch 完整服务名（当 `kibanaEnabled=false` 时忽略） | `""` |
| `global.elasticsearch.service.ports.restAPI` | Kibana 子 Chart 使用的 Elasticsearch REST API 端口（当 `kibanaEnabled=false` 时忽略） | `9200` |
| `global.kibanaEnabled` | 是否启用 Kibana | `false` |
| `global.security.allowInsecureImages` | 是否允许跳过镜像验证 | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 调整安全上下文以适配 OpenShift restricted-v2 SCC（移除 runAsUser、runAsGroup、fsGroup），可选值：`auto`（自动检测 OpenShift 时应用）、`force`（强制应用）、`disabled`（禁用） | `auto` |


### 7.2 通用参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `kubeVersion` | 覆盖 Kubernetes 版本 | `""` |
| `nameOverride` | 部分覆盖资源全名 | `""` |
| `fullnameOverride` | 完全覆盖资源全名 | `""` |
| `commonLabels` | 添加到所有部署对象的标签 | `{}` |
| `commonAnnotations` | 添加到所有部署对象的注解 | `{}` |
| `clusterDomain` | Kubernetes 集群域名 | `cluster.local` |
| `extraDeploy` | 额外部署的 Kubernetes 对象数组 | `[]` |
| `namespaceOverride` | 覆盖命名空间 | `""` |
| `usePasswordFiles` | 以文件形式挂载凭证（而非环境变量） | `true` |
| `diagnosticMode.enabled` | 启用诊断模式（禁用所有探针并覆盖命令） | `false` |
| `diagnosticMode.command` | 诊断模式下覆盖所有容器的命令 | `["sleep"]` |
| `diagnosticMode.args` | 诊断模式下覆盖所有容器的参数 | `["infinity"]` |


### 7.3 Elasticsearch 集群参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `clusterName` | Elasticsearch 集群名称 | `elastic` |
| `containerPorts.restAPI` | Elasticsearch REST API 端口 | `9200` |
| `containerPorts.transport` | Elasticsearch 传输端口 | `9300` |
| `plugins` | 要安装的插件列表（逗号分隔） | `""` |
