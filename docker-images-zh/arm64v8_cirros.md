---
image: arm64v8/cirros
description: "CirrOS是一种小型操作系统，专门用于在云上运行。"
source: https://xuanyuan.cloud/zh/r/arm64v8/cirros
canonical: https://xuanyuan.cloud/zh/r/arm64v8/cirros
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm64v8/cirros" title="arm64v8/cirros Docker 镜像中文简介、标签列表与拉取命令">arm64v8/cirros 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

**注意：** 这是 [cirros官方镜像](https://hub.docker.com/_/cirros) 的 `arm64v8` 构建的“每架构”仓库——更多信息，请参见官方镜像文档中的“[除amd64之外的架构？](https://github.com/docker-library/official-images#architectures-other-than-amd64)”和官方镜像FAQ中的“[Git中的镜像源已更改，现在该怎么办？](https://github.com/docker-library/faq#an-images-source-changed-in-git-now-what)”。

# 快速参考

-** 维护者：**[Docker社区](https://github.com/tianon/docker-brew-cirros)

-** 哪里获取帮助：**[Docker社区Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)

# 支持的标签及对应的 `Dockerfile` 链接

- [`0.6.3`, `0.6`, `0`, `latest`](https://github.com/tianon/docker-brew-cirros/blob/1821a0ca9eaf82280a2e953df56e88ab50178628/arches/arm64v8/Dockerfile)

# 快速参考（续）

-** 问题提交地址：**[https://github.com/tianon/docker-brew-cirros/issues](https://github.com/tianon/docker-brew-cirros/issues?q=)

-** 支持的架构：**([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64)) [`amd64`](https://hub.docker.com/r/amd64/cirros/)、[`arm32v7`](https://hub.docker.com/r/arm32v7/cirros/)、[`arm64v8`](https://hub.docker.com/r/arm64v8/cirros/)、[`ppc64le`](https://hub.docker.com/r/ppc64le/cirros/)

-** 发布的镜像工件详情：**[repo-info仓库的 `repos/cirros/` 目录](https://github.com/docker-library/repo-info/blob/master/repos/cirros)（[历史](https://github.com/docker-library/repo-info/commits/master/repos/cirros)）（镜像元数据、传输大小等）

-** 镜像更新：**[official-images仓库的 `library/cirros` 标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fcirros)[official-images仓库的 `library/cirros` 文件](https://github.com/docker-library/official-images/blob/master/library/cirros)（[历史](https://github.com/docker-library/official-images/commits/master/library/cirros)）

-** 本描述的来源：**[docs仓库的 `cirros/` 目录](https://github.com/docker-library/docs/tree/master/cirros)（[历史](https://github.com/docker-library/docs/commits/master/cirros)）

# 什么是CirrOS？

CirrOS项目提供Linux磁盘和内核/initramfs镜像。这些镜像非常适合测试，因为它们体积小且启动迅速。请注意：

-** 镜像仅用于测试 **。不应在生产环境中使用。
-** 镜像具有已知的登录信息 **。用户可以使用“cirros:letsgocubs”本地或远程登录，并拥有无密码的sudo root权限。

CirrOS镜像具有用于调试或开发云基础设施的有用工具和功能。

> [github.com/cirros-dev/cirros](https://github.com/cirros-dev/cirros#readme)

![logo](https://raw.githubusercontent.com/docker-library/docs/b449be7df57e9ed9086bb5821bfb5d6cdc5d67a4/cirros/logo.png)

# 许可

查看此镜像中包含的软件的[许可信息](https://launchpad.net/cirros)：

> 构建CirrOS的代码在GPLv2下可用。将要分发的二进制镜像包含许多不同的许可，所有这些许可都是开源的。

与所有Docker镜像一样，这些镜像可能还包含其他软件，这些软件可能使用其他许可（例如基础发行版中的Bash等，以及包含的主要软件的任何直接或间接依赖项）。

一些能够自动检测到的其他许可信息可能位于[repo-info仓库的 `cirros/` 目录](https://github.com/docker-library/repo-info/tree/master/repos/cirros)中。

对于任何预构建镜像的使用，镜像用户有责任确保对本镜像的任何使用都符合其中包含的所有软件的相关许可。
