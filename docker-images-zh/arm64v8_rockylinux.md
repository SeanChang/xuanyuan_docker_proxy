---
image: arm64v8/rockylinux
description: "Rocky Linux官方Docker镜像，提供稳定可靠的企业级Linux运行环境，适用于开发与部署场景。"
source: https://xuanyuan.cloud/zh/r/arm64v8/rockylinux
canonical: https://xuanyuan.cloud/zh/r/arm64v8/rockylinux
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm64v8/rockylinux" title="arm64v8/rockylinux Docker 镜像中文简介、标签列表与拉取命令">arm64v8/rockylinux 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# arm64v8/rockylinux Docker镜像文档

## 重要说明

Docker团队负责管理官方镜像项目，目前存在一些技术限制，导致Rocky Linux无法在此发布更新。如需获取最新的容器镜像，请暂时参考[Rocky Linux Docker Hub仓库](https://hub.docker.com/r/rockylinux/rockylinux)。


## 镜像概述

`arm64v8/rockylinux`是Rocky Linux操作系统的Docker镜像，专为arm64v8架构构建。Rocky Linux是一款社区支持的Linux发行版，源自Red Hat提供的Red Hat Enterprise Linux (RHEL)源代码，旨在与RHEL功能兼容。该项目主要修改软件包以移除上游供应商的品牌标识和 artwork，提供无成本且可自由再分发的操作系统。每个Rocky Linux版本支持长达10年的安全更新，约每2年发布一个新版本，每6个月进行一次硬件支持更新，确保环境安全、低维护、可靠且可预测。


## 核心功能与特性

- **RHEL兼容性**：与Red Hat Enterprise Linux功能兼容，可无缝替代RHEL作为基础运行环境
- **长期支持**：每个版本提供长达10年的安全更新支持，满足企业级稳定性需求
- **多架构支持**：支持amd64、arm64v8、ppc64le、s390x等多种架构（本镜像专注于arm64v8）
- **精简变体**：提供`-minimal`标签的精简版本，仅包含microdnf及最小依赖集，减少镜像体积
- **滚动更新**：主要版本标签（如`8`、`9`）提供月度滚动更新，包含最新安全补丁
- **灵活标签策略**：提供主要版本、次要版本及具体构建日期标签，满足不同场景需求
- **优化镜像体积**：默认使用`nodocs`选项构建，减少文档文件以缩小镜像大小


## 使用场景与适用范围

- **企业级应用环境**：需要稳定、安全且长期支持的Linux基础操作系统
- **RHEL兼容场景**：作为RHEL的替代方案，运行依赖RHEL生态的应用程序
- **多架构部署**：在arm64v8架构设备（如ARM服务器、嵌入式系统）上构建标准化运行环境
- **开发与测试**：提供与生产环境一致的RHEL兼容基础，确保开发测试准确性
- **轻量级容器**：通过`-minimal`变体构建资源受限环境下的轻量级应用容器
- **长期维护项目**：需要10年周期安全支持的服务器应用或基础设施


## 支持的标签及Dockerfile链接

| 标签                                     | Dockerfile链接                                                                 | 说明                     |
|------------------------------------------|-------------------------------------------------------------------------------|--------------------------|
| `9.3.20231119`, `9.3`, `9`               | [链接](https://github.com/rocky-linux/sig-cloud-instance-images/blob/29d1766aa469897f6690547364d45d352cbe7ae6/Dockerfile) | Rocky Linux 9系列基础镜像 |
| `9.3.20231119-minimal`, `9.3-minimal`, `9-minimal` | [链接](https://github.com/rocky-linux/sig-cloud-instance-images/blob/0b10d7d7a8ba867de715441b52c591880480bc94/Dockerfile) | Rocky Linux 9系列精简镜像 |
| `8.9.20231119`, `8.9`, `8`               | [链接](https://github.com/rocky-linux/sig-cloud-instance-images/blob/94d578e7e1eeaf0591657eff018929928e0bfdfc/Dockerfile) | Rocky Linux 8系列基础镜像 |
| `8.9.20231119-minimal`, `8.9-minimal`, `8-minimal` | [链接](https://github.com/rocky-linux/sig-cloud-instance-images/blob/cc181de9168465f9e9e2fbddd5a0f8e1a89cddfc/Dockerfile) | Rocky Linux 8系列精简镜像 |

> **注意**：`arm64v8/rockylinux:latest`标签不存在，需指定具体主版本标签（如`8`或`9`）或更具体的标签。


## 详细使用指南

### 拉取镜像

根据需求选择标签拉取镜像：

```bash
# 拉取Rocky Linux 9基础镜像（滚动更新版本）
docker pull docker.xuanyuan.run/arm64v8/rockylinux:9

# 拉取Rocky Linux 9精简镜像
docker pull docker.xuanyuan.run/arm64v8/rockylinux:9-minimal

# 拉取特定次要版本（不自动更新）
docker pull docker.xuanyuan.run/arm64v8/rockylinux:9.3.20231119
```


### 运行容器

#### 基础使用

运行交互式容器并进入bash终端：

```bash
docker run -it --rm docker.xuanyuan.run/arm64v8/rockylinux:9 /bin/bash
```

#### 作为基础镜像构建自定义镜像

创建`Dockerfile`：

```dockerfile
FROM docker.xuanyuan.run/arm64v8/rockylinux:9

# 安装必要软件包（示例：安装nginx）
RUN yum -y update && \
    yum -y install nginx && \
    yum clean all

# 暴露端口
EXPOSE 80

# 启动命令
CMD ["nginx", "-g", "daemon off;"]
```

构建并运行自定义镜像：

```bash
docker build -t my-rockylinux-nginx .
docker run -d -p 80:80 docker.xuanyuan.run/my-rockylinux-nginx
```


### Docker Compose示例

创建`docker-compose.yml`：

```yaml
version: '3'
services:
  rockylinux-app:
    image: docker.xuanyuan.run/arm64v8/rockylinux:9
    container_name: rockylinux-demo
    tty: true
    volumes:
      - ./app:/app
    command: /bin/bash -c "cd /app && ./start.sh"
```

启动服务：

```bash
docker-compose up -d
```


### 精简变体（Minimal Variant）

精简镜像使用`microdnf`替代`yum`，包含最小化依赖集，适用于资源受限场景：

```bash
# 拉取精简镜像
docker pull docker.xuanyuan.run/arm64v8/rockylinux:9-minimal

# 运行精简镜像并使用microdnf安装软件
docker run -it --rm docker.xuanyuan.run/arm64v8/rockylinux:9-minimal /bin/bash
microdnf install -y curl && microdnf clean all
```


### 滚动更新标签与次要版本标签区别

- **滚动更新标签**（如`9`、`8`、`9-minimal`）：每月或在紧急修复时更新，包含最新安全补丁，推荐生产环境使用以保持安全性。
  
- **次要版本标签**（如`9.3`、`8.9`、`9.3.20231119`）：对应特定安装介质版本，**不自动更新**。若使用此类标签，建议在Dockerfile中添加更新命令：

  ```dockerfile
  FROM docker.xuanyuan.run/arm64v8/rockylinux:9.3
  RUN yum -y update && yum clean all
  ```


## 软件包文档说明

默认情况下，Rocky Linux容器使用`yum`的`nodocs`选项构建，以减小镜像体积，这会导致部分软件包文档未安装。如需获取软件包文档，可修改`/etc/yum.conf`并重新安装软件包：

```bash
# 在容器内执行
sed -i 's/tsflags=nodocs/#tsflags=nodocs/' /etc/yum.conf
yum reinstall -y <package-name>
```


## 许可证信息

查看此镜像包含软件的[许可证信息](https://www.rockylinux.org/legal/)。与所有Docker镜像一样，本镜像可能包含其他软件，这些软件可能采用其他许可证（如基础发行版中的Bash等，以及主要软件的直接或间接依赖项）。

自动检测到的额外许可证信息可在[repo-info仓库的`rockylinux/`目录](https://github.com/docker-library/repo-info/tree/master/repos/rockylinux)中找到。

对于任何预构建镜像的使用，镜像用户有责任确保对本镜像的任何使用符合其中包含的所有软件的相关许可证。


## 快速参考

- **维护者**：[Rocky Enterprise Software Foundation](https://github.com/rocky-linux/sig-cloud-instance-images)
  
- **获取帮助**：[Docker社区Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic)或[Stack Overflow](https://stackoverflow.com/help/on-topic)

- **提交Issue**：[Rocky Linux Bug跟踪](https://bugs.rockylinux.org)或[GitHub](https://github.com/rocky-linux/sig-cloud-instance-images/issues)

- **支持的架构**：`amd64`、`arm64v8`、`ppc64le`、`s390x`（[更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64)）

- **镜像元数据**：[repo-info仓库`repos/rockylinux/`目录](https://github.com/docker-library/repo-info/blob/master/repos/rockylinux)（包含镜像元数据、传输大小等）

- **镜像更新**：[official-images仓库`library/rockylinux`标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Frockylinux)

- **文档来源**：[docs仓库`rockylinux/`目录](https://github.com/docker-library/docs/tree/master/rockylinux)
