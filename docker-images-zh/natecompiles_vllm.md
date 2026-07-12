---
image: natecompiles/vllm
description: "为无法使用最新CUDA工具包的系统提供预编译的vLLM Docker镜像，支持基于分页注意力机制的高吞吐量LLM服务，当前针对CUDA 12.4版本。"
source: https://xuanyuan.cloud/zh/r/natecompiles/vllm
canonical: https://xuanyuan.cloud/zh/r/natecompiles/vllm
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/natecompiles/vllm" title="natecompiles/vllm Docker 镜像中文简介、标签列表与拉取命令">natecompiles/vllm 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 为旧版CUDA编译的vLLM镜像

## 镜像概述

本仓库提供为旧版NVIDIA CUDA版本编译的**vLLM镜像**，旨在为无法使用最新CUDA工具包的系统提供预编译的Docker镜像。目前，该仓库提供专门针对**CUDA 12.4**版本编译的镜像。

vLLM是一款高吞吐量、易于使用的**LLM服务引擎**，它利用**分页注意力（Paged Attention）** 机制，实现了比传统服务方法显著更高的吞吐量。

## 核心功能与特性

### 核心功能
- **高吞吐量LLM服务**：基于分页注意力机制，大幅提升LLM服务的并发处理能力
- **预编译适配**：针对旧版CUDA环境（当前支持CUDA 12.4）进行编译，解决旧系统兼容性问题
- **易于部署**：提供Docker镜像形式，简化在受限环境中的部署流程

### 主要特性
- 兼容CUDA 12.4环境，无需升级系统CUDA工具包
- 保留vLLM原生的高性能和低延迟特性
- 支持主流LLM模型的高效服务

## 使用场景与适用范围

### 适用场景
- 企业服务器环境：已部署旧版CUDA但需要运行vLLM服务的系统
- 学术研究环境：受限于硬件或系统配置无法升级CUDA的研究平台
- 边缘计算设备：对CUDA版本有严格限制的边缘计算场景

### 适用范围
- 需要部署LLM服务但受限于CUDA 12.4版本的系统
- 追求高吞吐量LLM推理服务的应用场景
- 希望简化vLLM部署流程的用户

## 使用方法与配置说明

### 基本使用流程

#### 1. 拉取镜像
```bash
docker pull docker.xuanyuan.run/[镜像仓库地址]/vllm-cuda12.4:latest
```

#### 2. 运行容器
基本运行命令：
```bash
docker run --gpus all -p 8000:8000 docker.xuanyuan.run/[镜像仓库地址]/vllm-cuda12.4:latest \
  --model [模型名称或路径] \
  --port 8000
```

### 关键配置参数

| 参数 | 说明 | 示例 |
|------|------|------|
| `--model` | 指定要加载的LLM模型名称或本地路径 | `--model meta-llama/Llama-2-7b-chat-hf` |
| `--port` | 指定服务端口 | `--port 8000` |
| `--gpu-memory-utilization` | GPU内存利用率（0-1之间） | `--gpu-memory-utilization 0.9` |
| `--max-num-batched-tokens` | 批处理的最大token数 | `--max-num-batched-tokens 4096` |

### 环境变量说明

| 环境变量 | 说明 | 默认值 |
|----------|------|--------|
| `VLLM_LOG_LEVEL` | 日志级别 | `info` |
| `CUDA_VISIBLE_DEVICES` | 指定可见GPU设备 | `all` |

### 示例：部署Llama-2-7B模型
```bash
docker run --gpus all -p 8000:8000 docker.xuanyuan.run/[镜像仓库地址]/vllm-cuda12.4:latest \
  --model meta-llama/Llama-2-7b-chat-hf \
  --port 8000 \
  --gpu-memory-utilization 0.9 \
  --max-num-batched-tokens 4096
```

服务启动后，可通过`http://localhost:8000`访问vLLM的API接口。
