---
image: ai/deepseek-v3.2-vllm
description: "DeepSeek-V3.2通过DeepSeek稀疏注意力(DSA)、可扩展强化学习框架和大规模智能体任务合成管道提升计算效率与推理能力，荣获2025年国际数学奥林匹克(IMO)和国际信息学奥林匹克(IOI)金牌。"
source: https://xuanyuan.cloud/zh/r/ai/deepseek-v3.2-vllm
canonical: https://xuanyuan.cloud/zh/r/ai/deepseek-v3.2-vllm
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ai/deepseek-v3.2-vllm" title="ai/deepseek-v3.2-vllm Docker 镜像中文简介、标签列表与拉取命令">ai/deepseek-v3.2-vllm — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ai/deepseek-v3.2-vllm" title="ai/deepseek-v3.2-vllm Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ai/deepseek-v3.2-vllm</a>

# DeepSeek-V3.2：高效推理与智能体AI

![logo](https://github.com/docker/model-cards/raw/refs/heads/main/logos/deepseek-280x184-overview@2x.svg)

我们推出DeepSeek-V3.2，这是一款兼顾高计算效率与卓越推理及智能体性能的模型。该模型基于三项关键技术突破构建：

1. **DeepSeek稀疏注意力(DSA)**：引入DSA这一高效注意力机制，在保持模型性能的同时大幅降低计算复杂度，专为长上下文场景优化。

2. **可扩展强化学习框架**：通过实施稳健的强化学习协议并扩展训练后计算量，DeepSeek-V3.2性能可与GPT-5媲美。值得注意的是，高计算量变体DeepSeek-V3.2-Speciale超越GPT-5，推理能力与Gemini-3.0-Pro相当。

3. **大规模智能体任务合成管道**：为将推理能力融入工具使用场景，我们开发了新型合成管道，可系统化生成大规模训练数据。这支持可扩展的智能体训练后优化，提升复杂交互式环境中的合规性与泛化能力。

**成就**：🥇 荣获2025年国际数学奥林匹克(IMO)和国际信息学奥林匹克(IOI)金牌。

![benchmark](https://huggingface.co/deepseek-ai/DeepSeek-V3.2/resolve/main/assets/benchmark.png)

## 使用Docker Model Runner运行此AI模型

```bash
docker model run deepseek-v3.2-vllm
```

有关Docker Model Runner的更多信息，请[查阅文档](https://docs.docker.com/desktop/features/model-runner/)。

## 使用提示

- 推荐参数值：temperature=1，top_p=0.95

## 链接
- https://huggingface.co/deepseek-ai/DeepSeek-V3.2
- https://github.com/deepseek-ai/DeepSeek-V3.2-Exp
