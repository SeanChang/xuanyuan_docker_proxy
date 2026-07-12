---
image: amd64/python
description: "Python是一种解释型、交互式、面向对象的开源编程语言。"
source: https://xuanyuan.cloud/zh/r/amd64/python
canonical: https://xuanyuan.cloud/zh/r/amd64/python
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amd64/python" title="amd64/python Docker 镜像中文简介、标签列表与拉取命令">amd64/python 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Python Docker镜像(amd64架构)技术文档

## 注意事项

本仓库是[`python`官方镜像](https://hub.docker.com/_/python)的`amd64`架构构建版本。更多信息请参见官方镜像文档中的["除amd64之外的架构？"](https://github.com/docker-library/official-images#architectures-other-than-amd64)和官方镜像FAQ中的["Git中的镜像源已更改，该怎么办？"](https://github.com/docker-library/faq#an-images-source-changed-in-git-now-what)。

## 镜像概述和主要用途

Python是一种解释型、交互式、面向对象的开源编程语言。它集成了模块、异常处理、动态类型、高级动态数据类型和类等特性。Python以强大的功能和清晰的语法著称，拥有众多系统调用、库和窗口系统接口，并可通过C或C++进行扩展。它也可用作需要可编程接口的应用程序的扩展语言。Python具有良好的可移植性，可在多种Unix变体、Mac和Windows 2000及更高版本上运行。

### 维护者

[Docker社区](https://github.com/docker-library/python)

### 获取帮助

[Docker社区Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic)或[Stack Overflow](https://stackoverflow.com/help/on-topic)

## 支持的标签及对应Dockerfile链接

参见FAQ中的["'Shared'和'Simple'标签有什么区别？"](https://github.com/docker-library/faq#whats-the-difference-between-shared-and-simple-tags)。

### 简单标签(Simple Tags)

- [`3.15.0a1-trixie`, `3.15-rc-trixie`](https://github.com/docker-library/python/blob/303456576fd52b3e000639d5cfdf384442e730d7/3.15-rc/trixie/Dockerfile)
- [`3.15.0a1-slim-trixie`, `3.15-rc-slim-trixie`, `3.15.0a1-slim`, `3.15-rc-slim`](https://github.com/docker-library/python/blob/303456576fd52b3e000639d5cfdf384442e730d7/3.15-rc/slim-trixie/Dockerfile)
- [`3.15.0a1-bookworm`, `3.15-rc-bookworm`](https://github.com/docker-library/python/blob/303456576fd52b3e000639d5cfdf384442e730d7/3.15-rc/bookworm/Dockerfile)
- [`3.15.0a1-slim-bookworm`, `3.15-rc-slim-bookworm`](https://github.com/docker-library/python/blob/303456576fd52b3e000639d5cfdf384442e730d7/3.15-rc/slim-bookworm/Dockerfile)
- [`3.15.0a1-alpine3.22`, `3.15-rc-alpine3.22`, `3.15.0a1-alpine`, `3.15-rc-alpine`](https://github.com/docker-library/python/blob/303456576fd52b3e000639d5cfdf384442e730d7/3.15-rc/alpine3.22/Dockerfile)
- [`3.15.0a1-alpine3.21`, `3.15-rc-alpine3.21`](https://github.com/docker-library/python/blob/303456576fd52b3e000639d5cfdf384442e730d7/3.15-rc/alpine3.21/Dockerfile)
- [`3.14.0-trixie`, `3.14-trixie`, `3-trixie`, `trixie`](https://github.com/docker-library/python/blob/a83345bce8e75b407f283511dc3128b2062d8c1e/3.14/trixie/Dockerfile)
- [`3.14.0-slim-trixie`, `3.14-slim-trixie`, `3-slim-trixie`, `slim-trixie`, `3.14.0-slim`, `3.14-slim`, `3-slim`, `slim`](https://github.com/docker-library/python/blob/a83345bce8e75b407f283511dc3128b2062d8c1e/3.14/slim-trixie/Dockerfile)
- [`3.14.0-bookworm`, `3.14-bookworm`, `3-bookworm`, `bookworm`](https://github.com/docker-library/python/blob/a83345bce8e75b407f283511dc3128b2062d8c1e/3.14/bookworm/Dockerfile)
- [`3.14.0-slim-bookworm`, `3.14-slim-bookworm`, `3-slim-bookworm`, `slim-bookworm`](https://github.com/docker-library/python/blob/a83345bce8e75b407f283511dc3128b2062d8c1e/3.14/slim-bookworm/Dockerfile)
- [`3.14.0-alpine3.22`, `3.14-alpine3.22`, `3-alpine3.22`, `alpine3.22`, `3.14.0-alpine`, `3.14-alpine`, `3-alpine`, `alpine`](https://github.com/docker-library/python/blob/a83345bce8e75b407f283511dc3128b2062d8c1e/3.14/alpine3.22/Dockerfile)
- [`3.14.0-alpine3.21`, `3.14-alpine3.21`, `3-alpine3.21`, `alpine3.21`](https://github.com/docker-library/python/blob/a83345bce8e75b407f283511dc3128b2062d8c1e/3.14/alpine3.21/Dockerfile)

### 共享标签(Shared Tags)

- `3.15.0a1`, `3.15-rc`:
  - [`3.15.0a1-trixie`](https://github.com/docker-library/python/blob/303456576fd52b3e000639d5cfdf384442e730d7/3.15-rc/trixie/Dockerfile)

- `3.14.0`, `3.14`, `3`, `latest`:
  - [`3.14.0-trixie`](https://github.com/docker-library/python/blob/a83345bce8e75b407f283511dc3128b2062d8c1e/3.14/trixie/Dockerfile)

- `3.13.9`, `3.13`:
  - [`3.13.9-trixie`](https://github.com/docker-library/python/blob/3f2d7e4c339ab883455b81a873519f1d0f2cd80a/3.13/trixie/Dockerfile)

- `3.12.12`, `3.12`:
  - [`3.12.12-trixie`](https://github.com/docker-library/python/blob/e4ab0fe5ef4df797ed09883becf983a56ab97eca/3.12/trixie/Dockerfile)

- `3.11.14`, `3.11`:
  - [`3.11.14-trixie`](https://github.com/docker-library/python/blob/54a65f4ff531391810946ee17b0806accbda0fae/3.11/trixie/Dockerfile)

- `3.10.19`, `3.10`:
  - [`3.10.19-trixie`](https://github.com/docker-library/python/blob/54a65f4ff531391810946ee17b0806accbda0fae/3.10/trixie/Dockerfile)

- `3.9.24`, `3.9`:
  - [`3.9.24-trixie`](https://github.com/docker-library/python/blob/00c4cce6b91488475bfaf85921bae12604a56d4a/3.9/trixie/Dockerfile)

## 快速参考

### 问题反馈渠道

[https://github.com/docker-library/python/issues](https://github.com/docker-library/python/issues?q=)

### 支持的架构

([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
[`amd64`](https://hub.docker.com/r/amd64/python/), [`arm32v5`](https://hub.docker.com/r/arm32v5/python/), [`arm32v6`](https://hub.docker.com/r/arm32v6/python/), [`arm32v7`](https://hub.docker.com/r/arm32v7/python/), [`arm64v8`](https://hub.docker.com/r/arm64v8/python/), [`i386`](https://hub.docker.com/r/i386/python/), [`mips64le`](https://hub.docker.com/r/mips64le/python/), [`ppc64le`](https://hub.docker.com/r/ppc64le/python/), [`riscv64`](https://hub.docker.com/r/riscv64/python/), [`s390x`](https://hub.docker.com/r/s390x/python/), [`windows-amd64`](https://hub.docker.com/r/winamd64/python/)

### 镜像工件详情

[repo-info仓库的`repos/python/`目录](https://github.com/docker-library/repo-info/blob/master/repos/python) ([历史记录](https://github.com/docker-library/repo-info/commits/master/repos/python))  
(包含镜像元数据、传输大小等信息)

### 镜像更新

[official-images仓库的`library/python`标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fpython)  
[official-images仓库的`library/python`文件](https://github.com/docker-library/official-images/blob/master/library/python) ([历史记录](https://github.com/docker-library/official-images/commits/master/library/python))

### 文档来源

[docs仓库的`python/`目录](https://github.com/docker-library/docs/tree/master/python) ([历史记录](https://github.com/docker-library/docs/commits/master/python))

## 核心功能和特性

Python是一种解释型、交互式、面向对象的开源编程语言。它具有以下核心特性：

- 简洁清晰的语法
- 动态类型系统
- 高级动态数据类型
- 支持面向对象编程
- 模块化和异常处理机制
- 可扩展C/C++接口
- 丰富的标准库和第三方库
- 跨平台可移植性

## 使用场景和适用范围

Python Docker镜像适用于多种场景：

- Python应用程序的容器化部署
- 开发环境标准化
- CI/CD流程集成
- 微服务架构中的Python服务
- 快速原型开发
- 自动化脚本运行环境
- 数据科学和机器学习工作流

## 详细使用方法和配置说明

### 创建Dockerfile

在Python应用项目中创建Dockerfile：

```dockerfile
FROM docker.xuanyuan.run/amd64/python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./your-daemon-or-script.py" ]
```

如需使用Python 2：

```dockerfile
FROM docker.xuanyuan.run/amd64/python:2

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

对于简单的单文件项目，可直接使用Python Docker镜像运行脚本：

```console
$ docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp amd64/python:3 python your-daemon-or-script.py
```

Python 2版本：

```console
$ docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp amd64/python:2 python your-daemon-or-script.py
```

### docker-compose配置示例

创建`docker-compose.yml`文件：

```yaml
version: '3'
services:
  python-app:
    build: .
    image: docker.xuanyuan.run/amd64/python:3.14-slim
    volumes:
      - ./app:/usr/src/app
    working_dir: /usr/src/app
    command: python your-script.py
    environment:
      - PYTHONUNBUFFERED=1
      - PYTHONDONTWRITEBYTECODE=1
```

运行服务：

```console
$ docker-compose up
```

### 镜像中的多个Python版本

在非slim变体中，除了镜像提供的`/usr/local/bin/python`（默认在`$PATH`中）外，还会有一个（发行版提供的）`python`可执行文件位于`/usr/bin/python`（和/或`/usr/bin/python3`）。这是由于在非slim变体中使用`buildpack-deps`镜像导致的副作用。

## 镜像变体

`amd64/python`镜像有多种变体，适用于不同场景：

### `amd64/python:<version>`（默认版本）

这是默认镜像，适合大多数用户。它基于`buildpack-deps`，包含大量常用的Debian软件包，减少了衍生镜像需要安装的软件包数量，从而减小整体镜像大小。

标签中包含如bookworm或trixie等名称，这些是[Debian](https://wiki.debian.org/DebianReleases)的发行版代号，表示镜像基于哪个Debian版本构建。

### `amd64/python:<version>-slim`（精简版本）

此镜像不包含默认标签中的常见Debian软件包，只包含运行`amd64/python`所需的最小Debian软件包。适用于空间受限的环境。

使用此镜像时，`pip install`在安装预编译的Python包时可以正常工作，但安装需要编译的源代码包时可能失败。解决方法包括：

- 使用此镜像并在运行`pip install`前安装所需的Debian软件包
- 使用默认镜像，它包含最常用的Debian软件包

### `amd64/python:<version>-alpine`（轻量级版本）

此镜像基于流行的[Alpine Linux项目](https://alpinelinux.org)，镜像大小非常小（约5MB），因此生成的最终镜像也更精简。

该变体适用于对最终镜像大小有严格要求的场景。注意它使用[musl libc](https://musl.libc.org)而非[glibc](https://www.etalabs.net/compare_libcs.html)，可能导致某些软件出现兼容性问题。

由于镜像极小，通常不包含额外工具（如`git`或`bash`），需要时可在Dockerfile中自行安装。

## 许可证信息

查看[Python 2](https://docs.python.org/2/license.html)和[Python 3](https://docs.python.org/3/license.html)的许可证信息。

与所有Docker镜像一样，这些镜像可能还包含其他软件，这些软件可能具有其他许可证（如基础发行版中的Bash等，以及主软件的任何直接或间接依赖项）。

在[`repo-info`仓库的`python/`目录](https://github.com/docker-library/repo-info/tree/master/repos/python)中可以找到一些能够自动检测到的额外许可证信息。

对于任何预构建镜像的使用，镜像用户有责任确保对该镜像的任何使用都符合其中包含的所有软件的相关许可证。
