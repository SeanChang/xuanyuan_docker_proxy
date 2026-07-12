---
image: polyaxon/polyaxon-core
description: "用于内部构建和开发工作的Docker镜像，支持团队内部的开发环境搭建与构建流程执行。"
source: https://xuanyuan.cloud/zh/r/polyaxon/polyaxon-core
canonical: https://xuanyuan.cloud/zh/r/polyaxon/polyaxon-core
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/polyaxon/polyaxon-core" title="polyaxon/polyaxon-core Docker 镜像中文简介、标签列表与拉取命令">polyaxon/polyaxon-core 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 镜像概述
本镜像专为内部构建和开发工作设计，旨在提供稳定、一致的开发环境，支持团队内部的开发、测试及构建任务，简化开发流程并确保环境一致性，满足内部团队的开发协作需求。

## 核心功能与特性
- 提供内部开发所需的基础运行环境及工具链，适配团队技术栈
- 支持内部项目的构建流程，包括代码编译、依赖管理等任务
- 确保开发环境一致性，减少因环境差异导致的开发问题
- 简化内部开发团队的环境配置流程，降低环境搭建成本

## 使用场景与适用范围
- 内部开发团队日常开发工作，提供统一的开发环境
- 内部项目的构建流程执行，支持自动化构建任务
- 团队协作开发时的环境共享，确保各成员开发环境一致
- 内部测试环境的快速部署与复用

## 使用方法与配置说明
### 镜像拉取
从内部镜像仓库拉取最新版本：
```bash
docker pull docker.xuanyuan.run/[内部仓库地址]/internal-dev:latest
```

### 容器运行
基本运行命令（交互式终端）：
```bash
docker run -it --name internal-dev-container docker.xuanyuan.run/[内部仓库地址]/internal-dev:latest /bin/bash
```

### 环境配置
根据内部项目需求，可通过以下方式自定义配置：
- **挂载本地目录**：将本地开发目录挂载至容器内，实现代码实时同步：
  ```bash
  docker run -it -v /本地开发路径:/app docker.xuanyuan.run/[内部仓库地址]/internal-dev:latest /bin/bash
  ```
- **环境变量**：通过`-e`参数设置环境变量，具体变量需参考内部项目文档，例如：
  ```bash
  docker run -it -e DEV_MODE=debug -e PROJECT_ID=internal-001 docker.xuanyuan.run/[内部仓库地址]/internal-dev:latest /bin/bash
  ```

### 注意事项
- 本镜像为内部专用，需通过内部权限访问镜像仓库
- 具体工具版本及配置细节请参考内部开发文档
- 容器运行前请确保本地Docker环境已配置内部仓库访问权限

## 维护与更新
- 镜像更新由内部DevOps团队负责，更新日志将同步至内部文档系统
- 建议定期拉取最新镜像以获取最新开发工具及安全更新
