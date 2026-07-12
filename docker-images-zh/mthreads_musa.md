---
image: mthreads/musa
description: "mthreads/musa是MUSA SDK开发与运行时Docker镜像，用于在MTGPU上开发和部署异构计算任务（如AI推理、图形渲染等），类似NVIDIA CUDA镜像，便于容器环境快速集成MUSA工具链与库。"
source: https://xuanyuan.cloud/zh/r/mthreads/musa
canonical: https://xuanyuan.cloud/zh/r/mthreads/musa
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mthreads/musa" title="mthreads/musa Docker 镜像中文简介、标签列表与拉取命令">mthreads/musa 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MUSA SDK Docker镜像文档

## 📦 镜像概述

`mthreads/musa` 是MUSA SDK开发与运行时Docker镜像，用于支持在MTGPU（摩尔线程GPU）上开发和部署异构计算任务，如AI推理、图形渲染等。其设计思路类似于NVIDIA的CUDA镜像，预安装MUSA工具链，便于在容器环境中快速集成，简化MTGPU应用的开发与部署流程。

## 🏷️ 镜像标签说明

镜像标签遵循以下格式：

> `<musa-version>-<type>-ubuntu<version>-<arch>`

### ✅ 基础镜像

| 标签示例                  | 说明                                                                 |
|---------------------------|----------------------------------------------------------------------|
| `rc4.2.0-runtime-ubuntu22.04-amd64` | 运行时镜像，仅包含必要运行库（如libmusart）                         |
| `rc4.2.0-devel-ubuntu22.04-amd64`   | 开发镜像，包含编译器、工具链、头文件等                               |

基础镜像适合部署一般性MUSA应用与模型，不包含muDNN加速库。

### ⚡ 带muDNN的镜像

| 标签示例                  | 说明                                                                 |
|---------------------------|----------------------------------------------------------------------|
| `rc4.0.1-mudnn-runtime-ubuntu22.04` | 带有muDNN推理加速的运行时镜像                                       |
| `rc4.0.1-mudnn-devel-ubuntu22.04`   | 带有muDNN的开发镜像，适合训练与优化                                 |

此类镜像额外集成muDNN（Moore Threads Deep Neural Network库），可显著提升推理/训练性能。

## 🚀 核心功能与特性

- **双环境支持**：提供运行时（runtime）和开发（devel）两种镜像类型，分别满足应用部署与开发调试需求。
- **工具链预配置**：镜像内置完整MUSA工具链，无需手动安装编译器、头文件及核心库，开箱即用。
- **深度学习加速**：部分镜像集成muDNN库，针对深度学习任务提供专用优化，提升推理与训练效率。
- **系统兼容性**：基于Ubuntu系统构建，支持amd64架构，适配MTGPU硬件环境。

## 📋 使用场景

- **异构计算开发**：利用devel镜像在MTGPU上开发AI推理、图形渲染等异构计算应用，获取完整编译与调试工具支持。
- **应用部署**：通过runtime镜像部署已开发的MUSA应用，确保运行环境一致性，简化跨环境部署流程。
- **深度学习任务**：选择带muDNN的镜像，加速深度学习模型的训练与推理过程，提升计算性能。

## 💻 使用方法示例

### 拉取镜像

根据需求拉取对应标签的镜像：

```bash
# 拉取基础开发镜像
docker pull docker.xuanyuan.run/mthreads/musa:rc4.2.0-devel-ubuntu22.04-amd64

# 拉取带muDNN的运行时镜像
docker pull docker.xuanyuan.run/mthreads/musa:rc4.0.1-mudnn-runtime-ubuntu22.04
```

### 运行容器

#### 开发环境容器
启动开发容器并挂载本地代码目录（假设代码位于`./musa-project`）：

```bash
docker run -it --rm --gpus all \
  -v $(pwd)/musa-project:/workspace \
  docker.xuanyuan.run/mthreads/musa:rc4.2.0-devel-ubuntu22.04-amd64 /bin/bash
```

#### 运行时容器
部署应用时运行runtime容器：

```bash
docker run -it --rm --gpus all \
  -v $(pwd)/my-app:/app \
  docker.xuanyuan.run/mthreads/musa:rc4.0.1-mudnn-runtime-ubuntu22.04 \
  /app/run_musa_app.sh
```

### 验证环境

容器内执行以下命令验证MUSA环境是否正常：

```bash
# 查看MUSA设备信息（类似nvidia-smi）
musa-smi

# 编译并运行示例程序（开发镜像中）
cd /workspace
musa-g++ hello_musa.cpp -o hello_musa
./hello_musa
```

> 注意：运行容器时需确保Docker环境已安装MTGPU驱动，且支持`--gpus`参数（需Docker 19.03+版本）。
