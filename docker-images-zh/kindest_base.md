---
image: kindest/base
description: "KIND（Kubernetes IN Docker）项目的基础镜像，用于提供构建和运行本地Kubernetes集群所需的底层环境，支持KIND工具创建开发、测试用Kubernetes集群。"
source: https://xuanyuan.cloud/zh/r/kindest/base
canonical: https://xuanyuan.cloud/zh/r/kindest/base
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kindest/base" title="kindest/base Docker 镜像中文简介、标签列表与拉取命令">kindest/base — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/kindest/base" title="kindest/base Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/kindest/base</a>

# kind 基础镜像技术文档


## 1. 镜像概述和主要用途

本镜像来自 [kind.sigs.k8s.io](https://kind.sigs.k8s.io/)，由 kind 项目维护团队预构建，是 `kindest/node` 镜像的基础组件。其核心用途是为 `kindest/node` 提供运行环境支持，包含在容器中运行 Kubernetes 所需的各类工具和依赖，是 kind（Kubernetes IN Docker）工具实现“容器中运行 Kubernetes 集群”能力的底层基础。


## 2. 核心功能和特性

### 2.1 核心功能
- 作为 `kindest/node` 镜像的基础层，提供运行 Kubernetes 节点的底层环境
- 集成运行 Kubernetes 容器化集群所需的核心工具链和依赖组件

### 2.2 主要特性
- **预构建版本**：由 kind 官方维护团队构建并发布，确保稳定性和兼容性
- **工具集成**：包含运行 Kubernetes 节点所需的各类系统工具和服务组件
- **开源维护**：基于开源项目开发，源代码公开，支持社区贡献和定制
- **版本同步**：与 kind 项目版本同步，适配不同 Kubernetes 版本的节点需求


## 3. 使用场景和适用范围

### 3.1 典型使用场景
- kind 工具节点镜像构建：作为 `kindest/node` 的基础镜像，用于生成可直接运行的 Kubernetes 节点容器
- Kubernetes 容器化运行环境：支持在 Docker 容器中快速部署和运行 Kubernetes 集群
- 开发与测试环境：为开发人员、测试人员提供轻量级、隔离的 Kubernetes 集群环境

### 3.2 适用范围
- 依赖 kind 工具构建 Kubernetes 集群的场景
- 需要在容器中运行 Kubernetes 节点的场景
- 开发、测试 Kubernetes 功能或应用的本地环境


## 4. 使用方法和配置说明

### 4.1 预构建镜像使用

本镜像作为 `kindest/node` 的基础层，通常不直接通过 `docker run` 命令独立运行，而是由 kind 工具在创建集群时间接使用。通过 kind 工具使用预构建镜像的典型流程如下：

1. **安装 kind 工具**  
   参考 [kind 官方快速入门](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) 安装 kind。

2. **创建 Kubernetes 集群**  
   使用 kind 命令创建集群时，kind 会自动拉取并使用基于本基础镜像构建的 `kindest/node` 镜像：
   ```bash
   kind create cluster
   ```

### 4.2 自建基础镜像（高级用法）

如需定制基础镜像，可参考 kind 官方文档的自建指南：

1. **克隆 kind 源代码**  
   ```bash
   git clone https://github.com/kubernetes-sigs/kind.git
   cd kind/images/base
   ```

2. **构建基础镜像**  
   执行构建脚本（具体步骤参考 [官方自建指南](https://kind.sigs.k8s.io/docs/user/quick-start/#building-the-base-image)）：
   ```bash
   # 具体构建命令需根据官方文档调整，以下为示例
   make build-base-image
   ```

3. **使用自建镜像**  
   构建完成后，可通过修改 kind 配置文件指定自定义基础镜像，用于生成 `kindest/node`。


## 5. 相关资源

- **官方文档**：[kind.sigs.k8s.io](https://kind.sigs.k8s.io/)
- **自建基础镜像指南**：[kind 快速入门 - 构建基础镜像](https://kind.sigs.k8s.io/docs/user/quick-start/#building-the-base-image)
- **源代码**：[github.com/kubernetes-sigs/kind/tree/main/images/base](https://github.com/kubernetes-sigs/kind/tree/main/images/base)
- **贡献指南**：[kind 贡献者入门](https://kind.sigs.k8s.io/docs/contributing/getting-started/)
