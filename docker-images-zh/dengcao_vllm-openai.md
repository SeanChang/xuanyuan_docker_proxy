---
image: dengcao/vllm-openai
description: "vLLM是一个快速且易用的大语言模型推理与服务库，最初由加州大学伯克利分校开发，采用PagedAttention技术优化内存使用，支持高吞吐量、低延迟的推理，兼容Hugging Face模型格式，可轻松部署各类LLM，适用于科研和生产环境，显著提升大语言模型的服务效率。"
source: https://xuanyuan.cloud/zh/r/dengcao/vllm-openai
canonical: https://xuanyuan.cloud/zh/r/dengcao/vllm-openai
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [dengcao/vllm-openai — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/dengcao/vllm-openai)

含镜像标签、拉取命令、部署文档与相关推荐。

[dengcao/vllm-openai Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/dengcao/vllm-openai)

# Qwen3-Reranker模型部署与调用说明


## 一、镜像信息
基于vllm最新源码构建的Docker镜像：`dengcao/vllm-openai:latest`，已在NVIDIA RTX3060环境测试通过，运行稳定，可直接用于部署Qwen3系列模型。


## 二、支持模型
当前镜像支持以下模型（模型文件可从ModelScope获取）：  
- Qwen3-Reranker-0.6B：[ModelScope地址]([])  
- Qwen3-Reranker-4B：[ModelScope地址]([])  
- Qwen3-Reranker-8B：[ModelScope地址]([])  
- 其他Qwen3系列模型（如Qwen3-Embedding、通用Qwen3-Reranker）  


## 三、部署步骤
### 1. 准备部署配置
创建`docker-compose.yaml`文件，内容如下（以部署Qwen3-Reranker-0.6B为例，其他模型需调整对应参数）：  
```yaml
services:
  Qwen3-Reranker-0.6B:
    container_name: Qwen3-Reranker-0.6B
    restart: no
    image: dengcao/vllm-openai:v0.9.2-dev  # 基于vllm开发版构建，测试可用
    ipc: host
    volumes:
      - ./models:/models  # 宿主机模型目录挂载到容器内/models（需提前将模型文件放入宿主机./models目录）
    command: ['--model', '/models/Qwen3-Reranker-0.6B', '--served-model-name', 'Qwen3-Reranker-0.6B', '--gpu-memory-utilization', '0.90', '--hf_overrides', '{"architectures": ["Qwen3ForSequenceClassification"],"classifier_from_token": ["no", "yes"],"is_original_qwen3_reranker": true}']
    ports:
      - 8010:8000  # 宿主机端口:容器内端口（容器内默认8000）
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
```


### 2. 启动容器
将上述文件保存到本地后，在文件所在目录执行以下命令启动服务：  
```bash
docker compose up -d
```


## 四、API调用方法
### 1. Docker内应用调用
- 请求地址：`[]  
- 认证Key：无需（填写`NOT_NEED`）  
- 模型名称：`Qwen3-Reranker-0.6B`（需与部署时`--served-model-name`参数一致）  


### 2. Docker外部应用调用
- 请求地址：`[]  
- 认证Key：无需（填写`NOT_NEED`）  
- 模型名称：`Qwen3-Reranker-0.6B`（同上）  


## 五、测试验证
上述部署及调用流程已在FastGPT平台验证，可正常实现文本排序功能。
