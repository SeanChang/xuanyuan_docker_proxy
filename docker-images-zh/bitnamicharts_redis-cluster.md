---
image: bitnamicharts/redis-cluster
description: "Bitnami Redis® Cluster的Helm Chart，用于在Kubernetes集群部署支持分片的Redis集群。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/redis-cluster
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/redis-cluster
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/redis-cluster" title="bitnamicharts/redis-cluster Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/redis-cluster — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnamicharts/redis-cluster" title="bitnamicharts/redis-cluster Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnamicharts/redis-cluster</a>

# Bitnami Redis® Cluster 软件包

Redis®是一个开源、可扩展的分布式内存缓存应用，用于存储和提供字符串、哈希、列表、集合及有序集合形式的数据。

[Redis® Cluster 概述](http://redis.io)

免责声明：Redis是Redis Ltd.的注册商标。其所有权利归Redis Ltd.所有。Bitnami的任何使用仅为参考目的，不表示Redis Ltd.的任何赞助、认可或关联。

## 快速开始

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/redis-cluster
```

希望在生产环境中使用Redis® Cluster？请尝试[VMware Tanzu Application Catalog](https://bitnami.com/enterprise)，即Bitnami目录的商业版。

## ⚠️ 重要通知：Bitnami目录即将变更

自2025年8月28日起，Bitnami将升级其公共目录，通过新的[Bitnami Secure Images计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)提供精选的强化、安全聚焦镜像。作为过渡的一部分：

- 首次向社区用户提供流行容器镜像的安全优化版本。
- Bitnami将开始在免费层中弃用对非强化、基于Debian的软件镜像的支持，并逐步从公共目录中移除非最新标签。因此，社区用户将可访问数量减少的强化镜像。这些镜像仅以“latest”标签发布，适用于开发目的。
- 自8月28日起，两周内所有现有容器镜像（包括旧版本或带版本的标签，如2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用Bitnami Secure Images，包括强化容器、更小的攻击面、CVE透明度（通过VEX/KEV）、SBOM以及企业支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提升所有Bitnami用户的安全态势。更多详情，请访问[Bitnami Secure Images公告](https://github.com/bitnami/containers/issues/83267)。

## 介绍

此Chart使用[Helm](https://helm.sh)包管理器在[Kubernetes](https://kubernetes.io)集群上引导[Redis®](https://github.com/bitnami/containers/tree/main/bitnami/redis)部署。

### Redis® Helm Chart与Redis® Cluster Helm Chart的选择

您可以选择以下两种Redis® Helm Chart部署Redis®集群：
[Redis® Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/redis)使用Redis® Sentinel部署主从集群，而[Redis® Cluster Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/redis-cluster)部署支持分片的Redis®集群。两者的主要特性如下：

| Redis®                                     | Redis® Cluster                                             |
|--------------------------------------------|------------------------------------------------------------|
| 支持多数据库                               | 仅支持一个数据库，适用于大型数据集                         |
| 单写入点（单个主节点）                     | 多写入点（多个主节点）                                     |
| ![Redis®拓扑](img/redis-topology.png)     | ![Redis® Cluster拓扑](img/redis-cluster-topology.png)       |

## 前提条件

- Kubernetes 1.23+
- Helm 3.8.0+
- 底层基础设施支持PV动态供应

## 安装Chart

使用发布名称`my-release`安装Chart：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/redis-cluster
```

> 注意：需将占位符`REGISTRY_NAME`和`REPOSITORY_NAME`替换为Helm Chart仓库和存储库的引用。例如，Bitnami的情况下，使用`REGISTRY_NAME=registry-1.docker.io`和`REPOSITORY_NAME=bitnamicharts`。

该命令使用默认配置在Kubernetes集群上部署Redis®。[参数](#参数)部分列出了安装过程中可配置的参数。

注意：如果等待钩子完成时出现超时错误，请增加默认超时时间（300秒），例如：

```console
helm install --timeout 600s myrelease oci://REGISTRY_NAME/REPOSITORY_NAME/redis-cluster
```

> 注意：需将占位符`REGISTRY_NAME`和`REPOSITORY_NAME`替换为Helm Chart仓库和存储库的引用。例如，Bitnami的情况下，使用`REGISTRY_NAME=registry-1.docker.io`和`REPOSITORY_NAME=bitnamicharts`。
> **提示**：使用`helm list`查看所有发布。

## 配置和安装细节

### 资源请求和限制

Bitnami Chart允许为Chart部署中的所有容器设置资源请求和限制，这些配置位于`resources`值中（参见参数表）。设置请求对于生产工作负载至关重要，应根据具体用例调整。

为简化此过程，Chart包含`resourcesPreset`值，可根据不同预设自动设置`resources`部分。有关这些预设，请查看[bitnami/common Chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15)。但在生产工作负载中，不建议使用`resourcesPreset`，因为它可能无法完全适应您的具体需求。有关容器资源管理的更多信息，请参见[Kubernetes官方文档](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)。

### Prometheus指标

通过将`metrics.enabled`设置为`true`，可将Chart与Prometheus集成。这将在所有Pod中部署带有[redis_exporter](https://github.com/oliver006/redis_exporter)的Sidecar容器和`metrics`服务，可在`metrics.service`部分下配置。此`metrics`服务将包含必要的注解，以便被Prometheus自动抓取。

#### Prometheus要求

集成需要Prometheus或Prometheus Operator正常安装。安装[Bitnami Prometheus Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus)或[Bitnami Kube Prometheus Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus)，可在集群中轻松部署Prometheus。

#### 与Prometheus Operator集成

通过设置`metrics.serviceMonitor.enabled=true`，Chart可部署`ServiceMonitor`对象以与Prometheus Operator集成。确保集群中已安装Prometheus Operator的CustomResourceDefinitions，否则将失败并显示以下错误：

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

安装[Bitnami Kube Prometheus Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus)以获取必要的CRD和Prometheus Operator。

### [滚动标签与不可变标签](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

强烈建议在生产环境中使用不可变标签。这可确保即使相同标签更新为不同镜像，部署也不会自动更改。

如果主容器有新版本、重大变更或严重漏洞，Bitnami将发布新Chart更新其容器。

### 使用不同Redis®版本

要修改此Chart使用的应用版本，可通过`image.tag`参数指定不同的镜像版本，和/或通过`image.repository`参数指定不同的仓库。

### 集群拓扑

集群成功部署至少需要3个主节点。节点总数计算公式为：`nodes = 主节点数 + 主节点数 * 副本数`。因此，默认`cluster.nodes=6`和`cluster.replicas=1`表示将部署3个主节点和3个副本节点。

默认情况下，Redis® Cluster无法从Kubernetes集群外部访问。要从外部访问，需在部署时设置`cluster.externalAccess.enabled=true`。首次安装时将创建6个LoadBalancer服务（每个Redis®节点一个），获取每个服务的外部IP后，需通过`cluster.externalAccess.service.loadbalancerIP`数组传递这些IP进行升级。

副本是主节点的只读副本。默认情况下（不使用外部访问模式）仅公开一个服务。无论读写操作，客户端均连接到公开的服务。当写操作到达副本时，副本会将客户端重定向到正确的主节点。例如，使用`redis-cli`时需提供`-c`标志以自动跟随重定向。

使用外部访问模式时，可连接到任何Pod，从节点将以相同方式重定向客户端，但所有IP均为公共IP。

若主节点崩溃，其从节点之一将升级为主节点。崩溃主节点存储的槽位在从节点完成升级前不可用。若主节点及其所有从节点均崩溃，集群将不可用，直至其中一个节点恢复。要避免 downtime，可通过`cluster.nodes`和`cluster.replicas`配置Redis®节点数量。例如：

- `cluster.nodes=9`（3个主节点，每个主节点2个副本）
- `cluster.replicas=2`

> 注意：默认`cluster.init=true`以在首次安装时初始化Redis® Cluster。若仅测试部署或升级节点而避免创建集群，可设置`cluster.init=false`。

#### 添加新节点到集群

可通过`post-upgrade`钩子执行作业添加新节点。需提供以下参数：

- 通过`password`参数提供安装时使用的密码。若未提供密码，可按照NOTES.txt中的说明获取生成的密码。
- 设置`cluster.nodes`为所需节点数。
- 设置`cluster.update.currentNumberOfNodes`为当前节点数。
- 设置`cluster.update.addNodes=true`。

以下是添加一个节点的示例：

```console
helm upgrade --timeout 600s <release> --set "password=${REDIS_PASSWORD},cluster.nodes=7,cluster.update.addNodes=true,cluster.update.currentNumberOfNodes=6" oci://REGISTRY_NAME/REPOSITORY_NAME/redis-cluster
```

> 注意：需将占位符`REGISTRY_NAME`和`REPOSITORY_NAME`替换为Helm Chart仓库和存储库的引用。例如，Bitnami的情况下，使用`REGISTRY_NAME=registry-1.docker.io`和`REPOSITORY_NAME=bitnamicharts`。

其中`REDIS_PASSWORD`是Helm Chart首次安装后显示的命令获取的密码。集群将在重启Pod时保持可用，前提是未丢失法定人数。

##### 外部访问

使用外部访问时，添加新节点需执行两次升级。首次升级添加新Redis®节点并获取LoadBalancerIP服务：

```console
helm upgrade <release> --set "password=${REDIS_PASSWORD},cluster.externalAccess.enabled=true,cluster.externalAccess.service.type=LoadBalancer,cluster.externalAccess.service.loadBalancerIP[0]=<loadBalancerip-0>,cluster.externalAccess.service.loadBalancerIP[1]=<loadbalanacerip-1>,cluster.externalAccess.service.loadBalancerIP[2]=<loadbalancerip-2>,cluster.externalAccess.service.loadBalancerIP[3]=<loadbalancerip-3>,cluster.externalAccess.service.loadBalancerIP[4]=<loadbalancerip-4>,cluster.externalAccess.service.loadBalancerIP[5]=<loadbalancerip-5>,cluster.externalAccess.service.loadBalancerIP[6]=,cluster.nodes=7,cluster.init=false" oci://REGISTRY_NAME/REPOSITORY_NAME/redis-cluster
```

> 注意：需将占位符`REGISTRY_NAME`和`REPOSITORY_NAME`替换为Helm Chart仓库和存储库的引用。例如，Bitnami的情况下，使用`REGISTRY_NAME=registry-1.docker.io`和`REPOSITORY_NAME=bitnamicharts`。
> 重要：为避免索引错误，需为新节点的loadBalancerIP参数留空。

设置`cluster.nodes=7`并为新节点留空LoadBalancerIP，集群将提供正确的IP。此时，新Redis® Pod将处于`crashLoopBackOff`状态，直至提供新服务的LoadBalancerIP。

等待集群提供新服务的LoadBalancerIP后，执行第二次升级：

```console
helm upgrade <release> --set "password=${REDIS_PASSWORD},cluster.externalAccess.enabled=true,cluster.externalAccess.service.type=LoadBalancer,cluster.externalAccess.service.loadBalancerIP[0]=<loadbalancerip-0>,cluster.externalAccess.service.loadBalancerIP[1]=<loadbalancerip-1>,cluster.externalAccess.service.loadBalancerIP[2]=<loadbalancerip-2>,cluster.externalAccess.service.loadBalancerIP[3]=<loadbalancerip-3>,cluster.externalAccess.service.loadBalancerIP[4]=<loadbalancerip-4>,cluster.externalAccess.service.loadBalancerIP[5]=<loadbalancerip-5>,cluster.externalAccess.service.loadBalancerIP[6]=<loadbalancerip-6>,cluster.nodes=7,cluster.init=false,cluster.update.addNodes=true,cluster.update.newExternalIPs[0]=<load-balancerip-6>" oci://REGISTRY_NAME/REPOSITORY_NAME/redis-cluster
```

> 注意：需将占位符`REGISTRY_NAME`和`REPOSITORY_NAME`替换为Helm Chart仓库和存储库的引用。例如，Bitnami的情况下，使用`REGISTRY_NAME=registry-1.docker.io`和`REPOSITORY_NAME=bitnamicharts`。

需在`cluster.update.newExternalIPs`提供新IP，设置`cluster.update.addNodes=true`以启用添加节点的作业，并设置新服务的LoadBalancerIP（不再留空）。

> 注意：为避免再次创建初始化Redis® Cluster的作业，需提供`cluster.init=false`。

#### 集群缩容

缩容Redis® Cluster步骤如下：

首先执行常规升级，将`cluster.nodes`设置为所需节点数。节点数不得少于6，且当前节点数与所需节点数之差应小于或等于`cluster.replicas`，以避免同时移除主节点及其从节点。还需通过`password`提供密码。例如，从多于6个节点缩容至6个节点：

```console
helm upgrade --timeout 600s <release> --set "password=${REDIS_PASSWORD},cluster.nodes=6" .
```

只要未丢失法定人数，集群将在更新期间继续运行。

> 注意：为避免再次创建初始化Redis® Cluster的作业，需提供`cluster.init=false`。

所有节点就绪后，使用`CLUSTER NODES`命令获取集群节点列表。记录显示`fail`的节点ID，在每个集群节点上执行`redis-cli -a $REDIS_PASSWORD CLUSTER FORGET NODE_ID`。

### 使用密码文件

要使用密码文件，需创建包含密码的Secret（密码文件必须命名为`redis-password`），然后部署时指定：

```text
usePassword=true
usePasswordFile=true
existingSecret=redis-password-secret
metrics.enabled=true
```

### 使用TLS加密流量

通过指定`tls.`参数启用TLS支持，需配置证书Secret、证书文件名等。示例：

```console
kubectl create secret generic certificates-tls-secret --from-file=./cert.pem --from-file=./cert.key --from-file=./ca.pem
```

部署参数：

```console
tls.enabled="true"
tls.existingSecret="certificates-tls-secret"
tls.certFilename="cert.pem"
tls.certKeyFilename="cert.key"
tls.certCAFilename="ca.pem"
```

### Sidecar和Init容器

通过`sidecars`和`initContainers`参数添加额外容器，遵循Kubernetes容器规范。

### 其他配置

包括添加额外环境变量、主机内核设置、网络策略、Pod亲和性配置等，详情参见完整文档。

## 持久化

默认挂载Persistent Volume（动态供应），禁用时使用emptyDir（仅测试环境），因缺少nodes.conf文件可能导致节点独立运行。

注意：此Chart的README因超出DockerHub限制被截断。完整README请参见https://github.com/bitnami/charts/blob/main/bitnami/redis-cluster/README.md
