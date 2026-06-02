<!-- xuanyuan-docker-images-zh
image: opea/vllm
source: https://xuanyuan.cloud/zh/r/opea/vllm
canonical: https://xuanyuan.cloud/zh/r/opea/vllm
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [opea/vllm — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/opea/vllm "opea/vllm Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/opea/vllm

# vLLM Docker镜像文档


## 镜像概述和主要用途

vLLM Docker镜像是基于vLLM项目构建的容器化解决方案，专注于大语言模型（LLM）的高效推理与服务部署。vLLM项目起源于加州大学伯克利分校Sky Computing实验室，现为PyTorch基金会托管项目，以**高性能、低资源消耗、易用性**为核心优势，通过创新的内存管理和计算优化技术，实现LLM服务的高吞吐量和低延迟。

**主要用途**：  
- 部署和服务各类开源LLM模型（如Llama、Mixtral、LLaVA等）  
- 构建高吞吐量的LLM推理服务  
- 在多样化硬件环境（NVIDIA GPU、AMD GPU/CPU、Intel CPU/GPU等）中高效运行LLM  


## 核心功能和特性

### 高效性能优化
- **PagedAttention内存管理**：通过类操作系统分页机制高效管理注意力键值（KV）内存，解决传统LLM服务中的内存碎片化问题，支持更大批量请求。  
- **连续批处理（Continuous Batching）**：动态合并 incoming 请求，最大化GPU利用率，提升吞吐量。  
- **CUDA/HIP图加速**：通过预编译计算图减少 kernel 启动开销，加速模型执行。  
- **Speculative Decoding**：结合草稿模型提升生成速度，降低推理延迟。  


### 多样化模型与量化支持
- **广泛模型兼容性**：无缝集成Hugging Face生态，支持Transformer类LLM（Llama、GPT-2等）、混合专家模型（Mixtral、Deepseek-V2/V3）、多模态模型（LLaVA）及嵌入模型（E5-Mistral）。  
- **多量化方案**：支持GPTQ、AWQ、AutoRound、INT4、INT8、FP8等量化技术，平衡性能与显存占用。  


### 灵活部署与易用性
- **分布式推理**：支持张量并行、流水线并行、数据并行及专家并行，适配多GPU/多节点部署。  
- **OpenAI兼容API**：提供与OpenAI API一致的接口（如`/v1/completions`、`/v1/chat/completions`），便于现有系统集成。  
- **流式输出**：支持SSE（Server-Sent Events）流式返回生成结果，优化用户交互体验。  
- **多硬件支持**：兼容NVIDIA GPU、AMD GPU/CPU、Intel CPU/GPU、PowerPC CPU及TPU，支持Intel Gaudi、IBM Spyre等硬件插件。  


## 使用场景和适用范围

### 高吞吐量LLM服务
适用于需要处理大量并发请求的场景（如聊天机器人、智能客服），通过连续批处理和PagedAttention实现高GPU利用率。

### 资源受限环境部署
通过量化技术（如INT4/INT8）和内存优化，在显存有限的硬件（如消费级GPU）中运行大模型。

### 多模态与混合专家模型服务
支持多模态模型（如LLaVA）和混合专家模型（如Mixtral），满足复杂任务需求（如图文理解、多领域知识融合）。

### 多样化硬件环境适配
可在NVIDIA GPU（主流场景）、AMD GPU/CPU（低成本替代方案）、Intel x86架构（边缘设备）等环境中部署，降低硬件依赖。

### 科研与开发验证
提供简洁的接口和配置方式，便于快速验证模型性能、测试新量化方案或推理优化技术。


## 使用方法和配置说明

### 前置要求
- 支持Docker Engine 20.10+及nvidia-docker（如需使用NVIDIA GPU）。  
- 硬件环境需满足模型运行要求（如GPU显存≥模型大小+批处理开销，具体参考模型文档）。  


### Docker快速启动

#### 基础命令（NVIDIA GPU环境）
通过`docker run`直接启动vLLM服务，示例如下（以Llama-2-7b模型为例）：

```bash
docker run -it --gpus all \
  -p 8000:8000 \
  -e MODEL_PATH="meta-llama/Llama-2-7b-hf" \
  vllm/vllm:latest \
  serve \
  --model ${MODEL_PATH} \
  --port 8000 \
  --host 0.0.0.0 \
  --max-num-seqs 256 \
  --quantization awq  # 可选，如使用量化模型
```

#### 参数说明
- `--gpus all`：启用所有GPU（仅NVIDIA环境）。  
- `-p 8000:8000`：映射容器端口8000到主机，用于API访问。  
- `MODEL_PATH`：指定模型路径，支持Hugging Face Hub模型ID（自动下载）或本地路径（需通过`-v`挂载）。  
- `serve`：启动vLLM API服务模式。  
- `--model`：模型路径或Hugging Face Hub ID。  
- `--port/--host`：API服务端口和绑定地址。  
- `--max-num-seqs`：最大并发序列数（控制批处理大小）。  
- `--quantization`：量化方式（如`awq`、`gptq`、`int4`、`int8`，需模型支持）。  


#### 本地模型挂载（如需使用私有模型）
若模型存储在本地路径`/path/to/local/model`，通过`-v`挂载到容器中：

```bash
docker run -it --gpus all \
  -p 8000:8000 \
  -v /path/to/local/model:/app/model \
  vllm/vllm:latest \
  serve \
  --model /app/model \
  --port 8000 \
  --host 0.0.0.0
```


### Docker Compose配置

创建`docker-compose.yml`文件，定义服务配置（以多GPU分布式推理为例）：

```yaml
version: '3.8'

services:
  vllm-service:
    image: vllm/vllm:latest
    runtime: nvidia  # 或使用deploy.resources.device_requests（Docker 23.0+）
    ports:
      - "8000:8000"
    environment:
      - MODEL_PATH=mistralai/Mixtral-8x7B-Instruct-v0.1
      - CUDA_VISIBLE_DEVICES=0,1  # 指定使用GPU 0和1（分布式推理）
    command: >
      serve
      --model ${MODEL_PATH}
      --port 8000
      --host 0.0.0.0
      --tensor-parallel-size 2  # 张量并行度（需与GPU数量匹配）
      --max-batch-size 64
      --quantization gptq
      --streaming  # 启用流式输出
    volumes:
      - ./cache:/root/.cache/huggingface/hub  # 挂载模型缓存目录，避免重复下载
    restart: unless-stopped
```

启动服务：
```bash
docker-compose up -d
```


## 配置参数与环境变量

### 核心启动参数
| 参数名                | 说明                                                                 | 示例值                          |
|-----------------------|----------------------------------------------------------------------|---------------------------------|
| `--model`             | 模型路径（Hugging Face Hub ID或本地路径）                            | `meta-llama/Llama-2-7b-hf`      |
| `--port`              | API服务端口                                                          | `8000`                          |
| `--host`              | 绑定地址（0.0.0.0表示允许外部访问）                                  | `0.0.0.0`                       |
| `--quantization`      | 量化方式（需模型支持）                                              | `awq`、`gptq`、`int4`、`fp8`   |
| `--tensor-parallel-size` | 张量并行度（分布式推理时GPU数量）                                   | `2`（使用2张GPU）               |
| `--max-batch-size`    | 最大批处理大小（控制GPU内存占用）                                    | `64`                            |
| `--max-num-seqs`      | 最大并发序列数                                                      | `256`                           |
| `--streaming`         | 启用流式输出（SSE）                                                 | （无需值，添加即启用）          |
| `--openai-api-compatible` | 启用OpenAI兼容API（支持`/v1/completions`等端点）                  | （无需值，添加即启用）          |


### 环境变量
| 环境变量名              | 说明                                                                 | 示例值                          |
|-------------------------|----------------------------------------------------------------------|---------------------------------|
| `CUDA_VISIBLE_DEVICES`  | 指定可用GPU（逗号分隔ID）                                           | `0,1`（仅使用GPU 0和1）         |
| `MODEL_PATH`            | 模型路径（可替代`--model`参数，通过环境变量传递）                    | `/app/model`                    |
| `HUGGINGFACE_HUB_CACHE` | Hugging Face模型缓存目录（避免重复下载）                             | `/root/.cache/huggingface/hub`  |


## 验证服务可用性

服务启动后，可通过HTTP请求验证API是否正常工作（以OpenAI兼容API为例）：

```bash
curl http://localhost:8000/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta-llama/Llama-2-7b-hf",
    "prompt": "Hello, world!",
    "max_tokens": 50
  }'
```

若返回包含生成文本的JSON响应，表明服务部署成功。


## 常见问题

### 1. 模型下载缓慢或失败
- **解决**：挂载本地Hugging Face缓存目录（通过`-v ./cache:/root/.cache/huggingface/hub`），或提前通过`huggingface-cli download`下载模型到本地后挂载。


### 2. GPU内存不足
- **解决**：启用量化（`--quantization int4/awq`）、减小`--max-batch-size`或`--max-num-seqs`，或使用分布式推理（`--tensor-parallel-size`）拆分模型到多GPU。


### 3. AMD GPU/CPU环境支持
- **说明**：需使用支持HIP的vLLM镜像（如`vllm/vllm:amd-latest`），并通过`HIP_VISIBLE_DEVICES`指定设备，启动命令中无需`--gpus`参数。


### 4. 流式输出无响应
- **解决**：确保启动时添加`--streaming`参数，且客户端支持SSE（如使用`curl -N`或浏览器EventSource API）。
