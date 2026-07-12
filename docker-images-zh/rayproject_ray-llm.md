---
image: rayproject/ray-llm
description: "面向开发者的就绪型Docker镜像，集成Ray框架与大语言模型，便于快速开展相关开发工作。"
source: https://xuanyuan.cloud/zh/r/rayproject/ray-llm
canonical: https://xuanyuan.cloud/zh/r/rayproject/ray-llm
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rayproject/ray-llm" title="rayproject/ray-llm Docker 镜像中文简介、标签列表与拉取命令">rayproject/ray-llm 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Ray LLM 开发者就绪 Docker 镜像

## 镜像概述和主要用途

本镜像是基于 [`rayproject/ray`](https://hub.docker.com/repository/docker/rayproject/ray) 的扩展 Docker 镜像，集成了使用 `ray[llm]` 所需的扩展依赖，旨在为开发者提供开箱即用的 Ray LLM（大语言模型）开发环境。镜像预配置了 Ray 及 LLM 相关工具链，可直接用于 LLM 应用的开发、调试与原型验证。

## 核心功能和特性

- **基于官方 Ray 镜像构建**：确保与 Ray 生态系统的兼容性，继承基础镜像的全部功能。
- **预集成 ray[llm] 依赖**：包含使用 `ray[llm]` 所需的扩展依赖，无需手动安装配置。
- **多版本支持**：提供稳定版、特定版本及每日构建版标签，满足不同开发需求。
- **GPU 支持**：通过 `-cu12x` 后缀标签提供 NVIDIA CUDA 支持，适配 GPU 加速场景。

## 使用场景和适用范围

- **LLM 应用开发**：需使用 Ray 框架进行大语言模型训练、推理、微调的开发者。
- **快速原型验证**：需要快速搭建 Ray LLM 环境，验证算法或应用逻辑的研究人员。
- **多环境适配**：支持 CPU 和 GPU 环境，适用于本地开发、实验室环境及 GPU 工作站。

## 详细使用方法和配置说明

### 镜像标签说明

镜像提供以下标签，用于指定不同版本和环境：

| 标签格式       | 说明                                                                 |
|----------------|----------------------------------------------------------------------|
| `:latest`      | 最新稳定版 Ray 镜像，包含最新 `ray[llm]` 依赖。                      |
| `:2.x.x`       | 特定版本 Ray 镜像（如 `:2.9.3`），对应 Ray 的历史稳定版本。           |
| `:nightly`     | 每日构建版，包含最新开发特性，适合需要尝鲜新功能的场景（稳定性较低）。|
| `:-cu12x`      | 基于 NVIDIA CUDA 12.x 构建的镜像（如 `:latest-cu12x`），需配合 GPU 使用。 |

### 部署示例

#### 1. CPU 环境运行

使用 `latest` 标签启动基本 Ray LLM 环境：

```bash
docker run -it --rm docker.xuanyuan.run/rayproject/ray-ml:latest
```

#### 2. GPU 环境运行（需 CUDA 支持）

使用 `-cu12x` 标签启动支持 GPU 的环境，需确保主机已安装 [Nvidia Docker Runtime](https://github.com/NVIDIA/nvidia-docker)：

```bash
docker run -it --rm --gpus all docker.xuanyuan.run/rayproject/ray-ml:latest-cu12x
```

#### 3. 指定特定版本

如需使用 Ray 2.9.3 版本：

```bash
docker run -it --rm docker.xuanyuan.run/rayproject/ray-ml:2.9.3
```

### 注意事项

- 使用 `-cu12x` 标签时，需确保主机 GPU 驱动与 CUDA 12.x 兼容，且已正确配置 Nvidia Docker Runtime，否则可能无法识别 GPU。
- `nightly` 标签镜像可能包含未稳定的功能，建议仅用于测试，生产环境推荐使用 `latest` 或特定版本标签。

## 许可证

本镜像遵循 [Apache-2.0 许可证](https://github.com/ray-project/ray/blob/master/LICENSE)。
