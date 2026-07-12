---
image: mambaorg/micromamba
description: "使用micromamba在容器中快速构建小型基于conda的环境"
source: https://xuanyuan.cloud/zh/r/mambaorg/micromamba
canonical: https://xuanyuan.cloud/zh/r/mambaorg/micromamba
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mambaorg/micromamba" title="mambaorg/micromamba Docker 镜像中文简介、标签列表与拉取命令">mambaorg/micromamba 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# micromamba-docker 镜像文档

## 1. 镜像概述和主要用途

micromamba-docker 是基于 [Micromamba](https://github.com/mamba-org/mamba#micromamba) 的 Docker 镜像，旨在快速构建轻量级的 conda 环境容器。Micromamba 是 mamba-org 开发的轻量级包管理器，作为 conda 的高效替代方案，提供更快的依赖解析和包安装速度。该镜像适用于需要小型化、快速部署的 conda 环境容器化场景。

镜像托管地址：
- Docker Hub: [mambaorg/micromamba](https://hub.docker.com/r/mambaorg/micromamba)
- GitHub Container Registry (GHCR): [ghcr.io/mamba-org/micromamba](https://github.com/mamba-org/micromamba-docker/pkgs/container/micromamba)

源码仓库：[mamba-org/micromamba-docker](https://github.com/mamba-org/micromamba-docker/)

用户反馈："我将项目 CI 切换到 micromamba，与使用 miniconda 镜像相比，构建时间减少了超过 2 倍" —— 一位新用户

## 2. 核心功能和特性

- **构建速度快**：依赖 Micromamba 的高效依赖解析引擎，容器构建时间较传统 miniconda 镜像缩短 2 倍以上
- **镜像体积小**：基于精简基础镜像（如 Debian Slim、Alpine），显著降低最终容器体积
- **多版本支持**：提供 Micromamba 版本化标签（如 `2.3.2`、`2.3`、`2`）及开发版标签（如 `git-fb21d17`）
- **多基础系统适配**：支持 Debian、Ubuntu、Alpine、Amazon Linux 等多种基础系统
- **CUDA 集成**：提供预配置 CUDA 环境的镜像变体，支持 GPU 加速应用部署
- **conda 兼容性**：完全兼容 conda 包管理生态，可无缝迁移现有 conda 环境配置

## 3. 使用场景和适用范围

- **CI/CD 流水线**：在持续集成流程中快速构建一致性 conda 环境，提升构建效率
- **开发环境标准化**：为团队提供统一的 conda 开发环境，消除"本地环境差异"问题
- **轻量级生产部署**：适用于对容器体积敏感的生产环境，减少资源占用
- **GPU 应用开发**：通过 CUDA 标签变体部署机器学习、科学计算等 GPU 加速应用
- **多平台适配**：满足不同基础系统需求（Alpine 极小体积/ Debian/Ubuntu 兼容性优先）

## 4. 镜像标签说明

镜像提供丰富的标签变体，按基础系统和功能特性分类如下：

### 4.1 基础系统标签

| 基础系统       | 主要标签示例                                                                 | Dockerfile 链接                                                                 |
|----------------|-----------------------------------------------------------------------------|--------------------------------------------------------------------------------|
| Debian Slim    | `latest`, `debian13-slim`, `debian-slim`, `2.3.2`, `2.3`, `2`              | [debian.Dockerfile](https://github.com/mamba-org/micromamba-docker/blob/main/debian.Dockerfile) |
| Debian         | `debian13`, `debian`, `2.3.2-debian13`, `2.3-debian13`                     | [debian.Dockerfile](https://github.com/mamba-org/micromamba-docker/blob/main/debian.Dockerfile) |
| Ubuntu         | `ubuntu25.04`, `ubuntu24.04`, `ubuntu22.04`, `ubuntu20.04`, `ubuntu`       | [debian.Dockerfile](https://github.com/mamba-org/micromamba-docker/blob/main/debian.Dockerfile) |
| Alpine         | `alpine3.21`, `alpine`, `alpine3.19`, `alpine3.18`, `2.3.2-alpine3.21`     | [alpine.Dockerfile](https://github.com/mamba-org/micromamba-docker/blob/main/alpine.Dockerfile) |
| Amazon Linux   | `amazon2023`, `amazon`, `2.3.2-amazon2023`, `2.3-amazon2023`               | [fedora.Dockerfile](https://github.com/mamba-org/micromamba-docker/blob/main/fedora.Dockerfile) |

### 4.2 CUDA 环境标签

提供多种 CUDA 版本与 Ubuntu 系统组合，支持 GPU 加速应用：

| CUDA 版本    | 兼容 Ubuntu 版本       | 主要标签示例                                                                 |
|--------------|------------------------|-----------------------------------------------------------------------------|
| CUDA 13.0.0  | 24.04, 22.04           | `cuda13.0.0-ubuntu24.04`, `cuda`, `2.3.2-cuda13.0.0-ubuntu24.04`            |
| CUDA 12.9.1  | 24.04, 22.04, 20.04    | `cuda12.9.1-ubuntu24.04`, `2.3.2-cuda12.9.1-ubuntu22.04`                    |
| CUDA 12.8.1  | 24.04, 22.04, 20.04    | `cuda12.8.1-ubuntu24.04`, `2.3.2-cuda12.8.1-ubuntu22.04`                    |
| CUDA 12.6.3  | 24.04, 22.04, 20.04    | `cuda12.6.3-ubuntu24.04`, `2.3.2-cuda12.6.3-ubuntu22.04`                    |
| CUDA 11.x    | 22.04, 20.04           | `cuda11.7.1-ubuntu22.04`, `cuda11.8.0-ubuntu20.04`, `cuda11.4.3-ubuntu20.04` |

### 4.3 标签命名规则

标签采用以下格式组合：`[micromamba版本]-[基础系统/特性]`，例如：
- 特定版本：`2.3.2-debian13-slim`（Micromamba 2.3.2 + Debian 13 Slim）
- 主版本族：`2-debian13-slim`（Micromamba 2.x + Debian 13 Slim）
- 开发版本：`git-fb21d17-debian13-slim`（基于 Git commit fb21d17 的开发构建）

## 5. 使用方法和配置说明

### 5.1 基础运行

#### 5.1.1 交互式 shell

启动包含默认 `base` 环境的交互式容器：

```bash
docker run -it --rm docker.xuanyuan.run/mambaorg/micromamba
```

#### 5.1.2 执行命令

直接在容器中运行 Micromamba 命令（如查看版本）：

```bash
docker run --rm docker.xuanyuan.run/mambaorg/micromamba micromamba --version
```

### 5.2 构建自定义镜像

通过 Dockerfile 扩展基础镜像，添加自定义依赖：

#### 5.2.1 简单依赖安装

```dockerfile
FROM docker.xuanyuan.run/mambaorg/micromamba:2.3.2-debian13-slim

# 切换到默认非 root 用户（micromamba）
USER micromamba

# 创建并激活自定义环境
RUN micromamba create -n myenv python=3.11 numpy pandas -y && \
    micromamba clean -afy  # 清理缓存减小体积

# 设置默认环境
ENV MAMBA_DEFAULT_ENV=myenv
# 将环境二进制路径添加到 PATH
ENV PATH="/opt/conda/envs/myenv/bin:$PATH"
```

#### 5.2.2 使用 environment.yml

通过 `environment.yml` 批量定义环境：

```dockerfile
FROM docker.xuanyuan.run/mambaorg/micromamba:latest

# 复制环境配置文件
COPY environment.yml /tmp/

# 创建环境并清理缓存
RUN micromamba env create -f /tmp/environment.yml && \
    micromamba clean -afy

# 激活环境
ENV MAMBA_DEFAULT_ENV=myenv
ENV PATH="/opt/conda/envs/myenv/bin:$PATH"
```

### 5.3 环境变量配置

镜像支持以下环境变量自定义行为：

| 环境变量             | 描述                          | 默认值                  |
|----------------------|-------------------------------|-------------------------|
| `MAMBA_ROOT_PREFIX`  | Micromamba 根目录路径         | `/opt/conda`            |
| `MAMBA_DEFAULT_ENV`  | 默认激活的环境名称            | `base`                  |
| `MAMBA_USER`         | 运行用户名称                  | `micromamba`            |
| `MAMBA_USER_ID`      | 用户 UID                      | `1000`                  |
| `MAMBA_USER_GID`     | 用户组 GID                    | `1000`                  |

### 5.4 自定义 Conda Channels

添加额外 channels 或调整优先级：

```dockerfile
FROM docker.xuanyuan.run/mambaorg/micromamba:latest

USER micromamba

# 配置 conda-forge 为优先 channel
RUN micromamba config set channels conda-forge && \
    micromamba config set channel_priority strict && \
    micromamba install -y python=3.11 && \
    micromamba clean -afy
```

## 6. 部署方案示例

### 6.1 Docker Compose 配置（开发环境）

`docker-compose.yml`:

```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    image: docker.xuanyuan.run/myapp-micromamba:latest
    volumes:
      - ./src:/app  # 挂载本地代码目录
    environment:
      - MAMBA_DEFAULT_ENV=dev
      - PYTHONUNBUFFERED=1  # Python 实时输出日志
    command: python /app/main.py
```

配套 `Dockerfile`:

```dockerfile
FROM docker.xuanyuan.run/mambaorg/micromamba:2.3.2-ubuntu22.04

# 复制环境配置
COPY environment.yml /tmp/

# 创建开发环境
RUN micromamba env create -f /tmp/environment.yml && \
    micromamba clean -afy

# 配置环境变量
ENV MAMBA_DEFAULT_ENV=dev
ENV PATH="/opt/conda/envs/dev/bin:$PATH"

WORKDIR /app
```

### 6.2 GPU 应用部署（CUDA 环境）

使用 CUDA 标签部署 GPU 加速应用（需主机安装 [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)）：

```bash
# 拉取 CUDA 12.8.1 + Ubuntu 22.04 镜像
docker pull docker.xuanyuan.run/mambaorg/micromamba:cuda12.8.1-ubuntu22.04

# 启动带 GPU 支持的交互式容器
docker run --gpus all -it --rm docker.xuanyuan.run/mambaorg/micromamba:cuda12.8.1-ubuntu22.04

# 在容器内安装 PyTorch（示例）
micromamba install -c pytorch pytorch torchvision torchaudio cudatoolkit=12.1 -y
```

## 7. 参考文档

- 官方文档与 FAQ: [micromamba-docker.readthedocs.io](https://micromamba-docker.readthedocs.io/)
- Micromamba 官方文档: [github.com/mamba-org/mamba#micromamba](https://github.com/mamba-org/mamba#micromamba)
- 镜像源码仓库: [github.com/mamba-org/micromamba-docker](https://github.com/mamba-org/micromamba-docker/)
