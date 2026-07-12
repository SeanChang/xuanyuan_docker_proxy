---
image: bitnami/keycloak
description: "Bitnami安全Keycloak镜像，提供可靠的身份认证与访问管理功能，适合生产环境部署。"
source: https://xuanyuan.cloud/zh/r/bitnami/keycloak
canonical: https://xuanyuan.cloud/zh/r/bitnami/keycloak
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/keycloak" title="bitnami/keycloak Docker 镜像中文简介、标签列表与拉取命令">bitnami/keycloak 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Secure Image for Keycloak 技术文档


## 1. 镜像概述

Bitnami Secure Image for Keycloak 是 Bitnami 提供的 Keycloak 安全加固镜像，基于 Debian 或 Photon 操作系统构建，旨在为企业级应用提供高安全性的身份认证与授权解决方案。该镜像目前已不再通过 Docker Hub 免费提供，需通过 Bitnami 商业订阅获取。


## 2. 核心功能与特性

### 2.1 安全与合规能力
- **近零漏洞的安全加固**：基于开源 Keycloak 构建，经过安全加固处理，显著降低漏洞风险。
- **漏洞管理与优先级划分**：支持漏洞分类与优先级评估，提供 VEX（漏洞利用交换）声明、KEV（已知被利用漏洞）列表及 EPSS（Exploit Prediction Scoring System）评分，助力漏洞响应决策。
- **合规性支持**：满足 FIPS（联邦信息处理标准）、STIG（安全技术实施指南）等合规要求，提供 air-gap（离线）部署选项及安全物料清单（SBOM）。

### 2.2 软件供应链安全
- **供应链完整性证明**：通过 in-toto 框架提供软件供应链 provenance（来源） attestation（证明），确保镜像从构建到分发的完整性。

### 2.3 兼容性与生态支持
- **Helm Charts 兼容性**：完全兼容主流 Keycloak Helm Charts，可无缝替换原有 Debian 基础镜像，无需修改现有部署配置。
- **一流的 Helm Charts 支持**：针对社区常用 Helm Charts 提供优化，简化部署与管理流程。


## 3. 使用场景与适用范围

### 3.1 适用场景
- 企业级应用的身份认证与授权管理（如 SSO、OAuth2、OpenID Connect 实现）。
- 对安全性、合规性要求严格的行业场景（如金融、医疗、政府、能源等）。
- 需要保障软件供应链安全的组织或项目。
- 已采用 Bitnami Helm Charts 部署 Keycloak，并寻求安全升级的用户。

### 3.2 目标用户
- 需满足严格安全合规要求的企业 IT 团队。
- 关注开源软件供应链安全的 DevSecOps 团队。
- 寻求商业支持与长期维护保障的 Keycloak 用户。


## 4. 获取与订阅信息

### 4.1 订阅方式
该镜像目前仅通过 Bitnami 商业订阅提供，支持 Debian 和 Photon 两种基础操作系统格式的 OCI 制品。

### 4.2 了解更多
如需获取商业订阅详情或技术支持，可访问 [Bitnami 官方网站](https://bitnami.com/)。


## 5. 部署与使用说明

由于该镜像为商业订阅产品，具体部署命令（如 `docker run`、`docker-compose` 配置）、环境变量、配置参数及 Helm Charts 使用细节，需通过商业订阅后获取官方文档。订阅用户可获得：
- 完整的部署指南与最佳实践。
- 针对企业环境的定制化配置支持。
- 与原有 Debian 基础镜像兼容的迁移方案。


## 6. 注意事项

- **版本兼容性**：Photon-based 版本与原有 Debian 基础镜像的 Helm Charts 完全兼容，建议升级以获得更优的安全特性。
- **试用资源**：Bitnami 仍在 Docker Hub 提供部分 Secure Images 的开发者版（试用版），可通过 [VMware 应用目录](https://app-catalog.vmware.com/bitnami/apps) 筛选“可用性类型：试用”获取相关列表（Keycloak 镜像可能不在试用列表中，以目录实际内容为准）。
