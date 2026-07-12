---
image: ai/smollm2
description: "为速度、边缘设备和本地开发构建的小型语言模型"
source: https://xuanyuan.cloud/zh/r/ai/smollm2
canonical: https://xuanyuan.cloud/zh/r/ai/smollm2
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ai/smollm2" title="ai/smollm2 Docker 镜像中文简介、标签列表与拉取命令">ai/smollm2 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# SmolLM2

![logo](https://github.com/docker/model-cards/raw/refs/heads/main/logos/hugginfface-280x184-overview@2x.svg)

SmolLM2-360M 是一款拥有 3.6 亿参数的紧凑型语言模型，设计用于在设备端高效运行，同时执行广泛的语言任务。它在 4 万亿 tokens 的多样化数据集（包括 FineWeb-Edu、DCLM、The Stack 以及新整理的过滤数据源）上训练而成，在指令遵循、知识掌握和推理能力方面表现出色。指令版本通过在公共和专有数据集混合集上进行监督微调（SFT）开发，随后使用 UltraFeedback 进行直接偏好优化（DPO）。

## 预期用途

SmolLM2 设计用于：

- **聊天助手**
- **文本提取**
- **重写和摘要**

## 特性

| 属性             | 详情           |
|------------------|----------------|
| **提供商**       | Hugging Face   |
| **架构**         | Llama2         |
| **数据截止日期** | 2024年6月      |
| **支持语言**     | 英语           |
| **工具调用**     | ✅             |
| **输入模态**     | 文本           |
| **输出模态**     | 文本           |
| **许可证**       | [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) |


## 可用模型变体

| 模型变体 | 参数 | 量化方式 | 上下文窗口 | 显存¹ | 大小 |
|----------|------|----------|------------|------|------|
| `ai/smollm2:latest`<br><br>`ai/smollm2:360M-Q4_K_M` | 3.6亿 | IQ2_XXS/Q4_K_M | 8K tokens | 0.63 GiB | 256.35 MB |
| `ai/smollm2:135M-Q4_0` | 1.35亿 | Q4_0 | 8K tokens | 0.35 GiB | 85.77 MB |
| `ai/smollm2:135M-Q4_K_M` | 1.35亿 | IQ2_XXS/Q4_K_M | 8K tokens | 0.36 GiB | 98.87 MB |
| `ai/smollm2:135M-F16` | 1.35亿 | F16 | 8K tokens | 0.51 GiB | 256.63 MB |
| `ai/smollm2:135M-Q2_K` | 1.35亿 | Q2_K | 8K tokens | 0.34 GiB | 82.41 MB |
| `ai/smollm2:360M-Q4_0` | 3.6亿 | Q4_0 | 8K tokens | 0.59 GiB | 216.80 MB |
| `ai/smollm2:360M-Q4_K_M` | 3.6亿 | IQ2_XXS/Q4_K_M | 8K tokens | 0.63 GiB | 256.35 MB |
| `ai/smollm2:360M-F16` | 3.6亿 | F16 | 8K tokens | 1.06 GiB | 690.24 MB |

¹: 显存基于模型特性估算。

> `latest` → `360M-Q4_K_M`

## 使用Docker Model Runner运行此AI模型

首先，拉取模型：

```bash
docker model pull ai/smollm2
```

然后运行模型：

```bash
docker model run ai/smollm2
```

有关Docker Model Runner的更多信息，请[查阅文档](https://docs.docker.com/desktop/features/model-runner/)。

## 基准性能

| 类别                     | 基准测试                   | 得分 |
|--------------------------|----------------------------|------|
| 推理                     | HellaSwag                  | 54.5 |
| 科学                     | OpenBookQA                 | 37.4 |
|                          | ARC                        | 53.0 |
| 推理                     | PIQA                       | 71.7 |
|                          | CommonsenseQA              | 38.0 |
|                          | Winogrande                 | 52.5 |
| 热门综合基准测试         | MMLU (完形填空)            | 35.8 |
|                          | TriviaQA (保留集)          | 16.9 |
| 数学                     | GSM8K (5次示例)            | 3.2  |


## 链接

- [SmolLM2：当小型模型走向强大——小型语言模型的数据中心训练](https://arxiv.org/abs/2502.02737)
