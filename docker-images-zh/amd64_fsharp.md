---
image: amd64/fsharp
description: "F#是一种多范式编程语言，涵盖函数式、命令式和面向对象编程风格"
source: https://xuanyuan.cloud/zh/r/amd64/fsharp
canonical: https://xuanyuan.cloud/zh/r/amd64/fsharp
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amd64/fsharp" title="amd64/fsharp Docker 镜像中文简介、标签列表与拉取命令">amd64/fsharp 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# **弃用通知**

这些镜像已被移除，建议使用由微软提供和维护的[官方.NET SDK镜像](https://hub.docker.com/_/microsoft-dotnet-sdk/)。

# 快速参考

- **维护者**：  
  [F#社区](https://github.com/fsprojects/docker-fsharp)

- **获取帮助**：  
  [Docker社区论坛](https://forums.docker.com/)、[Docker社区Slack](https://dockr.ly/slack)或[Stack Overflow](https://stackoverflow.com/search?tab=newest&q=docker)

# 支持的标签及对应`Dockerfile`链接

- [`latest`, `10`, `10.10`, `10.10.0`](https://github.com/fsprojects/docker-fsharp/blob/a47a73b4b99d85720e191680e29f1bd1d62724ea/10.10.0/mono/Dockerfile)
- [`4`, `4.1`, `4.1.34`](https://github.com/fsprojects/docker-fsharp/blob/a47a73b4b99d85720e191680e29f1bd1d62724ea/4.1.34/mono/Dockerfile)
- [`netcore`, `10-netcore`, `10.10-netcore`, `10.10.0-netcore`](https://github.com/fsprojects/docker-fsharp/blob/a47a73b4b99d85720e191680e29f1bd1d62724ea/10.10.0/netcore/Dockerfile)

# 快速参考（续）

- **问题提交地址**：  
  [https://github.com/fsprojects/docker-fsharp/issues](https://github.com/fsprojects/docker-fsharp/issues)

- **支持的架构**：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
  [`amd64`](https://hub.docker.com/r/amd64/fsharp/)、[`arm64v8`](https://hub.docker.com/r/arm64v8/fsharp/)

- **已发布镜像工件详情**：  
  [repo-info仓库的`repos/fsharp/`目录](https://github.com/docker-library/repo-info/blob/master/repos/fsharp)（[历史记录](https://github.com/docker-library/repo-info/commits/master/repos/fsharp)）  
  （镜像元数据、传输大小等）

- **镜像更新**：  
  [official-images仓库的`library/fsharp`标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Ffsharp)  
  [official-images仓库的`library/fsharp`文件](https://github.com/docker-library/official-images/blob/master/library/fsharp)（[历史记录](https://github.com/docker-library/official-images/commits/master/library/fsharp)）

- **本描述的来源**：  
  [docs仓库的`fsharp/`目录](https://github.com/docker-library/docs/tree/master/fsharp)（[历史记录](https://github.com/docker-library/docs/commits/master/fsharp)）

# 什么是F#？

F#（发音为F sharp）是一种强类型、多范式编程语言，涵盖函数式、命令式和面向对象编程技术。F#最常被用作跨平台CLI语言，也可用于生成JavaScript和GPU代码。

> [wikipedia.org/wiki/F Sharp (programming language)](https://en.wikipedia.org/wiki/F_Sharp_%28programming_language%29)

![logo](https://raw.githubusercontent.com/docker-library/docs/7d8c02340482b7f0c08c9fa7dc534d72314d3a22/fsharp/logo.png)

# 如何使用此镜像

## 在镜像中启动应用程序

使用此镜像最直接的方式是将其同时用作构建和运行环境。在`Dockerfile`中，可编写如下内容：

```dockerfile
FROM docker.xuanyuan.run/fsharp
COPY . /app
RUN xbuild /app/myproject.sln
```

这会将应用程序源代码复制到镜像中，并使用`xbuild`进行构建。

# 许可证

查看[Apache 2.0许可证](https://github.com/fsharp/fsharp/blob/d518f91418ef43a61875a5d932147b97fd0f47f3/LICENSE)以了解此镜像中包含的软件许可信息。

与所有Docker镜像一样，这些镜像可能还包含其他软件，这些软件可能采用其他许可证（例如基础发行版中的Bash等，以及所包含的主要软件的任何直接或间接依赖项）。

一些能够自动检测到的额外许可信息可在[`repo-info`仓库的`fsharp/`目录](https://github.com/docker-library/repo-info/tree/master/repos/fsharp)中找到。

对于任何预构建镜像的使用，镜像用户有责任确保对该镜像的任何使用均符合其中包含的所有软件的相关许可证。
