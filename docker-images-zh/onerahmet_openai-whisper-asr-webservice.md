---
image: onerahmet/openai-whisper-asr-webservice
description: "whisper-asr-webservice 是一个基于 OpenAI Whisper 语音识别模型构建的 Web 服务，提供便捷的 API 接口，支持多语言语音到文本的实时或批量转录，用户可根据需求选择 tiny、base、small、medium、large 等不同大小的模型，具备易于部署、高效准确的特点，适用于将语音识别功能快速集成到各类应用、服务或系统中。"
source: https://xuanyuan.cloud/zh/r/onerahmet/openai-whisper-asr-webservice
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[onerahmet/openai-whisper-asr-webservice](https://xuanyuan.cloud/zh/r/onerahmet/openai-whisper-asr-webservice)
> 含镜像标签、拉取命令、部署文档与相关推荐。

![Release]([])
![Docker Pulls]([])
![Build]([])
![Licence]([])


# Whisper ASR Box

Whisper ASR Box 是一款通用语音识别工具包。其模型基于大规模多样化音频数据集训练，支持多语言语音识别、语音翻译及语言识别等多任务处理。


## 支持模型

当前 v1.8.2 版本支持以下语音识别模型：
- [openai/whisper]([])（版本 [v20240930]([])）
- [SYSTRAN/faster-whisper]([])（版本 [v1.1.0]([])）
- [whisperX]([])（版本 [v3.1.1]([])）


## 快速使用

### CPU 版本
通过 Docker 启动 CPU 服务：
```shell
docker run -d -p 9000:9000 \
  -e ASR_MODEL=base \
  -e ASR_ENGINE=openai_whisper \
  onerahmet/openai-whisper-asr-webservice:latest
```

### GPU 版本
需确保已安装 NVIDIA Docker 支持，启动命令：
```shell
docker run -d --gpus all -p 9000:9000 \
  -e ASR_MODEL=base \
  -e ASR_ENGINE=openai_whisper \
  onerahmet/openai-whisper-asr-webservice:latest-gpu
```

#### 缓存设置
为避免重复下载模型、缩短启动时间，可持久化缓存目录：
```shell
docker run -d -p 9000:9000 \
  -v $PWD/cache:/root/.cache/ \
  onerahmet/openai-whisper-asr-webservice:latest
```


## 核心功能
- 多引擎支持：OpenAI Whisper、Faster Whisper、WhisperX
- 多输出格式：文本（text）、JSON、VTT、SRT、TSV
- 词级时间戳标注
- 语音活动检测（VAD）过滤
- 说话人分离（WhisperX 支持）
- FFmpeg 集成：支持多种音视频格式
- GPU 加速
- 模型加载/卸载可配置
- REST API 带 Swagger 文档


## 环境变量配置
关键参数说明：
- `ASR_ENGINE`：引擎选择（openai_whisper / faster_whisper / whisperx）
- `ASR_MODEL`：模型规格（tiny / base / small / medium / large-v3 等）
- `ASR_MODEL_PATH`：自定义模型存储/加载路径
- `ASR_DEVICE`：运行设备（cuda / cpu）
- `MODEL_IDLE_TIMEOUT`：模型闲置卸载超时时间


## 完整文档
详细使用说明及配置项参见：  
[[]]([])


## 开发指南
### 本地部署步骤
1. 安装 poetry：
```shell
pip3 install poetry
```

2. 安装依赖：
```shell
poetry install
```

3. 启动服务：
```shell
poetry run whisper-asr-webservice --host 0.0.0.0 --port 9000
```

服务启动后，访问 `[] 或 `[] 可打开 Swagger UI，测试 API 接口。


## 第三方依赖声明
本软件使用 [FFmpeg]([]) 项目的库，遵循 [LGPLv2.1]([]) 许可证。
