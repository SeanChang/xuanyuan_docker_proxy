---
image: dustynv/ros
description: "为NVIDIA Jetson平台提供预配置的ROS环境，支持机器人应用的快速开发、部署与运行，适配Jetson硬件加速能力。"
source: https://xuanyuan.cloud/zh/r/dustynv/ros
canonical: https://xuanyuan.cloud/zh/r/dustynv/ros
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dustynv/ros" title="dustynv/ros Docker 镜像中文简介、标签列表与拉取命令">dustynv/ros 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ROS Docker镜像文档


## 镜像概述

本文档描述的ROS Docker镜像是为NVIDIA Jetson平台（基于JetPack）构建的ROS/ROS2基础容器。这些镜像从源代码构建ROS，以确保在Jetson设备所需的Ubuntu版本上兼容运行，提供了针对嵌入式环境优化的机器人操作系统基础。


## 核心功能与特性

### 支持的ROS发行版
- **ROS1**：`melodic`、`noetic`  
- **ROS2**：`foxy`、`galactic`、`humble`、`iron`  

### 支持的ROS包类型
- `ros_core`：最小核心组件集，包含ROS运行基础功能  
- `ros_base`：扩展核心组件，包含更多基础工具和库  
- `desktop`：完整桌面版，包含RViz、rqt等可视化工具  

### 预装依赖与优化
- 基础构建工具：`build-essential`、`cmake`（APT/PyPI版）  
- NVIDIA加速库：`cuda`、`cudnn`、`tensorrt`（适配JetPack版本）  
- 科学计算库：`python`、`numpy`、`opencv`  


## 适用范围

- **硬件平台**：NVIDIA Jetson系列设备（Nano、TX2、Xavier、Orin）  
- **软件环境**：需匹配JetPack对应的L4T版本（见各镜像要求）  
- **应用场景**：机器人系统开发、嵌入式ROS应用部署、依赖CUDA加速的感知算法验证  


## 镜像详情

### 通用说明
所有镜像均托管于[GitHub Jetson Containers](https://github.com/dusty-nv/jetson-containers/packages/ros)，镜像标签格式为`dustynv/ros:<distro>-<package>-l4t-<l4t-version>`，其中`<l4t-version>`需与设备JetPack版本匹配。


### ROS1镜像

#### melodic（仅支持JetPack 4，L4T <34）

| 镜像变体 | 构建状态 | 依赖项 | Dockerfile | 可用镜像标签 |
|----------|----------|--------|------------|--------------|
| `melodic-ros-base` | [![ros-melodic-ros-base:jp46](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-melodic-ros-base_jp46.yml?label=ros-melodic-ros-base:jp46)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-melodic-ros-base_jp46.yml) | `build-essential`、`cmake:apt`、`cuda`、`cudnn`、`python`、`tensorrt` | [Dockerfile.ros.melodic](https://github.com/dusty-nv/jetson-containers/tree/master/packages/ros/Dockerfile.ros.melodic) | `dustynv/ros:melodic-ros-base-l4t-r32.4.4`<br>`dustynv/ros:melodic-ros-base-l4t-r32.5.0`<br>`dustynv/ros:melodic-ros-base-l4t-r32.6.1`<br>`dustynv/ros:melodic-ros-base-l4t-r32.7.1` |
| `melodic-ros-core` | [![ros-melodic-ros-core:jp46](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-melodic-ros-core_jp46.yml?label=ros-melodic-ros-core:jp46)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-melodic-ros-core_jp46.yml) | 同上 | 同上 | `dustynv/ros:melodic-ros-core-l4t-r32.7.1` |
| `melodic-desktop` | [![ros-melodic-desktop:jp46](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-melodic-desktop_jp46.yml?label=ros-melodic-desktop:jp46)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-melodic-desktop_jp46.yml) | 同上 | 同上 | `dustynv/ros:melodic-desktop-l4t-r32.7.1` |


#### noetic（支持L4T >=32.6）

| 镜像变体 | 构建状态 | 依赖项 | Dockerfile | 可用镜像标签 |
|----------|----------|--------|------------|--------------|
| `noetic-ros-base` | [![ros-noetic-ros-base:jp46](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-noetic-ros-base_jp46.yml?label=ros-noetic-ros-base:jp46)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-noetic-ros-base_jp46.yml)、[![ros-noetic-ros-base:jp51](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-noetic-ros-base_jp51.yml?label=ros-noetic-ros-base:jp51)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-noetic-ros-base_jp51.yml) | `build-essential`、`cuda`、`cudnn`、`python`、`tensorrt`、`numpy`、`opencv`、`cmake` | [Dockerfile.ros.noetic](https://github.com/dusty-nv/jetson-containers/tree/master/packages/ros/Dockerfile.ros.noetic) | `dustynv/ros:noetic-ros-base-l4t-r32.4.4`<br>`dustynv/ros:noetic-ros-base-l4t-r32.5.0`<br>`dustynv/ros:noetic-ros-base-l4t-r32.6.1`<br>`dustynv/ros:noetic-ros-base-l4t-r32.7.1`<br>`dustynv/ros:noetic-ros-base-l4t-r34.1.0`<br>`dustynv/ros:noetic-ros-base-l4t-r34.1.1`<br>`dustynv/ros:noetic-ros-base-l4t-r35.1.0`<br>`dustynv/ros:noetic-ros-base-l4t-r35.2.1`<br>`dustynv/ros:noetic-ros-base-l4t-r35.3.1`<br>`dustynv/ros:noetic-ros-base-l4t-r35.4.1` |
| `noetic-ros-core` | [![ros-noetic-ros-core:jp46](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-noetic-ros-core_jp46.yml?label=ros-noetic-ros-core:jp46)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-noetic-ros-core_jp46.yml)、[![ros-noetic-ros-core:jp51](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-noetic-ros-core_jp51.yml?label=ros-noetic-ros-core:jp51)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-noetic-ros-core_jp51.yml) | 同上 | 同上 | `dustynv/ros:noetic-ros-core-l4t-r32.7.1`<br>`dustynv/ros:noetic-ros-core-l4t-r35.2.1`<br>`dustynv/ros:noetic-ros-core-l4t-r35.3.1`<br>`dustynv/ros:noetic-ros-core-l4t-r35.4.1` |
| `noetic-desktop` | [![ros-noetic-desktop:jp46](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-noetic-desktop_jp46.yml?label=ros-noetic-desktop:jp46)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-noetic-desktop_jp46.yml)、[![ros-noetic-desktop:jp51](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-noetic-desktop_jp51.yml?label=ros-noetic-desktop:jp51)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-noetic-desktop_jp51.yml) | 同上 | 同上 | `dustynv/ros:noetic-desktop-l4t-r32.7.1`<br>`dustynv/ros:noetic-desktop-l4t-r35.2.1`<br>`dustynv/ros:noetic-desktop-l4t-r35.3.1`<br>`dustynv/ros:noetic-desktop-l4t-r35.4.1` |


### ROS2镜像

#### foxy（支持L4T >=32.6）

| 镜像变体 | 构建状态 | 依赖项 | Dockerfile | 可用镜像标签 |
|----------|----------|--------|------------|--------------|
| `foxy-ros-base` | [![ros-foxy-ros-base:jp46](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-foxy-ros-base_jp46.yml?label=ros-foxy-ros-base:jp46)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-foxy-ros-base_jp46.yml)、[![ros-foxy-ros-base:jp51](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-foxy-ros-base_jp51.yml?label=ros-foxy-ros-base:jp51)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-foxy-ros-base_jp51.yml) | `build-essential`、`cuda`、`cudnn`、`python`、`tensorrt`、`numpy`、`opencv`、`cmake` | [Dockerfile.ros2](https://github.com/dusty-nv/jetson-containers/tree/master/packages/ros/Dockerfile.ros2) | `dustynv/ros:foxy-ros-base-l4t-r32.4.4`<br>`dustynv/ros:foxy-ros-base-l4t-r32.5.0`<br>`dustynv/ros:foxy-ros-base-l4t-r32.6.1`<br>`dustynv/ros:foxy-ros-base-l4t-r32.7.1`<br>`dustynv/ros:foxy-ros-base-l4t-r34.1.0`<br>`dustynv/ros:foxy-ros-base-l4t-r34.1.1`<br>`dustynv/ros:foxy-ros-base-l4t-r35.1.0`<br>`dustynv/ros:foxy-ros-base-l4t-r35.2.1`<br>`dustynv/ros:foxy-ros-base-l4t-r35.3.1`<br>`dustynv/ros:foxy-ros-base-l4t-r35.4.1` |
| `foxy-ros-core` | [![ros-foxy-ros-core:jp46](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-foxy-ros-core_jp46.yml?label=ros-foxy-ros-core:jp46)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-foxy-ros-core_jp46.yml)、[![ros-foxy-ros-core:jp51](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-foxy-ros-core_jp51.yml?label=ros-foxy-ros-core:jp51)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-foxy-ros-core_jp51.yml) | 同上 | 同上 | `dustynv/ros:foxy-ros-core-l4t-r32.7.1`<br>`dustynv/ros:foxy-ros-core-l4t-r35.2.1`<br>`dustynv/ros:foxy-ros-core-l4t-r35.3.1`<br>`dustynv/ros:foxy-ros-core-l4t-r35.4.1` |
| `foxy-desktop` | [![ros-foxy-desktop:jp46](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-foxy-desktop_jp46.yml?label=ros-foxy-desktop:jp46)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-foxy-desktop_jp46.yml)、[![ros-foxy-desktop:jp51](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-foxy-desktop_jp51.yml?label=ros-foxy-desktop:jp51)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-foxy-desktop_jp51.yml) | 同上 | 同上 | `dustynv/ros:foxy-desktop-l4t-r32.7.1`<br>`dustynv/ros:foxy-desktop-l4t-r34.1.1`<br>`dustynv/ros:foxy-desktop-l4t-r35.1.0`<br>`dustynv/ros:foxy-desktop-l4t-r35.2.1`<br>`dustynv/ros:foxy-desktop-l4t-r35.3.1`<br>`dustynv/ros:foxy-desktop-l4t-r35.4.1` |


#### galactic（支持L4T >=32.6）

| 镜像变体 | 构建状态 | 依赖项 | Dockerfile | 可用镜像标签 |
|----------|----------|--------|------------|--------------|
| `galactic-ros-base` | [![ros-galactic-ros-base:jp46](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-galactic-ros-base_jp46.yml?label=ros-galactic-ros-base:jp46)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-galactic-ros-base_jp46.yml)、[![ros-galactic-ros-base:jp51](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-galactic-ros-base_jp51.yml?label=ros-galactic-ros-base:jp51)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-galactic-ros-base_jp51.yml) | `build-essential`、`cuda`、`cudnn`、`python`、`tensorrt`、`numpy`、`opencv`、`cmake` | [Dockerfile.ros2](https://github.com/dusty-nv/jetson-containers/tree/master/packages/ros/Dockerfile.ros2) | `dustynv/ros:galactic-ros-base-l4t-r32.4.4`<br>`dustynv/ros:galactic-ros-base-l4t-r32.5.0`<br>`dustynv/ros:galactic-ros-base-l4t-r32.6.1`<br>`dustynv/ros:galactic-ros-base-l4t-r32.7.1`<br>`dustynv/ros:galactic-ros-base-l4t-r34.1.0`<br>`dustynv/ros:galactic-ros-base-l4t-r34.1.1`<br>`dustynv/ros:galactic-ros-base-l4t-r35.1.0`<br>`dustynv/ros:galactic-ros-base-l4t-r35.2.1`<br>`dustynv/ros:galactic-ros-base-l4t-r35.3.1`<br>`dustynv/ros:galactic-ros-base-l4t-r35.4.1` |
| `galactic-ros-core` | [![ros-galactic-ros-core:jp46](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-galactic-ros-core_jp46.yml?label=ros-galactic-ros-core:jp46)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-galactic-ros-core_jp46.yml)、[![ros-galactic-ros-core:jp51](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/ros-galactic-ros-core_jp51.yml?label=ros-galactic-ros-core:jp51)](https://github.com/dusty-nv/jetson-containers/actions/workflows/ros-galactic-ros-core_jp51.yml) | 同上 | 同上 | `dustynv/ros:galactic-ros-core-l4t-r32.7.1`<br>`dustynv/ros:galactic-ros-core-l4t-r35.2.1`<br>`dustynv/ros:galactic-ros-core-l4t-r35.3.1`<br>`dustynv/ros:galactic-ros-core-l4t-r35.4.
