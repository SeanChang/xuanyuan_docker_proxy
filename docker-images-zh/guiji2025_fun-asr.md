<!-- xuanyuan-docker-images-zh
image: guiji2025/fun-asr
source: https://xuanyuan.cloud/zh/r/guiji2025/fun-asr
canonical: https://xuanyuan.cloud/zh/r/guiji2025/fun-asr
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [guiji2025/fun-asr — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/guiji2025/fun-asr "guiji2025/fun-asr Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/guiji2025/fun-asr

# guiji2025/fun-asr 镜像使用指南

## 一、镜像概述与核心定位

`guiji2025/fun-asr` 是基于阿里达摩院开源语音识别工具包 FunASR 的容器化部署镜像，核心作用是快速提供工业级语音识别（ASR）服务。FunASR 是面向学术与工业场景的开源语音识别工具包，集成了达摩院语音实验室的核心能力（如高精度 ASR 模型、语音端点检测 VAD、标点恢复 PUNC），而该镜像通过 Docker 封装，跳过复杂的环境配置（如依赖安装、模型下载、硬件适配），让开发者通过拉取镜像即可快速启动语音识别服务。

### 核心价值

- **全链路语音识别**：集成 VAD（语音端点检测）+ ASR（语音识别）+ PUNC（标点恢复）完整流程，实现「音频输入 → 带标点文字输出」
- **即开即用**：预装 FunASR 核心模块与 Paraformer-large 等高精度模型，无需手动配置环境
- **多场景适配**：支持离线批量转写、实时流式识别、高并发处理，适配 CPU/GPU 硬件
- **生产级质量**：基于达摩院工业级技术，识别准确率高，支持长音频、多格式输入

## 二、核心功能与特性

### 2.1 完整语音识别链路

#### 语音端点检测（VAD）

自动识别音频中的「有效语音段」与「静音段」，过滤无效噪声，提升识别准确性与处理效率。

**优势**：有效分离语音与静音，减少无效音频的识别开销。

#### 语音识别（ASR）

基于 Paraformer-large 等高精度模型，支持中文/英文语音转文字，识别准确率适配日常对话、会议录音等场景。

**模型特性**：
- 中文识别：支持普通话、多种方言
- 英文识别：针对英文语音优化
- 准确率高：基于达摩院先进算法

#### 标点恢复（PUNC）

自动为识别结果添加逗号、句号等标点，提升文本可读性，避免「纯文字无断句」的阅读障碍。

**优势**：输出即用的格式化文本，无需人工后期处理。

### 2.2 多场景语音处理能力

#### 离线批量转写

支持处理几十小时的长音频/视频文件，支持通过 `wav.scp` 列表批量输入多文件。

**支持的格式**：
- 音频：`.wav`、`.pcm`、`.mp3`、`.flac`、`.m4a`
- 视频：`.mp4`、`.avi`、`.mov`

**典型场景**：
- 会议录音批量转写
- 视频字幕自动生成
- 音频内容归档检索

#### 实时流式识别

针对低延迟优化，支持实时语音交互场景。

**典型应用**：
- 智能客服语音输入
- 实时字幕显示
- 语音输入法
- 语音助手

#### 高并发支撑

支持上百路请求同时转写，满足企业级多用户并发使用需求。

**技术特性**：
- 动态批处理（GPU 版本）
- 请求队列管理
- 资源优化调度

### 2.3 硬件与格式兼容性

| 维度 | 详细信息 |
| --- | --- |
| **CPU 版本** | 支持 ARM64 架构，低内存占用，适合无 GPU 环境 |
| **GPU 版本** | 基于 NVIDIA CUDA，动态批处理，提升识别速度 |
| **输入格式** | 兼容主流音频（.wav、.pcm、.mp3）与视频（.mp4）格式 |
| **无需转码** | 直接处理多格式输入，减少预处理步骤 |

## 三、镜像版本与选择建议

根据 FunASR 的部署需求，该镜像提供多版本细分，适配不同场景：

| 镜像版本类型 | 核心特性 | 适配场景 | 推荐标签 |
| --- | --- | --- | --- |
| **中文 CPU 版** | Ubuntu 20.04 基础，ARM64 兼容，低内存占用 | 通用中文场景、无 GPU 环境、普通服务器 | `latest` 或 `cpu` |
| **中文 GPU 版** | 基于 NVIDIA CUDA，动态批处理，高识别速度 | 高性能中文场景、批量长音频转写、高并发 | `gpu` 或 `cuda` |
| **英文 CPU 版** | 专为英语语音优化，修复内存泄漏问题 | 英文语音识别、海外业务、英文会议 | `en-cpu` |
| **实时服务版** | 低延迟流式处理，支持实时请求响应 | 实时语音交互、智能助手、实时字幕 | `online` |

### 版本选择建议

1. **普通服务器、预算有限**：选择 CPU 版本
2. **需要高性能、有 GPU 资源**：选择 GPU 版本
3. **主要是英文识别**：选择英文版本
4. **需要实时交互**：选择实时服务版

## 四、前置准备

### 4.1 硬件与软件要求

| 项目 | 要求 |
| --- | --- |
| **硬件** | CPU：多核处理器；GPU（可选）：NVIDIA GPU 支持 CUDA |
| **操作系统** | Linux（推荐 Ubuntu 20.04+），macOS（Docker Desktop），Windows（WSL2） |
| **容器工具** | Docker 19.03+，如需 GPU 需安装 NVIDIA Container Runtime |
| **存储空间** | 建议预留 ≥2GB（镜像） + 模型文件空间 |
| **网络环境** | 首次使用需联网下载模型，建议科学上网或使用国内镜像源 |

### 4.2 GPU 环境准备（如使用 GPU 版本）

```bash
# 安装 NVIDIA Container Runtime
# Ubuntu/Debian
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker

# 验证 GPU 支持
docker run --rm --gpus all nvidia/cuda:12.0.0-base-ubuntu22.04 nvidia-smi
```

## 五、镜像拉取与启动

### 5.1 拉取镜像

```bash
# 拉取最新版本
docker pull docker.xuanyuan.run/r/guiji2025/fun-asr:latest

# 拉取 GPU 版本
docker pull docker.xuanyuan.run/r/guiji2025/fun-asr:gpu

# 拉取英文版本
docker pull docker.xuanyuan.run/r/guiji2025/fun-asr:en-cpu
```

### 5.2 基础启动命令

#### CPU 版本启动

```bash
docker run -d \
  --name fun-asr \
  -p 10095:10095 \
  -v /宿主机/模型路径:/root/funasr-runtime-resources \
  docker.xuanyuan.run/r/guiji2025/fun-asr:latest
```

#### GPU 版本启动

```bash
docker run -d \
  --name fun-asr-gpu \
  --runtime=nvidia \
  --privileged=true \
  -p 10095:10095 \
  -v /宿主机/模型路径:/root/funasr-runtime-resources \
  -w /workspace/FunASR/runtime \
  docker.xuanyuan.run/r/guiji2025/fun-asr:gpu \
  sh /run.sh
```

#### 完整 docker-compose 配置示例

参考 HeyGem AI 数字人项目的实际应用：

```yaml
version: '3.8'

services:
  heygem-asr:
    image: guiji2025/fun-asr
    container_name: heygem-asr
    restart: always
    runtime: nvidia  # 启用 GPU 加速
    privileged: true
    working_dir: /workspace/FunASR/runtime
    ports:
      - '10095:10095'  # 服务端口
    volumes:
      - ./models:/root/funasr-runtime-resources  # 模型目录挂载
    command: sh /run.sh  # 启动服务脚本
```

### 5.3 参数说明

| 参数 | 说明 | 示例 |
| --- | --- | --- |
| `-p 10095:10095` | 映射服务端口（FunASR 默认端口） | 宿主机端口:容器端口 |
| `--runtime=nvidia` | 启用 GPU 支持（GPU 版本必需） | - |
| `--privileged=true` | 赋予容器特权（部分场景需要） | - |
| `-w /workspace/FunASR/runtime` | 设置工作目录 | FunASR 运行目录 |
| `-v /宿主机/模型路径:/root/funasr-runtime-resources` | 挂载模型目录到容器 | 模型与配置目录 |
| `sh /run.sh` | 启动服务脚本 | GPU 版本默认命令 |

## 六、API 使用示例

### 6.1 单音频文件识别

```bash
curl -X POST "http://localhost:10095/asr" \
  -H "Content-Type: application/json" \
  -d '{
    "audio": "base64_encoded_audio_data",
    "format": "wav",
    "language": "zh"
  }'
```

### 6.2 批量文件识别（使用 wav.scp）

创建 `wav.scp` 文件：

```
audio001 /path/to/audio001.wav
audio002 /path/to/audio002.wav
audio003 /path/to/audio003.wav
```

容器内执行：

```bash
docker exec -it fun-asr bash
cd /workspace/FunASR/runtime
./run.sh --wav.scp /path/to/wav.scp --output-dir /path/to/output
```

### 6.3 Python SDK 调用示例

```python
import requests
import base64

# 读取音频文件
with open("audio.wav", "rb") as f:
    audio_data = base64.b64encode(f.read()).decode('utf-8')

# 调用 ASR API
url = "http://localhost:10095/asr"
payload = {
    "audio": audio_data,
    "format": "wav",
    "language": "zh"  # zh: 中文, en: 英文
}

response = requests.post(url, json=payload)
result = response.json()
print(f"识别结果: {result.get('text', '')}")
```

### 6.4 实时流式识别

```python
import websocket
import json

# WebSocket 连接到实时服务
ws = websocket.WebSocket()
ws.connect("ws://localhost:10095/asr-stream")

# 发送音频数据流
# ... (音频流处理逻辑)

# 接收识别结果
result = ws.recv()
print(f"实时识别: {result}")

ws.close()
```

## 七、模型配置与替换

### 7.1 默认模型路径

容器内模型与资源目录：

```bash
/root/funasr-runtime-resources
```

### 7.2 使用自定义微调模型

如需替换为自定义模型，将模型文件挂载到容器：

```bash
docker run -d \
  --name fun-asr-custom \
  -p 10095:10095 \
  -v /宿主机/自定义模型:/root/funasr-runtime-resources \
  docker.xuanyuan.run/r/guiji2025/fun-asr:latest
```

### 7.3 模型来源

- **官方模型**：镜像内置的 ASR 模型（如 Paraformer-large）来自 ModelScope 社区
- **自定义模型**：支持替换为自定义微调模型
- **模型格式**：支持 FunASR 兼容的模型格式

## 八、测试与验证

### 8.1 容器状态检查

```bash
# 查看容器运行状态
docker ps | grep fun-asr

# 查看日志
docker logs -f fun-asr

# 进入容器调试
docker exec -it fun-asr bash
```

### 8.2 使用 samples 工具测试

进入容器后，使用 FunASR 内置的 samples 工具测试识别效果：

```bash
docker exec -it fun-asr bash
cd /root/funasr-runtime-resources/samples

# 运行测试脚本
./test.sh
```

### 8.3 测试 API 连接

```bash
# 检查服务健康状态
curl http://localhost:10095/health

# 发送测试请求
curl -X POST "http://localhost:10095/asr" \
  -H "Content-Type: application/json" \
  -d '{"test": "ping"}'
```

## 九、典型应用场景

### 9.1 AI 数字人语音服务

在 AI 数字人项目中集成 ASR 能力，实现语音交互：

```yaml
# docker-compose.yml 配置
digital-human:
  services:
    # AI 数字人交互模块
    interaction:
      image: digital-human-core
      depends_on:
        - asr-service
    
    # ASR 语音识别服务
    asr-service:
      image: guiji2025/fun-asr
      ports:
        - '10095:10095'
```

### 9.2 会议录音批量转写

处理大量会议录音，实现自动化转写：

```bash
# 批量转写脚本示例
docker exec -it fun-asr bash

for audio in /data/meetings/*.wav; do
    ./run.sh --audio "$audio" --output "/data/transcripts/$(basename $audio).txt"
done
```

### 9.3 智能客服语音输入

集成到智能客服系统，支持实时语音输入：

```python
# 客服系统集成示例
from funasr import ASR

# 初始化 ASR 客户端
asr_client = ASR(api_url="http://fun-asr:10095")

# 处理客服语音输入
def process_customer_voice(audio_stream):
    text = asr_client.transcribe(audio_stream)
    return handle_customer_query(text)
```

### 9.4 视频字幕自动生成

为视频内容自动生成字幕文件：

```bash
# 视频转字幕流程
# 1. 提取音频
docker exec -it fun-asr ffmpeg -i video.mp4 audio.wav

# 2. 识别转文字
docker exec -it fun-asr ./run.sh --audio audio.wav --output subtitle.srt
```

## 十、性能优化建议

### 10.1 内存优化

```bash
# 限制容器内存使用
docker run -d \
  --name fun-asr \
  --memory="4g" \
  --memory-swap="4g" \
  -p 10095:10095 \
  docker.xuanyuan.run/r/guiji2025/fun-asr:latest
```

### 10.2 CPU 核心限制

```bash
# 限制 CPU 使用核心数
docker run -d \
  --name fun-asr \
  --cpus="4" \
  -p 10095:10095 \
  docker.xuanyuan.run/r/guiji2025/fun-asr:latest
```

### 10.3 批量处理优化

对于大批量文件，建议使用 GPU 版本并调整批处理参数：

```bash
# GPU 版本 + 动态批处理
docker run -d \
  --name fun-asr-gpu \
  --runtime=nvidia \
  -p 10095:10095 \
  -e BATCH_SIZE=32 \
  -e MAX_CONCURRENT_REQUESTS=100 \
  docker.xuanyuan.run/r/guiji2025/fun-asr:gpu
```

## 十一、常见问题与解决方案（FAQ）

| 问题现象 | 可能原因 | 解决方案 |
| --- | --- | --- |
| 容器启动失败 | 端口冲突或资源不足 | 检查端口 10095 是否被占用；调整内存/CPU 限制 |
| GPU 不可用 | 未安装 NVIDIA Container Runtime | 安装 nvidia-container-toolkit 并重启 Docker |
| 识别准确率低 | 音频质量差或采样率不匹配 | 确保音频清晰、无噪声；检查采样率（推荐 16kHz/8kHz） |
| 批量处理速度慢 | 未使用 GPU 或批处理设置不当 | 切换到 GPU 版本；调整 batch_size 参数 |
| 实时识别延迟高 | 网络延迟或资源不足 | 检查网络状况；增加 CPU/GPU 资源 |
| 模型加载失败 | 模型路径错误或文件损坏 | 检查挂载路径；重新下载模型文件 |
| 英文识别效果差 | 使用中文版本处理英文 | 切换至英文版本（en-cpu 标签） |
| 并发处理崩溃 | 内存不足或线程数过多 | 限制并发数量；增加容器内存 |

## 十二、进阶配置

### 12.1 自定义配置

挂载自定义配置文件：

```bash
docker run -d \
  --name fun-asr-custom \
  -p 10095:10095 \
  -v /宿主机/config:/root/funasr-runtime-resources/config \
  docker.xuanyuan.run/r/guiji2025/fun-asr:latest
```

### 12.2 日志管理

挂载日志目录到宿主机：

```bash
docker run -d \
  --name fun-asr \
  -p 10095:10095 \
  -v /宿主机/logs:/workspace/FunASR/runtime/logs \
  docker.xuanyuan.run/r/guiji2025/fun-asr:latest
```

### 12.3 多语言切换

```bash
# 设置识别语言
docker run -d \
  --name fun-asr-multilang \
  -p 10095:10095 \
  -e LANGUAGE=zh  # zh: 中文, en: 英文
docker run -d \
  --name fun-asr-multilang \
  -p 10095:10095 \
  -e LANGUAGE=zh  # zh: 中文, en: 英文
  docker.xuanyuan.run/r/guiji2025/fun-asr:latest
```

## 十三、参考资源

- **FunASR 官方网站**：<https://github.com/alibaba-damo-academy/FunASR>
- **ModelScope 模型社区**：<https://modelscope.cn/models?page=1&tasks=auto-speech-recognition>
- **FunASR 官方文档**：<https://funasr.readthedocs.io/>
- **阿里达摩院语音实验室**：<https://damo.alibaba.com/labs/ai-speech>
- **HeyGem AI 数字人项目**：（如有公开链接）

---

**注意**：本镜像基于阿里达摩院 FunASR 开源工具包构建，建议根据实际场景选择合适的版本（CPU/GPU、中文/英文）。首次使用建议从 CPU 版本开始测试，确保环境配置正确后再部署生产环境。
