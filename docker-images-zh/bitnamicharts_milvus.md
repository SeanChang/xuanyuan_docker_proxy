<!-- xuanyuan-docker-images-zh
image: bitnamicharts/milvus
source: https://xuanyuan.cloud/zh/r/bitnamicharts/milvus
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/milvus
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/bitnamicharts/milvus" title="bitnamicharts/milvus Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/milvus — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/bitnamicharts/milvus" title="bitnamicharts/milvus Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnamicharts/milvus</a></p>

# Bitnami Milvus 软件包介绍  


## Milvus 简介  
Milvus 是一款云原生、开源的向量数据库，专为 AI 应用和相似度搜索设计，具备高可扩展性、混合搜索能力及统一 lambda 架构。  

[Milvus 官方概述]([])  

**商标说明**：本软件包由 Bitnami 打包，产品中提及的所有商标分属各自公司所有，使用这些商标并不意味着存在关联或背书关系。  


## 快速部署（TL;DR）  
```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/milvus
```  

如需在生产环境使用 Milvus，可尝试 [VMware Tanzu Application Catalog]([])（Bitnami 商业版应用目录）。  


## ⚠️ 重要通知：Bitnami 应用目录即将变更  
自 2025 年 8 月 28 日起，Bitnami 将升级其公共应用目录，推出全新的 [Bitnami Secure Images 计划]([])，提供精选的强化版、安全聚焦的镜像。本次调整包括：  

- 首次向社区用户开放热门容器镜像的安全优化版本。  
- Bitnami 将逐步停止对免费 tier 中非强化的 Debian 基础镜像的支持，并从公共目录中移除非最新标签（non-latest tags）。社区用户将仅能访问数量减少的强化镜像，且这些镜像仅以 “latest” 标签发布，供开发用途。  
- 2025 年 8 月 28 日起，两周内所有现有容器镜像（包括旧版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至 “Bitnami Legacy” 仓库（docker.io/bitnamilegacy），且不再接收更新。  
- 对于生产工作负载和长期支持，建议用户采用 Bitnami Secure Images，包含强化容器、更小攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 文件及企业级支持。  

这些变更旨在通过推广软件供应链完整性最佳实践和最新部署方式，提升所有 Bitnami 用户的安全态势。详情参见 [Bitnami Secure Images 公告]([])。  


## 概述  
Bitnami Helm 图表经过精心设计和持续维护，是在 Kubernetes 集群上快速部署容器的最简单方式，可直接用于生产环境。  

本图表通过 [Helm]([]) 包管理器在 [Kubernetes]([]) 集群中部署 [Milvus]([])。  


## 前提条件  
- Kubernetes 1.23 及以上版本  
- Helm 3.8.0 及以上版本  
- 底层基础设施支持 PV 动态供应  


## 安装图表  
如需以发布名称 `my-release` 安装图表，执行：  
```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/milvus
```  

> **注意**：需将占位符 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 替换为实际的 Helm 仓库地址。例如，Bitnami 仓库需使用 `REGISTRY_NAME=registry-1.docker.io` 和 `REPOSITORY_NAME=bitnamicharts`。  

上述命令将以默认配置在集群中部署 Milvus。[参数](#参数) 部分列出了安装时可配置的选项。  

> **提示**：使用 `helm list` 命令查看所有发布。  


## 配置与安装详情  

### 资源请求与限制  
Bitnami 图表允许为部署中的所有容器设置资源请求（requests）和限制（limits），配置位于 `resources` 参数中（参见参数表）。生产环境务必设置资源请求，并根据实际需求调整。  

图表提供 `resourcesPreset` 参数，可根据预设自动配置 `resources` 部分（预设详情见 [bitnami/common 图表]([])）。但生产环境不建议依赖预设，需根据具体场景自定义。更多容器资源管理信息参见 [Kubernetes 官方文档]([])。  


### Prometheus 指标集成  
通过将 `coordinator`、`dataNode`、`queryNode`、`streamingNode` 和 `proxy` 部分的 `*.metrics.enabled` 设为 `true`，可启用 Prometheus 指标集成。这将在容器和服务中暴露 Milvus 原生 Prometheus 端口，服务也会添加自动发现注解。  

#### 前置条件  
需先安装 Prometheus 或 Prometheus Operator。可通过 [Bitnami Prometheus Helm 图表]([]) 或 [Bitnami Kube Prometheus Helm 图表]([]) 快速部署。  

#### 与 Prometheus Operator 集成  
设置 `*.metrics.serviceMonitor.enabled=true`（同上组件）可部署 `ServiceMonitor` 对象，实现与 Prometheus Operator 的集成。需确保集群已安装 Prometheus Operator CRD，否则会报错：  
```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```  

可通过 [Bitnami Kube Prometheus Helm 图表]([]) 安装所需 CRD 和 Prometheus Operator。  


### 滚动标签与不可变标签  
生产环境强烈建议使用不可变标签（immutable tags），避免因标签更新导致部署自动变更。Bitnami 会在主容器更新、重大变更或发现严重漏洞时，发布新图表更新容器。  


### Milvus 配置  
Milvus 配置文件 `milvus.yaml` 由 `coordinator`、`dataNode`、`queryNode`、`streamingNode` 等组件共享，通过 `milvus.defaultConfig` 设置。可通过 `milvus.extraConfig` 添加额外配置，或在各组件的 `extraConfig` 部分自定义组件专属配置。具体配置项参见 [Milvus 官方文档]([])。  


### 备份与恢复  
如需备份和恢复 Kubernetes 上的 Helm 部署，需通过 [Velero]([])（Kubernetes 备份工具）备份源部署的持久卷，并将其挂载到新部署。操作步骤参见 [Velero 使用指南]([])。  


### 额外环境变量  
如需添加额外环境变量（如自定义初始化脚本），可在 `rootCoord`、`dataCoord`、`indexCoord`、`dataNode`、`streamingNode`、`attu`、`queryNode` 等组件的 `extraEnvVars` 中配置：  
```yaml
dataCoord:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
# 其他组件类似
```  

也可通过 `extraEnvVarsCM` 或 `extraEnvVarsSecret` 引用 ConfigMap 或 Secret 中的环境变量。  


### 边车容器与初始化容器  
如需在 Pod 中添加额外容器（如指标或日志导出器），可在上述组件的 `sidecars` 中定义：  
```yaml
sidecars:
- name: 自定义镜像名
  image: 镜像地址
  imagePullPolicy: Always
  ports:
  - name: 端口名
    containerPort: 1234
```  

如需暴露边车容器端口，可通过 `service.extraPorts` 配置：  
```yaml
service:
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```  

> **注意**：本图表已包含 Prometheus 导出器边车容器（需通过 `--enable-metrics=true` 启用），`sidecars` 参数仅用于添加额外容器。  

初始化容器可通过 `initContainers` 配置，示例同上。更多信息参见 [边车容器]([]) 和 [初始化容器]([]) 文档。  


###  credentials 更新  
Bitnami 图表在首次启动时配置 credentials，后续更新需手动操作：  
1. 按 [官方文档]([]) 更新用户密码。  
2. 用新密码更新 Secret（替换占位符 `SECRET_NAME`、`PASSWORD`、`ROOT_PASSWORD`）：  
```shell
kubectl create secret generic SECRET_NAME --from-literal=password=PASSWORD --from-literal=root-password=ROOT_PASSWORD --dry-run -o yaml | kubectl apply -f -
```  


### 外部服务集成  
#### 外部 Kafka  
如需连接外部 Kafka（而非集群内安装），需禁用内置 Kafka 并配置 `externalKafka`：  
```yaml
kafka:
  enabled: false
externalKafka:
  hosts:
    - 外部 Kafka 地址
```  

#### 外部 etcd  
类似地，连接外部 etcd 需禁用内置 etcd 并配置 `externalEtcd`：  
```yaml
etcd:
  enabled: false
externalEtcd:
  hosts:
    - 外部 etcd 地址
```  

#### 外部 S3 存储  
连接外部 S3 存储需禁用内置 MinIO 并配置 `externalS3`：  
```console
minio.enabled=false
externalS3.host=外部存储地址
externalS3.accessKeyID=访问密钥
externalS3.accessKeySecret=密钥
```  


### Ingress 配置  
若集群已安装 Ingress 控制器（如 [nginx-ingress-controller]([]) 或 [contour]([])），可通过 Ingress 暴露服务。设置 `attu.ingress.enabled=true` 启用 Ingress。  

- **单主机场景**：通过 `attu.ingress.hostname` 设置主机名，`attu.ingress.tls` 配置 TLS。  
- **多主机场景**：通过 `attu.ingress.extraHosts` 添加额外主机，`attu.ingress.extraTLS` 配置对应 TLS。  

> **注意**：`extraHosts` 需指定名称、路径及 Ingress 控制器注解（不同控制器支持的注解不同，参考 [注解列表]([])）。  


### TLS 安全配置  
Ingress 支持多种 TLS 配置方式：  
- **通过 Helm 参数管理证书**：将证书和密钥内容填入 `*.ingress.secrets` 的 `certificate` 和 `key`。  
- **外部管理证书**：创建名为 `INGRESS_HOSTNAME-tls` 的 TLS Secret（`INGRESS_HOSTNAME` 替换为实际主机名）。  
- **cert-manager 自动签发**：在 `*.ingress.annotations` 中添加 [cert-manager 注解]([])。  
- **自签名证书**：设置 `*.ingress.tls=true` 和 `*.ingress.selfSigned=true`。  


## 参数  
### 全局参数  

| 参数名 | 描述 | 默认值 |
| --- | --- | --- |
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局镜像拉取密钥数组 | `[]` |
| `global.defaultStorageClass` | 持久卷默认存储类 | `""` |
| `global.security.allowInsecureImages` | 是否允许跳过镜像校验 | `false` |


### 通用参数  

| 参数名 | 描述 | 默认值 |
| --- | --- | --- |
| `kubeVersion` | 覆盖 Kubernetes 版本 | `""` |
| `nameOverride` | 部分覆盖资源全名 | `""` |
| `fullnameOverride` | 完全覆盖资源全名 | `""` |
| `commonLabels` | 所有资源的标签 | `{}` |
| `commonAnnotations` | 所有资源的注解 | `{}` |


> **注意**：完整参数列表参见 [Bitnami Milvus 图表 GitHub 仓库]([])。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/bitnamicharts/milvus" title="bitnamicharts/milvus Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/bitnamicharts/milvus</a></p>
