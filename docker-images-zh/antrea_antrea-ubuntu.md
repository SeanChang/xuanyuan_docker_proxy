---
image: antrea/antrea-ubuntu
description: "Antrea的旧版统一镜像，包含Antrea Agent和Controller，用于Kubernetes集群的网络和安全服务，已弃用，建议迁移至独立镜像。"
source: https://xuanyuan.cloud/zh/r/antrea/antrea-ubuntu
canonical: https://xuanyuan.cloud/zh/r/antrea/antrea-ubuntu
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/antrea/antrea-ubuntu" title="antrea/antrea-ubuntu Docker 镜像中文简介、标签列表与拉取命令">antrea/antrea-ubuntu 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## Antrea 统一镜像（已弃用）

### 镜像概述
Antrea是一个Kubernetes原生网络解决方案，运行在OSI模型第3/4层，为Kubernetes集群提供网络和安全服务，底层使用Open vSwitch作为数据平面。本镜像为多平台镜像（支持amd64、arm64、arm/v7架构），包含Antrea Agent和Antrea Controller。

**重要提示**：自Antrea v1.15版本起，Antrea Agent和Controller已分别打包为独立Docker镜像（[antrea-agent-ubuntu](https://hub.docker.com/r/antrea/antrea-agent-ubuntu)和[antrea-controller-ubuntu](https://hub.docker.com/r/antrea/antrea-controller-ubuntu)）。因此，本"统一"镜像已被标记为弃用，除为旧版Antrea发布维护版本外，不再更新。未来该仓库可能被移除。

### 核心功能与特性
- **Kubernetes原生设计**：专为Kubernetes集群打造，与Kubernetes API深度集成
- **网络与安全服务**：提供第3/4层网络连接和安全策略 enforcement
- **Open vSwitch数据平面**：基于成熟的Open vSwitch技术实现高效网络转发
- **多平台支持**：兼容amd64、arm64、arm/v7等多种硬件架构
- **集成组件**：包含Antrea Agent（运行在每个节点）和Antrea Controller（集群级控制组件）

### 使用场景与适用范围
本镜像适用于需要部署旧版Antrea（v1.14及更早版本）的Kubernetes集群。对于新建部署，强烈建议使用v1.15及以上版本的独立镜像（antrea-agent-ubuntu和antrea-controller-ubuntu）。

### 使用方法与配置说明
由于本镜像已弃用，官方不再推荐使用。如需部署Antrea，建议：
1. 升级至Antrea v1.15及以上版本
2. 使用独立的Agent和Controller镜像

如需获取更多信息，请参考Antrea源码仓库：[https://github.com/antrea-io/antrea](https://github.com/antrea-io/antrea)
