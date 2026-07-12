---
image: intel/intel-gpu-plugin
description: "Intel GPU设备插件是一款为Kubernetes集群开发的组件，旨在实现对Intel GPU资源的识别、管理与高效调度，支持部署GPU加速的工作负载，包括AI模型训练、高性能计算、数据分析等任务，并通过优化资源分配和实时监控，提升集群中GPU资源的利用率及相关工作负载的运行效率。"
source: https://xuanyuan.cloud/zh/r/intel/intel-gpu-plugin
canonical: https://xuanyuan.cloud/zh/r/intel/intel-gpu-plugin
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/intel/intel-gpu-plugin" title="intel/intel-gpu-plugin Docker 镜像中文简介、标签列表与拉取命令">intel/intel-gpu-plugin 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## Intel GPU 设备插件（Kubernetes）


这是一款适用于 Kubernetes 集群的 Intel GPU 设备插件，核心作用是帮助 Kubernetes 识别、管理 Intel GPU 硬件资源，让容器化工作负载能够便捷、高效地调度和使用 Intel GPU 算力。


### 主要功能  
- **资源暴露**：向 Kubernetes 集群上报 Intel GPU 设备详情，包括型号、可用算力、内存等信息，使集群感知 GPU 资源状态；  
- **调度支持**：配合 Kubernetes 调度器，实现基于 GPU 资源的 Pod 调度，确保工作负载被分配到具备可用 Intel GPU 的节点；  
- **原生集成**：兼容 Kubernetes 设备管理框架，支持通过标准资源配置（如 `resources.limits.gpu.intel.com/i915`）申请和限制 GPU 资源。  


### 操作与文档  
关于插件的部署步骤（如 DaemonSet 配置）、参数说明（如设备过滤规则）、兼容性列表（支持的 Intel GPU 型号及 Kubernetes 版本），可通过以下链接获取完整文档：  
[Intel 设备插件 GitHub 仓库]
