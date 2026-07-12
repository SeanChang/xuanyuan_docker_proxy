---
image: jianjungki/mineru
description: "MinerU的Docker镜像，封装了PDF转机器可读格式的完整功能，支持WebUI、API及GPU加速，快速部署解决环境问题。"
source: https://xuanyuan.cloud/zh/r/jianjungki/mineru
canonical: https://xuanyuan.cloud/zh/r/jianjungki/mineru
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jianjungki/mineru" title="jianjungki/mineru Docker 镜像中文简介、标签列表与拉取命令">jianjungki/mineru 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MinerU Docker镜像 技术文档


## 1. 镜像概述和主要用途

### 1.1 镜像概述
![MinerU Logo](docs/images/MinerU-logo.png)

MinerU是一款专注于将PDF转换为机器可读格式（如markdown、JSON）的工具，诞生于[InternLM](https://github.com/InternLM/InternLM)的预训练过程，致力于解决科技文献中的符号转换问题。本Docker镜像封装了MinerU的完整运行环境，包含webui、API服务及vllm推理加速框架，可快速部署并解决环境兼容问题，确保在不同平台上提供一致的运行体验。

### 1.2 主要用途
- 将PDF文档（包括扫描版、图片型文档）转换为结构化的机器可读格式（markdown、JSON等）
- 通过WebUI（Gradio）进行可视化操作，方便非技术用户使用
- 提供API接口，支持集成到自动化工作流或第三方系统
- 利用vllm框架加速VLM模型推理，提升PDF转换效率


## 2. 核心功能和特性

### 2.1 核心功能
- **文档转换**：支持PDF到markdown、JSON等格式的转换，保留文档结构和符号信息
- **多服务支持**：集成API服务、Gradio WebUI、vllm推理服务器，满足不同使用场景
- **OCR能力**：可选启用OCR功能，处理扫描版或图片型文档
- **批量处理**：支持同时处理多个文档，提升效率

### 2.2 关键特性
- **环境一致性**：Docker容器化确保在Linux、Windows、macOS等平台上运行环境一致
- **简化部署**：无需手动配置依赖，一键启动完整服务
- **加速支持**：集成vllm框架，支持Turing及以后架构GPU加速（需显存≥8G）
- **资源隔离**：与宿主机其他服务隔离，避免依赖冲突
- **跨平台兼容**：支持CPU纯环境运行，也可利用GPU/CUDA/NPU/MPS加速


## 3. 使用场景和适用范围

### 3.1 典型使用场景
- **个人用户**：通过Gradio WebUI可视化转换PDF文档，快速获取结构化内容
- **开发者集成**：调用API接口将PDF转换功能嵌入自有应用或工作流
- **批量处理需求**：针对大量学术论文、报告等PDF文件进行批量转换和结构化存储
- **离线环境部署**：在无网络或隐私敏感场景中，通过本地部署处理文档

### 3.2 适用范围
- **用户群体**：研究人员、开发者、需要处理PDF文档的个人或企业用户
- **环境要求**：支持Docker的设备，若使用GPU加速需满足CUDA 12.8+及显卡架构要求
- **应用场景**：学术文献处理、文档结构化存储、自动化办公流程集成


## 4. 使用方法和配置说明

### 4.1 基础使用（Docker Run）

#### 4.1.1 直接运行官方镜像
```bash
docker run --rm -it -p 3000:3000 -p 7860:7860 --gpus=all docker.xuanyuan.run/jianjungki/mineru:latest
```
- 参数说明：
  - `--rm`：容器退出后自动清理
  - `-it`：启用交互式终端
  - `-p 3000:3000 -p 7860:7860`：映射服务端口（3000用于vllm-server，7860用于Gradio WebUI）
  - `--gpus=all`：允许容器访问GPU（如需vllm加速）

#### 4.1.2 手动构建并运行镜像
```bash
# 克隆仓库
git clone https://github.com/jianjungki/MinerU
cd MinerU
# 构建镜像
docker build -t mineru:latest .
# 启动容器
docker run -p 8001:8001 --env-file .env docker.xuanyuan.run/mineru:latest
```
- 参数说明：
  - `--env-file .env`：通过环境变量文件配置API密钥等参数
  - `-p 8001:8001`：映射MCP-Server服务端口


### 4.2 Docker Compose 配置示例
```yaml
version: '3'
services:
  mineru:
    image: docker.xuanyuan.run/jianjungki/mineru:latest
    ports:
      - "30000:30000"  # vllm-server端口
      - "7860:7860"    # Gradio WebUI端口
      - "8000:8000"    # API服务端口
    shm_size: "32g"
    ipc: host
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    command: /bin/bash
```

#### 4.2.1 启动特定服务

**启动Web API服务：**
```bash
docker compose -f compose.yaml --profile api up -d
```

访问`http://<server_ip>:8000/docs`查看API文档

**启动Gradio WebUI：**
```bash
docker compose -f compose.yaml --profile gradio up -d
```

访问`http://<server_ip>:7860`使用WebUI，`http://<server_ip>:7860/?view=api`调用Gradio API

**启动vllm-server：**
```bash
docker compose -f compose.yaml --profile vllm-server up -d
```

通过客户端连接：`mineru -p <input_path> -o <output_path> -b vlm-http-client -u http://<server_ip>:30000`


### 4.3 核心配置参数
通过环境变量或命令行参数配置服务，常用参数如下：

| 参数                 | 描述                                  | 默认值                  |
|----------------------|---------------------------------------|-------------------------|
| `MINERU_API_BASE`    | MinerU远程API基础URL                  | `https://mineru.net`    |
| `MINERU_API_KEY`     | 从官网申请的API密钥（远程调用时需配置） | -                       |
| `OUTPUT_DIR`         | 转换后文件保存路径                    | `/app/downloads`        |
| `--port`             | 服务端口（如vllm-server、API）        | 30000（vllm）、8000（API） |
| `--enable-vllm-engine` | 启用vllm推理引擎（Gradio服务）        | `false`                 |


### 4.4 数据持久化
为保留转换结果，建议挂载输出目录：
```bash
docker run -p 8001:8001 --env-file .env \
  -v $(pwd)/downloads:/app/downloads \
  docker.xuanyuan.run/jianjungki/mineru:latest
```
- 挂载`$(pwd)/downloads`到容器`/app/downloads`，用于持久化存储转换后的文件


## 5. 参考链接
- MinerU GitHub仓库：[https://github.com/jianjungki/MinerU](https://github.com/jianjungki/MinerU)
- Docker Hub镜像地址：[https://hub.docker.com/r/jianjungki/mineru](https://hub.docker.com/r/jianjungki/mineru)
- 官方文档：[https://opendatalab.github.io/MinerU/](https://opendatalab.github.io/MinerU/)
- 快速开始指南：[https://opendatalab.github.io/MinerU/quick_start/](https://opendatalab.github.io/MinerU/quick_start/)
