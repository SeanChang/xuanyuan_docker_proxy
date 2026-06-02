---
image: bitnami/jmx-exporter
description: "Bitnami提供的安全镜像，用于运行jmx-exporter以导出JMX指标，适用于Java应用监控场景。"
source: https://xuanyuan.cloud/zh/r/bitnami/jmx-exporter
canonical: https://xuanyuan.cloud/zh/r/bitnami/jmx-exporter
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/jmx-exporter" title="bitnami/jmx-exporter Docker 镜像中文简介、标签列表与拉取命令">bitnami/jmx-exporter — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/jmx-exporter" title="bitnami/jmx-exporter Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/jmx-exporter</a>

# Bitnami JMX Exporter 镜像文档


## 1. 镜像概述和主要用途

### 1.1 关于 JMX Exporter
JMX Exporter 是一个用于通过 HTTP 暴露 JMX Beans 指标的工具，供 Prometheus 抓取和监控。它允许将 Java 应用程序的 JMX 指标转换为 Prometheus 可识别的格式，是 Java 应用监控的关键组件。

### 1.2 Bitnami 镜像特点
本镜像是由 Bitnami 打包的 JMX Exporter 安全镜像，属于 [Bitnami Secure Images](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications) 计划的一部分。该镜像基于安全加固理念构建，旨在提供更可靠、更安全的容器化部署选项。

> **重要通知**：自 2025 年 8 月 28 日起，Bitnami 将逐步迁移非硬化的 Debian 基础镜像至 "Bitnami Legacy" 仓库（docker.io/bitnamilegacy），且不再提供更新。社区用户可免费使用安全加固的 "latest" 标签镜像（适用于开发环境），生产环境建议采用商业版 Bitnami Secure Images。


## 2. 核心功能和特性

### 2.1 JMX Exporter 核心功能
- 将 Java 应用的 JMX Beans 指标通过 HTTP 接口暴露，支持 Prometheus 抓取
- 灵活的配置方式，可自定义需要暴露的指标（详见 [JMX Exporter 官方配置文档](https://github.com/prometheus/jmx_exporter#configuration)）

### 2.2 Bitnami 安全镜像特性
- **安全加固**：基于最小化操作系统（Photon Linux），减少攻击面
- **CVE 透明度**：通过 VEX/KEV 标准提供漏洞可利用性信息，支持 EPSS 评分
- **供应链安全**：提供软件物料清单（SBOM）、签名验证（Notation）、病毒扫描报告，符合 SLSA-3 合规性
- **快速漏洞修复**：上游补丁发布后数小时内更新镜像，确保安全性
- **跨平台一致性**：容器、虚拟机和云镜像使用相同组件和配置，便于格式切换
- **非 root 运行**：默认以非 root 用户启动，增强生产环境安全性


## 3. 使用场景和适用范围

### 3.1 适用场景
- **Java 应用监控**：需收集 JVM 或 Java 应用内部指标（如内存使用、线程数、业务指标）的场景
- **Prometheus 监控体系**：作为 Prometheus 监控管道的一部分，将 JMX 指标转换为 Prometheus 格式
- **容器化环境**：Kubernetes、Docker Swarm 等容器编排平台中的 Java 服务监控
- **微服务架构**：分布式 Java 微服务的统一指标采集

### 3.2 适用范围
- 开发环境：快速搭建 JMX 指标暴露测试环境
- 生产环境（需商业版）：通过 Bitnami Secure Images 商业版获得长期支持和企业级保障


## 4. 使用方法和配置说明

### 4.1 获取镜像
推荐从 Docker Hub 拉取预构建镜像：

```console
# 拉取最新版（安全加固版本）
docker pull bitnami/jmx-exporter:latest

# 拉取特定版本（仅 legacy 仓库提供，不再更新）
docker pull bitnamilegacy/jmx-exporter:[TAG]  # 如 2.50.0
```

如需自定义构建，可克隆 Bitnami 容器仓库并构建：

```console
git clone https://github.com/bitnami/containers.git
cd containers/bitnami/jmx-exporter/[VERSION]/[OS]  # 替换 VERSION 和 OS（如 photon）
docker build -t bitnami/jmx-exporter:latest .
```


### 4.2 基本运行命令
快速启动 JMX Exporter 容器：

```console
docker run --name jmx-exporter -p 9404:9404 bitnami/jmx-exporter:latest
```

> 说明：默认暴露 9404 端口（JMX Exporter 标准端口），可通过 `-p` 映射至主机端口。


### 4.3 网络配置（连接其他容器）
通过 Docker 网络实现容器间通信（如监控同一网络中的 Java 应用）：

#### 步骤 1：创建自定义网络
```console
docker network create jmx-exporter-network --driver bridge
```

#### 步骤 2：启动 JMX Exporter 并加入网络
```console
docker run --name jmx-exporter --network jmx-exporter-network bitnami/jmx-exporter:latest
```

#### 步骤 3：连接其他容器
其他容器（如 Java 应用）加入同一网络后，可通过容器名（`jmx-exporter`）访问 JMX Exporter 服务。


### 4.4 配置 JMX Exporter
JMX Exporter 配置需通过配置文件定义（详见 [官方配置文档](https://github.com/prometheus/jmx_exporter#configuration)）。可通过挂载配置文件到容器实现自定义配置：

```console
docker run --name jmx-exporter -v /本地配置路径/config.yaml:/opt/bitnami/jmx-exporter/conf/config.yaml bitnami/jmx-exporter:latest
```


### 4.5 FIPS 模式配置（仅 Bitnami Secure Images）
安全加固镜像支持 FIPS（联邦信息处理标准）模式，通过环境变量配置：

| 环境变量       | 说明                                                                 | 默认值 |
|----------------|----------------------------------------------------------------------|--------|
| `OPENSSL_FIPS` | 是否启用 OpenSSL FIPS 模式，可选值：`yes`（启用）、`no`（禁用）       | `yes`  |

示例：禁用 FIPS 模式

```console
docker run --name jmx-exporter -e OPENSSL_FIPS=no bitnami/jmx-exporter:latest
```


## 5. 日志管理

容器日志默认输出至 `stdout`，可通过 `docker logs` 查看：

```console
docker logs jmx-exporter
```

如需自定义日志驱动（如输出至文件或集中式日志系统），可通过 `--log-driver` 指定（需 Docker 支持）：

```console
docker run --name jmx-exporter --log-driver json-file --log-opt max-size=10m bitnami/jmx-exporter:latest
```


## 6. 维护与升级

### 6.1 升级镜像
1. **拉取最新镜像**：
   ```console
   docker pull bitnami/jmx-exporter:latest
   ```

2. **停止并删除旧容器**：
   ```console
   docker stop jmx-exporter
   docker rm -v jmx-exporter  # -v 移除关联的数据卷（如无持久化数据可省略）
   ```

3. **启动新容器**：
   ```console
   docker run --name jmx-exporter -p 9404:9404 bitnami/jmx-exporter:latest
   ```


## 7. 变更记录

### 2024 年 1 月 16 日起
- 移除 `docker-compose.yaml` 文件（仅用于内部测试，不推荐生产使用）


## 8. 贡献与反馈

- **贡献代码**：通过 [Bitnami Containers 仓库](https://github.com/bitnami/containers) 提交 PR
- **问题反馈**：在 [GitHub Issues](https://github.com/bitnami/containers/issues) 提交 bug 或功能需求


## 9. 版权信息

Copyright © 2025 Broadcom. "Broadcom" 指 Broadcom Inc. 及其子公司。

本镜像基于 Apache License 2.0 许可分发，详见 [LICENSE](http://www.apache.org/licenses/LICENSE-2.0)。

> 商标说明：本镜像由 Bitnami 打包，相关商标归各自公司所有，使用不代表关联或背书。
