---
image: bitnamicharts/gitea
description: "Bitnami提供的Gitea Helm chart，用于在Kubernetes环境中便捷部署和管理自托管Git服务。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/gitea
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/gitea
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/gitea" title="bitnamicharts/gitea Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/gitea 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Gitea Docker镜像文档

## 1. 镜像概述和主要用途

Gitea是一款轻量级代码托管解决方案，采用Go语言开发，具有资源消耗低、易于升级和支持多种数据库等特点。Bitnami Gitea镜像提供了一种简单、可靠的方式来部署和运行Gitea服务，适用于个人开发者、小型团队和企业内部使用。

[Gitea官方网站](https://gitea.io/)

**商标说明**：本软件列表由Bitnami打包。所提及的各个商标分别归各自公司所有，使用这些商标并不意味着任何关联或认可。

## 2. 核心功能和特性

- **轻量级设计**：资源消耗低，适合在各种环境中部署
- **完整功能集**：提供Git代码仓库管理、用户管理、权限控制等功能
- **多数据库支持**：可与PostgreSQL、MySQL等主流数据库集成
- **易于升级**：简化的版本升级流程
- **安全可靠**：遵循最佳安全实践，定期更新以修复漏洞
- **可扩展性**：支持多种插件和扩展，满足不同需求
- **Web界面**：直观的Web管理界面，便于操作

## 3. 使用场景和适用范围

- **个人代码托管**：为个人开发者提供私有的Git仓库服务
- **小型团队协作**：支持团队成员间的代码共享和协作开发
- **企业内部代码管理**：在企业内部部署私有的代码托管平台
- **开发测试环境**：快速搭建用于开发和测试的代码仓库
- **教育和培训**：用于教学环境中的版本控制演示和实践

## 4. 快速开始

### 使用Helm快速部署（Kubernetes环境）

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/gitea
```

> 注意：如需在生产环境使用Gitea，建议尝试[VMware Tanzu Application Catalog](https://bitnami.com/enterprise)，即Bitnami目录的商业版本。

## 5. 详细使用方法

### 5.1 前提条件

- Kubernetes 1.23+
- Helm 3.8.0+
- 底层基础设施支持PV供应

### 5.2 使用Helm安装Chart

使用发布名称`my-release`安装Chart：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/gitea
```

> 注意：需要将占位符`REGISTRY_NAME`和`REPOSITORY_NAME`替换为Helm Chart仓库和存储库的引用。例如，对于Bitnami，需使用`REGISTRY_NAME=registry-1.docker.io`和`REPOSITORY_NAME=bitnamicharts`。

此命令使用默认配置在Kubernetes集群上部署Gitea。可在安装过程中配置的参数详见[参数](#6-配置参数)部分。

> **提示**：使用`helm list`命令列出所有发布

### 5.3 Docker Compose配置示例

以下是一个基本的Docker Compose配置示例：

```yaml
version: '3'

services:
  gitea:
    image: docker.xuanyuan.run/bitnami/gitea:latest
    ports:
      - "3000:3000"
      - "22:22"
    environment:
      - GITEA_ADMIN_USERNAME=admin
      - GITEA_ADMIN_PASSWORD=your_password
      - GITEA_ADMIN_EMAIL=admin@example.com
      - GITEA_DATABASE_TYPE=postgres
      - GITEA_DATABASE_HOST=postgresql
      - GITEA_DATABASE_NAME=gitea
      - GITEA_DATABASE_USER=gitea
      - GITEA_DATABASE_PASSWORD=gitea_password
    volumes:
      - gitea_data:/bitnami/gitea
    depends_on:
      - postgresql

  postgresql:
    image: docker.xuanyuan.run/bitnami/postgresql:14
    environment:
      - POSTGRESQL_USERNAME=gitea
      - POSTGRESQL_PASSWORD=gitea_password
      - POSTGRESQL_DATABASE=gitea
    volumes:
      - postgresql_data:/bitnami/postgresql

volumes:
  gitea_data:
  postgresql_data:
```

### 5.4 Docker Run命令示例

使用PostgreSQL数据库运行Gitea：

```console
# 首先启动PostgreSQL
docker run -d \
  --name postgresql \
  -e POSTGRESQL_USERNAME=gitea \
  -e POSTGRESQL_PASSWORD=gitea_password \
  -e POSTGRESQL_DATABASE=gitea \
  -v postgresql_data:/bitnami/postgresql \
  docker.xuanyuan.run/bitnami/postgresql:14

# 然后启动Gitea
docker run -d \
  --name gitea \
  -p 3000:3000 \
  -p 22:22 \
  --link postgresql:postgresql \
  -e GITEA_ADMIN_USERNAME=admin \
  -e GITEA_ADMIN_PASSWORD=your_password \
  -e GITEA_ADMIN_EMAIL=admin@example.com \
  -e GITEA_DATABASE_TYPE=postgres \
  -e GITEA_DATABASE_HOST=postgresql \
  -e GITEA_DATABASE_NAME=gitea \
  -e GITEA_DATABASE_USER=gitea \
  -e GITEA_DATABASE_PASSWORD=gitea_password \
  -v gitea_data:/bitnami/gitea \
  docker.xuanyuan.run/bitnami/gitea:latest
```

## 6. 配置参数

### 6.1 全局参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `global.imageRegistry` | 全局Docker镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局Docker仓库密钥名称数组 | `[]` |
| `global.defaultStorageClass` | 持久卷的全局默认存储类 | `""` |
| `global.storageClass` | 已弃用：使用global.defaultStorageClass代替 | `""` |
| `global.security.allowInsecureImages` | 允许跳过镜像验证 | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 调整部署的securityContext部分，使其与Openshift restricted-v2 SCC兼容 | `auto` |

### 6.2 通用参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `kubeVersion` | 强制目标Kubernetes版本 | `""` |
| `nameOverride` | 部分覆盖gitea.fullname模板的字符串 | `""` |
| `fullnameOverride` | 完全覆盖gitea.fullname模板的字符串 | `""` |
| `namespaceOverride` | 完全覆盖common.names.namespace的字符串 | `""` |
| `commonAnnotations` | 添加到所有Gitea资源的通用注释 | `{}` |
| `commonLabels` | 添加到所有Gitea资源的通用标签 | `{}` |
| `extraDeploy` | 随发布一起部署的额外对象数组 | `[]` |
| `usePasswordFiles` | 将凭据挂载为文件而不是使用环境变量 | `true` |

### 6.3 Gitea参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `image.registry` | Gitea镜像仓库 | `REGISTRY_NAME` |
| `image.repository` | Gitea镜像名称 | `REPOSITORY_NAME/gitea` |
| `image.digest` | Gitea镜像摘要 | `""` |
| `image.pullPolicy` | Gitea镜像拉取策略 | `IfNotPresent` |
| `image.pullSecrets` | 指定docker-registry密钥名称数组 | `[]` |
| `image.debug` | 指定是否启用调试日志 | `false` |
| `adminUsername` | 应用程序管理员用户名 | `bn_user` |
| `adminPassword` | 应用程序管理员密码 | `""` |
| `adminEmail` | 管理员邮箱 | `user@example.com` |
| `appName` | Gitea应用程序名称 | `example` |
| `runMode` | Gitea运行模式 | `prod` |
| `exposeSSH` | 是否使SSH服务器可访问 | `true` |
| `rootURL` | UI根URL（用于链接生成） | `""` |
| `command` | 覆盖默认容器命令 | `[]` |
| `args` | 覆盖默认容器参数 | `[]` |
| `updateStrategy.type` | 更新策略 | `RollingUpdate` |
| `priorityClassName` | Gitea pods的priorityClassName | `""` |
| `schedulerName` | k8s调度器名称（非默认） | `""` |
| `topologySpreadConstraints` | 用于pod分配的拓扑扩展约束 | `[]` |
| `automountServiceAccountToken` | 在pod中挂载服务账户令牌 | `false` |
| `hostAliases` | 添加部署主机别名 | `[]` |
| `extraEnvVars` | 额外环境变量 | `[]` |
| `extraEnvVarsCM` | 包含额外环境变量的ConfigMap | `""` |
| `extraEnvVarsSecret` | 包含额外环境变量的Secret | `""` |
| `extraVolumes` | 要添加到部署的额外卷数组 | `[]` |
| `extraVolumeMounts` | 要添加到容器的额外卷挂载数组 | `[]` |
| `initContainers` | 添加到pod的额外初始化容器 | `[]` |
| `pdb.create` | 启用/禁用PodDisruptionBudget创建 | `true` |
| `pdb.minAvailable` | 应保持调度的最小pod数量/百分比 | `""` |
| `pdb.maxUnavailable` | 可能不可用的最大pod数量/百分比 | `""` |
| `sidecars` | 附加到pod的额外容器 | `[]` |
| `tolerations` | pod分配的容忍度 | `[]` |

## 7. 高级配置

### 7.1 资源请求和限制

Bitnami图表允许为图表部署内的所有容器设置资源请求和限制。这些设置位于`resources`值内（参见参数表）。设置请求对于生产工作负载至关重要，应根据具体用例进行调整。

为简化此过程，图表包含`resourcesPreset`值，可根据不同预设自动设置`resources`部分。但在生产工作负载中，不建议使用`resourcesPreset`，因为它可能无法完全适应您的特定需求。

### 7.2 持久化存储

Bitnami Gitea镜像将Gitea数据和配置存储在容器的`/bitnami/gitea`路径下。

持久卷声明用于跨部署保留数据。这在GCE、AWS和minikube上已测试可行。

#### 使用现有PersistentVolumeClaim

1. 创建PersistentVolume
2. 创建PersistentVolumeClaim
3. 安装图表：

```console
helm install my-release --set persistence.existingClaim=PVC_NAME oci://REGISTRY_NAME/REPOSITORY_NAME/gitea
```

#### 使用主机路径

指定的`hostPath`目录必须已存在（如果不存在，请创建一个）。

安装图表：

```console
helm install my-release --set persistence.hostPath=/PATH/TO/HOST/MOUNT oci://REGISTRY_NAME/REPOSITORY_NAME/gitea
```

由于容器无法控制主机的目录权限，您必须自己设置Gitea文件目录权限。

### 7.3 私有仓库配置

如果将`image`值配置为私有仓库中的镜像，您需要指定镜像拉取密钥：

1. 在命名空间中手动创建镜像拉取密钥
2. 使用values.yaml文件提供这些密钥：

```yaml
imagePullSecrets:
  - name: SECRET_NAME
```

3. 安装图表

### 7.4 更新凭据

Bitnami图表在首次启动时配置凭据。后续对密钥或凭据的任何更改都需要手动干预：

- 按照[上游文档](https://docs.gitea.com/administration/command-line#admin)更新用户密码
- 使用新值更新密码密钥：

```shell
kubectl create secret generic SECRET_NAME --from-literal=admin-password=PASSWORD --from-literal=smtp-password=SMTP_PASSWORD --dry-run -o yaml | kubectl apply -f -
```

### 7.5 设置Pod亲和性

此图表允许使用`affinity`参数设置自定义亲和性。作为替代方案，您可以使用bitnami/common图表中提供的预设配置。

### 7.6 备份和恢复

要在Kubernetes上备份和恢复Helm图表部署，您需要备份源部署的持久卷，并使用Velero（Kubernetes备份/恢复工具）将它们附加到新部署。

## 8. 重要注意事项：Bitnami目录即将发生的变化

自2025年8月28日起，Bitnami将改进其公共目录，在新的[Bitnami Secure Images计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)下提供精选的强化、安全聚焦的镜像。作为此过渡的一部分：

- 首次向社区用户提供流行容器镜像的安全优化版本
- Bitnami将开始在其免费层级中弃用对非强化、基于Debian的软件镜像的支持，并将逐步从公共目录中删除非最新标签
- 从8月28日开始，在两周内，所有现有容器镜像，包括旧版本或版本化标签（例如2.50.0、10.6），将从公共目录（docker.io/bitnami）迁移到"Bitnami Legacy"仓库（docker.io/bitnamilegacy），在那里它们将不再接收更新
- 对于生产工作负载和长期支持，建议用户采用Bitnami Secure Images，其中包括强化容器、更小的攻击面、CVE透明度等

完整README可在https://github.com/bitnami/charts/blob/main/bitnami/gitea/README.md找到。
