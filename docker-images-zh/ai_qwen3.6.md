---
image: ai/qwen3.6
description: "具备35B混合专家(MoE)架构的多模态AI模型，专注于编码代理、推理和视觉任务，支持262K原生上下文长度（可扩展至100万+ tokens），为软件工程和多模态应用提供高效开发体验。"
source: https://xuanyuan.cloud/zh/r/ai/qwen3.6
canonical: https://xuanyuan.cloud/zh/r/ai/qwen3.6
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ai/qwen3.6" title="ai/qwen3.6 Docker 镜像中文简介、标签列表与拉取命令">ai/qwen3.6 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Qwen3.6

![Qwen Logo](https://qianwen-res.oss-accelerate.aliyuncs.com/Qwen3.6/logo.png)

Qwen3.6-35B-A3B是阿里云Qwen团队开发的前沿多模态AI模型，在代理编码、推理保留和实际开发工作流方面实现了重大升级。该模型基于Qwen3.5系列发布后的社区反馈构建，注重稳定性和实用性，为开发者提供直观高效的编码体验，增强了前端工作流和仓库级推理能力。

本版本采用混合专家(MoE)架构，总参数350亿，激活参数30亿，支持文本和视觉输入。原生上下文长度达262,144 tokens（可扩展至100万+ tokens），能高效处理复杂的多轮交互。模型在SWE-bench Verified、Terminal-Bench等编码代理基准测试和Web开发任务中表现优异，特别适用于软件工程、代码生成和多模态应用场景。

核心创新包括跨迭代保留推理上下文的思维保留机制、改进的工具调用（支持更好的嵌套对象解析）以及增强的开发者角色支持。无论构建编码助手、多模态应用还是代理系统，Qwen3.6都能提供开源可访问的最先进性能。

---

## 特性参数

| 属性 | 数值 |
|---|---|
| **提供商** | 阿里云 / Qwen团队 |
| **架构** | Qwen3.5 MoE（混合专家） |
| **参数规模** | 总350亿，激活30亿 |
| **上下文长度** | 原生262,144 tokens，可扩展至1,010,000 tokens |
| **支持语言** | 多语言（英语、中文及其他） |
| **输入模态** | 文本、图像 |
| **输出模态** | 文本 |
| **许可证** | Apache 2.0 |

## 使用Docker Model Runner运行模型

```bash
docker model run qwen3.6
```

更多信息，请查看[Docker Model Runner文档](https://docs.docker.com/desktop/features/model-runner/)。

## 基准测试结果

![基准测试结果](https://qianwen-res.oss-cn-beijing.aliyuncs.com/Qwen3.6/Figures/qwen3.6_35b_a3b_score.png)

### 编码代理基准测试

| 基准测试 | Qwen3.5-27B | Gemma4-31B | Qwen3.5-35BA3B | Gemma4-26BA4B | **Qwen3.6-35BA3B** |
|---|---|---|---|---|---|
| SWE-bench Verified | 75.0 | 52.0 | 70.0 | 17.4 | **73.4** |
| SWE-bench 多语言 | 69.3 | 51.7 | 60.3 | 17.3 | **67.2** |
| SWE-bench Pro | 51.2 | 35.7 | 44.6 | 13.8 | **49.5** |
| Terminal-Bench 2.0 | 41.6 | 42.9 | 40.5 | 34.2 | **51.5** |
| Claw-Eval（平均） | 64.3 | 48.5 | 65.4 | 58.8 | **68.7** |
| Claw-Eval（Pass³） | 46.2 | 25.0 | 51.0 | 28.0 | **50.0** |
| SkillsBench（Avg5） | 27.2 | 23.6 | 4.4 | 12.3 | **28.7** |
| QwenClawBench | 52.2 | 41.7 | 47.7 | 38.7 | **52.6** |
| NL2Repo | 27.3 | 15.5 | 20.5 | 11.6 | **29.4** |
| QwenWebBench | 1068 | 1197 | 978 | 1178 | **1397** |

### 通用代理基准测试

| 基准测试 | Qwen3.5-27B | Gemma4-31B | Qwen3.5-35BA3B | Gemma4-26BA4B | **Qwen3.6-35BA3B** |
|---|---|---|---|---|---|
| TAU3-Bench | 68.4 | 67.5 | 68.9 | 59.0 | **67.2** |
| VITA-Bench | 41.8 | 43.0 | 29.1 | 36.9 | **35.6** |
| DeepPlanning | 22.6 | 24.0 | 22.8 | 16.2 | **25.9** |
| Tool Decathlon | 31.5 | 21.2 | 28.7 | 12.0 | **26.9** |
| MCPMark | 36.3 | 18.1 | 27.0 | 14.2 | **37.0** |
| MCP-Atlas | 68.4 | 57.2 | 62.4 | 50.0 | **62.8** |
| WideSearch | 66.4 | 35.2 | 59.1 | 38.3 | **60.1** |

### 知识基准测试

| 基准测试 | Qwen3.5-27B | Gemma4-31B | Qwen3.5-35BA3B | Gemma4-26BA4B | **Qwen3.6-35BA3B** |
|---|---|---|---|---|---|
| MMLU-Pro | 86.1 | 85.2 | 85.3 | 82.6 | **85.2** |
| MMLU-Redux | 93.2 | 93.7 | 93.3 | 92.7 | **93.3** |
| SuperGPQA | 65.6 | 65.7 | 63.4 | 61.4 | **64.7** |
| C-Eval | 90.5 | 82.6 | 90.2 | 82.5 | **90.0** |

### STEM与推理基准测试

| 基准测试 | Qwen3.5-27B | Gemma4-31B | Qwen3.5-35BA3B | Gemma4-26BA4B | **Qwen3.6-35BA3B** |
|---|---|---|---|---|---|
| GPQA | 85.5 | 84.3 | 84.2 | 82.3 | **86.0** |
| HLE | 24.3 | 19.5 | 22.4 | 8.7 | **21.4** |
| LiveCodeBench v6 | 80.7 | 80.0 | 74.6 | 77.1 | **80.4** |
| HMMT Feb 25 | 92.0 | 88.7 | 89.0 | 91.7 | **90.7** |
| HMMT Nov 25 | 89.8 | 87.5 | 89.2 | 87.5 | **89.1** |
| HMMT Feb 26 | 84.3 | 77.2 | 78.7 | 79.0 | **83.6** |
| IMOAnswerBench | 79.9 | 74.5 | 76.8 | 74.3 | **78.9** |
| AIME26 | 92.6 | 89.2 | 91.0 | 88.3 | **92.7** |

### 视觉语言基准测试

| 基准测试 | Qwen3.5-27B | Claude-Sonnet-4.5 | Gemma4-31B | Gemma4-26BA4B | Qwen3.5-35BA3B | **Qwen3.6-35BA3B** |
|---|---|---|---|---|---|---|
| MMMU | 82.3 | 79.6 | 80.4 | 78.4 | 81.4 | **81.7** |
| MMMU-Pro | 75.0 | 68.4 | 76.9 | 73.8 | 75.1 | **75.3** |
| MathVista (mini) | 87.8 | 79.8 | 87.5 | 86.3 | 87.1 | **87.6** |
| MathVision | 32.4 | 31.5 | 29.7 | 24.8 | 32.0 | **33.3** |
| AI2D | 98.0 | 96.2 | 98.0 | 97.2 | 97.8 | **98.1** |

## 相关链接

- [Hugging Face模型 (GGUF格式)](https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF)
- [Qwen博客：Qwen3.6-35B-A3B](https://qwen.ai/blog?id=qwen3.6)
- [Qwen官方GitHub](https://github.com/QwenLM/Qwen)
- [Qwen文档](https://qwen.readthedocs.io/)

## 注意事项

- **硬件要求**：由于采用350亿参数的MoE架构，高效运行模型需要足够的GPU内存。GGUF量化版本可降低内存需求同时保持性能。
- **上下文窗口**：原生上下文长度为262K tokens，但在极端长度下性能可能有所变化。对于大多数应用，原生262K上下文已能提供出色性能。
- **多模态能力**：模型支持文本和图像输入。视觉功能需要相应的多模态投影文件（mmproj文件有GGUF格式可用）。
- **工具调用**：Qwen3.6包含改进的工具调用支持，能更好地处理嵌套对象。为获得最佳工具使用效果，请遵循文档中的聊天模板格式。
- **开发者角色支持**：模型增强了对开发者角色的支持，特别适用于编码助手和代理工作流。
- **思维保留**：在使用模型进行迭代开发时，启用思维保留功能可跨多轮保持推理上下文。

### 生成工具
本模型卡片由[cagent-action](https://github.com/docker/cagent-action)自动生成。
想了解更多关于Docker Model Runner的信息？查看项目仓库：[https://github.com/docker/model-runner](https://github.com/docker/model-runner)。
