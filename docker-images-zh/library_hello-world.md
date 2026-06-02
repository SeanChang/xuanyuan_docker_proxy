---
image: library/hello-world
description: "“Hello World!”是一个经典的入门示例，具体而言是最小化Docker化的范例，它通过简单的应用展示了如何利用Docker将程序打包为容器，涵盖基础的镜像构建与容器运行流程，适合初学者快速理解Docker的核心概念及基本操作，直观体现了Docker化的简洁性与入门友好性。"
source: https://xuanyuan.cloud/zh/r/library/hello-world
canonical: https://xuanyuan.cloud/zh/r/library/hello-world
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/hello-world" title="library/hello-world Docker 镜像中文简介、标签列表与拉取命令">library/hello-world — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/hello-world" title="library/hello-world Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/hello-world</a>

# hello-world 镜像介绍


## 快速参考

### 维护者  
[Docker 社区]([])  


### 获取帮助的渠道  
[Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])  


## 支持的标签及对应 Dockerfile 链接  

（关于“Shared 标签”和“Simple 标签”的区别，可参考 [FAQ]([])）  


### Simple 标签  
- [`linux`]([])  
- [`nanoserver-ltsc2025`]([])  
- [`nanoserver-ltsc2022`]([])  


### Shared 标签  
- `latest`：  
  - [`linux`]([])  
  - [`nanoserver-ltsc2025`]([])  
  - [`nanoserver-ltsc2022`]([])  

- `nanoserver`：  
  - [`nanoserver-ltsc2025`]([])  
  - [`nanoserver-ltsc2022`]([])  


## 快速参考（续）  

- **提交 issue 地址**：  
  [[]]([])  

- **支持的架构**（[更多信息]([])）：  
  [`amd64`]([])、[`arm32v5`]([])、[`arm32v6`]([])、[`arm32v7`]([])、[`arm64v8`]([])、[`i386`]([])、[`mips64le`]([])、[`ppc64le`]([])、[`riscv64`]([])、[`s390x`]([])、[`windows-amd64`]([])  

- **镜像详情**（如元数据、传输大小等）：  
  [repo-info 仓库的 `repos/hello-world/` 目录]([])（[历史记录]([])）  

- **镜像更新**：  
  [official-images 仓库的 `library/hello-world` 标签]([])  
  [official-images 仓库的 `library/hello-world` 文件]([])（[历史记录]([])）  

- **本文档来源**：  
  [docs 仓库的 `hello-world/` 目录]([])（[历史记录]([])）  


## 运行示例  

```console
$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 [] more examples and ideas, visit:
 [] docker images hello-world
REPOSITORY    TAG       IMAGE ID       SIZE
hello-world   latest    1b44b5a3e06a   10.07kB
```

![logo]([])  


## 镜像创建方式  

该镜像是有效使用 [`scratch`]([]) 基础镜像的典型示例。镜像中包含的 `hello` 可执行文件源代码见：[`hello.c`]([])（GitHub 仓库链接）。  

由于镜像仅包含一个静态二进制文件（用于输出文本），因此可直接以任意用户身份运行，例如：  
`docker run --user $RANDOM:$RANDOM hello-world`  


## 许可证  

镜像中软件的许可证信息可查看 [LICENSE 文件]([])。  

与所有 Docker 镜像类似，本镜像可能包含其他软件（如基础系统的 Bash 等），这些软件可能适用不同许可证。部分自动检测到的许可证信息可参考 [repo-info 仓库的 `hello-world/` 目录]([])。  

使用前，用户需自行确保对镜像中所有软件的使用符合相关许可证要求。
