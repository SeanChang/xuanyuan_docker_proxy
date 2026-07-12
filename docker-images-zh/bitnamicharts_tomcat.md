---
image: bitnamicharts/tomcat
description: "Bitnami提供的Apache Tomcat Helm chart，用于简化在Kubernetes环境中部署和管理Tomcat应用服务器。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/tomcat
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/tomcat
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/tomcat" title="bitnamicharts/tomcat Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/tomcat 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Apache Tomcat Helm Chart

## 镜像概述和主要用途

Apache Tomcat 是一款开源 Web 服务器，专为托管和运行基于 Java 的 Web 应用程序设计。它轻量级且性能优异，适用于生产环境中的应用部署。Bitnami Helm Chart 提供了在 Kubernetes 集群上快速部署和管理 Apache Tomcat 的标准化方案，集成了持久化存储、安全配置、监控等企业级特性。

[Apache Tomcat 官方概述](http://tomcat.apache.org/)

**商标说明**：本软件包由 Bitnami 打包，相关商标归各自公司所有，使用不意味着任何关联或背书。


## 核心功能和特性

- **符合 Java EE 规范**：支持 Java Servlet、JavaServer Pages (JSP)、Java EL 和 WebSocket 等规范，提供纯 Java HTTP 运行环境。
- **灵活部署模式**：支持 Kubernetes Deployment 或 StatefulSet 部署，可配置副本数实现高可用。
- **持久化存储**：通过 Persistent Volume Claims (PVC) 实现数据持久化，支持 GCE、AWS、minikube 等环境。
- **安全强化**：默认以非 root 用户运行，支持 Kubernetes 安全上下文配置（fsGroup、supplementalGroups 等）。
- **监控集成**：可通过 jmx_exporter 集成 Prometheus，支持自动指标采集和 PodMonitor 配置。
- **环境变量管理**：支持通过 ConfigMap、Secret 或直接定义方式注入额外环境变量。
- **扩展能力**：支持添加 Sidecar 容器和 Init 容器，满足日志收集、自定义初始化等需求。
- **资源控制**：可配置 CPU/内存资源请求与限制，支持资源预设策略。


## 使用场景和适用范围

### 适用场景
- **开发环境**：快速搭建 Tomcat 开发环境，支持应用调试和测试。
- **生产环境**：结合 Bitnami Secure Images（2025 年 8 月后推荐）部署生产级 Java Web 应用，需注意镜像版本支持策略。
- **企业级应用托管**：适用于需要稳定运行、可监控、可扩展的 Java Web 应用场景（如内部系统、门户网站等）。

### 环境要求
- Kubernetes 集群版本 1.23+
- Helm 版本 3.8.0+
- 底层基础设施支持 PV 供应
- 部署扩展需 ReadWriteMany 卷支持


## 详细使用方法和配置说明

### 前提条件
- 已安装 Kubernetes 集群（1.23+）
- 已安装 Helm 3.8.0+
- 集群支持 PV 动态供应（或手动创建 PV）


### 快速开始（TL;DR）

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/tomcat
```

> 生产环境建议使用 [VMware Tanzu Application Catalog](https://bitnami.com/enterprise)（Bitnami 商业版目录）。


### 重要通知：Bitnami 镜像目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共镜像目录，推出 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)，核心变更如下：

- **社区用户首次获得安全优化镜像**：提供针对热门容器镜像的安全强化版本。
- **非强化镜像逐步弃用**：免费 tier 中将逐步停止对非强化 Debian 基础镜像的支持，逐步移除非最新标签，社区用户仅可访问有限的强化镜像（仅保留 "latest" 标签，用于开发目的）。
- **镜像迁移至 Legacy 仓库**：2025 年 8 月 28 日起，两周内所有现有容器镜像（含历史版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至 "Bitnami Legacy" 仓库（docker.io/bitnamilegacy），且不再接收更新。
- **生产环境建议**：生产工作负载需长期支持的用户，应采用 Bitnami Secure Images，包含强化容器、更小攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 和企业支持。

更多详情见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


### 安装 Chart

#### 基本安装

使用 release 名称 `my-release` 安装 Chart：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/tomcat
```

> **注意**：需替换占位符 `REGISTRY_NAME` 和 `REPOSITORY_NAME`。Bitnami 官方仓库示例：`REGISTRY_NAME=registry-1.docker.io`，`REPOSITORY_NAME=bitnamicharts`。

#### 查看已安装 release

```console
helm list
```


### 配置与高级使用

#### 资源请求与限制

生产环境需配置资源请求与限制，避免资源争抢。可通过 `resources` 参数直接定义，或使用 `resourcesPreset` 应用预设策略（不建议生产环境使用预设，需根据实际需求调整）：

```yaml
resources:
  requests:
    cpu: 500m
    memory: 512Mi
  limits:
    cpu: 1000m
    memory: 1Gi
```

详情参考 [Kubernetes 容器资源管理](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)。


#### 更新凭证

Bitnami Chart 在首次启动时配置凭证，后续更新需手动操作：

1. 参考 [Tomcat 官方文档](https://tomcat.apache.org/) 更新用户密码。
2. 更新 Secret 中的凭证（替换 `SECRET_NAME`、`USER`、`PASSWORD`）：

```shell
kubectl create secret generic SECRET_NAME --from-literal=tomcat-username=USER --from-literal=tomcat-password=PASSWORD --dry-run -o yaml | kubectl apply -f -
```


#### Prometheus 监控集成

启用 Prometheus 指标采集：

```yaml
metrics:
  enabled: true
```

- 自动部署 jmx_exporter 作为 Sidecar 容器，暴露指标端口。
- 支持通过 `metrics.podMonitor.enabled=true` 创建 PodMonitor 对象，集成 Prometheus Operator。

**前提**：集群需已安装 Prometheus 或 Prometheus Operator。推荐使用 [Bitnami Prometheus Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus)。


#### 滚动标签与不可变标签

生产环境强烈建议使用不可变标签，避免镜像更新导致部署意外变更。Bitnami 会在主容器版本更新、重大变更或发现严重漏洞时发布新 Chart。


#### 使用不同 Tomcat 版本

通过 `image.repository` 和 `image.tag` 参数指定镜像仓库和版本：

```yaml
image:
  repository: docker.io/bitnami/tomcat
  tag: 10.1.18-debian-11-r10  # 示例版本
```


#### 添加额外环境变量

**方式 1：直接定义**

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

**方式 2：通过 ConfigMap 或 Secret**

```yaml
extraEnvVarsCM: "my-configmap"  # 现有 ConfigMap 名称
extraEnvVarsSecret: "my-secret"  # 现有 Secret 名称
```


#### Sidecar 与 Init 容器

**添加 Sidecar 容器**（如日志采集器）：

```yaml
sidecars:
  - name: log-exporter
    image: docker.xuanyuan.run/busybox:latest
    command: ["tail", "-f", "/bitnami/tomcat/logs/catalina.out"]
    volumeMounts:
      - name: tomcat-data
        mountPath: /bitnami/tomcat
```

暴露 Sidecar 端口（如需）：

```yaml
service:
  extraPorts:
    - name: log-port
      port: 8081
      targetPort: 8081
```

**添加 Init 容器**（如初始化配置）：

```yaml
initContainers:
  - name: init-config
    image: docker.xuanyuan.run/busybox:latest
    command: ["sh", "-c", "echo 'custom config' > /bitnami/tomcat/conf/custom.conf"]
    volumeMounts:
      - name: tomcat-data
        mountPath: /bitnami/tomcat
```


#### 持久化存储

Tomcat 数据和配置存储路径：`/bitnami/tomcat`（容器内）。

**配置 PVC**：

```yaml
persistence:
  enabled: true
  storageClass: "my-storage-class"
  size: 10Gi
  accessModes:
    - ReadWriteOnce
```

**权限调整**：默认通过 Kubernetes 安全上下文自动调整存储卷权限。若环境不支持，可启用 init 容器调整权限：

```yaml
volumePermissions:
  enabled: true
```


### 参数说明

#### 全局参数

| 名称 | 描述 | 默认值 |
|------|------|--------|
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局镜像拉取密钥数组 | `[]` |
| `global.defaultStorageClass` | 全局默认存储类 | `""` |
| `global.security.allowInsecureImages` | 允许跳过镜像验证 | `false` |


#### 通用参数

| 名称 | 描述 | 默认值 |
|------|------|--------|
| `nameOverride` | 部分覆盖资源名称模板 | `""` |
| `fullnameOverride` | 完全覆盖资源名称模板 | `""` |
| `commonLabels` | 所有资源的额外标签 | `{}` |
| `commonAnnotations` | 所有资源的额外注解 | `{}` |
| `clusterDomain` | Kubernetes 集群域名 | `cluster.local` |


#### Tomcat 核心参数

| 名称 | 描述 | 默认值 |
|------|------|--------|
| `replicaCount` | 副本数 | `1` |
| `deployment.type` | 部署类型（deployment/statefulset） | `deployment` |
| `tomcatUsername` | 管理员用户名 | `user` |
| `tomcatPassword` | 管理员密码（为空时自动生成） | `""` |
| `existingSecret` | 现有凭证 Secret 名称（覆盖默认生成） | `""` |
| `catalinaOpts` | JVM 参数 | `""` |
| `containerPorts.http` | 容器 HTTP 端口 | `8080` |
| `image.registry` | 镜像仓库 | `docker.io` |
| `image.repository` | 镜像名称 | `bitnami/tomcat` |
| `image.pullPolicy` | 镜像拉取策略 | `IfNotPresent` |


## 部署示例

### Helm 部署示例（生产环境）

```yaml
# values-prod.yaml
replicaCount: 3
image:
  tag: 10.1.18-debian-11-r10  # 不可变标签
persistence:
  enabled: true
  storageClass: "gp2"  # AWS EBS 存储类示例
  size: 20Gi
resources:
  requests:
    cpu: 1000m
    memory: 1Gi
  limits:
    cpu: 2000m
    memory: 2Gi
metrics:
  enabled: true
  podMonitor:
    enabled: true
extraEnvVars:
  - name: CATALINA_OPTS
    value: "-Xms1g -Xmx2g"
```

部署命令：

```console
helm install tomcat-prod oci://registry-1.docker.io/bitnamicharts/tomcat -f values-prod.yaml
```


### Docker 快速启动（开发环境）

```console
docker run -d -p 8080:8080 --name tomcat docker.xuanyuan.run/bitnami/tomcat:latest
```

> **注意**：开发环境使用，生产环境建议通过 Kubernetes 部署并采用 Bitnami Secure Images。


## 备份与恢复

生产环境建议使用 [Velero](https://velero.io/) 进行备份与恢复：

1. 备份现有部署的持久卷。
2. 在新集群中恢复卷并关联至新部署。

详情参考 [Velero 备份指南](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html)。


## 参考链接

- [Bitnami Tomcat 容器镜像](https://github.com/bitnami/containers/tree/main/bitnami/tomcat)
- [完整 Helm Chart 文档](https://github.com/bitnami/charts/blob/main/bitnami/tomcat/README.md)
- [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)
