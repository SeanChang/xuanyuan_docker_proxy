---
image: bitnamicharts/clickhouse-operator
description: "Bitnami的Helm图表，用于在Kubernetes环境中部署和管理ClickHouse Operator，简化ClickHouse数据库的运维部署流程。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/clickhouse-operator
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/clickhouse-operator
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/clickhouse-operator" title="bitnamicharts/clickhouse-operator Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/clickhouse-operator 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami ClickHouse Operator Helm Chart

## 镜像概述和主要用途

ClickHouse Operator 是一个生产级的 Kubernetes Operator，用于管理 ClickHouse 数据库集群，提供经济高效的实时分析应用所需的稳健功能。Bitnami Helm Chart 为 ClickHouse Operator 提供了便捷的部署和配置方式，支持在 Kubernetes 集群中快速搭建生产就绪的 ClickHouse 管理环境。

## 核心功能和特性

- **自动化集群管理**：支持 ClickHouse 集群的部署、扩缩容、升级和维护，减少手动操作
- **灵活配置**：提供自定义配置模板（ChiTemplate、ChkTemplate），支持通过 ConfigMap 注入配置
- **资源优化**：支持资源请求与限制配置，可通过预设（resourcesPreset）或自定义参数调整
- **监控集成**：内置 Prometheus 监控支持，可部署 metrics exporter 并自动配置 ServiceMonitor（适用于 Prometheus Operator）
- **环境定制**：支持添加额外环境变量、Sidecar 容器和 Init 容器，满足高级运维需求
- **安全性增强**：兼容 Kubernetes 安全上下文配置，支持 OpenShift 环境适配
- **高可用性**：支持 Pod 亲和性/反亲和性配置，优化集群部署分布

## 使用场景和适用范围

- **Kubernetes 环境下的 ClickHouse 部署**：适用于需要在 Kubernetes 集群中统一管理 ClickHouse 数据库的场景
- **实时分析平台**：支持大规模实时数据处理，满足日志分析、用户行为分析等实时分析需求
- **生产级数据基础设施**：提供自动化运维能力，适合对稳定性和可靠性要求高的生产环境
- **多租户隔离**：通过自定义配置模板和资源限制，支持多团队共享集群资源
- **监控与可观测性**：集成 Prometheus 监控，便于构建完整的数据库监控体系

## 详细使用方法和配置说明

### 前提条件

- Kubernetes 集群版本 1.23+
- Helm 版本 3.8.0+
- 集群支持 PV 动态供应（Persistent Volume Provisioner）
- 支持 ReadWriteMany 访问模式的存储卷（用于部署扩展）

### 安装步骤

#### 快速安装

使用 Helm 快速安装 ClickHouse Operator（默认配置）：

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/clickhouse-operator
```

#### 自定义安装

1. **指定仓库和版本**  
   替换仓库地址和版本标签（如使用私有仓库）：

   ```console
   helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/clickhouse-operator --version 1.0.0
   ```

2. **通过 values 文件配置**  
   创建自定义 `values.yaml` 文件覆盖默认配置：

   ```yaml
   # values.yaml 示例
   resources:
     requests:
       cpu: 500m
       memory: 512Mi
     limits:
       cpu: 1000m
       memory: 1Gi
   metrics:
     enabled: true
   ```

   安装时指定配置文件：

   ```console
   helm install my-release oci://registry-1.docker.io/bitnamicharts/clickhouse-operator -f values.yaml
   ```

3. **查看部署状态**  
   检查 Deployment 和 Pod 状态：

   ```console
   kubectl get deployments
   kubectl get pods
   ```

4. **卸载**  
   卸载 Helm 发布：

   ```console
   helm uninstall my-release
   ```

### 配置说明

#### Operator 配置

ClickHouse Operator 支持多种配置方式：

- **自动生成配置**：默认根据 `configuration`、`chiTemplate`、`chkTemplate` 参数生成配置
- **使用现有 ConfigMap**：通过 `existingConfigmap`、`existingChiTemplatesConfigmap` 或 `existingChkTemplatesConfigmap` 指定已存在的 ConfigMap
- **配置覆盖**：通过 `overrideConfiguration` 参数覆盖默认配置值

详细配置选项参考 [官方文档](https://github.com/Altinity/clickhouse-operator/blob/master/docs/operator_configuration.md)。

#### 环境变量配置

**添加额外环境变量**：通过 `extraEnvVars` 注入环境变量：

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: "error"
  - name: OPERATOR_NAMESPACE
    valueFrom:
      fieldRef:
        fieldPath: metadata.namespace
```

**通过 ConfigMap/Secret 注入**：使用 `extraEnvVarsCM` 或 `extraEnvVarsSecret` 指定包含环境变量的 ConfigMap/Secret 名称。

#### 资源管理

**资源请求与限制**：直接配置 `resources` 参数：

```yaml
resources:
  requests:
    cpu: 1000m
    memory: 2Gi
  limits:
    cpu: 2000m
    memory: 4Gi
```

**资源预设**：通过 `resourcesPreset` 使用预设配置（如 `small`、`medium`、`large`），预设定义参考 [bitnami/common  chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15)（生产环境建议自定义资源配置而非依赖预设）。

#### 监控配置

**启用 Prometheus 监控**：

```yaml
metrics:
  enabled: true
  serviceMonitor:
    enabled: true  # 如需集成 Prometheus Operator，启用此项
    namespace: monitoring  # 指定 Prometheus 所在命名空间
    interval: 15s  # 抓取间隔
```

监控集成要求集群中已部署 Prometheus 或 Prometheus Operator，推荐使用 [Bitnami Prometheus Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus)。

#### Sidecar 和 Init 容器

**添加 Sidecar 容器**（如日志收集器）：

```yaml
sidecars:
  - name: log-exporter
    image: docker.xuanyuan.run/busybox:latest
    command: ["/bin/sh", "-c", "tail -f /var/log/clickhouse-operator/*.log"]
    volumeMounts:
      - name: logs
        mountPath: /var/log/clickhouse-operator
```

**添加 Init 容器**（如配置初始化）：

```yaml
initContainers:
  - name: init-config
    image: docker.xuanyuan.run/busybox:latest
    command: ["/bin/sh", "-c", "echo 'init config' > /init/config.txt"]
    volumeMounts:
      - name: init-volume
        mountPath: /init
```

#### Pod 亲和性配置

通过 `affinity` 参数自定义 Pod 亲和性：

```yaml
affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
            - key: app.kubernetes.io/name
              operator: In
              values:
                - clickhouse-operator
        topologyKey: "kubernetes.io/hostname"
```

或使用预设亲和性配置：

```yaml
podAntiAffinityPreset: "soft"  # 软反亲和性，尽量避免同节点部署
nodeAffinityPreset:
  type: "required"
  key: "node-role.kubernetes.io/worker"
  values: ["true"]
```

### 部署 ClickHouse 集群示例

通过 `extraDeploy` 参数部署 ClickHouse 集群和 Keeper 集群：

```yaml
extraDeploy:
  # ClickHouse Keeper 集群部署
  - apiVersion: clickhouse-keeper.altinity.com/v1
    kind: ClickHouseKeeperInstallation
    metadata:
      name: chk-cluster
    spec:
      defaults:
        storageManagement:
          provisioner: Operator
        templates:
          podTemplate: keeper-pod
          dataVolumeClaimTemplate: keeper-volume
      configuration:
        clusters:
          - name: main
            layout:
              replicasCount: 3  # 3副本高可用配置
      templates:
        podTemplates:
          - name: keeper-pod
            spec:
              containers:
                - name: clickhouse-keeper
                  image: docker.xuanyuan.run/bitnami/clickhouse-keeper:latest
                  volumeMounts:
                    - name: keeper-volume
                      mountPath: /bitnami/clickhouse-keeper
        volumeClaimTemplates:
          - name: keeper-volume
            spec:
              accessModes: ["ReadWriteOnce"]
              resources:
                requests:
                  storage: 10Gi

  # ClickHouse 集群部署
  - apiVersion: clickhouse.altinity.com/v1
    kind: ClickHouseInstallation
    metadata:
      name: ch-cluster
    spec:
      defaults:
        storageManagement:
          provisioner: Operator
        templates:
          podTemplate: ch-pod
          dataVolumeClaimTemplate: ch-volume
      configuration:
        clusters:
          - name: analytics
            layout:
              replicasCount: 2  # 2副本集群
        zookeeper:
          nodes:
            - host: chk-cluster-main  # 关联 Keeper 集群服务
              port: 2181
      templates:
        podTemplates:
          - name: ch-pod
            spec:
              containers:
                - name: clickhouse
                  image: docker.xuanyuan.run/bitnami/clickhouse:latest
                  volumeMounts:
                    - name: ch-volume
                      mountPath: /bitnami/clickhouse
        volumeClaimTemplates:
          - name: ch-volume
            spec:
              accessModes: ["ReadWriteOnce"]
              resources:
                requests:
                  storage: 50Gi
```

## 参数说明

### 全局参数

| 参数名 | 描述 | 默认值 |
| --- | --- | --- |
| `global.imageRegistry` | 全局 Docker 镜像仓库地址 | `""` |
| `global.imagePullSecrets` | 全局镜像拉取密钥列表 | `[]` |
| `global.defaultStorageClass` | 全局默认存储类 | `""` |
| `global.security.allowInsecureImages` | 是否允许不安全镜像（跳过校验） | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 是否适配 OpenShift 安全上下文（auto/force/disabled） | `auto` |
| `global.compatibility.omitEmptySeLinuxOptions` | 移除空的 seLinuxOptions 配置 | `false` |

### 通用参数

| 参数名 | 描述 | 默认值 |
| --- | --- | --- |
| `kubeVersion` | 覆盖 Kubernetes 版本 | `""` |
| `apiVersions` | 覆盖 Kubernetes API 版本 | `[]` |
| `nameOverride` | 覆盖资源名称前缀 | `""` |
| `fullnameOverride` | 完全覆盖资源全名 | `""` |
| `namespaceOverride` | 覆盖命名空间 | `""` |
| `commonLabels` | 全局标签 | `{}` |
| `commonAnnotations` | 全局注解 | `{}` |
| `clusterDomain` | Kubernetes 集群域名 | `cluster.local` |
| `extraDeploy` | 额外部署的 Kubernetes 资源清单 | `[]` |

### ClickHouse Operator 参数

| 参数名 | 描述 | 默认值 |
| --- | --- | --- |
| `image.registry` | Operator 镜像仓库 | `REGISTRY_NAME` |
| `image.repository` | Operator 镜像仓库路径 | `REPOSITORY_NAME/clickhouse-operator` |
| `image.digest` | 镜像摘要（覆盖标签） | `""` |
| `image.pullPolicy` | 镜像拉取策略 | `IfNotPresent` |
| `image.pullSecrets` | 镜像拉取密钥 | `[]` |
| `clickHouseImage.registry` | ClickHouse 镜像仓库 | `REGISTRY_NAME` |
| `clickHouseImage.repository` | ClickHouse 镜像路径 | `REPOSITORY_NAME/clickhouse` |
| `keeperImage.registry` | ClickHouse Keeper 镜像仓库 | `REGISTRY_NAME` |
| `keeperImage.repository` | ClickHouse Keeper 镜像路径 | `REPOSITORY_NAME/clickhouse-keeper` |
| `auth.username` | Operator 认证用户名 | `clickhouse_operator` |
| `auth.password` | Operator 认证密码 | `""` |
| `auth.existingSecret` | 包含认证信息的现有 Secret 名称 | `""` |
| `ipFamily.enableIpv4` | 是否启用 IPv4 | `true` |

> **注**：完整参数列表请参考 [官方文档](https://github.com/bitnami/charts/blob/main/bitnami/clickhouse-operator/README.md)

## ⚠️ 重要通知：Bitnami 镜像目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共镜像目录，推出 [Bitnami Secure Images](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications) 计划，主要变更包括：

- **安全镜像开放**：首次向社区用户提供安全优化版容器镜像，减少攻击面
- **非强化镜像逐步淘汰**：免费版将逐步停止支持非强化的 Debian 基础镜像，仅保留最新标签（latest）的强化镜像（供开发使用）
- **旧镜像迁移**：所有现有镜像（含历史版本标签，如 2.50.0、10.6）将在两周内迁移至 `docker.io/bitnamilegacy` 仓库，且不再更新
- **生产环境建议**：生产环境推荐使用 Bitnami Secure Images，包含强化容器、CVE 透明度（VEX/KEV）、SBOM 和企业支持

更多详情请参考 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。

## 注意事项

- **生产环境标签策略**：建议使用不可变标签（如具体版本号）而非滚动标签（latest），避免镜像更新导致部署意外变更
- **资源配置**：生产环境需根据实际负载调整资源请求与限制，避免过度分配或资源不足
- **监控依赖**：启用 Prometheus 监控前需确保集群已部署 Prometheus 或 Prometheus Operator，否则可能导致部署失败
- **OpenShift 兼容性**：通过 `global.compatibility.openshift.adaptSecurityContext: force` 强制适配 OpenShift 安全上下文
