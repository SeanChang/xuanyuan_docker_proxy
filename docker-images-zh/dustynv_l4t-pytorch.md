---
image: dustynv/l4t-pytorch
description: "适用于NVIDIA Jetson设备的PyTorch环境Docker镜像，集成PyTorch 2.2、TorchVision、TensorRT等组件，支持GPU加速和模型优化，适用于深度学习开发与部署。"
source: https://xuanyuan.cloud/zh/r/dustynv/l4t-pytorch
canonical: https://xuanyuan.cloud/zh/r/dustynv/l4t-pytorch
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dustynv/l4t-pytorch" title="dustynv/l4t-pytorch Docker 镜像中文简介、标签列表与拉取命令">dustynv/l4t-pytorch 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# l4t-pytorch

## 容器概述

l4t-pytorch是专为NVIDIA Jetson平台优化的Docker镜像，集成了PyTorch及其相关组件，适用于在Jetson设备上进行深度学习模型开发、训练和推理。该镜像基于L4T (Linux for Tegra)系统，提供了完整的PyTorch深度学习环境，支持GPU加速和TensorRT优化。

## 构建状态

| **l4t-pytorch** | |
| :-- | :-- |
| 构建状态 | [![l4t-pytorch_jp46](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/l4t-pytorch_jp46.yml?label=l4t-pytorch:jp46)](https://github.com/dusty-nv/jetson-containers/actions/workflows/l4t-pytorch_jp46.yml) [![l4t-pytorch_jp60](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/l4t-pytorch_jp60.yml?label=l4t-pytorch:jp60)](https://github.com/dusty-nv/jetson-containers/actions/workflows/l4t-pytorch_jp60.yml) [![l4t-pytorch_jp51](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/l4t-pytorch_jp51.yml?label=l4t-pytorch:jp51)](https://github.com/dusty-nv/jetson-containers/actions/workflows/l4t-pytorch_jp51.yml) |
| 系统要求 | `L4T ['>=32.6']` |
| 依赖项 | [`build-essential`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/build/build-essential) [`cuda`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/cuda/cuda) [`cudnn`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/cuda/cudnn) [`python`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/build/python) [`numpy`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/numpy) [`cmake`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/build/cmake/cmake_pip) [`onnx`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/onnx) [`pytorch:2.2`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/pytorch) [`torchvision`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/pytorch/torchvision) [`torchaudio`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/pytorch/torchaudio) [`tensorrt`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/tensorrt) [`torch2trt`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/pytorch/torch2trt) [`opencv`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/opencv) [`pycuda`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/cuda/pycuda) |

## 容器镜像

| 仓库/标签 | 日期 | 架构 | 大小 |
| :-- | :--: | :--: | :--: |
| [`dustynv/l4t-pytorch:r32.7.1`](https://hub.docker.com/r/dustynv/l4t-pytorch/tags) | `2023-12-14` | `arm64` | `1.2GB` |
| [`dustynv/l4t-pytorch:r35.2.1`](https://hub.docker.com/r/dustynv/l4t-pytorch/tags) | `2023-12-11` | `arm64` | `5.6GB` |
| [`dustynv/l4t-pytorch:r35.3.1`](https://hub.docker.com/r/dustynv/l4t-pytorch/tags) | `2023-12-14` | `arm64` | `5.6GB` |
| [`dustynv/l4t-pytorch:r35.4.1`](https://hub.docker.com/r/dustynv/l4t-pytorch/tags) | `2023-12-12` | `arm64` | `5.6GB` |
| [`dustynv/l4t-pytorch:r36.2.0`](https://hub.docker.com/r/dustynv/l4t-pytorch/tags) | `2023-12-14` | `arm64` | `7.3GB` |

容器镜像与JetPack/L4T的其他次要版本兼容：
• L4T R32.7容器可在L4T R32.7的其他版本上运行（JetPack 4.6+）
• L4T R35.x容器可在L4T R35.x的其他版本上运行（JetPack 5.1+）

## Docker部署方案

### 运行容器

要启动容器，可以使用`jetson-containers run`和`autotag`，或手动组合`docker run`命令：

```bash
# 自动拉取或构建兼容的容器镜像
jetson-containers run $(autotag l4t-pytorch)

# 或显式指定上述容器镜像之一
jetson-containers run dustynv/l4t-pytorch:r36.2.0

# 或使用'docker run'（指定镜像和挂载等）
sudo docker run --runtime nvidia -it --rm --network=host dustynv/l4t-pytorch:r36.2.0
```

`jetson-containers run`将参数转发给`docker run`，并添加一些默认值（如`--runtime nvidia`，挂载`/data`缓存，检测设备）。`autotag`会找到与您的JetPack/L4T版本兼容的容器镜像 - 无论是本地的、从注册表拉取的，还是通过构建的。

要将您自己的目录挂载到容器中，请使用`-v`或`--volume`标志：
```bash
jetson-containers run -v /主机路径:/容器路径 $(autotag l4t-pytorch)
```

要启动运行命令的容器（而非交互式shell）：
```bash
jetson-containers run $(autotag l4t-pytorch) my_app --abc xyz
```

您可以向其传递任何`docker run`支持的选项，它会在执行前打印出完整的命令。

### 构建容器

如果如上所示使用`autotag`，则在需要时会提示您构建容器。要手动构建，请先完成[系统设置](https://github.com/dusty-nv/jetson-containers/tree/master/docs/setup.md)，然后运行：
```bash
jetson-containers build l4t-pytorch
```

上述依赖项将被构建到容器中，并在构建过程中进行测试。使用`--help`查看构建选项。
