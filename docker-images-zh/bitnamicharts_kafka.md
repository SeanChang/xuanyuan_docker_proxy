---
image: bitnamicharts/kafka
description: "Bitnami为Apache Kafka提供的Helm Chart是一款预配置的Kubernetes包管理工具，旨在简化分布式流处理平台Apache Kafka在Kubernetes集群中的部署、配置与全生命周期运维管理，集成了高可用性集群设置、安全认证机制、Prometheus监控指标及自动伸缩策略等核心功能，帮助用户无需手动处理复杂的集群参数配置，即可快速搭建稳定、可扩展且符合生产级标准的Kafka服务，适用于从开发测试到大规模生产环境的各类场景。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/kafka
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[bitnamicharts/kafka](https://xuanyuan.cloud/zh/r/bitnamicharts/kafka)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Apache Kafka 软件包介绍


## 关于 Apache Kafka  
Apache Kafka 是一个分布式流处理平台，旨在构建实时数据管道，可作为消息代理或大数据应用的日志聚合解决方案替代品。  
[Apache Kafka 官方概述]([])  

**商标说明**：本软件列表由 Bitnami 打包。所提及的商标分属各自公司所有，使用此类商标不意味着任何关联或背书。


## 快速入门（TL;DR）  
通过以下命令快速部署：  
```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/kafka
```

> **提示**：该应用也可作为 Kubernetes 应用在 Azure Marketplace 中获取。Kubernetes 应用是在 AKS 上部署 Bitnami 的最简单方式，详见 [Azure Marketplace 列表]([])。  

如需生产环境使用 Apache Kafka，可尝试 [VMware Tanzu Application Catalog]([])（Bitnami 目录的商业版）。


## ⚠️ 重要通知：Bitnami 目录即将变更  
自 **2025年8月28日** 起，Bitnami 将升级其公共目录，通过新的 [Bitnami Secure Images 计划]([]) 提供精选的强化安全镜像。主要变更如下：  

- **首次向社区用户开放安全优化镜像**：提供经过安全加固的热门容器镜像版本。  
- **逐步淘汰非强化镜像**：Bitnami 将逐步停止对免费 tier 中非强化 Debian 基础镜像的支持，并从公共目录中移除非最新标签（non-latest tags）。社区用户将仅能访问数量减少的强化镜像，且仅以 “latest” 标签发布，供开发用途。  
- **旧镜像迁移至 Legacy 仓库**：8月28日起，两周内所有现有容器镜像（含旧版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至 “Bitnami Legacy” 仓库（docker.io/bitnamilegacy），且不再更新。  
- **生产环境建议**：对于生产工作负载和长期支持，建议采用 Bitnami Secure Images，包含强化容器、更小攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 文件及企业级支持。  

这些变更旨在通过推广软件供应链完整性最佳实践和最新部署方式，提升所有 Bitnami 用户的安全态势。详见 [Bitnami Secure Images 公告]([])。


## 简介  
本 Helm Chart 通过 [Helm]([]) 包管理器在 [Kubernetes]([]) 集群上部署 [Kafka]([])。


## 前提条件  
- Kubernetes 版本 1.23+  
- Helm 版本 3.8.0+  
- 底层基础设施需支持 PV（持久卷）供应  


## 部署步骤  
以发布名称 `my-release` 为例，执行以下命令部署：  
```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/kafka
```  

> **注意**：需将占位符 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 替换为实际的 Helm 仓库地址。例如，Bitnami 官方仓库需使用 `REGISTRY_NAME=registry-1.docker.io` 和 `REPOSITORY_NAME=bitnamicharts`。  

上述命令将以默认配置在 Kubernetes 集群中部署 Kafka。可通过 [参数配置](#参数说明) 部分自定义部署选项。  

> **提示**：使用 `helm list` 查看所有已部署的 release。  


## 配置与部署详情  

### 监听器（Listeners）配置  
本 Chart 支持自动配置 4 种监听器：  
- 控制器通信监听器  
-  broker 间通信监听器  
- Kubernetes 集群内客户端通信监听器  
- （可选）集群外客户端通信监听器（详见 [集群外访问](#从集群外访问-kafka-broker)）  

如需复杂配置，可手动设置 `listeners`、`advertisedListeners` 和 `listenerSecurityProtocolMap` 参数。  


### 启用 Kafka 安全认证  
可针对不同监听器配置认证协议。例如，客户端通信使用 `sasl_tls`，控制器和 broker 间通信使用 `tls`。支持的协议及安全特性如下表：  

| 协议方法   | 认证方式                | 是否通过 TLS 加密 |  
|------------|-------------------------|-------------------|  
| plaintext  | 无                      | 否                |  
| tls        | 无                      | 是                |  
| mtls       | 双向认证                | 是                |  
| sasl       | 通过 SASL 认证          | 否                |  
| sasl_tls   | 通过 SASL 认证          | 是                |  


#### 配置认证协议  
通过以下参数分别设置客户端、控制器、broker 间通信的认证协议：  
- `listeners.client.protocol`  
- `listeners.controller.protocol`  
- `listeners.interbroker.protocol`  


#### SASL 认证配置  
若某监听器启用 SASL 认证，需通过以下参数设置凭据：  
- 客户端通信：`sasl.client.users`/`sasl.client.passwords`  
- broker 间通信：`sasl.interbroker.user`/`sasl.interbroker.password`  
- 控制器通信：`sasl.controller.user`/`sasl.controller.password`  


#### TLS 认证/加密配置  
需为每个 Kafka 节点创建包含 Java Key Stores（JKS）文件的 Secret：信任库（`kafka.truststore.jks`）和密钥库（`kafka.keystore.jks`），部署时通过 `tls.existingSecret` 参数传入 Secret 名称。  

> **注意**：若 JKS 文件受密码保护（推荐），需通过 `tls.keystorePassword` 和 `tls.truststorePassword` 提供密码。  

**示例**：为 2 节点 Kafka 集群创建 JKS Secret：  
```console
kubectl create secret generic kafka-jks-0 --from-file=kafka.truststore.jks=./kafka.truststore.jks --from-file=kafka.keystore.jks=./kafka-0.keystore.jks
kubectl create secret generic kafka-jks-1 --from-file=kafka.truststore.jks=./kafka.truststore.jks --from-file=kafka.keystore.jks=./kafka-1.keystore.jks
```  

> **说明**：上述命令需预先准备好 JKS 文件。可使用 [此脚本]([]) 生成 JKS 文件。  


### 凭证更新  
升级时，Chart 会复用之前生成的 Secret 或 `sasl.existingSecret` 指定的 Secret。如需更新凭证，可：  
- 执行 `helm upgrade` 并通过 `sasl` 部分参数传入新凭证  
- 执行 `helm upgrade` 并通过 `sasl.existingSecret` 指定新 Secret  


### 从集群外访问 Kafka Broker  
需配置额外的监听器和暴露监听器，并为每个 Kafka Pod 创建独立服务。支持以下三种方式：  


#### 方式一：使用 LoadBalancer 服务  
**选项 A：自动发现随机 LoadBalancer IP**（需 initContainer 等待 IP 就绪）：  
```console
externalAccess.enabled=true
externalAccess.broker.service.type=LoadBalancer
externalAccess.controller.service.type=LoadBalancer
externalAccess.broker.service.ports.external=9094
externalAccess.controller.service.ports.external=9094
defaultInitContainers.autoDiscovery.enabled=true
serviceAccount.create=true
broker.automountServiceAccountToken=true
controller.automountServiceAccountToken=true
rbac.create=true
```  
> **注意**：若集群启用 RBAC，需创建 RBAC 规则。  

**选项 B：手动指定 LoadBalancer IP**：  
```console
externalAccess.enabled=true
externalAccess.controller.service.type=LoadBalancer
externalAccess.controller.service.containerPorts.external=9094
externalAccess.controller.service.loadBalancerIPs[0]='external-ip-1'  # 替换为实际 IP
externalAccess.broker.service.type=LoadBalancer
externalAccess.broker.service.ports.external=9094
externalAccess.broker.service.loadBalancerIPs[0]='external-ip-3'  # 替换为实际 IP
```  


#### 方式二：使用 NodePort 服务  
**选项 A：自动发现随机 NodePort**：  
```console
externalAccess.enabled=true
externalAccess.controller.service.type=NodePort
externalAccess.broker.service.type=NodePort
defaultInitContainers.autoDiscovery.enabled=true
serviceAccount.create=true
rbac.create=true
```  

**选项 B：手动指定 NodePort**：  
```console
externalAccess.enabled=true
externalAccess.controller.service.type=NodePort
externalAccess.controller.service.nodePorts[0]='node-port-1'  # 替换为实际端口
```  

**选项 C：手动指定外部 IP**：  
```console
externalAccess.enabled=true
externalAccess.controller.service.type=NodePort
externalAccess.controller.service.externalIPs[0]='172.16.0.20'  # 替换为实际 IP
```  


#### 方式三：使用 ClusterIP 服务（需配合 Ingress）  
```console
externalAccess.enabled=true
externalAccess.controller.service.type=ClusterIP
externalAccess.controller.service.ports.external=9094
externalAccess.controller.service.domain='ingress-ip'  # 替换为 Ingress IP
externalAccess.broker.service.type=ClusterIP
externalAccess.broker.service.ports.external=9094
externalAccess.broker.service.domain='ingress-ip'  # 替换为 Ingress IP
```  


### 资源需求与限制  
可通过 `resources` 参数设置容器资源请求（requests）和限制（limits）。生产环境建议根据实际需求调整，而非依赖 `resourcesPreset` 预设（预设可能无法完全适配场景）。详见 [Kubernetes 容器资源管理文档]([])。  


### Prometheus 监控集成  
#### 启用监控  
设置 `metrics.jmx.enabled=true` 即可集成 Prometheus。此时会在所有 Pod 中部署 [jmx_exporter]([]) 边车容器，并创建带自动采集注解的 `metrics` 服务。  

#### 前提条件  
需已安装 Prometheus 或 Prometheus Operator。推荐使用 [Bitnami Prometheus Helm Chart]([]) 快速部署。  

#### 与 Prometheus Operator 集成  
设置 `metrics.serviceMonitor.enabled=true` 可部署 `ServiceMonitor` 对象，需确保集群已安装 Prometheus Operator CRD。  


### 持久化存储  
Bitnami Kafka 镜像将数据存储在容器内 `/bitnami/kafka` 路径，通过 Persistent Volume Claim（PVC）实现数据持久化，支持 GCE、AWS、minikube 等环境。  

#### 调整持久卷权限  
默认以非 root 用户运行镜像，需确保持久卷可写。可通过以下方式实现：  
- 启用 Kubernetes 安全上下文自动调整权限（默认配置）。  
- 若上述方式不支持，设置 `volumePermissions.enabled=true`，通过 initContainer 调整卷权限。  


### 备份与恢复  
使用 [Velero]([])（Kubernetes 备份工具）备份源部署的持久卷，并将其挂载到新部署中。详见 [Velero 使用指南]([])。  


## 参数说明  
### 全局参数  

| 参数名 `global.imageRegistry` | 描述                 | 默认值 |  
|-------------------------------|----------------------|--------|  
| 全局 Docker 镜像仓库地址      | 为空则使用官方仓库   | `""`   |  
| `global.imagePullSecrets`     | 全局镜像拉取密钥数组 | `[]`   |  


> **注意**：完整参数列表超出本文长度限制，详见 [GitHub 完整文档]([])。
