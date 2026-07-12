---
image: voipmonitor/vllm
description: "针对RTX PRO 6000 Blackwell (SM120a)的vLLM推理栈，基于CUDA 13.2构建，包含Ubuntu 24.04、PyTorch nightly、vLLM、FlashInfer、SGLang等组件，修复了nvidia-cutlass-dsl的NVVM/ptxas版本冲突问题，适用于高性能LLM推理任务。"
source: https://xuanyuan.cloud/zh/r/voipmonitor/vllm
canonical: https://xuanyuan.cloud/zh/r/voipmonitor/vllm
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/voipmonitor/vllm" title="voipmonitor/vllm Docker 镜像中文简介、标签列表与拉取命令">voipmonitor/vllm 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# voipmonitor/vllm:test-cu132

## 镜像概述

voipmonitor/vllm:test-cu132是专为**RTX PRO 6000 Blackwell (SM120a)** 硬件优化的vLLM推理栈镜像，基于CUDA 13.2构建，旨在提供高性能的大语言模型(LLM)推理能力。该镜像集成了多个关键组件，确保在特定硬件上实现高效的模型部署和运行。

## 核心功能与特性

### 组件栈
- **基础环境**：Ubuntu 24.04 操作系统，集成 CUDA 13.2.0 和 cuDNN
- **深度学习框架**：PyTorch nightly (cu132)
- **推理引擎**：vLLM（源码构建）
- **加速库**：FlashInfer（git main分支）
- **服务框架**：SGLang（源码，可编辑模式）
- **优化工具**：nvidia-cutlass-dsl 4.4.2（包含CUDA 13.1 NVVM/ptxas修复）

### 关键修复：nvidia-cutlass-dsl NVVM/ptxas版本冲突

`nvidia-cutlass-dsl[cu13]` 包含两个子包，均会写入 `_cutlass_ir.so` 文件：
- `libs-base`（必填）：提供 NVVM/ptxas **12.9** 版本（无法为 SM120 编译 `_mma.block_scale`）
- `libs-cu13`（可选扩展）：提供 NVVM/ptxas **13.1** 版本（支持 SM120）

默认 pip 安装会先安装 `libs-cu13` 再安装 `libs-base`，导致 CUDA 13 版本的二进制文件被覆盖。修复方法：将以下命令作为最后一步执行：
```bash
pip install --force-reinstall --no-deps nvidia-cutlass-dsl-libs-cu13
```

## 使用场景与适用范围

该镜像适用于需要在 **RTX PRO 6000 Blackwell (SM120a)** 硬件上部署和运行大语言模型推理的场景，尤其适合对性能要求较高的应用，如：
- 高性能LLM服务部署
- 大规模语言模型推理性能测试
- 针对SM120架构的模型优化验证

## 使用方法与配置说明

### 获取镜像
```bash
docker pull docker.xuanyuan.run/voipmonitor/vllm:test-cu132
```

### 基本运行示例
```bash
docker run --gpus all -it --rm docker.xuanyuan.run/voipmonitor/vllm:test-cu132
```

### 详细配置
完整的Dockerfile及更多配置细节，请参考源码仓库中的说明文档。

### 注意事项
- 该镜像仅针对 **RTX PRO 6000 Blackwell (SM120a)** 硬件优化，其他架构可能无法正常运行
- 运行时需确保主机已安装支持CUDA 13.2的NVIDIA驱动
- 如需自定义配置，建议基于该镜像构建新的Dockerfile并保留关键修复步骤
