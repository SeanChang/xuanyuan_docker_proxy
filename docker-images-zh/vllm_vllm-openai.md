<!-- xuanyuan-docker-images-zh
image: vllm/vllm-openai
source: https://xuanyuan.cloud/zh/r/vllm/vllm-openai
canonical: https://xuanyuan.cloud/zh/r/vllm/vllm-openai
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [vllm/vllm-openai — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/vllm/vllm-openai "vllm/vllm-openai Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/vllm/vllm-openai

# vllm/vllm-openai 镜像使用指南

## 一、镜像概述与核心定位

`vllm/vllm-openai` 是 vLLM 高性能大模型推理框架的官方 Docker 容器镜像，由加州大学伯克利分校发起，专门用于快速部署兼容 OpenAI API 的大模型推理服务。该镜像将 vLLM 的高性能推理能力封装为标准的 OpenAI API 接口，开发者无需手动配置 vLLM 环境，即可快速启动支持 ChatGPT 同款接口（如 `/v1/completions`、`/v1/chat/completions`）的大模型推理服务，无缝替代 OpenAI 官方后端。

### 核心价值

- **高性能推理**：继承 vLLM 框架的 PagedAttention 内存优化与连续批处理技术，吞吐量可达传统推理引擎 10-24 倍
- **API 兼容性**：完全兼容 OpenAI API 标准，包括 `/v1/chat/completions`、`/v1/completions`、`/v1/embeddings` 等接口
- **快速部署**：一条 Docker 命令即可启动生产级大模型推理服务，无需手动安装 CUDA、PyTorch 等依赖
- **生态适配**：支持 Llama、Mistral、Qwen、ChatGLM 等 50+ 主流开源模型，支持 INT4/INT8/GPTQ 量化方案

## 二、核心技术特性

### 2.1 PagedAttention 内存优化

借鉴操作系统「分页管理」思想，将大模型推理中的「键值缓存（KV Cache）」分割为固定大小的块，动态分配给不同请求，有效解决内存碎片问题。

**优势**：内存利用率提升 3-5 倍，可在相同显存下部署更大规模的模型或处理更多并发请求。

### 2.2 连续批处理（Continuous Batching）

动态合并新请求到正在处理的批次中，避免传统静态批处理的资源闲置，实现请求队列的实时管理与调度。

**优势**：吞吐量可达传统推理引擎（如 HuggingFace Transformers）的 10-24 倍，显著提升 GPU 利用率。

### 2.3 硬件与模型支持

**硬件支持**：
- NVIDIA GPU（推荐 A100/H100/V100，算力需 ≥7.0）
- AMD GPU（实验性支持）
- CPU（仅支持测试，性能有限）

**模型支持**：
- 主流开源模型：Llama、Mistral、Qwen、ChatGLM、DeepSeek、Phi 等 50+ 模型
- 量化支持：INT4/INT8/GPTQ、AWQ 等量化方案
- 模型格式：支持 HuggingFace Transformers 格式

## 三、使用场景

### 3.1 开源大模型的快速部署

开发者无需手动安装 vLLM 依赖（如 CUDA、PyTorch），通过 Docker 拉取镜像后，仅需一条命令即可启动大模型服务：

```bash
docker run --gpus all -p 8000:8000 vllm/vllm-openai:latest --model meta-llama/Llama-3-70b-chat-hf --api-server
```

### 3.2 OpenAI 应用的本地化替代

企业或个人为降低 API 调用成本、保障数据隐私，将原有依赖 OpenAI 的应用切换为本地服务，直接复用原有 API 调用代码。

**典型场景**：AI 助手、内容生成工具、聊天机器人等应用。

### 3.3 高吞吐场景的生产部署

在多租户、高请求量场景（如客服 AI、批量内容生成）中，利用该镜像的高性能特性（连续批处理、PagedAttention），在相同 GPU 资源下处理更多请求，降低延迟。

### 3.4 定制化推理服务开发

基于该镜像扩展自定义功能，例如通过 `FROM vllm/vllm-openai:v0.7.3` 构建定制镜像，升级 NCCL 版本解决通信稳定性问题，适配多节点分布式部署。

## 四、前置准备

### 4.1 硬件与软件要求

| 项目 | 要求 |
| --- | --- |
| **硬件** | NVIDIA GPU（推荐 A100/H100/V100，算力 ≥7.0），显存需满足模型要求 |
| **操作系统** | Linux（推荐 Ubuntu 20.04+），macOS（需 Docker Desktop + WSL2），Windows 需 WSL2+Docker |
| **容器工具** | Docker 19.03+，需安装 NVIDIA Container Runtime |
| **存储空间** | 建议预留 ≥50GB（镜像约 21GB + 模型文件） |
| **网络环境** | 首次使用需联网下载模型，建议科学上网提升速度 |

### 4.2 安装 NVIDIA Container Runtime

```bash
# Ubuntu/Debian
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

### 4.3 验证 GPU 支持

```bash
# 检查 NVIDIA 驱动
nvidia-smi

# 验证 Docker GPU 支持
docker run --rm --gpus all nvidia/cuda:12.0.0-base-ubuntu22.04 nvidia-smi
```

## 五、镜像拉取与启动

### 5.1 拉取镜像

```bash
# 拉取最新版本
docker pull docker.xuanyuan.run/r/vllm/vllm-openai:latest

# 拉取指定版本
docker pull docker.xuanyuan.run/r/vllm/vllm-openai:v0.7.3
```

> **注意**：镜像约 21GB，拉取时需注意网络稳定性，建议使用镜像加速或科学上网。

### 5.2 基础启动命令

#### 启动 Llama 3 70B 模型

```bash
docker run -d \
  --name vllm-openai \
  --gpus all \
  -p 8000:8000 \
  docker.xuanyuan.run/r/vllm/vllm-openai:latest \
  --model meta-llama/Llama-3-70b-chat-hf \
  --api-server
```

#### 启动 Qwen 模型（支持量化）

```bash
docker run -d \
  --name vllm-qwen \
  --gpus all \
  -p 8000:8000 \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  docker.xuanyuan.run/r/vllm/vllm-openai:latest \
  --model Qwen/Qwen2.5-72B-Instruct-GPTQ-Int4 \
  --quantization gptq \
  --api-server
```

#### 启动自定义模型（挂载本地模型）

```bash
docker run -d \
  --name vllm-custom \
  --gpus all \
  -p 8000:8000 \
  -v /宿主机/模型路径:/models \
  docker.xuanyuan.run/r/vllm/vllm-openai:latest \
  --model /models/your-model \
  --api-server \
  --host 0.0.0.0
```

### 5.3 参数说明

| 参数 | 说明 | 示例 |
| --- | --- | --- |
| `--model` | 模型名称或路径（HuggingFace 模型 ID 或本地路径） | `meta-llama/Llama-3-70b-chat-hf` |
| `--api-server` | 启动兼容 OpenAI API 的服务 | - |
| `--host` | 服务监听地址 | `0.0.0.0`（默认） |
| `--port` | 服务端口 | `8000`（默认） |
| `--quantization` | 量化方案（awq/gptq/squeezellm/fp8） | `gptq` |
| `--tensor-parallel-size` | 张量并行度（多 GPU） | `2`（2 个 GPU） |
| `--dtype` | 数据类型（auto/float16/bfloat16） | `auto`（默认） |
| `--max-model-len` | 最大序列长度 | `8192` |
| `--gpu-memory-utilization` | GPU 显存利用率 | `0.9`（默认 0.9） |

## 六、API 使用示例

### 6.1 Chat Completions API（对话生成）

```bash
curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta-llama/Llama-3-70b-chat-hf",
    "messages": [
      {"role": "user", "content": "你好，介绍一下 vLLM"}
    ],
    "temperature": 0.7,
    "max_tokens": 500
  }'
```

### 6.2 流式输出（Stream）

```bash
curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta-llama/Llama-3-70b-chat-hf",
    "messages": [
      {"role": "user", "content": "写一首关于 AI 的诗"}
    ],
    "stream": true
  }'
```

### 6.3 使用 Python SDK

```python
from openai import OpenAI

# 指定 vLLM 服务的地址
client = OpenAI(
    api_key="EMPTY",  # vLLM 不需要 API Key
    base_url="http://localhost:8000/v1"
)

# 调用对话接口
response = client.chat.completions.create(
    model="meta-llama/Llama-3-70b-chat-hf",
    messages=[
        {"role": "user", "content": "你好！"}
    ]
)

print(response.choices[0].message.content)
```

### 6.4 替换现有 OpenAI 应用

只需修改 API 地址即可：

```python
# 原来使用 OpenAI
client = OpenAI(api_key="your-openai-key")

# 现在使用 vLLM 本地服务
client = OpenAI(
    api_key="EMPTY",
    base_url="http://localhost:8000/v1"
)
```

## 七、高级配置

### 7.1 多 GPU 配置

使用多个 GPU 加速推理：

```bash
docker run -d \
  --name vllm-multi-gpu \
  --gpus all \
  -p 8000:8000 \
  docker.xuanyuan.run/r/vllm/vllm-openai:latest \
  --model meta-llama/Llama-3-70b-chat-hf \
  --tensor-parallel-size 2 \
  --api-server
```

> `--tensor-parallel-size` 需等于 GPU 数量

### 7.2 调整显存利用率和序列长度

```bash
docker run -d \
  --name vllm-optimized \
  --gpus all \
  -p 8000:8000 \
  docker.xuanyuan.run/r/vllm/vllm-openai:latest \
  --model meta-llama/Llama-3-70b-chat-hf \
  --gpu-memory-utilization 0.95 \
  --max-model-len 16384 \
  --api-server
```

### 7.3 启用量化以减少显存占用

使用 AWQ 量化（Automatic Weight Quantization）：

```bash
docker run -d \
  --name vllm-quantized \
  --gpus all \
  -p 8000:8000 \
  docker.xuanyuan.run/r/vllm/vllm-openai:latest \
  --model meta-llama/Llama-3-8B-Instruct-AWQ \
  --quantization awq \
  --api-server
```

## 八、监控与调试

### 8.1 容器状态检查

```bash
# 查看容器运行状态
docker ps | grep vllm-openai

# 查看日志
docker logs -f vllm-openai

# 查看 GPU 使用情况
docker exec vllm-openai nvidia-smi
```

### 8.2 性能监控

vLLM 提供内置的监控接口：

```bash
# 查看服务状态
curl http://localhost:8000/health

# 查看模型信息
curl http://localhost:8000/v1/models
```

### 8.3 调试模式

启用详细日志输出：

```bash
docker run -d \
  --name vllm-debug \
  --gpus all \
  -p 8000:8000 \
  -e LOG_LEVEL=DEBUG \
  docker.xuanyuan.run/r/vllm/vllm-openai:latest \
  --model meta-llama/Llama-3-70b-chat-hf \
  --api-server
```

## 九、常见问题与解决方案（FAQ）

| 问题现象 | 可能原因 | 解决方案 |
| --- | --- | --- |
| GPU 不可用或访问被拒绝 | 未安装 NVIDIA Container Runtime | 安装 nvidia-container-toolkit 并重启 Docker |
| 显存不足（OOM） | 模型过大或显存设置不合理 | 减小 `--gpu-memory-utilization`；使用量化模型；或减小 `--max-model-len` |
| 模型下载失败 | 网络问题或模型路径错误 | 使用科学上网；检查模型名称是否正确；手动下载后挂载 |
| API 请求超时 | 显存不足或并发过高 | 调整 `--max-num-seqs`；增加显存利用率；使用多 GPU |
| 版本兼容性问题 | 镜像版本与模型不匹配 | 使用 `v0.7.3` 等稳定版本；参考官方兼容性文档 |
| Windows 无法运行 | 不支持 Windows 原生 | 使用 WSL2+Docker 或切换到 Linux 系统 |
| 多 GPU 不生效 | tensor-parallel-size 配置错误 | 确保 `--tensor-parallel-size` 等于可用 GPU 数量 |

## 十、自定义镜像构建

如需定制镜像（如升级 NCCL 版本、添加自定义依赖），可基于官方镜像二次构建：

```dockerfile
FROM docker.xuanyuan.run/r/vllm/vllm-openai:v0.7.3

# 安装额外依赖
RUN pip install your-package

# 升级 NCCL 版本（如需要）
RUN pip install --upgrade nccl

# 设置工作目录
WORKDIR /workspace
```

构建并运行：

```bash
# 构建镜像
docker build -t vllm-custom:v0.7.3 .

# 运行自定义镜像
docker run -d \
  --name vllm-custom \
  --gpus all \
  -p 8000:8000 \
  vllm-custom:v0.7.3 \
  --model meta-llama/Llama-3-70b-chat-hf \
  --api-server
```

## 十一、参考资源

- **vLLM 官方网站**：<https://vllm.readthedocs.io/>
- **vLLM GitHub 仓库**：<https://github.com/vllm-project/vllm>
- **vLLM 官方文档**：<https://docs.vllm.ai/>
- **HuggingFace 模型库**：<https://huggingface.co/models>
- **OpenAI API 文档**：<https://platform.openai.com/docs/api-reference>
- **NVIDIA Container Toolkit**：<https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html>

---

**注意**：本镜像基于 vLLM 框架构建，需确保硬件环境满足要求（推荐 NVIDIA GPU 算力 ≥7.0）。首次使用建议从较小规模的模型开始测试（如 Llama 3 8B），确保环境配置正确后再部署大模型。
