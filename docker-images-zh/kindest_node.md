---
image: kindest/node
description: "[] node image 是 Kubernetes 特殊兴趣小组（SIGs）旗下 kind（Kubernetes IN Docker）项目的节点镜像，其以 Docker 容器形式运行 Kubernetes 节点，支持用户在本地快速部署和运行 Kubernetes 集群，适用于 Kubernetes 相关功能的开发、测试与学习场景。"
source: https://xuanyuan.cloud/zh/r/kindest/node
canonical: https://xuanyuan.cloud/zh/r/kindest/node
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kindest/node" title="kindest/node Docker 镜像中文简介、标签列表与拉取命令">kindest/node 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

### kind 预构建节点镜像说明  


#### 镜像来源与用途  
以下镜像由 kind 维护团队预构建，托管于 [kind.sigs.k8s.io]([])。  
主要用于配合 `kind` 工具搭建本地 Kubernetes 集群。集群中每个节点以容器形式运行，内置 Kubernetes 和 containerd-in-docker 环境。  


#### 使用与原理说明  
关于镜像的工作机制及具体使用方法，可参考 [kind 官方文档]([])。  


#### 自行构建节点镜像  
如需定制节点镜像，可按文档指引操作：[kind 快速入门 - 构建镜像]([])。  


#### 版本选择建议  
选择镜像时，请根据当前使用的 kind 版本，查阅对应 [发布说明]([])，确保版本兼容性。  


#### 源代码与贡献  
- 项目源代码：[kubernetes-sigs/kind]([])（节点镜像构建模块位于 [`pkg/build/nodeimage`]([]) 目录）。  
- 参与贡献：参考 [贡献指南]([])。
