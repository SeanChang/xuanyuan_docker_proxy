---
image: arm64v8/ubuntu
description: "Ubuntu是一种基于Debian的Linux操作系统，以自由软件为核心构建，具备开源、用户友好、社区驱动等显著特点，广泛应用于个人电脑、服务器及嵌入式设备等场景，致力于为全球用户提供稳定、安全且易于上手的计算环境，其设计理念强调软件的自由获取、使用与分享，支持开发者与用户共同参与系统改进，是开源生态中极具影响力的操作系统之一。"
source: https://xuanyuan.cloud/zh/r/arm64v8/ubuntu
canonical: https://xuanyuan.cloud/zh/r/arm64v8/ubuntu
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm64v8/ubuntu" title="arm64v8/ubuntu Docker 镜像中文简介、标签列表与拉取命令">arm64v8/ubuntu 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# arm64v8/ubuntu 镜像介绍


## 说明
本仓库是 [Ubuntu 官方镜像]  的 `arm64v8` 架构专用仓库。更多信息可参考官方镜像文档中的 [“非 amd64 架构说明”]  和 FAQ 中的 [“镜像源码变更后如何处理？”] 。


## 快速参考

### 维护方  
[Canonical] 


### 获取帮助  
可通过以下渠道获取支持：  
[Docker 社区 Slack] 、[Server Fault] 、[Unix & Linux]  或 [Stack Overflow] 


## 支持的标签及对应 Dockerfile 链接  
- [`22.04`, `jammy-20251001`, `jammy`]   
- [`24.04`, `noble-20251001`, `noble`, `latest`]   
- [`25.04`, `plucky-20251001`, `plucky`]   
- [`25.10`, `questing-20251007`, `questing`, `rolling`]   


## 补充参考信息  

### 问题反馈渠道  
[cloud-images  bug 跟踪器] （需添加 `docker` 标签）  


### 支持的架构  
（[更多说明] ）  
[`amd64`] 、[`arm32v7`] 、[`arm64v8`] 、[`ppc64le`] 、[`riscv64`] 、[`s390x`]   


### 镜像 artifact 详情  
[repo-info 仓库的 `repos/ubuntu/` 目录] （[历史记录] ）  
（包含镜像元数据、传输大小等信息）  


### 镜像更新  
- official-images 仓库的 `library/ubuntu` 标签：[issues]   
- official-images 仓库的 `library/ubuntu` 文件：[文件内容] （[历史记录] ）  


### 本文档来源  
[docs 仓库的 `ubuntu/` 目录] （[历史记录] ）  


## 什么是 Ubuntu？  
Ubuntu 是基于 Debian 的 Linux 操作系统，可运行于桌面、云端及各类联网设备。它是公共云与 OpenStack 云中最受欢迎的操作系统，也是容器领域的首选平台——从 Docker 到 Kubernetes 再到 LXD，Ubuntu 均可支持容器规模化部署。其特点是快速、安全、简洁，全球数百万台 PC 均采用 Ubuntu 系统。  

Ubuntu 的开发由 Canonical Ltd. 主导。Canonical 通过提供技术支持及其他 Ubuntu 相关服务获取收益。Ubuntu 项目秉持开源软件开发原则，鼓励用户使用自由软件、研究其原理、改进并分发。  

> 更多信息：[ubuntu.com]   

![Ubuntu 标志]   


## 镜像内容说明  
本镜像基于 Canonical 提供的官方 rootfs 压缩包构建（可在 [] 查看 `dist-*` 标签）。  


### 标签说明  
- `arm64v8/ubuntu:latest`：指向“最新 LTS 版本”（推荐日常使用）  
- `arm64v8/ubuntu:rolling`：指向最新发布版本（无论是否为 LTS）  
- `arm64v8/ubuntu:devel`：对应镜像源中 `devel` 套件的当前版本，可通过以下命令获取具体版本：  
  ```bash
  wget -qO- [] | awk -F ': ' '$1 == "Codename" { print $2; exit }'
  ```  


###  locales 支持  
由于是 Ubuntu 最小化安装镜像，默认仅包含 `C`、`C.UTF-8` 和 `POSIX` 三种 locales。多数需 UTF-8 编码的场景下，`C.UTF-8` 已足够使用（可通过 `-e LANG=C.UTF-8` 或 `ENV LANG C.UTF-8` 设置）。  

如需其他 locales，可通过 `locales` 包安装生成。以下是 PostgreSQL 镜像中的实现示例：  
```dockerfile
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
```  


### unminimize 命令  
从 [Ubuntu 24.10 "Oracular Oriole"]  开始，最小化镜像不再默认包含 `unminimize` 命令。如需使用，需单独安装：  
```bash
apt-get install -y unminimize
```  


## rootfs 构建方式  
本镜像的 rootfs 压缩包（即前文提到的 `dist-*` 标签）由 [livecd-rootfs 项目]  中的脚本构建（特别是 `live-build/auto/build`），构建过程在 Launchpad 上执行。各版本的构建历史可查看：  
- [Jammy]   
- [Noble]   
- [Plucky]   
- [Questing]   


## 许可信息  
镜像中软件的许可信息可查看 [Ubuntu 许可页面] 。  

与所有 Docker 镜像类似，本镜像可能包含其他软件，其许可可能不同（如基础系统中的 Bash 等依赖）。  

自动检测到的补充许可信息可在 [repo-info 仓库的 `ubuntu/` 目录]  中查看。  

使用预构建镜像时，用户需自行确保符合其中所有软件的许可要求。
