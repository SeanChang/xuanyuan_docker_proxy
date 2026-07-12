---
image: vistart/cuda
description: "基于NVIDIA官方Dockerfile构建的CUDA镜像，使用清华源，集成CUDA、CUDNN、NCCL、TensorRT等组件，支持多种Ubuntu版本，每周更新，提供Docker Hub和阿里云香港节点双存储。"
source: https://xuanyuan.cloud/zh/r/vistart/cuda
canonical: https://xuanyuan.cloud/zh/r/vistart/cuda
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/vistart/cuda" title="vistart/cuda Docker 镜像中文简介、标签列表与拉取命令">vistart/cuda 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 警告!!!

所有继承自官方版本Ubuntu的镜像存在问题，**请勿更新**！我们正在从源码重新构建所有镜像。

[![构建状态](https://api.travis-ci.com/vistart/Dockerfiles.svg?branch=cuda)](https://travis-ci.com/github/vistart/Dockerfiles)

# 简介

本仓库下的所有镜像均严格按照NVIDIA官方发布的Dockerfile构建。与官方版本的唯一区别是操作系统源来自[清华大学](https://mirrors.tuna.tsinghua.edu.cn)。这些镜像每周更新。

除了存储在Docker Hub外，镜像还存储在阿里云容器服务香港节点作为备用。如果您希望尽快使用最新镜像，但Docker Hub长时间未能同步，可尝试使用阿里云容器服务香港节点。

标签名称格式为：
```
registry.cn-hongkong.aliyuncs.com/vistart_public/cuda:<tag name>
```

如果您希望尽快使用最新镜像，但不想更改标签名称，可先拉取阿里云香港节点的镜像，再拉取Docker Hub上的镜像。由于两者内容完全相同，拉取Docker Hub镜像的清单后会进行标记，无需拉取任何镜像层。之后如需更新镜像，重复上述操作即可。

# 最新CUDA 11.0（实验版）（Ubuntu 20.04的CUDA 11.0已就绪！CUDNN 8.0.2/NCCL 2.7.8/TensorRT 7.1.3已发布！）

## Ubuntu 20.04
- 11.0-base-ubuntu20.04（cuda 11.0.3）
- 11.0-runtime-ubuntu20.04（cuda 11.0.3，nccl 2.7.8）
- 11.0-devel-ubuntu20.04（cuda 11.0.3，nccl 2.7.8）
- 11.0-cudnn8-runtime-ubuntu20.04（cuda 11.0.3，nccl 2.7.8，cudnn 8.0.2.39）
- 11.0-cudnn8-devel-ubuntu20.04（cuda 11.0.3，nccl 2.7.8，cudnn 8.0.2.39）
- 11.0-cudnn8-tensorrt7-devel-ubuntu20.04, 11.0-ubuntu20.04, latest（cuda 11.0.3，nccl 2.7.8，cudnn 8.0.2.39，tensorrt 7.1.3.4）

## Ubuntu 18.04
- 11.0-base-ubuntu18.04（cuda 11.0.3）
- 11.0-runtime-ubuntu18.04（cuda 11.0.3，nccl 2.7.8）
- 11.0-devel-ubuntu18.04（cuda 11.0.3，nccl 2.7.8）
- 11.0-cudnn8-runtime-ubuntu18.04（cuda 11.0.3，nccl 2.7.8，cudnn 8.0.2.39）
- 11.0-cudnn8-devel-ubuntu18.04（cuda 11.0.3，nccl 2.7.8，cudnn 8.0.2.39）
- 11.0-cudnn8-tensorrt7-devel-ubuntu18.04, 10.2-ubuntu18.04（cuda 11.0.3，nccl 2.7.8，cudnn 8.0.2.39，tensorrt 7.1.3.4）

## Ubuntu 16.04
- 11.0-base-ubuntu16.04（cuda 11.0.3）
- 11.0-runtime-ubuntu16.04（cuda 11.0.3，nccl 2.7.8）
- 11.0-devel-ubuntu16.04（cuda 11.0.3，nccl 2.7.8）
- 11.0-cudnn8-runtime-ubuntu16.04（cuda 11.0.3，nccl 2.7.8，cudnn 8.0.2.39）
- 11.0-cudnn8-devel-ubuntu16.04（cuda 11.0.3，nccl 2.7.8，cudnn 8.0.2.39）
- 11.0-cudnn8-tensorrt7-devel-ubuntu16.04（cuda 11.0.3，nccl 2.7.8，cudnn 8.0.2.39，tensorrt 7.1.3.4）

# CUDA 10.2

## Ubuntu 20.04（已弃用）
- 10.2-base-ubuntu20.04（cuda 10.2.89）
- 10.2-runtime-ubuntu20.04（cuda 10.2.89，nccl 2.7.8）
- 10.2-cudnn7-runtime-ubuntu20.04（cuda 10.2.89，nccl 2.7.8，cudnn 7.6.5.32）
- 10.2-devel-ubuntu20.04（cuda 10.2.89，nccl 2.7.8）
- 10.2-cudnn7-devel-ubuntu20.04（cuda 10.2.89，nccl 2.7.8，cudnn 7.6.5.32）
- 10.2-cudnn7-tensorrt6-devel-ubuntu20.04（cuda 10.2.89，nccl 2.7.8，cudnn 7.6.5.32，tensorrt 6.0.1.8）
- 10.2-cudnn7-tensorrt7-devel-ubuntu20.04（cuda 10.2.89，nccl 2.7.8，cudnn 7.6.5.32，tensorrt 7.0.0.11）
- 10.2-cudnn8-runtime-ubuntu20.04（cuda 10.2.89，nccl 2.7.8，cudnn 8.0.2.39）
- 10.2-cudnn8-devel-ubuntu20.04（cuda 10.2.89，nccl 2.7.8，cudnn 8.0.2.39）
- 10.2-cudnn8-tensorrt7-devel-ubuntu20.04, 10.2-ubuntu20.04（cuda 10.2.89，nccl 2.7.8，cudnn 8.0.2.39，tensorrt 7.1.3.4）

## Ubuntu 18.04
- 10.2-base-ubuntu18.04（cuda 10.2.89）
- 10.2-runtime-ubuntu18.04（cuda 10.2.89，nccl 2.7.8）
- 10.2-cudnn7-runtime-ubuntu18.04（cuda 10.2.89，nccl 2.7.8，cudnn 7.6.5.32）
- 10.2-devel-ubuntu18.04（cuda 10.2.89，nccl 2.7.8）
- 10.2-cudnn7-devel-ubuntu18.04（cuda 10.2.89，nccl 2.7.8，cudnn 7.6.5.32）
- 10.2-cudnn7-tensorrt6-devel-ubuntu18.04（cuda 10.2.89，nccl 2.7.8，cudnn 7.6.5.32，tensorrt 6.0.1.8）
- 10.2-cudnn7-tensorrt7-devel-ubuntu18.04（cuda 10.2.89，nccl 2.7.8，cudnn 7.6.5.32，tensorrt 7.0.0.11）
- 10.2-cudnn8-runtime-ubuntu18.04（cuda 10.2.89，nccl 2.7.8，cudnn 7.6.5.32）
- 10.2-cudnn8-devel-ubuntu18.04（cuda 10.2.89，nccl 2.7.8，cudnn 7.6.5.32）
- 10.2-cudnn8-tensorrt7-devel-ubuntu18.04, 10.2-ubuntu18.04（cuda 10.2.89，nccl 2.7.8，cudnn 8.0.2.39，tensorrt 7.1.3.4）

## Ubuntu 16.04
- 10.2-base-ubuntu16.04（cuda 10.2.89）
- 10.2-runtime-ubuntu16.04（cuda 10.2.89，nccl 2.7.8）
- 10.2-cudnn7-runtime-ubuntu16.04（cuda 10.2.89，nccl 2.7.8，cudnn 7.6.5.32）
- 10.2-devel-ubuntu16.04（cuda 10.2.89，nccl 2.7.8）
- 10.2-cudnn7-devel-ubuntu16.04（cuda 10.2.89，nccl 2.7.8，cudnn 7.6.5.32）
- 10.2-cudnn7-tensorrt6-devel-ubuntu16.04（cuda 10.2.89，nccl 2.7.8，cudnn 7.6.5.32，tensorrt 6.0.1.8）
- 10.2-cudnn7-tensorrt7-devel-ubuntu16.04（cuda 10.2.89，nccl 2.7.8，cudnn 7.6.5.32，tensorrt 7.0.0.11）
- 10.2-cudnn8-runtime-ubuntu16.04（cuda 10.2.89，nccl 2.7.8，cudnn 7.6.5.32）
- 10.2-cudnn8-devel-ubuntu16.04（cuda 10.2.89，nccl 2.7.8，cudnn 7.6.5.32）
- 10.2-cudnn8-tensorrt7-devel-ubuntu16.04, 10.2-ubuntu16.04（cuda 10.2.89，nccl 2.7.8，cudnn 8.0.2.39，tensorrt 7.1.3.4）

# CUDA 10.1

## Ubuntu 20.04（已弃用）
- 10.1-base-ubuntu20.04（cuda 10.1.243）
- 10.1-runtime-ubuntu20.04（cuda 10.1.243，nccl 2.7.8）
- 10.1-cudnn7-runtime-ubuntu20.04（cuda 10.1.243，nccl 2.7.8，cudnn 7.6.5.32）
- 10.1-devel-ubuntu20.04（cuda 10.1.243，nccl 2.7.8）
- 10.1-cudnn7-devel-ubuntu20.04（cuda 10.1.243，nccl 2.7.8，cudnn 7.6.5.32）
- 10.1-cudnn7-tensorrt6-devel-ubuntu20.04, 10.1-ubuntu20.04（cuda 10.1.243，nccl 2.7.8，cudnn 7.6.5.32，tensorrt 6.0.1.5）

## Ubuntu 18.04
- 10.1-base-ubuntu18.04（cuda 10.1.243）
- 10.1-runtime-ubuntu18.04（cuda 10.1.243，nccl 2.7.8）
- 10.1-cudnn7-runtime-ubuntu18.04（cuda 10.1.243，nccl 2.7.8，cudnn 7.6.5.32）
- 10.1-cudnn8-runtime-ubuntu18.04（cuda 10.1.243，nccl 2.7.8，cudnn 8.0.2.39）
- 10.1-devel-ubuntu18.04（cuda 10.1.243，nccl 2.7.8）
- 10.1-cudnn7-devel-ubuntu18.04（cuda 10.1.243，nccl 2.7.8，cudnn 7.6.5.32）
- 10.1-cudnn8-devel-ubuntu18.04（cuda 10.1.243，nccl 2.7.8，cudnn 8.0.2.39）
- 10.1-cudnn7-tensorrt6-devel-ubuntu18.04, 10.1-ubuntu18.04（cuda 10.1.243，nccl 2.7.8，cudnn 7.6.5.32，tensorrt 6.0.1.5）

## Ubuntu 16.04
- 10.1-base-ubuntu16.04（cuda 10.1.243）
- 10.1-runtime-ubuntu16.04（cuda 10.1.243，nccl 2.7.8）
- 10.1-cudnn7-runtime-ubuntu16.04（cuda 10.1.243，nccl 2.7.8，cudnn 7.6.5.32）
- 10.1-cudnn8-runtime-ubuntu16.04（cuda 10.1.243，nccl 2.7.8，cudnn 8.0.2.39）
- 10.1-devel-ubuntu16.04（cuda 10.1.243，nccl 2.7.8）
- 10.1-cudnn7-devel-ubuntu16.04（cuda 10.1.243，nccl 2.7.8，cudnn 7.6.5.32）
- 10.1-cudnn8-devel-ubuntu16.04（cuda 10.1.243，nccl 2.7.8，cudnn 8.0.2.39）
- 10.1-cudnn7-tensorrt6-devel-ubuntu16.04, 10.1-ubuntu16.04（cuda 10.1.243，nccl 2.7.8，cudnn 7.6.5.32，tensorrt 6.0.1.5）

## Ubuntu 14.04
- 10.1-base-ubuntu14.04（cuda 10.1.243）
- 10.1-runtime-ubuntu14.04（cuda 10.1.243，nccl 2.7.8）
- 10.1-cudnn7-runtime-ubuntu14.04（cuda
