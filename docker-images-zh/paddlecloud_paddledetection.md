---
image: paddlecloud/paddledetection
description: "PaddleDetection模型套件的标准Docker镜像，用于便捷的Docker化部署和云上部署，包含运行模型案例的所有依赖，支持异构硬件环境和常见CUDA版本，开箱即用且持续更新。"
source: https://xuanyuan.cloud/zh/r/paddlecloud/paddledetection
canonical: https://xuanyuan.cloud/zh/r/paddlecloud/paddledetection
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/paddlecloud/paddledetection" title="paddlecloud/paddledetection Docker 镜像中文简介、标签列表与拉取命令">paddlecloud/paddledetection — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/paddlecloud/paddledetection" title="paddlecloud/paddledetection Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/paddlecloud/paddledetection</a>

# PaddleDetection

本镜像仓库用于存储飞桨模型套件[PaddleDetection](https://github.com/PaddlePaddle/PaddleDetection)的标准镜像，方便用户进行Docker化部署或云上部署。PaddleDetection套件的标准镜像由[PaddleCloud](https://github.com/PaddlePaddle/PaddleCloud)项目基于[Tekton Pipeline](https://github.com/tektoncd/pipeline)自动构建。若需对模型套件进行二次开发并持续构建定制镜像，可参考[PaddleCloud Tekton文档](https://github.com/PaddlePaddle/PaddleCloud/blob/main/tekton/README.md)构建自定义套件镜像CI流水线。更多部署内容可参考云上飞桨项目[PaddleCloud](https://github.com/PaddlePaddle/PaddleCloud)。

## PaddleCloud优势

- **模型套件Docker镜像大礼包**  
  提供飞桨模型套件Docker镜像大礼包，包含运行模型套件案例的所有依赖，支持持续更新，适配异构硬件环境和常见CUDA版本，开箱即用。

- **丰富的云上飞桨组件**  
  包含样本数据缓存组件、分布式训练组件、推理服务组件等云原生功能组件，方便用户在Kubernetes集群上快速实现模型的训练和部署。

- **功能强大的自运维能力**  
  基于Kubernetes的Operator机制提供自运维能力，如训练组件支持多种架构模式，具备分布式容错与弹性训练能力；推理服务组件支持自动扩缩容与蓝绿发版等。

- **针对飞桨框架的定制优化**  
  通过缓存样本数据加速云上飞桨分布式训练作业，基于飞桨框架和调度器的协同设计优化集群GPU利用率。

## 安装Docker

若未安装Docker，可参考[Docker官方文档](https://docs.docker.com/get-docker/)进行安装。如需使用GPU版本镜像，还需安装NVIDIA相关驱动和nvidia-docker，详情参考[官方文档](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker)。

## 快速上手

Docker环境可快速体验，提供CPU和GPU版本镜像。Docker新手建议学习[docker基本用法](https://github.com/PaddlePaddle/PaddleCloud/blob/main/docs/zh_CN/docker-tutorial.md)。

### 使用CPU版本的Docker镜像
```bash
docker run --name dev -v $PWD:/mnt -p 8888:8888 -it paddlecloud/paddledetection:2.4-cpu-e9a542 /bin/bash
```

### 使用GPU版本的Docker镜像
```bash
docker run --name dev --runtime=nvidia -v $PWD:/mnt -p 8888:8888 -it paddlecloud/paddledetection:2.4-gpu-cuda10.2-cudnn7-e9a542 /bin/bash
```

进入容器后，即可执行PaddleDetection套件中提供的案例。

## PaddleDetection Docker化部署案例

- [PP-Human行人检测](https://github.com/PaddlePaddle/PaddleCloud/blob/main/samples/pphuman/pphuman-docker.md)
- [训练PP-YOLOE模型](https://github.com/PaddlePaddle/PaddleCloud/blob/main/samples/pphuman/ppyoloe-docker.md)

## 镜像列表

镜像tag最后6个字符为commit id（如`bb4fbe`），用于定位镜像中的模型套件代码版本，方便问题排查。

| 镜像路径 | 构建时间 |
|--------------------------------------------------------------|-------------------|
| paddlecloud/paddledetection:2.4-cpu-e9a542 | 2022年05月09日 |
| paddlecloud/paddledetection:2.4-gpu-cuda11.2-cudnn8-e9a542 | 2022年05月09日 |
| paddlecloud/paddledetection:2.4-gpu-cuda10.2-cudnn7-e9a542 | 2022年05月09日 |
