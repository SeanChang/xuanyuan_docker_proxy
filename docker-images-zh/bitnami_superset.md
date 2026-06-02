---
image: bitnami/superset
description: "Bitnami安全镜像，用于部署Apache Superset，支持数据可视化与探索，具备安全强化特性。"
source: https://xuanyuan.cloud/zh/r/bitnami/superset
canonical: https://xuanyuan.cloud/zh/r/bitnami/superset
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/superset" title="bitnami/superset Docker 镜像中文简介、标签列表与拉取命令">bitnami/superset — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/superset" title="bitnami/superset Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/superset</a>

# Bitnami Secure Image for superset

## 1. 镜像概述与主要用途

### 1.1 概述
Bitnami Secure Image for superset是Bitnami推出的针对superset的安全加固镜像。该镜像目前已不再通过Docker Hub免费提供，而是作为构建完成的OCI制品，通过Bitnami Secure Images商业订阅服务提供，支持Debian和Photon两种基础操作系统格式。

### 1.2 主要用途
为superset提供经过安全加固的运行环境，适用于企业级部署场景，满足对系统安全性、合规性及软件供应链完整性有严格要求的用户需求，保障superset应用在生产环境中的稳定与安全运行。

## 2. 核心功能与特性

- **近零漏洞的加固安全镜像**：基于流行开源软件构建，经过专业安全加固，实现近零漏洞风险，提升应用运行安全性
- **漏洞分类与优先级管理**：支持漏洞分类与优先级评估，提供VEX（漏洞利用交换）声明、KEV（已知被利用漏洞）清单及EPSS（利用预测评分系统）评分，助力用户高效管理漏洞风险
- **全面合规性支持**：聚焦合规需求，支持FIPS（联邦信息处理标准）、STIG（安全技术实施指南）及空气隔离（air-gap）部署选项，并提供安全物料清单（SBOM），满足企业合规审计要求
- **软件供应链完整性证明**：通过in-toto实现软件供应链来源证明，确保镜像从构建到分发的全流程可追溯，保障软件供应链安全
- **Helm Charts原生支持**：与主流Helm Charts完全兼容，提供对互联网热门Helm Charts的一流支持，简化部署与集成流程

## 3. 适用场景与用户范围

- **企业级生产环境**：适用于对安全性、稳定性要求极高的企业级superset部署场景
- **合规性敏感场景**：满足金融、政务、医疗等对FIPS、STIG等合规标准有强制要求的行业用户
- **安全加固需求用户**：需要近零漏洞防护、软件供应链安全保障及专业支持的组织或团队

## 4. 获取与订阅信息

该镜像需通过Bitnami Secure Images商业订阅获取。订阅用户可获取Debian和Photon两种基础OS格式的OCI制品，并享受相关技术支持服务。详细订阅方案及商业服务信息，请访问[Bitnami官方网站](https://bitnami.com/)。

## 5. 推荐升级建议

对于当前使用旧版Debian基础Bitnami镜像的用户，推荐升级至基于Photon的Bitnami Secure Images，主要优势包括：

- 与原Debian镜像使用的流行Helm Charts完全兼容，无需修改现有部署配置即可无缝迁移
- 获得更高级别的安全加固，显著降低漏洞风险
- 享受商业订阅提供的专业技术支持服务
- 增强合规性支持与软件供应链安全性保障

## 6. 注意事项

- 该镜像已从Docker Hub移除免费访问渠道，仅通过商业订阅提供
- 开发者版Bitnami Secure Images仍可在Docker Hub获取部分其他开源软件镜像，完整列表可通过[公开目录](https://app-catalog.vmware.com/bitnami/apps)筛选“Availability Type: Trial”查看
