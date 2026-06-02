---
image: bitnamicharts/rabbitmq
description: "Bitnami的RabbitMQ Helm chart，用于在Kubernetes环境中便捷、可靠地部署和管理RabbitMQ消息队列。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/rabbitmq
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/rabbitmq
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/rabbitmq" title="bitnamicharts/rabbitmq Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/rabbitmq — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnamicharts/rabbitmq" title="bitnamicharts/rabbitmq Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnamicharts/rabbitmq</a>

# Bitnami RabbitMQ 镜像文档

## 镜像概述和主要用途

RabbitMQ 是一个开源的通用消息代理，设计用于一致、高可用的消息传递场景（包括同步和异步）。Bitnami RabbitMQ 镜像提供了一个预配置、随时可用的 RabbitMQ 部署方案，适用于开发和生产环境。

[RabbitMQ 官方网站](https://www.rabbitmq.com)

**商标声明**：本软件列表由 Bitnami 打包。产品中提及的各个商标分别归其各自公司所有，使用这些商标并不意味着任何关联或背书。

## 核心功能和特性

- 基于官方 RabbitMQ 稳定版本构建
- 预配置的管理插件，提供 Web 管理界面
- 支持 Kubernetes 环境下的自动集群发现
- 内置监控指标导出功能，支持 Prometheus 集成
- 支持 TLS 加密以保障数据传输安全
- 可自定义的用户认证和权限管理
- 持久化存储支持，确保消息数据不丢失
- 支持水平扩展，可根据需求增加节点数量
- 包含多种安全加固措施，符合生产环境要求

## 使用场景和适用范围

- 微服务架构中的服务间通信
- 异步任务处理和工作队列管理
- 系统解耦和集成
- 流量削峰和缓冲
- 发布/订阅消息模式实现
- 需要可靠消息传递的业务系统
- 分布式系统中的事件驱动架构

## 详细的使用方法和配置说明

### 前置要求

- Kubernetes 1.23+
- Helm 3.8.0+
- 底层基础设施支持 PV 供应

### 安装 Helm Chart

使用以下命令安装 chart，发布名称为 `my-release`：

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/rabbitmq
```

> **提示**：使用 `helm list` 命令查看所有发布

### 资源请求和限制

Bitnami charts 允许为部署中的所有容器设置资源请求和限制，这些配置位于 `resources` 值中（参见参数表）。设置请求对于生产工作负载至关重要，应根据具体使用场景进行调整。

为简化此过程，chart 包含 `resourcesPreset` 值，可根据不同预设自动设置 `resources` 部分。但在生产环境中，不建议使用 `resourcesPreset`，因为它可能无法完全适应您的特定需求。有关容器资源管理的更多信息，请参阅 [Kubernetes 官方文档](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)。

### Prometheus 指标集成

通过将 `metrics.enabled` 设置为 `true`，可以将此 chart 与 Prometheus 集成。这将启用 [rabbitmq_prometheus 插件](https://github.com/rabbitmq/rabbitmq-server/tree/c4d9a840c2611290a128ab6d914d2791e2ff302d/deps/rabbitmq_prometheus)，并在所有 Pod 和 RabbitMQ 服务中公开指标端点。该服务将具有必要的注释，以便被 Prometheus 自动抓取。

#### Prometheus 要求

要使集成正常工作，需要安装 Prometheus 或 Prometheus Operator。可以安装 [Bitnami Prometheus Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) 或 [Bitnami Kube Prometheus Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) 以在集群中轻松部署 Prometheus。

#### 与 Prometheus Operator 集成

该 chart 可以部署 `ServiceMonitor` 对象，用于与 Prometheus Operator 集成。每个 RabbitMQ 端点有不同的 `ServiceMonitor` 对象：

- `metrics.serviceMonitor.default` 用于 `/metrics` 端点
- `metrics.serviceMonitor.perObject` 用于 `/metrics/per-object` 端点
- `metrics.serviceMonitor.detailed` 用于 `/metrics/detailed` 端点

通过设置 `metrics.serviceMonitor.*.enabled=true` 启用每个 ServiceMonitor。确保集群中已安装 Prometheus Operator `CustomResourceDefinitions`，否则会失败并显示以下错误：

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

安装 [Bitnami Kube Prometheus Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) 可获取必要的 CRD 和 Prometheus Operator。

### 水平扩展

部署后，可以通过以下两种方式水平扩展此 chart：

- 使用 `kubectl scale` 命令
- 更新 chart 并修改 `replicaCount` 参数

```text
replicaCount=3
auth.password="$RABBITMQ_PASSWORD"
auth.erlangCookie="$RABBITMQ_ERLANG_COOKIE"
```

> **注意**：升级 chart 时，必须指定首次安装 chart 时设置的密码和 Erlang cookie。否则，新的 Pod 将无法加入集群。

缩容时，不必要的 RabbitMQ 节点会自动停止，但不会从集群中移除。必须通过 `rabbitmqctl forget_cluster_node` 命令手动移除这些节点。

例如，如果 RabbitMQ 最初安装了三个副本，然后缩容到两个副本，运行以下命令（假设发布名称为 `rabbitmq`，集群类型为 `hostname`）：

```console
kubectl exec rabbitmq-0 --container rabbitmq -- rabbitmqctl forget_cluster_node rabbit@rabbitmq-2.rabbitmq-headless.default.svc.cluster.local
kubectl delete pvc data-rabbitmq-2
```

### 使用 TLS 加密流量

要启用 TLS 支持，首先按照 [RabbitMQ SSL 证书生成文档](https://www.rabbitmq.com/ssl.html#automated-certificate-generation) 中的说明生成证书。

生成证书后，有两种选择：

- 创建包含证书的 secret，并在部署 chart 时关联该 secret
- 在部署 chart 时将证书包含在 *values.yaml* 文件中

设置 `auth.tls.failIfNoPeerCert` 参数为 `false`，以允许客户端无法提供证书时的 TLS 连接。

设置 `auth.tls.sslOptionsVerify` 为 `verify_peer` 以强制节点执行对等验证。设置为 `verify_none` 时，将禁用对等验证，并且不会执行证书交换。

该 chart 还便于创建用于 Ingress 控制器的 TLS secret（尽管这不是必需的）。有几种常见用例：

- 基于 chart 参数生成证书 secret
- 启用外部生成的证书
- 通过外部服务（如 [cert-manager](https://github.com/jetstack/cert-manager/)）管理应用程序证书
- 在 chart 内创建自签名证书（如果支持）

在前两种情况下，需要证书和密钥。文件应为 `.pem` 格式。

### 加载自定义定义

可以[加载 RabbitMQ 定义文件来配置 RabbitMQ](https://www.rabbitmq.com/management.html#load-definitions)。请按照以下步骤操作：

由于定义可能包含 RabbitMQ 凭据，[将 JSON 存储为 Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-files-from-a-pod)。在 secret 的数据中，选择与所需加载定义文件名对应的键名（即 `load_definition.json`），并使用 JSON 对象作为值。

接下来，将 `load_definitions` 属性指定为指向容器内加载定义文件路径的 `extraConfiguration`（即 `/app/load_definition.json`），并将 `loadDefinition.enable` 设置为 `true`。任何指定的加载定义都将在容器内的 `/app` 目录中可用。

> **注意**：加载定义将优先于通过 [Helm 值](#parameters) 完成的任何配置。

如果需要，可以使用 `extraSecrets` 让 chart 为您创建 secret。这样，您无需在部署发布前手动创建它。这些 secret 也可以使用提供的 chart 值进行模板化。以下是一个示例：

```yaml
auth:
  password: CHANGEME
extraSecrets:
  load-definition:
    load_definition.json: |
      {
        "users": [
          {
            "name": "{{ .Values.auth.username }}",
            "password": "{{ .Values.auth.password }}",
            "tags": "administrator"
          }
        ],
        "vhosts": [
          {
            "name": "/"
          }
        ]
      }
loadDefinition:
  enabled: true
  existingSecret: load-definition
extraConfiguration: |
  load_definitions = /app/load_definition.json
```

### 更新凭据

Bitnami RabbitMQ chart 在升级时会重用之前由 chart 呈现的 secret 或 `auth.existingSecret` 中指定的 secret。要更新凭据，请使用以下方法之一：

- 运行 `helm upgrade` 并在 `auth.password` 中指定新密码，同时设置 `auth.updatePassword=true`
- 运行 `helm upgrade` 并在 `auth.existingSecret` 中指定新 secret，同时设置 `auth.updatePassword=true`

### 配置 LDAP 支持

可以通过在创建发布时指定 `ldap.*` 参数来启用 chart 中的 LDAP 支持。例如：

```text
ldap.enabled="true"
ldap.server="my-ldap-server"
ldap.port="389"
ldap.user_dn_pattern="cn=${username},dc=example,dc=org"
```

如果 `ldap.tls.enabled` 设置为 true，请考虑使用 `ldap.port=636` 并检查 `advancedConfiguration` chart 参数中的设置。

### 配置内存高水位线

可以使用 `memoryHighWatermark.*` 参数配置 RabbitMQ 的内存高水位线，以定义[内存阈值](https://www.rabbitmq.com/memory.html#threshold)。有两种选择：

- 设置每个 RabbitMQ 节点要使用的 RAM 绝对限制，如以下配置示例所示：

```text
memoryHighWatermark.enabled="true"
memoryHighWatermark.type="absolute"
memoryHighWatermark.value="512Mi"
```

- 设置每个 RabbitMQ 节点要使用的 RAM 相对限制。要启用此功能，还需要在 pod 级别定义内存限制。以下是示例配置：

```text
memoryHighWatermark.enabled="true"
memoryHighWatermark.type="relative"
memoryHighWatermark.value="0.4"
resources.limits.memory="2Gi"
```

### 使用插件

Bitnami Docker RabbitMQ 镜像默认附带一组插件。默认情况下，此 chart 启用 `rabbitmq_management` 和 `rabbitmq_peer_discovery_k8s`，因为它们是 RabbitMQ 在 K8s 上工作所必需的。

要启用额外的插件，请使用要启用的插件列表设置 `extraPlugins` 参数。此外，`communityPlugins` 参数可用于指定自定义 RabbitMQ 插件的 URL 列表（以空格分隔）。

```text
communityPlugins="http://URL-TO-PLUGIN/"
extraPlugins="my-custom-plugin"
```

## Docker 部署方案示例

### Helm 安装命令

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/rabbitmq
```

### 自定义参数安装

```console
helm install my-release \
  --set replicaCount=3 \
  --set auth.username=admin \
  --set auth.password=secretpassword \
  --set auth.erlangCookie=secretcookie \
  oci://registry-1.docker.io/bitnamicharts/rabbitmq
```

### 使用现有持久卷声明

```console
helm install my-release \
  --set persistence.existingClaim=my-rabbitmq-pvc \
  oci://registry-1.docker.io/bitnamicharts/rabbitmq
```

### 启用 Prometheus 监控

```console
helm install my-release \
  --set metrics.enabled=true \
  --set metrics.serviceMonitor.enabled=true \
  oci://registry-1.docker.io/bitnamicharts/rabbitmq
```

## 持久化

[Bitnami RabbitMQ](https://github.com/bitnami/containers/tree/main/bitnami/rabbitmq) 镜像将 RabbitMQ 数据和配置存储在容器的 `/opt/bitnami/rabbitmq/var/lib/rabbitmq/` 路径中。

chart 在该位置挂载 [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)。默认情况下，使用动态卷配置创建卷。也可以定义现有的 PersistentVolumeClaim。

### 使用现有 PersistentVolumeClaims

1. 创建 PersistentVolume
2. 创建 PersistentVolumeClaim
3. 安装 chart

```console
helm install my-release --set persistence.existingClaim=PVC_NAME oci://REGISTRY_NAME/REPOSITORY_NAME/rabbitmq
```

> 注意：需要将占位符 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 替换为 Helm chart 仓库和存储库的引用。例如，对于 Bitnami，需要使用 `REGISTRY_NAME=registry-1.docker.io` 和 `REPOSITORY_NAME=bitnamicharts`。

### 调整持久卷挂载点的权限

由于镜像默认以非 root 用户运行，因此需要调整持久卷的所有权，以便容器可以将数据写入其中。

默认情况下，chart 配置为使用 Kubernetes Security Context 自动更改卷的所有权。但是，此功能并非在所有 Kubernetes 发行版中都有效。

作为替代方案，此 chart 支持使用 `initContainer` 在将卷挂载到最终目标之前更改卷的所有权。

可以通过将 `volumePermissions.enabled` 设置为 `true` 来启用此 `initContainer`。

## Prometheus 指标

RabbitMQ 具有[内置支持](https://www.rabbitmq.com/docs/prometheus#default-endpoint)用于在 `GET /metrics` 公开 Prometheus 指标。但是，这些指标都是集群范围的，不显示任何每队列或每节点指标。

要获取每对象指标，有一个[第二个指标端点](https://www.rabbitmq.com/docs/prometheus#detailed-endpoint)位于 `GET /metrics/detailed`，它接受查询参数以选择要查看的指标系列。例如，可以传递 `family=node_coarse_metrics&family=queue_coarse_metrics` 来查看每节点和每队列指标，而无需查看 Erlang、连接或通道指标。

此外，还有[第三个指标端点](https://www.rabbitmq.com/docs/prometheus#per-object-endpoint)：`GET /metrics/per-object`，它返回*所有*每对象指标。但是，在具有许多对象的大型集群上，这可能在计算上很昂贵，因此 RabbitMQ 文档建议使用上面提到的 `GET /metrics/detailed` 来过滤抓取内容，只获取给定监控应用程序所需的每对象指标。

由于它们公开不同的数据集，一个有效的用例是从 `GET /metrics` 和 `GET /metrics/detailed` 两者抓取指标，同时摄入集群级和每对象指标。`metrics.serviceMonitor.default` 和 `metrics.serviceMonitor.detailed` 值支持配置 ServiceMonitor，以针对这些指标中的一个或两个。

## 配置参数

### 全局参数

| 名称 | 描述 | 默认值 |
|------|------|-------|
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局 Docker 仓库密钥名称数组 | `[]` |
| `global.defaultStorageClass` | 持久卷的全局默认 StorageClass | `""` |
| `global.storageClass` | 已弃用：使用 global.defaultStorageClass 代替 | `""` |

### 镜像参数

| 名称 | 描述 | 默认值 |
|------|------|-------|
| `image.registry` | RabbitMQ 镜像仓库 | `docker.io` |
| `image.repository` | RabbitMQ 镜像仓库名称 | `bitnami/rabbitmq` |
| `image.tag` | RabbitMQ 镜像标签 | `3.12.10-debian-11-r2` |
| `image.pullPolicy` | 镜像拉取策略 | `IfNotPresent` |
| `image.pullSecrets` | 镜像拉取密钥 | `[]` |

### 认证参数

| 名称 | 描述 | 默认值 |
|------|------|-------|
| `auth.username` | RabbitMQ 管理员用户名 | `user` |
| `auth.password` | RabbitMQ 管理员密码 | 随机生成 |
| `auth.erlangCookie` | Erlang cookie | 随机生成 |
| `auth.existingSecret` | 包含 RabbitMQ 凭据的现有 secret 名称 | `""` |
| `auth.tls.enabled` | 启用 TLS 认证 | `false` |

### 持久化参数

| 名称 | 描述 | 默认值 |
|------|------|-------|
| `persistence.enabled` | 启用持久化存储 | `true` |
| `persistence.existingClaim` | 现有 PVC 的名称 | `""` |
| `persistence.storageClass` | PVC 的 storage class | `""` |
| `persistence.size` | PVC 的存储大小 | `8Gi` |
| `persistence.accessModes` | PVC 的访问模式 | `["ReadWriteOnce"]` |

### 资源参数

| 名称 | 描述 | 默认值 |
|------|------|-------|
| `resources.limits` | 资源限制 | `{}` |
| `resources.requests` | 资源请求 | `{}` |
| `resourcesPreset` | 资源预设 | `""` |

### 网络参数

| 名称 | 描述 | 默认值 |
|------|------|-------|
| `service.type` | 服务类型 | `ClusterIP` |
| `service.port` | AMQP 服务端口 | `5672` |
| `service.nodePort` | AMQP 服务节点端口 | `""` |
| `service.managementPort` | 管理界面端口 | `15672` |
| `service.managementNodePort` | 管理界面节点
