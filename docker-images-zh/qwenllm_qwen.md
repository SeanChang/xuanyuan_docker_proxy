---
image: qwenllm/qwen
description: "阿里云提出的Qwen聊天与预训练大型语言模型的官方仓库。"
source: https://xuanyuan.cloud/zh/r/qwenllm/qwen
canonical: https://xuanyuan.cloud/zh/r/qwenllm/qwen
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/qwenllm/qwen" title="qwenllm/qwen Docker 镜像中文简介、标签列表与拉取命令">qwenllm/qwen — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/qwenllm/qwen" title="qwenllm/qwen Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/qwenllm/qwen</a>

# Qwen Docker镜像技术文档


## 1. 镜像概述

Qwen Docker镜像是阿里云官方提供的Qwen系列大语言模型（Large Language Model, LLM）部署工具，封装了Qwen聊天模型及预训练模型的运行环境。该镜像旨在为开发者、研究人员及企业用户提供便捷、一致的Qwen模型部署方案，简化模型部署流程，降低环境配置复杂度。


## 2. 核心功能与特性

### 2.1 核心功能
- **官方原生支持**：由阿里云官方维护，与Qwen模型代码库同步更新，确保兼容性与安全性。
- **多场景适配**：支持Qwen系列预训练模型加载及聊天交互功能，满足文本生成、对话交互等基础LLM能力需求。
- **环境隔离**：通过Docker容器化部署，避免宿主环境依赖冲突，简化跨平台迁移。

### 2.2 关键特性
- **模型版本兼容**：支持Qwen系列主流模型版本（如Qwen-7B、Qwen-14B等，具体版本需参考镜像标签）。
- **资源灵活调度**：适配CPU/GPU运行环境，可根据硬件资源自动调整计算策略。
- **轻量部署**：镜像体积经过优化，核心依赖预打包，减少部署耗时。
- **可扩展接口**：预留模型服务API接口，支持与外部系统集成。


## 3. 使用场景与适用范围

### 3.1 主要使用场景
- **开发与测试环境**：快速搭建Qwen模型本地运行环境，用于应用原型开发或功能验证。
- **演示系统构建**：部署轻量级Qwen聊天演示服务，展示模型对话能力。
- **研究实验**：作为基础环境支持Qwen模型微调、Prompt工程等研究场景。
- **企业内部服务**：部署至企业内网，为内部业务系统提供LLM能力支撑（需结合权限控制）。

### 3.2 适用人群
- AI应用开发者、大语言模型研究人员、企业IT运维人员。


## 4. 使用方法与配置说明

### 4.1 前提条件
- 已安装Docker Engine（20.10+版本）及Docker Compose（可选）。
- 若使用GPU加速，需安装NVIDIA Docker Runtime（nvidia-docker2）。
- 模型文件：需提前获取Qwen预训练模型文件（如通过阿里云ModelScope或官方渠道下载）。


### 4.2 镜像拉取
通过Docker Hub或阿里云容器镜像服务拉取官方镜像：
```bash
# 从Docker Hub拉取（示例，实际标签以官方为准）
docker pull qwenlm/qwen:latest

# 从阿里云容器镜像服务拉取（推荐国内用户）
docker pull .xuanyuan.run/qwen/qwen:latest
```


### 4.3 快速启动
#### 4.3.1 基础运行（CPU模式）
适用于无GPU环境，仅用于功能验证（性能有限）：
```bash
docker run -it --rm \
  -p 8000:8000 \
  -v /path/to/your/qwen/model:/app/model \  # 挂载本地模型文件
  qwenlm/qwen:latest \
  --model-path /app/model \
  --server-port 8000
```

#### 4.3.2 GPU加速运行
需确保宿主环境已配置NVIDIA Docker：
```bash
docker run -it --rm \
  --gpus all \  # 启用所有GPU
  -p 8000:8000 \
  -v /path/to/your/qwen/model:/app/model \
  qwenlm/qwen:latest \
  --model-path /app/model \
  --server-port 8000 \
  --device cuda
```


### 4.4 Docker Compose配置示例
创建`docker-compose.yml`文件，简化多环境部署：
```yaml
version: '3.8'
services:
  qwen-service:
    image: qwenlm/qwen:latest
    restart: unless-stopped
    ports:
      - "8000:8000"
    volumes:
      - ./local_model:/app/model  # 本地模型目录挂载
      - ./logs:/app/logs          # 日志持久化
    environment:
      - MODEL_PATH=/app/model
      - SERVER_PORT=8000
      - DEVICE=cuda               # 或cpu
      - LOG_LEVEL=info
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]  # GPU资源预留（仅GPU模式需配置）
```
启动服务：`docker-compose up -d`


## 5. 配置参数说明

### 5.1 命令行参数
| 参数名          | 说明                     | 默认值       | 示例                  |
|-----------------|--------------------------|--------------|-----------------------|
| --model-path    | 模型文件路径（容器内）   | /app/model   | --model-path /data/qwen-7b |
| --server-port   | 服务监听端口             | 8000         | --server-port 9000    |
| --device        | 运行设备（cpu/cuda）     | cpu          | --device cuda         |
| --max-seq-len   | 最大序列长度             | 2048         | --max-seq-len 4096    |
| --log-path      | 日志输出路径             | /app/logs    | --log-path /var/log/qwen |


### 5.2 环境变量
通过`-e`或`environment`配置，优先级高于命令行参数：
| 环境变量名       | 说明                     | 默认值       | 示例值                |
|------------------|--------------------------|--------------|-----------------------|
| MODEL_PATH       | 模型文件路径             | /app/model   | /data/qwen-14b        |
| SERVER_PORT      | 服务端口                 | 8000         | 8080                  |
| DEVICE           | 运行设备                 | cpu          | cuda                  |
| LOG_LEVEL        | 日志级别（debug/info/warn/error） | info     | debug                 |
| MAX_BATCH_SIZE   | 最大批量请求数           | 4            | 8                     |


## 6. 注意事项
- **模型文件获取**：Qwen模型文件需通过官方渠道获取（如阿里云ModelScope），镜像本身不包含模型权重。
- **资源要求**：7B模型建议至少16GB内存（CPU）或8GB显存（GPU）；14B及以上模型需更高配置。
- **网络安全**：生产环境部署时需配置身份验证（如API Key）及网络隔离，避免未授权访问。
- **版本兼容性**：镜像标签与模型版本需匹配（如`qwen:7b-v1.0`对应Qwen-7B v1.0模型），具体参考官方版本说明。


## 7. 参考链接
- Qwen官方代码库：[https://github.com/QwenLM/Qwen](https://github.com/QwenLM/Qwen)
- 阿里云ModelScope模型下载：[https://modelscope.cn/models/qwen](https://modelscope.cn/models/qwen)
- Docker官方文档：[https://docs.docker.com/](https://docs.docker.com/)
