---
image: voipmonitor/sglang
description: "针对RTX PRO 6000 Blackwell (SM120a) GPU优化的SGLang推理栈，基于Ubuntu 24.04和CUDA 13.2.0，集成PyTorch nightly、FlashInfer和b12x，支持NVFP4精度，提供高性能大语言模型推理能力。"
source: https://xuanyuan.cloud/zh/r/voipmonitor/sglang
canonical: https://xuanyuan.cloud/zh/r/voipmonitor/sglang
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/voipmonitor/sglang" title="voipmonitor/sglang Docker 镜像中文简介、标签列表与拉取命令">voipmonitor/sglang 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# voipmonitor/sglang:test-cu132 镜像文档

## 镜像概述

`voipmonitor/sglang:test-cu132` 是一个专为 **RTX PRO 6000 Blackwell (SM120a)** GPU优化的SGLang推理环境。该镜像基于Ubuntu 24.04操作系统，集成CUDA 13.2.0和cuDNN，提供完整的大语言模型推理栈，支持NVFP4精度和MoE/GEMM加速，适用于高性能LLM部署场景。

## 核心功能与特性

### 技术栈组成
- **基础环境**：Ubuntu 24.04 + CUDA 13.2.0 + cuDNN
- **计算框架**：PyTorch nightly (cu132)
- **推理加速**：FlashInfer (git main)、b12x 0.5.1 (SM120专用NVFP4 MoE/GEMM)
- **核心引擎**：SGLang (源码编辑模式安装，含精选补丁)
- **编译工具**：nvidia-cutlass-dsl 4.4.2 (含CUDA 13.1 NVVM/ptxas修复)

### 关键特性
- **硬件优化**：针对SM120a架构深度优化，支持NVFP4精度推理
- **性能增强**：集成多个未合并PR补丁，优化MoE层、CUDA图、内存管理等关键路径
- **灵活部署**：SGLang采用可编辑安装模式，支持源码实时修改与测试
- **依赖管理**：通过uv包管理器实现高效依赖解析，修复cutlass-dsl版本冲突问题

## 使用场景

- 基于RTX PRO 6000 Blackwell GPU的大语言模型部署
- 需要NVFP4精度加速的MoE模型推理任务
- 高性能LLM服务开发与测试
- 推理性能基准测试与优化研究

## 使用方法

### 基本运行命令

```bash
docker run --gpus all \
  -v /path/to/cache:/cache \
  -v /path/to/models:/models \
  -p 8000:8000 \
  docker.xuanyuan.run/voipmonitor/sglang:test-cu132 \
  sglang serve --model /models/your_model --port 8000
```

### 构建参数说明

构建镜像时可通过`--build-arg`调整以下参数：

| 参数名 | 默认值 | 说明 |
|--------|--------|------|
| CUDA_VERSION | 13.2.0 | CUDA版本 |
| UBUNTU_VERSION | 24.04 | 基础系统版本 |
| PYTHON_VERSION | 3.12 | Python版本 |
| MAX_JOBS | 128 | 编译并行任务数 |
| NVCC_THREADS | 8 | NVCC编译线程数 |
| TORCH_CUDA_ARCH_LIST | "12.0a" | PyTorch目标GPU架构 |
| FLASHINFER_CUDA_ARCH_LIST | "12.0a" | FlashInfer目标GPU架构 |

### 运行时环境变量

| 环境变量 | 作用 |
|----------|------|
| TORCH_CUDA_ARCH_LIST | 指定PyTorch CUDA架构 |
| FLASHINFER_CUDA_ARCH_LIST | 指定FlashInfer CUDA架构 |
| TRITON_CACHE_DIR | Triton JIT缓存目录 |
| TORCH_EXTENSIONS_DIR | PyTorch扩展缓存目录 |
| FLASHINFER_WORKSPACE_BASE | FlashInfer工作目录 |
| NCCL_P2P_DISABLE | 是否禁用NCCL P2P通信 |
| CUDA_DEVICE_MAX_CONNECTIONS | CUDA设备最大连接数 |

### JIT缓存管理

镜像默认将JIT编译缓存存储在`/cache/jit`目录，建议通过卷挂载持久化此目录以加速重复启动：

```bash
-v /host/path/to/jit_cache:/cache/jit
```

## 配置说明

### SGLang服务配置

可通过命令行参数或配置文件调整SGLang服务行为：

```bash
# 启动带FlashInfer加速的服务
sglang serve \
  --model /models/qwen3.5-7b \
  --port 8000 \
  --enable-flashinfer-all \
  --kv-cache-dtype fp8 \
  --num-gpus 1
```

### 模型部署示例

部署Qwen3.5-7B模型示例：

```bash
docker run --gpus all \
  -v $PWD/models:/models \
  -v $PWD/cache:/cache \
  -p 8000:8000 \
  docker.xuanyuan.run/voipmonitor/sglang:test-cu132 \
  sglang serve \
    --model /models/qwen3.5-7b \
    --port 8000 \
    --enable-flashinfer-all \
    --kv-cache-dtype fp8 \
    --max-num-batched-tokens 8192
```

## 注意事项

1. **硬件要求**：仅支持SM120a架构GPU（如RTX PRO 6000 Blackwell）
2. **驱动要求**：需安装支持CUDA 13.2的NVIDIA驱动
3. **缓存管理**：首次运行会进行JIT编译，耗时较长，建议持久化缓存目录
4. **依赖冲突**：镜像已修复nvidia-cutlass-dsl的NVVM/ptxas版本冲突问题，无需额外处理
5. **源码修改**：SGLang采用可编辑安装，可通过修改`/opt/sglang`目录下源码进行定制开发
