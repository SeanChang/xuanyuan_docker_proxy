---
image: bitnami/os-shell
description: "Bitnami安全镜像，为os-shell提供安全的运行环境。"
source: https://xuanyuan.cloud/zh/r/bitnami/os-shell
canonical: https://xuanyuan.cloud/zh/r/bitnami/os-shell
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/os-shell" title="bitnami/os-shell Docker 镜像中文简介、标签列表与拉取命令">bitnami/os-shell 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami OS Shell + Utility 镜像文档

## 1. 镜像概述与主要用途

OS Shell + Utility 是 Bitnami 提供的通用最小化 Docker 镜像，专为辅助任务设计。其核心定位是提供轻量级运行环境，适用于执行初始化操作、脚本运行等辅助性任务，典型场景包括在 Helm 图表的 `initContainers` 中执行前置初始化流程。

> 注：本镜像由 Bitnami 打包，相关商标归各自所有者所有，使用不暗示任何关联或背书。

## 2. 核心功能与特性

- **最小化设计**：基于精简操作系统构建，资源占用低，攻击面小
- **通用辅助能力**：内置基础 shell 环境与工具集，支持各类辅助脚本执行
- **安全优化**：作为 Bitnami Secure Images 生态的一部分，支持安全加固配置（如 FIPS 模式）
- **环境一致性**：与 Bitnami 其他容器、虚拟机镜像采用统一配置标准，便于跨环境迁移
- **轻量级部署**：镜像体积小，启动速度快，适合临时或短期运行的辅助任务

## 3. 使用场景与适用范围

- **Kubernetes 初始化任务**：在 Helm 部署中作为 `initContainers` 执行前置初始化（如文件准备、服务探测、配置注入）
- **临时命令执行**：快速运行一次性 shell 命令或脚本，无需本地安装完整依赖环境
- **辅助脚本运行**：执行日志收集、数据格式转换、文件传输等轻量级辅助操作
- **开发环境工具**：作为开发过程中的临时工具容器，提供标准命令行环境

## 4. 使用方法与配置说明

### 4.1 获取镜像

#### 4.1.1 从 Docker Hub 拉取（推荐）

```console
# 拉取最新版本
docker pull docker.xuanyuan.run/bitnami/os-shell:latest

# 拉取特定版本（需替换 [TAG] 为具体版本号）
docker pull docker.xuanyuan.run/bitnami/os-shell:[TAG]
```

可用版本标签列表见 [Docker Hub 标签页面](https://hub.docker.com/r/bitnami/os-shell/tags/)。

#### 4.1.2 本地构建

如需自定义构建，可通过以下步骤操作：

```console
# 克隆 Bitnami 容器仓库
git clone https://github.com/bitnami/containers.git

# 进入对应目录（替换 [VERSION] 和 [OPERATING-SYSTEM] 为实际值）
cd containers/bitnami/os-shell/[VERSION]/[OPERATING-SYSTEM]

# 构建镜像
docker build -t bitnami/os-shell:latest .
```

### 4.2 基本运行

#### 4.2.1 启动交互式 shell

```console
docker run --rm -it --name os-shell docker.xuanyuan.run/bitnami/os-shell:latest
```

#### 4.2.2 执行一次性命令

直接运行指定命令，完成后容器自动退出：

```console
# 示例：执行 echo 命令
docker run --rm --name os-shell docker.xuanyuan.run/bitnami/os-shell:latest echo "Hello from os-shell"

# 示例：执行脚本文件（需挂载本地脚本到容器）
docker run --rm -v $(pwd)/script.sh:/tmp/script.sh --name os-shell docker.xuanyuan.run/bitnami/os-shell:latest sh /tmp/script.sh
```

### 4.3 配置说明

#### 4.3.1 FIPS 模式配置（Bitnami Secure Images）

若使用 Bitnami Secure Images 版本，可通过环境变量配置 OpenSSL FIPS 模式：

- **环境变量**：`OPENSSL_FIPS`
  - 取值：`yes`（默认，启用 FIPS 模式）、`no`（禁用 FIPS 模式）

```console
# 示例：禁用 FIPS 模式运行容器
docker run --rm -e OPENSSL_FIPS=no --name os-shell docker.xuanyuan.run/bitnami/os-shell:latest
```

## 5. 重要注意事项

### 5.1 Bitnami 镜像仓库政策变更（2025年8月28日起）

Bitnami 将对公共镜像目录实施以下变更：

- **非加固镜像逐步弃用**：免费 tier 将停止支持非加固 Debian 基础镜像，逐步移除非最新标签，仅保留少量加固镜像的 `latest` 标签（用于开发目的）
- **现有镜像迁移**：所有历史版本标签（如 `2.50.0`、`10.6`）将在两周内迁移至 `docker.io/bitnamilegacy` 仓库，且不再接收更新
- **生产环境建议**：生产 workload 需采用 Bitnami Secure Images，提供加固容器、CVE 透明度（VEX/KEV）、SBOMs 及企业支持

详细说明参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。

### 5.2 Bitnami Secure Images 核心优势

- **安全加固**：基于 Photon Linux 构建，攻击面小，支持安全基线配置
- **漏洞透明**：通过 VEX/KEV 提供 CVE 风险评估，包含 EPSS 评分
- **持续更新**：上游补丁发布后数小时内完成镜像更新，保障安全性
- **合规支持**：提供 SLSA-3 合规的构建元数据（签名证明、SBOMs、病毒扫描报告）
- **跨格式一致性**：与 Bitnami 虚拟机、云镜像采用统一组件与配置，便于环境切换

## 6. 支持的标签

Bitnami 镜像采用滚动标签（rolling tags）与不可变标签（immutable tags）策略，详细说明参见 [Bitnami 标签政策文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

各标签对应关系可查看仓库分支目录下的 `tags-info.yaml` 文件（路径示例：`bitnami/os-shell/BRANCH/DISTRO/tags-info.yaml`）。建议通过 [Docker Hub 标签页面](https://hub.docker.com/r/bitnami/os-shell/tags/) 获取最新标签信息，并订阅 [bitnami/containers GitHub 仓库](https://github.com/bitnami/containers) 以接收更新通知。

## 7. 变更记录

### 2024年1月16日起
- 移除 `docker-compose.yaml` 文件（该文件仅用于内部测试）

## 8. 贡献与反馈

### 8.1 代码贡献
通过 [GitHub Pull Request](https://github.com/bitnami/containers/pulls) 提交改进。

### 8.2 问题反馈
使用中遇到的问题可通过 [GitHub Issue](https://github.com/bitnami/containers/issues/new/choose) 提交，提交时请按模板填写环境信息与复现步骤。

## 9. 许可证

本镜像基于 Apache License 2.0 许可协议发布，详细条款参见 [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0)。

版权所有 &copy; 2025 Broadcom。"Broadcom" 指 Broadcom Inc. 及其子公司。
