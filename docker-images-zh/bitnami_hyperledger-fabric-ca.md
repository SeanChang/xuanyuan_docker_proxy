---
image: bitnami/hyperledger-fabric-ca
description: "Bitnami提供的Hyperledger Fabric CA安全镜像，用于Fabric区块链框架中的身份管理，具备安全加固、最小化攻击面及软件供应链完整性支持，适用于区块链身份认证场景。"
source: https://xuanyuan.cloud/zh/r/bitnami/hyperledger-fabric-ca
canonical: https://xuanyuan.cloud/zh/r/bitnami/hyperledger-fabric-ca
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/hyperledger-fabric-ca" title="bitnami/hyperledger-fabric-ca Docker 镜像中文简介、标签列表与拉取命令">bitnami/hyperledger-fabric-ca 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Hyperledger Fabric CA 镜像

## 什么是 Hyperledger Fabric CA？

> Hyperledger Fabric CA 是 Fabric 区块链中的身份管理器。Hyperledger Fabric 是开源的许可制区块链框架。

[Hyperledger Fabric CA 概述](https://www.hyperledger.org/projects/fabric)  
商标声明：本软件列表由 Bitnami 打包。所提及的相应商标归各公司所有，使用这些商标并不意味着任何关联或认可。

## 快速入门

```console
docker run --name hyperledger-fabric-ca docker.xuanyuan.run/bitnami/hyperledger-fabric-ca:latest
```

## ⚠️ 重要通知：Bitnami 目录即将变更

自2025年8月28日起，Bitnami将升级其公共目录，通过新的[Bitnami安全镜像计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)提供精选的加固、安全聚焦镜像集。作为此过渡的一部分：

- 首次向社区用户提供热门容器镜像的安全优化版本访问权限。
- Bitnami将开始在免费层级中弃用对非加固、基于Debian的软件镜像的支持，并逐步从公共目录中移除非最新标签。因此，社区用户将只能访问数量减少的加固镜像，这些镜像仅以“latest”标签发布，适用于开发目的。
- 自8月28日起，在两周内，所有现有容器镜像（包括旧版或版本化标签，如2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用Bitnami安全镜像，包括加固容器、更小的攻击面、CVE透明度（通过VEX/KEV）、SBOM（软件物料清单）和企业支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提升所有Bitnami用户的安全态势。更多详情，请访问[Bitnami安全镜像公告](https://github.com/bitnami/containers/issues/83267)。

## 为什么使用 Bitnami 安全镜像？

- Bitnami安全镜像和Helm图表旨在使开源软件更安全且企业就绪。
- 更快地分类安全漏洞，通过行业标准漏洞可利用性交换（VEX）、KEV和EPSS评分透明了解CVE风险。
- 我们的加固镜像使用最小化操作系统（Photon Linux），减少攻击面，同时通过行业标准包格式保持可扩展性。
- 通过持续构建的镜像（上游补丁发布后数小时内更新），保持更高的安全性和合规性。
- Bitnami容器、虚拟机和云镜像使用相同的组件和配置方法，便于根据项目需求在不同格式间切换。
- 加固镜像附带证明签名（Notation）、SBOM、病毒扫描报告和其他元数据，在SLSA-3合规的软件工厂中生成。

仅有部分BSI应用可免费使用。希望访问完整应用目录及企业支持？立即尝试[Bitnami安全镜像商业版](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)。

## 支持的标签及相应 `Dockerfile` 链接

了解更多关于Bitnami标签政策以及滚动标签与不可变标签的区别，请参阅[我们的文档页面](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

您可通过查看分支文件夹中的`tags-info.yaml`文件（即`bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）了解不同标签之间的对应关系。

订阅项目更新，请关注[bitnami/containers GitHub仓库](https://github.com/bitnami/containers)。

## 获取此镜像

获取Bitnami Hyperledger Fabric CA Docker镜像的推荐方式是从[Docker Hub Registry](https://hub.docker.com/r/bitnami/hyperledger-fabric-ca)拉取预构建镜像。

```console
docker pull docker.xuanyuan.run/bitnami/hyperledger-fabric-ca:latest
```

如需使用特定版本，可拉取带版本的标签。您可在Docker Hub Registry中查看[可用版本列表](https://hub.docker.com/r/bitnami/hyperledger-fabric-ca/tags/)。

```console
docker pull docker.xuanyuan.run/bitnami/hyperledger-fabric-ca:[TAG]
```

如果您希望自行构建镜像，可克隆仓库，进入包含Dockerfile的目录，执行`docker build`命令。请记得将以下示例命令中的`APP`、`VERSION`和`OPERATING-SYSTEM`路径占位符替换为正确值。

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## 配置

### 运行命令

要在此容器内运行命令，可使用`docker run`，例如执行`fabric-ca-server start`，可参考以下示例：

```console
docker run --name git docker.xuanyuan.run/bitnami/hyperledger-fabric-ca:latest fabric-ca-server start
```

有关可用命令列表，请参阅[Hyperledger Fabric官方文档](https://hyperledger-fabric.readthedocs.io/en/latest/commands/fabric-ca-commands.html)。

### Bitnami安全镜像中的FIPS配置

来自[Bitnami安全镜像](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)目录的Bitnami Hyperledger Fabric CA Docker镜像包含额外功能和设置，可配置容器的FIPS（联邦信息处理标准）功能。您可配置以下环境变量：

- `OPENSSL_FIPS`：OpenSSL是否运行在FIPS模式。`yes`（默认）、`no`。

## 贡献

我们欢迎您为此容器贡献代码。您可通过创建[issue](https://github.com/bitnami/containers/issues)请求新功能，或提交[pull request](https://github.com/bitnami/containers/pulls)贡献代码。

## 问题

如果您在运行此容器时遇到问题，可提交[issue](https://github.com/bitnami/containers/issues/new/choose)。为帮助我们提供更好的支持，请务必填写issue模板。

## 许可证

版权所有 &copy; 2025 Broadcom。“Broadcom”一词指Broadcom Inc.及其子公司。

根据Apache许可证2.0版（“许可证”）授权；除非遵守许可证，否则您不得使用此文件。您可在以下位置获取许可证副本：

<http://www.apache.org/licenses/LICENSE-2.0>

除非适用法律要求或书面同意，否则根据许可证分发的软件按“原样”分发，不附带任何明示或暗示的保证或条件。有关许可证下权限和限制的具体语言，请参阅许可证。
