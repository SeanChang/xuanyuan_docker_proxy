<!-- xuanyuan-docker-images-zh
image: openeuler/vllm-cpu
source: https://xuanyuan.cloud/zh/r/openeuler/vllm-cpu
canonical: https://xuanyuan.cloud/zh/r/openeuler/vllm-cpu
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/openeuler/vllm-cpu" title="openeuler/vllm-cpu Docker 镜像中文简介、标签列表与拉取命令">openeuler/vllm-cpu — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/openeuler/vllm-cpu" title="openeuler/vllm-cpu Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/openeuler/vllm-cpu</a></p>

# vLLM Ascend Docker镜像文档

## 镜像概述

vLLM Ascend Docker镜像是由[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)维护的官方镜像，基于[openEuler](https://repo.openeuler.org/)构建，提供免费使用且无每用户速率限制。vLLM是一个快速易用的大型语言模型（LLM）推理与服务库，最初由加州大学伯克利分校Sky计算实验室开发，现已发展为社区驱动项目，融合学术界与工业界贡献。

## 核心功能与特性

vLLM具备以下核心优势：
- **领先的服务吞吐量**：优化的推理性能，支持高并发请求处理
- **高效内存管理**：采用[PagedAttention](https://blog.vllm.ai/2023/06/20/vllm.html)技术高效管理注意力键值对内存
- **连续批处理**：动态批处理传入请求，提升资源利用率
- **快速模型执行**：通过CUDA/HIP图加速模型运行
- **丰富量化支持**：兼容[GPTQ](https://arxiv.org/abs/2210.17323)、[AWQ](https://arxiv.org/abs/2306.00978)、INT4、INT8及FP8量化
- **优化内核**：集成FlashAttention和FlashInfer的CUDA内核优化
- **推测解码**：提升生成速度的推理优化技术
- **分块预填充**：优化长文本输入处理效率

更多技术细节可参考[vLLM论文](https://arxiv.org/abs/2309.06180)（SOSP 2023）及[vLLM官方文档](https://docs.vllm.ai/)。

## 支持的标签及架构

vLLM Docker镜像标签由vLLM版本和基础镜像版本组成，具体信息如下：

| 标签 | 当前版本信息 | 支持架构 |
|------|--------------|----------|
|[0.6.3-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.6.3/24.03-lts/Dockerfile)| vLLM 0.6.3 基于 openEuler 24.03-LTS | amd64 |
|[0.8.3-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.8.3/22.03-lts-sp4/Dockerfile)| vLLM 0.8.3 基于 openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.8.3-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.8.3/24.03-lts/Dockerfile)| vLLM 0.8.3 基于 openEuler 24.03-LTS | amd64, arm64 |
|[0.8.4-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.8.4/22.03-lts-sp4/Dockerfile)| vLLM 0.8.4 基于 openEuler 22.03-LTS-SP4 | amd64 |
|[0.8.4-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.8.4/24.03-lts/Dockerfile)| vLLM 0.8.4 基于 openEuler 24.03-LTS | amd64 |
|[0.8.5-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.8.5/22.03-lts-sp4/Dockerfile)| vLLM 0.8.5 基于 openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.8.5-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.8.5/24.03-lts/Dockerfile)| vLLM 0.8.5 基于 openEuler 24.03-LTS | amd64, arm64 |
|[0.9.0-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.9.0/22.03-lts-sp4/Dockerfile)| vLLM 0.9.0 基于 openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.9.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.9.0/24.03-lts/Dockerfile)| vLLM 0.9.0 基于 openEuler 24.03-LTS | amd64, arm64 |
|[0.9.1-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.9.1/22.03-lts-sp4/Dockerfile)| vLLM 0.9.1 基于 openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.9.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.9.1/24.03-lts/Dockerfile)| vLLM 0.9.1 基于 openEuler 24.03-LTS | amd64, arm64 |
|[0.10.1-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.10.1/22.03-lts-sp4/Dockerfile)| vLLM 0.10.1 基于 openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.10.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.10.1/24.03-lts/Dockerfile)| vLLM 0.10.1 基于 openEuler 24.03-LTS | amd64, arm64 |

## 使用场景与适用范围

适用于需要高性能LLM推理和服务部署的场景，包括但不限于：
- 离线批量文本生成任务
- 低延迟在线LLM服务部署
- 学术研究与工业界语言模型应用开发

支持的硬件架构：Intel/AMD x86（amd64）、ARM AArch64（arm64）。

## 使用方法与配置说明

### 环境准备

确保已安装Docker环境，支持amd64或arm64架构。

### 快速启动容器

```bash
# 启动vLLM容器，映射8000端口
docker run --rm --name vllm -p 8000:8000 -it --entrypoint bash openeuler/vllm-cpu:latest
```

### 离线推理示例

#### 加速模型下载

可使用Modelscope镜像加速模型下载：

```bash
export VLLM_USE_MODELSCOPE=true
```

#### Python推理脚本

安装vLLM后，可通过以下Python脚本进行离线批量推理（首次运行需3-5分钟下载模型，取决于网络速度）：

```python
from vllm import LLM, SamplingParams

prompts = [
    "Hello, my name is",
    "The future of AI is",
]
sampling_params = SamplingParams(temperature=0.8, top_p=0.95)
# 模型下载（首次运行，10 MB/s速度下约3-5分钟）
llm = LLM(model="Qwen/Qwen3-8B")

outputs = llm.generate(prompts, sampling_params)

# 输出结果
for output in outputs:
    prompt = output.prompt
    generated_text = output.outputs[0].text
    print(f"Prompt: {prompt!r}, Generated text: {generated_text!r}")
```

## 问题与反馈

如有疑问或需使用特殊功能，请通过[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)仓库提交issue或Pull Request。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/openeuler/vllm-cpu" title="openeuler/vllm-cpu Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/openeuler/vllm-cpu</a></p>
