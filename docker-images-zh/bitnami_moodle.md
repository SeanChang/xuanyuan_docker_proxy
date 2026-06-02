---
image: bitnami/moodle
description: "Bitnami提供的Moodle安全镜像，用于快速部署安全、预配置的开源学习管理系统。"
source: https://xuanyuan.cloud/zh/r/bitnami/moodle
canonical: https://xuanyuan.cloud/zh/r/bitnami/moodle
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/moodle" title="bitnami/moodle Docker 镜像中文简介、标签列表与拉取命令">bitnami/moodle — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/moodle" title="bitnami/moodle Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/moodle</a>

# Bitnami Secure Image for moodle 技术文档


## 1. 镜像概述和主要用途

### 1.1 基本信息
Bitnami Secure Image for moodle 是针对 Moodle 平台的安全加固镜像，旨在提供高安全性、合规性的部署选项。

### 1.2 可用性说明
- 该镜像**不再通过 Docker Hub 免费提供**，目前仅作为构建后的 OCI 制品，支持 Debian 和 Photon 两种基础操作系统格式，需通过 Bitnami Secure Images 商业订阅获取。
- 其他 Bitnami Secure Images 仍在 Docker Hub 提供开发者版，完整列表可通过 [公共目录](https://app-catalog.vmware.com/bitnami/apps) 筛选“可用性类型：试用版”(Availability Type: Trial) 查看。


## 2. 核心功能和特性

推荐从早期 Debian 基础镜像升级至 Photon-based Bitnami Secure Images，其与原 Debian 版本的热门 Helm Charts 完全兼容，并带来以下核心优势：

- **近零漏洞的开源软件加固安全镜像**：基于 Photon 系统构建，针对开源软件进行深度安全加固，显著降低漏洞风险。
- **漏洞分类与优先级排序**：支持 VEX 声明、KEV（已知被利用漏洞）和 EPSS（漏洞利用预测评分系统）评分，便于精准管理漏洞。
- **合规性聚焦**：支持 FIPS（联邦信息处理标准）、STIG（安全技术实施指南）及离线部署选项，包含安全物料清单（SBOM）。
- **软件供应链溯源验证**：通过 in-toto 实现软件供应链来源证明，确保镜像构建过程的完整性和可追溯性。
- **一流的 Helm Charts 支持**：原生支持主流 Helm Charts，兼容互联网广泛使用的部署配置。


## 3. 使用场景和适用范围

该镜像适用于对安全性、合规性及软件供应链完整性有严格要求的企业级用户，具体场景包括：
- 部署 Moodle 平台的企业或教育机构，需满足行业合规标准（如 FIPS、STIG）。
- 对漏洞管理和安全加固有高需求的组织，需降低开源软件部署风险。
- 依赖 Helm Charts 进行标准化部署，且需要长期技术支持的生产环境。


## 4. 使用方法和配置说明

### 4.1 获取方式
Bitnami Secure Image for moodle 需通过商业订阅获取，详情可访问 [Bitnami 官方网站](https://bitnami.com/) 了解商业套餐。

### 4.2 兼容性说明
- 与原 Debian 基础版本的 Bitnami Helm Charts 完全兼容，可无缝升级现有部署。
- 支持 Photon 和 Debian 两种基础操作系统格式，可根据环境需求选择。

### 4.3 进一步信息
如需了解更多关于 Bitnami Secure Images 商业方案的技术细节、订阅流程或支持服务，可访问 [Bitnami 官方网站](https://bitnami.com/) 获取详细资料。
