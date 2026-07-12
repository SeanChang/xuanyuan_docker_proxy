---
image: amperecomputingai/llama.cpp
description: "Ampere®优化的llama.cpp，全面支持HuggingFace上的GGUF模型。"
source: https://xuanyuan.cloud/zh/r/amperecomputingai/llama.cpp
canonical: https://xuanyuan.cloud/zh/r/amperecomputingai/llama.cpp
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amperecomputingai/llama.cpp" title="amperecomputingai/llama.cpp Docker 镜像中文简介、标签列表与拉取命令">amperecomputingai/llama.cpp 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Ampere®优化的llama.cpp

![llama.cpp pull count](https://img.shields.io/docker/pulls/amperecomputingai/llama.cpp?logo=meta&logoColor=black&label=llama.cpp&labelColor=violet&color=purple)

## 镜像概述和主要用途

Ampere®优化的[llama.cpp](https://github.com/ggerganov/llama.cpp?tab=readme-ov-file#llamacpp)构建版本，全面支持HuggingFace上丰富的GGUF模型集合：[GGUF模型](https://huggingface.co/models?search=gguf) [Ampere模型集合](https://huggingface.co/AmpereComputing/collections)。

该Docker镜像可在裸金属Ampere® CPU和云环境中基于Ampere®的虚拟机上运行。发布说明和二进制可执行文件可在我们的[GitHub](https://github.com/AmpereComputingAI/llama.cpp/releases)上获取。

## 核心功能和特性

- 基于Ampere®架构优化，提升推理性能
- 全面支持HuggingFace上的GGUF模型格式
- 新增Q4_K_4和Q8R16两种量化方法，与Q4_K和Q8_0相比，模型大小和困惑度相近，但推理速度提升1.5-2倍

## 使用场景和适用范围

适用于需要在Ampere® CPU或基于Ampere®的云VM上部署LLM模型的场景，尤其适合对推理性能有要求的应用。

## 使用方法和配置说明

### 启动容器

默认入口点运行llama.cpp的服务器二进制文件，模仿原始llama.cpp服务器镜像的行为：[docker image](https://github.com/ggerganov/llama.cpp/blob/master/.devops/llama-server.Dockerfile)

如需启动shell，执行以下命令：

```bash
sudo docker run --privileged=true --name llama --entrypoint /bin/bash -it amperecomputingai/llama.cpp:latest
```

容器启动时将显示快速启动示例。

请访问[Ampere Solutions Portal](https://solutions.amperecomputing.com/solutions/ampere-ai)获取更多信息！

### 量化

Ampere®优化的llama.cpp构建版本支持两种新的量化方法Q4_K_4和Q8R16，提供与Q4_K和Q8_0相近的模型大小和困惑度，但推理速度提升1.5-2倍。

#### 步骤1：转换模型为GGUF格式

使用[此脚本](https://github.com/ggerganov/llama.cpp/blob/master/convert_hf_to_gguf.py)将模型转换为GGUF格式：

```bash
python3 convert-hf-to-gguf.py [原始模型路径] --outtype [f32, f16, bf16或q8_0] --outfile [输出路径]
```

示例：

```bash
python3 convert-hf-to-gguf.py path/to/llama2 --outtype f16 --outfile llama-2-7b-f16.gguf
```

#### 步骤2：量化模型

使用以下命令量化模型：

```bash
./llama-quantize [输入文件] [输出文件] [量化方法]
```

示例：

```bash
./llama-quantize llama-2-7b-f16.gguf llama-2-7b-Q8R16.gguf Q8R16
```

## 支持

请通过邮箱联系我们：<ai-support@amperecomputing.com>

## 法律声明

通过访问、下载或使用本软件及任何所需的依赖软件（“Ampere AI软件”），您同意Ampere AI软件许可协议的条款和条件，其中可能还包括Ampere AI软件中包含的第三方软件的通知、免责声明或许可条款。请参阅[Ampere AI软件EULA v1.6](https://ampereaidevelop.s3.eu-central-1.amazonaws.com/Ampere+AI+Software+EULA+-+v1.6.pdf)或其他类似名称的文本文件以获取更多详细信息。
