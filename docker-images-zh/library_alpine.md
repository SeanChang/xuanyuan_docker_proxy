---
image: library/alpine
description: "这是一款基于轻量级Alpine Linux构建的最小化Docker镜像，它不仅包含完整的软件包索引以确保用户能便捷获取所需依赖，而且体积仅为5MB，能极大节省存储空间与网络传输资源，非常适合对资源占用有严格要求的容器化应用场景，为快速部署和高效运行提供了轻量可靠的基础环境。"
source: https://xuanyuan.cloud/zh/r/library/alpine
canonical: https://xuanyuan.cloud/zh/r/library/alpine
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [library/alpine — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/library/alpine)

含镜像标签、拉取命令、部署文档与相关推荐。

[library/alpine Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/library/alpine)

# Alpine Linux Docker 镜像介绍


## 快速参考

### 维护者  
[Natanael Copa]([])（Alpine Linux 维护者）


### 获取帮助渠道  
- [Docker 社区 Slack]([])  
- [Server Fault]([])（服务器相关问题）  
- [Unix & Linux]([])（Unix/Linux 技术问题）  
- [Stack Overflow]([])（编程相关问题）  


## 支持的标签及对应 Dockerfile 链接  

- [`20250108`, `edge`]([])  
- [`3.22.2`, `3.22`, `3`, `latest`]([])  
- [`3.21.5`, `3.21`]([])  
- [`3.20.8`, `3.20`]([])  
- [`3.19.9`, `3.19`]([])  


## 快速参考（续）  

### 问题反馈地址  
[[]]([])  


### 支持的架构  
（[更多说明]([])）  
- [`amd64`]([])  
- [`arm32v6`]([])  
- [`arm32v7`]([])  
- [`arm64v8`]([])  
- [`i386`]([])  
- [`ppc64le`]([])  
- [`riscv64`]([])  
- [`s390x`]([])  


### 镜像 artifact 详情  
[repo-info 仓库的 `repos/alpine/` 目录]([])（[历史记录]([])）  
（包含镜像元数据、传输大小等信息）  


### 镜像更新  
- [official-images 仓库的 `library/alpine` 标签]([])  
- [official-images 仓库的 `library/alpine` 文件]([])（[历史记录]([])）  


### 描述来源  
[docs 仓库的 `alpine/` 目录]([])（[历史记录]([])）  


## Alpine Linux 简介  

[Alpine Linux]([]) 是一款围绕 [musl libc]([])（轻量级 C 标准库）和 [BusyBox]([])（集成工具集）构建的 Linux 发行版。该镜像仅 5 MB 大小，且可访问 [包仓库]([])——比其他基于 BusyBox 的镜像更完整。这使得 Alpine Linux 成为工具程序乃至生产应用的理想基础镜像。[点击了解更多关于 Alpine Linux 的信息]([])。  


## 如何使用此镜像  

### 使用示例  
像使用其他基础镜像一样直接使用：  

```dockerfile
FROM alpine:3.14
RUN apk add --no-cache mysql-client
ENTRYPOINT ["mysql"]
```  

**体积对比**：上述示例的虚拟镜像大小仅 36.8 MB。相比之下，基于 Ubuntu 的同类配置：  

```dockerfile
FROM ubuntu:20.04
RUN apt-get update \
    && apt-get install -y --no-install-recommends mysql-client \
    && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["mysql"]
```  

虚拟镜像大小约为 145 MB，Alpine 镜像体积优势明显。  


## 许可证信息  

镜像包含软件的许可证信息可查看 [这里]([])。  

与所有 Docker 镜像一样，其中可能包含其他软件（如基础发行版的 Bash 等），这些软件可能采用其他许可证。部分自动检测到的额外许可证信息可在 [repo-info 仓库的 `alpine/` 目录]([]) 中找到。  

对于任何预构建镜像的使用，用户需自行确保其使用行为符合镜像中所有软件的相关许可证要求。
