---
image: ai/llama3.3
description: "最新LLama 3版本，具备改进的推理能力和生成质量。"
source: https://xuanyuan.cloud/zh/r/ai/llama3.3
canonical: https://xuanyuan.cloud/zh/r/ai/llama3.3
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ai/llama3.3" title="ai/llama3.3 Docker 镜像中文简介、标签列表与拉取命令">ai/llama3.3 — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ai/llama3.3" title="ai/llama3.3 Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ai/llama3.3</a>

# Llama 3.3

![logo](https://github.com/docker/model-cards/raw/refs/heads/main/logos/meta-280x184-overview@2x.svg)

## 镜像概述和主要用途

Meta Llama 3.3 是由Meta设计的700亿参数多语言语言模型，专为聊天和内容生成等文本任务而优化。其指令调优版本针对多语言对话进行了优化，在常见基准测试中性能优于许多开源和商业模型。作为最新的Llama 3版本，该模型在推理能力和生成质量方面均有显著提升。


## 使用场景和适用范围

- **多语言助手式聊天**：使用指令调优模型构建跨语言对话AI，支持在多种语言环境下实现自然且上下文感知的交互。
- **编码支持与软件开发任务**：辅助代码生成、调试、文档编写及其他软件工程工作流。
- **多语言内容创作与本地化**：跨语言和文化生成及调整书面内容，支持全球沟通与用户 engagement。
- **知识型应用**：将大型语言模型与结构化或非结构化数据源集成，用于问答、洞察提取或决策支持。
- **通用自然语言生成**：各类自然语言生成任务，如摘要、翻译或跨领域内容创作。
- **合成数据生成（synth）**：创建真实、高质量的合成文本数据，用于扩充训练、测试数据集或匿名化处理。


## 核心功能和特性

### 关键特性
- **最新Llama 3版本**：相比前代模型，推理能力和生成质量显著提升
- **多语言支持**：覆盖英语、德语、法语、意大利语、葡萄牙语、印地语、西班牙语和泰语
- **工具调用能力**：支持工具调用功能（✅）
- **代码生成能力**：输出模态包括文本和代码，适用于软件开发任务
- **长上下文窗口**：支持131K tokens的上下文窗口，可处理长文本输入

### 基本属性

| 属性             | 详情                     |
|------------------|--------------------------|
| **提供者**       | Meta                     |
| **架构**         | llama                    |
| **数据截止日期** | 2023年12月               |
| **支持语言**     | 英语、德语、法语、意大利语、葡萄牙语、印地语、西班牙语和泰语 |
| **工具调用**     | ✅                        |
| **输入模态**     | 文本                     |
| **输出模态**     | 文本和代码               |
| **许可证**       | [Llama 3.3 社区许可证](https://github.com/meta-llama/llama-models/blob/main/models/llama3_3/LICENSE) |


## 可用模型变体

| 模型变体                                  | 参数   | 量化方式       | 上下文窗口 | 显存¹   | 大小     |
|-------------------------------------------|--------|----------------|------------|---------|----------|
| `ai/llama3.3:latest`<br><br>`ai/llama3.3:70B-Q4_K_M` | 70B    | IQ2_XXS/Q4_K_M | 131K tokens | 41.11 GiB | 39.59 GB |
| `ai/llama3.3:70B-Q4_0`                    | 70B    | Q4_0           | 131K tokens | 38.73 GiB | 37.22 GB |
| `ai/llama3.3:70B-Q4_K_M`                  | 70B    | IQ2_XXS/Q4_K_M | 131K tokens | 41.11 GiB | 39.59 GB |

¹: 显存基于模型特性估算。

> `latest` 标签对应 `70B-Q4_K_M` 变体


## 使用方法和配置说明

### 通过 Docker Model Runner 使用

#### 1. 拉取模型镜像
```bash
docker model pull ai/llama3.3
```

#### 2. 运行模型
```bash
docker model run ai/llama3.3
```

有关 Docker Model Runner 的更多信息，请参阅 [官方文档](https://docs.docker.com/desktop/features/model-runner/)。


## 基准性能

| 类别         | 基准测试                  | Llama-3.3 70B 指令版 |
|--------------|--------------------------|----------------------|
| 通用能力     | MMLU (CoT)               | 86.0                 |
|              | MMLU Pro (CoT)           | 68.9                 |
| 可控性       | IFEval                   | 92.1                 |
| 推理能力     | GPQA Diamond (CoT)       | 50.5                 |
| 代码能力     | HumanEval                | 88.4                 |
|              | MBPP EvalPlus (base)     | 87.6                 |
| 数学能力     | MATH (CoT)               | 77.0                 |
| 工具使用     | BFCL v2                  | 77.3                 |
| 多语言能力   | MGSM                     | 91.1                 |


## 链接
- [Meta Llama 3 发布：迄今为止能力最强的开源LLM](https://ai.meta.com/blog/meta-llama-3/)
- [Llama 3 模型集群](https://arxiv.org/pdf/2407.21783)
