---
image: paddlecloud/paddleocr
description: "PaddleOCR的图像是百度开发的开源OCR工具库相关的视觉素材，该工具库支持多语言文本识别，具备高精度、轻量化模型特性，可实现文本检测与识别一体化，广泛适配文档处理、车牌识别、身份证识别等多种实际应用场景，为开发者提供高效便捷的光学字符识别解决方案，其图像内容通常涵盖工具界面、识别效果对比、模型架构示意图等，直观展示该OCR系统的功能优势与技术特点。"
source: https://xuanyuan.cloud/zh/r/paddlecloud/paddleocr
canonical: https://xuanyuan.cloud/zh/r/paddlecloud/paddleocr
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/paddlecloud/paddleocr" title="paddlecloud/paddleocr Docker 镜像中文简介、标签列表与拉取命令">paddlecloud/paddleocr — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/paddlecloud/paddleocr" title="paddlecloud/paddleocr Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/paddlecloud/paddleocr</a>

# PaddleOCR


## 镜像仓库用途  
本镜像仓库用于存储飞桨模型套件[PaddleOCR]([])的标准镜像，便于用户进行Docker化部署或云上部署。这些镜像由[PaddleCloud]([])项目基于[Tekton Pipeline]([])自动构建。若需二次开发并持续构建定制镜像，可参考[PaddleCloud Tekton文档]([])搭建自己的镜像CI流水线。关于部署的更多内容，可查看云上飞桨项目[PaddleCloud]([])。


## PaddleCloud优势  
PaddleCloud作为支持PaddleOCR部署的工具，主要优势如下：  

### 模型套件Docker镜像资源丰富  
提供飞桨模型套件Docker镜像资源，包含运行案例所需的全部依赖，支持持续更新，适配异构硬件环境和常见CUDA版本，开箱即可使用。  

### 云原生功能组件完善  
提供丰富的云原生功能组件，包括样本数据缓存、分布式训练、推理服务等，方便用户在Kubernetes集群上快速完成模型训练与部署。  

### 自运维能力强  
基于Kubernetes的Operator机制，组件自运维能力强。例如，训练组件支持多种架构模式，具备分布式容错与弹性训练能力；推理服务组件支持自动扩缩容与蓝绿发版。  

### 针对飞桨框架做了定制化优化  
除部署便捷和自运维优势外，还针对飞桨框架做了定制化优化。比如通过缓存样本数据加速分布式训练作业，基于飞桨框架与调度器的协同设计提升集群GPU利用率。  


## 安装Docker  
使用镜像前需确保环境已安装Docker，若未安装，可参考[Docker官方文档]([])。如需使用GPU版本镜像，还需安装NVIDIA驱动及nvidia-docker，具体步骤见[NVIDIA官方文档]([])。  


## 快速上手  
以下为CPU和GPU版本镜像的使用方法（若不熟悉Docker，建议先阅读[Docker基本用法]([])）。  


### 使用CPU版本Docker镜像  
#### 以jupyter notebook模式创建容器  
```bash
docker run --name ppocr -v $PWD:/mnt -p 8888:8888 --shm-size=32g paddlecloud/paddleocr:2.5-cpu-latest 
```  
- `--name ppocr`：指定容器名称为ppocr  
- `-v $PWD:/mnt`：将当前目录挂载到容器内的/mnt目录（方便文件共享）  
- `-p 8888:8888`：映射容器8888端口到本地8888端口（用于访问jupyter notebook）  
- `--shm-size=32g`：设置共享内存大小为32g（避免内存不足问题）  


#### 以bash模式创建容器  
```bash
docker run --name ppocr -v $PWD:/mnt -p 8888:8888 -it --shm-size=32g paddlecloud/paddleocr:2.5-cpu-latest /bin/bash
```  
- `-it`：以交互模式运行容器，直接进入bash终端  


### 使用GPU版本Docker镜像  
#### 以jupyter模式创建容器  
```bash
docker run --name ppocr --runtime=nvidia -v $PWD:/mnt -p 8888:8888 --shm-size=32g paddlecloud/paddleocr:2.5-gpu-cuda10.2-cudnn7-latest
```  
- `--runtime=nvidia`：启用NVIDIA运行时（使容器能调用GPU）  


#### 以bash模式创建容器  
```bash
docker run --name ppocr --runtime=nvidia -v $PWD:/mnt -p 8888:8888 -it --shm-size=32g paddlecloud/paddleocr:2.5-gpu-cuda10.2-cudnn7-latest /bin/bash
```  


进入容器后，即可执行PaddleOCR套件中的案例。  


## PaddleOCR Docker化部署案例  
- [PP-OCRv3 训推一体部署实战]([])  


## 镜像版本说明  
镜像tag格式为`套件代码分支(branch)-环境(cpu/gpu/rocm)-commit_id/latest`：  
- **分支**：对应PaddleOCR的代码分支（如2.5）  
- **环境**：区分cpu、gpu（含CUDA/CuDNN版本，如gpu-cuda10.2-cudnn7）或rocm  
- **commit_id/latest**：`latest`为最新发布镜像；特定版本需对应GitHub提交的commit id（取后6位）  

**建议**：无特殊需求时使用`latest`后缀的最新镜像；需固定版本时，通过commit id匹配对应镜像。  


若有建议或问题，可在[paddlecloud issue]([])反馈。
