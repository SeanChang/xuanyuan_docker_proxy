---
image: bitnami/nginx-exporter
description: "Bitnami安全镜像，用于NGINX Prometheus Exporter，支持通过Prometheus监控NGINX或NGINX Plus，提供安全加固、最小化攻击面、FIPS配置及持续更新等企业级特性。"
source: https://xuanyuan.cloud/zh/r/bitnami/nginx-exporter
canonical: https://xuanyuan.cloud/zh/r/bitnami/nginx-exporter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/nginx-exporter" title="bitnami/nginx-exporter Docker 镜像中文简介、标签列表与拉取命令">bitnami/nginx-exporter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami NGINX Exporter 镜像

## 关于 NGINX Exporter

> NGINX Prometheus Exporter 使通过 Prometheus 监控 NGINX 或 NGINX Plus 成为可能。

[NGINX Exporter 概述](https://github.com/nginxinc/nginx-prometheus-exporter)  
商标说明：本软件列表由 Bitnami 打包。产品中提及的各商标分属相应公司所有，使用这些商标并不意味着任何关联或背书。

## 快速启动

```console
docker run --name nginx-exporter docker.xuanyuan.run/bitnami/nginx-exporter:latest
```

## ⚠️ 重要通知：Bitnami 镜像目录即将变更

自2025年8月28日起，Bitnami 将升级其公共镜像目录，通过新的 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications) 提供精选的加固、安全聚焦镜像。此次变更包括：

- 首次向社区用户开放热门容器镜像的安全优化版本。
- Bitnami 将开始在免费层中弃用对非加固、基于 Debian 的软件镜像的支持，并逐步从公共目录中移除非最新标签。因此，社区用户将只能访问数量减少的加固镜像，这些镜像仅以“latest”标签发布，适用于开发目的。
- 自8月28日起，两周内所有现有容器镜像（包括旧版本或特定版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用 Bitnami Secure Images，包括加固容器、更小攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 和企业支持。

这些变更旨在通过推广软件供应链完整性最佳实践和最新部署，提升所有 Bitnami 用户的安全态势。更多详情请访问 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。

## 为何使用 Bitnami 安全镜像？

- Bitnami 安全镜像和 Helm 图表旨在使开源软件更安全、更适合企业使用。
- 通过行业标准漏洞可利用性交换 (VEX)、KEV 和 EPSS 评分，更快地分类安全漏洞，提高 CVE 风险透明度。
- 加固镜像使用最小化操作系统（Photon Linux），减少攻击面，同时通过行业标准包格式保持可扩展性。
- 通过上游补丁发布后数小时内更新的持续构建镜像，保持更高的安全性和合规性。
- Bitnami 容器、虚拟机和云镜像使用相同的组件和配置方法，便于根据项目需求在不同格式间切换。
- 加固镜像附带证明签名（Notation）、SBOM、病毒扫描报告和其他元数据，通过 SLSA-3 合规软件工厂生成。

仅有部分 BSI 应用可免费使用。如需访问完整应用目录及企业支持，请尝试 [Bitnami Secure Images 商业版](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)。

## 为何使用非 root 容器？

非 root 容器镜像增加了额外安全层，通常推荐用于生产环境。但由于以非 root 用户运行，特权任务通常受限。更多关于非 root 容器的信息请参见 [官方文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html)。

## 支持的标签及对应 Dockerfile 链接

了解 Bitnami 标签政策及滚动标签与不可变标签的区别，请参见 [文档页面](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

可通过查看分支文件夹中的 `tags-info.yaml` 文件（如 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）了解不同标签的对应关系。

订阅项目更新请关注 [bitnami/containers GitHub 仓库](https://github.com/bitnami/containers)。

## 获取镜像

获取 Bitnami NGINX Exporter Docker 镜像的推荐方式是从 [Docker Hub 仓库](https://hub.docker.com/r/bitnami/nginx-exporter) 拉取预构建镜像。

```console
docker pull docker.xuanyuan.run/bitnami/nginx-exporter:latest
```

如需使用特定版本，可拉取带版本的标签。可在 Docker Hub 仓库查看 [可用版本列表](https://hub.docker.com/r/bitnami/nginx-exporter/tags/)。

```console
docker pull docker.xuanyuan.run/bitnami/nginx-exporter:[TAG]
```

如需自行构建镜像，可克隆仓库，进入包含 Dockerfile 的目录，执行 `docker build` 命令。请将以下示例中的 `APP`、`VERSION` 和 `OPERATING-SYSTEM` 占位符替换为正确值。

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## 连接到其他容器

使用 [Docker 容器网络](https://docs.docker.com/engine/userguide/networking/)，容器内运行的其他服务可轻松被应用容器访问，反之亦然。

同一网络中的容器可通过容器名称作为主机名相互通信。

### 使用命令行

#### 步骤 1：创建网络

```console
docker network create nginx-exporter-network --driver bridge
```

#### 步骤 2：在网络中启动 nginx-exporter 容器

使用 `--network <NETWORK>` 参数执行 `docker run` 命令，将容器附加到 `nginx-exporter-network` 网络。

```console
docker run --name nginx-exporter-node1 --network nginx-exporter-network docker.xuanyuan.run/bitnami/nginx-exporter:latest
```

#### 步骤 3：运行其他容器

可使用相同标志（`--network NETWORK`）执行 `docker run` 命令启动其他容器。如为容器设置名称，可在网络中用作主机名。

## 配置

所有配置标志请参见 [NGINX Prometheus Exporter 官方文档](https://github.com/nginxinc/nginx-prometheus-exporter#command-line-arguments)。

### Bitnami 安全镜像中的 FIPS 配置

[Bitnami Secure Images](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/) 目录中的 Bitnami NGINX Exporter Docker 镜像包含额外功能和设置，可配置容器的 FIPS 能力。可配置以下环境变量：

- `OPENSSL_FIPS`：OpenSSL 是否运行在 FIPS 模式。`yes`（默认）、`no`。

## 日志

Bitnami NGINX Exporter Docker 镜像将容器日志发送至 `stdout`。查看日志：

```console
docker logs nginx-exporter
```

如需不同方式处理容器日志，可使用 `--log-driver` 选项配置容器 [日志驱动](https://docs.docker.com/engine/admin/logging/overview/)。默认配置下 Docker 使用 `json-file` 驱动。

## 维护

### 升级镜像

Bitnami 会及时提供 NGINX Exporter 的更新版本，包括安全补丁。建议按以下步骤升级容器。

#### 步骤 1：获取更新镜像

```console
docker pull docker.xuanyuan.run/bitnami/nginx-exporter:latest
```

#### 步骤 2：停止运行中的容器

使用以下命令停止当前运行的容器：

```console
docker stop nginx-exporter
```

#### 步骤 3：删除当前运行的容器

```console
docker rm -v nginx-exporter
```

#### 步骤 4：运行新镜像

从新镜像重新创建容器。

```console
docker run --name nginx-exporter docker.xuanyuan.run/bitnami/nginx-exporter:latest
```

## 重要变更

### 2024 年 1 月 16 日起

- `docker-compose.yaml` 文件已移除，该文件仅用于内部测试。

## 许可证

版权所有 &copy; 2025 Broadcom。“Broadcom”一词指 Broadcom Inc. 及其子公司。

根据 Apache 许可证 2.0 版（“许可证”）授权；除非遵守许可证，否则不得使用本文件。可在以下位置获取许可证副本：

<http://www.apache.org/licenses/LICENSE-2.0>

除非适用法律要求或书面同意，否则软件按“原样”分发，不提供任何明示或暗示的担保或条件。详见许可证以了解特定语言的权限和限制。
