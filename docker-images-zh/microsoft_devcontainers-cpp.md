---
image: microsoft/devcontainers-cpp
description: "支持dev container规范的C++开发镜像，适用于在Linux环境中开发C++应用程序，包含Debian C++构建工具、常用开发依赖、Vcpkg包管理器及非root用户配置。"
source: https://xuanyuan.cloud/zh/r/microsoft/devcontainers-cpp
canonical: https://xuanyuan.cloud/zh/r/microsoft/devcontainers-cpp
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/microsoft/devcontainers-cpp" title="microsoft/devcontainers-cpp Docker 镜像中文简介、标签列表与拉取命令">microsoft/devcontainers-cpp 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# C++

## 概述

在Linux上开发C++应用程序。包含Debian C++构建工具。

| 元数据 | 值 |  
|----------|-------|
| *类别* | 核心、编程语言 |
| *镜像类型* | Dockerfile |
| *已发布镜像* | mcr.microsoft.com/devcontainers/cpp |
| *可用镜像变体* | debian-12、debian-11、debian-10、ubuntu-24.04、ubuntu-22.04、ubuntu-20.04（[完整列表](https://mcr.microsoft.com/v2/devcontainers/cpp/tags/list)） |
| *已发布镜像架构* | x86-64，以及适用于`debian-12`、`debian-11`、`ubuntu-24.04`和`ubuntu-22.04`变体的aarch64/arm64 |
| *容器主机OS支持* | Linux、macOS、Windows |
| *容器OS* | Debian、Ubuntu |
| *支持的语言和平台* | C++ |

有关已发布镜像内容的信息，请参见**[历史记录](https://github.com/devcontainers/images/tree/main/src/cpp/history)**。

## 核心功能和特性

- 包含Debian/Ubuntu系统下的C++构建工具链
- 集成Vcpkg（C++跨平台包管理器），已完成仓库克隆和工具引导
- 预装zsh、Oh My Zsh!，提供增强的终端体验
- 创建非root用户`vscode`，具备sudo权限，符合开发安全最佳实践
- 包含Git及常用开发依赖，开箱即可进行C++项目开发
- 支持多架构（x86-64、aarch64/arm64）和多Linux发行版变体

## 使用场景和适用范围

- C++应用程序的跨平台开发环境搭建
- 需要统一构建环境的团队协作场景
- 基于dev container规范的IDE集成（如VS Code Remote Development）
- 使用Vcpkg管理C++依赖的项目开发
- Linux环境下的C++编译、调试和测试工作流

## 使用方法和配置说明

### 直接引用预构建镜像

可通过在`.devcontainer/devcontainer.json`中设置`image`属性，或在自定义`Dockerfile`中更新`FROM`语句，直接引用预构建的`Dockerfile`版本。仓库中包含示例`Dockerfile`。

**可用镜像标签：**
- `mcr.microsoft.com/devcontainers/cpp`（最新Debian GA版本）
- `mcr.microsoft.com/devcontainers/cpp:debian`（最新Debian GA版本）
- `mcr.microsoft.com/devcontainers/cpp:debian-12`（或`bookworm`）
- `mcr.microsoft.com/devcontainers/cpp:debian-11`（或`bullseye`）
- `mcr.microsoft.com/devcontainers/cpp:debian-10`（或`buster`）
- `mcr.microsoft.com/devcontainers/cpp:ubuntu`（最新Ubuntu LTS版本）
- `mcr.microsoft.com/devcontainers/cpp:ubuntu-24.04`（或`noble`）
- `mcr.microsoft.com/devcontainers/cpp:ubuntu-22.04`（或`jammy`）
- `mcr.microsoft.com/devcontainers/cpp:ubuntu-20.04`（或`focal`）

更多详情请参考[此指南](https://containers.dev/guide/dockerfile)。

### 语义化版本控制

可通过引用镜像的[语义化版本](https://semver.org/)控制更新频率，例如：
- `mcr.microsoft.com/devcontainers/cpp:1-bookworm`
- `mcr.microsoft.com/devcontainers/cpp:1.0-bookworm`
- `mcr.microsoft.com/devcontainers/cpp:1.0.0-bookworm`

> **注意**：我们仅对最新的[非破坏性、支持中的](https://github.com/devcontainers/images/issues/90)镜像版本（如`0-debian-11`）进行安全补丁更新。如果锁定到更具体的版本，建议在Dockerfile中运行`apt-get update && apt-get upgrade`以获取OS安全更新。

有关每个版本内容的信息，请参见[历史记录](https://github.com/devcontainers/images/tree/main/src/cpp/history)，[完整标签列表](https://mcr.microsoft.com/v2/devcontainers/cpp/tags/list)。

### 自定义容器内容

如需完全自定义容器内容，或为镜像不支持的容器主机架构构建，可使用[.devcontainer](https://github.com/devcontainers/images/tree/main/src/cpp/.devcontainer)中的内容。

### 使用Vcpkg

此开发容器及其关联镜像包含`Vcpkg`仓库（用于库包）的克隆，以及`Vcpkg-tool`的引导实例。

#### CMake版本要求
Debian（<=11）和Ubuntu（<=21.10）的主软件仓库中提供的`cmake`版本低于安装包所需的最低版本。在此情况下，`Vcpkg`将为自身使用下载兼容版本的`cmake`（仅x86_64架构）。

#### 库包来源与配置
使用Vcpkg安装的大多数额外库包将从其[官方分发位置](https://github.com/microsoft/vcpkg#security)下载。如需配置容器中的Vcpkg以访问备用注册表，请参考：[Registries: Bring your own libraries to vcpkg](https://devblogs.microsoft.com/cppblog/registries-bring-your-own-libraries-to-vcpkg/)。

#### 更新Vcpkg库包
要更新可用的库包，可在终端中运行以下命令从git仓库拉取最新内容：

```sh
cd "${VCPKG_ROOT}"
git pull --ff-only
```

> **注意**：请查看[Vcpkg许可证详情](https://github.com/microsoft/vcpkg#license)，以了解其自身许可证以及与库包和支持端口相关的附加许可证信息。

## 支持与维护

dev container规范镜像由[devcontainers/images](https://github.com/devcontainers/images)仓库维护。可在该仓库中浏览各镜像并提交问题或功能请求。

## 许可证

版权所有 (c) Microsoft Corporation。保留所有权利。

根据MIT许可证授权。详见[LICENSE](https://github.com/devcontainers/images/blob/main/LICENSE)。
