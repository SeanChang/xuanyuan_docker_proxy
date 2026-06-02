---
image: bitnami/flink
description: "Bitnami安全镜像为Apache Flink提供预配置、安全强化的运行环境，适用于部署流处理与批处理应用。"
source: https://xuanyuan.cloud/zh/r/bitnami/flink
canonical: https://xuanyuan.cloud/zh/r/bitnami/flink
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/flink" title="bitnami/flink Docker 镜像中文简介、标签列表与拉取命令">bitnami/flink — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/flink" title="bitnami/flink Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/flink</a>

# Bitnami Apache Flink 镜像文档

## 镜像概述和主要用途

### Apache Flink 简介
Apache Flink 是一个框架和分布式处理引擎，用于对无界和有界数据流进行有状态计算。它支持实时流处理和批处理作业，提供高吞吐量、低延迟的数据处理能力。

### Bitnami 镜像概述
Bitnami Apache Flink 镜像是经过安全加固的容器化解决方案，旨在简化 Flink 的部署与管理。该镜像基于 Bitnami Secure Images 计划，提供最小化攻击面、透明的漏洞管理和跨格式一致的配置方式，适用于开发测试（免费版）和生产环境（企业版）。

## 核心功能和特性

- **安全加固**：通过 SLSA-3 合规软件工厂构建，包含签名证明（Notation）、SBOM、病毒扫描报告等元数据。
- **最小化操作系统**：基于 Photon Linux，减少攻击面同时保持标准包格式的可扩展性。
- **漏洞透明度**：通过 VEX/KEV 和 EPSS 评分提供 CVE 风险评估，快速响应安全漏洞。
- **持续更新**：上游补丁发布后数小时内更新镜像，确保安全性与合规性。
- **跨格式一致性**：与 Bitnami 虚拟机、云镜像使用相同组件和配置方法，便于部署格式切换。
- **多模式支持**：支持 Flink 多种运行模式（JobManager、TaskManager、Standalone Job、History Server）。

## 使用场景和适用范围

### 适用场景
- **实时流处理**：实时日志分析、监控告警、数据 ETL 等无界数据流处理。
- **批处理作业**：大规模数据集批处理、数据分析报告生成等有界数据处理。
- **混合处理**：同时处理流数据和批数据的混合计算场景。

### 适用环境
- **开发与测试**：免费版 Bitnami Secure Images（latest 标签）提供基础功能和安全加固，适合开发测试。
- **生产环境**：企业版提供完整应用目录、长期支持和企业服务，适合生产工作负载。

## 详细使用方法和配置说明

### 获取镜像

#### 拉取预构建镜像
推荐从 Docker Hub 拉取：
```console
docker pull bitnami/flink:latest
```

指定版本（注意：2025年8月28日后，非 latest 标签将迁移至 `docker.io/bitnamilegacy`）：
```console
docker pull bitnami/flink:[TAG]
```

#### 源码构建
```console
git clone https://github.com/bitnami/containers.git
cd bitnami/flink/[VERSION]/[OPERATING-SYSTEM]
docker build -t bitnami/flink:latest .
```

### 基本运行命令

#### 快速启动（默认 JobManager 模式）
```console
docker run --name flink bitnami/flink:latest
```

#### 查看支持的运行模式
```console
docker run --rm -e FLINK_MODE=help --name flink bitnami/flink:latest
```
输出：
```
Usage: FLINK_MODE=(jobmanager|standalone-job|taskmanager|history-server)

  By default, the Apache Flink Packaged by Bitnami image will run in jobmanager mode.
  Also, by default, Apache Flink Packaged by Bitnami image adopts jemalloc as default memory allocator. This behavior can be disabled by setting the 'DISABLE_JEMALLOC' environment variable to 'true'.
```

### Docker Compose 配置示例
**注意**：此文件未经过内部测试，仅建议用于开发测试。生产环境推荐使用 [Bitnami Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/flink)。

```yaml
version: '3'

services:
  jobmanager:
    image: bitnami/flink:latest
    environment:
      - FLINK_MODE=jobmanager
      - FLINK_CFG_REST_PORT=8081
    ports:
      - "8081:8081"

  taskmanager:
    image: bitnami/flink:latest
    environment:
      - FLINK_MODE=taskmanager
      - FLINK_CFG_REST_PORT=8081
      - FLINK_TASK_MANAGER_NUMBER_OF_TASK_SLOTS=2
    depends_on:
      - jobmanager
```

启动服务：
```console
docker-compose up -d
```

### 环境变量配置

#### 可自定义环境变量

| 名称                                  | 描述                                                                 | 默认值                                 |
|---------------------------------------|----------------------------------------------------------------------|---------------------------------------|
| `FLINK_MODE`                          | Flink 运行模式                                                       | `jobmanager`                          |
| `FLINK_CFG_REST_PORT`                 | 客户端连接的 REST 端口                                                | `8081`                                |
| `FLINK_TASK_MANAGER_NUMBER_OF_TASK_SLOTS` | TaskManager 的任务槽数量                                          | `$(grep -c ^processor /proc/cpuinfo)` |
| `FLINK_PROPERTIES`                    | Flink 集群配置选项列表（换行分隔，格式同 flink-conf）                  | `nil`                                 |

#### 只读环境变量

| 名称                     | 描述                                                                 | 值                                      |
|--------------------------|----------------------------------------------------------------------|----------------------------------------|
| `FLINK_BASE_DIR`         | Flink 安装目录                                                       | `${BITNAMI_ROOT_DIR}/flink`            |
| `FLINK_BIN_DIR`          | Flink 二进制文件目录                                                 | `${FLINK_BASE_DIR}/bin`                |
| `FLINK_WORK_DIR`         | Flink 工作目录                                                       | `${FLINK_BASE_DIR}`                    |
| `FLINK_LOG_DIR`          | Flink 日志目录                                                       | `${FLINK_BASE_DIR}/log`                |
| `FLINK_CONF_DIR`         | Flink 配置目录                                                       | `${FLINK_BASE_DIR}/conf`               |
| `FLINK_DEFAULT_CONF_DIR` | Flink 默认配置目录                                                   | `${FLINK_BASE_DIR}/conf.default`       |
| `FLINK_CONF_FILE`        | Flink 配置文件名                                                     | `config.yaml`                          |
| `FLINK_CONF_FILE_PATH`   | Flink 配置文件路径                                                   | `${FLINK_CONF_DIR}/${FLINK_CONF_FILE}` |
| `FLINK_VOLUME_DIR`       | 挂载配置文件的目录                                                    | `${BITNAMI_VOLUME_DIR}/flink`          |
| `FLINK_DATA_TO_PERSIST`  | 需持久化的文件（相对于 Flink 安装目录，多值用空格分隔）                | `conf plugins`                         |
| `FLINK_DAEMON_USER`      | Flink 守护进程用户                                                   | `flink`                                |
| `FLINK_DAEMON_GROUP`     | Flink 守护进程用户组                                                 | `flink`                                |

### 运行模式详解

#### JobManager（默认模式）
启动 JobManager 并暴露 REST 端口：
```console
docker run --name flink-jobmanager -p 8081:8081 bitnami/flink:latest
```

#### TaskManager
启动 TaskManager 连接到 JobManager：
```console
docker run --name flink-taskmanager -e FLINK_MODE=taskmanager -e FLINK_CFG_REST_PORT=8081 bitnami/flink:latest
```

#### Standalone Job
运行独立作业（需挂载作业 JAR）：
```console
docker run --name flink-standalone -e FLINK_MODE=standalone-job -v /local/job.jar:/opt/bitnami/flink/job.jar bitnami/flink:latest
```

#### History Server
启动历史服务器：
```console
docker run --name flink-history -e FLINK_MODE=history-server bitnami/flink:latest
```

### FIPS 配置（Bitnami Secure Images）
通过以下环境变量配置 FIPS 模式：
- `OPENSSL_FIPS`：是否启用 OpenSSL FIPS 模式，默认 `yes`（启用），设为 `no` 禁用。

## 重要通知：Bitnami 镜像目录变更

自 2025 年 8 月 28 日起，Bitnami 将升级公共目录，主要变更：
- 免费版仅提供加固的 latest 标签镜像（适合开发），非加固 Debian 镜像逐步弃用。
- 所有现有镜像（含旧版本标签）将迁移至 `docker.io/bitnamilegacy` 仓库，不再更新。
- 生产环境建议使用企业版 Bitnami Secure Images，提供长期支持和完整安全特性。

详情见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。

## 为什么使用非 root 容器？
非 root 容器增加安全层，降低特权任务被滥用的风险，推荐用于生产环境。详情参见 [Bitnami 非 root 容器文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html)。

## 贡献与反馈

- **贡献**：通过 [GitHub Pull Request](https://github.com/bitnami/containers/pulls) 提交改进，遵循 [贡献指南](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md)。
- **问题反馈**：通过 [GitHub Issues](https://github.com/bitnami/containers/issues/new/choose) 提交问题，填写模板以获得支持。

## 许可证
Copyright © 2025 Broadcom。"Broadcom" 指 Broadcom Inc. 及其子公司。  
本软件基于 Apache License 2.0 许可证授权，详见 [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)。
