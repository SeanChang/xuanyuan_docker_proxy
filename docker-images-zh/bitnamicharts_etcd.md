---
image: bitnamicharts/etcd
description: "Bitnami为etcd提供的Helm chart，是一款用于简化分布式键值存储系统etcd在Kubernetes等容器编排平台上部署、配置与管理的打包解决方案，集成了最佳实践配置，支持高可用性集群部署、数据持久化存储及版本控制，可帮助用户快速搭建稳定可靠的etcd环境，满足容器化应用对分布式数据存储的核心需求。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/etcd
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/etcd
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/etcd" title="bitnamicharts/etcd Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/etcd — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnamicharts/etcd" title="bitnamicharts/etcd Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnamicharts/etcd</a>

# Bitnami Etcd 软件包

Etcd 是一款分布式键值存储工具，专为跨集群安全存储数据设计。凭借其可靠性、容错能力和易用性，Etcd 在生产环境中被广泛应用。


## 快速上手

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/etcd
```

如需在生产环境使用 Etcd，可尝试 [VMware Tanzu Application Catalog]([])（Bitnami 目录的商业版）。


## ⚠️ 重要通知：Bitnami 软件目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共软件目录，通过新的 [Bitnami Secure Images 计划]([]) 提供精选的强化安全镜像。此次变更包括：

- 首次向社区用户开放热门容器镜像的安全优化版本。
- Bitnami 将逐步停止对免费层中非强化的 Debian 基础镜像的支持，并从公共目录中移除非最新标签。社区用户将只能访问数量减少的强化镜像，且仅提供“latest”标签，供开发使用。
- 自 8 月 28 日起，两周内所有现有容器镜像（包括旧版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再更新。
- 对于生产工作负载和长期支持，建议用户采用 Bitnami Secure Images，包含强化容器、更小攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 以及企业级支持。

这些变更旨在通过推广软件供应链完整性最佳实践和最新部署方式，提升所有 Bitnami 用户的安全态势。详情见 [Bitnami Secure Images 公告]([])。


## 简介

本 Chart 使用 [Helm]([]) 包管理器在 [Kubernetes]([]) 集群上部署 [etcd]([])。


## 前提条件

- Kubernetes 1.23+
- Helm 3.8.0+
- 底层基础设施支持 PV 动态供应


## 安装 Chart

使用发布名称 `my-release` 安装 Chart：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/etcd
```

> 注意：需将占位符 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 替换为实际的 Helm 仓库地址。例如，Bitnami 仓库需使用 `REGISTRY_NAME=registry-1.docker.io` 和 `REPOSITORY_NAME=bitnamicharts`。

上述命令将以默认配置在 Kubernetes 集群部署 Etcd。[参数](#参数) 部分列出了安装时可配置的选项。

> 提示：使用 `helm list` 查看所有发布。


## 配置与安装详情

### 资源请求与限制

Bitnami Chart 允许为部署中的所有容器设置资源请求（requests）和限制（limits），相关配置位于 `resources` 字段（见参数表）。生产环境必须设置资源请求，并根据实际场景调整。

为简化配置，Chart 提供 `resourcesPreset` 参数，可自动按预设值配置 `resources`。预设定义见 [bitnami/common Chart]([])。但生产环境不建议直接使用 `resourcesPreset`，需根据具体需求调整。更多容器资源管理信息见 [Kubernetes 官方文档]([])。


### 滚动标签与不可变标签

生产环境强烈建议使用不可变标签，避免因标签指向镜像更新导致部署意外变更。Bitnami 会在主容器版本更新、重大变更或发现严重漏洞时，发布新的 Chart 以更新容器镜像。


### Prometheus 监控指标

设置 `metrics.enabled=true` 可启用 Etcd 原生 Prometheus 指标暴露，容器和 Service（若 `metrics.useSeparateEndpoint=true`）将开放指标端口，并添加 Prometheus 自动发现注解。

#### 前提条件

需已安装 Prometheus 或 Prometheus Operator。可通过 [Bitnami Prometheus Helm Chart]([]) 或 [Bitnami Kube Prometheus Helm Chart]([]) 快速部署。

#### 集成 Prometheus Operator

设置 `*.metrics.podMonitor.enabled=true` 可部署 `PodMonitor` 对象以集成 Prometheus Operator。需确保集群已安装 Prometheus Operator 的 CRD，否则会报错：

```text
no matches for kind "PodMonitor" in version "monitoring.coreos.com/v1"
```

可通过 [Bitnami Kube Prometheus Helm Chart]([]) 安装所需 CRD 和 Prometheus Operator。


### 更新凭证

Bitnami Chart 在首次启动时配置凭证，后续修改密钥或凭证需手动操作：

1. 参考 [上游文档]([]) 更新用户密码。
2. 用新值更新密码密钥（替换 `SECRET_NAME` 和 `PASSWORD` 占位符）：

```shell
kubectl create secret generic SECRET_NAME --from-literal=etcd-root-password=PASSWORD --dry-run -o yaml | kubectl apply -f -
```


### 集群配置

Bitnami Etcd Chart 可快速搭建可扩展、支持灾难恢复的 Etcd 集群，通过环境变量配置静态发现实现集群引导。基于初始副本数和无头服务（headless service）添加的 DNS A 记录，Chart 可自动计算每个节点的对等 URL。

Chart 利用 Kubernetes 特性确保集群引导成功：

- 设置“Parallel” Pod 管理策略：所有 Etcd 副本需同时创建以确保相互发现。
- DNS 记录“未就绪”Pod：Etcd 副本在就绪前即可通过 FQDN 访问。

更多信息见 [etcd 发现机制]([])、[Pod 管理策略]([]) 和 [未就绪 Pod DNS 记录]([])。

以下是 3 副本 Etcd 集群的环境配置示例：

| 节点 | 环境变量 | 值 |
|------|----------|-----|
| 0 | ETCD_NAME | etcd-0 |
| 0 | ETCD_INITIAL_ADVERTISE_PEER_URLS | <[]> |
| 1 | ETCD_NAME | etcd-1 |
| 1 | ETCD_INITIAL_ADVERTISE_PEER_URLS | <[]> |
| 2 | ETCD_NAME | etcd-2 |
| 2 | ETCD_INITIAL_ADVERTISE_PEER_URLS | <[]> |
| 所有 | ETCD_INITIAL_CLUSTER_TOKEN | etcd-cluster-k8s |
| 所有 | ETCD_INITIAL_CLUSTER | etcd-0=<[]>,etcd-1=<[]>,etcd-2=<[]> |

就绪和存活探针默认延迟 60 秒，确保副本有时间启动并相互发现。之后，通过 `etcdctl endpoint health` 定期检查副本健康状态。


#### 可扩展性

集群扩缩容时，Chart 通过 Etcd 重配置操作添加/移除节点：

- 缩容时，“pre-stop”生命周期钩子执行 `etcdctl member remove`，并将结果存储在 PV 中。手动删除 Pod 或 Kubernetes 重调度时也会触发此钩子，实现无人工干预的扩缩容。

示例流程：

1. 3 节点 Kubernetes 集群上部署 3 副本 Etcd 集群。
2. 管理员需升级某个节点内核，执行节点排空（drain），Pod 被调度至其他节点。
3. Pod 驱逐时，“pre-stop”钩子移除 Etcd 节点，集群缩容至 2 副本。
4. Pod 在新节点启动后，通过 `etcdctl member add` 重新加入集群，恢复至 3 副本。

若钩子执行失败，初始化逻辑会检查 PV 中存储的 `etcdctl member remove` 输出，通过 `etcdctl member update` 重新添加节点。此时集群不会自动扩缩容，其他节点可能报错：

```text
E | rafthttp: failed to dial XXXXXXXX on stream Message (peer XXXXXXXX failed to find local node YYYYYYYYY)
```

更多信息见 [etcd 运行时配置]([]) 和 [Kubernetes 节点排空]([])。


#### 集群更新

更新 Etcd StatefulSet（如通过 `helm upgrade` 更新 Chart 版本）时，需按 StatefulSet 更新策略替换 Pod。Chart 默认使用“RollingUpdate”策略，按 Pod 序号从大到小依次更新，等待当前 Pod 就绪后再更新前一个。更多信息见 [StatefulSet 更新策略]([])。


#### 灾难恢复

若超过 (N-1)/2 节点故障且“pre-stop”钩子未移除故障节点，集群将失去法定人数（quorum），无法达成共识或接受更新，需从快照恢复（所有节点必须使用同一快照）。

Bitnami Etcd Chart 可配置 Kubernetes CronJob 定期创建数据快照并存储在 RWX 卷中。集群故障时，Pod 将自动尝试使用最新快照恢复。[启用方法](#启用灾难恢复功能)。

Chart 默认配置“软”Pod 反亲和性（Pod AntiAffinity），降低集群整体故障风险。更多信息见 [etcd 恢复]([])、[Kubernetes CronJob]([]) 和 [Pod 亲和性与反亲和性]([])。


### 启用 Etcd 安全特性

可配置基于角色的访问控制（RBAC）和 TLS 加密增强安全性。

#### 配置 RBAC

设置以下参数启用 RBAC：

```text
auth.rbac.create=true
auth.rbac.rootPassword=ETCD_ROOT_PASSWORD
```

将创建拥有全部权限的 `root` 用户及对应角色，其他用户默认使用无权限的 `guest` 角色。

#### 配置节点间 TLS 加密

设置以下参数启用节点间安全通信：

```text
auth.peer.secureTransport=true
auth.peer.useAutoTLS=true
```

#### 配置客户端证书

创建包含证书、密钥和 CA 的密钥（Secret），并设置以下参数启用客户端与服务端的安全通信：

```text
auth.client.secureTransport=true
auth.client.enableAuthentication=true
auth.client.existingSecret=etcd-client-certs
```

更多信息见 [etcd 安全模型]([]) 和 [生成自签名证书]([])。


### 启用灾难恢复功能

通过以下参数启用自动灾难恢复（定期快照 + 自动恢复）：

```text
persistence.enabled=true
disasterRecovery.enabled=true
disasterRecovery.pvc.size=2Gi
disasterRecovery.pvc.storageClassName=nfs
```

若同时设置 `startFromSnapshot.*` 参数，快照将存储在 `startFromSnapshot.existingClaim` 指定的 PVC 中。

> 注意：灾难恢复功能需 RWX 访问模式的卷。


### 备份与恢复

两种备份恢复方式：

#### 方法 1：使用 etcd 工具备份数据

1. 使用 `etcdctl` 创建源集群快照。
2. 将快照存储在支持 ReadWriteMany 的 PVC 中。
3. 在新集群中，通过 `startFromSnapshot.existingClaim` 和 `startFromSnapshot.snapshotFilename` 指定快照 PVC 和文件名，恢复数据。

> 注意：新部署需使用与源集群相同的凭证。

#### 方法 2：使用 Velero 备份持久卷

通过 [Velero]([]) 备份 PV 并在新集群恢复，适用于：

- Kubernetes 提供商在 [Velero 支持列表]([]) 中。
- 源和目标集群使用同一提供商（Velero 原生 PV 迁移要求）。
- 目标集群部署名称、命名空间、拓扑和凭证与源集群一致。

步骤：

1. 在源和目标集群安装 Velero。
2. 备份源集群 Etcd 部署使用的 PV。
3. 在目标集群恢复 PV。
4. 使用与源集群相同的参数部署新 Etcd，挂载恢复的 PV。


### 暴露监控指标

集群内暴露指标的方式：

- 添加 Prometheus 发现注解：

```yaml
podAnnotations:
  prometheus.io/scrape: "true"
  prometheus.io/path: "/metrics/cluster"
  prometheus.io/port: "9000"
```

- 创建 ServiceMonitor 或 PodMonitor（需 Prometheus Operator）。
- 参考 [Prometheus 抓取配置示例]([])。

集群外可通过 Kubernetes API Proxy 访问指标端点。


### 自定义配置

两种方式自定义配置：

- 环境变量：通过 `extraEnvVars` 设置额外环境变量，或通过 `extraEnvVarsCM`/`extraEnvVarsSecret` 引用 ConfigMap/Secret：

```yaml
extraEnvVars:
  - name: ETCD_AUTO_COMPACTION_RETENTION
    value: "0"
  - name: ETCD_HEARTBEAT_INTERVAL
    value: "150"
```

- 自定义 `etcd.conf.yml`：通过 `configuration` 参数定义配置，或使用 `existingConfigmap` 引用现有 ConfigMap。


### 自动压缩

Etcd 保留键空间完整历史，需定期压缩以避免性能下降和存储耗尽。压缩会删除指定修订版前的键信息，释放存储空间。

- `autoCompactionMode`：默认 `periodic`，可选 `periodic`（基于时间，如“5m”）或 `revision`（基于修订版号）。
- `autoCompactionRetention`：默认 0（禁用），压缩保留时间（如“10m”）。

启用命令：

```console
autoCompactionMode=periodic
autoCompactionRetention=10m
```


### 边车容器与初始化容器

通过 `sidecars` 添加边车容器（如监控 exporter）：

```yaml
sidecars:
  - name: 镜像名称
    image: 镜像地址
    imagePullPolicy: Always
    ports:
      - name: 端口名
        containerPort: 1234
```

通过 `initContainers` 添加初始化容器：

```yaml
initContainers:
  - name: 镜像名称
    image: 镜像地址
    imagePullPolicy: Always
    ports:
      - name: 端口名
        containerPort: 1234
```


### 部署额外资源

通过 `extraDeploy` 参数部署额外 Kubernetes 对象（如 ConfigMap），直接定义完整对象规格。


### 设置 Pod 亲和性

通过 `affinity` 参数自定义亲和性，或使用 `bitnami/common` Chart 提供的预设（`podAffinityPreset`、`podAntiAffinityPreset`、`nodeAffinityPreset`）。更多信息见 [Kubernetes 亲和性文档]([])。


### 持久化存储

Bitnami Etcd 镜像将数据存储在容器的 `/bitnami/etcd` 路径，通过 Persistent Volume Claim（PVC）实现持久化。

> 注意：本文档因 DockerHub 长度限制已精简，完整内容见 [GitHub]([])。
