---
image: portainer/portainer-k8s-beta
description: "Portainer for Kubernetes BETA是一款用于Kubernetes集群管理的测试版工具。"
source: https://xuanyuan.cloud/zh/r/portainer/portainer-k8s-beta
canonical: https://xuanyuan.cloud/zh/r/portainer/portainer-k8s-beta
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/portainer/portainer-k8s-beta" title="portainer/portainer-k8s-beta Docker 镜像中文简介、标签列表与拉取命令">portainer/portainer-k8s-beta 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Portainer for Kubernetes BETA 镜像文档


## 一、镜像概述与主要用途
本镜像为 Portainer 的 Kubernetes 版本 BETA 镜像，旨在提供 Kubernetes 集群的图形化管理能力。作为测试阶段版本，其主要用途是供用户评估和测试 Portainer 在 Kubernetes 环境中的核心功能与易用性。


## 二、核心功能与特性
- **简化 Kubernetes 集群管理**：提供图形化界面，降低 Kubernetes 集群操作门槛，支持基本集群资源（如 Pod、Service、Deployment 等）的可视化管理。
- **BETA 阶段特性**：功能范围及稳定性可能受限，具体以官方测试计划为准，不包含生产环境级别的完整功能支持。


## 三、使用场景与适用范围
- **适用场景**：仅用于测试、评估 Portainer 在 Kubernetes 环境中的功能表现，或作为内部非生产环境的临时管理工具。
- **限制说明**：**禁止用于生产环境**，BETA 版本可能存在未修复的缺陷或兼容性问题。


## 四、使用方法与配置说明
### 部署要求
- 需预先配置 Kubernetes 集群环境（版本兼容性请参考官方文档）。
- 仅支持通过官方提供的 Kubernetes Manifest 文件部署，不支持常规 Docker 命令（如 `docker run`）直接启动。

### 部署步骤
1. 访问官方 GitHub 仓库获取部署文档及 Manifest 文件：  
   [https://github.com/portainer/portainer-k8s/blob/master/README.md](https://github.com/portainer/portainer-k8s/blob/master/README.md)  
2. 按照文档说明执行部署命令（通常为 `kubectl apply -f <manifest-file.yaml>`）。

### 配置参数
具体配置项（如资源限制、网络策略、存储卷设置等）需参考上述 GitHub 仓库中的 Manifest 文件及说明文档，官方未提供额外环境变量或配置参数的独立说明。


## 五、部署方案示例
### Kubernetes 集群部署
通过 `kubectl` 工具应用官方 Manifest 文件（以官方最新 Manifest 路径为准）：  
```bash
kubectl apply -f https://raw.githubusercontent.com/portainer/portainer-k8s/master/deploy/manifests/portainer.yaml
```
> 注：Manifest 文件路径可能随版本更新变化，请以 GitHub 仓库最新内容为准。


## 六、注意事项
- **版本生命周期**：BETA 阶段结束后，本镜像将从 DockerHub 移除，建议关注官方公告以获取正式版信息。
- **依赖说明**：部署及配置细节（如 RBAC 权限、Ingress 设置等）需严格遵循官方 Manifest 文档，避免因自定义修改导致功能异常。


## 参考链接
- 官方部署文档：[Portainer Kubernetes BETA 部署指南](https://github.com/portainer/portainer-k8s/blob/master/README.md)
