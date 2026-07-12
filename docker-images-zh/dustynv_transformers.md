---
image: dustynv/transformers
description: "HuggingFace Transformers Docker镜像提供便捷API，支持多种NLP和视觉模型，兼容HuggingFace Hub上大量模型，适用于文本生成等LLM任务，支持多种精度和量化选项。"
source: https://xuanyuan.cloud/zh/r/dustynv/transformers
canonical: https://xuanyuan.cloud/zh/r/dustynv/transformers
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dustynv/transformers" title="dustynv/transformers Docker 镜像中文简介、标签列表与拉取命令">dustynv/transformers 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# transformers

> [`容器`](#containers) [`镜像`](#images) [`运行`](#run) [`构建`](#build)


HuggingFace [Transformers](https://huggingface.co/docs/transformers/index)库通过便捷的API支持各种NLP和视觉模型，被许多其他LLM包所使用。在[HuggingFace Hub](https://huggingface.co/models)上有大量与其兼容的模型。

> [!NOTE]  
> 如果您希望使用Transformer的集成[bitsandbytes](https://huggingface.co/docs/transformers/main_classes/quantization#bitsandbytes-integration)量化（`load_in_8bit/load_in_4bit`）或[AutoGPTQ](https://huggingface.co/docs/transformers/main_classes/quantization#autogptq-integration)量化，请运行以下容器，这些容器在Transformers基础上包含了相应的库：
>   * [`auto_gptq`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/auto_gptq)（依赖于Transformers）
>   * [`bitsandbytes`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/bitsandbytes)（依赖于Transformers）

### 文本生成基准测试

替换您想要运行的[文本生成模型](https://huggingface.co/models?pipeline_tag=text-generation&sort=trending)（应该是像GPT、Llama等CausalLM模型）

```bash
./run.sh $(./autotag transformers) \
   huggingface-benchmark.py --model=gpt2
```
> 如果模型仓库是私有的或需要身份验证，请添加`--env HUGGINGFACE_TOKEN=<您的访问令牌>`

默认情况下，性能测量会生成128个新的输出标记（可以使用`--tokens=N`设置）

可以使用`--prompt='your prompt here'`更改提示

#### 精度/量化

使用`--precision`参数启用量化（选项：`fp32` `fp16` `fp4` `int8`，默认：`fp16`）

如果您使用`fp4`或`int8`，请运行上面提到的[`bitsandbytes`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/bitsandbytes)容器，以便安装bitsandbytes包进行量化。预期通过Transformers的4位/8位量化比FP16慢（但消耗更少内存）- 更多信息请参见[此处](https://huggingface.co/docs/transformers/main_classes/quantization)。

其他库如[`exllama`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/exllama)、[`awq`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/awq)和[`AutoGPTQ`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/auto-gptq)有自定义CUDA内核和更高效的量化性能。

#### Llama2

* 首先从https://ai.meta.com/llama/请求访问权限
* 然后创建HuggingFace账户，并请求访问其中一个Llama2模型，如https://huggingface.co/meta-llama/Llama-2-7b-hf（这样您将获得所有Llama2模型的访问权限）
* 从https://huggingface.co/settings/tokens获取用户访问令牌

```bash
./run.sh --env HUGGINGFACE_TOKEN=<您的访问令牌> $(./autotag transformers) \
   huggingface-benchmark.py --model=meta-llama/Llama-2-7b-hf
```

<details open>
<summary><b><a id="containers">容器</a></b></summary>
<br>

| **`transformers`** | |
| :-- | :-- |
| &nbsp;&nbsp;&nbsp;构建状态 | [![`transformers_jp60`](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/transformers_jp60.yml?label=transformers:jp60)](https://github.com/dusty-nv/jetson-containers/actions/workflows/transformers_jp60.yml) [![`transformers_jp51`](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/transformers_jp51.yml?label=transformers:jp51)](https://github.com/dusty-nv/jetson-containers/actions/workflows/transformers_jp51.yml) [![`transformers_jp46`](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/transformers_jp46.yml?label=transformers:jp46)](https://github.com/dusty-nv/jetson-containers/actions/workflows/transformers_jp46.yml) |
| &nbsp;&nbsp;&nbsp;要求 | `L4T ['>=32.6']` |
| &nbsp;&nbsp;&nbsp;依赖项 | [`build-essential`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/build/build-essential) [`cuda`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/cuda/cuda) [`cudnn`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/cuda/cudnn) [`python`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/build/python) [`numpy`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/numpy) [`cmake`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/build/cmake/cmake_pip) [`onnx`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/onnx) [`pytorch:2.2`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/pytorch) [`torchvision`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/pytorch/torchvision) [`huggingface_hub`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/huggingface_hub) [`rust`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/build/rust) |
| &nbsp;&nbsp;&nbsp;被依赖项 | [`audiocraft`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/audio/audiocraft) [`auto_awq:0.2.4`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/auto_awq) [`auto_gptq:0.7.1`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/auto_gptq) [`awq:0.1.0`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/awq) [`bitsandbytes`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/bitsandbytes) [`bitsandbytes:builder`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/bitsandbytes) [`efficientvit`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/vit/efficientvit) [`gptq-for-llama`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/gptq-for-llama) [`l4t-diffusion`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/l4t/l4t-diffusion) [`llava`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/llava) [`mlc:0.1.0`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/mlc) [`mlc:0.1.0-builder`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/mlc) [`mlc:0.1.1`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/mlc) [`mlc:0.1.1-builder`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/mlc) [`nanodb`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/vectordb/nanodb) [`nanoowl`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/vit/nanoowl) [`nanosam`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/vit/nanosam) [`nemo`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/nemo) [`optimum`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/optimum) [`stable-diffusion`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/diffusion/stable-diffusion) [`stable-diffusion-webui`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/diffusion/stable-diffusion-webui) [`tensorrt_llm:0.10.dev0`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/tensorrt_llm) [`tensorrt_llm:0.10.dev0-builder`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/tensorrt_llm) [`tensorrt_llm:0.5`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/tensorrt_llm) [`tensorrt_llm:0.5-builder`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/tensorrt_llm) [`text-generation-inference`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/text-generation-inference) [`text-generation-webui:1.7`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/text-generation-webui) [`text-generation-webui:6a7cd01`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/text-generation-webui) [`text-generation-webui:main`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/text-generation-webui) [`voicecraft`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/audio/voicecraft) [`whisperx`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/audio/whisperx) [`xtts`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/audio/xtts) |
| &nbsp;&nbsp;&nbsp;Dockerfile | [`Dockerfile`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/transformers/Dockerfile) |
| &nbsp;&nbsp;&nbsp;镜像 | [`dustynv/transformers:git-r35.2.1`](https://hub.docker.com/r/dustynv/transformers/tags) `(2023-12-15, 5.9GB)`<br>[`dustynv/transformers:git-r35.3.1`](https://hub.docker.com/r/dustynv/transformers/tags) `(2023-12-12, 5.9GB)`<br>[`dustynv/transformers:git-r35.4.1`](https://hub.docker.com/r/dustynv/transformers/tags) `(2023-12-11, 5.9GB)`<br>[`dustynv/transformers:nvgpt-r35.2.1`](https://hub.docker.com/r/dustynv/transformers/tags) `(2023-12-05, 5.9GB)`<br>[`dustynv/transformers:nvgpt-r35.3.1`](https://hub.docker.com/r/dustynv/transformers/tags) `(2023-12-15, 5.9GB)`<br>[`dustynv/transformers:nvgpt-r35.4.1`](https://hub.docker.com/r/dustynv/transformers/tags) `(2023-12-14, 5.9GB)`<br>[`dustynv/transformers:r32.7.1`](https://hub.docker.com/r/dustynv/transformers/tags) `(2023-12-15, 1.5GB)`<br>[`dustynv/transformers:r35.2.1`](https://hub.docker.com/r/dustynv/transformers/tags) `(2023-12-11, 5.9GB)`<br>[`dustynv/transformers:r35.3.1`](https://hub.docker.com/r/dustynv/transformers/tags) `(2023-12-12, 5.9GB)`<br>[`dustynv/transformers:r35.4.1`](https://hub.docker.com/r/dustynv/transformers/tags) `(2023-12-15, 5.9GB)`<br>[`dustynv/transformers:r36.2.0`](https://hub.docker.com/r/dustynv/transformers/tags) `(2023-12-15, 7.6GB)` |
| &nbsp;&nbsp;&nbsp;说明 | 在JetPack5上添加了bitsandbytes和auto_gptq依赖项，用于4位/8位量化 |

| **`transformers:git`** | |
| :-- | :-- |
| &nbsp;&nbsp;&nbsp;构建状态 | [![`transformers-git_jp51`](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/transformers-git_jp51.yml?label=transformers-git:jp51)](https://github.com/dusty-nv/jetson-containers/actions/workflows/transformers-git_jp51.yml) |
| &nbsp;&nbsp;&nbsp;要求 | `L4T ['>=32.6']` |
| &nbsp;&nbsp;&nbsp;依赖项 | [`build-essential`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/build/build-essential) [`cuda`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/cuda/cuda) [`cudnn`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/cuda/cudnn) [`python`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/build/python) [`numpy`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/numpy) [`cmake`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/build/cmake/cmake_pip) [`onnx`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/onnx) [`pytorch:2.2`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/pytorch) [`torchvision`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/pytorch/torchvision) [`huggingface_hub`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/huggingface_hub) [`rust`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/build/rust) |
| &nbsp;&nbsp;&nbsp;Dockerfile | [`Dockerfile`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/llm/transformers/Dockerfile) |
| &nbsp;&nbsp;&nbsp;镜像 | [`dustynv/transformers:git-r35.2.1`](https://hub.docker.com/r/dustynv/transformers/tags) `(2023-12-15, 5.9GB)`<br>[`dustynv/transformers:git-r35.3.1`](https://hub.docker.com/r/dustynv/transformers/tags) `(2023-12-12, 5.9GB)`<br>[`dustynv/transformers:git-r35.4.1`](https://hub.docker.com/r/dustynv/transformers/tags) `(2023-12-11, 5.9GB)` |
| &nbsp;&nbsp;&nbsp;说明 | 在JetPack5上添加了bitsandbytes和auto_gptq依赖项，用于4位/8位量化 |

| **`transformers:nvgpt`** | |
| :-- | :-- |
| &nbsp;&nbsp;&nbsp;构建状态 | [![`transformers-nvgpt_jp51`](https://img.shields.io/github/actions/workflow/status/dusty-nv/jetson-containers/transformers-nvgpt_jp51.yml?label=transformers-nvgpt:jp51)](https://github.com/dusty-nv/jetson-containers/actions/workflows/transformers-nvgpt_jp51.yml) |
| &nbsp;&nbsp;&nbsp;要求 | `L4T ['>=32.6']` |
| &nbsp;&nbsp;&nbsp;依赖项 | [`build-essential`](https://github.com/dusty-nv/jetson-containers/tree/master/packages/build/build-
