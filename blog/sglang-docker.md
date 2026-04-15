# SGLANG Docker容器化部署指南

![SGLANG Docker容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-sglang.png)

*分类: Docker,SGLANG | 标签: sglang,docker,部署教程 | 发布时间: 2025-11-08 11:35:29*

> SGLANG 是一个高性能的语言模型推理引擎，旨在为大语言模型（LLM）应用提供高效、灵活的部署和服务能力。该引擎基于sgl-project开源项目开发，支持复杂的提示工程、多轮对话管理和推理优化，广泛应用于智能客服、内容生成、代码辅助等场景。
> 

本文面向大模型推理场景，提供SGLANG全流程Docker容器化部署方案，覆盖环境准备、服务启动、参数配置、生产优化与故障排查全环节，同时通过轩辕镜像解决Docker环境安装与镜像拉取的网络痛点，实现SGLANG LLM推理服务的快速落地。

## 一、什么是SGLANG
SGLANG是LMSYS Org开源的高性能大语言模型（LLM）推理引擎，专为LLM应用提供低延迟、高吞吐的部署与服务能力。基于sgl-project开源项目深度优化，支持复杂提示工程、多轮对话管理、连续批处理和推理性能优化，广泛应用于智能客服、AIGC内容生成、代码辅助开发、企业级LLM API服务等场景，是目前开源社区中最主流的LLM推理部署方案之一。

本文核心关键词：**SGLANG Docker部署**、**SGLANG 推理服务**、**SGLANG LLM Server**、**SGLANG GPU 推理**、**sglang docker install**、**sglang server deploy**、**sglang openai compatible api**、**sglang inference server**、**sglang gpu inference docker**

## 二、部署前置要求
SGLANG作为LLM推理引擎，核心依赖GPU算力完成模型推理，无GPU环境仅可做基础功能测试，无法实现生产级LLM服务部署，具体要求如下：

### 2.1 硬件与系统要求
| 类别 | 最低要求 | 生产级推荐 |
|------|----------|------------|
| GPU | NVIDIA GPU，显存≥8GB（支持7B模型） | NVIDIA A10/A100/A800，显存≥24GB，支持FP8/FP16推理 |
| CPU | 4核8线程 | 8核16线程及以上 |
| 内存 | 16GB | 64GB及以上 |
| 系统 | Linux x86_64/arm64（Ubuntu/Debian/CentOS/Rocky Linux等主流发行版） | Ubuntu 22.04 LTS / Debian 12 |
| 驱动 | NVIDIA 驱动版本≥535，支持CUDA 12.x | NVIDIA 驱动版本≥550，CUDA 12.4+ |

### 2.2 Docker环境准备
部署SGLANG前需完成Docker环境、NVIDIA Container Toolkit的安装，确保容器可正常调用宿主机GPU资源。

#### 2.2.1 一键安装Docker环境（推荐）
推荐使用轩辕镜像提供的一键安装脚本，自动完成Docker、Docker Compose的安装与国内镜像源配置，解决官方源网络访问慢、安装失败的问题，支持几乎所有主流Linux发行版：
```bash
# 轩辕镜像一键安装Docker环境（全Linux系统兼容）
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

脚本执行完成后，通过以下命令验证Docker环境是否正常：
```bash
# 验证Docker服务状态
systemctl status docker

# 验证Docker版本
docker --version

# 运行测试容器，输出hello world则环境正常
docker run --rm hello-world
```

#### 2.2.2 安装NVIDIA Container Toolkit
容器调用GPU必须安装NVIDIA容器运行时，执行以下命令完成安装：
```bash
# 配置NVIDIA仓库
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# 安装并配置
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# 验证GPU容器能力，输出显卡信息则配置成功
docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi
```

## 三、SGLANG镜像拉取
### 3.1 镜像信息说明
SGLANG官方Docker镜像由LMSYS Org维护，核心信息如下：
- 镜像名称：`lmsysorg/sglang`
- 官方仓库：[轩辕镜像SGLANG镜像页](https://xuanyuan.cloud/r/lmsysorg/sglang)
- 全量标签：[SGLANG版本标签列表](https://xuanyuan.cloud/r/lmsysorg/sglang/tags)
- 推荐标签：
  - `latest`：最新稳定版，适配绝大多数场景
  - `main-cann8.5.0-*`：昇腾NPU适配版本
  - `v*.*.*-rocm*`：AMD GPU适配版本

### 3.2 镜像拉取命令（轩辕镜像加速）
通过轩辕镜像国内加速地址拉取，解决Docker Hub网络超时、拉取慢的问题，镜像名包含命名空间分隔符`/`，无需添加`library`前缀，命令如下：
```bash
# 拉取最新稳定版SGLANG镜像（轩辕镜像加速）
docker pull docker.xuanyuan.run/lmsysorg/sglang:latest

# 拉取指定版本镜像示例
docker pull docker.xuanyuan.run/lmsysorg/sglang:v0.5.10rc0-rocm720-mi30x

# 验证镜像拉取结果
docker images | grep lmsysorg/sglang
```

> 若 Docker Hub 拉取失败，建议直接使用轩辕镜像地址：`docker.xuanyuan.run/lmsysorg/sglang:latest`，国内网络环境下拉取稳定性和速度均有大幅提升。

## 四、快速启动SGLANG推理服务
### 4.1 100%可运行最简部署命令
以下为开箱即用的SGLANG服务启动命令，解决容器无主进程无限重启、端口不匹配、模型重复下载、GPU无法调用等核心问题，直接复制即可运行：
```bash
docker run -d \
  --gpus all \
  --name sglang-service \
  -p 30000:30000 \
  --shm-size 32g \
  --ipc=host \
  -e HF_ENDPOINT=https://hf-mirror.com \
  -v /data/huggingface:/root/.cache/huggingface \
  --restart always \
  docker.xuanyuan.run/lmsysorg/sglang:latest \
  python3 -m sglang.launch_server \
  --model-path Qwen/Qwen2-7B-Instruct \
  --host 0.0.0.0 \
  --port 30000
```

> 关键说明：
> 1. 末尾的`python3 -m sglang.launch_server`为容器主进程，是服务正常启动的核心，缺失会导致容器启动后立即退出、无限重启
> 2. `--model-path`指定LLM模型地址，示例使用阿里千问开源模型，无需申请权限可直接下载；如需使用Llama系列模型，需先完成Hugging Face授权配置
> 3. SGLANG默认服务端口为`30000`，端口映射需保持`宿主端口:30000`一致
> 4. `--gpus all`将宿主机所有GPU挂载到容器，是GPU推理的必填参数；如需指定单卡/多卡，可使用`--gpus '"device=0"'`（单卡）或`--gpus '"device=0,1"'`（多卡）
> 5. `-v /data/huggingface:/root/.cache/huggingface`挂载模型缓存目录，路径稳定、适配大容量数据盘、便于运维管理，避免容器重启后重复下载模型
> 6. `--restart always`为AI推理服务推荐的重启策略，Docker服务重启后会自动拉起容器，保障服务持续可用

### 4.2 国内模型下载加速配置
若Hugging Face模型下载缓慢，可在启动命令中添加国内镜像环境变量，加速模型拉取，上述最简命令已默认配置该参数：
```bash
-e HF_ENDPOINT=https://hf-mirror.com
```

### 4.3 Hugging Face授权配置（解决私有模型401报错）
针对Llama系列等需要申请权限的Gated模型，需配置Hugging Face Token完成授权，否则会出现`401 Unauthorized`报错，提供两种配置方式：

#### 方式1：环境变量注入（推荐，容器化场景首选）
在启动命令中添加`HF_TOKEN`环境变量，填入你的Hugging Face Access Token：
```bash
docker run -d \
  --gpus all \
  --name sglang-service \
  -p 30000:30000 \
  --shm-size 32g \
  --ipc=host \
  -e HF_ENDPOINT=https://hf-mirror.com \
  -e HF_TOKEN=hf_你的HuggingFaceToken \
  -v /data/huggingface:/root/.cache/huggingface \
  --restart always \
  docker.xuanyuan.run/lmsysorg/sglang:latest \
  python3 -m sglang.launch_server \
  --model-path meta-llama/Llama-3.1-8B-Instruct \
  --host 0.0.0.0 \
  --port 30000
```

#### 方式2：宿主机登录后挂载凭证
先在宿主机完成Hugging Face登录，再将凭证目录挂载到容器中：
```bash
# 宿主机安装huggingface-cli并登录
pip install -U huggingface_hub
huggingface-cli login

# 启动容器时挂载凭证目录
docker run -d \
  --gpus all \
  --name sglang-service \
  -p 30000:30000 \
  --shm-size 32g \
  --ipc=host \
  -e HF_ENDPOINT=https://hf-mirror.com \
  -v ~/.huggingface:/root/.huggingface \
  -v /data/huggingface:/root/.cache/huggingface \
  --restart always \
  docker.xuanyuan.run/lmsysorg/sglang:latest \
  python3 -m sglang.launch_server \
  --model-path meta-llama/Llama-3.1-8B-Instruct \
  --host 0.0.0.0 \
  --port 30000
```

## 五、核心部署参数详解
### 5.1 Docker容器核心参数
| 参数 | 作用 | 推荐配置 |
|------|------|----------|
| `--gpus all` | 挂载宿主机GPU到容器，GPU推理必填 | 单卡指定：`--gpus '"device=0"'`；多卡指定：`--gpus '"device=0,1"'`；全量挂载：`--gpus all` |
| `-p 30000:30000` | 端口映射，宿主端口:容器内SGLANG服务端口 | 保持容器内端口30000，宿主端口可自定义 |
| `--shm-size` | 共享内存大小，影响PyTorch多进程通信和NCCL多卡通信稳定性 | 单卡推理建议 ≥8G，多卡推理建议 ≥16G，生产环境推荐32G |
| `--ipc=host` | 共享宿主机IPC命名空间，提升多卡推理性能 | 多卡推理必加，单卡推理推荐添加 |
| `-v /data/huggingface:/root/.cache/huggingface` | 模型缓存持久化，避免重复下载模型 | 固定配置，宿主目录建议使用大容量数据盘 |
| `--restart` | 容器重启策略，保障服务可用性 | 生产环境AI推理服务推荐`always`，Docker服务重启后自动拉起容器；`unless-stopped`仅在手动停止后不重启 |
| `--cpus 8 --memory 64g` | CPU和内存资源限制，避免服务占用过多系统资源 | 生产环境根据服务器配置设置 |
| `-e HF_ENDPOINT=https://hf-mirror.com` | Hugging Face国内镜像环境变量，加速模型下载 | 国内环境必加 |
| `-e HF_TOKEN=xxx` | Hugging Face授权Token，访问Gated私有模型必填 | 按需配置 |

### 5.2 SGLANG服务核心启动参数
所有参数需追加在镜像名之后，作为`python3 -m sglang.launch_server`的入参：
| 参数 | 作用 | 示例 |
|------|------|------|
| `--model-path` | 【必填】LLM模型在Hugging Face的地址，或本地模型路径 | `--model-path meta-llama/Llama-3.1-8B-Instruct` |
| `--host 0.0.0.0` | 【必填】服务监听地址，容器内必须设置为0.0.0.0，否则外部无法访问 | 固定配置`--host 0.0.0.0` |
| `--port 30000` | 【必填】服务监听端口，需与Docker端口映射的容器内端口保持一致 | 默认30000，可自定义 |
| `--tensor-parallel-size` | 张量并行数，多卡推理时设置，数值等于GPU数量 | 2卡推理：`--tensor-parallel-size 2` |
| `--max-total-token` | 单请求最大token数，限制上下文长度 | `--max-total-token 8192` |
| `--api-key` | API接口鉴权密钥，生产环境必加，防止接口未授权访问 | `--api-key your_secure_api_key` |
| `--log-level` | 日志级别，可选debug/info/warning/error | `--log-level info` |

## 六、服务验证与API测试
容器启动后，通过以下步骤验证服务是否正常运行，避免无效部署。

### 6.1 容器运行状态检查
```bash
# 查看容器运行状态，STATUS为Up则正常运行，Restarting则启动失败
docker ps | grep sglang-service

# 若容器异常，查看实时日志定位问题
docker logs -f sglang-service

# 查看最近200行启动日志，排查模型下载、服务启动错误
docker logs --tail=200 sglang-service
```

### 6.2 服务接口可用性测试
SGLANG原生兼容OpenAI API格式，通过以下命令验证服务是否正常响应：
```bash
# 基础健康检查，返回模型列表则服务启动成功
curl http://localhost:30000/v1/models

# 带鉴权的测试（若启动时添加了--api-key）
curl http://localhost:30000/v1/models \
  -H "Authorization: Bearer your_secure_api_key"

# 聊天补全测试，验证推理能力
curl http://localhost:30000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Qwen/Qwen2-7B-Instruct",
    "messages": [{"role": "user", "content": "你好，介绍一下SGLANG"}],
    "temperature": 0.7,
    "max_tokens": 512
  }'
```

正常返回结果示例：
```json
{
  "id": "chatcmpl-xxx",
  "object": "chat.completion",
  "created": 1712345678,
  "model": "Qwen/Qwen2-7B-Instruct",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "SGLANG是LMSYS Org开源的高性能大语言模型推理引擎，专为LLM部署优化，具备低延迟、高吞吐的特点..."
      },
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 15,
    "completion_tokens": 128,
    "total_tokens": 143
  }
}
```

### 6.3 OpenAI SDK Python测试
绝大多数开发者通过Python SDK调用SGLANG的sglang inference server服务，以下为可直接运行的测试代码：
```python
from openai import OpenAI

# 初始化客户端，SGLANG完全兼容OpenAI接口格式
client = OpenAI(
    base_url="http://localhost:30000/v1",
    api_key="your_secure_api_key" # 未设置api-key时可填任意非空字符串，如"test"
)

# 调用聊天补全接口
resp = client.chat.completions.create(
    model="Qwen/Qwen2-7B-Instruct",
    messages=[{"role": "user", "content": "你好，介绍一下SGLANG的核心优势"}],
    temperature=0.7,
    max_tokens=512,
    stream=False # 如需流式输出，设置为True即可
)

# 打印返回结果
print(resp.choices[0].message.content)
print(f"Token消耗：{resp.usage.total_tokens}")
```

## 七、生产级部署优化
### 7.1 服务安全加固
1. **API鉴权配置**
生产环境必须添加`--api-key`参数开启接口鉴权，避免未授权访问：
```bash
docker run -d \
  --gpus all \
  --name sglang-service \
  -p 30000:30000 \
  --shm-size 32g \
  --ipc=host \
  -e HF_ENDPOINT=https://hf-mirror.com \
  -v /data/huggingface:/root/.cache/huggingface \
  --restart always \
  docker.xuanyuan.run/lmsysorg/sglang:latest \
  python3 -m sglang.launch_server \
  --model-path Qwen/Qwen2-7B-Instruct \
  --host 0.0.0.0 \
  --port 30000 \
  --api-key your_secure_strong_api_key
```

2. **日志轮转配置**
限制容器日志大小，避免磁盘占满：
```bash
docker run -d \
  --gpus all \
  --name sglang-service \
  -p 30000:30000 \
  --shm-size 32g \
  --ipc=host \
  --log-driver json-file \
  --log-opt max-size=100m \
  --log-opt max-file=5 \
  -e HF_ENDPOINT=https://hf-mirror.com \
  -v /data/huggingface:/root/.cache/huggingface \
  --restart always \
  docker.xuanyuan.run/lmsysorg/sglang:latest \
  python3 -m sglang.launch_server \
  --model-path Qwen/Qwen2-7B-Instruct \
  --host 0.0.0.0 \
  --port 30000 \
  --api-key your_secure_strong_api_key
```

### 7.2 核心监控指标
LLM推理服务核心监控指标为GPU相关指标，而非通用容器资源，推荐重点监控：
1. **GPU利用率**：通过`nvidia-smi`实时查看，正常推理场景应保持在70%-90%
2. **GPU显存占用**：避免显存OOM导致服务崩溃，预留10%-20%显存余量
3. **Token吞吐量**：每秒生成token数，衡量服务吞吐能力
4. **首包延迟**：用户请求到返回第一个token的时间，衡量服务响应速度

基础监控命令：
```bash
# 实时查看GPU状态
nvidia-smi -l 1

# 查看容器内GPU进程
docker exec sglang-service nvidia-smi
```

### 7.3 高可用负载均衡部署
生产环境推荐多实例部署配合Nginx负载均衡，实现服务高可用与流量分发，同时优化流式输出体验：
1. **部署多实例**
```bash
# 实例1（绑定0号GPU）
docker run -d \
  --gpus '"device=0"' \
  --name sglang-service-1 \
  -p 30001:30000 \
  --shm-size 16g \
  --ipc=host \
  -e HF_ENDPOINT=https://hf-mirror.com \
  -v /data/huggingface:/root/.cache/huggingface \
  --restart always \
  docker.xuanyuan.run/lmsysorg/sglang:latest \
  python3 -m sglang.launch_server \
  --model-path Qwen/Qwen2-7B-Instruct \
  --host 0.0.0.0 \
  --port 30000 \
  --api-key your_secure_strong_api_key

# 实例2（绑定1号GPU）
docker run -d \
  --gpus '"device=1"' \
  --name sglang-service-2 \
  -p 30002:30000 \
  --shm-size 16g \
  --ipc=host \
  -e HF_ENDPOINT=https://hf-mirror.com \
  -v /data/huggingface:/root/.cache/huggingface \
  --restart always \
  docker.xuanyuan.run/lmsysorg/sglang:latest \
  python3 -m sglang.launch_server \
  --model-path Qwen/Qwen2-7B-Instruct \
  --host 0.0.0.0 \
  --port 30000 \
  --api-key your_secure_strong_api_key
```

2. **Nginx负载均衡配置**
```nginx
upstream sglang_llm_cluster {
    server 127.0.0.1:30001;
    server 127.0.0.1:30002;
}

server {
    listen 80;
    server_name sglang-llm.yourdomain.com;

    # 统一鉴权，避免多实例密钥管理麻烦
    proxy_set_header Authorization "Bearer your_secure_strong_api_key";
    
    location / {
        proxy_pass http://sglang_llm_cluster;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_buffering off;
        chunked_transfer_encoding on;
        proxy_cache off;
        proxy_read_timeout 300s;
        proxy_send_timeout 300s;
    }
}
```
> 关键优化：`chunked_transfer_encoding on` 适配LLM流式输出场景，避免部分客户端出现卡顿、断连问题。

## 八、常见故障排查
### 8.1 容器启动后无限重启
**症状**：`docker ps`显示容器状态为`Restarting`，无正常运行时间
**核心原因**：缺失启动命令`python3 -m sglang.launch_server`，容器无主进程，启动后立即退出
**解决方案**：
1. 检查启动命令，确保镜像名后追加了完整的launch_server启动命令
2. 查看容器日志，确认是否为模型下载失败、权限不足导致的进程退出：`docker logs --tail=100 sglang-service`
3. 确认`--host 0.0.0.0`参数已添加，避免服务监听127.0.0.1导致进程退出

### 8.2 镜像拉取失败/超时
**症状**：`docker pull`提示网络超时、`no such image`、连接被拒绝
**解决方案**：
1. 优先使用轩辕镜像加速地址`docker.xuanyuan.run/lmsysorg/sglang:latest`，替代Docker Hub官方地址，国内网络环境下稳定性大幅提升
2. 检查Docker镜像源配置，确认已通过轩辕一键脚本配置国内源
3. 检查宿主机网络，确认可正常访问`docker.xuanyuan.run`：`ping docker.xuanyuan.run`

### 8.3 服务启动成功，但接口无法访问
**症状**：容器状态为Up，curl接口无响应/连接被拒绝
**解决方案**：
1. 确认端口映射配置正确，宿主端口未被其他服务占用：`netstat -tulpn | grep 30000`
2. 确认启动命令中`--port`参数与Docker端口映射的容器内端口完全一致
3. 检查宿主机防火墙，开放对应端口：
   ```bash
   # UFW防火墙（Ubuntu/Debian）
   sudo ufw allow 30000/tcp
   # Firewalld防火墙（CentOS/Rocky Linux）
   sudo firewall-cmd --add-port=30000/tcp --permanent
   sudo firewall-cmd --reload
   ```
4. 确认启动命令中添加了`--host 0.0.0.0`，否则服务仅监听容器内本地地址，外部无法访问

### 8.4 GPU无法识别/调用失败
**症状**：日志提示CUDA不可用、no CUDA-capable device detected
**解决方案**：
1. 确认启动命令中添加了`--gpus all`或指定GPU设备的参数
2. 验证NVIDIA Container Toolkit安装正常：`docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi`
3. 检查宿主机NVIDIA驱动版本，确认≥535，支持CUDA 12.x
4. 重启Docker服务：`sudo systemctl restart docker`，重新加载NVIDIA运行时

### 8.5 模型下载失败/容器OOM崩溃
**症状**：日志显示模型下载超时、校验失败，或容器因内存不足被kill
**解决方案**：
1. 添加`-e HF_ENDPOINT=https://hf-mirror.com`环境变量，使用国内Hugging Face镜像加速下载
2. 挂载模型缓存目录`-v /data/huggingface:/root/.cache/huggingface`，避免重复下载
3. 增大`--shm-size`参数，单卡推理≥8G，多卡推理≥16G，生产环境推荐32G
4. 确认GPU显存满足模型要求，7B模型至少需要8GB显存，13B模型至少需要16GB显存

### 8.6 端口被占用导致服务启动失败
**症状**：容器启动失败，日志提示`bind: address already in use`
**核心原因**：宿主机30000端口被ollama、vllm、open-webui等其他服务占用
**解决方案**：
1. 执行以下命令查看端口占用情况，确认占用进程：
   ```bash
   # 方法1：lsof命令
   lsof -i:30000
   # 方法2：ss命令（推荐，无需额外安装）
   ss -lntp | grep 30000
   ```
2. 停止占用端口的进程，或修改Docker端口映射，更换未被占用的宿主端口（如`-p 30001:30000`）

### 8.7 Hugging Face私有模型401未授权报错
**症状**：容器日志提示`401 Unauthorized`，无法下载Llama等Gated模型
**解决方案**：
1. 确认已在Hugging Face官网申请该模型的访问权限，审核通过后方可下载
2. 按照本文4.3节的方法，通过`HF_TOKEN`环境变量或挂载凭证目录完成授权配置
3. 确认Token具备模型读取权限，且未过期

## 九、参考资源
- [SGLANG官方镜像仓库 - 轩辕镜像](https://xuanyuan.cloud/r/lmsysorg/sglang)
- [SGLANG全版本标签列表](https://xuanyuan.cloud/r/lmsysorg/sglang/tags)
- [Docker Run命令可视化生成工具 - 轩辕镜像](https://xuanyuan.cloud/docker/run)
- [Docker官方run命令参考文档](https://docs.docker.com/engine/reference/commandline/run/)
- [轩辕镜像官方网站 - Docker镜像加速服务](https://xuanyuan.cloud/)

