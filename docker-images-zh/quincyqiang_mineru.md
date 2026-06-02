---
image: quincyqiang/mineru
description: "该PDF解析API基于MinerU开发，主要由两部分核心内容构成：一是MinerU的GPU镜像构建，用于提供高效的计算资源支持；二是基于FastAPI框架搭建的PDF解析接口，确保接口具备高性能与易用性，通过整合这两项关键技术，实现了高效、稳定的PDF解析功能，为用户提供便捷可靠的文档处理服务。"
source: https://xuanyuan.cloud/zh/r/quincyqiang/mineru
canonical: https://xuanyuan.cloud/zh/r/quincyqiang/mineru
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/quincyqiang/mineru" title="quincyqiang/mineru Docker 镜像中文简介、标签列表与拉取命令">quincyqiang/mineru — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/quincyqiang/mineru" title="quincyqiang/mineru Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/quincyqiang/mineru</a>

# MinerU PDF解析API介绍

MinerU 提供了一个基于 GPU 加速的 PDF 解析 API 服务，方便用户快速部署和使用高效的 PDF 内容提取功能。其核心包含以下两方面：

*   **MinerU 的 GPU 镜像构建**：提供预构建的 Docker 镜像，集成了所需的模型和运行环境，支持 GPU 加速以提升解析性能。
*   **基于 FastAPI 的 PDF 解析接口**：采用 FastAPI 框架开发，提供易用且高效的 RESTful API 接口，便于集成到各类应用中。

## 快速启动

使用以下 Docker 命令即可快速启动 MinerU PDF 解析服务：

```bash
docker run -itd --name=mineru_server --gpus=all -p 8888:8000 quincyqiang/mineru:0.1-models
```

*   该命令会拉取指定镜像并启动容器，将容器的 8000 端口映射到主机的 8888 端口，并启用所有可用 GPU。
*   关于启动过程的具体截图及更多细节，可参考博客文章：[[]]([])

## 服务验证与接口文档

### 启动日志确认

服务启动后，可以通过查看容器日志确认服务是否正常启动。正常启动的日志信息示例可参考提供的截图。

### 访问接口文档

服务启动后，可通过以下地址访问自动生成的交互式 API 文档（Swagger UI），以了解详细的接口参数和使用方法：

*   `[]   `[] (注意：原地址中的 `127.0.01` 修正为标准的 `127.0.0.1`)

## 解析效果示例

该 PDF 解析 API 能够有效提取 PDF 中的文本内容、表格等信息。具体的解析效果可以参考提供的解析结果截图，展示了对复杂格式 PDF 的解析能力。

## 镜像获取

您可以通过以下地址获取 MinerU 的 Docker 镜像：

*   **阿里云地址**：
    ```bash
    docker pull registry.cn-beijing.aliyuncs.com/quincyqiang/mineru:0.1-models
    ```
*   **Docker Hub 地址**：
    ```bash
    docker pull quincyqiang/mineru:0.1-models
    ```
