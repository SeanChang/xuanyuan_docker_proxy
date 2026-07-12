---
image: tensorflow/serving
description: "TensorFlow Serving（[]"
source: https://xuanyuan.cloud/zh/r/tensorflow/serving
canonical: https://xuanyuan.cloud/zh/r/tensorflow/serving
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/tensorflow/serving" title="tensorflow/serving Docker 镜像中文简介、标签列表与拉取命令">tensorflow/serving 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# TensorFlow Serving Docker镜像介绍


## 镜像标签 (Tags)

`tensorflow/serving` 镜像提供以下几种类型，适用于不同场景：

- **:latest**: 最小化镜像，已预装 TensorFlow Serving 二进制文件，可直接启动并用于模型服务。  
- **:latest-gpu**: 最小化 GPU 镜像，预装支持 NVIDIA GPU 的 TensorFlow Serving 二进制文件，可直接用于 GPU 环境下的模型服务。  
- **:latest-devel**: 开发版镜像，包含完整的源码、依赖库及编译工具链，同时提供 CPU 版本的已编译二进制文件，适用于二次开发或自定义构建。  
- **:latest-devel-gpu**: GPU 开发版镜像，包含完整的源码、依赖库（如 cuda9、cudnn7）及编译工具链，同时提供 NVIDIA GPU 版本的已编译二进制文件，适用于 GPU 环境下的二次开发。  


## 注意事项 (Note)

- 运行 GPU 类型镜像（如 `:latest-gpu`、`:latest-devel-gpu`）时，需先安装 [nvidia-docker]  工具。  
- 可将标签中的 `latest` 替换为具体版本号（如 `1.9.0-rc2`，版本列表见 [发布页面] ）或 `nightly`（基于最新源码构建的每日更新镜像）。  


## 详细操作指南 (HOWTO)

完整的 Docker 镜像使用步骤（如启动服务、部署模型等），请参考官方文档：  
[TensorFlow Serving Docker 操作指南]
