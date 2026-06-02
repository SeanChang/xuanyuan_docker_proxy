---
image: bitnami/node-exporter
description: "Bitnami安全版node-exporter镜像，用于节点监控，收集主机系统及硬件指标。"
source: https://xuanyuan.cloud/zh/r/bitnami/node-exporter
canonical: https://xuanyuan.cloud/zh/r/bitnami/node-exporter
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/node-exporter" title="bitnami/node-exporter Docker 镜像中文简介、标签列表与拉取命令">bitnami/node-exporter — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/node-exporter" title="bitnami/node-exporter Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/node-exporter</a>

# Bitnami Node Exporter 镜像文档

## 1. 镜像概述与主要用途

### 1.1 镜像概述
Bitnami Node Exporter 镜像是基于 Bitnami Secure Images 计划构建的容器化部署方案，用于快速部署 Node Exporter。Node Exporter 是 Prometheus 生态系统中的核心组件，作为指标导出器，专门收集 Unix 内核暴露的硬件和操作系统指标，并提供可插拔的指标收集机制。

### 1.2 主要用途
- 作为 Prometheus 监控系统的数据源，提供服务器硬件（CPU、内存、磁盘、网络等）和操作系统级指标
- 支持自定义指标收集配置，满足不同监控场景需求
- 提供安全加固的容器化部署方式，适用于开发和生产环境的系统监控

## 2. 核心功能与特性

### 2.1 核心功能
- **可插拔指标收集器**：支持通过配置启用/禁用特定指标收集器，灵活定制监控范围
- **全面指标覆盖**：收集 Unix 系统核心指标，包括 CPU 使用率、内存占用、磁盘 I/O、网络流量、文件系统状态等
- **Prometheus 兼容**：原生支持 Prometheus 数据格式，可直接集成到 Prometheus 监控架构

### 2.2 Bitnami 镜像特性
- **安全加固**：基于最小化 Photon Linux 操作系统，减少攻击面
- **非 root 容器**：默认以非特权用户运行，增强部署安全性
- **供应链安全**：提供 SLSA-3 合规的构建流程，包含软件物料清单（SBOM）、漏洞扫描报告和签名验证
- **持续更新**：上游安全补丁发布后数小时内提供更新镜像，快速响应安全漏洞
- **跨平台一致性**：与 Bitnami 虚拟机和云镜像使用相同配置策略，支持多环境无缝迁移

## 3. 使用场景与适用范围

### 3.1 典型使用场景
- **服务器监控**：部署在物理机或虚拟机上，监控基础设施健康状态
- **容器环境监控**：在 Kubernetes 或 Docker Swarm 集群中监控节点级指标
- **DevOps 流程集成**：作为 CI/CD 流水线的监控组件，跟踪构建和部署环境性能
- **系统性能分析**：收集历史指标用于性能瓶颈排查和容量规划

### 3.2 适用范围
- 需要构建 Prometheus 监控体系的组织
- 对系统级指标有监控需求的 DevOps 团队
- 关注容器安全和供应链完整性的企业环境
- 需快速部署标准化监控组件的开发/测试环境

## 4. 使用方法

### 4.1 获取镜像
推荐从 Docker Hub 拉取预构建镜像：
```console
# 获取最新版
docker pull bitnami/node-exporter:latest

# 获取特定版本（需替换 [TAG] 为具体版本号）
docker pull bitnami/node-exporter:[TAG]
```

### 4.2 快速启动
基本部署命令：
```console
docker run --name node-exporter bitnami/node-exporter:latest
```

### 4.3 网络配置
Node Exporter 默认通过 9100 端口暴露指标。如需与其他容器（如 Prometheus）通信，建议使用 Docker 网络：

#### 步骤 1：创建专用网络
```console
docker network create node-exporter-network --driver bridge
```

#### 步骤 2：在网络中启动 Node Exporter
```console
docker run --name node-exporter --network node-exporter-network bitnami/node-exporter:latest
```

#### 步骤 3：连接其他容器
同一网络中的其他容器可通过容器名 `node-exporter` 和端口 9100 访问指标：
```console
# 示例：使用 curl 测试连接（需在同一网络的容器中执行）
curl http://node-exporter:9100/metrics
```

## 5. 配置说明

### 5.1 收集器配置
Node Exporter 通过收集器（Collectors）获取指标，支持灵活配置：

#### 启用收集器
通过 `--collector.<name>` 标志启用特定收集器：
```console
docker run --name node-exporter bitnami/node-exporter:latest --collector.processes
```

#### 禁用默认收集器
通过 `--no-collector.<name>` 标志禁用默认启用的收集器：
```console
docker run --name node-exporter bitnami/node-exporter:latest --no-collector.loadavg
```

> 收集器完整列表及平台支持情况请参考 [Prometheus 官方文档](https://prometheus.io/docs/instrumenting/exporters/#node-exporter)

### 5.2 FIPS 模式配置
Bitnami Secure Images 支持 FIPS (Federal Information Processing Standards) 模式，通过环境变量配置：

| 环境变量       | 描述                     | 取值范围       | 默认值 |
|----------------|--------------------------|----------------|--------|
| `OPENSSL_FIPS` | 启用/禁用 OpenSSL FIPS 模式 | `yes` 或 `no` | `yes`  |

配置示例：
```console
docker run --name node-exporter -e OPENSSL_FIPS=no bitnami/node-exporter:latest
```

## 6. 日志管理

### 6.1 查看日志
容器日志默认输出到标准输出（stdout），可通过以下命令查看：
```console
docker logs node-exporter
```

### 6.2 日志驱动配置
可通过 `--log-driver` 参数自定义日志驱动（如使用 `journald` 或 `syslog`）：
```console
docker run --name node-exporter --log-driver journald bitnami/node-exporter:latest
```

## 7. 维护与升级

### 7.1 升级步骤
#### 步骤 1：获取最新镜像
```console
docker pull bitnami/node-exporter:latest
```

#### 步骤 2：停止并备份当前容器
```console
# 停止容器
docker stop node-exporter

# 备份相关数据（如自定义配置）
rsync -a /path/to/node-exporter-config /path/to/node-exporter-config.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### 步骤 3：移除旧容器
```console
docker rm -v node-exporter
```

#### 步骤 4：启动新容器
```console
docker run --name node-exporter bitnami/node-exporter:latest
```

## 8. 注意事项

### 8.1 Bitnami 镜像仓库变更通知（2025年8月28日起）
- 现有非加固 Debian 基础镜像将逐步从 `docker.io/bitnami` 迁移至 `docker.io/bitnamilegacy` 仓库，且不再接收更新
- 免费用户可访问的镜像将限于最新标签（latest）的加固版本，主要用于开发环境
- 生产环境建议使用 Bitnami Secure Images 商业版，提供长期支持和全面安全保障

详细信息请参考 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)

### 8.2 非 root 容器说明
本镜像默认以非 root 用户运行，提供额外安全层。运行特权操作时需注意权限配置，详细信息参考 [Bitnami 非 root 容器文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html)

### 8.3 标签支持策略
- 滚动标签（如 `latest`）：指向最新稳定版本，持续更新
- 固定版本标签（如 `2.50.0`）：已迁移至 `bitnamilegacy` 仓库，不再更新

标签策略详情请参考 [Bitnami 容器标签文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

## 9. 显著变更

### 2024年1月16日起
- 移除 `docker-compose.yaml` 文件，该文件仅用于内部测试目的

## 10. 贡献与反馈

### 10.1 贡献代码
欢迎通过 GitHub 仓库提交贡献：
- 代码仓库：[bitnami/containers](https://github.com/bitnami/containers)
- 贡献指南：提交 Issue 或 Pull Request

### 10.2 问题反馈
如遇部署或使用问题，请通过以下方式反馈：
- GitHub Issues：[bitnami/containers/issues](https://github.com/bitnami/containers/issues)
- 社区支持：[Bitnami 社区论坛](https://community.bitnami.com/)

## 11. 许可协议
本镜像基于 Apache License 2.0 许可协议发布。详细条款请参见 [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0)。

> 注：Node Exporter 本身及第三方组件可能使用不同许可协议，详见各组件官方文档。Bitnami 商标归 Broadcom 所有。
