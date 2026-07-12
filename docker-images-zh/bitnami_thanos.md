---
image: bitnami/thanos
description: "Bitnami提供的Thanos安全镜像，用于部署Prometheus高可用及长期存储解决方案，具备安全加固特性。"
source: https://xuanyuan.cloud/zh/r/bitnami/thanos
canonical: https://xuanyuan.cloud/zh/r/bitnami/thanos
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/thanos" title="bitnami/thanos Docker 镜像中文简介、标签列表与拉取命令">bitnami/thanos 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Secure Image for thanos 技术文档


## 1. 镜像概述与主要用途

Bitnami Secure Image for thanos 是 Bitnami 提供的 Thanos 安全镜像，旨在为 Thanos 部署提供经过加固的运行环境。该镜像目前已不再通过 Docker Hub 免费提供，而是作为商业订阅服务的一部分，提供基于 Debian 和 Photon 两种基础操作系统格式的构建 OCI 制品。同时，Docker Hub 上仍提供其他 Bitnami Secure Images 的开发者版本（可通过 [公开目录](https://app-catalog.vmware.com/bitnami/apps) 筛选“Availability Type: Trial”获取）。


## 2. 核心功能与特性

推荐从早期 Debian 镜像升级至基于 Photon 的 Bitnami Secure Images，其与原 Debian 镜像兼容相同的热门 Helm charts，并具备以下核心特性：

- **近零漏洞的安全加固**：基于开源软件构建的加固安全镜像，显著降低漏洞风险。  
- **漏洞管理与优先级划分**：支持通过 VEX 声明、KEV（已知被利用漏洞）和 EPSS（漏洞利用预测评分系统）评分进行漏洞分类与优先级排序。  
- **合规性聚焦**：支持 FIPS、STIG 合规标准，提供离线部署选项，包含安全物料清单（SBOM）。  
- **软件供应链溯源**：通过 in-toto 实现软件供应链来源证明，确保镜像完整性与可追溯性。  
- **Helm charts 一流支持**：原生支持主流 Helm charts，适配互联网广泛使用的部署配置。  


## 3. 使用场景与适用范围

该镜像适用于对安全性、合规性及供应链可信度有较高要求的场景，包括：  
- 企业级生产环境中 Thanos 的安全部署；  
- 需满足行业合规标准（如金融、医疗、政府领域的 FIPS/STIG 要求）的场景；  
- 依赖 Helm charts 进行应用编排与管理的环境；  
- 对软件供应链安全有严格要求，需确保镜像来源可追溯、漏洞风险可控的组织。  


## 4. 使用方法与配置说明

### 4.1 镜像获取方式  
Bitnami Secure Image for thanos 需通过商业订阅获取。订阅后可获取 Debian 和 Photon 基础 OS 格式的 OCI 制品。  

### 4.2 部署与配置指引  
具体部署步骤、配置参数及环境变量说明，请通过以下方式获取：  
- 访问 [Bitnami 官方网站](https://bitnami.com/) 了解商业订阅详情；  
- 联系 Bitnami 支持团队获取针对性部署文档与技术支持。  

### 4.3 升级建议  
对于当前使用 Debian 基础 Bitnami 镜像的用户，建议升级至 Photon-based 版本，以获得上述安全与合规增强特性，且与现有 Helm charts 完全兼容。  


## 5. 更多信息  
如需了解商业版 Bitnami Secure Images 的完整功能与订阅方案，请访问 [Bitnami 官方网站](https://bitnami.com/)。
