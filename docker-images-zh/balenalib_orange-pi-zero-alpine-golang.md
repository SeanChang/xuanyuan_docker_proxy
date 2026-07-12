---
image: balenalib/orange-pi-zero-alpine-golang
description: "该镜像属于balena.io物联网设备基础镜像系列，适用于Orange Pi Zero设备，基于Alpine系统，集成Go环境，优化用于balena.io和balenaOS，也可用于其他Docker环境。"
source: https://xuanyuan.cloud/zh/r/balenalib/orange-pi-zero-alpine-golang
canonical: https://xuanyuan.cloud/zh/r/balenalib/orange-pi-zero-alpine-golang
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/balenalib/orange-pi-zero-alpine-golang" title="balenalib/orange-pi-zero-alpine-golang Docker 镜像中文简介、标签列表与拉取命令">balenalib/orange-pi-zero-alpine-golang 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# balenalib/orange-pi-zero-alpine-golang 镜像文档

## 镜像概述

该镜像属于balena.io物联网设备基础镜像系列的一部分，专为Orange Pi Zero设备设计，基于Alpine Linux系统，集成Go编程语言环境。镜像针对balena.io平台和balenaOS操作系统进行了优化，同时也可在其他支持相应架构的Docker环境中使用。

![balenalogo](https://avatars2.githubusercontent.com/u/6157842?s=200&v=4)

## 核心功能与特性

### 1. 便捷的包管理工具
提供`install_packages`脚本，可抽象底层包管理器细节，自动安装指定软件包并最小化依赖（忽略可选依赖），清理包管理器元数据，并在安装失败时重试。

### 2. 动态设备支持
默认ENTRYPOINT为`ENTRYPOINT ["/usr/bin/entry.sh"]`，通过设置`ENV UDEV=1`可启用udevd守护进程，使容器内`/dev`目录能自动识别并创建动态插入设备的节点。

更多特性详情请参见[balena基础镜像特性概述](https://www.balena.io/docs/reference/base-images/base-images/#features-overview)。

# 镜像变体

balenalib镜像提供多种变体以适应不同使用场景：

## `:<version>` 或 `:<version>-run`
默认镜像变体。`run`变体为精简版本，仅包含运行时必需组件，体积小巧。

## `:<version>-build`
构建变体，包含源码构建所需的多种工具，减少Dockerfile中手动安装的依赖包数量，从而减小系统中所有镜像的总体积。

更多变体信息请参见[运行时与构建时变体](https://www.balena.io/docs/reference/base-images/base-images/#run-vs-build?ref=dockerhub)。

# 与Balena平台配合使用

[快速入门指南](https://www.balena.io/docs/learn/getting-started/orange-pi-zero/go/?ref=dockerhub)可帮助您快速上手使用该镜像与balena平台，同时[示例项目](https://www.balena.io/docs/learn/getting-started/orange-pi-zero/go/#example-projects?ref=dockerhub)展示了其实际应用场景。

# 关于Go语言

Go（又称Golang）是由Google开发的编程语言，为静态类型语言，语法松散源自C，具备垃圾回收、类型安全、部分动态类型能力、额外内置类型（如变长数组和键值映射）及庞大的标准库。

> 更多信息：[维基百科 - Go (编程语言)](http://en.wikipedia.org/wiki/Go_%28programming_language%29)

![Go语言logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/golang/logo.png)

# 支持的版本及对应Dockerfile链接

[`1.19 (latest)`、`1.18.15`、`1.17.12`](https://github.com/balena-io-library/base-images/tree/master/balena-base-images/golang/orange-pi-zero/alpine/)

关于该镜像及其历史的更多信息，可参见[balena-io-library/official-images](https://github.com/balena-io-library/official-images) GitHub仓库中的[相关清单文件（`orange-pi-zero-alpine-golang`）](https://github.com/balena-io-library/official-images/blob/master/library/orange-pi-zero-alpine-golang)。

# 如何使用该镜像

## 在应用中启动Go实例

将Go容器同时作为构建和运行环境，在Dockerfile中编写如下内容：

```dockerfile
FROM docker.xuanyuan.run/balenalib/orange-pi-zero-alpine-golang:latest

WORKDIR /go/src/app
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

CMD ["app"]
```

构建并运行镜像：

```console
$ docker build -t my-golang-app .
$ docker run -it --rm --name my-running-app my-golang-app
```

## 在Docker容器内编译应用

如需仅编译应用（不运行），可执行：

```console
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp balenalib/orange-pi-zero-alpine-golang:latest go build -v
```

该命令将当前目录挂载为容器卷，设置工作目录为该卷，并运行`go build`编译项目，输出可执行文件至工作目录。

# 用户反馈

## 问题反馈

如对镜像有问题或疑问，请通过[GitHub Issues](https://github.com/balena-io-library/base-images/issues)联系我们。

## 贡献

欢迎贡献新功能、修复或更新（无论大小）。我们会及时处理拉取请求。

编码前建议通过[GitHub Issues](https://github.com/balena-io-library/base-images/issues)讨论计划，尤其是复杂贡献，以便获取指导和反馈。

## 文档

镜像文档存储于[基础镜像文档](https://www.balena.io/docs/reference/base-images/base-images/#balena-base-images?ref=dockerhub)，可查看所有基础镜像（含node、python、go等专用镜像及精简镜像）。

balenalib基础镜像新功能详情参见[博客文章](https://www.balena.io/blog/new-year-new-balena-base-images/?ref=dockerhub)。
