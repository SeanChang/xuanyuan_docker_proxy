---
image: victoriametrics/operator
description: "用于在Kubernetes环境中自动化部署、管理和运维Victoria Metrics时序数据库的Operator控制器"
source: https://xuanyuan.cloud/zh/r/victoriametrics/operator
canonical: https://xuanyuan.cloud/zh/r/victoriametrics/operator
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/victoriametrics/operator" title="victoriametrics/operator Docker 镜像中文简介、标签列表与拉取命令">victoriametrics/operator — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/victoriametrics/operator" title="victoriametrics/operator Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/victoriametrics/operator</a>

# VictoriaMetrics Operator 中文技术文档


<p align="center">
  <img src="https://victoriametrics.com/icons/apple-touch-icon.webp" width="150" alt="VictoriaMetrics logo"/>
</p>

## 概述与主要用途

VictoriaMetrics Operator 是一款 Kubernetes Operator，用于简化在 Kubernetes 集群上部署、扩缩容和管理完整的 VictoriaMetrics 监控栈。它通过引入自定义资源定义（CRDs）（如 `VMCluster`、`VMAgent`、`VMAlert` 等），允许用户通过简单的声明式 YAML 清单管理复杂的 VictoriaMetrics 部署，实现监控栈的自动化运维。


## 核心功能与特性

### 1. 基于 Kubernetes CRD 的声明式管理
引入多种自定义资源（CR），如 `VMSingle`（单节点部署）、`VMCluster`（集群部署）、`VMAgent`（数据采集）、`VMAlert`（告警规则）等，支持通过 YAML 清单定义监控栈组件，简化配置流程。

### 2. 自动化部署与扩缩容
自动处理 VictoriaMetrics 各组件的部署、升级和扩缩容，减少手动操作成本，确保监控栈稳定运行。

### 3. 全栈监控管理
支持管理完整的 VictoriaMetrics 监控栈，包括数据采集（VMAgent）、存储（VMStorage）、查询（VMSelect）、告警（VMAlert）等组件，实现一站式监控解决方案。

### 4. 简化复杂配置
通过 CRD 抽象复杂的部署细节，用户无需手动管理 StatefulSet、Service 等底层 Kubernetes 资源，降低运维门槛。


## 使用场景与适用范围

### 适用场景
- 在 Kubernetes 集群中部署和管理 VictoriaMetrics 监控栈。
- 需要通过声明式配置实现监控系统自动化运维。
- 构建大规模、高可用的监控平台，需支持数据分片、副本管理等高级特性。

### 适用人群/团队
- DevOps 团队：简化监控栈部署与维护流程。
- SRE（站点可靠性工程师）：实现监控系统的自动化扩缩容与故障恢复。
- 平台团队：为内部用户提供标准化的监控服务。


## 使用方法

VictoriaMetrics Operator 作为 Kubernetes Operator，通常不通过 `docker run` 直接运行，而是部署在 Kubernetes 集群中，通过 Helm 实现自动化部署。


### 前置条件
- Kubernetes 集群（v1.21+）。
- Helm 3.5+。


### 通过 Helm 部署 Operator

#### 1. 添加 VictoriaMetrics Helm 仓库
```bash
helm repo add vm https://victoriametrics.github.io/helm-charts/
helm repo update
```

#### 2. 安装 Operator
创建命名空间并安装 Operator：
```bash
helm install vmoperator vm/victoria-metrics-operator -n victoria-metrics --create-namespace
```

#### 3. 验证部署
检查 Operator Pod 状态：
```bash
kubectl get pods -n victoria-metrics
```
预期输出类似：
```
NAME                           READY   STATUS    RESTARTS   AGE
vmoperator-7f9b6c7f9c-abcde   1/1     Running   0          5m
```


### 创建 VictoriaMetrics 资源

部署 Operator 后，可通过 CRD 创建 VictoriaMetrics 组件，例如单节点部署（`VMSingle`）：

#### 示例：创建 VMSingle 资源
创建 `vmsingle.yaml` 文件：
```yaml
apiVersion: operator.victoriametrics.com/v1beta1
kind: VMSingle
metadata:
  name: example-vmsingle
  namespace: victoria-metrics
spec:
  retentionPeriod: "15d"  # 数据保留期
  storage:
    volumeClaimTemplate:
      spec:
        resources:
          requests:
            storage: 10Gi  # 请求存储容量
        accessModes: ["ReadWriteOnce"]
  resources:
    requests:
      cpu: 1
      memory: 2Gi
    limits:
      cpu: 2
      memory: 4Gi
```

应用资源：
```bash
kubectl apply -f vmsingle.yaml
```

验证 `VMSingle` 状态：
```bash
kubectl get vmsingle -n victoria-metrics
```


## 配置说明

VictoriaMetrics Operator 的配置分为两部分：**Operator 自身配置**和**所管理组件的配置**。


### Operator 自身配置

Operator 自身通过 Helm `values.yaml` 或部署清单配置，主要包括资源限制、镜像版本、日志级别等。

#### Helm values.yaml 关键配置示例
```yaml
# 资源限制
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi

# 镜像配置
image:
  repository: victoriametrics/operator
  tag: v0.39.0  # 指定 Operator 版本

# 日志级别（debug, info, warn, error）
logLevel: info

# 监控 Operator 自身（启用 Prometheus 指标暴露）
serviceMonitor:
  enabled: true
```

通过 Helm 升级配置：
```bash
helm upgrade vmoperator vm/victoria-metrics-operator -n victoria-metrics -f custom-values.yaml
```


### 管理组件的配置

VictoriaMetrics 组件（如 VMSingle、VMCluster、VMAgent 等）通过各自的 CRD 规范（`spec`）配置，具体参数可参考 [官方 CRD 文档](https://docs.victoriametrics.com/operator/api.html)。

#### 示例：VMCluster 配置（分布式集群）
```yaml
apiVersion: operator.victoriametrics.com/v1beta1
kind: VMCluster
metadata:
  name: example-vmcluster
  namespace: victoria-metrics
spec:
  # 存储组件配置
  storage:
    replicas: 3  # 3 副本确保高可用
    resources:
      requests:
        cpu: 2
        memory: 8Gi
    storage:
      volumeClaimTemplate:
        spec:
          resources:
            requests:
              storage: 100Gi
  # 查询组件配置
  select:
    replicas: 2
  # 写入组件配置
  insert:
    replicas: 2
```


## 参考链接
- [VictoriaMetrics Operator GitHub](https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/app/vmoperator)
- [Helm Charts 仓库](https://victoriametrics.github.io/helm-charts/)
- [CRD API 文档](https://docs.victoriametrics.com/operator/api.html)
