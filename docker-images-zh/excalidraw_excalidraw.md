---
image: excalidraw/excalidraw
description: "用于自托管的Excalidraw客户端Docker镜像，提供手绘风格图表绘制功能的虚拟白板工具"
source: https://xuanyuan.cloud/zh/r/excalidraw/excalidraw
canonical: https://xuanyuan.cloud/zh/r/excalidraw/excalidraw
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/excalidraw/excalidraw" title="excalidraw/excalidraw Docker 镜像中文简介、标签列表与拉取命令">excalidraw/excalidraw — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/excalidraw/excalidraw" title="excalidraw/excalidraw Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/excalidraw/excalidraw</a>

# Excalidraw客户端Docker镜像

## 概述
Excalidraw客户端Docker镜像是用于自托管的Excalidraw客户端，可部署在自有域名、Kubernetes、AWS ECS等环境中，提供手绘风格图表绘制功能的虚拟白板工具。

## 核心功能与特性
- 不含分析和其他跟踪库，保护用户隐私
- 支持绘制手绘风格的各类图表
- 轻量级部署，适合自托管场景

> **注意**：目前自托管实例暂不支持共享或协作功能，开发团队正致力于提供完整的自托管解决方案。

## 使用方法

### 构建与运行镜像
```sh
# 构建镜像
docker build -t excalidraw/excalidraw .

# 运行容器（后台模式，映射端口5000到容器80端口）
docker run --rm -dit --name excalidraw -p 5000:80 excalidraw/excalidraw:latest
```

## 使用场景
适合需要在自有基础设施上部署虚拟白板工具的团队或个人，用于绘制流程图、架构图、思维导图等手绘风格图表。

## 支持
如有任何问题、建议或支持请求，请通过[GitHub](https://github.com/excalidraw/excalidraw/issues)提交。
