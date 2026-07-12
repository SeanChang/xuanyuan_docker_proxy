---
image: scaleway/cli
description: "从命令行管理裸金属服务器，操作体验如同使用Docker般简单便捷。"
source: https://xuanyuan.cloud/zh/r/scaleway/cli
canonical: https://xuanyuan.cloud/zh/r/scaleway/cli
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/scaleway/cli" title="scaleway/cli Docker 镜像中文简介、标签列表与拉取命令">scaleway/cli 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 裸金属服务器命令行管理工具镜像

## 镜像概述

本镜像提供了一套从命令行管理裸金属服务器的工具集，其核心设计目标是将复杂的裸金属服务器管理流程简化为类Docker式的操作体验，降低运维门槛，提升管理效率。通过统一的命令行接口，用户可便捷地完成裸金属服务器的生命周期管理，无需深入掌握底层硬件配置细节。

## 核心功能与特性

- **类Docker命令体系**：采用与Docker相似的命令结构（如`bmctl run`、`bmctl stop`、`bmctl status`等），降低学习成本
- **轻量级设计**：镜像体积小巧，无冗余依赖，可快速部署和启动
- **跨平台兼容**：支持主流Linux发行版作为宿主机环境
- **完整生命周期管理**：覆盖服务器启动、停止、重启、状态监控、配置更新等核心操作
- **无状态架构**：配置信息可通过环境变量或外部配置文件注入，便于容器化部署和扩展

## 使用场景与适用范围

- **中小型数据中心**：无需部署复杂硬件管理平台，通过命令行快速管理少量至中量裸金属服务器
- **开发测试环境**：开发者可自助管理测试用裸金属资源，减少对运维团队的依赖
- **边缘计算节点**：在资源受限的边缘环境中，通过轻量级工具实现高效服务器管理
- **自动化运维流程**：可集成至CI/CD或自动化脚本中，实现裸金属服务器的程序化管理

## 使用方法与配置说明

### 基本部署

通过Docker快速启动工具容器：

```bash
docker run --rm -it --name bmctl [镜像名称] bmctl --help
```

### 环境变量配置

| 环境变量名 | 描述 | 默认值 | 必选 |
|------------|------|--------|------|
| `BM_API_URL` | 裸金属服务器管理API端点 | `http://localhost:8080` | 否 |
| `BM_AUTH_TOKEN` | 访问API的认证令牌 | 空 | 是 |
| `BM_TIMEOUT` | 命令执行超时时间（秒） | `30` | 否 |
| `BM_LOG_LEVEL` | 日志级别（debug/info/warn/error） | `info` | 否 |

带环境变量的启动示例：

```bash
docker run --rm -it \
  -e BM_API_URL="https://bms-api.example.com" \
  -e BM_AUTH_TOKEN="your-secure-token" \
  --name bmctl [镜像名称] bmctl status
```

### 基本命令示例

#### 查看服务器列表
```bash
docker run --rm -it -e BM_AUTH_TOKEN="your-token" [镜像名称] bmctl list
```

#### 启动指定服务器
```bash
docker run --rm -it -e BM_AUTH_TOKEN="your-token" [镜像名称] bmctl start server-01
```

#### 停止指定服务器
```bash
docker run --rm -it -e BM_AUTH_TOKEN="your-token" [镜像名称] bmctl stop server-02
```

#### 查看服务器详细状态
```bash
docker run --rm -it -e BM_AUTH_TOKEN="your-token" [镜像名称] bmctl inspect server-01
```

### 持久化配置（可选）

如需持久化保存配置或日志，可挂载本地目录：

```bash
docker run --rm -it \
  -v /path/to/local/config:/etc/bmctl \
  -v /path/to/local/logs:/var/log/bmctl \
  -e BM_AUTH_TOKEN="your-token" \
  --name bmctl [镜像名称] bmctl status
```

## 注意事项

- 确保宿主机与目标裸金属服务器网络通畅，且已开放必要的管理端口
- 认证令牌需妥善保管，建议通过Docker Secrets或环境变量加密方式注入
- 大规模服务器集群管理建议配合编排工具（如Kubernetes）使用，实现高可用部署
