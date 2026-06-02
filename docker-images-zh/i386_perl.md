---
image: i386/perl
description: "Perl是一种高级、通用、解释型、动态编程语言。"
source: https://xuanyuan.cloud/zh/r/i386/perl
canonical: https://xuanyuan.cloud/zh/r/i386/perl
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/i386/perl" title="i386/perl Docker 镜像中文简介、标签列表与拉取命令">i386/perl — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/i386/perl" title="i386/perl Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/i386/perl</a>

**注意：** 这是 [perl 官方镜像](https://hub.docker.com/_/perl) 的 `i386` 架构构建的“per-architecture”仓库——更多信息请参见官方镜像文档中的“[除 amd64 外的架构？](https://github.com/docker-library/official-images#architectures-other-than-amd64)”以及官方镜像 FAQ 中的“[Git 中镜像的源代码已更改，该怎么办？](https://github.com/docker-library/faq#an-images-source-changed-in-git-now-what)”。


# 快速参考

- **维护者**：  
  [Perl 社区](https://github.com/Perl/docker-perl)

- **获取帮助**：  
  [Docker 社区 Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)

- **提交问题**：  
  [https://github.com/Perl/docker-perl/issues](https://github.com/Perl/docker-perl/issues?q=)

- **支持的架构**：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
  [`amd64`](https://hub.docker.com/r/amd64/perl/)、[`arm32v5`](https://hub.docker.com/r/arm32v5/perl/)、[`arm32v7`](https://hub.docker.com/r/arm32v7/perl/)、[`arm64v8`](https://hub.docker.com/r/arm64v8/perl/)、[`i386`](https://hub.docker.com/r/i386/perl/)、[`mips64le`](https://hub.docker.com/r/mips64le/perl/)、[`ppc64le`](https://hub.docker.com/r/ppc64le/perl/)、[`riscv64`](https://hub.docker.com/r/riscv64/perl/)、[`s390x`](https://hub.docker.com/r/s390x/perl/)

- **已发布镜像制品详情**：  
  [repo-info 仓库的 `repos/perl/` 目录](https://github.com/docker-library/repo-info/blob/master/repos/perl)（[历史记录](https://github.com/docker-library/repo-info/commits/master/repos/perl)）  
 （镜像元数据、传输大小等）

- **镜像更新**：  
  [official-images 仓库的 `library/perl` 标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fperl)  
  [official-images 仓库的 `library/perl` 文件](https://github.com/docker-library/official-images/blob/master/library/perl)（[历史记录](https://github.com/docker-library/official-images/commits/master/library/perl)）

- **本描述的来源**：  
  [docs 仓库的 `perl/` 目录](https://github.com/docker-library/docs/tree/master/perl)（[历史记录](https://github.com/docker-library/docs/commits/master/perl)）


# 支持的标签及对应的 Dockerfile 链接

- [`5.42.0-bookworm`, `5.42-bookworm`, `5-bookworm`, `bookworm`, `stable-bookworm`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.042.000-main-bookworm/Dockerfile)

- [`5.42.0-bullseye`, `5.42-bullseye`, `5-bullseye`, `bullseye`, `stable-bullseye`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.042.000-main-bullseye/Dockerfile)

- [`5.42.0-slim-bookworm`, `5.42-slim-bookworm`, `5-slim-bookworm`, `slim-bookworm`, `stable-slim-bookworm`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.042.000-slim-bookworm/Dockerfile)

- [`5.42.0-slim-bullseye`, `5.42-slim-bullseye`, `5-slim-bullseye`, `slim-bullseye`, `stable-slim-bullseye`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.042.000-slim-bullseye/Dockerfile)

- [`5.42.0-threaded-bookworm`, `5.42-threaded-bookworm`, `5-threaded-bookworm`, `threaded-bookworm`, `stable-threaded-bookworm`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.042.000-main,threaded-bookworm/Dockerfile)

- [`5.42.0-threaded-bullseye`, `5.42-threaded-bullseye`, `5-threaded-bullseye`, `threaded-bullseye`, `stable-threaded-bullseye`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.042.000-main,threaded-bullseye/Dockerfile)

- [`5.42.0-slim-threaded-bookworm`, `5.42-slim-threaded-bookworm`, `5-slim-threaded-bookworm`, `slim-threaded-bookworm`, `stable-slim-threaded-bookworm`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.042.000-slim,threaded-bookworm/Dockerfile)

- [`5.42.0-slim-threaded-bullseye`, `5.42-slim-threaded-bullseye`, `5-slim-threaded-bullseye`, `slim-threaded-bullseye`, `stable-slim-threaded-bullseye`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.042.000-slim,threaded-bullseye/Dockerfile)

- [`5.40.3-bookworm`, `5.40-bookworm`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.040.003-main-bookworm/Dockerfile)

- [`5.40.3-bullseye`, `5.40-bullseye`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.040.003-main-bullseye/Dockerfile)

- [`5.40.3-slim-bookworm`, `5.40-slim-bookworm`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.040.003-slim-bookworm/Dockerfile)

- [`5.40.3-slim-bullseye`, `5.40-slim-bullseye`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.040.003-slim-bullseye/Dockerfile)

- [`5.40.3-threaded-bookworm`, `5.40-threaded-bookworm`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.040.003-main,threaded-bookworm/Dockerfile)

- [`5.40.3-threaded-bullseye`, `5.40-threaded-bullseye`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.040.003-main,threaded-bullseye/Dockerfile)

- [`5.40.3-slim-threaded-bookworm`, `5.40-slim-threaded-bookworm`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.040.003-slim,threaded-bookworm/Dockerfile)

- [`5.40.3-slim-threaded-bullseye`, `5.40-slim-threaded-bullseye`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.040.003-slim,threaded-bullseye/Dockerfile)

- [`5.38.5-bookworm`, `5.38-bookworm`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.038.005-main-bookworm/Dockerfile)

- [`5.38.5-bullseye`, `5.38-bullseye`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.038.005-main-bullseye/Dockerfile)

- [`5.38.5-slim-bookworm`, `5.38-slim-bookworm`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.038.005-slim-bookworm/Dockerfile)

- [`5.38.5-slim-bullseye`, `5.38-slim-bullseye`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.038.005-slim-bullseye/Dockerfile)

- [`5.38.5-threaded-bookworm`, `5.38-threaded-bookworm`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.038.005-main,threaded-bookworm/Dockerfile)

- [`5.38.5-threaded-bullseye`, `5.38-threaded-bullseye`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.038.005-main,threaded-bullseye/Dockerfile)

- [`5.38.5-slim-threaded-bookworm`, `5.38-slim-threaded-bookworm`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.038.005-slim,threaded-bookworm/Dockerfile)

- [`5.38.5-slim-threaded-bullseye`, `5.38-slim-threaded-bullseye`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.038.005-slim,threaded-bullseye/Dockerfile)

- [`5.43.2-bookworm`, `5.43-bookworm`, `devel-bookworm`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.043.002-main-bookworm/Dockerfile)

- [`5.43.2-bullseye`, `5.43-bullseye`, `devel-bullseye`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.043.002-main-bullseye/Dockerfile)

- [`5.43.2-slim-bookworm`, `5.43-slim-bookworm`, `devel-slim-bookworm`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.043.002-slim-bookworm/Dockerfile)

- [`5.43.2-slim-bullseye`, `5.43-slim-bullseye`, `devel-slim-bullseye`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.043.002-slim-bullseye/Dockerfile)

- [`5.43.2-threaded-bookworm`, `5.43-threaded-bookworm`, `devel-threaded-bookworm`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.043.002-main,threaded-bookworm/Dockerfile)

- [`5.43.2-threaded-bullseye`, `5.43-threaded-bullseye`, `devel-threaded-bullseye`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.043.002-main,threaded-bullseye/Dockerfile)

- [`5.43.2-slim-threaded-bookworm`, `5.43-slim-threaded-bookworm`, `devel-slim-threaded-bookworm`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.043.002-slim,threaded-bookworm/Dockerfile)

- [`5.43.2-slim-threaded-bullseye`, `5.43-slim-threaded-bullseye`, `devel-slim-threaded-bullseye`](https://github.com/perl/docker-perl/blob/9a593371b5b762c4e6247a4b14141dfaa0ccaeb8/5.043.002-slim,threaded-bullseye/Dockerfile)


# 什么是 Perl？

Perl 是一种高级、通用、解释型、动态编程语言。Perl 语言借鉴了其他编程语言的特性，包括 C、shell 脚本（sh）、AWK 和 sed。

> [wikipedia.org/wiki/Perl](https://en.wikipedia.org/wiki/Perl)

![logo](https://raw.githubusercontent.com/docker-library/docs/2f0c63f66919d5f310ba8357cec
