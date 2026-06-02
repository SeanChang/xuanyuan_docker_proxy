---
image: localai/localai
description: "LocalAI是免费开源的OpenAI替代方案"
source: https://xuanyuan.cloud/zh/r/localai/localai
canonical: https://xuanyuan.cloud/zh/r/localai/localai
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [localai/localai — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/localai/localai)

含镜像标签、拉取命令、部署文档与相关推荐。

[localai/localai Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/localai/localai)

# LocalAI Docker镜像文档

## 1. 镜像概述和主要用途

LocalAI是一款免费开源的OpenAI替代品，提供与OpenAI（及Elevenlabs、Anthropic等）API规范兼容的RESTful API，支持本地AI推理。其核心功能是作为 drop-in 替代方案，允许在消费级硬件上运行大型语言模型（LLM）、生成图像、音频等内容，无需依赖GPU，适用于本地或私有环境部署，保护数据隐私并降低外部API依赖。

## 2. 核心功能和特性

- **API兼容性**：完全兼容OpenAI API规范，可无缝替换现有基于OpenAI API的应用系统。
- **多模态支持**：支持文本生成（LLM）、图像生成、音频处理等多种AI任务。
- **硬件灵活性**：无需GPU即可在CPU环境运行，同时支持Nvidia GPU加速以提升性能。
- **多模型支持**：兼容多种模型家族，可通过官方模型库（https://models.localai.io）获取并加载不同类型模型。
- **Web管理界面**：内置直观的WebUI，提供模型管理、对话交互、音频生成、P2P节点管理等可视化操作功能。
- **轻量级部署**：通过Docker镜像实现快速部署，提供多种镜像类型（CPU专用、GPU加速、全功能AIO等）以适配不同场景。
- **P2P网络支持**：集成Swarm功能，支持P2P节点发现与资源共享，扩展分布式推理能力。

## 3. 使用场景和适用范围

- **本地AI推理**：在个人设备或私有服务器上进行AI推理，避免数据上传至第三方服务器，保障数据隐私。
- **OpenAI API替代**：在开发、测试或生产环境中替代OpenAI API，降低API调用成本，消除外部服务依赖。
- **资源受限环境**：适用于无GPU的硬件环境（如个人PC、边缘设备），通过CPU实现轻量级AI推理。
- **企业内部部署**：满足企业对数据合规性和安全性的要求，在内部网络中部署私有AI服务。
- **多模态应用开发**：支持开发集成文本生成、图像生成、音频处理的多模态AI应用。
- **模型测试与评估**：快速测试不同模型的性能、效果及兼容性，无需访问外部API。

## 4. 使用方法和配置说明

### 4.1 安装方式

#### 4.1.1 官方安装脚本（推荐）

通过官方一键安装脚本快速部署：

```bash
curl https://localai.io/install.sh | sh
```

#### 4.1.2 Docker镜像部署

根据硬件环境选择以下镜像类型：

##### CPU专用镜像（轻量级）

适用于无GPU环境，镜像体积较小：

```bash
docker run -ti --name local-ai -p 8080:8080 localai/localai:latest-cpu
```

**参数说明**：
- `-ti`：启用交互式终端
- `--name local-ai`：指定容器名称为`local-ai`
- `-p 8080:8080`：端口映射（主机端口:容器端口），WebUI和API通过8080端口访问
- `localai/localai:latest-cpu`：CPU专用镜像标签

##### Nvidia GPU加速镜像

需预先安装Nvidia Docker运行时，支持CUDA 12：

```bash
docker run -ti --name local-ai -p 8080:8080 --gpus all localai/localai:latest-gpu-nvidia-cuda-12
```

**参数说明**：
- `--gpus all`：启用所有GPU资源（需Nvidia Docker支持）

##### 全功能镜像（CPU+GPU）

包含CPU和GPU支持，功能全面但镜像体积较大：

```bash
docker run -ti --name local-ai -p 8080:8080 localai/localai:latest
```

##### AIO（All-in-One）镜像（预下载模型）

预下载一组常用模型，开箱即用：

```bash
docker run -ti --name local-ai -p 8080:8080 localai/localai:latest-aio-cpu
```

### 4.2 模型加载与管理

通过`local-ai run`命令加载模型，支持多种来源：

#### 4.2.1 从官方模型库加载

模型库提供多种预配置模型，可通过名称加载（需先安装local-ai客户端）：

```bash
# 列出可用模型
local-ai models list

# 加载指定模型（如llama-3.2-1b-instruct量化版本）
local-ai run llama-3.2-1b-instruct:q4_k_m
```

#### 4.2.2 从Hugging Face加载

直接从Hugging Face加载GGUF格式模型：

```bash
local-ai run huggingface://TheBloke/phi-2-GGUF/phi-2.Q8_0.gguf
```

#### 4.2.3 从Ollama注册表加载

加载Ollama格式模型：

```bash
local-ai run ollama://gemma:2b
```

#### 4.2.4 从配置文件加载

通过远程配置文件加载模型：

```bash
local-ai run https://gist.githubusercontent.com/.../phi-2.yaml
```

#### 4.2.5 从OCI注册表加载

从标准OCI注册表（如Docker Hub）加载模型：

```bash
local-ai run oci://localai/phi-2:latest
```

### 4.3 配置说明

LocalAI支持通过YAML配置文件自定义模型参数、API行为等。配置文件通常放置在模型目录或指定的配置路径，可定义模型名称、推理参数、上下文窗口大小等。详细配置选项请参考[官方文档](https://localai.io/basics/getting_started/index.html)。

## 5. 访问与使用

容器启动后，可通过以下方式访问LocalAI服务：

- **WebUI**：访问 `http://localhost:8080`，通过界面进行模型管理、对话交互、图像/音频生成等操作。
- **API**：通过 `http://localhost:8080/v1` 访问兼容OpenAI的API端点（如`/v1/chat/completions`、`/v1/images/generations`）。

## 6. 相关工具

LocalAI属于Local Stack Family，与以下工具协同工作：

### 6.1 LocalAGI

LocalAGI是一个强大的本地AI代理管理平台，作为OpenAI Responses API的替代品，增强了高级代理功能。

### 6.2 LocalRecall

LocalRecall是一个RESTful API和知识库管理系统，为AI代理提供持久化内存和存储能力。

## 7. 参考链接

- [官方文档](https://localai.io/)
- [模型库](https://models.localai.io/)
- [GitHub仓库](https://github.com/go-skynet/LocalAI)
- [Docker Hub](https://hub.docker.com/r/localai/localai)
