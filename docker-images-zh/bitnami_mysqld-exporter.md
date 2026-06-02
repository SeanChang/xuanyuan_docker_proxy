---
image: bitnami/mysqld-exporter
description: "Bitnami MySQL Server Exporter安全镜像，用于收集MySQL服务器指标供Prometheus监控，基于Photon Linux构建，提供强化安全特性、合规支持及供应链安全保障。"
source: https://xuanyuan.cloud/zh/r/bitnami/mysqld-exporter
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[bitnami/mysqld-exporter](https://xuanyuan.cloud/zh/r/bitnami/mysqld-exporter)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami MySQL Server Exporter 镜像

## 什么是 MySQL Server Exporter？

> MySQL Server Exporter 收集 MySQL 服务器指标，供 Prometheus 监控使用。

[MySQL Server Exporter 概述](https://github.com/prometheus/mysqld_exporter)
商标说明：本软件列表由 Bitnami 打包。所提及的相关商标归各自公司所有，使用这些商标并不意味着任何关联或认可。

## 快速启动

```console
docker run --name mysqld-exporter bitnami/mysqld-exporter:latest
```

这是由 Bitnami 构建和维护的强化、最小化 CVE 镜像。Bitnami 安全镜像基于云优化、安全强化的企业级 [Photon Linux 操作系统](https://vmware.github.io/photon/)。选择 BSI 镜像的理由：
- 流行开源软件的强化安全镜像，近乎零漏洞
- 漏洞分类与优先级划分，包含 VEX 声明、KEV 和 EPSS 评分
- 专注合规性，支持 FIPS、STIG 和离线选项，包括安全物料清单（SBOM）
- 通过 in-toto 提供软件供应链来源证明
- 对互联网上最受欢迎的 Helm 图表提供一流支持

每个镜像都附带有价值的安全元数据。您可以在 [我们的公共目录](https://app-catalog.vmware.com/bitnami/apps) 中查看元数据。注意：某些数据仅对 [BSI 商业订阅](https://bitnami.com/) 用户可用。

如果您正在寻找我们基于 Debian Linux 的上一代镜像，请参阅 Bitnami Legacy 仓库。

## 为什么使用非 root 容器？

非 root 容器镜像增加了额外的安全层，通常推荐用于生产环境。然而，由于它们以非 root 用户运行，特权任务通常被禁止。在我们的文档中[了解更多关于非 root 容器的信息](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html)。

## 支持的标签及对应的 `Dockerfile` 链接

了解更多关于 Bitnami 标签策略以及滚动标签和不可变标签之间的区别，请参阅[我们的文档页面](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

您可以通过查看分支文件夹中的 `tags-info.yaml` 文件（即 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）了解不同标签之间的对应关系。

通过关注 [bitnami/containers GitHub 仓库](https://github.com/bitnami/containers) 订阅项目更新。

## 获取此镜像

获取 Bitnami MySQL Server Exporter Docker 镜像的推荐方式是从 [Docker Hub Registry](https://hub.docker.com/r/bitnami/mysqld-exporter) 拉取预构建镜像。

```console
docker pull bitnami/mysqld-exporter:latest
```

要使用特定版本，可以拉取带版本的标签。您可以在 Docker Hub Registry 中查看[可用版本列表](https://hub.docker.com/r/bitnami/mysqld-exporter/tags/)。

```console
docker pull bitnami/mysqld-exporter:[TAG]
```

如果您希望自己构建镜像，可以克隆仓库，切换到包含 Dockerfile 的目录，然后执行 `docker build` 命令。请记住替换示例命令中的 `APP`、`VERSION` 和 `OPERATING-SYSTEM` 路径占位符为正确值。

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## 连接到其他容器

使用 [Docker 容器网络](https://docs.docker.com/engine/userguide/networking/)，运行在容器内的不同服务可以轻松地被应用容器访问，反之亦然。

连接到同一网络的容器可以使用容器名称作为主机名进行通信。

### 使用命令行

#### 步骤 1：创建网络

```console
docker network create mysqld-exporter-network --driver bridge
```

#### 步骤 2：在网络中启动 mysqld-exporter 容器

使用 `--network <NETWORK>` 参数执行 `docker run` 命令，将容器附加到 `mysqld-exporter-network` 网络。

```console
docker run --name mysqld-exporter-node1 --network mysqld-exporter-network bitnami/mysqld-exporter:latest
```

#### 步骤 3：运行其他容器

我们可以使用相同的标志（`--network NETWORK`）在 `docker run` 命令中启动其他容器。如果您也为容器设置了名称，则可以在网络中将其用作主机名。

## 配置

在 [MySQL Server Exporter 官方文档](https://github.com/prometheus/mysqld_exporter#collector-flags) 中查找所有配置标志。

### Bitnami 安全镜像中的 FIPS 配置

Bitnami MySQL Server Exporter Docker 镜像（来自 [Bitnami Secure Images](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/) 目录）包含额外功能和设置，可将容器配置为具有 FIPS 功能。您可以配置以下环境变量：

- `OPENSSL_FIPS`：OpenSSL 是否运行在 FIPS 模式。`yes`（默认）、`no`。

## 日志

Bitnami MySQL Server Exporter Docker 镜像将容器日志发送到 `stdout`。查看日志：

```console
docker logs mysqld-exporter
```

如果您希望以不同方式消费容器日志，可以使用 `--log-driver` 选项配置容器的[日志驱动](https://docs.docker.com/engine/admin/logging/overview/)。在默认配置中，docker 使用 `json-file` 驱动。

## 维护

### 升级此镜像

Bitnami 会在 upstream 发布后尽快提供 MySQL Server Exporter 的更新版本，包括安全补丁。我们建议您按照以下步骤升级容器。

#### 步骤 1：获取更新的镜像

```console
docker pull bitnami/mysqld-exporter:latest
```

#### 步骤 2：停止运行中的容器

使用以下命令停止当前运行的容器

```console
docker stop mysqld-exporter
```

#### 步骤 3：删除当前运行的容器

```console
docker rm -v mysqld-exporter
```

#### 步骤 4：运行新镜像

从新镜像重新创建容器。

```console
docker run --name mysqld-exporter bitnami/mysqld-exporter:latest
```

## 重要变更

### 自 2024 年 1 月 16 日起

- `docker-compose.yaml` 文件已被移除，因为它仅用于内部测试目的。

### 0.12.1-centos-7-r175

- `0.12.1-centos-7-r175` 被视为基于 CentOS 的最新镜像。
- 标准支持的发行版：Debian 和 OEL。

## 贡献

我们欢迎您为此容器做出贡献。您可以通过创建 [issue](https://github.com/bitnami/containers/issues) 或提交 [pull request](https://github.com/bitnami/containers/pulls) 来请求新功能或贡献代码。

## 问题

如果您在运行此容器时遇到问题，可以提交 [issue](https://github.com/bitnami/containers/issues/new/choose)。为了让我们提供更好的支持，请务必填写 issue 模板。

## 许可

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
