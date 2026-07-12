---
image: rancher/fleet-agent
description: "Rancher Fleet Agent是Rancher Fleet跨集群Kubernetes资源管理系统中的轻量级代理程序，部署于各目标Kubernetes集群，作为Fleet控制平面与集群间的通信桥梁，负责接收并执行资源部署指令，同步集群配置，实时监控部署状态，反馈执行结果，确保跨集群应用部署的一致性、自动化管理及故障恢复能力，是实现大规模Kubernetes集群统一资源编排与运维的关键组件。"
source: https://xuanyuan.cloud/zh/r/rancher/fleet-agent
canonical: https://xuanyuan.cloud/zh/r/rancher/fleet-agent
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rancher/fleet-agent" title="rancher/fleet-agent Docker 镜像中文简介、标签列表与拉取命令">rancher/fleet-agent 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Rancher Fleet Agent 介绍


## 概述  
Rancher Fleet Agent 是 Rancher Fleet 架构中的核心执行组件，部署在每一个需要通过 Fleet 管理的目标 Kubernetes 集群上。它作为 Fleet Controller（通常运行在 Rancher 管理集群）的“本地代理”，负责接收 Controller 下发的部署指令、在目标集群中实际执行资源部署，并持续监控状态、向 Controller 反馈结果，是实现跨集群 GitOps 管理的关键纽带。


## 核心功能  
### 1. 指令接收与执行  
接收 Fleet Controller 基于 Git 仓库配置生成的部署计划（包含 Kubernetes 资源清单、Helm Chart 或 Kustomize 配置），并在本地集群中调用 Kubernetes API 应用这些资源（如 Deployment、Service、ConfigMap 等）。  

### 2. 状态监控与上报  
实时监控已部署资源的运行状态（如 Pod 就绪状态、Deployment 副本数、资源冲突等），并将状态数据（成功/失败/重试）持续上报给 Fleet Controller，确保 Controller 能实时掌握所有目标集群的部署情况。  

### 3. 差异化配置处理  
支持根据目标集群的标签、环境变量等元数据，动态应用差异化配置（如通过 Kustomize 的 overlay 或 Helm 的 values 文件区分生产/测试集群配置），无需修改 Git 仓库中的基础配置。  

### 4. 异常重试与自愈  
当资源部署失败（如依赖缺失、权限不足）时，Agent 会根据 Controller 设定的策略自动重试；若发现已部署资源异常（如 Pod 崩溃），会触发重新同步，保障目标集群状态与 Git 仓库配置一致。  


## 工作流程  
1. **计划生成**：Fleet Controller 监听 Git 仓库变更，解析配置文件（如 `fleet.yaml`）生成针对不同目标集群的部署计划。  
2. **指令下发**：Controller 根据集群标签或选择器，将对应集群的部署计划推送给该集群的 Fleet Agent。  
3. **本地执行**：Agent 接收计划后，在本地集群中执行资源部署（调用 `kubectl apply` 逻辑，或通过 Helm 客户端安装 Chart）。  
4. **状态反馈**：Agent 持续监控部署后的资源状态，通过 gRPC 或 HTTP 协议将状态（如“资源已应用”“Pod 启动中”“部署失败：镜像拉取错误”）上报给 Controller。  
5. **全局同步**：Controller 汇总所有 Agent 的上报状态，更新 Git 仓库中配置的部署状态（如在 Rancher UI 显示“已同步”“同步失败”），并对失败任务触发重试或告警。  


## 部署步骤（基于 Rancher 环境）  
假设已具备：Rancher 管理集群（运行 Fleet Controller）、目标 Kubernetes 集群（需被管理）、目标集群已接入 Rancher（或可通过 `kubectl` 访问）。  

### 1. 启用 Fleet 功能  
在 Rancher 管理集群的 UI 中，进入 **设置 > 功能开关**，找到 “Fleet” 并启用（首次启用会自动部署 Fleet Controller 到管理集群的 `cattle-fleet-system` 命名空间）。  

### 2. 部署 Fleet Agent 到目标集群  
Rancher 会自动为目标集群生成 Agent 部署清单，也可手动部署：  
- **自动部署**：在 Rancher UI 中进入目标集群详情页，点击 **Fleet > 启用 Agent**，Rancher 会自动创建 `cattle-fleet-system` 命名空间并部署 Agent。  
- **手动部署**：若需手动执行，从 Rancher 管理集群获取 Agent 部署文件（路径通常为 `https://<rancher-server-url>/v3/fleet/agent-manifest`），保存为 `fleet-agent.yaml`，在目标集群执行：  
  ```bash
  kubectl apply -f fleet-agent.yaml -n cattle-fleet-system
  ```  

### 3. 验证 Agent 状态  
- 检查 Agent Pod 是否运行：  
  ```bash
  kubectl get pods -n cattle-fleet-system
  # 预期输出：fleet-agent-xxxxxx-xxxxx   1/1     Running   0          5m
  ```  
- 查看 Agent 日志，确认与 Controller 通信正常：  
  ```bash
  kubectl logs -n cattle-fleet-system deployment/fleet-agent
  # 正常日志示例："msg":"successfully connected to upstream controller"
  ```  


## 注意事项  
### 1. 网络连通性  
目标集群需满足：  
- 能访问管理集群的 Fleet Controller（默认端口 443，需开放出站规则）；  
- 能访问 Git 仓库（若使用私有仓库，需在 Agent 部署时配置访问凭证，如 SSH 密钥或 HTTPS Token，通过 Secret 挂载到 Agent Pod）。  

### 2. 权限配置  
Fleet Agent 需要在目标集群拥有足够的 RBAC 权限（如 `cluster-admin` 或自定义权限，包含对所有资源的 `get`/`list`/`create`/`update`/`delete` 权限）。Rancher 自动部署时会默认配置，手动部署需确保 `ClusterRoleBinding` 正确。  

### 3. 版本兼容性  
Agent 版本需与管理集群的 Fleet Controller 版本完全一致（如 Controller 版本为 `v0.3.9`，Agent 也必须是 `v0.3.9`），否则可能出现通信异常。Rancher 升级时会自动同步 Agent 版本，手动升级需注意匹配。  

### 4. 日志排查  
若部署失败，优先查看 Agent 日志定位问题：  
- 资源冲突：日志中会提示 `AlreadyExists` 或 `Conflict`，需检查目标集群是否已有同名资源；  
- 权限不足：日志中会提示 `Forbidden`，需检查 RBAC 配置；  
- Git 仓库访问失败：日志中会提示 `git clone failed`，需检查网络或凭证配置。
