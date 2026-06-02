---
image: ai/qwen3-coder-next
description: "Qwen3-Coder-Next是专为编码代理和本地开发设计的开源语言模型，采用混合专家（MoE）架构，80B总参数中仅激活3B参数实现高效运行，具备256K上下文长度和强大的代理能力，适用于动态编码任务。"
source: https://xuanyuan.cloud/zh/r/ai/qwen3-coder-next
canonical: https://xuanyuan.cloud/zh/r/ai/qwen3-coder-next
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ai/qwen3-coder-next" title="ai/qwen3-coder-next Docker 镜像中文简介、标签列表与拉取命令">ai/qwen3-coder-next 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Qwen3-Coder-Next

Qwen3-Coder-Next是一款开源权重语言模型，专为编码代理和本地开发设计。该创新模型采用混合专家（Mixture-of-Experts, MoE）架构，在800亿总参数中仅激活30亿参数即可实现卓越效率，性能可媲美激活参数多10-20倍的模型。

该模型在高级代理能力方面表现出色，包括长程推理、复杂工具使用和执行故障恢复，使其在动态编码任务中具有高度稳健性。凭借256K上下文长度和对各种脚手架模板的适应性，Qwen3-Coder-Next可无缝集成Claude Code、Qwen Code、Qoder、Kilo、Trae和Cline等多种CLI/IDE平台，支持多样化开发环境。这使得它在保持各类编码基准测试优异性能的同时，对代理部署具有极高的成本效益。

## 特性

| 属性 | 值 |
|---|---|
| **提供商** | 阿里云（Qwen团队） |
| **架构** | Qwen3Next（混合：Gated DeltaNet + Gated Attention + 混合专家） |
| **总参数** | 800亿 |
| **激活参数** | 30亿 |
| **上下文长度** | 262,144 tokens |
| **输入模态** | 文本 |
| **输出模态** | 文本 |
| **许可证** | Apache 2.0 |

## 使用Docker Model Runner运行模型

```bash
docker model run qwen3-coder-next
```

更多信息，请查看[Docker Model Runner文档](https://docs.docker.com/desktop/features/model-runner/)。

## 架构细节

Qwen3-Coder-Next采用复杂的混合架构，具体规格如下：

- **层数**：48层混合布局：12 × (3 × (Gated DeltaNet → MoE) → 1 × (Gated Attention → MoE))
- **隐藏维度**：2048
- **Gated Attention**：16个Q头，2个KV头，头维度256
- **Gated DeltaNet**：32个V头，16个QK头，头维度128
- **混合专家**：512个总专家，每token激活10个专家，1个共享专家
- **训练**：预训练和后训练阶段

## 基准测试

![基准测试对比](https://qianwen-res.oss-accelerate-overseas.aliyuncs.com/Qwen3-Coder-Next/benchmarks.png)

该模型在各种编码基准测试中表现强劲，使用显著更少的激活参数却能达到与更大模型相当的结果。

![SWE-bench PRO结果](https://qianwen-res.oss-accelerate-overseas.aliyuncs.com/Qwen3-Coder-Next/swebench_pro.png)

Qwen3-Coder-Next在SWE-bench PRO上表现优异，展示了其处理实际软件工程任务的能力。

## 核心特性

- **高效架构**：800亿总参数中仅激活30亿参数，部署效率极高
- **长上下文**：原生支持262K tokens，可处理大型代码库和海量文档
- **代理能力**：擅长工具调用、长程推理和错误恢复
- **IDE集成**：与多种开发环境和编码平台无缝集成
- **非思考模式**：专注于直接输出，不生成中间推理块

## 链接

- [Qwen3-Coder-Next GGUF仓库](https://huggingface.co/unsloth/Qwen3-Coder-Next-GGUF)
- [Qwen3-Coder-Next博客文章](https://qwen.ai/blog?id=qwen3-coder-next)
- [原始模型仓库](https://huggingface.co/Qwen/Qwen3-Coder-Next)
- [GitHub仓库](https://github.com/QwenLM/Qwen3-Coder)
- [文档](https://qwen.readthedocs.io/en/latest/)

## 注意事项

- **内存要求**：建议配备>45GB统一内存或RAM/VRAM以运行4位量化版本
- **最佳量化**：为获得最佳效果，使用2位XL量化或更高版本（需>30GB统一内存/组合RAM+VRAM）
- **上下文长度**：默认上下文长度为256K tokens。若遇到内存不足或服务器启动失败问题，可考虑将上下文长度减少至32,768 tokens等较短值
- **采样参数**：为获得最佳性能，使用`temperature=1.0`，`top_p=0.95`，`top_k=40`
- **模型更新**：截至2025年2月4日，llama.cpp已修复导致Qwen循环和输出质量差的bug。确保使用最新版本的llama.cpp和更新的GGUF以获得改进的输出
- **推理引擎**：该模型支持多种推理引擎，包括SGLang（≥v0.5.8）和vLLM（≥0.15.0），以及Ollama、LMStudio、MLX-LM、llama.cpp和KTransformers等本地工具
