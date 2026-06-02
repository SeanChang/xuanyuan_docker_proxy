<!-- xuanyuan-docker-images-zh
image: nvidia/cuda
source: https://xuanyuan.cloud/zh/r/nvidia/cuda
canonical: https://xuanyuan.cloud/zh/r/nvidia/cuda
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/nvidia/cuda" title="nvidia/cuda Docker 镜像中文简介、标签列表与拉取命令">nvidia/cuda — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/nvidia/cuda" title="nvidia/cuda Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/nvidia/cuda</a></p>

## NVIDIA CUDA  
[CUDA](https://developer.nvidia.com/cuda-zone) 是 NVIDIA 开发的并行计算平台与编程模型，用于图形处理器（GPU）的通用计算。借助 CUDA，开发者可利用 GPU 算力显著加速计算应用。  

NVIDIA 提供的 CUDA 工具包包含开发 GPU 加速应用所需的全部组件，包括 GPU 加速库、编译器、开发工具及 CUDA 运行时。CUDA 容器镜像则为支持的平台和架构提供了便捷的分发方式。  


## 最终用户许可协议  
CUDA 容器镜像受 NVIDIA 最终用户许可协议约束。拉取并使用这些镜像即表示您接受许可条款。由于镜像可能包含 GPL 等开源许可下的组件，其源代码可通过 [此处](https://developer.download.nvidia.com/compute/cuda/opensource/image) 获取。  

#### NVIDIA 深度学习容器许可  
如需查看 NVIDIA 深度学习容器许可，可点击 [链接](https://developer.nvidia.com/ngc/nvidia-deep-learning-container-license)。  


## 文档  
有关 CUDA 的更多信息（包括发行说明、编程模型、API 及开发工具），请访问 [CUDA 文档网站](https://docs.nvidia.com/cuda)。  


## 公告  

### CUDA 容器支持政策  
CUDA 容器镜像标签具有生命周期。标签将在以下任一条件满足后删除：  
- 最后一个受支持的“Tesla 推荐驱动程序”终止支持后六个月；  
- 同一 CUDA 版本发布更新版本。  

详细说明见 [CUDA 容器支持政策](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/doc/support-policy.md)。重大变更将通过 [Gitlab Issue #209](https://gitlab.com/nvidia/container-images/cuda/-/issues/209) 公告。  


### CUDA 仓库签名密钥已变更！  
此变更可能导致以下错误：  

**debian 系统：**  
```  
Reading package lists... Done  
W: GPG error: http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64  InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY A4B469963BF863CC  
W: The repository 'http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64  InRelease' is not signed.  
N: Data from such a repository can't be authenticated and is therefore potentially dangerous to use.  
N: See apt-secure(8) manpage for repository creation and user configuration details.  
```  

**RPM 系统：**  
```  
warning: /var/cache/dnf/cuda-fedora32-x86_64-d60aafcddb176bf5/packages/libnvjpeg-11-1-11.3.0.105-1.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID d42d0685: NOKEY  
cuda-fedora32-x86_64                                                                                  23 kB/s | 1.6 kB     00:00  
Importing GPG key 0x7FA2AF80:  
 Userid     : "cudatools <[邮箱已删除]>"  
 Fingerprint: AE09 FE4B BD22 3A84 B2CC FCE3 F60F 4B3D 7FA2 AF80  
 From       : https://developer.download.nvidia.com/compute/cuda/repos/fedora32/x86_64/7fa2af80.pub  
Is this ok [y/N]: y  
Key imported successfully  
Import of key(s) didn't help, wrong key(s)?  
Public key for libnvjpeg-11-1-11.3.0.105-1.x86_64.rpm is not installed. Failing package is: libnvjpeg-11-1-11.3.0.105-1.x86_64  
 GPG Keys are configured as: https://developer.download.nvidia.com/compute/cuda/repos/fedora32/x86_64/7fa2af80.pub  
The downloaded packages were saved in cache until the next successful transaction.  
You can remove cached packages by executing 'dnf clean packages'.  
Error: GPG check FAILED  
```  

包含新密钥的更新镜像将在未来几天内推送，进度可通过以下链接跟踪：  
- https://forums.developer.nvidia.com/t/notice-cuda-linux-repository-key-rotation/212771h  
- https://gitlab.com/nvidia/container-images/cuda/-/issues/158  


### 多架构镜像清单已支持所有 CUDA 容器版本  
现在可通过 Docker Buildkit 一步构建所有支持架构的 CUDA 容器镜像（示例脚本略）。旧架构特定镜像名称 `nvidia/cuda-arm64` 和 `nvidia/cuda-ppc64le` 仍可用，但不再提供支持。以下资源也将停止支持：  
- Docker Hub 页面：https://hub.docker.com/r/nvidia/cuda-ppc64le  
- GitLab 仓库：https://hub.docker.com/r/nvidia/cuda-arm64  


### 弃用：“latest”标签  
NGC 和 Docker Hub 上的 CUDA、CUDAGL、OPENGL 镜像已弃用“latest”标签。移除后，以下命令将返回“manifest unknown”错误：  
```  
$ docker pull nvidia/cuda  
Error response from daemon: manifest for nvidia/cuda:latest not found: manifest unknown: manifest unknown  
```  
此为正常现象，非 bug。  


## 镜像概述  

### 镜像类型  
提供三种镜像版本：  
- **base**：包含 CUDA 运行时（cudart）。  
- **runtime**：基于 `base`，包含 [CUDA 数学库](https://developer.nvidia.com/gpu-accelerated-libraries) 和 [NCCL](https://developer.nvidia.com/nccl)；部分版本还包含 [cuDNN](https://developer.nvidia.com/cudnn) 或 [TensorRT](https://developer.nvidia.com/tensorrt)。  
- **devel**：基于 `runtime`，包含头文件和开发工具，适用于构建 CUDA 应用，尤其适合多阶段构建。  

镜像的 Dockerfile 开源，采用 3 条款 BSD 许可（详见下方“支持的标签”）。  


### NVIDIA 容器工具包  
运行 CUDA 镜像需安装 [NVIDIA 容器工具包](https://github.com/NVIDIA/nvidia-container-toolkit)。对于 CUDA 10.0，建议使用 `nvidia-docker2`（v2.1.0 及以上）和 Docker 19.03 及以上版本。  


### 问题报告方式  
1. 先查阅 [NVIDIA 容器工具包常见问题](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions)，确认问题是否已有解决方案。  
2. 若确认非运行时问题，可在 [CUDA 容器镜像 Issue 追踪器](https://gitlab.com/nvidia/container-images/cuda/-/issues) 提交报告。  


## 支持的标签  
支持的标签已更新至最新 CUDA、cuDNN 和 TensorRT 版本，并定期更新以修复 CVE 漏洞。完整列表见 [支持的标签文档](https://gitlab.com/nvidia/container-images/cuda/blob/master/doc/supported-tags.md)。以下为 CUDA 13.0.1 的主要标签：  


### ubuntu24.04 [arm64, x86_64]  
- `13.0.1-cudnn-runtime-ubuntu24.04`（[Dockerfile](https://developer.download.nvidia.com/compute/cuda/opensource/image/)）  
- `13.0.1-runtime-ubuntu24.04`（[Dockerfile](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubuntu2404/runtime/cudnn/Dockerfile)）  
- `13.0.1-cudnn-devel-ubuntu24.04`（[Dockerfile](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubuntu2404/runtime/Dockerfile)）  
- `13.0.1-devel-ubuntu24.04`（[Dockerfile](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubuntu2404/devel/cudnn/Dockerfile)）  
- `13.0.1-base-ubuntu24.04`（[Dockerfile](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubuntu2404/devel/Dockerfile)）  


### ubuntu22.04 [arm64, x86_64]  
- `13.0.1-cudnn-runtime-ubuntu22.04`（[Dockerfile](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubuntu2404/base/Dockerfile)）  
- `13.0.1-runtime-ubuntu22.04`（[Dockerfile](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubuntu2204/runtime/cudnn/Dockerfile)）  
- `13.0.1-cudnn-devel-ubuntu22.04`（[Dockerfile](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubuntu2204/runtime/Dockerfile)）  
- `13.0.1-devel-ubuntu22.04`（[Dockerfile](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubuntu2204/devel/cudnn/Dockerfile)）  
- `13.0.1-base-ubuntu22.04`（[Dockerfile](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubuntu2204/devel/Dockerfile)）  


### ubi9 [arm64, x86_64]  
- `13.0.1-cudnn-runtime-ubi9`（[Dockerfile](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubuntu2204/base/Dockerfile)）  
- `13.0.1-runtime-ubi9`（[Dockerfile](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubi9/runtime/cudnn/Dockerfile)）  
- `13.0.1-cudnn-devel-ubi9`（[Dockerfile](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubi9/runtime/Dockerfile)）  
- `13.0.1-devel-ubi9`（[Dockerfile](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubi9/devel/cudnn/Dockerfile)）  
- `13.0.1-base-ubi9`（[Dockerfile](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubi9/devel/Dockerfile)）  


### 其他操作系统  
更多系统（ubi8/10、rockylinux8/9/10、oraclelinux8/9、opensuse15、cm2、azl3、amzn2023）的标签及 Dockerfile 链接，可参考 [支持的标签文档](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubi9/base/Dockerfile)。  


## 不支持的标签  
已停止支持的标签列表见 [此处](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubi8/runtime/cudnn/Dockerfile)。  


## 描述来源  
本文档基于 CUDA 容器镜像源码仓库的 `doc/README.md`（[历史记录](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/13.2.0/ubi8/runtime/Dockerfile)）。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/nvidia/cuda" title="nvidia/cuda Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/nvidia/cuda</a></p>
