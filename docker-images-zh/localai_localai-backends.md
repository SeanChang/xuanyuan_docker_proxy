<!-- xuanyuan-docker-images-zh
image: localai/localai-backends
source: https://xuanyuan.cloud/zh/r/localai/localai-backends
canonical: https://xuanyuan.cloud/zh/r/localai/localai-backends
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/localai/localai-backends" title="localai/localai-backends Docker 镜像中文简介、标签列表与拉取命令">localai/localai-backends — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/localai/localai-backends" title="localai/localai-backends Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/localai/localai-backends</a></p>

# LocalAI 额外后端镜像 (extra-backends)

## 镜像概述和主要用途

本镜像是 LocalAI 的官方额外后端扩展，旨在为 LocalAI 提供更丰富的模型支持和推理能力。LocalAI 是一个开源的本地 AI 服务，兼容 OpenAI API 规范，允许用户在本地部署和运行 AI 模型。该镜像通过集成额外的推理后端和模型格式支持，扩展了 LocalAI 的功能边界，使用户能够在本地环境中运行更多类型、更多格式的 AI 模型。


## 核心功能和特性

### 多模型格式支持
- 扩展支持主流模型格式：GGUF、ONNX、TensorFlow SavedModel、PyTorch (.pth)、TensorRT 等
- 兼容社区常用模型格式（如 Hugging Face Hub 模型、自定义格式模型）

### 扩展推理引擎
- 集成多种推理引擎：llama.cpp（GGUF 格式支持）、ONNX Runtime（ONNX 模型加速）、TensorRT（NVIDIA GPU 优化）、TFLite（轻量级设备支持）
- 支持推理引擎动态切换，根据模型类型自动选择最优引擎

### 无缝集成 LocalAI
- 与 LocalAI 核心服务通过 REST API 或 gRPC 无缝通信
- 自动注册为 LocalAI 后端，无需手动配置模型路由

### 性能优化
- 支持模型量化（INT4/INT8）以降低资源占用
- 多后端并行处理，提升并发请求处理能力
- 内置模型缓存机制，减少重复加载开销


## 使用场景和适用范围

1. **多模型本地部署**  
   需要在本地环境运行多种格式（如 GGUF、ONNX、TensorFlow）AI 模型的场景，如个人工作站、实验室服务器。

2. **模型兼容性增强**  
   对模型格式兼容性要求高的用户，需支持社区新发布模型或自定义格式模型。

3. **推理性能优化**  
   边缘计算、本地服务器等资源受限环境，需通过扩展后端（如 TensorRT）提升推理速度。

4. **LocalAI 功能扩展**  
   开发者需扩展 LocalAI 原生不支持的后端能力，如添加 ONNX 模型推理支持。

5. **企业级本地 AI 服务**  
   企业内部部署需支持多团队、多模型类型的本地 AI 服务，需统一管理和扩展后端能力。


## 使用方法和配置说明

### 前提条件
- 已安装 Docker Engine（20.10+）
- 已部署 LocalAI 服务（版本需与本镜像兼容，建议 LocalAI v2.0+）
- 网络可访问 Docker Hub 或私有镜像仓库


### 1. 安装镜像

从 Docker Hub 拉取最新版本镜像：
```bash
docker pull localai/extra-backends:latest
```

如需指定版本，可替换 `latest` 为具体版本号（如 `v2.1.0`）。


### 2. 基本使用（Docker Run）

通过 `docker run` 启动额外后端服务，需指定与 LocalAI 的连接参数：

```bash
docker run -d \
  --name localai-extra-backends \
  -p 8081:8081 \  # 额外后端服务端口
  -e LOCALAI_URL=http://localai:8080 \  # LocalAI 核心服务地址（需与 LocalAI 容器网络互通）
  -e BACKENDS_ENABLED=llama.cpp,onnxruntime,tensorrt \  # 启用的后端列表，逗号分隔
  -e MODEL_CACHE_PATH=/models/cache \  # 模型缓存路径
  -v /host/models/cache:/models/cache \  # 挂载宿主机模型缓存目录（可选）
  localai/extra-backends:latest
```

**说明**：  
- 容器默认监听端口 `8081`，可通过 `-p` 映射到宿主机端口。  
- `LOCALAI_URL` 需指向 LocalAI 核心服务的 HTTP 地址（若与 LocalAI 共存在同一 Docker 网络，可使用容器名作为主机名，如 `http://localai:8080`）。  


### 3. Docker Compose 配置示例

与 LocalAI 核心服务联动部署时，推荐使用 `docker-compose.yml` 统一管理：

```yaml
version: '3.8'

services:
  localai:
    image: localai/localai:latest
    ports:
      - "8080:8080"
    environment:
      - MODELS_PATH=/models
      - DEBUG=true
    volumes:
      - ./localai/models:/models  # LocalAI 模型目录
    networks:
      - localai-net

  extra-backends:
    image: localai/extra-backends:latest
    ports:
      - "8081:8081"
    environment:
      - LOCALAI_URL=http://localai:8080  # 通过服务名访问 LocalAI 核心
      - BACKENDS_ENABLED=llama.cpp,onnxruntime  # 启用 llama.cpp 和 ONNX Runtime 后端
      - MODEL_CACHE_PATH=/models/cache
      - LOG_LEVEL=info  # 日志级别：debug/info/warn/error
    volumes:
      - ./extra-backends/cache:/models/cache  # 挂载宿主机缓存目录
    depends_on:
      - localai  # 确保 LocalAI 先启动
    networks:
      - localai-net

networks:
  localai-net:  # 自定义网络，确保服务间通信
```

启动服务：
```bash
docker-compose up -d
```


### 4. 环境变量配置

| 环境变量名             | 用途                                  | 默认值                  | 示例值                                  |
|------------------------|---------------------------------------|-------------------------|-----------------------------------------|
| `LOCALAI_URL`          | LocalAI 核心服务 HTTP 地址            | `http://localhost:8080` | `http://localai:8080`                   |
| `BACKENDS_ENABLED`     | 启用的后端列表（逗号分隔）            | `llama.cpp`             | `llama.cpp,onnxruntime,tensorrt`        |
| `MODEL_CACHE_PATH`     | 模型缓存目录（容器内路径）            | `/models/cache`         | `/data/models/extra-cache`              |
| `LOG_LEVEL`            | 日志级别                              | `info`                  | `debug`（调试）/`warn`（警告）          |
| `MAX_WORKERS`          | 后端处理线程数                        | CPU 核心数              | `8`（限制为 8 线程）                    |
| `GRPC_ENABLED`         | 是否启用 gRPC 通信（与 LocalAI 联动） | `false`                 | `true`（启用 gRPC 以提升性能）          |
| `GRPC_PORT`            | gRPC 服务端口（若启用）               | `50051`                 | `50052`                                 |
| `CACHE_TTL`            | 模型缓存过期时间（秒）                | `86400`（1 天）         | `3600`（1 小时）                        |


### 5. 验证服务状态

启动后，可通过以下命令检查额外后端是否注册到 LocalAI：

```bash
# 访问 LocalAI 的后端状态接口
curl http://localhost:8080/v1/backends
```

若返回包含 `llama.cpp`、`onnxruntime` 等后端信息，则表示集成成功。


## 注意事项

1. **版本兼容性**  
   本镜像版本需与 LocalAI 核心服务版本匹配（如 `extra-backends:v2.1.0` 需搭配 `localai:v2.1.0`），版本不匹配可能导致功能异常。

2. **模型文件准备**  
   额外后端依赖的模型文件需提前放置在 `MODEL_CACHE_PATH` 或 LocalAI 的 `MODELS_PATH` 中，或配置模型自动拉取（需 LocalAI 启用模型下载功能）。

3. **资源需求**  
   部分后端（如 TensorRT）依赖 NVIDIA GPU，需确保宿主机已安装 NVIDIA Docker 运行时（nvidia-docker），并通过 `--gpus all` 参数分配 GPU 资源。

4. **网络隔离**  
   若 LocalAI 与额外后端部署在不同网络，需确保 `LOCALAI_URL` 可访问，建议使用 Docker 自定义网络（如示例中的 `localai-net`）。


## 常见问题

- **Q：启用 TensorRT 后端后启动失败？**  
  A：检查是否安装 nvidia-docker，且宿主机 GPU 驱动版本支持 TensorRT 要求（参考 [TensorRT 官方文档](https://docs.nvidia.com/deeplearning/tensorrt/quick-start-guide/index.html)）。

- **Q：如何添加自定义后端？**  
  A：通过挂载自定义后端插件目录到容器 `/backends/plugins`，并在 `BACKENDS_ENABLED` 中添加插件名称（需符合 LocalAI 插件规范）。

- **Q：模型缓存目录占用过大如何清理？**  
  A：手动删除 `MODEL_CACHE_PATH` 下的过期模型文件，或通过设置 `CACHE_TTL` 自动清理过期缓存。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/localai/localai-backends" title="localai/localai-backends Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/localai/localai-backends</a></p>
