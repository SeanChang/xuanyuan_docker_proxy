---
image: fishaudio/fish-speech
description: "Fish Speech官方容器镜像，用于部署和运行Fish Speech语音处理相关应用，提供官方支持的标准化运行环境。"
source: https://xuanyuan.cloud/zh/r/fishaudio/fish-speech
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[fishaudio/fish-speech](https://xuanyuan.cloud/zh/r/fishaudio/fish-speech)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Fish Speech Docker 镜像文档

## 镜像概述和主要用途

Fish Speech（现更名为OpenAudio）是一个开源的多语言文本转语音（TTS）工具，支持语音克隆功能。该Docker镜像提供了便捷的部署方式，让用户能够快速体验和集成高质量的文本转语音技术。OpenAudio系列模型在TTS-Arena2基准测试中排名第一，具备卓越的语音合成质量和多语言支持能力。

## 核心功能和特性

### 卓越的TTS质量

OpenAudio S1模型在Seed TTS评估指标中表现优异，在英文文本上实现了**0.008 WER**（词错误率）和**0.004 CER**（字符错误率），显著优于先前模型。

| 模型 | 词错误率 (WER) | 字符错误率 (CER) | 说话人相似度 |
|------|---------------|-----------------|------------|
| **S1** | **0.008** | **0.004** | **0.332** |
| **S1-mini** | **0.011** | **0.005** | **0.380** |

### 语音控制能力

支持多种情感、语调和特殊标记来增强语音合成：

- **基本情感**：(angry) (sad) (excited) (surprised) (satisfied) 等
- **高级情感**：(disdainful) (unhappy) (anxious) (hysterical) 等
- **语调标记**：(in a hurry tone) (shouting) (whispering) (soft tone) 等
- **特殊音频效果**：(laughing) (sobbing) (sighing) (panting) 等

### 核心功能

1. **零样本和少样本TTS**：仅需10-30秒的语音样本即可生成高质量TTS输出
2. **多语言和跨语言支持**：支持英语、日语、韩语、中文、法语、德语、阿拉伯语和西班牙语
3. **无需音素依赖**：模型具有很强的泛化能力，可处理任何语言脚本的文本
4. **高精度**：实现约0.4%的CER和0.8%的WER
5. **快速性能**：通过torch编译加速，在Nvidia RTX 4090 GPU上实时因子约为1:7
6. **WebUI界面**：基于Gradio的易用Web界面，兼容主流浏览器
7. **GUI界面**：提供PyQt6图形界面，支持Linux、Windows和macOS

### 两种模型类型

| 模型 | 大小 | 可用性 | 特点 |
|------|------|--------|------|
| **S1** | 4B参数 | [fish.audio](https://fish.audio/) | 全功能旗舰模型 |
| **S1-mini** | 0.5B参数 | [Hugging Face](https://huggingface.co/spaces/fishaudio/openaudio-s1-mini) | 精简版，保留核心功能 |

## 使用场景和适用范围

- 文本转语音应用开发
- 语音助手和虚拟人语音生成
- 有声内容创作和音频书籍制作
- 多语言语音合成需求
- 语音克隆和个性化语音生成
- 教育、无障碍和辅助技术应用

## 快速开始

### 前提条件

- Docker Engine 20.10+
- 对于GPU加速:
  - NVIDIA GPU with CUDA support
  - NVIDIA Container Toolkit

### 基本使用 (Web UI)

```bash
docker run -p 7860:7860 --name fish-speech fishaudio/fish-speech
```

访问 `http://localhost:7860` 即可使用Web界面。

### GPU加速

```bash
docker run --gpus all -p 7860:7860 --name fish-speech fishaudio/fish-speech
```

### 后台运行

```bash
docker run -d --gpus all -p 7860:7860 --name fish-speech fishaudio/fish-speech
```

## 高级配置

### Docker Compose 部署

创建 `docker-compose.yml` 文件:

```yaml
version: '3.8'

services:
  fish-speech:
    image: fishaudio/fish-speech
    container_name: fish-speech
    restart: unless-stopped
    ports:
      - "7860:7860"  # Web UI端口
      - "5000:5000"  # API端口
    volumes:
      - ./data:/app/data  # 数据持久化
      - ./models:/app/models  # 模型文件
    environment:
      - MODEL_TYPE=s1-mini  # 模型类型: s1 或 s1-mini
      - ENABLE_API=true     # 启用API服务
      - CORS_ALLOWED_ORIGINS=*  # CORS设置
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

启动服务:

```bash
docker-compose up -d
```

### 环境变量配置

| 环境变量 | 说明 | 默认值 | 可选值 |
|---------|------|--------|--------|
| `MODEL_TYPE` | 模型类型选择 | `s1-mini` | `s1`, `s1-mini` |
| `ENABLE_WEBUI` | 是否启用Web UI | `true` | `true`, `false` |
| `ENABLE_API` | 是否启用API服务 | `false` | `true`, `false` |
| `WEBUI_PORT` | Web UI端口 | `7860` | 1-65535 |
| `API_PORT` | API服务端口 | `5000` | 1-65535 |
| `CORS_ALLOWED_ORIGINS` | CORS允许的源 | `*` | 具体域名或`*` |
| `LOG_LEVEL` | 日志级别 | `info` | `debug`, `info`, `warning`, `error` |
| `MAX_BATCH_SIZE` | 最大批处理大小 | `4` | 正整数 |
| `CACHE_DIR` | 缓存目录 | `/app/cache` | 容器内路径 |

### 模型持久化

为避免每次启动重新下载模型，可以将模型目录挂载到宿主机:

```bash
docker run --gpus all -p 7860:7860 \
  -v ./fish-speech-models:/app/models \
  --name fish-speech fishaudio/fish-speech
```

### API 使用示例

启用API后，可以通过HTTP请求调用TTS服务:

```bash
curl -X POST http://localhost:5000/tts \
  -H "Content-Type: application/json" \
  -d '{
    "text": "你好，这是Fish Speech的API示例。",
    "speaker_id": 0,
    "emotion": "neutral",
    "speed": 1.0,
    "pitch": 0.0
  }' --output output.wav
```

## 许可证信息

- 代码库采用 **Apache License** 许可
- 所有模型权重采用 **CC-BY-NC-SA-4.0 License** 许可

> **法律声明**：我们不对代码库的任何非法使用承担责任。请参考当地关于DMCA和其他相关法律的规定。

## 相关资源

- [官方网站](https://fish.audio)
- [GitHub 仓库](https://github.com/fishaudio/fish-speech)
- [模型下载](https://huggingface.co/fishaudio)
- [技术报告](https://arxiv.org/abs/2411.01156)
- [文档中心](https://speech.fish.audio)

## 引用

```bibtex
@misc{fish-speech-v1.4,
      title={Fish-Speech: Leveraging Large Language Models for Advanced Multilingual Text-to-Speech Synthesis},
      author={Shijia Liao and Yuxuan Wang and Tianyu Li and Yifan Cheng and Ruoyi Zhang and Rongzhi Zhou and Yijin Xing},
      year={2024},
      eprint={2411.01156},
      archivePrefix={arXiv},
      primaryClass={cs.SD},
      url={https://arxiv.org/abs/2411.01156},
}
