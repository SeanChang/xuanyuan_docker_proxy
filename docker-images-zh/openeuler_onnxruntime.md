---
image: openeuler/onnxruntime
description: "官方ONNX Runtime Docker镜像，基于openEuler构建，提供跨平台机器学习推理和训练加速，支持PyTorch、TensorFlow等框架及多种硬件，通过优化和硬件加速提升性能并降低成本。"
source: https://xuanyuan.cloud/zh/r/openeuler/onnxruntime
canonical: https://xuanyuan.cloud/zh/r/openeuler/onnxruntime
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/onnxruntime" title="openeuler/onnxruntime Docker 镜像中文简介、标签列表与拉取命令">openeuler/onnxruntime 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ONNX Runtime Docker镜像（openEuler版）

## 镜像概述
本镜像为官方ONNX Runtime Docker镜像，基于[openEuler](https://repo.openeuler.org/)构建，由[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)维护。ONNX Runtime是一款跨平台的机器学习推理和训练加速器，支持从PyTorch、TensorFlow/Keras等深度学习框架以及scikit-learn、LightGBM、XGBoost等经典机器学习库导出的模型，可在不同硬件、驱动和操作系统上运行，并通过硬件加速、图优化和转换提供最佳性能。

## 核心功能与特性
- **跨平台支持**：兼容不同硬件架构（amd64、arm64）、驱动和操作系统
- **多框架兼容**：支持PyTorch、TensorFlow/Keras等深度学习框架及scikit-learn等经典机器学习库的模型
- **硬件加速**：利用硬件加速器提升推理和训练性能
- **性能优化**：通过图优化和转换技术降低成本，提升用户体验
- **开源免费**：无每用户速率限制，可自由使用

## 支持的标签及Dockerfile链接
ONNX Runtime Docker镜像的标签由完整软件栈版本组成，具体信息如下：

| 标签 | 说明 | 架构 |
|------|------|------|
|[1.22.1-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/onnxruntime/1.22.1/24.03-lts-sp2/Dockerfile)| 基于openEuler 24.03-LTS-SP2的ONNX Runtime 1.22.1 | amd64, arm64 |

## 使用方法

### 前提条件
确保已安装Docker，或在Windows上使用适用于Linux容器的Docker。

### 获取镜像
有两种方式获取ONNX Runtime Docker镜像：

1. **从DockerHub拉取预构建镜像**
   ```bash
   docker pull docker.xuanyuan.run/openeuler/onnxruntime
   ```

2. **本地构建镜像**
   - 克隆[源代码仓库](https://gitee.com/openeuler/openeuler-docker-images)
   - 进入`AI/onnxruntime`目录，执行以下命令构建镜像：
     ```bash
     docker build . -t openeuler/onnxruntime
     ```

### 运行容器
启动ONNX Runtime开发者镜像容器：
```bash
docker run -it docker.xuanyuan.run/openeuler/onnxruntime
```

## 问题反馈
如遇问题或需使用特殊功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)仓库提交issue或pull request。获取帮助可联系[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)或[openEuler社区](https://gitee.com/openeuler/community)。
