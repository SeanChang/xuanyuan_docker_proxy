---
image: hiyouga/llamafactory
description: "LLaMA-Factory官方Docker镜像是由开源大模型微调平台LLaMA-Factory提供的官方容器化部署包，旨在为开发者和研究者提供便捷、高效的大模型微调与应用环境，支持多种主流大模型及训练方法，可简化部署流程，实现快速环境搭建与管理，助力用户轻松开展大模型微调、评估及应用开发工作。"
source: https://xuanyuan.cloud/zh/r/hiyouga/llamafactory
canonical: https://xuanyuan.cloud/zh/r/hiyouga/llamafactory
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hiyouga/llamafactory" title="hiyouga/llamafactory Docker 镜像中文简介、标签列表与拉取命令">hiyouga/llamafactory 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# LLaMA-Factory 官方 Docker 镜像


## 简介  
这是 LLaMA-Factory 的官方 Docker 镜像，旨在简化 LLaMA-Factory 的环境配置流程。LLaMA-Factory 是一个功能全面的大模型微调/推理工具（项目地址：[[]] ），而该镜像已预装所有依赖组件，可帮助用户跳过复杂的环境配置步骤，直接上手模型微调、推理、评估等核心任务。


## 核心优势  
- **环境一致性**：镜像内已集成 Python、PyTorch、Transformers、Accelerate 等所有必要依赖，避免因系统环境差异导致的“配置失败”问题。  
- **部署简单高效**：无需手动安装依赖，通过一条 Docker 命令即可启动完整运行环境，新手也能快速上手。  
- **灵活适配场景**：支持自定义数据挂载、端口映射和启动参数，可根据实际需求调整（如微调不同模型、启用 Web UI 等）。  


## 快速使用指南  

### 1. 拉取镜像  
首先确保本地已安装 Docker，然后通过以下命令拉取最新版镜像：  
```bash
docker pull docker.xuanyuan.run/hiyouga/llama-factory:latest
```  
（如需指定版本，可替换 `latest` 为具体标签，如 `v0.9.0`，标签列表可在项目 GitHub 查看）


### 2. 启动容器  
启动容器时，建议挂载本地目录以持久化数据（如模型文件、微调数据、输出结果等），并映射必要端口（如需使用 Web UI）。  

示例命令（基础用法）：  
```bash
docker run -it --rm \
  -v /path/to/your/data:/app/data  # 挂载本地数据目录到容器内 /app/data  
  -p 7860:7860  # 映射 Web UI 端口（如使用 gradio 界面）  
  hiyouga/llama-factory:latest  
```  

- `-v /path/to/your/data:/app/data`：将本地的 `/path/to/your/data` 目录挂载到容器内的 `/app/data`，确保数据持久化（如存放模型、数据集）。  
- `-p 7860:7860`：如需使用 Web UI，映射容器内的 7860 端口到本地，启动后可通过 `[] 访问。  
- `--rm`：容器退出后自动删除，如需保留容器，可去掉此参数。  


### 3. 开始使用  
容器启动后，会自动进入 LLaMA-Factory 的工作目录（`/app`），此时可直接运行相关命令：  
- 微调模型：`python src/train_bash.py --config configs/train/llama2/llama2-7b-sft.yaml`  
- 启动 Web UI：`python src/webui.py`  
- 模型推理：`python src/cli_demo.py --model_path /app/data/llama-2-7b --load_in_4bit`  


## 注意事项  
- **数据持久化**：本地数据（如模型、数据集）需通过 `-v` 参数挂载，否则容器内数据会在退出后丢失。  
- **资源需求**：模型微调/推理需足够的 CPU 内存或 GPU 显存，建议根据模型大小配置硬件（如 7B 模型微调需至少 16GB GPU 显存）。  
- **镜像更新**：定期通过 `docker pull docker.xuanyuan.run/hiyouga/llama-factory:latest` 更新镜像，获取最新功能和依赖修复。  


## 相关链接  
- LLaMA-Factory 项目主页：[[https://github.com/hiyouga/LLaMA-Factory]]   
- Docker 镜像仓库：[[https://github.com/hiyouga/LLaMA-Factory]] （可查看所有镜像标签和版本信息）
