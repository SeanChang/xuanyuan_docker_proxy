---
image: ai/deepseek-r1-distill-llama
description: "由DeepSeek开发的蒸馏版LLaMA模型，快速且针对实际任务优化，适用于高效执行各类真实场景任务。"
source: https://xuanyuan.cloud/zh/r/ai/deepseek-r1-distill-llama
canonical: https://xuanyuan.cloud/zh/r/ai/deepseek-r1-distill-llama
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ai/deepseek-r1-distill-llama" title="ai/deepseek-r1-distill-llama Docker 镜像中文简介、标签列表与拉取命令">ai/deepseek-r1-distill-llama — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ai/deepseek-r1-distill-llama" title="ai/deepseek-r1-distill-llama Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ai/deepseek-r1-distill-llama</a>

# Deepseek-R1-Distill-Llama 镜像文档


## 镜像概述和主要用途

Deepseek-R1-Distill-Llama 是 DeepSeek 推出的基于 LLaMA 架构的蒸馏版推理模型，是 DeepSeek 第一代推理模型（DeepSeek-R1-Zero 和 DeepSeek-R1）的衍生版本。该模型通过强化学习增强推理性能，在完整 DeepSeek-R1 模型的响应和推理输出上进行了微调优化，具有快速高效的特点，专为实际业务场景中的任务处理设计。


## 核心功能和特性

### 基本特性

| 属性                 | 详情                  |
|----------------------|-----------------------|
| **提供方**           | Deepseek              |
| **架构**             | LLaMA                 |
| **数据截止日期**     | 2024年5月ⁱ            |
| **支持语言**         | 英语、中文            |
| **工具调用能力**     | ✅（支持）            |
| **输入模态**         | 文本                  |
| **输出模态**         | 文本                  |
| **许可证**           | [MIT](https://github.com/deepseek-ai/DeepSeek-R1/blob/main/LICENSE) |

ⁱ：估算值


### 可用模型变体

| 模型变体                                  | 参数   | 量化方式       | 上下文窗口 | 显存¹ | 大小   |
|-------------------------------------------|--------|----------------|------------|-------|--------|
| `ai/deepseek-r1-distill-llama:latest`<br><br>`ai/deepseek-r1-distill-llama:8B-Q4_K_M` | 8B     | IQ2_XXS/Q4_K_M | 131K tokens | 5.33 GiB | 4.58 GB |
| `ai/deepseek-r1-distill-llama:8B-Q4_0`    | 8B     | Q4_0           | 131K tokens | 5.09 GiB | 4.33 GB |
| `ai/deepseek-r1-distill-llama:8B-Q4_K_M`  | 8B     | IQ2_XXS/Q4_K_M | 131K tokens | 5.33 GiB | 4.58 GB |
| `ai/deepseek-r1-distill-llama:8B-F16`     | 8B     | F16            | 131K tokens | 15.01 GiB | 14.96 GB |
| `ai/deepseek-r1-distill-llama:70B-Q4_0`   | 70B    | Q4_0           | 131K tokens | 38.73 GiB | 37.22 GB |
| `ai/deepseek-r1-distill-llama:70B-Q4_K_M` | 70B    | IQ2_XXS/Q4_K_M | 131K tokens | 41.11 GiB | 39.59 GB |

¹：显存基于模型特性估算。

> 说明：`latest` 标签对应 `8B-Q4_K_M` 变体。


## 使用场景和适用范围

Deepseek-R1-Distill-Llama 适用于以下场景：

- **软件开发**：生成代码、调试程序、解释复杂技术概念。
- **数学领域**：解决复杂数学问题并提供解释，支持科研和教育场景。
- **内容创作与编辑**：为各行业撰写、编辑和总结内容。
- **客户服务**：驱动聊天机器人与用户互动，解答咨询。
- **数据分析**：从大型数据集中提取洞察并生成报告。
- **教育领域**：作为数字 tutor，提供清晰解释和个性化课程。


## 使用方法和配置说明

### 使用 Docker Model Runner

#### 前提条件

确保已安装支持 Model Runner 功能的 Docker 环境，详情参考 [Docker Model Runner 文档](https://docs.docker.com/desktop/features/model-runner/)。

#### 拉取镜像

```bash
docker model pull ai/deepseek-r1-distill-llama
```

#### 运行模型

```bash
docker model run ai/deepseek-r1-distill-llama
```


### 配置建议

- **温度参数**：建议设置在 0.5-0.7 之间（推荐值 0.6），以避免输出重复或逻辑不一致。
- **提示词格式**：不使用系统提示（system prompt），所有指令需包含在用户提示（user prompt）中。
- **数学问题处理**：添加明确指令，例如：“请逐步推理，并将最终答案用 \boxed{} 括起来。”
- **提示词优化**：模型对提示词敏感，少样本提示（few-shot prompting）会降低性能，建议使用零样本（zero-shot）设置，直接描述问题并指定输出格式以获得最佳结果。


## 性能基准

| 类别       | 基准测试                  | DeepSeek R1  |
|------------|---------------------------|--------------|
| **英文任务** |                           |              |
|            | MMLU (Pass@1)             | 90.8         |
|            | MMLU-Redux (EM)           | 92.9         |
|            | MMLU-Pro (EM)             | 84.0         |
|            | DROP (3-shot F1)          | 92.2         |
|            | IF-Eval (Prompt Strict)   | 83.3         |
|            | GPQA-Diamond (Pass@1)     | 71.5         |
|            | SimpleQA (Correct)        | 30.1         |
|            | FRAMES (Acc.)             | 82.5         |
|            | AlpacaEval2.0 (LC-winrate)| 87.6         |
|            | ArenaHard (GPT-4-1106)    | 92.3         |
| **代码任务** |                           |              |
|            | LiveCodeBench (Pass@1-COT)| 65.9         |
|            | Codeforces (Percentile)   | 96.3         |
|            | Codeforces (Rating)       | 2029         |
|            | SWE Verified (Resolved)   | 49.2         |
|            | Aider-Polyglot (Acc.)     | 53.3         |
| **数学任务** |                           |              |
|            | AIME 2024 (Pass@1)        | 79.8         |
|            | MATH-500 (Pass@1)         | 97.3         |
|            | CNMO 2024 (Pass@1)        | 78.8         |
| **中文任务** |                           |              |
|            | CLUEWSC (EM)              | 92.8         |
|            | C-Eval (EM)               | 91.8         |
|            | C-SimpleQA (Correct)      | 63.7         |


## 相关链接

- [DeepSeek-R1 论文](https://arxiv.org/abs/2501.12948)：《DeepSeek-R1: Incentivizing Reasoning Capability in LLMs via Reinforcement Learning》
