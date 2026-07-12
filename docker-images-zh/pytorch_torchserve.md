---
image: pytorch/torchserve
description: "PyTorch Serve Docker镜像是用于部署PyTorch模型的服务框架，提供REST API接口，支持模型管理、推理及扩展，简化生产环境中PyTorch模型的部署流程。"
source: https://xuanyuan.cloud/zh/r/pytorch/torchserve
canonical: https://xuanyuan.cloud/zh/r/pytorch/torchserve
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/pytorch/torchserve" title="pytorch/torchserve Docker 镜像中文简介、标签列表与拉取命令">pytorch/torchserve 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PyTorch Serve Docker镜像

## 概述
PyTorch Serve是由PyTorch官方提供的模型服务框架，旨在简化PyTorch模型的部署流程。该Docker镜像封装了PyTorch Serve的完整运行环境，可快速部署PyTorch模型并提供RESTful API接口，支持模型加载、推理、管理及横向扩展，适用于生产环境中的模型服务化部署需求。

## 核心功能与特性
- **RESTful API支持**：提供标准REST API接口，包含模型推理、健康检查、模型管理等功能
- **模型生命周期管理**：支持模型的加载、卸载、版本控制及A/B测试
- **动态批处理优化**：自动对推理请求进行批处理，提升服务吞吐量
- **多模型部署**：支持同时部署多个PyTorch模型，实现多服务实例共存
- **可扩展性**：支持通过增加服务实例实现水平扩展，应对高并发场景
- **监控与日志**：内置日志记录和性能指标监控，便于服务运维与问题排查

## 使用场景
- 生产环境中PyTorch模型的快速部署与服务化
- 构建AI推理服务，为应用提供实时模型预测能力
- 多模型服务管理，满足复杂业务场景下的多模型部署需求
- 科研与开发环境中的模型测试与验证

## 使用方法与配置说明

### 基本部署（Docker Run）
```bash
docker run -p 8080:8080 -p 8081:8081 docker.xuanyuan.run/pytorch/torchserve:latest
```
- 8080端口：推理API端口（用于模型预测请求）
- 8081端口：管理API端口（用于模型加载、卸载等管理操作）

### 部署自定义模型
1. **准备模型文件**：使用`torch-model-archiver`工具将PyTorch模型打包为`.mar`格式（模型归档文件）
2. **启动服务并加载模型**：
```bash
docker run -p 8080:8080 -p 8081:8081 \
  -v /本地模型存储路径:/home/model-server/model-store \
  docker.xuanyuan.run/pytorch/torchserve:latest \
  torchserve --start --model-store /home/model-server/model-store --models 模型名称=模型文件.mar
```

### 环境变量配置
| 环境变量 | 描述 | 默认值 |
|----------|------|--------|
| `TS_PORT` | 推理API端口 | 8080 |
| `TS_MANAGEMENT_PORT` | 管理API端口 | 8081 |
| `TS_MODEL_STORE` | 模型存储目录 | /home/model-server/model-store |
| `TS_LOG_LEVEL` | 日志级别（支持DEBUG/INFO/WARN/ERROR） | INFO |
| `TS_MAX_WORKERS` | 工作进程数 | CPU核心数 |

### Docker Compose示例
```yaml
version: '3'
services:
  torchserve:
    image: docker.xuanyuan.run/pytorch/torchserve:latest
    ports:
      - "8080:8080"  # 推理API
      - "8081:8081"  # 管理API
    volumes:
      - ./local-model-store:/home/model-server/model-store  # 本地模型目录挂载
    environment:
      - TS_LOG_LEVEL=INFO
      - TS_MAX_WORKERS=4
    command: torchserve --start --model-store /home/model-server/model-store --models my_model=my_model.mar
```

## 更多信息
访问GitHub仓库获取完整文档和示例：[pytorch/serve](https://github.com/pytorch/serve)
