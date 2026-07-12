---
image: bitnami/harbor-portal
description: "Bitnami提供的安全镜像，用于部署Harbor容器镜像仓库的Web门户组件，支持用户界面交互与镜像管理功能。"
source: https://xuanyuan.cloud/zh/r/bitnami/harbor-portal
canonical: https://xuanyuan.cloud/zh/r/bitnami/harbor-portal
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/harbor-portal" title="bitnami/harbor-portal Docker 镜像中文简介、标签列表与拉取命令">bitnami/harbor-portal 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Harbor 镜像文档


## 1. 镜像概述和主要用途

Bitnami Harbor镜像是基于开源项目Harbor构建的容器化解决方案。Harbor是一个可信云原生注册表，用于存储、签名和扫描内容，为开源Docker分发添加了安全、身份和管理等增强功能。该镜像主要用于在容器化环境中提供企业级镜像管理能力，支持镜像的全生命周期管理，包括存储、访问控制、漏洞扫描和数字签名验证。


## 2. 核心功能和特性

### 2.1 Harbor核心功能
- **安全增强**：提供镜像签名、漏洞扫描和访问控制机制，确保镜像供应链安全
- **身份管理**：支持LDAP/AD集成、RBAC权限控制，实现精细化的用户和团队管理
- **内容管理**：镜像版本控制、复制同步、垃圾回收等功能，优化镜像存储效率
- **多租户支持**：通过项目隔离实现多团队共享注册表，满足企业级多租户需求

### 2.2 Bitnami Secure Images特性
- **安全加固**：基于Photon Linux最小化操作系统，减少攻击面，符合安全最佳实践
- **漏洞透明**：通过VEX/KEV标准提供CVE风险透明度，附带EPSS评分，加速漏洞响应
- **持续更新**：上游补丁发布后数小时内完成镜像更新，确保安全补丁及时应用
- **合规性**：SLSA-3合规软件工厂生产，提供签名证明（Notation）、SBOMs和病毒扫描报告
- **跨格式一致性**：容器、虚拟机和云镜像使用相同组件和配置，便于多环境切换


## 3. 使用场景和适用范围

### 3.1 适用场景
- **开发测试环境**：使用`latest`标签快速部署Harbor，验证镜像管理流程
- **生产环境**：建议采用Bitnami Secure Images商业版，获得长期支持和企业级安全保障
- **Kubernetes集群**：作为容器镜像私有仓库，与K8s无缝集成，支持镜像拉取和推送

### 3.2 适用范围
- 企业级容器化应用开发团队
- 需要严格控制镜像质量和安全的组织
- 采用Kubernetes或Docker Swarm的容器编排环境


## 4. 使用方法和配置说明

### 4.1 Docker快速启动（开发测试用）
```bash
docker run --name harbor docker.xuanyuan.run/bitnami/harbor-portal:latest
```
> **注意**：该命令仅用于快速验证，生产环境需通过Helm Chart部署完整Harbor解决方案。

### 4.2 Kubernetes部署（推荐生产环境）
Bitnami Harbor主要设计用于Kubernetes环境，推荐通过Helm Chart部署：
```bash
# 添加Bitnami Helm仓库
helm repo add bitnami https://charts.bitnami.com/bitnami

# 部署Harbor
helm install harbor bitnami/harbor
```
详细配置参见[Bitnami Harbor Chart GitHub仓库](https://github.com/bitnami/charts/tree/main/bitnami/harbor)。

### 4.3 Docker Compose部署（仅开发测试）
以下`docker-compose.yaml`文件未经过生产测试，仅用于开发验证：
```yaml
version: '3'
services:
  harbor-portal:
    image: docker.xuanyuan.run/bitnami/harbor-portal:latest
    ports:
      - "80:8080"
    environment:
      - OPENSSL_FIPS=yes
```
> **警告**：生产环境请使用Bitnami Helm Chart，避免直接使用此Compose配置。


## 5. 配置参数说明

### 5.1 环境变量
| 环境变量 | 描述 | 默认值 | 可选值 |
|----------|------|--------|--------|
| `OPENSSL_FIPS` | 控制OpenSSL是否启用FIPS模式 | `yes` | `yes`/`no` |


## 6. 重要通知：Bitnami Catalog即将变更

### 6.1 变更概要（2025年8月28日生效）
- **镜像迁移**：所有现有容器镜像（含历史版本标签，如`2.50.0`、`10.6`）将从`docker.io/bitnami`迁移至`docker.io/bitnamilegacy`，且不再接收更新
- **标签策略调整**：免费版仅提供`latest`标签的加固镜像，非加固Debian基础镜像逐步停止支持
- **版本支持**：非`latest`标签将从公共 catalog 中移除，社区用户可访问的镜像数量减少

### 6.2 影响与建议
- **开发环境**：可继续使用`latest`标签的免费加固镜像
- **生产环境**：建议迁移至Bitnami Secure Images商业版，获取完整应用目录和企业支持
- **历史版本依赖**：需在2025年8月28日后从`bitnamilegacy`仓库拉取历史镜像

详细信息参见[Bitnami Secure Images公告](https://github.com/bitnami/containers/issues/83267)。


## 7. 非root容器说明

该镜像默认以非root用户运行，提供额外安全层，适用于生产环境。非root容器限制特权操作，但通过标准权限模型确保功能完整性。更多信息参见[Bitnami非root容器文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html)。


## 8. 支持的标签

Bitnami镜像遵循滚动标签和不可变标签策略：
- **滚动标签**：如`latest`，指向最新稳定版本，持续更新
- **不可变标签**：如`2.50.0`，绑定特定版本，2025年8月28日后迁移至`bitnamilegacy`仓库

标签策略详情参见[Bitnami标签文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。


## 9. 贡献与反馈

### 9.1 贡献指南
欢迎通过以下方式贡献：
- 提交[issue](https://github.com/bitnami/containers/issues)提出新功能需求
- 提交[pull request](https://github.com/bitnami/containers/pulls)贡献代码修复

### 9.2 问题反馈
如运行容器时遇到问题，请通过[issue模板](https://github.com/bitnami/containers/issues/new/choose)提交详细信息，以便快速定位问题。


## 10. 许可证

本镜像基于Apache License 2.0许可协议分发。您可在[Apache官网](http://www.apache.org/licenses/LICENSE-2.0)获取完整许可文本。

Copyright © 2025 Broadcom. "Broadcom"指Broadcom Inc.及其子公司。除非法律要求或书面同意，软件按"原样"分发，不提供任何明示或暗示的担保。
