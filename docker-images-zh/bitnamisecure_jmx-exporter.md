---
image: bitnamisecure/jmx-exporter
description: "Bitnami JMX Exporter镜像是通过HTTP暴露JMX Beans以支持Prometheus监控的工具。"
source: https://xuanyuan.cloud/zh/r/bitnamisecure/jmx-exporter
canonical: https://xuanyuan.cloud/zh/r/bitnamisecure/jmx-exporter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamisecure/jmx-exporter" title="bitnamisecure/jmx-exporter Docker 镜像中文简介、标签列表与拉取命令">bitnamisecure/jmx-exporter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami JMX Exporter 镜像文档

## 镜像概述和主要用途

### 什么是 JMX Exporter？

> 一个通过 HTTP 暴露 JMX Beans 以供 Prometheus 消费的进程。

[JMX Exporter 概述](https://github.com/prometheus/jmx_exporter)

**商标声明**：本软件列表由 Bitnami 打包。产品中提及的相关商标归各自公司所有，使用这些商标并不意味着任何关联或背书。


## 核心功能和特性

### 为什么使用 Bitnami 安全镜像？

- Bitnami 安全镜像和 Helm 图表旨在提高开源软件的安全性和企业就绪性。
- 通过行业标准漏洞可利用性交换（VEX）、KEV 和 EPSS 评分，更快地分类安全漏洞，透明呈现 CVE 风险。
- 强化镜像采用最小化操作系统（Photon Linux），减少攻击面的同时，通过行业标准包格式保持可扩展性。
- 持续构建的镜像在上游补丁发布后数小时内更新，确保安全性和合规性。
- Bitnami 容器、虚拟机和云镜像使用相同的组件和配置方法，便于根据项目需求在不同格式间切换。
- 强化镜像附带证明签名（Notation）、SBOMs（软件物料清单）、病毒扫描报告和其他元数据，由符合 SLSA-3 标准的软件工厂生成。

仅部分 BSI 应用可免费使用。如需访问完整应用目录及企业支持，请尝试[Bitnami 安全镜像商业版](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)。

### 为什么使用非 root 容器？

非 root 容器镜像增加了额外的安全层，通常推荐用于生产环境。但由于以非 root 用户运行，特权任务通常受限。如需了解更多关于非 root 容器的信息，请参阅[Bitnami 文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html)。


## 使用场景和适用范围

JMX Exporter 主要用于通过 HTTP 协议暴露 Java 应用的 JMX（Java Management Extensions）指标，供 Prometheus 监控系统采集和分析。适用于以下场景：
- 生产环境中 Java 应用的 JMX 指标监控
- 集成 Prometheus 构建企业级监控体系
- 需要最小化攻击面的安全敏感环境
- 需符合合规要求（如 FIPS）的企业级部署
- 跨容器、虚拟机或云环境的统一监控配置


## 详细的使用方法和配置说明

### 支持的标签及对应 `Dockerfile` 链接

了解 Bitnami 标签策略以及滚动标签与不可变标签的区别，请参阅[文档页面](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

可通过分支文件夹中的 `tags-info.yaml` 文件（如 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）查看不同标签的对应关系。

订阅项目更新，请关注 [bitnami/containers GitHub 仓库](https://github.com/bitnami/containers)。

### 获取镜像

获取 Bitnami JMX Exporter Docker 镜像的推荐方式是从 [Docker Hub 仓库](https://hub.docker.com/r/bitnami/jmx-exporter)拉取预构建镜像。

```console
docker pull docker.xuanyuan.run/REGISTRY_NAME/bitnami/jmx-exporter:latest
```

如需使用特定版本，可拉取带版本的标签。可在 [Docker Hub](https://hub.docker.com/r/bitnami/jmx-exporter/tags/) 查看[可用版本列表](https://hub.docker.com/r/bitnami/jmx-exporter/tags/)。

```console
docker pull docker.xuanyuan.run/REGISTRY_NAME/bitnami/jmx-exporter:[TAG]
```

如需自行构建镜像，可克隆仓库并执行 `docker build` 命令（替换 `APP`、`VERSION` 和 `OPERATING-SYSTEM` 占位符）：

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t REGISTRY_NAME/bitnami/APP:latest .
```

### 快速启动

```console
docker run --name jmx-exporter docker.xuanyuan.run/REGISTRY_NAME/bitnami/jmx-exporter:latest
```

### 连接其他容器

通过 [Docker 容器网络](https://docs.docker.com/engine/userguide/networking/)，网络中的其他容器可轻松访问运行在容器内的服务，反之亦然。同一网络中的容器可使用容器名称作为主机名进行通信。

#### 使用命令行

##### 步骤 1：创建网络

```console
docker network create jmx-exporter-network --driver bridge
```

##### 步骤 2：在网络中启动 jmx-exporter 容器

使用 `--network <NETWORK>` 参数将容器附加到 `jmx-exporter-network` 网络：

```console
docker run --name jmx-exporter-node1 --network jmx-exporter-network docker.xuanyuan.run/REGISTRY_NAME/bitnami/jmx-exporter:latest
```

##### 步骤 3：运行其他容器

使用相同的 `--network NETWORK` 参数启动其他容器。若为容器设置名称，可在网络中将其用作主机名。

### 配置

所有配置选项请参见 [JMX Prometheus Exporter 文档](https://github.com/prometheus/jmx_exporter#configuration)。

#### Bitnami 安全镜像中的 FIPS 配置

[Bitnami 安全镜像](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)目录中的 Bitnami JMX Exporter Docker 镜像包含额外功能和设置，可配置容器的 FIPS 能力。可通过以下环境变量进行配置：

- `OPENSSL_FIPS`：OpenSSL 是否运行在 FIPS 模式。可选值：`yes`（默认）、`no`。


## 日志

Bitnami JMX Exporter Docker 镜像将容器日志输出至 `stdout`。查看日志：

```console
docker logs jmx-exporter
```

如需自定义日志消费方式，可使用 `--log-driver` 选项配置容器[日志驱动](https://docs.docker.com/engine/admin/logging/overview/)。默认配置下，Docker 使用 `json-file` 驱动。


## 维护

### 升级镜像

Bitnami 会及时提供 JMX Exporter 的更新版本，包括安全补丁。建议按以下步骤升级容器：

#### 步骤 1：获取更新的镜像

```console
docker pull docker.xuanyuan.run/REGISTRY_NAME/bitnami/jmx-exporter:latest
```

#### 步骤 2：停止运行中的容器

```console
docker stop jmx-exporter
```

#### 步骤 3：删除当前运行的容器

```console
docker rm -v jmx-exporter
```

#### 步骤 4：运行新镜像

使用新镜像重新创建容器：

```console
docker run --name jmx-exporter docker.xuanyuan.run/REGISTRY_NAME/bitnami/jmx-exporter:latest
```


## 变更记录

### 自 2024 年 1 月 16 日起

- `docker-compose.yaml` 文件已移除，该文件仅用于内部测试。


## 贡献

欢迎为该容器贡献代码。可通过创建 [issue](https://github.com/bitnami/containers/issues) 请求新功能，或提交 [pull request](https://github.com/bitnami/containers/pulls) 贡献代码。


## 问题反馈

如在运行容器时遇到问题，可提交 [issue](https://github.com/bitnami/containers/issues/new/choose)。为获得更好的支持，请务必填写 issue 模板。


## 许可证

版权所有 &copy; 2025 Broadcom。"Broadcom" 指 Broadcom Inc. 及其子公司。

根据 Apache 许可证 2.0 版（"许可证"）授权；除非遵守许可证，否则不得使用本文件。您可在以下地址获取许可证副本：

<http://www.apache.org/licenses/LICENSE-2.0>

除非适用法律要求或书面同意，否则根据许可证分发的软件按"原样"分发，不附带任何明示或暗示的担保或条件。有关许可证下权限和限制的具体语言，请参阅许可证。
