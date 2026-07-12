---
image: bitnami/hubble-ui-backend
description: "Bitnami安全镜像，为Cilium Hubble开源用户界面提供所需的后端服务。"
source: https://xuanyuan.cloud/zh/r/bitnami/hubble-ui-backend
canonical: https://xuanyuan.cloud/zh/r/bitnami/hubble-ui-backend
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/hubble-ui-backend" title="bitnami/hubble-ui-backend Docker 镜像中文简介、标签列表与拉取命令">bitnami/hubble-ui-backend 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Hubble UI Backend 镜像

## 什么是 Hubble UI Backend？

> Hubble UI Backend 是 Cilium Hubble 开源用户界面所需的后端服务。

[Hubble UI Backend 概述](https://cilium.io/)  
商标声明：本软件列表由 Bitnami 打包。产品中提及的 respective 商标归各自公司所有，使用这些商标并不意味着任何关联或背书。

## 快速入门

```console
docker run --name hubble-ui-backend docker.xuanyuan.run/bitnami/hubble-ui-backend:latest
```

## ⚠️ 重要通知：Bitnami 镜像目录即将变更

自2025年8月28日起，Bitnami 将升级其公共镜像目录，通过新的 [Bitnami 安全镜像计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications) 提供精选的强化、安全聚焦型镜像。作为此次转型的一部分：

- 首次向社区用户提供流行容器镜像的安全优化版本。
- Bitnami 将开始在免费 tier 中弃用对非强化、基于 Debian 的软件镜像的支持，并逐步从公共目录中移除非最新标签。因此，社区用户将只能访问数量减少的强化镜像，这些镜像仅以“latest”标签发布，适用于开发目的。
- 从8月28日开始，在两周内，所有现有容器镜像（包括旧版本或特定版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用 Bitnami 安全镜像，包括强化容器、更小的攻击面、CVE 透明度（通过 VEX/KEV）、软件物料清单（SBOMs）和企业支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提升所有 Bitnami 用户的安全态势。更多详情，请访问 [Bitnami 安全镜像公告](https://github.com/bitnami/containers/issues/83267)。

## 为什么使用 Bitnami 安全镜像？

- Bitnami 安全镜像和 Helm 图表旨在使开源软件更安全且适合企业使用。
- 使用行业标准漏洞可利用性交换（VEX）、KEV 和 EPSS 评分，更快地分类安全漏洞，提高 CVE 风险透明度。
- 强化镜像采用最小化操作系统（Photon Linux），减少攻击面，同时通过行业标准包格式保持可扩展性。
- 通过持续构建的镜像（上游补丁发布后数小时内更新），保持更高的安全性和合规性。
- Bitnami 容器、虚拟机和云镜像使用相同的组件和配置方法，便于根据项目需求在不同格式间切换。
- 强化镜像附带证明签名（Notation）、软件物料清单、病毒扫描报告和其他元数据，这些均在符合 SLSA-3 标准的软件工厂中生成。

仅有部分 BSI 应用可免费获取。希望访问完整应用目录并获得企业支持？立即尝试 [Bitnami 安全镜像商业版](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)。

## 为什么使用非 root 容器？

非 root 容器镜像增加了额外的安全层，通常推荐用于生产环境。但由于它们以非 root 用户运行，特权任务通常受限。在我们的 [文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html) 中了解更多关于非 root 容器的信息。

## 支持的标签及对应的 `Dockerfile` 链接

在我们的 [文档页面](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html) 中了解更多关于 Bitnami 标签政策以及滚动标签和不可变标签之间的区别。

您可以通过查看分支文件夹中的 `tags-info.yaml` 文件（即 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）查看不同标签之间的对应关系。

通过关注 [bitnami/containers GitHub 仓库](https://github.com/bitnami/containers) 订阅项目更新。

## 获取此镜像

获取 Bitnami Hubble UI Backend Docker 镜像的推荐方式是从 [Docker Hub 仓库](https://hub.docker.com/r/bitnami/hubble-ui-backend) 拉取预构建镜像。

```console
docker pull docker.xuanyuan.run/bitnami/hubble-ui-backend:latest
```

如需使用特定版本，可拉取带版本的标签。您可以在 Docker Hub 仓库中查看 [可用版本列表](https://hub.docker.com/r/bitnami/hubble-ui-backend/tags/)。

```console
docker pull docker.xuanyuan.run/bitnami/hubble-ui-backend:[TAG]
```

如果需要，您也可以自行构建镜像：克隆仓库，进入包含 Dockerfile 的目录，执行 `docker build` 命令。请记得将以下示例命令中的 `APP`、`VERSION` 和 `OPERATING-SYSTEM` 路径占位符替换为正确的值。

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## 配置

Hubble UI Backend 是 Hubble 的组件。如需在 Kubernetes 上运行 Hubble，建议查看 [bitnami/hubble Helm chart](https://github.com/bitnami/charts/tree/master/bitnami/hubble) 并使用 values.yaml 文件中公开的选项进行配置。

有关该组件本身的更多信息，请参考 [官方 Hubble 文档](https://docs.cilium.io/en/stable/internals/hubble)。

### Bitnami 安全镜像中的 FIPS 配置

[Bitnami 安全镜像](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/) 目录中的 Bitnami Hubble UI Backend Docker 镜像包含额外功能和设置，可配置容器的 FIPS 功能。您可以配置以下环境变量：

- `OPENSSL_FIPS`：OpenSSL 是否运行在 FIPS 模式。`yes`（默认）、`no`。

## 贡献

我们欢迎您为此容器做出贡献。您可以通过创建 [issue](https://github.com/bitnami/containers/issues) 提出新功能请求，或提交 [pull request](https://github.com/bitnami/containers/pulls) 贡献代码。

## 问题反馈

如果运行此容器时遇到问题，可提交 [issue](https://github.com/bitnami/containers/issues/new/choose)。为了获得更好的支持，请务必填写 issue 模板。

## 许可证

Copyright &copy; 2025 Broadcom。术语“Broadcom”指 Broadcom Inc. 及其子公司。

根据 Apache 许可证 2.0 版（“许可证”）授权；除非遵守许可证，否则您不得使用此文件。您可以在以下位置获取许可证副本：

<http://www.apache.org/licenses/LICENSE-2.0>

除非适用法律要求或书面同意，否则根据许可证分发的软件按“原样”分发，不附带任何明示或暗示的保证或条件。有关许可证下权限和限制的具体语言，请参阅许可证。
