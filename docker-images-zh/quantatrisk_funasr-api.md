---
image: quantatrisk/funasr-api
description: "基于FunASR和Qwen3-ASR的生产级本地语音识别API服务，支持多模型、OpenAI API兼容接口、流式识别和说话人分离，提供GPU加速和批量处理能力。"
source: https://xuanyuan.cloud/zh/r/quantatrisk/funasr-api
canonical: https://xuanyuan.cloud/zh/r/quantatrisk/funasr-api
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/quantatrisk/funasr-api" title="quantatrisk/funasr-api Docker 镜像中文简介、标签列表与拉取命令">quantatrisk/funasr-api — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/quantatrisk/funasr-api" title="quantatrisk/funasr-api Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/quantatrisk/funasr-api</a>

# FunASR-API

基于[FunASR](https://github.com/alibaba-damo-academy/FunASR)和[Qwen3-ASR](https://github.com/QwenLM/Qwen3-ASR)构建的生产级本地语音识别API服务。

## 快速开始

### GPU版本（推荐）

```bash
docker run -d --name funasr-api \
  --gpus all \
  -p 17003:8000 \
  -e ENABLED_MODELS=auto \
  -e API_KEY=your_api_key \
  -v ./models/modelscope:/root/.cache/modelscope \
  -v ./models/huggingface:/root/.cache/huggingface \
  -v ./logs:/app/logs \
  -v ./temp:/app/temp \
  quantatrisk/funasr-api:gpu-latest
```

### CPU版本

```bash
docker run -d --name funasr-api \
  -p 17003:8000 \
  -e ENABLED_MODELS=paraformer-large \
  -e API_KEY=your_api_key \
  -v ./models/modelscope:/root/.cache/modelscope \
  -v ./logs:/app/logs \
  -v ./temp:/app/temp \
  quantatrisk/funasr-api:cpu-latest
```

## 支持的标签

| 标签 | 描述 |
|-----|-------------|
| `gpu-latest` | 带CUDA 12.6的GPU版本，支持自动模型选择 |
| `cpu-latest` | 仅CPU版本，仅支持Paraformer模型 |

## 功能特性

- **多模型支持**：Qwen3-ASR (1.7B/0.6B) + Paraformer Large
- **OpenAI API兼容**：提供`/v1/audio/transcriptions`端点
- **阿里云兼容**：RESTful和WebSocket流式API
- **说话人分离**：自动多说话人识别
- **词级时间戳**：Qwen3-ASR支持精确时间戳
- **智能远场滤波**：减少流式识别中的环境噪音
- **GPU批量处理**：批量推理速度提升2-3倍

## 环境变量

| 变量 | 默认值 | 描述 |
|----------|---------|-------------|
| `ENABLED_MODELS` | `auto` | 要加载的模型：`auto`、`all`或逗号分隔的列表 |
| `API_KEY` | - | API认证密钥（可选） |
| `LOG_LEVEL` | `INFO` | 日志级别：DEBUG, INFO, WARNING, ERROR |
| `MAX_AUDIO_SIZE` | `2048` | 最大音频文件大小（MB） |
| `ASR_BATCH_SIZE` | `4` | 推理批处理大小（GPU: 4, CPU: 2） |
| `MAX_SEGMENT_SEC` | `90` | 最大音频段持续时间（秒） |
| `DEVICE` | `auto` | 设备：`auto`、`cpu`、`cuda:0` |

## 自动模式行为

- **显存 >= 32GB**：自动加载`qwen3-asr-1.7b` + `paraformer-large`
- **显存 < 32GB**：自动加载`qwen3-asr-0.6b` + `paraformer-large`
- **无CUDA**：仅加载`paraformer-large`（Qwen3需要GPU）

## API端点

- **OpenAI兼容**：`POST /v1/audio/transcriptions`
- **阿里云兼容**：`POST /stream/v1/asr`
- **WebSocket**：`/ws/v1/asr`、`/ws/v1/asr/qwen`
- **健康检查**：`GET /stream/v1/asr/health`
- **API文档**：`http://localhost:17003/docs`

## 快速测试

```bash
# 健康检查
curl http://localhost:17003/stream/v1/asr/health

# 使用OpenAI API进行转录
curl -X POST "http://localhost:17003/v1/audio/transcriptions" \
  -H "Authorization: Bearer your_api_key" \
  -F "file=@audio.wav" \
  -F "model=qwen3-asr-1.7b" \
  -F "response_format=verbose_json"

# 使用阿里云API进行转录
curl -X POST "http://localhost:17003/stream/v1/asr" \
  -H "Content-Type: application/octet-stream" \
  --data-binary @audio.wav
```

## 模型存储

模型缓存在Docker卷中，支持离线使用：

```bash
# ModelScope模型（Paraformer, VAD, CAM++）
./models/modelscope:/root/.cache/modelscope

# HuggingFace模型（Qwen3-ASR，仅GPU）
./models/huggingface:/root/.cache/huggingface
```

首次运行会自动下载模型。如需离线部署，可预先下载：

```bash
# 使用辅助脚本（推荐）
./scripts/prepare-models.sh

# 或使用Docker手动下载
docker run --rm \
  -v ./models/modelscope:/root/.cache/modelscope \
  -v ./models/huggingface:/root/.cache/huggingface \
  quantatrisk/funasr-api:gpu-latest \
  python -c "from app.utils.download_models import download_models; download_models()"
```

## 资源要求

**最低要求（CPU）：**
- CPU：4核
- 内存：16GB
- 磁盘：20GB

**推荐配置（GPU）：**
- CPU：4核
- 内存：16GB
- GPU：NVIDIA GPU（16GB+显存）
- 磁盘：20GB

## 链接

- **GitHub**：https://github.com/Quantatirsk/funasr-api
- **文档**：https://github.com/Quantatirsk/funasr-api/tree/main/docs
- **问题跟踪**：https://github.com/Quantatirsk/funasr-api/issues

## 许可证

MIT许可证
