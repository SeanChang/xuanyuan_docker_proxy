---
image: bitnamicharts/node-exporter
description: "Bitnami提供的Helm chart，用于在Kubernetes环境中部署Node Exporter，以收集主机系统的硬件和操作系统指标。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/node-exporter
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/node-exporter
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/node-exporter" title="bitnamicharts/node-exporter Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/node-exporter — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnamicharts/node-exporter" title="bitnamicharts/node-exporter Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnamicharts/node-exporter</a>

# Bitnami Node Exporter 镜像文档


## 镜像概述和主要用途

Node Exporter 是 Prometheus 生态中的指标导出器，用于收集 UNIX 内核暴露的硬件和操作系统指标，支持可插拔的指标收集器。Bitnami 提供的 Node Exporter 镜像封装了该工具，简化了在容器环境中的部署和配置，适用于监控 Linux/UNIX 主机的系统性能指标。

[Node Exporter 官方概述](https://prometheus.io/)

**商标声明**：本软件包由 Bitnami 打包。相关商标归各自公司所有，使用此类商标不意味着任何关联或背书。


## 核心功能和特性

### 核心功能
- 收集系统级指标：包括 CPU、内存、磁盘 I/O、网络流量、文件系统、进程状态等硬件和 OS 指标。
- 可插拔收集器架构：支持通过配置启用/禁用特定指标收集器（如 `cpu`、`meminfo`、`diskstats`、`netdev` 等）。
- 文本文件收集器：支持从自定义文本文件中读取指标，便于扩展监控自定义应用或系统状态。

### Bitnami 镜像特性
- 预配置的安全上下文：默认使用非 root 用户（UID 1001）运行，遵循最小权限原则。
- 简化的部署流程：支持 Docker 容器直接运行，或集成到 Kubernetes 环境（通过 Helm Chart）。
- 镜像迁移与安全硬化：2025 年 8 月 28 日后，旧版本镜像迁移至 `bitnamilegacy` 仓库，推荐生产环境使用 Bitnami Secure Images（提供安全硬化、SBOM、CVE 透明度等特性）。


## 使用场景和适用范围

### 适用场景
- **系统监控**：监控 Linux/UNIX 主机的核心性能指标（CPU 使用率、内存占用、磁盘空间、网络吞吐量等）。
- **Prometheus 集成**：作为 Prometheus 的数据源，将收集的指标暴露给 Prometheus 进行存储和分析。
- **自定义指标扩展**：通过文本文件收集器监控应用特定指标（如业务系统状态、自定义健康检查结果等）。

### 适用范围
- **开发/测试环境**：使用公共仓库（`docker.io/bitnami`）的 `latest` 标签镜像，快速部署和验证监控流程。
- **生产环境**：推荐使用 Bitnami Secure Images（需商业许可），获取长期支持、安全硬化和企业级服务。


## ⚠️ 重要通知：Bitnami 镜像目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共镜像目录，推出 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)，重点变更如下：

- **安全镜像开放**：首次向社区用户提供安全优化版容器镜像。
- **非硬化镜像弃用**：免费 tier 将逐步停止支持基于 Debian 的非硬化镜像，公共目录仅保留少量硬化镜像（仅 `latest` 标签，用于开发目的）。
- **镜像仓库迁移**：所有现有容器镜像（包括历史版本标签，如 `2.50.0`、`10.6`）将在 2 周内从 `docker.io/bitnami` 迁移至 `docker.io/bitnamilegacy` 仓库，且不再接收更新。
- **生产环境建议**：生产工作负载需采用 Bitnami Secure Images，包含硬化容器、更小攻击面、CVE 透明度（VEX/KEV）、SBOM 和企业支持。

更多详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


## 使用方法和配置说明

### Docker 快速启动

#### 基础运行命令
Node Exporter 需要访问主机的 `/proc` 和 `/sys` 文件系统以收集指标，通常需使用主机网络模式：

```bash
docker run --name node-exporter -d \
  --net=host \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /var/lib/node-exporter:/var/lib/node-exporter:rw \
  bitnami/node-exporter:latest \
  --path.procfs=/host/proc \
  --path.sysfs=/host/sys \
  --collector.textfile.directory=/var/lib/node-exporter
```

#### 参数说明
- `--net=host`：使用主机网络，使容器可直接访问主机网络栈（默认监听 9100 端口）。
- `-v /proc:/host/proc:ro`：只读挂载主机的 `/proc` 文件系统（进程和系统信息）。
- `-v /sys:/host/sys:ro`：只读挂载主机的 `/sys` 文件系统（内核设备和驱动信息）。
- `-v /var/lib/node-exporter:/var/lib/node-exporter:rw`：挂载目录用于文本文件收集器（自定义指标）。
- 命令行参数：`--path.procfs` 和 `--path.sysfs` 指定主机文件系统路径，`--collector.textfile.directory` 启用文本文件收集器。


### 自定义配置

#### 启用/禁用收集器
通过 `--collector.<name>` 启用收集器，`--no-collector.<name>` 禁用特定收集器。例如，禁用 `diskstats` 收集器：

```bash
docker run --name node-exporter -d \
  --net=host \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  bitnami/node-exporter:latest \
  --path.procfs=/host/proc \
  --path.sysfs=/host/sys \
  --no-collector.diskstats
```

#### 文本文件收集器示例
1. 在主机创建自定义指标文件（如 `/tmp/custom_metrics.prom`）：
   ```prometheus
   # HELP custom_up Custom service status
   # TYPE custom_up gauge
   custom_up 1
   ```
2. 挂载文件到容器并指定收集目录：
   ```bash
   docker run --name node-exporter -d \
     --net=host \
     -v /proc:/host/proc:ro \
     -v /sys:/host/sys:ro \
     -v /tmp/custom_metrics.prom:/var/lib/node-exporter/custom_metrics.prom:ro \
     bitnami/node-exporter:latest \
     --path.procfs=/host/proc \
     --path.sysfs=/host/sys \
     --collector.textfile.directory=/var/lib/node-exporter
   ```


### 安全上下文配置
Bitnami 镜像默认使用非 root 用户运行（UID 1001），可通过 `--user` 调整：

```bash
docker run --name node-exporter -d \
  --net=host \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  --user 1001:1001 \  # 指定用户和组（默认 1001）
  bitnami/node-exporter:latest \
  --path.procfs=/host/proc \
  --path.sysfs=/host/sys
```


## 参数说明

### 镜像相关参数

| 参数名                | 描述                                                                 | 默认值                          |
|-----------------------|----------------------------------------------------------------------|---------------------------------|
| `image.registry`      | 镜像仓库地址                                                         | `docker.io`                     |
| `image.repository`    | 镜像名称                                                             | `bitnami/node-exporter`（2025年8月28日前）；`bitnamilegacy/node-exporter`（旧版本） |
| `image.tag`           | 镜像标签                                                             | `latest`                        |
| `image.pullPolicy`    | 镜像拉取策略                                                         | `IfNotPresent`                  |


### 容器配置参数

| 参数名                          | 描述                                                                 | 默认值       |
|---------------------------------|----------------------------------------------------------------------|--------------|
| `containerPorts.metrics`        | 容器暴露的指标端口                                                   | `9100`       |
| `podSecurityContext.fsGroup`    | 文件系统组 ID                                                        | `1001`       |
| `containerSecurityContext.runAsUser` | 运行用户 UID                                                     | `1001`       |
| `containerSecurityContext.runAsGroup` | 运行用户组 GID                                                   | `1001`       |
| `extraArgs`                     | 传递给 Node Exporter 的额外命令行参数（如 `--collector.<name>`）     | `{}`         |


### 挂载卷配置

| 挂载路径                  | 用途                                  | 权限   |
|---------------------------|---------------------------------------|--------|
| `/host/proc`              | 主机 proc 文件系统（进程和系统信息）  | 只读   |
| `/host/sys`               | 主机 sys 文件系统（内核设备信息）     | 只读   |
| `/var/lib/node-exporter`  | 文本文件收集器目录（自定义指标）      | 读写   |


## 注意事项

- **主机网络依赖**：Node Exporter 需访问主机网络和系统文件，生产环境建议通过 DaemonSet 部署在 Kubernetes 中，或直接在主机上以容器运行（使用 `--net=host`）。
- **镜像迁移**：2025 年 8 月 28 日后，旧版本镜像需从 `bitnamilegacy` 仓库拉取（如 `docker pull bitnamilegacy/node-exporter:2.50.0`）。
- **生产环境**：长期支持和安全保障需采用 Bitnami Secure Images，具体参见 [VMware Tanzu Application Catalog](https://bitnami.com/enterprise)。
