---
image: kubernetesui/metrics-scraper
description: "用于从Kubernetes Metrics Server抓取并存储一小段时间窗口指标的小型二进制程序。"
source: https://xuanyuan.cloud/zh/r/kubernetesui/metrics-scraper
canonical: https://xuanyuan.cloud/zh/r/kubernetesui/metrics-scraper
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [kubernetesui/metrics-scraper — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/kubernetesui/metrics-scraper)

含镜像标签、拉取命令、部署文档与相关推荐。

[kubernetesui/metrics-scraper Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/kubernetesui/metrics-scraper)

# Kubernetes Dashboard

## 镜像概述和主要用途

Kubernetes Dashboard 是一个通用的、基于 Web 的 Kubernetes 集群管理界面（UI）。它通过直观的可视化界面，允许用户与 Kubernetes 集群进行交互，实现对集群中应用资源的管理、故障排查以及集群本身的配置与监控。其核心用途包括简化 Kubernetes 资源的操作流程、提供集群状态的实时视图，以及降低用户使用 Kubernetes 的技术门槛。


## 核心功能和特性

### 1. 应用与资源管理
- 支持查看、创建、编辑和删除 Kubernetes 核心资源（如 Pod、Deployment、Service、ConfigMap、Secret 等）。
- 提供资源拓扑视图，直观展示应用组件间的依赖关系。

### 2. 集群监控与故障排查
- 集成 Metrics Server，实时展示集群节点、Pod 的 CPU、内存等资源使用指标。
- 提供 Pod 日志查看、事件追踪功能，辅助定位应用运行异常。

### 3. 集群配置管理
- 支持管理集群节点、命名空间、RBAC（角色与权限）等集群级资源。
- 可视化展示集群整体健康状态、资源分配情况。

### 4. 易用性与安全性
- 基于 Web 的图形化界面，无需命令行操作经验。
- 支持通过 Kubernetes Token、kubeconfig 文件等方式进行身份认证，遵循 RBAC 权限控制。

### 5. 兼容性与集成
- 与 Kubernetes API 深度集成，支持主流 Kubernetes 版本（具体版本需参考官方兼容性文档）。
- 可扩展支持第三方插件（如自定义资源 CRD 管理）。


## 使用场景和适用范围

### 适用场景
- **开发人员**：管理部署在 Kubernetes 集群中的应用，查看应用日志、调整资源配置。
- **运维人员**：监控集群节点健康状态、资源利用率，执行日常集群维护操作。
- **集群管理员**：配置 RBAC 权限、管理命名空间、审核集群资源使用情况。
- **新手用户**：通过可视化界面快速熟悉 Kubernetes 资源模型和操作流程。

### 适用范围
- 所有规模的 Kubernetes 集群（包括开发、测试、生产环境）。
- 支持 Kubernetes v1.19+ 版本（具体以官方最新兼容性说明为准）。


## 详细的使用方法和配置说明

### 部署方式（官方推荐）
Kubernetes Dashboard 通常通过 Kubernetes 资源清单部署在集群内部，官方提供了部署 YAML 文件：

```bash
# 部署最新稳定版
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

#### 部署资源说明
- **命名空间**：默认部署在 `kubernetes-dashboard` 命名空间。
- **组件**：包含 Deployment（Dashboard 应用）、Service（暴露服务）、ServiceAccount（权限账户）及 RBAC 角色绑定。


### 访问方式
#### 1. 端口转发（开发/测试环境）
通过 `kubectl port-forward` 暴露本地访问端口：

```bash
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard 8080:443
```
访问地址：`https://localhost:8080`（注意：浏览器可能提示证书不安全，需信任自签名证书）。

#### 2. NodePort 或 LoadBalancer（生产环境）
修改 Service 类型为 NodePort 或 LoadBalancer，通过节点 IP:端口或负载均衡器 IP 访问：
```yaml
# 编辑 Service
kubectl -n kubernetes-dashboard edit svc kubernetes-dashboard
# 将 spec.type 修改为 NodePort，并指定 nodePort（如 30007）
```
访问地址：`https://<节点IP>:30007`。

#### 3. Ingress（推荐生产环境）
通过 Ingress 资源配置域名访问，需集群已部署 Ingress Controller：
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kubernetes-dashboard-ingress
  namespace: kubernetes-dashboard
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  rules:
  - host: dashboard.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: kubernetes-dashboard
            port:
              number: 443
```


### 认证与授权
#### 获取访问 Token
1. 创建具有管理员权限的 ServiceAccount（仅测试环境使用，生产环境需遵循最小权限原则）：
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: dashboard-admin
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: dashboard-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: dashboard-admin
  namespace: kubernetes-dashboard
```

2. 获取 Token：
```bash
kubectl -n kubernetes-dashboard create token dashboard-admin
```
将 Token 粘贴到 Dashboard 登录界面的“Token”选项中完成登录。


### 配置参数说明
#### 环境变量
Dashboard 部署时可通过环境变量调整配置，常见参数如下：

| 环境变量名                | 描述                                                                 | 默认值                  |
|---------------------------|----------------------------------------------------------------------|-------------------------|
| `KUBERNETES_SERVICE_HOST` | Kubernetes API Server 地址                                           | 从集群内部自动发现      |
| `KUBERNETES_SERVICE_PORT` | Kubernetes API Server 端口                                           | 443                     |
| `DASHBOARD_VERSION`       | Dashboard 版本号                                                     | 镜像内置版本            |
| `LOG_LEVEL`               | 日志级别（`info`/`debug`/`warn`/`error`）                            | `info`                  |
| `METRICS_PROVIDER_URL`    | 外部指标提供者 URL（如 Prometheus），用于扩展指标展示                 | 空（默认使用 Metrics Server） |

#### 命令行参数
通过 Deployment 的 `args` 字段配置，常见参数：

| 参数                      | 描述                                                                 | 示例                     |
|---------------------------|----------------------------------------------------------------------|--------------------------|
| `--apiserver-host`        | 手动指定 Kubernetes API Server 地址                                 | `--apiserver-host=https://10.96.0.1:443` |
| `--namespace`             | 限制 Dashboard 仅管理指定命名空间（多租户场景）                      | `--namespace=default`    |
| `--enable-skip-login`     | 允许跳过登录（仅开发环境使用，禁用认证）                             | `--enable-skip-login`    |


## Docker 部署方案示例（非推荐，仅作参考）
Kubernetes Dashboard 设计为运行在 Kubernetes 集群内部，直接通过 Docker 运行需手动配置与集群的连接，适用于特殊测试场景：

### Docker Run 示例
```bash
docker run -d \
  --name kubernetes-dashboard \
  -p 8443:8443 \
  -e KUBERNETES_SERVICE_HOST=<k8s-api-server-ip> \
  -e KUBERNETES_SERVICE_PORT=6443 \
  k8s.gcr.io/dashboard/kubernetes-dashboard-amd64:v2.7.0 \
  --auto-generate-certificates \
  --apiserver-host=https://<k8s-api-server-ip>:6443
```
> 注意：需替换 `<k8s-api-server-ip>` 为实际 Kubernetes API Server 地址，并确保 Docker 容器可访问集群网络。


## 参考链接
- 官方文档：[https://github.com/kubernetes/dashboard](https://github.com/kubernetes/dashboard)
- 部署指南：[https://github.com/kubernetes/dashboard/blob/master/docs/user/installation.md](https://github.com/kubernetes/dashboard/blob/master/docs/user/installation.md)
- 权限配置：[https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control.md](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control.md)
