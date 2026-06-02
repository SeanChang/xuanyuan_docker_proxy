<!-- xuanyuan-docker-images-zh
image: rocm/vllm
source: https://xuanyuan.cloud/zh/r/rocm/vllm
canonical: https://xuanyuan.cloud/zh/r/rocm/vllm
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [rocm/vllm — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/rocm/vllm "rocm/vllm Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/rocm/vllm

## ROCm优化的vLLM Docker容器（适用于AMD GPU）


### 一、概述  
这是一套基于ROCm（AMD的开源GPU计算平台）优化的vLLM Docker容器，专为AMD GPU用户设计。vLLM是一款高效的大语言模型服务框架，通过该容器，用户可快速部署支持高并发、低延迟的大语言模型推理服务，无需手动配置ROCm环境或编译vLLM依赖，直接开箱即用。


### 二、核心特性  
#### 1. ROCm深度优化  
- 针对AMD GPU架构（如MI250、MI300、Radeon Pro等型号）做了底层适配，充分利用GPU计算核心与显存带宽，提升模型推理效率。  
- 内置兼容当前主流ROCm版本（如ROCm 5.7+），无需额外安装驱动或 runtime，容器内环境已预配置完成。  

#### 2. 继承vLLM核心优势  
- 支持PagedAttention技术：通过高效的显存管理，减少模型加载时的内存占用，支持更大批次的并发请求。  
- 兼容多模型格式：可直接加载Hugging Face格式、GPTQ/AWQ量化模型等，无需额外转换。  
- 低延迟、高吞吐量：相比传统推理框架（如Transformers），相同硬件下吞吐量提升2-4倍，响应延迟降低30%以上。  


### 三、适用场景  
- **企业/开发者测试**：快速搭建大语言模型本地测试环境，验证模型性能或应用逻辑。  
- **中小规模服务部署**：适合需要对外提供API服务的场景（如客服机器人、智能问答），单容器可支撑数百QPS的并发请求。  
- **AMD GPU硬件使用者**：解决AMD GPU用户部署vLLM时的环境配置难题（如ROCm依赖冲突、编译失败等）。  


### 四、使用步骤  
#### 1. 准备环境  
- 确保本地已安装Docker（推荐20.10+版本），并启用GPU支持（安装nvidia-docker兼容工具，如`rocm-docker`）。  
- 确认AMD GPU支持ROCm（可通过`rocm-smi`命令检查，或参考AMD官方ROCm支持列表）。  


#### 2. 获取容器镜像  
从Docker Hub或私有仓库拉取镜像（以Docker Hub为例）：  
```bash
docker pull rocm/vllm:latest  # 最新版，默认包含ROCm优化和vLLM稳定版
```  
如需指定版本，可替换`:latest`为具体标签（如`:v0.4.0-rocm5.7`）。  


#### 3. 启动容器并部署模型  
假设本地已下载模型文件（如Llama-2-7B），存放路径为`/path/to/your/model`，执行以下命令启动容器：  
```bash
docker run -it --network=host \
  --device=/dev/kfd --device=/dev/dri \  # 映射AMD GPU设备
  -v /path/to/your/model:/workspace/model \  # 挂载本地模型目录到容器内
  rocm/vllm:latest \
  python -m vllm.entrypoints.api_server \
    --model /workspace/model \  # 指定容器内模型路径
    --port 8000  # 服务端口（可自定义）
```  
- `--network=host`：直接使用主机网络（简单场景），或用`-p 8000:8000`映射端口。  
- 如需调整并发参数（如`--tensor-parallel-size`指定GPU数量，`--max-num-batched-tokens`控制批处理大小），可在命令后追加。  


#### 4. 测试服务  
容器启动后，通过HTTP请求测试推理效果（以curl为例）：  
```bash
curl [] \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Hello! How are you?", "max_tokens": 50}'
```  
若返回模型生成的文本，说明服务部署成功。


### 五、注意事项  
- 模型文件需提前下载至本地（推荐Hugging Face格式），容器内默认不包含模型数据。  
- 高并发场景下，建议根据GPU显存大小调整`--max-num-batched-tokens`（如MI250 64GB显存可设为8192）。  
- 如需使用量化模型（如GPTQ），启动命令需追加`--quantization gptq`，并确保模型文件包含量化参数。
