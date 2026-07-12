---
image: martynas/archlinux
description: "Archlinux Docker容器，包含构建Archlinux软件包的工具，用于Archlinux软件包的构建。"
source: https://xuanyuan.cloud/zh/r/martynas/archlinux
canonical: https://xuanyuan.cloud/zh/r/martynas/archlinux
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/martynas/archlinux" title="martynas/archlinux Docker 镜像中文简介、标签列表与拉取命令">martynas/archlinux 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# archlinux-docker 镜像文档


## 镜像概述与主要用途

本镜像基于官方 Arch Linux 基础镜像 (`archlinux/base`) 构建，扩展集成了一系列工具以简化 Arch Linux 包的构建流程。主要用途是提供一个便捷、隔离的容器环境，支持 Arch Linux 官方包及 AUR (Arch User Repository) 包的构建、测试与维护。


## 核心功能与特性

- **基础镜像自动更新**：当官方 `archlinux/base` 镜像更新时，自动在 Docker Hub 触发本镜像的重建流程，确保基础环境始终保持最新。

- **版本一致性保障**：每次镜像构建时，会自动将 `mirrorlist` 切换至与基础镜像构建日期对应的 [Arch Linux Archive](https://wiki.archlinux.org/index.php/Arch_Linux_Archive) 仓库，避免因滚动更新导致的包版本依赖冲突。

- **AUR 包构建支持**：集成 `yay` 工具，可一键构建、安装 AUR 包，简化第三方包的获取与管理流程。

- **基础维护工具集成**：包含 `grep`、`difftools` 等常用系统维护及文本处理工具，满足日常包构建过程中的日志分析、文件对比等需求。


## 使用场景与适用范围

### 适用场景
- **自动化构建环境**：作为 CI/CD 流程（如 GitHub Actions、GitLab CI）的组件，用于自动化构建 Arch Linux 包。
- **AUR 包开发测试**：为 AUR 包开发者提供隔离的构建环境，避免本地系统配置干扰包构建过程。
- **PKGBUILD 验证**：快速验证 PKGBUILD 文件的语法正确性及包构建流程完整性。

### 已知应用项目
- [2m/arch-pkgbuild-builder](https://github.com/2m/arch-pkgbuild-builder)：Arch Linux PKGBUILD 的 GitHub 构建器动作，基于本镜像实现自动化构建。


## 使用方法与配置说明

### 获取镜像
从 Docker Hub 拉取最新版本镜像：
```bash
docker pull docker.xuanyuan.run/martynas/archlinux
```

### 基本使用

#### 交互式运行容器
启动一个交互式终端，用于手动测试包构建流程：
```bash
docker run -it --rm docker.xuanyuan.run/martynas/archlinux
```
- `-it`：启用交互式终端
- `--rm`：容器退出后自动删除，避免残留

#### 构建 AUR 包示例
在容器内使用 `yay` 构建 AUR 包（以 `example-package` 为例）：
```bash
# 启动容器
docker run -it --rm docker.xuanyuan.run/martynas/archlinux

# 在容器内执行构建命令
yay -S --noconfirm example-package
```
- `--noconfirm`：自动确认所有提示，适用于非交互式场景

#### 挂载本地目录构建
挂载本地 PKGBUILD 文件所在目录至容器，实现本地文件直接构建：
```bash
# 假设本地 PKGBUILD 位于 /path/to/pkgbuild
docker run -it --rm -v /path/to/pkgbuild:/build docker.xuanyuan.run/martynas/archlinux

# 在容器内进入挂载目录并构建
cd /build
makepkg -s
```
- `-v /path/to/pkgbuild:/build`：将本地目录挂载至容器内 `/build` 路径
- `makepkg -s`：自动解决依赖并构建包


## 相关链接
- 项目源码：[2m/archlinux-docker](https://github.com/2m/archlinux-docker)
- Docker Hub 镜像：[martynas/archlinux](https://hub.docker.com/r/martynas/archlinux)
- Arch Linux Archive：[Arch Linux 文档](https://wiki.archlinux.org/index.php/Arch_Linux_Archive)
