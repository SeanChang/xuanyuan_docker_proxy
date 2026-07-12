---
image: bitnami/cassandra
description: "Bitnami安全镜像，用于部署和运行Cassandra分布式NoSQL数据库，提供安全加固的运行环境。"
source: https://xuanyuan.cloud/zh/r/bitnami/cassandra
canonical: https://xuanyuan.cloud/zh/r/bitnami/cassandra
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/cassandra" title="bitnami/cassandra Docker 镜像中文简介、标签列表与拉取命令">bitnami/cassandra 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Secure Image for Cassandra 技术文档


## 1. 镜像概述与主要用途

Bitnami Secure Image for Cassandra 是 Bitnami 提供的针对 Cassandra 数据库的安全加固镜像。该镜像目前不再通过 Docker Hub 免费提供，而是作为构建好的 OCI 制品，通过 Bitnami Secure Images 商业订阅服务提供，支持 Debian 和 Photon 两种基础操作系统格式。  

该镜像旨在为企业用户提供高安全性、合规性的 Cassandra 部署方案，兼容主流 Helm Charts，适用于对安全标准和供应链管理有严格要求的生产环境。


## 2. 核心功能与特性

升级至 Photon 基础 OS 的 Bitnami Secure Images 可带来以下核心优势：  

- **高安全性加固**：基于流行开源软件构建的硬化安全镜像，实现接近零漏洞（Near-Zero Vulnerabilities）  
- **漏洞管理能力**：提供漏洞分类与优先级排序，包含 VEX（漏洞利用状态）声明、KEV（已知被利用漏洞）和 EPSS（利用预测评分系统）评分  
- **合规性支持**：聚焦合规需求，提供 FIPS、STIG 标准支持及离线部署选项，包含安全物料清单（SBOM）  
- **供应链溯源**：通过 in-toto 实现软件供应链来源证明与完整性验证  
- **Helm Charts 兼容性**：对主流 Helm Charts 提供一流支持，确保与现有部署流程无缝衔接  


## 3. 使用场景与适用范围

该镜像适用于以下场景：  

- 企业级生产环境中 Cassandra 数据库的安全部署与运维  
- 对数据安全、漏洞管理有严格要求的金融、政府、医疗等行业  
- 需要满足 FIPS、STIG 等合规标准的关键业务系统  
- 使用 Helm Charts 进行容器化部署，且需保障供应链安全的场景  


## 4. 使用方法与配置说明

### 4.1 镜像获取

该镜像需通过 Bitnami Secure Images 商业订阅获取。订阅用户可获取 Debian 和 Photon 两种基础 OS 格式的 OCI 制品。详情请访问 [Bitnami 官方网站](https://bitnami.com/) 了解商业订阅方案。

### 4.2 兼容性说明

该镜像与原 Debian 基础的 Bitnami Cassandra 镜像完全兼容，可直接用于现有基于 Helm Charts 的部署流程，无需修改配置即可升级。

### 4.3 部署建议

由于镜像通过商业订阅提供，具体部署命令及配置需结合订阅服务提供的访问凭证和仓库地址。部署时需确保：  
- 已配置商业订阅提供的容器镜像仓库访问权限  
- 使用兼容的 Helm Charts 版本（建议使用 Bitnami 官方维护的 Cassandra Helm Chart）  


## 5. 更多信息

了解更多关于 Bitnami Secure Images 商业方案的信息，请访问 [Bitnami 官方网站](https://bitnami.com/)。
