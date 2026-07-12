---
image: balenalib/jetson-tx1-alpine-openjdk
description: "该镜像属于balena.io物联网设备基础镜像系列的一部分，针对balena.io和balenaOS优化，也可在任何适当架构的Docker环境中使用。"
source: https://xuanyuan.cloud/zh/r/balenalib/jetson-tx1-alpine-openjdk
canonical: https://xuanyuan.cloud/zh/r/balenalib/jetson-tx1-alpine-openjdk
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/balenalib/jetson-tx1-alpine-openjdk" title="balenalib/jetson-tx1-alpine-openjdk Docker 镜像中文简介、标签列表与拉取命令">balenalib/jetson-tx1-alpine-openjdk 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# balenalib/jetson-tx1-alpine-openjdk 镜像文档

## 镜像概述

该镜像属于[balena.io][balena]物联网设备基础镜像系列，针对[balena.io][balena]和[balenaOS][balena-os]进行了优化，但也可在任何运行于适当架构的Docker环境中使用。

![balenalogo](https://avatars2.githubusercontent.com/u/6157842?s=200&v=4)

## 核心功能与特性

`balenalib`基础镜像具有以下显著特性：

- **便捷的包安装脚本**：提供名为`install_packages`的脚本，抽象了底层包管理器的细节。它会以最小依赖（忽略可选依赖）安装指定包，清理包管理器元数据，并在安装失败时重试。

- **动态设备支持**：每个`balenalib`基础镜像都有默认`ENTRYPOINT`定义为`ENTRYPOINT ["/usr/bin/entry.sh"]`。该脚本会检查`UDEV`标志是否设置为true（通过添加`ENV UDEV=1`），若为true，则启动`udevd`守护进程，使容器内`/dev`目录中出现相关设备节点。

更多详情，请查看文档中的[特性概述](https://www.balena.io/docs/reference/base-images/base-images/#features-overview)。

# 镜像变体

`balenalib`镜像提供多种版本，每种版本针对特定使用场景设计。

## `:<version>` 或 `:<version>-run`

这是默认镜像。`run`变体设计为精简且最小化的版本，仅包含运行时必要组件。

## `:<version>-build`

build变体是包含更多构建工具的较重型镜像，包含从源代码构建所需的许多工具。这减少了在Dockerfile中手动安装的包数量，从而减小系统上所有镜像的总体大小。

[variants]: https://www.balena.io/docs/reference/base-images/base-images/#run-vs-build?ref=dockerhub

# 什么是OpenJDK？

OpenJDK（开放Java开发工具包）是Java平台标准版（Java SE）的免费开源实现。自版本7起，OpenJDK成为Java SE的官方参考实现。

> [wikipedia.org/wiki/OpenJDK](http://en.wikipedia.org/wiki/OpenJDK)

Java是Oracle及其关联公司的注册商标。

![logo](https://raw.githubusercontent.com/docker-library/docs/a3439b66b7980d1811f6b3835a3c541747172970/openjdk/logo.png)

# 如何使用此镜像

## 在应用中启动Java实例

使用此镜像最直接的方式是将Java容器同时用作构建和运行时环境。在`Dockerfile`中，可编写如下内容来编译和运行项目：

```dockerfile
FROM docker.xuanyuan.run/balenalib/jetson-tx1-alpine-openjdk:latest
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN javac Main.java
CMD ["java", "Main"]
```

然后可以构建并运行Docker镜像：

```console
$ docker build -t my-java-app .
$ docker run -it --rm --name my-running-app my-java-app
```

## 在Docker容器内编译应用

有时可能不适合在容器内运行应用。要在Docker实例内编译而非运行应用，可执行如下命令：

```console
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp balenalib/jetson-tx1-alpine-openjdk:latest javac Main.java
```

此命令会将当前目录作为卷添加到容器，将工作目录设置为该卷，并运行`javac Main.java`命令，该命令会指示Java编译`Main.java`中的代码，并将Java类文件输出到`Main.class`。

# 用户反馈

## 问题反馈

如果对该镜像有任何问题或疑问，请通过[GitHub issue](https://github.com/balena-io-library/base-images/issues)与我们联系。

## 贡献

我们邀请您贡献新功能、修复或更新，无论大小；我们始终乐于接收拉取请求，并会尽力快速处理。

在开始编码之前，建议通过[GitHub issue](https://github.com/balena-io-library/base-images/issues)讨论您的计划，尤其是对于更复杂的贡献。这让其他贡献者有机会为您指明方向，提供设计反馈，并帮助您了解是否有其他人正在处理相同的内容。

## 文档

该镜像的文档存储在[基础镜像文档][docs]中。查看该文档可获取所有基础镜像的列表，包括许多专门的镜像（如node、python、go、更小的镜像等）。

您还可以在这篇[博客文章][migration-docs]中找到`balenalib`基础镜像新功能的更多详情。

[docs]: https://www.balena.io/docs/reference/base-images/base-images/#balena-base-images?ref=dockerhub
[variants]: https://www.balena.io/docs/reference/base-images/base-images/#run-vs-build?ref=dockerhub
[migration-docs]: https://www.balena.io/blog/new-year-new-balena-base-images/?ref=dockerhub
[balena]: https://balena.io/?ref=dockerhub
[balena-os]: https://www.balena.io/os/?ref=dockerhub
