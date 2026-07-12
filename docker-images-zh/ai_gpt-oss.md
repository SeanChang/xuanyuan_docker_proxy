---
image: ai/gpt-oss
description: "OpenAI的开源权重模型系列，设计用于强大的推理、代理任务和多用途开发场景，提供多种量化版本以适应不同资源需求。"
source: https://xuanyuan.cloud/zh/r/ai/gpt-oss
canonical: https://xuanyuan.cloud/zh/r/ai/gpt-oss
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ai/gpt-oss" title="ai/gpt-oss Docker 镜像中文简介、标签列表与拉取命令">ai/gpt-oss 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# GPT‑OSS
*Unsloth的GGUF版本*

欢迎使用gpt-oss系列，这是OpenAI的开源权重模型，专为强大的推理、代理任务和多用途开发场景设计。

## 可用模型变体

| 模型变体 | 参数规模 | 量化方式 | 上下文窗口 | 显存¹ | 大小 |
|---------------|------------|--------------|----------------|------|-------|
| `ai/gpt-oss:latest`<br><br>`ai/gpt-oss:20B-UD-Q4_K_XL` | 200亿 | MOSTLY_Q4_K_M | 131K tokens | 11.97 GiB | 11.04 GB |
| `ai/gpt-oss:20B-F16` | 200亿 | MOSTLY_F16 | 131K tokens | 13.25 GiB | 12.83 GB |
| `ai/gpt-oss:20B-UD-Q4_K_XL` | 200亿 | MOSTLY_Q4_K_M | 131K tokens | 11.97 GiB | 11.04 GB |
| `ai/gpt-oss:20B-UD-Q6_K_XL` | 200亿 | MOSTLY_Q6_K | 131K tokens | 12.12 GiB | 11.20 GB |
| `ai/gpt-oss:20B-UD-Q8_K_XL` | 200亿 | MOSTLY_Q8_0 | 131K tokens | 12.69 GiB | 12.28 GB |

¹：显存基于模型特性估算。

> `latest` → `20B-UD-Q4_K_XL`

## 使用场景与适用范围
适用于需要本地部署开源大模型进行推理任务、代理应用开发及多用途AI功能集成的开发场景，支持不同显存配置需求的环境。

## 使用Docker Model Runner运行模型

运行模型：

```bash
docker model run ai/gpt-oss
```

## 注意事项
- 请注意当前版本仍存在响应解析问题
- 不支持思维链（CoT）和工具调用

## 链接
- [Hugging Face模型](https://huggingface.co/openai/gpt-oss-20b)
- [OpenAI公告](https://openai.com/index/introducing-gpt-oss/)
- [Unsloth Dynamic 2.0 GGUF](https://docs.unsloth.ai/basics/unsloth-dynamic-2.0-ggufs)
