---
image: balenalib/up-board-fedora-golang
description: "已弃用：此镜像不再接收更新。"
source: https://xuanyuan.cloud/zh/r/balenalib/up-board-fedora-golang
canonical: https://xuanyuan.cloud/zh/r/balenalib/up-board-fedora-golang
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/balenalib/up-board-fedora-golang" title="balenalib/up-board-fedora-golang Docker 镜像中文简介、标签列表与拉取命令">balenalib/up-board-fedora-golang 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ⚠️ 已弃用

此基础镜像已弃用，将不再接收更新。请阅读[公告帖子](https://blog.balena.io/deprecate-balenalib-images/)获取迁移指南和建议的替代方案。

该镜像属于[balena.io][balena]的IoT设备基础镜像系列。此镜像针对[balena.io][balena]和[balenaOS][balena-os]进行了优化，但也可用于任何运行在适当架构上的Docker环境。

![balenalogo](https://avatars2.githubusercontent.com/u/6157842?s=200&v=4)

`balenalib`基础镜像的一些显著特性：

- 名为`install_packages`的实用软件包安装脚本，它抽象掉了底层包管理器的细节。该脚本将以最少的依赖项（忽略可选依赖项）安装指定软件包，清理包管理器元数据，并在安装失败时重试。

- 处理动态插入设备：每个`balenalib`基础镜像都有一个默认的`ENTRYPOINT`，定义为`ENTRYPOINT ["/usr/bin/entry.sh"]`。它会检查`UDEV`标志是否设置为true（通过添加`ENV UDEV=1`），如果为true，将启动`udevd`守护进程，容器内的/dev目录中会出现相关设备节点。

有关更多详细信息，请查看我们文档中的[特性概述](https://www.balena.io/docs/reference/base-images/base-images/#features-overview)。

# [镜像变体][variants]

`balenalib`镜像有多种版本，每种版本都针对特定用例设计。

## `:<version>` 或 `:<version>-run`

这是默认镜像。`run`变体设计为精简的运行时变体，仅包含运行时基本组件。

## `:<version>-build`

build变体是较重的镜像，包含从源代码构建所需的许多工具。这减少了你需要在Dockerfile中手动安装的软件包数量，从而减小系统上所有镜像的总体大小。

[variants]: https://www.balena.io/docs/reference/base-images/base-images/#run-vs-build?ref=dockerhub

# 如何将此镜像与Balena一起使用

此[指南][getting-started]可帮助你开始将此基础镜像与balena一起使用，还有一些很酷的[示例项目][example-projects]，让你了解balena的功能。

# 什么是Go？

Go（又称Golang）是一种最初由Google开发的编程语言。它是一种静态类型语言，语法松散源自C，但具有额外特性，如垃圾回收、类型安全、一些动态类型能力、额外的内置类型（如变长数组和键值映射）以及庞大的标准库。

> [wikipedia.org/wiki/Go_(programming_language)](http://en.wikipedia.org/wiki/Go_%28programming_language%29)

![logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/golang/logo.png)

# 支持的版本及对应的`Dockerfile`链接：

[`1.20.1 (latest)`、`1.19.6`、`1.18.10`](https://github.com/balena-io-library/base-images/tree/master/balena-base-images/golang/up-board/fedora/)

有关此镜像及其历史的更多信息，请参阅[`balena-io-library/official-images` GitHub仓库](https://github.com/balena-io-library/official-images)中的[相关清单文件（`up-board-fedora-golang`）](https://github.com/balena-io-library/official-images/blob/master/library/up-board-fedora-golang)。

# 如何使用此镜像

## 在应用中启动Go实例

使用此镜像最直接的方法是将Go容器同时用作构建和运行时环境。在你的`Dockerfile`中，编写如下内容将编译并运行你的项目：

```dockerfile
FROM docker.xuanyuan.run/balenalib/up-board-fedora-golang:latest

WORKDIR /go/src/app
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

CMD ["app"]
```

然后你可以构建并运行Docker镜像：

```console
$ docker build -t my-golang-app .
$ docker run -it --rm --name my-running-app my-golang-app
```

## 在Docker容器内编译应用

有时可能不适合在容器内运行应用。要在Docker实例内编译但不运行应用，可执行如下命令：

```console
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp balenalib/up-board-fedora-golang:latest go build -v
```

这会将你当前的目录作为卷挂载到容器中，将工作目录设置为该卷，并运行`go build`命令，该命令会编译工作目录中的项目并将可执行文件输出到`myapp`。

[example-projects]: https://www.balena.io/docs/learn/getting-started/up-board/go/#example-projects?ref=dockerhub
[getting-started]: https://www.balena.io/docs/learn/getting-started/up-board/go/?ref=dockerhub

# 用户反馈

## 问题

如果你对此镜像有任何问题或疑问，请通过[GitHub issue](https://github.com/balena-io-library/base-images/issues)与我们联系。

## 贡献

我们邀请你贡献新功能、修复或更新，无论大小；我们始终乐于收到拉取请求，并会尽力尽快处理。

在开始编码之前，我们建议通过[GitHub issue](https://github.com/balena-io-library/base-images/issues)讨论你的计划，尤其是对于更宏大的贡献。这让其他贡献者有机会为你指明正确方向，对你的设计提供反馈，并帮助你了解是否有其他人正在做相同的工作。

## 文档

此镜像的文档存储在[基础镜像文档][docs]中。查看该文档可获取所有基础镜像的列表，包括许多专门的镜像（如node、python、go、更小的镜像等）。

你还可以在这篇[博客文章][migration-docs]中找到`balenalib`基础镜像新特性的更多详细信息。

[docs]: https://www.balena.io/docs/reference/base-images/base-images/#balena-base-images?ref=dockerhub
[variants]: https://www.balena.io/docs/reference/base-images/base-images/#run-vs-build?ref=dockerhub
[migration-docs]: https://www.balena.io/blog/new-year-new-balena-base-images/?ref=dockerhub
[balena]: https://balena.io/?ref=dockerhub
[balena-os]: https://www.balena.io/os/?ref=dockerhub
