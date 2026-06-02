---
image: zhangp365/comfyui
description: "最新的Comfyui Docker镜像每日更新，集成了Manager管理节点、ControlNet控制网络节点及IPAdapter图像提示适配节点，为AI绘图工作流提供便捷部署与高效运行环境，支持用户通过容器化方式快速搭建功能完备的Comfyui平台，满足多样化的图像生成控制需求，助力开发者与创作者轻松实现复杂绘图任务的流程管理与效果调控。"
source: https://xuanyuan.cloud/zh/r/zhangp365/comfyui
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[zhangp365/comfyui](https://xuanyuan.cloud/zh/r/zhangp365/comfyui)
> 含镜像标签、拉取命令、部署文档与相关推荐。

## ComfyUI Docker部署工具


### 项目简介  
这是一个帮你快速搭起ComfyUI的Docker工具。ComfyUI是节点式AI图像生成工具，手动配环境时总遇到依赖冲突、驱动不兼容的问题？用这个项目，直接通过Docker容器打包所有环境，点几下就能跑起来，省掉折腾系统配置的时间。


### 主要功能  
- **环境隔离**：ComfyUI的Python库、CUDA驱动这些都包在容器里，不影响你本地其他程序。  
- **简单上手**：不用记复杂命令，跟着步骤走，新手也能搞定部署。  
- **跨系统用**：Windows、Mac、Linux都行（前提是装了Docker）。  
- **方便更新**：想换ComfyUI版本？拉个新镜像就行，老环境不会乱。  


### 怎么用  
#### 1. 先装Docker  
你的电脑得先有Docker和Docker Compose。  
- Windows/Mac：直接装 [Docker Desktop]([])（装的时候记得勾上“使用WSL2”或“启用虚拟化”）。  
- Linux：按官网教程装Docker Engine和Docker Compose。  

#### 2. 拉代码  
打开终端（Windows用PowerShell，Mac/Linux用Terminal），输入：  
```bash
git clone  comfyUI_docker  # 进项目文件夹
```

#### 3. 启动服务  
看项目里的README，一般是执行：  
```bash
docker-compose up -d  # 后台启动容器
```  
等几分钟，Docker会自动下载镜像、配环境。

#### 4. 开始用ComfyUI  
打开浏览器，输 `[] 注意点  
- **电脑配置别太低**：ComfyUI跑AI模型费资源，建议至少8G内存，有N卡（支持CUDA）会快很多。  
- **端口别冲突**：如果8188端口被其他程序占了，去 `docker-compose.yml` 里改端口映射（比如把 `8188:8188` 改成 `8888:8188`）。  
- **图片别丢了**：生成的图默认存在容器里，最好按项目说明把本地文件夹“挂”到容器里（比如 `./output:/app/output`），这样删了容器图片也还在。  


### 更多细节  
具体怎么配GPU加速、加插件、更新镜像，都在GitHub仓库里写着，去看看：  
[]()
