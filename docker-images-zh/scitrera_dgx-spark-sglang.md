---
image: scitrera/dgx-spark-sglang
description: "为NVIDIA DGX Spark系统优化的sglang容器镜像，基于CUDA，集成PyTorch、Transformers等工具，提供稳定版本化预构建镜像，支持即开即用，适用于高性能多节点推理工作负载。"
source: https://xuanyuan.cloud/zh/r/scitrera/dgx-spark-sglang
canonical: https://xuanyuan.cloud/zh/r/scitrera/dgx-spark-sglang
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/scitrera/dgx-spark-sglang" title="scitrera/dgx-spark-sglang Docker 镜像中文简介、标签列表与拉取命令">scitrera/dgx-spark-sglang 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# NVIDIA DGX Spark的CUDA容器

https://github.com/scitrera/cuda-containers

本仓库包含针对**NVIDIA DGX Spark**系统优化的CUDA容器Dockerfile和构建配方，专注于**vLLM**、**sglang**、**PyTorch**以及多节点推理工作负载。

本项目的主要目标是提供**稳定、版本化的预构建镜像**，可在DGX Spark（支持Blackwell）上即开即用，同时也适合作为**基础镜像**用于自定义构建。

## 仓库存在的意义

官方NVIDIA镜像往往滞后于最新版本，而其他社区镜像则优先考虑前沿功能而非版本控制和稳定性。

本仓库的目标是提供**稳定、版本化的预构建镜像**，可在DGX Spark（支持Blackwell）上即开即用。

与其他构建（例如eugr的仓库——社区标准）的主要架构差异在于：
- **NCCL和PyTorch优先构建**，在专用基础镜像中完成
- vLLM及相关工具层叠在基础镜像之上
- 版本控制以**vLLM发布**为主要轴

对于sglang，官方提供的容器未持续更新。预计随着sglang对SM121支持的提升，这种情况可能会改变，但在此期间，Scitrera将尽最大努力维护与vLLM镜像类似的sglang镜像。

## 可用镜像

### SGLang镜像

SGLang镜像同样针对DGX Spark优化，提供高性能推理运行时的替代方案。

- 托管在Docker Hub：[https://hub.docker.com/r/scitrera/dgx-spark-sglang](https://hub.docker.com/r/scitrera/dgx-spark-sglang)

#### 最新版本

##### SGLang 0.5.8

- `scitrera/dgx-spark-sglang:0.5.8-t4`
  - SGLang 0.5.8（包含发布后的构建修复）
  - PyTorch 2.10.0（含torchvision和torchaudio）
  - CUDA 13.1.1
  - Transformers 4.57.6
  - Triton 3.6.0
  - NCCL 2.29.3-1
  - FlashInfer 0.6.3

- `scitrera/dgx-spark-sglang:0.5.8-t5`
  - 与上述相同，但包含**Transformers 5.1.0**

### PyTorch开发基础镜像

如果需要构建自定义推理栈：

- **`scitrera/dgx-spark-pytorch-dev:2.10.0-v2-cu131`**
  - PyTorch 2.10.0
  - CUDA 13.1.1
  - NCCL 2.29.3-1
  - 基于`nvidia/cuda:13.1.1-devel-ubuntu24.04`构建
  - 包含标准构建工具

- **`scitrera/dgx-spark-pytorch-dev:2.10.0-cu131`**
  - PyTorch 2.10.0
  - CUDA 13.1.0
  - NCCL 2.29.2-1
  - 基于`nvidia/cuda:13.1.0-devel-ubuntu24.04`构建
  - 包含标准构建工具

推荐在以下场景使用此基础镜像：
- 自行构建vLLM/sglang/其他工具
- 添加自定义内核或扩展
- 实验替代运行时

## 标签语义

vLLM和SGLang容器的标签遵循以下模式：

```
<version>-t<transformers-major>
```

示例：
- `0.13.0-t4` → vLLM 0.13.0 + Transformers 4.x
- `0.5.8-t5` → SGLang 0.5.8 + Transformers 5.x

## 使用示例（SGLang）

```bash
docker run \
  --privileged \
  --gpus all \
  -it --rm \
  --network host --ipc=host \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  docker.xuanyuan.run/scitrera/dgx-spark-sglang:0.5.8-t4 \
  sglang serve \
    --model-path Qwen/Qwen2.5-7B-Instruct \
    --mem-fraction-static 0.4
```

## 检查组件版本

主要组件版本嵌入为Docker标签。

```bash
docker inspect scitrera/dgx-spark-vllm:0.14.0rc2-t4 \
  --format '{{json .Config.Labels}}' | jq
```

示例输出：

```json
{
  "dev.scitrera.cuda_version": "13.1.0",
  "dev.scitrera.flashinfer_version": "0.6.1",
  "dev.scitrera.nccl_version": "2.28.9-1",
  "dev.scitrera.torch_version": "2.10.0-rc6",
  "dev.scitrera.transformers_version": "4.57.5",
  "dev.scitrera.triton_version": "3.5.1",
  "dev.scitrera.vllm_version": "0.14.0rc2"
}
```

## 注意事项

* NCCL版本相对于上游PyTorch构建已升级
* PyTorch、Triton和vLLM/sglang已相应重建
* 镜像大小仍有进一步优化空间
* 版本组合选择以**稳定性**为优先（不保证包含可能导致问题的最新功能）

## 路线图（初步）

* 更好的大小优化
* 为DGX Spark新手提供更多文档/支持

本项目与NVIDIA无关。由[scitrera.ai](https://scitrera.ai/)赞助和维护。
