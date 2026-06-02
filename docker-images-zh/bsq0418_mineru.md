---
image: bsq0418/mineru
description: "基于NEON优化的arm64 Docker镜像，集成MinerU PDF智能工具包（magic-pdf[full]），可将PDF转换为Markdown、JSON等结构化格式，预下载模型，适用于Apple Silicon、AWS Graviton等arm64环境，无需GPU即可运行。"
source: https://xuanyuan.cloud/zh/r/bsq0418/mineru
canonical: https://xuanyuan.cloud/zh/r/bsq0418/mineru
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bsq0418/mineru" title="bsq0418/mineru Docker 镜像中文简介、标签列表与拉取命令">bsq0418/mineru — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bsq0418/mineru" title="bsq0418/mineru Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bsq0418/mineru</a>

# MinerU Docker镜像指南

## 概述
本仓库构建了MinerU PDF智能工具包的Docker镜像。该镜像包含`magic-pdf[full]`及必要配置，可在容器内直接将PDF转换为Markdown、JSON等结构化格式。基于Arm优化的`armswdev/pytorch-arm-neoverse`基础镜像构建，适用于Apple Silicon、AWS Graviton及其他arm64主机。

关于MinerU的功能、算法组件和配置选项详情，请参考官方文档：
- MinerU GitHub: <https://github.com/opendatalab/MinerU>
- MinerU 用户指南: <https://opendatalab.github.io/MinerU/>

## 支持场景与限制
- 本镜像针对MinerU **Pipeline**版本，包含传统YOLO + OCR + 表格/公式模型，**不提供**官方项目最新的视觉语言（VLM） pipeline。
- 所有必要模型已预下载至`/mineru/models`，无需额外设置。
- 在arm64上启用NEON指令，即使在纯CPU环境下也能提供稳定吞吐量。
- 最适合Arm CPU部署（如Apple Silicon、AWS Graviton等），无需GPU依赖即可实现纯CPU加速。

## 镜像亮点
- 集成`magic-pdf[full]`、`huggingface_hub`及布局、OCR、公式、表格识别所需依赖。
- 包含即用型`magic-pdf.json`配置，容器可开箱即用。
- 安装`libgl1`确保OpenCV和PaddleOCR在无头环境中正常运行。
- 在`/mineru/models`缓存PDF Extract Kit和LayoutReader资源，针对Arm CPU/NEON优化，减少冷启动延迟。

## 快速开始
### 1. 拉取镜像
```bash
docker pull <dockerhub-namespace>/mineru:<tag>
```
将`<dockerhub-namespace>`和`<tag>`替换为Docker Hub上发布的仓库和标签。

### 2. 启动带挂载工作区的容器
```bash
docker run --name mineru-dev \
  -v $(pwd)/data:/workspace \
  -it <dockerhub-namespace>/mineru:<tag> /bin/bash
```
- `$(pwd)/data`用于存放待处理PDF和输出文件。
- 默认工作目录为`/mineru`；`magic-pdf.json`已复制到`/root/`和`/home/ubuntu/`。

### 3. 在容器内运行转换任务
```bash
magic-pdf run \
  --config /root/magic-pdf.json \
  --input /workspace/input.pdf \
  --output /workspace/output_dir \
  --task pdf2md
```
- 根据需求将`--task`切换为`pdf2json`、`pdf2html`等，完整CLI参考请查阅官方文档。
- 如需处理单张图片，可参考本仓库中的`picture_test.py`示例脚本。

## 仓库布局
- `Dockerfile`: 镜像构建说明。
- `magic-pdf.json`: 默认配置，包含模型位置、OCR/表格/公式识别开关及可选LLM钩子。
- `models/`: 预存的MinerU/MoTao模型缓存。
- `download_models_hf.py`: 通过Hugging Face Hub刷新模型/配置的脚本。
- `picture_test.py`: 对单张图片运行布局+OCR的示例脚本。
- `docker_start.sh`: 将仓库根目录挂载到`/app`的示例启动脚本。

## 更新模型与配置
- 如需同步更新模型，在容器内运行`python download_models_hf.py`。该脚本使用`huggingface_hub.snapshot_download`并更新`magic-pdf.json`中的路径。
- 公式和表格识别默认启用，可通过修改`/root/magic-pdf.json`中对应部分禁用，或激活LLM辅助功能。
- 如需启用通义千问等LLM辅助功能，在配置中填写`api_key`和`base_url`字段，并将`enable`设为`true`。

## FAQ
- **架构**：仅适用于arm64架构。
- **模型大小**：捆绑模型较大，拉取时需确保足够带宽和磁盘空间。
- **网络访问**：如需重新下载资源，需允许容器访问Hugging Face Hub。
- **GPU支持**：本镜像针对CPU工作流。如需GPU/ACL加速，需按官方文档更换基础镜像并调整`device-mode`。

## 致谢
本镜像基于OpenDataLab社区的MinerU解决方案构建。感谢项目维护者和贡献者提供的提取管道和预训练资源。高级场景（如区域提取、批处理管道、生产部署）请参考MinerU官方文档。
