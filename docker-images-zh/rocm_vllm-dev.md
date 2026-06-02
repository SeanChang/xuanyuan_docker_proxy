---
image: rocm/vllm-dev
description: "rocm/vllm-dev是基于AMD ROCm平台的高性能大语言模型开发镜像，集成vllm框架与AMD GPU加速能力，专为开发者打造大语言模型部署、推理优化及二次开发环境。镜像预配置PyTorch、HIP等核心依赖，支持低延迟、高吞吐量的LLM推理，可快速进行模型加载、性能调优与多实例部署测试，助力开发者高效构建和调试大语言模型应用，充分发挥AMD GPU在AI计算中的算力优势。"
source: https://xuanyuan.cloud/zh/r/rocm/vllm-dev
canonical: https://xuanyuan.cloud/zh/r/rocm/vllm-dev
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rocm/vllm-dev" title="rocm/vllm-dev Docker 镜像中文简介、标签列表与拉取命令">rocm/vllm-dev 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## vLLM-dev

vLLM-dev 是用于大语言模型（LLM）推理和服务的每周开发流工具包及库。这些容器提供了在 AMD Instinct™ 加速器上快速运行或试用 vLLM 的方式。如需构建或扩展 vLLM-dev，请参考 [构建 Dockerfiles]([])。


### 运行容器

执行以下命令启动容器：

```shell
docker run -it --rm \
    --ipc=host \
    --network=host \
    --privileged \
    --cap-add=CAP_SYS_ADMIN \
    --device=/dev/kfd \
    --device=/dev/dri \
    --device=/dev/mem \
    --group-add render \
    --cap-add=SYS_PTRACE \
    --security-opt seccomp=unconfined \
    rocm/vllm-dev:main
```


### 文档

完整文档（含入门指南、环境配置等内容）详见 [此处]([])。
