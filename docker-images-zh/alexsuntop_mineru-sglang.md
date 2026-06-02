<!-- xuanyuan-docker-images-zh
image: alexsuntop/mineru-sglang
source: https://xuanyuan.cloud/zh/r/alexsuntop/mineru-sglang
canonical: https://xuanyuan.cloud/zh/r/alexsuntop/mineru-sglang
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [alexsuntop/mineru-sglang — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/alexsuntop/mineru-sglang "alexsuntop/mineru-sglang Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/alexsuntop/mineru-sglang

### MinerU SGLang 后端部署指南


#### 一、概述  
MinerU 是一款文档解析工具，其 SGLang 后端支持通过 Docker 快速部署。本文基于官方 Dockerfile 及 Docker Compose 配置，提供 SGLang 后端服务（含服务器、API、WebUI）的部署与使用说明。  

> **注意**：MinerU 2.5+ 版本已切换为 vLLM 后端，相关镜像可参考 [alexsuntop/mineru]([])。本文内容适用于基于 SGLang 后端的旧版本（如 2.2.2）。  


#### 二、环境准备  
- **依赖工具**：Docker、Docker Compose（需支持 Compose V2）。  
- **硬件要求**：NVIDIA GPU（需配置 NVIDIA Container Toolkit，确保容器可调用 GPU）。  


#### 三、配置说明  
以下是核心配置文件 `docker-compose.yaml` 的关键说明（完整配置见 [源码仓库]([])）：  


##### 3.1 默认配置（x-default）  
定义所有服务的通用基础配置：  
- 重启策略：`unless-stopped`（异常退出后自动重启）。  
- 数据卷：挂载本地时区文件（`/etc/localtime`、`/etc/timezone`），确保容器内时间同步。  
- 日志限制：单日志文件最大 100MB（避免磁盘占用过大）。  


##### 3.2 通用服务配置（x-mineru-sglang）  
所有 MinerU 服务的共享配置：  
- **镜像**：默认使用 `alexsuntop/mineru-sglang:2.2.2`，可通过环境变量 `MINERU_DOCKER_IMAGE` 自定义。  
- **环境变量**：`MINERU_MODEL_SOURCE: local`（使用本地模型）。  
- **资源限制**：默认限制 8 CPU 核心、4G 内存，保留 1 CPU 核心、2G 内存；GPU 仅使用第 0 号设备（可通过 `device_ids` 调整）。  
- **性能优化**：解除内存锁定限制（`memlock: -1`），提升 GPU 通信效率（`ipc: host`）。  


##### 3.3 服务详情  

###### （1）SGLang 后端服务器（sglang-server）  
- **功能**：提供模型推理服务，端口 30000（可通过 `MINERU_PORT_OVERRIDE_SGLANG` 自定义）。  
- **启动命令**：`mineru-sglang-server --host 0.0.0.0 --port 30000`。  
- **可选参数**：  
  - 多 GPU 并行：`--data-parallel-size 2`（需调整 `device_ids` 包含多个 GPU）。  
  - 显存优化：`--gpu-memory-utilization 0.5`（单 GPU 显存不足时降低，如 0.4）。  
- **健康检查**：通过 `curl [] 验证服务状态。  


###### （2）文档解析 API（api）  
- **功能**：提供文档解析接口，端口 8000（可通过 `MINERU_PORT_OVERRIDE_API` 自定义）。  
- **启动命令**：`mineru-api --host 0.0.0.0 --port 8000`，支持与 sglang-server 相同的 GPU 配置参数。  


###### （3）Gradio WebUI（gradio）  
- **功能**：可视化 Web 界面，端口 7860（可通过 `MINERU_PORT_OVERRIDE_GRADIO` 自定义）。  
- **核心参数**：  
  - `--enable-vllm-engine true`：启用 vllm 引擎加速推理。  
  - `--enable-api false`：可选，禁用 API 接口。  
  - `--max-convert-pages 20`：可选，限制文档转换页数。  


#### 四、启动服务  
通过 Docker Compose 的 `--profile` 指定服务类型，后台启动：  

```bash
# 启动 SGLang 后端服务器
docker compose --profile sglang-server up -d

# 启动文档解析 API
docker compose --profile api up -d

# 启动 Gradio WebUI
docker compose --profile gradio up -d
```


#### 五、测试 SGLang 后端  
安装 MinerU 客户端并测试文档解析：  

1. **安装客户端**：  
   ```bash
   pip install mineru
   ```  

2. **执行测试**（需替换 `demo.pdf` 为实际文件路径）：  
   ```bash
   mineru -p demo.pdf -o ./output -b vlm-sglang-client -u []   ```  
   - `-p`：输入文档路径  
   - `-o`：输出目录  
   - `-b`：后端类型（`vlm-sglang-client`）  
   - `-u`：sglang-server 地址（默认 `[]  


#### 六、注意事项  
1. **GPU 资源调整**：根据实际硬件配置修改 `device_ids`（GPU 设备）、`data-parallel-size`（多卡并行）及 `gpu-memory-utilization`（显存占用）。  
2. **端口冲突**：通过环境变量（如 `MINERU_PORT_OVERRIDE_SGLANG=30001`）修改默认端口。  
3. **功能限制**：Gradio 界面可通过 `--max-convert-pages` 限制文档转换页数，避免资源过载。  


**源码参考**：[compose-anything]([])
