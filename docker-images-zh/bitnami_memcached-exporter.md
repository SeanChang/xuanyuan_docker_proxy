---
image: bitnami/memcached-exporter
description: "Bitnami提供的memcached-exporter安全镜像，用于从memcached服务器导出指标供Prometheus监控，基于Photon Linux构建，具备高安全性、低漏洞特性及合规支持。"
source: https://xuanyuan.cloud/zh/r/bitnami/memcached-exporter
canonical: https://xuanyuan.cloud/zh/r/bitnami/memcached-exporter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/memcached-exporter" title="bitnami/memcached-exporter Docker 镜像中文简介、标签列表与拉取命令">bitnami/memcached-exporter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Memcached Exporter 镜像文档

## 概述和主要用途

Bitnami Memcached Exporter镜像是用于部署memcached-exporter的安全容器镜像。memcached-exporter是一款从memcached服务器导出指标供Prometheus监控的工具。该镜像由Bitnami构建维护，基于云优化、安全强化的企业级操作系统Photon Linux，属于Bitnami Secure Images（BSI）系列，旨在提供高安全性、低漏洞风险的开源软件部署方案。

## 核心功能和特性

### 安全强化特性
- **低漏洞风险**：提供热门开源软件的强化安全镜像，实现近零漏洞（Near-Zero Vulnerabilities）
- **漏洞管理**：支持漏洞分类与优先级划分，提供VEX声明、KEV（已知被利用漏洞）和EPSS（漏洞利用预测评分系统）评分
- **合规性支持**：聚焦合规需求，提供FIPS、STIG及空气隔离选项，包含安全物料清单（SBOM）
- **软件供应链安全**：通过in-toto提供软件供应链来源证明
- **生态集成**：原生支持主流Helm charts

### 容器安全特性
- **非root容器**：默认以非root用户运行，增加额外安全层，适合生产环境；限制特权任务执行，降低攻击面

## 使用场景和适用范围

适用于生产环境中需要对memcached服务器进行监控的场景，尤其适合对容器安全性、软件供应链合规性有严格要求的企业级应用。可作为Prometheus监控体系的一部分，实现memcached性能指标的采集与分析。

## 使用方法

### 快速启动（TL;DR）

```console
docker run --name memcached-exporter docker.xuanyuan.run/bitnami/memcached-exporter:latest
```

### 获取镜像

#### 拉取预构建镜像
推荐从Docker Hub Registry拉取预构建镜像：
- 拉取最新版本：
  ```console
  docker pull docker.xuanyuan.run/bitnami/memcached-exporter:latest
  ```
- 拉取特定版本：
  ```console
  docker pull docker.xuanyuan.run/bitnami/memcached-exporter:[TAG]
  ```
  > 其中`[TAG]`需替换为具体版本标签，可在[Docker Hub标签列表](https://hub.docker.com/r/bitnami/memcached-exporter/tags/)中查看可用版本

#### 构建本地镜像
如需本地构建，可执行以下步骤：
```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM  # 替换APP、VERSION、OPERATING-SYSTEM为实际值
docker build -t bitnami/APP:latest .
```

### 容器网络配置

容器可通过Docker网络与其他容器通信，同一网络内的容器可使用容器名作为主机名相互访问。

#### 步骤1：创建网络
```console
docker network create memcached-exporter-network --driver bridge
```

#### 步骤2：在网络中启动memcached-exporter容器
```console
docker run --name memcached-exporter-node1 --network memcached-exporter-network docker.xuanyuan.run/bitnami/memcached-exporter:latest
```

#### 步骤3：连接其他容器
其他容器可通过`--network`参数加入同一网络，并使用容器名作为主机名访问：
```console
docker run --name [OTHER_CONTAINER_NAME] --network memcached-exporter-network [OTHER_IMAGE]
```

### 配置说明

#### 获取配置参数
通过`--help`标志查看所有配置选项：
```console
docker run --rm docker.xuanyuan.run/bitnami/memcached-exporter --help
```

#### 更多配置参考
详细配置说明可查阅[memcached-exporter官方文档](https://github.com/prometheus/memcached_exporter)。

## 日志管理

### 查看日志
容器日志输出至`stdout`，可通过以下命令查看：
```console
docker logs memcached-exporter
```

### 配置日志驱动
可使用`--log-driver`选项配置日志驱动（默认使用`json-file`驱动），具体参考[Docker日志驱动文档](https://docs.docker.com/engine/admin/logging/overview/)。

## 维护与升级

### 升级镜像
Bitnami会及时更新镜像以包含安全补丁和新版本，建议按以下步骤升级：

#### 步骤1：拉取更新镜像
```console
docker pull docker.xuanyuan.run/bitnami/memcached-exporter:latest
```

#### 步骤2：停止当前容器
```console
docker stop memcached-exporter
```

#### 步骤3：删除当前容器
```console
docker rm -v memcached-exporter
```

#### 步骤4：启动新容器
```console
docker run --name memcached-exporter docker.xuanyuan.run/bitnami/memcached-exporter:latest
```

## 重要变更

### 2025年4月22日起
- `bitnami/memcached-exporter`镜像基于scratch构建，仅包含memcached_exporter二进制文件及其许可证文件。

### 2024年1月16日起
- 移除`docker-compose.yaml`文件（该文件仅用于内部测试）。

## 贡献与反馈

### 贡献代码
欢迎通过以下方式贡献：
- 创建[issue](https://github.com/bitnami/containers/issues)提出新功能需求
- 提交[pull request](https://github.com/bitnami/containers/pulls)贡献代码

### 问题反馈
如运行容器时遇到问题，可在[GitHub](https://github.com/bitnami/containers/issues/new/choose)提交issue，并按模板填写相关信息以获得更好支持。

## 许可证

Copyright &copy; 2025 Broadcom. 术语"Broadcom"指Broadcom Inc.及其子公司。

本镜像基于Apache License 2.0许可发布。您可在[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)获取许可证副本。除非法律要求或书面同意，软件按"原样"分发，不提供任何明示或暗示的保证或条件。
