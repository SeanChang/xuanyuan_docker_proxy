---
image: sombi/comfyui
description: "为RunPod平台设计的ComfyUI镜像，预安装自定义包，便于快速部署和运行AI工作流。"
source: https://xuanyuan.cloud/zh/r/sombi/comfyui
canonical: https://xuanyuan.cloud/zh/r/sombi/comfyui
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/sombi/comfyui" title="sombi/comfyui Docker 镜像中文简介、标签列表与拉取命令">sombi/comfyui — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/sombi/comfyui" title="sombi/comfyui Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/sombi/comfyui</a>

# ComfyUI-Docker-RP 镜像文档


## 一、镜像概述和主要用途  
ComfyUI-Docker-RP 是一个预安装自定义组件包的 Docker 镜像，专为 RunPod 环境设计，旨在简化 ComfyUI 的部署流程。ComfyUI 是一款灵活的节点式 AI 图像生成工具，支持 Stable Diffusion 等模型的自定义工作流设计。本镜像通过预集成常用插件、模型及配置，使开发者和创作者可直接在 RunPod 平台快速启动 ComfyUI，无需手动处理环境依赖和组件安装。


## 二、核心功能和特性  

### 2.1 预安装组件  
- 集成 ComfyUI 核心框架及官方推荐插件（如 ComfyUI-Manager、ComfyUI-Impact-Pack 等）  
- 预装常用 Stable Diffusion 模型（基础模型、LoRA、VAE 等，具体以镜像内置清单为准）  
- 包含节点扩展库（如 ControlNet、IP-Adapter、风格迁移相关节点）  

### 2.2 RunPod 环境适配  
- 优化容器启动流程，适配 RunPod 容器生命周期管理  
- 支持 RunPod 动态资源分配（CPU/内存/GPU），自动识别 GPU 型号并启用加速  
- 兼容 RunPod 持久化存储（可挂载外部模型/工作流文件）  

### 2.3 部署简化  
- 零手动配置启动：镜像内置默认工作流，启动后直接访问 Web 界面即可使用  
- 依赖自动管理：预解决 Python 依赖冲突，确保插件间兼容性  
- 日志标准化：输出结构化日志，便于调试和问题定位  


## 三、使用场景和适用范围  

### 3.1 目标用户  
- **AI 创作者**：无需配置环境，直接通过节点编辑器设计图像生成工作流  
- **开发者**：基于预配置环境快速扩展自定义节点或集成新模型  
- **研究人员**：在 RunPod 弹性算力环境中测试不同模型组合及参数  

### 3.2 典型场景  
- 快速部署 ComfyUI 进行 Stable Diffusion 图像生成、风格迁移、图生图等任务  
- 基于 RunPod 高 GPU 算力运行大模型（如 SDXL）的复杂工作流  
- 团队协作：通过持久化存储共享自定义模型和工作流配置  


## 四、使用方法和配置说明  

### 4.1 前置条件  
- 已注册 RunPod 账号并创建包含 GPU 的 Pod（推荐 NVIDIA GPU，显存 ≥ 8GB）  
- 本地或 RunPod 环境已安装 Docker（若手动部署）或直接使用 RunPod 容器服务  


### 4.2 快速部署示例  

#### 4.2.1 Docker Run 命令（本地或 RunPod 手动部署）  
```bash
docker run -d \
  --name comfyui-rp \
  --gpus all \
  -p 8188:8188 \  # ComfyUI 默认 Web 端口
  -v /path/to/local/models:/app/ComfyUI/models \  # 挂载本地模型目录（可选）
  -v /path/to/workflows:/app/ComfyUI/workflows \  # 挂载自定义工作流（可选）
  somb1/comfyui-docker-rp:latest
```

#### 4.2.2 RunPod 模板部署  
在 RunPod 控制台选择 "Custom Container"，输入镜像地址 `somb1/comfyui-docker-rp:latest`，配置如下：  
- **端口映射**：`8188:8188`  
- **存储卷**（可选）：挂载 RunPod 持久化存储至 `/app/ComfyUI/models` 或 `/app/ComfyUI/outputs`  
- **环境变量**：按需添加（见 4.3 节）  


### 4.3 配置参数与环境变量  

#### 4.3.1 核心参数  
| 参数/环境变量       | 说明                                  | 默认值                |
|---------------------|---------------------------------------|-----------------------|
| `--gpus`            | GPU 设备分配（Docker 参数）           | `all`（使用所有 GPU） |
| `-p 8188:8188`      | Web 端口映射                          | `8188`                |
| `MODEL_PATH`        | 自定义模型目录（环境变量）            | `/app/ComfyUI/models` |
| `OUTPUT_DIR`        | 生成图像输出目录（环境变量）          | `/app/ComfyUI/outputs`|
| `LOG_LEVEL`         | 日志级别（环境变量）                  | `INFO`                |

#### 4.3.2 持久化存储配置  
通过 `-v` 挂载卷实现数据持久化（推荐在 RunPod 中使用）：  
```bash
# 示例：挂载 RunPod 持久化存储至模型和输出目录
-v /runpod/storage/models:/app/ComfyUI/models \
-v /runpod/storage/outputs:/app/ComfyUI/outputs
```


### 4.4 访问与使用  
1. 容器启动后，通过 `http://<Pod-IP>:8188` 访问 ComfyUI Web 界面（RunPod 可通过 "Connect" 按钮获取访问链接）  
2. 预加载的工作流位于 `/app/ComfyUI/workflows` 目录，可直接在界面中加载使用  
3. 生成的图像默认保存至 `OUTPUT_DIR`（可通过卷挂载持久化）  


## 五、注意事项  
- **GPU 兼容性**：需确保 RunPod Pod 配置的 GPU 支持 CUDA 11.7+（镜像依赖 CUDA 运行时）  
- **模型大小**：预安装模型可能占用较大存储空间，建议通过持久化卷挂载外部模型以节省容器空间  
- **插件更新**：如需更新内置插件，可通过 ComfyUI-Manager 插件在 Web 界面中操作，或重建容器时指定新版本镜像  

如需获取完整插件清单、默认工作流示例及高级配置，可参考 [GitHub 项目页](https://github.com/somb1/ComfyUI-Docker-RP)。
