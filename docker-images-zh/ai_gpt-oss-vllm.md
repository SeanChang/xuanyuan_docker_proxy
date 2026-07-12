---
image: ai/gpt-oss-vllm
description: "OpenAI的开源权重模型，专为强大的推理能力和代理任务设计，适用于多用途开发场景。"
source: https://xuanyuan.cloud/zh/r/ai/gpt-oss-vllm
canonical: https://xuanyuan.cloud/zh/r/ai/gpt-oss-vllm
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ai/gpt-oss-vllm" title="ai/gpt-oss-vllm Docker 镜像中文简介、标签列表与拉取命令">ai/gpt-oss-vllm 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# GPT‑OSS

欢迎使用gpt-oss系列，这是OpenAI的开源权重模型，旨在提供强大的推理能力、代理任务支持和多用途开发场景。

## 使用Docker Model Runner运行模型

运行模型：

```bash
docker model run ai/gpt-oss-vllm
```

## 核心特性

- **宽松的Apache 2.0许可证**：无需考虑copyleft限制或专利风险，可自由构建，非常适合实验、定制和商业部署。
- **可配置推理强度**：可根据具体使用场景和延迟需求轻松调整推理强度（低、中、高）。
- **完整思维链**：完全访问模型的推理过程，便于调试并增强对输出结果的信任（不建议向终端用户展示）。
- **可微调**：通过参数微调，可针对特定使用场景完全定制模型。
- **代理能力**：利用模型原生功能支持函数调用、网页浏览、Python代码执行和结构化输出。
- **MXFP4量化**：模型通过MoE权重的MXFP4量化进行后训练，使gpt-oss-120b可在单张80GB GPU（如NVIDIA H100或AMD MI300X）上运行，gpt-oss-20b模型可在16GB内存内运行。所有评估均使用相同的MXFP4量化。

## 注意事项

- 不支持思维链（CoT）和工具调用

## 相关链接

- [Hugging Face模型](https://huggingface.co/openai/gpt-oss-20b)
- [OpenAI公告](https://openai.com/index/introducing-gpt-oss/)
