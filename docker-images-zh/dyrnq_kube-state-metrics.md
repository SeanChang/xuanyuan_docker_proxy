---
image: dyrnq/kube-state-metrics
description: "kube-state-metrics镜像用于从Kubernetes API收集并以Prometheus格式暴露集群对象（如Pod、Deployment等）的状态指标，支持监控系统抓取以实现集群状态监控与分析。"
source: https://xuanyuan.cloud/zh/r/dyrnq/kube-state-metrics
canonical: https://xuanyuan.cloud/zh/r/dyrnq/kube-state-metrics
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dyrnq/kube-state-metrics" title="dyrnq/kube-state-metrics Docker 镜像中文简介、标签列表与拉取命令">dyrnq/kube-state-metrics 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# kube-state-metrics 镜像文档


## 1. 镜像概述和主要用途

### 1.1 镜像信息
**镜像名称**：`k8s.gcr.io/kube-state-metrics/kube-state-metrics`  
**官方维护**：Kubernetes SIG Monitoring  
**功能定位**：Kubernetes 集群状态指标收集工具，用于从 Kubernetes API 服务器抓取集群内资源对象（如 Pod、Deployment、Service 等）的状态指标，并通过 HTTP 接口暴露给监控系统（如 Prometheus）。


## 2. 核心功能和特性

### 2.1 核心功能
- **资源状态指标收集**：支持抓取 Kubernetes 核心资源（Pod、Node、Service、Deployment、StatefulSet 等）及自定义资源（CRD）的状态指标（如副本数、就绪状态、重启次数等）。
- **无侵入式部署**：通过 Kubernetes API Server 读取资源数据，不修改集群原生组件或资源定义。
- **标准化指标格式**：输出符合 Prometheus 规范的指标（如 `kube_pod_status_ready{condition="true"}`），支持直接被 Prometheus 抓取。

### 2.2 关键特性
- **可配置资源范围**：支持通过参数指定需收集的资源类型（如仅收集 Deployment 和 StatefulSet）。
- **指标过滤能力**：可通过白名单/黑名单过滤特定指标，减少不必要的指标暴露。
- **高可用性**：支持多副本部署，通过 leader 选举避免指标重复。
- **轻量级设计**：镜像体积小（约 20-30MB），运行时资源消耗低（默认 100m CPU/128Mi 内存）。
- **版本兼容性**：适配 Kubernetes 1.19+ 版本，不同镜像版本需与集群版本匹配（见 [版本矩阵](https://github.com/kubernetes/kube-state-metrics#compatibility-matrix)）。


## 3. 使用场景和适用范围

### 3.1 典型使用场景
- **Kubernetes 集群监控**：作为 Prometheus + Grafana 监控栈的核心组件，提供集群资源状态数据。
- **资源状态可视化**：配合 Grafana 仪表盘展示集群资源健康度（如 Deployment 副本就绪率、Pod 重启次数）。
- **告警规则配置**：基于状态指标触发告警（如 Deployment 副本未就绪、Node 资源不足）。
- **集群问题排查**：通过历史指标回溯资源状态变化（如 Pod 异常重启时间线）。

### 3.2 适用范围
- **环境**：所有 Kubernetes 集群（包括自建集群、云厂商托管集群如 EKS/GKE/AKS）。
- **规模**：支持从小型测试集群（10 节点以内）到大型生产集群（1000+ 节点）。
- **用户**：集群管理员、DevOps 工程师、SRE，需监控集群资源状态的场景。


## 4. 详细使用方法和配置说明

### 4.1 部署方式
kube-state-metrics 需运行在 Kubernetes 集群内，主流部署方式包括 **直接 YAML 部署** 和 **Helm 部署**。


### 4.2 部署前置条件
- Kubernetes 集群版本 ≥ 1.19（需与 kube-state-metrics 版本匹配，详见 [版本矩阵](https://github.com/kubernetes/kube-state-metrics#compatibility-matrix)）。
- 集群已配置 RBAC（需为 kube-state-metrics 分配访问 API Server 的权限）。
- 监控系统（如 Prometheus）已部署，且配置了对 kube-state-metrics 服务的抓取规则。


### 4.3 配置参数说明
kube-state-metrics 主要通过**命令行参数**配置，支持自定义资源范围、指标过滤、网络端口等。


#### 4.3.1 核心命令行参数
| 参数名                  | 说明                                                                 | 默认值                  |
|-------------------------|----------------------------------------------------------------------|-------------------------|
| `--port`                | 指标暴露端口（Prometheus 抓取端口）                                  | `8080`                  |
| `--telemetry-port`      | 自身监控端口（暴露组件内部指标，如 `kube_state_metrics_build_info`） | `8081`                  |
| `--namespace`           | 限制仅收集指定命名空间的资源（多命名空间用逗号分隔，默认全命名空间） | 空（全命名空间）        |
| `--resources`           | 指定需收集的资源类型（多资源用逗号分隔，默认全资源）                 | 空（全资源）            |
| `--metric-allowlist`    | 指标白名单（仅暴露符合正则的指标，如 `kube_pod_.*`）                 | 空（暴露所有指标）      |
| `--metric-denylist`     | 指标黑名单（排除符合正则的指标，优先级高于白名单）                   | 空（不排除指标）        |
| `--kubeconfig`          | 本地 kubeconfig 文件路径（集群外运行时使用，集群内无需指定）         | 空（使用集群内 ServiceAccount） |
| `--leader-election`     | 启用 leader 选举（多副本部署时避免指标重复）                         | `true`                  |


#### 4.3.2 RBAC 配置
kube-state-metrics 需通过 Kubernetes API 访问资源，需配置以下 RBAC 资源：
- **ServiceAccount**：为 Pod 分配身份。
- **ClusterRole**：定义访问资源的权限（如 `get`/`list`/`watch` Pod、Node 等）。
- **ClusterRoleBinding**：将 ClusterRole 绑定到 ServiceAccount。


## 5. 部署示例

### 5.1 Kubernetes Deployment 部署（推荐）
以下为完整部署示例，包含 Deployment、Service、RBAC 配置。


#### 5.1.1 RBAC 配置（`rbac.yaml`）
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: kube-state-metrics
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: kube-state-metrics
rules:
- apiGroups: [""]
  resources: ["pods", "nodes", "services", "endpoints", "namespaces", "configmaps", "secrets"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments", "daemonsets", "statefulsets", "replicasets"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["batch"]
  resources: ["jobs", "cronjobs"]
  verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kube-state-metrics
subjects:
- kind: ServiceAccount
  name: kube-state-metrics
  namespace: kube-system
roleRef:
  kind: ClusterRole
  name: kube-state-metrics
  apiGroup: rbac.authorization.k8s.io
```


#### 5.1.2 Deployment 配置（`deployment.yaml`）
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kube-state-metrics
  namespace: kube-system
  labels:
    app: kube-state-metrics
spec:
  replicas: 2  # 多副本提高可用性
  selector:
    matchLabels:
      app: kube-state-metrics
  template:
    metadata:
      labels:
        app: kube-state-metrics
    spec:
      serviceAccountName: kube-state-metrics  # 关联 RBAC 账号
      containers:
      - name: kube-state-metrics
        image: ***-k8s.xuanyuan.run/kube-state-metrics/kube-state-metrics:v2.10.0  # 使用最新稳定版
        ports:
        - containerPort: 8080  # 指标端口
          name: metrics
        - containerPort: 8081  # 自身监控端口
          name: telemetry
        args:
        - --resources=pods,deployments,nodes,services  # 仅收集指定资源
        - --metric-allowlist=kube_pod_.*,kube_deployment_.*  # 仅暴露 Pod 和 Deployment 指标
        resources:
          limits:
            cpu: 200m
            memory: 256Mi
          requests:
            cpu: 100m
            memory: 128Mi
        livenessProbe:
          httpGet:
            path: /healthz
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
```


#### 5.1.3 Service 配置（`service.yaml`）
```yaml
apiVersion: v1
kind: Service
metadata:
  name: kube-state-metrics
  namespace: kube-system
  labels:
    app: kube-state-metrics
spec:
  ports:
  - name: metrics
    port: 8080
    targetPort: metrics
  - name: telemetry
    port: 8081
    targetPort: telemetry
  selector:
    app: kube-state-metrics
```


### 5.2 Helm 部署（推荐生产环境）
通过 Helm 部署可简化配置管理，支持自定义参数：
```bash
# 添加 Helm 仓库
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# 安装 kube-state-metrics（自定义资源和指标过滤）
helm install kube-state-metrics prometheus-community/kube-state-metrics \
  --namespace kube-system \
  --set resourcesToWatch="{pods,deployments,nodes}" \
  --set metricAllowlist="{kube_pod_.*,kube_deployment_.*}" \
  --set replicaCount=2
```


### 5.3 本地 Docker 运行（仅测试用）
**注意**：kube-state-metrics 通常需运行在 Kubernetes 集群内，本地 Docker 运行需通过 `kubeconfig` 访问集群 API：
```bash
docker run -d \
  --name kube-state-metrics \
  -p 8080:8080 \
  -v ~/.kube/config:/kubeconfig \  # 挂载本地 kubeconfig
  k8s.gcr.io/kube-state-metrics/kube-state-metrics:v2.10.0 \
  --kubeconfig=/kubeconfig \
  --resources=pods,deployments
```


## 6. 使用场景示例

### 6.1 Prometheus 抓取配置
在 Prometheus 的 `prometheus.yml` 中添加抓取规则：
```yaml
scrape_configs:
- job_name: 'kube-state-metrics'
  static_configs:
  - targets: ['kube-state-metrics.kube-system.svc:8080']  # 通过 Service 域名访问
```


### 6.2 Grafana 仪表盘集成
1. 导入 Grafana 官方仪表盘（ID：[7249](https://grafana.com/grafana/dashboards/7249-kubernetes-cluster-monitoring-via-prometheus/)）。
2. 配置数据源为 Prometheus，即可查看集群资源状态面板（如 Pod 就绪率、Deployment 副本状态）。


## 7. 常见问题与注意事项

### 7.1 权限不足导致指标缺失
**现象**：Pod 日志报 `forbidden: User "system:serviceaccount:kube-system:kube-state-metrics" cannot list resource`。  
**解决**：检查 RBAC 配置，确保 ClusterRole 包含需访问的资源权限（参考 5.1.1 节）。


### 7.2 指标重复或缺失
- **重复**：多副本部署时未启用 `--leader-election`，导致同一指标被多次暴露。需确保 `--leader-election=true`（默认启用）。
- **缺失**：检查 `--resources` 或 `--metric-allowlist` 参数是否误过滤了目标资源/指标。


### 7.3 版本兼容性
kube-state-metrics 版本需与 Kubernetes 集群版本匹配，例如：
- Kubernetes 1.24+ → kube-state-metrics v2.8+  
- Kubernetes 1.21-1.23 → kube-state-metrics v2.6-v2.7  
具体参考 [官方版本矩阵](https://github.com/kubernetes/kube-state-metrics#compatibility-matrix)。


### 7.4 性能优化
- 大规模集群（1000+ Node）建议：  
  - 限制资源范围（`--resources`），仅收集核心资源；  
  - 增加副本数（3-5 副本）并配置资源限制（CPU 200m/内存 256Mi+）；  
  - 使用 `--metric-allowlist` 过滤非必要指标。
