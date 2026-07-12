---
image: scottsbaldwin/docker-hello-world
description: "一个简单的NGINX镜像，用于演示Docker基础使用，提供显示容器主机名的单页HTML服务。"
source: https://xuanyuan.cloud/zh/r/scottsbaldwin/docker-hello-world
canonical: https://xuanyuan.cloud/zh/r/scottsbaldwin/docker-hello-world
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/scottsbaldwin/docker-hello-world" title="scottsbaldwin/docker-hello-world Docker 镜像中文简介、标签列表与拉取命令">scottsbaldwin/docker-hello-world 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## NGINX Hello World镜像

### 镜像概述
本镜像基于NGINX构建，是一个轻量的Docker演示镜像，旨在展示容器化应用的基础运行逻辑和Web服务能力。

### 核心功能
- 运行NGINX Web服务器
- 提供静态HTML页面，显示当前容器的主机名

### 使用场景
- Docker入门学习与演示场景
- 容器主机名验证测试
- 简单Web服务容器化示例

### 配置说明
通过端口映射可将容器的80端口暴露到主机端口，实现外部访问。

### 部署示例
```bash
docker run -d -p 8080:80 docker.xuanyuan.run/scottsbaldwin/docker-hello-world
```
部署后访问 `http://localhost:8080` 即可查看显示容器主机名的页面。
