---
image: okteto/python
description: "该镜像包含用于与Okteto CLI配合使用的Python开发环境，Okteto是面向开发者的Kubernetes工具。"
source: https://xuanyuan.cloud/zh/r/okteto/python
canonical: https://xuanyuan.cloud/zh/r/okteto/python
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/okteto/python" title="okteto/python Docker 镜像中文简介、标签列表与拉取命令">okteto/python 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Python-Okteto 开发环境镜像文档


## 一、镜像概述和主要用途

本镜像是一个集成 [Okteto CLI](https://github.com/okteto/okteto) 的 Python 开发环境，基于 [Okteto](https://okteto.com/)（面向开发者的 Kubernetes 平台）构建。主要用途是为 Python 应用提供便捷的本地-集群协同开发环境，支持代码同步、实时调试和 Kubernetes 环境下的快速验证，适用于微服务开发、集群化应用调试等场景。


## 二、核心功能和特性

### 1. 环境集成
- 预装 Python 运行环境（常规支持 Python 3.8+ 版本，具体以镜像标签为准，如 `3.9`, `3.10`）
- 内置 Okteto CLI 工具，无需额外安装即可使用 Okteto 开发功能（如 `okteto up`、`okteto sync`）

### 2. 开发协同能力
- 支持 Okteto 双向文件同步（本地代码与 Kubernetes 集群容器实时同步）
- 集成 Kubernetes 端口转发、服务发现功能，可直接访问集群内依赖服务
- 兼容 Okteto 开发工作流（如 `okteto deploy` 快速部署、`okteto logs` 日志查看）

### 3. 轻量与灵活
- 基于轻量级基础镜像（如 Alpine 或 Debian Slim），减少资源占用
- 支持自定义 Python 依赖（通过 `requirements.txt` 或 `pyproject.toml` 动态安装）
- 可通过环境变量、配置文件调整运行参数，适配不同项目需求

### 4. 兼容性
- 兼容标准 Docker 命令及 Kubernetes 环境
- 支持多阶段构建，可作为开发阶段基础镜像集成到 CI/CD 流程


## 三、使用场景和适用范围

### 典型场景
- **Python 微服务开发**：在 Kubernetes 集群环境下开发 Python 微服务，实现本地代码修改实时同步到集群容器
- **集群化应用调试**：通过 Okteto 端口转发和日志功能，直接调试运行在 Kubernetes 中的 Python 应用
- **团队统一开发环境**：标准化开发工具链（Python 版本、Okteto 配置），减少"本地环境不一致"问题
- **CI/CD 前置开发阶段**：作为开发环境集成到流水线，支持代码提交前的集群化验证

### 适用范围
- Python 3.x 应用开发（具体版本需匹配镜像标签）
- 基于 Kubernetes 的容器化应用开发团队
- 需要本地-集群环境实时协同的开发流程


## 四、使用方法和配置说明

### 1. 基本使用

#### 拉取镜像
```bash
docker pull docker.xuanyuan.run/[镜像仓库地址]/python-okteto-dev:[标签]  # 例如：docker pull docker.xuanyuan.run/okteto/python:3.10-okteto
```

#### 基本运行（本地开发模式）
```bash
docker run -it --name python-okteto-dev \
  -v $(pwd):/app  # 挂载本地代码目录到容器内/app
  -p 8080:8080    # 端口映射（按需调整）
  [镜像名称]:[标签] \
  /bin/bash       # 启动交互式终端
```


### 2. 集成 Okteto CLI 配置

#### 前提条件
- 本地已安装 Okteto CLI（可通过容器内预装的 CLI 或 [官方文档](https://www.okteto.com/docs/getting-started/install) 安装）
- 已配置 Kubernetes 集群访问权限（`kubectl` 可用）


#### 配置 okteto.yml（项目根目录）
创建 Okteto 配置文件定义开发环境，示例：
```yaml
# okteto.yml
name: python-app          # 开发环境名称
image: docker.xuanyuan.run/[镜像名称]:[标签]   # 使用当前开发镜像
workdir: /app             # 容器内工作目录
command: python app.py    # 应用启动命令（开发阶段可替换为调试命令，如 `python -m debugpy --listen 0.0.0.0:5678 app.py`）
sync:
  - .:/app                # 本地目录与容器目录同步（双向同步）
forward:
  - 8080:8080             # 本地端口:容器端口（应用端口）
  - 5678:5678             # 调试端口（如使用 debugpy）
environment:
  - PYTHONPATH=/app/lib   # Python 依赖路径
  - LOG_LEVEL=debug       # 应用日志级别
```


#### 启动 Okteto 开发环境
在项目根目录执行：
```bash
okteto up  # 启动开发环境，自动同步代码并转发端口
```

#### 常用 Okteto 命令（容器内或本地执行）
- `okteto sync`：手动触发代码同步
- `okteto logs`：查看容器日志
- `okteto down`：停止开发环境并清理资源


### 3. 环境变量配置

容器支持通过环境变量调整行为，常见配置（具体以镜像实际支持为准）：

| 环境变量名          | 说明                          | 默认值示例       |
|---------------------|-------------------------------|------------------|
| `PYTHON_VERSION`    | Python 版本（容器内预装版本） | `3.10`           |
| `OKTETO_SYNC_MODE`  | 文件同步模式（双向/单向）     | `bidirectional`  |
| `WORKDIR`           | 容器内工作目录                | `/app`           |
| `PYTHONPATH`        | Python 模块搜索路径           | `/app:/usr/local/lib/python3.10/site-packages` |
| `DEBUG_PORT`        | 调试端口（如 debugpy 使用）   | `5678`           |


### 4. Docker Compose 示例

创建 `docker-compose.yml` 简化本地开发环境启动：
```yaml
version: '3.8'
services:
  python-dev:
    image: docker.xuanyuan.run/[镜像名称]:[标签]
    volumes:
      - ./:/app:cached  # 本地代码目录挂载（cached 模式优化性能）
    ports:
      - "8080:8080"     # 应用端口
      - "5678:5678"     # 调试端口
    environment:
      - PYTHONPATH=/app
      - LOG_LEVEL=debug
    command: okteto up  # 直接启动 Okteto 开发环境
```

启动命令：
```bash
docker-compose up -d  # 后台启动服务
docker-compose exec python-dev /bin/bash  # 进入容器终端
```


### 5. 自定义 Python 依赖

在项目根目录创建 `requirements.txt`，容器启动时自动安装依赖（需确保启动命令包含安装步骤，或通过 Okteto 配置触发）：
```txt
# requirements.txt
flask==2.0.1
requests==2.26.0
```

在 `okteto.yml` 中添加依赖安装命令：
```yaml
# okteto.yml（片段）
command: |
  pip install -r requirements.txt &&  # 安装依赖
  python app.py                      # 启动应用
```


## 五、注意事项

- 镜像标签通常包含 Python 版本（如 `3.10-okteto`），请根据项目需求选择匹配标签
- 本地代码目录挂载时，避免覆盖容器内预装依赖（建议挂载到独立工作目录如 `/app`）
- Okteto 同步功能依赖集群网络，请确保本地与 Kubernetes 集群网络通畅
- 生产环境请勿直接使用本镜像，建议仅作为开发阶段环境，生产环境使用精简的 Python 运行时镜像（如 `python:3.10-slim`）
