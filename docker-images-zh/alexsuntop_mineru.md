<!-- xuanyuan-docker-images-zh
image: alexsuntop/mineru
source: https://xuanyuan.cloud/zh/r/alexsuntop/mineru
canonical: https://xuanyuan.cloud/zh/r/alexsuntop/mineru
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/alexsuntop/mineru" title="alexsuntop/mineru Docker 镜像中文简介、标签列表与拉取命令">alexsuntop/mineru — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/alexsuntop/mineru" title="alexsuntop/mineru Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/alexsuntop/mineru</a></p>

# MinerU 镜像文档

## 镜像概述

MinerU镜像是基于[MinerU官方Dockerfile](https://github.com/opendatalab/MinerU/blob/master/docker/global/Dockerfile)构建的Docker镜像，用于快速部署vLLM后端服务器、文档解析API服务及Gradio WebUI界面。该镜像支持本地模型加载，提供灵活的CPU/GPU资源配置，适用于AI文档解析、本地LLM交互及开发测试场景。

## 核心功能和特性

- **多服务模式**：支持vLLM后端服务器、文档解析API服务、Gradio WebUI三种部署模式
- **本地模型支持**：通过`MINERU_MODEL_SOURCE=local`配置，支持加载本地模型文件
- **GPU优化配置**：支持NVIDIA GPU设备绑定，可配置多GPU并行及显存利用率
- **资源管控**：支持CPU/内存资源限制与预留设置，保障服务稳定运行
- **健康检查**：vLLM后端服务内置HTTP健康检查机制，监控服务可用性
- **时区同步**：挂载宿主机`/etc/localtime`和`/etc/timezone`，确保时间一致性

## 使用场景

- **本地AI文档处理**：通过Gradio WebUI实现可视化文档解析与LLM交互
- **vLLM后端测试**：部署独立vLLM服务器，作为本地LLM后端供开发调试
- **API服务集成**：通过mineru-api提供文档解析接口，集成至第三方应用系统
- **资源受限环境**：可调整CPU/内存/GPU资源参数，适配不同硬件条件

## 使用方法

### 服务启动

镜像通过Docker Compose管理，使用`--profile`参数指定启动的服务类型：

#### 1. vLLM后端服务器
启动基础vLLM后端服务，提供LLM推理能力：
```bash
docker compose --profile vllm-server up -d
```

#### 2. 文档解析API服务
启动文档解析API服务，开放接口供程序调用：
```bash
docker compose --profile api up -d
```

#### 3. Gradio WebUI
启动带Web界面的交互服务，支持可视化操作：
```bash
docker compose --profile gradio up -d
```

### 配置参数说明

#### 环境变量

| 变量名                | 说明                     | 默认值                          |
|-----------------------|--------------------------|---------------------------------|
| `MINERU_MODEL_SOURCE` | 模型来源                 | `local`（本地模型）             |
| `MINERU_DOCKER_IMAGE` | 镜像名称                 | `alexsuntop/mineru:latest`      |

#### 核心命令行参数

各服务支持通过`command`字段配置运行参数：

| 参数                          | 适用服务          | 说明                                  | 默认值         |
|-------------------------------|-------------------|---------------------------------------|----------------|
| `--host`                      | 所有服务          | 服务监听地址                          | `0.0.0.0`      |
| `--port`                      | 所有服务          | 服务监听端口                          | 30000（vLLM）、8000（API）、7860（Gradio） |
| `--data-parallel-size`        | 所有服务          | 多GPU并行数量（多GPU环境使用）        | 未启用         |
| `--gpu-memory-utilization`    | 所有服务          | GPU显存利用率（单GPU显存不足时降低）  | 未设置（默认1.0）|
| `--enable-vllm-engine`        | Gradio服务        | 是否启用vLLM引擎                     | `true`         |
| `--max-convert-pages`         | Gradio服务        | 文档最大转换页数限制                  | 未限制         |

#### 资源配置说明

在`docker-compose.yaml`的`deploy`字段中配置资源参数：

```yaml
deploy:
  resources:
    limits:          # 资源上限
      cpus: '8.0'    # 最大CPU核心数
      memory: 4G     # 最大内存
    reservations:    # 资源预留
      cpus: '2.0'    # 预留CPU核心数
      memory: 2G     # 预留内存
      devices:       # GPU设备配置
        - driver: nvidia
          device_ids: [ '0' ]  # GPU设备ID（多GPU用逗号分隔）
          capabilities: [ gpu ]
```

## 配置示例

### 多GPU并行配置
修改服务的`command`字段，启用2GPU并行：
```yaml
command:
  --host 0.0.0.0
  --port 30000
  --data-parallel-size 2  # 启用2GPU并行
```

### 显存优化配置
单GPU显存不足时，降低显存利用率：
```yaml
command:
  --host 0.0.0.0
  --port 7860
  --gpu-memory-utilization 0.4  # 显存利用率调整为40%
```

### 测试vLLM后端服务
安装mineru客户端测试已启动的vLLM服务：
```bash
pip install mineru
mineru -p demo.pdf -o ./output -b vlm-http-client -u http://localhost:30000
```

## 服务端口说明

| 服务类型           | 容器端口 | 宿主机映射端口 | 说明                |
|--------------------|----------|----------------|---------------------|
| vLLM后端服务器     | 30000    | 30000          | vLLM服务通信端口    |
| 文档解析API服务    | 8000     | 8000           | API接口访问端口     |
| Gradio WebUI       | 7860     | 7860           | Web界面访问端口     |

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/alexsuntop/mineru" title="alexsuntop/mineru Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/alexsuntop/mineru</a></p>
