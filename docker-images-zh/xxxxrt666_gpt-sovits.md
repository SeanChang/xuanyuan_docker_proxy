<!-- xuanyuan-docker-images-zh
image: xxxxrt666/gpt-sovits
source: https://xuanyuan.cloud/zh/r/xxxxrt666/gpt-sovits
canonical: https://xuanyuan.cloud/zh/r/xxxxrt666/gpt-sovits
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [xxxxrt666/gpt-sovits — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/xxxxrt666/gpt-sovits "xxxxrt666/gpt-sovits Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/xxxxrt666/gpt-sovits

🐳 Docker概述

提供官方Docker镜像，便于部署，通过Miniconda环境实现完全集成。

- 镜像基于 [GPT-SoVITS](https://github.com/RVC-Boss/GPT-SoVITS) 提供的脚本和工作流构建
- 提供两个CUDA版本：`CU126` 和 `CU128`（默认 `latest` 指向 `CU126-Lite`）。
- 所有GPU功能、依赖项和WebUI组件均已预配置。

有关使用说明和自定义，请参考 [Dockerfile](https://github.com/RVC-Boss/GPT-SoVITS/blob/main/Dockerfile) 和 [README](https://github.com/RVC-Boss/GPT-SoVITS/blob/main/README.md)。

### Git Clone 和 Compose

```bash
docker compose run --service-ports <GPT-SoVITS-CU126-Lite|GPT-SoVITS-CU128-Lite|GPT-SoVITS-CU126|GPT-SoVITS-CU128>
```

### Git Clone 和本地构建

```bash
bash docker_build.sh --cuda <12.6|12.8> [--lite]
```

### 进入运行中的容器

```bash
docker exec -it <GPT-SoVITS-CU126-Lite|GPT-SoVITS-CU128-Lite|GPT-SoVITS-CU126|GPT-SoVITS-CU128> bash
```
