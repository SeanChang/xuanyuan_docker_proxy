---
image: syntheticdreamlabs/vllm
description: "vLLM构建镜像用于构建高性能大语言模型服务环境，支持快速部署及推理性能优化。"
source: https://xuanyuan.cloud/zh/r/syntheticdreamlabs/vllm
canonical: https://xuanyuan.cloud/zh/r/syntheticdreamlabs/vllm
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/syntheticdreamlabs/vllm" title="syntheticdreamlabs/vllm Docker 镜像中文简介、标签列表与拉取命令">syntheticdreamlabs/vllm — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/syntheticdreamlabs/vllm" title="syntheticdreamlabs/vllm Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/syntheticdreamlabs/vllm</a>

# vLLM 镜像文档

## 1. 镜像概述和主要用途

vLLM 是一个高性能的大型语言模型(LLM)服务库，基于 PagedAttention 高效注意力算法实现。该 Docker 镜像封装了 vLLM 的核心构建版本，提供便捷、可移植的部署方案，用于快速搭建高性能 LLM 推理服务。

主要用途：
- 部署高性能 LLM 推理服务
- 构建基于 LLM 的应用程序后端
- 进行 LLM 性能测试和基准测试
- 开发和调试 LLM 相关应用

## 2. 核心功能和特性

### 性能优化
- 基于 PagedAttention 技术，显著提高内存效率
- 支持连续批处理(Continuous Batching)，提升吞吐量
- 优化的 KV 缓存管理，减少内存占用
- 支持张量并行，可在多 GPU 上扩展

### 模型支持
- 兼容 Hugging Face Transformers 模型格式
- 支持多种开源 LLM，包括 Llama 系列、GPT-2、GPT-NeoX 等
- 支持量化模型(INT4/INT8)，降低资源需求
- 支持自定义模型配置

### 服务能力
- 提供 REST API 和 gRPC 接口
- 支持流式输出(Streaming)响应
- 兼容 OpenAI API 格式，易于集成
- 内置 Prometheus 指标监控

## 3. 使用场景和适用范围

### 适用场景
- 生产环境 LLM 服务部署
- 开发和测试 LLM 应用程序
- 构建 AI 助手、聊天机器人等对话系统
- 文本生成、摘要、翻译等 NLP 任务
- 学术研究和性能评估

### 硬件要求
- 最低配置：单 GPU(8GB 显存)
- 推荐配置：NVIDIA GPU(A10, A100, L4 等)，16GB+ 显存
- 支持多 GPU 部署，提升并发处理能力
- 需安装 NVIDIA 容器工具包(nvidia-docker)

## 4. 使用方法和配置说明

### 基本使用

#### 拉取镜像
```bash
docker pull vllm/vllm:latest
```

#### 基本启动命令
```bash
docker run --gpus all -p 8000:8000 vllm/vllm:latest \
  --model facebook/opt-13b \
  --port 8000
```

### Docker Compose 部署

创建 `docker-compose.yml` 文件：

```yaml
version: '3'
services:
  vllm:
    image: vllm/vllm:latest
    runtime: nvidia
    ports:
      - "8000:8000"
    environment:
      - MODEL_PATH=meta-llama/Llama-2-7b-chat-hf
      - PORT=8000
      - MAX_BATCH_SIZE=32
    volumes:
      - ./models:/models
      - ./cache:/root/.cache/huggingface/hub
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

启动服务：
```bash
docker-compose up -d
```

### 关键配置参数

#### 启动参数

| 参数 | 描述 | 默认值 |
|------|------|-------|
| `--model` | 模型路径或 Hugging Face 模型 ID | 无 |
| `--port` | 服务端口 | 8000 |
| `--host` | 服务绑定地址 | 0.0.0.0 |
| `--tensor-parallel-size` | 张量并行 GPU 数量 | 1 |
| `--max-batch-size` | 最大批处理大小 | 16 |
| `--max-seq-len` | 最大序列长度 | 2048 |
| `--gpu-memory-utilization` | GPU 内存利用率目标 | 0.9 |
| `--quantization` | 量化方式(如 "awq", "gptq", "bitsandbytes") | 无 |
| `--api-key` | API 访问密钥 | 无 |
| `--served-model-name` | 服务模型名称(用于 API) | 模型名称 |

#### 环境变量

| 环境变量 | 描述 | 默认值 |
|---------|------|-------|
| `MODEL_PATH` | 模型路径或 ID | 无 |
| `PORT` | 服务端口 | 8000 |
| `LOG_LEVEL` | 日志级别(DEBUG/INFO/WARNING/ERROR) | INFO |
| `HUGGING_FACE_HUB_TOKEN` | Hugging Face 访问令牌 | 无 |

### 高级用法示例

#### 使用量化模型
```bash
docker run --gpus all -p 8000:8000 vllm/vllm:latest \
  --model TheBloke/Llama-2-7B-Chat-AWQ \
  --quantization awq \
  --port 8000
```

#### 多 GPU 部署
```bash
docker run --gpus all -p 8000:8000 vllm/vllm:latest \
  --model meta-llama/Llama-2-13b-chat-hf \
  --tensor-parallel-size 2 \
  --port 8000
```

#### 本地模型部署
```bash
docker run --gpus all -p 8000:8000 \
  -v /path/to/local/model:/models/local-model \
  vllm/vllm:latest \
  --model /models/local-model \
  --port 8000
```

#### 启用 OpenAI 兼容 API
```bash
docker run --gpus all -p 8000:8000 vllm/vllm:latest \
  --model meta-llama/Llama-2-7b-chat-hf \
  --port 8000 \
  --api-key secret-key \
  --served-model-name llama-2-7b-chat
```

### API 使用示例

#### 文本生成请求
```bash
curl http://localhost:8000/generate \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Hello, my name is",
    "max_tokens": 128,
    "temperature": 0.7
  }'
```

#### 流式输出请求
```bash
curl http://localhost:8000/generate \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Write a story about AI.",
    "max_tokens": 200,
    "stream": true
  }'
```

## 5. 监控和日志

### 访问指标
vLLM 内置 Prometheus 指标，可通过 `/metrics` 端点访问：
```
http://localhost:8000/metrics
```

主要指标包括：
- `vllm_requests_total`: 总请求数
- `vllm_requests_success_total`: 成功请求数
- `vllm_requests_failed_total`: 失败请求数
- `vllm_batch_size`: 当前批处理大小
- `vllm_queue_length`: 请求队列长度

### 查看日志
```bash
docker logs -f <container_id>
```

## 6. 故障排除

### 常见问题解决

1. **内存不足错误**
   - 降低 `--gpu-memory-utilization` 值
   - 使用量化模型 (`--quantization`)
   - 减少 `--max-batch-size`

2. **模型下载失败**
   - 配置 Hugging Face 访问令牌: `--hf-token <token>`
   - 手动下载模型并挂载到容器
   - 检查网络连接

3. **性能不佳**
   - 增加 `--max-batch-size`
   - 调整 `--gpu-memory-utilization`
   - 确保使用支持的 GPU (计算能力 ≥ 7.0)

4. **端口冲突**
   - 更改 `--port` 参数
   - 映射到主机的不同端口: `-p 8001:8000`
