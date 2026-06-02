---
image: universonic/stable-diffusion-webui
description: "这是一个适用于NVIDIA显卡的Stable Diffusion WebUI Docker镜像，集成了Stable Diffusion的网页用户界面，专为NVIDIA GPU优化以实现高效AI图像生成，包含必要依赖组件，可简化部署流程，方便开发者及用户快速搭建和使用Stable Diffusion进行文本到图像生成、图像编辑等任务，无需复杂配置即可利用GPU加速性能，是基于Docker容器技术的便捷工具。"
source: https://xuanyuan.cloud/zh/r/universonic/stable-diffusion-webui
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[universonic/stable-diffusion-webui](https://xuanyuan.cloud/zh/r/universonic/stable-diffusion-webui)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Stable Diffusion web UI Docker 使用指南


## 简介  
Stable Diffusion web UI 是一个基于 Gradio 库开发的 Stable Diffusion 浏览器界面工具，支持通过 Docker 快速部署和使用。


## 基本使用示例  
快速启动容器的基础命令如下，适用于简单测试或临时使用：  

```bash
docker run --gpus all --restart unless-stopped -p 8080:8080 \
  --name stable-diffusion-webui -d universonic/stable-diffusion-webui
```  

**参数说明**：  
- `--gpus all`：启用主机所有 GPU 资源；  
- `--restart unless-stopped`：容器意外停止后自动重启；  
- `-p 8080:8080`：将容器内 8080 端口映射到主机 8080 端口，访问 `[] 即可打开界面；  
- `-d`：后台运行容器。  


## 数据存储配置  
为避免容器内数据丢失（如扩展、模型、生成结果等），建议将数据目录挂载到宿主机。具体步骤如下：  


### 1. 创建宿主机数据目录  
在宿主机合适位置创建数据根目录，例如 `/my/own/datadir`（路径可自定义，需确保有读写权限）。  


### 2. 启动容器并挂载目录  
通过 `-v` 参数将宿主机目录挂载到容器内对应路径，命令如下：  

```bash
docker run --gpus all --restart unless-stopped -p 8080:8080 \
  -v /my/own/datadir/extensions:/app/stable-diffusion-webui/extensions \  # 扩展目录
  -v /my/own/datadir/models:/app/stable-diffusion-webui/models \          # 模型目录
  -v /my/own/datadir/outputs:/app/stable-diffusion-webui/outputs \        # 生成结果目录
  -v /my/own/datadir/localizations:/app/stable-diffusion-webui/localizations \  # 本地化文件目录
  --name stable-diffusion-webui -d universonic/stable-diffusion-webui
```  


### 3. 故障排查  
若容器启动失败或服务异常，可通过日志定位问题：  

```bash
docker logs -f stable-diffusion-webui  # 实时查看容器日志
```  


## docker-compose 部署  
对于需要长期运行或多服务管理的场景，推荐使用 `docker-compose` 配置，示例如下：  

```yaml
version: "3.2"

services:
  stable-diffusion-webui:
    image: universonic/stable-diffusion-webui:minimal  # 使用轻量版镜像
    command: --no-half --no-half-vae --precision full  # 非半精度模式（部分设备需此配置）
    runtime: nvidia  # 启用 NVIDIA 运行时
    restart: unless-stopped  # 除非手动停止，否则自动重启
    ports:
      - "8080:8080/tcp"  # 端口映射
    volumes:  # 挂载宿主机目录（根据需求增减）
      - /my/own/datadir/inputs:/app/stable-diffusion-webui/inputs
      - /my/own/datadir/textual_inversion_templates:/app/stable-diffusion-webui/textual_inversion_templates
      - /my/own/datadir/embeddings:/app/stable-diffusion-webui/embeddings
      - /my/own/datadir/extensions:/app/stable-diffusion-webui/extensions
      - /my/own/datadir/models:/app/stable-diffusion-webui/models
      - /my/own/datadir/localizations:/app/stable-diffusion-webui/localizations
      - /my/own/datadir/outputs:/app/stable-diffusion-webui/outputs
    cap_drop:  # 移除不必要权限，增强安全性
      - ALL
    cap_add:  # 仅保留必要权限
      - NET_BIND_SERVICE
    deploy:  # 部署约束（适用于 Swarm 集群，单机可忽略）
      mode: global
      placement:
        constraints:
          - "node.labels.iface != extern"
      restart_policy:
        condition: unless-stopped
      resources:  # GPU 资源预留
        reservations:
          devices:
            - driver: nvidia
              capabilities: [gpu]
```  

**使用方法**：将上述内容保存为 `docker-compose.yml`，在文件目录下执行 `docker-compose up -d` 启动服务。  


## 重要注意事项  
- **模型文件必须存在**：若宿主机模型目录（如 `/my/own/datadir/models/Stable-diffusion`）未放置 Stable Diffusion 模型文件（checkpoint、vae 等），容器会启动失败并不断重启。需手动将模型文件放入该目录，等待服务启动后即可正常使用。  
- **进一步问题参考**：更多配置细节可查阅 [官方文档]([])。
