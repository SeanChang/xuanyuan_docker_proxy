---
image: apache/skywalking-helm
description: "Apache Skywalking Helm镜像提供Skywalking分布式追踪与可观测性平台的Helm Chart，用于在Kubernetes集群中简化其部署、配置管理及版本控制，提升分布式系统监控平台的部署效率与运维便捷性。"
source: https://xuanyuan.cloud/zh/r/apache/skywalking-helm
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[apache/skywalking-helm](https://xuanyuan.cloud/zh/r/apache/skywalking-helm)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Apache SkyWalking Kubernetes Helm Chart 文档

![Sky Walking logo](https://skywalking.apache.org/assets/logo.svg)

[![GitHub stars](https://img.shields.io/github/stars/apache/skywalking.svg?style=for-the-badge&label=Stars&logo=github)](https://github.com/apache/skywalking)
[![Twitter Follow](https://img.shields.io/twitter/follow/asfskywalking.svg?style=for-the-badge&label=Follow&logo=twitter)](https://twitter.com/AsfSkyWalking)


## 1. 镜像概述和主要用途

Apache SkyWalking Kubernetes 仓库提供在 Kubernetes 集群中安装和配置 Apache SkyWalking 的方法，所有部署脚本基于 Helm 3 编写。该仓库的核心目标是简化 SkyWalking 在 Kubernetes 环境中的部署流程，实现可观测性分析平台（OAP）、用户界面（UI）及相关组件的自动化部署与配置管理。


## 2. 核心功能和特性

- **Helm 3 管理**：采用 Helm 3 作为部署工具，支持版本控制、配置管理和生命周期管理
- **多存储类型支持**：兼容 Elasticsearch、PostgreSQL、BanyanDB 等多种存储后端
- **组件版本控制**：可灵活配置 OAP 和 UI 组件的镜像版本
- **自定义配置**：支持覆盖 OAP 或 Satellite 的配置文件，传递环境变量
- **Satellite 集成**：支持部署 Satellite 作为数据收集网关，优化 agent 数据上报
- **现有数据库集成**：支持对接已有的外部数据库（如 Elasticsearch、PostgreSQL），无需重新部署
- **SWCK 组件支持**：提供 SWCK Adapter 和 Operator 的 Helm 部署方案


## 3. 使用场景和适用范围

### 适用场景
- 在 Kubernetes 集群中部署 SkyWalking 实现分布式追踪、性能监控和服务健康管理
- 微服务架构或云原生应用的全链路可观测性建设
- 服务网格（如 Istio）环境下的流量监控与分析
- 需要自定义存储后端或集成现有数据库的 SkyWalking 部署需求

### 适用范围
- Kubernetes 集群环境（支持标准 K8s 部署流程）
- 开发、测试及生产环境的 SkyWalking 部署
- Apache SkyWalking 版本 >= 6.0.0-GA 的部署需求


## 4. 配置说明

### 4.1 核心配置参数

#### 4.1.1 必填参数
部署时必须显式设置以下参数：

| 参数名               | 描述                     | 示例值                                  |
|----------------------|--------------------------|----------------------------------------|
| `oap.image.tag`      | OAP 镜像版本标签         | `10.0.0`                               |
| `oap.storageType`    | OAP 存储类型             | `elasticsearch`、`postgresql`、`banyandb` 等 |
| `ui.image.tag`       | UI 镜像版本标签          | `10.0.0`                               |

#### 4.1.2 参数设置方式
可通过以下方式设置参数：
- 命令行参数：`--set oap.image.tag=10.0.0 --set oap.storageType=elasticsearch`
- 配置文件：编辑 `values.yaml` 或自定义文件（如 `values-my-es.yaml`），通过 `-f <filename>` 或 `--values=<filename>` 指定


### 4.2 可选配置

#### 4.2.1 数据库连接配置
对接现有数据库时，需在配置文件中设置以下参数（以 Elasticsearch 为例）：

```yaml
elasticsearch:
  enabled: false  # 禁用内置 Elasticsearch
  config:         # 外部 Elasticsearch 配置
    port:
      http: 9200
    host: elasticsearch  # K8s 服务名或外部主机地址
    user: "admin"        # [可选] 认证用户名
    password: "password" # [可选] 认证密码
```

PostgreSQL、BanyanDB 等其他存储类型配置方式类似。


#### 4.2.2 环境变量配置
OAP 支持通过环境变量配置，可通过 `--set oap.env.<ENV_NAME>=<ENV_VALUE>` 设置，例如：

```shell
--set oap.env.SW_ENVOY_METRIC_ALS_HTTP_ANALYSIS=k8s-mesh
```

环境变量优先级高于配置文件覆盖项，详细环境变量列表参见 [SkyWalking 官方文档](https://github.com/apache/skywalking/blob/master/docs/en/setup/backend/configuration-vocabulary.md)。


## 5. 安装指南

### 5.1 环境准备
设置环境变量简化后续操作：

```shell
export SKYWALKING_RELEASE_VERSION=4.3.0  # 根据需求修改版本
export SKYWALKING_RELEASE_NAME=skywalking  # 发布名称（按需修改）
export SKYWALKING_RELEASE_NAMESPACE=default  # 部署命名空间（按需修改）
```


### 5.2 安装正式版本

#### 5.2.1 使用 Docker Helm 仓库（>= 4.3.0）
```shell
helm install "${SKYWALKING_RELEASE_NAME}" \
  oci://registry-1.docker.io/apache/skywalking-helm \
  --version "${SKYWALKING_RELEASE_VERSION}" \
  -n "${SKYWALKING_RELEASE_NAMESPACE}" \
  --set oap.image.tag=10.0.0 \
  --set oap.storageType=elasticsearch \
  --set ui.image.tag=10.0.0
```

#### 5.2.2 使用 Apache Jfrog Helm 仓库（<= 4.3.0）
```shell
export REPO=skywalking
helm repo add ${REPO} https://apache.jfrog.io/artifactory/skywalking-helm
helm repo update
helm install "${SKYWALKING_RELEASE_NAME}" ${REPO}/skywalking \
  --version "${SKYWALKING_RELEASE_VERSION}" \
  -n "${SKYWALKING_RELEASE_NAMESPACE}" \
  --set oap.image.tag=10.0.0 \
  --set oap.storageType=elasticsearch \
  --set ui.image.tag=10.0.0
```


### 5.3 安装开发版本（master 分支）

#### 5.3.1 基础开发版本
```shell
export REPO=chart
git clone https://github.com/apache/skywalking-helm
cd skywalking-helm
helm repo add elastic https://helm.elastic.co
helm dep up ${REPO}/skywalking

helm install "${SKYWALKING_RELEASE_NAME}" \
  ${REPO}/skywalking \
  -n "${SKYWALKING_RELEASE_NAMESPACE}" \
  --set oap.image.tag=10.0.0 \
  --set oap.storageType=elasticsearch \
  --set ui.image.tag=10.0.0
```

#### 5.3.2 使用 BanyanDB 作为存储
```shell
export REPO=chart
git clone https://github.com/apache/skywalking-helm
cd skywalking-helm
helm install "${SKYWALKING_RELEASE_NAME}" \
  ${REPO}/skywalking \
  -n "${SKYWALKING_RELEASE_NAMESPACE}" \
  --set oap.image.tag=10.0.0 \
  --set oap.storageType=banyandb \
  --set ui.image.tag=10.0.0 \
  --set elasticsearch.enabled=false \
  --set banyandb.enabled=true
```


### 5.4 安装特定版本 SkyWalking

#### 5.4.1 部署 SkyWalking 10.0.0
```shell
helm install "${SKYWALKING_RELEASE_NAME}" ${REPO}/skywalking \
  -n "${SKYWALKING_RELEASE_NAMESPACE}" \
  --set oap.image.tag=10.0.0 \
  --set oap.storageType=elasticsearch \
  --set ui.image.tag=10.0.0
```

#### 5.4.2 使用现有数据库部署
通过自定义配置文件部署（以 `values-my-es.yaml` 为例）：
```shell
helm install "${SKYWALKING_RELEASE_NAME}" ${REPO}/skywalking \
  -n "${SKYWALKING_RELEASE_NAMESPACE}" \
  -f ./skywalking/values-my-es.yaml
```


### 5.5 安装 SWCK 组件

#### 5.5.1 SWCK Adapter（master 分支）
```shell
export REPO=chart
git clone https://github.com/apache/skywalking-helm
cd skywalking-helm
helm -n skywalking-custom-metrics-system install adapter ${REPO}/adapter --create-namespace
```

#### 5.5.2 SWCK Operator（master 分支）
1. 安装 cert-manager：
```shell
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.yaml
```

2. 安装 Operator：
```shell
export REPO=chart
git clone https://github.com/apache/skywalking-helm
cd skywalking-helm
helm -n skywalking-swck-system install operator ${REPO}/operator
```


### 5.6 安装快照版本（测试用）
使用 ghcr.io 仓库的开发快照版本（需替换 commit hash）：
```shell
helm -n istio-system install skywalking \
  oci://ghcr.io/apache/skywalking-helm/skywalking-helm \
  --version "0.0.0-b670c41d94a82ddefcf466d54bab5c492d88d772" \
  -n "${SKYWALKING_RELEASE_NAMESPACE}" \
  --set oap.image.tag=10.0.0 \
  --set oap.storageType=elasticsearch \
  --set ui.image.tag=10.0.0
```


### 5.7 集成 Satellite
启用 Satellite 作为数据网关：
```shell
helm install "${SKYWALKING_RELEASE_NAME}" ${REPO}/skywalking \
  -n "${SKYWALKING_RELEASE_NAMESPACE}" \
  --set satellite.enabled=true \
  --set satellite.image.tag=v0.4.0
```

部署后，需将 agent 或 Istio 的数据上报地址从 OAP 替换为 Satellite 地址（如 `skywalking-satellite.istio-system:11800`）。


## 6. 自定义配置

### 6.1 覆盖配置文件
通过 `oap.config` 和 `satellite.config` 字段覆盖 OAP 或 Satellite 的配置文件，示例：
```yaml
oap:
  config:
    application.yml: |
      sw:
        storage:
          elasticsearch:
            nameSpace: skywalking-es  # 自定义 ES 命名空间
satellite:
  config:
    satellite.yml: |
      receiver:
        gRPC:
          port: 11800  # 自定义 gRPC 接收端口
```


### 6.2 传递环境变量给 OAP
通过 `--set oap.env.<ENV_NAME>=<ENV_VALUE>` 设置 OAP 环境变量，例如：
```shell
--set oap.env.SW_ENVOY_METRIC_ALS_HTTP_ANALYSIS=k8s-mesh
```

> 环境变量优先级高于覆盖的配置文件。


## 7. 重新运行 OAP 初始化 Job

Kubernetes Job 默认不可重运行，如需重新执行 OAP 初始化 Job，需删除现有 Job 并重新创建：

```shell
# 导出 Job 清单
kubectl get job -n "${SKYWALKING_RELEASE_NAMESPACE}" -l release=$SKYWALKING_RELEASE_NAME -o yaml > oap-init.job.yaml

# 清理不需要的字段（可使用 yq 工具或手动编辑）
yq 'del(.items[0].metadata.creationTimestamp,.items[0].metadata.resourceVersion,.items[0].metadata.uid,.items[0].status,.items[0].spec.template.metadata.labels."batch.kubernetes.io/controller-uid",.items[0].spec.template.metadata.labels."controller-uid",.items[0].spec.selector.matchLabels."batch.kubernetes.io/controller-uid")' oap-init.job.yaml > oap-init.job.trimmed.yaml

# 检查清理后的清单
cat oap-init.job.trimmed.yaml

# 删除原 Job 并创建新 Job
kubectl delete job -n "${SKYWALKING_RELEASE_NAMESPACE}" -l release=$SKYWALKING_RELEASE_NAME
kubectl -n "${SKYWALKING_RELEASE_NAMESPACE}" apply -f oap-init.job.trimmed.yaml
```


## 8. 联系方式与许可

### 8.1 联系方式
- 提交 [issue](https://github.com/apache/skywalking/issues)
- 邮件列表：**dev@skywalking.apache.org**（发送邮件至 `dev-subscribe@skywalking.apache.org` 订阅）
- Slack：发送邮件至 `dev@skywalking.apache.org` 请求加入（中文用户请在邮件主题注明 `[CN] Request to join SkyWalking slack`）
- Twitter：[@AsfSkyWalking](https://twitter.com/AsfSkyWalking)
- B站视频：[Apache SkyWalking 官方账号](https://space.bilibili.com/390683219)


### 8.2 许可协议
本项目采用 [Apache 2.0 许可协议](https://www.apache.org/licenses/LICENSE-2.0)。
