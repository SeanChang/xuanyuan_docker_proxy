---
image: rocm/pytorch-training
description: "针对ROCm优化的统一PyTorch基础训练容器"
source: https://xuanyuan.cloud/zh/r/rocm/pytorch-training
canonical: https://xuanyuan.cloud/zh/r/rocm/pytorch-training
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rocm/pytorch-training" title="rocm/pytorch-training Docker 镜像中文简介、标签列表与拉取命令">rocm/pytorch-training 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ROCm PyTorch训练容器 (v25.7)
针对ROCm优化的统一PyTorch基础训练容器。

## 概述

PyTorch是一款开源机器学习框架，广泛用于模型训练，其GPU优化组件适用于基于Transformer的模型。

ROCm PyTorch训练Docker镜像`rocm/pytorch-training:v25.5`（可通过AMD Infinity Hub获取）提供预构建的优化环境，用于在AMD Instinct™ MI300X和MI325X加速器上进行模型微调与预训练。详细文档请参考ROCm文档页面：https://rocm.docs.amd.com/en/latest/how-to/rocm-for-ai/training/benchmark-docker/pytorch-training.html

## Docker部署示例

### 拉取镜像
```bash
docker pull docker.xuanyuan.run/rocm/pytorch-training:v25.5
```

### 运行容器（模型微调示例）
以下命令展示如何运行容器进行Qwen2模型微调：
```bash
docker run -it --rm \
  --device=/dev/kfd \
  --device=/dev/dri \
  --group-add docker.xuanyuan.run/video \
  --ipc=host \
  -v /本地数据路径:/data \
  -v /模型 checkpoint 路径:/checkpoints \
  rocm/pytorch-training:v25.5 \
  bash -c "cd /workspace && \
           torchtune finetune --model qwen2-7b --data /data/train_data.json --checkpoint /checkpoints/qwen2-7b-base --output_dir /data/output"
```
说明：
- `--device`：挂载ROCm设备以访问GPU
- `--group-add video`：添加视频组权限
- `--ipc=host`：使用主机IPC命名空间，避免共享内存限制
- `-v`：挂载本地数据和模型文件到容器内

## v25.7 发布说明

### 更新内容

* 库更新：
  * ROCm: 6.4.2
  * Python: 3.10.18
  * PyTorch: 2.8.0a0+gitd06a406
  * Transformer Engine: 2.2.0.dev0+94e53dd8
  * Flash Attention: 3.0.0.post1
  * hipBLASLt: 1.1.0-4b9a52edfc
  * Triton: 3.3.0

* 增强FP8支持覆盖范围
  * Torchtune全权重微调
  * Torchtitan预训练

* 新增Qwen模型微调支持
  * Qwen2 - 1.5B、7B
  * Qwen2.5 - 32B、72B
  * Qwen3 - 8B、32B

* 支持GPT-OSS模型微调

* 修复因PyTorch更新导致的SemiAnalysis模型问题

## v25.6 发布说明

### 更新内容

* 库更新：
  * PyTorch: 2.8.0a0+git7d205b2
  * Triton: 3.3.0
  * Hipblaslt: 0.15.0-8c69191d
  * Transformer Engine: 1.14.0+2f85f5f2

* 开箱即用地全面支持上游pytorch/TorchTune

* 新增与最新Torchtune匹配的支持矩阵

* 为所有支持的模型和用法添加基准测试示例

* 新增统一的Torchtune_Tester.sh脚本，用于Torchtune微调基准测试

* 新增模型支持及基准测试示例：
  * Llama 4 17B_16E (scout)：全权重SFT、LoRA
  * Llama 3.2 Vision 11B：仅全权重SFT
  * Llama 3.2 Vision 90B：仅全权重SFT

* 开箱即支持Torchtitan：
  * 更新Torchtitan以匹配上游版本
  * 基于CK的Flash Attention实现开箱即用地全面支持BF16

### 已知问题

* 由于ROCm 6.4运行时问题，仍使用ROCm 6.3.4，已确定解决方法，将在下一版本应用

* 上游Torchtune中Llama 3.2视觉模型LoRA微调存在已知问题

* ROCm 6.3存在内存泄漏问题（将在ROCm 6.4中修复）

* 移除2024年12月使用的Semi Analysis模型的基准测试支持，因其实现不再支持PyTorch 2.8+

## v25.5 发布说明

### 更新内容

* 库更新：
  * ROCm: 6.3.4
  * Triton: 3.2.0
  * Hipblaslt: 0.13.0-98e224a3
  * Transformer Engine: 1.12.0.dev0+25a33da

* 全面支持TorchTune：
  * 模型支持：Llama-3.3、Llama-3.2、Llama 3.1、Llama 2
  * 功能支持：全权重微调、LoRA、qLoRA

* Torchtune打包输入设置下性能提升约38%

### 已知问题

* SPDA内存高效后端存在数值问题报告

* ROCm 6.3存在内存泄漏问题（将在ROCm 6.4中修复）
