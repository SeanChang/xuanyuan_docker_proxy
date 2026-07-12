---
image: i386/alpine
description: "基于Alpine Linux的极简Docker镜像，仅5MB大小，包含完整的软件包索引，适用于构建轻量级应用和工具。"
source: https://xuanyuan.cloud/zh/r/i386/alpine
canonical: https://xuanyuan.cloud/zh/r/i386/alpine
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/i386/alpine" title="i386/alpine Docker 镜像中文简介、标签列表与拉取命令">i386/alpine 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

** 注意 **：这是[`alpine`官方镜像](https://hub.docker.com/_/alpine)的`i386`架构构建的"每架构"仓库——更多信息请参见官方镜像文档中的"[除amd64外的架构？](https://github.com/docker-library/official-images#architectures-other-than-amd64)"和官方镜像FAQ中的"[镜像源在Git中变更后如何处理？](https://github.com/docker-library/faq#an-images-source-changed-in-git-now-what)"。

# 快速参考

-** 维护者 **：  
  [Natanael Copa](https://github.com/alpinelinux/docker-alpine)（Alpine Linux维护者）

-** 获取帮助 **：  
  [Docker社区Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)

# 支持的标签及对应的`Dockerfile`链接

- [`20250108`, `edge`](https://github.com/alpinelinux/docker-alpine/blob/c1f1de232c970df2285c03050ab3747b8563164f/x86/Dockerfile)

- [`3.22.2`, `3.22`, `3`, `latest`](https://github.com/alpinelinux/docker-alpine/blob/4dc13cbc7caffe03c98aa99f28e27c2fb6f7e74d/x86/Dockerfile)

- [`3.21.5`, `3.21`](https://github.com/alpinelinux/docker-alpine/blob/2c30d5daeebb5090b1b6363a9e97dd88bf08a642/x86/Dockerfile)

- [`3.20.8`, `3.20`](https://github.com/alpinelinux/docker-alpine/blob/f5ce8f036ef8a57481ae6f3f1cf7f2300cff8d29/x86/Dockerfile)

- [`3.19.9`, `3.19`](https://github.com/alpinelinux/docker-alpine/blob/ee939d52345248420cf62d4606ccc7152bc5a107/x86/Dockerfile)

# 快速参考（续）

-** 提交issue **：  
  [https://github.com/alpinelinux/docker-alpine/issues](https://github.com/alpinelinux/docker-alpine/issues?q=)

-** 支持的架构 **：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
  [`amd64`](https://hub.docker.com/r/amd64/alpine/)、[`arm32v6`](https://hub.docker.com/r/arm32v6/alpine/)、[`arm32v7`](https://hub.docker.com/r/arm32v7/alpine/)、[`arm64v8`](https://hub.docker.com/r/arm64v8/alpine/)、[`i386`](https://hub.docker.com/r/i386/alpine/)、[`ppc64le`](https://hub.docker.com/r/ppc64le/alpine/)、[`riscv64`](https://hub.docker.com/r/riscv64/alpine/)、[`s390x`](https://hub.docker.com/r/s390x/alpine/)

-** 镜像 artifact 详情 **：  
  [repo-info仓库的`repos/alpine/`目录](https://github.com/docker-library/repo-info/blob/master/repos/alpine)（[历史记录](https://github.com/docker-library/repo-info/commits/master/repos/alpine)）  
  （镜像元数据、传输大小等）

-** 镜像更新 **：  
  [official-images仓库的`library/alpine`标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Falpine)  
  [official-images仓库的`library/alpine`文件](https://github.com/docker-library/official-images/blob/master/library/alpine)（[历史记录](https://github.com/docker-library/official-images/commits/master/library/alpine)）

-** 本描述的来源 **：  
  [docs仓库的`alpine/`目录](https://github.com/docker-library/docs/tree/master/alpine)（[历史记录](https://github.com/docker-library/docs/commits/master/alpine)）

# 什么是Alpine Linux？

[Alpine Linux](https://alpinelinux.org/)是围绕[musl libc](https://www.musl-libc.org/)和[BusyBox](https://www.busybox.net/)构建的Linux发行版。该镜像仅5MB大小，并可访问[软件包仓库](https://pkgs.alpinelinux.org/)，其完整性远超其他基于BusyBox的镜像。这使得Alpine Linux成为构建工具乃至生产应用的理想基础镜像。[在此了解更多关于Alpine Linux的信息](https://alpinelinux.org/about/)，其理念与Docker镜像的设计目标高度契合。

![logo](https://raw.githubusercontent.com/docker-library/docs/781049d54b1bd9b26d7e8ad384a92f7e0dcb0894/alpine/logo.png)

# 如何使用此镜像

## 使用方法

与其他基础镜像用法相同：

```dockerfile
FROM docker.xuanyuan.run/i386/alpine:3.14
RUN apk add --no-cache mysql-client
ENTRYPOINT ["mysql"]
```

此示例构建的镜像虚拟大小仅36.8MB。相比之下，基于Ubuntu的类似配置：

```dockerfile
FROM docker.xuanyuan.run/ubuntu:20.04
RUN apt-get update \
    && apt-get install -y --no-install-recommends mysql-client \
    && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["mysql"]
```

生成的镜像虚拟大小约为145MB。

# 许可

查看[许可信息](https://pkgs.alpinelinux.org)以了解此镜像中包含的软件的许可条款。

与所有Docker镜像一样，本镜像可能还包含其他软件，这些软件可能采用其他许可（如基础发行版中的Bash等，以及主要软件的任何直接或间接依赖项）。

可在[repo-info仓库的`alpine/`目录](https://github.com/docker-library/repo-info/tree/master/repos/alpine)中找到一些能够自动检测到的额外许可信息。

对于任何预构建镜像的使用，镜像用户有责任确保对本镜像的任何使用都符合其中包含的所有软件的相关许可。
