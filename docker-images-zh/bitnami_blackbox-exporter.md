---
image: bitnami/blackbox-exporter
description: "Bitnami Secure Image提供的blackbox-exporter镜像，支持通过HTTP、HTTPS、DNS、TCP和ICMP对端点进行黑盒探测，具备安全加固、最小攻击面和供应链安全特性。"
source: https://xuanyuan.cloud/zh/r/bitnami/blackbox-exporter
canonical: https://xuanyuan.cloud/zh/r/bitnami/blackbox-exporter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/blackbox-exporter" title="bitnami/blackbox-exporter Docker 镜像中文简介、标签列表与拉取命令">bitnami/blackbox-exporter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami 软件包：Blackbox Exporter

## 什么是 Blackbox Exporter？

> blackbox exporter 允许通过 HTTP、HTTPS、DNS、TCP 和 ICMP 对端点进行黑盒探测。

[Blackbox Exporter 概述](https://github.com/prometheus/blackbox_exporter)  
商标声明：本软件列表由 Bitnami 打包。产品中提及的 respective 商标归各自公司所有，使用这些商标并不意味着任何关联或认可。

## 快速入门

```console
docker run --name blackbox-exporter docker.xuanyuan.run/bitnami/blackbox-exporter:latest
```

## ⚠️ 重要通知：Bitnami 目录即将变更

自2025年8月28日起，Bitnami 将升级其公共目录，在新的[Bitnami Secure Images计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)下提供精选的安全加固镜像集。此次变更包括：

- 首次向社区用户提供流行容器镜像的安全优化版本。
- Bitnami 将开始在免费层中弃用对非加固、基于 Debian 的软件镜像的支持，并逐步从公共目录中移除非最新标签。因此，社区用户将只能访问数量减少的加固镜像，这些镜像仅以“latest”标签发布，适用于开发目的。
- 从8月28日开始，在两周内，所有现有容器镜像（包括旧版本或特定版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移到“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用 Bitnami Secure Images，包括加固容器、更小的攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 和企业支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提高所有 Bitnami 用户的安全态势。更多详情，请访问[Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。

## 为什么使用 Bitnami Secure Images？

- Bitnami Secure Images 和 Helm 图表旨在使开源软件更安全且适合企业使用。
- 更快地分类安全漏洞，通过行业标准漏洞可利用性交换（VEX）、KEV 和 EPSS 评分透明了解 CVE 风险。
- 我们的加固镜像使用最小化操作系统（Photon Linux），减少攻击面的同时通过行业标准包格式保持可扩展性。
- 通过持续构建的镜像（上游补丁发布后数小时内更新）保持更高的安全性和合规性。
- Bitnami 容器、虚拟机和云镜像使用相同的组件和配置方法——便于根据项目需求在不同格式之间切换。
- 加固镜像附带证明签名（Notation）、SBOM、病毒扫描报告和其他元数据，这些均在符合 SLSA-3 标准的软件工厂中生成。

只有部分 BSI 应用程序可免费使用。希望访问完整的应用程序目录并获得企业支持？立即尝试[Bitnami Secure Images 商业版](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)。

## 为什么使用非 root 容器？

非 root 容器镜像增加了额外的安全层，通常推荐用于生产环境。但是，由于它们以非 root 用户运行，通常无法执行特权任务。在我们的文档中[了解更多关于非 root 容器的信息](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html)。

## 支持的标签及对应的 `Dockerfile` 链接

在我们的文档页面中[了解更多关于 Bitnami 标签策略以及滚动标签和不可变标签之间的区别](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

您可以通过查看分支文件夹中的 `tags-info.yaml` 文件（即 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）了解不同标签之间的对应关系。

通过关注 [bitnami/containers GitHub 仓库](https://github.com/bitnami/containers) 订阅项目更新。

## 获取此镜像

获取 Bitnami Blackbox Exporter Docker 镜像的推荐方式是从 [Docker Hub  registry](https://hub.docker.com/r/bitnami/blackbox-exporter) 拉取预构建镜像。

```console
docker pull docker.xuanyuan.run/bitnami/blackbox-exporter:latest
```

要使用特定版本，您可以拉取带版本的标签。您可以在 Docker Hub Registry 中查看[可用版本列表](https://hub.docker.com/r/bitnami/blackbox-exporter/tags/)。

```console
docker pull docker.xuanyuan.run/bitnami/blackbox-exporter:[TAG]
```

如果需要，您也可以通过克隆仓库、切换到包含 Dockerfile 的目录并执行 `docker build` 命令来自行构建镜像。请记住在下面的示例命令中用正确的值替换 `APP`、`VERSION` 和 `OPERATING-SYSTEM` 路径占位符。

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## 连接到其他容器

使用 [Docker 容器网络](https://docs.docker.com/engine/userguide/networking/)，在容器内运行的不同服务器可以轻松被您的应用容器访问，反之亦然。

连接到同一网络的容器可以使用容器名称作为主机名进行通信。

### 使用命令行

#### 步骤 1：创建网络

```console
docker network create blackbox-exporter-network --driver bridge
```

#### 步骤 2：在网络中启动 Blackbox_exporter 容器

使用 `--network <NETWORK>` 参数执行 `docker run` 命令，将容器附加到 `blackbox-exporter-network` 网络。

```console
docker run --name blackbox-exporter-node1 --network blackbox-exporter-network docker.xuanyuan.run/bitnami/blackbox-exporter:latest
```

#### 步骤 3：运行其他容器

我们可以使用 `docker run` 命令中的相同标志（`--network NETWORK`）启动其他容器。如果您还为容器设置了名称，则可以在网络中将其用作主机名。

## 配置

Blackbox exporter 通过配置文件和命令行标志进行配置（例如加载哪个配置文件、监听哪个端口以及日志格式和级别）。

配置文件的默认位置是 `/opt/bitnami/blackbox-exporter/conf/config.yml`，您可以挂载卷到该位置以覆盖默认配置。

该文件采用 YAML 格式编写，由下面描述的方案定义。方括号表示参数是可选的。对于非列表参数，值设置为指定的默认值。

通用占位符定义如下：

`<boolean>`: 布尔值，可取 true 或 false  
`<int>`: 常规整数  
`<duration>`: 匹配正则表达式 [0-9]+(ms|[smhdwy]) 的持续时间  
`<filename>`: 当前工作目录中的有效路径  
`<string>`: 常规字符串  
`<secret>`: 包含敏感信息的常规字符串，如密码  
`<regex>`: 正则表达式  
其他占位符单独指定。

配置示例：

```yaml
scrape_configs:
  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]  # 查找 HTTP 200 响应。
    static_configs:
      - targets:
        - http://prometheus.io    # 用 http 探测的目标。
        - https://prometheus.io   # 用 https 探测的目标。
        - http://example.com:8080 # 用 http 在 8080 端口探测的目标。
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: 127.0.0.1:9115  # blackbox exporter 的实际主机名:端口。
```

[更多信息](https://github.com/prometheus/blackbox_exporter/blob/master/CONFIGURATION.md)

### Bitnami Secure Images 中的 FIPS 配置

来自 [Bitnami Secure Images](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/) 目录的 Bitnami Blackbox Exporter Docker 镜像包含额外功能和设置，可将容器配置为具有 FIPS 功能。您可以配置以下环境变量：

- `OPENSSL_FIPS`: OpenSSL 是否运行在 FIPS 模式。`yes`（默认）、`no`。

## 日志

Bitnami blackbox-exporter Docker 镜像将容器日志发送到 `stdout`。要查看日志：

```console
docker logs blackbox-exporter
```

如果您希望以不同方式使用容器日志，可以使用 `--log-driver` 选项配置容器的[日志驱动](https://docs.docker.com/engine/admin/logging/overview/)。在默认配置中，docker 使用 `json-file` 驱动。

## 维护

### 升级此镜像

Bitnami 提供最新版本的 blackbox-exporter，包括安全补丁，在上游发布后不久即提供。建议您按照以下步骤升级容器。

#### 步骤 1：获取更新的镜像

```console
docker pull docker.xuanyuan.run/bitnami/blackbox-exporter:latest
```

#### 步骤 2：停止并备份当前运行的容器

使用以下命令停止当前运行的容器：

```console
docker stop blackbox-exporter
```

接下来，使用以下命令对持久卷 `/path/to/blackbox-exporter-persistence` 进行快照：

```console
rsync -a /path/to/blackbox-exporter-persistence /path/to/blackbox-exporter-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

如果升级失败，您可以使用此快照恢复数据库状态。

#### 步骤 3：移除当前运行的容器

```console
docker rm -v blackbox-exporter
```

#### 步骤 4：运行新镜像

从新镜像重新创建容器，必要时恢复备份。

```console
docker run --name blackbox-exporter docker.xuanyuan.run/bitnami/blackbox-exporter:latest
```

## 重要变更

### 自2024年1月16日起

- `docker-compose.yaml` 文件已被移除，因为它仅用于内部测试目的。

## 贡献

我们欢迎您为此容器做出贡献。您可以通过创建 [issue](https://github.com/bitnami/containers/issues) 请求新功能，或提交 [pull request](https://github.com/bitnami/containers/pulls) 贡献代码。

## 问题

如果您在运行此容器时遇到问题，可以提交 [issue](https://github.com/bitnami/containers/issues/new/choose)。为了让我们提供更好的支持，请务必填写 issue 模板。

## 许可证

版权所有 &copy; 2025 Broadcom。术语“Broadcom”指 Broadcom Inc. 及其子公司。

根据 Apache 许可证 2.0 版（“许可证”）授权；除非遵守许可证，否则您不得使用此文件。您可以在以下位置获取许可证副本：

<http://www.apache.org/licenses/LICENSE-2.0>

除非适用法律要求或书面同意，否则根据许可证分发的软件按“原样”分发，不附带任何明示或暗示的担保或条件。有关许可证下权限和限制的具体语言，请参阅许可证。
