---
image: osrf/ros
description: "OSRF 提供的 ROS（机器人操作系统）Docker 镜像，支持 ROS 1 和 ROS 2，基于官方镜像构建并包含桌面安装元包，适用于开发环境和 GUI 应用程序。必须使用显式标签拉取，不支持 latest 标签。"
source: https://xuanyuan.cloud/zh/r/osrf/ros
canonical: https://xuanyuan.cloud/zh/r/osrf/ros
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/osrf/ros" title="osrf/ros Docker 镜像中文简介、标签列表与拉取命令">osrf/ros 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OSRF ROS Docker 镜像

OSRF ROS 镜像是由 Open Source Robotics Foundation (OSRF) 提供的 ROS（机器人操作系统）Docker 镜像，支持 ROS 1 和 ROS 2。这些镜像基于官方 Docker 库镜像构建，并包含额外的桌面安装元包，适用于开发和 GUI 应用程序。

## 镜像概述

OSRF ROS 镜像构建自官方 Docker 库的 ROS 镜像，通过添加桌面安装所需的元包扩展功能。这些镜像特别适合在容器中进行开发工作，或在使用 GUI 应用程序时进行显示转发。

## 核心特性

- **基于官方镜像**：从官方 Docker 库的 ROS 镜像构建，确保稳定性和兼容性
- **桌面环境支持**：包含桌面安装所需的元包，支持 GUI 应用程序运行
- **ROS 1 和 ROS 2**：同时支持 ROS 1 和 ROS 2 两个主要版本
- **开发友好**：预装开发工具和依赖，适合容器化开发环境
- **显示转发支持**：支持 X11 显示转发，可在容器中运行图形界面应用

## 使用方法

### 拉取镜像

**重要提示**：此镜像仓库不提供 `latest` 标签，必须使用显式标签来拉取镜像。

```bash
# 拉取指定标签的镜像
docker pull docker.xuanyuan.run/osrf/ros:<tag_name>
```

### 查看可用标签

所有可用标签列表请访问：https://hub.docker.com/r/osrf/ros/tags

标签通常包含以下信息：
- ROS 发行版名称（如 `noetic`、`humble`、`iron` 等）
- 基础操作系统（如 `ubuntu`、`debian`）
- 架构信息（如 `amd64`）

### 运行容器示例

```bash
# 运行 ROS 2 Humble 桌面版容器
docker run -it docker.xuanyuan.run/osrf/ros:humble-desktop

# 运行带显示转发的容器（Linux）
docker run -it \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  docker.xuanyuan.run/osrf/ros:humble-desktop

# 运行交互式容器并挂载工作空间
docker run -it \
  -v /path/to/workspace:/workspace \
  docker.xuanyuan.run/osrf/ros:humble-desktop \
  /bin/bash
```

## 镜像分类

### 与官方库镜像的区别

- **官方库镜像**（`ros:*`）：适用于生产环境和一般下游使用，推荐用于已发布的稳定版本
- **OSRF 镜像**（`osrf/ros:*`）：包含额外的桌面元包，更适合开发和 GUI 应用场景

### 支持的架构

- **amd64**：x86_64 架构（主要支持）

## 使用场景

### 开发环境

适合在容器中构建和测试 ROS 应用程序，提供完整的开发工具链和依赖。

### GUI 应用程序

支持运行需要图形界面的 ROS 工具和应用程序，如 RViz、Gazebo 等可视化工具。

### 持续集成

可用于 CI/CD 流程中，提供一致的构建和测试环境。

## 注意事项

1. **必须使用显式标签**：此镜像仓库不提供 `latest` 标签，拉取时必须指定具体标签
2. **标签格式**：标签通常遵循 `<ros-distro>-<variant>` 格式，如 `humble-desktop`、`noetic-desktop-full`
3. **显示转发**：在 Linux 系统上使用 GUI 应用时，需要配置 X11 显示转发
4. **资源需求**：桌面版镜像包含更多依赖，镜像体积相对较大

## 相关镜像

- **osrf/ros2**：专门用于 ROS 2 开发的镜像，包含测试和开发版本
- **osrf/gazebo**：Gazebo 仿真器的 OSRF 镜像
- **osrf/ros_legacy**：ROS 1 的旧版本镜像
- **官方库 ros**：生产环境推荐使用的官方 ROS 镜像

## 文档与资源

- **Docker Hub 仓库**：https://hub.docker.com/r/osrf/ros
- **标签列表**：https://hub.docker.com/r/osrf/ros/tags
- **GitHub 仓库**：https://github.com/osrf/docker_images
- **ROS 官方文档**：https://www.ros.org/

## 构建状态

镜像构建状态和 CI 信息可通过 GitHub 仓库查看。

## 许可证

遵循 ROS 和相应基础镜像的许可证协议。
