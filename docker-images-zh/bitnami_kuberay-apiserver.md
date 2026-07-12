---
image: bitnami/kuberay-apiserver
description: "Bitnami安全镜像，用于KubeRay API Server，是KubeRay的组件，作为Kubernetes operator管理Ray应用的API服务，提供安全加固的容器环境。"
source: https://xuanyuan.cloud/zh/r/bitnami/kuberay-apiserver
canonical: https://xuanyuan.cloud/zh/r/bitnami/kuberay-apiserver
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/kuberay-apiserver" title="bitnami/kuberay-apiserver Docker 镜像中文简介、标签列表与拉取命令">bitnami/kuberay-apiserver 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami KubeRay API Server 镜像

## 什么是 KubeRay API Server？

> APIServer 是 KubeRay 的组件。KubeRay 是一个 Kubernetes operator，通过 CustomResourceDefinitions 在 Kubernetes 上部署和管理 Ray 应用。

[KubeRay API Server 概述](https://ray.io)
商标声明：本软件列表由 Bitnami 打包。所提及的商标分别归各自公司所有，使用这些商标并不意味着任何关联或背书。

## 快速开始

```console
docker run -it --name kuberay-apiserver docker.xuanyuan.run/bitnami/kuberay-apiserver
```

## ⚠️ 重要通知：Bitnami 目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共目录，在新的[Bitnami 安全镜像计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)下提供精选的强化、安全聚焦镜像集。作为此次过渡的一部分：

- 首次向社区用户开放热门容器镜像的安全优化版本。
- Bitnami 将开始在免费层中弃用非强化的基于 Debian 的软件镜像，并逐渐从公共目录中移除非最新标签。因此，社区用户将可访问数量减少的强化镜像，这些镜像仅以“latest”标签发布，适用于开发目的。
- 从 8 月 28 日开始，在两周内，所有现有容器镜像（包括旧版本或版本化标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移到“Bitnami Legacy”仓库（docker.io/bitnamilegacy），不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用 Bitnami 安全镜像，包括强化容器、更小的攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 以及企业支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提高所有 Bitnami 用户的安全态势。更多详情，请访问[Bitnami 安全镜像公告](https://github.com/bitnami/containers/issues/83267)。

## 为什么使用 Bitnami 安全镜像？

- Bitnami 安全镜像和 Helm 图表旨在使开源更安全且适合企业使用。
- 使用行业标准漏洞可利用性交换（VEX）、KEV 和 EPSS 分数，更快地分类安全漏洞，提高 CVE 风险透明度。
- 我们的强化镜像使用最小化操作系统（Photon Linux），减少攻击面，同时通过行业标准包格式保持可扩展性。
- 通过持续构建的镜像（在 upstream 补丁发布后数小时内更新），保持更高的安全性和合规性。
- Bitnami 容器、虚拟机和云镜像使用相同的组件和配置方法，便于根据项目需求在不同格式之间切换。
- 强化镜像附带证明签名（Notation）、SBOM、病毒扫描报告和其他元数据，在符合 SLSA-3 的软件工厂中生成。

只有部分 BSI 应用可免费使用。希望访问完整的应用目录以及企业支持？立即尝试[Bitnami 安全镜像商业版](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)。

## 支持的标签及相应的 `Dockerfile` 链接

了解更多关于 Bitnami 标签策略以及滚动标签和不可变标签之间的区别，请参阅[我们的文档页面](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

您可以通过查看分支文件夹中的 `tags-info.yaml` 文件（即 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）查看不同标签之间的对应关系。

通过关注 [bitnami/containers GitHub 仓库](https://github.com/bitnami/containers) 订阅项目更新。

## 获取此镜像

获取 Bitnami KubeRay API Server Docker 镜像的推荐方式是从 [Docker Hub 仓库](https://hub.docker.com/r/bitnami/kuberay-apiserver) 拉取预构建镜像。

```console
docker pull docker.xuanyuan.run/bitnami/kuberay-apiserver:latest
```

要使用特定版本，您可以拉取带版本的标签。您可以在 Docker Hub 仓库中查看[可用版本列表](https://hub.docker.com/r/bitnami/kuberay-apiserver/tags/)。

```console
docker pull docker.xuanyuan.run/bitnami/kuberay-apiserver:[TAG]
```

如果需要，您也可以通过克隆仓库、进入包含 Dockerfile 的目录并执行 `docker build` 命令自行构建镜像。请记得将以下示例命令中的 `APP`、`VERSION` 和 `OPERATING-SYSTEM` 路径占位符替换为正确的值。

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## 维护

### 升级此镜像

Bitnami 提供最新版本的 KubeRay API Server，包括安全补丁，通常在 upstream 发布后不久。建议按照以下步骤升级容器。

#### 步骤 1：获取更新的镜像

```console
docker pull docker.xuanyuan.run/bitnami/kuberay-apiserver:latest
```

#### 步骤 2：移除当前运行的容器

```console
docker rm -v kuberay-apiserver
```

#### 步骤 3：运行新镜像

从新镜像重新创建容器。

```console
docker run --name kuberay-apiserver docker.xuanyuan.run/bitnami/kuberay-apiserver:latest
```

## 配置

### 运行命令

要在此容器内运行命令，您可以使用 `docker run`，例如执行 `apiserver --help`，可参考以下示例：

```console
docker run --rm --name kuberay-apiserver docker.xuanyuan.run/bitnami/kuberay-apiserver:latest --help
```

有关如何使用 KubeRay API Server 的更多信息，请查看[官方 KubeRay API Server 文档](https://ray.io)。

### Bitnami 安全镜像中的 FIPS 配置

来自 [Bitnami 安全镜像](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/) 目录的 Bitnami KubeRay API Server Docker 镜像包含额外功能和设置，可配置容器的 FIPS 功能。您可以配置以下环境变量：

- `OPENSSL_FIPS`：OpenSSL 是否以 FIPS 模式运行。`yes`（默认）、`no`。

## 重要变更

### 自 2024 年 1 月 16 日起

- `docker-compose.yaml` 文件已移除，该文件仅用于内部测试目的。

## 贡献

我们欢迎您为此 Docker 镜像做出贡献。您可以通过创建 [issue](https://github.com/bitnami/containers/issues) 请求新功能，或提交 [pull request](https://github.com/bitnami/containers/pulls) 贡献代码。

## 问题

如果您在运行此容器时遇到问题，可以提交 [issue](https://github.com/bitnami/containers/issues/new/choose)。为了让我们提供更好的支持，请务必填写 issue 模板。

## 许可证

版权所有 &copy; 2025 Broadcom。“Broadcom”一词指 Broadcom Inc. 及其子公司。

根据 Apache 许可证 2.0 版（“许可证”）授权；除非遵守许可证，否则您不得使用此文件。您可以在以下位置获取许可证副本：

<http://www.apache.org/licenses/LICENSE-2.0>

除非适用法律要求或书面同意，否则根据许可证分发的软件按“原样”分发，不附带任何明示或暗示的保证或条件。有关许可证下权限和限制的具体语言，请参阅许可证。
