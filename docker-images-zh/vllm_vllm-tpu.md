---
image: vllm/vllm-tpu
description: "vLLM框架在TPU上运行的Docker镜像仓库"
source: https://xuanyuan.cloud/zh/r/vllm/vllm-tpu
canonical: https://xuanyuan.cloud/zh/r/vllm/vllm-tpu
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/vllm/vllm-tpu" title="vllm/vllm-tpu Docker 镜像中文简介、标签列表与拉取命令">vllm/vllm-tpu — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/vllm/vllm-tpu" title="vllm/vllm-tpu Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/vllm/vllm-tpu</a>

# vLLM TPU 镜像技术文档


## 一、镜像概述和主要用途

vLLM TPU 镜像是基于 vLLM（高效大语言模型推理库）构建的 Docker 镜像，专为 Google TPU（张量处理单元）硬件环境优化，提供高性能的大语言模型推理服务。该镜像整合了 vLLM 的高效推理引擎与 TPU 硬件加速能力，旨在简化大语言模型在 TPU 集群或单机 TPU 设备上的部署流程，支持低延迟、高吞吐量的模型推理场景。


## 二、核心功能和特性

### 1. 高效推理引擎
- 基于 vLLM 核心框架，支持 PagedAttention 技术，优化内存管理，提升模型并行效率。
- 兼容主流大语言模型（如 LLaMA、GPT-2、GPT-NeoX、OPT 等）的推理需求。

### 2. TPU 硬件加速
- 深度适配 TPU 架构（v3、v4 等型号），利用 TPU 高带宽内存（HBM）和矩阵计算单元，最大化算力利用率。
- 集成 TPU 驱动与运行时环境（如 libtpu、JAX 等依赖），无需手动配置 TPU 底层依赖。

### 3. 模型兼容性
- 支持 Hugging Face Transformers 模型格式，可直接加载预训练模型或微调后的自定义模型。
- 支持模型权重自动下载（通过 Hugging Face Hub）或本地路径挂载。

### 4. 动态批处理与调度
- 内置动态批处理（Dynamic Batching）功能，自动适配输入请求流量，平衡延迟与吞吐量。
- 支持请求优先级调度，保障高优先级任务的响应速度。

### 5. 低延迟与高吞吐量
- 针对 TPU 硬件特性优化算子实现，降低推理延迟（p99 延迟可低至毫秒级）。
- 支持多实例并行部署，提升并发处理能力，满足高并发请求场景。


## 三、使用场景和适用范围

### 1. 大语言模型部署服务
- 适用于需要将大语言模型（如 LLaMA-2、Mistral 等）部署为 API 服务的场景，提供稳定的推理接口。

### 2. TPU 集群环境推理
- 支持在 Google Cloud TPU 集群、本地 TPU Pod 或单机 TPU v4 等环境中部署，适配多 TPU 核心并行推理。

### 3. 实时对话系统
- 满足聊天机器人、智能助手等实时对话场景的低延迟需求，支持持续对话上下文管理。

### 4. AI 应用后端服务
- 作为 AI 应用（如内容生成、代码辅助、智能问答）的后端推理服务，提供高吞吐量的模型调用能力。

### 5. 研究与开发
- 供科研人员或开发者在 TPU 环境中快速验证模型性能、测试推理优化策略。


## 四、详细的使用方法和配置说明

### 1. 前提条件
- **硬件环境**：已配置 Google TPU 设备（如 TPU v3、TPU v4），且具备 TPU 访问权限（如 Cloud TPU 服务账号或本地 TPU 设备驱动）。
- **软件环境**：Docker Engine（20.10+）、Docker Compose（可选，用于多容器管理）。
- **网络**：可访问 Hugging Face Hub（用于自动下载模型）或本地已存储模型文件。


### 2. 获取镜像
镜像可通过 Docker Hub 或私有仓库获取，默认标签为 `latest`（对应最新稳定版本）：
```bash
docker pull vllm/tpu:latest
```


### 3. 基本使用（`docker run` 命令示例）
#### 3.1 单机 TPU 基础部署
在已配置 TPU 的环境中，通过以下命令启动基础推理服务（以 LLaMA-2-7B 模型为例）：
```bash
docker run -it --rm \
  --privileged \
  --device=/dev/tpu \  # 挂载 TPU 设备
  -e MODEL_PATH="meta-llama/Llama-2-7b-hf" \  # 模型路径（Hugging Face Hub 或本地路径）
  -e TPU_NUM_CORES=8 \  # TPU 核心数（根据硬件配置调整，如 v3-8 为 8 核）
  -p 8000:8000 \  # 端口映射（主机端口:容器端口）
  vllm/tpu:latest \
  python -m vllm.entrypoints.api_server --host 0.0.0.0 --port 8000
```

#### 3.2 本地模型挂载部署
若模型存储在主机本地路径（如 `/data/models/llama-2-7b`），通过 `-v` 挂载主机目录至容器：
```bash
docker run -it --rm \
  --privileged \
  --device=/dev/tpu \
  -v /data/models:/models \  # 主机模型目录挂载至容器 /models
  -e MODEL_PATH="/models/llama-2-7b" \  # 容器内模型路径
  -e TPU_NUM_CORES=8 \
  -p 8000:8000 \
  vllm/tpu:latest \
  python -m vllm.entrypoints.api_server --host 0.0.0.0 --port 8000
```


### 4. 配置参数说明
#### 4.1 环境变量（推荐配置）
| 环境变量名          | 说明                                                                 | 默认值          |
|---------------------|----------------------------------------------------------------------|-----------------|
| `MODEL_PATH`        | 模型路径，支持 Hugging Face Hub ID（如 `meta-llama/Llama-2-7b-hf`）或容器内本地路径 | 无（必填）      |
| `TPU_NUM_CORES`     | TPU 核心数，需与硬件配置匹配（如 TPU v3-8 填 8，v4-16 填 16）         | 8               |
| `MAX_BATCH_SIZE`    | 动态批处理最大批次大小，影响吞吐量（值越大吞吐量越高，延迟可能增加）   | 32              |
| `MAX_NUM_SEQUENCES` | 并发序列数上限，控制内存占用                                         | 128             |
| `LOG_LEVEL`         | 日志级别（`DEBUG`/`INFO`/`WARNING`/`ERROR`）                         | `INFO`          |

#### 4.2 命令行参数（vLLM API 服务参数）
启动容器时，可通过命令行参数调整 vLLM 服务配置（完整参数见 [vLLM 官方文档](https://docs.vllm.ai/)），常用参数：
| 参数                | 说明                                                                 |
|---------------------|----------------------------------------------------------------------|
| `--host`            | 服务绑定主机地址（容器内地址，通常设为 `0.0.0.0` 允许外部访问）       |
| `--port`            | 服务监听端口（需与容器端口映射一致）                                 |
| `--tensor-parallel-size` | 模型并行度，建议设为 TPU 核心数（如 `--tensor-parallel-size 8`）    |
| `--served-model-name` | 服务模型名称（用于 API 标识）                                       |


### 5. Docker Compose 配置示例
创建 `docker-compose.yml` 文件，简化多容器或固定配置部署：
```yaml
version: '3.8'

services:
  vllm-tpu-service:
    image: vllm/tpu:latest
    privileged: true
    devices:
      - /dev/tpu:/dev/tpu  # 挂载 TPU 设备
    volumes:
      - /data/models:/models  # 本地模型目录挂载（可选）
    environment:
      - MODEL_PATH=/models/llama-2-7b  # 容器内模型路径（本地挂载或 Hub ID）
      - TPU_NUM_CORES=8
      - MAX_BATCH_SIZE=64
      - LOG_LEVEL=INFO
    ports:
      - "8000:8000"  # API 服务端口
      - "8001:8001"  # 监控指标端口（可选）
    command: >
      python -m vllm.entrypoints.api_server
      --host 0.0.0.0
      --port 8000
      --tensor-parallel-size 8
      --served-model-name llama-2-7b
```
启动服务：
```bash
docker-compose up -d
```


### 6. 高级配置说明
#### 6.1 模型并行与 TPU 核心分配
- 对于大模型（如 70B），需通过 `--tensor-parallel-size` 指定模型并行数，建议与 `TPU_NUM_CORES` 一致（如 TPU v4-32 设为 32）。
- 若 TPU 设备为 Pod 集群（如 TPU v4-1024），需配合 `--distributed-executor-backend tpu` 启用分布式执行。

#### 6.2 日志与监控
- 日志输出路径：默认输出至容器 stdout，可通过 `-v /host/logs:/app/logs` 挂载日志目录，并配置 `--log-file /app/logs/vllm.log`。
- 监控指标：vLLM 内置 Prometheus 指标，通过 `--metrics-port 8001` 暴露，可对接 Grafana 监控吞吐量、延迟等指标。

#### 6.3 安全与权限
- 生产环境建议添加 `--user` 参数指定非 root 用户运行，避免权限风险。
- 敏感配置（如 Hugging Face Hub Token）可通过环境变量 `HUGGING_FACE_HUB_TOKEN` 传入，用于私有模型下载。


## 五、注意事项
1. **TPU 环境依赖**：需确保主机已安装 TPU 驱动（如 `libtpu`）和对应版本的 TensorFlow/JAX 依赖，镜像仅包含运行时环境，不包含底层驱动。
2. **模型兼容性**：部分模型可能需要适配 TPU 算子，建议优先使用 vLLM 官方验证过的模型（见 [vLLM 模型支持列表](https://docs.vllm.ai/en/latest/models/supported_models.html)）。
3. **资源限制**：根据模型大小调整容器内存限制（通过 `--memory` 参数），避免 OOM 错误（推荐预留模型大小 2 倍以上内存）。
4. **版本匹配**：确保镜像版本与 TPU 硬件型号兼容（如 TPU v4 需使用基于 JAX 0.4.10+ 构建的镜像版本）。
