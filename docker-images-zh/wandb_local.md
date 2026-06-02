---
image: wandb/local
description: "在您自己的服务器上运行Weights & Biases（wandb.com），该平台专注于机器学习实验跟踪、模型版本控制、团队协作与结果可视化，能帮助数据科学家和工程师有效管理项目流程、复现实验结果、优化模型性能，进而加速机器学习项目的开发与迭代效率。"
source: https://xuanyuan.cloud/zh/r/wandb/local
canonical: https://xuanyuan.cloud/zh/r/wandb/local
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/wandb/local" title="wandb/local Docker 镜像中文简介、标签列表与拉取命令">wandb/local — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/wandb/local" title="wandb/local Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/wandb/local</a>

# wandb/local  

在您自己的网络中运行wandb！  


## 快速启动  

在已安装[Docker]([])和Python的机器上，运行以下命令启动服务器：  

1. `pip install wandb --upgrade`  
2. `wandb local`  

这会启动服务器并转发主机的8080端口。若要让其他机器向该服务器上报指标，请运行：`wandb login --host=[]  

```  
WANDB_BASE_URL=[]  
WANDB_API_KEY=XXXX  
```  


## 关于wandb  

Weights & Biases（W&B）是一个面向开发者的MLOps平台。更多信息请查看[官方文档]([])。  


## 生产环境说明  

默认情况下，此Docker容器不适用于生产环境。如需解锁生产环境功能（如外部MySQL、云存储、SSO等），可发送邮件至`[邮箱已删除]`获取许可。若服务暴露在公网中，务必在其前端部署可终止SSL的负载均衡器以确保安全。也可通过CloudFlare等服务搭建简单的SSL代理。
