---
image: bitnamicharts/pytorch
description: "Bitnami提供的PyTorch Helm chart，用于在Kubernetes环境中简化PyTorch的部署与管理。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/pytorch
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/pytorch
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/pytorch" title="bitnamicharts/pytorch Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/pytorch 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami PyTorch 镜像文档


## 镜像概述和主要用途

PyTorch 是一个深度学习平台，可加速从研究原型到生产部署的过渡。Bitnami 提供的 PyTorch 镜像包含 Torchvision，专为特定计算机视觉任务提供支持。该镜像由 Bitnami 打包，旨在简化 PyTorch 在容器化环境中的部署和使用。

[PyTorch 官方概述](https://pytorch.org/)

**商标说明**：本软件列表由 Bitnami 打包。所提及的相关商标归各自公司所有，使用这些商标并不意味着任何关联或背书。


## 核心功能和特性

- **完整深度学习平台**：支持从研究原型设计到生产部署的全流程，提供灵活的张量计算和自动微分功能。
- **Torchvision 集成**：内置计算机视觉库，包含常用数据集、模型架构和图像变换工具。
- **容器化优化**：基于 Bitnami 标准镜像构建，支持非 root 用户运行，安全性增强。
- **多环境适配**：兼容 Docker 单机部署和 Kubernetes 集群（通过 Helm Chart）。
- **持久化支持**：可配置持久化存储，确保数据在容器重启后不丢失。
- **灵活的文件加载方式**：支持通过现有 ConfigMap、本地文件目录或 Git 仓库加载自定义代码和数据。


## 使用场景和适用范围

- **研究原型开发**：快速搭建深度学习实验环境，验证模型算法。
- **生产部署**：将训练好的 PyTorch 模型部署到生产环境，处理实际业务数据。
- **计算机视觉任务**：利用 Torchvision 支持图像分类、目标检测、语义分割等任务。
- **分布式训练**：通过配置 `worldSize` 参数支持多节点分布式训练。
- **开发与测试**：在隔离的容器环境中进行 PyTorch 应用的开发和测试。


## ⚠️ 重要注意事项：Bitnami 镜像目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共镜像目录，推出[Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)，提供经过安全强化的精选镜像。过渡期间的关键变更包括：

- **安全优化镜像开放**：首次向社区用户提供流行容器镜像的安全优化版本。
- **非硬化镜像逐步淘汰**：免费 tier 中将逐步停止支持基于 Debian 的非硬化软件镜像，并从公共目录中移除非最新标签。社区用户将只能访问数量减少的硬化镜像，且仅提供“latest”标签，适用于开发目的。
- **现有镜像迁移**：8 月 28 日起，两周内所有现有容器镜像（包括旧版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- **生产环境建议**：对于生产工作负载和长期支持，建议采用 Bitnami Secure Images，包含硬化容器、更小攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 及企业支持。


## 使用方法和配置说明

### Docker 快速启动

#### 基本部署（最新硬化镜像）
使用 Bitnami Secure Images（仅 latest 标签，适用于开发）：
```console
docker run --name pytorch -d docker.io/bitnami/pytorch:latest
```

#### 旧版本镜像（Legacy 仓库）
若需使用旧版本或非硬化镜像，从 Legacy 仓库拉取（不再更新）：
```console
docker run --name pytorch-legacy -d docker.io/bitnamilegacy/pytorch:2.50.0
```

#### 挂载持久化存储
默认持久化路径为 `/bitnami/pytorch`，可通过 `-v` 参数挂载本地目录：
```console
docker run --name pytorch -v /local/path:/bitnami/pytorch -d docker.io/bitnami/pytorch:latest
```


### Helm Chart 部署（Kubernetes）

#### 前提条件
- Kubernetes 1.23+
- Helm 3.8.0+
- 底层基础设施支持 PV 动态供应
- 支持 ReadWriteMany 卷（用于部署扩展）

#### 安装 Chart
使用以下命令安装名为 `my-release` 的 release：
```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/pytorch
```
> **注**：需将占位符替换为实际 Helm 仓库信息。Bitnami 官方仓库为 `registry-1.docker.io`（ registry）和 `bitnamicharts`（repository）。


### 配置参数详解

#### 全局参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局 Docker 仓库密钥名称数组 | `[]` |
| `global.defaultStorageClass` | 持久化卷的全局默认 StorageClass | `""` |
| `global.storageClass` | （已弃用）使用 `global.defaultStorageClass` 替代 | `""` |
| `global.security.allowInsecureImages` | 是否允许跳过镜像验证 | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 适配 OpenShift 安全上下文（auto/force/disabled） | `auto` |


#### 通用参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `kubeVersion` | 覆盖 Kubernetes 版本 | `""` |
| `nameOverride` | 部分覆盖 release 名称模板 | `""` |
| `commonLabels` | 所有部署对象的标签 | `{}` |
| `commonAnnotations` | 所有部署对象的注解 | `{}` |
| `fullnameOverride` | 完全覆盖 release 名称模板 | `""` |
| `extraDeploy` | 额外部署的对象数组 | `[]` |
| `diagnosticMode.enabled` | 启用诊断模式（禁用所有探针并覆盖命令） | `false` |
| `diagnosticMode.command` | 诊断模式下覆盖所有容器的命令 | `["sleep"]` |
| `diagnosticMode.args` | 诊断模式下覆盖所有容器的参数 | `["infinity"]` |


#### PyTorch 核心参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `image.registry` | PyTorch 镜像仓库 | `REGISTRY_NAME` |
| `image.repository` | PyTorch 镜像路径 | `REPOSITORY_NAME/pytorch` |
| `image.digest` | 镜像摘要（sha256:xx 格式，设置后覆盖标签） | `""` |
| `image.pullPolicy` | 镜像拉取策略 | `IfNotPresent` |
| `image.pullSecrets` | 镜像拉取密钥数组 | `[]` |
| `worldSize` | 运行代码的节点数量 | `1` |
| `containerPorts.pytorch` | PyTorch 主端口（对应环境变量 `MASTER_PORT`） | `49875` |
| `podSecurityContext.enabled` | 是否启用 Pod 安全上下文 | `true` |
| `podSecurityContext.fsGroup` | Pod 文件系统组 ID | `1001` |
| `containerSecurityContext.enabled` | 是否启用容器安全上下文 | `true` |
| `containerSecurityContext.runAsUser` | 容器运行用户 ID | `1001` |
| `containerSecurityContext.runAsGroup` | 容器运行用户组 ID | `1001` |


### 文件加载方式

PyTorch 镜像支持三种文件加载方式，优先级从高到低为：

1. **现有 ConfigMap**：通过 `configMap=my-config-map` 参数指定，镜像将直接使用该 ConfigMap 中的文件。
   
2. **本地文件目录**：将文件放入 `files/` 目录，无需额外配置，镜像会自动加载。

3. **Git 仓库克隆**：通过以下参数配置 Git 仓库：
   ```yaml
   cloneFilesFromGit.enabled: true
   cloneFilesFromGit.repository: https://github.com/my-user/my-repo
   cloneFilesFromGit.revision: master
   ```


### 持久化存储配置

#### 持久化路径
默认持久化路径为 `/bitnami/pytorch`，通过 PV 动态供应实现持久化。

#### 权限调整
由于镜像默认以非 root 用户运行，需调整持久化卷的权限以确保容器可写入数据：
- **默认方式**：通过 Kubernetes Security Context 自动调整所有权（部分 Kubernetes 发行版可能不支持）。
- **替代方式**：启用 initContainer 调整权限，设置 `volumePermissions.enabled: true`。


### 备份与恢复

使用 [Velero](https://velero.io/)（Kubernetes 备份/恢复工具）备份和恢复部署：
1. 备份源部署的持久化卷。
2. 将备份的卷挂载到新部署。

详细步骤参考 [Bitnami 备份恢复指南](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html)。
