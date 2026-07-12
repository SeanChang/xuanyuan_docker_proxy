---
image: bitnami/victoriametrics-vmstorage
description: "Bitnami提供的VictoriaMetrics Storage安全镜像，是高性能、经济且可扩展的时序数据库和监控解决方案，兼容Prometheus和Graphite，适用于高效存储和查询时序数据。"
source: https://xuanyuan.cloud/zh/r/bitnami/victoriametrics-vmstorage
canonical: https://xuanyuan.cloud/zh/r/bitnami/victoriametrics-vmstorage
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/victoriametrics-vmstorage" title="bitnami/victoriametrics-vmstorage Docker 镜像中文简介、标签列表与拉取命令">bitnami/victoriametrics-vmstorage 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami VictoriaMetrics Storage 镜像

## 什么是 VictoriaMetrics Storage？

> VictoriaMetrics 是一个快速、经济且可扩展的监控解决方案和时序数据库，兼容 Prometheus 和 Graphite。

[VictoriaMetrics Storage 概述](https://victoriametrics.com/)  
商标说明：本软件列表由 Bitnami 打包。所提及的相关商标归各自公司所有，使用这些商标并不意味着任何关联或认可。

## 快速启动

```console
docker run --name victoriametrics-vmstorage docker.xuanyuan.run/bitnami/victoriametrics-vmstorage:latest
```

## ⚠️ 重要通知：Bitnami 目录即将变更

自2025年8月28日起，Bitnami 将升级其公共目录，通过新的[Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)提供精选的强化、安全聚焦镜像。此过渡包括：

- 首次向社区用户开放流行容器镜像的安全优化版本。
- Bitnami 将开始在免费层级中弃用对非强化 Debian 基础软件镜像的支持，并逐步从公共目录中移除非最新标签。因此，社区用户将只能访问数量减少的强化镜像，这些镜像仅以“latest”标签发布，适用于开发目的。
- 自8月28日起，两周内所有现有容器镜像（包括旧版本或特定版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用 Bitnami Secure Images，包括强化容器、更小的攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 以及企业级支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提升所有 Bitnami 用户的安全态势。更多详情，请访问 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。

## 为什么使用 Bitnami 安全镜像？

- Bitnami 安全镜像和 Helm 图表旨在让开源软件更安全且具备企业级就绪性。
- 通过行业标准漏洞可利用性交换（VEX）、KEV 和 EPSS 分数，更快地分类安全漏洞，透明了解 CVE 风险。
- 强化镜像使用最小化操作系统（Photon Linux），减少攻击面的同时通过行业标准包格式保持可扩展性。
- 持续构建的镜像在 upstream 补丁发布后数小时内更新，保持更高的安全性和合规性。
- Bitnami 容器、虚拟机和云镜像使用相同的组件和配置方法，便于根据项目需求在不同格式间切换。
- 强化镜像附带证明签名（Notation）、SBOM、病毒扫描报告和其他元数据，通过 SLSA-3 合规的软件工厂生成。

仅有部分 BSI 应用可免费获取。如需访问完整应用目录及企业级支持，请尝试 [Bitnami Secure Images 商业版](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)。

## 支持的标签及对应的 `Dockerfile` 链接

了解更多关于 Bitnami 标签策略以及滚动标签与不可变标签的区别，请参阅 [官方文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

您可通过查看分支文件夹中的 `tags-info.yaml` 文件（如 `bitnami/APP/BRANCH/DISTRO/tags-info.yaml`）了解不同标签之间的对应关系。

订阅项目更新，请关注 [bitnami/containers GitHub 仓库](https://github.com/bitnami/containers)。

## 获取此镜像

获取 Bitnami VictoriaMetrics Storage Docker 镜像的推荐方式是从 [Docker Hub 仓库](https://hub.docker.com/r/bitnami/victoriametrics-vmstorage) 拉取预构建镜像。

```console
docker pull docker.xuanyuan.run/bitnami/victoriametrics-vmstorage:latest
```

如需使用特定版本，可拉取带版本的标签。您可在 Docker Hub 仓库查看 [可用版本列表](https://hub.docker.com/r/bitnami/victoriametrics-vmstorage/tags/)。

```console
docker pull docker.xuanyuan.run/bitnami/victoriametrics-vmstorage:[标签]
```

如需自行构建镜像，可克隆仓库，进入包含 Dockerfile 的目录，执行 `docker build` 命令。请将以下示例命令中的 `APP`、`VERSION` 和 `OPERATING-SYSTEM` 占位符替换为正确值。

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## 为什么使用非 root 容器？

非 root 容器增加了额外的安全层，通常推荐用于生产环境。但由于以非 root 用户运行，特权任务通常受限。了解更多关于非 root 容器的信息，请参阅 [Bitnami 文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html)。

## 配置

### 运行命令

如需在容器内运行命令，可使用 `docker run`。例如，执行 `vmstorage --help` 命令如下：

```console
docker run --rm --name victoriametrics-vmstorage docker.xuanyuan.run/bitnami/victoriametrics-vmstorage:latest -- --help
```

更多信息，请查看 [VictoriaMetrics Storage 官方文档](https://victoriametrics.com/)。

## 贡献

我们欢迎您为此容器贡献代码。您可通过创建 [issue](https://github.com/bitnami/containers/issues) 请求新功能，或提交 [pull request](https://github.com/bitnami/containers/pulls) 贡献代码。

## 问题反馈

如在运行此容器时遇到问题，可提交 [issue](https://github.com/bitnami/containers/issues/new/choose)。为获得更好支持，请务必填写 issue 模板。

## 许可证

版权所有 &copy; 2025 Broadcom。“Broadcom”一词指 Broadcom Inc. 及其子公司。

根据 Apache 许可证 2.0 版（“许可证”）授权；除非遵守许可证，否则您不得使用此文件。您可在以下位置获取许可证副本：

<http://www.apache.org/licenses/LICENSE-2.0>

除非适用法律要求或书面同意，否则根据许可证分发的软件按“原样”分发，不提供任何明示或暗示的担保或条件。有关许可证下权限和限制的具体语言，请参阅许可证。
