---
image: lyspal/comfyui
description: "ComfyUI扩散模型GUI的容器化版本，包含ComfyUI-Manager，便于在家庭实验室部署及与Open WebUI集成，适用于个人使用和教育目的。"
source: https://xuanyuan.cloud/zh/r/lyspal/comfyui
canonical: https://xuanyuan.cloud/zh/r/lyspal/comfyui
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/lyspal/comfyui" title="lyspal/comfyui Docker 镜像中文简介、标签列表与拉取命令">lyspal/comfyui 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ComfyUI-docker

## 镜像概述和主要用途
ComfyUI-docker是官方ComfyUI扩散模型GUI的容器化实现，集成了ComfyUI-Manager工具。最初设计目的是将ComfyUI容器化，以便在家庭实验室环境中部署，并实现与Open WebUI实例的集成。

## 核心功能和特性
- **容器化部署**：将ComfyUI及其依赖打包为Docker镜像，简化部署流程，降低环境配置复杂度
- **集成管理工具**：内置ComfyUI-Manager，提供便捷的功能管理和扩展能力

## 使用场景和适用范围
适用于需要在家庭实验室环境中部署ComfyUI的用户，或希望将ComfyUI与Open WebUI集成的场景。主要用于个人使用和教育目的。

## 使用方法和配置说明
1. 部署容器后，通过浏览器访问以下地址即可使用GUI界面：
   ```
   http://localhost:8188
   ```

## 已知问题
- 构建过程中可能需要忽略更多目录和文件以优化镜像体积。

## 免责声明
本项目与ComfyUI、ComfyUI Manager或其各自所有者无任何关联，也未获得其官方认可。  
本项目仅为个人使用和教育目的创建，发布旨在为他人提供参考，但不提供任何明示或暗示的担保。使用本项目的风险由用户自行承担。

## 致谢
- [confyanonymous/ComfyUI](https://github.com/comfyanonymous/ComfyUI)
- [ltdrdata/ComfyUI-Manager](https://github.com/ltdrdata/ComfyUI-Manager)

建议访问 [comfyui.org](https://comfyui.org/) 了解原作者的更多工作。
