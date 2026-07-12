---
image: lisp19/vllm-gemma4
description: "vllm的分支版本，专门优化以更好地在Turing架构上与Gemma4模型协同工作。"
source: https://xuanyuan.cloud/zh/r/lisp19/vllm-gemma4
canonical: https://xuanyuan.cloud/zh/r/lisp19/vllm-gemma4
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/lisp19/vllm-gemma4" title="lisp19/vllm-gemma4 Docker 镜像中文简介、标签列表与拉取命令">lisp19/vllm-gemma4 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# vllm-Gemma4-Turing优化镜像

## 镜像概述
本镜像基于vllm项目的分支版本构建，针对Gemma4模型在Turing架构（如NVIDIA Turing系列GPU，包括RTX 20系列、T4等）上的运行进行了专门优化，旨在提升模型兼容性和推理性能。

## 核心功能与特性
- **Gemma4模型适配**：针对Gemma4模型的架构特性进行定制化调整，优化模型加载与推理流程
- **Turing架构优化**：针对Turing GPU的计算特性（如Tensor Cores、显存带宽等）进行性能调优
- **vllm核心能力保留**：继承vllm的高效推理引擎，支持PagedAttention等关键技术

## 使用场景
适用于需要在Turing架构GPU上部署Gemma4模型的场景，包括但不限于：
- 低延迟文本生成服务
- 本地模型推理测试环境
- 教育科研中的模型实验平台

## 使用方法

### 基础运行命令
```bash
docker run -it --gpus all \
  -v /path/to/gemma4-model:/model \
  -p 8000:8000 \
  [镜像名称] \
  --model /model \
  --device cuda:0 \
  --port 8000
```

### 参数说明
- `--model`：指定Gemma4模型文件路径（容器内路径）
- `--device`：指定使用的GPU设备（如`cuda:0`表示第一块GPU）
- `--port`：设置API服务端口

### 环境变量
目前镜像未定义特殊环境变量，主要通过启动参数进行配置。

## 注意事项
- 确保主机已安装NVIDIA Docker运行时（nvidia-docker2）
- 建议使用至少16GB显存的Turing架构GPU以获得最佳性能
- 模型文件需自行准备并通过卷挂载到容器中
