---
image: bitnami/cainjector
description: "Bitnami CA Injector安全镜像是用于配置cert-manager webhooks CA证书的命令行工具，帮助自动化管理Kubernetes环境中的TLS证书颁发与维护。"
source: https://xuanyuan.cloud/zh/r/bitnami/cainjector
canonical: https://xuanyuan.cloud/zh/r/bitnami/cainjector
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/cainjector" title="bitnami/cainjector Docker 镜像中文简介、标签列表与拉取命令">bitnami/cainjector 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami CA Injector镜像

## 什么是CA Injector？

> CA Injector是一款命令行工具，用于配置cert-manager webhooks的CA证书。cert-manager是Kubernetes的一个附加组件，用于自动化管理和颁发来自各种签发源的TLS证书。

[CA Injector概述](https://github.com/jetstack/cert-manager)  
商标声明：本软件列表由Bitnami打包。产品中提及的各商标分别归其各自公司所有，使用这些商标并不意味着任何关联或背书。

## 快速启动

```console
docker run --name cainjector -e ALLOW_EMPTY_PASSWORD=yes docker.xuanyuan.run/bitnami/cainjector:latest
```

**警告**：这些快速设置仅适用于开发环境。建议您更改不安全的默认凭据，并查看[配置](#配置)部分中的可用配置选项，以实现更安全的部署。

## 先决条件

支持`CustomResourceDefinition`或`ThirdPartyResource`的Kubernetes集群

## ⚠️ 重要通知：Bitnami Catalog即将变更

自2025年8月28日起，Bitnami将升级其公共目录，通过新的[Bitnami安全镜像计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)提供精选的强化、安全聚焦型镜像。作为此次转型的一部分：

- 首次向社区用户开放流行容器镜像的安全优化版本访问权限。
- Bitnami将开始在免费层中弃用对非强化、基于Debian的软件镜像的支持，并将逐步从公共目录中移除非最新标签。因此，社区用户将只能访问数量减少的强化镜像，这些镜像仅以“latest”标签发布，适用于开发目的。
- 从8月28日开始，在两周内，所有现有容器镜像（包括旧版本或特定版本标签，如2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），迁移后将不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用Bitnami安全镜像，包括强化容器、更小的攻击面、CVE透明度（通过VEX/KEV）、软件物料清单（SBOMs）和企业支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，改善所有Bitnami用户的安全状况。更多详情，请访问[Bitnami安全镜像公告](https://github.com/bitnami/containers/issues/83267)。

## 为什么使用Bitnami安全镜像？

- Bitnami安全镜像和Helm图表旨在提高开源软件的安全性和企业就绪性。
- 使用行业标准漏洞可利用性交换（VEX）、已知被利用漏洞（KEV）和EPSS评分，更快地分类安全漏洞，透明了解CVE风险。
- 我们的强化镜像使用最小化操作系统（Photon Linux），减少攻击面，同时通过行业标准包格式保持可扩展性。
- 通过持续构建的镜像（上游补丁发布后数小时内更新），保持更高的安全性和合规性。
- Bitnami容器、虚拟机和云镜像使用相同的组件和配置方法——便于根据项目需求在不同格式之间切换。
- 强化镜像附带证明签名（Notation）、SBOMs、病毒扫描报告和其他元数据，这些均在符合SLSA-3标准的软件工厂中生成。

仅有部分BSI应用可免费使用。希望访问完整的应用目录并获得企业支持？立即尝试[Bitnami安全镜像商业版](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)。

## 为什么使用非root容器？

非root容器镜像增加了额外的安全层，通常推荐用于生产环境。然而，由于它们以非root用户运行，通常无法执行特权任务。在我们的[文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html)中了解更多关于非root容器的信息。

## 支持的标签及对应的Dockerfile链接

了解Bitnami的标签政策以及滚动标签和不可变标签之间的区别，请参阅我们的[文档页面](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

您可以通过查看分支文件夹中的`tags-info.yaml`文件（即`bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）了解不同标签之间的对应关系。

通过关注[bitnami/containers GitHub仓库](https://github.com/bitnami/containers)订阅项目更新。

## 配置

### 进一步文档

更多文档，请查看[此处](https://github.com/jetstack/cert-manager/blob/master/docs)

### Bitnami安全镜像中的FIPS配置

[Bitnami安全镜像](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)目录中的Bitnami CA Injector Docker镜像包含额外功能和设置，可将容器配置为具备FIPS能力。您可以配置以下环境变量：

- `OPENSSL_FIPS`：OpenSSL是否以FIPS模式运行。可选值：`yes`（默认）、`no`。

## 显著变更

### 自2024年1月16日起

- `docker-compose.yaml`文件已被移除，该文件仅用于内部测试目的。

## 贡献

我们欢迎您为该容器做出贡献。您可以通过创建[issue](https://github.com/bitnami/containers/issues)请求新功能，或提交[pull request](https://github.com/bitnami/containers/pulls)贡献代码。

## 问题

如果您在运行此容器时遇到问题，可以提交[issue](https://github.com/bitnami/containers/issues/new/choose)。为了获得更好的支持，请务必填写issue模板。

## 许可证

版权所有 &copy; 2025 Broadcom。"Broadcom"一词指Broadcom Inc.及其子公司。

根据Apache许可证2.0版（"许可证"）授权；除非遵守许可证，否则您不得使用此文件。您可以在以下位置获取许可证副本：

<http://www.apache.org/licenses/LICENSE-2.0>

除非适用法律要求或书面同意，否则根据许可证分发的软件按"原样"分发，不附带任何明示或暗示的保证或条件。有关许可证下权限和限制的具体语言，请参阅许可证。
