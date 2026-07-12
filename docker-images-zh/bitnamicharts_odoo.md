---
image: bitnamicharts/odoo
description: "Bitnami提供的Helm Chart，用于在Kubernetes环境中简化Odoo（开源ERP/CRM软件）的部署与管理。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/odoo
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/odoo
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/odoo" title="bitnamicharts/odoo Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/odoo 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Odoo 镜像文档

## 镜像概述和主要用途

Odoo 是一个开源 ERP（企业资源规划）和 CRM（客户关系管理）平台，前身为 OpenERP，可整合销售、供应链、财务、项目管理等多种业务流程。Bitnami Odoo 镜像是由 Bitnami 打包的容器化版本，旨在简化 Odoo 在 Kubernetes 集群中的部署与管理，通过 Helm 包管理器提供快速配置和扩展能力。

[Odoo 官方概述](https://www.odoo.com/)

**商标说明**：本软件列表由 Bitnami 打包，所提及的商标分属各自公司所有，使用不代表任何关联或背书。

## 核心功能和特性

- **全功能集成**：支持作为独立应用或集成套件运行，形成完整 ERP 系统
- **容器化优化**：遵循 Bitnami 安全最佳实践，包含精简配置和最小化攻击面
- **灵活部署**：通过 Helm chart 实现 Kubernetes 环境自动化部署与扩展
- **配置定制**：丰富的参数选项，支持数据库连接、资源分配、安全策略等定制
- **数据持久化**：支持 Persistent Volume Claims (PVC)，确保数据跨部署持久化
- **外部服务集成**：兼容外部数据库（如托管数据库服务）和 SMTP 邮件服务
- **扩展能力**：支持 Sidecar 容器、Init Containers 和自定义初始化脚本

## 使用场景和适用范围

### 适用场景
- 中小企业的企业资源规划（ERP）系统部署
- 销售团队的客户关系管理（CRM）流程管理
- 项目管理与团队协作平台搭建
- 财务会计与供应链流程自动化
- 多业务模块整合的企业级应用

### 适用范围
- 需要在 Kubernetes 环境中部署 ERP/CRM 系统的组织
- 寻求开源、可扩展且易于维护的业务管理解决方案的用户
- 开发/测试环境快速搭建 Odoo 实例
- 生产环境中需要稳定运行并具备长期支持的企业应用

## ⚠️ 重要通知：Bitnami 镜像目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共镜像目录，推出 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)，提供精选的强化安全镜像。过渡要点包括：

- 首次向社区用户开放安全优化版本容器镜像
- 逐步弃用免费层中非强化的 Debian 基础镜像，仅保留"latest"标签的强化镜像（用于开发目的）
- 现有镜像（含历史版本标签）将在两周内迁移至 `docker.io/bitnamilegacy` 仓库，不再接收更新
- 生产环境建议采用 Bitnami Secure Images，提供强化容器、CVE 透明度和企业级支持

详细信息参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。

## 前提条件

- Kubernetes 集群版本 1.23+
- Helm 版本 3.8.0+
- 底层基础设施支持 PV 供应器
- 支持 ReadWriteMany 卷（用于部署扩展）

## 部署方法

### Helm 部署（Kubernetes）

#### 快速安装

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/odoo
```

#### 自定义安装

指定仓库和参数安装：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/odoo \
  --set odooEmail=admin@example.com \
  --set odooPassword=StrongPassword \
  --set postgresql.enabled=false \
  --set externalDatabase.host=db-host
```

> 替换 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 为实际仓库地址（Bitnami 官方仓库使用 `registry-1.docker.io` 和 `bitnamicharts`）

### Docker 部署（单机）

#### 基本运行命令

```bash
docker run -d --name odoo \
  -p 8069:8069 \
  -e POSTGRESQL_HOST=postgresql \
  -e POSTGRESQL_USER=odoo \
  -e POSTGRESQL_PASSWORD=odoo_password \
  -e POSTGRESQL_DATABASE=odoo \
  -e ODOO_EMAIL=admin@example.com \
  -e ODOO_PASSWORD=admin_password \
  docker.xuanyuan.run/bitnami/odoo:latest
```

#### Docker Compose 配置

```yaml
version: '3'

services:
  postgresql:
    image: docker.xuanyuan.run/bitnami/postgresql:latest
    environment:
      - POSTGRESQL_USER=odoo
      - POSTGRESQL_PASSWORD=odoo_password
      - POSTGRESQL_DATABASE=odoo
    volumes:
      - postgresql_data:/bitnami/postgresql

  odoo:
    image: docker.xuanyuan.run/bitnami/odoo:latest
    ports:
      - "8069:8069"
    environment:
      - POSTGRESQL_HOST=postgresql
      - POSTGRESQL_USER=odoo
      - POSTGRESQL_PASSWORD=odoo_password
      - POSTGRESQL_DATABASE=odoo
      - ODOO_EMAIL=admin@example.com
      - ODOO_PASSWORD=admin_password
    depends_on:
      - postgresql
    volumes:
      - odoo_data:/bitnami/odoo

volumes:
  postgresql_data:
  odoo_data:
```

启动服务：`docker-compose up -d`

## 配置说明

### 资源配置

生产环境必须设置资源请求和限制：

```yaml
resources:
  requests:
    cpu: 500m
    memory: 512Mi
  limits:
    cpu: 1000m
    memory: 1Gi
```

或使用预设配置：`resourcesPreset: medium`（支持 none/nano/micro/small/medium/large/xlarge/2xlarge）

### 使用外部数据库

禁用内置 PostgreSQL 并配置外部数据库：

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/odoo \
  --set postgresql.enabled=false \
  --set externalDatabase.host=db.example.com \
  --set externalDatabase.port=5432 \
  --set externalDatabase.user=odoo_user \
  --set externalDatabase.password=odoo_pass \
  --set externalDatabase.database=odoo_db
```

### 安全上下文配置

可自定义 Pod 和容器安全上下文：

```yaml
podSecurityContext:
  enabled: true
  fsGroup: 1001
  supplementalGroups: [1001]

containerSecurityContext:
  enabled: true
  runAsUser: 1001
  runAsGroup: 1001
  readOnlyRootFilesystem: true
```

### 环境变量配置

通过 `extraEnvVars` 添加自定义环境变量：

```yaml
extraEnvVars:
  - name: ODOO_LOG_LEVEL
    value: "info"
  - name: ODOO_CACHE_SIZE
    value: "2048"
```

或通过现有 ConfigMap/Secret 注入：

```yaml
extraEnvVarsCM: "odoo-env-cm"
extraEnvVarsSecret: "odoo-env-secret"
```

### 参数参考表

#### 全局参数

| 名称 | 描述 | 默认值 |
|------|------|--------|
| `global.imageRegistry` | 全局镜像仓库地址 | `""` |
| `global.imagePullSecrets` | 镜像拉取密钥数组 | `[]` |
| `global.defaultStorageClass` | 默认存储类 | `""` |
| `global.security.allowInsecureImages` | 允许不安全镜像 | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | OpenShift 安全上下文适配 | `disabled` |

#### 通用参数

| 名称 | 描述 | 默认值 |
|------|------|--------|
| `nameOverride` | 名称覆盖字符串 | `""` |
| `fullnameOverride` | 完整名称覆盖字符串 | `""` |
| `commonLabels` | 通用标签 | `{}` |
| `clusterDomain` | 集群域名 | `cluster.local` |
| `image.registry` | 镜像仓库 | `REGISTRY_NAME` |
| `image.repository` | 镜像路径 | `REPOSITORY_NAME/odoo` |
| `image.tag` | 镜像标签 | `latest` |
| `image.pullPolicy` | 拉取策略 | `IfNotPresent` |
| `image.debug` | 调试模式 | `false` |

#### Odoo 配置参数

| 名称 | 描述 | 默认值 |
|------|------|--------|
| `odooEmail` | 管理员邮箱 | `user@example.com` |
| `odooPassword` | 管理员密码 | `""` |
| `odooSkipInstall` | 跳过安装向导 | `false` |
| `odooDatabaseFilter` | 数据库过滤正则 | `.*` |
| `loadDemoData` | 加载演示数据 | `false` |
| `smtpHost` | SMTP 主机 | `""` |
| `smtpPort` | SMTP 端口 | `""` |
| `smtpUser` | SMTP 用户名 | `""` |
| `smtpPassword` | SMTP 密码 | `""` |
| `smtpProtocol` | SMTP 协议 | `""` |
| `existingSecret` | 现有凭证密钥 | `""` |

#### 部署参数

| 名称 | 描述 | 默认值 |
|------|------|--------|
| `replicaCount` | 副本数 | `1` |
| `containerPorts.http` | HTTP 端口 | `8069` |
| `resourcesPreset` | 资源预设 | `large` |
| `resources` | 资源配置 | `{}` |
| `podSecurityContext.enabled` | 启用 Pod 安全上下文 | `true` |
| `podSecurityContext.fsGroup` | 文件系统组 | `0` |
| `containerSecurityContext.enabled` | 启用容器安全上下文 | `true` |
| `containerSecurityContext.runAsUser` | 运行用户 ID | `0` |

> 完整参数列表参见 [Bitnami Odoo Chart 文档](https://github.com/bitnami/charts/blob/main/bitnami/odoo/README.md)

## 持久化存储

Odoo 数据存储路径：`/bitnami/odoo`

持久化配置参数：

| 名称 | 描述 | 默认值 |
|------|------|--------|
| `persistence.enabled` | 启用持久化 | `true` |
| `persistence.storageClass` | 存储类 | `""` |
| `persistence.accessModes` | 访问模式 | `["ReadWriteOnce"]` |
| `persistence.size` | 存储大小 | `8Gi` |
| `persistence.path` | 挂载路径 | `/bitnami/odoo` |

## 备份与恢复

使用 Velero 进行 Kubernetes 环境备份：

1. 安装 Velero 客户端和服务端
2. 创建备份：
   ```bash
   velero backup create odoo-backup --include-resources pvc,pv --selector app.kubernetes.io/instance=my-release
   ```
3. 恢复备份：
   ```bash
   velero restore create --from-backup odoo-backup
   ```

详细步骤参见 [Bitnami 备份恢复指南](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html)

## 更新与维护

### 升级 Helm Chart

```console
helm upgrade my-release oci://registry-1.docker.io/bitnamicharts/odoo
```

### 版本迁移

1. 备份现有数据
2. 使用新镜像标签部署：
   ```console
   helm upgrade my-release oci://registry-1.docker.io/bitnamicharts/odoo --set image.tag=16.0.0
   ```
3. 执行数据库迁移（如需要）

### 凭证更新

```bash
# 创建新密钥
kubectl create secret generic odoo-secret \
  --from-literal=odoo-password=new_password \
  --from-literal=smtp-password=new_smtp_password \
  --dry-run=client -o yaml | kubectl apply -f -

# 重启部署
kubectl rollout restart deployment my-release-odoo
