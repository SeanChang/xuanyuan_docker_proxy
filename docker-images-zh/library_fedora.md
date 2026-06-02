---
image: library/fedora
description: "Fedora官方Docker镜像是由红帽公司主导开发的Linux发行版Fedora提供的官方容器化构建成果，旨在为开发者与系统管理员提供基于Fedora操作系统的标准化、轻量级Docker镜像资源，支持快速搭建、测试及部署容器化应用，有效保障开发与运行环境的一致性和可靠性，是Fedora生态系统中推动容器技术应用的重要基础组件。"
source: https://xuanyuan.cloud/zh/r/library/fedora
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[library/fedora](https://xuanyuan.cloud/zh/r/library/fedora)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Fedora Docker 镜像介绍


## 快速参考

### 维护方  
[Fedora 发布工程团队]([])  


### 获取帮助途径  
- [Docker 社区 Slack]([])  
- [Server Fault]([])  
- [Unix & Linux]([])  
- [Stack Overflow]([])  


## 支持的标签及对应 Dockerfile 链接  

- [`41`]([])  
- [`42`, `latest`]([])  
- [`43`]([])  
- [`44`, `rawhide`]([])  


## 快速参考（续）  

### 问题反馈地点  
- [Fedora Bugzilla 页面]([])  
- [GitHub 仓库]([])  


### 支持的架构（了解更多）  
- [`amd64`]([])  
- [`arm64v8`]([])  
- [`ppc64le`]([])  
- [`s390x`]([])  


### 发布的镜像制品详情  
- [repo-info 仓库的 `repos/fedora/` 目录]([])（[历史记录]([])）  
  （包含镜像元数据、传输大小等信息）  


### 镜像更新  
- [official-images 仓库的 `library/fedora` 标签]([])  
- [official-images 仓库的 `library/fedora` 文件]([])（[历史记录]([])）  


### 本文档来源  
- [docs 仓库的 `fedora/` 目录]([])（[历史记录]([])）  


## Fedora 镜像说明  

该镜像为 [Fedora 发行版]([]) 官方 Docker 镜像。  

![Fedora 标志]([])  

- `fedora:latest` 标签始终指向最新稳定版本。  
- 与标准 Fedora 安装相比，该镜像体积较小，由 [Fedora 构建系统]([]) 生成，基于 [此 kickstart 文件]([]) 构建。  
- [Fedora Rawhide]([])（开发版）可通过 `fedora:rawhide` 获取；特定版本的 Fedora 可通过 `fedora:$version` 获取（例如 `fedora:23`）。  


## 许可信息  

查看该镜像包含软件的 [许可信息]([])。  

与所有 Docker 镜像一样，该镜像可能包含其他软件（如基础发行版中的 Bash 等，以及主要软件的直接或间接依赖），这些软件可能采用其他许可协议。  

部分可自动检测的额外许可信息可在 [repo-info 仓库的 `fedora/` 目录]([]) 中找到。  

使用预构建镜像时，用户需自行确保其使用行为符合镜像中所有软件的相关许可要求。
