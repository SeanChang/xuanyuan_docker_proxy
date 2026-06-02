---
image: rocker/cuda
description: "集成NVIDIA CUDA库的Rocker镜像，提供R语言环境下的GPU加速计算支持，基于rocker-org/rocker-versioned2项目构建。"
source: https://xuanyuan.cloud/zh/r/rocker/cuda
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[rocker/cuda](https://xuanyuan.cloud/zh/r/rocker/cuda)
> 含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述
本镜像基于 [rocker-org/rocker-versioned2](https://github.com/rocker-org/rocker-versioned2) 项目构建，详细描述参见 [Rocker官方文档](https://rocker-project.org/images/versioned/cuda)。

## 主要特性
- 集成NVIDIA CUDA库，支持GPU加速计算
- 基于Rocker基础镜像，提供完整的R语言运行环境
- 包含CUDA开发工具链及相关依赖组件，确保与R生态工具兼容性

## 使用场景
适用于需要在R语言环境中进行大规模数据处理、机器学习模型训练（如使用`gpuR`、`tensorflow`等GPU加速库）的场景，广泛应用于科研计算、数据分析及AI模型开发领域。

## Docker部署示例
### 1. 拉取镜像
```bash
docker pull rocker/cuda:latest
```

### 2. 运行容器（启用GPU支持）
```bash
docker run --gpus all -it --rm rocker/cuda:latest R
```
> 说明：`--gpus all`参数用于启用容器对GPU的访问，确保主机已安装NVIDIA Docker运行时（nvidia-container-runtime）。
