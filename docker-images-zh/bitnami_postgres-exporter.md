---
image: bitnami/postgres-exporter
description: "Bitnami提供的安全镜像，用于部署postgres-exporter，可将PostgreSQL数据库指标导出至监控系统，具备安全加固特性。"
source: https://xuanyuan.cloud/zh/r/bitnami/postgres-exporter
canonical: https://xuanyuan.cloud/zh/r/bitnami/postgres-exporter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/postgres-exporter" title="bitnami/postgres-exporter Docker 镜像中文简介、标签列表与拉取命令">bitnami/postgres-exporter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami PostgreSQL Exporter 镜像文档

## 镜像概述和主要用途

PostgreSQL Exporter 用于收集 PostgreSQL 数据库指标，供 Prometheus 监控系统消费。Bitnami 提供的此镜像为安全加固的最小化 CVE 镜像，基于云优化、安全加固的企业级操作系统 Photon Linux 构建和维护。

[PostgreSQL Exporter 概述](https://github.com/wrouesnel/postgres_exporter)  
商标声明：本软件列表由 Bitnami 打包，所提及的商标分属各自公司所有，使用不意味着任何关联或背书。


## 核心功能和特性

- **安全加固**：流行开源软件的安全加固镜像，近零漏洞
- **漏洞管理**：提供漏洞分类与优先级排序，包含 VEX 声明、KEV 和 EPSS 评分
- **合规支持**：支持 FIPS、STIG 和离线部署选项，包含安全软件物料清单（SBOM）
- **供应链安全**：通过 in-toto 提供软件供应链来源证明
- **Helm 图表支持**：一流支持主流 Helm 图表
- **非 root 运行**：默认以非 root 用户运行，增强安全性
- **安全元数据**：每个镜像附带有价值的安全元数据，可在 [Bitnami 公共目录](https://app-catalog.vmware.com/bitnami/apps) 查看（部分数据需 [Bitnami Secure Images 商业订阅](https://bitnami.com/)）


## 使用场景和适用范围

- **生产环境监控**：适用于需要安全加固的 PostgreSQL 数据库监控场景
- **Prometheus 集成**：作为 Prometheus 监控架构的一部分，收集 PostgreSQL 性能指标
- **合规要求场景**：满足 FIPS、STIG 等合规标准的企业环境
- **供应链安全需求**：需要软件供应链来源证明和 SBOM 的场景


## 详细使用方法和配置说明

### 支持的标签及对应 `Dockerfile` 链接

了解 Bitnami 标签策略及滚动标签与不可变标签的区别，请参见 [官方文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

不同标签的对应关系可查看分支文件夹中的 `tags-info.yaml` 文件（如 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）。

可通过关注 [bitnami/containers GitHub 仓库](https://github.com/bitnami/containers) 订阅项目更新。


### 获取镜像

推荐从 Docker Hub 拉取预构建镜像：

```console
docker pull docker.xuanyuan.run/bitnami/postgres-exporter:latest
```

如需特定版本，可拉取带版本的标签。查看 [Docker Hub 可用版本列表](https://hub.docker.com/r/bitnami/postgres-exporter/tags/)：

```console
docker pull docker.xuanyuan.run/bitnami/postgres-exporter:[TAG]
```

也可通过克隆仓库自行构建镜像：

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```


### 快速启动

```console
docker run --name postgres-exporter docker.xuanyuan.run/bitnami/postgres-exporter:latest
```


### 连接其他容器

通过 Docker 容器网络，可实现容器间通信，使用容器名称作为主机名。

#### 步骤 1：创建网络

```console
docker network create postgres-exporter-network --driver bridge
```

#### 步骤 2：在网络中启动 PostgreSQL Exporter

```console
docker run --name postgres-exporter-node1 --network postgres-exporter-network docker.xuanyuan.run/bitnami/postgres-exporter:latest
```

#### 步骤 3：启动其他容器

使用相同 `--network` 参数启动其他容器，设置容器名称后可作为主机名访问：

```console
docker run --name other-container --network postgres-exporter-network [OTHER_IMAGE]
```


### 配置

#### 配置标志

所有配置标志请参考 [postgres_exporter 官方文档](https://github.com/wrouesnel/postgres_exporter#flags)。

#### FIPS 配置（Bitnami Secure Images）

Bitnami Secure Images 版本支持 FIPS 模式配置，通过以下环境变量：

- `OPENSSL_FIPS`：控制 OpenSSL 是否启用 FIPS 模式。可选值：`yes`（默认）、`no`


### 日志

容器日志输出至 `stdout`，查看日志：

```console
docker logs postgres-exporter
```

可通过 `--log-driver` 选项配置 [日志驱动](https://docs.docker.com/engine/admin/logging/overview/)，默认使用 `json-file` 驱动。


### 维护

#### 升级镜像

##### 步骤 1：拉取更新镜像

```console
docker pull docker.xuanyuan.run/bitnami/postgres-exporter:latest
```

##### 步骤 2：停止当前容器

```console
docker stop postgres-exporter
```

##### 步骤 3：删除当前容器

```console
docker rm -v postgres-exporter
```

##### 步骤 4：使用新镜像启动容器

```console
docker run --name postgres-exporter docker.xuanyuan.run/bitnami/postgres-exporter:latest
```


## 非 root 容器说明

非 root 容器镜像增加了额外安全层，通常推荐用于生产环境。由于以非 root 用户运行，特权任务通常受限。更多信息参见 [Bitnami 文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html)。


## 变更记录

### 2024 年 1 月 16 日起

- 移除 `docker-compose.yaml` 文件，该文件仅用于内部测试。


## 贡献

欢迎通过 [issue](https://github.com/bitnami/containers/issues) 提出新功能需求或提交 [pull request](https://github.com/bitnami/containers/pulls) 贡献代码。


## 问题反馈

如运行容器时遇到问题，请提交 [issue](https://github.com/bitnami/containers/issues/new/choose)，并按模板填写信息以获得更好支持。


## 许可证

Copyright &copy; 2025 Broadcom。"Broadcom" 指 Broadcom Inc. 及其子公司。

根据 Apache License 2.0 许可协议授权（"许可协议"）；除非遵守许可协议，否则不得使用本文件。您可在以下地址获取许可协议副本：

<http://www.apache.org/licenses/LICENSE-2.0>

除非适用法律要求或书面同意，否则根据许可协议分发的软件按"原样"分发，不附带任何明示或暗示的担保或条件。详见许可协议了解具体权限和限制。
