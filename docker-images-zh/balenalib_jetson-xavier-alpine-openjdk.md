---
image: balenalib/jetson-xavier-alpine-openjdk
description: "balenalib系列基础镜像之一，专为物联网设备优化，适用于balena.io和balenaOS环境，也可在其他Docker环境中使用，提供便捷的包安装工具和动态设备支持。"
source: https://xuanyuan.cloud/zh/r/balenalib/jetson-xavier-alpine-openjdk
canonical: https://xuanyuan.cloud/zh/r/balenalib/jetson-xavier-alpine-openjdk
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/balenalib/jetson-xavier-alpine-openjdk" title="balenalib/jetson-xavier-alpine-openjdk Docker 镜像中文简介、标签列表与拉取命令">balenalib/jetson-xavier-alpine-openjdk 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# balenalib/jetson-xavier-alpine-openjdk 镜像文档

## 镜像概述和主要用途

本镜像属于balena.io物联网设备基础镜像系列，专为balena.io平台和balenaOS系统优化，同时也可在任何支持相应架构的Docker环境中使用。基于OpenJDK，提供了适用于物联网场景的Java运行和开发环境。

## 核心功能和特性

- **便捷的包安装工具**：内置`install_packages`脚本，抽象底层包管理器差异，以最小依赖安装指定包（忽略可选依赖），自动清理包管理器元数据，并在安装失败时重试。

- **动态设备支持**：默认ENTRYPOINT为`/usr/bin/entry.sh`，可通过设置`ENV UDEV=1`启用udevd守护进程，使动态插入的设备节点在容器`/dev`目录中正常显示。

更多特性详情请查看[特性概述](https://www.balena.io/docs/reference/base-images/base-images/#features-overview)。

## 镜像变体

balenalib镜像提供多种变体，适用于不同使用场景：

### `:<version>` 或 `:<version>-run`

默认镜像变体，设计为精简的运行时环境，仅包含必要的运行时组件。

### `:<version>-build`

构建环境变体，包含大量源代码构建所需工具，减少Dockerfile中手动安装的包数量，从而减小系统中所有镜像的总体积。

了解更多变体信息请参见[运行时与构建时镜像](https://www.balena.io/docs/reference/base-images/base-images/#run-vs-build?ref=dockerhub)。

## 关于OpenJDK

OpenJDK（开放Java开发工具包）是Java平台标准版（Java SE）的免费开源实现。自版本7起，OpenJDK成为Java SE的官方参考实现。

> 更多信息：[wikipedia.org/wiki/OpenJDK](http://en.wikipedia.org/wiki/OpenJDK)

Java是Oracle及其关联公司的注册商标。

## 使用方法

### 在应用中启动Java实例

最直接的使用方式是将Java容器同时作为构建和运行环境。在Dockerfile中编写如下内容可编译并运行项目：

```dockerfile
FROM docker.xuanyuan.run/balenalib/jetson-xavier-alpine-openjdk:latest
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN javac Main.java
CMD ["java", "Main"]
```

构建并运行Docker镜像：

```console
$ docker build -t my-java-app .
$ docker run -it --rm --name my-running-app my-java-app
```

### 在Docker容器内编译应用

若不需要在容器中运行应用，仅需编译，可使用以下命令：

```console
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp balenalib/jetson-xavier-alpine-openjdk:latest javac Main.java
```

该命令将当前目录挂载为容器卷，设置工作目录为该卷，并执行`javac Main.java`命令，编译`Main.java`生成`Main.class`文件。

## 用户反馈

### 问题反馈

如遇镜像相关问题或疑问，请通过[GitHub Issue](https://github.com/balena-io-library/base-images/issues)联系我们。

### 贡献指南

欢迎贡献新功能、修复或更新（无论大小）。我们乐于接收拉取请求，并会尽快处理。

编码前建议通过[GitHub Issue](https://github.com/balena-io-library/base-images/issues)讨论计划，特别是较复杂的贡献，以便其他贡献者提供指导、反馈或避免重复工作。

### 文档资源

本镜像文档存储在[基础镜像文档](https://www.balena.io/docs/reference/base-images/base-images/#balena-base-images?ref=dockerhub)中。查看完整基础镜像列表（包括node、python、go等专用镜像及更小体积镜像）。

了解balenalib基础镜像新特性详情，请参见[博客文章](https://www.balena.io/blog/new-year-new-balena-base-images/?ref=dockerhub)。
