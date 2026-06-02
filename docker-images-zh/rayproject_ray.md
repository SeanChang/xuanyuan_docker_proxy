---
image: rayproject/ray
description: "这是分布式计算API Ray的官方Docker镜像，旨在为用户提供便捷可靠的容器化部署方案，助力快速搭建和运行基于Ray的分布式计算环境，支持高效开发与部署分布式应用，满足大规模数据处理及并行计算需求，确保开发与生产环境的一致性和稳定性。"
source: https://xuanyuan.cloud/zh/r/rayproject/ray
canonical: https://xuanyuan.cloud/zh/r/rayproject/ray
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rayproject/ray" title="rayproject/ray Docker 镜像中文简介、标签列表与拉取命令">rayproject/ray 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Ray 容器镜像  

Ray 容器镜像包含运行 Ray 所需的全部组件，适用于本地开发和 [Ray Cluster Launcher]([]) 集群环境。  


## 标签说明  
镜像标签用于区分不同版本，可根据需求选择：  

- `:latest`：最新的 Ray 稳定版 release。  
- `:2.x.x`：特定版本构建（如 `:2.9.3`，对应具体发布版本）。  
- `:nightly`：每日构建版，包含最新开发中的功能（非稳定版）。  


## 后缀说明  
标签可搭配后缀，区分 CPU/GPU 环境，未指定后缀时默认使用 CPU 版本：  

- `-gpu`：基于 NVIDIA CUDA 镜像，需在主机安装 [Nvidia Docker Runtime]([]) 以支持 GPU 资源访问。  
- `-cpu`：基于 Ubuntu 镜像，适用于纯 CPU 环境。  
- **无后缀标签**：默认等同于 `-cpu` 版本（如 `:latest` 即 `:latest-cpu`）。  


## 其他镜像  
- `rayproject/ray-ml`：包含常用机器学习库（如 TensorFlow、PyTorch 等），简化 ML 任务的开发与部署流程。  


## 许可证  
采用 [Apache-2.0 许可协议]([])。
