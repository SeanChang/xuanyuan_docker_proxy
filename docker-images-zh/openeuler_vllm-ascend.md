---
image: openeuler/vllm-ascend
description: "官方vLLM Ascend Docker镜像，基于openEuler构建，是社区维护的硬件插件，用于在Ascend NPU上无缝运行vLLM，支持Transformer、MoE、Embedding、多模态等多种开源模型，遵循硬件可插拔接口规范。"
source: https://xuanyuan.cloud/zh/r/openeuler/vllm-ascend
canonical: https://xuanyuan.cloud/zh/r/openeuler/vllm-ascend
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/vllm-ascend" title="openeuler/vllm-ascend Docker 镜像中文简介、标签列表与拉取命令">openeuler/vllm-ascend — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/openeuler/vllm-ascend" title="openeuler/vllm-ascend Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/openeuler/vllm-ascend</a>

# vLLM Ascend Docker镜像文档

## 镜像概述

vLLM Ascend Docker镜像是基于[openEuler](https://repo.openeuler.org/)构建的官方镜像，由[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)维护。该镜像集成了vLLM Ascend插件，这是一个社区维护的硬件插件，旨在实现vLLM在Ascend NPU上的无缝运行，是vLLM社区支持Ascend后端的推荐方案。

该插件遵循[vLLM硬件可插拔RFC](https://github.com/vllm-project/vllm/issues/11162)规范，提供硬件可插拔接口，将Ascend NPU与vLLM解耦集成。通过使用vLLM Ascend插件，可在Ascend NPU上运行多种流行开源模型，包括Transformer类、混合专家（Mixture-of-Expert）、Embedding及多模态LLM等。

## 核心功能与特性

- **硬件适配**：专为Ascend NPU设计，支持Atlas系列设备
- **模型兼容性**：支持Transformer、MoE、Embedding、多模态等多种LLM模型
- **接口规范**：遵循vLLM硬件可插拔接口规范，与vLLM生态无缝集成
- **开源免费**：基于openEuler构建，免费使用且无用户速率限制
- **多架构支持**：支持amd64和arm64架构

## 支持的标签及Dockerfile链接

镜像标签由vLLM Ascend版本、基础镜像版本组成，具体如下：

| 标签 | 说明 | 架构 |
|------|------|------|
|[0.7.3rc2-torch_npu2.5.1-cann8.0.0-python3.10-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-ascend/0.7.3rc2-torch_npu2.5.1-cann8.0.0-python3.10/22.03-lts/Dockerfile)| vLLM Ascend 0.7.3rc2 on openEuler 22.03-LTS | amd64, arm64 |
|[0.7.3-torch_npu2.5.1-cann8.1.rc1-python3.10-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-ascend/0.7.3-torch_npu2.5.1-cann8.1.rc1-python3.10/22.03-lts/Dockerfile)| vLLM Ascend 0.7.3 on openEuler 22.03-LTS | amd64, arm64 |
|[0.8.4rc1-torch_npu2.5.1-cann8.0.0-python3.10-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-ascend/0.8.4rc1-torch_npu2.5.1-cann8.0.0-python3.10/22.03-lts/Dockerfile)| vLLM Ascend 0.8.4rc1 on openEuler 22.03-LTS | amd64, arm64 |
|[0.8.5rc1-torch_npu2.5.1-cann8.1.rc1-python3.10-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-ascend/0.8.5rc1-torch_npu2.5.1-cann8.1.rc1-python3.10/22.03-lts/Dockerfile)| vLLM Ascend 0.8.5rc1 on openEuler 22.03-LTS | amd64, arm64 |
|[0.9.0rc1-torch_npu2.5.1-cann8.1.rc1-python3.10-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-ascend/0.9.0rc1-torch_npu2.5.1-cann8.1.rc1-python3.10/22.03-lts/Dockerfile)| vLLM Ascend 0.9.0rc1 on openEuler 22.03-LTS | amd64, arm64 |
|[0.9.0rc2-torch_npu2.5.1-cann8.1.rc1-python3.10-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-ascend/0.9.0rc2-torch_npu2.5.1-cann8.1.rc1-python3.10/22.03-lts/Dockerfile)| vLLM Ascend 0.9.0rc2 on openEuler 22.03-LTS | amd64, arm64 |
|[0.9.1rc1-torch_npu2.5.1-cann8.1.rc1-python3.10-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-ascend/0.9.1rc1-torch_npu2.5.1-cann8.1.rc1-python3.10/22.03-lts/Dockerfile)| vLLM Ascend 0.9.1rc1 on openEuler 22.03-LTS | amd64, arm64 |
|[0.11.0rc0-torch_npu2.5.1-cann8.1.rc1-python3.10-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-ascend/0.11.0rc0-torch_npu2.5.1-cann8.1.rc1-python3.10/22.03-lts/Dockerfile)| vLLM Ascend 0.11.0rc0 on openEuler 22.03-LTS | amd64, arm64 |

## 使用场景

- Ascend NPU上的大语言模型推理任务
- 多模态模型部署与推理
- 批量离线推理任务
- LLM应用开发与测试

## 使用方法

### 1. 支持的设备

- Atlas A2训练系列（Atlas 800T A2、Atlas 900 A2 PoD、Atlas 200T A2 Box16、Atlas 300T A2）
- Atlas 800I A2推理系列（Atlas 800I A2）

### 2. 使用容器设置环境

```bash
# 根据设备更新DEVICE（/dev/davinci[0-7]）
export DEVICE=/dev/davinci0
# 更新vllm-ascend镜像
export IMAGE=quay.io/ascend/vllm-ascend:v0.8.4rc1-openeuler
docker run --rm \
--name vllm-ascend \
--device $DEVICE \
--device /dev/davinci_manager \
--device /dev/devmm_svm \
--device /dev/hisi_hdc \
-v /usr/local/dcmi:/usr/local/dcmi \
-v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
-v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
-v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \
-v /etc/ascend_install.info:/etc/ascend_install.info \
-v /root/.cache:/root/.cache \
-p 8000:8000 \
-it $IMAGE bash
```

### 3. 离线推理

可使用Modelscope镜像加速模型下载：

```bash
export VLLM_USE_MODELSCOPE=true
```

安装vLLM后，可对输入提示列表进行文本生成（即离线批量推理）。直接运行以下Python脚本或使用`python3` shell生成文本：

```python
from vllm import LLM, SamplingParams

prompts = [
    "Hello, my name is",
    "The future of AI is",
]
sampling_params = SamplingParams(temperature=0.8, top_p=0.95)
# 首次运行将花费约3-5分钟（10 MB/s）下载模型
llm = LLM(model="Qwen/Qwen2.5-0.5B-Instruct")

outputs = llm.generate(prompts, sampling_params)

for output in outputs:
    prompt = output.prompt
    generated_text = output.outputs[0].text
    print(f"提示: {prompt!r}, 生成文本: {generated_text!r}")
```

## 问题与反馈

如有任何问题或需使用特殊功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。

## 获取帮助

- [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)
- [openEuler社区](https://gitee.com/openeuler/community)
- [vLLM Ascend技术文档](https://vllm-ascend.readthedocs.io/en/latest/)
