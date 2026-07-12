---
image: bitnamicharts/airflow
description: "Bitnami提供的Apache Airflow Helm chart，用于在Kubernetes环境中便捷部署和管理工作流编排平台。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/airflow
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/airflow
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/airflow" title="bitnamicharts/airflow Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/airflow 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Apache Airflow Helm Chart

## 镜像概述和主要用途

Apache Airflow 是一个用于以有向无环图（DAGs）形式表达和执行工作流的工具，包含任务调度、进度监控和依赖管理等功能。Bitnami 提供的该 Helm Chart 用于在 Kubernetes 集群上快速部署和配置 Apache Airflow，简化其在容器化环境中的管理流程。

[Apache Airflow 官方概述](https://airflow.apache.org/)

**商标说明**：本软件包由 Bitnami 打包，提及的商标分属各自公司所有，使用不意味着关联或背书。


## 核心功能和特性

- **多执行器支持**：兼容 CeleryExecutor、KubernetesExecutor、LocalExecutor 等多种执行器，适应不同规模的工作负载
- **灵活的 DAG 加载**：支持通过现有 ConfigMap 或 Git 仓库（含自动同步）加载自定义 DAG 文件
- **插件扩展**：可从 Git 仓库加载插件，并通过 sidecar 容器定期更新
- **安全配置**：支持 TLS 加密（Ingress 或直接配置 Webserver）、密钥管理（现有 Secret 集成）
- **监控集成**：可与 Prometheus 联动，通过 StatsD 导出指标，支持 ServiceMonitor 配置
- **资源管理**：支持设置资源请求与限制，提供资源预设（resourcesPreset）简化配置
- **自动数据库初始化**：通过 Helm Hook 自动执行数据库迁移和管理员用户创建
- **高可用性**：支持 worker pod 自动扩缩容（KubernetesExecutor 原生支持，其他执行器需配置 HPA）


## 使用场景和适用范围

- **开发环境**：快速搭建 Airflow 实例，用于工作流开发和测试
- **生产环境**：通过配置硬化镜像（Bitnami Secure Images）、资源限制和持久化存储，支持生产级工作流调度
- **大规模任务处理**：结合 KubernetesExecutor 或 CeleryExecutor，处理高并发任务队列
- **CI/CD 集成**：作为数据处理、ETL 流程的调度核心，与 CI/CD 管道联动
- **多团队协作**：通过 Git 同步 DAGs 和插件，支持多团队共享 Airflow 实例


## 前提条件

- Kubernetes 集群版本 1.23+
- Helm 版本 3.8.0+
- 底层基础设施支持 PV 动态供应（Persistent Volume Provisioner）


## 详细使用方法和配置说明

### 快速部署（TL;DR）

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/airflow
```

> 生产环境建议使用 [VMware Tanzu Application Catalog](https://bitnami.com/enterprise)（Bitnami 商业版目录）。


### 重要通知：Bitnami 镜像目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共镜像目录，推出 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)，重点提供安全硬化的容器镜像。过渡期间注意：

- **社区用户首次可访问安全优化镜像**：提供经过安全加固、攻击面更小的容器镜像
- **非硬化镜像逐步弃用**：免费 tier 将逐步停止支持基于 Debian 的非硬化镜像，仅保留最新（latest）标签用于开发
- **旧镜像迁移**：所有现有容器镜像（含历史版本标签，如 2.50.0、10.6）将在两周内迁移至 `docker.io/bitnamilegacy` 仓库，不再更新
- **生产环境建议**：生产工作负载需采用 Bitnami Secure Images，包含硬化容器、CVE 透明度（VEX/KEV）、SBOM 和企业支持

详细信息见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


### 安装 Chart

使用发布名称 `my-release` 安装：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/airflow
```

> 需替换占位符：`REGISTRY_NAME` 为 Helm 镜像仓库（如 `registry-1.docker.io`），`REPOSITORY_NAME` 为仓库名称（如 `bitnamicharts`）。


### 执行器配置

Airflow 支持多种执行器，通过 `executor` 参数指定：

#### CeleryExecutor（默认）
基于 Redis 消息队列协调 worker 节点，适用于分布式任务处理：
```console
executor=CeleryExecutor  # 默认启用，无需额外配置
```

#### KubernetesExecutor
为每个任务动态创建 worker pod，无需预置 worker：
```console
executor=KubernetesExecutor
rbac.create=true
serviceAccount.create=true
redis.enabled=false  # 无需 Redis，可禁用
```
> 任务 pod 模板通过 `worker.podTemplate` 自定义。

#### LocalExecutor
在 Scheduler pod 内通过进程池执行任务：
```console
executor=LocalExecutor
redis.enabled=false
```

#### 其他执行器
- **CeleryKubernetesExecutor**：混合模式，默认使用 Celery，指定队列任务使用 Kubernetes（Airflow 3.0.0 起已弃用）
- **LocalKubernetesExecutor**：混合模式，默认使用 Local，指定队列任务使用 Kubernetes（Airflow 3.0.0 起已弃用）
- **SequentialExecutor**：单任务串行执行，仅用于开发（Airflow 3.0.0 起已弃用）


### 更新凭证

Bitnami Chart 在首次启动时配置凭证，后续更新需手动操作：

1. 按 [上游文档](https://airflow.apache.org/docs/apache-airflow-providers-fab/stable/cli-ref.html#reset-password) 更新用户密码
2. 更新 Secret 中的凭证（替换占位符）：
```shell
kubectl create secret generic SECRET_NAME \
  --from-literal=airflow-password=PASSWORD \
  --from-literal=airflow-fernet-key=FERNET_KEY \
  --from-literal=airflow-secret-key=SECRET_KEY \
  --from-literal=airflow-jwt-secret-key=JWT_SECRET_KEY \
  --dry-run -o yaml | kubectl apply -f -
```


### Airflow 配置文件

#### 自动生成配置
默认根据 Chart 参数自动生成 `airflow.cfg`，例如 `executor` 参数对应 `[core]` 部分的 `executor` 配置。

#### 自定义配置
通过 `configuration` 参数提供完整配置（YAML 格式）：
```yaml
configuration:
  core:
    dags_folder: "/opt/bitnami/airflow/dags"
    load_examples: "False"
  webserver:
    expose_config: "True"
```
将被转换为：
```ini
[core]
dags_folder = "/opt/bitnami/airflow/dags"
load_examples = "False"

[webserver]
expose_config = "True"
```

#### 扩展默认配置
通过 `overrideConfiguration` 参数覆盖默认配置，优先级高于 `configuration`：
```yaml
overrideConfiguration:
  core:
    parallelism: 32
```


### 加载 DAG 文件

支持以下两种方式（可同时使用）：

#### 方式 1：使用现有 ConfigMap
1. 手动创建包含 DAG 文件的 ConfigMap
2. 部署时指定：
```console
dags.enabled=true
dags.existingConfigmap=my-dags-configmap
```

#### 方式 2：从 Git 仓库同步
通过 initContainer 克隆仓库，sidecar 容器定期更新：
```console
dags.enabled=true
dags.repositories[0].repository=https://github.com/USERNAME/REPOSITORY  # Git 仓库地址
dags.repositories[0].name=REPO-IDENTIFIER  # 仓库标识（唯一）
dags.repositories[0].branch=main  # 分支
```
- **私有仓库**：支持 HTTPS（嵌入 Personal Access Token：`https://USERNAME:TOKEN@repo`）或 SSH（通过 `dags.sshKey` 或 `dags.existingSshKeySecret` 配置密钥）


### 加载插件

从 Git 仓库加载插件，配置方式类似 DAG：
```console
plugins.enabled=true
plugins.repositories[0].repository=https://github.com/teamclairvoyant/airflow-rest-api-plugin.git
plugins.repositories[0].branch=v1.0.9-branch
plugins.repositories[0].path=plugins  # 插件在仓库中的路径
```


### 安装额外 Python 包

通过 `extraVolumes` 和 `extraVolumeMounts` 挂载 `requirements.txt` 至 `/bitnami/python/requirements.txt`，容器启动时自动执行 `pip install -r`：
```yaml
extraVolumes:
  - name: requirements-volume
    configMap:
      name: airflow-requirements
extraVolumeMounts:
  - name: requirements-volume
    mountPath: /bitnami/python/requirements.txt
    subPath: requirements.txt
```


### 外部数据库和缓存配置

#### 使用外部 PostgreSQL
```console
postgresql.enabled=false  # 禁用内置 PostgreSQL
externalDatabase.host=my.external.postgres.host  # 外部数据库地址
externalDatabase.user=bn_airflow  # 用户名
externalDatabase.database=bitnami_airflow  # 数据库名
externalDatabase.existingSecret=all-my-secrets  # 存储密码的 Secret 名称
externalDatabase.existingSecretPasswordKey=postgresql-password  # Secret 中密码的 Key
```

#### 使用外部 Redis（仅 CeleryExecutor）
```console
redis.enabled=false  # 禁用内置 Redis
externalRedis.host=my.external.redis.host  # 外部 Redis 地址
externalRedis.existingSecret=all-my-secrets  # 存储密码的 Secret 名称
externalRedis.existingSecretPasswordKey=redis-password  # Secret 中密码的 Key
```

#### 现有 Secret 示例
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: all-my-secrets
type: Opaque
data:
  airflow-password: "Smo1QTJLdGxXMg=="  # base64 编码的密码
  airflow-fernet-key: "YVRZeVJVWnlXbU4wY1dOalVrdE1SV3cxWWtKeFIzWkVRVTVrVjNaTFR6WT0="
  postgresql-password: "cG9zdGdyZXMK"
  redis-password: "cmVkaXMK"
```


### 监控集成（Prometheus）

#### 基本配置
启用 StatsD 指标导出和 Prometheus 集成：
```console
metrics.enabled=true
```
Chart 会部署 StatsD Exporter，将指标转换为 Prometheus 格式。

#### Prometheus Operator 集成
部署 ServiceMonitor 资源：
```console
metrics.serviceMonitor.enabled=true
```
> 需确保集群已安装 Prometheus Operator CRD（可通过 [Bitnami Kube Prometheus Chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) 安装）。


### 安全配置

#### Ingress TLS
通过 Ingress 控制器管理 TLS：
```console
ingress.enabled=true
ingress.tls=true
ingress.hostname=airflow.example.com
ingress.tlsSecret=airflow-tls-secret  # 包含 tls.crt 和 tls.key 的 Secret
```

#### Webserver 直接 TLS
配置 Webserver 自身启用 TLS：
```console
web.tls.enabled=true
web.tls.existingSecret=web-tls-secret  # 现有 TLS Secret
```
- **自动生成证书**：支持 Helm 生成（`web.tls.autoGenerated.engine=helm`）或 CertManager（`engine=cert-manager`，需集群安装 CertManager）


### 资源配置

#### 手动设置资源请求与限制
```yaml
web:
  resources:
    requests:
      cpu: 200m
      memory: 256Mi
    limits:
      cpu: 1000m
      memory: 1Gi
scheduler:
  resources:
    requests:
      cpu: 300m
      memory: 512Mi
worker:
  resources:
    requests:
      cpu: 500m
      memory: 1Gi
```

#### 使用资源预设
通过 `resourcesPreset` 快速应用预定义配置（如 `small`、`medium`，定义见 [bitnami/common](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15)）：
```console
web.resourcesPreset=medium
scheduler.resourcesPreset=medium
worker.resourcesPreset=large
```


## 持久化

Airflow 自身无持久化存储需求，依赖 PostgreSQL 存储元数据（由 PostgreSQL Chart 管理持久化）。


## 参数说明

### 全局参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局镜像拉取密钥列表 | `[]` |
| `global.defaultStorageClass` | 持久化存储的默认 StorageClass | `""` |

> **完整参数列表**：由于长度限制，完整参数请参考 [Bitnami Airflow Chart 文档](https://github.com/bitnami/charts/blob/main/bitnami/airflow/README.md)。


## 备份与恢复

使用 [Velero](https://velero.io/) 备份和恢复 Kubernetes 集群中的持久化卷及部署配置，具体步骤见 [Bitnami 备份指南](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html)。
