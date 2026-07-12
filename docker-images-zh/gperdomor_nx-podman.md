---
image: gperdomor/nx-podman
description: "@nx-tools/nx-container npm包的构建器辅助镜像，用于在Nx工作区中简化容器化构建流程，提供一致的构建环境和工具支持。"
source: https://xuanyuan.cloud/zh/r/gperdomor/nx-podman
canonical: https://xuanyuan.cloud/zh/r/gperdomor/nx-podman
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/gperdomor/nx-podman" title="gperdomor/nx-podman Docker 镜像中文简介、标签列表与拉取命令">gperdomor/nx-podman 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# @nx-tools/nx-container 构建器辅助镜像

## 镜像概述
本Docker镜像为@nx-tools/nx-container npm包提供构建器辅助功能，旨在简化Nx工作区（Nx Workspace）中的容器化构建流程。通过预配置构建环境与工具链，该镜像可无缝集成Nx任务执行机制，帮助开发者在Nx生态中高效完成应用的容器镜像构建、优化与打包。

## 核心功能与特性
- **环境一致性**：提供标准化的容器构建环境，避免因本地环境差异导致的构建不一致问题
- **Nx集成**：深度适配@nx-tools/nx-container包，支持Nx任务图（Task Graph）执行逻辑，兼容Nx缓存机制
- **工具链内置**：预安装容器构建所需工具（如Docker CLI、Buildx、QEMU等），减少外部依赖配置
- **构建优化**：支持多平台构建、层缓存优化等高级容器构建特性
- **轻量设计**：基于Alpine基础镜像，平衡功能与镜像体积

## 使用场景与适用范围
- Nx工作区中需要容器化部署的前端/后端应用构建
- 持续集成/持续部署（CI/CD）流程中的Nx容器构建环节
- 团队协作中需要统一容器构建标准的开发场景
- 需要多平台镜像构建（如amd64、arm64）的场景

## 使用方法与配置说明

### 基础使用示例（docker run）
```bash
docker run --rm \
  -v $(pwd):/workspace \
  -e NX_WORKSPACE=/workspace \
  -e BUILD_TARGET=my-app \
  -e DOCKER_REGISTRY=docker.io \
  docker.xuanyuan.run/nx-tools/nx-container-builder:latest
```

### docker-compose配置示例
```yaml
version: '3.8'
services:
  nx-container-builder:
    image: docker.xuanyuan.run/nx-tools/nx-container-builder:latest
    volumes:
      - ./:/workspace
      - /var/run/docker.sock:/var/run/docker.sock  # 如需本地Docker引擎构建
    environment:
      - NX_WORKSPACE=/workspace
      - BUILD_TARGET=my-app:production
      - NX_CACHE_DIRECTORY=/workspace/node_modules/.cache/nx
      - DOCKER_BUILD_ARGS=--no-cache
```

### 关键配置参数说明
| 参数名                | 描述                                  | 默认值                  |
|-----------------------|---------------------------------------|-------------------------|
| `NX_WORKSPACE`        | Nx工作区根目录路径                    | `/workspace`            |
| `BUILD_TARGET`        | 要构建的Nx目标（格式：`项目名:目标名`） | 无（必填）              |
| `NX_CACHE_DIRECTORY`  | Nx缓存目录路径                        | `/workspace/node_modules/.cache/nx` |
| `DOCKER_REGISTRY`     | 容器镜像推送目标仓库                  | `docker.io`             |
| `DOCKER_BUILD_ARGS`   | 额外Docker构建参数（空格分隔）        | `--progress=plain`      |

### 与Nx任务集成
在`workspace.json`或`project.json`中配置构建任务：
```json
{
  "targets": {
    "container-build": {
      "executor": "@nx-tools/nx-container:build",
      "options": {
        "builderImage": "nx-tools/nx-container-builder:latest",
        "buildArgs": ["--platform=linux/amd64"]
      }
    }
  }
}
```
执行构建命令：
```bash
nx run my-app:container-build
```

## 注意事项
- 本地开发时需挂载Docker套接字（`/var/run/docker.sock`）以使用主机Docker引擎
- 生产环境建议通过CI/CD管道集成，配合Nx Cloud实现分布式缓存
- 镜像标签应与@nx-tools/nx-container npm包版本保持一致以确保兼容性
