---
image: balenalib/odroid-c1-node
description: "该镜像属于balena.io IoT设备基础镜像系列的一部分，针对balena.io和balenaOS优化，也可在任何适当架构的Docker环境中使用。"
source: https://xuanyuan.cloud/zh/r/balenalib/odroid-c1-node
canonical: https://xuanyuan.cloud/zh/r/balenalib/odroid-c1-node
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/balenalib/odroid-c1-node" title="balenalib/odroid-c1-node Docker 镜像中文简介、标签列表与拉取命令">balenalib/odroid-c1-node 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# balenalib/odroid-c1-debian-node 镜像文档

## 镜像概述和主要用途

该镜像属于[balena.io][balena] IoT设备基础镜像系列，专为IoT设备设计。虽然针对[balena.io][balena]和[balenaOS][balena-os]进行了优化，但也可在任何运行于适当架构的Docker环境中使用。

![balenalogo](https://avatars2.githubusercontent.com/u/6157842?s=200&v=4)

## 核心功能和特性

`balenalib`基础镜像具有以下显著特性：

- **便捷的包安装脚本**：名为`install_packages`的脚本，抽象了底层包管理器的细节。它将以最少的依赖（忽略可选依赖）安装指定包，清理包管理器元数据，并在安装失败时重试。

- **动态设备支持**：每个`balenalib`基础镜像都有默认的`ENTRYPOINT`定义为`ENTRYPOINT ["/usr/bin/entry.sh"]`。它会检查`UDEV`标志是否设置为true（通过添加`ENV UDEV=1`），如果为true，将启动`udevd`守护进程，使容器中的`/dev`目录出现相关设备节点。

更多详情，请查看文档中的[特性概述](https://www.balena.io/docs/reference/base-images/base-images/#features-overview)。

## 镜像变体

`balenalib`镜像有多种版本，每种版本针对特定使用场景设计。

### `:<version>` 或 `:<version>-run`

这是默认镜像。`run`变体设计为精简且最小化的变体，仅包含运行时必需组件。

### `:<version>-build`

构建变体是一个较重的镜像，包含许多从源代码构建所需的工具。这减少了您需要在Dockerfile中手动安装的包数量，从而减小系统上所有镜像的总体大小。

[variants]: https://www.balena.io/docs/reference/base-images/base-images/#run-vs-build?ref=dockerhub

## 使用场景和适用范围

适用于在IoT设备上开发和部署Node.js应用，特别是使用balena.io平台进行设备管理和应用部署的场景。可用于构建实时应用、服务器端应用和网络应用等。

## 详细使用方法和配置说明

### 在Balena中使用该镜像

此[指南][getting-started]可帮助您开始在balena中使用此基础镜像，还有一些很酷的[示例项目][example-projects]，让您了解balena的功能。

### 什么是Node.js？

Node.js是一个用于可扩展服务器端和网络应用的软件平台。Node.js应用使用JavaScript编写，可在Mac OS X、Windows和Linux上的Node.js运行时中无需修改即可运行。

Node.js应用旨在通过使用非阻塞I/O和异步事件来最大化吞吐量和效率。Node.js应用单线程运行，但Node.js使用多线程处理文件和网络事件。由于其异步特性，Node.js通常用于实时应用。

Node.js内部使用Google V8 JavaScript引擎执行代码；大部分基本模块用JavaScript编写。Node.js包含内置的异步I/O库，用于文件、 socket和HTTP通信。HTTP和socket支持使Node.js无需额外软件（如Apache）即可作为Web服务器运行。

> [wikipedia.org/wiki/Node.js](https://en.wikipedia.org/wiki/Node.js)

![logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/node/logo.png)

### 支持的版本及对应的`Dockerfile`链接

[`18.7.0 (latest)`、`16.17.0`、`14.20.0`、`12.22.12`](https://github.com/balena-io-library/base-images/tree/master/balena-base-images/node/odroid-c1/debian/)

有关此镜像及其历史的更多信息，请参见[`balena-io-library/official-images` GitHub仓库](https://github.com/balena-io-library/official-images)中的[相关清单文件（`odroid-c1-debian-node`）](https://github.com/balena-io-library/official-images/blob/master/library/odroid-c1-debian-node)。

### 如何使用此镜像

#### 在Node.js应用项目中创建`Dockerfile`

```dockerfile
# 指定所需版本的Node基础镜像 node:<version>
FROM docker.xuanyuan.run/balenalib/odroid-c1-debian-node:latest
# 替换为应用的默认端口
EXPOSE 8888
```

然后可以构建并运行Docker镜像：

```console
$ docker build -t my-nodejs-app .
$ docker run -it --rm --name my-running-app my-nodejs-app
```

如果您更喜欢Docker Compose：

```yml
version: "2"
services:
  node:
    image: "docker.xuanyuan.run/balenalib/odroid-c1-debian-node:latest"
    user: "node"
    working_dir: /home/node/app
    environment:
      - NODE_ENV=production
    volumes:
      - ./:/home/node/app
    expose:
      - "8081"
    command: "npm start"
```

然后使用Docker Compose运行：

```console
$ docker-compose up -d
```

Docker Compose示例将当前目录（包括node_modules）复制到容器中。它假设您的应用有一个名为[`package.json`](https://docs.npmjs.com/files/package.json)的文件，定义了[启动脚本](https://docs.npmjs.com/misc/scripts#default-values)。

#### 运行单个Node.js脚本

对于许多简单的单文件项目，编写完整的`Dockerfile`可能不方便。在这种情况下，您可以直接使用Node.js Docker镜像运行Node.js脚本：

```console
$ docker run -it --rm --name my-running-script -v "$PWD":/usr/src/app -w /usr/src/app balenalib/odroid-c1-debian-node:latest node your-daemon-or-script.js
```

[example-projects]: https://www.balena.io/docs/learn/getting-started/odroid-c1/nodejs/#example-projects?ref=dockerhub
[getting-started]: https://www.balena.io/docs/learn/getting-started/odroid-c1/nodejs/?ref=dockerhub

## 用户反馈

### 问题

如果您对此镜像有任何问题或疑问，请通过[GitHub issue](https://github.com/balena-io-library/base-images/issues)与我们联系。

### 贡献

我们邀请您贡献新功能、修复或更新，无论大小；我们始终很高兴收到拉取请求，并会尽力尽快处理。

在开始编码之前，我们建议通过[GitHub issue](https://github.com/balena-io-library/base-images/issues)讨论您的计划，特别是对于更宏大的贡献。这使其他贡献者有机会为您指明正确方向，提供设计反馈，并帮助您了解是否有人在做相同的事情。

### 文档

此镜像的文档存储在[基础镜像文档][docs]中。查看它以获取所有基础镜像的列表，包括许多专门的镜像，例如Node.js、Python、Go、更小的镜像等。

您还可以在此[博客文章][migration-docs]中找到`balenalib`基础镜像新功能的更多详细信息。

[docs]: https://www.balena.io/docs/reference/base-images/base-images/#balena-base-images?ref=dockerhub
[variants]: https://www.balena.io/docs/reference/base-images/base-images/#run-vs-build?ref=dockerhub
[migration-docs]: https://www.balena.io/blog/new-year-new-balena-base-images/?ref=dockerhub
[balena]: https://balena.io/?ref=dockerhub
[balena-os]: https://www.balena.io/os/?ref=dockerhub
