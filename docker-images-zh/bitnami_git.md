---
image: bitnami/git
description: "Bitnami Git安全镜像，用于安全运行Git版本控制系统，具备预配置和安全加固特性，支持快速部署与使用。"
source: https://xuanyuan.cloud/zh/r/bitnami/git
canonical: https://xuanyuan.cloud/zh/r/bitnami/git
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/git" title="bitnami/git Docker 镜像中文简介、标签列表与拉取命令">bitnami/git — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/git" title="bitnami/git Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/git</a>

# Bitnami Git 镜像文档


## 镜像概述和主要用途

### 关于 Git
Git 是一个开源分布式版本控制系统，能够高效地处理从小到大的各类项目。

### Bitnami Git 镜像概述
Bitnami Git 镜像是由 Bitnami 构建和维护的硬化、最小化 CVE 安全镜像。该镜像基于云优化、安全硬化的企业级操作系统 [Photon Linux](https://vmware.github.io/photon/)，旨在提供安全可靠的 Git 运行环境，适用于需要版本控制功能且对安全性有较高要求的场景。


## 核心功能和特性

- **硬化安全镜像**：基于流行开源软件构建的硬化安全镜像，具有近零漏洞特性
- **漏洞管理**：支持漏洞分类与优先级划分，提供 VEX 声明、KEV 和 EPSS 评分
- **合规性支持**：专注于合规需求，提供 FIPS、STIG 和离线环境选项，包括安全软件物料清单（SBOM）
- **软件供应链溯源**：通过 in-toto 实现软件供应链来源证明
- **Helm Charts 支持**：为互联网上广泛使用的 Helm Charts 提供一流支持


## 使用场景和适用范围

- **开发环境**：本地或容器化开发环境中执行 Git 版本控制操作（如克隆、提交、合并等）
- **CI/CD 流水线**：在持续集成/持续部署流程中拉取代码、管理版本标签或执行版本相关操作
- **安全合规场景**：对漏洞控制、供应链安全或合规性（如 FIPS、STIG）有严格要求的生产或测试环境
- **轻量级部署**：需要最小化镜像体积和攻击面的容器化部署场景


## 详细使用方法和配置说明

### 快速启动

使用以下命令快速启动 Bitnami Git 容器：

```console
docker run --name git bitnami/git:latest
```


### 获取镜像

#### 拉取预构建镜像（推荐）
从 Docker Hub  registry 拉取预构建镜像：

```console
docker pull bitnami/git:latest
```

如需使用特定版本，可拉取带版本标签的镜像。查看 [Docker Hub 上的可用版本列表](https://hub.docker.com/r/bitnami/git/tags/)：

```console
docker pull bitnami/git:[TAG]
```

#### 本地构建镜像
如需自行构建镜像，克隆仓库并执行 `docker build` 命令（替换以下命令中的 `APP`、`VERSION` 和 `OPERATING-SYSTEM` 占位符）：

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```


### 配置说明

#### 运行 Git 命令
通过 `docker run` 在容器内执行 Git 命令，例如查看 Git 版本：

```console
docker run --name git bitnami/git:latest git --version
```

#### FIPS 配置（Bitnami Secure Images）
Bitnami Git 镜像（来自 [Bitnami Secure Images 目录](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)）支持 FIPS 模式配置，可通过以下环境变量设置：

- `OPENSSL_FIPS`：控制 OpenSSL 是否运行在 FIPS 模式。可选值：`yes`（默认）、`no`


## 支持的标签及对应 Dockerfile 链接

了解 Bitnami 标签策略以及滚动标签与不可变标签的区别，请参见 [官方文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

不同标签的对应关系可查看分支文件夹中的 `tags-info.yaml` 文件，例如 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`。

通过关注 [bitnami/containers GitHub 仓库](https://github.com/bitnami/containers) 订阅项目更新。


## 重要变更

### 2024 年 1 月 16 日起
- 移除 `docker-compose.yaml` 文件，该文件仅用于内部测试。

### 2.31.0-debian-10-r2 版本
- 修改容器的 `ENTRYPOINT`，以加载正确的 NSS 环境，支持非 root 用户运行容器时的 Git SSH 连接
- `CMD` 变更为进入 Bash shell

若之前使用未替换 entrypoint 的容器，需现在指定 `git` 命令：

```diff
-docker run bitnami/git:latest --version
+docker run bitnami/git:latest git --version
```


## 贡献

欢迎为该容器贡献代码。可通过创建 [issue](https://github.com/bitnami/containers/issues) 请求新功能，或提交 [pull request](https://github.com/bitnami/containers/pulls) 贡献代码。


## 问题反馈

如在运行容器时遇到问题，可提交 [issue](https://github.com/bitnami/containers/issues/new/choose)。为获得更好的支持，请务必填写 issue 模板。


## 许可证

版权所有 © 2025 Broadcom。"Broadcom" 指 Broadcom Inc. 及其子公司。

根据 Apache 许可证 2.0 版（"许可证"）授权；除非遵守许可证，否则不得使用本文件。您可在以下地址获取许可证副本：

<http://www.apache.org/licenses/LICENSE-2.0>

除非适用法律要求或书面同意，否则软件按"原样"分发，不附带任何明示或暗示的担保或条件。请查看许可证以获取管理权限和限制的具体语言。


**商标说明**：本软件列表由 Bitnami 打包。产品中提及的 respective 商标归 respective 公司所有，使用这些商标并不意味着任何关联或认可。

**安全元数据**：每个镜像均附带有价值的安全元数据，可在 [我们的公共目录](https://app-catalog.vmware.com/bitnami/apps) 中查看。注意：部分数据仅对 [BSI 商业订阅用户](https://bitnami.com/) 开放。

**旧版镜像**：如需基于 Debian Linux 的旧版镜像，请参见 Bitnami Legacy registry。
