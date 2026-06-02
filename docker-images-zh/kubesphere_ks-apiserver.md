---
image: kubesphere/ks-apiserver
description: "KubeSphere API服务器是KubeSphere容器平台的核心组件，负责接收、验证和处理来自用户、集群组件及外部系统的API请求，实现对Kubernetes集群资源（如Pod、Deployment、Service等）的统一管理与调度，支持权限控制、请求路由和数据校验，确保集群操作的安全与高效，是连接用户操作与底层资源的关键桥梁。"
source: https://xuanyuan.cloud/zh/r/kubesphere/ks-apiserver
canonical: https://xuanyuan.cloud/zh/r/kubesphere/ks-apiserver
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [kubesphere/ks-apiserver — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/kubesphere/ks-apiserver)

含镜像标签、拉取命令、部署文档与相关推荐。

[kubesphere/ks-apiserver Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/kubesphere/ks-apiserver)

# KubeSphere API Server 介绍


## 概述  
KubeSphere API Server 是 KubeSphere 容器平台的核心组件之一，作为用户、应用程序及平台内部组件与 KubeSphere 交互的“统一入口”，负责接收、验证并处理各类 API 请求。它基于 RESTful 架构设计，兼容 Kubernetes API 规范，同时扩展了 KubeSphere 特有的功能接口，让用户能通过标准化的 API 操作平台资源、配置功能及获取状态数据。


## 核心功能  
### 1. 请求处理与路由  
接收来自用户（如通过 kubectl、Web 控制台）、应用程序或其他组件的 HTTP/HTTPS 请求，根据请求类型（如 GET、POST、PUT、DELETE）和资源路径，将请求路由至对应的后端服务（如 KubeSphere 控制器、Kubernetes API Server 等），确保请求准确分发。  


### 2. 资源全生命周期管理  
提供对 KubeSphere 平台各类资源的完整操作接口，包括：  
- **集群资源**：集群、节点、命名空间（KubeSphere 中称为“项目”）的创建、查询、更新、删除；  
- **工作负载**：Deployment、StatefulSet、Job 等 Kubernetes 原生工作负载，以及 KubeSphere 扩展的应用生命周期管理；  
- **自定义资源**：如多集群配置、DevOps 流水线、微服务治理规则等 KubeSphere 特有的资源类型（CR/CRD）。  


### 3. 权限与安全验证  
基于 Kubernetes RBAC（基于角色的访问控制）模型，在处理请求前验证用户身份（如通过 Token、证书）及权限，确保用户仅能操作其权限范围内的资源。例如：普通用户仅可查看和管理自己项目下的资源，管理员可配置集群级策略。  


### 4. 扩展功能接口  
除兼容 Kubernetes 原生 API 外，扩展了 KubeSphere 特色功能的专用接口，支持：  
- 多集群管理（跨集群资源同步、统一监控）；  
- DevOps 流程（流水线创建、代码仓库配置）；  
- 监控与告警（资源使用率查询、告警规则配置）；  
- 存储与网络（存储卷申领、服务网格配置）等场景。  


### 5. 数据聚合与返回  
整合底层 Kubernetes 资源数据（如 Pod 状态、Service 网络）与 KubeSphere 扩展数据（如项目配额、用户操作日志），通过标准化格式（JSON/JSON Patch）返回给请求方，简化用户对复杂资源关系的理解。  


## 与 Kubernetes API Server 的关系  
KubeSphere API Server 并非替代 Kubernetes API Server，而是**上层抽象与扩展层**：  
- 对于 Kubernetes 原生资源（如 Pod、Service）的请求，KubeSphere API Server 会转发至 Kubernetes API Server 处理；  
- 对于 KubeSphere 自定义资源（如 ClusterConfiguration、DevOpsProject）的请求，由 KubeSphere API Server 直接处理，依赖 KubeSphere 控制器（Controller）完成资源的实际编排；  
- 两者协同工作：Kubernetes API Server 负责容器编排的底层实现，KubeSphere API Server 提供更贴近用户需求的“平台级”交互接口，降低使用复杂度。  


## 典型使用场景  
### 1. 平台管理  
管理员通过 API 配置集群参数（如资源配额、安全策略）、管理用户与权限（创建角色、绑定用户到项目），或集成第三方工具（如运维平台）实现自动化管理。  


### 2. 应用开发与部署  
开发者通过 API 提交应用部署请求（如创建 Deployment）、查询应用状态（如 Pod 运行日志），或集成 CI/CD 工具（如 Jenkins）实现应用自动发布。  


### 3. 监控与运维  
运维人员通过 API 获取集群/项目资源使用率（如 CPU、内存）、工作负载健康状态，或配置监控告警规则（如当 Pod 重启次数超过阈值时触发通知）。  


## 基本操作示例  
以下为通过 KubeSphere API Server 操作资源的简单示例（需先获取用户 Token，通过 `kubectl get secret -n kubesphere-system` 获取对应 ServiceAccount 的 Token）。  


### 示例 1：查询项目（Namespace）列表  
通过 GET 请求获取当前集群中的所有项目：  
```bash
curl -X GET "https://<kubeSphere-api-server-ip>:<port>/apis/tenant.kubesphere.io/v1alpha2/projects" \
  -H "Authorization: Bearer <your-token>" \
  -H "Content-Type: application/json"
```  
响应将返回项目名称、创建时间、状态等信息（JSON 格式）。  


### 示例 2：创建工作负载（Deployment）  
通过 POST 请求在指定项目中创建 Deployment（需提前准备符合 KubeSphere API 规范的 JSON 请求体）：  
```bash
curl -X POST "https://<kubeSphere-api-server-ip>:<port>/apis/apps/v1/namespaces/<project-name>/deployments" \
  -H "Authorization: Bearer <your-token>" \
  -H "Content-Type: application/json" \
  -d @deployment.json  # deployment.json 为本地定义的 Deployment 配置文件
```  


## 总结  
KubeSphere API Server 是连接用户与平台功能的“桥梁”，通过标准化的 API 接口简化了集群管理、应用部署与运维操作。无论是手动调用还是集成自动化工具，它都能提供稳定、安全的交互能力，是 KubeSphere 平台易用性与扩展性的核心保障。
