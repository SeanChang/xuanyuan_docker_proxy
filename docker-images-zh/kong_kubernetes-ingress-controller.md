---
image: kong/kubernetes-ingress-controller
description: "使用 Kong 作为 Kubernetes Ingress 控制器，通过 CRDs 和原生工具配置路由、插件、健康检查及负载均衡"
source: https://xuanyuan.cloud/zh/r/kong/kubernetes-ingress-controller
canonical: https://xuanyuan.cloud/zh/r/kong/kubernetes-ingress-controller
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kong/kubernetes-ingress-controller" title="kong/kubernetes-ingress-controller Docker 镜像中文简介、标签列表与拉取命令">kong/kubernetes-ingress-controller 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 详细说明
Kong Kubernetes Ingress Controller 是一款将 Kong Gateway 与 Kubernetes 集群集成的工具，用于管理 Ingress 资源并处理集群内外流量。它通过 Kubernetes 原生工具（如 kubectl、Helm）和自定义资源定义（CRDs）配置路由规则、插件、健康检查、负载均衡等功能，实现 Kong Gateway 在 Kubernetes 环境中的自动化部署与动态管理。

## 使用场景
适用于 Kubernetes 集群中的流量管理需求，包括：微服务架构的 API 网关部署、多团队共享集群的流量隔离、动态路由规则配置、插件化流量控制（如认证、限流）等场景，尤其适合需要高可用与灵活扩展的生产环境。

## 特性
- **CRD 驱动配置**：支持通过 Ingress、KongPlugin、KongIngress 等 CRDs 定义路由与插件，与 Kubernetes 生态深度集成。
- **插件系统**：提供认证、限流、监控、日志等丰富插件，可通过 CRDs 动态启用与配置。
- **健康检查与负载均衡**：内置服务健康检查机制，支持多种负载均衡策略，保障服务可用性。
- **原生工具兼容**：支持 kubectl、Helm 等 Kubernetes 工具，简化部署与运维流程。

## Docker 部署方案示例
推荐使用 Helm 部署：
1. 添加 Kong Helm 仓库：helm repo add kong https://charts.konghq.com
2. 更新仓库：helm repo update
3. 安装控制器（含 CRDs）：helm install kong/kong --generate-name --set ingressController.installCRDs=true

部署后可通过 Ingress 资源配置路由，示例：
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo-ingress
  annotations:
    konghq.com/plugins: rate-limit
spec:
  ingressClassName: kong
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: demo-service
            port:
              number: 80
```
执行 kubectl apply -f ingress.yaml 即可应用配置，Kong 将自动更新路由规则。
