---
image: openeuler/caffe
description: "基于openEuler构建的官方Caffe深度学习框架Docker镜像，支持CPU/GPU训练，适用于深度学习模型开发与训练，由openEuler CloudNative SIG维护。"
source: https://xuanyuan.cloud/zh/r/openeuler/caffe
canonical: https://xuanyuan.cloud/zh/r/openeuler/caffe
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/caffe" title="openeuler/caffe Docker 镜像中文简介、标签列表与拉取命令">openeuler/caffe 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 快速参考

- 官方Caffe Docker镜像。

- 维护者：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)。

- 获取帮助：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)、[openEuler](https://gitee.com/openeuler/community)。

# Caffe | openEuler
当前Caffe Docker镜像基于[openEuler](https://repo.openeuler.org/)构建。本仓库可免费使用，且无每用户速率限制。

Caffe是一个以表达性、速度和模块化为设计理念的深度学习框架。

更多信息请访问[Caffe官方网站](https://caffe.berkeleyvision.org/)。

# 支持的标签及对应Dockerfile链接
每个`caffe` Docker镜像的标签由完整的软件栈版本组成，详情如下：

| 标签                                                                                                                      | 当前版本                              | 架构         |
|--------------------------------------------------------------------------------------------------------------------------|-------------------------------------|------------|
| [1.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/caffe/1.0/24.03-lts-sp1/Dockerfile) | Caffe 1.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# 使用方法
在使用时，用户可根据需求选择对应的`{Tag}`和容器启动选项。

- 从Docker拉取`openeuler/caffe`镜像

  ```bash
  docker pull docker.xuanyuan.run/openeuler/caffe:{Tag}
  ```

- 以交互式shell运行

  也可启动带交互式shell的容器以使用caffe：
  ```bash
  docker run -it --rm docker.xuanyuan.run/openeuler/caffe:{Tag} bash
  ```

- 如何使用BVLC Caffe在MNIST上训练LeNet（CPU/GPU）

  - 手动下载MNIST数据集（镜像）
  
    在容器中，进入mnist目录：
    ```bash
    cd /opt/caffe/data/mnist
    ```
    
    从可靠的公共镜像下载文件：
    ```bash
    wget https://ossci-datasets.s3.amazonaws.com/mnist/train-images-idx3-ubyte.gz
    wget https://ossci-datasets.s3.amazonaws.com/mnist/train-labels-idx1-ubyte.gz
    wget https://ossci-datasets.s3.amazonaws.com/mnist/t10k-images-idx3-ubyte.gz
    wget https://ossci-datasets.s3.amazonaws.com/mnist/t10k-labels-idx1-ubyte.gz
    ```
  
    解压缩文件：
    ```bash
    gzip -d *.gz
    ```

  - 将数据集转换为LMDB格式
  
    切换到Caffe根目录并运行：
    ```bash
    cd /opt/caffe
    ./examples/mnist/create_mnist.sh
    ```
    该脚本将原始MNIST文件转换为Caffe训练用的LMDB格式。

  - 检查求解器配置
  
    打开求解器prototxt文件：
    ```bash
    vi ./examples/mnist/lenet_solver.prototxt
    ```
    确保最后一行与构建版本匹配：
    ```
    solver_mode: CPU   # 适用于仅CPU的Caffe构建
    ```
    或
    ```
    solver_mode: GPU   # 适用于带CUDA/cuDNN的Caffe构建
    ```

  - 训练模型
  
    最后，运行训练命令：
    ```bash
    ./build/tools/caffe train --solver=examples/mnist/lenet_solver.prototxt
    ```
    Caffe将开始在MNIST数据集上训练LeNet模型。

# 问答
如有任何问题或需要使用特定功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。
