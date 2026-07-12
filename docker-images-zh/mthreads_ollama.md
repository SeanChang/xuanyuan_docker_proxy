---
image: mthreads/ollama
description: "mthreads/ollama是支持在摩尔线程GPU上运行大语言模型的Ollama分支镜像，基于MUSA平台提升模型推理性能。"
source: https://xuanyuan.cloud/zh/r/mthreads/ollama
canonical: https://xuanyuan.cloud/zh/r/mthreads/ollama
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mthreads/ollama" title="mthreads/ollama Docker 镜像中文简介、标签列表与拉取命令">mthreads/ollama 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Ollama MUSA 镜像文档

## 镜像概述和主要用途

`mthreads/ollama` 是 [Ollama](https://github.com/ollama/ollama) 的分支镜像，专门优化用于在摩尔线程（Moore Threads）GPU上运行大语言模型（LLM）。该镜像基于MUSA（Meta-computing Unified System Architecture，统一元计算系统架构）平台构建，旨在充分利用摩尔线程GPU的硬件能力，提升LLM推理性能。

## 核心功能和特性

- **摩尔线程GPU支持**：针对摩尔线程GPU进行优化，实现高效的模型推理
- **MUSA平台加速**：基于MUSA架构，充分利用GPU计算资源，提升推理效率
- **与Ollama兼容**：继承Ollama的核心功能，支持模型管理、推理交互等操作
- **版本对齐**：镜像版本与Ollama上游版本及MUSA SDK版本明确对应，便于环境管理

## 镜像标签说明

镜像标签遵循以下命名规则：

> `<ollama-version>-musa-<musa-sdk-version>-<arch>`

### 标签示例

```
0.11.4-musa-rc4.2.0-amd64
```

### 标签组成说明

- `<ollama-version>`：Ollama上游版本，如`0.11.4`
- `<musa-sdk-version>`：MUSA SDK版本，通常与驱动版本对应，如`musa-rc4.2.0`
- `<arch>`：CPU架构，如`amd64`

### 特殊标签

- `latest`：始终指向最新的Ollama版本与最新的MUSA SDK版本组合，适合快速部署使用。

## 使用场景和适用范围

- 基于摩尔线程GPU的LLM本地部署
- 对推理性能有要求的大语言模型应用场景
- 需要利用MUSA平台加速的AI推理服务

## 使用方法和配置说明

### 基本运行命令

使用以下命令启动容器（需确保已安装摩尔线程GPU驱动及MUSA环境）：

```bash
docker run -d --name ollama-musa --gpus all -v ./ollama_data:/root/.ollama -p 11434:11434 docker.xuanyuan.run/mthreads/ollama:latest
```

### 参数说明

- `--gpus all`：允许容器访问所有GPU资源
- `-v ./ollama_data:/root/.ollama`：挂载本地目录用于存储模型数据
- `-p 11434:11434`：映射Ollama默认端口，便于外部访问

### 模型使用

容器启动后，可通过Ollama CLI或API与模型交互，例如拉取并运行模型：

```bash
# 进入容器
docker exec -it ollama-musa bash

# 拉取模型（示例）
ollama pull llama2

# 运行模型
ollama run llama2
