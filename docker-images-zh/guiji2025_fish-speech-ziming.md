<!-- xuanyuan-docker-images-zh
image: guiji2025/fish-speech-ziming
source: https://xuanyuan.cloud/zh/r/guiji2025/fish-speech-ziming
canonical: https://xuanyuan.cloud/zh/r/guiji2025/fish-speech-ziming
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/guiji2025/fish-speech-ziming" title="guiji2025/fish-speech-ziming Docker 镜像中文简介、标签列表与拉取命令">guiji2025/fish-speech-ziming — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/guiji2025/fish-speech-ziming" title="guiji2025/fish-speech-ziming Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/guiji2025/fish-speech-ziming</a></p>

# fish-speech-ziming 镜像使用指南

## 一、镜像概述与核心优势

`fish-speech-ziming` 镜像基于 Fish Speech 1.5 构建，继承其多语言支持、低显存需求与高自然度合成等特性，并针对环境配置痛点进行优化，避免官方脚本可能导致的环境混乱。

- **核心功能**：支持中文、英语、日语等 8 种语言的 TTS 文本到语音转换，具备语音克隆、模型微调（LoRA）、可选 WebUI 等能力。
- **硬件优势**：推理 ≥4GB 显存可用；语音克隆建议 ≥6GB；LoRA 微调 ≥8GB；兼容主流 NVIDIA 显卡（CUDA 12.x）。
- **镜像优化**：预装 Python 3.10 虚拟环境、PyTorch 2.4.1 及匹配 torchaudio，开箱即用。
- **速度优势**：集成优化推理，在 RTX 4060 上实时因子约 1:5，RTX 4090 约 1:15。

## 二、前置准备

### 2.1 硬件要求

| 功能场景 | 显存要求 | 其他要求 |
| --- | --- | --- |
| 基础推理（随机音色） | ≥4GB | NVIDIA 显卡（CUDA 12.x），硬盘预留 ≥20GB（含模型与数据） |
| 语音克隆推理 | ≥6GB | — |
| 模型微调（LoRA） | ≥8GB | — |

### 2.2 软件环境

- 操作系统：Linux（Ubuntu 20.04+/CentOS 7+ 推荐）、Windows 10/11（需 WSL2）、macOS（Intel 芯片）。
- 容器工具：Docker 19.03+ 或 Podman 3.0+，GPU 访问需安装 `nvidia-docker2`。
- 网络环境：首次使用需联网下载预训练模型（国内建议镜像加速/手动下载）。
- 浏览器：WebUI 建议 Chrome 100+ / Firefox 98+。

## 三、镜像启动与基础配置

### 3.1 镜像拉取

```bash
docker pull docker.xuanyuan.run/r/guiji2025/fish-speech-ziming:latest
```

### 3.2 容器启动

> 建议将模型与数据目录挂载到宿主机，避免容器重建后数据丢失。

#### 3.2.1 基础推理模式（默认）

```bash
docker run -d \
  --name fish-speech-ziming \
  --gpus all \
  -p 7862:7862 \
  -v /宿主机/模型路径:/app/checkpoints \
  -v /宿主机/数据路径:/app/data \
  docker.xuanyuan.run/r/guiji2025/fish-speech-ziming:latest
```

参数说明：`--gpus all` 允许容器使用所有 GPU；`-v` 为目录挂载，`/宿主机路径` 请替换为实际本地路径。

#### 3.2.2 API 服务模式

```bash
docker run -d \
  --name fish-speech-api \
  --gpus all \
  -p 8000:8000 \
  -v /宿主机/模型路径:/app/checkpoints \
  docker.xuanyuan.run/r/guiji2025/fish-speech-ziming:latest \
  --api --port 8000
```

### 3.3 容器状态检查

```bash
docker ps | grep fish-speech-ziming
docker logs -f fish-speech-ziming
```

若日志出现 “Gradio UI launched at http://0.0.0.0:7862”，表示启动成功。

## 四、核心功能使用教程

### 4.1 预训练模型下载

容器启动后可在容器内下载官方模型，或在宿主机手动下载后挂载：

```bash
# 进入容器
docker exec -it fish-speech-ziming /bin/bash

# 下载 Fish Speech 1.5 预训练模型
huggingface-cli download fishaudio/fish-speech-1.5 --local-dir /app/checkpoints/fish-speech-1.5
```

> 国内下载缓慢时，可手动从 Hugging Face 获取后解压到宿主机挂载的 `/宿主机/模型路径`。

### 4.2 WebUI 推理

浏览器访问 `http://localhost:7862`，支持随机音色与语音克隆两种模式。

#### 4.2.1 随机音色合成

1. 在左侧“文本输入”填写需合成文本（支持多语言混合）。
2. 点击“文本规范化”提升合成准确性。
3. 在“模型配置”选择 `/app/checkpoints/fish-speech-1.5`。
4. 调整参数：语速（默认 1.0）、情感强度（0.0–2.0）、采样率（建议 22050Hz）。
5. 点击“生成语音”，完成后可预览或下载 WAV。

#### 4.2.2 语音克隆（个性化合成）

1. 切换到“参考音频”标签页并启用功能。
2. 上传 5–30 秒清晰语音（WAV 最佳）。
3. 在“参考文本”中填写参考音频的准确文字。
4. 回到“文本输入”填写目标文本并生成。
5. 通过“克隆强度”等参数微调效果。

> 参考音频需尽量无噪声；文本匹配度越高，克隆效果越自然。建议单段文本 ≤500 字。

### 4.3 模型微调（LoRA）

#### 4.3.1 数据集准备

- 音频：WAV、22050Hz、单声道、每段 3–10 秒。
- 文本：同名 `.lab` 文件，内容为对应纯文本。
- 规模：≥50 段音频，总时长 10–30 分钟更佳。

目录结构示例：

```
data/
├── train/
│   ├── audio1.wav
│   ├── audio1.lab
│   ├── audio2.wav
│   └── audio2.lab
└── val/
    ├── val1.wav
    └── val1.lab
```

#### 4.3.2 微调命令

```bash
# 进入容器
docker exec -it fish-speech-ziming /bin/bash

# 执行 LoRA 微调
python tools/finetune.py \
  --model-path /app/checkpoints/fish-speech-1.5 \
  --data-dir /app/data \
  --output-dir /app/checkpoints/lora-finetuned \
  --lora-r 8 \
  --batch-size 4 \
  --epochs 10
```

参数说明：`--lora-r` 越小显存占用越低；`--batch-size` 视显存调整（8GB 显存建议 4）。

#### 4.3.3 使用微调模型

在 WebUI “模型配置”中选择 `/app/checkpoints/lora-finetuned`。

## 五、常见问题与解决方案（FAQ）

| 问题现象 | 可能原因 | 解决方案 |
| --- | --- | --- |
| 启动提示 GPU access denied | 未安装 nvidia-docker2 或驱动不兼容 | 安装 `nvidia-docker2`；使用 `nvidia-smi` 检查 CUDA 版本 ≥12.1 |
| 模型下载缓慢/失败 | 网络限制 | 使用国内镜像或手动下载后挂载 |
| 微调显存不足报错 | batch-size 过大或 LoRA 秩过高 | 降低 batch-size 至 2/1；将 `--lora-r` 降至 4；加 `--gradient-accumulation-steps 2` |
| Triton 加速报错找不到 CUDA | 加速组件与 CUDA 不匹配 | 暂时禁用 Triton 加速，移除相关参数 |

## 六、进阶与扩展

### 6.1 GUI 客户端

容器内可安装 PyQt6 GUI：

```bash
pip install fish-speech-gui
fish-speech-gui
```

Windows 建议通过 VNC 显示 GUI；Linux 可用 X11 转发。

### 6.2 批量合成脚本

在宿主机创建脚本并挂载到容器：

```python
# batch_synthesis.py
from fish_speech.inference import TextToSpeech
import os

# 初始化 TTS 引擎
tts = TextToSpeech(model_path="/app/checkpoints/fish-speech-1.5")

# 批量处理文本文件（每行一段文本）
with open("/app/data/texts.txt", "r", encoding="utf-8") as f:
    texts = f.readlines()

# 生成音频并保存
for i, text in enumerate(texts):
    text = text.strip()
    if not text:
        continue
    audio = tts.synthesize(text, speed=1.0)
    with open(f"/app/data/output/audio_{i}.wav", "wb") as f:
        f.write(audio)
print("批量合成完成！")
```

容器内执行：

```bash
python /app/data/batch_synthesis.py
```

## 七、参考资源

- Fish Speech 官方文档：<https://speech.fish.audio/zh/>
- 预训练模型下载：<https://huggingface.co/fishaudio/fish-speech-1.5>
- GUI 客户端源码：<https://github.com/AnyaCoder/fish-speech-gui>

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/guiji2025/fish-speech-ziming" title="guiji2025/fish-speech-ziming Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/guiji2025/fish-speech-ziming</a></p>
