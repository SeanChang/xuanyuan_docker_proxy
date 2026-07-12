---
image: openvino/openvino_tensorflow_ubuntu20_runtime
description: "OpenVINO™与TensorFlow集成的运行时Docker镜像，适用于Ubuntu 20.04 LTS，通过添加两行代码即可利用OpenVINO优化，加速TensorFlow推理在Intel CPU、iGPU、VPU及VAD-M等设备上的性能。"
source: https://xuanyuan.cloud/zh/r/openvino/openvino_tensorflow_ubuntu20_runtime
canonical: https://xuanyuan.cloud/zh/r/openvino/openvino_tensorflow_ubuntu20_runtime
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openvino/openvino_tensorflow_ubuntu20_runtime" title="openvino/openvino_tensorflow_ubuntu20_runtime Docker 镜像中文简介、标签列表与拉取命令">openvino/openvino_tensorflow_ubuntu20_runtime 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 最新标签

* `2.2.0`, `latest`

## 关于OpenVINO™与TensorFlow集成

**OpenVINO™与TensorFlow集成**专为希望在推理应用中使用[OpenVINO™](https://software.intel.com/content/www/us/en/develop/tools/openvino-toolkit.html)的TensorFlow*开发者设计。TensorFlow*开发者现在只需添加两行代码，即可在多种Intel®计算设备上的TensorFlow推理应用中利用[OpenVINO™](https://software.intel.com/content/www/us/en/develop/tools/openvino-toolkit.html)工具包优化。

```python
import openvino_tensorflow
openvino_tensorflow.set_backend('<backend_name>')
```

本产品提供[OpenVINO™](https://software.intel.com/content/www/us/en/develop/tools/openvino-toolkit.html)内联优化，通过最少的代码修改提升推理性能。**OpenVINO™与TensorFlow集成可加速**多种AI模型在各类Intel®芯片上的推理，如：

- Intel® CPU
- Intel®集成GPU
- Intel® Movidius™视觉处理单元（简称VPU）
- 搭载8个Intel Movidius™ MyriadX VPU的Intel®视觉加速器设计（简称VAD-M或HDDL）

[注：为获得最佳性能、效率、工具定制化和硬件控制，建议开发者采用原生OpenVINO™ API及其运行时。]

GitHub：https://github.com/openvinotoolkit/openvino_tensorflow/

文档：https://github.com/openvinotoolkit/openvino_tensorflow/tree/master/docs

构建此镜像的Dockerfile可在以下位置找到：https://github.com/openvinotoolkit/openvino_tensorflow/tree/master/docker

## OpenVINO™与TensorFlow集成运行时Docker镜像（适用于Ubuntu* 20.04 LTS）

标签为**2.2.0**的此镜像包含所有必要的运行时Python包和共享库，支持在CPU、GPU、VPU和VAD-M上执行带OpenVINO™后端的TensorFlow Python应用。默认情况下，它运行Jupyter服务器，包含图像分类和目标检测示例，展示使用OpenVINO™与TensorFlow集成的性能优势。

### 启动Jupyter服务器（CPU访问）

```bash
docker run -it --rm \
           -p 8888:8888 \
           docker.xuanyuan.run/openvino/openvino_tensorflow_ubuntu20_runtime:2.2.0
```

### 启动Jupyter服务器（iGPU访问）

```bash
docker run -it --rm \
           -p 8888:8888 \
           --device-cgroup-rule='c 189:* rmw' \
           --device /dev/dri:/dev/dri \
           docker.xuanyuan.run/openvino/openvino_tensorflow_ubuntu20_runtime:2.2.0
```

### 启动Jupyter服务器（MYRIAD访问）

```bash
docker run -it --rm \
           -p 8888:8888 \
           --device-cgroup-rule='c 189:* rmw' \
           -v /dev/bus/usb:/dev/bus/usb \
           docker.xuanyuan.run/openvino/openvino_tensorflow_ubuntu20_runtime:2.2.0
```

### 启动Jupyter服务器（VAD-M访问）

```bash
docker run -itu docker.xuanyuan.run/root:root --rm \
           -p 8888:8888 \
           --device-cgroup-rule='c 189:* rmw' \
           --mount type=bind,source=/var/tmp,destination=/var/tmp \
           --device /dev/ion:/dev/ion \
           -v /dev/bus/usb:/dev/bus/usb \
           openvino/openvino_tensorflow_ubuntu20_runtime:2.2.0
```

### 以运行时目标/bin/bash启动镜像（支持CPU、iGPU和MYRIAD设备访问的容器shell）

```bash
docker run -itu docker.xuanyuan.run/root:root --rm \
           -p 8888:8888 \
           --device-cgroup-rule='c 189:* rmw' \
           --device /dev/dri:/dev/dri \
           --mount type=bind,source=/var/tmp,destination=/var/tmp \
           -v /dev/bus/usb:/dev/bus/usb \
           openvino/openvino_tensorflow_ubuntu20_runtime:2.2.0 /bin/bash
```

### 在Windows*操作系统上运行镜像

该镜像也可在Windows*操作系统上运行，支持OpenVINO™后端的CPU和iGPU。

#### 启动Jupyter服务器（CPU访问）

```bash
docker run -it --rm \
           -p 8888:8888 \
           docker.xuanyuan.run/openvino/openvino_tensorflow_ubuntu20_runtime:2.2.0
```

#### 启动Jupyter服务器（iGPU访问）

**前提条件**：

- Windows* 10 21H2或Windows* 11，已安装[WSL-2](https://learn.microsoft.com/en-us/windows/wsl/install)
- [Intel iGPU驱动](https://www.intel.com/content/www/us/en/download/19344/intel-graphics-windows-dch-drivers.html)版本≥30.0.100.9684

```bash
docker run -it --rm \
           -p 8888:8888 \
           --device /dev/dxg:/dev/dxg \
           --volume /usr/lib/wsl:/usr/lib/wsl \
           docker.xuanyuan.run/openvino/openvino_tensorflow_ubuntu20_runtime:2.2.0
```

## OpenVINO™与TensorFlow集成运行时Docker镜像（适用于TF-Serving，Ubuntu* 20.04 LTS）

标签为**2.2.0-serving**的此镜像提供与TensorFlow模型的开箱即用集成，便于部署新算法和实验。该镜像中的tensorflow_model_server可执行文件基于OpenVINO™构建，在Intel后端（包括CPU、GPU、VPU和VAD-M）上提供性能优势。

以下示例展示使用此镜像部署Resnet50模型，并通过客户端脚本利用REST API进行推理。

### 步骤1：下载模型

从TF Hub下载[Resnet50模型](https://storage.googleapis.com/tfhub-modules/google/imagenet/resnet_v2_50/classification/5.tar.gz)，并将其内容解压到文件夹`resnet_v2_50_classifiation/5`。

### 步骤2：启动Resnet50模型服务容器

#### 在CPU后端运行

```bash
docker run -it --rm \
           -p 8501:8501 \
           -v <resnet_v2_50_classifiation路径>:/models/resnet \
           -e MODEL_NAME=resnet \
           docker.xuanyuan.run/openvino/openvino_tensorflow_ubuntu20_runtime:2.2.0-serving
```

#### 在iGPU上运行

```bash
docker run -it --rm \
           -p 8501:8501 \
           --device-cgroup-rule='c 189:* rmw' \
           --device /dev/dri:/dev/dri \
           -v <resnet_v2_50_classifiation路径>:/models/resnet \
           -e MODEL_NAME=resnet \
           -e OPENVINO_TF_BACKEND=GPU \
           docker.xuanyuan.run/openvino/openvino_tensorflow_ubuntu20_runtime:2.2.0-serving
```

#### 在MYRIAD上运行

```bash
docker run -it --rm \
           -p 8501:8501 \
           --device-cgroup-rule='c 189:* rmw' \
           -v /dev/bus/usb:/dev/bus/usb \
           -v <resnet_v2_50_classifiation路径>:/models/resnet \
           -e MODEL_NAME=resnet \
           -e OPENVINO_TF_BACKEND=MYRIAD \
           docker.xuanyuan.run/openvino/openvino_tensorflow_ubuntu20_runtime:2.2.0-serving
```

#### 在VAD-M上运行

```bash
docker run -itu docker.xuanyuan.run/root:root --rm \
           -p 8501:8501 \
           --device-cgroup-rule='c 189:* rmw' \
           -v /dev/bus/usb:/dev/bus/usb \
           --mount type=bind,source=/var/tmp,destination=/var/tmp \
           --device /dev/ion:/dev/ion \
           -v <resnet_v2_50_classifiation路径>:/models/resnet \
           -e MODEL_NAME=resnet \
           -e OPENVINO_TF_BACKEND=VAD-M \
           openvino/openvino_tensorflow_ubuntu20_runtime:2.2.0-serving
```

### 步骤3：运行客户端推理脚本

```bash
wget https://raw.githubusercontent.com/tensorflow/serving/master/tensorflow_serving/example/resnet_client.py
python resnet_client.py
```

**OpenVINO™与TensorFlow集成**执行期间适用的所有相关环境变量，在通过容器运行时同样适用。例如，要在启动TensorFlow Serving容器时禁用**OpenVINO™与TensorFlow集成**，只需在`docker run`命令中添加环境变量OPENVINO_TF_DISABLE=1。更多此类环境变量详见[USAGE.md](https://github.com/openvinotoolkit/openvino_tensorflow/blob/master/docs/USAGE.md)。

```bash
docker run -it --rm \
           -p 8501:8501 \
           -v <resnet_v2_50_classifiation路径>:/models/resnet \
           -e MODEL_NAME=resnet \
           -e OPENVINO_TF_DISABLE=1 \
           docker.xuanyuan.run/openvino/openvino_tensorflow_ubuntu20_runtime:2.2.0-serving
```

## 许可证

版权所有 © 2022 Intel Corporation

**OpenVINO™与TensorFlow集成**的这些镜像基于[Apache License Version 2.0](https://github.com/openvinotoolkit/openvino_tensorflow/blob/master/LICENSE)许可。

组件：
* [Intel® Distribution of OpenVINO™ toolkit](https://hub.docker.com/r/openvino/ubuntu18_runtime)
* [TensorFlow](https://www.tensorflow.org/)

---
\* 其他名称和品牌可能是他人的财产。
