---
image: condaforge/miniforge3
description: "包含conda-forge的miniforge3安装程序的容器镜像，基于最小化Ubuntu构建，支持多架构。"
source: https://xuanyuan.cloud/zh/r/condaforge/miniforge3
canonical: https://xuanyuan.cloud/zh/r/condaforge/miniforge3
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/condaforge/miniforge3" title="condaforge/miniforge3 Docker 镜像中文简介、标签列表与拉取命令">condaforge/miniforge3 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Miniforge3 Docker镜像

## 概述
基于最小化Ubuntu安装的Docker容器，预安装conda-forge提供的[miniforge3](https://github.com/conda-forge/miniforge)安装程序，安装路径为`/opt/conda`。该镜像提供轻量级环境，便于快速部署包含miniforge3的开发或运行时场景。

## 核心信息
- **基础系统**：最小化Ubuntu操作系统
- **预安装组件**：conda-forge的miniforge3安装程序（路径：`/opt/conda`）
- **支持架构**：`amd64`、`arm64`、`ppc64le`
- **标签说明**：镜像标签与官方miniforge发布标签一致，可直接通过发布版本号拉取对应镜像
- **构建代码**：托管于GitHub仓库 [conda-forge/miniforge-images](https://github.com/conda-forge/miniforge-images)

## Docker部署方案示例
### 1. 拉取镜像
```bash
docker pull docker.xuanyuan.run/condaforge/miniforge3:latest  # 拉取最新版本
# 或指定具体版本，如 docker pull docker.xuanyuan.run/condaforge/miniforge3:23.11.0-0
```

### 2. 运行容器
```bash
docker run -it --rm docker.xuanyuan.run/condaforge/miniforge3:latest /bin/bash
```
> 参数说明：`-it` 启用交互终端，`--rm` 容器退出后自动删除

### 3. 验证安装
进入容器后，通过以下命令确认miniforge3安装状态：
```bash
/opt/conda/bin/conda --version  # 输出conda版本信息，如 conda 23.11.0
```
