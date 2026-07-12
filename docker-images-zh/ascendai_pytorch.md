---
image: ascendai/pytorch
description: "基于CANN镜像构建的Ascend PyTorch基础容器镜像，预安装torch、torchvision、torchaudio及torch_npu，支持在Ascend NPU上进行PyTorch开发和运行。"
source: https://xuanyuan.cloud/zh/r/ascendai/pytorch
canonical: https://xuanyuan.cloud/zh/r/ascendai/pytorch
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ascendai/pytorch" title="ascendai/pytorch Docker 镜像中文简介、标签列表与拉取命令">ascendai/pytorch 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Torch-NPU Docker镜像

## 镜像概述和主要用途

Torch-NPU Docker镜像基于[cann](https://hub.docker.com/r/ascendai/cann)镜像构建，通过`pip`预安装了PyTorch及其相关组件，旨在为Ascend NPU环境提供便捷的PyTorch开发和运行环境。

可用标签及构建参数可参考[arg.json](https://github.com/openmerlin/dockerfile/blob/main/arg.json)：
- `2.1.0`
- `2.2.0`

> [!NOTE]
> 若所需标签未列出，可提交issue反馈或自行构建。

## 核心功能和特性

- 基于CANN基础镜像，确保与Ascend NPU驱动和运行时环境兼容
- 预安装关键PyTorch组件：
  - `torch`：PyTorch核心库
  - `torchvision`：计算机视觉扩展库
  - `torchaudio`：音频处理扩展库
  - `torch_npu`：Ascend NPU的PyTorch适配层

## 使用场景和适用范围

适用于在Ascend NPU硬件上进行：
- PyTorch模型开发与调试
- 深度学习模型训练
- 推理任务部署
- 算法原型验证

## 使用方法和配置说明

假设NPU设备挂载路径为`/dev/davinci1`，NPU驱动安装路径为`/usr/local/Ascend`，使用以下命令启动容器：

```docker
docker run \
    --name torch_container \
    --device /dev/davinci1 \
    --device /dev/davinci_manager \
    --device /dev/devmm_svm \
    --device /dev/hisi_hdc \
    -v /usr/local/dcmi:/usr/local/dcmi \
    -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
    -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
    -v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \
    -v /etc/ascend_install.info:/etc/ascend_install.info \
    -it docker.xuanyuan.run/ascendai/pytorch:2.2.0 bash
```

### 参数说明：
- `--device`：挂载NPU相关设备节点
- `-v`：挂载主机上的NPU驱动、工具和配置文件

## 构建方法

### 使用Docker Buildx Bake（需Docker Engine 20.10+）
在项目根目录执行：
```docker
docker buildx bake -f arg.json -f docker-bake.hcl pytorch
```

### 使用Docker Build（需Docker Engine 18+）
在项目根目录执行：
```docker
docker build \
    -t ascendai/pytorch:latest \
    -f pytorch/new.Dockerfile \
    --build-arg BASE_VERSION=latest \
    --build-arg PYTORCH_VERSION=2.2.0 \
    pytorch/
