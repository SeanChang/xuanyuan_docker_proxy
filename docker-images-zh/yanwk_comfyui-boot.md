---
image: yanwk/comfyui-boot
description: "这是一个用于启动加载ComfyUI的Docker镜像，其中ComfyUI是一款在AI绘画领域广泛应用的强大工具，具备灵活的工作流定制与丰富的插件扩展功能；该Docker镜像通过预先配置必要的运行环境、集成关键依赖组件，旨在简化ComfyUI的部署流程，帮助用户无需手动进行复杂的环境搭建，即可快速启动并高效使用ComfyUI开展绘画创作、模型测试等相关工作，为AI绘画爱好者和开发者提供便捷、稳定的启动加载解决方案。"
source: https://xuanyuan.cloud/zh/r/yanwk/comfyui-boot
canonical: https://xuanyuan.cloud/zh/r/yanwk/comfyui-boot
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/yanwk/comfyui-boot" title="yanwk/comfyui-boot Docker 镜像中文简介、标签列表与拉取命令">yanwk/comfyui-boot 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ComfyUI Docker镜像


## 相关链接  
- **[GitHub仓库]([])**  
- **[GitHub中文文档]([])**  
- **[国内适配镜像（Gitee）]([])**  


## 简介  
这里提供的是ComfyUI的Docker镜像。ComfyUI是一款基于节点工作流的Stable Diffusion图形界面，通过Docker镜像可快速部署使用。


## 快速启动（NVIDIA GPU）  
以下是NVIDIA GPU用户的快速启动步骤：  

1. 先创建本地存储目录：  
   ```sh
   mkdir -p storage
   ```  

2. 运行Docker命令启动容器：  
   ```sh
   docker run -it --rm \
     --name comfyui-cu126 \
     --gpus all \
     -p 8188:8188 \
     -v "$(pwd)"/storage:/root \
     -e CLI_ARGS="" \
     yanwk/comfyui-boot:cu126-slim
   ```  

3. 应用加载完成后，访问 `[] 即可使用。  


## 镜像标签说明  
不同镜像标签适用于不同场景，以下是主要标签的特点说明：  

### `cu121`  
- [文档]([])  
- 适合ComfyUI新手  
- 预装ComfyUI、ComfyUI-Manager及Photon（SD1.5）模型  
- 容器内使用低权限用户（便于WSL2部署）  
- 基于CUDA 12.1 + Python 3.11  


### `cu124-slim`  
- [文档]([])  
- 功能类似 `cu121`，但预装更多依赖  
- 仅包含ComfyUI和ComfyUI-Manager，无SD模型（下载内容更少）  
- 容器内使用root用户（便于无root部署）  
- 基于CUDA 12.4 + Python 3.12  


### `cu121-megapak` / `cu124-megapak`  
- [cu121文档]([]) / [cu124文档]([])  
- 全能型镜像，包含开发工具包  
- 容器内使用root用户（便于无root部署）  
- 分别基于CUDA 12.1 + Python 3.11、CUDA 12.4 + Python 3.12（`cu124`版本在新GPU上可能表现更佳）  


### `cu124-cn`  
- [文档]([])  
- 专为中国大陆用户优化，所有下载链接均使用国内镜像  


### `rocm`  
- [文档]([])  
- 适用于AMD GPU，基于ROCm  


### `nightly`  
- [文档]([])  
- 使用PyTorch预览版  


### `comfy3d-pt25`  
- [文档]([])  
- 专为 [ComfyUI-3D-Pack]([]) 设计的镜像  


## 详细文档  
更多使用细节可参考 [GitHub仓库文档]([])。
