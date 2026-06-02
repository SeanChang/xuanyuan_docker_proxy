---
image: ai/qwen3-vl
description: "Qwen系列迄今最强大的视觉语言模型，全面升级文本理解生成、视觉感知推理、上下文长度、空间和视频动态理解能力，具备视觉代理、视觉编码增强、高级空间感知等核心特性。"
source: https://xuanyuan.cloud/zh/r/ai/qwen3-vl
canonical: https://xuanyuan.cloud/zh/r/ai/qwen3-vl
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ai/qwen3-vl" title="ai/qwen3-vl Docker 镜像中文简介、标签列表与拉取命令">ai/qwen3-vl — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ai/qwen3-vl" title="ai/qwen3-vl Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ai/qwen3-vl</a>

# Qwen3 VL
*Unsloth提供的GGUF版本*

![logo](https://github.com/docker/model-cards/raw/refs/heads/main/logos/qwen-280x184-overview@2x.svg)

Qwen3-VL——Qwen系列迄今最强大的视觉语言模型。

本代模型实现全面升级：卓越的文本理解与生成、更深入的视觉感知与推理、更长的上下文长度、增强的空间和视频动态理解能力，以及更强的智能体交互能力。

核心增强：
- **视觉代理**：操作电脑/移动设备图形界面——识别元素、理解功能、调用工具、完成任务。
- **视觉编码增强**：从图像/视频生成Draw.io/HTML/CSS/JS代码。
- **高级空间感知**：判断物体位置、视角和遮挡；提供更强的2D定位，并支持3D定位以实现空间推理和具身AI。
- **长上下文与视频理解**：原生256K上下文，可扩展至1M；处理书籍和数小时长视频，具备完整回忆和秒级索引能力。
- **增强多模态推理**：在STEM/数学领域表现出色——支持因果分析和基于证据的逻辑答案。
- **升级视觉识别**：更广泛、更高质量的预训练使其能够“识别万物”——名人、动漫、产品、地标、动植物等。
- **扩展OCR**：支持32种语言（从19种扩展）：在低光、模糊和倾斜场景下表现稳健；对罕见/古文字和专业术语识别更优；改进长文档结构解析。
- **文本理解能力媲美纯语言模型**：无缝融合文本-视觉，实现无损统一理解。

---

## 模型架构更新：

![arc](https://github.com/docker/model-cards/raw/refs/heads/main/images/qwen3vl_arc.jpg)
1. **Interleaved-MRoPE**：通过稳健的位置嵌入在时间、宽度和高度上实现全频率分配，增强长时视频推理能力。
2. **DeepStack**：融合多级ViT特征，捕捉细粒度细节并增强图文对齐。
3. **文本-时间戳对齐**：超越T-RoPE，实现精确的时间戳定位事件，增强视频时间建模。

本仓库为Qwen3-VL-8B-Instruct的权重仓库。

---

## 可用模型变体

| 模型变体 | 参数 | 量化方式 | 上下文窗口 | 显存¹ | 大小 |
|---------------|------------|--------------|----------------|------|-------|
| `ai/qwen3-vl:8B`<br><br>`ai/qwen3-vl:8B-UD-Q4_K_XL`<br><br>`ai/qwen3-vl:latest` | 8B | MOSTLY_Q4_K_M | 262K tokens | 5.91 GiB | 4.79 GB |
| `ai/qwen3-vl:2B-BF16` | 2B | MOSTLY_BF16 | 262K tokens | 4.38 GiB | 3.21 GB |
| `ai/qwen3-vl:2B-Q8_K_XL` | 2B | MOSTLY_Q8_0 | 262K tokens | 3.34 GiB | 2.17 GB |
| `ai/qwen3-vl:2B-UD-Q4_K_XL` | 2B | MOSTLY_Q4_K_M | 262K tokens | 2.22 GiB | 1.05 GB |
| `ai/qwen3-vl:4B-Q8_K_XL` | 4B | MOSTLY_Q8_0 | 262K tokens | 6.13 GiB | 4.70 GB |
| `ai/qwen3-vl:8B-Q8_K_XL` | 8B | MOSTLY_Q8_0 | 262K tokens | 10.36 GiB | 10.08 GB |
| `ai/qwen3-vl:32B-Q8_K_XL` | 32B | MOSTLY_Q8_0 | 262K tokens | 37.46 GiB | 36.76 GB |
| `ai/qwen3-vl:32B-UD-Q4_K_XL` | 32B | MOSTLY_Q4_K_M | 262K tokens | 20.41 GiB | 18.67 GB |
| `ai/qwen3-vl:4B-BF16` | 4B | MOSTLY_BF16 | 262K tokens | 8.92 GiB | 7.49 GB |
| `ai/qwen3-vl:8B-BF16` | 8B | MOSTLY_BF16 | 262K tokens | 15.54 GiB | 15.26 GB |

¹：显存基于模型特性估算。

> `latest` → `8B`

## 🐳 使用Docker Model Runner运行模型

运行模型：

```bash
docker model run ai/qwen3-vl
```

更多信息，请查看[Docker Model Runner文档](https://docs.docker.com/desktop/features/model-runner/)。

---

## 🔗 链接

- [Qwen3-VL](https://github.com/QwenLM/Qwen3-VL)
- [Unsloth Dynamic 2.0 GGUF](https://docs.unsloth.ai/basics/unsloth-dynamic-2.0-ggufs)
- [如何微调](https://docs.unsloth.ai/models/qwen3-vl-run-and-fine-tune)
