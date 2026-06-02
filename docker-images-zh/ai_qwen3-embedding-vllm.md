<!-- xuanyuan-docker-images-zh
image: ai/qwen3-embedding-vllm
source: https://xuanyuan.cloud/zh/r/ai/qwen3-embedding-vllm
canonical: https://xuanyuan.cloud/zh/r/ai/qwen3-embedding-vllm
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [ai/qwen3-embedding-vllm — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/ai/qwen3-embedding-vllm "ai/qwen3-embedding-vllm Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/ai/qwen3-embedding-vllm

# Qwen3-Embedding

![logo](https://github.com/docker/model-cards/raw/refs/heads/main/logos/qwen-280x184-overview@2x.svg)

Qwen3 Embedding模型系列是Qwen家族的最新专有模型，专为文本嵌入和排序任务设计。基于Qwen3系列的密集基础模型，提供0.6B、4B和8B多种尺寸的文本嵌入与重排序模型。该系列继承了基础模型卓越的多语言能力、长文本理解和推理技能，在文本检索、代码检索、文本分类、文本聚类和双语挖掘等多个文本嵌入与排序任务中取得了显著进步。

---

## 核心特性

| 属性 | 值 |
|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **提供商** | 阿里云 |
| **架构** | qwen3 |
| **支持语言** | 119种不同语系语言（印欧语系、汉藏语系、闪含语系、南岛语系、达罗毗荼语系、突厥语系、侗台语系、乌拉尔语系、南亚语系），包括日语、巴斯克语、海地语等 |
| **工具调用** | ❌ |
| **输入模态** | 文本 |
| **输出模态** | 文本嵌入 |
| **许可证** | Apache 2.0 |

---

## 使用方法（通过Docker Model Runner）

### 拉取模型

```bash
docker model pull ai/qwen3-embedding-vllm
```

### 运行模型

```bash
curl --location 'http://localhost:12434/engines/vllm/v1/embeddings' \
--header 'Content-Type: application/json' \
--data '{
    "model": "ai/qwen3-embedding-vllm",
    "input": "hello world!"
  }'
```

更多信息，请查看[Docker Model Runner文档](https://docs.docker.com/desktop/features/model-runner/)。

---

## MTEB（多语言）评测结果

| 模型 | 尺寸 | 任务平均值 | 类型平均值 | 双语挖掘 | 分类 | 聚类 | 实例 | 检索 | 多分类 | 配对分类 | 重排序检索 | STS |
|--------------------------------|------|-------------|-------------|-------------|--------|--------|-------|--------|----------------|--------------|--------------|------|
| NV-Embed-v2                    | 7B   | 56.29       | 49.58       | 57.84       | 57.29  | 40.80  | 1.04  | 18.63  | 78.94          | 63.82        | 56.72        | 71.10 |
| GritLM-7B                      | 7B   | 60.92       | 53.74       | 70.53       | 61.83  | 49.75  | 3.45  | 22.77  | 79.94          | 63.78        | 58.31        | 73.33 |
| BGE-M3                         | 0.6B | 59.56       | 52.18       | 79.11       | 60.35  | 40.88  | -3.11 | 20.1   | 80.76          | 62.79        | 54.60        | 74.12 |
| multilingual-e5-large-instruct | 0.6B | 63.22       | 55.08       | 80.13       | 64.94  | 50.75  | -0.40 | 22.91  | 80.86          | 62.61        | 57.12        | 76.81 |
| gte-Qwen2-1.5B-instruct        | 1.5B | 59.45       | 52.69       | 62.51       | 58.32  | 52.05  | 0.74  | 24.02  | 81.58          | 62.58        | 60.78        | 71.61 |
| gte-Qwen2-7B-Instruct          | 7B   | 62.51       | 55.93       | 73.92       | 61.55  | 52.77  | 4.94  | 25.48  | 85.13          | 65.55        | 60.08        | 73.98 |
| text-embedding-3-large         | –    | 58.93       | 51.41       | 62.17       | 60.27  | 46.89  | -2.68 | 22.03  | 79.17          | 63.89        | 59.27        | 71.68 |
| Cohere-embed-multilingual-v3.0 | –    | 61.12       | 53.23       | 70.50       | 62.95  | 46.89  | -1.89 | 22.74  | 79.88          | 64.07        | 59.16        | 74.80 |
| gemini-embedding-exp-03-07     | –    | 68.37       | 59.59       | 79.28       | 71.82  | 54.59  | 5.18  | 29.16  | 83.63          | 65.58        | 67.71        | 79.40 |
| **Qwen3-Embedding-0.6B**       | 0.6B | 64.33       | 56.00       | 72.22       | 66.83  | 52.33  | 5.09  | 24.59  | 80.83          | 61.41        | 64.64        | 76.17 |
| **Qwen3-Embedding-4B**         | 4B   | 69.45       | 60.86       | 79.36       | 72.33  | 57.15  | 11.56 | 26.77  | 85.05          | 65.08        | 69.60        | 80.86 |
| **Qwen3-Embedding-8B**         | 8B   | 70.58       | 61.69       | 80.89       | 74.00  | 57.65  | 10.06 | 28.66  | 86.40          | 65.63        | 70.88        | 81.08 |

> 注：对比模型的分数取自2025年5月24日MTEB在线排行榜。

---

## 相关链接

- [Qwen3-Embedding 0.6B](https://huggingface.co/Qwen/Qwen3-Embedding-0.6B)
- [Qwen3-Embedding 4B](https://huggingface.co/Qwen/Qwen3-Embedding-4B)
- [Qwen3-Embedding 8B](https://huggingface.co/Qwen/Qwen3-Embedding-8B)
