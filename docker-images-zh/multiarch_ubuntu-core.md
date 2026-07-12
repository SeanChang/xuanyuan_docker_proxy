---
image: multiarch/ubuntu-core
description: "支持多架构的Ubuntu Core移植版，适配不同架构环境。"
source: https://xuanyuan.cloud/zh/r/multiarch/ubuntu-core
canonical: https://xuanyuan.cloud/zh/r/multiarch/ubuntu-core
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/multiarch/ubuntu-core" title="multiarch/ubuntu-core Docker 镜像中文简介、标签列表与拉取命令">multiarch/ubuntu-core 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# multiarch/ubuntu-core 镜像文档


## 镜像概述

`multiarch/ubuntu-core` 是一个多架构支持的 Ubuntu 基础镜像，旨在为 Docker 环境提供跨架构的 Ubuntu 运行能力。该镜像基于 [tianon/docker-brew-ubuntu-core](https://github.com/tianon/docker-brew-ubuntu-core/) 项目构建，支持在不同架构的主机上运行多种 CPU 架构的 Ubuntu 环境。

- 镜像托管：[Docker Hub](https://hub.docker.com/r/multiarch/ubuntu-core/)
- 源代码：[GitHub 项目](https://github.com/multiarch/ubuntu-core)


## 核心功能与特性

### 多架构支持
支持多种 CPU 架构，包括但不限于：
- `amd64`（x86_64）
- `armhf`（32位 ARM）
- `arm64`（64位 ARM，AArch64）

### 轻量级基础
基于 Ubuntu Core 构建，保留 Ubuntu 系统核心组件，体积小巧，适合作为基础镜像使用。

### 跨架构运行能力
通过配合 `qemu-user-static` 工具，可在 x86_64 主机上无缝运行非 x86 架构的容器，无需修改主机系统配置（仅需一次性注册模拟器）。


## 使用场景

1. **跨架构开发与测试**  
   在 x86_64 开发机上直接运行 ARM 架构的 Ubuntu 环境，验证应用在不同架构下的兼容性。

2. **多平台应用构建**  
   作为基础镜像，用于构建支持多种 CPU 架构的应用容器。

3. **架构迁移验证**  
   模拟目标架构（如 ARM 服务器）环境，测试应用迁移后的运行状态。


## 使用方法

### 前置配置：注册 QEMU 模拟器
由于跨架构运行依赖 QEMU 模拟器，需在 Docker 主机上预先注册相关架构的模拟器。此步骤仅需执行一次。

```console
# 在 Docker 主机上注册 QEMU 模拟器（需特权模式）
docker run --rm --privileged docker.xuanyuan.run/multiarch/qemu-user-static:register --reset
```

**说明**：  
- `--privileged`：需要特权模式以修改主机的 `binfmt_misc` 配置，实现模拟器注册。  
- `--reset`：重置现有注册项，确保模拟器配置正确。  


### 运行示例

#### 1. 在 x86_64 主机上运行 armhf 架构容器
```console
# 启动 armhf 架构的 Ubuntu 容器（以 wily 版本为例）
docker run -it --rm docker.xuanyuan.run/multiarch/ubuntu-core:armhf-wily

# 容器内验证架构（示例输出）
root@a0818570f614:/# uname -a
Linux a0818570f614 4.1.13-boot2docker #1 SMP Fri Nov 20 19:05:50 UTC 2015 armv7l armv7l armv7l GNU/Linux
```

#### 2. 运行原生 amd64 架构容器
在 x86_64 主机上可直接运行，无需 QEMU 模拟：
```console
# 启动 amd64 架构的 Ubuntu 容器（以 wily 版本为例）
docker run -it --rm docker.xuanyuan.run/multiarch/ubuntu-core:amd64-wily

# 容器内验证架构（示例输出）
root@27fe384370c9:/# uname -a
Linux 27fe384370c9 4.1.13-boot2docker #1 SMP Fri Nov 20 19:05:50 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
```

#### 3. 运行 arm64 架构容器
```console
# 启动 arm64 架构的 Ubuntu 容器（以 wily 版本为例）
docker run -it --rm docker.xuanyuan.run/multiarch/ubuntu-core:arm64-wily

# 容器内验证架构（示例输出）
root@723fb9f184fa:/# uname -a
Linux 723fb9f184fa 4.1.13-boot2docker #1 SMP Fri Nov 20 19:05:50 UTC 2015 aarch64 aarch64 aarch64 GNU/Linux
```

**参数说明**：  
- `-it`：分配交互式终端，支持命令行交互。  
- `--rm`：容器退出后自动删除，避免残留。  


## 标签说明

镜像标签遵循 `{架构}-{Ubuntu版本}` 命名规则，例如：  
- `armhf-wily`：armhf 架构，Ubuntu Wily 版本  
- `amd64-wily`：amd64 架构，Ubuntu Wily 版本  
- `arm64-wily`：arm64 架构，Ubuntu Wily 版本  

**获取最新标签**：访问 [Docker Hub 标签页面](https://hub.docker.com/r/multiarch/ubuntu-core/tags/) 查看所有可用标签及版本信息。


## 许可证

本镜像的分发遵循 [MIT 许可证](https://opensource.org/licenses/MIT)。
