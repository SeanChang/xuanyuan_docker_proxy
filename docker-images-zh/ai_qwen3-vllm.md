---
image: ai/qwen3-vllm
description: "Qwen3是最新一代Qwen大语言模型，专为顶级编码、数学、推理和语言任务设计，支持密集型和混合专家模型架构，提供动态推理模式切换，适用于多语言多领域应用。"
source: https://xuanyuan.cloud/zh/r/ai/qwen3-vllm
canonical: https://xuanyuan.cloud/zh/r/ai/qwen3-vllm
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ai/qwen3-vllm" title="ai/qwen3-vllm Docker 镜像中文简介、标签列表与拉取命令">ai/qwen3-vllm — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ai/qwen3-vllm" title="ai/qwen3-vllm Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ai/qwen3-vllm</a>

# Qwen3

![logo](https://github.com/docker/model-cards/raw/refs/heads/main/logos/qwen-280x184-overview@2x.svg)

Qwen3是Qwen大语言模型家族的最新一代，旨在在编码、数学、推理和语言任务中提供顶级性能。它包含密集型和混合专家（MoE）模型，支持从轻型应用到大规模研究的灵活部署。

Qwen3引入双推理模式——"思考"模式用于复杂任务，"非思考"模式用于快速响应，为用户提供动态性能控制。它在推理、指令遵循和代码生成方面优于前代模型，同时在创意写作和对话方面表现出色。

凭借强大的代理和工具使用能力以及对100多种语言的支持，Qwen3针对多语言、多领域应用进行了优化。

## 📌 特性

| 属性 | 值 |
|-----------------------|-------------------|
| **提供商** | 阿里云 |
| **架构** | qwen3 |
| **数据截止日期** | 2025年4月（预计） |
| **支持语言** | 119种不同语系语言（印欧语系、汉藏语系、闪含语系、南岛语系、达罗毗荼语系、突厥语系、侗台语系、乌拉尔语系、南亚语系），包括日语、巴斯克语、海地语等 |
| **工具调用** | ✅ |
| **输入模态** | 文本 |
| **输出模态** | 文本 |
| **许可证** | Apache 2.0 |

## 🧠 预期用途

Qwen3-8B适用于广泛的高级自然语言处理任务：

- 支持**密集型和混合专家（MoE）** 模型架构，提供多种尺寸选择，包括0.6B、1.7B、4B、8B、14B、32B以及大型MoE变体（如30B-A3B和235B-A22B）。
- 支持**思考与非思考模式无缝切换**：
  - *思考模式*：针对复杂逻辑推理、数学和代码生成优化。
  - *非思考模式*：针对高效、通用对话和聊天优化。
- **推理性能显著提升**，在数学、代码生成和常识推理基准测试中优于前代QwQ（思考模式）和Qwen2.5-Instruct（非思考模式）模型。
- **卓越的人类对齐能力**，在以下方面表现突出：创意写作、角色扮演、多轮对话、沉浸式对话指令遵循。
- 强大的**代理能力**，包括：外部工具集成，以及在思考和非思考模式下复杂基于代理的工作流中的最佳性能。
- 支持**100多种语言和方言**，具备强大的多语言指令遵循和翻译能力。

## 注意事项

- **思考模式切换**  
  Qwen3支持通过`/think`和`/no_think`提示词进行软切换（当`enable_thinking=True`时）。这允许在多轮对话中动态控制模型的推理深度。
- **使用Qwen-Agent进行工具调用**  
  对于代理任务，使用**Qwen-Agent**，它通过内置模板和解析器简化外部工具集成，减少手动工具调用处理需求。
> **注意**：Qwen3模型采用新命名约定：后训练模型不再包含`-Instruct`后缀（例如，`Qwen3-32B`替代`Qwen2.5-32B-Instruct`），基础模型现在以`-Base`结尾。

## 🐳 使用Docker Model Runner运行模型

首先拉取模型：

```bash
docker model pull ai/qwen3-vllm
```

然后运行模型：

```bash
docker model run ai/qwen3-vllm
```

更多信息，请查看[Docker Model Runner文档](https://docs.docker.com/desktop/features/model-runner/)。

## 基准测试

| 类别 | 基准测试 | Qwen3 |
|-----------------------------|------------|-------|
| 通用任务 | MMLU | 87.81 |
|  | MMLU-Redux | 87.40 |
|  | MMLU-Pro | 68.18 |
|  | SuperGPQA | 44.06 |
|  | BBH | 88.87 |
| 数学与科学任务 | GPQA | 47.47 |
|  | GSM8K | 94.39 |
|  | MATH | 71.84 |
| 多语言任务 | MGSM | 83.53 |
|  | MMMLU | 86.70 |
|  | INCLUDE | 73.46 |
| 代码任务 | EvalPlus | 77.60 |
|  | MultiPL-E | 65.94 |
|  | MBPP | 81.40 |
|  | CRUX-O | 79.00 |

## 🔗 链接

- [Qwen3: Think Deeper, Act Faster](https://qwenlm.github.io/blog/qwen3/)
