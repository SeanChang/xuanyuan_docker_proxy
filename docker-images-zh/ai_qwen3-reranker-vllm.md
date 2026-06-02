---
image: ai/qwen3-reranker-vllm
description: "多语言重排序模型，用于文本检索，可跨119种语言对文档相关性进行评分，基于Qwen3系列基础模型，具备多语言能力、长文本理解和推理技能。"
source: https://xuanyuan.cloud/zh/r/ai/qwen3-reranker-vllm
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[ai/qwen3-reranker-vllm](https://xuanyuan.cloud/zh/r/ai/qwen3-reranker-vllm)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Qwen3-Reranker

Qwen3 Embedding模型系列是Qwen家族的最新专有模型，专为文本嵌入和排序任务设计。基于Qwen3系列的密集基础模型，提供多种尺寸（0.6B、4B和8B）的文本嵌入和重排序模型。该系列继承了基础模型卓越的多语言能力、长文本理解和推理技能，在文本检索、代码检索、文本分类、文本聚类和双语文本挖掘等多个文本嵌入和排序任务中取得了显著进步。

## 📌 特性

| 属性             | 说明                                                                                                                                                                                                 |
|------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **提供商**       | 阿里云                                                                                                                                                                                                 |
| **架构**         | qwen3                                                                                                                                                                                                 |
| **支持语言**     | 119种不同语系语言（印欧语系、汉藏语系、闪含语系、南岛语系、达罗毗荼语系、突厥语系、壮侗语系、乌拉尔语系、南亚语系等），包括日语、巴斯克语、海地语等                                                                                                                               |
| **工具调用**     | ❌                                                                                                                                                                                                   |
| **输入模态**     | 文本                                                                                                                                                                                                 |
| **输出模态**     | 分数                                                                                                                                                                                                 |
| **许可证**       | Apache 2.0                                                                                                                                                                                           |

## 可用模型变体

| 模型变体 | 参数 | 量化 | 上下文窗口 | 显存¹ | 大小 |
|----------|------|------|------------|-------|------|
| `ai/qwen3-reranker-vllm:4B` <br><br> `ai/qwen3-reranker-vllm:latest` | 4B | F16 | 32K tokens | 8 GiB | 1.11 GB |
| `ai/qwen3-reranker-vllm:0.6B` | 0.6B | F16 | 32K tokens | 1.2 GiB | 2.32 GB |
| `ai/qwen3-reranker-vllm:8B` | 8B | F16 | 32K tokens | 16 GiB | 7.49 GB |

¹: 显存基于模型特性估算。

> `latest` → `4B`

## 🐳 使用Docker Model Runner运行模型

首先，拉取模型：

```bash
docker model pull ai/qwen3-reranker-vllm
```

然后运行模型：

### 重排序接口（rerank）
```bash
curl --location 'http://localhost:8080/engines/vllm/rerank' \
--header 'Content-Type: application/json' \
--data '{
  "model": "ai/qwen3-reranker-vllm:0.6B",
  "query": "法国的首都是哪里？",
  "documents": [
    "巴西的首都是巴西利亚。",
    "法国的首都是巴黎。",
    "马和牛都是动物。"
  ]
}'
```

### 评分接口（score）
```bash
curl --location 'http://localhost:8080/engines/vllm/score' \
--header 'Content-Type: application/json' \
--data '{
  "model": "ai/qwen3-reranker-vllm:0.6B",
  "text_1": "ping",
  "text_2": "pong"
}'
```

更多信息，请查看 [Docker Model Runner 文档](https://docs.docker.com/desktop/features/model-runner/)。

## 评估结果

| 模型                              | 参数  | MTEB-R  | CMTEB-R | MMTEB-R | MLDR   | MTEB-Code | FollowIR |
|-----------------------------------|-------|---------|---------|---------|--------|-----------|----------|
| **Qwen3-Embedding-0.6B**          | 0.6B  | 61.82   | 71.02   | 64.64   | 50.26  | 75.41     | 5.09     |
| Jina-multilingual-reranker-v2-base | 0.3B  | 58.22   | 63.37   | 63.73   | 39.66  | 58.98     | -0.68    |
| gte-multilingual-reranker-base    | 0.3B  | 59.51   | 74.08   | 59.44   | 66.33  | 54.18     | -1.64    |
| BGE-reranker-v2-m3                | 0.6B  | 57.03   | 72.16   | 58.36   | 59.51  | 41.38     | -0.01    |
| **Qwen3-Reranker-0.6B**           | 0.6B  | 65.80   | 71.31   | 66.36   | 67.28  | 73.42     | 5.41     |
| **Qwen3-Reranker-4B**             | 4B    | **69.76** | 75.94   | 72.74   | 69.97  | 81.20     | **14.84** |
| **Qwen3-Reranker-8B**             | 8B    | 69.02   | **77.45** | **72.94** | **70.19** | **81.22** | 8.05     |

## 🔗 链接

- [Qwen3-Reranker 0.6B](https://huggingface.co/Qwen/Qwen3-Reranker-0.6B)
- [Qwen3-Reranker 4B](https://huggingface.co/Qwen/Qwen3-Reranker-4B)
- [Qwen3-Reranker 8B](https://huggingface.co/Qwen/Qwen3-Reranker-8B)
