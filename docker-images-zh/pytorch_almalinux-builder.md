---
image: pytorch/almalinux-builder
description: "已安装conda的通用目的镜像，用于PyTorch的CI/CD流程。"
source: https://xuanyuan.cloud/zh/r/pytorch/almalinux-builder
canonical: https://xuanyuan.cloud/zh/r/pytorch/almalinux-builder
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/pytorch/almalinux-builder" title="pytorch/almalinux-builder Docker 镜像中文简介、标签列表与拉取命令">pytorch/almalinux-builder 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PyTorch CI/CD Conda 通用镜像文档


## 1. 镜像概述与主要用途
本镜像是一个预装 Conda 包管理器的通用基础镜像，专为 PyTorch 项目的 CI/CD（持续集成/持续部署）流程设计。其核心目标是提供标准化、可复现的运行环境，支持 PyTorch 项目在自动化流水线中快速完成环境配置、依赖安装、代码测试、模型构建等任务，简化跨平台/跨版本的环境一致性问题。


## 2. 核心功能与特性
- **预装 Conda 环境**：集成 Miniconda/Anaconda 包管理器，支持 Python 环境快速隔离与配置。
- **PyTorch 兼容性**：默认包含 PyTorch 基础依赖（如 CUDA 运行时，视镜像标签而定），可直接构建 PyTorch 开发/测试环境。
- **CI/CD 适配优化**：支持非交互式命令执行、轻量级启动，适配 Jenkins、GitHub Actions、GitLab CI 等主流 CI/CD 平台。
- **环境可定制化**：支持通过环境变量、配置文件或命令行扩展 Conda 环境，满足项目特定依赖需求。
- **跨版本支持**：提供多标签镜像（如 `py3.8-cuda11.7`、`py3.10-cuda12.1`），适配不同 Python/PyTorch/CUDA 版本组合。


## 3. 使用场景与适用范围
- **PyTorch 代码自动化测试**：在 CI 流程中执行单元测试、集成测试，验证代码兼容性。
- **模型训练/推理任务编排**：在 CD 流程中自动化执行模型训练、评估或推理任务。
- **多版本兼容性验证**：快速切换 Python/PyTorch/CUDA 版本，验证项目在不同环境下的稳定性。
- **轻量级开发环境**：临时搭建隔离的 PyTorch 开发/调试环境，避免本地环境污染。


## 4. 详细使用方法与配置说明

### 4.1 镜像拉取
从镜像仓库拉取指定版本（以 `py3.9-cuda11.8` 为例，具体标签需参考仓库实际提供的版本列表）：
```bash
docker pull docker.xuanyuan.run/[镜像仓库地址]/pytorch-ci-conda:py3.9-cuda11.8
# 示例：若为 Docker Hub 官方镜像，可能为 `pytorch/ci-conda:py3.9-cuda11.8`
```


### 4.2 基础运行命令
#### 4.2.1 交互式模式（调试/手动操作）
启动容器并进入交互式终端，用于手动配置环境或调试：
```bash
docker run -it --rm \
  docker.xuanyuan.run/[镜像仓库地址]/pytorch-ci-conda:py3.9-cuda11.8 \
  /bin/bash
```
- `-it`：启用交互式终端；`--rm`：退出后自动删除容器。


#### 4.2.2 非交互式执行命令（CI/CD 自动化）
直接在容器中执行命令（如运行测试脚本），适合 CI/CD 流水线集成：
```bash
docker run --rm \
  -v $(pwd):/workspace \  # 挂载本地项目目录到容器内 /workspace
  [镜像仓库地址]/pytorch-ci-conda:py3.9-cuda11.8 \
  bash -c "cd /workspace && python -m pytest tests/"  # 执行测试命令
```


### 4.3 环境变量配置
通过环境变量自定义容器行为，支持以下核心变量：

| 环境变量名          | 描述                          | 默认值              | 示例值                  |
|---------------------|-------------------------------|---------------------|-------------------------|
| `CONDA_ENV_NAME`    | 指定 Conda 环境名称           | `pytorch-ci-env`    | `my-project-env`        |
| `PYTHON_VERSION`    | 指定 Python 版本（需镜像支持）| `3.9`               | `3.10`                  |
| `PIP_REQUIREMENTS`  | 项目依赖文件路径（相对于 `/workspace`） | `requirements.txt` | `requirements-dev.txt` |
| `CUDA_VISIBLE_DEVICES` | 限制 GPU 可见性（需宿主机支持） | `all`               | `0,1`                   |


### 4.4 自定义 Conda 环境
#### 4.4.1 运行时安装依赖
通过 `conda install` 或 `pip install` 直接在容器内扩展环境：
```bash
docker run --rm \
  -v $(pwd):/workspace \
  -e CONDA_ENV_NAME=my-env \
  docker.xuanyuan.run/[镜像仓库地址]/pytorch-ci-conda:py3.9-cuda11.8 \
  bash -c "conda activate my-env && pip install -r /workspace/requirements.txt"
```

#### 4.4.2 通过 Dockerfile 扩展镜像
如需固化自定义环境，可基于本镜像构建新镜像：
```dockerfile
FROM docker.xuanyuan.run/[镜像仓库地址]/pytorch-ci-conda:py3.9-cuda11.8

# 创建并激活自定义环境
RUN conda create -n custom-env python=3.9 pytorch torchvision -c pytorch -y \
  && echo "conda activate custom-env" >> ~/.bashrc

# 安装额外依赖
COPY requirements.txt .
RUN conda run -n custom-env pip install -r requirements.txt
```


### 4.5 CI/CD 集成示例（GitHub Actions）
在 GitHub Actions 中集成镜像执行 PyTorch 测试：
```yaml
# .github/workflows/pytorch-test.yml
name: PyTorch CI Test
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run test with CI/CD conda image
        run: |
          docker run --rm \
            -v $(pwd):/workspace \
            -e PIP_REQUIREMENTS=requirements-test.txt \
            docker.xuanyuan.run/[镜像仓库地址]/pytorch-ci-conda:py3.9-cuda11.8 \
            bash -c "conda activate pytorch-ci-env && python -m pytest /workspace/tests/"
```


## 5. Docker 部署方案示例

### 5.1 `docker run` 命令示例
#### 示例 1：执行 PyTorch 模型训练脚本
```bash
docker run --rm \
  -v $(pwd):/workspace \
  -e CUDA_VISIBLE_DEVICES=0 \
  -e CONDA_ENV_NAME=train-env \
  docker.xuanyuan.run/[镜像仓库地址]/pytorch-ci-conda:py3.9-cuda11.8 \
  bash -c "conda activate train-env && python /workspace/train.py --epochs 10"
```

#### 示例 2：多依赖文件安装与测试
```bash
docker run --rm \
  -v $(pwd):/workspace \
  -e PIP_REQUIREMENTS=requirements-dev.txt \
  docker.xuanyuan.run/[镜像仓库地址]/pytorch-ci-conda:py3.10-cuda12.1 \
  bash -c "conda activate pytorch-ci-env && pip install -r /workspace/\$PIP_REQUIREMENTS && pytest /workspace/tests/ -v"
```


### 5.2 `docker-compose` 配置示例
通过 `docker-compose.yml` 定义服务，简化多步骤任务编排：
```yaml
# docker-compose.yml
version: '3.8'
services:
  pytorch-ci:
    image: docker.xuanyuan.run/[镜像仓库地址]/pytorch-ci-conda:py3.9-cuda11.8
    volumes:
      - ./:/workspace  # 挂载项目根目录
    environment:
      - CONDA_ENV_NAME=ci-test-env
      - PYTHON_VERSION=3.9
      - PIP_REQUIREMENTS=requirements.txt
    command: >
      bash -c "conda activate ci-test-env &&
               pip install -r /workspace/requirements.txt &&
               python -m pytest /workspace/tests/ --cov=src"
```
启动服务：
```bash
docker-compose up --build
```


## 6. 注意事项
- **镜像标签选择**：根据项目需求选择匹配的 Python/CUDA 版本标签，避免版本不兼容（如 CUDA 版本需与宿主机驱动匹配）。
- **权限管理**：挂载本地目录时，容器内默认使用 root 用户，可能导致生成文件的权限问题，建议通过 `--user $(id -u):$(id -g)` 映射本地用户 ID。
- **网络配置**：如需通过 Conda/Pip 安装额外依赖，确保容器网络通畅（可添加 `--network host` 共享宿主机网络）。
- **镜像缓存**：在 CI/CD 流程中建议启用 Docker 镜像缓存（如 GitHub Actions 的 `actions/cache`），加速镜像拉取。
