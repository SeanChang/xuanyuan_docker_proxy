---
image: shinejh0528/ollama
description: "基于ollama/ollama的镜像，集成fastAPI服务器，允许外部系统释放Ollama占用的GPU内存，提供Ollama服务（11434端口）和fastAPI管理接口（5000端口）。"
source: https://xuanyuan.cloud/zh/r/shinejh0528/ollama
canonical: https://xuanyuan.cloud/zh/r/shinejh0528/ollama
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/shinejh0528/ollama" title="shinejh0528/ollama Docker 镜像中文简介、标签列表与拉取命令">shinejh0528/ollama 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Ollama + fastAPI 服务器镜像

## 镜像概述和主要用途
本镜像基于 `ollama/ollama` 构建，集成了 fastAPI 服务器，主要用途是允许外部系统释放由 Ollama 占用的 GPU 内存，同时提供标准的 Ollama 服务和便捷的管理接口。

## 核心功能和特性
- **双服务端口**：11434端口提供标准Ollama服务，5000端口提供fastAPI管理接口
- **GPU内存管理**：支持通过fastAPI接口停止指定Ollama模型，释放其占用的GPU内存
- **数据持久化**：支持挂载卷保存Ollama数据（模型、配置等）
- **GPU支持**：原生支持GPU加速，需在运行时指定GPU资源

## 使用场景和适用范围
适用于需要运行Ollama模型且需管理GPU资源的场景，特别是在多模型交替运行或资源受限环境中，可通过外部系统调用API释放不再使用的模型内存，优化GPU资源利用率。

## 使用方法和配置说明

### 运行容器
通过以下命令启动容器，需指定GPU资源、数据卷挂载和端口映射：

```bash
docker run -itd --gpus=all -v [本地数据路径]:/root/.ollama -p 11434:11434 -p 5000:5000 --name ollama docker.xuanyuan.run/shinejh0528/ollama:1.0.0
```

**参数说明**：
- `--gpus=all`：启用所有GPU资源（Ollama模型运行依赖）
- `-v [本地数据路径]:/root/.ollama`：挂载本地目录到容器内Ollama数据目录，实现数据持久化（请将`[本地数据路径]`替换为实际本地路径）
- `-p 11434:11434`：映射Ollama服务端口
- `-p 5000:5000`：映射fastAPI管理接口端口
- `--name ollama`：指定容器名称为"ollama"

### 停止模型（释放GPU内存）
通过fastAPI接口停止指定模型，释放其占用的GPU内存：

**请求命令**：
```bash
curl -X POST http://localhost:5000/stop -H "Content-Type: application/json" -d '{"model":"[模型名称]"}'
```

**参数说明**：
- `[模型名称]`：需停止的Ollama模型名称（如`gemma3:latest`）

**成功响应示例**：
```bash
{"message":"Model 'gemma3:latest' stopped successfully.","output":""}
```

**响应说明**：
- `message`：操作结果描述
- `output`：命令执行输出（通常为空）
