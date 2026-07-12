---
image: bitnami/mongodb-exporter
description: "Bitnami mongodb-exporter安全镜像，用于导出MongoDB监控指标，提供安全可靠的指标采集与导出功能。"
source: https://xuanyuan.cloud/zh/r/bitnami/mongodb-exporter
canonical: https://xuanyuan.cloud/zh/r/bitnami/mongodb-exporter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/mongodb-exporter" title="bitnami/mongodb-exporter Docker 镜像中文简介、标签列表与拉取命令">bitnami/mongodb-exporter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MongoDB Exporter (Bitnami 镜像)

## 1. 镜像概述和主要用途

MongoDB Exporter 是一款用于 MongoDB® 的 Prometheus 导出器，支持监控 MongoDB 的分片集群、复制集及存储引擎等核心组件。本镜像由 Bitnami 打包，旨在提供安全、易用且标准化的容器化部署方案，便于快速集成到 Prometheus 监控体系中。

> **商标说明**：本软件列表由 Bitnami 打包，提及的相关商标分属各自公司所有，使用此类商标不意味着任何关联或背书。

## 2. 核心功能与特性

### 2.1 MongoDB Exporter 核心功能
- 支持 MongoDB 分片集群、复制集及独立实例的全面监控
- 收集关键指标：连接数、操作吞吐量、索引性能、存储使用量、复制延迟等
- 兼容 Prometheus 指标格式，支持 Grafana 可视化集成

### 2.2 Bitnami 镜像特性
- **安全加固**：基于最小化操作系统（Photon Linux）构建，减少攻击面
- **供应链安全**：SLSA-3 合规构建流程，提供签名验证（Notation）、软件物料清单（SBOM）及病毒扫描报告
- **漏洞透明**：通过 VEX（漏洞可利用性交换）、KEV（已知被利用漏洞）及 EPSS 评分提供 CVE 风险透明度
- **非 root 容器**：默认以非特权用户运行，增强生产环境安全性
- **标准化配置**：与 Bitnami 虚拟机、云镜像采用一致的组件和配置策略，便于跨环境迁移

## 3. 使用场景和适用范围

本镜像适用于需要对 MongoDB 数据库进行监控的各类场景：
- 开发/测试环境中 MongoDB 实例的性能调试与问题排查
- 生产环境下 MongoDB 分片集群或复制集的实时状态监控
- 需与 Prometheus + Grafana 集成构建完整监控告警体系的场景
- 对容器镜像安全性、合规性有较高要求的企业级部署

## 4. 快速入门

通过以下命令快速启动 MongoDB Exporter 容器：

```console
docker run --name mongodb-exporter docker.xuanyuan.run/bitnami/mongodb-exporter:latest
```

> **注意**：默认配置需通过环境变量或命令行参数指定 MongoDB 连接信息（见 7. 配置说明）。

## 5. 获取镜像

### 5.1 拉取官方镜像
推荐从 Docker Hub 拉取预构建镜像：

```console
# 拉取最新版
docker pull docker.xuanyuan.run/bitnami/mongodb-exporter:latest

# 拉取特定版本（需替换 [TAG] 为具体版本号，如 0.40.0）
docker pull docker.xuanyuan.run/bitnami/mongodb-exporter:[TAG]
```

### 5.2 本地构建镜像
如需自定义构建，可通过以下步骤操作：

```console
git clone https://github.com/bitnami/containers.git
cd containers/bitnami/mongodb-exporter/[VERSION]/[OS]  # 替换为具体版本和操作系统
docker build -t bitnami/mongodb-exporter:latest .
```

## 6. 网络连接

容器需通过 Docker 网络与 MongoDB 实例及 Prometheus 通信，建议使用自定义桥接网络实现容器互联。

### 6.1 创建专用网络
```console
docker network create mongodb-monitor-net --driver bridge
```

### 6.2 启动 exporter 容器
```console
docker run \
  --name mongodb-exporter \
  --network mongodb-monitor-net \
  docker.xuanyuan.run/bitnami/mongodb-exporter:latest
```

### 6.3 多容器通信
同一网络内的容器可通过容器名作为主机名通信（如 Prometheus 可通过 `mongodb-exporter:9216` 抓取指标）。

## 7. 配置说明

### 7.1 基础配置
MongoDB Exporter 的所有配置参数可通过命令行标志或环境变量指定，完整参数列表参见 [官方文档](https://github.com/percona/mongodb_exporter#flags)。常用配置示例：

```console
docker run \
  --name mongodb-exporter \
  -e MONGODB_URI="mongodb://user:password@mongodb-host:27017/admin?ssl=false" \
  -e EXPORTER_COLLECTORS="dbstats,top" \
  docker.xuanyuan.run/bitnami/mongodb-exporter:latest
```

### 7.2 FIPS 模式配置
Bitnami 安全镜像支持 FIPS（联邦信息处理标准）模式，通过以下环境变量配置：

| 环境变量       | 说明                          | 默认值 | 可选值       |
|----------------|-------------------------------|--------|--------------|
| `OPENSSL_FIPS` | 是否启用 OpenSSL FIPS 模式    | `yes`  | `yes`/`no`   |

## 8. 日志管理

容器日志默认输出至 `stdout`，可通过 Docker 日志驱动进行收集和管理：

### 8.1 查看实时日志
```console
docker logs -f mongodb-exporter
```

### 8.2 配置日志驱动
如需自定义日志收集（如输出至文件或集中式日志系统），可通过 `--log-driver` 指定驱动类型：

```console
docker run \
  --name mongodb-exporter \
  --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  bitnami/mongodb-exporter:latest
```

## 9. 维护与升级

### 9.1 升级镜像步骤
1. **拉取最新镜像**
   ```console
   docker pull docker.xuanyuan.run/bitnami/mongodb-exporter:latest
   ```

2. **停止并移除旧容器**
   ```console
   docker stop mongodb-exporter && docker rm -v mongodb-exporter
   ```

3. **启动新容器**
   ```console
   docker run --name mongodb-exporter docker.xuanyuan.run/bitnami/mongodb-exporter:latest # 需保留原配置参数
   ```

### 9.2 版本迁移注意事项
- 2024 年 1 月 16 日起，官方已移除 `docker-compose.yaml` 文件（仅用于内部测试），生产环境建议使用 Docker CLI 或编排工具（Kubernetes/Helm）部署。

## 10. 重要注意事项

### 10.1 镜像仓库变更通知（2025 年 8 月 28 日起）
Bitnami 将对公共镜像仓库进行调整，核心变更如下：
- **仓库迁移**：所有现有镜像（含历史版本标签，如 `2.50.0`、`10.6`）将迁移至 `docker.io/bitnamilegacy` 仓库，且不再接收更新
- **免费镜像调整**：公共仓库（`docker.io/bitnami`）仅保留安全加固的 `latest` 标签镜像，供开发使用
- **生产环境建议**：企业级用户推荐使用 [Bitnami Secure Images](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)，提供完整版本支持、安全加固及企业级服务

> 详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)

## 11. 贡献与反馈

### 11.1 贡献代码
欢迎通过 GitHub 提交 PR 参与镜像优化，或通过 [issue](https://github.com/bitnami/containers/issues) 提出功能需求。

### 11.2 问题反馈
如遇容器运行问题，请通过 [GitHub Issues](https://github.com/bitnami/containers/issues/new/choose) 提交详细信息（含环境配置、日志及复现步骤）。

## 12. 许可信息

本镜像基于 Apache License 2.0 许可协议分发。您可在 [Apache 官方网站](http://www.apache.org/licenses/LICENSE-2.0) 获取许可协议完整文本。

Copyright © 2025 Broadcom. "Broadcom" 指 Broadcom Inc. 及其子公司。
