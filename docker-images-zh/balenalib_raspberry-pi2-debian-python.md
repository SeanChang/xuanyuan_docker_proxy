---
image: balenalib/raspberry-pi2-debian-python
description: "balena.io IoT设备基础镜像系列成员，优化用于balena.io和balenaOS，也适用于其他Docker环境，提供install_packages包安装脚本、udev动态设备支持等特性，支持Python应用开发部署。"
source: https://xuanyuan.cloud/zh/r/balenalib/raspberry-pi2-debian-python
canonical: https://xuanyuan.cloud/zh/r/balenalib/raspberry-pi2-debian-python
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/balenalib/raspberry-pi2-debian-python" title="balenalib/raspberry-pi2-debian-python Docker 镜像中文简介、标签列表与拉取命令">balenalib/raspberry-pi2-debian-python 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# balenalib Raspberry Pi 2 Debian Python 基础镜像

## 镜像概述和主要用途

本镜像属于[balena.io][balena] IoT设备基础镜像系列，专为物联网设备优化设计。该镜像针对[balena.io][balena]和[balenaOS][balena-os]进行了优化，但也可在任何适当架构的Docker环境中使用。

![balenalogo](https://avatars2.githubusercontent.com/u/6157842?s=200&v=4)

## 核心功能和特性

`balenalib`基础镜像包含以下显著特性：

- **便捷的包安装脚本**：提供`install_packages`工具，抽象底层包管理器细节，以最少依赖安装指定包（忽略可选依赖），清理包管理器元数据，并在安装失败时重试。

- **动态设备支持**：每个`balenalib`基础镜像默认`ENTRYPOINT`为`ENTRYPOINT ["/usr/bin/entry.sh"]`，通过设置`ENV UDEV=1`可启用udev支持，此时会启动`udevd`守护进程，使容器`/dev`目录中显示相关设备节点。

更多详情请查看文档中的[特性概述](https://www.balena.io/docs/reference/base-images/base-images/#features-overview)。

## 镜像变体

`balenalib`镜像提供多种版本，适用于不同使用场景：

### `:<version>` 或 `:<version>-run`

默认镜像版本。`run`变体设计为精简版本，仅包含运行时必需组件。

### `:<version>-build`

构建变体是包含更多源码构建工具的重量级镜像，减少Dockerfile中手动安装工具的需求，从而减小系统中所有镜像的总体积。

[了解更多变体信息](https://www.balena.io/docs/reference/base-images/base-images/#run-vs-build?ref=dockerhub)

## 使用场景和适用范围

- 基于balena.io和balenaOS的IoT设备Python应用开发与部署
- 需要动态设备接入支持的物联网项目
- 在Raspberry Pi 2等ARM架构设备上运行Python应用
- 需简化包管理和依赖安装的Docker环境

## 与Balena一起使用

[入门指南][getting-started]可帮助您开始使用此基础镜像，同时提供[示例项目][example-projects]展示balena平台的应用可能性。

## 关于Python

Python是一种解释型、交互式、面向对象的开源编程语言。它包含模块、异常处理、动态类型、高级动态数据类型和类。Python结合了强大的功能和清晰的语法，可与许多系统调用、库及窗口系统交互，并可通过C或C++扩展。此外，Python具有可移植性，可在多种Unix变体、Mac和Windows 2000及更高版本上运行。

> [wikipedia.org/wiki/Python_(programming_language)](https://en.wikipedia.org/wiki/Python_%28programming_language%29)

![Python logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/python/logo.png)

## 支持的版本及Dockerfile链接

[`2.7.16 (latest)`、`3.7.4`、`3.6.9`、`3.5.7`、`3.4.10`](https://github.com/balena-io-library/base-images/tree/master/balena-base-images/python/raspberry-pi2/debian/)

有关镜像及其历史的更多信息，请查看[`balena-io-library/official-images` GitHub仓库](https://github.com/balena-io-library/official-images)中的[相关清单文件 (`raspberry-pi2-debian-python`)](https://github.com/balena-io-library/official-images/blob/master/library/raspberry-pi2-debian-python)。

## 使用方法和配置说明

### 创建Python应用的Dockerfile

在Python项目中创建`Dockerfile`：

```dockerfile
FROM docker.xuanyuan.run/balenalib/raspberry-pi2-debian-python:latest

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./your-daemon-or-script.py" ]
```

构建并运行Docker镜像：

```console
$ docker build -t my-python-app .
$ docker run -it --rm --name my-running-app my-python-app
```

### 运行单个Python脚本

对于简单的单文件项目，可直接使用Python镜像运行脚本：

```console
$ docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp balenalib/raspberry-pi2-debian-python:latest python your-daemon-or-script.py
```

### 配置参数

- **UDEV支持**：设置环境变量`ENV UDEV=1`可启用udevd守护进程，使容器`/dev`目录自动识别动态插入的设备节点。

## 用户反馈

### 问题反馈

如遇镜像相关问题或疑问，请通过[GitHub Issue](https://github.com/balena-io-library/base-images/issues)联系我们。

### 贡献

欢迎贡献新功能、修复或更新（无论大小）。我们鼓励在编码前通过[GitHub Issue](https://github.com/balena-io-library/base-images/issues)讨论您的计划，以便其他贡献者提供指导和反馈。

### 文档

镜像文档存储在[基础镜像文档][docs]中，包含所有基础镜像（如node、python、go等专用镜像）的列表。有关`balenalib`基础镜像新特性的更多详情，请查看此[博客文章][migration-docs]。

[balena]: https://balena.io/?ref=dockerhub
[balena-os]: https://www.balena.io/os/?ref=dockerhub
[getting-started]: https://www.balena.io/docs/learn/getting-started/raspberry-pi2/python/?ref=dockerhub
[example-projects]: https://www.balena.io/docs/learn/getting-started/raspberry-pi2/python/#example-projects?ref=dockerhub
[docs]: https://www.balena.io/docs/reference/base-images/base-images/#balena-base-images?ref=dockerhub
[migration-docs]: https://www.balena.io/blog/new-year-new-balena-base-images/?ref=dockerhub
