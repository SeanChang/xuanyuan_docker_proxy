---
image: zulfifazhar/vllm-cpu
description: "在CPU上运行vLLM并提供OpenAI兼容API的Docker镜像，适用于原型开发、批量推理、CI检查及1B至3B参数的小型模型。"
source: https://xuanyuan.cloud/zh/r/zulfifazhar/vllm-cpu
canonical: https://xuanyuan.cloud/zh/r/zulfifazhar/vllm-cpu
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zulfifazhar/vllm-cpu" title="zulfifazhar/vllm-cpu Docker 镜像中文简介、标签列表与拉取命令">zulfifazhar/vllm-cpu 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# vllm-cpu

## 镜像概述和主要用途
在CPU上运行vLLM并提供OpenAI兼容API，适用于原型开发、批量推理、CI检查以及1B至3B参数范围的小型模型。

## 核心功能和特性
- OpenAI兼容端点：`/v1/models`、`/v1/chat/completions`、`/v1/completions`
- 无需GPU，针对CPU运行优化
- Hugging Face缓存卷，避免重复下载模型
- 支持Docker CLI、Docker Compose和Portainer
- 通过环境变量实现简单配置

## 系统要求
- 推荐x86_64架构CPU，支持AVX2指令集
- 内存需满足模型需求：1B至3B参数模型通常需要8至16GB RAM
- 首次拉取模型需联网（从Hugging Face下载）

## 使用方法和配置说明

### 快速开始
```bash
docker run -it --rm -p 9001:8000 \
  -e VLLM_TARGET_DEVICE=cpu \
  -e VLLM_CPU_KVCACHE_SPACE=8 \
  --shm-size=4g \
  -v $HOME/.cache/huggingface:/root/.cache/huggingface \
  docker.xuanyuan.run/zulfifazhar/vllm-cpu:cpu \
  --model Qwen/Qwen2.5-coder-1.5B-Instruct --port 8000
```

根据可用内存调整`VLLM_CPU_KVCACHE_SPACE`参数：
- 8GB RAM：`VLLM_CPU_KVCACHE_SPACE=4`
- 16GB RAM：`VLLM_CPU_KVCACHE_SPACE=8`
- 32GB RAM：`VLLM_CPU_KVCACHE_SPACE=16`

#### 检查服务器状态：
```bash
curl http://localhost:9001/v1/models
```

#### 聊天示例：
```bash
curl -s http://localhost:9001/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model":"meta-llama/Llama-3.2-1B-Instruct",
    "messages":[{"role":"user","content":"Hello from vLLM CPU"}],
    "max_tokens":64
  }'
```

### 环境变量
- `MODEL`：Hugging Face上的模型名称，例如：`meta-llama/Llama-3.2-1B-Instruct`
- `VLLM_TARGET_DEVICE`：必须设置为`cpu`
- `VLLM_CPU_KVCACHE_SPACE`：KV缓存大小（GiB），例如：`8`
- 其他vLLM选项：根据构建版本，可使用命令行标志或环境变量配置

### 端口和卷
- 容器监听端口：8000
- 主机端口映射：根据需要映射，例如：`-p 9001:8000`
- Hugging Face缓存挂载：将主机路径挂载到`/root/.cache/huggingface`

### Docker Compose配置

#### 普通模型
```yaml
services:
  vllm:
    image: docker.xuanyuan.run/zulfifazhar/vllm-cpu:cpu
    ports:
      - "9001:8000"
    environment:
      VLLM_TARGET_DEVICE: cpu
      VLLM_CPU_KVCACHE_SPACE: "8"
    command: ["--model","Qwen/Qwen2.5-coder-1.5B-Instruct","--port","8000"]
    volumes:
      - $HOME/.cache/huggingface:/root/.cache/huggingface
    shm_size: "4g"
    restart: unless-stopped
```

#### 推理模型
```yaml
version: "3.8"
services:
  vllm_qwen3_thinking_cpu:
    image: docker.xuanyuan.run/yourname/vllm-cpu:local
    command: ["--model","Qwen/Qwen3-4B-Thinking-2507",
              "--port","8000",
              "--max-model-len","24576",
              "--reasoning-parser","qwen3"]
    environment:
      VLLM_TARGET_DEVICE: cpu
      VLLM_CPU_KVCACHE_SPACE: "8"
    ports:
      - "9000:8000"
    volumes:
      - $HOME/.cache/huggingface:/root/.cache/huggingface
    shm_size: "4g"
    restart: unless-stopped
```

### Portainer部署
1. 进入Portainer → Stacks → 添加堆栈
2. 粘贴上述Compose配置
3. 部署后，通过`curl http://SERVER_IP:9001/v1/models`测试服务
