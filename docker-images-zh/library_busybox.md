---
image: library/busybox
description: "Busybox基础镜像是一种集成了多种常用UNIX工具的精简容器基础镜像，其体积小巧、资源占用低，能够为嵌入式系统、轻量级应用开发等场景提供高效的底层运行环境，是构建各类精简容器镜像的理想起点，兼具功能全面与轻量高效的特性，广泛应用于对资源有严格限制的开发和部署环境中。"
source: https://xuanyuan.cloud/zh/r/library/busybox
canonical: https://xuanyuan.cloud/zh/r/library/busybox
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/busybox" title="library/busybox Docker 镜像中文简介、标签列表与拉取命令">library/busybox — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/busybox" title="library/busybox Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/busybox</a>

# BusyBox 镜像介绍


## 快速参考

### 维护方  
[Docker 社区]([])  


### 获取帮助  
可通过以下途径获取帮助：  
- [Docker 社区 Slack]([])  
- [Server Fault]([])（Unix/Linux 相关问题）  
- [Unix & Linux Stack Exchange]([])  
- [Stack Overflow]([])  


## 支持的标签及对应 Dockerfile 链接  

以下是 BusyBox 镜像支持的标签及其对应的 Dockerfile 链接：  

- [`1.37.0-glibc`, `1.37-glibc`, `1-glibc`, `unstable-glibc`, `glibc`]([])  
- [`1.37.0-uclibc`, `1.37-uclibc`, `1-uclibc`, `unstable-uclibc`, `uclibc`]([])  
- [`1.37.0-musl`, `1.37-musl`, `1-musl`, `unstable-musl`, `musl`]([])  
- [`1.37.0`, `1.37`, `1`, `unstable`, `latest`]([])  
- [`1.36.1-glibc`, `1.36-glibc`, `stable-glibc`]([])  
- [`1.36.1-uclibc`, `1.36-uclibc`, `stable-uclibc`]([])  
- [`1.36.1-musl`, `1.36-musl`, `stable-musl`]([])  
- [`1.36.1`, `1.36`, `stable`]([])  


## 快速参考（续）  

### 提交问题的位置  
[[]]([])  


### 支持的架构  
（更多信息见 [官方镜像架构说明]([])）  
[`amd64`]([])、[`arm32v5`]([])、[`arm32v6`]([])、[`arm32v7`]([])、[`arm64v8`]([])、[`i386`]([])、[`ppc64le`]([])、[`riscv64`]([])、[`s390x`]([])  


### 已发布镜像的详细信息  
[repo-info 仓库的 `repos/busybox/` 目录]([])（包含镜像元数据、传输大小等）  


### 镜像更新  
- 关注 [official-images 仓库的 `library/busybox` 标签]([])  
- 查看 [official-images 仓库的 `library/busybox` 文件历史]([])  


### 本说明的来源  
[docs 仓库的 `busybox/` 目录]([])（含历史版本）  


## 什么是 BusyBox？  

BusyBox 被称为“嵌入式 Linux 的瑞士军刀”，磁盘大小通常在 1-5 Mb 之间（取决于变体），是构建空间高效发行版的理想组件。  

它将众多常见 UNIX 工具的精简版本整合到单个小型可执行文件中，提供了 GNU fileutils、shellutils 等工具的替代品。虽然 BusyBox 工具的选项通常比 GNU 完整版少，但包含的选项能满足基本功能需求，且行为与 GNU 工具高度一致，可为小型或嵌入式系统提供完整的运行环境。  

> 更多信息：[.org/wiki/BusyBox]()  

![logo]([])  


## 如何使用此镜像  

### 运行 BusyBox shell  

```console
$ docker run -it --rm busybox
```  

该命令会启动一个 `sh`  shell，方便在 BusyBox 环境中执行操作。  


### 为二进制文件创建 Dockerfile  

```dockerfile
FROM busybox
COPY ./my-static-binary /my-static-binary
CMD ["/my-static-binary"]
```  

此 Dockerfile 可用于为静态编译的二进制文件构建最小镜像。需注意，二进制文件需在其他环境（如另一个容器）中编译。若需更易扩展的轻量替代方案，可参考 [alpine 镜像]([])。  


## 镜像变体  

BusyBox 镜像基于不同的“libc”变体构建（关于 libc 变体对比，[Eta Labs 的图表]([]) 列出了主要异同点）。各变体的构建细节可查看对应 Dockerfile 目录下的 `Dockerfile.builder` 文件（见上文标签链接）。  


### `busybox:glibc`  
- 基于 [Debian 的 glibc]([])（已包含在镜像中）  


### `busybox:uclibc`  
- 基于 [Buildroot 的 uClibc]([])（静态编译）  


### `busybox:musl`  
- 基于 [Alpine 的 musl]([])（静态编译）  


## 许可协议  

镜像中软件的许可信息可查看 [BusyBox 许可页面]([])。  

与所有 Docker 镜像一样，本镜像可能包含其他软件（如基础发行版的 Bash 及依赖项），这些软件可能适用不同许可协议。  

自动检测到的额外许可信息可在 [repo-info 仓库的 `busybox/` 目录]([]) 中找到。  

使用预构建镜像时，用户需自行确保符合所有包含软件的许可要求。
