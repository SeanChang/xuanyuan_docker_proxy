---
image: ultralytics/yolov5
description: "YOLOv5是Ultralytics推出的开源视觉AI模型，支持目标检测、图像分割与分类任务，具备快速准确的推理能力，可导出为ONNX、CoreML、TFLite等多种格式，适用于多场景计算机视觉应用，Docker镜像提供便捷部署环境。"
source: https://xuanyuan.cloud/zh/r/ultralytics/yolov5
canonical: https://xuanyuan.cloud/zh/r/ultralytics/yolov5
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ultralytics/yolov5" title="ultralytics/yolov5 Docker 镜像中文简介、标签列表与拉取命令">ultralytics/yolov5 — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ultralytics/yolov5" title="ultralytics/yolov5 Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ultralytics/yolov5</a>

# YOLOv5 Docker镜像文档

## 镜像概述

YOLOv5是Ultralytics开源的先进视觉AI模型，代表了其在未来视觉AI方法上的研究成果。该模型以高效、准确、易用为特点，广泛应用于目标检测、图像分割和图像分类任务。YOLOv5 Docker镜像封装了完整的运行环境，无需手动配置依赖，可快速部署至各类平台，适用于开发、测试及生产环境。

## 核心功能与特性

- **多任务支持**：集成目标检测、图像分割、图像分类能力，满足多样化视觉需求
- **模型多样性**：提供多种尺寸模型（n/s/m/l/x），平衡速度与精度，适配不同硬件条件
- **跨平台部署**：支持导出为ONNX、CoreML、TFLite、TensorRT等多种格式，适配边缘设备至云端
- **高效推理**：优化的网络结构与推理流程，支持GPU加速，实现实时处理
- **易用性**：简洁的API与命令行接口，支持多种输入源（图像、视频、摄像头、网络流等）
- **开源生态**：丰富的教程、预训练模型及社区支持，便于二次开发与集成

## 适用场景

- **实时监控**：智能安防、人流统计、异常行为检测
- **自动驾驶**：交通目标识别、车道线检测、障碍物规避
- **工业质检**：产品缺陷检测、零件定位、装配验证
- **图像分析**：医学影像识别、遥感图像解析、文档扫描处理
- **机器人视觉**：物体抓取、环境感知、导航避障

## 使用方法

### 1. 获取镜像

从Docker Hub拉取官方镜像：

```bash
docker pull ultralytics/yolov5
```

### 2. 基本推理示例

#### 2.1 图像推理
挂载本地图像目录，对单张图像进行目标检测：

```bash
docker run -v $(pwd)/data:/app/data ultralytics/yolov5 \
  python detect.py --weights yolov5s.pt --source /app/data/input.jpg --save-dir /app/data/output
```

- `-v $(pwd)/data:/app/data`：将本地`data`目录挂载至容器内`/app/data`，用于输入输出
- `--weights yolov5s.pt`：使用小型模型（可替换为n/m/l/x，分别对应更小/更大模型）
- `--source`：指定输入源（本地路径需使用容器内路径，如`/app/data/input.jpg`）
- `--save-dir`：指定结果保存目录（容器内路径，对应本地`data/output`）

#### 2.2 视频推理
处理本地视频文件：

```bash
docker run -v $(pwd)/data:/app/data ultralytics/yolov5 \
  python detect.py --weights yolov5m.pt --source /app/data/video.mp4 --save-dir /app/data/video_output
```

#### 2.3 摄像头实时推理（需要主机摄像头权限）
```bash
docker run --device /dev/video0 -v $(pwd)/output:/app/runs/detect ultralytics/yolov5 \
  python detect.py --weights yolov5s.pt --source 0
```

- `--device /dev/video0`：映射主机摄像头设备至容器

### 3. 模型训练示例

挂载数据集与输出目录，使用自定义数据训练模型：

```bash
docker run -v $(pwd)/dataset:/app/dataset -v $(pwd)/runs:/app/runs ultralytics/yolov5 \
  python train.py --data /app/dataset/data.yaml --epochs 100 --weights yolov5s.pt --batch-size 16 --img 640
```

- `--data`：指定数据集配置文件（需包含训练集/验证集路径、类别数等信息）
- `--epochs`：训练轮次
- `--batch-size`：批次大小（根据GPU内存调整）
- `--img`：输入图像尺寸

### 4. 模型导出

将训练好的模型导出为ONNX格式：

```bash
docker run -v $(pwd)/runs:/app/runs ultralytics/yolov5 \
  python export.py --weights /app/runs/train/exp/weights/best.pt --include onnx --img 640
```

- `--include`：指定导出格式（onnx, coreml, tflite, engine等）

## 常用配置参数

| 参数 | 说明 | 示例 |
|------|------|------|
| `--weights` | 模型权重文件路径 | `yolov5s.pt` 或自定义路径 |
| `--source` | 输入源 | `0`(摄像头)、`img.jpg`、`video.mp4`、`rtsp://...` |
| `--img` | 输入图像尺寸 | `640`(默认)、`1280` |
| `--conf-thres` | 置信度阈值 | `0.25`(默认)、`0.5` |
| `--iou-thres` | IOU阈值 | `0.45`(默认) |
| `--device` | 计算设备 | `0`(GPU)、`cpu` |
| `--save-dir` | 结果保存目录 | `/app/output` |
| `--batch-size` | 训练批次大小 | `16`、`32`(需匹配GPU内存) |
| `--epochs` | 训练轮次 | `100`、`300` |

## 许可证信息

- **开源许可证**：采用AGPL-3.0开源许可证，适用于学术研究与非商业用途，详见[LICENSE](https://github.com/ultralytics/yolov5/blob/master/LICENSE)
- **商业许可**：如需将YOLOv5集成至商业产品或服务，需联系Ultralytics获取企业许可证，详情参见[Ultralytics Licensing](https://ultralytics.com/license)

## 支持与社区

- **文档**：完整使用指南参见[YOLOv5 Docs](https://docs.ultralytics.com/yolov5)
- **问题反馈**：GitHub Issues ([ultralytics/yolov5](https://github.com/ultralytics/yolov5/issues))
- **社区交流**：[Discord](https://ultralytics.com/discord)、[GitHub Discussions](https://github.com/ultralytics/yolov5/discussions)
- **更新动态**：关注[Ultralytics Twitter](https://twitter.com/ultralytics)或[GitHub Releases](https://github.com/ultralytics/yolov5/releases)获取最新模型与功能
