---
image: bitnami/golang
description: "Bitnami安全Golang镜像，提供加固配置与安全更新，适用于构建和运行Golang应用的生产环境。"
source: https://xuanyuan.cloud/zh/r/bitnami/golang
canonical: https://xuanyuan.cloud/zh/r/bitnami/golang
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/golang" title="bitnami/golang Docker 镜像中文简介、标签列表与拉取命令">bitnami/golang — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/golang" title="bitnami/golang Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/golang</a>

# Bitnami Golang 镜像文档

## 1. 镜像概述和主要用途

### 什么是 Golang？

Go 是一种面向对象的编程语言，具有合理的基本语法、静态类型和反射机制。它还支持包管理，可高效管理依赖项。

[Golang 官方概述](https://golang.org/)

**商标说明**：本软件列表由 Bitnami 打包。所提及的 respective 商标归各自公司所有，使用这些商标并不意味着任何关联或认可。

### 主要用途

Bitnami Golang 镜像是预配置的 Docker 镜像，旨在简化 Golang 应用程序的开发、测试和运行流程。该镜像基于 Bitnami 安全镜像标准构建，提供了安全强化的运行环境，适用于需要可靠、合规的 Golang 开发环境。

## 2. 核心功能和特性

Bitnami 安全镜像和 Helm 图表旨在使开源软件更安全且企业级可用，主要特性包括：

- **安全强化**：通过行业标准漏洞可利用性交换（VEX）、KEV 和 EPSS 评分，更快地分类安全漏洞，提高 CVE 风险透明度。
- **最小化攻击面**：强化镜像使用最小化操作系统（Photon Linux），减少攻击面的同时通过行业标准包格式保持可扩展性。
- **持续更新**：持续构建的镜像在 upstream 补丁发布后数小时内更新，确保安全性和合规性。
- **跨格式一致性**：Bitnami 容器、虚拟机和云镜像使用相同的组件和配置方法，便于根据项目需求切换格式。
- **安全元数据**：强化镜像附带证明签名（Notation）、SBOM（软件物料清单）、病毒扫描报告和其他元数据，在 SLSA-3 合规的软件工厂中生成。

## 3. 使用场景和适用范围

- **开发环境**：快速搭建 Golang 开发环境，支持挂载本地项目并直接运行。
- **安全合规需求**：需要满足企业安全标准、减少供应链风险的场景。
- **CI/CD 流程**：集成到持续集成/持续部署管道，确保构建环境的一致性和安全性。
- **临时测试**：快速启动 Golang 环境进行代码测试或原型验证。

> **注意**：免费版仅提供部分 Bitnami 安全镜像应用。如需完整应用目录和企业支持，请考虑商业版 [Bitnami 安全镜像](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)。

## 4. 支持的标签和标签政策

Bitnami 镜像遵循特定的标签政策，了解滚动标签（rolling tags）和不可变标签（immutable tags）的区别请参考 [官方文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

不同标签的对应关系可通过分支文件夹中的 `tags-info.yaml` 文件查看，例如 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`。

建议通过关注 [bitnami/containers GitHub 仓库](https://github.com/bitnami/containers) 订阅项目更新。

## 5. 获取镜像

### 推荐方式：拉取预构建镜像

从 Docker Hub 拉取最新版镜像：

```console
docker pull bitnami/golang:latest
```

如需使用特定版本，可拉取带版本号的标签（查看 [可用版本列表](https://hub.docker.com/r/bitnami/golang/tags/)）：

```console
docker pull bitnami/golang:[TAG]
```

### 构建镜像（可选）

如需自行构建镜像，克隆仓库并执行 `docker build`：

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM  # 替换 APP、VERSION、OPERATING-SYSTEM 为实际值
docker build -t bitnami/golang:latest .
```

## 6. 持久化应用数据

为持久化数据，需挂载目录到容器的 `/bitnami` 路径。若挂载的目录为空，首次运行时会自动初始化。

### 使用 `docker run` 持久化

```console
docker run \
  -v /path/to/golang-persistence:/bitnami \
  bitnami/golang:latest
```

### 使用 `docker-compose` 持久化

修改 `docker-compose.yml` 文件：

```yaml
golang:
  ...
  volumes:
    - /path/to/golang-persistence:/bitnami
  ...
```

## 7. 连接到其他容器

通过 Docker 容器网络，可轻松实现容器间通信。同一网络中的容器可使用容器名称作为主机名相互访问。

### 步骤 1：创建网络

```console
docker network create golang-network --driver bridge
```

### 步骤 2：在网络中启动 Golang 容器

使用 `--network` 参数将容器附加到 `golang-network`：

```console
docker run --name golang-node1 --network golang-network bitnami/golang:latest
```

### 步骤 3：运行其他容器

使用相同 `--network` 参数启动其他容器，设置容器名称后即可作为主机名在网络中使用：

```console
docker run --name other-container --network golang-network [OTHER_IMAGE]
```

## 8. 配置说明

### 运行 Golang 项目

Bitnami Golang 镜像的默认工作区为 `/go`（GOPATH，详见 [Golang 工作区文档](https://golang.org/doc/gopath_code#Workspaces)）。可将本地项目挂载到 `/go/src` 目录，并使用 `go` 命令运行。

示例：

```console
docker run -it --name golang \
  -v /path/to/your/project:/go/src/project \
  bitnami/golang \
  bash -ec 'cd src/project && go run .'
```

### FIPS 配置（Bitnami 安全镜像）

Bitnami 安全镜像支持 FIPS 配置，可通过以下环境变量设置：

- `OPENSSL_FIPS`：控制 OpenSSL 是否运行在 FIPS 模式。可选值：`yes`（默认）、`no`。

示例：

```console
docker run --name golang -e OPENSSL_FIPS=no bitnami/golang:latest
```

## 9. 日志

Bitnami Golang 镜像将容器日志输出到 `stdout`。查看日志：

```console
docker logs golang
```

可通过 `--log-driver` 选项配置 [日志驱动](https://docs.docker.com/engine/admin/logging/overview/)，默认使用 `json-file` 驱动。

## 10. 维护

### 升级镜像

Bitnami 会及时提供包含安全补丁的 Golang 更新版本，建议按以下步骤升级容器：

#### 步骤 1：拉取更新的镜像

```console
docker pull bitnami/golang:latest
```

#### 步骤 2：停止当前运行的容器

```console
docker stop golang
```

#### 步骤 3：移除当前容器

```console
docker rm -v golang
```

#### 步骤 4：使用新镜像运行容器

```console
docker run --name golang bitnami/golang:latest
```

## 11. 使用 `docker-compose.yaml`

> **注意**：此文件未经内部测试，建议仅用于开发或测试环境。如发现问题，请按 [贡献指南](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md) 报告或修复。

示例 `docker-compose.yaml` 配置：

```yaml
version: '2'

services:
  golang:
    image: bitnami/golang:latest
    ports:
      - '8080:8080'  # 根据应用需求调整端口
    volumes:
      - /path/to/golang-persistence:/bitnami
      - /path/to/your/project:/go/src/project  # 挂载本地项目
    environment:
      - OPENSSL_FIPS=yes  # 启用 FIPS 模式（默认）
```

启动服务：

```console
docker-compose up -d
```

## 12. 重要通知：Bitnami 镜像目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共目录，通过新的 [Bitnami 安全镜像计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications) 提供精选的强化、安全聚焦镜像。变更要点：

- 首次向社区用户开放热门容器镜像的安全优化版本。
- Bitnami 将开始弃用免费 tier 中的非强化 Debian 基础软件镜像，并逐步从公共目录中移除非最新标签。社区用户将只能访问数量减少的强化镜像，这些镜像仅以 “latest” 标签发布，适用于开发目的。
- 自 8 月 28 日起，两周内所有现有容器镜像（包括旧版本或带版本号的标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至 “Bitnami Legacy” 仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议采用 Bitnami 安全镜像，包括强化容器、更小攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 和企业支持。

这些变更旨在通过推广软件供应链完整性最佳实践和最新部署，提升所有 Bitnami 用户的安全态势。更多详情请访问 [Bitnami 安全镜像公告](https://github.com/bitnami/containers/issues/83267)。

## 13. 贡献

欢迎为该容器贡献代码。可通过创建 [issue](https://github.com/bitnami/containers/issues) 请求新功能，或提交 [pull request](https://github.com/bitnami/containers/pulls) 贡献代码。

## 14. 问题反馈

如运行容器时遇到问题，请提交 [issue](https://github.com/bitnami/containers/issues/new/choose)。为获得更好支持，请务必填写 issue 模板。

## 15. 许可证

版权所有 © 2025 Broadcom。“Broadcom” 指 Broadcom Inc. 及其子公司。

根据 Apache 许可证 2.0 版（“许可证”）授权；除非遵守许可证，否则不得使用此文件。您可在以下地址获取许可证副本：

<http://www.apache.org/licenses/LICENSE-2.0>

除非适用法律要求或书面同意，否则根据许可证分发的软件按 “原样” 分发，不附带任何明示或暗示的担保或条件。有关许可证下权限和限制的具体语言，请参阅许可证。
