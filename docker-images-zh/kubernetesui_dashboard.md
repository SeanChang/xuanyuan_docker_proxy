---
image: kubernetesui/dashboard
description: "用于Kubernetes集群的通用Web用户界面"
source: https://xuanyuan.cloud/zh/r/kubernetesui/dashboard
canonical: https://xuanyuan.cloud/zh/r/kubernetesui/dashboard
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kubernetesui/dashboard" title="kubernetesui/dashboard Docker 镜像中文简介、标签列表与拉取命令">kubernetesui/dashboard — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/kubernetesui/dashboard" title="kubernetesui/dashboard Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/kubernetesui/dashboard</a>

# Kubernetes Dashboard 镜像文档


## 一、镜像概述和主要用途

Kubernetes Dashboard 是一款面向 Kubernetes 集群的通用 Web 界面工具。作为 Kubernetes 官方提供的可视化管理平台，其核心用途是为集群用户提供直观的图形化操作界面，实现对集群中应用的全生命周期管理、故障排查以及集群本身的配置与监控。


## 二、核心功能和特性

### 2.1 核心功能
- **应用生命周期管理**：支持部署、扩容、缩容、更新及删除 Kubernetes 应用资源（如 Deployment、StatefulSet、DaemonSet 等）。
- **集群资源监控**：实时展示集群节点、Pod、Service、ConfigMap 等资源的运行状态与 metrics 数据（需配合 metrics-server）。
- **故障排查工具**：提供 Pod 日志查看、事件监控、容器终端访问等功能，辅助定位应用运行异常。
- **集群配置管理**：支持管理 Namespace、Role、RoleBinding 等集群配置资源，配置集群网络、存储等基础设施。
- **用户认证与授权**：集成 Kubernetes RBAC 权限体系，支持 Token、Kubeconfig、OIDC 等多种认证方式，确保操作安全性。


## 三、使用场景和适用范围

### 3.1 适用场景
- **集群管理员日常运维**：通过图形化界面执行节点健康检查、资源分配调整、集群升级等操作。
- **开发人员应用调试**：快速部署应用、查看 Pod 日志、调整资源配置，简化开发环境调试流程。
- **团队协作与状态共享**：支持多用户访问，便于团队成员共同查看集群状态、协同排查问题。
- **教学与演示环境**：直观展示 Kubernetes 资源关系和运行机制，降低学习门槛。

### 3.2 适用范围
- 所有 Kubernetes 集群环境（包括本地开发集群如 Minikube、生产环境集群等）。
- 支持 Kubernetes 1.19+ 版本（具体版本兼容性需参考镜像标签对应的官方说明）。


## 四、使用方法和配置说明

### 4.1 部署方式概述
Kubernetes Dashboard 通常通过 Kubernetes 资源清单（YAML）部署（官方推荐方式），也可通过 Docker 容器独立运行（适用于测试或本地开发场景）。以下提供 Docker 部署示例及配置说明。


### 4.2 Docker 运行示例
#### 4.2.1 基础运行命令
```bash
docker run -d \
  --name kubernetes-dashboard \
  -p 8443:8443 \
  -e KUBERNETES_DASHBOARD_APISERVER_URL=https://<k8s-apiserver-ip>:6443 \
  kubernetesui/dashboard:latest
```
- 说明：  
  - `-p 8443:8443`：映射容器 8443 端口（Dashboard 默认 HTTPS 端口）到主机。  
  - `KUBERNETES_DASHBOARD_APISERVER_URL`：指定 Kubernetes API Server 地址，确保 Dashboard 能连接集群。  


#### 4.2.2 带认证配置的运行命令
启用 Token 认证（默认开启），并挂载本地证书（可选，用于 HTTPS 加密）：
```bash
docker run -d \
  --name kubernetes-dashboard \
  -p 8443:8443 \
  -v /path/to/local/certs:/certs \
  -e KUBERNETES_DASHBOARD_TLS_CERT_FILE=/certs/tls.crt \
  -e KUBERNETES_DASHBOARD_TLS_KEY_FILE=/certs/tls.key \
  -e KUBERNETES_DASHBOARD_APISERVER_URL=https://<k8s-apiserver-ip>:6443 \
  kubernetesui/dashboard:latest
```


### 4.3 Docker Compose 配置示例
```yaml
version: '3'
services:
  kubernetes-dashboard:
    image: kubernetesui/dashboard:latest
    container_name: kubernetes-dashboard
    ports:
      - "8443:8443"
    environment:
      - KUBERNETES_DASHBOARD_APISERVER_URL=https://<k8s-apiserver-ip>:6443
      - KUBERNETES_DASHBOARD_LOG_LEVEL=info  # 日志级别：debug/info/warn/error
    volumes:
      - /path/to/local/certs:/certs  # 可选：挂载自定义证书
    restart: unless-stopped
```


### 4.4 核心配置参数与环境变量
| 参数/环境变量                  | 描述                                                                 | 默认值                  |
|-------------------------------|----------------------------------------------------------------------|-------------------------|
| `--port`                      | 服务监听端口（容器内）                                               | 8443（HTTPS）           |
| `KUBERNETES_DASHBOARD_APISERVER_URL` | Kubernetes API Server 地址（格式：`https://<ip>:<port>`）           | 无（需手动指定）        |
| `KUBERNETES_DASHBOARD_TLS_CERT_FILE` | HTTPS 证书路径（容器内）                                            | 自动生成临时证书        |
| `KUBERNETES_DASHBOARD_TLS_KEY_FILE`  | HTTPS 私钥路径（容器内）                                            | 自动生成临时私钥        |
| `KUBERNETES_DASHBOARD_LOG_LEVEL`     | 日志级别（debug/info/warn/error）                                   | info                    |
| `KUBERNETES_DASHBOARD_AUTH_MODE`     | 认证模式（`token`/`kubeconfig`/`oidc`）                             | token,kubeconfig        |


### 4.5 访问与使用
1. **访问 Dashboard**：通过浏览器访问 `https://<主机IP>:8443`（注意使用 HTTPS）。  
2. **认证登录**：  
   - Token 认证：通过 `kubectl -n kube-system create token default` 获取默认 ServiceAccount Token（仅测试用，生产环境需配置 RBAC 权限）。  
   - Kubeconfig 认证：上传本地 `~/.kube/config` 文件（需确保集群地址可访问）。  


## 五、注意事项
1. **生产环境部署**：建议通过 Kubernetes 官方资源清单部署（`kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml`），而非直接 Docker 运行，以确保与集群的安全集成（如 RBAC、网络策略）。  
2. **安全配置**：生产环境必须启用 HTTPS，配置自定义证书，并通过 RBAC 严格限制用户权限（避免使用高权限 ServiceAccount）。  
3. **版本兼容性**：Dashboard 版本需与 Kubernetes 集群版本匹配（如 Dashboard v2.7.x 兼容 K8s 1.24+），具体参考 [官方版本说明](https://github.com/kubernetes/dashboard/releases)。
