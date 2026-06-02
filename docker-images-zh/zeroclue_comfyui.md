---
image: zeroclue/comfyui
description: "ComfyUI的Docker镜像，提供可视化界面用于创建和运行AI生成图像工作流，支持Stable Diffusion等模型，简化部署与使用流程，适合AI图像生成研究和应用开发。"
source: https://xuanyuan.cloud/zh/r/zeroclue/comfyui
canonical: https://xuanyuan.cloud/zh/r/zeroclue/comfyui
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zeroclue/comfyui" title="zeroclue/comfyui Docker 镜像中文简介、标签列表与拉取命令">zeroclue/comfyui 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ComfyUI Docker镜像

## 概述

ComfyUI Docker镜像提供了一个预配置的环境，用于部署和运行ComfyUI——一个功能强大的可视化界面，用于创建和执行AI图像生成工作流。该镜像简化了ComfyUI的安装和配置过程，让用户能够快速开始使用Stable Diffusion等模型进行图像生成，无需处理复杂的依赖关系。

## 核心功能和特性

- 预配置的ComfyUI环境，包含所有必要依赖
- 可视化工作流编辑器，用于构建AI图像生成流程
- 支持多种Stable Diffusion模型
- 内置常用节点和扩展
- 简单的启动和配置选项
- 支持模型和工作流的持久化存储
- 兼容CPU和GPU运行环境

## 使用场景和适用范围

- AI图像生成研究与开发
- 数字艺术创作
- 内容创作者辅助工具
- 教育和学习AI生成技术
- 原型设计和概念验证
- 个人和小型团队使用

## 使用方法和配置说明

### 基本使用

使用以下命令快速启动ComfyUI容器：

```bash
docker run -p 8188:8188 zeroclue/comfyui
```

启动后，通过浏览器访问 `http://localhost:8188` 即可使用ComfyUI界面。

### 持久化存储

为保存模型和工作流数据，建议挂载本地目录：

```bash
docker run -p 8188:8188 \
  -v ./models:/app/models \
  -v ./workflows:/app/workflows \
  -v ./output:/app/output \
  zeroclue/comfyui
```

### Docker Compose 配置

创建`docker-compose.yml`文件：

```yaml
version: '3'
services:
  comfyui:
    image: zeroclue/comfyui
    ports:
      - "8188:8188"
    volumes:
      - ./models:/app/models
      - ./workflows:/app/workflows
      - ./output:/app/output
    restart: unless-stopped
    environment:
      - LOG_LEVEL=INFO
      - MAX_QUEUE_SIZE=10
```

启动服务：

```bash
docker-compose up -d
```

### 环境变量配置

可通过环境变量自定义配置：

- `PORT`: 服务端口，默认8188
- `LOG_LEVEL`: 日志级别(DEBUG, INFO, WARNING, ERROR)，默认INFO
- `MAX_QUEUE_SIZE`: 最大队列大小，默认10
- `ENABLE_EXTENSIONS`: 是否启用扩展，默认true

示例：
```bash
docker run -p 8188:8188 -e PORT=8000 -e LOG_LEVEL=DEBUG zeroclue/comfyui
```

## 模型管理

1. 将Stable Diffusion模型文件放入本地`models`目录
2. 确保模型文件格式正确（通常为.safetensors或.ckpt文件）
3. 启动容器后，模型将自动在ComfyUI界面中可用

## 高级配置

### GPU支持

对于GPU加速，需要确保系统已安装NVIDIA Docker支持，并使用适当的运行命令：

```bash
docker run --gpus all -p 8188:8188 zeroclue/comfyui
```

### 自定义扩展

要添加自定义扩展，可挂载extensions目录：

```bash
docker run -p 8188:8188 \
  -v ./extensions:/app/extensions \
  zeroclue/comfyui
```

## 访问界面

启动容器后，通过以下地址访问ComfyUI界面：
- 本地访问: http://localhost:8188
- 网络访问: http://[服务器IP]:8188

## 注意事项

- 较大的模型文件需要足够的存储空间和内存
- GPU加速需要兼容的NVIDIA显卡和驱动
- 首次运行可能需要下载额外资源，请确保网络连接正常
- 生产环境使用时建议配置适当的资源限制和安全措施
