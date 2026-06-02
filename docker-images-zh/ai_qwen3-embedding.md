---
image: ai/qwen3-embedding
description: "Qwen3 Embedding是Qwen系列最新专有模型，专为文本嵌入和排序任务设计，支持119种语言，提供0.6B、4B、8B等多种尺寸模型，适用于文本检索、代码检索、分类、聚类、平行文本挖掘等高级任务。"
source: https://xuanyuan.cloud/zh/r/ai/qwen3-embedding
canonical: https://xuanyuan.cloud/zh/r/ai/qwen3-embedding
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ai/qwen3-embedding" title="ai/qwen3-embedding Docker 镜像中文简介、标签列表与拉取命令">ai/qwen3-embedding — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ai/qwen3-embedding" title="ai/qwen3-embedding Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ai/qwen3-embedding</a>

# Qwen3-Embedding

![logo](https://github.com/docker/model-cards/raw/refs/heads/main/logos/qwen-280x184-overview@2x.svg)

Qwen3 Embedding模型系列是Qwen家族的最新专有模型，专为文本嵌入和排序任务设计。该系列基于Qwen3系列的密集基础模型构建，提供多种尺寸（0.6B、4B和8B）的文本嵌入和重排序模型。它继承了基础模型卓越的多语言能力、长文本理解和推理能力，在文本检索、代码检索、文本分类、文本聚类、平行文本挖掘等多种文本嵌入和排序任务上取得了显著进步。

---

## 📌 特性

| 属性                 | 值                                                                                                                                                                                                 |
|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **提供商**           | 阿里云                                                                                                                                                                                           |
| **架构**             | qwen3                                                                                                                                                                                           |
| **支持语言**         | 119种来自多个语系的语言（印欧语系、汉藏语系、亚非语系、南岛语系、达罗毗荼语系、突厥语系、侗台语系、乌拉尔语系、南亚语系），包括日语、巴斯克语、海地语等其他语言                                                                                                      |
| **工具调用能力**     | ❌                                                                                                                                                                                                |
| **输入模态**         | 文本                                                                                                                                                                                             |
| **输出模态**         | 文本嵌入                                                                                                                                                                                           |
| **许可证**           | Apache 2.0                                                                                                                                                                                      |

---


## 可用模型变体

| 模型变体 | 参数量 | 量化方式 | 上下文窗口 | 显存¹ | 大小 |
|----------|--------|----------|------------|------|------|
| `ai/qwen3-embedding:4B`<br><br>`ai/qwen3-embedding:4B-Q4_K_M`<br><br>`ai/qwen3-embedding:latest` | 4B | MOSTLY_Q4_K_M | 41K tokens | 3.75 GiB | 2.32 GB |
| `ai/qwen3-embedding:0.6B-F16` | 0.6B | MOSTLY_F16 | 33K tokens | 2.27 GiB | 1.11 GB |
| `ai/qwen3-embedding:4B-F16` | 4B | MOSTLY_F16 | 41K tokens | 8.92 GiB | 7.49 GB |
| `ai/qwen3-embedding:8B-Q4_K_M` | 8B | MOSTLY_Q4_K_M | 41K tokens | 5.80 GiB | 4.35 GB |
| `ai/qwen3-embedding:8B-F16` | 8B | MOSTLY_F16 | 41K tokens | 15.54 GiB | 14.10 GB |

¹: 显存基于模型特性估算。

> `latest` → `4B`

---

## 🐳 使用Docker Model Runner

首先，拉取模型：

```bash
docker model pull ai/qwen3-embedding
```

然后运行模型：

```bash
curl --location 'http://localhost:12434/engines/llama.cpp/v1/embeddings' \
--header 'Content-Type: application/json' \
--data '{
    "model": "ai/qwen3-embedding",
    "input": "hello world!"
  }'
```

更多信息，请查看 [Docker Model Runner 文档](https://docs.docker.com/desktop/features/model-runner/)。

---

### MTEB（多语言）评测结果

| 模型                          | 大小 | 任务均值 | 类型均值 | 平行文本挖掘 | 分类 | 聚类 | Inst. | 检索 | 多分类 | 配对分类 | 重排序检索 | STS  |
|-------------------------------|------|----------|----------|--------------|------|------|-------|------|--------|----------|------------|------|
| NV-Embed-v2                   | 7B   | 56.29    | 49.58    | 57.84        | 57.29 | 40.80 | 1.04  | 18.63 | 78.94   | 63.82     | 56.72      | 71.10 |
| GritLM-7B                     | 7B   | 60.92    | 53.74    | 70.53        | 61.83 | 49.75 | 3.45  | 22.77 | 79.94   | 63.78     | 58.31      | 73.33 |
| BGE-M3                        | 0.6B | 59.56    | 52.18    | 79.11        | 60.35 | 40.88 | -3.11 | 20.1  | 80.76   | 62.79     | 54.60      | 74.12 |
| multilingual-e5-large-instruct | 0.6B | 63.22    | 55.08    | 80.13        | 64.94 | 50.75 | -0.40 | 22.91 | 80.86   | 62.61     | 57.12      | 76.81 |
| gte-Qwen2-1.5B-instruct       | 1.5B | 59.45    | 52.69    | 62.51        | 58.32 | 52.05 | 0.74  | 24.02 | 81.58   | 62.58     | 60.78      | 71.61 |
| gte-Qwen2-7B-Instruct         | 7B   | 62.51    | 55.93    | 73.92        | 61.55 | 52.77 | 4.94  | 25.48 | 85.13   | 65.55     | 60.08      | 73.98 |
| text-embedding-3-large        | –    | 58.93    | 51.41    | 62.17        | 60.27 | 46.89 | -2.68 | 22.03 | 79.17   | 63.89     | 59.27      | 71.68 |
| Cohere-embed-multilingual-v3.0 | –    | 61.12    | 53.23    | 70.50        | 62.95 | 46.89 | -1.89 | 22.74 | 79.88   | 64.07     | 59.16      | 74.80 |
| gemini-embedding-exp-03-07    | –    | 68.37    | 59.59    | 79.28        | 71.82 | 54.59 | 5.18  | 29.16 | 83.63   | 65.58     | 67.71      | 79.40 |
| **Qwen3-Embedding-0.6B**      | 0.6B | 64.33    | 56.00    | 72.22        | 66.83 | 52.33 | 5.09  | 24.59 | 80.83   | 61.41     | 64.64      | 76.17 |
| **Qwen3-Embedding-4B**        | 4B   | 69.45    | 60.86    | 79.36        | 72.33 | 57.15 | 11.56 | 26.77 | 85.05   | 65.08     | 69.60      | 80.86 |
| **Qwen3-Embedding-8B**        | 8B   | 70.58    | 61.69    | 80.89        | 74.00 | 57.65 | 10.06 | 28.66 | 86.40   | 65.63     | 70.88      | 81.08 |

> 注：对比模型的分数取自2025年5月24日的MTEB在线排行榜。

---

## 🔗 链接

- [Qwen3-Embedding 0.6B](https://huggingface.co/Qwen/Qwen3-Embedding-0.6B-GGUF)
- [Qwen3-Embedding 4B](https://huggingface.co/Qwen/Qwen3-Embedding-4B-GGUF)
- [Qwen3-Embedding 8B](https://huggingface.co/Qwen/Qwen3-Embedding-8B-GGUF)
