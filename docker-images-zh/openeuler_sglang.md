<!-- xuanyuan-docker-images-zh
image: openeuler/sglang
source: https://xuanyuan.cloud/zh/r/openeuler/sglang
canonical: https://xuanyuan.cloud/zh/r/openeuler/sglang
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [openeuler/sglang — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/openeuler/sglang "openeuler/sglang Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/openeuler/sglang

# SGLang | openEuler Docker镜像文档

## 镜像概述

本镜像为官方SGLang Docker镜像，基于[openEuler](https://repo.openeuler.org/)构建，由[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)维护。该镜像可免费使用，且不受每用户速率限制，提供高效的大语言模型（LLM）和视觉语言模型服务能力。

## 核心功能与特性

SGLang是一个高性能的大语言模型和视觉语言模型服务框架，旨在跨多种部署环境（从单GPU到大型分布式集群）提供低延迟、高吞吐量的推理能力。其核心特性包括：

### 快速后端运行时
- 集成RadixAttention实现前缀缓存，零开销CPU调度器
- 支持预填充-解码分离、推测解码、连续批处理、分页注意力
- 提供张量/流水线/专家/数据并行、结构化输出、分块预填充
- 支持量化（FP4/FP8/INT4/AWQ/GPTQ）和多LoRA批处理

### 广泛的模型支持
- 支持多种生成模型（Llama、Qwen、DeepSeek、Kimi、GLM、GPT、Gemma、Mistral等）
- 支持嵌入模型（e5-mistral、gte、mcdse）和奖励模型（Skywork）
- 易于扩展以集成新模型，兼容大多数Hugging Face模型和OpenAI API

### 全面的硬件支持
- 支持NVIDIA GPU（GB200/B300/H100/A100/Spark）
- 支持AMD GPU（MI355/MI300）、Intel Xeon CPU、Google TPU、Ascend NPU等

### 灵活的前端语言
- 提供直观的LLM应用编程接口
- 支持链式生成调用、高级提示工程、控制流、多模态输入、并行处理和外部交互

### 活跃的社区支持
- 开源项目，拥有充满活力的社区和广泛的行业采用
- 全球支持超过300,000个GPU运行

## 支持的标签及对应Dockerfile链接

SGLang Docker镜像的标签由SGLang版本和基础镜像版本组成，具体信息如下：

| 标签 | 当前版本 | 架构 |
|------|----------|------|
|[0.5.5-torch2.8.0-cuda12.4-python3.11-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/sglang/0.5.5-torch2.8.0-cuda12.4-python3.11/24.03-lts-sp2/Dockerfile)| 基于openEuler 24.03-LTS-SP2的SGLang 0.5.5 | amd64, arm64 |

## 使用方法

### 支持的设备
- Intel/AMD x86架构
- ARM AArch64架构

### 拉取SGLang镜像
```bash
docker pull openeuler:sglang:{TAG}
```
> 注意：将`{TAG}`替换为上述支持的标签，如`0.5.5-torch2.8.0-cuda12.4-python3.11-oe2403sp2`

### 离线推理
可使用Modelscope镜像加速模型下载：
```bash
docker run --rm --name sglang -p 8000:8000 --gpus all openeuler/sglang:{TAG} python3 -m sglang.launch_server --model-path {MODEL_PATH} --host 0.0.0.0 -port 8000
```
> 参数说明：
> - `--model-path {MODEL_PATH}`：模型路径，可指定本地路径或Modelscope模型ID
> - `--host 0.0.0.0`：允许外部访问
> - `-port 8000`：服务端口，需与容器端口映射一致

## 问题反馈

如有任何问题或需要使用特殊功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。

## 获取帮助

- [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)
- [openEuler社区](https://gitee.com/openeuler/community)
