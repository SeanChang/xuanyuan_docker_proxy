---
image: bitnamicharts/apisix
description: "Bitnami提供的Helm图表，用于在Kubernetes环境中简化Apache APISIX API网关的部署与管理。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/apisix
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/apisix
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/apisix" title="bitnamicharts/apisix Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/apisix 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Apache APISIX Helm Chart 文档


## 镜像概述和主要用途

Apache APISIX 是一款高性能、实时的 API 网关，支持负载均衡、动态上游、金丝雀发布、熔断、认证、可观测性等功能。Bitnami Apache APISIX Helm Chart 用于在 Kubernetes 集群上通过 Helm 包管理器快速部署和配置 Apache APISIX，简化其在容器化环境中的部署流程。


## 核心功能和特性

- **高性能**：基于 Nginx 和 etcd，提供低延迟、高吞吐量的 API 流量处理能力。
- **动态配置**：支持无需重启即可动态更新路由、上游服务等配置。
- **多部署模式**：支持分离模式（默认）、传统模式和独立模式，适应不同场景需求。
- **丰富的流量管理**：包含负载均衡、熔断、限流、金丝雀发布等流量控制功能。
- **可观测性集成**：支持与 Prometheus 等监控工具集成，提供 metrics 数据。
- **安全特性**：支持 TLS 加密、认证授权（如 JWT、OAuth2）等安全机制。
- **灵活扩展**：可通过 Helm 参数自定义资源、环境变量、sidecar 容器等配置。


## 使用场景和适用范围

- **API 网关**：作为微服务架构的入口，统一管理 API 流量。
- **流量管理**：实现请求路由、负载均衡、熔断降级，保障服务稳定性。
- **安全防护**：对 API 进行认证、授权和加密，防止未授权访问。
- **可观测性**：集成监控工具，实时监控 API 性能和健康状态。
- **开发与生产环境**：支持开发环境快速部署，同时提供生产级配置选项（如资源限制、Immutable 标签）。


## 前提条件

- Kubernetes 集群版本 1.23+
- Helm 版本 3.8.0+


## 详细使用方法和配置说明

### 快速部署（TL;DR）

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/apisix
```


### 重要通知：Bitnami 镜像目录变更

自 2025 年 8 月 28 日起，Bitnami 将调整其公共镜像目录，推出 **Bitnami Secure Images** 计划，主要变更包括：

- 社区用户首次可访问安全优化版本的容器镜像。
- 逐步弃用免费 tier 中非强化的 Debian 基础镜像，仅保留“latest”标签的强化镜像（用于开发目的）。
- 现有容器镜像（含历史版本标签，如 2.50.0、10.6）将迁移至 `docker.io/bitnamilegacy` 仓库，不再更新。
- 生产环境建议使用 Bitnami Secure Images，提供强化容器、SBOM、CVE 透明度及企业支持。

详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


## 安装与配置

### 前提条件检查

确保集群满足以下要求：
- Kubernetes 1.23+
- Helm 3.8.0+
- （可选）Prometheus 或 Prometheus Operator（如需监控集成）


### 安装 Helm Chart

#### 标准安装

使用默认配置安装，发布名称为 `my-release`：

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/apisix
```

#### 自定义安装

通过 `--set` 参数或自定义 values 文件覆盖默认配置：

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/apisix \
  --set dataPlane.replicaCount=3 \
  --set etcd.enabled=false \
  --set externalEtcd.hosts={external-etcd-host}
```


### 部署模式配置

Apache APISIX 支持多种部署模式，可通过 Helm 参数切换。

#### 分离模式（默认）

控制平面（Control Plane）和数据平面（Data Plane）分离部署，适用于大规模集群：

```yaml
# 默认配置无需额外设置
dataPlane:
  enabled: true  # 数据平面启用
controlPlane:
  enabled: true  # 控制平面启用
etcd:
  enabled: true  # 内置 etcd 启用
```

#### 传统模式

控制平面和数据平面合并部署：

```yaml
dataPlane:
  enabled: false  # 禁用独立数据平面
controlPlane:
  extraConfig:
    deployment:
      role: traditional  # 设置为传统模式
      role_traditional:
        config_provider: etcd  # 使用 etcd 存储配置
  service:
    extraPorts:  # 暴露 HTTP/HTTPS 端口
      - name: http
        port: 80
        targetPort: 9080
      - name: https
        port: 443
        targetPort: 9443
```

#### 独立模式

无需 etcd，使用本地文件存储配置（适用于小规模或边缘场景）：

```yaml
controlPlane:
  enabled: false  # 禁用控制平面
ingressController:
  enabled: false  # 禁用 Ingress Controller
etcd:
  enabled: false  # 禁用 etcd
dashboard:
  enabled: false  # 禁用 Dashboard
dataPlane:
  extraConfig:
    deployment:
      role_data_plane:
        config_provider: yaml  # 使用 YAML 文件配置
  extraVolumes:  # 挂载包含路由配置的 ConfigMap
    - name: routes
      configMap:
        name: apisix-routes
  extraVolumeMounts:
    - name: routes
      mountPath: /usr/local/apisix/conf/apisix.yaml
      subPath: apisix.yaml
extraDeploy:  # 部署路由配置 ConfigMap
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: apisix-routes
    data:
      apisix.yaml: |-
        routes:
          - uri: /hello
            upstream:
              nodes:
                "127.0.0.1:1980": 1
              type: roundrobin
```


### Prometheus 监控集成

通过以下配置启用 metrics 采集：

#### 基础监控（暴露 metrics 端口）

```yaml
dataPlane:
  metrics:
    enabled: true  # 启用数据平面 metrics
controlPlane:
  metrics:
    enabled: true  # 启用控制平面 metrics
```

#### 与 Prometheus Operator 集成（ServiceMonitor）

```yaml
dataPlane:
  metrics:
    serviceMonitor:
      enabled: true  # 创建 ServiceMonitor 对象
controlPlane:
  metrics:
    serviceMonitor:
      enabled: true
```

> **注意**：需先部署 Prometheus Operator 及相关 CRD（可使用 Bitnami Kube Prometheus Helm Chart）。


### 外部 etcd 配置

如需使用外部 etcd 而非内置实例：

```yaml
etcd:
  enabled: false  # 禁用内置 etcd
externalEtcd:
  hosts:  # 外部 etcd 节点列表
    - external-etcd-0.example.com
    - external-etcd-1.example.com
  port: 2379  # etcd 端口（默认 2379）
  tls:  # 如需 TLS 认证
    enabled: true
    existingSecret: etcd-tls-secret  # 包含 etcd 证书的 Secret 名称
```


### Ingress 与 TLS 配置

#### Ingress 规则配置

通过 Ingress 暴露 APISIX 服务：

```yaml
ingress:
  enabled: true  # 启用 Ingress
  hostname: apisix.example.com  # 域名
  tls: true  # 启用 TLS
  annotations:
    kubernetes.io/ingress.class: nginx  # 指定 Ingress Controller
```

#### TLS 证书管理

- **使用现有 Secret**：创建包含 TLS 证书的 Secret（名称格式为 `<hostname>-tls`），例如：
  ```bash
  kubectl create secret tls apisix-example-com-tls \
    --cert=path/to/tls.crt \
    --key=path/to/tls.key
  ```

- **通过 cert-manager 自动签发**：添加 cert-manager 注解：
  ```yaml
  ingress:
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
  ```


## 参数说明

### 全局参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `global.imageRegistry` | 全局 Docker 镜像仓库地址 | `""` |
| `global.imagePullSecrets` | 镜像拉取密钥列表 | `[]` |
| `global.security.allowInsecureImages` | 是否允许不安全镜像（跳过校验） | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 适配 OpenShift 安全上下文（`auto`/`force`/`disabled`） | `auto` |


### 通用参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `nameOverride` | 覆盖资源名称前缀 | `""` |
| `fullnameOverride` | 完全覆盖资源全名 | `""` |
| `image.registry` | APISIX 镜像仓库 | `docker.io/bitnami` |
| `image.repository` | APISIX 镜像名称 | `apisix` |
| `image.pullPolicy` | 镜像拉取策略 | `IfNotPresent` |
| `diagnosticMode.enabled` | 启用诊断模式（禁用探针，覆盖命令） | `false` |


### 数据平面参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `dataPlane.enabled` | 是否启用数据平面 | `true` |
| `dataPlane.replicaCount` | 数据平面副本数 | `1` |
| `dataPlane.useDaemonSet` | 是否以 DaemonSet 部署 | `false` |
| `dataPlane.hostNetwork` | 是否使用主机网络 | `false` |
| `dataPlane.resources` | 资源请求与限制 | `{}` |
| `dataPlane.metrics.enabled` | 是否启用 metrics | `false` |


### 控制平面参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `controlPlane.enabled` | 是否启用控制平面 | `true` |
| `controlPlane.replicaCount` | 控制平面副本数 | `1` |
| `controlPlane.extraConfig` | 额外配置（如部署模式、路由规则） | `{}` |
| `controlPlane.metrics.enabled` | 是否启用 metrics | `false` |


## 升级与维护

### 升级 Helm Chart

```console
helm upgrade my-release oci://registry-1.docker.io/bitnamicharts/apisix
```

### 更新凭证

如需更新 Dashboard 密码：

```console
helm upgrade my-release oci://registry-1.docker.io/bitnamicharts/apisix \
  --set dashboard.password=new-strong-password
```

或使用现有 Secret：

```console
helm upgrade my-release oci://registry-1.docker.io/bitnamicharts/apisix \
  --set dashboard.existingSecret=new-dashboard-secret
```


## 卸载

```console
helm uninstall my-release
```

> **注意**：卸载不会自动删除持久卷（PV）和 etcd 数据，需手动清理。


## 参考链接

- [Apache APISIX 官方文档](https://apisix.apache.org/docs/apisix/)
- [Bitnami Apache APISIX Helm Chart 源码](https://github.com/bitnami/charts/tree/main/bitnami/apisix)
- [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)
