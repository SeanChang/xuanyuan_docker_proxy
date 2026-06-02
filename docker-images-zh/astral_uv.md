---
image: astral/uv
description: "uv（Python包管理器）的官方Docker镜像"
source: https://xuanyuan.cloud/zh/r/astral/uv
canonical: https://xuanyuan.cloud/zh/r/astral/uv
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/astral/uv" title="astral/uv Docker 镜像中文简介、标签列表与拉取命令">astral/uv 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# uv Docker 镜像文档


## 镜像概述与主要用途

uv 是由 Astral 开发的 Python 包和项目管理器，旨在提供高效的包安装、依赖解析及项目管理能力。本镜像为 uv 的官方 Docker 镜像，提供了 uv 的容器化部署方案，便于在容器环境中快速集成和使用 uv 管理 Python 项目及依赖。


## 核心功能与特性

- **预安装 uv 环境**：镜像中已内置 uv，无需手动安装即可直接使用。  
- **多版本与基础镜像支持**：提供基于不同 Python 版本（如 3.12）和基础镜像（如 Debian Bookworm slim）的变体，满足多样化环境需求。  
- **轻量级设计**：支持使用 slim 等轻量级基础镜像，减少容器体积，适合资源受限场景。  
- **灵活集成**：可通过复制二进制文件或直接作为基础镜像两种方式集成到现有 Docker 工作流中。  


## 使用场景与适用范围

- **容器化 Python 项目开发**：在本地或开发环境中，通过容器快速启动包含 uv 的环境，管理项目依赖。  
- **CI/CD 流程集成**：在持续集成/部署 pipeline 中，使用 uv 高效解析和安装依赖，加速构建过程。  
- **生产环境部署**：作为基础镜像构建 Python 应用容器，利用 uv 管理运行时依赖，确保环境一致性。  


## 使用方法与配置说明

### 1. 安装 uv 到现有镜像

通过复制 scratch 镜像中的 uv 二进制文件，将 uv 集成到自定义 Docker 镜像中：

```dockerfile
# 基于 Python 3.12 slim 基础镜像
FROM python:3.12-slim-bookworm
# 从 uv scratch 镜像复制 uv 和 uvx 二进制文件到 /bin 目录
COPY --from=docker.io/astral/uv:latest /uv /uvx /bin/
```


### 2. 使用预安装 uv 的基础镜像

直接使用已预安装 uv 的官方基础镜像，简化 Dockerfile 配置：

```dockerfile
# 使用预安装 uv 的 Python 3.12 Bookworm slim 镜像
FROM astral/uv:python3.12-bookworm-slim
```


### 3. 运行 uv 命令

通过预安装镜像直接运行 uv 命令，例如查看版本：

```bash
docker run -it --rm astral/uv:bookworm-slim uv --version
```


### 4. 镜像标签说明

uv Docker 镜像采用特定的标签方案，以区分不同 Python 版本、基础镜像类型（如 slim）及操作系统版本（如 Bookworm）。标签格式通常包含 Python 版本、基础镜像名称等信息（例如 `python3.12-bookworm-slim`）。  

详细标签说明请参考 [uv Docker 集成指南 - 可用镜像](https://docs.astral.sh/uv/guides/integration/docker/#available-images)。


## 参考链接

- [uv 官方文档](https://docs.astral.sh/uv/)  
- [uv Docker 集成指南](https://docs.astral.sh/uv/guides/integration/docker/)
