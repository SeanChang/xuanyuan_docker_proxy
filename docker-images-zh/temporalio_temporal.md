---
image: temporalio/temporal
description: "Temporal的命令行界面与开发服务器，用于Temporal工作流平台的命令行操作及开发环境搭建。"
source: https://xuanyuan.cloud/zh/r/temporalio/temporal
canonical: https://xuanyuan.cloud/zh/r/temporalio/temporal
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/temporalio/temporal" title="temporalio/temporal Docker 镜像中文简介、标签列表与拉取命令">temporalio/temporal 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Temporal CLI Docker镜像文档

## 镜像概述和主要用途

Temporal CLI Docker镜像是Temporal命令行界面（CLI）的容器化分发形式，提供通过终端直接访问Temporal Service的能力。该镜像主要用于管理、监控和调试Temporal应用，支持工作流（Workflow）与活动（Activity）的全生命周期操作，同时集成嵌入式Temporal开发服务器，适用于本地开发和CI/CD环境快速部署Temporal服务。


## 核心功能和特性

### 核心功能
- **工作流与活动管理**：支持启动、停止、检查工作流和活动的执行状态
- **资源管理**：执行命名空间（Namespace）、调度（Schedule）、任务队列（Task Queue）等管理任务
- **服务交互**：通过终端直接与Temporal Service通信，执行监控和调试操作

### 主要特性
- **嵌入式Temporal Service**：内置可独立运行的Temporal服务，无需额外依赖
- **完整组件集成**：包含Temporal Server核心服务、SQLite轻量级持久化存储及Temporal Web UI
- **开发优化**：针对本地开发和CI/CD场景设计，支持快速启动和简化配置


## 使用场景和适用范围

### 适用场景
- **本地开发环境**：开发者在本地启动Temporal服务，测试Temporal应用的工作流逻辑
- **CI/CD流程**：集成到自动化测试 pipeline，提供临时Temporal服务环境验证应用功能
- **日常运维**：通过CLI执行Temporal资源的日常管理操作

### 适用范围
- Temporal应用开发者（本地开发、调试工作流/活动）
- 测试工程师（CI/CD环境集成测试）
- 运维人员（Temporal资源管理）


## 使用方法和配置说明

### 基础CLI命令使用

镜像入口点已设置为Temporal CLI，可直接通过`docker run`执行命令。例如查看帮助信息：

```bash
docker run --rm docker.xuanyuan.run/temporalio/temporal --help
```

### 开发服务器启动（带端口映射）

启动嵌入式开发服务器时，需配置端口映射以允许主机访问，并指定绑定IP（默认仅监听容器内回环地址）：

```bash
docker run --rm -p 7233:7233 -p 8233:8233 docker.xuanyuan.run/temporalio/temporal:latest server start-dev --ip 0.0.0.0
```

#### 参数说明
- `-p 7233:7233`：映射Temporal服务端口（默认服务端口）
- `-p 8233:8233`：映射Temporal Web UI端口（默认Web UI端口）
- `server start-dev`：启动开发模式服务器
- `--ip 0.0.0.0`：指定服务绑定IP为0.0.0.0，允许外部主机访问（必选，否则主机无法连接容器内服务）


## 配置参数说明

### 开发服务器核心参数
- `--ip <address>`：服务绑定IP地址，开发环境需设为`0.0.0.0`以允许外部访问（默认值：`127.0.0.1`）
- 其他参数可通过`server start-dev --help`查看完整列表


## 注意事项
- 开发服务器基于SQLite持久化，仅适用于开发和测试场景，**不建议用于生产环境**
- 端口映射需确保主机端口未被占用，冲突时可修改主机端口（如`-p 7234:7233`）
- 完整文档参考[Temporal官方CLI文档](https://docs.temporal.io/cli)
