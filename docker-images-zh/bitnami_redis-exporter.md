---
image: bitnami/redis-exporter
description: "Bitnami安全镜像，集成redis-exporter工具，用于安全导出Redis监控指标。"
source: https://xuanyuan.cloud/zh/r/bitnami/redis-exporter
canonical: https://xuanyuan.cloud/zh/r/bitnami/redis-exporter
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/redis-exporter" title="bitnami/redis-exporter Docker 镜像中文简介、标签列表与拉取命令">bitnami/redis-exporter — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/redis-exporter" title="bitnami/redis-exporter Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/redis-exporter</a>

# Bitnami Redis Exporter 镜像文档

## 1. 镜像概述和主要用途

### 1.1 什么是 Redis Exporter？

Redis Exporter 用于收集 Redis® 指标，供 Prometheus 监控系统使用。

[Redis Exporter 概述](https://github.com/oliver006/redis_exporter)

**商标说明**：本软件列表由 Bitnami 打包。所提及的商标分属各自公司所有，使用此类商标并不意味着任何关联或背书。

## 2. 核心功能和特性

### 2.1 Bitnami 安全镜像优势

- 构建 Bitnami 安全镜像和 Helm 图表旨在提升开源软件的安全性和企业级可用性。
- 通过行业标准漏洞可利用性交换（VEX）、已知被利用漏洞目录（KEV）和 EPSS 评分，更快地分类安全漏洞并透明呈现 CVE 风险。
- 硬化镜像采用最小化操作系统（Photon Linux），在通过行业标准包格式保持可扩展性的同时，减少攻击面。
- 持续构建的镜像在上游补丁发布后数小时内更新，确保更安全的合规性。
- Bitnami 容器、虚拟机和云镜像使用相同的组件和配置方法，便于根据项目需求在不同格式间切换。
- 硬化镜像附带证明签名（Notation）、软件物料清单（SBOM）、病毒扫描报告及其他元数据，均在符合 SLSA-3 标准的软件工厂中生成。

### 2.2 非 root 容器优势

非 root 容器镜像增加了一层额外安全性，通常推荐用于生产环境。尽管以非 root 用户运行会限制特权任务，但能有效降低安全风险。更多关于非 root 容器的信息，请参阅 [Bitnami 文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html)。

## 3. 使用场景和适用范围

- **Redis 监控**：适用于需要通过 Prometheus 收集 Redis 实例关键指标（如内存使用、命中率、连接数等）的场景。
- **监控系统集成**：作为 Prometheus 监控架构的一部分，为 Grafana 等可视化平台提供数据源。
- **开发与生产环境**：支持开发阶段的本地测试及生产环境的 Redis 性能与健康状态监控。

## 4. 重要通知：Bitnami 镜像目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共镜像目录，通过新的 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications) 提供精选的硬化、安全聚焦镜像。过渡内容包括：

- 首次向社区用户开放热门容器镜像的安全优化版本访问权限。
- Bitnami 将开始弃用免费层中非硬化的 Debian 基础软件镜像，并逐步从公共目录中移除非最新标签。社区用户将只能访问数量减少的硬化镜像，这些镜像仅以 “latest” 标签发布，适用于开发目的。
- 自 8 月 28 日起，在两周内，所有现有容器镜像（包括旧版本或特定版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至 “Bitnami Legacy” 仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用 Bitnami Secure Images，包括硬化容器、更小的攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 及企业支持。

这些变更旨在通过推广软件供应链完整性最佳实践和最新部署，提升所有 Bitnami 用户的安全态势。更多详情，请访问 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。

## 5. 支持的标签及对应 Dockerfile 链接

了解 Bitnami 标签策略及滚动标签与不可变标签的区别，请参阅 [Bitnami 文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

可通过分支文件夹中的 `tags-info.yaml` 文件查看不同标签的对应关系（例如 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）。

订阅项目更新，请关注 [bitnami/containers GitHub 仓库](https://github.com/bitnami/containers)。

## 6. 使用方法和配置说明

### 6.1 获取镜像

推荐通过 Docker Hub 拉取预构建镜像：

```console
docker pull bitnami/redis-exporter:latest
```

如需使用特定版本，可拉取带版本标签的镜像。查看 [Docker Hub 标签列表](https://hub.docker.com/r/bitnami/redis-exporter/tags/) 获取可用版本：

```console
docker pull bitnami/redis-exporter:[TAG]
```

如需手动构建镜像，克隆仓库后执行 `docker build`：

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM  # 替换为实际路径
docker build -t bitnami/redis-exporter:latest .
```

### 6.2 快速启动

```console
docker run --name redis-exporter bitnami/redis-exporter:latest
```

### 6.3 连接其他容器

通过 [Docker 容器网络](https://docs.docker.com/engine/userguide/networking/)，容器间可通过容器名称作为主机名通信。

#### 步骤 1：创建网络

```console
docker network create redis-exporter-network --driver bridge
```

#### 步骤 2：在网络中启动 Redis Exporter

```console
docker run --name redis-exporter-node1 --network redis-exporter-network bitnami/redis-exporter:latest
```

#### 步骤 3：启动其他容器

使用相同 `--network` 参数启动其他容器，容器名称可作为网络内主机名使用。

### 6.4 配置

#### 6.4.1 Redis Exporter 配置参数

所有配置参数请参考 [redis_exporter 官方文档](https://github.com/oliver006/redis_exporter#flags)。

#### 6.4.2 FIPS 配置（Bitnami 安全镜像）

Bitnami Secure Images 支持 FIPS 模式配置，通过以下环境变量设置：

- `OPENSSL_FIPS`：是否启用 OpenSSL FIPS 模式。可选值：`yes`（默认）、`no`。

### 6.5 日志

容器日志输出至 `stdout`，可通过以下命令查看：

```console
docker logs redis-exporter
```

可通过 `--log-driver` 选项配置 [日志驱动](https://docs.docker.com/engine/admin/logging/overview/)，默认使用 `json-file` 驱动。

### 6.6 维护与升级

#### 升级镜像步骤：

1. **拉取更新镜像**：
   ```console
   docker pull bitnami/redis-exporter:latest
   ```

2. **停止当前容器**：
   ```console
   docker stop redis-exporter
   ```

3. **删除当前容器**：
   ```console
   docker rm -v redis-exporter
   ```

4. **使用新镜像启动容器**：
   ```console
   docker run --name redis-exporter bitnami/redis-exporter:latest
   ```

## 7. 重要变更

### 2024 年 1 月 16 日起

- `docker-compose.yaml` 文件已移除，该文件仅用于内部测试。

## 8. 贡献

欢迎贡献代码或功能建议，可通过 [Issue](https://github.com/bitnami/containers/issues) 提交需求或 [Pull Request](https://github.com/bitnami/containers/pulls) 贡献代码。

## 9. 问题反馈

如运行容器时遇到问题，请提交 [Issue](https://github.com/bitnami/containers/issues/new/choose)，并按模板填写详细信息以获得更好支持。

## 10. 许可协议

Copyright © 2025 Broadcom. "Broadcom" 指 Broadcom Inc. 及其子公司。

根据 Apache License 2.0 许可协议授权（“许可协议”）；未经许可，不得使用本文件。可在以下地址获取许可协议副本：

<http://www.apache.org/licenses/LICENSE-2.0>

除非法律要求或书面同意，软件按“原样”分发，不提供任何明示或暗示的担保或条件。详情请参阅许可协议。
