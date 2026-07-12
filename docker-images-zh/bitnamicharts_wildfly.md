---
image: bitnamicharts/wildfly
description: "Bitnami的WildFly Helm图表，用于在Kubernetes环境中便捷部署和管理WildFly Java应用服务器，具备配置灵活、安全可靠及遵循最佳实践的特点。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/wildfly
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/wildfly
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/wildfly" title="bitnamicharts/wildfly Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/wildfly 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami WildFly 镜像文档

## 镜像概述和主要用途

Bitnami WildFly 镜像是一个轻量级、开源的应用服务器容器化解决方案，WildFly 前身为 JBoss，实现了最新的企业 Java 标准。该镜像由 Bitnami 打包，提供了简单易用、安全可靠的 WildFly 部署方式，适用于开发和生产环境中的 Java EE 应用部署。

## 核心功能和特性

- **企业级 Java 支持**：完全兼容 Java Platform, Enterprise Edition (Java EE) 规范
- **轻量级架构**：优化的运行时环境，减少资源占用
- **容器化优化**：针对 Docker 环境进行了专门优化，支持非 root 用户运行
- **安全加固**：遵循容器安全最佳实践，减少攻击面
- **灵活配置**：支持通过环境变量、配置文件和命令行参数进行自定义配置
- **持久化存储**：支持使用 Persistent Volume Claims 实现数据持久化
- **高可用性**：可配置多副本部署，支持滚动更新策略
- **监控集成**：支持 Prometheus 指标导出（需启用相关配置）

## 使用场景和适用范围

- **Java EE 应用部署**：为企业级 Java 应用提供运行环境
- **微服务架构**：作为微服务架构中的应用服务器节点
- **开发环境**：快速搭建一致的开发和测试环境
- **CI/CD 流水线**：集成到持续集成和部署流程中
- **云原生应用**：在 Kubernetes 集群中部署和扩展 Java 应用
- **生产环境**：通过适当配置可用于生产环境，提供稳定可靠的服务

## 详细的使用方法和配置说明

### 快速开始 (TL;DR)

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/wildfly
```

### 重要通知：Bitnami Catalog 即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共目录，通过新的 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)提供精选的强化、安全聚焦的镜像。此过渡包括：

- 首次向社区用户提供流行容器镜像的安全优化版本
- Bitnami 将开始在免费层级中弃用对非强化、基于 Debian 的软件镜像的支持，并将逐步从公共目录中移除非最新标签。因此，社区用户将只能访问数量减少的强化镜像，这些镜像仅以 "latest" 标签发布，适用于开发目的
- 从 8 月 28 日开始，在两周内，所有现有容器镜像，包括旧版本或特定版本标签（例如 2.50.0、10.6），将从公共目录 (docker.io/bitnami) 迁移到 "Bitnami Legacy" 仓库 (docker.io/bitnamilegacy)，不再接收更新
- 对于生产工作负载和长期支持，建议用户采用 Bitnami Secure Images，包括强化容器、更小的攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 和企业支持

### 先决条件

- Kubernetes 1.23+
- Helm 3.8.0+
- 底层基础设施支持 PV 供应器
- 用于部署扩展的 ReadWriteMany 卷

### 安装 Helm Chart

使用发布名称 `my-release` 安装 chart：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/wildfly
```

> 注意：需要将占位符 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 替换为 Helm chart 仓库和存储库的引用。例如，对于 Bitnami，需使用 `REGISTRY_NAME=registry-1.docker.io` 和 `REPOSITORY_NAME=bitnamicharts`。

这些命令使用默认配置在 Kubernetes 集群上部署 WildFly。[参数](#参数) 部分列出了可在安装过程中配置的参数。

> **提示**：使用 `helm list` 命令列出所有发布

### 配置和安装详情

#### 资源请求和限制

Bitnami charts 允许为 chart 部署中的所有容器设置资源请求和限制，这些配置位于 `resources` 值中（参见参数表）。设置请求对于生产工作负载至关重要，应根据具体用例进行调整。

为简化此过程，chart 包含 `resourcesPreset` 值，可根据不同预设自动设置 `resources` 部分。可在 [bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15) 中查看这些预设。但是，在生产工作负载中不建议使用 `resourcesPreset`，因为它可能无法完全适应您的特定需求。有关容器资源管理的更多信息，请参阅 [官方 Kubernetes 文档](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)。

#### 滚动与不可变标签

强烈建议在生产环境中使用不可变标签。这可确保如果相同标签使用不同镜像更新，部署不会自动更改。

如果主容器有新版本、重大更改或严重漏洞，Bitnami 将发布新的 chart 更新其容器。

#### 更新凭据

Bitnami charts 在首次启动时配置凭据。对密钥或凭据的任何进一步更改都需要手动干预。请按照以下说明操作：

- 按照 [上游文档](https://docs.wildfly.org/) 更新用户密码
- 使用新值更新密码密钥（替换 SECRET_NAME 和 PASSWORD 占位符）

```shell
kubectl create secret generic SECRET_NAME --from-literal=wildfly-password=PASSWORD --dry-run -o yaml | kubectl apply -f -
```

#### 备份和恢复

要在 Kubernetes 上备份和恢复 Helm chart 部署，需要从源部署备份持久卷，并使用 [Velero](https://velero.io/)（Kubernetes 备份/恢复工具）将其附加到新部署。有关使用 Velero 的说明，请参阅 [本指南](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html)。

#### 添加额外环境变量

要添加额外的环境变量（对高级操作如自定义初始化脚本很有用），请使用 `extraEnvVars` 属性。

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

或者，使用包含环境变量的 ConfigMap 或 Secret。为此，请使用 `extraEnvVarsCM` 或 `extraEnvVarsSecret` 值。

#### 使用 Sidecars 和 Init Containers

如果在同一个 pod 中需要额外的容器（例如额外的指标或日志导出器），可以使用 `sidecars` 配置参数定义它们。

```yaml
sidecars:
- name: your-image-name
  image: docker.xuanyuan.run/your-image
  imagePullPolicy: Always
  ports:
  - name: portname
    containerPort: 1234
```

如果这些 sidecars 导出额外端口，可以使用 `service.extraPorts` 参数（如果可用）添加额外的端口定义，如下例所示：

```yaml
service:
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

> 注意：此 Helm chart 已包含 Prometheus 导出器的 sidecar 容器（如适用）。可以通过在部署时添加 `--enable-metrics=true` 参数来激活它们。因此，`sidecars` 参数应仅用于任何额外的 sidecar 容器。

如果在同一个 pod 中需要额外的 init 容器，可以使用 `initContainers` 参数定义它们。示例如下：

```yaml
initContainers:
  - name: your-image-name
    image: docker.xuanyuan.run/your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

了解更多关于 [sidecar 容器](https://kubernetes.io/docs/concepts/workloads/pods/) 和 [init 容器](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) 的信息。

#### 设置 Pod 亲和性

此 chart 允许使用 `affinity` 参数设置自定义 Pod 亲和性。有关 Pod 亲和性的更多信息，请参阅 [Kubernetes 文档](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity)。

作为替代方案，可以使用 [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart 中提供的 pod 亲和性、pod 反亲和性和节点亲和性的预设配置之一。为此，请设置 `podAffinityPreset`、`podAntiAffinityPreset` 或 `nodeAffinityPreset` 参数。

### 持久化

[Bitnami WildFly](https://github.com/bitnami/containers/tree/main/bitnami/wildfly) 镜像将 WildFly 数据和配置存储在容器的 `/bitnami/wildfly` 路径中。

持久卷声明用于跨部署保留数据。已知在 GCE、AWS 和 minikube 中有效。
请参阅 [参数](#参数) 部分配置 PVC 或禁用持久性。

#### 调整持久卷挂载点的权限

由于镜像默认以非 root 用户运行，需要调整持久卷的所有权，以便容器可以将数据写入其中。

默认情况下，chart 配置为使用 Kubernetes 安全上下文自动更改卷的所有权。但是，此功能并非在所有 Kubernetes 发行版中都有效。
作为替代方案，此 chart 支持使用 initContainer 在将卷挂载到最终目标之前更改卷的所有权。

可以通过将 `volumePermissions.enabled` 设置为 `true` 来启用此 initContainer。

### Docker 部署方案示例

#### 使用 docker run 命令部署

```bash
docker run -d \
  --name wildfly \
  -p 8080:8080 \
  -e WILDFLY_USERNAME=user \
  -e WILDFLY_PASSWORD=password \
  -v wildfly_data:/bitnami/wildfly \
  docker.xuanyuan.run/bitnami/wildfly:latest
```

#### 使用 docker-compose 部署

```yaml
version: '3'

services:
  wildfly:
    image: docker.xuanyuan.run/bitnami/wildfly:latest
    ports:
      - "8080:8080"
    environment:
      - WILDFLY_USERNAME=user
      - WILDFLY_PASSWORD=password
    volumes:
      - wildfly_data:/bitnami/wildfly
    restart: unless-stopped

volumes:
  wildfly_data:
```

## 参数

### 全局参数

| 名称 | 描述 | 值 |
|------|------|-----|
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局 Docker 仓库密钥名称数组 | `[]` |
| `global.defaultStorageClass` | 持久卷的全局默认 StorageClass | `""` |
| `global.storageClass` | 已弃用：使用 global.defaultStorageClass 代替 | `""` |
| `global.security.allowInsecureImages` | 允许跳过镜像验证 | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 调整部署的 securityContext 部分，使其与 Openshift restricted-v2 SCC 兼容：删除 runAsUser、runAsGroup 和 fsGroup，让平台使用其允许的默认 ID。可能的值：auto（如果检测到运行的集群是 Openshift，则应用），force（始终执行适配），disabled（不执行适配） | `disabled` |

### 通用参数

| 名称 | 描述 | 值 |
|------|------|-----|
| `kubeVersion` | 覆盖 Kubernetes 版本 | `""` |
| `nameOverride` | 部分覆盖 common.names.fullname 的字符串 | `""` |
| `fullnameOverride` | 完全覆盖 common.names.fullname 的字符串 | `""` |
| `commonLabels` | 要添加到所有部署对象的标签 | `{}` |
| `commonAnnotations` | 要添加到所有部署对象的注释 | `{}` |
| `clusterDomain` | Kubernetes 集群域名 | `cluster.local` |
| `extraDeploy` | 要与发布一起部署的额外对象数组 | `[]` |
| `usePasswordFiles` | 将凭据挂载为文件而不是使用环境变量 | `true` |
| `diagnosticMode.enabled` | 启用诊断模式（所有探针将被禁用，命令将被覆盖） | `false` |
| `diagnosticMode.command` | 覆盖 deployment(s)/statefulset(s) 中所有容器的命令 | `["sleep"]` |
| `diagnosticMode.args` | 覆盖 deployment(s)/statefulset(s) 中所有容器的参数 | `["infinity"]` |

### WildFly 镜像参数

| 名称 | 描述 | 值 |
|------|------|-----|
| `image.registry` | WildFly 镜像仓库 | `REGISTRY_NAME` |
| `image.repository` | WildFly 镜像存储库 | `REPOSITORY_NAME/wildfly` |
| `image.digest` | WildFly 镜像摘要，格式为 sha256:aa.... 请注意，如果设置此参数，将覆盖标签 | `""` |
| `image.pullPolicy` | WildFly 镜像拉取策略 | `IfNotPresent` |
| `image.pullSecrets` | WildFly 镜像拉取密钥 | `[]` |
| `image.debug` | 启用镜像调试模式 | `false` |

### WildFly 配置参数

| 名称 | 描述 | 值 |
|------|------|-----|
| `wildflyUsername` | WildFly 用户名 | `user` |
| `wildflyPassword` | WildFly 用户密码 | `""` |
| `exposeManagementConsole` | 允许在集群外部暴露 WildFly 管理控制台 | `false` |
| `command` | 覆盖默认容器命令（使用自定义镜像时有用） | `[]` |
| `args` | 覆盖默认容器参数（使用自定义镜像时有用） | `[]` |
| `lifecycleHooks` | 容器在启动前或启动后自动配置 | `{}` |
| `extraEnvVars` | 要添加到 WildFly 容器的额外环境变量数组 | `[]` |
| `extraEnvVarsCM` | 包含额外环境变量的现有 ConfigMap 名称 | `""` |
| `extraEnvVarsSecret` | 包含额外环境变量的现有 Secret 名称 | `""` |

### WildFly 部署参数

| 名称 | 描述 | 值 |
|------|------|-----|
| `replicaCount` | 要部署的 Wildfly 副本数 | `1` |
| `updateStrategy.type` | WildFly 部署策略类型 | `RollingUpdate` |
| `automountServiceAccountToken` | 在 pod 中挂载服务账户令牌 | `true` |
| `hostAliases` | WildFly pod 主机别名 | `[]` |
| `extraVolumes` | 可选地指定 WildFly pods 的额外卷列表 | `[]` |
| `extraVolumeMounts` | 可选地指定 WildFly 容器的额外 volumeMounts 列表 | `[]` |
| `serviceAccountName` | 要连接的现有 ServiceAccount 的名称 | `""` |
| `sidecars` | 向 WildFly pod 添加额外的 sidecar 容器 | `[]` |
| `initContainers` | 向 WildFly pods 添加额外的 init 容器 | `[]` |
| `pdb.create` | 启用/禁用 Pod 中断预算创建 | `true` |
| `pdb.minAvailable` | 应保持调度的最小 pod 数量/百分比 | `""` |
| `pdb.maxUnavailable` | 可能不可用的最大 pod 数量/百分比。如果 `pdb.minAvailable` 和 `pdb.maxUnavailable` 都为空，则默认为 `1` | `""` |
| `podLabels` | WildFly pods 的额外标签 | `{}` |
| `podAnnotations` | WildFly pods 的注释 | `{}` |
| `podAffinityPreset` | Pod 亲和性预设。如果设置了 `affinity`，则忽略。允许值：`soft` 或 `hard` | `""` |
| `podAntiAffinityPreset` | Pod 反亲和性预设。如果设置了 `affinity`，则忽略。允许值：`soft` 或 `hard` | `soft` |
| `nodeAffinityPreset.type` | 节点亲和性预设类型。如果设置了 `affinity`，则忽略。允许值：`soft` 或 `hard` | `""` |
| `nodeAffinityPreset.key` | 要匹配的节点标签键。如果设置了 `affinity`，则忽略 | `""` |
| `nodeAffinityPreset.values` | 要匹配的节点标签值。如果设置了 `affinity`，则忽略 | `[]` |
| `affinity` | Pod 分配的亲和性 | `{}` |
| `nodeSelector` | Pod 分配的节点标签 | `{}` |
| `tolerations` | Pod 分配的容忍度 | `{}` |
| `priorityClassName` | Pod 优先级类名 | `""` |
| `schedulerName` | k8s 调度程序名称（非默认） | `""` |

> 注意：此 chart 的 README 超出了 DockerHub 的 25000 字符限制，因此已被截断。完整 README 可在 https://github.com/bitnami/charts/blob/main/bitnami/wildfly/README.md 找到。
