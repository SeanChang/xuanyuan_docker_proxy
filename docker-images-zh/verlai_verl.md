---
image: verlai/verl
description: "verl 是一款聚焦大模型\"训练+推理\"全流程的工具集，核心定位是降低大模型强化学习（RL）训练与高效推理的门槛，支持 FSDP、Megatron-LM 训练后端和 vLLM、SGLang、TGI 推理引擎，内置多种 RL 算法，适用于企业级大模型落地场景。"
source: https://xuanyuan.cloud/zh/r/verlai/verl
canonical: https://xuanyuan.cloud/zh/r/verlai/verl
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/verlai/verl" title="verlai/verl Docker 镜像中文简介、标签列表与拉取命令">verlai/verl 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# verl - 大模型强化学习训练与推理工具集

## 前言

verl 是一款聚焦大模型"训练+推理"全流程的工具集，核心定位是降低大模型强化学习（RL）训练与高效推理的门槛，尤其适配企业级大模型落地场景。其本质是通过封装主流深度学习框架（如 PyTorch、Megatron-LM）和推理引擎（如 vLLM、SGLang），让开发者无需手动解决复杂的环境依赖、分布式配置问题，专注于模型优化与业务逻辑。

## verl 的核心功能

verl 的能力覆盖"训练"和"推理"两大核心场景，且支持灵活扩展：

### 大模型训练：主打强化学习与分布式能力

- **支持多训练后端**：适配 FSDP（PyTorch 原生分布式框架，适合快速验证原型）、Megatron-LM（NVIDIA 高性能分布式框架，支持万卡级大模型训练，适合大规模落地）
- **强化学习（RL）优化**：内置 RL 训练流程封装，可直接用于大模型 RLHF（基于人类反馈的强化学习）、RLHF 变种任务，无需从零搭建训练 pipeline
- **依赖自动兼容**：自动适配 PyTorch、CUDA、FlashAttention 等核心依赖版本，避免"版本冲突导致训练崩溃"

### 大模型推理：高效生成 rollout 结果

- **支持多推理引擎**：集成 vLLM（业界领先的高吞吐推理框架，支持动态批处理）、SGLang（高性能推理引擎，提供丰富的优化特性）、TGI（Hugging Face Text Generation Inference，适合标准 Hugging Face 模型）
- **聚焦"rollout 生成"**：专为强化学习场景设计——快速生成模型输出样本（如 RLHF 中的"模型回答候选"），推理访问表现比原生 Hugging Face pipeline 提升 5-10 倍

### 高扩展性与定制化

- **支持自定义训练配置**：可通过 YAML 配置文件修改训练参数（如学习率、batch size、分布式策略）
- **源码级可定制**：若使用挂载目录部署，可直接修改 verl 源码（如适配新的 RL 算法、自定义数据集），无需重新构建镜像

## verl 的适用场景

| 用户类型 | 适用场景 |
| ---- | ---- |
| 算法工程师 | 快速验证大模型 RL 算法、搭建 RLHF 训练流程、测试不同推理引擎的 rollout 效率 |
| 企业运维/DevOps | 为团队快速部署统一的大模型训练/推理环境，避免"一人一环境"的运维混乱 |
| 初学者 | 零门槛体验大模型分布式训练与高效推理，无需手动配置 CUDA、PyTorch 等复杂环境 |
| 大型团队 | 基于 Megatron-LM 后端搭建大规模分布式训练集群，支撑百亿/千亿参数模型训练 |

## 系统要求

- **Python**: 版本 >= 3.10
- **CUDA**: 版本 >= 12.8
- **cuDNN**: 版本 >= 9.10.0（推荐）

## 快速开始

### 使用 Docker 镜像（推荐）

verl 提供了预构建的 Docker 镜像，支持 vLLM 和 SGLang 两种基础镜像。您可以从 Docker Hub 拉取最新镜像：

```bash
# 使用 vLLM 基础镜像
docker pull docker.xuanyuan.run/verlai/verl:vllm011.latest

# 或使用 SGLang 基础镜像
docker pull docker.xuanyuan.run/verlai/verl:sgl055.latest
```

### 运行容器

```bash
docker create --runtime=nvidia --gpus all --net=host --shm-size="10g" --cap-add=SYS_ADMIN -v .:/workspace/verl --name verl verlai/verl:vllm011.latest sleep infinity
docker start verl
docker exec -it verl bash
```

### 安装 verl

在容器内安装 verl：

```bash
# 安装 nightly 版本（推荐）
git clone https://github.com/volcengine/verl && cd verl
pip3 install --no-deps -e .

# 或安装特定框架支持
pip3 install -e .[vllm]
pip3 install -e .[sglang]
```

## 支持的算法

verl 内置了多种强化学习算法，包括：

- **PPO** (Proximal Policy Optimization)
- **GRPO** (Group Relative Policy Optimization)
- **DAPO** (Decoupled Clip and Dynamic Sampling Policy Optimization)
- **SPIN** (Self-Play Fine-Tuning)
- **SPPO** (Self-Play Preference Optimization)
- **OPO** (On-Policy RL with Optimal Reward Baseline)

## 硬件支持

- **NVIDIA GPU**: 完整支持 CUDA 12.8+，推荐使用 A100、H100 等高性能 GPU
- **AMD GPU**: 支持 ROCm 6.2+，适用于 MI300 系列 GPU（使用 FSDP 训练后端）
- **Ascend**: 支持华为昇腾设备

## 相关资源

- **官方文档**: https://verl.readthedocs.io/
- **GitHub 仓库**: https://github.com/volcengine/verl
- **Docker Hub**: https://hub.docker.com/r/verlai/verl

## 许可证

verl 采用开源许可证，详情请参阅项目仓库。
