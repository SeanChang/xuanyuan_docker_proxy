---
image: bitnami/java
description: "Bitnami Secure Image for Java 是 Bitnami 推出的针对 Java 应用开发与部署的安全镜像，其预配置了稳定的 Java 运行环境及相关依赖组件，通过严格的安全加固措施（如漏洞修复、最小权限配置、加密传输支持等）保障应用安全性，同时具备跨平台兼容性，可无缝适配主流云服务与容器平台，能帮助开发者与运维人员快速构建安全可靠的 Java 应用环境，有效减少环境配置时间与潜在安全风险。"
source: https://xuanyuan.cloud/zh/r/bitnami/java
canonical: https://xuanyuan.cloud/zh/r/bitnami/java
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/java" title="bitnami/java Docker 镜像中文简介、标签列表与拉取命令">bitnami/java — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/java" title="bitnami/java Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/java</a>

# Bitnami Java 软件包介绍


## 什么是 Java？

> Java 是一种通用计算机编程语言，支持并发、基于类、面向对象，其设计目标是尽可能减少实现依赖。

[Java 概述]([])  
商标说明：本软件列表由 Bitnami 打包。所提及的相关商标归各自公司所有，使用这些商标并不意味着任何关联或背书。


## 快速上手

```console
docker run -it --name java bitnami/java
```

此镜像是由 Bitnami 构建和维护的强化版最小化 CVE 镜像。Bitnami 安全镜像（BSI）基于云优化、安全强化的企业级 [Photon Linux 操作系统]([]) 构建。选择 BSI 镜像的理由包括：  
- 热门开源软件的强化安全镜像，漏洞数量趋近于零  
- 漏洞分类与优先级排序，包含 VEX 声明、KEV 和 EPSS 评分  
- 聚焦合规性，支持 FIPS、STIG 和离线部署选项，提供安全物料清单（SBOM）  
- 通过 in-toto 实现软件供应链来源证明  
- 原生支持主流 Helm 图表  

每个镜像均附带安全元数据，可在 [公开目录]([]) 中查看。注意：部分数据需 [BSI 商业订阅]([]) 方可获取。  

如需基于 Debian Linux 的旧版镜像，请查看 Bitnami Legacy 仓库。


## 支持的标签及对应 Dockerfile 链接

了解 Bitnami 标签策略及滚动标签与固定标签的区别，请参阅 [文档页面]([])。  

不同标签的对应关系可通过分支文件夹中的 `tags-info.yaml` 文件查看，例如 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`。  

可通过关注 [bitnami/containers GitHub 仓库]([]) 获取项目更新。


### 弃用说明（2022-01-21）

`prod` 标签已移除，今后仅发布常规容器镜像。


### 弃用说明（2020-08-18）

`prod` 标签的格式已调整：  
- `BRANCH-debian-10-prod` 调整为 `BRANCH-prod-debian-10`  
- `VERSION-debian-10-rX-prod` 调整为 `VERSION-prod-debian-10-rX`  
- `latest-prod` 已弃用  


## 获取镜像

获取 Bitnami Java Docker 镜像的推荐方式是从 [Docker Hub 仓库]([]) 拉取预构建镜像。

```console
docker pull bitnami/java:latest
```

如需使用特定版本，可拉取带版本标签的镜像。可在 [Docker Hub 仓库]([]) 查看所有可用版本。

```console
docker pull bitnami/java:[TAG]
```

如需自行构建镜像，可克隆仓库，进入包含 Dockerfile 的目录，执行 `docker build` 命令。请将以下示例中的 `APP`、`VERSION` 和 `OPERATING-SYSTEM` 占位符替换为实际值。

```console
git clone [] bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```


## 配置

### 运行 Java jar 或 war 文件

Java 镜像的默认工作目录为 `/app`。可将主机中的文件夹挂载到此目录（包含 Java jar 或 war 文件），然后使用 `java` 命令正常运行。

```console
docker run -it --name java -v /path/to/app:/app bitnami/java:latest \
  java -jar package.jar
```

或使用 Docker Compose：

```yaml
java:
  image: bitnami/java:latest
  command: "java -jar package.jar"
  volumes:
    - .:/app
```

**延伸阅读**：  
- [Java SE 文档]([])


### 使用自定义基础镜像替换默认信任库

若将默认 [minideb]([]) 基础镜像替换为自定义（基于 Debian 的）基础镜像，可替换位于 `/opt/bitnami/java/lib/security` 目录的默认信任库。通过设置 `JAVA_EXTRA_SECURITY_DIR` Docker 构建参数实现，该参数需指向包含 `cacerts` 文件的路径（用于替换原信任库）。以下示例使用 minideb 分支镜像，其 `/bitnami/java/extra-security` 目录包含自定义 `cacerts` 文件：

- 在 Dockerfile 中，将 `FROM docker.io/bitnami/minideb:latest` 替换为自定义镜像（用 `MYJAVAFORK:TAG` 占位符表示）：

```diff
- FROM bitnami/minideb:latest
+ FROM MYFORK:TAG
```

- 执行 `docker build` 时设置 `JAVA_EXTRA_SECURITY_DIR` 的值。请替换 `MYJAVAFORK:TAG` 占位符。

```console
docker build --build-arg JAVA_EXTRA_SECURITY_DIR=/bitnami/java/extra-security -t MYJAVAFORK:TAG .
```


### Bitnami 安全镜像的 FIPS 配置

[Bitnami 安全镜像]([]) 目录中的 Java Docker 镜像包含额外功能，可配置 FIPS 能力。可通过以下环境变量进行配置：

- `OPENSSL_FIPS`：控制 OpenSSL 是否运行在 FIPS 模式。可选值：`yes`（默认）、`no`。


## 维护

### 升级镜像

Bitnami 会及时提供包含安全补丁的 Java 最新版本。建议按以下步骤升级容器：

#### 步骤 1：获取更新后的镜像

```console
docker pull bitnami/java:latest
```

若使用 Docker Compose，将 `image` 属性值更新为 `bitnami/java:latest`。

#### 步骤 2：移除当前运行的容器

```console
docker rm -v java
```

或使用 Docker Compose：

```console
docker-compose rm -v java
```

#### 步骤 3：运行新镜像

基于新镜像重新创建容器。

```console
docker run --name java bitnami/java:latest
```

或使用 Docker Compose：

```console
docker-compose up java
```


## 重要变更

### 1.8.252-debian-10-r0、11.0.7-debian-10-r7 和 15.0.1-debian-10-r20 版本

Java 发行版已从 AdoptOpenJDK 迁移至 OpenJDK Liberica。作为 VMware 的一部分，我们与 Bell Software 达成协议，可分发 OpenJDK Liberica 发行版，从而提供 Java 的支持服务、最新版本及安全更新。


## 使用 `docker-compose.yaml`

请注意，此文件未经内部测试。因此，建议仅用于开发或测试环境。

若在 `docker-compose.yaml` 文件中发现问题，可按照 [贡献指南]([]) 报告问题或提交修复。


## 贡献

欢迎为该 Docker 镜像贡献代码。可通过创建 [issue]([]) 请求新功能，或提交 [pull request]([]) 贡献代码。


## 问题反馈

若运行容器时遇到问题，可提交 [issue]([])。为便于提供支持，请务必填写 issue 模板。


## 许可协议

版权所有 © 2025 Broadcom。“Broadcom” 指 Broadcom Inc. 及其子公司。

根据 Apache 许可证 2.0 版（“许可证”）授权；除非遵守许可证，否则不得使用此文件。可在以下位置获取许可证副本：

<[]>

除非适用法律要求或书面同意，否则根据许可证分发的软件按“原样”分发，不附带任何明示或暗示的担保或条件。有关许可证下权限和限制的具体语言，请参阅许可证。
