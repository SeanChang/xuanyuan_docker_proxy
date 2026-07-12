---
image: ai/granite-docling
description: "Granite Docling是一个多模态图文转文本模型，专为高效文档转换设计，保留Docling核心功能并与Docling Documents无缝集成。"
source: https://xuanyuan.cloud/zh/r/ai/granite-docling
canonical: https://xuanyuan.cloud/zh/r/ai/granite-docling
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ai/granite-docling" title="ai/granite-docling Docker 镜像中文简介、标签列表与拉取命令">ai/granite-docling 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Granite Docling

![logo](https://github.com/docker/model-cards/raw/refs/heads/main/logos/ibm-280x184-overview.svg)

## 概述

Granite Docling是一个多模态图文转文本模型，专为高效文档转换设计。它保留了Docling的核心功能，同时与[Docling Documents](https://docling-project.github.io/docling)无缝集成，确保完全兼容。

## 核心特性

| 属性             | 详情                                                                             |
|------------------|----------------------------------------------------------------------------------|
| **提供商**       | IBM Research                                                                     |
| **架构**         | 基于Idefics2-8B；视觉编码器=siglip-base-patch16-512；LLM=Granite 165M            |
| **数据截止日期** | -                                                                                |
| **支持语言**     | 英语（对日语、阿拉伯语、中文提供实验性支持）                                      |
| **工具调用**     | ❌                                                                                |
| **输入模态**     | 文本、图像                                                                       |
| **输出模态**     | 文本                                                                             |
| **许可证**       | [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0)                        |

## 可用模型变体

| 模型变体                                                                                         | 参数规模 | 量化方式   | 上下文窗口  | 显存¹    | 大小      |
|--------------------------------------------------------------------------------------------------|----------|------------|-------------|----------|-----------|
| `ai/granite-docling:258M`<br><br>`ai/granite-docling:258M-F16`<br><br>`ai/granite-docling:latest` | 258M     | MOSTLY_F16 | 8K tokens   | 0.86 GiB | 312.88 MB |
| `ai/granite-docling:258M-Q8_0`                                                                   | 258M     | MOSTLY_Q8_0| 8K tokens   | 0.72 GiB | 166.28 MB |

¹：显存基于模型特性估算。

> `latest` → `258M`

## 使用方法

通过Docker Model Runner使用该AI模型：

```bash
docker model run ai/granite-docling
```

## 注意事项

- 最适合文档转换和提取工作流（PDF→Markdown/HTML/结构化输出）。
- 建议通过Docling库或SDK使用，以获得最佳集成和推理稳定性。
- 原生支持英语；对日语、阿拉伯语和中文的支持为实验性。

Granite-Docling-258M注重布局保真度和内容完整性，而非创造性或开放式生成。它基于Apache 2.0许可证发布，与Docling生态系统无缝集成，适用于结构化文档AI工作流。

## 链接

- https://huggingface.co/ibm-granite/granite-docling-258M
- https://huggingface.co/ggml-org/granite-docling-258M-GGUF
