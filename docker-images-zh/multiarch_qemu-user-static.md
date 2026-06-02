---
image: multiarch/qemu-user-static
description: "提供多架构的QEMU静态二进制文件，用于支持在不同架构系统上进行跨架构模拟和应用运行。"
source: https://xuanyuan.cloud/zh/r/multiarch/qemu-user-static
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[multiarch/qemu-user-static](https://xuanyuan.cloud/zh/r/multiarch/qemu-user-static)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# qemu-user-static Docker镜像文档


## 镜像概述和主要用途  
qemu-user-static 镜像是一个提供多架构支持的工具镜像，主要包含 `multiarch /usr/bin/qemu-*-static` 系列二进制文件。其核心用途是通过注册 `binfmt_misc` 机制，允许在当前架构的主机系统上运行其他处理器架构的 Docker 容器，实现跨架构容器的无缝执行。


## 核心功能和特性  
1. **多架构二进制支持**：提供多种处理器架构的 `qemu-*-static` 二进制文件，满足跨架构执行需求。  
2. **binfmt_misc 注册**：支持将 `qemu-*-static` 注册到系统的 `binfmt_misc` 中，自动处理不同架构的可执行文件。  
3. **配置重置能力**：可清除已注册的 `binfmt_misc` 配置，避免冲突并确保干净的注册环境。  


## 使用场景和适用范围  
- **多架构镜像构建**：作为跨架构 Docker 镜像构建系统的基础工具（如 Scaleway 的 `image-tools` 和 `image-builder`）。  
- **跨架构应用测试**：在单一主机上测试 ARM、amd64 等不同架构的应用（如 C 语言基准测试、Node.js 应用）。  
- **特定设备部署**：在嵌入式设备（如 Raspberry Pi）上运行非原生架构的应用（如 Haskell 程序）。  
- **多架构软件项目**：支持跨平台软件开发与构建（如音乐 notation 软件 MuseScore）。  


## 详细使用方法和配置说明  

### 前置要求  
- 主机需支持 `binfmt_misc` 内核特性。  
- 运行容器时需使用 `--privileged` 权限，以修改系统 `binfmt_misc` 配置。  


### 基本使用命令  

#### 1. 注册 qemu-*-static（排除当前架构）  
将 `qemu-*-static` 注册到 `binfmt_misc`，支持除当前主机架构外的所有处理器：  
```bash
docker run --rm --privileged multiarch/qemu-user-static:register
```

#### 2. 重置并注册（推荐首次使用）  
先移除所有已注册的 `binfmt_misc` 配置，再重新注册，避免冲突：  
```bash
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

#### 参数说明  
- `--reset`：可选参数，重置现有 `binfmt_misc` 配置，确保注册环境干净。  


## 兼容镜像  
以下镜像已验证与 qemu-user-static 兼容，支持多架构运行：  
- [multiarch/ubuntu-core](https://hub.docker.com/r/multiarch/ubuntu-core/)  
- [multiarch/debian-debootstrap](https://hub.docker.com/r/multiarch/debian-debootstrap/)  
- [multiarch/ubuntu-debootstrap](https://hub.docker.com/r/multiarch/ubuntu-debootstrap/)  
- [multiarch/busybox](https://hub.docker.com/r/multiarch/busybox/)  


## 相关多架构镜像组织  
提供多架构 Docker 镜像的组织（部分或全部镜像支持多架构）：  
- [multiarch](https://hub.docker.com/u/multiarch/)  
- [scaleway](https://hub.docker.com/u/scaleway/)  
- [meyskens](https://hub.docker.com/u/meyskens/)  


## 二进制文件获取  
- **发布版本**：[GitHub Releases](https://github.com/multiarch/qemu-user-static/releases/)  
- **Docker Hub**：[multiarch/qemu-user-static](https://hub.docker.com/r/multiarch/qemu-user-static/)  


## 许可证  
本镜像遵循 [MIT 许可证](https://opensource.org/licenses/MIT)。
