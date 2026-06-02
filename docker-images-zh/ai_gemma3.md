---
image: ai/gemma3
description: "Google最新推出的AI模型Gemma，虽体型小巧却性能强劲，尤其在聊天交互与内容生成领域表现突出；其轻量化设计不仅便于高效部署，还能在保证响应速度的同时，持续输出高质量内容，为用户带来便捷且智能的使用体验，是一款兼顾小巧体型与强大功能的新一代AI模型。"
source: https://xuanyuan.cloud/zh/r/ai/gemma3
canonical: https://xuanyuan.cloud/zh/r/ai/gemma3
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ai/gemma3" title="ai/gemma3 Docker 镜像中文简介、标签列表与拉取命令">ai/gemma3 — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ai/gemma3" title="ai/gemma3 Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ai/gemma3</a>

# Gemma 3（Unsloth GGUF版本）

![logo]([])

Gemma是一个多用途AI模型系列，适用于问答、摘要生成、推理等任务。该模型提供开放权重，支持负责任的商业使用，可处理图文输入，上下文长度达128K tokens，覆盖140多种语言。


## 适用场景

Gemma 3 4B模型可用于以下场景：

- **文本生成**：创作诗歌、脚本、代码、营销文案及邮件草稿。  
- **聊天机器人与对话AI**：开发虚拟助手、客服机器人等交互系统。  
- **文本摘要**：生成报告、研究论文的简洁摘要。  
- **图像数据提取**：解析视觉数据并转化为文本形式输出。  
- **语言学习工具**：辅助语法纠错、交互式写作练习。  
- **知识探索**：为研究者生成内容摘要、解答专业问题。  


## 模型特性

| 属性             | 详情                                          |
|------------------|-----------------------------------------------|
| **提供商**       | Google DeepMind                               |
| **架构**         | Gemma3                                        |
| **数据截止日期** | -                                             |
| **支持语言**     | 140种语言                                     |
| **工具调用**     | ❌                                             |
| **输入模态**     | 文本、图像                                    |
| **输出模态**     | 文本、代码                                    |
| **许可证**       | [Gemma使用条款]([]) |


## 可用模型变体

| 模型变体 | 参数规模 | 量化方式 | 上下文窗口 | 显存需求¹ | 文件大小 |
|----------|----------|----------|------------|-----------|----------|
| `ai/gemma3:4B`<br><br>`ai/gemma3:4B-Q4_K_M`<br><br>`ai/gemma3:latest` | 4B | MOSTLY_Q4_K_M | 131K tokens | 3.83 GiB | 2.31 GB |
| `ai/gemma3:270M-F16` | 270M | MOSTLY_F16 | 33K tokens | 1.59 GiB | 511.46 MB |
| `ai/gemma3:270M-UD-IQ2_XXS` | 270M | MOSTLY_IQ2_XXS | 33K tokens | 1.26 GiB | 165.54 MB |
| `ai/gemma3:270M-UD-Q4_K_XL` | 270M | MOSTLY_Q4_K_M | 33K tokens | 1.33 GiB | 235.95 MB |
| `ai/gemma3:4B-F16` | 4B | MOSTLY_BF16 | 131K tokens | 8.75 GiB | 7.23 GB |

¹：显存需求基于模型特性估算。  

> `latest` → `4B`（`latest`标签默认指向4B版本）


## 使用Docker Model Runner运行模型

### 步骤1：拉取模型  
```bash
docker model pull ai/gemma3
```

### 步骤2：运行模型  
```bash
docker model run ai/gemma3
```

更多关于Docker Model Runner的说明，可参考[官方文档]([])。


## 基准性能测试

| 类别         | 评测基准          | 得分  |
|--------------|-------------------|-------|
| **通用能力** | MMLU              | 59.6  |
|              | GSM8K             | 38.4  |
|              | ARC-Challenge     | 56.2  |
|              | BIG-Bench Hard    | 50.9  |
|              | DROP              | 60.1  |
| **STEM与代码** | MATH              | 24.2  |
|              | MBPP              | 46.0  |
|              | HumanEval         | 36.0  |
| **多语言能力** | MGSM              | 34.7  |
|              | Global-MMLU-Lite  | 57.0  |
|              | XQuAD (all)       | 68.0  |
| **多模态能力** | VQAv2             | 63.9  |
|              | TextVQA           | 58.9  |
|              | DocVQA            | 72.8  |


## 相关链接  
- [Gemma 3模型概述]([])  
- [Gemma 3技术报告]([])  
- [Unsloth Dynamic 2.0 GGUF格式说明]([])
