---
image: bitnamicharts/valkey
description: "Bitnami提供的Valkey Helm chart，用于在Kubernetes环境中便捷部署高性能键值存储数据库Valkey。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/valkey
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/valkey
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/valkey" title="bitnamicharts/valkey Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/valkey 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Valkey Helm Chart 文档


## 1. 镜像概述和主要用途

Valkey 是一款开源（BSD协议）的高性能键值数据存储系统，支持缓存、消息队列、主数据库等多种工作负载场景。Bitnami Valkey Helm Chart 用于在 Kubernetes 集群上快速部署和管理 Valkey，提供预配置的集群拓扑、监控集成、安全加固等企业级特性，简化 Valkey 在容器化环境中的运维流程。


## 2. 核心功能和特性

- **多集群拓扑支持**：
  - 主从复制（Primary-Replicas）：主节点处理读写操作，从节点提供只读能力
  - 独立模式（Standalone）：单节点部署，适用于开发或轻量场景
  - 带 Sentinel 的主从架构：自动故障转移，提升高可用性
- **监控与可观测性**：集成 Prometheus `redis_exporter`，支持 ServiceMonitor 自动发现
- **安全加固**：支持密码认证、TLS 加密通信、网络策略隔离
- **灵活的持久化**：基于 PersistentVolume 的数据持久化，支持现有 PVC 复用
- **外部集成**：兼容 ExternalDNS 实现动态域名解析，支持与外部 Valkey 集群混合部署
- **配置自定义**：支持通过 ConfigMap 注入自定义 Valkey 配置、Lua 监控脚本


## 3. 使用场景和适用范围

### 适用场景
- **缓存层**：作为应用前端缓存，加速数据访问（如会话存储、热点数据缓存）
- **消息队列**：基于 List 数据结构实现简单的生产者-消费者模型
- **主数据库**：适用于中小规模键值数据存储需求
- **分布式锁**：利用 `SET NX` 命令实现分布式锁机制

### 适用范围
- **开发环境**：快速部署单节点或小规模集群，支持功能验证和调试
- **生产环境**：推荐使用带 Sentinel 的主从架构或外部托管的 Bitnami Secure Images，确保高可用性和长期支持


## 4. 前提条件

- Kubernetes 集群版本 ≥ 1.23
- Helm 版本 ≥ 3.8.0
- 集群支持 PersistentVolume（PV）动态供应
- （可选）Prometheus 或 Prometheus Operator（如需监控集成）
- （可选）ExternalDNS（如需动态域名解析）


## 5. 安装方法

### 5.1 快速开始（TL;DR）

通过 Helm 快速部署默认配置的 Valkey 集群：

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/valkey
```


### 5.2 详细安装步骤

#### 5.2.1 添加 Helm 仓库（如需）

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

#### 5.2.2 部署自定义配置

指定自定义参数部署（如设置密码、集群规模）：

```console
helm install my-release bitnami/valkey \
  --set auth.password=your_secure_password \
  --set primary.replicaCount=1 \
  --set replica.replicaCount=2
```

#### 5.2.3 验证部署

检查 Pod 状态：

```console
kubectl get pods -l app.kubernetes.io/name=valkey
```

访问 Valkey 集群（内部访问）：

```console
kubectl exec -it my-release-valkey-primary-0 -- valkey-cli -a your_secure_password
```


## 6. 配置说明

### 6.1 集群拓扑配置

#### 6.1.1 主从复制模式（默认）

架构参数 `architecture=replication`（默认），部署主节点 StatefulSet 和从节点 StatefulSet：
- 主服务（`my-release-valkey-primary`）：处理读写操作
- 从服务（`my-release-valkey-replicas`）：仅处理读操作

配置示例：
```yaml
architecture: replication
primary:
  replicaCount: 1  # 主节点数量（建议保持1）
replica:
  replicaCount: 2  # 从节点数量
```

#### 6.1.2 独立模式

架构参数 `architecture=standalone`，部署单节点 StatefulSet：

```yaml
architecture: standalone
primary:
  replicaCount: 1
```

#### 6.1.3 带 Sentinel 的主从架构

启用 Sentinel 实现自动故障转移：

```yaml
architecture: replication
sentinel:
  enabled: true  # 启用 Sentinel
  replicaCount: 3  # Sentinel 节点数量（建议 ≥3）
```

Sentinel 服务暴露在 `26379` 端口，通过以下命令查询当前主节点：
```console
kubectl exec -it my-release-valkey-node-0 -c sentinel -- valkey-cli -p 26379 SENTINEL get-primary-addr-by-name myprimary
```


### 6.2 资源请求与限制

通过 `resources` 参数配置容器资源：

```yaml
primary:
  resources:
    requests:
      cpu: 500m
      memory: 512Mi
    limits:
      cpu: 1000m
      memory: 1Gi
replica:
  resources:
    requests:
      cpu: 200m
      memory: 256Mi
```


### 6.3 认证配置

#### 6.3.1 自动生成密码

默认自动生成随机密码，存储在 Secret `my-release-valkey` 中。获取密码：
```console
kubectl get secret my-release-valkey -o jsonpath="{.data.valkey-password}" | base64 -d
```

#### 6.3.2 使用自定义密码

部署时指定密码：
```console
helm install my-release bitnami/valkey --set auth.password=your_secure_password
```

#### 6.3.3 使用现有 Secret

引用已存在的 Secret（需包含 `valkey-password` 键）：
```yaml
auth:
  existingSecret: my-existing-secret  # 现有 Secret 名称
```


### 6.4 监控集成（Prometheus）

启用 Prometheus 监控：

```yaml
metrics:
  enabled: true  # 启用监控 sidecar
  serviceMonitor:
    enabled: true  # 部署 ServiceMonitor（需 Prometheus Operator）
  extraArgs:  # 自定义 exporter 参数（如 TLS 配置）
    tls-ca-cert-file: /etc/tls/ca.crt
```

监控指标通过 `my-release-valkey-metrics` 服务暴露，默认端口 `9121`。


### 6.5 TLS 加密

#### 6.5.1 启用 TLS

创建包含证书的 Secret，然后配置：

```yaml
tls:
  enabled: true
  existingSecret: valkey-tls-secret  # 包含证书的 Secret 名称
  certFilename: tls.crt  # 证书文件名
  certKeyFilename: tls.key  # 私钥文件名
  certCAFilename: ca.crt  # CA 证书文件名
```

#### 6.5.2 监控 TLS 配置

如启用 TLS，需为监控 exporter 配置 TLS 参数：

```yaml
metrics:
  extraArgs:
    tls-client-cert-file: /etc/tls/tls.crt
    tls-client-key-file: /etc/tls/tls.key
    tls-ca-cert-file: /etc/tls/ca.crt
```


### 6.6 外部 DNS 集成

通过 ExternalDNS 自动注册 Pod FQDN：

```yaml
useExternalDNS:
  enabled: true
  suffix: prod.example.org  # DNS 后缀
  additionalAnnotations:
    ttl: 10  # DNS 记录 TTL
```

生成的 FQDN 格式：`<pod-name>.<release-name>.<suffix>`，用于 Valkey 节点间通信。


### 6.7 备份与恢复

#### 6.7.1 数据备份

手动触发 RDB 备份并导出：
```console
# 进入主节点 Pod
kubectl exec -it my-release-valkey-primary-0 -- bash
# 执行备份
valkey-cli -a $VALKEY_PASSWORD save
# 复制备份文件到本地
kubectl cp my-release-valkey-primary-0:/data/dump.rdb ./dump.rdb -c valkey
```

#### 6.7.2 数据恢复

1. 创建临时 Pod 挂载目标 PVC：
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: valkey-restore-pod
spec:
  containers:
  - name: restore
    image: docker.xuanyuan.run/bitnami/os-shell
    command: ["tail", "-f", "/dev/null"]
    volumeMounts:
    - name: valkey-data
      mountPath: /data
  volumes:
  - name: valkey-data
    persistentVolumeClaim:
      claimName: my-release-valkey-primary-0  # 目标 PVC 名称
```

2. 复制备份文件到 PVC：
```console
kubectl cp ./dump.rdb valkey-restore-pod:/data/dump.rdb
```

3. 重启 Valkey 集群：
```console
helm upgrade my-release bitnami/valkey --reuse-values
```


### 6.8 网络策略

启用网络策略限制访问：

```yaml
networkPolicy:
  enabled: true
  ingressNSMatchLabels:  # 允许指定命名空间访问
    valkey: external
  ingressNSPodMatchLabels:  # 允许指定 Pod 标签访问
    valkey-client: true
```


## 7. 持久化存储

### 使用现有 PVC

部署时指定已存在的 PVC：

```console
helm install my-release bitnami/valkey \
  --set primary.persistence.existingClaim=my-existing-pvc
```

PVC 需提前创建，且访问模式为 `ReadWriteOnce`。


## 8. 配置参数

### 全局参数

| 参数名                  | 描述                                     | 默认值 |
|-------------------------|------------------------------------------|--------|
| `global.imageRegistry`  | 全局 Docker 镜像仓库地址                 | `""`   |
| `global.imagePullSecrets` | 全局镜像拉取密钥列表                     | `[]`   |
| `global.defaultStorageClass` | 全局默认存储类                           | `""`   |


### 镜像参数

| 参数名                  | 描述                                     | 默认值 |
|-------------------------|------------------------------------------|--------|
| `image.registry`        | Valkey 镜像仓库                         | `docker.io` |
| `image.repository`      | Valkey 镜像名称                         | `bitnami/valkey` |
| `image.tag`             | Valkey 镜像标签                         | `latest` |
| `image.pullPolicy`      | 镜像拉取策略                             | `IfNotPresent` |


### 认证参数

| 参数名                  | 描述                                     | 默认值 |
|-------------------------|------------------------------------------|--------|
| `auth.enabled`          | 是否启用密码认证                         | `true` |
| `auth.password`         | Valkey 访问密码（自动生成 if 为空）      | `""`   |
| `auth.existingSecret`   | 现有密码 Secret 名称                     | `""`   |


## 9. 重要通知：Bitnami 镜像目录变更

自 2025 年 8 月 28 日起，Bitnami 将启动 **Bitnami Secure Images** 计划，优化容器镜像安全性：

- **社区版变更**：逐步淘汰非加固的 Debian 基础镜像，免费 tier 仅提供少量“latest”标签的加固镜像（用于开发）。
- **镜像迁移**：所有现有镜像（含历史版本标签，如 2.50.0）将从 `docker.io/bitnami` 迁移至 `docker.io/bitnamilegacy`，不再更新。
- **生产建议**：生产环境推荐使用 Bitnami Secure Images，包含加固容器、CVE 透明度（VEX/KEV）、SBOM 和企业支持。

详细信息参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


## 10. Docker 部署示例（单节点）

除 Helm 部署外，可通过 Docker 直接运行 Valkey 单节点：

```console
docker run -d \
  --name valkey \
  -p 6379:6379 \
  -e VALKEY_PASSWORD=your_secure_password \
  -v valkey-data:/data \
  docker.xuanyuan.run/bitnami/valkey:latest
```

- `-e VALKEY_PASSWORD`：设置访问密码
- `-v valkey-data:/data`：挂载数据卷持久化数据
- 访问：`docker exec -it valkey valkey-cli -a your_secure_password`


> 完整配置参数及高级用法参见 [Bitnami Valkey Helm Chart 文档](https://github.com/bitnami/charts/blob/main/bitnami/valkey/README.md)
