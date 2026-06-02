---
image: ollama/ollama
description: "轻松在本地部署和运行大型语言模型的最简单方式。"
source: https://xuanyuan.cloud/zh/r/ollama/ollama
canonical: https://xuanyuan.cloud/zh/r/ollama/ollama
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ollama/ollama" title="ollama/ollama Docker 镜像中文简介、标签列表与拉取命令">ollama/ollama — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ollama/ollama" title="ollama/ollama Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ollama/ollama</a>

# Ollama Docker镜像

Ollama 让在本地搭建和运行大型语言模型变得简单。

## 核心功能
- 支持在本地环境快速部署大型语言模型
- 兼容 CPU、NVIDIA GPU 和 AMD GPU 等多种硬件环境
- 提供简单的命令行界面管理和运行模型

## 使用场景
适用于需要在本地运行大语言模型的开发者、研究人员或个人用户，无需依赖云端服务即可体验 AI 模型能力。

## 使用方法

### CPU 仅模式
直接运行容器，无需额外硬件加速：
```bash
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
```

### NVIDIA GPU 模式
需先安装 [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installation)。

#### 通过 Apt 安装
1. 配置仓库
```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
    | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
    | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
    | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
```

2. 安装 NVIDIA Container Toolkit 包
```bash
sudo apt-get install -y nvidia-container-toolkit
```

#### 通过 Yum 或 Dnf 安装
1. 配置仓库
```bash
curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo \
    | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo
```

2. 安装 NVIDIA Container Toolkit 包
```bash
sudo yum install -y nvidia-container-toolkit
```

#### 配置 Docker 使用 Nvidia 驱动
```bash
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

#### 启动容器
```bash
docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
```

### AMD GPU 模式
使用 `rocm` 标签运行容器：
```bash
docker run -d --device /dev/kfd --device /dev/dri -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama:rocm
```

## 运行模型
容器启动后，可通过以下命令运行模型：
```bash
docker exec -it ollama ollama run llama3
```

## 尝试不同模型
更多模型可在 [Ollama 库](https://ollama.com/library) 中找到。

## 了解更多
https://github.com/ollama/ollama
