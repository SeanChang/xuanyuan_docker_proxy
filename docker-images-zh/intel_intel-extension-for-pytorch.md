---
image: intel/intel-extension-for-pytorch
description: "Intel® Extension for PyTorch*扩展PyTorch，通过最新功能优化在Intel硬件上提供额外性能提升，CPU利用AMX、AVX-512及VNNI指令集，GPU支持简易加速。"
source: https://xuanyuan.cloud/zh/r/intel/intel-extension-for-pytorch
canonical: https://xuanyuan.cloud/zh/r/intel/intel-extension-for-pytorch
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/intel/intel-extension-for-pytorch" title="intel/intel-extension-for-pytorch Docker 镜像中文简介、标签列表与拉取命令">intel/intel-extension-for-pytorch 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Intel® Extension for PyTorch* Docker 镜像文档

## 镜像概述和主要用途

[Intel® Extension for PyTorch*] 扩展了 [PyTorch*]，通过针对 Intel 硬件的最新特性优化，提供额外的性能提升。本镜像基于 [Ubuntu* 22.04](https://hub.docker.com/_/ubuntu) 构建，集成了 Intel® Extension for PyTorch* 及相关软件，适用于在 Intel CPU 和 GPU 上加速深度学习工作负载。

镜像通过 [Python Dockerfile](https://github.com/intel/ai-containers/blob/main/python/Dockerfile) 生成，源码位于 [intel/ai-containers](https://github.com/intel/ai-containers) 仓库。

> **注意**：Docker Hub 上有两个仓库（`intel/intel-extension-for-pytorch` 和 `intel/intel-optimized-pytorch`）会定期更新最新镜像，但部分 legacy 镜像可能未同步至两个仓库。


## 核心功能和特性

### CPU 优化
- 支持 Intel 高级矩阵扩展（Intel® AMX）
- 支持 Intel 高级向量扩展 512（Intel® AVX-512）
- 支持向量神经网络指令（VNNI）

### GPU 支持
- 通过 PyTorch* `xpu` 设备实现 GPU 加速
- 支持 Intel Arc™ A 系列显卡、Intel 数据中心 GPU Flex 系列和 Max 系列

### 扩展功能
- 部分镜像集成 Jupyter Notebook 服务
- 提供多节点训练支持（集成 Intel® oneAPI Collective Communications Library）
- 包含神经压缩器（Neural Compressor）工具
- 支持 TorchServe* 模型部署


## 支持的硬件

### CPU
- 支持 AMX、AVX-512、VNNI 指令集的 Intel CPU

### GPU
- [Intel® Arc™ A 系列显卡](https://ark.intel.com/content/www/us/en/ark/products/series/227957/intel-arc-a-series-graphics.html)
- [Intel® 数据中心 GPU Flex 系列](https://ark.intel.com/content/www/us/en/ark/products/series/230021/intel-data-center-gpu-flex-series.html)
- [Intel® 数据中心 GPU Max 系列](https://ark.intel.com/content/www/us/en/ark/products/series/232874/intel-data-center-gpu-max-series.html)


## 镜像类型和标签

### 1. XPU 镜像（支持 CPU 和 GPU 优化）

#### 基础 XPU 镜像
| 标签                          | PyTorch 版本 | IPEX 版本          | 驱动版本 | Dockerfile       |
|-------------------------------|--------------|--------------------|----------|------------------|
| `2.8.10-xpu-pip-base`,`2.8.10-xpu` | [v2.8.0]     | [v2.8.10+xpu]      | [1099]   | [v0.4.0-Beta]    |
| `2.7.10-xpu-pip-base`,`2.7.10-xpu` | [v2.7.0]     | [v2.7.10+xpu]      | [1077]   | [v0.4.0-Beta]    |
| `2.6.10-xpu-pip-base`,`2.6.10-xpu` | [v2.6.0]     | [v2.6.10+xpu]      | [1077]   | [v0.4.0-Beta]    |
| `2.5.10-xpu-pip-base`,`2.5.10-xpu` | [v2.5.1]     | [v2.5.10+xpu]      | [1057]   | [v0.4.0-Beta]    |
| `2.3.110-xpu-pip-base`,`2.3.110-xpu` | [v2.3.1][torch-v2.3.1] | [v2.3.110+xpu] | [950]    | [v0.4.0-Beta]    |
| `2.1.40-xpu-pip-base`,`2.1.40-xpu`   | [v2.1.0]     | [v2.1.40+xpu]      | [914]    | [v0.4.0-Beta]    |
| `2.1.30-xpu`                  | [v2.1.0]     | [v2.1.30+xpu]      | [803]    | [v0.4.0-Beta]    |
| `2.1.20-xpu`                  | [v2.1.0]     | [v2.1.20+xpu]      | [803]    | [v0.3.4]         |
| `2.1.10-xpu`                  | [v2.1.0]     | [v2.1.10+xpu]      | [736]    | [v0.2.3]         |
| `xpu-flex-2.0.110-xpu`        | [v2.0.1]     | [v2.0.110+xpu]     | [647]    | [v0.1.0]         |

#### 带 Jupyter Notebook 的 XPU 镜像
| 标签                          | PyTorch 版本 | IPEX 版本          | 驱动版本 | Jupyter 端口 | Dockerfile       |
|-------------------------------|--------------|--------------------|----------|--------------|------------------|
| `2.8.10-xpu-pip-jupyter`      | [v2.8.0]     | [v2.8.10+xpu]      | [1099]   | `8888`       | [v0.4.0-Beta]    |
| `2.7.10-xpu-pip-jupyter`      | [v2.7.0]     | [v2.7.10+xpu]      | [1077]   | `8888`       | [v0.4.0-Beta]    |
| `2.6.10-xpu-pip-jupyter`      | [v2.6.0]     | [v2.6.10+xpu]      | [1077]   | `8888`       | [v0.4.0-Beta]    |
| `2.5.10-xpu-pip-jupyter`      | [v2.5.1]     | [v2.5.10+xpu]      | [1057]   | `8888`       | [v0.4.0-Beta]    |
| `2.3.110-xpu-pip-jupyter`     | [v2.3.1][torch-v2.3.1] | [v2.3.110+xpu] | [950]    | `8888`       | [v0.4.0-Beta]    |
| `2.1.40-xpu-pip-jupyter`      | [v2.1.0]     | [v2.1.40+xpu]      | [914]    | `8888`       | [v0.4.0-Beta]    |
| `2.1.20-xpu-pip-jupyter`      | [v2.1.0]     | [v2.1.20+xpu]      | [803]    | `8888`       | [v0.3.4]         |
| `2.1.10-xpu-pip-jupyter`      | [v2.1.0]     | [v2.1.10+xpu]      | [736]    | `8888`       | [v0.2.3]         |


### 2. CPU 专用镜像（不含 GPU 支持）

#### 基础 CPU 镜像
| 标签                          | PyTorch 版本 | IPEX 版本          | Dockerfile       |
|-------------------------------|--------------|--------------------|------------------|
| `2.8.0-pip-base`, `latest`    | [v2.8.0]     | [v2.8.0+cpu]       | [v0.4.0-Beta]    |
| `2.7.0-pip-base`              | [v2.7.0]     | [v2.7.0+cpu]       | [v0.4.0-Beta]    |
| `2.6.0-pip-base`              | [v2.6.0]     | [v2.6.0+cpu]       | [v0.4.0-Beta]    |
| `2.5.0-pip-base`              | [v2.5.0]     | [v2.5.0+cpu]       | [v0.4.0-Beta]    |
| `2.4.0-pip-base`              | [v2.4.0]     | [v2.4.0+cpu]       | [v0.4.0-Beta]    |
| `2.3.0-pip-base`              | [v2.3.0]     | [v2.3.0+cpu]       | [v0.4.0-Beta]    |
| `2.2.0-pip-base`              | [v2.2.0]     | [v2.2.0+cpu]       | [v0.3.4]         |
| `2.1.0-pip-base`              | [v2.1.0]     | [v2.1.0+cpu]       | [v0.2.3]         |
| `2.0.0-pip-base`              | [v2.0.0]     | [v0.2.3]           | [v0.1.0]         |

#### 带 Jupyter Notebook 的 CPU 镜像
| 标签                          | PyTorch 版本 | IPEX 版本          | Dockerfile       |
|-------------------------------|--------------|--------------------|------------------|
| `2.8.0-pip-jupyter`           | [v2.8.0]     | [v2.8.0+cpu]       | [v0.4.0-Beta]    |
| `2.7.0-pip-jupyter`           | [v2.7.0]     | [v2.7.0+cpu]       | [v0.4.0-Beta]    |
| `2.6.0-pip-jupyter`           | [v2.6.0]     | [v2.6.0+cpu]       | [v0.4.0-Beta]    |
| `2.5.0-pip-jupyter`           | [v2.5.0]     | [v2.5.0+cpu]       | [v0.4.0-Beta]    |
| `2.4.0-pip-jupyter`           | [v2.4.0]     | [v2.4.0+cpu]       | [v0.4.0-Beta]    |
| `2.3.0-pip-jupyter`           | [v2.3.0]     | [v2.3.0+cpu]       | [v0.4.0-Beta]    |
| `2.2.0-pip-jupyter`           | [v2.2.0]     | [v2.2.0+cpu]       | [v0.3.4]         |
| `2.1.0-pip-jupyter`           | [v2.1.0]     | [v2.1.0+cpu]       | [v0.2.3]         |
| `2.0.0-pip-jupyter`           | [v2.0.0]     | [v2.0.0+cpu]       | [v0.1.0]         |

#### 带 oneCCL 和神经压缩器的 CPU 多节点镜像
| 标签                          | PyTorch 版本 | IPEX 版本          | oneCCL 版本        | 神经压缩器版本 | Dockerfile       |
|-------------------------------|--------------|--------------------|--------------------|----------------|------------------|
| `2.4.0-pip-multinode`         | [v2.4.0]     | [v2.4.0+cpu]       | [v2.4.0][ccl-v2.4.0] | [v3.0]         | [v0.4.0-Beta]    |
| `2.3.0-pip-multinode`         | [v2.3.0]     | [v2.3.0+cpu]       | [v2.3.0][ccl-v2.3.0] | [v2.6]         | [v0.4.0-Beta]    |
| `2.2.0-pip-multinode`         | [v2.2.2]     | [v2.2.0+cpu]       | [v2.2.0][ccl-v2.2.0] | [v2.6]         | [v0.4.0-Beta]    |
| `2.1.100-pip-mulitnode`       | [v2.1.2]     | [v2.1.100+cpu]     | [v2.1.0][ccl-v2.1.0] | [v2.6]         | [v0.4.0-Beta]    |
| `2.0.100-pip-multinode`       | [v2.0.1]     | [v2.0.100+cpu]     | [v2.0.0][ccl-v2.0.0] | [v2.6]         | [v0.4.0-Beta]    |

> **注意**：镜像中启用了无密码 SSH 连接，但不含 SSH ID 密钥。用户需将密钥挂载至 `/root/.ssh/id_rsa` 和 `/etc/ssh/authorized_keys`。

> **提示**：挂载密钥前，需通过 `chmod 600 authorized_keys; chmod 600 id_rsa` 修改文件权限，确保默认用户可读取。

#### TorchServe CPU 镜像
| 标签                          | PyTorch 版本 | IPEX 版本          | Dockerfile       |
|-------------------------------|--------------|--------------------|------------------|
| `2.8.0-serving-cpu`           | [v2.8.0]     | [v2.8.0+cpu]       | [v0.4.0-Beta]    |
| `2.7.0-serving-cpu`           | [v2.7.0]     | [v2.7.0+cpu]       | [v0.4.0-Beta]    |
| `2.6.0-serving-cpu`           | [v2.6.0]     | [v2.6.0+cpu]       | [v0.4.0-Beta]    |
| `2.5.0-serving-cpu`           | [v2.5.0]     | [v2.5.0+cpu]       | [v0.4.0-Beta]    |
| `2.4.0-serving-cpu`           | [v2.4.0]     | [v2.4.0+cpu]       | [v0.4.0-Beta]    |
| `2.3.0-serving-cpu`           | [v2.3.0]     | [v2.3.0+cpu]       | [v0.4.0-Beta]    |
| `2.2.0-serving-cpu`           | [v2.2.0]     | [v2.2.0+cpu]       | [v0.3.4]         |


### 3. 集成 Intel® Distribution for Python* 的镜像

#### CPU 基础镜像
| 标签                          | PyTorch 版本 | IPEX 版本          | Dockerfile       |
|-------------------------------|--------------|--------------------|------------------|
| `2.8.0-idp-base`              | [v2.8.0]     | [v2.8.0+cpu]       | [v0.4.0-Beta]    |
| `2.7.0-idp-base`              | [v2.7.0]     | [v2.7.0+cpu]       | [v0.4.0-Beta]    |
| `2.6.0-idp-base`              | [v2.6.0]     | [v2.6.0+cpu]       | [v0.4.0-Beta]    |
| `2.5.0-idp-base`              | [v2.5.0]     | [v2.5.0+cpu]       | [v0.4.0-Beta]    |
| `2.4.0-idp-base`              | [v2.4.0]     | [v2.4.0+cpu]       | [v0.4.0-Beta]    |
| `2.3.0-idp-base`              | [v2.3.0]     | [v
