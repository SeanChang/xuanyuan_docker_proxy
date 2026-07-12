---
image: openeuler/bisheng-jdk
description: "官方BiSheng JDK Docker镜像，基于openEuler构建，是高性能OpenJDK发行版，适用于生产环境，针对ARM架构和大数据场景优化，提供稳定功能和季度安全补丁。"
source: https://xuanyuan.cloud/zh/r/openeuler/bisheng-jdk
canonical: https://xuanyuan.cloud/zh/r/openeuler/bisheng-jdk
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/bisheng-jdk" title="openeuler/bisheng-jdk Docker 镜像中文简介、标签列表与拉取命令">openeuler/bisheng-jdk 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# BiSheng JDK | openEuler Docker镜像文档

## 镜像概述和主要用途
官方BiSheng JDK Docker镜像，基于openEuler构建，由[openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)维护。BiSheng JDK是基于OpenJDK开发的高性能生产环境Java发行版，已在华为多种产品中应用，解决了服务运行中的诸多问题，增强了ARM架构支持，在大数据场景下表现卓越。支持Linux/aarch64和Linux/x86_64平台，兼容Java SE规范。获取帮助可联系[openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)或[openEuler社区](https://atomgit.com/openeuler/community)。

## 核心功能和特性
- **架构与场景优化**：针对ARM架构和大数据场景进行性能优化，提升运行效率
- **安全更新**：每季度更新补丁，保障运行安全性
- **稳定可靠**：经过大规模测试验证，功能稳定，适合生产环境

## 支持的标签及对应Dockerfile链接
BiSheng JDK Docker镜像标签由BiSheng JDK版本和基础镜像版本组成，具体如下：

| 标签 | 说明 | 架构 |
|------|------|------|
| [1.8.0-oe2203lts](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/bisheng-jdk/1.8.0/22.03-lts/Dockerfile) | 基于openEuler 22.03-LTS的BiSheng JDK 1.8.0 | amd64, arm64 |
| [1.8.0-oe2203sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/bisheng-jdk/1.8.0/22.03-lts-sp3/Dockerfile) | 基于openEuler 22.03-LTS-SP3的BiSheng JDK 1.8.0 | amd64, arm64 |
| [17.0.10-oe2203sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/bisheng-jdk/17.0.10/22.03-lts-sp3/Dockerfile) | 基于openEuler 22.03-LTS-SP3的BiSheng JDK 17.0.10 | amd64, arm64 |
| [21.0.5-oe2203sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/bisheng-jdk/21.0.5/22.03-lts-sp3/Dockerfile) | 基于openEuler 22.03-LTS-SP3的BiSheng JDK 21.0.5 | amd64, arm64 |

## 使用方法和配置说明

### 在应用中启动Java实例
将Java容器同时作为构建和运行环境，在Dockerfile中编写如下内容：

```dockerfile
# Dockerfile
FROM docker.xuanyuan.run/openeuler/bisheng-jdk:{Tag}

COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN javac Main.java
CMD ["java", "Main"]
```

构建并运行镜像：
```bash
docker build -t my-java-app .
docker run -it --rm --name my-running-app docker.xuanyuan.run/my-java-app
```

### 容器测试
验证镜像中的Java环境：
```bash
docker run -it docker.xuanyuan.run/openeuler/bisheng-jdk:{Tag} java --version
```
以`17.0.10-oe2203sp3`标签为例，返回以下信息表示环境正常：
```
openjdk 17.0.10 2024-01-16
OpenJDK Runtime Environment BiSheng (build 17.0.10+11)
OpenJDK 64-Bit Server VM BiSheng (build 17.0.10+11, mixed mode, sharing)
```

### 在Docker容器内编译应用
仅在容器内编译应用（不运行）：
```bash
docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp docker.xuanyuan.run/openeuler/bisheng-jdk:{Tag} javac Main.java
```
此命令将当前目录挂载为卷，设置工作目录并编译`Main.java`生成`Main.class`。

### 使JVM尊重CPU和RAM限制
- **Linux容器**：OpenJDK 8及更高版本可自动检测容器限制的CPU核心数和RAM，默认启用。
- **Windows Server容器**：
  - CPU限制：需手动设置CPU亲和性，如限制为2核：`start /b /wait /affinity 0x3 path/to/java.exe ...`
  - RAM限制：JVM无法自动检测，需通过`-XX:MaxRAM=...`参数指定，值不超过容器RAM限制。

### 名称含句点的环境变量
部分shell（如Alpine Linux的BusyBox /bin/sh）不支持名称含句点的环境变量。解决方法：
- 直接使用`CMD ["java", ...]`（无shell）
- 安装并使用Bash替代/bin/sh

## 问题与解答
如有问题或需特殊功能，请在[openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images)提交issue或pull request。
