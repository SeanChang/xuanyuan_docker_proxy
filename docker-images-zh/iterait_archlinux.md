---
image: iterait/archlinux
description: "定制的ArchLinux镜像，用于部署用途。"
source: https://xuanyuan.cloud/zh/r/iterait/archlinux
canonical: https://xuanyuan.cloud/zh/r/iterait/archlinux
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [iterait/archlinux — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/iterait/archlinux)

含镜像标签、拉取命令、部署文档与相关推荐。

[iterait/archlinux Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/iterait/archlinux)

# Iterait Docker镜像文档


## 镜像概述与主要用途

本仓库包含Iterait a.s.提供的开源Docker镜像，基于ArchLinux定制，支持CPU与GPU环境，适用于部署、开发及TensorFlow应用等场景。镜像设计兼顾灵活性与性能，可满足基础环境部署、开发工具链集成及深度学习任务（如GPU加速）等需求。


## 核心功能与特性

- **定制化ArchLinux环境**：基于ArchLinux构建，集成yay包管理器，支持灵活扩展。  
- **双环境支持**：提供CPU-only与GPU-enabled两种版本，GPU版本通过nvidia-docker实现CUDA加速。  
- **场景化镜像**：包含基础部署环境、开发环境（集成base-devel）及TensorFlow运行环境。  
- **灵活构建选项**：支持通过构建参数指定是否启用CUDA，适配不同硬件需求。  


## 使用场景与适用范围

| 场景类型                | 适用镜像                          | 说明                                  |
|-------------------------|-----------------------------------|---------------------------------------|
| 基础ArchLinux部署        | `iterait/archlinux:latest`        | 轻量定制化ArchLinux环境，用于通用部署。|
| 开发环境需求            | `iterait/archlinux-dev:latest`    | 集成base-devel工具链，适用于源码编译。|
| TensorFlow应用运行      | `iterait/tensorflow:latest`       | 预安装TensorFlow，适用于CPU环境推理。|
| GPU加速场景（如深度学习）| `iterait/*:cuda`系列              | 支持CUDA的镜像，适用于GPU训练/推理。  |


## 详细使用方法与配置说明

### 镜像列表

Iterait提供的镜像已发布至[DockerHub](https://hub.docker.com/r/iterait/)，包含以下版本：

| CPU-only镜像                  | GPU-enabled镜像                   | 描述                                 |
|-------------------------------|-----------------------------------|--------------------------------------|
| `iterait/archlinux:latest`    | `iterait/archlinux:cuda`          | 基础ArchLinux环境，集成yay包管理器。 |
| `iterait/archlinux-dev:latest`| `iterait/archlinux-dev:cuda`      | 基础镜像 + base-devel开发工具链。    |
| `iterait/tensorflow:latest`   | `iterait/tensorflow:cuda`         | 基础镜像 + TensorFlow运行环境。      |


### 构建指南

所有镜像支持通过标准Docker构建流程生成，可指定CPU或GPU版本。

#### 1. 构建CPU-only镜像
使用常规Docker构建命令，可选择添加`--squash`参数压缩镜像层：
```bash
docker build -t <镜像名称> -f <Dockerfile路径> --squash .
```

#### 2. 构建GPU-enabled（CUDA）镜像
如需启用CUDA支持，通过`--build-arg tag=cuda`指定构建参数：
```bash
docker build --build-arg tag=cuda -t <镜像名称>:cuda -f <Dockerfile路径> .
```


### 运行指南

#### 1. CPU环境运行
直接通过`docker run`启动容器，示例如下：
```bash
docker run -it <镜像名称> /bin/bash  # -it：交互式终端；/bin/bash：启动bash shell
```

#### 2. GPU环境运行
需使用`nvidia-docker`（或Docker的nvidia运行时）启用GPU支持，关键配置如下：
- **运行时指定**：`--runtime=nvidia`  
- **GPU设备控制**：通过环境变量`NVIDIA_VISIBLE_DEVICES`指定可用GPU（如`0,1`表示第1、2块GPU）  

示例（使用2块GPU并启动bash）：
```bash
docker run --runtime=nvidia \
  -e NVIDIA_VISIBLE_DEVICES=0,1 \  # 指定使用GPU 0和1
  -it <镜像名称>:cuda /bin/bash    # 使用带cuda标签的镜像
```


### 关键参数说明

| 参数/环境变量         | 作用                          | 示例值          |
|-----------------------|-------------------------------|-----------------|
| `--build-arg tag=cuda`| 构建时启用CUDA支持            | `tag=cuda`      |
| `--runtime=nvidia`    | 运行时使用nvidia-docker运行时 | -               |
| `NVIDIA_VISIBLE_DEVICES` | 指定可用GPU设备ID列表      | `0,1`（多GPU）、`all`（所有GPU） |
