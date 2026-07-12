---
image: dustynv/jetson-inference
description: "jetson-inference是为NVIDIA Jetson平台设计的深度学习推理容器，集成CUDA、PyTorch、TensorRT、OpenCV等关键依赖，支持多种JetPack/L4T版本，便于快速部署和运行计算机视觉等推理任务。"
source: https://xuanyuan.cloud/zh/r/dustynv/jetson-inference
canonical: https://xuanyuan.cloud/zh/r/dustynv/jetson-inference
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dustynv/jetson-inference" title="dustynv/jetson-inference Docker 镜像中文简介、标签列表与拉取命令">dustynv/jetson-inference 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# jetson-inference

## 镜像概述和主要用途
jetson-inference是针对NVIDIA Jetson平台优化的深度学习推理容器，旨在简化深度学习模型在Jetson设备上的部署和运行。该容器集成了运行推理任务所需的核心依赖组件，包括CUDA、CuDNN、PyTorch、TensorRT、OpenCV等，支持多种JetPack/L4T版本，适用于图像分类、目标检测、语义分割等计算机视觉推理应用。

## 核心功能和特性

### 系统要求
- 需运行在L4T版本 >=32.6的Jetson设备上

### 核心依赖
- `build-essential`：基础构建工具
- `cuda`：NVIDIA CUDA工具包
- `cudnn`：CUDA深度神经网络库
- `python`：Python运行环境
- `numpy`：数值计算库
- `cmake`：跨平台构建工具
- `onnx`：开放神经网络交换格式支持
- `pytorch:2.2`：PyTorch深度学习框架
- `torchvision`：PyTorch计算机视觉库
- `tensorrt`：NVIDIA TensorRT推理优化器
- `opencv`：计算机视觉库
- `gstreamer`：多媒体处理框架

### 兼容性
- L4T R32.7容器可运行在其他L4T R32.7版本（JetPack 4.6+）
- L4T R35.x容器可运行在其他L4T R35.x版本（JetPack 5.1+）

## 容器镜像信息

| 仓库/标签 | 日期 | 架构 | 大小 |
| :-- | :--: | :--: | :--: |
| [`dustynv/jetson-inference:22.06`](https://hub.docker.com/r/dustynv/jetson-inference/tags) | `2022-09-30` | `amd64` | `6.5GB` |
| [`dustynv/jetson-inference:r32.4.3`](https://hub.docker.com/r/dustynv/jetson-inference/tags) | `2020-10-27` | `arm64` | `0.9GB` |
| [`dustynv/jetson-inference:r32.4.4`](https://hub.docker.com/r/dustynv/jetson-inference/tags) | `2021-11-16` | `arm64` | `0.9GB` |
| [`dustynv/jetson-inference:r32.5.0`](https://hub.docker.com/r/dustynv/jetson-inference/tags) | `2021-08-09` | `arm64` | `0.9GB` |
| [`dustynv/jetson-inference:r32.6.1`](https://hub.docker.com/r/dustynv/jetson-inference/tags) | `2021-08-24` | `arm64` | `0.9GB` |
| [`dustynv/jetson-inference:r32.7.1`](https://hub.docker.com/r/dustynv/jetson-inference/tags) | `2023-05-15` | `arm64` | `1.1GB` |
| [`dustynv/jetson-inference:r34.1.0`](https://hub.docker.com/r/dustynv/jetson-inference/tags) | `2022-04-08` | `arm64` | `5.9GB` |
| [`dustynv/jetson-inference:r34.1.1`](https://hub.docker.com/r/dustynv/jetson-inference/tags) | `2023-03-18` | `arm64` | `6.1GB` |
| [`dustynv/jetson-inference:r35.1.0`](https://hub.docker.com/r/dustynv/jetson-inference/tags) | `2023-05-15` | `arm64` | `6.1GB` |
| [`dustynv/jetson-inference:r35.2.1`](https://hub.docker.com/r/dustynv/jetson-inference/tags) | `2023-05-15` | `arm64` | `6.0GB` |
| [`dustynv/jetson-inference:r35.3.1`](https://hub.docker.com/r/dustynv/jetson-inference/tags) | `2023-05-15` | `arm64` | `5.6GB` |
| [`dustynv/jetson-inference:r35.4.1`](https://hub.docker.com/r/dustynv/jetson-inference/tags) | `2023-08-30` | `arm64` | `5.7GB` |
| [`dustynv/jetson-inference:r36.2.0`](https://hub.docker.com/r/dustynv/jetson-inference/tags) | `2023-12-19` | `arm64` | `7.9GB` |
| [`dustynv/jetson-inference:r36.3.0`](https://hub.docker.com/r/dustynv/jetson-inference/tags) | `2024-05-08` | `arm64` | `7.2GB` |

## 运行容器

要启动容器，可以使用[`jetson-containers run`](https://github.com/dusty-nv/jetson-containers/tree/master/docs/run.md)和[`autotag`](https://github.com/dusty-nv/jetson-containers/tree/master/docs/run.md#autotag)，或手动组合[`docker run`](https://docs.docker.com/engine/reference/commandline/run/)命令：

```bash
# 自动拉取或构建兼容的容器镜像
jetson-containers run $(autotag jetson-inference)

# 或显式指定上述容器镜像之一
jetson-containers run dustynv/jetson-inference:r36.3.0

# 或使用'docker run'（指定镜像及挂载等）
sudo docker run --runtime nvidia -it --rm --network=host dustynv/jetson-inference:r36.3.0
```

> <sup>[`jetson-containers run`](https://github.com/dusty-nv/jetson-containers/tree/master/docs/run.md)会将参数转发给[`docker run`](https://docs.docker.com/engine/reference/commandline/run/)，并添加一些默认设置（如`--runtime nvidia`、挂载`/data`缓存、检测设备等）</sup><br>
> <sup>[`autotag`](https://github.com/dusty-nv/jetson-containers/tree/master/docs/run.md#autotag)会找到与您的JetPack/L4T版本兼容的容器镜像——无论是本地镜像、从仓库拉取的镜像，还是需要构建的镜像。</sup>

要将主机目录挂载到容器中，使用[`-v`](https://docs.docker.com/engine/reference/commandline/run/#volume)或[`--volume`](https://docs.docker.com/engine/reference/commandline/run/#volume)标志：

```bash
jetson-containers run -v /主机路径:/容器路径 $(autotag jetson-inference)
```

要启动容器并运行命令（而非交互式shell）：

```bash
jetson-containers run $(autotag jetson-inference) my_app --abc xyz
```

您可以向其传递任何[`docker run`](https://docs.docker.com/engine/reference/commandline/run/)支持的选项，它会在执行前打印出构建的完整命令。

## 构建容器

如果如上所示使用[`autotag`](https://github.com/dusty-nv/jetson-containers/tree/master/docs/run.md#autotag)，必要时它会提示您构建容器。要手动构建，请先完成[系统设置](https://github.com/dusty-nv/jetson-containers/tree/master/docs/setup.md)，然后运行：

```bash
jetson-containers build jetson-inference
```

上述依赖项将被构建到容器中，并在构建过程中进行测试。运行时添加[`--help`](https://github.com/dusty-nv/jetson-containers/tree/master/jetson_containers/build.py)可查看构建选项。
