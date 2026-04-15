# MinerU Docker 部署指南：PDF 结构化解析服务实践

![MinerU Docker 部署指南：PDF 结构化解析服务实践](https://img.xuanyuan.dev/docker/blog/docker-mineru.png)

*分类: MinerU,PDF,人工智能,vLLM | 标签: mineru,部署教程,人工智能,vLLM | 发布时间: 2025-12-30 07:27:09*

> MinerU 是一款面向开发者与科研用户的容器化应用，专为 vLLM 后端服务设计，提供高效的文档解析与处理能力。通过 Docker 容器化部署 MinerU，可以简化安装流程、确保环境一致性，并便于在不同环境中快速迁移和扩展。
> 
> 本指南将详细介绍 MinerU 的 Docker 容器化部署方案，包括环境准备、镜像拉取、容器部署、功能测试及生产环境配置建议，旨在帮助用户快速搭建稳定可靠的 MinerU 服务。

## 概述

MinerU 是一款面向开发者与科研用户的 PDF 结构化解析工具，专注于将 PDF 文档高质量地转换为机器可读格式（如 Markdown、JSON 等），以便于后续的检索、分析与二次加工。MinerU 起源于「书生·浦语」大模型预训练过程，核心目标是解决科技文献中复杂版式、符号与公式的高质量解析问题，在大模型时代为科研与工程应用提供可靠的数据基础。

随着 2.7.0 版本的发布，MinerU 在解析架构和易用性方面进行了重要升级，引入了全新的 **hybrid 后端**，融合了 pipeline 与 VLM 两类后端的优势，在保证解析精度的同时显著提升了扩展性与稳定性。该后端在文本型 PDF 场景下可直接抽取原生文本，天然支持多语言并有效降低解析幻觉；在扫描版 PDF 场景下，则支持多达 109 种语言的 OCR 识别，并提供独立的行内公式识别开关，以适配不同视觉与结构需求。

在推理加速与部署层面，MinerU 提供了多种后端与引擎组合（pipeline / VLM / hybrid），并支持通过 `*-auto-engine` 模式自动选择适合当前运行环境的推理引擎，显著降低了使用与部署门槛。默认解析后端已切换为 `hybrid-auto-engine`，为新用户提供更加一致、开箱即用的解析体验。

本指南将以 **Docker 容器化部署** 为核心，详细介绍 MinerU 在 vLLM 等加速后端场景下的部署方式，包括环境准备、镜像拉取、服务启动、功能验证以及生产环境配置建议，帮助用户快速构建稳定、可复现的 MinerU 文档解析服务。

## 环境准备

### 系统要求

部署 MinerU 容器化应用前，请确保您的系统满足以下基本要求：
- 操作系统：Linux (Ubuntu 20.04+/CentOS 7+)、macOS 10.15+ 或 Windows 10+（建议使用 WSL2）
- 硬件配置：至少 2 CPU 核心、4GB 内存；如使用 GPU 加速功能，需配备 NVIDIA GPU 及相应驱动
- 网络环境：能够访问互联网以拉取 Docker 镜像和相关依赖
- 权限要求：具有 sudo 或 root 权限以安装 Docker 和管理容器

### Docker 环境安装

推荐使用以下一键脚本安装 Docker 环境，该脚本会自动安装 Docker Engine、Docker CLI、Docker Compose 等必要组件：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

安装完成后，建议将当前用户添加到 docker 用户组以避免每次使用 Docker 命令都需要 sudo 权限：

```bash
sudo usermod -aG docker $USER
```

> ⚠️ 注意：添加用户组后需要注销并重新登录才能生效

验证 Docker 是否安装成功：

```bash
docker --version
docker compose version
```

若命令输出 Docker 版本信息，则说明安装成功。

### GPU 运行环境（可选）

如需启用 GPU 加速，请确保系统已正确安装：

- NVIDIA GPU 驱动
- NVIDIA Container Toolkit（nvidia-docker）

验证 GPU 是否可被 Docker 识别：

```bash
docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi
```

如能正常输出 GPU 信息，则说明 GPU 容器环境配置成功。

## 镜像准备

### 拉取 MinerU 镜像

使用以下命令通过轩辕镜像访问支持域名拉取最新版本的 MinerU 镜像：

```bash
docker pull xxx.xuanyuan.run/alexsuntop/mineru:latest
```

验证镜像是否拉取成功：

```bash
docker images | grep mineru
```

若输出包含 `xxx.xuanyuan.run/alexsuntop/mineru:latest` 则说明镜像拉取成功。

### 查看可用镜像标签

如需指定特定版本的 MinerU 镜像，可访问 [MinerU 镜像标签列表（轩辕）](https://xuanyuan.cloud/r/alexsuntop/mineru/tags) 查看所有可用标签。拉取特定版本镜像的命令格式为：

```bash
docker pull xxx.xuanyuan.run/alexsuntop/mineru:{TAG}
```

将 `{TAG}` 替换为实际标签名称，例如拉取 1.0.0 版本：

```bash
docker pull xxx.xuanyuan.run/alexsuntop/mineru:1.0.0
```

## 🚀 5 分钟快速启动（推荐）

如果您希望最快体验 MinerU 的 vLLM 后端服务，可使用以下最小化启动命令（GPU 环境推荐）：

```bash
docker run -d \
  --name mineru-vllm \
  --restart unless-stopped \
  --gpus all \
  --ipc host \
  -p 30000:30000 \
  xxx.xuanyuan.run/alexsuntop/mineru:latest \
  mineru-vllm-server \
  --host 0.0.0.0 \
  --port 30000
```

启动完成后，使用以下命令验证服务是否正常：

```bash
curl http://localhost:30000/health
```

返回 HTTP 200 即表示服务正常运行。

> ⚠️ 提示
> 
> - 如未安装 NVIDIA Container Toolkit，请先完成 GPU 运行环境配置
> - 若仅使用 CPU，可移除 `--gpus all` 参数

## 容器部署

MinerU 提供三种主要服务模式，可根据实际需求选择部署：vLLM 后端服务、API 服务和 Gradio WebUI。以下分别介绍这三种服务的部署方法。

### 1. vLLM 后端服务部署

vLLM 后端服务是 MinerU 的核心组件，提供高性能的文档解析与处理能力。使用以下命令部署 vLLM 后端服务：

```bash
docker run -d \
  --name mineru-vllm-server \
  --restart unless-stopped \
  --ipc host \
  -p 30000:30000 \
  -e MINERU_MODEL_SOURCE=local \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  xxx.xuanyuan.run/alexsuntop/mineru:latest \
  mineru-vllm-server \
  --host 0.0.0.0 \
  --port 30000
```

命令参数说明：
- `-d`: 后台运行容器
- `--name mineru-vllm-server`: 指定容器名称为 mineru-vllm-server
- `--restart unless-stopped`: 除非手动停止，否则容器总是自动重启
- `--ipc host`: 使用主机的 IPC 命名空间，提高共享内存性能
- `-p 30000:30000`: 将容器的 30000 端口映射到主机的 30000 端口
- `-e MINERU_MODEL_SOURCE=local`: 设置模型来源为本地
- `--ulimit memlock=-1`: 禁用内存锁定限制
- `--ulimit stack=67108864`: 设置栈大小限制为 64MB

> ⚠️ GPU 说明  
> 若需启用 GPU，请在 `docker run` 命令中添加 `--gpus all` 参数；  
> 若未启用 GPU，相关显存与并行参数将不会生效。

对于多 GPU 环境，可添加 `--data-parallel-size` 参数以提高吞吐量：

```bash
docker run -d \
  --name mineru-vllm-server \
  --restart unless-stopped \
  --ipc host \
  -p 30000:30000 \
  -e MINERU_MODEL_SOURCE=local \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  xxx.xuanyuan.run/alexsuntop/mineru:latest \
  mineru-vllm-server \
  --host 0.0.0.0 \
  --port 30000 \
  --data-parallel-size 2
```

若在单 GPU 环境中遇到显存不足问题，可通过 `--gpu-memory-utilization` 参数调整显存利用率（取值范围 0-1）：

```bash
docker run -d \
  --name mineru-vllm-server \
  --restart unless-stopped \
  --ipc host \
  -p 30000:30000 \
  -e MINERU_MODEL_SOURCE=local \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  xxx.xuanyuan.run/alexsuntop/mineru:latest \
  mineru-vllm-server \
  --host 0.0.0.0 \
  --port 30000 \
  --gpu-memory-utilization 0.5
```

### 2. API 服务部署

API 服务提供 RESTful 接口，方便其他应用程序集成 MinerU 的文档处理能力。使用以下命令部署 API 服务：

```bash
docker run -d \
  --name mineru-api \
  --restart unless-stopped \
  --ipc host \
  -p 8000:8000 \
  -e MINERU_MODEL_SOURCE=local \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  xxx.xuanyuan.run/alexsuntop/mineru:latest \
  mineru-api \
  --host 0.0.0.0 \
  --port 8000
```

同样，可根据 GPU 配置添加相应参数：

```bash
docker run -d \
  --name mineru-api \
  --restart unless-stopped \
  --ipc host \
  -p 8000:8000 \
  -e MINERU_MODEL_SOURCE=local \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  xxx.xuanyuan.run/alexsuntop/mineru:latest \
  mineru-api \
  --host 0.0.0.0 \
  --port 8000 \
  --data-parallel-size 2 \
  --gpu-memory-utilization 0.5
```

### 3. Gradio WebUI 部署

Gradio WebUI 提供直观的图形界面，适合非技术用户使用 MinerU 的功能。使用以下命令部署 Gradio WebUI：

```bash
docker run -d \
  --name mineru-gradio \
  --restart unless-stopped \
  --ipc host \
  -p 7860:7860 \
  -e MINERU_MODEL_SOURCE=local \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  xxx.xuanyuan.run/alexsuntop/mineru:latest \
  mineru-gradio \
  --server-name 0.0.0.0 \
  --server-port 7860 \
  --enable-vllm-engine true
```

可根据需要添加其他参数，如限制转换页数：

```bash
docker run -d \
  --name mineru-gradio \
  --restart unless-stopped \
  --ipc host \
  -p 7860:7860 \
  -e MINERU_MODEL_SOURCE=local \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  xxx.xuanyuan.run/alexsuntop/mineru:latest \
  mineru-gradio \
  --server-name 0.0.0.0 \
  --server-port 7860 \
  --enable-vllm-engine true \
  --max-convert-pages 20 \
  --gpu-memory-utilization 0.5
```

## Docker Compose 部署（生产推荐）

对于生产环境，推荐使用 Docker Compose 管理多个服务。创建 `docker-compose.yml` 文件：

> ⚠️ Docker Compose 资源限制说明  
> `deploy.resources` 仅在 Docker Swarm 或 Kubernetes 环境中生效。  
> 普通 Docker Compose（docker compose up）请使用以下方式限制资源。

```yaml
version: '3.8'

x-default: &default
  restart: unless-stopped
  volumes:
    - /etc/localtime:/etc/localtime:ro
    - /etc/timezone:/etc/timezone:ro
  logging:
    driver: json-file
    options:
      max-size: 100m

x-mineru-vllm: &mineru-vllm
  <<: *default
  image: xxx.xuanyuan.run/alexsuntop/mineru:latest
  environment:
    MINERU_MODEL_SOURCE: local
  ulimits:
    memlock: -1
    stack: 67108864
  ipc: host
  # 普通 Docker Compose 资源限制（非 Swarm 模式）
  cpus: 4
  mem_limit: 16g

services:
  mineru-vllm-server:
    <<: *mineru-vllm
    container_name: mineru-vllm-server
    profiles: ["vllm-server"]
    ports:
      - 30000:30000
    entrypoint: mineru-vllm-server
    command:
      --host 0.0.0.0
      --port 30000
      # --data-parallel-size 2  # 多GPU环境下可启用
      # --gpu-memory-utilization 0.5  # 显存不足时可调整

  mineru-api:
    <<: *mineru-vllm
    container_name: mineru-api
    profiles: ["api"]
    ports:
      - 8000:8000
    entrypoint: mineru-api
    command:
      --host 0.0.0.0
      --port 8000
      # --data-parallel-size 2  # 多GPU环境下可启用
      # --gpu-memory-utilization 0.5  # 显存不足时可调整

  mineru-gradio:
    <<: *mineru-vllm
    container_name: mineru-gradio
    profiles: ["gradio"]
    ports:
      - 7860:7860
    entrypoint: mineru-gradio
    command:
      --server-name 0.0.0.0
      --server-port 7860
      --enable-vllm-engine true
      # --max-convert-pages 20  # 限制转换页数
      # --gpu-memory-utilization 0.5  # 显存不足时可调整
```

根据需要部署不同服务：

```bash
# 部署 vLLM 后端服务
docker compose --profile vllm-server up -d

# 部署 API 服务
docker compose --profile api up -d

# 部署 Gradio WebUI
docker compose --profile gradio up -d

# 部署所有服务
docker compose --profile vllm-server --profile api --profile gradio up -d
```

## 功能测试

### 验证容器状态

部署完成后，首先检查容器是否正常运行：

```bash
# 查看单个容器状态
docker ps --filter "name=mineru-vllm-server"
docker ps --filter "name=mineru-api"
docker ps --filter "name=mineru-gradio"

# 或使用 docker compose 查看
docker compose ps
```

正常运行的容器状态应为 "Up"。若状态异常，可通过日志排查问题：

```bash
docker logs mineru-vllm-server
docker logs mineru-api
docker logs mineru-gradio
```

### 测试 vLLM 后端服务

vLLM 后端服务提供健康检查接口，可通过以下命令测试：

```bash
curl -f http://localhost:30000/health || echo "服务未正常运行"
```

若返回状态码 200，则说明服务正常运行。

官方提供了专门的测试工具，可通过以下步骤进行更全面的测试：

1. 安装 mineru 客户端：

```bash
pip install mineru
```

2. 准备测试文档（如 demo.pdf），执行测试命令：

```bash
mineru -p demo.pdf -o ./output -b vlm-http-client -u http://localhost:30000
```

3. 查看输出目录 `./output`，若生成解析结果文件，则说明 vLLM 后端服务工作正常。

### 测试 API 服务

API 服务部署后，可通过 curl 或浏览器访问以下地址测试：

```bash
curl http://localhost:8000/health
```

若返回健康状态信息，则说明 API 服务正常运行。

### 测试 Gradio WebUI

Gradio WebUI 部署后，可通过浏览器访问以下地址：

```
http://localhost:7860
```

若能正常打开 MinerU 的 Web 界面，则说明 Gradio 服务部署成功。您可以上传测试文档并尝试解析功能，验证系统是否正常工作。

## 生产环境建议

### 硬件资源配置

MinerU 的性能很大程度上取决于硬件配置，特别是在处理大型文档或启用 AI 增强功能时。生产环境建议配置：

- CPU：至少 4 核心，推荐 8 核心或更高
- 内存：至少 8GB，推荐 16GB 或更高
- 存储：至少 20GB 可用空间，推荐使用 SSD 以提高性能
- GPU：如使用 AI 相关功能，推荐配备 NVIDIA GPU（至少 8GB 显存）

可根据实际负载情况调整资源配置。对于 Docker Swarm 或 Kubernetes 环境，可使用以下配置：

```yaml
deploy:
  resources:
    limits:
      cpus: '8.0'
      memory: 16G
    reservations:
      cpus: '4.0'
      memory: 8G
```

对于普通 Docker Compose 环境，请使用以下方式：

```yaml
services:
  mineru-vllm-server:
    image: xxx.xuanyuan.run/alexsuntop/mineru:latest
    cpus: 4
    mem_limit: 16g
```

### 数据持久化

为确保数据安全，建议将关键数据目录挂载到主机：

```bash
# 为 vLLM 服务添加数据持久化
docker run -d \
  --name mineru-vllm-server \
  # 其他参数...
  -v /path/on/host/models:/app/models \
  -v /path/on/host/cache:/app/cache \
  xxx.xuanyuan.run/alexsuntop/mineru:latest \
  mineru-vllm-server \
  # 其他参数...
  --model-path /app/models
```

对于 Docker Compose 部署，可在 `docker-compose.yml` 中添加卷挂载配置：

```yaml
services:
  mineru-vllm-server:
    <<: *mineru-vllm
    # 其他配置...
    volumes:
      - /path/on/host/models:/app/models
      - /path/on/host/cache:/app/cache
    # 其他配置...
```

### 安全配置

生产环境中，建议采取以下安全措施：

1. **使用非 root 用户运行容器**：在 Dockerfile 或运行时指定用户
2. **限制容器权限**：使用 `--cap-drop=ALL` 移除不必要的内核能力
3. **设置资源限制**：防止容器过度消耗资源
4. **使用环境变量管理敏感信息**：避免在命令行或配置文件中硬编码密码等敏感信息
5. **启用 TLS/SSL**：为 API 和 WebUI 服务配置 HTTPS

示例安全增强的运行命令：

```bash
docker run -d \
  --name mineru-vllm-server \
  --restart unless-stopped \
  --ipc host \
  -p 30000:30000 \
  -e MINERU_MODEL_SOURCE=local \
  -e MINERU_API_KEY=your_secure_api_key \
  --user 1000:1000 \
  --cap-drop=ALL \
  --cap-add=IPC_LOCK \
  --security-opt no-new-privileges \
  --memory=16g \
  --cpus=4 \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  -v /path/on/host/models:/app/models \
  -v /path/on/host/cache:/app/cache \
  xxx.xuanyuan.run/alexsuntop/mineru:latest \
  mineru-vllm-server \
  --host 0.0.0.0 \
  --port 30000
```

> 说明：  
> vLLM / PyTorch 在部分场景下需要 IPC_LOCK 能力以支持高性能共享内存。

### 监控与日志

为确保服务稳定运行，建议配置监控和日志收集：

1. **容器健康检查**：

```bash
docker run -d \
  --name mineru-vllm-server \
  # 其他参数...
  --health-cmd "curl -f http://localhost:30000/health || exit 1" \
  --health-interval 30s \
  --health-timeout 10s \
  --health-retries 3 \
  --health-start-period 60s \
  # 其他参数...
```

2. **集中式日志管理**：可考虑使用 ELK Stack、Graylog 或 Loki 等工具收集和分析日志

3. **性能监控**：可使用 Prometheus + Grafana 监控容器资源使用情况和应用性能指标

### 高可用部署

对于关键业务场景，建议部署多实例并配置负载均衡，以提高系统可用性：

1. **多实例部署**：部署多个 MinerU 实例，避免单点故障
2. **负载均衡**：使用 Nginx 或云服务提供商的负载均衡服务分发流量
3. **自动扩缩容**：在 Kubernetes 环境中，可配置 HPA (Horizontal Pod Autoscaler) 实现自动扩缩容

## 故障排查

### 常见问题及解决方法

#### 容器无法启动

若容器无法启动，首先查看容器日志：

```bash
docker logs mineru-vllm-server
```

常见原因及解决方法：

1. **端口冲突**：
   - 错误信息：`Bind for 0.0.0.0:30000 failed: port is already allocated`
   - 解决方法：更换主机端口或停止占用端口的其他服务

```bash
# 更换主机端口
docker run -d \
  --name mineru-vllm-server \
  -p 30001:30000 \  # 将主机端口改为 30001
  # 其他参数不变...
```

2. **资源不足**：
   - 错误信息：`no resources available to schedule container` 或内存溢出相关错误
   - 解决方法：增加系统资源或调整容器资源限制

3. **权限问题**：
   - 错误信息：`permission denied`
   - 解决方法：检查挂载目录权限或调整运行用户

#### 服务响应缓慢

1. **资源瓶颈**：
   - 检查容器资源使用情况：`docker stats mineru-vllm-server`
   - 解决方法：增加资源配额或优化应用配置

2. **GPU 相关问题**：
   - 若使用 GPU 功能，检查 GPU 驱动和 CUDA 版本是否兼容
   - 解决方法：更新 GPU 驱动或调整 `--gpu-memory-utilization` 参数

```bash
# 降低 GPU 内存利用率
docker run -d \
  --name mineru-vllm-server \
  # 其他参数...
  xxx.xuanyuan.run/alexsuntop/mineru:latest \
  mineru-vllm-server \
  --host 0.0.0.0 \
  --port 30000 \
  --gpu-memory-utilization 0.4  # 降低至 0.4 或更低
```

#### 文档解析失败

1. **文件格式不支持**：
   - 解决方法：检查文档格式是否在支持列表中，转换为支持的格式重试

2. **文件过大**：
   - 解决方法：拆分大型文档或调整配置以支持更大文件

```bash
# 增加最大转换页数限制
docker run -d \
  --name mineru-gradio \
  # 其他参数...
  xxx.xuanyuan.run/alexsuntop/mineru:latest \
  mineru-gradio \
  # 其他参数...
  --max-convert-pages 50  # 增加最大转换页数
```

### 日志查看与分析

MinerU 容器日志包含详细的运行信息，是排查问题的重要依据：

```bash
# 查看最新日志
docker logs mineru-vllm-server

# 实时查看日志
docker logs mineru-vllm-server -f

# 查看特定数量的日志
docker logs mineru-vllm-server --tail 100

# 查看指定时间段的日志
docker logs mineru-vllm-server --since 2023-11-01T00:00:00 --until 2023-11-02T00:00:00
```

对于 Docker Compose 部署：

```bash
# 查看所有服务日志
docker compose logs

# 查看特定服务日志
docker compose logs mineru-vllm-server

# 实时查看特定服务日志
docker compose logs -f mineru-vllm-server
```

### 镜像文档参考

若遇到其他问题，可参考 [MinerU 镜像文档（轩辕）](https://xuanyuan.cloud/r/alexsuntop/mineru) 获取更多信息。

## 参考资源

### 官方文档

- [MinerU 镜像文档（轩辕）](https://xuanyuan.cloud/r/alexsuntop/mineru)
- [MinerU 镜像标签列表](https://xuanyuan.cloud/r/alexsuntop/mineru/tags)

### Docker 相关资源

- [Docker 官方文档](https://docs.docker.com/)
- [Docker Compose 官方文档](https://docs.docker.com/compose/)
- [Docker Hub](https://hub.docker.com/)

### vLLM 相关资源

- [vLLM 官方 GitHub](https://github.com/vllm-project/vllm)
- [vLLM 文档](https://docs.vllm.ai/)

### Gradio 相关资源

- [Gradio 官方文档](https://www.gradio.app/docs)

## 总结

本文详细介绍了 MinerU 的 Docker 容器化部署方案，包括环境准备、镜像拉取、容器部署、功能测试、生产环境配置及故障排查等内容。通过容器化部署，用户可以快速搭建 MinerU 服务，充分利用其提供的 vLLM 后端服务、API 服务和 Gradio WebUI 等功能。

**关键要点**：

- 使用一键脚本可快速部署 Docker 环境，简化前期准备工作
- 轩辕镜像访问支持可改善镜像访问体验，镜像来源于官方公共仓库
- MinerU 提供三种服务模式（vLLM 后端、API 和 Gradio WebUI），可根据需求选择部署
- 生产环境中应注意资源配置、数据持久化、安全加固和监控等关键环节
- Docker Compose 是管理多服务部署的推荐方式，可简化复杂部署流程
- 遇到问题时，容器日志是排查故障的重要依据

**后续建议**：

- 深入学习 MinerU 高级特性，如自定义模型配置、批量处理优化等
- 根据业务需求调整资源配置参数，平衡性能与成本
- 建立完善的监控告警机制，及时发现并解决潜在问题
- 定期更新 MinerU 镜像，获取最新功能和安全修复
- 考虑在 Kubernetes 环境中部署，以获得更强大的编排和管理能力

通过本文提供的指南，相信您已能够顺利部署和使用 MinerU 容器化应用。如遇其他问题，建议参考官方文档或社区资源获取帮助。

