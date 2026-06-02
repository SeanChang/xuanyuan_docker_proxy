---
image: ai/qwen3-coder
description: "Qwen3-Coder是Qwen推出的新一代智能编码代理模型系列。"
source: https://xuanyuan.cloud/zh/r/ai/qwen3-coder
canonical: https://xuanyuan.cloud/zh/r/ai/qwen3-coder
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ai/qwen3-coder" title="ai/qwen3-coder Docker 镜像中文简介、标签列表与拉取命令">ai/qwen3-coder — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ai/qwen3-coder" title="ai/qwen3-coder Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ai/qwen3-coder</a>

# Qwen3‑Coder‑30B‑A3B‑Instruct
*Unsloth 提供的 GGUF 版本*

![logo](https://github.com/docker/model-cards/raw/refs/heads/main/logos/qwen-280x184-overview@2x.svg)

开源智能编码模型，针对长上下文、指令跟随式代码生成和工具使用进行优化。

## 预期用途

轻量但强大的仓库级任务编码助手：

- **智能编码工作流**：通过平台集成（如 Qwen Code、CLINE）自动化多步骤代码任务。
- **浏览器使用场景**：驱动智能浏览器交互，用于搜索、数据抓取或 UI 自动化。
- **大型代码上下文理解**：原生支持高达 256K token 上下文（可通过 Yarn 扩展至约 100 万），处理仓库级文件。

## 特性

| 属性             | 详情                                                                 |
|------------------|----------------------------------------------------------------------|
| **提供方**       | Qwen / 阿里巴巴                                                      |
| **架构**         | MoE（混合专家模型，总参数量 305 亿，活跃参数量约 33 亿，128 个专家，8 个活跃） |
| **数据截止日期** | 2025年7月（模型于2025年8月发布）                                     |
| **支持语言**     | 多语言；超过100种口语和编程语言                                      |
| **工具调用**     | 支持                                                                 |
| **输入模态**     | 文本（代码+自然语言）                                                |
| **输出模态**     | 文本（代码+自然语言）                                                |
| **许可证**       | Apache‑2.0                                                           |

## 可用模型变体

| 模型变体 | 参数量 | 量化方式 | 上下文窗口 | 显存¹ | 大小    |
|----------|--------|----------|------------|-------|---------|
| `ai/qwen3-coder:30B-A3B-UD-Q4_K_XL`<br><br>`ai/qwen3-coder:latest` | 30B-A3B | MOSTLY_Q4_K_M | 262K tokens | 17.52 GiB | 16.45 GB |

¹: 显存基于模型特性估算。

> `latest` → `30B-A3B-UD-Q4_K_XL`

## 使用Docker Model Runner运行AI模型

首先拉取模型：

```bash
docker model pull ai/qwen3-coder:30B-A3B-UD-Q4_K_XL
```

然后运行模型：

```bash
docker model run ai/qwen3-coder:30B-A3B-UD-Q4_K_XL
```

有关Docker Model Runner的更多信息，请[查阅文档](https://docs.docker.com/desktop/features/model-runner/)。

## 链接

- [Hugging Face](https://huggingface.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF)
- [Unsloth Dynamic 2.0 GGUF](https://docs.unsloth.ai/basics/unsloth-dynamic-2.0-ggufs)
