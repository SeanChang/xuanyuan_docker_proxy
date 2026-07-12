---
image: mathworks/matlab-deep-learning
description: "包含深度学习工具箱、预训练模型及其他工具箱的MATLAB Docker容器，用于支持深度学习等任务。"
source: https://xuanyuan.cloud/zh/r/mathworks/matlab-deep-learning
canonical: https://xuanyuan.cloud/zh/r/mathworks/matlab-deep-learning
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mathworks/matlab-deep-learning" title="mathworks/matlab-deep-learning Docker 镜像中文简介、标签列表与拉取命令">mathworks/matlab-deep-learning 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MATLAB 深度学习 Docker 容器

通过在 MATLAB® 深度学习容器中训练神经网络，加速您的深度学习应用。该容器旨在充分利用高性能 NVIDIA® GPU。它提供了一个简单灵活的解决方案，可在 AWS® 或 Microsoft® Azure® 等云环境中使用 MATLAB 进行深度学习工作流。

## 支持的标签

| 标签 | MATLAB 版本 | 操作系统 | 基础镜像 |
| ---- |:--------------:| ---------------- | ---------- |
| `latest`, `R2025b`, `r2025b` | R2025b | Ubuntu® 24.04 | ubuntu:24.04 |
| `R2025a`, `r2025a` | R2025a | Ubuntu 24.04 | ubuntu:24.04 |
| `R2024b`, `r2024b` | R2024b | Ubuntu 24.04 | ubuntu:24.04 |
| `R2024a`, `r2024a` | R2024a | Ubuntu 24.04 | ubuntu:24.04 |
| `R2023b`, `r2023b` | R2023b | Ubuntu 24.04 | ubuntu:24.04 |
| `R2023a`, `r2023a` | R2023a | Ubuntu 24.04 | ubuntu:24.04 |
| `R2022b`, `r2022b` | R2022b | Ubuntu 20.04 | ubuntu:20.04 |
| `R2022a`, `r2022a` | R2022a | Ubuntu 20.04 | ubuntu:20.04 |
| `R2021b`, `r2021b` | R2021b | Ubuntu 20.04 | ubuntu:20.04 |

## 快速启动说明

本节描述拉取 R2025b MATLAB 深度学习镜像并从镜像启动交互式 MATLAB 会话的示例工作流。

要将 R2025b MATLAB 镜像拉取到您的机器，请执行：
```console
docker pull docker.xuanyuan.run/mathworks/matlab-deep-learning:r2025b
```

要使用 `-browser` 选项启动容器，请执行：
```console
docker run -it --rm -p 8888:8888 --shm-size=512M docker.xuanyuan.run/mathworks/matlab-deep-learning:r2025b -browser
```

执行此命令将显示一个可访问 MATLAB 的 URL，例如：
```console
http://localhost:8888/index.html
```

有关运行容器的更多信息，请参见 [如何使用此镜像](#如何使用此镜像) 部分。

## 什么是 MATLAB？

[MATLAB](https://www.mathworks.com/products/matlab.html) 是专为工程师和科学家设计的编程平台。它将为迭代分析和设计过程优化的桌面环境与直接表达矩阵和数组数学的编程语言相结合。有关更多信息，请[点击此链接访问我们的网站](https://www.mathworks.com/discovery/what-is-matlab.html)。

MATLAB 深度学习容器提供算法、预训练模型和应用程序，用于创建、训练、可视化和优化深度神经网络。您还可以访问用于图像和信号处理、文本分析以及自动生成 C 和 CUDA® 代码的工具，以便在数据中心和嵌入式系统中的 NVIDIA® GPU 上部署。具体而言，此容器提供基于 Ubuntu 的镜像，其中安装了 MATLAB 和以下工具箱：

* Computer Vision Toolbox™（计算机视觉工具箱）
* Deep Learning Toolbox™（深度学习工具箱）
* GPU Coder™（GPU 编码器）
* Image Processing Toolbox™（图像处理工具箱）
* MATLAB Coder™（MATLAB 编码器）
* Parallel Computing Toolbox™（并行计算工具箱）
* Signal Processing Toolbox™（信号处理工具箱）
* Statistics and Machine Learning Toolbox™（统计和机器学习工具箱）
* Text Analytics Toolbox™（文本分析工具箱）

以及以下支持包：

* Deep Learning Toolbox Converter for TensorFlow Models（深度学习工具箱 TensorFlow 模型转换器）
* Deep Learning Toolbox Converter for ONXX Models Format（深度学习工具箱 ONXX 模型格式转换器）
* Deep Learning Toolbox Importer for Caffe Models（深度学习工具箱 Caffe 模型导入器）
* Deep Learning Toolbox Model for AlexNet Network（AlexNet 网络深度学习工具箱模型）
* Deep Learning Toolbox Model for GoogLeNet Network（GoogLeNet 网络深度学习工具箱模型）
* Deep Learning Toolbox Model for Inception-v3 Network（Inception-v3 网络深度学习工具箱模型）
* Deep Learning Toolbox Model for Inception-ResNet-v2 Network（Inception-ResNet-v2 网络深度学习工具箱模型）
* Deep Learning Toolbox Model for ResNet-18 Network（ResNet-18 网络深度学习工具箱模型）
* Deep Learning Toolbox Model for ResNet-50 Network（ResNet-50 网络深度学习工具箱模型）
* Deep Learning Toolbox Model for ResNet-101 Network（ResNet-101 网络深度学习工具箱模型）
* GPU Coder Interface for Deep Learning Libraries（深度学习库的 GPU 编码器接口）
* MATLAB Coder Interface for Deep Learning Libraries（深度学习库的 MATLAB 编码器接口）
* （自 R2023a 起）Deep Learning Toolbox Verification Library（深度学习工具箱验证库）

## 许可证配置

要使用 MATLAB 深度学习容器，您需要容器中 MathWorks® 产品的许可证。

要训练深度学习模型，您需要 MATLAB、深度学习和并行计算工具箱的许可证。如果您获得了容器中其他产品的许可，则其功能将被扩展。

在 Amazon EC2® 等公共云实例上，您可以使用启用云使用的许可证。对于本地 DGX 使用，您可以在运行容器时指定网络许可证管理器的位置来使用并发许可证。个人和校园范围的许可证已配置为云使用。对于其他许可证类型，请联系您的许可证管理员。您可以通过查看 [MathWorks 账户](https://www.mathworks.com/login) 来确定您的许可证类型和管理员。管理员可以参考 [管理网络许可证](https://www.mathworks.com/help/install/administer-network-licenses.html)。

## 如何使用此镜像

本节描述根据您的用例运行容器的不同选项。一些选项允许您通过命令行界面与 MATLAB 交互，而其他选项允许您与 MATLAB 桌面交互。

### 在主机上使用 GPU 运行 MATLAB

在启动容器之前，请检查您的图形驱动程序是否是最新的。有关详细信息，请参见 [MATLAB GPU 计算要求](https://www.mathworks.com/help/parallel-computing/gpu-computing-requirements.html)。

要启动容器并在主机上使用 GPU 运行 MATLAB，请执行：

```console
$ docker run --gpus all -it --rm --shm-size=512M mathworks/matlab-deep-learning:r2025b
```

默认情况下，容器无法访问其主机的硬件资源。要使容器能够访问主机系统的 GPU，请在执行 `docker run` 命令时使用 `--gpus` 标志。如果您希望容器能够访问主机的所有 GPU，请将此标志设置为 `all`。

有关更多信息，请参见 [访问 NVIDIA GPU](https://docs.docker.com/engine/reference/commandline/container_run/#gpus)。

### 在交互式命令提示符中运行 MATLAB

要启动容器并在交互式命令提示符中运行 MATLAB，请执行：

```console
$ docker run -it --rm mathworks/matlab-deep-learning:r2025b
```

### 以批处理模式非交互式运行 MATLAB

要启动容器并运行 MATLAB 命令 `RAND`，请执行：
```console
$ docker run --rm -e MLM_LICENSE_FILE=27000@MyLicenseServer mathworks/matlab-deep-learning:r2025b -batch rand
```
其中，您必须将 `27000@MyLicenseServer` 替换为网络许可证管理器的正确端口号和 DNS 地址。

或者，如果系统管理员为您提供了许可证文件，您可以将许可证文件挂载到容器，并将 `MLM_LICENSE_FILE` 指向容器中的许可证文件路径。例如，要启动容器并使用许可证文件运行 MATLAB 命令 `RAND`，请执行：
```console
$ docker run --rm -v /path/to/local/license/file:/licenses/license.lic -e MLM_LICENSE_FILE=/licenses/license.lic mathworks/matlab-deep-learning:r2025b -batch rand
```

如果提供了有效的许可证文件，容器将在 MATLAB 中运行命令 `RAND` 并退出。有关使用网络许可证管理器的更多信息，请参见 [使用网络许可证管理器](https://github.com/mathworks-ref-arch/matlab-dockerfile#use-the-network-license-manager)。

### 运行 MATLAB 并通过 Web 浏览器与之交互

要启动容器，请执行：
```console
$ docker run -it --rm -p 8888:8888 --shm-size=512M mathworks/matlab:r2025b -browser
```

运行上述命令会在终端中打印访问 MATLAB 的 URL。例如：

```console
MATLAB 可通过以下地址访问：
http://localhost:8888/index.html
```

在 Web 浏览器中输入提供的 URL。如果出现提示，请输入与 MATLAB 许可证关联的 MathWorks 账户凭据。
如果您使用网络许可证管理器，请切换到"网络许可证管理器"选项卡并输入许可证服务器地址。提供许可证信息后，MATLAB 会话将在浏览器中启动（这可能需要几分钟时间）。

要修改使用 `-browser` 标志启动时 MATLAB 的行为，请将环境变量传递给 `docker run` 命令。有关更多信息，请参见 [高级用法.md](https://github.com/mathworks/matlab-proxy/blob/main/Advanced-Usage.md)。

某些浏览器可能不支持此工作流。有关更多信息，请参见 [云解决方案浏览器要求](https://www.mathworks.com/support/requirements/browser-requirements.html)。

**注意：** Docker® 镜像从 MATLAB `R2022a` 开始支持 `-browser` 标志。
要在包含 MATLAB 的自定义 Docker 镜像或较旧的 MATLAB Docker 镜像（例如 `R2021b`）中通过 Web 浏览器访问 MATLAB，请参见 [示例](https://github.com/mathworks/matlab-proxy/blob/main/examples/Dockerfile)。

### 以桌面模式运行 MATLAB 并通过 VNC 与之交互

要启动 MATLAB 桌面，请执行：

```console
$ docker run -it --rm -p 5901:5901 -p 6080:6080 --shm-size=512M mathworks/matlab-deep-learning:r2025b -vnc
```

要连接到 MATLAB 桌面，请执行以下任一操作：

1. 将浏览器指向运行此容器的 Docker 主机的端口 6080（`http://hostname:6080`）
2. 使用 VNC 客户端连接到 Docker 主机的显示 1（`hostname:1`）

VNC 密码默认为 `matlab`。使用 `PASSWORD` 环境变量更改它。如果您使用云服务提供商，或者主机或客户端计算机受到防火墙保护，则必须在客户端计算机和 Docker 主机之间设置 SSH 隧道才能访问容器桌面。有关说明，请参见 [创建到远程应用程序和容器的加密连接](https://www.mathworks.com/help/cloudcenter/ug/create-encrypted-connection-to-remote-applications-and-containers.html)。

### 使用 X11 运行 MATLAB 桌面

要启动容器并使用 X11 运行 MATLAB 桌面，请执行：

```console
$ xhost +
$ docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro --shm-size=512M mathworks/matlab-deep-learning:r2025b
```

MATLAB 桌面窗口将在您的机器上打开。请注意，上面的命令仅在安装了 ```X11``` 及其依赖项的 Linux 操作系统上有效。

### 使用启动选项运行 MATLAB

要覆盖容器的默认行为并使用任何参数集运行 MATLAB，例如 `-logfile`，请执行：

```console
$ docker run -it --rm mathworks/matlab-deep-learning:r2025b -logfile "logfilename.log"
```

## 环境变量

执行 `docker run` 命令时，您可以使用 `-e` 选项指定环境变量。本节描述可以指定的所有环境变量。

#### ```MLM_LICENSE_FILE ```
当您希望使用许可证文件或网络许可证管理器为 MATLAB 授权时，使用此环境变量。

<i>示例：</i>

`docker run -it --rm -e MLM_LICENSE_FILE=27000@MyLicenseServer mathworks/matlab-deep-learning:r2025b`
<br />

`docker run -it --rm -e MLM_LICENSE_FILE=/license.dat mathworks/matlab-deep-learning:r2025b`

#### ```PROXY_SETTINGS```
当您希望使用代理服务器连接到 MathWorks 许可服务器时，使用此环境变量。

<i>示例：</i>

`docker run -it --rm -e PROXY_SETTINGS=<proxy-server-address> mathworks/matlab-deep-learning:r2025b`

您可以使用以下任何形式指定代理服务器地址：

* `hostname:12345`
* `shorthostname:12345`
* `http://hostname:12345`
* `http://username:password@hostname:12345`
* `IPaddress:12345`

其中 `hostname` 是完全限定域名，`shorthostname` 是相对域名，12345 是端口号。

#### ```PASSWORD```
当您希望更改用于访问 VNC 服务器的密码时，使用此环境变量。

<i>示例：</i>

`docker run -it --rm -e PASSWORD=ILoveMATLAB -p 5901:5901 -p 6080:6080 --shm-size=512M mathworks/matlab-deep-learning:r2025b -vnc`

### 在容器中安装更新、工具箱、附加组件并保存更改

您可以在此容器中安装最新的 MATLAB 更新或安装其他工具箱和附加组件。有关更多信息，请参见 [在容器中安装更新、工具箱、支持包和附加组件](https://www.mathworks.com/help/cloudcenter/ug/install-updates-toolboxes-support-packages-and-add-ons-in-containers.html)。

## 安全报告

按照这些说明 [报告疑似安全问题](https://github.com/mathworks-ref-arch/container-images/blob/master/SECURITY.md)。

## 附加信息

此容器包含 The MathWorks, Inc. 的商业软件产品（"MathWorks 程序"）和相关材料。MathWorks 程序根据 MathWorks 软件许可协议授权，该协议在此容器的 MATLAB 安装中提供。此容器中的相关材料根据单独的许可证授权，这些许可证可在其各自的文件夹中找到。

要了解有关 MATLAB 容器的更多信息，请参见 [Docker Hub 上的 MATLAB 容器](https://www.mathworks.com/help/cloudcenter/ug/matlab-container-on-docker-hub.html)。

要查看用于构建此 Docker 镜像的源文件，请参见 [GitHub 上的 MATLAB 容器镜像](https://github.com/mathworks-ref-arch/container-images/tree/main/matlab)。

要提供有关其他功能或能力的建议，请 [联系我们](https://www.mathworks.com/solutions/cloud.html)。

## 技术支持

如果您需要帮助或请求其他功能或能力，请联系 [MathWorks 技术支持](https://www.mathworks.com/support/contact_us.html)。

Copyright 2021-2025 The MathWorks, Inc.
