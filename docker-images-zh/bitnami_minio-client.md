---
image: bitnami/minio-client
description: "Bitnami提供的minio-client安全镜像，用于管理MinIO对象存储，具备安全可靠的部署特性。"
source: https://xuanyuan.cloud/zh/r/bitnami/minio-client
canonical: https://xuanyuan.cloud/zh/r/bitnami/minio-client
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/minio-client" title="bitnami/minio-client Docker 镜像中文简介、标签列表与拉取命令">bitnami/minio-client 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 基于MinIO®的Bitnami对象存储客户端

## 什么是基于MinIO®的Bitnami对象存储客户端？

> MinIO® Client是一个Golang CLI工具，为文件系统和对象存储系统提供ls、cp、mkdir、diff和rsync等命令的替代方案。

[基于MinIO®的Bitnami对象存储客户端概述](https://min.io/)  
免责声明：所有软件产品、项目和公司名称均为其各自持有者的商标(TM)或注册商标(R)，使用这些名称并不意味着任何关联或背书。本软件根据一个或多个开源许可证授权给您，VMware按"原样"提供软件。MinIO(R)是MinIO, Inc在美国和其他国家的注册商标。Bitnami与MinIO Inc无任何关联、关联、授权、背书或任何官方联系。MinIO(R)根据GNU AGPL v3.0许可。


## 快速使用

```console
docker run --name minio-client docker.xuanyuan.run/bitnami/minio-client:latest
```


## ⚠️ 重要通知：Bitnami目录即将变更

自2025年8月28日起，Bitnami将改进其公共目录，通过新的[Bitnami Secure Images计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)提供精选的强化、安全聚焦镜像集。作为此过渡的一部分：

- 首次向社区用户提供流行容器镜像的安全优化版本访问权限。
- Bitnami将开始在免费层级中弃用对非强化、基于Debian的软件镜像的支持，并逐步从公共目录中移除非最新标签。因此，社区用户将只能访问数量减少的强化镜像，这些镜像仅以“latest”标签发布，适用于开发目的。
- 自8月28日起，在两周内，所有现有容器镜像（包括旧版本或版本化标签，如2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用Bitnami Secure Images，包括强化容器、更小的攻击面、CVE透明度（通过VEX/KEV）、SBOM以及企业支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提升所有Bitnami用户的安全态势。更多详情请访问[Bitnami Secure Images公告](https://github.com/bitnami/containers/issues/83267)。


## 为什么使用Bitnami Secure Images？

- Bitnami Secure Images和Helm图表旨在提高开源软件的安全性和企业就绪性。
- 通过行业标准漏洞可利用性交换（VEX）、KEV和EPSS评分，更快地分类安全漏洞，并透明了解CVE风险。
- 强化镜像使用最小化操作系统（Photon Linux），减少攻击面，同时通过行业标准包格式保持可扩展性。
- 通过持续构建的镜像（上游补丁发布后数小时内更新），保持更高的安全性和合规性。
- Bitnami容器、虚拟机和云镜像使用相同的组件和配置方法，便于根据项目需求在不同格式间切换。
- 强化镜像附带证明签名（Notation）、SBOM、病毒扫描报告和其他元数据，这些均在符合SLSA-3标准的软件工厂中生成。

仅有部分BSI应用可免费获取。希望访问完整应用目录并获得企业支持？立即试用[Bitnami Secure Images商业版](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)。


## 为什么使用非root容器？

非root容器镜像增加了额外的安全层，通常推荐用于生产环境。但由于它们以非root用户运行，通常无法执行特权任务。更多关于非root容器的信息，请参见[我们的文档](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html)。


## 支持的标签及对应的Dockerfile链接

了解更多关于Bitnami标签策略以及滚动标签与不可变标签的区别，请参见[文档页面](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

您可以通过查看分支文件夹中的`tags-info.yaml`文件（即`bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）了解不同标签之间的对应关系。

订阅项目更新，请关注[bitnami/containers GitHub仓库](https://github.com/bitnami/containers)。


## 获取此镜像

获取Bitnami MinIO(R) Client Docker镜像的推荐方式是从[Docker Hub Registry](https://hub.docker.com/r/bitnami/minio-client)拉取预构建镜像。

```console
docker pull docker.xuanyuan.run/bitnami/minio-client:latest
```

如需使用特定版本，可拉取带版本的标签。您可以在Docker Hub Registry中查看[可用版本列表](https://hub.docker.com/r/bitnami/minio-client/tags/)。

```console
docker pull docker.xuanyuan.run/bitnami/minio-client:[标签]
```

如果需要，您也可以自行构建镜像：克隆仓库，进入包含Dockerfile的目录，执行`docker build`命令。请将以下示例命令中的`APP`、`VERSION`和`OPERATING-SYSTEM`路径占位符替换为正确值。

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```


## 镜像概述和主要用途

基于MinIO®的Bitnami对象存储客户端是一个轻量级Docker镜像，封装了MinIO® Client（`mc`）工具。MinIO® Client是用Golang开发的命令行工具，为文件系统和对象存储系统提供与`ls`、`cp`、`mkdir`、`diff`和`rsync`等效的命令，支持与MinIO® Server及其他兼容S3的对象存储服务交互。该镜像适用于在容器环境中快速部署和使用MinIO® Client，简化对象存储的管理操作。


## 核心功能和特性

- **多命令支持**：提供`ls`（列出对象）、`cp`（复制对象）、`mkdir`（创建存储桶）、`diff`（比较对象差异）、`rsync`（同步对象）等核心命令。
- **跨平台兼容**：支持与MinIO® Server及任何兼容S3 API的对象存储服务（如AWS S3）交互。
- **非root运行**：默认以非root用户（`minio`）运行，增强容器安全性，减少攻击面。
- **配置灵活性**：通过环境变量快速配置MinIO® Server连接参数，无需手动编写配置文件。
- **轻量级设计**：基于精简操作系统，镜像体积小，启动速度快，适合开发和测试环境。


## 使用场景和适用范围

- **开发环境对象存储管理**：在本地开发或CI/CD流程中，通过命令行快速管理对象存储中的文件和存储桶。
- **MinIO® Server交互**：与Bitnami MinIO® Server镜像配合使用，执行存储桶创建、数据迁移、权限配置等操作。
- **S3兼容服务管理**：用于管理AWS S3或其他S3兼容对象存储服务中的资源。
- **自动化脚本集成**：嵌入Shell脚本或自动化流程，实现对象存储的批量操作和同步任务。


## 详细的使用方法和配置说明

### 基本使用

运行容器并直接执行`mc`命令：

```console
docker run --rm docker.xuanyuan.run/bitnami/minio-client:latest --help
```

上述命令将输出`mc`工具的帮助信息，展示所有支持的命令。


### 连接MinIO® Server

#### 场景1：连接容器网络中的MinIO® Server

1. **创建Docker网络**：

```console
docker network create minio-network --driver bridge
```

2. **启动MinIO® Server容器**（需提前拉取Bitnami MinIO® Server镜像）：

```console
docker run -d \
  --name minio-server \
  --network minio-network \
  -e MINIO_ROOT_USER=minio-root-user \
  -e MINIO_ROOT_PASSWORD=minio-root-password \
  docker.xuanyuan.run/bitnami/minio:latest
```

3. **使用客户端连接并操作**：

通过环境变量配置MinIO® Server连接参数，创建存储桶：

```console
docker run --rm \
  --name minio-client \
  --network minio-network \
  -e MINIO_SERVER_HOST=minio-server \
  -e MINIO_SERVER_ROOT_USER=minio-root-user \
  -e MINIO_SERVER_ROOT_PASSWORD=minio-root-password \
  docker.xuanyuan.run/bitnami/minio-client:latest \
  mb minio/my-bucket
```

#### 场景2：连接远程MinIO® Server

配置远程MinIO® Server的地址、访问密钥和密钥，执行存储桶列表查看：

```console
docker run --rm \
  --name minio-client \
  -e MINIO_SERVER_HOST=my.minio.domain \
  -e MINIO_SERVER_SCHEME=https \
  -e MINIO_SERVER_PORT_NUMBER=9000 \
  -e MINIO_SERVER_ROOT_USER=AKIAEXAMPLE \
  -e MINIO_SERVER_ROOT_PASSWORD=secret123 \
  docker.xuanyuan.run/bitnami/minio-client:latest \
  ls minio
```


### 环境变量配置

#### 可自定义环境变量

| 名称                         | 描述                                  | 默认值   |
|------------------------------|---------------------------------------|----------|
| `MINIO_CLIENT_CONF_DIR`      | MinIO Client配置文件目录              | `/.mc`   |
| `MINIO_SERVER_HOST`          | MinIO Server主机地址                  | `nil`    |
| `MINIO_SERVER_PORT_NUMBER`   | MinIO Server端口号                    | `9000`   |
| `MINIO_SERVER_SCHEME`        | MinIO Server访问协议（http/https）    | `http`   |
| `MINIO_SERVER_ROOT_USER`     | MinIO Server访问密钥（Access Key）    | `nil`    |
| `MINIO_SERVER_ROOT_PASSWORD` | MinIO Server密钥（Secret Key）        | `nil`    |

#### 只读环境变量

| 名称                    | 描述                          | 值                                  |
|-------------------------|-------------------------------|-------------------------------------|
| `MINIO_CLIENT_BASE_DIR` | MinIO Client安装目录          | `${BITNAMI_ROOT_DIR}/minio-client`  |
| `MINIO_CLIENT_BIN_DIR`  | MinIO Client可执行文件目录    | `${MINIO_CLIENT_BASE_DIR}/bin`      |
| `MINIO_DAEMON_USER`     | 容器运行用户                  | `minio`                             |
| `MINIO_DAEMON_GROUP`    | 容器运行用户组                | `minio`                             |


### FIPS配置（Bitnami Secure Images）

来自[Bitnami Secure Images](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)目录的基于MinIO®的Bitnami对象存储客户端Docker镜像包含额外功能，可配置FIPS能力。支持以下环境变量：

- `OPENSSL_FIPS`：是否启用OpenSSL FIPS模式。可选值：`yes`（默认）、`no`。


## 显著变化

### 2024年1月16日起

- 移除了`docker-compose.yaml`文件，该文件仅用于内部测试目的。


## 贡献

欢迎为此容器贡献代码。您可以通过创建[issue](https://github.com/bitnami/containers/issues)请求新功能，或提交[pull request](https://github.com/bitnami/containers/pulls)贡献代码。


## 问题反馈

如果在运行此容器时遇到问题，请提交[issue](https://github.com/bitnami/containers/issues/new/choose)。为获得更好的支持，请务必填写issue模板。


## 许可证

版权所有 © 2025 Broadcom。"Broadcom"一词指Broadcom Inc.及其子公司。

根据Apache许可证2.0版（"许可证"）授权；除非遵守许可证，否则您不得使用此文件。您可以在以下位置获取许可证副本：

<http://www.apache.org/licenses/LICENSE-2.0>

除非适用法律要求或书面同意，否则根据许可证分发的软件按"原样"分发，不附带任何明示或暗示的担保或条件。有关许可证下权限和限制的具体语言，请参见许可证。
