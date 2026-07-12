---
image: balenalib/amd64-ubuntu-golang
description: "此镜像已弃用，将不再接收更新。"
source: https://xuanyuan.cloud/zh/r/balenalib/amd64-ubuntu-golang
canonical: https://xuanyuan.cloud/zh/r/balenalib/amd64-ubuntu-golang
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/balenalib/amd64-ubuntu-golang" title="balenalib/amd64-ubuntu-golang Docker 镜像中文简介、标签列表与拉取命令">balenalib/amd64-ubuntu-golang 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ⚠️ 已弃用

此基础镜像已弃用，将不再接收更新。请阅读[公告帖子](https://blog.balena.io/deprecate-balenalib-images/)获取迁移指南和建议的替代方案。

该镜像属于[balena.io][balena]物联网设备基础镜像系列的一部分。此镜像针对[balena.io][balena]和[balenaOS][balena-os]进行了优化，但也可用于运行在相应架构上的任何Docker环境。

![balenalogo](https://avatars2.githubusercontent.com/u/6157842?s=200&v=4)

`balenalib`基础镜像的一些显著特性：

- 名为`install_packages`的实用软件包安装脚本，抽象了底层包管理器的细节。它将以最少依赖（忽略可选依赖）安装指定软件包，清理包管理器元数据，并在安装失败时重试。

- 支持动态插入设备：每个`balenalib`基础镜像都有默认的`ENTRYPOINT`定义为`ENTRYPOINT ["/usr/bin/entry.sh"]`，它会检查`UDEV`标志是否设为true（通过添加`ENV UDEV=1`），如果为true，将启动`udevd`守护进程，容器的/dev目录中会出现相关设备节点。

更多详情，请查看我们文档中的[特性概述](https://www.balena.io/docs/reference/base-images/base-images/#features-overview)。

# [镜像变体][variants]

`balenalib`镜像有多种版本，每种版本针对特定使用场景设计。

## `:<version>` 或 `:<version>-run`

这是默认镜像。`run`变体设计为精简的最小变体，仅包含运行时必需组件。

## `:<version>-build`

构建变体是一个较重的镜像，包含许多从源代码构建所需的工具。这减少了您需要在Dockerfile中手动安装的软件包数量，从而减小系统上所有镜像的总体大小。

[variants]: https://www.balena.io/docs/reference/base-images/base-images/#run-vs-build?ref=dockerhub

# 什么是Go？

Go（又称Golang）是Google首先开发的编程语言。它是一种静态类型语言，语法大致源自C，但增加了垃圾回收、类型安全、一些动态类型功能、额外的内置类型（如变长数组和键值映射）以及大型标准库。

> [wikipedia.org/wiki/Go_(programming_language)](http://en.wikipedia.org/wiki/Go_%28programming_language%29)

![logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/golang/logo.png)

# 支持的版本及对应的`Dockerfile`链接：

[`1.20.1 (latest)`，`1.19.6`，`1.18.10`](https://github.com/balena-io-library/base-images/tree/master/balena-base-images/golang/amd64/ubuntu/)

有关此镜像及其历史的更多信息，请参阅[`balena-io-library/official-images` GitHub仓库](https://github.com/balena-io-library/official-images)中的[相关清单文件（`amd64-ubuntu-golang`）](https://github.com/balena-io-library/official-images/blob/master/library/amd64-ubuntu-golang)。

# 如何使用此镜像

## 在应用中启动Go实例

使用此镜像最直接的方法是将Go容器同时用作构建和运行时环境。在您的`Dockerfile`中，编写如下内容将编译并运行您的项目：

```dockerfile
FROM docker.xuanyuan.run/balenalib/amd64-ubuntu-golang:latest

WORKDIR /go/src/app
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

CMD ["app"]
```

然后您可以构建并运行Docker镜像：

```console
$ docker build -t my-golang-app .
$ docker run -it --rm --name my-running-app my-golang-app
```

## 在Docker容器内编译应用

有时可能不适合在容器内运行应用。要在Docker实例内编译但不运行应用，您可以编写如下命令：

```console
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp balenalib/amd64-ubuntu-golang:latest go build -v
```

这会将您当前目录作为卷添加到容器，将工作目录设置为该卷，并运行`go build`命令，该命令会指示go编译工作目录中的项目，并将可执行文件输出为`myapp`。

[example-projects]: https://www.balena.io/docs/learn/getting-started//go/#example-projects?ref=dockerhub
[getting-started]: https://www.balena.io/docs/learn/getting-started//go/?ref=dockerhub

# 用户反馈

## 问题

如果您对此镜像有任何问题或疑问，请通过[GitHub issue](https://github.com/balena-io-library/base-images/issues)与我们联系。

## 贡献

我们邀请您贡献新功能、修复或更新，无论大小；我们始终很高兴收到拉取请求，并会尽力快速处理。

在开始编码之前，我们建议通过[GitHub issue](https://github.com/balena-io-library/base-images/issues)讨论您的计划，尤其是对于更宏大的贡献。这让其他贡献者有机会为您指明正确方向，提供设计反馈，并帮助您了解是否有其他人正在做同样的事情。

## 文档

此镜像的文档存储在[基础镜像文档][docs]中。查看它以获取我们所有基础镜像的列表，包括许多专门的镜像，例如node、python、go、更小的镜像等。

您还可以在此[博客文章][migration-docs]中找到`balenalib`基础镜像新功能的更多详情。

[docs]: https://www.balena.io/docs/reference/base-images/base-images/#balena-base-images?ref=dockerhub
[variants]: https://www.balena.io/docs/reference/base-images/base-images/#run-vs-build?ref=dockerhub
[migration-docs]: https://www.balena.io/blog/new-year-new-balena-base-images/?ref=dockerhub
[balena]: https://balena.io/?ref=dockerhub
[balena-os]: https://www.balena.io/os/?ref=dockerhub
