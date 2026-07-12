---
image: bitnami/deepspeed
description: "Bitnami提供的安全优化镜像，用于支持DeepSpeed深度学习优化库，适用于加速深度学习模型的训练与推理过程。"
source: https://xuanyuan.cloud/zh/r/bitnami/deepspeed
canonical: https://xuanyuan.cloud/zh/r/bitnami/deepspeed
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/deepspeed" title="bitnami/deepspeed Docker 镜像中文简介、标签列表与拉取命令">bitnami/deepspeed 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Secure Image for deepspeed 技术文档


## 1. 镜像概述与主要用途

Bitnami Secure Image for deepspeed 是 Bitnami 提供的针对 deepspeed 的安全加固镜像。该镜像目前已不在 Docker Hub 免费提供，而是通过商业订阅的 Bitnami Secure Images 服务，以构建好的 OCI 制品形式提供，支持 Debian 和 Photon 两种基础操作系统格式。  

对于开发者，Docker Hub 仍提供其他 Bitnami Secure Images 的开发者版本，可通过 [公共应用目录](https://app-catalog.vmware.com/bitnami/apps) 筛选 **Availability Type: Trial** 获取完整列表。  


## 2. 核心功能与特性

Bitnami Secure Image for deepspeed 基于 Photon 系统的版本（推荐从 Debian 基础版升级）具备以下核心特性：  

- **近零漏洞的安全加固**：基于流行开源软件构建，通过严格安全加固实现近零漏洞风险。  
- **漏洞管理与优先级划分**：支持 VEX 声明、KEV（已知被利用漏洞）和 EPSS（漏洞可利用性评分系统）评分，实现漏洞精准分类与优先级排序。  
- **合规性支持**：聚焦合规需求，提供 FIPS、STIG 合规选项及离线（air-gap）部署支持，包含安全物料清单（SBOM）。  
- **软件供应链溯源**：通过 in-toto 实现软件供应链来源验证，确保镜像构建过程的完整性与可追溯性。  
- **Helm Charts 兼容性**：原生支持主流 Helm Charts，与原 Debian 基础版镜像完全兼容，可无缝对接现有 Helm 部署流程。  


## 3. 使用场景与适用范围

该镜像适用于对安全性、合规性和供应链可信度有高要求的场景，包括但不限于：  

- 企业级深度学习训练与推理环境（基于 deepspeed 的分布式训练场景）。  
- 需满足严格安全合规标准（如 FIPS、STIG）的生产环境。  
- 对软件供应链安全有强需求，需验证镜像来源与构建过程的组织或项目。  
- 使用 Helm Charts 进行容器化部署，且需保障基础镜像安全性的场景。  


## 4. 使用方法与配置说明

### 4.1 获取商业版镜像

Bitnami Secure Image for deepspeed 商业版需通过订阅 Bitnami Secure Images 服务获取，具体步骤：  

1. 访问 [Bitnami 官网](https://bitnami.com/) 了解商业订阅详情。  
2. 订阅后，通过 Bitnami 提供的私有仓库或制品库获取 OCI 格式镜像（支持 Debian 或 Photon 基础版）。  


### 4.2 获取开发者版镜像（其他 Secure Images）

Docker Hub 提供其他 Bitnami Secure Images 的开发者版本（Trial 类型），获取方式：  

1. 访问 [Bitnami 公共应用目录](https://app-catalog.vmware.com/bitnami/apps)。  
2. 在筛选条件中选择 **Availability Type: Trial**，查找所需镜像并按指引下载。  


### 4.3 部署与配置

由于商业版镜像的具体部署配置依赖订阅后提供的官方文档，建议：  

- 订阅用户参考 Bitnami 提供的私有文档，获取镜像拉取命令、环境变量配置及 Helm Charts 使用指南。  
- 确保环境支持 OCI 制品拉取（如 Docker、containerd 等容器运行时）。  


## 5. 了解更多

如需了解 Bitnami Secure Images 商业版的详细信息，可访问 [Bitnami 官网](https://bitnami.com/)。
