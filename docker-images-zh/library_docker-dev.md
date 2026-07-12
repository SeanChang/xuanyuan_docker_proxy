---
image: library/docker-dev
description: "此镜像已正式弃用，推荐使用dockercore/docker自动构建版本，将不再接收更新，请相应调整使用方式。"
source: https://xuanyuan.cloud/zh/r/library/docker-dev
canonical: https://xuanyuan.cloud/zh/r/library/docker-dev
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/docker-dev" title="library/docker-dev Docker 镜像中文简介、标签列表与拉取命令">library/docker-dev 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 已弃用（DEPRECATED）

此镜像已正式弃用，推荐使用[dockercore/docker自动构建版本](https://hub.docker.com/r/dockercore/docker/)，将不再接收更新。请相应调整您的使用方式。

# 支持的标签及对应的`Dockerfile`链接

- [`1.9.1`, `1.9`, `1` (*Dockerfile*)](https://github.com/docker/docker/blob/a34a1d598c6096ed8b5ce5219e77d68e5cd85462/Dockerfile)

[![](https://badge.imagelayers.io/docker-dev:1.9.1.svg)](https://imagelayers.io/?images=docker-dev:1.9.1)

有关此镜像及其历史的更多信息，请参见[相关清单文件（`library/docker-dev`）](https://github.com/docker-library/official-images/blob/master/library/docker-dev)。此镜像通过[向`docker-library/official-images` GitHub仓库提交拉取请求](https://github.com/docker-library/official-images/pulls?q=label%3Alibrary%2Fdocker-dev)进行更新。

有关上述各支持标签的虚拟/传输大小和各个层的详细信息，请参见[`docker-library/docs` GitHub仓库](https://github.com/docker-library/docs)中的[`docker-dev/tag-details.md`文件](https://github.com/docker-library/docs/blob/master/docker-dev/tag-details.md)。

# 什么是Docker？

Docker是一个开源项目，通过在Linux上提供操作系统级虚拟化的额外抽象层和自动化，来自动化软件容器内应用程序的部署。Docker使用Linux内核的资源隔离功能（如cgroups和内核命名空间），允许在单个Linux实例中运行独立的“容器”，避免了启动虚拟机的开销。

> [wikipedia.org/wiki/Docker_(software)](https://en.wikipedia.org/wiki/Docker_%28software%29)

![logo](https://raw.githubusercontent.com/docker-library/docs/b449be7df57e9ed9086bb5821bfb5d6cdc5d67a4/docker-dev/logo.png)

# 关于此镜像

此镜像包含Docker项目本身的构建和测试环境，官方发布版本均由此生成。

如果您正在寻找用于Docker `master`分支开发工作的最新开发环境，应使用[`dockercore/docker`](https://registry.hub.docker.com/u/dockercore/docker/)。它是[`github.com/docker/docker`](https://github.com/docker/docker)的`master`分支的自动构建版本，由Docker核心团队维护。

# 支持的Docker版本

此镜像官方支持Docker 1.11.2版本。

对旧版本（低至1.6）的支持基于尽力而为原则。

有关如何升级Docker守护程序的详细信息，请参见[Docker安装文档](https://docs.docker.com/installation/)。

# 用户反馈

## 文档

此镜像的文档存储在[`docker-library/docs` GitHub仓库](https://github.com/docker-library/docs)的[`docker-dev/`目录](https://github.com/docker-library/docs/tree/master/docker-dev)中。在尝试提交拉取请求之前，请务必熟悉该仓库的[`README.md`文件](https://github.com/docker-library/docs/blob/master/README.md)。

## 问题

如果您对此镜像有任何问题或疑问，请通过[GitHub issue](https://github.com/docker/docker/issues)与我们联系。如果问题与CVE相关，请首先检查[`official-images`仓库上的`cve-tracker` issue](https://github.com/docker-library/official-images/issues?q=label%3Acve-tracker)。

您也可以通过[Freenode](https://freenode.net)上的`#docker-library` IRC频道联系许多官方镜像维护者。

## 贡献

我们邀请您贡献新功能、修复或更新，无论大小；我们始终很高兴收到拉取请求，并会尽力尽快处理。

在开始编码之前，我们建议通过[GitHub issue](https://github.com/docker/docker/issues)讨论您的计划，尤其是对于更宏大的贡献。这让其他贡献者有机会为您指明方向，提供设计反馈，并帮助您了解是否有其他人正在做同样的事情。
