<!-- xuanyuan-docker-images-zh
image: rocm/vllm-dev
source: https://xuanyuan.cloud/zh/r/rocm/vllm-dev
canonical: https://xuanyuan.cloud/zh/r/rocm/vllm-dev
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [rocm/vllm-dev — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/rocm/vllm-dev "rocm/vllm-dev Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/rocm/vllm-dev

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
