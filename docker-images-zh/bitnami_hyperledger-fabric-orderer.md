---
image: bitnami/hyperledger-fabric-orderer
description: "Bitnami安全镜像，用于Hyperledger Fabric Orderer，负责Fabric区块链网络中的交易处理，提供安全加固、最小化攻击面和供应链安全保障，适用于开发和生产环境的区块链部署。"
source: https://xuanyuan.cloud/zh/r/bitnami/hyperledger-fabric-orderer
canonical: https://xuanyuan.cloud/zh/r/bitnami/hyperledger-fabric-orderer
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/hyperledger-fabric-orderer" title="bitnami/hyperledger-fabric-orderer Docker 镜像中文简介、标签列表与拉取命令">bitnami/hyperledger-fabric-orderer 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Hyperledger Fabric Orderer 镜像

## 什么是 Hyperledger Fabric Orderer？

> Hyperledger Fabric Orderer负责Fabric区块链内的交易处理。Hyperledger Fabric是开源的许可区块链框架。

[Hyperledger Fabric Orderer概述](https://www.hyperledger.org/projects/fabric)  
商标说明：本软件列表由Bitnami打包。所提及的相关商标归各自公司所有，使用这些商标并不意味着任何关联或认可。

## 快速启动

```console
docker run --name hyperledger-fabric-orderer docker.xuanyuan.run/bitnami/hyperledger-fabric-orderer:latest
```

## ⚠️ 重要通知：Bitnami 镜像目录即将变更

自2025年8月28日起，Bitnami将升级其公共镜像目录，通过新的[Bitnami Secure Images计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)提供精选的安全加固镜像集。此次过渡包括：

- 首次向社区用户开放热门容器镜像的安全优化版本访问权限。
- Bitnami将开始在免费层中弃用非加固的基于Debian的软件镜像，并逐步从公共目录中移除非最新标签。因此，社区用户将只能访问数量减少的加固镜像，这些镜像仅以“latest”标签发布，适用于开发目的。
- 自8月28日起，在两周内，所有现有容器镜像（包括旧版本或特定版本标签，如2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用Bitnami Secure Images，包括加固容器、更小的攻击面、CVE透明度（通过VEX/KEV）、软件物料清单（SBOMs）和企业支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提升所有Bitnami用户的安全态势。更多详情请访问[Bitnami Secure Images公告](https://github.com/bitnami/containers/issues/83267)。

## 为什么使用 Bitnami 安全镜像？

- Bitnami安全镜像和Helm图表旨在使开源软件更安全、更适合企业使用。
- 通过行业标准漏洞可利用性交换（VEX）、已知被利用漏洞（KEV）和EPSS评分，更快地分类安全漏洞，提高CVE风险透明度。
- 加固镜像使用最小化操作系统（Photon Linux），减少攻击面，同时通过行业标准包格式保持可扩展性。
- 通过上游补丁发布后数小时内更新的持续构建镜像，保持更高的安全性和合规性。
- Bitnami容器、虚拟机和云镜像使用相同的组件和配置方法，便于根据项目需求在不同格式间切换。
- 加固镜像附带证明签名（Notation）、SBOMs、病毒扫描报告和其他元数据，通过SLSA-3合规的软件工厂生成。

仅有部分BSI应用可免费使用。如需访问完整应用目录及企业支持，请试用[Bitnami Secure Images商业版](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)。

## 支持的标签及对应 `Dockerfile` 链接

了解Bitnami标签政策以及滚动标签与不可变标签的区别，请参阅[文档页面](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

可通过查看分支文件夹中的`tags-info.yaml`文件（如`bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）了解不同标签的对应关系。

订阅项目更新，请关注[bitnami/containers GitHub仓库](https://github.com/bitnami/containers)。

## 获取镜像

获取Bitnami Hyperledger Fabric Orderer Docker镜像的推荐方式是从[Docker Hub Registry](https://hub.docker.com/r/bitnami/hyperledger-fabric-orderer)拉取预构建镜像。

```console
docker pull docker.xuanyuan.run/bitnami/hyperledger-fabric-orderer:latest
```

如需使用特定版本，可拉取带版本的标签。可在Docker Hub Registry查看[可用版本列表](https://hub.docker.com/r/bitnami/hyperledger-fabric-orderer/tags/)。

```console
docker pull docker.xuanyuan.run/bitnami/hyperledger-fabric-orderer:[TAG]
```

也可自行构建镜像：克隆仓库，进入包含Dockerfile的目录，执行`docker build`命令。请将以下示例中的`APP`、`VERSION`和`OPERATING-SYSTEM`路径占位符替换为实际值。

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## 配置

### 运行命令

可使用`docker run`在容器内运行命令，例如执行`peer version`：

```console
docker run --name git docker.xuanyuan.run/bitnami/hyperledger-fabric-orderer:latest peer version
```

有关可用命令列表，请参阅[Hyperledger Fabric官方文档](https://hyperledger-fabric.readthedocs.io/en/latest/command_ref.html)。

### Bitnami安全镜像中的FIPS配置

[Bitnami Secure Images](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)目录中的Bitnami Hyperledger Fabric Orderer Docker镜像包含额外功能和设置，可配置容器的FIPS能力。可配置以下环境变量：

- `OPENSSL_FIPS`：OpenSSL是否运行在FIPS模式。`yes`（默认）、`no`。

## 贡献

我们欢迎您为该容器贡献代码。可通过创建[issue](https://github.com/bitnami/containers/issues)请求新功能，或提交[pull request](https://github.com/bitnami/containers/pulls)贡献代码。

## 问题反馈

如运行容器时遇到问题，可提交[issue](https://github.com/bitnami/containers/issues/new/choose)。为获得更好支持，请填写issue模板。

## 许可

Copyright &copy; 2025 Broadcom。“Broadcom”指Broadcom Inc.及其子公司。

根据Apache License 2.0许可（“许可”）授权；除非遵守许可，否则不得使用本软件。

可在以下地址获取许可副本：

<http://www.apache.org/licenses/LICENSE-2.0>

除非适用法律要求或书面同意，否则软件按“原样”分发，不提供任何明示或暗示的保证或条件。详见许可协议中有关权限和限制的具体规定。
