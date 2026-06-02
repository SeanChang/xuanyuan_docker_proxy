---
image: amd64/ubuntu
description: "Ubuntu是基于Debian的Linux操作系统，以自由软件为基础，适用于构建和运行各类应用的基础环境。"
source: https://xuanyuan.cloud/zh/r/amd64/ubuntu
canonical: https://xuanyuan.cloud/zh/r/amd64/ubuntu
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amd64/ubuntu" title="amd64/ubuntu Docker 镜像中文简介、标签列表与拉取命令">amd64/ubuntu — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/amd64/ubuntu" title="amd64/ubuntu Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/amd64/ubuntu</a>

# Ubuntu Docker 镜像文档

## 镜像概述与主要用途

### 关于 Ubuntu
Ubuntu 是一款基于 Debian 的 Linux 操作系统，广泛应用于桌面环境、云平台及各类联网设备。作为全球最受欢迎的公共云与 OpenStack 云平台操作系统，它也是容器技术的首选平台，支持从 Docker 到 Kubernetes 再到 LXD 的全栈容器解决方案，可实现容器的规模化运行。Ubuntu 以快速、安全、简洁为特点，为全球数百万台 PC 提供支持。其开发由 Canonical Ltd. 主导，Canonical 通过提供技术支持及相关服务获取收益，并坚定遵循开源软件开发原则，鼓励用户自由使用、学习、改进和分发软件。

### 镜像主要用途
本镜像为 `amd64` 架构的 Ubuntu 官方 Docker 镜像，基于 Canonical 提供的官方 rootfs 压缩包构建（详见 [cloud-images 仓库](https://git.launchpad.net/cloud-images/+oci/ubuntu-base) 的 `dist-*` 标签）。主要用作容器化应用的基础镜像，适用于开发环境搭建、生产环境部署及各类轻量级 Linux 容器场景。


## 核心功能与特性

1. **官方源构建**  
   基于 Canonical 发布的官方 rootfs 压缩包构建，确保系统安全性与可靠性。

2. **多版本支持**  
   包含长期支持版（LTS）与常规版，如 22.04（Jammy Jellyfish）、24.04（Noble Numbat）等 LTS 版本，以及 25.04（Plucky Penguin）、25.10（Questing Quokka）等非 LTS 版本。

3. **轻量级最小化安装**  
   默认仅包含 `C`、`C.UTF-8` 和 `POSIX`  locales，减少镜像体积，适合容器化部署。

4. **多架构兼容**  
   除 `amd64` 外，官方还提供 `arm32v7`、`arm64v8`、`ppc64le`、`riscv64`、`s390x` 等架构的镜像（详见 [官方镜像架构说明](https://github.com/docker-library/official-images#architectures-other-than-amd64)）。

5. **清晰的标签体系**  
   - `latest`：指向最新 LTS 版本（推荐用于生产环境）  
   - `rolling`：指向最新发布版本（含非 LTS）  
   - 版本号标签（如 `22.04`、`24.04`）：对应具体 Ubuntu 版本  


## 使用场景与适用范围

1. **开发环境基础镜像**  
   作为应用开发的底层环境，快速搭建一致的 Linux 开发环境。

2. **生产环境容器部署**  
   用于运行微服务、Web 应用等容器化服务，尤其适合云平台与容器编排系统（如 Kubernetes）。

3. **轻量级 Linux 环境需求**  
   适用于需要最小化系统资源占用的场景，如边缘计算、嵌入式设备等。

4. **CI/CD 流水线**  
   作为自动化构建、测试的基础环境，确保流程一致性。


## 使用方法与配置说明

### 支持的标签及说明

| 标签                          | 对应版本               | 说明                     | Dockerfile 链接                                                                 |
|-------------------------------|------------------------|--------------------------|--------------------------------------------------------------------------------|
| `22.04`, `jammy-20251001`, `jammy` | 22.04 LTS（Jammy）     | LTS 版本，长期支持       | [链接](https://git.launchpad.net/cloud-images/+oci/ubuntu-base/tree/oci/index.json?h=refs/tags/dist-jammy-amd64-20251001-1758709c&id=1758709c0ef8b678abab7ba1c66546f8c1e8229f) |
| `24.04`, `noble-20251001`, `noble`, `latest` | 24.04 LTS（Noble） | 最新 LTS 版本，`latest` 指向此版本 | [链接](https://git.launchpad.net/cloud-images/+oci/ubuntu-base/tree/oci/index.json?h=refs/tags/dist-noble-amd64-20251001-f5b85bb8&id=f5b85bb809ca07067994b7b0ec661a31718d6c75) |
| `25.04`, `plucky-20251001`, `plucky` | 25.04（Plucky）        | 非 LTS 版本              | [链接](https://git.launchpad.net/cloud-images/+oci/ubuntu-base/tree/oci/index.json?h=refs/tags/dist-plucky-amd64-20251001-547c400a&id=547c400a291828191316040f3e41e24b971efb8e) |
| `25.10`, `questing-20251007`, `questing`, `rolling` | 25.10（Questing） | 最新发布版，`rolling` 指向此版本 | [链接](https://git.launchpad.net/cloud-images/+oci/ubuntu-base/tree/oci/index.json?h=refs/tags/dist-questing-amd64-20251007-2012176a&id=2012176ad7653cd1c95d622cbcb2744f24237be3) |


### 拉取与运行镜像

#### 拉取镜像
```bash
# 拉取最新 LTS 版本
docker pull amd64/ubuntu:latest

# 拉取指定版本（如 22.04 LTS）
docker pull amd64/ubuntu:22.04

# 拉取滚动更新版本
docker pull amd64/ubuntu:rolling
```

#### 基本运行
```bash
# 交互式运行（进入 bash 终端）
docker run -it --rm amd64/ubuntu:latest bash
```


### 环境变量配置

#### Locale 设置
默认仅包含 `C`、`C.UTF-8` 和 `POSIX` locales。如需其他 locale（如 `en_US.UTF-8`），需通过 `locales` 包安装并生成：

```dockerfile
# 示例：在 Dockerfile 中配置 en_US.UTF-8
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
```

若仅需 UTF-8 支持，可直接设置环境变量：
```bash
docker run -it --rm -e LANG=C.UTF-8 amd64/ubuntu:latest bash
```


### 扩展系统组件（unminimize）
Ubuntu 24.10 及以上版本中，`unminimize` 命令默认不包含，需先安装对应包：
```bash
# 安装 unminimize 工具
apt-get update && apt-get install -y unminimize

# 扩展系统组件（安装标准 Ubuntu 组件，增大镜像体积）
unminimize
```


### Docker Compose 示例
```yaml
version: '3'
services:
  ubuntu-app:
    image: amd64/ubuntu:latest
    tty: true  # 保持终端连接
    environment:
      - LANG=C.UTF-8  # 设置默认 locale
    volumes:
      - ./app:/app  # 挂载本地目录到容器
    command: /app/start.sh  # 运行自定义启动脚本
```


## 高级信息

### rootfs 构建方式
镜像基于 Canonical 的 [livecd-rootfs 项目](https://code.launchpad.net/~ubuntu-core-dev/livecd-rootfs/+git/livecd-rootfs/+ref/ubuntu/master) 构建，具体构建流程由 `live-build/auto/build` 脚本定义，构建历史可在 Launchpad 查看：
- [Jammy（22.04）](https://launchpad.net/~cloud-images-release-managers/+livefs/ubuntu/jammy/ubuntu-oci)
- [Noble（24.04）](https://launchpad.net/~cloud-images-release-managers/+livefs/ubuntu/noble/ubuntu-oci)
- [Plucky（25.04）](https://launchpad.net/~cloud-images-release-managers/+livefs/ubuntu/plucky/ubuntu-oci)
- [Questing（25.10）](https://launchpad.net/~cloud-images-release-managers/+livefs/ubuntu/questing/ubuntu-oci)


### 镜像更新与维护
- **更新跟踪**：通过 [official-images 仓库的 library/ubuntu 标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fubuntu) 获取更新信息。
- **历史版本**：查看 [official-images 仓库的 library/ubuntu 文件历史](https://github.com/docker-library/official-images/commits/master/library/ubuntu)。


### 问题反馈与支持
- **提交 issue**：[cloud-images bug tracker](https://bugs.launchpad.net/cloud-images)（需添加 `docker` 标签）。
- **获取帮助**：Docker 社区 Slack（[dockr.ly/comm-slack](https://dockr.ly/comm-slack)）、Server Fault、Unix & Linux 或 Stack Overflow。


## 许可信息
镜像包含的软件许可信息详见 [Ubuntu 官方许可说明](https://www.ubuntu.com/about/about-ubuntu/licensing)。作为 Docker 镜像，可能包含基础系统组件（如 Bash）及依赖软件，其许可需由用户自行确保合规。更多自动检测的许可信息可参考 [repo-info 仓库的 ubuntu 目录](https://github.com/docker-library/repo-info/tree/master/repos/ubuntu)。


**维护者**：[Canonical](https://launchpad.net/cloud-images)  
**镜像元数据**：[repo-info 仓库](https://github.com/docker-library/repo-info/blob/master/repos/ubuntu)  
**文档源**：[docker-library/docs 仓库](https://github.com/docker-library/docs/tree/master/ubuntu)
