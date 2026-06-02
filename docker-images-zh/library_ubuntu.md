---
image: library/ubuntu
description: "Ubuntu是一款基于Debian的Linux操作系统，以自由软件为核心构建，由Canonical公司主导开发并提供支持。它注重用户友好性与开源精神，兼容多种硬件架构，广泛适用于个人电脑、服务器及嵌入式设备，提供长期支持版本（LTS）以保障系统稳定性，拥有全球活跃的开发者与用户社区，致力于为各类用户提供安全、高效且免费的开源计算体验。"
source: https://xuanyuan.cloud/zh/r/library/ubuntu
canonical: https://xuanyuan.cloud/zh/r/library/ubuntu
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/ubuntu" title="library/ubuntu Docker 镜像中文简介、标签列表与拉取命令">library/ubuntu 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Ubuntu Docker镜像介绍


## 基本参考信息

### 维护方  
[Canonical]([])


### 获取帮助渠道  
- Docker社区Slack：[dockr.ly/comm-slack]([])  
- Server Fault：[Unix & Linux相关问题]([])  
- Stack Overflow：[技术问题讨论]([])  


## 支持的标签及对应Dockerfile链接  

| 标签 | 说明 | Dockerfile链接 |  
|------|------|---------------|  
| `22.04`, `jammy-20251001`, `jammy` | Jammy版本 | [查看]([]) |  
| `24.04`, `noble-20251001`, `noble`, `latest` | Noble版本（`latest`指向最新LTS版） | [查看]([]) |  
| `25.04`, `plucky-20251001`, `plucky` | Plucky版本 | [查看]([]) |  
| `25.10`, `questing-20251007`, `questing`, `rolling` | Questing版本（`rolling`指向滚动更新版） | [查看]([]) |  


## 扩展参考信息

### 问题反馈渠道  
[cloud-images bug跟踪平台]([])（需添加`docker`标签）  


### 支持的架构  
（[更多说明]([])）  
- `amd64`：[amd64/ubuntu]([])  
- `arm32v7`：[arm32v7/ubuntu]([])  
- `arm64v8`：[arm64v8/ubuntu]([])  
- `ppc64le`：[ppc64le/ubuntu]([])  
- `riscv64`：[riscv64/ubuntu]([])  
- `s390x`：[s390x/ubuntu]([])  


### 镜像 artifact 详情  
[repo-info仓库的`repos/ubuntu/`目录]([])（[历史记录]([])）  
包含镜像元数据、传输大小等信息。  


### 镜像更新  
- [official-images仓库的`library/ubuntu`标签]([])  
- [official-images仓库的`library/ubuntu`文件]([])（[历史记录]([])）  


### 本文档来源  
[docs仓库的`ubuntu/`目录]([])（[历史记录]([])）  


## 关于Ubuntu  

Ubuntu是基于Debian的Linux操作系统，应用场景覆盖桌面、云端及各类联网设备。它是公共云与OpenStack云中最流行的操作系统，也是容器领域的首选平台（支持Docker、Kubernetes、LXD等），可实现容器规模化部署。Ubuntu以快速、安全、简洁为特点，全球数百万台PC均采用该系统。  

Ubuntu的开发由Canonical Ltd.主导，该公司通过提供技术支持及相关服务盈利。Ubuntu项目坚持开源软件开发原则，鼓励用户使用、学习、改进和分发自由软件。  

> 官网：[ubuntu.com]([])  

![Ubuntu logo]([])  


## 镜像内容说明  

### 构建来源  
本镜像基于Canonical提供的官方rootfs tarballs构建（可查看[]  


### 标签说明  
- `ubuntu:latest`：指向“最新LTS版本”（推荐日常使用）。  
- `ubuntu:rolling`：指向最新发布版本（不区分是否为LTS）。  
- `ubuntu:devel`：动态关联镜像源中“devel”套件指向的版本，可通过以下命令获取当前对应的版本代号：  
  ```bash
  wget -qO- [] | awk -F ': ' '$1 == "Codename" { print $2; exit }'
  ```  


### 本地化设置（Locales）  
作为最小化安装的Ubuntu镜像，默认仅包含`C`、`C.UTF-8`和`POSIX`三种locale。对于多数需要UTF-8编码的场景，`C.UTF-8`已足够使用，可通过`-e LANG=C.UTF-8`（运行时）或`ENV LANG C.UTF-8`（Dockerfile中）设置。  

如需其他locale，可通过`locales`包安装并生成。以下是参考PostgreSQL的配置示例：  
```dockerfile
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
```  


### `unminimize`命令变化  
从Ubuntu 24.10 "Oracular Oriole"开始，最小化镜像不再默认包含`unminimize`命令，需通过以下命令单独安装：  
```bash
apt-get install -y unminimize
```  


## 根文件系统（rootfs）构建方式  

Canonical发布的tarballs（对应[]]([])中的脚本构建，核心逻辑位于`live-build/auto/build`。构建过程在Launchpad上执行，各版本的构建历史可查看：  
- [Jammy]([])  
- [Noble]([])  
- [Plucky]([])  
- [Questing]([])  


## 许可协议  

镜像中软件的许可信息可查看[Ubuntu官方许可页面]([])。  

与所有Docker镜像类似，本镜像可能包含其他软件（如基础系统的Bash等），这些软件可能适用不同许可协议。  

部分自动检测到的许可信息可在[repo-info仓库的`ubuntu/`目录]([])中找到。  

**使用前须知**：使用本镜像时，用户需自行确保符合其中所有软件的许可协议要求。
