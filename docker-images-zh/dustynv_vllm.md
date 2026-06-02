---
image: dustynv/vllm
description: "NVIDIA Jetson 平台优化的大语言模型推理服务框架"
source: https://xuanyuan.cloud/zh/r/dustynv/vllm
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[dustynv/vllm](https://xuanyuan.cloud/zh/r/dustynv/vllm)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# vLLM (NVIDIA Jetson 优化版) 镜像文档

## 概述
本镜像为 vLLM 项目针对 NVIDIA Jetson 平台的优化版本。vLLM 是一个高效的开源大语言模型（LLM）推理服务框架，通过创新的 PagedAttention 技术实现高吞吐量和低延迟的推理性能。本镜像由 [dustynv/jetson-containers](https://github.com/dustynv/jetson-containers) 项目构建，专门为 Jetson 边缘计算设备优化，支持在资源受限的嵌入式平台上运行大语言模型推理服务。更多项目细节可参考上游仓库：[vllm-project/vllm](https://github.com/vllm-project/vllm)。

## 核心功能与特性
- **高效推理引擎**：采用 PagedAttention 技术优化注意力键值缓存（KV 缓存）的内存管理，几乎消除内存浪费，显著提升推理吞吐量（相比 Hugging Face Transformers 提升最高 24 倍）。
- **OpenAI 兼容 API**：提供与 OpenAI API 兼容的 RESTful 接口，支持无缝集成现有应用和服务，便于部署和迁移。
- **Jetson 平台优化**：针对 NVIDIA Jetson 平台（L4T R36.4+）进行深度优化，充分利用 CUDA 12.6/12.8 和 TensorRT 等硬件加速能力，适配边缘计算场景。
- **丰富的模型支持**：支持 Hugging Face 模型库中的主流大语言模型，包括 LLaMA、Mistral、Qwen 等系列，支持量化（bitsandbytes）和多种优化技术（Flash Attention、xformers 等）。
- **完整依赖集成**：预装 PyTorch、Transformers、Diffusers 等深度学习框架，以及 Flash Attention、Triton、CUTLASS 等性能优化库，开箱即用。

## 使用场景与适用范围
- **边缘 AI 推理服务**：在 NVIDIA Jetson 设备上部署大语言模型推理服务，适用于边缘计算、IoT 设备、机器人等场景。
- **本地私有化部署**：需要本地部署大语言模型服务，保护数据隐私，避免依赖云端 API 的场景。
- **开发与测试环境**：为 LLM 应用开发提供本地测试环境，支持快速迭代和调试。
- **资源受限环境**：在计算资源有限的边缘设备上运行轻量级或量化后的大语言模型。

## 使用方法与配置说明

### 系统要求
- **硬件平台**：NVIDIA Jetson 设备（AGX Xavier、Xavier NX、Orin 等）
- **软件要求**：JetPack 5.1+ / L4T R35.x+ 或 JetPack 6.0+ / L4T R36.4.0+
- **CUDA 版本**：CUDA 12.6 或 12.8

### 基础部署（使用 jetson-containers）
推荐使用 `jetson-containers` 工具自动选择兼容的镜像版本：

```bash
# 自动选择兼容版本并运行
jetson-containers run $(autotag vllm)

# 或指定具体版本
jetson-containers run dustynv/vllm:0.9.3-r36.4.0-cu128-24.04
```

### 手动 Docker Run 部署
如需手动运行，可使用以下命令：

```bash
sudo docker run --runtime nvidia -it --rm --network=host \
  -v /path/to/models:/models \
  -v /path/to/data:/data \
  dustynv/vllm:0.9.3-r36.4.0-cu128-24.04 \
  python -m vllm.entrypoints.openai.api_server \
  --model mistralai/Mistral-7B-Instruct-v0.2 \
  --port 8000
```

### Docker Compose 配置示例
```yaml
version: '3.8'

services:
  vllm:
    image: dustynv/vllm:0.9.3-r36.4.0-cu128-24.04
    container_name: vllm-server
    runtime: nvidia
    network_mode: host
    volumes:
      - ./models:/models
      - ./data:/data
      - ~/.cache/huggingface:/root/.cache/huggingface
    environment:
      - HUGGING_FACE_HUB_TOKEN=${HUGGING_FACE_HUB_TOKEN}
    command: >
      python -m vllm.entrypoints.openai.api_server
      --model mistralai/Mistral-7B-Instruct-v0.2
      --port 8000
      --host 0.0.0.0
    restart: unless-stopped
```

### 配置参数说明
vLLM 支持丰富的命令行参数，常用配置包括：
- `--model`：指定模型路径或 Hugging Face 模型标识符
- `--port`：API 服务端口（默认 8000）
- `--host`：绑定地址（默认 0.0.0.0）
- `--tensor-parallel-size`：张量并行度（多 GPU 推理）
- `--gpu-memory-utilization`：GPU 内存利用率（0.0-1.0）
- `--max-model-len`：最大序列长度
- `--quantization`：量化方法（awq、gptq、squeezellm 等）
- `--trust-remote-code`：允许执行远程代码（某些模型需要）

更多参数说明请参考 [vLLM 官方文档](https://docs.vllm.ai/en/latest/)。

### 版本说明
本镜像提供多个版本标签，建议根据 Jetson 平台和 CUDA 版本选择：
- `0.9.3`（latest）：最新稳定版本，推荐使用
- `0.9.2`、`0.9.0`：较新版本
- `0.8.x`：稳定版本系列
- `r36.4.0-cu128-24.04`：针对 L4T R36.4.0、CUDA 12.8、Ubuntu 24.04 的特定构建

## 参考与更多信息
- 上游项目：[vllm-project/vllm](https://github.com/vllm-project/vllm)
- 官方文档：[vLLM Documentation](https://docs.vllm.ai/)
- Jetson 容器项目：[dustynv/jetson-containers](https://github.com/dustynv/jetson-containers)
- PagedAttention 论文：[Efficient Memory Management for Large Language Model Serving with PagedAttention](https://arxiv.org/abs/2309.06180)
