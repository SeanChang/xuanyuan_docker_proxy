---
image: bitnami/phpmyadmin
description: "Bitnami提供的phpMyAdmin安全镜像，用于通过Web界面安全管理MySQL和MariaDB数据库。"
source: https://xuanyuan.cloud/zh/r/bitnami/phpmyadmin
canonical: https://xuanyuan.cloud/zh/r/bitnami/phpmyadmin
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/phpmyadmin" title="bitnami/phpmyadmin Docker 镜像中文简介、标签列表与拉取命令">bitnami/phpmyadmin — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/phpmyadmin" title="bitnami/phpmyadmin Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/phpmyadmin</a>

# Bitnami Secure Image for phpmyadmin

## 镜像概述和主要用途

本镜像为phpMyAdmin的Bitnami安全镜像。目前，该镜像已不再通过Docker Hub提供免费版本，而是作为构建好的OCI制品，通过Bitnami Secure Images的商业订阅服务提供，支持Debian和Photon两种基础操作系统格式。其主要用途是为企业用户提供安全加固的phpMyAdmin部署方案，用于数据库管理操作。

> 注：仍有其他Bitnami Secure Images以开发者版形式在Docker Hub提供，完整列表可访问[公共目录](https://app-catalog.vmware.com/bitnami/apps)并按“可用性类型：试用”筛选。

## 核心功能和特性

推荐从早期Debian基础镜像升级至基于Photon的Bitnami Secure Images，该类镜像与原Debian镜像的热门Helm charts完全兼容，并具备以下核心特性：

- **加固的安全镜像**：基于流行开源软件构建，实现近零漏洞（Near-Zero Vulnerabilities）的安全镜像。
- **漏洞分类与优先级管理**：提供漏洞分类与优先级划分，包含VEX声明、KEV（已知被利用漏洞）和EPSS（漏洞利用预测评分系统）评分。
- **合规性支持**：聚焦合规需求，支持FIPS、STIG标准及离线部署选项，包含安全物料清单（SBOM）。
- **软件供应链溯源证明**：通过in-toto实现软件供应链的来源证明与完整性验证。
- **Helm Charts支持**：对主流Helm charts提供一流支持，兼容互联网广泛使用的Helm charts。

## 使用场景和适用范围

本镜像适用于以下场景和范围：

- 企业环境中需要安全部署phpMyAdmin进行数据库管理的场景；
- 对系统安全性、合规性（如FIPS、STIG）及软件供应链安全有严格要求的组织；
- 需要使用Helm charts进行部署和管理的环境；
- 追求低漏洞风险、需安全加固镜像的应用场景。

## 使用方法和配置说明

由于本镜像为商业订阅服务，详细的使用方法、部署步骤及配置说明需通过Bitnami Secure Images商业订阅渠道获取。

### 兼容性说明

基于Photon的Bitnami Secure Images与原Debian基础镜像的热门Helm charts完全兼容，可沿用现有Helm charts进行部署管理，具体配置参数、环境变量及部署示例（如`docker run`命令、`docker-compose`配置等）请参考商业订阅提供的官方文档。

## 相关资源

- 了解更多关于Bitnami Secure Images商业产品：[访问官方网站](https://bitnami.com/)
- 查看可用的Bitnami Secure Images开发者版：[公共目录](https://app-catalog.vmware.com/bitnami/apps)
