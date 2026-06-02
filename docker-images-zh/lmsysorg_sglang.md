---
image: lmsysorg/sglang
description: "这是用于开源项目sglang（GitHub地址：[https://github.com/sgl-project/sglang]"
source: https://xuanyuan.cloud/zh/r/lmsysorg/sglang
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[lmsysorg/sglang](https://xuanyuan.cloud/zh/r/lmsysorg/sglang)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# sglang Docker镜像使用说明


## 概述  
sglang Docker镜像是为简化sglang项目（[https://github.com/sgl-project/sglang] 前提条件  
使用前需确保环境已满足以下条件：  
- 安装Docker Engine（推荐20.10+版本，[官方安装指南]([])）；  
- （可选）如需使用GPU，需安装nvidia-docker（[配置说明]([])）；  
- 本地已准备好sglang所需的模型文件（如需要加载自定义模型）。  


## 使用步骤  

### 1. 拉取镜像  
从Docker Hub拉取sglang官方镜像（若无特殊需求，建议使用`latest`标签获取最新版本）：  
```bash
docker pull sgl-project/sglang:latest
```  


### 2. 启动容器  
根据实际需求配置参数，启动sglang服务容器。以下为基础启动命令，可根据场景调整：  

#### 基础启动（默认配置）  
若无需自定义模型或端口，直接启动默认服务（默认监听容器内8000端口，使用内置示例模型）：  
```bash
docker run -d --name sglang-service -p 8000:8000 sgl-project/sglang:latest
```  

#### 加载本地模型  
如需使用本地模型文件，通过`-v`参数将本地模型目录挂载到容器内指定路径（假设本地模型路径为`/path/to/local/models`，容器内路径为`/app/models`）：  
```bash
docker run -d --name sglang-service \
  -p 8000:8000 \
  -v /path/to/local/models:/app/models \
  -e MODEL_PATH=/app/models \  # 告诉容器模型在容器内的路径
  -e MODEL_NAME=my_custom_model \  # 指定模型名称（需与模型文件匹配）
  sglang-project/sglang:latest
```  


## 配置说明  
容器支持通过参数或环境变量调整服务配置，常用选项如下：  

| 配置项         | 说明                                                                 | 示例                          |
|----------------|----------------------------------------------------------------------|-------------------------------|
| 端口映射       | 通过`-p host_port:container_port`修改宿主机与容器的端口映射          | `-p 8888:8000`（宿主机用8888端口） |
| 模型路径       | 通过`-v`挂载本地模型目录，并设置`MODEL_PATH`环境变量指定容器内路径   | `-v /local/models:/app/models -e MODEL_PATH=/app/models` |
| 模型名称       | 通过`MODEL_NAME`环境变量指定加载的模型名称（需与模型文件命名一致）   | `-e MODEL_NAME=llama-7b`       |
| 服务日志       | 去掉`-d`参数可前台运行，实时查看日志；或通过`docker logs sglang-service`查看后台日志 | `docker logs -f sglang-service`（实时日志） |  


## 注意事项  
- **Docker服务状态**：启动容器前确保Docker服务已运行（`systemctl status docker`或`service docker status`）；  
- **端口冲突**：若宿主机8000端口已被占用，需修改`-p`参数中的宿主端口（如`-p 8001:8000`）；  
- **模型文件权限**：挂载本地模型目录时，确保宿主机目录有读权限（可通过`chmod`调整，避免容器内权限不足）；  
- **GPU支持**：如需使用GPU，启动时需添加`--gpus all`参数（需安装nvidia-docker）：  
  ```bash
  docker run -d --name sglang-service --gpus all -p 8000:8000 sgl-project/sglang:latest
  ```  
- **停止/重启服务**：通过`docker stop sglang-service`停止，`docker start sglang-service`重启，`docker rm sglang-service`删除容器。  


通过以上步骤，即可快速通过Docker容器启动sglang服务，如需更多配置细节，可参考sglang项目官方文档或镜像仓库说明。
